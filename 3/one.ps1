$Data = Get-Content ./input.txt

$priorities = 0

foreach ($ruggsack in $Data) {
    $compartment1 = $ruggsack.Substring(0,$ruggsack.Length/2)
    $compartment2 = $ruggsack.Substring($ruggsack.Length/2)

    $shared = (Compare-Object $compartment1.ToCharArray() $compartment2.ToCharArray() -ExcludeDifferent).InputObject
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

    Write-Host ("{0} {1} {2} {3} {4}" -f $ruggsack, $compartment1, $compartment2, $shared, $priority)
    $priorities += $priority
}

$priorities