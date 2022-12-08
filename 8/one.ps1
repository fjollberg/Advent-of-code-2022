$Data = Get-Content ./input.txt

$script:grid = [array[]]::new($Data.Length)

$i = 0

foreach ($line in $Data) {
    [int[]] $row = $()

    foreach ($char in $line.ToCharArray()) {
        $row += [convert]::ToInt32($char, 10)
    }

    $grid[$i++] = $row
}

# Ugly, but first tree in each row always visible, 0 can only be
# visible on the edges, so negation to mark already found trees works.
function setSeen([int]$x, [int]$y) {
    $grid[$y][$x] = -([Math]::abs($grid[$y][$x]))
}

function notSeen([int]$x, [int]$y) {
    $grid[$y][$x] -ge 0
}

function countBackAndForthRow([int] $row) {
    $local:count = 0

    $h = $grid[$row][0]

    for ($i = 1; $i -lt $grid[$row].Length - 1; $i++) {
        if ((notSeen $i $row) -and ($grid[$row][$i] -gt $h)) {
            Write-Host "found row" $row $i $grid[$row][$i]
            setSeen $i $row
            $count++
        }
        $h = [Math]::max([Math]::Abs($grid[$row][$i]), $h)
    }
    
    $h = $grid[$row][$grid[$row].Length -1]

    for ($i = $grid[$row].Length - 2; $i -ge 1; $i--) {
        if ((notSeen $i $row) -and ($grid[$row][$i] -gt $h)) {
            Write-Host "found row back" $row $i $grid[$row][$i]
            setSeen $i $row
            $count++
        }
        $h = [Math]::max([Math]::Abs($grid[$row][$i]), $h)
    }

    $count
}

function countBackAndForthCol([int] $col) {
    $local:count = 0

    $h = $grid[0][$col]

    for ($i = 1; $i -lt $grid.Length-1; $i++) {
        if ((notSeen $col $i) -and ($grid[$i][$col] -gt $h)) {
            Write-Host "found col" $i $col $grid[$i][$col]
            setSeen $col $i
            $count++
        }
        $h = [Math]::max([Math]::Abs($grid[$i][$col]), $h)
    }
    
    $h = $grid[$grid.Length-1][$col]

    for ($i = $grid.Length - 2; $i -ge 1; $i--) {
        if ((notSeen $col $i) -and ($grid[$i][$col] -gt $h)) {
            Write-Host "found col back" $i $col $grid[$i][$col]
            setSeen $col $i
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

for ($r = 1; $r -lt $grid.Length-1; $r++) {
    $total += countBackAndForthRow $r
}
for ($c = 1; $c -lt $grid[0].Length-1; $c++) {
    $total += countBackAndForthCol $c
}
Write-Host "answer:" $total
