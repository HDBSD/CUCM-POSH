function Find-CUCMDeviceProfile {
    [CmdletBinding(DefaultParameterSetName = 'NameSearch')]
    param(
        [Parameter(ParameterSetName = 'NameSearch', Mandatory = $true, Position = 0)]
        [string]$ProfileName,
        [Parameter(ParameterSetName = 'DescriptionSearch', Mandatory = $true, Position = 0)]
        [string]$Description,
        [Parameter(ParameterSetName = 'DescriptionSearch', Mandatory = $false, Position = 1)]
        [Parameter(ParameterSetName = 'NameSearch', Mandatory = $false, Position = 1)]
        [int]$ConnectionId = 0
    )
    
    begin {

        if ($null -eq $script:Connections[$ConnectionId])
        {
            $PSCmdlet.ThrowTerminatingError("No Connection at specified id. double check your connection exists or create a connection first.")
        }
    }

    process {

        $soapReq = ""

        switch ($PSCmdlet.ParameterSetName) {
            'NameSearch' {

                $ProfileName = "%$ProfileName%"

                $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/14.0">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:listDeviceProfile sequence="1">
            <searchCriteria>
                <name>$ProfileName</name>
            </searchCriteria>
            <returnedTags>
                <name>true</name>
                <description>true</description>
            </returnedTags>
        </ns:listDeviceProfile>
    </soapenv:Body>
</soapenv:Envelope>
"@
                break
            }
            'DescriptionSearch' {
                $Description = "%$Description%"

                $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/14.0">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:listDeviceProfile sequence="1">
            <searchCriteria>
                <description>$Description</description>
            </searchCriteria>
            <returnedTags>
                <name>true</name>
                <description>true</description>
            </returnedTags>
        </ns:listDeviceProfile>
    </soapenv:Body>
</soapenv:Envelope>
"@
                break
            }
        }

        try {
            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -Credential $script:Connections[$ConnectionId].Creds -Uri $script:Connections[$ConnectionId].Server `
                                        -ErrorAction Stop
        }
        catch 
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }
        
        $Result.Envelope.Body.listDeviceProfileResponse.return.deviceProfile
    }

}