<#
.SYNOPSIS
Searches for Cisco Unified Call Manager (CUCM) Device Profiles based on name or description.

.DESCRIPTION
This function performs a search for Device Profiles in CUCM based on name or description. You can use wildcard '%' for partial matching.

.PARAMETER ProfileName
Specifies the name to search for in Device Profiles. Supports wildcard '%' for partial matching.

.PARAMETER Description
Specifies the description to search for in Device Profiles. Supports wildcard '%' for partial matching.

.PARAMETER SessionIndex
Specifies the index of the CUCM session to use for the search.

.INPUTS
None.

.OUTPUTS
Returns a table with the following columns: [string]'UUID', [string]'Name', and [string]'Description'.

.EXAMPLE
PS> Find-CUCMDeviceProfile

Description:
Searches for all Device Profiles.

.EXAMPLE
PS> Find-CUCMDeviceProfile -SessionIndex 1

Description:
Searches for all Device Profiles using the specified session index.

.EXAMPLE
PS> Find-CUCMDeviceProfile -ProfileName "Brad S"

Description:
Searches for Device Profiles with names containing "Brad S".

.EXAMPLE
PS> Find-CUCMDeviceProfile -ProfileName "B%S"

Description:
Searches for Device Profiles with names containing "B" followed by any characters and "S".

.EXAMPLE
PS> Find-CUCMDeviceProfile -ProfileName "Brad S" -SessionIndex 1

Description:
Searches for Device Profiles with names containing "Brad S" using the specified session index.

.EXAMPLE
PS> Find-CUCMDeviceProfile -Description "Brad S office desk phone"

Description:
Searches for Device Profiles with descriptions containing "Brad S office desk phone".

.EXAMPLE
PS> Find-CUCMDeviceProfile -Description "B% phone" -SessionIndex 1

Description:
Searches for Device Profiles with descriptions containing "B" followed by any characters and "phone" using the specified session index.
#>

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

    begin {
        if ($null -eq $script:Connections[$SessionIndex]) {
            $PSCmdlet.ThrowTerminatingError("No connection found at the specified index. Please ensure the connection exists or create one first.")
        }
    }

    process {
        $soapReq = ""

        # Define a common template for the SOAP request XML
        $soapTemplate = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/$Script:AxlVersion">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:listDeviceProfile sequence="1">
            <searchCriteria>
                {0}
            </searchCriteria>
            <returnedTags>
                <name>true</name>
                <description>true</description>
            </returnedTags>
        </ns:listDeviceProfile>
    </soapenv:Body>
</soapenv:Envelope>
"@

        # Determine the search criteria based on the parameter set
        $searchCriteria = switch ($PSCmdlet.ParameterSetName) {
            'NameSearch' {
                $ProfileName = "%$ProfileName"
                "<name>$ProfileName</name>"
            }
            'DescriptionSearch' {
                $Description = "%$Description"
                "<description>$Description</description>"
            }
        }

        # Generate the SOAP request XML by inserting the search criteria into the template
        $soapReq = $soapTemplate -f $searchCriteria

        try {
            $Result = Invoke-RestMethod -Method Post -ContentType "text/xml" -Body $soapReq `
                                        -WebSession $script:Connections[$SessionIndex].Session -Uri $script:Connections[$SessionIndex].Server `
                                        -ErrorAction Stop
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $Result.Envelope.Body.listDeviceProfileResponse.return.deviceProfile
    }
}
