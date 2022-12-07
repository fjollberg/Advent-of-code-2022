$Data = Get-Content ./input.txt

$stacks = @(
    "WMLF".ToCharArray(),
    "BZVMF".ToCharArray(),
    "HVRSLQ".ToCharArray(),
    "FSVQPMTJ".ToCharArray(),
    "LSW".ToCharArray(),
    "FVPMRJW".ToCharArray(),
    "JQCPNRF".ToCharArray(),
    "VMPSZWRB".ToCharArray(),
    "BMJCGHZW".ToCharArray()
 )

foreach ($array in $stacks) {"$array"}

foreach ($move in $Data) {
    $move -match '^move (?<crates>[0-9]*) from (?<from>[0-9]*) to (?<to>[0-9]*)' | Out-Null
    [int]$crates = $Matches.crates
    [int]$from = $Matches.from
    [int]$to = $Matches.to

    Write-Host "move: $crates $from $to"

    for ([int]$i = 0; $i -lt $crates; $i++) {
        [array]$stacks[$to-1] += $stacks[$from-1][$stacks[$from-1].Length-1]
        [array]$stacks[$from-1] = $stacks[$from-1] | Select-Object -SkipLast 1
        if (-not $stacks[$from-1]) {
            $stacks[$from-1] = @()
        }
    }

    $i = 0;
    foreach ($array in $stacks) {$i++; Write-Host "${i}: $array"}
    Write-Host ""
}

$answer = foreach ($array in $stacks) {$array[$array.Length-1]}

Write-Host "answer:" "$answer".Replace(" ", "")