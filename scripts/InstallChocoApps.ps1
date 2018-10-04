[CmdletBinding()]
Param (
    [string[]]
    $Package
)

if ($null -eq (Get-Command -Name 'choco.exe' -ErrorAction SilentlyContinue)) {
    Write-Warning "Chocolatey not installed. Cannot install packages."
}
else {
    $Package | ForEach-Object {
        Write-Output "Installing Chocolatey package '$_'."
        choco upgrade $_ -y --no-progress
    }
}