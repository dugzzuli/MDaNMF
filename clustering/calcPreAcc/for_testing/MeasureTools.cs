/*
* MATLAB Compiler: 6.2 (R2016a)
* Date: Tue Mar 26 15:30:25 2019
* Arguments: "-B" "macro_default" "-W" "dotnet:MatlabDemo,MeasureTools,4.0" "-T"
* "link:lib" "-d" "H:\dugking\MDaNMF\clustering\calcPreAcc\for_testing" "-v"
* "class{MeasureTools:H:\dugking\MDaNMF\clustering\CalcMetrics.m,H:\dugking\MDaNMF\cluster
* ing\nmi.m,H:\dugking\MDaNMF\clustering\printResult4C.m}" "-a"
* "H:\dugking\MDaNMF\clustering\bestMap.m" "-a"
* "H:\dugking\MDaNMF\clustering\CalcMetrics.m" "-a"
* "H:\dugking\MDaNMF\clustering\EuDist2.m" "-a"
* "H:\dugking\MDaNMF\clustering\hungarian.m" "-a"
* "H:\dugking\MDaNMF\clustering\munkres.m" "-a" "H:\dugking\MDaNMF\clustering\nmi.m" "-a"
* "H:\dugking\MDaNMF\clustering\printResult4C.m" "-a"
* "H:\dugking\MDaNMF\clustering\RandIndex.m" 
*/
using System;
using System.Reflection;
using System.IO;
using MathWorks.MATLAB.NET.Arrays;
using MathWorks.MATLAB.NET.Utility;

#if SHARED
[assembly: System.Reflection.AssemblyKeyFile(@"")]
#endif

namespace MatlabDemo
{

  /// <summary>
  /// The MeasureTools class provides a CLS compliant, MWArray interface to the MATLAB
  /// functions contained in the files:
  /// <newpara></newpara>
  /// H:\dugking\MDaNMF\clustering\CalcMetrics.m
  /// <newpara></newpara>
  /// H:\dugking\MDaNMF\clustering\nmi.m
  /// <newpara></newpara>
  /// H:\dugking\MDaNMF\clustering\printResult4C.m
  /// </summary>
  /// <remarks>
  /// @Version 4.0
  /// </remarks>
  public class MeasureTools : IDisposable
  {
    #region Constructors

    /// <summary internal= "true">
    /// The static constructor instantiates and initializes the MATLAB Runtime instance.
    /// </summary>
    static MeasureTools()
    {
      if (MWMCR.MCRAppInitialized)
      {
        try
        {
          Assembly assembly= Assembly.GetExecutingAssembly();

          string ctfFilePath= assembly.Location;

          int lastDelimiter= ctfFilePath.LastIndexOf(@"\");

          ctfFilePath= ctfFilePath.Remove(lastDelimiter, (ctfFilePath.Length - lastDelimiter));

          string ctfFileName = "MatlabDemo.ctf";

          Stream embeddedCtfStream = null;

          String[] resourceStrings = assembly.GetManifestResourceNames();

          foreach (String name in resourceStrings)
          {
            if (name.Contains(ctfFileName))
            {
              embeddedCtfStream = assembly.GetManifestResourceStream(name);
              break;
            }
          }
          mcr= new MWMCR("",
                         ctfFilePath, embeddedCtfStream, true);
        }
        catch(Exception ex)
        {
          ex_ = new Exception("MWArray assembly failed to be initialized", ex);
        }
      }
      else
      {
        ex_ = new ApplicationException("MWArray assembly could not be initialized");
      }
    }


    /// <summary>
    /// Constructs a new instance of the MeasureTools class.
    /// </summary>
    public MeasureTools()
    {
      if(ex_ != null)
      {
        throw ex_;
      }
    }


    #endregion Constructors

    #region Finalize

    /// <summary internal= "true">
    /// Class destructor called by the CLR garbage collector.
    /// </summary>
    ~MeasureTools()
    {
      Dispose(false);
    }


    /// <summary>
    /// Frees the native resources associated with this object
    /// </summary>
    public void Dispose()
    {
      Dispose(true);

      GC.SuppressFinalize(this);
    }


    /// <summary internal= "true">
    /// Internal dispose function
    /// </summary>
    protected virtual void Dispose(bool disposing)
    {
      if (!disposed)
      {
        disposed= true;

        if (disposing)
        {
          // Free managed resources;
        }

        // Free native resources
      }
    }


    #endregion Finalize

    #region Methods

    /// <summary>
    /// Provides a single output, 0-input MWArrayinterface to the CalcMetrics MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray CalcMetrics()
    {
      return mcr.EvaluateFunction("CalcMetrics", new MWArray[]{});
    }


    /// <summary>
    /// Provides a single output, 1-input MWArrayinterface to the CalcMetrics MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="label">Input argument #1</param>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray CalcMetrics(MWArray label)
    {
      return mcr.EvaluateFunction("CalcMetrics", label);
    }


    /// <summary>
    /// Provides a single output, 2-input MWArrayinterface to the CalcMetrics MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="label">Input argument #1</param>
    /// <param name="result">Input argument #2</param>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray CalcMetrics(MWArray label, MWArray result)
    {
      return mcr.EvaluateFunction("CalcMetrics", label, result);
    }


    /// <summary>
    /// Provides the standard 0-input MWArray interface to the CalcMetrics MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] CalcMetrics(int numArgsOut)
    {
      return mcr.EvaluateFunction(numArgsOut, "CalcMetrics", new MWArray[]{});
    }


    /// <summary>
    /// Provides the standard 1-input MWArray interface to the CalcMetrics MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <param name="label">Input argument #1</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] CalcMetrics(int numArgsOut, MWArray label)
    {
      return mcr.EvaluateFunction(numArgsOut, "CalcMetrics", label);
    }


    /// <summary>
    /// Provides the standard 2-input MWArray interface to the CalcMetrics MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <param name="label">Input argument #1</param>
    /// <param name="result">Input argument #2</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] CalcMetrics(int numArgsOut, MWArray label, MWArray result)
    {
      return mcr.EvaluateFunction(numArgsOut, "CalcMetrics", label, result);
    }


    /// <summary>
    /// Provides an interface for the CalcMetrics function in which the input and output
    /// arguments are specified as an array of MWArrays.
    /// </summary>
    /// <remarks>
    /// This method will allocate and return by reference the output argument
    /// array.<newpara></newpara>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return</param>
    /// <param name= "argsOut">Array of MWArray output arguments</param>
    /// <param name= "argsIn">Array of MWArray input arguments</param>
    ///
    public void CalcMetrics(int numArgsOut, ref MWArray[] argsOut, MWArray[] argsIn)
    {
      mcr.EvaluateFunction("CalcMetrics", numArgsOut, ref argsOut, argsIn);
    }


    /// <summary>
    /// Provides a single output, 0-input MWArrayinterface to the nmi MATLAB function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// Nomalized mutual information
    /// Written by Mo Chen (mochen@ie.cuhk.edu.hk). March 2009.
    /// assert(length(label) == length(result));
    /// </remarks>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray nmi()
    {
      return mcr.EvaluateFunction("nmi", new MWArray[]{});
    }


    /// <summary>
    /// Provides a single output, 1-input MWArrayinterface to the nmi MATLAB function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// Nomalized mutual information
    /// Written by Mo Chen (mochen@ie.cuhk.edu.hk). March 2009.
    /// assert(length(label) == length(result));
    /// </remarks>
    /// <param name="label">Input argument #1</param>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray nmi(MWArray label)
    {
      return mcr.EvaluateFunction("nmi", label);
    }


    /// <summary>
    /// Provides a single output, 2-input MWArrayinterface to the nmi MATLAB function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// Nomalized mutual information
    /// Written by Mo Chen (mochen@ie.cuhk.edu.hk). March 2009.
    /// assert(length(label) == length(result));
    /// </remarks>
    /// <param name="label">Input argument #1</param>
    /// <param name="result">Input argument #2</param>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray nmi(MWArray label, MWArray result)
    {
      return mcr.EvaluateFunction("nmi", label, result);
    }


    /// <summary>
    /// Provides the standard 0-input MWArray interface to the nmi MATLAB function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// Nomalized mutual information
    /// Written by Mo Chen (mochen@ie.cuhk.edu.hk). March 2009.
    /// assert(length(label) == length(result));
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] nmi(int numArgsOut)
    {
      return mcr.EvaluateFunction(numArgsOut, "nmi", new MWArray[]{});
    }


    /// <summary>
    /// Provides the standard 1-input MWArray interface to the nmi MATLAB function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// Nomalized mutual information
    /// Written by Mo Chen (mochen@ie.cuhk.edu.hk). March 2009.
    /// assert(length(label) == length(result));
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <param name="label">Input argument #1</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] nmi(int numArgsOut, MWArray label)
    {
      return mcr.EvaluateFunction(numArgsOut, "nmi", label);
    }


    /// <summary>
    /// Provides the standard 2-input MWArray interface to the nmi MATLAB function.
    /// </summary>
    /// <remarks>
    /// M-Documentation:
    /// Nomalized mutual information
    /// Written by Mo Chen (mochen@ie.cuhk.edu.hk). March 2009.
    /// assert(length(label) == length(result));
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <param name="label">Input argument #1</param>
    /// <param name="result">Input argument #2</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] nmi(int numArgsOut, MWArray label, MWArray result)
    {
      return mcr.EvaluateFunction(numArgsOut, "nmi", label, result);
    }


    /// <summary>
    /// Provides an interface for the nmi function in which the input and output
    /// arguments are specified as an array of MWArrays.
    /// </summary>
    /// <remarks>
    /// This method will allocate and return by reference the output argument
    /// array.<newpara></newpara>
    /// M-Documentation:
    /// Nomalized mutual information
    /// Written by Mo Chen (mochen@ie.cuhk.edu.hk). March 2009.
    /// assert(length(label) == length(result));
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return</param>
    /// <param name= "argsOut">Array of MWArray output arguments</param>
    /// <param name= "argsIn">Array of MWArray input arguments</param>
    ///
    public void nmi(int numArgsOut, ref MWArray[] argsOut, MWArray[] argsIn)
    {
      mcr.EvaluateFunction("nmi", numArgsOut, ref argsOut, argsIn);
    }


    /// <summary>
    /// Provides a single output, 0-input MWArrayinterface to the printResult4C MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray printResult4C()
    {
      return mcr.EvaluateFunction("printResult4C", new MWArray[]{});
    }


    /// <summary>
    /// Provides a single output, 1-input MWArrayinterface to the printResult4C MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="indic">Input argument #1</param>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray printResult4C(MWArray indic)
    {
      return mcr.EvaluateFunction("printResult4C", indic);
    }


    /// <summary>
    /// Provides a single output, 2-input MWArrayinterface to the printResult4C MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="indic">Input argument #1</param>
    /// <param name="label">Input argument #2</param>
    /// <returns>An MWArray containing the first output argument.</returns>
    ///
    public MWArray printResult4C(MWArray indic, MWArray label)
    {
      return mcr.EvaluateFunction("printResult4C", indic, label);
    }


    /// <summary>
    /// Provides the standard 0-input MWArray interface to the printResult4C MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] printResult4C(int numArgsOut)
    {
      return mcr.EvaluateFunction(numArgsOut, "printResult4C", new MWArray[]{});
    }


    /// <summary>
    /// Provides the standard 1-input MWArray interface to the printResult4C MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <param name="indic">Input argument #1</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] printResult4C(int numArgsOut, MWArray indic)
    {
      return mcr.EvaluateFunction(numArgsOut, "printResult4C", indic);
    }


    /// <summary>
    /// Provides the standard 2-input MWArray interface to the printResult4C MATLAB
    /// function.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return.</param>
    /// <param name="indic">Input argument #1</param>
    /// <param name="label">Input argument #2</param>
    /// <returns>An Array of length "numArgsOut" containing the output
    /// arguments.</returns>
    ///
    public MWArray[] printResult4C(int numArgsOut, MWArray indic, MWArray label)
    {
      return mcr.EvaluateFunction(numArgsOut, "printResult4C", indic, label);
    }


    /// <summary>
    /// Provides an interface for the printResult4C function in which the input and
    /// output
    /// arguments are specified as an array of MWArrays.
    /// </summary>
    /// <remarks>
    /// This method will allocate and return by reference the output argument
    /// array.<newpara></newpara>
    /// </remarks>
    /// <param name="numArgsOut">The number of output arguments to return</param>
    /// <param name= "argsOut">Array of MWArray output arguments</param>
    /// <param name= "argsIn">Array of MWArray input arguments</param>
    ///
    public void printResult4C(int numArgsOut, ref MWArray[] argsOut, MWArray[] argsIn)
    {
      mcr.EvaluateFunction("printResult4C", numArgsOut, ref argsOut, argsIn);
    }



    /// <summary>
    /// This method will cause a MATLAB figure window to behave as a modal dialog box.
    /// The method will not return until all the figure windows associated with this
    /// component have been closed.
    /// </summary>
    /// <remarks>
    /// An application should only call this method when required to keep the
    /// MATLAB figure window from disappearing.  Other techniques, such as calling
    /// Console.ReadLine() from the application should be considered where
    /// possible.</remarks>
    ///
    public void WaitForFiguresToDie()
    {
      mcr.WaitForFiguresToDie();
    }



    #endregion Methods

    #region Class Members

    private static MWMCR mcr= null;

    private static Exception ex_= null;

    private bool disposed= false;

    #endregion Class Members
  }
}
