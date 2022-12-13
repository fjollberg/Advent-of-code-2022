[CmdletBinding()]
param (
    [String]$File = "./input.txt"
)

$Data = Get-Content $file

[string]$grid = ""
foreach ($line in $Data) {
    $grid += $line
}
$rowLength = $Data[0].Length
$distance = New-Object int[] $grid.Length
$visited = New-Object int[] $grid.Length

[int]$S = $grid.IndexOf('S')
[int]$E = $grid.IndexOf('E')


function isReachable {
    param(
        [int]$node,
        [int]$from
    )
    # Outside grid
    if (($node -lt 0) -or 
        ($node -ge $grid.Length) -or
        ($from -and ($node % $rowLength -eq 0) -and ($node -eq ($from + 1))) -or
        ($from -and ($from % $rowLength -eq 0) -and ($node -eq ($from - 1)))) {
        return $false
    }
    # Visited point
    if ($visited[$node]) {
        return $false
    }
    # Start node
    if ($node -eq $S) {        
        return $false                
    }
    # End node
    if ($node -eq $E) {
        return $grid[$from] -eq 'z'
    }
    # From initial point    
    if ($from -eq $S) {
        return $grid[$node] -eq 'a' 
    }
    # Other points
    if (([byte]($grid[$from]) + 1) -ge ([byte]($grid[$node]))) {
        return $true
    }
    return $false
}

function leastUnvisited {
    [int]$res = -1
    for ($i = 0; $i -lt $distance.Length; $i++) {
        if ($distance[$i] -and -not $visited[$i]) {
            if (($res -lt 0) -or ($distance[$i] -lt ($distance[$res]))) {
                $res = $i
            }
        }
    }
    $res
}

function findDistanses {
    param(
        [int]$Start
    )

    $nextNodes = (($Start + 1), ($Start - 1), ($Start + $rowLength), ($Start - $rowLength)) | `
        Where-Object {isReachable -node $_ -from $Start}

    foreach ($nextNode in $nextNodes) {
        if (-not $distance[$nextNode] -or ($distance[$nextNode] -lt ($distance[$Start] + 1))) {
            $distance[$nextNode] = $distance[$Start] + 1
            Write-Verbose ("Calculated distance from {0} to {1}: {2}" -f $Start, $nextNode, $distance[$nextNode])
        }
    }

    $nextStep = (leastUnvisited)

    if ($nextStep -ne $E) {
        $visited[$nextStep] = 1
        findDistanses -Start $nextStep
    }
}

Write-Verbose ("Found S at {0}" -f $S)
Write-Verbose ("Found E at {0}" -f $E)

$visited[$S] = 1

findDistanses -Start $S

if ($VerbosePreference -ne 'SilentlyContinue') {
    $str = ""
    for ($i = 0; $i -lt $distance.Length; $i++) {
        if ($i % $rowLength -eq 0) {
            Write-Verbose ("{0}" -f $str)
            $str = ""
        }
        $str += ("{0:d2}," -f $distance[$i])
    }
    Write-Verbose ("{0}" -f $str)
}

Write-Output ("answer: {0}" -f $distance[$E])
