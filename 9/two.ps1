[CmdletBinding()]
param (
    [String]$File = "./input.txt",
    [int] $NumberOfKnots = 2,
    [int] $Stop = 0
)

$Data = Get-Content $file

$knot = [object[]]::new($NumberOfKnots)

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
    ([Math]::Abs($knot[$k].x - $knot[$k+1].x) -gt 1) -or ([Math]::Abs($knot[$k].y - $knot[$k+1].y) -gt 1)
}

function visit([int]$x, [int]$y) {
    $visited[("{0}:{1}" -f $x, $y)] = 1
    Write-Verbose ("visited: {0} {1}" -f $x, $y)
}

function moveRight([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].x++

        for ($k = $knot.Count-2; $k -ge 0; $k--) {
            if (shouldMove $k) {
                if ($knot[$k+1].y -gt $knot[$k].y) {
                    $knot[$k].y++
                } elseif ($knot[$k+1].y -lt $knot[$k].y) {
                    $knot[$k].y--
                }
                $knot[$k].x++
            }
        }
        visit $knot[0].x $knot[0].y
    }
}

function moveLeft([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].x--

        for ($k = $knot.Count-2; $k -ge 0; $k--) {
            if (shouldMove $k) {
                if ($knot[$k+1].y -gt $knot[$k].y) {
                    $knot[$k].y++
                } elseif ($knot[$k+1].y -lt $knot[$k].y) {
                    $knot[$k].y--
                }
                $knot[$k].x--
            }
        }
        visit $knot[0].x $knot[0].y
    }
}

function moveUp([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].y++

        for ($k = $knot.Count-2; $k -ge 0; $k--) {
            if (shouldMove $k) {
                if ($knot[$k+1].x -gt $knot[$k].x) {
                    $knot[$k].x++
                } elseif ($knot[$k+1].x -lt $knot[$k].x) {
                    $knot[$k].x--
                }
                $knot[$k].y++
            }
        }
        visit $knot[0].x $knot[0].y
    }
}

function moveDown([int] $step) {
    while ($step--) {
        $knot[$knot.Count-1].y--

        for ($k = $knot.Count-2; $k -ge 0; $k--) {
            if (shouldMove $k) {
                if ($knot[$k+1].x -gt $knot[$k].x) {
                    $knot[$k].x++
                } elseif ($knot[$k+1].x -lt $knot[$k].x) {
                    $knot[$k].x--
                }
                $knot[$k].y--
            }
        }
        visit $knot[0].x $knot[0].y
    }
}



$g = 0
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
    if ($Stop -and ($g -gt $Stop)) {break}
}

Write-Host "answer:" $visited.Count