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
$visited = New-Object int[] $grid.Length

[int]$S = $grid.IndexOf('S')
[int]$E = $grid.IndexOf('E')
$script:distance = 0

function getPostion([int]$pos) {
    return @([Math]::Floor($pos / $rowLength), ($pos % $rowLength))
}

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
        return $grid[$from] -in $('z', 'y')
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

function findDistanses {
    param(
        [int]$Start
    )

    if ($visited[$Start]) {
        return
    }

#    Write-Verbose ("At {0},{1}" -f (getPostion($Start)))

    if ($Start -eq $E) {
        Write-Verbose ("Found E at : {0},{1}" -f (getPostion($Start)))
        Write-Output ("Distance: {0}" -f $distance)
        exit
    }

    $visited[$Start] = 1

    [array](($Start + 1), ($Start - 1), ($Start + $rowLength), ($Start - $rowLength)) | `
        Where-Object {isReachable -node $_ -from $Start}
}

Write-Verbose ("Found S at {0}" -f $S)
Write-Verbose ("Found E at {0}" -f $E)

$nextNodes = @($S)
while ($nextNodes.Length) {
    $nextNodes = $nextNodes | Foreach-Object {findDistanses -Start $_}
    $script:distance++
    Write-Verbose ("Next nodes: {0}" -f $nextNodes.Length)
    Write-Output ("Distance: {0}" -f $distance)
}
