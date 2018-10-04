Get-NetAdapter | ForEach-Object {
  Write-Host "Setting '$($_.Name)' interface to a 'Private' network."
  Get-NetConnectionProfile -InterfaceIndex $_.ifIndex | Set-NetConnectionProfile -NetworkCategory Private
}

Write-Host "Disabling IPv6"
Get-NetAdapterBinding | Where-Object ComponentID -eq 'ms_tcpip6' | Disable-NetAdapterBinding