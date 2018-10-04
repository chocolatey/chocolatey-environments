[CmdletBinding()]
Param (
    # use this to download and internalize the packages again regardless of whether the version exists or not
    [switch]
    $Force
)

$packagesPath = "..\packages"

@( 'jenkins' ) | ForEach-Object {
    .\scripts\InternalizePackage.ps1 -Name $_ -OutputDirectory $packagesPath -Force:$Force.IsPresent
}