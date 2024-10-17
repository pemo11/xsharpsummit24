<#
 .SYNOPSIS
 Search for a type in a loaded assembly
#>

using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms

[DataGridView].GetProperties().Where{[Control].GetProperties().Name -notcontains $_.Name}.Name  | Sort-Object