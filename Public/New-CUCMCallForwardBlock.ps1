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