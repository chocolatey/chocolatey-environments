# only install these apps on an operating system that has Explorer (ie. not Server Core)
if ([bool](Get-Command -Name 'explorer.exe' -ErrorAction SilentlyContinue)) {
    & \scripts\InstallChocoPackage.ps1 -Name @( 'baretail', 'dotnetversiondetector', 'notepadplusplus.install' )
}

# install in all environments
& \scripts\InstallChocoPackage.ps1 -Name @( '7zip', 'git' )