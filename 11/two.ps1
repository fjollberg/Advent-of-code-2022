[CmdletBinding()]
param (
    [String]$File = "./input.txt",
    [long]$Stop = 10000
)

$Data = Get-Content $file

$multiply = {
    param([long]$item, $arg)
    switch -Exact ($arg) {
        'old' {
            $item * $item
        }
        default {
            $item * ([long]$arg)
        }
    }
}
$add = {
    param([long]$item, $arg)
    $item + ([long]$arg)
}

class monkey {
    [long]$id
    $item = [System.Collections.ArrayList]@()
    [object]$operand
    [string]$arg
    [long]$test
    [long]$ifTrue
    [long]$ifFalse
    [long]$inspections = 0
}

$monkey = [System.Collections.ArrayList]@()

function printState {
    foreach ($m in $monkey) {
        Write-Verbose ("Monkey {0} inspected items {1} times." -f $m.id, $m.inspections)
    }
}

foreach ($line in $Data) {
    switch -Regex ($line) {
        "^Monkey (?<id>[0-9]*):$" {
            $m = New-Object monkey
            $m.id = $Matches.id
            $monkey.Add($m) | Out-Null
        }
        "^\W*Starting items: (?<items>.*)" {
            foreach ($item in $Matches.items.Split(", ")) {
                $m.item.Add([long]$item) | Out-Null
            }
        }
        "^\W*Operation: new = old (?<operation>.*)" {
            ($operation, $argument) = $Matches.operation.Split(' ')
            $m.arg = $argument
            switch -Exact ($operation) {
                '*' {
                    $m.operand = $multiply
                }
                '+' {
                    $m.operand = $add
                }
            }
        }
        "^\W*Test: divisible by (?<test>[0-9]*)" {
            $m.test = [long]$Matches.test
        }
        "^\W*If true: throw to monkey (?<ifTrue>[0-9]*)" {
            $m.ifTrue = [long]$Matches.ifTrue
        }
        "^\W*If false: throw to monkey (?<ifFalse>[0-9]*)" {
            $m.ifFalse = [long]$Matches.ifFalse
        }
    }
}

$product = 1
foreach ($m in $monkey) {
    $product = $product * $m.test
}

for ($round = 0; $round -lt $Stop; $round++) {
    foreach ($m in $monkey) {
        foreach ($item in $m.item) {
            $m.inspections++
            $item = Invoke-Command -ScriptBlock $m.operand -ArgumentList @($item, $m.arg)

            if (($item % $m.test) -eq 0) {
                $item = $item % $product
                $monkey[$m.ifTrue].item.Add($item) | Out-Null
            } else {
                $item = $item % $product
                $monkey[$m.ifFalse].item.Add($item) | Out-Null
            }
        }
        $m.item = [System.Collections.ArrayList]@()
    }

}

if ($VerbosePreference -ne 'SilentlyContinue') {
    Write-Verbose ("== After round {0} ==" -f ($round))
    printState
    Write-Verbose ""
}

$res = 1
$monkey | Sort-Object -Property inspections -Descending | Select-Object -First 2 | ForEach-Object {
    $res *= $_.inspections
}
Write-Output ("Answer: {0}" -f $res)

$product