<#
.SYNOPSIS
Removes a Cisco Unified Call Manager (CUCM) session stored in the module.

.DESCRIPTION
This function removes a CUCM session from the module based on the provided SessionId or Index. You can use either SessionId or Index to specify which session to remove.

.PARAMETER SessionId
Specifies the ID of the session to remove.

.PARAMETER Index
Specifies the index of the session to remove. If both SessionId and Index are provided, SessionId takes precedence.

.INPUTS
None.

.OUTPUTS
None.

.EXAMPLE
PS> Remove-CUCMSession -SessionId "abc123"

Description:
Removes the CUCM session with the specified SessionId.

.EXAMPLE
PS> Remove-CUCMSession -Index 0

Description:
Removes the CUCM session at the specified index.

.NOTES
Author: Brad S
Version: 1.0.0
#>

function Remove-CUCMSession
{
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'Sessions', Mandatory = $false)]
        [string]
        $SessionId = '',

        [Parameter(ParameterSetName = 'Sessions', Mandatory = $false)]
        [int]
        $Index
    )

    process
    {
        if ($SessionId.Length -ne 0)
        {
            # If SessionId is provided, remove the session with the matching ID
            $sessionToRemove = $script:Connections | Where-Object { $_.ID -eq $SessionId }
        }
        elseif ($Index -ge 0 -and $Index -lt $script:Connections.Count)
        {
            # If Index is provided and within the range of available sessions, remove the session at the specified index
            $sessionToRemove = $script:Connections[$Index]
        }
        else
        {
            Write-Error "No session found to remove."
            return
        }

        if ($sessionToRemove -ne $null)
        {
            # Remove the session from the Connections list
            $script:Connections.Remove($sessionToRemove)
            Write-Host "Session removed successfully."
        }
        else
        {
            Write-Error "Session not found."
        }
    }
}