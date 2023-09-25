class deviceProfileLinedDirn {
    [string]$pattern
    [string]$routeParitionName

    deviceProfileLinedDirn($pattern, $partition) {
        $this.pattern = $pattern
        $this.routeParitionName = $partition 
    }
}

class deviceProfileCallInfoDisplay {
    [bool]$callerName = $true
    [bool]$callerNumber = $false
    [bool]$redirectedNumber = $false
    [bool]$dialedNumber = $true
}

class deviceProfileEndusers
{
    [deviceProfileEnduser[]]$enduser

    deviceProfileEndusers($usr) {
        $this.enduser = [deviceProfileEnduser[]]::new(0)
        $this.enduser += [deviceProfileEnduser]::new($usr)
    }
}

class deviceProfileEnduser
{
    [string]$userId

    deviceProfileEnduser($usr) {
        $this.userId = $usr
    }

}

class deviceProfileLine {
    [int]$index = 1
    [string]$label
    [string]$display
    [deviceProfileLinedDirn]$dirn
    [string]$ringSetting = "Use System Default"
    [string]$consecutiveRingSetting = "Use System Default"
    [string]$ringSettingIdlePickupAlert = "Use System Default"
    [string]$ringSettingActivePickupAlert = "Use System Default"
    [string]$displayAscii
    [string]$e164Mask
    [string]$mwlPolicy = "Use System Policy"
    [int]$maxNumCalls = 4
    [int]$busyTrigger = 1
    [deviceProfileCallInfoDisplay]$callInfoDisplay
    [string]$recordingFlag = "Call Recording Disabled"
    [string]$audibleMwi = "Default"
    [string]$partitionUsage = "General"
    [deviceProfileEndusers]$associatedEndusers
    [bool]$missedCallLogging = $true
    [string]$recordingMediaSource = "Gateway Preferred"

    [string] ToXml() {
        $linesString = ""

        $linesString = @"
                    <line>
                        <index>$($this.index)</index>
                        <label>$($this.label)</label>
                        <display>$($this.display)</display>
                        <dirn>
                            <pattern>$($this.dirn.pattern)</pattern>
                            <routePartitionName>$($this.dirn.routeParitionName)</routePartitionName>
                        </dirn>
                        <ringSetting>$($this.ringSetting)</ringSetting>
                        <consecutiveRingSetting>$($this.consecutiveRingSetting)</consecutiveRingSetting>
                        <ringSettingIdlePickupAlert>$($this.ringSettingIdlePickupAlert)</ringSettingIdlePickupAlert>
                        <ringSettingActivePickupAlert>$($this.ringSettingActivePickupAlert)</ringSettingActivePickupAlert>
                        <displayAscii>$($this.displayAscii)</displayAscii>
                        <!--External Number-->
                        <e164Mask>$($this.e164Mask)</e164Mask>
                        <mwlPolicy>$($this.mwlPolicy)</mwlPolicy>
                        <maxNumCalls>$($this.maxNumCalls)</maxNumCalls>
                        <busyTrigger>$($this.busyTrigger)</busyTrigger>
                        <callInfoDisplay>
                            <callerName>$($this.callInfoDisplay.callerName)</callerName>
                            <callerNumber>$($this.callInfoDisplay.callerNumber)</callerNumber>
                            <redirectedNumber>$($this.callInfoDisplay.redirectedNumber)</redirectedNumber>
                            <dialedNumber>$($this.callInfoDisplay.dialedNumber)</dialedNumber>
                        </callInfoDisplay>
                        <recordingFlag>$($this.recordingFlag)</recordingFlag>
                        <audibleMwi>$($this.audibleMwi)</audibleMwi>
                        <partitionUsage>$($this.partitionUsage)</partitionUsage>
                        <associatedEndusers>
                            <enduser>
                                $(
                                    $out = ($this.associatedEndusers.enduser | ForEach-Object { "<userId>$($_.userId)</userId>`n" });
                                    $out.Trim()
                                )
                            </enduser>
                        </associatedEndusers>
                        <missedCallLogging>$($this.missedCallLogging)</missedCallLogging>
                        <recordingMediaSource>$($this.recordingMediaSource)</recordingMediaSource>
                    </line>

"@

        return $linesString
    }
}

class deviceProfile {
    [string]$name
    [string]$description
    [string]$product
    [string]$model
    [string]$class = "Device Profile"
    [string]$protocol
    [string]$protocolSide = "User"
    [bool]$traceFlag = $false
    [string]$mlppIndicationStatus = "Default"
    [deviceProfileLine[]]$Lines
    [string]$phoneTemplateName
    [string]$userLocale
    [string]$singleButtonBarge = "Default"
    [string]$joinAcrossLines = "Default"
    [string]$loginUserId
    [bool]$ignorePresentationIndicators = $false
    [string]$dndOption = "Use Common Phone Profile Setting"
    [string]$dndRingSetting = "Disable"
    [bool]$dndStatus = $false
    [string]$alwaysUsePrimeLine = "Default"
    [string]$alwaysUsePrimeLineForVoiceMessage = "Default"
    [string]$softkeyTemplateName
    [string]$callInfoPrivacyStatus = "Default"
    [string]$preemption = "Default"
    [string]ToXML()
    {

        $linesString = ""

        if ($this.Lines.Length -ne 0)
        {
            $linesString = ($this.Lines | ForEach-Object {$_.ToXml()}).Trim()
        }

        $soapReq = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/12.5">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:addDeviceProfile sequence="1">
            <deviceProfile>
                <name>$($this.name)</name>
                <description>$($this.description)</description>
                <product>$($this.product)</product>
                <model>$($this.model)</model>
                <class>$($this.class)</class>
                <protocol>$($this.protocol)</protocol>
                <protocolSide>$($this.protocolSide)</protocolSide>
                <traceFlag>$($this.traceFlag)</traceFlag>
                <mlppIndicationStatus>$($this.mlppIndicationStatus)</mlppIndicationStatus>
                <preemption>$($this.preemption)</preemption>
                <lines>
                    $($linesString)
                </lines>
                <phoneTemplateName>$($this.phoneTemplateName)</phoneTemplateName>
                <!--Needs to be UK in full version-->
                <!--<userLocale>$($this.userLocale)</userLocale>-->
                <singleButtonBarge>$($this.singleButtonBarge)</singleButtonBarge>
                <joinAcrossLines>$($this.joinAcrossLines)</joinAcrossLines>
                <loginUserId>$($this.loginUserId)</loginUserId>
                <ignorePresentationIndicators>$($this.ignorePresentationIndicators)</ignorePresentationIndicators>
                <dndOption>$($this.dndOption)</dndOption>
                <dndRingSetting>$($this.dndRingSetting)</dndRingSetting>
                <dndStatus>$($this.dndStatus)</dndStatus>
                <alwaysUsePrimeLine>$($this.alwaysUsePrimeLine)</alwaysUsePrimeLine>
                <alwaysUsePrimeLineForVoiceMessage>$($this.alwaysUsePrimeLineForVoiceMessage)</alwaysUsePrimeLineForVoiceMessage>
                <softkeyTemplateName>$($this.softkeyTemplateName)</softkeyTemplateName>
                <callInfoPrivacyStatus>$($this.callInfoPrivacyStatus)</callInfoPrivacyStatus>
            </deviceProfile>
        </ns:addDeviceProfile>
   </soapenv:Body>
</soapenv:Envelope>          
"@

        return $soapReq

    }
}