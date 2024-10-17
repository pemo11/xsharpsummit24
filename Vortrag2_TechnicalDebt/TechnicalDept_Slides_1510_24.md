# Getting out of (technical) debt

Last update: 16/10/2024

## Topics

- What is technical debt anyway?
- Tools for static source code analysis
- NDepend overview
- NDepend licensing
- Short overview over the dashboard
- So many metrics, so many numbers
- The important role of the baseline
- Analyzing the technical debt in detail
- Overview over the NDepend API
- How to use the NDepend API in simple terms
- Examples for using the NDepend API

---
## What is technical debt anyway?

- Its not an official term but a metapher
- There is a very good explanation on Wikipedia
- _Ward Cunningham_ (a "software legend") coined the phrase in 1992 when he was working on a Smalltalk application for a finance company
- "Some problems with code are like financial debt. Shipping first time code is like going into debt" (Ward Cunningham)
- Other software legends like _Grady Booch_ and _Martin Fowler_ added their own definitions

---
## A definition of technical debt

_Postponing measures to ensure and increase technical quality slows down the development process and increases costs_

The longer a measure is postponed, the more expensive it will be.

Technical debts that is not repaid (by fixing it) counts as interest on that debt.

The metaphor is good for communicating to the management the need for a refactoring.

In the end its all about money.

---
## Different kind of technical debts

_Martin Fowler_ distinguishes two kinds of technical debts:

_Those that you have consciously taken in, for example, to reach a milestone, and those that you have entered into unknowingly_.

## Practices that promote technical debt

- An architecture or code design that makes changes and extensions difficult
- Too many dependencies in a class
- No clear separation of concerns
- Methods with too many lines of code or a high complexity
- Inconsistent coding and naming standards
- Not applying SOLID principles

---
## What was SOLID again?

- **S**ingle Responsibility
- **O**pen Close
- **L**iskow Substitution
- **I**nterface Segregation
- **D**ependeny Inversion

Me: Can you apply the SOLID principles to a piece of code that I supply?
ChatGPT: Absolutely! I'd be happy to help apply the SOLID principles to your code. 
And: Please provide the code you'd like me to review, and I'll walk you through how to apply each of the SOLID principles.
	
---
## Reasons for technical debt

- Pressure by management - "we need this feature tomorow that we have promised our customers"
- No time because bug fixes and new features have priority
- No or little quality assurance (like component tests)
- Deferring refactoring
- Not enough knowledge (like I heard about _SOLID_ but I don't what it means)
- Ignoring compiler warnings (there are too many, several hundreds probably)
- there are more reasons...

---
## Where the metapher ends

- If you don't pay your financial debt you will be in (great) trouble
- If you ignore your technical debt nothing will happen
- Sometimes its ok or even better to ignore the debt when they are other priorities
- debt issues are not bugs!
- It should be part of the "team culture"

---
## You can't fight it if you can't measure it

Technical debt can be measured by a static source code analysis
A static source code analysis offers
- metrics like LOC or CC
- a maintainability index
- "code smells" (like duplicated code or long parameter lists)
- compliance to coding standards
- code coverage (how many methods are covered by component tests)
- calculates the cost of fixing code quality issues
and more...

## Several options

- SonarCube (a Java application)
- ReSharper (JetBrains)
- There used to be FxCop from Microsoft but...
- Roslyn Analyzers as part of the .Net compiler platform (_Roslyn_)
- NDepend

All tools can be integrated into a CI/CD pipeline (like _Azure DevOps_ or _ Jenkins_)

---
## NDepend overview

- offers comprehensive functionalities
- measures technical debt for each class and method
- does not support X# on a source code level (some limitations, but still very useful for X# projects)
- not cheap (800€ for a single license),, but worth the money
- very fast (analyzing a large project in about a few seconds)
- the best tool for .Net developers (my opinion)

---
## NDepend licensing
- every developer needs a licencse
- two kind of licenses: Professional and Build
- Professional: Visual Studio Extension and Visual NDepend as a standalone app
- Build: The NDepend API (for quality gates etc)

---

## Short overview over the dashboard

- Shows every aspect of the source code analsysis
- important are the issues
- rules can be reapplied any time
- Choose a baseline for comparison

---
## So many metrics, so many numbers

- CC = Cyclomatic complexity (not available for X#)
- LIC = CC on the IL level
- LOC = Lines of codes
- Percentage Comment (not available for X#)
- Code Coverage - percentage of  the methods covered by tests

---
## Cyclomatic Complexity
- A simple measurement for the "complexity" of a method
- M = E - N + 2P
- E = number of edges in the control flow graph
- N = number of nodes in the control flow graph
- P = number of connected components

---
## A simple example (part 1)

What is the CC for this function?
```
FUNCTION CalculateTotal(AS items AS ARRAY) AS INT
LOCAL i, total AS INT
total := 0
FOR i := 1 TO ALEN(items)
    IF items[i] > 0
        total := total + items[i]
    ELSE
        total := total + 1
    ENDIF
NEXT
RETURN total
```

---
## A simple example (part 2)
 - Count nodes (N) and edges (E)
 - 7 nodes (start of function, for, if condition, if branch, else branch, end of loop, return)
 - 8 edges (follow the flow graph like Start for loop entry, if condition, if condition true, if condition false, true branch, false branch, loop end, return)
 - CC = 8 - 7 + 2 P mit P = 1 => 8 - 7 + 2 = 3
 - 3 means three independent paths through the function

---
## How to measure Code Coverage
- Built in only in Visual Studio Enterprise
- There are several options for Community or Professional edition
- _NCover_ is the tool of choice (but a little expensive)
- My recommendation: _dotCover_ from _JetBrains_, export the result as "Extended Xml" and use the xml file with _NDepend_

---
## Create new rules or edit existing rules
- Rule can be written with an extended _LINQ_ syntax (_CQLing_)
- Powerful and flexible with intellisense in the editor
- Many examples and videos in the documentation
```C#
from m in Application.Methods 
 where m.NbLinesOfCode > 0 
 orderby m.NbLinesOfCode descending 
 select new { m, m.NbLinesOfCode }).Take(25) 
```
**tip:** Ask ChatGPT for help

## Using rules

- Over 200 rules are predefined
- Any rule will be applied by selecting it
- Rule Files can be created and shared among NDepend projects
- They can be part of the source too (but only C# and VB.Net)
- Issues generated by Roslyn analyzers can be imported into _NDepend_

---
## From red to green - the treemap

- A treemap visualizes the quality state of the project
- Treemapping is a visualization algorithm for displaying tree-structured data by using a nested rectangles hierarchy
- Green means good, red means "room for improvements"
- The treemap can be based on many different details and on different hierarchies like types
- Really fascinating, especially when watching the treemap became greene during a "debt reducing sprint"

## The important role of the baseline

- NDepends compares the current analysis against an older version of the project
- Baseline =  previous snapshot of the code
- The baseline can be choosen on a timeline
- Important concept with _NDepend_

---

## Analyzing the technical debt in detail

- from the NDepend docu "The technical debt can be seen as the mother of all code metrics."
- debt is measured per methods, per issue etc.
- _NDepend_ used the _SCALE_ method internally (**S**everity,**Cost**, **Ability** to implement, **L**ong-term impact, and **E**ase of implementation) for calculating _debt ratio_ and _debt rating_.
- the unit is the "effort" to fix the issue in "man days"
- Technical debt as a quality gate

```
failif value > 30%
warnif value > 20%
let timeToDev = codeBase.EffortToDevelop()
let debt = Issues.Sum(i => i.Debt)
select 100d * debt.ToManDay() / timeToDev.ToManDay()
```

---
## Debt ratio and debt rating

**debt ratio** = percentage of the estimated technical-debt, compared to the estimated effort it would take to rewrite the code element from scratch. 

Its an "estimated" effort - number of man-days to develop 1.000 logical lines of code. _NDepend_ uses 55.

**debt rating** = is inferred from thresholds applied on the debt ratio.

Five levels A to E with individual threshold values.

(looks nice, but for me it has only a limited significance)


---
## How to evaluate the results
- All technical debt items are not the same
- type of impact - which fuctionality is affected and how?
- amout of impact - how much will it hurt? Has it impact on the ussability, performance, security, stability etc.
- duration and periodicity - how often and how long will the impact affect the application?
- the age of the debt item - legacy or from the last sprint?
- intentional? - an important distinction :)
- cost for fixing - _NDepend_ will deliver the values

---

## Overview over the NDepend API

- Everything _Visual NDepend_ can do can be done in code too
- The NDepend API is used in a CI/CD pipeline for implementing quality gates or for custom tools
- It can be used from X# and from PowerShell too
- A separate build license is necessary
- Documenation is good, but there are no examples except the _NDepend.PowerTools_ project
- Support is helpful but for detailed answers you have to go to _stackoverflow.com_.

## How to use the NDepend API in simple terms

- The API is a little "strange"
- A complete NDepend installation is always necessary
- All the NDepend assemblies are loaded at runtime
- You have to use an "AssemblyResolver" or you have to have the complete (!) NDepend-Installation in the project directory (which is huge)
- The examples for this presentation explain how it can be done with a simple AssemblyResolver

---

## Examples for using the NDepend API

- I provide a dozen examples for how to use the NDepend API in the repo
- You need either the trial license (14 days) or a build license
- You have to create an NDepend project file first (with either _Visual Studio_ or _Visual NDepend_)
- The path of the ndproj file has to be in exe.config file
- The version of the _NDepend.API.dll_ in each sample directory has to match the  _NDepend.API.dll_ of the NDepend installation
- If everything is setup, using the _NDepend API_ is not difficult and mostly straigtforward
- If you want to learn how to use the _NDepend API_  try out each example

---
## How to compile the examples
- You will need either the build or the trial license key
- Each directory contains all files that are needed
- The exe.config file has to contain the path of _NDproj_ file
- Several examples expect an existing analysis file (extension _.ndar_)

```C#
xsc ND_IssueLister.prg ./AssResolver.prg /r:System.Configuration.dll /r:NDepend.Api.dll /r:netstandard.dll
```
A  reference to _netstandard.dll_ might not be necessary for every example

---

## Some of the NDepend API examples

| Directory                | Purpose                                                      | Remarks                                 |
| ------------------------ | ------------------------------------------------------------ | --------------------------------------- |
| ND_BaselineComparison    | Compares two baselines                                       | A more complex project                  |
| ND_CodeModel             | List types and their usage                                   |                                         |
| ND_CodeQuery             | List the ILC of each method                                  |                                         |
| ND_DebtQuery             | Displays the total debt of a project                         | It just displays the rating             |
| ND_ExecuteRule           | Executes an existing rules                                   |                                         |
| ND_IssueLister           | Displays a summary of all issues in the categories Blocker, Critical, High, Medium and Low |                                         |
| ND_ListAvailableAnalysis | Lists all available analysis in the specified output directory |                                         |
| ND_ListQualityGates      | List all defined quality gates                               |                                         |
| ND_StartAnalysisHTML     | Runs an analysis and display the report as an html file in the browser | The example for getting to know NDepend |

## What NDepend cannot do with X# code
- Calculating the _Cyclomatic Complexity_ (CC). Only _ILCC_.
- Analysing the number of comments and therefore cannot include this metric in the technical debt
- Everything else that is based on the source code
- **Solution**: For calculating the CC I have created "XSharp Cop" as a PowerShell script with a nice UI

## Topics not addressed
- I have covered maybe 10% percent of the functionality
- Code queries with _CQLinq_
- Import Roslyn analyzer rules
- Code diff since Baseline (really amazing functionality)
- Quality gates (rules with a failif )
- Reports
- Dependeny graphs
- its all described in the NDepend documentation

---
## Summary
- Technical debt should not be ignored easily
- Try to get a good rating
- It always a decision between effort (money) and benefits
- Some benefits might only be visible in the long run (if at all)
- Getting to know the current debt is very simple
- _NDepend_ is an excellent choice (and worth the money)

---
## Thank you!

Any questions?

All examples are in my repo [https://github.com/pemo11/xsharpsummit24]

Don't forget to vote for X# support! [https://ndepend.uservoice.com/]