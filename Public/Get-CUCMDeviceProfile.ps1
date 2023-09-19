function Get-CUCMDeviceProfile {
    param(
        [Parameter(ParameterSetName = 'Connect', Mandatory = $true, Position = 0)][string]$ProfileName,
        [Parameter(ParameterSetName = 'Connect', Mandatory = $false, Position = 1)][int]$SessionIndex = 0
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
        <ns:getDeviceProfile sequence="1">
            <name>$ProfileName</name>
        </ns:getDeviceProfile>
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
        
        $Result.Envelope.Body.getDeviceProfileResponse.return.deviceProfile
    }

}