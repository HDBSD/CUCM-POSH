<#
.SYNOPSIS
Searches for Cisco Unified Call Manager (CUCM) End Users based on various criteria.

.DESCRIPTION
This function allows you to search for CUCM End Users based on first name, last name, user ID, or department. You can use wildcard '%' for partial matching in the search criteria.

.PARAMETER FirstName
Specifies the first name to search for in End Users. Supports wildcard '%' for partial matching.

.PARAMETER LastName
Specifies the last name to search for in End Users. Supports wildcard '%' for partial matching.

.PARAMETER UserId
Specifies the user ID to search for in End Users. Supports wildcard '%' for partial matching.

.PARAMETER Department
Specifies the department to search for in End Users. Supports wildcard '%' for partial matching.

.PARAMETER SessionIndex
Specifies the index of the CUCM session to use for the search.

.INPUTS
None.

.OUTPUTS
Returns a table with the following columns: [string]'UserId', [string]'FirstName', [string]'LastName', [string]'Department', [string]'PrimaryExtension', and [string]'Status'.

.EXAMPLE
PS> Find-CUCMEndUsers

Description:
Searches for all CUCM End Users.

.EXAMPLE
PS> Find-CUCMEndUsers -SessionIndex 1

Description:
Searches for all CUCM End Users using the specified session index.

.EXAMPLE
PS> Find-CUCMEndUsers -FirstName "John"

Description:
Searches for CUCM End Users with the first name containing "John".

.EXAMPLE
PS> Find-CUCMEndUsers -LastName "Doe"

Description:
Searches for CUCM End Users with the last name containing "Doe".

.EXAMPLE
PS> Find-CUCMEndUsers -UserId "johndoe"

Description:
Searches for CUCM End Users with the user ID containing "johndoe".

.EXAMPLE
PS> Find-CUCMEndUsers -Department "Sales"

Description:
Searches for CUCM End Users in the "Sales" department.

.EXAMPLE
PS> Find-CUCMEndUsers -FirstName "John" -SessionIndex 1

Description:
Searches for CUCM End Users with the first name containing "John" using the specified session index.
#>
function Find-CUCMEndUsers 
{

    [CmdletBinding(DefaultParameterSetName = 'UserId')]
    param(
        
        [Parameter(ParameterSetName = 'FirstName',  Mandatory = $true,  Position = 0)]
        [Parameter(ParameterSetName = 'LastName',   Mandatory = $false, Position = 1)]
        [Parameter(ParameterSetName = 'UserId',     Mandatory = $false, Position = 1)]
        [Parameter(ParameterSetName = 'department', Mandatory = $false, Position = 1)]
        [string]$firstName = "%",

        [Parameter(ParameterSetName = 'FirstName',  Mandatory = $false, Position = 1)]
        [Parameter(ParameterSetName = 'LastName',   Mandatory = $true,  Position = 0)]
        [Parameter(ParameterSetName = 'UserId',     Mandatory = $false, Position = 1)]
        [Parameter(ParameterSetName = 'department', Mandatory = $false, Position = 1)]
        [string]$lastName = "%",

        [Parameter(ParameterSetName = 'FirstName',  Mandatory = $false, Position = 2)]
        [Parameter(ParameterSetName = 'LastName',   Mandatory = $false, Position = 2)]
        [Parameter(ParameterSetName = 'UserId',     Mandatory = $true,  Position = 0)]
        [Parameter(ParameterSetName = 'department', Mandatory = $false, Position = 2)]
        [string]$userid = "%",

        [Parameter(ParameterSetName = 'FirstName',  Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'LastName',   Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'UserId',     Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'department', Mandatory = $true,  Position = 0)]
        [string]$department = "%",


        [Parameter(ParameterSetName = 'FirstName',  Mandatory = $false, Position = 4)]
        [Parameter(ParameterSetName = 'LastName',   Mandatory = $false, Position = 4)]
        [Parameter(ParameterSetName = 'UserId',     Mandatory = $false, Position = 4)]
        [Parameter(ParameterSetName = 'department', Mandatory = $false, Position = 4)]
        [int]$SessionIndex = 0
    )

    begin {

        if ($null -eq $script:Connections[$SessionIndex])
        {
            $PSCmdlet.ThrowTerminatingError("No Connection at specified id. double check your connection exists or create a connection first.")
        }
    }

    process {

        $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/$Script:AxlVersion">
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

        try {
            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -WebSession $script:Connections[$SessionIndex].Session -Uri $script:Connections[$SessionIndex].Server `
                                        -ErrorAction Stop
        }
        catch 
        {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $Result.Envelope.Body.listUserResponse.return.user
    }
}