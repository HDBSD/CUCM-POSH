function Get-CUCMLdapConnectors {
    param(
        [Parameter(ParameterSetName = 'filter', Mandatory = $false, Position = 0)][int]$ConnectionId = 0
    )

    process {

        $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/14.0">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:listLdapDirectory sequence="1">
            <searchCriteria>
                <name>%</name>
            </searchCriteria>
            <returnedTags>
                <name>true</name>
                <ldapDn>true</ldapDn>
                <userSearchBase>true</userSearchBase>
            </returnedTags>
        </ns:listLdapDirectory>
    </soapenv:Body>
</soapenv:Envelope>
"@

        try {
            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -Credential $script:Connections[$ConnectionId].Creds -Uri $script:Connections[$ConnectionId].Server `
                                        -ErrorAction Stop
        }
        catch 
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $Result.Envelope.Body.listLdapDirectoryResponse.return.ldapDirectory
    }
}