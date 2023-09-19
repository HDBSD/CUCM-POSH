function Get-CUCMDeviceProfile {
    param(
        [Parameter(ParameterSetName = 'Connect', Mandatory = $true, Position = 0)][string]$ProfileName,
        [Parameter(ParameterSetName = 'Connect', Mandatory = $false, Position = 1)][int]$ConnectionId = 0
    )
    
    begin {

        if ($null -eq $script:Connections[$ConnectionId])
        {
            $PSCmdlet.ThrowTerminatingError("No Connection at specified id. double check your connection exists or create a connection first.")
        }

    }

    process {

        $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.0">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:getDeviceProfile sequence="1">
            <name>$ProfileName</name>
        </ns:getDeviceProfile>
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
        
        $Result.Envelope.Body.getDeviceProfileResponse.return.deviceProfile
    }

}