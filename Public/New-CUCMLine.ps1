function New-CUCMLine {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $Pattern,


        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $Description,


        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $RouteParitionName,

        
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [System.Array]
        $CallForwardingBlock,


        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $AlertingName,


        # Parameter help description
        [Parameter(Mandatory = $false)]
        [string]
        $usage = "Device",


        # Parameter help description
        [Parameter(Mandatory = $true)]
        [String]
        $ShareLineAppearanceCssName,

        # Parameter help description
        [Parameter(Mandatory = $false)]
        [int]
        $SessionIndex = 0
    )
    
    begin {
        

        $fwrdBlock = $null

        if ($CallForwardingBlock.Length -eq 0)
        {
            throw "Empty CallForwardingBlock provided"
        }
        elseif ($CallForwardingBlock.Length -eq 1 -and $CallForwardingBlock[0].ForwardType -eq [CallForwardTypes]::CoverAllTypes) 
        {
            $fwrdBlock = $CallForwardingBlock[0].ToXML()
        }
        else {

            foreach ($block in $CallForwardingBlock)
            {
                if ($null -ne $fwrdBlock)
                {
                    $fwrdBlock += "`n"
                }

                $fwrdBlock += $block.ToXML()
            }
        }

    }
    
    process {
        $soapReq = @"        
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/$script:AxlVersion">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:addLine sequence="1">
            <line>
                <pattern>$Pattern</pattern>
                <description>$Description</description>
                <usage>$usage</usage>
                <routePartitionName>$RouteParitionName</routePartitionName>
                <aarKeepCallHistory>true</aarKeepCallHistory>
                <aarVoiceMailEnabled>false</aarVoiceMailEnabled>
                $fwrdBlock
                <alertingName>$AlertingName</alertingName>
                <asciiAlertingName>$AlertingName</asciiAlertingName>
                <shareLineAppearanceCssName>$shareLineAppearanceCssName</shareLineAppearanceCssName>
                <enterpriseAltNum>
                    <isUrgent>f</isUrgent>
                    <addLocalRoutePartition>f</addLocalRoutePartition>
                    <advertiseGloballyIls>f</advertiseGloballyIls>
                </enterpriseAltNum>
                <e164AltNum>
                    <isUrgent>f</isUrgent>
                    <addLocalRoutePartition>f</addLocalRoutePartition>
                    <advertiseGloballyIls>f</advertiseGloballyIls>
                </e164AltNum>
                <useEnterpriseAltNum>false</useEnterpriseAltNum>
                <useE164AltNum>false</useE164AltNum>
                <active>true</active>
            </line>
        </ns:addLine>
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

        $Result
        
    }

}