<#
 .SYNOPSIS
 compiles a specific example from the NDepend API Examples.
#>

$examplePath = "ND_CodeModel"
$exampleName = "ND_CodeModel_ListTypes.prg"

$prgPath = Join-Path $PSScriptRoot -ChildPath "$examplePath/$exampleName"

$xscArgs = "$prgPath ./AssemblyResolver.prg /r:System.Configuration.dll /r:NDepend.Api.dll /r:netstandard.dll"

xsc $xscArgs