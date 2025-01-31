param(
    [string]
    $Name,
    
    $Description = '',
    
    [version]
    $Version = '1.0',

    [string]
    $Author = $env:USERNAME,

    [string]
    $Company = 'DR',

    [guid]
    $GUID = (New-Guid),

    [datetime]
    $DateTime = (Get-Date),

    [string]
    $OutputDirectory = $PWD.Path
)

function ConvertTo-Replaced {
    param(
        [Parameter(ValueFromPipeline)]
        [string]
        $Source,

        [hashtable]
        $Index
    )

    $output = $Source

    $Index.Keys.split() | foreach {
        $output = $output -replace $_, $Index.$_
    }

    return $output
}

$regex = @{

    '{Name}'        = $Name
    '{Description}' = $Description
    '{Version}'     = $Version.ToString()
    '{Author}'      = $Author
    '{Company}'     = $Company
    '{GUID}'        = $GUID.Guid
    '{Date}'        = $DateTime | Get-Date -Format 'dd/MM/yyyy'
    '{Year}'        = $DateTime | Get-Date -Format 'yyyy'

}

$targetFiles = @(
    "$PSScriptRoot\{Name}.psd1"
    "$PSScriptRoot\{Name}.psm1"
)

$moduleDirectory = "$OutputDirectory\$Name\$Version"

if (Test-Path $moduleDirectory) {
    Write-Error "unable to overwrite '$moduleDirectory'." -ErrorAction Stop
}

New-Item -Path $moduleDirectory -ItemType Directory | Out-Null
'Public', 'Private', 'Classes' | foreach {
    New-Item -Path "$moduleDirectory\$_" -ItemType Directory | Out-Null
}

$targetFiles | Copy-Item -Destination $moduleDirectory
$targetFiles = $targetFiles | foreach {
    "$moduleDirectory\$(Get-Item $_ | % Name)"
}

$targetFiles | foreach {
    $content = Get-Content -Path $_ -Raw | ConvertTo-Replaced -Index $regex
    $content | Set-Content -Path $_

    $newName = Get-Item -Path $_ | % Name | ConvertTo-Replaced -Index $regex
    $_ | Rename-Item -NewName $newName
}