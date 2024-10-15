// File: ND_BaselineComparison.prg
// Trend comparison between two baselines
// Compile with /r:System.Configuration.dll /r:NDepend.Api.dll /r:netstandard.dll
// /r:netstandard.dll is because of PathHelpers.ToDirectoryPath()?
// !works only with a Build Machine license!

// Stand: 17/08/24 - es läuft durch, aber das AnalysisResult muss noch richtig ausgewertet werden - der Teil ist mir noch nicht ganz klar
// In den PowerTools funkioniert es als Punkt a) - leider ist die Ausgabe etwas verschachelt
// Die Frage ist auch noch, was ich genau vergleiche? - die Baseline von vor 30 Tagen weil 30d ausgegeben wird?

USING System
USING System.Configuration
USING System.Collections.Generic
USING System.IO
USING System.LINQ

USING NDepend
USING NDepend.Analysis
USING NDepend.CodeModel
USING NDepend.CodeQuery
USING NDepend.Issue
USING NDepend.Path
USING NDepend.Project
USING NDepend.TechnicalDebt

BEGIN NAMESPACE ND_BaselineComparison

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
            // Step 1: Load the project
            VAR ndProvider := NDependServicesProvider{}
            VAR ndManager := ndProvider:ProjectManager
            VAR ndProject := ndManager.LoadProject(ndprojPath)
            // Step 2: Get the latest analysis
            //  Represents an analysis result
            LOCAL analysisResult AS IAnalysisResult
            // Represents a reference to a NDepend analysis result
            LOCAL analysisResultRef AS IAnalysisResultRef
            ndProject:TryGetMostRecentAnalysisResultRef(OUT analysisResultRef)
            // Step 3: Compare two baselines
            LOCAL baselines := <IProjectBaseline>{ndProject.BaselineInUI, ndProject.BaselineDuringAnalysis} AS IProjectBaseline[]
            LOCAL analysisResultRefBaseline AS IAnalysisResultRef
            LOCAL otherAnalysisResult AS IAnalysisResult
            FOREACH projectBaseline AS IProjectBaseline IN baselines
                // Is there something to compare with?
                IF projectBaseline:TryGetAnalysisResultRefToCompareWith(OUT analysisResultRefBaseline) == TryGetAnalysisResultRefToCompareWithResult.DoCompareWith
                    VAR baselineDesc := i"*** Baseline computed: {(Int)(DateTime.Now - analysisResultRefBaseline.Date).TotalDays} days ago"
                    Console.WriteLine(baselineDesc)
                    analysisResult := analysisResultRefBaseline:Load()
                    otherAnalysisResult := analysisResultRef:Load()
                    VAR compareContext := analysisResult:CodeBase:CreateCompareContextWithOlder(otherAnalysisResult:CodeBase)
                    VAR issuesSetDiff := analysisResult:ComputeIssuesDiff(compareContext)
                    // {issuesSet => issuesSet.AllRules.Where({r => r.IsCritical && issuesSet.IsViolated(r)}):ToArray()})
                    DisplayIssuesDiff("# Isuses with Severity=Critical",;
                        issuesSetDiff,;
                        {issuesSet => issuesSet:AllIssues:Where({i => i:Severity == Severity.Critical}):ToArray()})
                    DisplayIssuesDiff("# Issues with Severity=High",;
                        issuesSetDiff,;
                        {issuesSet => issuesSet:AllIssues:Where({i => i:Severity == Severity.High}):ToArray()})

                    DisplayRulesDiff("# Critical rules violated",;
                        issuesSetDiff,;
                        {issuesSet => issuesSet:AllRules:Count({r => r:IsCritical .AND. issuesSet:IsViolated(r)})})

                    DisplayRulesDiff("# Rules violated",;
                        issuesSetDiff,;
                        {issuesSet => issuesSet:AllRules:Count({r => issuesSet:IsViolated(r)})})

                    DisplayRulesDiff("# Rules OK",;
                        issuesSetDiff,;
                        {issuesSet => issuesSet:AllRules:Count({r => !issuesSet:IsViolated(r) })})

                END IF

            NEXT
            Console.WriteLine(CHR(13) + "*** Mission accomplished ***")
			RETURN

        STATIC METHOD DisplayIssuesDiff(Title AS STRING, issuesSet AS IIssuesSetDiff, getIssuesProc AS Func<IIssuesSet, IIssue[]>) AS VOID
            Console.WriteLine(Title)

            // Return an IIssue array!
            VAR oldIssues := getIssuesProc(issuesSet:OlderIssuesSet)
            VAR newIssues := getIssuesProc(issuesSet:NewerIssuesSet)
            VAR nbAddedIssues := newIssues:Count(issuesSet:WasAdded)
            VAR nbFixedIssues := oldIssues:Count(issuesSet:WasFixed)

            Console.WriteLine(i"Old Issues Count: {oldIssues.Length}")
            Console.WriteLine(i"New Issues Count: {oldIssues.Length}")
            Console.WriteLine(i"Issues added: {nbAddedIssues}")
            Console.WriteLine(i"Issues fixed: {nbFixedIssues}")
            RETURN

        STATIC METHOD DisplayRulesDiff(Title AS STRING, issuesSet AS IIssuesSetDiff, getRulesProc AS Func<IIssuesSet, INT>) AS VOID
            Console.WriteLine(Title)
            // Return an Int
            VAR oldCriticalRulesCount := getRulesProc(issuesSet:OlderIssuesSet)
            VAR newCriticalRulesCount := getRulesProc(issuesSet:NewerIssuesSet)
            Console.WriteLine(i"Old rules count: {oldCriticalRulesCount}")
            Console.WriteLine(i"New rules count: {newCriticalRulesCount}")


            RETURN

    END CLASS

END NAMESPACE

FUNCTION Start() AS VOID STRICT
    App.Main()

