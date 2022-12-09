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

function shouldMove([int]$k) {
    ([Math]::Abs($knot[$k+1].x - $knot[$k].x) -gt 1) -or ([Math]::Abs($knot[$k+1].y - $knot[$k].y) -gt 1)
}

function visit([int]$x, [int]$y) {
    $visited[("{0}:{1}" -f $x, $y)] = 1
}

function updateMax([int]$x, [int]$y) {
    $max.x = [Math]::Max($max.x, [Math]::Abs($x))
    $max.y = [Math]::Max($max.y, [Math]::Abs($y))
}

function moveRight([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].x++
        updateMax $knot[$knot.Count-1].x $knot[$knot.Count-1].y 

        for ($k = $knot.Count-2; $k -ge 0; $k--) {
            if (shouldMove $k) {
                moveKnot $k
            } else {
                break
            }
        }
        visit $knot[0].x $knot[0].y
    }
}

function moveknot([int]$k) {
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

function moveLeft([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].x--
        updateMax $knot[$knot.Count-1].x $knot[$knot.Count-1].y 

        for ($k = $knot.Count-2; $k -ge 0; $k--) {
            if (shouldMove $k) {
                moveKnot $k
            } else {
                break
            }
        }

        visit $knot[0].x $knot[0].y
    }
}

function moveUp([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].y++
        updateMax $knot[$knot.Count-1].x $knot[$knot.Count-1].y 

        for ($k = $knot.Count-2; $k -ge 0; $k--) {
            if (shouldMove $k) {
                moveKnot $k
            } else {
                break
            }
        }
        visit $knot[0].x $knot[0].y
    }
}

function moveDown([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].y--
        updateMax $knot[$knot.Count-1].x $knot[$knot.Count-1].y 

        for ($k = $knot.Count-2; $k -ge 0; $k--) {
            if (shouldMove $k) {
                moveKnot $k
            } else {
                break
            }
        }
        visit $knot[0].x $knot[0].y
    }
}

function point([int]$x, [int]$y) {
    for ($i = $knot.Count - 1; $i -ge 0; $i--) {
        if (($knot[$i].x -eq $x) -and ($knot[$i].y -eq $y)) {
            if ($i -eq ($knot.Count - 1)) {
                return 'H'
            }
            if ($i -eq 0) {
                return 'T'
            }
            return ($NumberOfKnots - $i - 1)
        }
    }
    if ($x -eq 0 -and $y -eq 0) {
        return 's'
    }
    return '.'
}

function printExample {
    foreach ($y in (${max}.y..-${max}.y)) {
        $str = ''
        foreach ($x in (-${max}.x)..${max}.x) {
            $str += point $x $y 
        }
        Write-Host $str
    }
}

$g = 1
foreach ($move in $Data) {
    ($dir, [int]$step) = $move.Split(' ')
    Write-Verbose ("move {2}: {0} {1}" -f $dir, $step, $g)
    switch -Exact ($dir) {
        'R' { moveRight $step; break}
        'L' { moveLeft $step; break}
        'U' { moveUp $step; break}
        'D' { moveDown $step; break}
    }
    $g++

    if ($VerbosePreference -ne 'SilentlyContinue') {
        printExample
        Write-Host ""
        Start-Sleep -Milliseconds $Sleep
    }
    if ($Stop -and ($g -gt $Stop)) {break}
}

Write-Host "answer:" $visited.Count