using System;
using System.Reflection;
using System.Globalization;
using Microsoft.CSharp;
using System.CodeDom;
using System.CodeDom.Compiler;
using System.Text;

namespace Test
{
    /// <summary>
    /// 动态执行C#代码的字符串
    /// </summary>
    public class CompilerAnyClass
    {
        static void Main(string[] args)
        {
            string codeText = @"
using System;
namespace Test
{
    public class HelloWorld
    {
        public string OutPut(int i)
        {
            return ""Hello world,哈哈:"" + i;
        }
    }
}
";
            object[] parameters = new object[] { 5566 };
            var result = CompilerAnyClass.Run(codeText, null, "Test.HelloWorld", "OutPut", parameters);
            Console.WriteLine(result);

            Console.ReadLine();
        }

        /// <summary>
        /// 动态执行C#代码的字符串
        /// </summary>
        /// <param name="codeText">代码字符串</param>
        /// <param name="addDlls">要加载的dll文件列表</param>
        /// <param name="className">要执行的类名</param>
        /// <param name="method">要执行的函数名</param>
        /// <param name="parameters">要执行的函数的参数列表</param>
        /// <returns>动态代码执行的结果</returns>
        public static object Run(string codeText, string[] addDlls, string className, string method, object[] parameters)
        {
            // 1.CSharpCodePrivoder
            // 获取编译器的实例
            CSharpCodeProvider objCSharpCodePrivoder = new CSharpCodeProvider();

            // 2.ICodeComplier
            // 定义用于调用源代码编译的接口或使用指定编译器的CodeDOM树。每种编译方法都接受指示编译器的CompilerParameters对象，并返回指示编译结果的CompilerResults对象。
            // CompilerAssemblyFromSource(CompilerParameters option, string source)：使用指定的编译器，从包含源代码的字符串设置编译程序集。
            ICodeCompiler objICodeCompiler = objCSharpCodePrivoder.CreateCompiler();

            // 3.CompilerParameters
            // 表示用于调用编译器的参数
            CompilerParameters objCompilerParameters = new CompilerParameters();
            // 获取当前项目所引用的程序集。Add方法为程序集添加引用。引用dll
            objCompilerParameters.ReferencedAssemblies.Add("System.dll");
            if (addDlls != null)
            {
                foreach (string item in addDlls)
                    objCompilerParameters.ReferencedAssemblies.Add(item);
            }
            // 获取或设置一个值，该值指示是否生成可执行文件。若此属性为false，则生成DLL，默认是false。
            objCompilerParameters.GenerateExecutable = false;
            // 获取或设置一个值，该值指示是否在内存中生成输出。
            objCompilerParameters.GenerateInMemory = true;

            // 4.CompilerResults
            // 表示从编译器返回的编译结果。
            // CompiledAssembly：获取或设置以编译的程序集，Assembly类型。
            CompilerResults cr = objICodeCompiler.CompileAssemblyFromSource(objCompilerParameters, codeText);

            if (cr.Errors.HasErrors)
            {
                // 编译错误
                string ErrorText = string.Empty;
                foreach (CompilerError err in cr.Errors)
                {
                    Console.WriteLine(err.ErrorText);
                    ErrorText += err.ErrorText + "\r\n";
                }
                return ErrorText;
            }
            else
            {
                // 通过反射，调用实例
                Assembly objAssembly = cr.CompiledAssembly;
                object objHelloWorld = objAssembly.CreateInstance(className);
                MethodInfo objMI = objHelloWorld.GetType().GetMethod(method);

                return (objMI.Invoke(objHelloWorld, parameters));
            }
        }

    }

}
