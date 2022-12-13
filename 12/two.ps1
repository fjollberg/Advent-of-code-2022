[CmdletBinding()]
param (
    [String]$File = "./input.txt"
)

$Data = Get-Content $file

[string]$grid = ""
foreach ($line in $Data) {
    $grid += $line.Replace('S', 'a')
}
$rowLength = $Data[0].Length
$visited = New-Object int[] $grid.Length

[int]$E = $grid.IndexOf('E')

$endPoints = [System.Collections.ArrayList]@()
for ($i = 0; $i -lt $grid.Length; $i++) {
    if ($grid[$i] -eq 'a') {
        $endPoints.Add($i) | Out-Null
    }
}

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
        Write-Verbose ("Outside grid {0},{1}" -f (getPostion($node)))
        return $false
    }
    # Visited point
#    if ($visited[$node]) {
#        Write-Verbose ("Is visited {0},{1}" -f (getPostion($node)))
#        return $false
#    }
    # End node
    if ($node -in $endPoints) {
        Write-Verbose ("Is endPoint {0},{1}" -f (getPostion($node)))
        Write-Verbose ("Is endPoint {0}" -f $node)
        return $grid[$from] -eq 'b'
    }
    # From initial point    
    if ($from -eq $E) {
        Write-Verbose ("From initial point {0},{1}" -f (getPostion($node)))
        return $grid[$node] -in $('y','z')
    }
    # Other points
    Write-Verbose ("Considering {0},{1}" -f (getPostion($node)))
    $step = [byte]($grid[$from]) - [byte]($grid[$node])
    Write-Verbose ("Considering step {0},{1}: {2}" -f $grid[$from], $grid[$node], $step)
    return ($step -le 1)
}

function findDistanses {
    param(
        [int]$Start
    )

    Write-Verbose ("At {0},{1}" -f (getPostion($Start)))

    if ($visited[$Start]) {
        Write-Verbose ("Already visisted {0},{1}" -f (getPostion($Start)))
        return
    }

    if ($Start -in $endPoints) {
        Write-Verbose ("Found a at : {0},{1}" -f (getPostion($Start)))
        Write-Output ("Distance: {0}" -f $distance)
        exit
    }

    $visited[$Start] = 1

    [array](($Start + 1), ($Start - 1), ($Start + $rowLength), ($Start - $rowLength)) | `
        Where-Object {isReachable -node $_ -from $Start}
}

Write-Verbose ("Found E at {0}" -f $E)
Write-Verbose ("Endpoints {0}" -f ($endPoints -join ","))

$nextNodes = @($E)
while ($nextNodes.Length) {
    $nextNodes = $nextNodes | Foreach-Object {findDistanses -Start $_}
    $script:distance++
    Write-Verbose ("Next nodes: {0}" -f $nextNodes.Length)
    Write-Output ("Distance: {0}" -f $distance)
}
