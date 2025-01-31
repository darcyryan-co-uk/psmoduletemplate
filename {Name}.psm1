$moduleName = Get-Item $PSScriptRoot | % Parent | % BaseName
$moduleManifest = "$PSScriptRoot\$moduleName.psd1"
$publicFunctionsPath = "$PSScriptRoot\Public"
$privateFunctionsPath = "$PSScriptRoot\Private"
$currentManifest = Test-ModuleManifest $moduleManifest

$aliases = @()
$publicFunctions = Get-ChildItem $publicFunctionsPath -Recurse -File | ? Extension -eq '.ps1'
$privateFunctions = Get-ChildItem $privateFunctionsPath -Recurse -File | ? Extension -eq '.ps1'
$publicFunctions | foreach { 
    . $_.FullName

    $alias = Get-Alias -Definition $_.BaseName -ErrorAction SilentlyContinue

    if ($alias) {
        $aliases += $alias
        Export-ModuleMember -Function $_.BaseName -Alias $alias
    }
    else {
        Export-ModuleMember -Function $_.BaseName
    }
}
$privateFunctions | foreach { 
    . $_.FullName
}

$functionsAdded = $publicFunctions | ? BaseName -notin $currentManifest.ExportedFunctions.Keys
$functionsRemoved = $currentManifest.ExportedFunctions.Keys | ? { $_ -notin $publicFunctions.BaseName }
$aliasesAdded = $aliases | ? { $_ -notin $currentManifest.ExportedAliases.Keys }
$aliasesRemoved = $currentManifest.ExportedAliases.Keys | ? { $_ -notin $aliases }