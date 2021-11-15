$targetFolder = "G:\My Drive\My Home\0_Unsorted\Obsidian Backup"

$files = Get-ChildItem -File -Path $targetFolder

Write-Host $files.Count

$limit = (Get-Date).AddDays(-5)
Write-Host $limit

forEach ($file in $files){
	Write-Host $file.Name
	if($file.LastWriteTime -lt $limit){
		$fileToBeRemoved = $file.Name
		Write-Host "Removing File: "$fileToBeRemoved
		Remove-Item "$targetFolder\$fileToBeRemoved"
	}
}
