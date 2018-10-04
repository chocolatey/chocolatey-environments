choco upgrade jenkins -y

Write-Host "Stopping Jenkins service."
Stop-Service -Name jenkins
Write-Host "Extracting Jenkins configuration files."
7z x c:\vagrant\scripts\jenkins-config.zip -y -r -bd -o"c:\program files (x86)\jenkins"
#Copy-Item c:\vagrant\scripts\jenkins-config\* "c:\program files (x86)\jenkins" -Recurse -Force
Write-Host "Starting Jenkins service."
Start-Service -Name Jenkins

Write-Host "Waiting up to 60 seconds for Jenkins to respond."
# loop either 60 times or until we get a 403 status code response (403 means we
# are unauthorised and the service is therefore up)
$status = 0
for ($i = 0; $i -lt 60 -and $status -ne 403; $i++) {
    Start-Sleep -Seconds 1
    try {
        $request = $null
        $request = Invoke-WebRequest -Uri 'http://localhost:8080' -UseBasicParsing
    }
    catch {
        $request = $_.exception.response
    }

    $status = [int]$request.StatusCode
}

# Just wait an extra 5 seconds to be sure
Start-Sleep -Seconds 5

$pw = Get-Content "c:\program files (x86)\jenkins\secrets\initialAdminPassword"
Set-Location "c:\program files (x86)\jenkins\jre\bin"

Write-Host "Installing Jenkins plugins."
"build-timeout", "workflow-aggregator", "pipeline-stage-view", "powershell" | ForEach-Object {
    .\java.exe -jar ..\..\war\web-inf\jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:$pw install-plugin $_
}

Write-Host "Restarting Jenkins service."
Restart-Service -Name jenkins