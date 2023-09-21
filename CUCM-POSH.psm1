# Define module-level variables

$script:Connections = @()
$Script:AxlVersion = "12.0"

# Get a list of all script files to import

$enumScripts = Get-ChildItem -Path $PSScriptRoot\Enums\*.ps1 -ErrorAction SilentlyContinue
$classScripts = Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 -ErrorAction SilentlyContinue
$publicScripts = Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue
$privateScripts = Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue

# Combine the script files into a single array
$allScripts = @() + $enumScripts + $classScripts + $publicScripts + $privateScripts

# Loop through each script file and import its contents
foreach ($import in $allScripts)
{
    try
    {
        . $import.FullName
    }
    catch
    {
        # Log an error if the import fails
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}

# Module initialization is complete
Write-Host "CUCM-POSH module initialized."