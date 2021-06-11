在线帮助: http://msdn.microsoft.com/zh-cn/library/618ayhy6(v=VS.80).aspx

1. 基本语法：
    1) 语句以分号结束“;”
    2) 变量使用前必须申明
    3) 向函数传递参数的时候要用圆括号，如：Response.Write("5566655");

2. 定义变量：
    类型           描述                                           例子
    object      所有其它类型的最根本的基础类型                 object o = null;
    string      字符串类型；一个字符传是一个Unicode字符序列    string s = "Hello";
    char        字符类型;一个字符数据是一个Unicode字符         char val = 'h';
    bool        Bool类型;一个二进制数据不是真就是假            bool val1 = true; bool val2 = false;
    byte        8-bit无符号整数类型                            byte val1 = 12; byte val2 = 34U;
    sbyte       8-bit有符号整数类型                            sbyte val = 12;
    short       16-bit有符号整数类型                           short val = 12;
    ushort      16-bit无符号整数类型                           ushort val1 = 12; ushort val2 = 34U;
    int         32-bit有符号整数类型                           int val = 12;
    uint        32-bit无符号整数类型                           uint val1 = 12; uint val2 = 34U;
    long        64-bit有符号整数类型                           long val1 = 12; long val2 = 34L;
    ulong       64-bit无符号整数类型                           ulong val1 = 12; ulong val2 = 34U; ulong val3 = 56L; ulong val4 = 78UL;
    float       单精度浮点数类型                               float val = 1.23F;
    double      双精度浮点数类型                               double val1 = 1.23; double val2 = 4.56D;
    decimal     精确十进制类型，有28个有效位                   decimal val = 1.23M;
    DateTime    日期型(如："09/19/2002")

3. 各种运算符号：
     赋值运算符：  =   +=  -=  *=  /=  %=  |=  ^=  &=
     数学运算符：  +   -   *   /   %
     逻辑运算符：  &&  ||  !

4. 各种结构：
    // 1) 选择
    if (条件) { ... } else { ... }
    switch (条件)
    {
      case option1: ...      break;
      case option2: ...      break;
      default: ...
    }
    //注意： switch条件表达式的值必须为下列类型中的一种:
    //sbyte、byte、short、ushort、int、uint、long、ulong、char、string。
    //你也可能使用一个能够隐性转换成上述值类型的表达式。

    // 2) 循环
    for ( int i = 1; i <= 10; i++ ) { ... }
    while (条件) { ... }
    do { ... } while(条件);  //while后面需“;”结尾

5. try-catch
    catch 可不写捕获的异常类型。预设为捕获 Exception, 如： try {...} catch {...}
    catch 也可写捕获的异常类型。如： try {...} catch ( ArgumentOutOfRangeException e ) {...}

6. 关键字
     const 用于修改字段或局部变量的声明。它指定字段或局部变量的值是常数，不能被修改。
           如: const string productName = "Visual C#";
     typeof 用于获取类型的 System.Type 对象。
           typeof 表达式形式： System.Type type = typeof(类别);
           若要获取表达式的运行时类型，可以使用: int i = 0; System.Type type = i.GetType();
           if (value.GetType() == typeof(System.Object[])) // 类型判断
     ref 和 out
           ref,out 关键字可以用來改变方法参数的传递机制，将原本的传值(by value)改为传址(by reference)
           因为有时候会碰到这样的需求，提供給某方法的引用会希望输出处理过的结果并回传到原本的变量上
           •以 ref 参数传递的引用必须先被初始化, out 则不需要。
           • out 参数要在离开目前的方法之前至少有一次赋值的动作。
           •若兩个方法仅有 ref, out 关键字的差异，在编译器会视为相同方法签章，无法定义为多载方法。
           定义此类方法时: public void SampleMethod(ref int refParam, out int outParam) { outParam = 44; }
           使用此类方法时: SampleMethod(ref p1, out p2);

7. 使用访问修饰符 public, protected, internal 或 private 可以为成员指定以下声明的可访问性之一。
     public 访问不受限制。
     protected 只可以被本类及其派生类访问。
     internal 可被本组合体（Assembly）内所有类访问，组合体是 C# 语言中类被组合后的逻辑单位和物理单位，其编译后的文件扩展名往往是 .dll、.exe等。
     protected internal 它可以被本组合体内所有类和这些类的派生类访问，注意比 internal 范围广。
     private 仅能被本类访问。
     sealed 用来修饰类，表示是密封类，不能被继承。

     如果在成员声明中未指定访问修饰符，则使用默认的可访问性。
     不嵌套在其他类型中的顶级类型的可访问性只能是 internal 或 public。这些类型的默认可访问性是 internal。
     名称空间上不允许使用访问修饰符。名称空间没有访问限制。

8. 类型转换
     int kk = Convert.ToInt32("88");
     int dd = int.Parse("88");
     // 泛型的类型转换
     object value = ...; // 获取的值
     return (T) System.Convert.ChangeType(value, typeof(T)); // T 为指定的泛型,返回 T 类型的值

9. using
    用于导入,如: using System.Text;
    需要重命名时,可写: using ServiceLogic = MyLib.SupportService.Logic;


  入门练习
     1. 在 Visual Studio 的菜单栏“File”-“New Project”,选“Visual C#”-“Windows”-“Console Application”
     2. Hello World 练习

        using System;
        class Hello
        {
            static void Main() {
                 Console.WriteLine("Hello, world");
                 Console.WriteLine("Values: {0}, {1}", 0, 123);
                 Console.ReadKey();
            }
        }

10. 代码段
    在“cs”文件(c#)的类里面，使用“#region”和“#endregion”可括起多个成员变量或函数，并说明他们的功能，方便阅读。如：
        # region 公有函数和属性
        private int m_nowlend;

        /// <summary>
        ///物件已删除
        /// </summary>
        public virtual void MarkAsDeleted()
        {
          m_IsDeleted = true;
          m_IsChanged = true;
        }
        # endregion



    还可以使用注释(#if, #elif, #else, #endif, #define)来控制程序语句的执行，以及控制执行哪些程序段。
        下面的代码中，通过名称符号(Hywork)的值，来控制程序语句的执行。
        其中，Hywork的值可以使用 #define 定义。如果使用 #define 定义，则Hywork的值为 true,否则为 false 。
        注意：在使用 #define 声名名称符号时必须用在程序的开头，并且在其他任何关键字之前，也就是说放在命名空间前申明。
    其代码如下：
        # define Hywork
        public class Program2
        {
            public string info()
            {
                string strIonf;
                # if(Hywork==false)
        　　　　　　　　strIonf="cannotif";
        　　　　　　　　return strIonf;
                # elif(Hywork==true)
                    strIonf = "doif";
                    return strIonf;
                # endif
            }
        }



11. decimal 保留小数位数
    默认变成字符串时是3位小数
    想改成保留两位小数是: decimal n = 71.546; string v = n.ToString("f2"); // 保留几位小数就写f几


12. is 和 as
    is 就是对类型的判断。返回 true 和 false 。如果一个对象是某个类型或是其父类型的话就返回为 true, 否则的话就会返回为 false 。
    另外 is 操作符永远不会抛出异常。如果对象引用为 null, 那么 is 操作符总是返回为 false, 因为没有对象可以检查其类型。
    代码如下：
        if (o is Employee) {
           Employee e = (Employee) o;
           //在if语句中使用e
        }

    上面这种编程范式十分常见，c#便提供了一种新的类型检查，转换方式。即 as 操作符,他可以在简化代码的同时，提高性能。
    这种 as 操作即便等同于上面代码，同时只进行了1次的类型检查，所以提高了性能。如果类型相同就返回一个非空的引用，否则就返回一个空引用。
    代码如下：
        Employee e = o as Employee;
        if (e != null) {
           //在if语句中使用e
        }

13. getter 和 setter
      写法如下例：
      public partial class User
      {
          private IUserServer _userServer;

          public string UserName { get; set; }  // getter, setter 可直接写,不需作处理
          public long Id { get; }  // 只有 getter, 没有 setter 则只读,不可写

          private string _password;
          public  string PassWord
          {
              get { return _password; }  // getter
              set { _password = MD5.parse(value); } // setter, 可以另外处理, 传过来的参数是 value
          }
      }

      使用 getter 和 setter ：
        User user = new User();
        直接写 user.UserName 就可以了取值和赋值。如：
        user.UserName = "ksdjfd"; //赋值
        Response.Write(user.UserName); //取值
        如果少了 getter 方法就不能取值，少了 setter 方法就不能赋值

14. 双问号( ?? )在检测 null 方面的带来的方便
    避免 NullReferenceException 可以用双问号(??)的单元运算符，方便得很。
    首先，既然双问号(??)是一个单元运算符，那么其左右两边数据类型必须是相同类型或能隐形转换类型的。它表示的意思是，首先检测左边的值，若其为 null,那么整个表达式取值为右侧的值，否则为左侧的值。
    例如: string s = null; Console.Write(s ?? "abc"); // 将打印出"abc"。
    例如: string s = "a"; Console.Write(s ?? "abc");  // 将打印出"a"。

15. 可变长参数
    使用 params 关键字,使用 params 关键词宣告的参数必须排在最后面。它接受可变长度数组的形式，而且每个方法只能有一个 params 参数。
    当编译器尝试解析方法呼叫时，它会寻找其自变量清单和被呼叫方法相符的方法。如果找不到符合自变量清单的方法多载，但是找到了具有适当型别之 params 参数的相符版本，那么该方法会被呼叫，而多余的自变量则会放置在数组中。

    // 例：
    private void print(params object[] values)
    {
        for (int i = 0; i < values.Length; i++)
        {
            System.Console.Write(values + ", ");
        }
        Console.ReadLine();
    }

16. 让程序暂停 1 秒
    System.Threading.Thread.Sleep(1000);


