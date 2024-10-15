// File: ND_StartAnalysisWithResolver.prg
// Starting a new analysis with the AssemblyResolver
// Compile with /r:System.Configuration.dll /r:NDepend.Api.dll /r:netstandard.dll
// /r:netstandard.dll is because of PathHelpers.ToDirectoryPath()?
// !works only with a Build Machine license!

// Example use the AssemblyResolver technique which is more flexible
// no need to copy anything into the program directory except NDepend.API.dll
// NDepend.UI.NetFx.resources.dll is missing 4 times but no problem

USING System
USING System.Configuration
USING System.IO

USING NDepend
USING NDepend.Analysis
USING NDepend.Path
USING NDepend.Project

BEGIN NAMESPACE ND_StartAnalysisWithResolver

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
			// Type is IAnalysisResult
			Console.WriteLine(i"AnalysisResultFilePath = {analysisResult.AnalysisResultRef.AnalysisResultFilePath}")
			Console.WriteLine("*** Mission accomplished ***")
			RETURN

	END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    App.Main()

