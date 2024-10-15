# PowerShell as the X\# developers (new) friend

Last update: **15/10/24**

## topics

- What is PowerShell?
- What makes PowerShell special?
- Installing PowerShell 7.x
- Getting to know the modern CLI with Terminal
- Simple naming rules and the tab key
- Every output is an object
- Finding out about an object with Get-Member
- Exploring types and assemblies
- Searching source code with Regexes
- Simple database access
- Static source code analysis
---

## What is the best friend of a software developer?

_ChatGPT_ lists six best friends:

1. Version Control Systems (VCS) - Git
2. Integrated Development Environments (IDEs)
3. Stack Overflow (and other developer communities)
4. Documentation
5. Automation Tools
6. Coffee (or any preferred source of energy)

## Why coffee?

ChatGPT says this about the effect of Coffee:

"caffeine helps boost alertness and focus, which can be essential when debugging or writing complex code late into the night"

## Who is missing?

Of course, one new friend is missing from the list.

Please think about it for a second or two.

Who can it be? Who can it be?

Its AI of course. Out new best friend.

Whether its _CoPilot_, _Q_, _TabNine_, _Replit AI_ or many others. Coding assistants are everywhere.

## Why is AI our new best friend?

Lets asks _ChatGPT_ again:

- Code Assistance and Autocompletion
- Bug Detection and Debugging
- Testing Automation
- Natural Language Processing (NLP) for Documentation
- Code Refactoring
- Project Management and Issue Tracking
- Learning and Skill Development
- AI in Continuous Integration/Continuous Delivery (CI/CD)

## What is the hottest new programming language?

English, German or any other language the AI assistant understands.

But now to the main topic...

## What is PowerShell?

A scripting engine based on .Net (Core or Framework) that can be hosted inside any kind of application.

_Pwsh.exe_ (_Powershell.exe_) is a console application hosting the PowerShell components.

There are other hosts like _PowerShell ISE_ (Windows only) or the _PowerShell Extension_ for _Visual Studio Code_

The main component of _PowerShell_ is _System.Management.Automation.dll_.

For many users _PowerShell_ is just another console window like the "DOS box" on Windows 95 or Windows NT 4.0 or another shell alternative on _Linux_ and _MacOS_.
---

## What makes PowerShell special for users?

1. Everything is an object and the pipeline processes objects
2. Naming consistency (like the verb-noun rule or every parametername starts with -)
3. Discoverability (tab-key auto completion, a command history retrival with ML support etc-)
---

## What makes PowerShell special for developers?

1. Everything is an .Net object and the pipeline processes .Net objects
2. The same type system (but extended) like .Net
3. Interactity with types and queries based on object properties
---

## Installing PowerShell 7.x

_Windows PowerShell 5.1_ is built in, _PowerShell 7.x_ has to be installed like any other application.

On Linux, MacOS etc. _PowerShell 7.x_ is the only option.

_PowerShell 7.x_ on _Linux_ is just another shell (but with .Net objects). There are **no** Windows specific elements (like Registry, WMI, the _Stop-Computer_-Command etc.)
---

## PowerShell 7.x and Windows PowerShell in comparison

_Windows PowerShell 5.1_ and _PowerShell 7.x_ can coexist without any problems and can share modules.

Windows PowerShell and PowerShell 7.x are "98% compatible" - PowerShell 7.x (under Windwos) can run 98% of all Windows PowerShell scripts with no need for modifications.

All modules without Windows dependencies can be used with both PowerShell 7.x and Windows PowerShell.

If a module uses .Net libraries it contains assemblies for .Net and .Net Framework.
---

## Using PowerShell as a developer

Using the _Visual Studio 2022 Developer PowerShell_ is highly recommended.

A regular (Windows) PowerShell with all environment variables set and pathes added to the _path_ environment variable.

Tools like _Fuslogvw.exe_ or _Ildasm.exe_ can run directly without having to search for them;)

```Powershell
gcm ??c.exe
```
---

## Getting to know the modern CLI with Terminal

With _Terminal_ the good, old command window becomes more friendly.

Different kind of shells in one window.

Each shell can be assigned its own settings.

Colored prompts (look very nice), try _Oh My Posh_ (offers dozens of themes).

Even emojys become normal (but you can have them in a regular PoweShell console too).
---

## Simple naming rules and the tab key

Each Cmdlet follows a simple naming rule: **verb-noun**

There are approved verbs ("get" is allowed, "transform" not for example).

```PowerShell
"transform" -in (Get-Verb).Verb
```

Every parameter starts with a - (eg. _-Computername_)

No plural "s" in the noun (its _Get-ADUser_ and not Get-ADUsers)

Upper/lowercase doesn`t matter (which is good)
---

## Cmdlets

The native PowerShell commands are called "Cmdlets" (pronounced "commandlets").

A Cmdlet is based on class that inherits from _System.Management.Automation.PSCmdlet_.

A Cmdlet can implement all the functionality of .Net - there are no security restrictions!

Every Cmdlet is part of a module.

```PowerShell
Get-Command -CommandType Cmdlet
```
---

## Every output is an object

Every get-command returns objects.

An PowerShell object is an extended .Net object.

`Get-Process` returns objects of type _System.Diagnostic.Process_, but they have additional members like _CPU_, _FileVersion_ or _WS_.

The extended members make dealing with the object a little easier.

```PowerShell
Get-Process | Get-Member -View Extended
```

Every .Net object can be extended either by _Add-Member_ or _Update-TypeData_.

This is a nice feature for (HTML) reports and any kind of object text transformations.

Its a powerfull and unique capability of _PowerShell_.
---

## Finding out about an object with Get-Member

The _Get-Member_-cmdlet returns the members of any object (as objects).

Use the _-Force_-Parameter for private members.

```PowerShell
Get-Process -ID $PID | Get-Member -Membertype Property | Out-GridView
```

**tip:** The PowerShell Cookbook module contains a GUI version of Get-Member (Show-Object)
---

## Exploring types

A PowerShell host allready loads a dozen assemblies or more.

Use _GetAssemblies()_ of the current appdomain to list them.

```PowerShell
[AppDomain]::CurrentDomain.GetAssemblies()
```

Finding a specific class is easy.

```PowerShell
[AppDomain]::CurrentDomain.GetAssemblies().GetTypes().Where{$_.IsClass -and $_.IsPublic -and $_.Name -match "table"} | Select-Object Name,Namespace
```

This command queries all type objects for those whose name contains "table".
---

## Loading Assemblies

With the _Add-Type_-Cmdlet.

```PowerShell
Add-Type -Assembly System.Windows.Forms -PassThru
```

```PowerShell
Add-Type -Path .\runtimeLibs\XSharp.Core.dll -PassThru
```
---

## Searching X\# source code with Regexes

The old joke: Some people, when confronted with a problem, think “I'll use regular expressions.”  Now they have two problems (_Jamie Zawinski_, please visit his website at [https://www.jwz.org/])

Regex are really powerful (and really not difficult to use)

PowerShell offers the _-match_ operator, the _Select-String_-Cmdlet and _[Regex]_.

```PowerShell
Get-Childitem -Path *.prg -recurse | Select-String  '(?:Internal\s+|Partial\s+|Sealed\s+)*class\s+([a-zA-Z_][a-zA-Z0-9_]*)'
```
or simpler

```PowerShell
Get-Childitem -Path *.prg -Recurse | Select-String  'class\s+(\w+)'
```

**tip:** Let ChatGPT do it for you
---

## Simple database access

Every DBMBS can be accessed where there is a .Net provider available.

SQL Server, Oracle, PostgreSQL, Sqlite and dBase too (by using ODBC or 3rd parties like _DevArt_).

Its all about the _DataTable_ object that cal hold data in rows from any kind of source

_DataTable_ and _DataSet_ are "in-memory DBMBS"

Its simple and fun to write little "database helpers" in PowerShell
---

## Accessing dbf files

They are several options

Requirement is **Microsoft Access Database Engine Redistributable** (ACE) (64 or 32 Bit)

**Option 1:** _System.Data.OleDb_ (DbfQuery.ps1)

```
Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$dbfDirectory;Extended Properties=dBASE IV;
```

**Option 2:** _DBServer_ from _VORDDClasses.dll_ (VODbfQuery.ps1)

**Option 3:** _DbfDataReader_ nuget package (DbfDataReader1.ps1)

---

## Demo time - practical examples for using PowerShell

- Searching for types in assemblies
- Search for assemblies wit specific versions
- Processing a search result from UltraSearch
- **Project:** Checking for assemblies with the "wrong version"
- **Project:** Updating data schemas
- **Project:** Static source code analysis for X#
---

## Let AI do it for you

dear AI friend: How can I create a bar chart with PowerShell?

1. Wait for 2-3s
2. Start PowerShell ISE and paste the code in
3. Hit F5
4. Fix the error
5. Hit F5 again and enjoy a simple bar chart
---


## Summary

PowerShell is a useful tool and can improve productity

100% .Net, Extended Type System

Naming consistency

Quering types, database, web data etc. become simple and consistent

Developing helpers for development tasks is easier than with X# or C#

Let CoPilot, ChatGPT & Co do the boring stuff or you
---

## Thank you

All examples and the slides are part of my X# Summit 2024 repo

[https://gitlab.com/pemome/xsharpsummit2024]
