function Get-CUCMCallingSearchSpace {
    [CmdletBinding()]
    param (
        # Parameter help description
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
        $soapReq = ""

        # Define a common template for the SOAP request XML
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
            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -WebSession $script:Connections[$SessionIndex].Session -Uri $script:Connections[$SessionIndex].Server `
                                        -ErrorAction Stop
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $Result.Envelope.Body.listCssResponse.return.css
    }
}