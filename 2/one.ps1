$Data = Import-Csv "./input.txt" -Header ("other", "me") -Delimiter ' '

function score {
    param(
        [Parameter(Mandatory=$true)]
        [string]$other,

        [Parameter(Mandatory=$true)]
        [string]$me
    )
    switch -regex ($me + $other) {
        "XA" { 1 + 3 }
        "XB" { 1 + 0 }
        "XC" { 1 + 6 }
        "YA" { 2 + 6 }
        "YB" { 2 + 3 }
        "YC" { 2 + 0 }
        "ZA" { 3 + 0 }
        "ZB" { 3 + 6 }
        "ZC" { 3 + 3 }
    }
}

$Total = 0
foreach ($round in $Data) {
    $Total += score $round.other $round.me
}

$Total