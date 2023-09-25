<#
.SYNOPSIS
Creates a new Device Profile configuration for Cisco Unified Call Manager (CUCM).

.DESCRIPTION
The `New-CUCMDeviceProfile` function generates a Device Profile configuration for CUCM with specified parameters such as pattern, external mask, user ID, display name, partition, product model, phone template, protocol, softkey template, user locale, and session index.

.PARAMETER Pattern
Specifies the pattern for the Device Profile.

.PARAMETER ExternalMask
Specifies the external mask for the Device Profile.

.PARAMETER UserId
Specifies the user ID associated with the Device Profile.

.PARAMETER DisplayName
Specifies the display name for the Device Profile.

.PARAMETER Partition
Specifies the partition for the Device Profile.

.PARAMETER ProductModel
Specifies the product model for the Device Profile.

.PARAMETER PhoneTemplate
Specifies the phone template for the Device Profile.

.PARAMETER Protocol
Specifies the protocol for the Device Profile. Default is "SCCP".

.PARAMETER SoftkeyTemplate
Specifies the softkey template for the Device Profile. Default is "Standard User".

.PARAMETER UserLocale
Specifies the user locale for the Device Profile. Default is "United Kingdom".

.PARAMETER SessionIndex
Specifies the index of the CUCM server connection to use. Default is 0.

.EXAMPLE
PS> $deviceProfile = New-CUCMDeviceProfile -Pattern "12345" -ExternalMask "ExternalMask1" -UserId "user1" -DisplayName "MyDeviceProfile" -Partition "MyPartition" -ProductModel "Model1" -PhoneTemplate "Template1" -Protocol "SIP" -SoftkeyTemplate "Custom Softkey" -UserLocale "US"

Description:
Creates a new Device Profile configuration with the specified parameters.

.NOTES
Author: Brad S
Version: 1.0.0
#>

function New-CUCMDeviceProfile {
    [CmdletBinding()]
    param ( 
        [Parameter(Mandatory=$true)]
        [string]
        $Pattern,
        [Parameter(Mandatory = $true)]
        [string]
        $ExternalMask,
        [Parameter(Mandatory=$true)]
        [string]
        $UserId,
        [Parameter(Mandatory=$true)]
        [string]
        $DisplayName,
        [Parameter(Mandatory=$true)]
        [string]
        $Partition,
        [Parameter(Mandatory=$true)]
        [string]
        $ProductModel,
        [Parameter(Mandatory = $true)]
        [string]
        $PhoneTemplate,
        [Parameter(Mandatory = $false)]
        [string]
        $Protocol = "SCCP",
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

        # Create an empty DeviceProfileLine array with a size of 0
        # and also create a single line object 

        # Set line objects attributes based on passed in parameters

        $lines = [deviceProfileLine[]]::new(0)
        $ldir = [deviceProfileLine]::new()
        
        $ldir.display = $ldir.label = $ldir.displayAscii = $DisplayName
        $ldir.e164Mask = $ExternalMask
        
        $ldir.dirn = [deviceProfileLinedDirn]::new($Pattern, $Partition)
        $ldir.associatedEndusers = [deviceProfileEndusers]::new($UserId)
        $ldir.callInfoDisplay = [deviceProfileCallInfoDisplay]::new()

        # add our single line object to our line array object

        $lines += $ldir

        # Create a new deviceProfile object and set its attributes

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

        # convert deviceProfile to XML (Create our Soap Request) 

        $soapReq = $dp.ToXML()

    }

    process {

        # Try to post our soap request to call manager 

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