function Get-CUCMSessions
{
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'Sessions', Mandatory = $false)][string]$SessionId = ''
    )

    process
    {

        if ($SessionId.Length -eq 0)
        {
            $script:Connections
        }
        else {
            $script:Connections | Where-Object {$_.ID -eq $SessionId}
        }

    }

}