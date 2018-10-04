function ConvertTo-ChocoObject {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline)]
        [string]$InputObject
    )

    Process {
        # format of the 'choco list' output is:
        # <PACKAGE NAME> <VERSION> (ie. adobereader 2015.6.7)
        if (-not [string]::IsNullOrEmpty($InputObject)) {
            $props = $_.split(' ')
            New-Object -TypeName psobject -Property @{ name = $props[0]; version = $props[1] }
        }
    }
}