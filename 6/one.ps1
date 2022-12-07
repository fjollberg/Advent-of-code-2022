$Data = (Get-Content ./input.txt).ToCharArray()

function checkPos([int]$i) {
    for ($j=$i-3; $j -le $i; $j++) {
        for ($k=$i-3; $j -le $i; $k++) {
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

for ($i=3; $i -lt $Data.Length; $i++) {
    $answer = $Data[($i-3)..$i]
    Write-Host "word:" "$answer".Replace(' ','')
    if (checkPos($i)) {
        Write-Host "index:" ($i)
        Write-Host "answer:" ($i+1)
        break
    }
}