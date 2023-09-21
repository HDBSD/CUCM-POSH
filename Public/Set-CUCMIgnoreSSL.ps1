<#
.SYNOPSIS
Disables SSL certificate validation for Cisco Unified Call Manager (CUCM) connections in the current session.

.DESCRIPTION
This function disables SSL certificate validation for CUCM connections within the current PowerShell session. It can be useful for testing and development environments but should be used with caution in production environments.

Note: Disabling SSL certificate validation is not recommended for production use, as it may expose your communication to security risks.

.INPUTS
None.

.OUTPUTS
None.

.EXAMPLE
PS> Set-CUCMIgnoreSSL

Description:
Disables SSL certificate validation for CUCM connections in the current session.

.NOTES
Author: Brad S
Version: 1.0.0
#>

function Set-CUCMIgnoreSSL {

    $certCallBack = @'
using System;
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint sPoint,
        X509Certificate cert,
        WebRequest wRequest,
        int certProb) { 
            Console.WriteLine("WARNING: A request was made to '" + wRequest.RequestUri + "'. Certificate validation has been disabled in this session due to 'Set-CUCMIgnoreSSL' - Look to implement PKI correctly.");
            return true;
        }
}
'@
    # Add a custom certificate policy to disable certificate validation
    Add-Type $certCallBack
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllPolicy
}