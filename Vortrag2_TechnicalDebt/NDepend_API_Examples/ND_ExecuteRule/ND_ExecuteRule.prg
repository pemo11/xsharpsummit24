// File: ND_ExecuteRule.prg
// Execute a single rule
// Compile with /r:System.Configuration.dll /r:NDepend.Api.dll /r:netstandard.dll
// /r:netstandard.dll is because of PathHelpers.ToDirectoryPath()?
// !works only with a Build Machine license!

USING System
USING System.Configuration
USING System.Collections.Generic
USING System.IO
USING System.LINQ

USING NDepend
USING NDepend.Analysis
USING NDepend.CodeModel
USING NDepend.CodeQuery
USING NDepend.Path
USING NDepend.Project

BEGIN NAMESPACE ND_ExecuteRule

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
        // Its important to have a separate directory for the analysis output
        ndProject:Properties:OutputDir := PathHelpers.ToDirectoryPath(Path.Combine(Environment.CurrentDirectory, "../OutputDir"))
        // Do an analysis
        Console.WriteLine("*** Starting analysis...")
        VAR analysisResult := ndProject:RunAnalysis("Test1234")
        // Get the rule
        VAR ruleName := "Constructors with too many lines or more"
        LOCAL query := ndProject:CodeQueries:CodeQueriesSet:AllQueriesRecursive.FirstOrDefault({;
            q => q.QueryString.Contains(ruleName)}) AS IQuery
        IF query == NULL
           Console.WriteLine(i"Query not found!")
           RETURN
        END IF

        // Compile the query against the codeBase
        LOCAL qCompiled := query:QueryString:Compile(analysisResult.Codebase) AS IQueryCompiled
        IF qCompiled.HasErrors
           Console.WriteLine(i"Query has errors!")
           RETURN
        END IF

        // Execute the compiled query
        LOCAL qResult := qCompiled:QueryCompiledSuccess:Execute() AS IQueryExecutionResult
        IF qResult:Status != QueryExecutionStatus.Success
           Console.WriteLine(i"Query has no insults!")
           RETURN
        END IF
        // There a no properties? Only export?
        VAR xmlPath := Path.Combine(Environment.CurrentDirectory, "QueryResult.xml")
        VAR xmlContent := qResult:ExportQueryResult(QueryResultExportDocumentKind.XML, QueryResultExportFlags.ShowRows + QueryResultExportFlags.ShowStatistics)
        File.WriteAllText(xmlPath, xmlContent)
        Console.WriteLine(i"*** {xmlPath} wurde geschrieben.")
        Console.WriteLine("*** Mission accomplished ***")
			RETURN

	END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    App.Main()

