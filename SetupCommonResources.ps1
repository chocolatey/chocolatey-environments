[CmdletBinding()]
Param (
    # use this to download and internalize the packages again regardless of whether the version exists or not
    [switch]
    $Force,

    # use this switch to download the .NET 4 installer
    [switch]
    $DownloadDotNet4
)

$packagesPath = "packages"

@( 'chocolatey', 'chocolateygui', 'dotnet4.5.2', 'chocolatey.server', 'dotnet4.6.1', 'KB2919355', 'KB2919442',
    'baretail', 'dotnetversiondetector', 'notepadplusplus', 'vscode', 'git', 'launchy', 'bginfo' ) | ForEach-Object {
    .\scripts\InternalizePackage.ps1 -Name $_ -OutputDirectory $packagesPath -Force:$Force.IsPresent
}

if ($DownloadDotNet4.IsPresent) {
    # Download .NET 4 Installer
    $NetFx4Url = 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe'
    $NetFx4Path = 'resources\installers\dotNetFx40_Full_x86_x64.exe'
    Invoke-WebRequest -Uri $NetFx4Url -OutFile $NetFx4Path -UseBasicParsing
}

Write-Warning "Need to place the chocolatey.extension package in '$packagesPath'."