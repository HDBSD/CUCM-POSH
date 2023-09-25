<#
.SYNOPSIS
Creates a Call Forward block object for use with New-CUCMLine.

.DESCRIPTION
The `New-CUCMCallForwardBlock` function generates a Call Forward block object for use with the New-CUCMLine function. This block includes settings for call forwarding types, calling search space, voicemail settings, destination, and secondary calling search space.

.PARAMETER ForwardType
Specifies the type of call forwarding. Use the `[CallForwardTypes]` enumeration to select the desired type. Default is `[CallForwardTypes]::CoverAllTypes`.

.PARAMETER CallingSearchSpace
Specifies the name of the calling search space to be associated with the call forward block.

.PARAMETER VoiceMail
Indicates whether voicemail is enabled. Default is `$false`.

.PARAMETER Destination
Specifies the destination for call forwarding. Provide a valid destination string. Default is `$null`.

.PARAMETER SecondaryCallingSearchSpace
Specifies the name of the secondary calling search space. Default is `$null`.

.EXAMPLE
PS> $callForwardBlock = New-CUCMCallForwardBlock -ForwardType [CallForwardTypes]::Unconditional -CallingSearchSpace "CSS1" -VoiceMail $true -Destination "VoicemailBox1" -SecondaryCallingSearchSpace "CSS2"

Description:
Creates a Call Forward block configuration for unconditional call forwarding with voicemail enabled.

.NOTES
Author: Brad S
Version: 1.0.0
#>

function New-CUCMCallForwardBlock {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [CallForwardTypes]
        $ForwardType = [CallForwardTypes]::CoverAllTypes,
        
        [Parameter(Position = 1, Mandatory = $true)]
        [string]
        $CallingSearchSpace,

        [Parameter(Position = 2, Mandatory = $false)]
        [bool]
        $VoiceMail = $false,

        [Parameter(Position = 3, Mandatory = $false)]
        [string]
        $Destination = $null,

        [Parameter(Position = 4, Mandatory = $false)]
        [string]
        $SecondaryCallingSearchSpace = $null
    )
    
    begin {
        $CallForwardObj = [CallForward]::new()
        
        $CallForwardObj.ForwardType = $ForwardType
        $CallForwardObj.VoiceMail = $VoiceMail
        $CallForwardObj.CallingSearchSpaceName = $CallingSearchSpace
        $CallForwardObj.SecondaryCallingSearchSpaceName = $SecondaryCallingSearchSpace
        $CallForwardObj.Destination = $Destination
        $CallForwardObj.indentLength = 4
        $CallForwardObj.indentDepth = 4
    }
    
    process {
        $CallForwardObj
    }
}