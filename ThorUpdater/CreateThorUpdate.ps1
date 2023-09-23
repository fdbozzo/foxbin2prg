# Get the project settings from Project.txt
$appInfo = Get-Content Project.txt
$appName = $appInfo[0].Substring($appInfo[0].IndexOf('=') + 1).Trim()
$appID   = $appInfo[1].Substring($appInfo[1].IndexOf('=') + 1).Trim()
$majorVersion = $appInfo[2].Substring($appInfo[2].IndexOf('=') + 1).Trim()
$exclude = $appInfo[3].Substring($appInfo[3].IndexOf('=') + 1).Trim()
# Ensure no spaces before or after comma
$excludeFiles = $exclude.Split(',')
# Ensure no spaces before or after comma
$exclude = $appInfo[4].Substring($appInfo[4].IndexOf('=') + 1).Trim()
$excludeFolders = $exclude.Split(',')

# Get the name of the zip file.
$zipFileName = "ThorUpdater\$appID.zip"

# Move up to the project folder

cd ..
try
{ 
    # Delete the zip file if it exists.
    $exists = Test-Path ($zipFileName)
    if ($exists)
    {
        del ($zipFileName)
    }

    # Loop through all the files in the project folder except those we don't want
    # and add them to a zip file.
    # See https://stackoverflow.com/questions/15294836/how-can-i-exclude-multiple-folders-using-get-childitem-exclude
    # for how to exclude folders when -Recurse is used
    $files = @(Get-ChildItem . -recurse -file -exclude $excludeFiles |
        %{ 
            $allowed = $true
            foreach ($exclude in $excludeFolders)
            { 
                if ((Split-Path $_.FullName -Parent) -ilike $exclude)
                { 
                    $allowed = $false
                    break
                }
            }
            if ($allowed)
            {
                $_
            }
        }
    );

    # See https://stackoverflow.com/questions/51392050/compress-archive-and-preserve-relative-paths to compress
    # exclude directory entries and generate fullpath list
    $filesFullPath = $files | Where-Object -Property Attributes -CContains Archive | ForEach-Object -Process {Write-Output -InputObject $_.FullName}

    #create zip file
    Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
    $zip = [System.IO.Compression.ZipFile]::Open((Join-Path -Path $(Resolve-Path -Path ".") -ChildPath $zipFileName), [System.IO.Compression.ZipArchiveMode]::Create)

    #write entries with relative paths as names
    foreach ($fname in $filesFullPath)
    {
        $rname = $(Resolve-Path -Path $fname -Relative) -replace '\.\\',''
        $zentry = $zip.CreateEntry($rname)
        $zentryWriter = New-Object -TypeName System.IO.BinaryWriter $zentry.Open()
        $zentryWriter.Write([System.IO.File]::ReadAllBytes($fname))
        $zentryWriter.Flush()
        $zentryWriter.Close()
    }

    # clean up
    Get-Variable -exclude Runspace | Where-Object {$_.Value -is [System.IDisposable]} | Foreach-Object {$_.Value.Dispose(); Remove-Variable $_.Name};

    # If the zip file was created, read in the Version source file, replace
    # placeholders, and write out the project version file.
    if ($?)
    {
        # Read in the update file
        $date = Get-Date
        $file = $appID + 'Version.txt'
        (Get-Content ThorUpdater\Version.txt).
            Replace('date()', 'date(' + $date.Year + ',' + $date.Month + ',' + $date.Day + ')').
            Replace('APPNAME', $appName).
            Replace('MAJORVERSION', $majorVersion) |
            Set-Content ThorUpdater\$file
        Write-Host "Update creation successful"
    }
    else
    { 
        Write-Host "Zip creation failed"
		pause
    } 
}

catch
{
    Write-Host "Error occurred at $(Get-Date): $($Error[0].Exception.Message)"
	pause
} 

finally
{
# Move back to the ThorUpdater folder
    cd ThorUpdater
} 
