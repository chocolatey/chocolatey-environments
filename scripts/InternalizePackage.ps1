[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string[]]
    $Name,

    [ValidateScript( { Test-Path $_ })]
    [string]
    $OutputDirectory = (Join-Path -Path $env:SystemDrive -ChildPath "packages"),

    [Version]
    $Version,

    [switch]
    $Force
)

function Test-PackageExist ($Name, $Version, $PackagePath) {
    if ($Version) {
        $Name += ".$Version"
    }
    else {
        $Name += ".*"
    }

    $Name += ".nupkg"

    Test-Path -Path (Join-Path -Path $PackagePath -ChildPath $Name)
}

$params = "--internalize --internalize-all-urls --append-use-original-location --source=""'https://chocolatey.org/api/v2/; https://licensedpackages.chocolatey.org/api/v2/'"""
$Name | ForEach-Object {
    if ($Force.IsPresent -or (-not (Test-PackageExist -Name $_ -Version $Version -PackagePath $OutputDirectory))) {
        #    if ($Force.IsPresent -or (-not (Test-Path -Path (Join-Path -Path $OutputDirectory -ChildPath "$_.*.nupkg")))) {
        Write-Host "Internalizing package '$_' from the Chocolatey Community Repository." -ForegroundColor Green
        $cmd = "choco download $_ --output-directory=$OutputDirectory $params "
        if ($Force.IsPresent) {
            $cmd += "--force "
        }
        Write-Verbose "Running '$cmd'."
        Invoke-Expression -Command $cmd
    }
    else {
        Write-Warning "Skipping internalizing package '$_' as it already exists in '$OutputDirectory'."
        Write-Warning "To internalize this package anyway, use the -Force parameter."
    }
}