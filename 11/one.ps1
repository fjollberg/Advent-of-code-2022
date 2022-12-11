[CmdletBinding()]
param (
    [String]$File = "./input.txt",
    [int]$Stop = 20
)

$Data = Get-Content $file

$multiply = {
    param([int]$item, $arg)
    switch -Exact ($arg) {
        'old' {
            $res = $item * $item
            Write-Verbose ("    Worry level is multiplied by itself to {0}." -f $res)
        }
        default {
            $res = $item * ([int]$arg)
            Write-Verbose ("    Worry level is multiplied by {1} to {0}." -f $res, $arg)
        }
    }

    $res
}
$add = {
    param([int]$item, $arg)
    $res = $item + ([int]$arg)
    Write-Verbose ("    Worry level increases by {1} to {0}." -f $res, $arg)

    $res
}

class monkey {
    [int]$id
    $item = [System.Collections.ArrayList]@()
    [object]$operand
    [string]$arg
    [int]$test
    [int]$ifTrue
    [int]$ifFalse
    [int]$inspections = 0
}

$monkey = [System.Collections.ArrayList]@()


function printState {
    foreach ($m in $monkey) {
        Write-Verbose ("Monkey {0}: {1}" -f $m.id, ($m.item -join ", "))
    }
    Write-Verbose " "
    foreach ($m in $monkey) {
        Write-Verbose ("Monkey {0} inspected items {1} times." -f $m.id, $m.inspections)
    }
}

foreach ($line in $Data) {
    switch -Regex ($line) {
        "^Monkey (?<id>[0-9]*):$" {
            Write-Verbose ("New monkey: {0}" -f $Matches.id)
            $m = New-Object monkey
            $m.id = $Matches.id
            $monkey.Add($m) | Out-Null
        }
        "^\W*Starting items: (?<items>.*)" {
            Write-Verbose ("Starting items: {0}" -f $Matches.items)
            foreach ($item in $Matches.items.Split(", ")) {
                $m.item.Add([int]$item) | Out-Null
            }
        }
        "^\W*Operation: new = old (?<operation>.*)" {
            Write-Verbose ("Operation: {0}" -f $Matches.operation)
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
            Write-Verbose ("Test: {0}" -f $Matches.test)
            $m.test = [int]$Matches.test
        }
        "^\W*If true: throw to monkey (?<ifTrue>[0-9]*)" {
            Write-Verbose ("If true: {0}" -f $Matches.ifTrue)
            $m.ifTrue = [int]$Matches.ifTrue
        }
        "^\W*If false: throw to monkey (?<ifFalse>[0-9]*)" {
            Write-Verbose ("If false: {0}" -f $Matches.ifFalse)
            $m.ifFalse = [int]$Matches.ifFalse
        }
    }
}

if ($VerbosePreference -ne 'SilentlyContinue') {
    foreach ($m in $monkey) {
        Write-Verbose ("Monkey {0}: {1}" -f $m.id, ($m.item -join ", "))
    }
}

for ($round = 0; $round -lt $Stop; $round++) {
    foreach ($m in $monkey) {
        Write-Verbose ("Monkey: {0}" -f $m.id)

        foreach ($item in $m.item) {
            Write-Verbose ("  Monkey inspects an item with a worry level of {0}" -f $item)
            $m.inspections++
            $item = Invoke-Command -ScriptBlock $m.operand -ArgumentList @($item, $m.arg)
            $item = [Math]::Floor($item / 3)
            Write-Verbose ("    Monkey gets bored with item. Worry level is divided by 3 to {0}." -f $item)

            if (($item % $m.test) -eq 0) {
                Write-Verbose ("    Current worry level is divisible by {0}." -f $m.test)
                Write-Verbose ("    Item with worry level {0} is thrown to monkey {1}." -f $item, $m.ifTrue)
                $monkey[$m.ifTrue].item.Add($item) | Out-Null
            } else {
                Write-Verbose ("    Current worry level is not divisible by {0}." -f $m.test)
                Write-Verbose ("    Item with worry level {0} is thrown to monkey {1}." -f $item, $m.ifFalse)
                $monkey[$m.ifFalse].item.Add($item) | Out-Null
            }
        }
        $m.item = [System.Collections.ArrayList]@()
    }

    if ($VerbosePreference -ne 'SilentlyContinue') {
        Write-Verbose ""
        Write-Verbose ("After round {0}, the monkeys are holding items with these worry levels:" -f ($round+1))
        printState
    }
}

$res = 1
$monkey | Sort-Object -Property inspections -Descending | Select-Object -First 2 | ForEach-Object {
    $res *= $_.inspections
}
Write-Output ("Answer: {0}" -f $res)