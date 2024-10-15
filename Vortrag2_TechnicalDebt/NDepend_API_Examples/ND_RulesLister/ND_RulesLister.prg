// File: ND_RulesLister.prg
// Getting a list of a rules
// Compile with /r:System.Configuration.dll /r:NDepend.Api.dll /r:netstandard.dll
// /r:netstandard.dll is because of PathHelpers.ToDirectoryPath()?
// !works only with a Build Machine license!

USING System
USING System.Configuration
USING System.IO
USING System.LINQ

USING NDepend
USING NDepend.Analysis
USING NDepend.CodeModel
USING NDepend.Issue
USING NDepend.Path
USING NDepend.Project

BEGIN NAMESPACE ND_RulesLister

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
			// Compute the issues - allways necessary?
			// This method compiles and runs all rules against analysisResult.IAnalysisResult.CodeBase and returns all issues in an NDepend.Issue.IIssuesSet object
			// Is there any other way to just get the list of rules?
			VAR issuesSet := analysisResult:ComputeIssues()
			// List the name of all rules with issues first
      FOREACH nRule AS IRule IN issuesSet:AllRules
         Console.WriteLine(i"***  Kategorie: {nRule.Category} Name: {nRule.Name} ID: {nRule.Id}")
      NEXT
      Console.WriteLine("*** Hit enter for all issues... ***")
      Console.ReadLine()
      // List the issue of each rule
      FOREACH nRule AS IRule IN issuesSet:AllRules
        Console.WriteLine(i"*** Issues with {nRule.Name}")
        // VAR nIssues := issuesSet:Issues(nRule)
        FOREACH nIssue AS IIssue IN issuesSet:AllIssues
            // The raw value of a debt estimation is based on a time-span
            Console.WriteLine(i">>> Codeelement: {nIssue.CodeElement.FullName} Severity: {nIssue.Severity} Debt: {nIssue.Debt.Value}")
        NEXT
      NEXT
			Console.WriteLine("*** Mission accomplished ***")
			RETURN

	END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    App.Main()

