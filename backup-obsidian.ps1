$sourceFolder = "C:\Users\abhik\Dropbox\Abhik\Documents"
$tempDir = "C:\"

Copy-Item $sourceFolder\'obsidian sync'\ $tempDir\backup -Recurse -Force


$targetFolder = "G:\My Drive\My Home\0_Unsorted\Obsidian Backup" 
$ts = Get-Date -Format yyyyMMddTHHmmss
Compress-Archive $tempDir\'backup'\ $targetFolder\obsidian_backup$ts.zip -Force


Remove-Item $tempDir\backup -Recurse -Force
