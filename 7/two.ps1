$Data = Get-Content ./input.txt

$dirs = @{}
$currentdir = '/'

foreach ($line in $Data) {
    switch -regex ($line) {
        "^\$ cd.*" {
            ($prompt, $command, $arg) = $line.Split(' ')
            switch -exact ($arg) {
                '/' {
                    $currentdir = '/'
                    break
                }
                '..' {
                    $currentdir = $currentdir.substring(0, ($currentdir.lastindexof('/')))
                    if (-not $currentdir) {
                        $currentdir = '/'
                    }
                    break
                }
                default {
                    $currentdir = ($currentdir -eq '/' ? '' : $currentdir) + '/' + $arg;
                }
            }
            break
        } 
        "^\$ ls.*" {
            $dirs[$currentdir] = 0
            break
        }
        "^dir\ .*" {
            break
        }
        default {
            ([int]$size, $file) = $line.Split(' ')
            $dirs[$currentdir] += $size
            break
        }
    }
}

$sumdirs = @{}
$totalsize = 0

foreach ($dir in $dirs.Keys) {
    $totalsize += $dirs[$dir]
    $sumdirs[$dir] = $dirs[$dir]
    foreach ($subdir in $dirs.Keys | Where-Object {$_ -match ("^{0}/.*" -f ($dir -eq '/' ? '' : $dir))}) {
        $sumdirs[$dir] += $dirs[$subdir]
    }
}

$amounttofree = 30000000 - (70000000 - $totalsize)

Write-Host "totalsize:" $totalsize
Write-Host "amount to free:" $amounttofree
Write-Host "smallest directory to delete:"

$sumdirs.GetEnumerator() | Where-Object {$_.Value -ge $amounttofree} | Sort-Object -Property Value | Select-Object -First 1