$Data = Import-Csv "./input.txt" -Header ("other", "me") -Delimiter ' '

function score {
    param(
        [Parameter(Mandatory=$true)]
        [string]$other,

        [Parameter(Mandatory=$true)]
        [string]$me
    )
    switch -regex ($me + $other) {
        "XA" { 3 + 0 }
        "XB" { 1 + 0 }
        "XC" { 2 + 0 }
        "YA" { 1 + 3 }
        "YB" { 2 + 3 }
        "YC" { 3 + 3 }
        "ZA" { 2 + 6 }
        "ZB" { 3 + 6 }
        "ZC" { 1 + 6 }
    }
}

$Total = 0
foreach ($round in $Data) {
    $Total += score $round.other $round.me
}

$Total