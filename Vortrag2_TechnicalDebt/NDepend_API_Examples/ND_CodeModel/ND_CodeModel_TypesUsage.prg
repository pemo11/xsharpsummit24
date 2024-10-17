// File: NSCodeModel_TypesUsage.prg
// compile with 
// List the usage of types

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
    // Separate directory for the analysis output
    ndProject:Properties:OutputDir := PathHelpers.ToDirectoryPath(Path.Combine(Environment.CurrentDirectory, "../OutputDir"))
    // Load the last available analysis
    LOCAL currentAnalysisResultRef AS IAnalysisResultRef
    IF !ndProject:TryGetMostRecentAnalysisResultRef(OUT currentAnalysisResultRef)
      Console.WriteLine("!!! No AnalysisResult found !!!")
      Return
    ENDIF
    // Load the analysis result to get the codebase
    LOCAL analysisResult := currentAnalysisResultRef:Load() AS IAnalysisResult
    VAR allTypes := analysisResult:Codebase:Types
    Console.WriteLine(i"{allTypes.ToList().Count} Types found")
    FOREACH nType AS IType IN allTypes:OrderBy({t => t:Name})
      VAR typesUsedCount := nType:TypesUsed:ToList():Count
      VAR typesUsingCount := nType:TypesUsingMe:ToList():Count
      Console.WriteLine(i"Name: {nType.Name} Number of Types used: {typesUsedCount} Numner of Types using this type: {typesUsingCount}")
    NEXT
    
    Console.WriteLine("*** Mission accomplished ***")
    RETURN

END CLASS

FUNCTION Start() AS VOID STRICT
    App.Main()

