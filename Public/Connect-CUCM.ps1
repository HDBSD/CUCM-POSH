function Connect-CUCM {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'Connect', Mandatory = $true)]$CUCMAddress,
        [Parameter(ParameterSetName = 'Connect', Mandatory = $true)][PSCredential]$Credentials,
        [Parameter(ParameterSetName = 'Connect', Mandatory = $false)][switch]$NoAddressValidation = $false
    )

    <#
    .SYNOPSIS
    Creates and validates Cisco Unified Call Manager (CUCM) AXL connection 

    .DESCRIPTION
    Creates and validates CUCM AXL connection 
    Takes the axl url of CUCM e.g. (https://10.10.20.1:8443/axl/) and creates a session for
    viewing and managing objects within call manager

    .PARAMETER CUCMAddress
    Specifies the URI of CUCMs axl endpoint, usually this will be along the lines of https://10.10.20.1:8443/axl/

    .PARAMETER Credentials
    Specifies the username and password to authenticate to call manager with. ensure this user account has axl access
    within call manager.

    .PARAMETER NoAddressValidation
    By default this script will require the following for the CUCMAddress to be considered valid. 
    The provided address must using 'https', port 8443 and attempt to reach the path '/axl/'.

    By specifying this switch, these validations are disabled. 
    
    Note: Call manager is very specific about the AXL url and will often throw authentication not provided errors if there
    is any mistakes

    .INPUTS
    None.

    .OUTPUTS
    None. Session tokens are stored in memory

    .EXAMPLE
    PS> Connect-CUCM -CUCMAddress "https://10.10.20.1:8443/axl/"

    .EXAMPLE
    PS> Connect-CUCM -CUCMAddress "https://10.10.20.1:8443/axl/" -Credentials $cred

    .EXAMPLE
    PS> Connect-CUCM -CUCMAddress "http://10.10.20.1:1234/axl/" -NoAddressValidation
    #>

    begin 
    {
        $uri = $null

        if ($NoAddressValidation -eq $false)
        {
            $uri = [System.UriBuilder]::new($CUCMAddress)
            
            if  ( $uri.port -ne 8443 -or $uri.Scheme -ne "https" -or $uri.path.ToLower() -ne "/axl/" )
            {
                $PSCmdlet.ThrowTerminatingError("Provided CUCM Address failed validation. if non-standard ports or https is being used, please use the '-NoAddressValidation'.`n" + `
                                                "For a URI to be considered valid, it most be using 'https', port 8443 and attempt to reach the path '/axl/'. e.g. https://xyz.123.abc.789:8443/axl/")
            }
                
        }
        else 
        {
            $uri = [System.UriBuilder]::new($CUCMAddress)
        }

        $uri = $uri.Uri

    }

    process 
    {

        # build a soap request to query the version of the "cm-ver" package. 
        # we dont actually use the reply from this query, but if we get a http 200 reply, we know we've connected okay

        $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/14.0">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:executeSQLQuery>
            <sql>SELECT version FROM ComponentVersion WHERE (SoftwareComponent = 'cm-ver')</sql>
        </ns:executeSQLQuery>
    </soapenv:Body>
</soapenv:Envelope>
"@

        try 
        {

            # create a session to hold our axl session cookie

            $sessionVar = New-Object Microsoft.PowerShell.Commands.WebRequestSession 

            # post the above soap AXL request to call manager and throw a terminating error if we dont get a successful reply

            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -Credential $Credentials -Uri $uri -WebSession $sessionVar `
                                        -ErrorAction Stop
        
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        # store session in connections script var for later use.

        $id = New-Guid

        $script:Connections += [pscustomobject]@{ID=$id; Server = $CUCMAddress; Creds = $credentials; Session=$sessionVar}
        write-host "Connection successful. Session assigned ID: $id)"
    }
}