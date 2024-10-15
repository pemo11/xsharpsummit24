// File: ND_LOCMetrics.prg
// Getting metrics like LOC
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
USING NDepend.Path
USING NDepend.Project

BEGIN NAMESPACE ND_LOCMetrics

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
        // Get all code elements from the Codebase first
        var codeBase := analysisResult.CodeBase
        // Simple sorting thanks to LINQ
        FOREACH VAR nType In codeBase:Types:OrderBy({c => c:Name})
          // var nLOC := IIF(nType:IsCodeContainer, (Short)((ICodeContainer)(nType)):NbLinesOfCode, -1)
          // Name is part of another interface ICodeElement is inherinting from
          Console.WriteLine(i"Type={nType.Name} LOC: {nType.NbLinesOfCode} LILC: {nType.NbILInstructions}")
        NEXT
        // NbLinesOfCode is member of ICodeContainer - Codebase also implements ICodeContainer
        // Total TOC identical to dashboard value
        Console.WriteLine(i"Total LOC: {codeBase.NbLinesOfCode}")
        Console.WriteLine("*** Mission accomplished ***")
        RETURN

	END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    App.Main()

