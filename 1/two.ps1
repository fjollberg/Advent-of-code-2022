$Data = Get-Content ./input.txt | ForEach-Object {[int]$_}

$CurrentCalories = 0
$MaxCalories = 0, 0, 0

$Data | ForEach-Object {
    if ($_ -eq 0) {
        if ($CurrentCalories -gt $MaxCalories[0]) {
            $MaxCalories[0] = $CurrentCalories
            $MaxCalories = $MaxCalories | Sort-Object
        }
        $CurrentCalories = 0
    } else {
        $CurrentCalories += $_
    }
}

($MaxCalories | Measure-Object -Sum).Sum