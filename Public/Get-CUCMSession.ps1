<#
.SYNOPSIS
Retrieves Cisco Unified Call Manager (CUCM) sessions stored in the module.

.DESCRIPTION
This function retrieves CUCM sessions that have been established and stored within the module. A session represents a connection to a CUCM server.

.PARAMETER SessionId
Specifies the ID of the session to retrieve. If no SessionId is provided, all available sessions will be returned.

.PARAMETER Index
Specifies the index of the session to retrieve. If both SessionId and Index are provided, SessionId takes precedence.

.INPUTS
None.

.OUTPUTS
A list of CUCM sessions. Each session contains:
- Index: The index of the session in the list.
- ID: The unique identifier for the session.
- Server: The URI of the CUCM server.
- Session: The session object.

.EXAMPLE
PS> Get-CUCMSession

Description:
Retrieves all active CUCM sessions.

.EXAMPLE
PS> Get-CUCMSession -SessionId "abc123"

Description:
Retrieves the CUCM session with the specified SessionId.

.EXAMPLE
PS> Get-CUCMSession -Index 0

Description:
Retrieves the first CUCM session by index.

.NOTES
Author: Brad S
Version: 1.2.0
#>

function Get-CUCMSession
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
        $sessions = @()

        if ($SessionId.Length -ne 0)
        {
            # If SessionId is provided, filter and return the session with the matching ID
            $sessions = $script:Connections | Where-Object { $_.ID -eq $SessionId }
        }
        elseif ($Index -ge 0 -and $Index -lt $script:Connections.Count)
        {
            # If Index is provided and within the range of available sessions, return the session at the specified index
            $sessions = $script:Connections[$Index]
        }
        else
        {
            # If neither SessionId nor Index is provided, return all available sessions
            $sessions = $script:Connections
        }

        # Add an 'Index' property to each session in the list
        $sessions | ForEach-Object { $_ | Add-Member -MemberType NoteProperty -Name "Index" -Value $script:Connections.IndexOf($_) }

        # Return the sessions list
        $sessions
    }
}