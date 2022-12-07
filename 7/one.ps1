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

foreach ($dir in $dirs.Keys) {
    $sumdirs[$dir] = $dirs[$dir]
    foreach ($subdir in $dirs.Keys | Where-Object {$_ -match ("^{0}/.*" -f ($dir -eq '/' ? '' : $dir))}) {
        $sumdirs[$dir] += $dirs[$subdir]
    }
}

$sum = 0
$sumdirs.GetEnumerator() | Where-Object {$_.Value -le 100000} | Sort-Object -Property Key | ForEach-Object {
    Write-Host "dir:" $_.Key $_.Value
    $sum += $_.Value
}
Write-Host "sum of dirs:" $sum
