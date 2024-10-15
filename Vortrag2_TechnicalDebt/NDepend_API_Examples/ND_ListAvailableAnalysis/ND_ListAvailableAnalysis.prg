// File: ND_ListAvailableAnalysis.prg
// List all available analyses
// Compile with /r:System.Configuration.dll /r:NDepend.Api.dll /r:netstandard.dll
// !works only with a Build Machine license!

USING System
USING System.Configuration
USING System.IO

USING NDepend
USING NDepend.Analysis
USING NDepend.CodeModel
USING NDepend.Issue
USING NDepend.Path
USING NDepend.Project

BEGIN NAMESPACE ND_ListAvailableAnalysis

	INTERNAL CLASS App
		PRIVATE STATIC AssResolver := AssemblyResolver{"D:\Program Files\NDepend\Lib"} AS AssemblyResolver

		// Entry point
		STATIC METHOD Main() AS VOID
		    AppDomain.CurrentDomain:AssemblyResolve += ResolveEventHandler{AssResolver:AssemblyResolveHandler}
        SubMain()
			  Console.ReadLine()
			  RETURN
			
		// Necessary, so that NDEPEND.API.DLL is not neeed in the Main method	
		STATIC Method SubMain() AS VOID
        Console.WriteLine(ConfigurationManager.AppSettings["ProjectPath"])
        VAR ndprojPath := ConfigurationManager.AppSettings["ProjectPath"]:ToString():ToAbsoluteFilePath()
        VAR ndProvider := NDependServicesProvider{}
        VAR ndManager := ndProvider:ProjectManager
        VAR ndProject := ndManager.LoadProject(ndprojPath)
        
        // Alternativ: GetAvailableAnalysisResultsRefsGroupedPerMonth for grouping per month
        VAR AnalysisResultRefs := ndProject:GetAvailableAnalysisResultsRefs()
        FOREACH resultRef AS IAnalysisResultRef IN AnalysisResultRefs
           VAR daysAgo := (Int)(DateTime.Now - resultRef.Date).TotalDays
           Console.WriteLine(i"Date: {resultRef.Date} {daysAgo} days ago")
           IF daysAgo == 15
              LOCAL analysis15 := resultRef:Load() AS IAnalysisResult
              LOCAL issues := analysis15:ComputeIssues() As IIssuesSet 
              Console.WriteLine(i"Issues computed with {issues.AllIssuesCount} Issues")
           END IF
        NEXT
        Console.WriteLine("*** Mission accomplished ***")
			RETURN

	END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    App.Main()

