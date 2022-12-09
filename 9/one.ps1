[CmdletBinding()]
param (
    [String]$file = "./input.txt"
)

$Data = Get-Content $file

$h = @{
    x = 0
    y = 0
}

$t = @{
    x = 0
    y = 0
}

$visited = @{
    "0:0" = 1
}

function shouldMoveTail {
    ([Math]::Abs($h.x - $t.x) -gt 1) -or ([Math]::Abs($h.y - $t.y) -gt 1)
}

function visit([int]$x, [int]$y) {
    $visited[("{0}:{1}" -f $x, $y)] = 1
    Write-Verbose ("visited: {0} {1}" -f $x, $y)
}

function moveRight([int] $step) {
    while ($step) {
        $step--
        $h.x++

        if (shouldMoveTail) {
            if ($h.y -eq $t.y) {
                $t.x++
            } elseif ($h.y -gt $t.y) {
                $t.x++
                $t.y++
            } else {
                $t.x++
                $t.y--
            }
        }
        visit $t.x $t.y
    }
}

function moveLeft([int] $step) {
    while ($step) {
        $step--
        $h.x--

        if (shouldMoveTail) {
            if ($h.y -eq $t.y) {
                $t.x--
            } elseif ($h.y -gt $t.y) {
                $t.x--
                $t.y++
            } else {
                $t.x--
                $t.y--
            }
        }
        visit $t.x $t.y
    }
}

function moveUp([int] $step) {
    while ($step) {
        $step--
        $h.y++

        if (shouldMoveTail) {
            if ($h.x -eq $t.x) {
                $t.y++
            } elseif ($h.x -gt $t.x) {
                $t.y++
                $t.x++
            } else {
                $t.y++
                $t.x--
            }
        }
        visit $t.x $t.y
    }
}

function moveDown([int] $step) {
    while ($step) {
        $step--
        $h.y--

        if (shouldMoveTail) {
            if ($h.x -eq $t.x) {
                $t.y--
            } elseif ($h.x -gt $t.x) {
                $t.y--
                $t.x++
            } else {
                $t.y--
                $t.x--
            }
        }
        visit $t.x $t.y
    }
}

foreach ($move in $Data) {
    ($dir, [int]$step) = $move.Split(' ')
    switch -Exact ($dir) {
        'R' { moveRight $step; break}
        'L' { moveLeft $step; break}
        'U' { moveUp $step; break}
        'D' { moveDown $step; break}
    }
}

Write-Host "answer:" $visited.Count