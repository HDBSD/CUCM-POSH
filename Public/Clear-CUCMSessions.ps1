<#
.SYNOPSIS
Clears all stored Cisco Unified Call Manager (CUCM) sessions.

.DESCRIPTION
This function clears all stored CUCM sessions, effectively disconnecting from all CUCM instances.

.INPUTS
None.

.OUTPUTS
None.

.EXAMPLE
PS> Clear-CUCMSessions

Description:
Clears all stored CUCM sessions.
#>

function Clear-CUCMSessions
{
    process
    {
        $script:Connections = @()
        write-host "Connections cleared!"
    }
}