function Connect-CUCM {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'Connect', Mandatory = $true)]$CUCMAddress,
        [Parameter(ParameterSetName = 'Connect', Mandatory = $true)][PSCredential]$credentials
    )

    begin {

        $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/12.5">
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

            

            $pwd = ConvertTo-SecureString $credentials.GetNetworkCredential().password -AsPlainText -Force
            $cred = New-Object Management.Automation.PSCredential ($credentials.UserName, $pwd)

            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -Credential $cred -Uri $CUCMAddress `
                                        -ErrorAction Stop
        }
        catch
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }

    }

    process 
    {
        $script:Connections += @(@{Server = $CUCMAddress; Creds = $credentials})
    }

}