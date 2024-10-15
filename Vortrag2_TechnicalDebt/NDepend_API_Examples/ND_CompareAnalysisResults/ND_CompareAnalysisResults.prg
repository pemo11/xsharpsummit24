// File: ND_CompareAnalysisResults.prg
// Compares to analysis results
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

BEGIN NAMESPACE ND_CompareAnalysisResults

	INTERNAL CLASS App
		PRIVATE STATIC AssResolver := AssemblyResolver{"D:\Program Files\NDepend\Lib"} AS AssemblyResolver

		// Entry point
		STATIC METHOD Main(days AS INT) AS VOID
		    AppDomain.CurrentDomain:AssemblyResolve += ResolveEventHandler{AssResolver:AssemblyResolveHandler}
        SubMain(days)
			  Console.ReadLine()
			  RETURN
			
		// Necessary, so that NDEPEND.API.DLL is not neeed in the Main method	
		STATIC Method SubMain(daysAgo AS Int32) AS VOID
        Console.WriteLine(ConfigurationManager.AppSettings["ProjectPath"])
        VAR ndprojPath := ConfigurationManager.AppSettings["ProjectPath"]:ToString():ToAbsoluteFilePath()
        VAR ndProvider := NDependServicesProvider{}
        VAR ndManager := ndProvider:ProjectManager
        VAR ndProject := ndManager.LoadProject(ndprojPath)
        LOCAL currentAnalysisResultRef AS IAnalysisResultRef
        ndProject:TryGetMostRecentAnalysisResultRef(OUT currentAnalysisResultRef)
        VAR oldAnalysisResultRef := GetAnalysisByDay(ndProject, daysAgo)
        IF oldAnalysisResultRef == NULL
           Console.WriteLine(i"No analysis result found for daysAgo={daysAgo}")
           RETURN
        ENDIF
        // Now compare the two results as IAnalysisResult objects
        VAR oldAnalysisResult := oldAnalysisResultRef:Load()
        VAR currentAnalysisResult := currentAnalysisResultRef:Load()
        VAR compareContext := currentAnalysisResult:CodeBase:CreateCompareContextWithOlder(oldAnalysisResult:CodeBase)
        // Returns an IIssuesSetDiff object
        VAR issuesSetDiff := currentAnalysisResult:ComputeIssuesDiff(compareContext)
        VAR oldIssuesSet := issuesSetDiff:OlderIssuesSet
        VAR newIssuesSet := issuesSetDiff:NewerIssuesSet
        var oldIssuesCount := oldIssuesSet:AllIssuesCount
        var newIssuesCount := newIssuesSet:AllIssuesCount
        Console.WriteLine(i"Old Issues Count={oldIssuesCount} New Issues Count={newIssuesCount}")
        Console.WriteLine("*** Mission accomplished ***")
			RETURN

    // Returns an old analysis result ref or NULL
    STATIC METHOD GetAnalysisByDay(ndProject AS IProject, daysAgo AS INT32) AS IAnalysisResultRef
        VAR analysisResultRefs := ndProject:GetAvailableAnalysisResultsRefs()
        FOREACH resultRef AS IAnalysisResultRef IN AnalysisResultRefs
           VAR days := (Int)(DateTime.Now - resultRef.Date).TotalDays
           IF days == daysAgo
              LOCAL analysisResultDaysAgo := resultRef:Load() AS IAnalysisResult
              RETURN analysisResultDaysAgo:AnalysisResultRef
           END IF
        NEXT
        RETURN NULL

	END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    VAR cmdArgs := Environment.GetCommandLineArgs()
    VAR days := 0
    IF cmdArgs:Length > 1
       INT32.TryParse(cmdArgs[2], Out days)
    ELSE
       days := 15
    ENDIF
    App.Main(days)

