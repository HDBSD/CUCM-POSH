<#
.SYNOPSIS
This class represents a call forward configuration for Cisco Call Manager (CUCM).

.DESCRIPTION
The CallForward class encapsulates call forward settings, including the forward type,
voicemail status, calling search space, secondary calling search space, and destination.

# Properties:
- ForwardType: The type of call forwarding.
- VoiceMail: Indicates whether voicemail is enabled.
- CallingSearchSpaceName: The name of the calling search space.
- SecondaryCallingSearchSpaceName: (Optional) The name of the secondary calling search space.
- Destination: The forwarding destination.
- indentLength: The length of indentation for XML formatting.
- indentDepth: The depth of indentation for XML formatting.

# Methods:
- ToXML: Converts the CallForward object to XML format.

.NOTES
Author: Brad S
Version: 1.0.0
#>
class CallForward
{
    [CallForwardTypes]$ForwardType
    [bool]$VoiceMail = $false
    [string]$CallingSearchSpaceName
    [string]$SecondaryCallingSearchSpaceName = $null
    [string]$Destination
    [int]$indentLength = 2
    [int]$indentDepth = 10

    [string] ToXML()
    {
        if ($this.ForwardType -ne [CallForwardTypes]::All -and $null -ne $this.SecondaryCallingSearchSpaceName)
        {
            throw "Cannot create an XML from CallForward object - SecondaryCallingSearchSpaceName must be null if ForwardType is not All"
        }

        $basepad = ("".PadLeft($this.indentLength * $this.indentDepth,' '))
        $pad     = ("".PadLeft($this.indentLength,' '))

        
        $obj  =   "$($basepad)<callForward$($this.TagName)>"
        $obj += "`n$($basepad + $pad)<forwardToVoiceMail>$($this.VoiceMail.ToString().ToLower())</forwardToVoiceMail>"
        $obj += "`n$($basepad + $pad)<callingSearchSpaceName>$($this.CallingSearchSpaceName)</callingSearchSpaceName>"

        if ($this.SecondaryCallingSearchSpaceName)
        { 
            $obj += "`n$($basepad + $pad)<secondaryCallingSearchSpaceName>$this.SecondaryCallingSearchSpaceName</secondaryCallingSearchSpaceName>"
        }

        $obj += "`n$($basepad + $pad)<destination>$($this.Destination)</destination>"
        $obj += "`n$($basepad)</callForward$($this.TagName)>"

        return $obj
        
    }
}