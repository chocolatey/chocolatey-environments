$siteName = 'ChocolateyServer'
$appPoolName = 'ChocolateyServerAppPool'
$sitePath = 'c:\tools\chocolatey.server'

function Add-Acl {
    [CmdletBinding()]
    Param (
        # Path to the object to set the acl on.
        [Parameter(Mandatory = $true)]
        [string]$Path,

        # Ace / Acl to set. Create this using New-Acl.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Acl', 'AclObject')]
        [System.Security.AccessControl.FileSystemAccessRule]$AceObject
    )

    Write-Verbose "Retrieving existing ACL from $Path"
    $objACL = Get-ACL -Path $Path
    $objACL.AddAccessRule($AceObject)
    Write-Verbose "Setting ACL on $Path"
    Set-ACL -Path $Path -AclObject $objACL
}

function New-AclObject {
    [OutputType([System.Security.AccessControl.FileSystemAccessRule])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'No state is being changed')]
    Param (
        # samAccountName to create the object for
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Sam', 'Username')]
        [string]$SamAccountName,

        # Permissions / rights to be applied (see https://msdn.microsoft.com/en-us/library/system.security.accesscontrol.filesystemrights(v=vs.110).aspx for information)
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('AccessRight')]
        [System.Security.AccessControl.FileSystemRights]$Permission,

        # Allow or deny the access rule (see https://msdn.microsoft.com/en-us/library/w4ds5h86(v=vs.110).aspx for information).
        # Default is 'Allow'
        [ValidateNotNullOrEmpty()]
        [System.Security.AccessControl.AccessControlType]$AccessControl = 'Allow',

        # Inheritance rules to be applied (see https://msdn.microsoft.com/en-us/library/system.security.accesscontrol.inheritanceflags(v=vs.110).aspx for information).
        # Default is 'None'
        [ValidateNotNullOrEmpty()]
        [Alias('InheritanceFlag')]
        [System.Security.AccessControl.InheritanceFlags]$Inheritance = 'None',

        # Propogation method for the rules (see https://msdn.microsoft.com/en-us/library/system.security.accesscontrol.propagationflags(v=vs.110).aspx for information).
        # Default is 'None'
        [ValidateNotNullOrEmpty()]
        [Alias('PropogationFlag')]
        [System.Security.AccessControl.PropagationFlags]$Propagation = 'None'
    )

    New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule($SamAccountName, $Permission, $Inheritance, $Propagation, $AccessControl)
}

if ($null -eq (Get-Command -Name 'choco.exe' -ErrorAction SilentlyContinue)) {
    Write-Warning "Chocolatey not installed. Cannot install standard packages."
    Exit 1
}
# Install Chocolatey.Server prereqs
choco install IIS-WebServer --source windowsfeatures
choco install IIS-ASPNET45 --source windowsfeatures

# Install Chocolatey.Server
choco upgrade chocolatey.server -y

# Step by step instructions here https://chocolatey.org/docs/how-to-set-up-chocolatey-server#setup-normally
# Import the right modules
Import-Module WebAdministration
# Disable or remove the Default website
Get-Website -Name 'Default Web Site' | Stop-Website
Set-ItemProperty "IIS:\Sites\Default Web Site" serverAutoStart False    # disables website

# Set up an app pool for Chocolatey.Server. Ensure 32-bit is enabled and the managed runtime version is v4.0 (or some version of 4). Ensure it is "Integrated" and not "Classic".
New-WebAppPool -Name $appPoolName -Force
Set-ItemProperty IIS:\AppPools\$appPoolName enable32BitAppOnWin64 True       # Ensure 32-bit is enabled
Set-ItemProperty IIS:\AppPools\$appPoolName managedRuntimeVersion v4.0       # managed runtime version is v4.0
Set-ItemProperty IIS:\AppPools\$appPoolName managedPipelineMode Integrated   # Ensure it is "Integrated" and not "Classic"
Restart-WebAppPool -Name $appPoolName   # likely not needed ... but just in case

# Set up an IIS website pointed to the install location and set it to use the app pool.
New-Website -Name $siteName -ApplicationPool $appPoolName -PhysicalPath $sitePath

# Go to explorer and right click on c:\tools\chocolatey.server and add the following permissions:
'IIS_IUSRS', 'IUSR', "IIS APPPOOL\$appPoolName" | ForEach-Object {
    $obj = New-AclObject -SamAccountName $_ -Permission 'ReadAndExecute' -Inheritance 'ContainerInherit','ObjectInherit'
    Add-Acl -Path $sitePath -AceObject $obj
}

# Right click on the App_Data subfolder and add the following permissions:
$appdataPath = Join-Path -Path $sitePath -ChildPath 'App_Data'
'IIS_IUSRS', "IIS APPPOOL\$appPoolName" | ForEach-Object {
    $obj = New-AclObject -SamAccountName $_ -Permission 'Modify' -Inheritance 'ContainerInherit', 'ObjectInherit'
    Add-Acl -Path $appdataPath -AceObject $obj
}