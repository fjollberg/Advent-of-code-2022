[CmdletBinding()]
param (
    [String]$File = "./input.txt"
)

$Data = Get-Content $file