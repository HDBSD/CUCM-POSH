function Find-CUCMDeviceProfile {
    [CmdletBinding(DefaultParameterSetName = 'NameSearch')]
    param(
        [Parameter(ParameterSetName = 'NameSearch', Mandatory = $false, Position = 0)]
        [string]$ProfileName = "%",
        [Parameter(ParameterSetName = 'DescriptionSearch', Mandatory = $true, Position = 0)]
        [string]$Description,
        [Parameter(ParameterSetName = 'DescriptionSearch', Mandatory = $false, Position = 1)]
        [Parameter(ParameterSetName = 'NameSearch', Mandatory = $false, Position = 1)]
        [int]$SessionIndex = 0
    )
    
    <#
    .SYNOPSIS
    Search/list Device Profiles in call manager 

    .DESCRIPTION
    Search/list Device Profiles in call manager
    Performs a contains search on name or description depending on provided parameters

    .PARAMETER ProfileName
    Find all device profiles where the profile name contain the provided ProfileName. supports wildcard '%'

    .PARAMETER Description 
    Find all device profiles where the description contain the provided Description. supports wildcard '%'

    .PARAMETER SessionIndex
    Specify which session index this request should be completed using.

    .INPUTS
    None.

    .OUTPUTS
    Returns a table contain the below.
    [string]'{uuid}', [string]'name' and [string]'description'

    .EXAMPLE
    PS> Find-CUCMDeviceProfile

    .EXAMPLE
    PS> Find-CUCMDeviceProfile -SessionIndex 1

    .EXAMPLE
    PS> Find-CUCMDeviceProfile -ProfileName "Brad S"

    .EXAMPLE
    PS> Find-CUCMDeviceProfile -ProfileName "B%S"
    
    .EXAMPLE
    PS> Find-CUCMDeviceProfile -ProfileName "Brad S" -SessionIndex 1
    
    .EXAMPLE
    PS> Find-CUCMDeviceProfile -Description "Brad S office desk phone"
    
    .EXAMPLE
    PS> Find-CUCMDeviceProfile -Description "B% phone" -SessionIndex 1
    #>

    begin {

        if ($null -eq $script:Connections[$SessionIndex])
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
                                        -WebSession $script:Connections[$SessionIndex].Session -Uri $script:Connections[$SessionIndex].Server `
                                        -ErrorAction Stop
        }
        catch 
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }
        
        $Result.Envelope.Body.listDeviceProfileResponse.return.deviceProfile
    }

}