function Set-CUCMAxlVersion {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName="Version", Position=0, Mandatory=$true)]
        [string]
        $AxlVersion
    )
    
    process {
        $script:AxlVersion = $AxlVersion    
    }
    
}