[CmdletBinding()]
param (
    [String]$File = "./input.txt"
)

$Data = Get-Content $file

$X = 1
$probeStart = 20
$probeInc = 40
$cycle = [System.Collections.ArrayList]@()
$cycle.Add($X) | Out-Null

foreach ($line in $Data) {
    Write-Verbose $line

    switch -Regex ($line) {
        "^noop$" {
            $cycle.Add($X) | Out-Null
        }
        "^addx .*" {
            ($command, [int]$arg) = $line.Split(' ')
            $cycle.Add($X) | Out-Null
            $cycle.Add($X) | Out-Null
            $X += $arg
        }
    }    
}

$sum = 0
for ($p = $probeStart; $p -lt $cycle.Count; $p += $probeInc) {
    $val = $p * $cycle[$p]
    $sum += $val
    Write-Verbose ("probe: {0} X: {1} val: {2} sum: {3}" -f $p, $cycle[$p], $val, $sum)
}
Write-Output ("answer: {0}" -f $sum)