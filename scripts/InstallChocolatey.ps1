[CmdletBinding()]
Param (
    [switch]
    $UseLocalSource
)

# From https://chocolatey.org/install
$installScript = Join-Path -Path $env:TEMP -ChildPath "$(([GUID]::NewGuid()).Guid.ToString()).ps1"
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing -OutFile $installScript
& $installScript

#Update-SessionEnvironment
choco feature enable --name="'autouninstaller'"
# - not recommended for production systems:
choco feature enable --name="'allowGlobalConfirmation'"
# - not recommended for production systems:
choco feature enable --name="'logEnvironmentValues'"

# Set Configuration
choco config set cacheLocation $env:ALLUSERSPROFILE\choco-cache
choco config set commandExecutionTimeoutSeconds 14400

if ($UseLocalSource.IsPresent) {
    Write-Output "Using local \packages folder as priority 1 install location."
    # Sources - Add internal repositories
    choco source add --name="'local'" --source="'$env:SystemDrive\packages'" --priority="'1'" --bypass-proxy --allow-self-service

    # Sources - change priority of community repository
    Write-Output "Using Chocolatey Community Repository as priority 2 install location."
    choco source remove --name="'chocolatey'"
    choco source add --name='chocolatey' --source='https://chocolatey.org/api/v2/' --priority='2' --bypass-proxy
}