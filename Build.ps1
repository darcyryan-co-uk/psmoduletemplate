param(

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
            !($_ -contains " ")
        })]
    [string]
    $Name,
    
    [ValidateNotNull()]
    [ValidateScript({
            !($_ -contains "`n")
        })]
    [string]
    $Description = "",
    
    [ValidateNotNullOrEmpty()]
    [version]
    $Version = "1.0",

    [ValidateNotNullOrEmpty()]
    [string]
    $Author = "$env:UserDomain\$env:UserName",

    [ValidateNotNullOrEmpty()]
    [string]
    $Company = "DarcyRyan",

    [ValidateNotNull()]
    [guid]
    $GUID = (New-Guid),

    [ValidateNotNull()]
    [datetime]
    $DateTime = (Get-Date),

    [ValidateNotNullOrEmpty()]
    [ValidateScript({
            (Test-Path $_ -PathType Container)
        })]
    [string]
    $OutputDirectory = $PWD.Path

)

function Replace-Multiple {
    param(

        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $InputObject,

        [hashtable]
        $Replace

    )

    $Replace.Keys.split() | foreach {
        $InputObject = $InputObject -Replace $_, $Replace.$_
    }

    return $InputObject
}

$regex = @{

    "{Name}"        = $Name
    "{Description}" = $Description
    "{Version}"     = $Version.ToString()
    "{Author}"      = $Author
    "{Company}"     = $Company
    "{GUID}"        = $GUID.Guid
    "{Date}"        = $DateTime | Get-Date -Format "dd/MM/yyyy"
    "{Year}"        = $DateTime | Get-Date -Format "yyyy"

}

$targetFiles = @(

    "$PSScriptRoot\{Name}.psd1"
    "$PSScriptRoot\{Name}.psm1"

)

$moduleDirectory = "$OutputDirectory\$Name\$($regex."{Version}")"

if (Test-Path $moduleDirectory) {
    Write-Error "unable to overwrite '$moduleDirectory'." -ErrorAction Stop
}

New-Item -Path $moduleDirectory -ItemType Directory | Out-Null
@(

    "Public"
    "Private"

) | foreach {
    New-Item -Path "$moduleDirectory\$_" -ItemType Directory | Out-Null
}
$targetFiles | Copy-Item -Destination $moduleDirectory
$targetFiles = $targetFiles | foreach {
    "$moduleDirectory\$(Get-Item $_ | % Name)"
}

$targetFiles | foreach {
    $content = Get-Content -Path $_ -Raw | Replace-Multiple -Replace $regex
    $content | Set-Content -Path $_

    $name = Get-Item -Path $_ | % Name | Replace-Multiple -Replace $regex
    $_ | Rename-Item -NewName $name
}