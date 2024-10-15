// AssemblyResolver.prg

USING System
USING System.Diagnostics
USING System.IO
USING System.Reflection
USING System.Windows.Forms

INTERNAL CLASS AssemblyResolver

      PRIVATE strLibPath AS STRING

      CONSTRUCTOR(LibPath AS STRING)
          strLibPath := LibPath
          RETURN

      PUBLIC METHOD AssemblyResolveHandler(Sender AS OBJECT, args AS ResolveEventArgs) AS Assembly
          LOCAL Ass := NULL AS Assembly
          LOCAL AssemblyNameObj := NULL AS AssemblyName
          LOCAL asmFilePath := "" AS STRING
          TRY
              AssemblyNameObj := AssemblyName{args:Name}
              // VAR AssName := AssemblyNameObj:Name
              // Not needed - taken from the NDepend PowerTools
              // IF AssName:ToLower() != "ndepend.api" .AND. AssName:ToLower() != "ndepend.core"
              //    RETURN NULL
              // END IF
              asmFilePath := Path.Combine(strLibPath, AssemblyNameObj:Name + ".dll")
              Ass := Assembly.LoadFrom(asmFilePath)
              Console.WriteLine(i"*** Success. Resolved {args.Name}")
          CATCH
              Console.WriteLine(i"!!! Warning. Could not load {args.Name}")
          END TRY
          RETURN Ass

END CLASS


