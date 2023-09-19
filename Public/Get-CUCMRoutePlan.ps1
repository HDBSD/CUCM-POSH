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
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/14.0">
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