[CmdletBinding()]
param (
    [String]$File = "./input.txt",
    [int]$Stop = 0
)

$Data = Get-Content $file

$X = 1
$width = 40
$cycle = [System.Collections.ArrayList]@()
$screen = [System.Collections.ArrayList]@()

function pixel {
    $sprite = (
        ($screen.Count % $width - 1),
        ($screen.Count % $width),
        ($screen.Count % $width + 1)
    )

    if ($cycle[$screen.Count] -in $sprite) {
        $char = '#'
    } else {
        $char = '.'
    }
    Write-Verbose ("cycle: {0} X: {1} char: '{2}'" -f $screen.Count, $cycle[$screen.Count], $char)
    $char
}

function cycle {
    $cycle.Add($X) | Out-Null
    $screen.Add((pixel)) | Out-Null
}

foreach ($line in $Data) {
    Write-Verbose $line

    switch -Regex ($line) {
        "^noop$" {
            cycle
        }
        "^addx .*" {
            ($command, [int]$arg) = $line.Split(' ')
            cycle
            cycle
            $X += $arg
        }
    }

    if ($Stop -and ($cycle.Count -gt $Stop)) {
        break
    }
}

for ($l = 0; $l -lt $screen.Count; $l += $width) {
    Write-Output ($screen[$l..($l+$width-1)] -join "")
}