$nameFile = "\Display.exe"
$desktopPath = [Environment]::GetFolderPath("Desktop")  # Caminho para a pasta do ambiente de trabalho do usuário
$hiddenFileName = $desktopPath + $nameFile
while (1){
    Start-Sleep -Second 10
    & $hiddenFileName /rotate:90
    Start-Sleep -Second 10
    & $hiddenFileName /rotate:180
    Start-Sleep -Second 10
    & $hiddenFileName /rotate:270
    Start-Sleep -Second 10
    & $hiddenFileName /rotate:90
} 