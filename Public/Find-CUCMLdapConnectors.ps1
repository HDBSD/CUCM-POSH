function Find-CUCMLdapConnectors {
    param(
        [Parameter(ParameterSetName = 'filter', Mandatory = $false, Position = 0)][int]$SessionIndex = 0
    )

    begin {

        if ($null -eq $script:Connections[$SessionIndex])
        {
            $PSCmdlet.ThrowTerminatingError("No Connection at specified id. double check your connection exists or create a connection first.")
        }
    }

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
                                        -WebSession $script:Connections[$SessionIndex].Session -Uri $script:Connections[$SessionIndex].Server `
                                        -ErrorAction Stop
        }
        catch 
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $Result.Envelope.Body.listLdapDirectoryResponse.return.ldapDirectory
    }
}