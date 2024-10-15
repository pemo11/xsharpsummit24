<#
 .SYNOPSIS
 Verarbeiten eines Suchergebnisses mit UltraSearch
#>

$csvPath = Join-Path -Path $PSScriptRoot -ChildPath "Data/devArt_Suche.csv"
$csvPath = Join-Path -Path $PSScriptRoot -ChildPath "Data/OraManagement_Suche.csv"

# Die ersten Zeilen auslassen
$lines = Get-Content -Path $csvPath

$i = 0
while(($lines[$i] -split ";").Count -eq 1)
{
    $i++
}

# Alles auflisten
$lines[$i..($lines.Length - 1)] | ConvertFrom-CSV -Delimiter ";" | Format-Table  -AutoSize

# Nur ausgewählte Properties anzeigen
$lines[$i..($lines.Length - 1)] | ConvertFrom-CSV -Delimiter ";" | Format-Table -Property DateiVersion, OrdnerPfad -AutoSize

# Sortiert nach der Dateiversion
$lines[$i..($lines.Length - 1)] | ConvertFrom-CSV -Delimiter ";" | Sort-Object -Property Dateiversion | Format-Table -Property DateiVersion, OrdnerPfad -AutoSize

# Die Sortierung sieht nur ok aus, da alle Major-Versionen < 10 sind

# Sortieren mit Type-Umwandlung - Version ist ein .Net Typ
$lines[$i..($lines.Length - 1)] | ConvertFrom-CSV -Delimiter ";" | Sort-Object -Property {[Version]$_.Dateiversion} | Format-Table -Property DateiVersion, OrdnerPfad -AutoSize

# Gruppieren nach Dateiversion
$lines[$i..($lines.Length - 1)] | ConvertFrom-CSV -Delimiter ";" | Group-Object -Property DateiVersion | Sort-Object -Property Count

# Verzeichnispfade einer bestimmten Version
$lines[$i..($lines.Length - 1)] | ConvertFrom-CSV -Delimiter ";" | Where-Object Dateiversion -eq "7.11.1190.0" | Sort-Object -Property DateiVersion | Format-Table -Property OrdnerPfad -AutoSize