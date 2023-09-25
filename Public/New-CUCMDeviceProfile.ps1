function New-CUCMDeviceProfile {
    [CmdletBinding()]
    param ( 
        
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]
        $Pattern,

        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $ExternalMask,

        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]
        $UserId,

        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]
        $DisplayName,

        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]
        $Partition,

        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]
        $ProductModel,

        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $PhoneTemplate,

        # Parameter help description
        [Parameter(Mandatory = $false)]
        [string]
        $Protocol = "SCCP",

        # Parameter help description
        [Parameter(Mandatory = $false)]
        [string]
        $SoftkeyTemplate = "Standard User",

        [Parameter(Mandatory = $false)]
        [string]
        $UserLocale = "United Kingdom",

        [Parameter(Mandatory = $false)]
        [int]
        $SessionIndex = 0
    )

    begin {
        $lines = [deviceProfileLine[]]::new(0)
        $ldir = [deviceProfileLine]::new()
        
        $ldir.display = $ldir.label = $ldir.displayAscii = $DisplayName
        $ldir.e164Mask = $ExternalMask
        
        $ldir.dirn = [deviceProfileLinedDirn]::new($Pattern, $Partition)
        $ldir.associatedEndusers = [deviceProfileEndusers]::new($UserId)
        $ldir.callInfoDisplay = [deviceProfileCallInfoDisplay]::new()

        $lines += $ldir

        $dp = [deviceProfile]::new()

        $dp.name = "$($DisplayName) - $($Pattern)"
        $dp.description = "$($DisplayName) UDP"
        $dp.product = $dp.model = $ProductModel
        $dp.protocol = $Protocol
        $dp.Lines += $ldir

        $dp.phoneTemplateName = $phoneTemplate
        $dp.userLocale = $UserLocale

        $dp.loginUserId = $UserId

        $dp.softkeyTemplateName = $SoftkeyTemplate

        $soapReq = $dp.ToXML()

    }

    process {
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