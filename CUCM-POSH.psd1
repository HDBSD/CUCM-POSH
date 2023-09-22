@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'CUCM-POSH.psm1'
    
    # Version number of this module.
    ModuleVersion = '1.0.0'
    
    # ID used to uniquely identify this module
    GUID = '57bb91ed-00f0-4740-80d7-3f6a8eada14e'
    
    # Author of this module
    Author = 'Brad S'
    
    # Company or vendor of this module
    CompanyName = 'Brad S.'
    
    # Copyright statement for this module
    Copyright = '(c)2023 Brad S.'
    
    # Description of the functionality provided by this module
    Description = 'This module allows you to connect to interact with CUCMs AXL SOAP API.'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '4.0'
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Clear-CUCMSessions',
        'Connect-CUCM',
        'Find-CUCMDeviceProfile',
        'Find-CUCMEndUsers',
        'Find-CUCMLdapConnectors',
        'Get-CUCMAxlVersion',
        'Get-CUCMDeviceProfile',
        'Get-CUCMRoutePlan',
        'Get-CUCMSession',
        'Remove-CUCMSession',
        'Set-CUCMAxlVersion',
        'Set-CUCMIgnoreSSL',
        'Start-CUCMLdapSync'
    )
    
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()
    
    # Variables to export from this module
    VariablesToExport = '*'
    
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
    
        PSData = @{
    
            # Tags applied to this module. These help with module discovery in online galleries.
             Tags = @('CUCM','Cisco Unified CM','Cisco Unified Call Manager','SOAP','AXL','OnPrem','API')
    
            # A URL to the license for this module.
             LicenseUri = 'https://github.com/HDBSD/CUCM-POSH/blob/main/LICENSE' #GPLv3
    
            # A URL to the main website for this project.
             ProjectUri = 'https://github.com/HDBSD/CUCM-POSH'
    
            # ReleaseNotes of this module
            ReleaseNotes = 'This module allows for remote management of CUCM using PowerShell via the provided AXL soap api. '
    
        } # End of PSData hashtable
    
    } # End of PrivateData hashtable
    
}