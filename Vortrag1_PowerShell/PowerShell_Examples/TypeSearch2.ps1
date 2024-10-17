<#
 .SYNOPSIS
 Search for a type in a loaded assembly
#>

using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms

# print the name of all properties of the DataGridView class that are not part of the Control class which is the parent class.
[DataGridView].GetProperties().Where{[Control].GetProperties().Name -notcontains $_.Name}.Name  | Sort-Object

# Exclude all names that starts with "_"

[DataGridView].GetMethods().Where{[Control].GetMethods().Name -notcontains $_.Name -and $_.Name -notmatch "_"}.Name | Sort-Object -Unique