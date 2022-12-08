$Data = Get-Content ./input.txt

[array[]]$script:grid = [array[]]::new($Data.Length)

$i = 0

foreach ($line in $Data) {
    [int[]] $row = $()

    foreach ($char in $line.ToCharArray()) {
        $row += [convert]::ToInt32($char, 10)
    }

    $grid[$i++] = $row
}

function viewFrom([int] $x, [int] $y) {
    (viewDown $x $y) * (viewUp $x $y) * (viewLeft $x $y) * (viewRight $x $y)
}

function viewLeft([int] $x, [int] $y) {
    $steps = 0
    for ([int] $i = $x - 1; $i -ge 0; $i--) {
        $steps++
        if ($grid[$y][$i] -ge $grid[$y][$x]) {
            break;
        }
    }
    $steps
}

function viewRight([int] $x, [int] $y) {
    $steps = 0
    for ([int] $i = $x + 1; $i -lt $grid[0].Length; $i++) {
        $steps++
        if ($grid[$y][$i] -ge $grid[$y][$x]) {
            break;
        }
    }
    $steps
}

function viewUp([int] $x, [int] $y) {
    $steps = 0
    for ([int] $i = $y - 1; $i -ge 0; $i--) {
        $steps++
        if ($grid[$i][$x] -ge $grid[$y][$x]) {
            break;
        }
    }
    $steps
}

function viewDown([int] $x, [int] $y) {
    $steps = 0
    for ([int] $i = $y + 1; $i -lt $grid.Length; $i++) {
        $steps++
        if ($grid[$i][$x] -ge $grid[$y][$x]) {
            break;
        }
    }
    $steps
}

$max = 0

for ($y = 1; $y -lt $grid.Length-1; $y++) {
    for ($x = 1; $x -lt $grid[0].Length-1; $x++) {
        $latest = viewFrom $y $x
        if ($latest -gt $max) {
            Write-Host "new max:" $x $y $latest
            $max = $latest
        }

    }
}

Write-Host "max:" $max
