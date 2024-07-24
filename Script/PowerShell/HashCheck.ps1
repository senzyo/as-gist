# List the hash values of files in the folder. Highlight duplicate hash values.

# Get the path for Folder A
Write-Host -ForegroundColor Yellow "Input the path for a Folder (If you want to use the current path, press enter):"
$folderA = Read-Host
$folderA = $folderA -replace '"', ''

# User chooses whether to include files from all subfolders in Folder A
Write-Host -ForegroundColor Yellow "Select a number: [1] Exclude subfolder (Default) [2] Include subfolder"
$subfolder = Read-Host
$subfolder = if ($subfolder -eq '2') { $true } else { $false }
$folderAFiles = Get-ChildItem -Path $folderA -File -Recurse:$subfolder

# Get the path for Folder B
Write-Host -ForegroundColor Yellow "Input the path for another Folder (If you don't need it, press enter):"
$folderB = Read-Host
$folderB = $folderB -replace '"', ''

# User chooses whether to include files from all subfolders in Folder B
if ($folderB -ne '') {
    Write-Host -ForegroundColor Yellow "Select a number: [1] Exclude subfolder (Default) [2] Include subfolder"
    $subfolder = Read-Host
    $subfolder = if ($subfolder -eq '2') { $true } else { $false }
    $folderBFiles = Get-ChildItem -Path $folderB -File -Recurse:$subfolder
}

# Get all files
$allFiles = @($folderAFiles)
if ($folderB -ne '') {
    $allFiles += $folderBFiles
}

# User chooses the hash algorithm
Write-Host -ForegroundColor Yellow "Enter a number to select an algorithm: [1] MD5 (Default), [2] SHA1, [3] SHA256"
$algorithm = Read-Host
switch ($algorithm) {
    '2' { $algorithm = 'SHA1' }
    '3' { $algorithm = 'SHA256' }
    Default { $algorithm = 'MD5' }
}

# Initialize hashtable to store hash values and corresponding file paths
$hashTable = @{}

# Calculate hash value for each file and store it in the hashtable
foreach ($file in $allFiles) {
    $hash = Get-FileHash -Path $file.FullName -Algorithm $algorithm | Select-Object -ExpandProperty Hash

    # If hash value already exists in the hashtable, add the current file path to the array associated with the hash value
    if ($hashTable.ContainsKey($hash)) {
        $hashTable[$hash] += $file.FullName
    }
    else {
        # If hash value does not exist, create a new array and add the current file path to the array
        $hashTable[$hash] = @($file.FullName)
    }
}

# Output hash values and corresponding file paths
foreach ($hash in $hashTable.Keys) {
    Write-Host -ForegroundColor Yellow "Hash:"
    if ($hashTable[$hash].Count -gt 1) {
        Write-Host $hash -BackgroundColor Yellow -ForegroundColor Black
    }
    else {
        Write-Host $hash
    }
    Write-Host -ForegroundColor Yellow "FilePath:"
    foreach ($filePath in $hashTable[$hash]) {
        Write-Host $filePath
    }
    Write-Host ""
}

# Prompt user to press Enter to close the window
Write-Host -ForegroundColor Green "`nPress Enter to close the window."
Read-Host