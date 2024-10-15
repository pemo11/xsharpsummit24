// File: ND_IssueLister.prg
// Summary of all issues Blocker, Critical, High, Medium and Low
// Compile with /r:System.Configuration.dll /r:NDepend.Api.dll /r:netstandard.dll
// /r:netstandard.dll is because of PathHelpers.ToDirectoryPath()?
// !works only with a Build Machine license!

// Example works but the numbers seems to high!

USING System
USING System.Configuration
USING System.Collections.Generic
USING System.IO
USING System.LINQ

USING NDepend
USING NDepend.Analysis
USING NDepend.CodeModel
USING NDepend.Issue
USING NDepend.Path
USING NDepend.Project

BEGIN NAMESPACE ND_IssueLister

	INTERNAL CLASS App
		PRIVATE STATIC AssResolver := AssemblyResolver{"D:\Program Files\NDepend\Lib"} AS AssemblyResolver

		// Entry point
		STATIC METHOD Main() AS VOID
		    AppDomain.CurrentDomain:AssemblyResolve += ResolveEventHandler{AssResolver:AssemblyResolveHandler}
        SubMain()
			  Console.ReadLine()
			
		// Necessary, so that NDEPEND.API.DLL is not neeed in the Main method	
		STATIC Method SubMain() AS VOID
			Console.WriteLine(ConfigurationManager.AppSettings["ProjectPath"])
			VAR ndprojPath := ConfigurationManager.AppSettings["ProjectPath"]:ToString():ToAbsoluteFilePath()
			VAR ndProvider := NDependServicesProvider{}
			VAR ndManager := ndProvider:ProjectManager
			VAR ndProject := ndManager.LoadProject(ndprojPath)
			// Its important to have a separate directory for the analysis output
			ndProject:Properties:OutputDir := PathHelpers.ToDirectoryPath(Path.Combine(Environment.CurrentDirectory, "../OutputDir"))
			// Do an analysis
			Console.WriteLine("*** Starting analysis...")
			VAR analysisResult := ndProject:RunAnalysis("Test1234")
			VAR issuesSet := analysisResult:ComputeIssues()
			// List of all issues only?
			// Does not work because issues() expect a rule parameter
      // FOREACH nIssue AS IIssue IN issuesSet:issues()
      // Probably necessary to go through the codebase again
      var codeBase := analysisResult.CodeBase
      // Prepare Dictionary for output
      var severityDict := Dictionary<NDepend.TechnicalDebt.Severity, Int32>{}
      var total := 0
      // May be going through all Codelements is not necessaryto get all issues?
      ForEach nCodeElement As ICodeElement IN codebase:CodeElements 
        IF nCodeElement:IsCodeContainer
          // returns a IEnumerable<IIssue>
          var codeIssues := issuesSet:AllIssuesIn(nCodeElement)
          FOREACH codeIssue AS IIssue IN codeIssues
             IF !severityDict:ContainsKey(codeIssue:Severity)
                severityDict[codeIssue:Severity] := 1
             ELSE
                severityDict[codeIssue:Severity] += 1
             END IF
          NEXT
        END IF
      NEXT
      FOREACH VAR key in severityDict:Keys
         Console.WriteLine(i"Severity: {key} {severityDict[key]}")
         total += severityDict[key]
      NEXT
      Console.WriteLine(i"Total: {total}")
			Console.WriteLine("*** Mission accomplished ***")
			RETURN

	END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    App.Main()

