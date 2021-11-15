$obsidianProcess = Get-Process obsidian -ErrorAction SilentlyContinue

if($obsidianProcess){
	Write-Host "Obsidian is currently running... Cannot take backup while Obsidian is running..."
}
else {
	$obsidianBackupScript = "$PSScriptRoot/backup-obsidian.ps1"
	Write-Host "Backup started..."
	invoke-expression -Command $obsidianBackupScript
	Write-Host "Backup completed..."
}


Write-Host "Running Cleanup Task..."
$cleanupScript = "$PSScriptRoot/cleanup-obsidian-backup-files.ps1"
invoke-expression -Command $cleanupScript
Write-Host "Cleanup Task Completed"
Write-Host "Done!! 🥂"
