
<#
.SYNOPSIS
Searches for LDAP connectors configured in Cisco Unified Call Manager (CUCM).

.DESCRIPTION
This function allows you to search for LDAP connectors in CUCM. It retrieves a list of LDAP directories and their details.

.PARAMETER SessionIndex
Specifies the index of the CUCM session to use for the search.

.INPUTS
None.

.OUTPUTS
Returns a table with the following columns: [string]'Name', [string]'LdapDn', and [string]'UserSearchBase'.

.EXAMPLE
PS> Find-CUCMLdapConnectors

Description:
Searches for all LDAP connectors configured in CUCM.

.EXAMPLE
PS> Find-CUCMLdapConnectors -SessionIndex 1

Description:
Searches for all LDAP connectors using the specified session index.
#>

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