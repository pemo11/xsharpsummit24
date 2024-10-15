<#
 .SYNOPSIS
 Eine Excel-Mappe als Datenquelle für eine DataTable verwenden
#>

using namespace System.Data.OleDb
using namespace System.Data

# Wichtig,  nicht vergessen
Set-StrictMode -Version Latest

# Load the Excel data into a DataTable
$excelFile = Join-Path $PSScriptRoot "data/books_data.xlsx"
$tabName = "books1"
$connString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$excelFile;Extended Properties='Excel 12.0 Xml;HDR=YES';"
$exlConn = [OleDbConnection]::new($connString)
$exlConn.Open()
$exlCmd = $exlConn.CreateCommand()
$exlCmd.CommandText = "SELECT * FROM [$tabName$]"
$exlReader = $exlCmd.ExecuteReader()

$dt = [DataTable]::New()
$dt.Load($exlReader)

$exlConn.Close()

$dt | Format-Table

