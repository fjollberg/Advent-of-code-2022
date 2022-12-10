[CmdletBinding()]
param (
    [String]$File = "./input.txt"
)

$Data = Get-Content $file

$X = 1
$probe = 20
$probeInc = 40
$cycle = [System.Collections.ArrayList]@()
$cycle.Add($X) | Out-Null

foreach ($line in $Data) {
    $command = ''
    [int]$arg = 0

    switch -Regex ($line) {
        "^noop$" {
            $command = "noop"
            break
        }
        "^addx .*" {
            ($command, [int]$arg) = $line.Split(' ')
            break
        }
    }    

    Write-Verbose ("command: {0} arg: {1}" -f $command, $arg)

    switch -Exact ($command) {
        'noop' {
            $cycle.Add($X) | Out-Null
            break;
        }
        'addx' {
            $cycle.Add($X) | Out-Null
            $cycle.Add($X) | Out-Null
            $X += $arg
            break;
        }
    }
}

$sum = 0
for ($p = $probe; $p -lt $cycle.Count; $p += $probeInc) {
    $val = $p * $cycle[$p]
    $sum += $val
    Write-Verbose ("probe: {0} X: {1} val: {2} sum: {3}" -f $p, $cycle[$probe], $val, $sum)
}
Write-Output ("answer: {0}" -f $sum)