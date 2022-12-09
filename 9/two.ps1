[CmdletBinding()]
param (
    [String]$File = "./input.txt",
    [int] $NumberOfKnots = 10,
    [int] $Stop = 0,
    [int] $Sleep = 0
)

$Data = Get-Content $file

$knot = [object[]]::new($NumberOfKnots)

$max = @{
    x = 0
    y = 0
}

for ($i = 0; $i -lt $NumberOfKnots; $i++) {
    $knot[$i] = @{
        x = 0
        y = 0
    }
}

$visited = @{
    "0:0" = 1
}

function visit([object]$k) {
    $visited[("{0}:{1}" -f $k.x, $k.y)] = 1
}

function updateMax([object]$k) {
    $max.x = [Math]::Max($max.x, [Math]::Abs($k.x))
    $max.y = [Math]::Max($max.y, [Math]::Abs($k.y))
}

function moveTail {
    for ($k = $knot.Count-2; $k -ge 0; $k--) {
        if (shouldMove $k) {
            moveTailKnot $k
        } else {
            break
        }
    }
}

function shouldMove([int]$k) {
    ([Math]::Abs($knot[$k+1].x - $knot[$k].x) -gt 1) -or ([Math]::Abs($knot[$k+1].y - $knot[$k].y) -gt 1)
}

function moveTailKnot([int]$k) {
    if ($knot[$k+1].y -gt $knot[$k].y) {
        $knot[$k].y++
    } elseif ($knot[$k+1].y -lt $knot[$k].y) {
        $knot[$k].y--
    }
    if ($knot[$k+1].x -gt $knot[$k].x) {
        $knot[$k].x++
    } elseif ($knot[$k+1].x -lt $knot[$k].x) {
        $knot[$k].x--
    }
}

function moveRight([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].x++
        updateMax $knot[$knot.Count-1]

        moveTail
        visit $knot[0]
    }
}

function moveLeft([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].x--
        updateMax $knot[$knot.Count-1]

        moveTail
        visit $knot[0]
    }
}

function moveUp([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].y++
        updateMax $knot[$knot.Count-1]

        moveTail
        visit $knot[0]
    }
}

function moveDown([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].y--
        updateMax $knot[$knot.Count-1]

        moveTail
        visit $knot[0]
    }
}

function drawPoint([int]$x, [int]$y) {
    for ($i = $knot.Count - 1; $i -ge 0; $i--) {
        if (($knot[$i].x -eq $x) -and ($knot[$i].y -eq $y)) {
            if ($i -eq ($knot.Count - 1)) {
                return 'H'
            }
            return ($NumberOfKnots - $i - 1)
        }
    }
    if ($x -eq 0 -and $y -eq 0) {
        return 's'
    }
    return '.'
}

function printState {
    foreach ($y in (${max}.y..-${max}.y)) {
        $str = ''
        foreach ($x in (-${max}.x)..${max}.x) {
            $str += drawPoint $x $y 
        }
        Write-Verbose $str
    }
}

$g = 1
foreach ($move in $Data) {
    ($dir, [int]$step) = $move.Split(' ')
    Write-Verbose ("move {2}: {0} {1}" -f $dir, $step, $g++)
    switch -Exact ($dir) {
        'R' { moveRight $step; break}
        'L' { moveLeft $step; break}
        'U' { moveUp $step; break}
        'D' { moveDown $step; break}
    }

    if ($VerbosePreference -ne 'SilentlyContinue') {
        printState
        Write-Verbose ""
        Start-Sleep -Milliseconds $Sleep
    }
    if ($Stop -and ($g -gt $Stop)) {break}
}

Write-Host "answer:" $visited.Count