function Find-CUCMEndUsers 
{

    [CmdletBinding(DefaultParameterSetName = 'UserId')]
    param(
        
        [Parameter(ParameterSetName = 'FirstName',  Mandatory = $true,  Position = 0)]
        [Parameter(ParameterSetName = 'LastName',   Mandatory = $false, Position = 1)]
        [Parameter(ParameterSetName = 'UserId',     Mandatory = $false, Position = 1)]
        [Parameter(ParameterSetName = 'department', Mandatory = $false, Position = 1)]
        [string]$firstName = "%",

        [Parameter(ParameterSetName = 'FirstName',  Mandatory = $true,  Position = 1)]
        [Parameter(ParameterSetName = 'LastName',   Mandatory = $false, Position = 0)]
        [Parameter(ParameterSetName = 'UserId',     Mandatory = $false, Position = 1)]
        [Parameter(ParameterSetName = 'department', Mandatory = $false, Position = 1)]
        [string]$lastName = "%",

        [Parameter(ParameterSetName = 'FirstName',  Mandatory = $true,  Position = 2)]
        [Parameter(ParameterSetName = 'LastName',   Mandatory = $false, Position = 2)]
        [Parameter(ParameterSetName = 'UserId',     Mandatory = $false, Position = 0)]
        [Parameter(ParameterSetName = 'department', Mandatory = $false, Position = 2)]
        [string]$userid = "%",

        [Parameter(ParameterSetName = 'FirstName',  Mandatory = $true,  Position = 3)]
        [Parameter(ParameterSetName = 'LastName',   Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'UserId',     Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'department', Mandatory = $false, Position = 0)]
        [string]$department = "%",


        [Parameter(ParameterSetName = 'FirstName',  Mandatory = $true,  Position = 4)]
        [Parameter(ParameterSetName = 'LastName',   Mandatory = $false, Position = 4)]
        [Parameter(ParameterSetName = 'UserId',     Mandatory = $false, Position = 4)]
        [Parameter(ParameterSetName = 'department', Mandatory = $false, Position = 4)]
        [int]$ConnectionId = 0
    )

    begin {

        $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/14.0">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:listUser sequence="1">
            <searchCriteria>
                <firstName>$firstName</firstName>
                <lastName>$lastName</lastName>
                <userid>$userid</userid>
                <department>$department</department>
            </searchCriteria>
            <returnedTags>
                <userid>true</userid>
                <firstName>true</firstName>
                <lastName>true</lastName>
                <department>true</department>
                <primaryExtension>true</primaryExtension>
                <status>true</status>
            </returnedTags>
        </ns:listUser>
    </soapenv:Body>
</soapenv:Envelope>
"@

    }

    process {
        try {
            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -Credential $script:Connections[$ConnectionId].Creds -Uri $script:Connections[$ConnectionId].Server `
                                        -ErrorAction Stop
        }
        catch 
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $Result.Envelope.Body.listUserResponse.return.user
    }
}