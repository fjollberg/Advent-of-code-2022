$Data = (Get-Content ./input.txt).ToCharArray()

function checkPos([int]$i, [int]$length) {
    for ($j=$i-$length+1; $j -le $i; $j++) {
        for ($k=$i-$length+1; $j -le $i; $k++) {
            if ($j -eq $k) {
                break
            }
            if ($Data[$j] -eq $Data[$k]) {
                return $false
            }
        }
    }
    return $true
}

$length = 14
for ($i=$length-1; $i -lt $Data.Length; $i++) {
    $answer = $Data[($i-$length+1)..$i]
    Write-Host "word:" "$answer".Replace(' ','')
    if (checkPos $i $length) {
        Write-Host "index:" ($i)
        Write-Host "answer:" ($i+1)
        break
    }
}