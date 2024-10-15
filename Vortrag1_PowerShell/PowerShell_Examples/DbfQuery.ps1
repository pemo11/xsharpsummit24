<#
 .SYNOPSIS
 Eine Dbf-Datei als Datenquelle für eine DataTable verwenden
#>

using namespace System.Data.OleDb
using namespace System.Data

# Wichtig,  nicht vergessen (vereinfacht eine Fehlersuche)
Set-StrictMode -Version Latest

# Load the Dbf records into a DataTable
$dbfDirectory = "$PSScriptRoot/data"
$tabName = "booksDb"
# User ID=Admin;Password=
$dbfConn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$dbfDirectory;Extended Properties=dBASE III;"
$dbfConn = [OleDbConnection]::new($dbfConn)
$dbfConn.Open()
$dbfCmd = $dbfConn.CreateCommand()
$dbfCmd.CommandText = "SELECT * FROM $tabName"
$dbfReader = $dbfCmd.ExecuteReader()
$dt = [DataTable]::New()
$dt.Load($dbfReader)

$dbfConn.Close()

$dt | Format-Table

