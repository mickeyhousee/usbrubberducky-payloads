$filePath = "D:\Display.exe" 
$nameFile = "\Display.exe"
$desktopPath = [Environment]::GetFolderPath("Desktop")
Copy-Item -Path "$filePath" -Destination "$desktopPath" -Recurse
$hiddenFileName = $desktopPath + $nameFile
$fileAttributes = [System.IO.FileAttributes]::Hidden
$file = Get-Item $hiddenFileName
$file.Attributes = $fileAttributes