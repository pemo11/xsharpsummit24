// File: ND_StartAnalysisHTML.prg
// Starting a new analysis with an HTML report
// Compile with /r:System.Configuration.dll /r:NDepend.Api.dll /r:netstandard.dll
// !works only with a Build Machine license!

USING System
USING System.Configuration
USING System.Diagnostics
USING System.IO

USING NDepend
USING NDepend.Analysis
USING NDepend.Path
USING NDepend.Project

BEGIN NAMESPACE ND_StartAnalysisHTML

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
			Console.WriteLine("*** Running analysis and building Html report ...")
			ndProject:RunAnalysisAndBuildReport()
			// NDependReport.html in the configured outputdir
			var reportDir := Path.Combine(Environment.CurrentDirectory, "../OutputDir")
			ndProject:Properties:OutputDir := PathHelpers.ToDirectoryPath(reportDir)
			// Display the Html report
			var htmlPath := Path.Combine(reportDir, "NDependReport.html")
			Process.Start(htmlPath)
			Console.WriteLine("*** Mission accomplished ***")
			RETURN

	END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    App.Main()

