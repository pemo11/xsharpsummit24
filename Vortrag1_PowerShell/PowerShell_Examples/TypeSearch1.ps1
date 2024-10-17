<#
 .SYNOPSIS
 Searching for types
#>

$assPath = Join-Path -Path $PSScriptRoot -ChildPath "assemblies/XSharp.Core.dll"

$allTypes = Add-Type -Path $assPath -PassThru

$allTypes |Where-Object {$_.IsClass -and $_.IsPublic} | Select-Object -Property Name,Namespace | Sort-Object -Property Name


[XSharp.Core.Functions].GetMethods().Name | Sort-Object

[XSharp.Core.Functions].GetMethods().Name  > CoreFunctions.txt

[XSharp.Core.Functions].GetMethods().Name | Group-Object { $_[0]} | Sort-Object Name | Where-Object Name -e "A" | Select-Object -ExpandProperty Group


[DataGridView].GetProperties().Where{[Control].GetProperties().Name -notcontains $_.Name}.Name  | Sort-Object