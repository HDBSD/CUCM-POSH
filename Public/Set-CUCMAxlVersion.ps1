<#
.SYNOPSIS
Sets the Cisco Unified Call Manager (CUCM) AXL version to be used for subsequent operations.

.DESCRIPTION
This function sets the AXL version to be used when interacting with CUCM. The AXL version determines the compatibility of API calls and responses with the specified CUCM version.

.PARAMETER AxlVersion
Specifies the AXL version to set. This should be a string representing the desired AXL version (e.g., "12.0").

.INPUTS
None.

.OUTPUTS
None.

.EXAMPLE
PS> Set-CUCMAxlVersion -AxlVersion "12.0"

Description:
Sets the AXL version to "12.0" for CUCM interactions.

.NOTES
Author: Brad S
Version: 1.0.0
#>

function Set-CUCMAxlVersion {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName="Version", Position=0, Mandatory=$true)]
        [string]
        $AxlVersion
    )
    
    process {
        # Set the module-level AxlVersion variable to the specified version
        $script:AxlVersion = $AxlVersion    
    }
}