$Data = Get-Content ./input.txt

$count = 0
foreach ($pair in $Data) {
    [int[]]($FirstStart, $FirstEnd, $SecondStart, $SecondEnd) = $pair.split(',').split('-')

    if ($FirstStart -le $SecondStart -and $FirstEnd -ge $SecondStart) {
        $count++
        Write-Host "yes1" $FirstStart $FirstEnd $SecondStart $SecondEnd
    } elseif ($FirstStart -le $SecondEnd -and $FirstEnd -ge $SecondStart) {
        $count++
        Write-Host "yes2" $FirstStart $FirstEnd $SecondStart $SecondEnd
    } else {
        Write-Host $FirstStart $FirstEnd $SecondStart $SecondEnd
    }
}
$count