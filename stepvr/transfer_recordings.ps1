function Transfer-Recordings {
    param (
        [string]$sourcePath,
        [string]$destinationPath,
        [string]$prefix
    )

    # Get all files from the source path
    Get-ChildItem -Path $sourcePath -File | ForEach-Object {
        $file = $_
        
        # Extract the date in "YYYY.MM.DD" format from the file name
        if ($file.Name -match "\d{4}\.\d{2}\.\d{2}") {
            $date = $matches[0]
            
            # Convert the date to "YYYY-MM-DD" format
            $formattedDate = $date -replace '\.', '-'
            
            # Create the destination folder path
            $targetFolder = Join-Path -Path $destinationPath -ChildPath $formattedDate
            
            # Ensure the destination folder exists
            if (-not (Test-Path -Path $targetFolder)) {
                New-Item -ItemType Directory -Path $targetFolder | Out-Null
            }
            
            # Prepend the prefix
            $newFileName = "$prefix $($file.Name)"

            # Assemble the full target file path
            $targetFilePath = Join-Path -Path $targetFolder -ChildPath $newFileName

            # Move the file to the destination folder
            Move-Item -Path $file.FullName -Destination $targetFilePath
        } else {
            Write-Host "File name does not match expectation: $($file.Name)"
        }
    }

    Write-Host "File transfer completed for $sourcePath to $destinationPath."
}

# Call the function for Raum01 to Raum12
for ($i = 1; $i -le 12; $i++) {
    $roomNumber = "{0:D2}" -f $i
    $sourcePath = "\\ifasdata.wwu.de\vrvideo\StepVR\Raum$roomNumber"
    $destinationPath = "V:\3_StepVR_Data\Videos"
    Transfer-Recordings -sourcePath $sourcePath -destinationPath $destinationPath -prefix "Raum$roomNumber"
}
