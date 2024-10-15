<#
 .SYNOPSIS
Typensuche in Assemblies
#>

using namespace System.IO
using namespace System.Reflection

$StartDir = "C:\"
$StartDir = "G:\2024\Trainings\XSharp Summit 2024\Vortrag1_PowerShell\PowerShell_Examples\assemblies"

$Assembly = "*.dll"

function Test-Assembly
{
    param([String]$Assembly)
    [AppDomain]::CurrentDomain.GetAssemblies().GetName().Name -contains $Assembly
    
}

Get-ChildItem -Path $StartDir -Recurse -Filter $Assembly -File -ErrorAction Ignore | ForEach-Object {
    $Assname = [Path]::GetFileNameWithoutExtension($_.Name)
    if (-not (Test-Assembly -Assembly $Assname))
    {
        $Assembly = [Assembly]::LoadFrom($_.FullName)
        $Assembly.GetTypes().Where{$_.IsPublic -and $_.IsClass}
    }
}