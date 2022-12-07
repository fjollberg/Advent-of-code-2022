$Data = Get-Content ./input.txt

$priorities = 0

while ($Data) {
    $ruggsack1 = $Data[0]    
    $ruggsack2 = $Data[1]    
    $ruggsack3 = $Data[2]    
    $Data = $Data[3..$Data.Length]

    $shared = (Compare-Object $ruggsack1.ToCharArray() $ruggsack2.ToCharArray() -ExcludeDifferent).InputObject
    $shared = (Compare-Object $shared $ruggsack3.ToCharArray() -ExcludeDifferent).InputObject

    if ($shared -is [Array]) {
        $shared = $shared[0]
    }

    $priority = switch -regex -casesensitive ($shared) {
        "[A-Z]" {
            [byte][char]$shared - [byte][char]'A' + 27
            break
        }
        default {
            [byte][char]$shared - [byte][char]'a' + 1
            break
        }
    }

    Write-Host ("{0} {1}" -f $shared, $priority)
    $priorities += $priority
}

$priorities
