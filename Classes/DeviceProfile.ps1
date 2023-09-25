<#
.SYNOPSIS
Class for representing a line directory number in a Cisco device profile.

.DESCRIPTION
The `deviceProfileLinedDirn` class represents a line directory number within a Cisco device profile. It includes properties for the pattern of the number and the associated route partition name.

.PROPERTIES
- `$pattern` (string): The pattern of the line directory number.
- `$routeParitionName` (string): The route partition name for the line directory number.

.CONSTRUCTORS
- `deviceProfileLinedDirn($pattern, $partition)`: Initializes a `deviceProfileLinedDirn` object with the provided pattern and partition values.

.NOTES
Author: Brad S
Version: 1.0.0
#>

class deviceProfileLinedDirn {
    [string]$pattern
    [string]$routeParitionName

    deviceProfileLinedDirn($pattern, $partition) {
        $this.pattern = $pattern
        $this.routeParitionName = $partition 
    }
}

<#
.SYNOPSIS
Class for configuring call information display settings in a Cisco device profile.

.DESCRIPTION
The `deviceProfileCallInfoDisplay` class allows you to configure call information display settings within a Cisco device profile. It includes properties to control the display of caller names, caller numbers, redirected numbers, and dialed numbers.

.PROPERTIES
- `$callerName` (bool): Indicates whether to display caller names.
- `$callerNumber` (bool): Indicates whether to display caller numbers.
- `$redirectedNumber` (bool): Indicates whether to display redirected numbers.
- `$dialedNumber` (bool): Indicates whether to display dialed numbers.

.NOTES
Author: Brad S
Version: 1.0.0
#>

class deviceProfileCallInfoDisplay {
    [bool]$callerName = $true
    [bool]$callerNumber = $false
    [bool]$redirectedNumber = $false
    [bool]$dialedNumber = $true
}

<#
.SYNOPSIS
Class for managing end users associated with a Cisco device profile.

.DESCRIPTION
The `deviceProfileEndusers` class is used to manage a collection of end users associated with a Cisco device profile. It includes an array property for storing `deviceProfileEnduser` objects representing individual end users.

.PROPERTIES
- `$enduser` (array of deviceProfileEnduser): An array of `deviceProfileEnduser` objects representing end users associated with the device profile.

.CONSTRUCTORS
- `deviceProfileEndusers($usr)`: Initializes a `deviceProfileEndusers` object with an array of `deviceProfileEnduser` objects based on the provided user IDs.

.NOTES
Author: Brad S
Version: 1.0.0
#>

class deviceProfileEndusers
{
    [deviceProfileEnduser[]]$enduser

    deviceProfileEndusers($usr) {
        $this.enduser = [deviceProfileEnduser[]]::new(0)
        $this.enduser += [deviceProfileEnduser]::new($usr)
    }
}

<#
.SYNOPSIS
Class for representing an end user in a Cisco device profile.

.DESCRIPTION
The `deviceProfileEnduser` class represents an individual end user associated with a Cisco device profile. It includes a property for the user ID.

.PROPERTIES
- `$userId` (string): The user ID associated with the end user.

.CONSTRUCTORS
- `deviceProfileEnduser($usr)`: Initializes a `deviceProfileEnduser` object with the provided user ID.

.NOTES
Author: Brad S
Version: 1.0.0
#>

class deviceProfileEnduser
{
    [string]$userId

    deviceProfileEnduser($usr) {
        $this.userId = $usr
    }

}

<#
.SYNOPSIS
Class for configuring a line within a Cisco device profile.

.DESCRIPTION
The `deviceProfileLine` class is used to configure a line within a Cisco device profile. It includes properties for various line settings such as index, label, display, directory number (`dirn`), ring settings, call information display, and more. It also provides a method to convert the line configuration to XML format.

.PROPERTIES
- Various properties for configuring line settings.

.METHODS
- `ToXml()`: Generates an XML representation of the line configuration.

.NOTES
Author: Brad S
Version: 1.0.0
#>

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

<#
.SYNOPSIS
Class for configuring a Cisco device profile.

.DESCRIPTION
The `deviceProfile` class is used to configure a Cisco device profile. It includes properties for various device profile settings such as name, description, product, model, lines, and other device-specific settings. It also provides a method to convert the device profile configuration to XML format for use in Cisco Unified Call Manager (CUCM) configurations.

.PROPERTIES
- Various properties for configuring device profile settings.

.METHODS
- `ToXml()`: Generates an XML representation of the device profile configuration.

.NOTES
Author: Brad S
Version: 1.0.0
#>

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