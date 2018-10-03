[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string[]]
    $Name,

    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ })]
    [string]
    $OutputDirectory,

    [switch]
    $Force
)

$Name | ForEach-Object {
    if ($Force.IsPresent -or (-not (Test-Path -Path (Join-Path -Path $OutputDirectory -ChildPath "$_.*.nupkg")))) {
        Write-Host "Internalizing package '$_' from the Chocolatey Community Repository." -ForegroundColor Green
        choco download $_ --internalize --internalize-all-urls --append-use-original-location --output-directory=$OutputDirectory --source="'https://chocolatey.org/api/v2/; https://licensedpackages.chocolatey.org/api/v2/'"
    }
    else {
        Write-Warning "Skipping internalizing package '$_' as it already exists in '$OutputDirectory'."
        Write-Warning "To interanlize this package anyway, use the -Force parameter."
    }
}