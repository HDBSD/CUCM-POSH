<#
.SYNOPSIS
Retrieves a list of Calling Search Spaces (CSS) from Cisco Unified Call Manager (CUCM) using the AXL API.

.DESCRIPTION
The `Get-CUCMCallingSearchSpace` function retrieves a list of Calling Search Spaces (CSS) from a specified CUCM server using the AXL (Administrative XML) API. You can specify the session index to target a specific CUCM server connection if multiple connections are established.

.PARAMETER SessionIndex
Specifies the index of the CUCM server connection to use. If omitted, the default session index is 0.

.EXAMPLE
PS> $callingSearchSpaces = Get-CUCMCallingSearchSpace

Description:
Retrieves a list of Calling Search Spaces (CSS) from the default CUCM server connection (index 0).

PS> foreach ($css in $callingSearchSpaces) {
    Write-Host "Calling Search Space Name: $($css.name)"
    # Add additional properties as needed
}

Description:
Displays the retrieved Calling Search Spaces with their names.

.NOTES
Author: Brad S
Version: 1.0.0
#>

function Get-CUCMCallingSearchSpace {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [int]
        $SessionIndex = 0
    )
    
    begin {
        if ($null -eq $script:Connections[$SessionIndex]) {
            $PSCmdlet.ThrowTerminatingError("No connection found at the specified index. Please ensure the connection exists or create one first.")
        }
    }

    process {
        # Define the SOAP request XML template
        $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/$Script:AxlVersion">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:listCss sequence="1">
            <searchCriteria>
                <name>%</name>
            </searchCriteria>
            <returnedTags>
                <name>true</name>
            </returnedTags>
        </ns:listCss>
    </soapenv:Body>
</soapenv:Envelope>
"@

        try {
            # Send the SOAP request to the CUCM server
            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -WebSession $script:Connections[$SessionIndex].Session -Uri $script:Connections[$SessionIndex].Server `
                                        -ErrorAction Stop
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        # Extract and return the CSS data from the response
        $Result.Envelope.Body.listCssResponse.return.css
    }
}