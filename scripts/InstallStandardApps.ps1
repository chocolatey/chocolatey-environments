if ($null -eq (Get-Command -Name 'choco.exe' -ErrorAction SilentlyContinue)) {
    Write-Warning "Chocolatey not installed. Cannot install standard packages."
}
else {
    @( 'baretail', 'dotnetversiondetector', 'notepadplusplus.install', '7zip' ) | ForEach-Object {
        choco upgrade $_ -y --no-progress
    }
}