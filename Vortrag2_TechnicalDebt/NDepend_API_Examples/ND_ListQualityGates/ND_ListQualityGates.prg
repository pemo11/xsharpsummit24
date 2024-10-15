// File: ND_ListQualityGates.prg
// List all quality gates
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

BEGIN NAMESPACE ND_ListQualityGates

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
        LOCAL currentAnalysisResultRef AS IAnalysisResultRef
        IF ndProject:TryGetMostRecentAnalysisResultRef(OUT currentAnalysisResultRef)
          VAR currentResult := currentAnalysisResultRef:Load()
          VAR currentIssuesSet := currentResult:ComputeIssues()
          Console.WriteLine("Quality Gates Details")
          VAR i := 0
          FOREACH qG AS IQualityGate IN currentIssuesSet:AllQualityGates
            i++
            Console.WriteLine(i"Nr={i} Name={qG.Name} Status={qG.Status} Value={qG.ValueString}")
          NEXT
        ELSE
           Console.WriteLine("!!! No recent analysis result found ")
        ENDIF
        Console.WriteLine("*** Mission accomplished ***")
			RETURN

	END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    App.Main()

