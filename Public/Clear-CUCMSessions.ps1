function Clear-CUCMSessions
{
    process
    {
        $script:Connections = @()
        write-host "Connections cleared!"
    }
}