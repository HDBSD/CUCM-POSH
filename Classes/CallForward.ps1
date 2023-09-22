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
    [int]$indentLength = 4
    [int]$indentDepth = 4

    [string] ToXML()
    {
        if ($this.ForwardType -ne [CallForwardTypes]::All -and -not [string]::IsNullOrEmpty($this.SecondaryCallingSearchSpaceName))
        {
            throw "Cannot create an XML from CallForward object - SecondaryCallingSearchSpaceName must be null if ForwardType is not All"
        }

        $basepad = ("".PadLeft($this.indentLength * $this.indentDepth,' '))
        $pad     = ("".PadLeft($this.indentLength,' '))

        $loop = @()

        if ($this.ForwardType -eq [CallForwardTypes]::CoverAllTypes)
        {
            $loop = ([CallForwardTypes]::GetValues([CallForwardTypes]) | Select-Object -SkipLast 1)
        }
        else {
            $loop = @($this.ForwardType)
        }
        
        $obj = $null

        foreach ($itm in $loop)
        {

            if ($null -ne $obj)
            {
                $obj += "`n$($basepad)"    
            }

            $obj +=   "<callForward$($itm)>"
            $obj += "`n$($basepad + $pad)<forwardToVoiceMail>$($this.VoiceMail.ToString().ToLower())</forwardToVoiceMail>"
            $obj += "`n$($basepad + $pad)<callingSearchSpaceName>$($this.CallingSearchSpaceName)</callingSearchSpaceName>"

            if ($this.SecondaryCallingSearchSpaceName)
            { 
                $obj += "`n$($basepad + $pad)<secondaryCallingSearchSpaceName>$($this.SecondaryCallingSearchSpaceName)</secondaryCallingSearchSpaceName>"
            }

            if ($this.Destination)
            {
                $obj += "`n$($basepad + $pad)<destination>$($this.Destination)</destination>"
            }

            $obj += "`n$($basepad)</callForward$($itm)>"
        }

        return $obj
    }
}