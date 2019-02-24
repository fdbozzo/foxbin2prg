# Import the Powershell Community Extensions add-on module.
#Import-Module PSCX
Import-Module Pscx -Prefix Pscx

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
    Get-ChildItem . -Recurse -File -Exclude $excludeFiles | %{ 
        $allowed = $true
        foreach ($exclude in $excludeFolders) { 
            if ((Split-Path $_.FullName -Parent) -ilike $exclude) { 
                $allowed = $false
                break
            }
        }
        if ($allowed) {
            $_
        }
    } | Write-Zip -OutputPath $zipFileName


    # If the zip file was created, read in the Version source file, replace
    # placeholders, and write out the project version file.
    if ($?)
    {
        # Read in the update file
        $date = Get-Date
        $file = $appID + 'Version.txt'
        (Get-Content ThorUpdater\Version.txt)
            .Replace('date()', 'date(' + $date.Year + ',' + $date.Month + ',' + $date.Day + ')')
            .Replace('APPNAME', $appName)
            .Replace('MAJORVERSION', $majorVersion) |
            Set-Content ThorUpdater\$file
        Write-Host "Update creation successful"
    }
    else
    { 
        Write-Host "Zip creation failed"
    } 
}

catch
{
    Write-Host "Error occurred at $(Get-Date): $($Error[0].Exception.Message)"
} 

finally
{
# Move back to the ThorUpdater folder
    cd ThorUpdater
} 
