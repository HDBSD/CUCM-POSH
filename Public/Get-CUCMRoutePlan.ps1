<#
.SYNOPSIS
Get Cisco Unified Call Manager (CUCM) Route Plans.

.DESCRIPTION
This function retrieves CUCM Route Plans based on the specified filter.

.PARAMETER filter
Specifies the filter for the Route Plans to retrieve. Supports wildcard '%'.

.PARAMETER SessionIndex
Specifies the index of the CUCM session to use for the operation.

.INPUTS
None.

.OUTPUTS
Returns a list of Route Plans including their DN/Pattern, type, partition, and routeDetail.

.EXAMPLE
PS> Get-CUCMRoutePlan

Description:
Retrieves all CUCM Route Plans.

.EXAMPLE
PS> Get-CUCMRoutePlan -filter "1XXX"

Description:
Retrieves CUCM Route Plans with patterns that match "1XXX".

.EXAMPLE
PS> Get-CUCMRoutePlan -filter "2%" -SessionIndex 1

Description:
Retrieves CUCM Route Plans with patterns starting with "2" using the specified session index.
#>

function Get-CUCMRoutePlan {
    param(
        [Parameter(ParameterSetName = 'filter', Mandatory = $false, Position = 0)][string]$filter = "%",
        [Parameter(ParameterSetName = 'filter', Mandatory = $false, Position = 1)][int]$SessionIndex = 0
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
        <ns:listRoutePlan sequence="1">
            <searchCriteria>    
                <dnOrPattern>$filter</dnOrPattern>
            </searchCriteria>
            <returnedTags>
                <dnOrPattern>true</dnOrPattern>
                <partition>true</partition>
                <type>true</type>
                <routeDetail>true</routeDetail>
            </returnedTags>
        </ns:listRoutePlan>
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

        $Result.Envelope.Body.listRoutePlanResponse.return.routePlan | select dnOrPattern,type,partition,@{N="routeDetail";E={$_.routeDetail.'#text'}}
    }
}