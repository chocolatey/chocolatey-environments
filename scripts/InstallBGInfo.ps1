if ($null -eq (Get-Command -Name 'choco.exe' -ErrorAction SilentlyContinue)) {
    Write-Warning "Chocolatey not installed. Cannot install BGInfo."
}
else {
    choco upgrade bginfo -y --source="'c:\packages'"

    #Copy-Item "C:\vagrant\shell\bginfo.bgi" 'C:\programdata\chocolatey\lib\sysinternals\tools\bginfo.bgi'
    Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name bginfo -Value 'c:\programdata\chocolatey\lib\bginfo\tools\bginfo.exe c:\vagrant\shell\bginfo.bgi /accepteula /silent /timer:0'
}