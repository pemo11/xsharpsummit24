// File: ND_LoadRecentAnalysis.prg
// Load the most recent analysis result
// Compile with /r:System.Configuration.dll /r:NDepend.Api.dll /r:netstandard.dll
// !works only with a Build Machine license!

USING System
USING System.Configuration
USING System.IO

USING NDepend
USING NDepend.Analysis
USING NDepend.CodeModel
USING NDepend.CodeQuery
USING NDepend.Path
USING NDepend.Project

BEGIN NAMESPACE ND_LoadRecentAnalysis

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
        //  Represents an analysis result
        LOCAL analysisResultRef AS IAnalysisResultRef
        // Gets the most recent analysis first
        ndProject:TryGetMostRecentAnalysisResultRef(OUT analysisResultRef)
        var refDate1 := analysisResultRef.Date
        // Now get the one from the UI setting through a project baseline
        LOCAL analysisResultRefBaseline AS IAnalysisResultRef
        LOCAL result := ndProject:BaselineInUI:TryGetAnalysisResultRefToCompareWith(out analysisResultRefBaseline) AS TryGetAnalysisResultRefToCompareWithResult 
        Console.WriteLine(result:ToString())
        var analysisResult := analysisResultRefBaseline:Load()
        var refDate2 := analysisResult.AnalysisResultRef.Date
        var dayDiff := (Int)(refDate1-refDate2):TotalDays
        Console.WriteLine(i"Most recent analysis: {refDate1}")
        Console.WriteLine(i"Analysis from UI settings: {refDate2}")
        Console.WriteLine(i"Day diff: {dayDiff}")
        Console.WriteLine("*** Mission accomplished ***")
			RETURN

	END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    App.Main()

