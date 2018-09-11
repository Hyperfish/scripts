function testAPP
{
$appep = @("a2.hyperfish.com")
$appport = "443"

    foreach ($endpoint in $appep)
    {
        try {
            write-host "testing" $endpoint "over" $appport 
            (New-Object System.Net.Sockets.TcpClient).Connect($endpoint,$appport)
            write-host $endpoint -NoNewline -ForegroundColor Yellow 
            write-host " is " -NoNewline
            write-host "GOOD" -ForegroundColor Green
            }

        catch
            {
            write-host "Unable to connect to" $endpoint -ForegroundColor Red
            }
    }
}  

function testAMQP
{
$mqep = @("q01.hyperfish.com","q02.hyperfish.com")
$mqport = "5671"

    foreach ($endpoint in $mqep)
    {
        try {
            write-host "testing" $endpoint "over" $mqport 
            (New-Object System.Net.Sockets.TcpClient).Connect($endpoint,$mqport)
            write-host $endpoint -NoNewline -ForegroundColor Yellow 
            write-host " is " -NoNewline
            write-host "GOOD" -ForegroundColor Green
            }

        catch
            {
            write-host "Unable to resolve" $endpoint -ForegroundColor Red
            }
    }
}

Write-host "Testing APP Connectivity"
testAPP
Write-host "Testing AMQPS Connectivity"
testAMQP
