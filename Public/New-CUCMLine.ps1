<#
.SYNOPSIS
Creates a new Line configuration for Cisco Unified Call Manager (CUCM).

.DESCRIPTION
The `New-CUCMLine` function generates a Line configuration for CUCM with specified parameters such as pattern, description, route partition name, call forwarding block, alerting name, usage, share line appearance CSS name, and session index.

.PARAMETER Pattern
Specifies the pattern for the Line.

.PARAMETER Description
Specifies the description for the Line.

.PARAMETER RouteParitionName
Specifies the route partition name for the Line.

.PARAMETER CallForwardingBlock
Specifies an array of call forwarding blocks to configure call forwarding settings.

.PARAMETER AlertingName
Specifies the alerting name for the Line.

.PARAMETER Usage
Specifies the usage for the Line. Default is "Device".

.PARAMETER ShareLineAppearanceCssName
Specifies the name of the shared line appearance CSS.

.PARAMETER SessionIndex
Specifies the index of the CUCM server connection to use. Default is 0.

.EXAMPLE
PS> $callForwardingBlock1 = New-CUCMCallForwardBlock -Pattern "12345" -CallingSearchSpace "CSS1"
PS> $callForwardingBlock2 = New-CUCMCallForwardBlock -Pattern "67890" -CallingSearchSpace "CSS2"
PS> $line = New-CUCMLine -Pattern "54321" -Description "My Line" -RouteParitionName "Partition1" -CallForwardingBlock $callForwardingBlock1, $callForwardingBlock2 -AlertingName "AlertName" -Usage "User" -ShareLineAppearanceCssName "SharedCSS"

Description:
Creates a new Line configuration with the specified parameters, including multiple call forwarding blocks.

.NOTES
Author: Brad S
Version: 1.0.0
#>

function New-CUCMLine {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Pattern,

        [Parameter(Mandatory = $true)]
        [string]
        $Description,

        [Parameter(Mandatory = $true)]
        [string]
        $RouteParitionName,

        [Parameter(Mandatory = $true)]
        [System.Array]
        $CallForwardingBlock,

        [Parameter(Mandatory = $true)]
        [string]
        $AlertingName,

        [Parameter(Mandatory = $false)]
        [string]
        $Usage = "Device",

        [Parameter(Mandatory = $true)]
        [String]
        $ShareLineAppearanceCssName,

        [Parameter(Mandatory = $false)]
        [int]
        $SessionIndex = 0
    )
    
    begin {
        $fwrdBlock = $null

        if ($CallForwardingBlock.Length -eq 0) {
            throw "Empty CallForwardingBlock provided"
        }
        elseif ($CallForwardingBlock.Length -eq 1 -and $CallForwardingBlock[0].ForwardType -eq [CallForwardTypes]::CoverAllTypes) {
            $fwrdBlock = $CallForwardingBlock[0].ToXML()
        }
        else {
            foreach ($block in $CallForwardingBlock) {
                if ($null -ne $fwrdBlock) {
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
                <usage>$Usage</usage>
                <routePartitionName>$RouteParitionName</routePartitionName>
                <aarKeepCallHistory>true</aarKeepCallHistory>
                <aarVoiceMailEnabled>false</aarVoiceMailEnabled>
                $fwrdBlock
                <alertingName>$AlertingName</alertingName>
                <asciiAlertingName>$AlertingName</asciiAlertingName>
                <shareLineAppearanceCssName>$ShareLineAppearanceCssName</shareLineAppearanceCssName>
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
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $Result.Envelope.Body.addLineResponse.return
    }
}