function New-CUCMForwardBlock {
    [CmdletBinding()]
    param (
        [Parameter(Position=1, Mandatory=$true, ParameterSetName = "default")]
        [string]
        $TagName,
        [Parameter(Position=1, Mandatory=$true, ParameterSetName = "default")]
        [bool]
        $VoiceMail,
        [Parameter(Position=1, Mandatory=$true, ParameterSetName = "default")]
        [string]
        $CallingSearchSpaceName,
        [Parameter(Position=1, Mandatory=$false, ParameterSetName = "default")]
        [string]
        $SecondaryCallingSearchSpaceName = $null,
        [Parameter(Position=1, Mandatory=$true, ParameterSetName = "default")]
        [string]
        $Destination,
        [Parameter(Position=1, Mandatory=$false, ParameterSetName = "default")]
        [int]
        $indentLength = 2,
        [Parameter(Position=1, Mandatory=$false, ParameterSetName = "default")]
        [int]
        $indentDepth = 10
    )
    
    process {
        
        $basepad = ("".PadLeft($indentLength*$indentDepth,' '))
        $pad     = ("".PadLeft($indentLength,' '))
        
        $obj  =   "$($basepad)<callForward$($TagName)>"
        $obj += "`n$($basepad + $pad)<forwardToVoiceMail>$($VoiceMail.ToString().ToLower())</forwardToVoiceMail>"
        $obj += "`n$($basepad + $pad)<callingSearchSpaceName>$($CallingSearchSpaceName)</callingSearchSpaceName>"

        if ($SecondaryCallingSearchSpaceName)
        { 
            $obj += "`n$($basepad + $pad)<secondaryCallingSearchSpaceName>$SecondaryCallingSearchSpaceName</secondaryCallingSearchSpaceName>"
        }

        $obj += "`n$($basepad + $pad)<destination>$($Destination)</destination>"
        $obj += "`n$($basepad)</callForward$($TagName)>"

        $obj
    }
    
}