<#
 .Synopsis
 Importieren einer CSV-Datei in eine Dbf-Datei
#>

using namespace VO

<#
 .SYNOPSIS
Importieren einer CSV-Datei in eine Dbf-Datei
#>
function Import-CSVData
{
    param([String]$DbName, [String]$CsvPath)
    $db = [DBServer]::new($DbName, $true, $false, "DBFCDX")
    Import-CSV -Path $CsvPath -Delimiter ";" | ForEach-Object {
        [void]$db.Append()
        [void]$db.FIELDPUT("Id", $_.Id)
        [void]$db.FIELDPUT("Title",$_.Title)
        [void]$db.FIELDPUT("PubYear",$_.PubYear)
        [void]$db.FIELDPUT("Publisher",$_.Publisher)
        [void]$db.FIELDPUT("MainAuthor",$_.MainAuthor)
    }
}

### Main ###

$VerbosePreference = "Continue"

$AssPfad = Join-Path -Path $PSScriptRoot -ChildPath "Assemblies/VORDDClasses.dll"
Add-Type -Path $AssPfad

$DbName = Join-Path -Path $PSScriptRoot -ChildPath "Data/BooksDb.dbf"

Import-CSVData -DbName $DbName -CsvPath "$PSScriptRoot/data/books_data.csv"

Write-Verbose "*** CSV-Daten wurden importiert ***"

$db = [DBServer]::new($DbName, $true, $false, "DBFCDX")

[void]$db.GoTop()

while(!$db.EoF.Value)
{
    if (!$db.Deleted.Value)
    {
        "$($db.FIELDGET('Id').Value.Trim()): $($db.FIELDGET('Title').Value.Trim()) von $($db.FIELDGET('MainAuthor').Value.Trim()) Ersch-Jahr: $($db.FIELDGET('PubYear').Value.Trim())"
    }
    [void]$db.Skip()
}

[void]$db.Close()
Write-Verbose "*** Verbindung wurde geschlossen ***"

$VerbosePreference = "SilentlyContinue"