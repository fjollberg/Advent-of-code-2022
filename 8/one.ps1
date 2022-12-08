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

function notSeen([int]$tree) {
    $tree -ge 0
}

function countBackAndForthRow([int] $row) {
    $count = 0

    # first tree visible, 0 can only be visible on the
    # border, so negation should work.
    $h = $grid[$row][0]

    for ($i = 1; $i -lt $grid[$row].Length - 1; $i++) {
        if ((notSeen $grid[$row][$i]) -and ($grid[$row][$i] -gt $h)) {
            Write-Host "found row" $row $i $grid[$row][$i]
            $grid[$row][$i] = -$grid[$row][$i]
            $count++
        }
        $h = [Math]::max([Math]::Abs($grid[$row][$i]), $h)
    }
    
    $h = $grid[$row][$grid[$row].Length -1]

    for ($i = $grid[$row].Length - 2; $i -ge 1; $i--) {
        if ((notSeen $grid[$row][$i]) -and ($grid[$row][$i] -gt $h)) {
            Write-Host "found row back" $row $i $grid[$row][$i]
            $grid[$row][$i] = -$grid[$row][$i]
            $count++
        }
        $h = [Math]::max([Math]::Abs($grid[$row][$i]), $h)
    }

    $count
}

function countBackAndForthCol([int] $col) {
    $count = 0
    # first tree visible, 0 can only be visible on the
    # border, so negation should work.
    $h = $grid[0][$col]

    for ($i = 1; $i -lt $grid.Length-1; $i++) {
        if ((notSeen $grid[$i][$col]) -and ($grid[$i][$col] -gt $h)) {
            Write-Host "found col" $i $col $grid[$i][$col]
            $grid[$i][$col] = -$grid[$i][$col]
            $count++
        }
        $h = [Math]::max([Math]::Abs($grid[$i][$col]), $h)
    }
    
    $h = $grid[$grid.Length-1][$col]

    for ($i = $grid.Length - 2; $i -ge 1; $i--) {
        if ((notSeen $grid[$i][$col]) -and ($grid[$i][$col] -gt $h)) {
            Write-Host "found col back" $i $col $grid[$i][$col]
            $grid[$i][$col] = -$grid[$i][$col]
            $count++
        }
        $h = [Math]::max([Math]::Abs($grid[$i][$col]), $h)
    }

    $count
} 

#for ($r = 0; $r -lt $grid.Length; $r++) {
#    Write-Host "${r}:" $grid[$r]    
#}

$total = ($grid.Length * 2) + ($grid[0].Length * 2) - 4
Write-Host "start:" $count

for ($r = 1; $r -lt $grid.Length-1; $r++) {
    Write-Host "row:" $r
    $total += countBackAndForthRow $r
}
for ($c = 1; $c -lt ($grid[0].Length-1); $c++) {
    Write-Host "col:" $c
    $total += countBackAndForthCol $c
}
Write-Host "answer:" $total

#for ($r = 0; $r -lt $grid.Length; $r++) {
#    Write-Host "${r}:" $grid[$r]    
#}