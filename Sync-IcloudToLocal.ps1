function Sync-ICloudToLocal {

    [CmdletBinding()]
    Param(
        [Switch] $ICloudToLocal #By Default this script will transfer data from Local to ICloud
    )

    $INCLUDE = @("*.md", "*.jepg", "*.jpg", "*.png", "*.svg")
    # Define Local and Icloud Path
    $allICloudFiles = Get-ChildItem -Recurse -Include $INCLUDE -Exclude *MOC.md "C:\Users\abhik\iCloudDrive\iCloud~md~obsidian\obsidian sync"
    $allLocalFiles = Get-ChildItem -Recurse -Include $INCLUDE -Exclude *MOC.md "C:\Users\abhik\Dropbox\Abhik\Documents\obsidian sync"

    $allLocalFileNames = $allLocalFiles.Name
    $allICloudFileNames = $allICloudFiles.Name
    $rootLocal = "C:\Users\abhik\Dropbox\Abhik\Documents\obsidian sync"
    $rootCloud = "C:\Users\abhik\iCloudDrive\iCloud~md~obsidian\obsidian sync"

    # Figure out all the common files
    $common = $allICloudFiles.Name | Where-Object { $allLocalFiles.Name -contains $_ }

    # What to do with these files now
    Write-Output "----------------------------------------------------------------------"
    Write-Output "-------------------PROCESSING EXISTING FILES--------------------------"
    #Write-Output "----------------------------------------------------------------------"
    forEach ($commonName in $common) {
        $commonObjFromCloud = $allICloudFiles | Where-Object { $_.Name -eq $commonName }
        $commonObjFromLocal = $allLocalFiles | Where-Object { $_.Name -eq $commonName }

        if ($commonObjFromCloud.Length -ne $commonObjFromLocal.Length) {
            Write-Output "Files are different: $commonName"
            Write-Output "Size for Cloud: $($commonObjFromCloud.Length)"
            Write-Output "Size for Local: $($commonObjFromLocal.Length)"
            Write-Output "ICloudToLocal Flag: $ICloudToLocal"

            if (!$ICloudToLocal) {
                $commonObj = $commonObjFromLocal
                $appendLocalPath = ($commonObj.DirectoryName).substring($rootLocal.Length, (($commonObj.DirectoryName).Length - $rootLocal.Length))
                $fullPathToCloud = "$rootCloud$appendLocalPath\$($commonObj.Name)"
                $dirPath = "$rootCloud$appendLocalPath"
                Write-Output "Dir: $dirPath"
                Write-Output "Source: $($commonObj.FullName)"
                Write-Output "Target: $fullPathToCloud"
                if (!(Test-Path -path $dirPath)) { New-Item $dirPath -Force -Type Directory }
                Copy-Item -Path $($commonObj.FullName) -Destination $fullPathToCloud
            }
            else {
                $commonObj = $commonObjFromCloud
                $appendCloudPath = ($commonObj.DirectoryName).substring($rootCloud.Length, (($commonObj.DirectoryName).Length - $rootCloud.Length))
                $fullPathToLocal = "$rootLocal$appendCloudPath\$($commonObj.Name)"
                $dirPath = "$rootLocal$appendCloudPath"
                Write-Output "Dir: $dirPath"
                Write-Output "Source: $($commonObj.FullName)"
                Write-Output "Target: $fullPathToLocal"
                if (!(Test-Path -path $dirPath)) { New-Item $dirPath -Force -Type Directory }
                Copy-Item -Path $($commonObj.FullName) -Destination $fullPathToLocal
            }
        }
    }

    #Write-Output "----------------------------------------------------------------------"
    Write-Output "---------------PROCESSING EXISTING FILES: DONE------------------------"
    Write-Output "----------------------------------------------------------------------"

    # Figure out all the new files
    Write-Output "----------------------------------------------------------------------"
    Write-Output "----------------------PROCESSING NEW FILES----------------------------"
    #Write-Output "----------------------------------------------------------------------"

    $cloudNew = $allICloudFiles.Name | Where-Object { $allLocalFiles.Name -notcontains $_ }
    $localNew = $allLocalFiles.Name | Where-Object { $allICloudFiles.Name -notcontains $_ }

    Write-Output "------------------CLOUD NEW FILES--------------------------"
    foreach ($cloudNewItem in $cloudNew) {
        Write-Output $cloudNewItem
        $newItemObj = $allICloudFiles | Where-Object { $_.Name -eq $cloudNewItem }
        $commonObj = $newItemObj
        $appendLocalPath = ($commonObj.DirectoryName).substring($rootCloud.Length, (($commonObj.DirectoryName).Length - $rootCloud.Length))
        $fullPathToCloud = "$rootLocal$appendLocalPath\$($commonObj.Name)"
        $dirPath = "$rootLocal$appendLocalPath"
        Write-Output "Dir: $dirPath"
        Write-Output "Source: $($commonObj.FullName)"
        Write-Output "Target: $fullPathToCloud"
        if (!(Test-Path -path $dirPath)) { New-Item $dirPath -Force -Type Directory }
        Copy-Item -Path $($commonObj.FullName) -Destination $fullPathToCloud
    }
    Write-Output "------------------LOCAL NEW FILES--------------------------"
    foreach ($localNewItem in $localNew) {
        Write-Output $localNewItem
        $newItemObj = $allLocalFiles | Where-Object { $_.Name -eq $localNewItem }
        $commonObj = $newItemObj
        $appendLocalPath = ($commonObj.DirectoryName).substring($rootLocal.Length, (($commonObj.DirectoryName).Length - $rootLocal.Length))
        $fullPathToCloud = "$rootCloud$appendLocalPath\$($commonObj.Name)"
        $dirPath = "$rootCloud$appendLocalPath"
        Write-Output "Dir: $dirPath"
        Write-Output "Source: $($commonObj.FullName)"
        Write-Output "Target: $fullPathToCloud"
        if (!(Test-Path -path $dirPath)) { New-Item $dirPath -Force -Type Directory }
        Copy-Item -Path $($commonObj.FullName) -Destination $fullPathToCloud
    }
    #Write-Output "----------------------------------------------------------------------"
    Write-Output "-----------------PROCESSING NEW FILES: DONE---------------------------"
    Write-Output "----------------------------------------------------------------------"
}
