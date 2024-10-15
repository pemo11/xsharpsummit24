<#
 .SYNOPSIS
 Einlesen einer Dbf-Datei mit dem DbfDataReader
.NOTES
DbfDataReader wurde zuvor per nuget cli installiert
Es gibt auch eine Version für .Net Framework
https://github.com/yellowfeather/DbfDataReader
#>

#requires -Version 7.0

using namespace DbfDataReader

$assPath = Join-Path -Path $PSScriptRoot -ChildPath "Assemblies/DbfDataReader.dll"

Add-Type -Path $assPath # -PassThru | Select-Object Name, IsPublic, Namespace

$dbfPath = Join-Path -Path $PSScriptRoot -ChildPath "Data/books_data.dbf"

# "UTF8" geht in diesem Fall nicht, da ansonsten die Überladung nicht erkannt wird
$dbfTable = [DbfTable]::new($dbfPath, [System.Text.Encoding]::UTF8)
$header = $dbfTable.Header
$header.VersionDescription
$header.RecordCount

$dbfTable.Columns.ForEach{
    @{
        Name = $_.ColumnName
        Type = $_.ColumnType
        Length = $_.Length
        DecimalCount = $_.DecimalCount
    }
}

$skipDeleted = $true

$dbfRecord = [DbfRecord]::new($dbfTable)
while ($dbfTable.Read($dbfRecord))
{
    if (-not ($skipDeleted -and $dbfRecord.IsDeleted))
    {
        $dbfRecord.Values.ForEach{
            $_
        }
    }

}
