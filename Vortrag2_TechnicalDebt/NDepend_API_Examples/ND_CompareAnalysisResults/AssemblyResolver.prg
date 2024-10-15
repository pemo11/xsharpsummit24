// AssemblyResolver.prg

USING System
USING System.Diagnostics
USING System.IO
USING System.Reflection
USING System.Windows.Forms

BEGIN NAMESPACE ND_CompareAnalysisResults

  INTERNAL CLASS AssemblyResolver

        PRIVATE strLibPath AS STRING

        CONSTRUCTOR(LibPath AS STRING)
            strLibPath := LibPath
            RETURN

        PUBLIC METHOD AssemblyResolveHandler(Sender AS OBJECT, args AS ResolveEventArgs) AS Assembly
           LOCAL Ass := NULL AS Assembly
            TRY
                VAR assemblyName := assemblyName{args:Name}
                VAR asmFilePath := Path.Combine(strLibPath, assemblyName:Name + ".dll")
                Ass := Assembly.LoadFrom(asmFilePath)
                Console.WriteLine(i"*** Resolved {args.name}")
            CATCH ex AS FileNotFoundException
                Console.WriteLine(i"!!! Could not resolve {args.name}")
            END TRY
            RETURN Ass

  END CLASS

END NAMESPACE
