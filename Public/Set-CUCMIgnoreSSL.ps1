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
    Add-Type $certCallBack
    [System.Net.ServicePointManager]::CertificatePolicy = new-object TrustAllPolicy

}