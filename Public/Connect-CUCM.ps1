<#
.SYNOPSIS
Creates and validates a Cisco Unified Call Manager (CUCM) AXL connection.

.DESCRIPTION
This function creates and validates a CUCM AXL connection. It takes the AXL URL of CUCM (e.g., https://10.10.20.1:8443/axl/) and creates a session for viewing and managing objects within Call Manager.

.PARAMETER CUCMAddress
Specifies the URI of CUCM's AXL endpoint. Typically, this will be in the format https://10.10.20.1:8443/axl/.

.PARAMETER Credentials
Specifies the username and password to authenticate with Call Manager. Ensure this user account has AXL access within Call Manager.

.PARAMETER NoAddressValidation
By default, this script validates that the provided address meets the following criteria:
- Uses 'https'
- Uses port 8443
- Requests the path '/axl/'

By specifying this switch, these validations are disabled. Note that Call Manager is specific about the AXL URL and may throw authentication errors if there are any mistakes.

.INPUTS
None.

.OUTPUTS
None. Session tokens are stored in memory.

.EXAMPLE
PS> Connect-CUCM -CUCMAddress "https://10.10.20.1:8443/axl/"

.EXAMPLE
PS> Connect-CUCM -CUCMAddress "https://10.10.20.1:8443/axl/" -Credentials $cred

.EXAMPLE
PS> Connect-CUCM -CUCMAddress "http://10.10.20.1:1234/axl/" -NoAddressValidation
#>

function Connect-CUCM {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'Connect', Mandatory = $true)]
        $CUCMAddress,

        [Parameter(ParameterSetName = 'Connect', Mandatory = $true)]
        [PSCredential]
        $Credentials,

        [Parameter(ParameterSetName = 'Connect', Mandatory = $false)]
        [switch]
        $NoAddressValidation = $false
    )

    begin 
    {
        # Build a URI and check if it uses HTTPS, port 8443, and requests the "/axl/" path
        $uri = $null

        if (-not $NoAddressValidation)
        {
            $uri = [System.UriBuilder]::new($CUCMAddress)

            if ($uri.Port -ne 8443 -or $uri.Scheme -ne "https" -or $uri.Path.ToLower() -ne "/axl/")
            {
                $PSCmdlet.ThrowTerminatingError("Provided CUCM Address failed validation. If non-standard ports or HTTPS is being used, please use the '-NoAddressValidation'.`n" +
                    "For a URI to be considered valid, it must use 'https', port 8443, and request the path '/axl/'. e.g., https://xyz.123.abc.789:8443/axl/")
            }
        }
        else 
        {
            # If NoAddressValidation is enabled, skip the validation
            $uri = [System.UriBuilder]::new($CUCMAddress)
        }

        # Set URI to the built URI string
        $uri = $uri.Uri
    }

    process 
    {
        # Build a SOAP request to query the version of the "cm-ver" package.
        # We don't use the reply from this query, but if we get an HTTP 200 reply, we know we've connected successfully
        $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/$script:AxlVersion">
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
            # Create a session to hold our AXL session cookie
            $sessionVar = New-Object Microsoft.PowerShell.Commands.WebRequestSession 

            # Post the SOAP AXL request to Call Manager and throw a terminating error if we don't get a successful reply
            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -Credential $Credentials -Uri $uri -WebSession $sessionVar -ErrorAction Stop
        
            # Store the session in the Connections script variable for later use
            $id = New-Guid
            $script:Connections += [pscustomobject]@{ ID = $id; Server = $CUCMAddress; Session = $sessionVar }
            Write-Host "Connection successful. Session assigned ID: $id"
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}