function Start-CUCMLdapSync {
    param(
        [Parameter(ParameterSetName = 'ldapsync', Mandatory = $true, Position = 0)][string]$LdapName,
        [Parameter(ParameterSetName = 'ldapsync', Mandatory = $false, Position = 1)][int]$SessionIndex = 0
    )


    begin {

        if ($null -eq $script:Connections[$SessionIndex])
        {
            $PSCmdlet.ThrowTerminatingError("No Connection at specified id. double check your connection exists or create a connection first.")
        }
    }

    process {

        $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.0">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:doLdapSync sequence="1">
            <name>$LdapName</name>
            <sync>true</sync>
        </ns:doLdapSync>
    </soapenv:Body>
</soapenv:Envelope>
"@

        try {
            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -WebSession $script:Connections[$SessionIndex].Session -Uri $script:Connections[$SessionIndex].Server `
                                        -ErrorAction Stop
        }
        catch 
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }
        
        $Result.Envelope.Body.doLdapSyncResponse.return
    }
}