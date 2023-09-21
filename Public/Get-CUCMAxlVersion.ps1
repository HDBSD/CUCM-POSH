<#
.SYNOPSIS
Gets the Cisco Unified Call Manager (CUCM) AXL version currently set in the module.

.DESCRIPTION
This function retrieves and returns the AXL version currently set in the module. The AXL version determines the compatibility of API calls and responses with the specified CUCM version.

.INPUTS
None.

.OUTPUTS
The currently configured AXL version.

.EXAMPLE
PS> Get-CUCMAxlVersion

Description:
Retrieves the currently configured AXL version for CUCM interactions.

.NOTES
Author: Brad S
Version: 1.0.0
#>

function Get-CUCMAxlVersion {
    process {
        # Return the currently configured AXL version
        $script:AXLVersion
    }
}