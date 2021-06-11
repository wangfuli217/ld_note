在线帮助: http://msdn.microsoft.com/zh-cn/library/618ayhy6(v=VS.80).aspx

一、基本语法
  1.定义变量：
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

  2.各种运算符号：
     赋值运算符：  =   +=  -=  *=  /=  %=  |=  ^=  &=
     数学运算符：  +   -   *   /   %
     逻辑运算符：  &&  ||  !

  3.各种结构：
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

  4.基本语法：
    1) 语句以分号结束“;”
    2) 变量使用前必须申明
    3) 向函数传递参数的时候要用圆括号，如：Response.Write("5566655");

  5.try-catch
    catch 可不写捕获的异常类型。预设为捕获 Exception, 如： try {...} catch {...}
    catch 也可写捕获的异常类型。如： try {...} catch ( ArgumentOutOfRangeException e ) {...}

  6.关键字
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

  9. 格式化字符串输出
     string.Format("log: {0} = {1}", Name, Value);
     其中 {0} 将替换成后面的第一个参数,{1}是第二个,以此类推
     需要输出大括号的时候，有3种方式：
     1. 使用双大括号代替一个大括号,如: string a = string.Format("{{hello}} {0},{1}", "nbwl", "wgzy2011"); //输出: {hello} nbwl,wgzy2011
     2. 以传参来做,如: string a = string.Format("{2}hello{3} {0},{1}", "nbwl", "wgzy2011", "{", "}"); //输出同上

     转码/解码
     string str = System.Web.HttpUtility.UrlEncode("<div>哈哈</div>"); // 结果: %3cdiv%3e%e5%93%88%e5%93%88%3c%2fdiv%3e
     string url = System.Web.HttpUtility.UrlDecode(str); // 解码回正常字符串
     //由于web端有安全验证，所有输入的特殊符号会报错，转码和解码就很有必要了(页面上用js的 encodeURIComponent 转码,服务器端用 HttpUtility.UrlDecode 解码)


  10.字符串拼接
     大量字符串拼接时,使用简单字符串的“+”运算,效率会非常低下,解决方案：
     1)  用 StringBuilder, 注意的是 StringBuilder 初始化(实例对象创建花费时间较长)较费资源, 一旦启动后效率很高,适合大数据量
         用例：
         using System.Text;
         StringBuilder sb = new StringBuilder();
         sb.Append("内容1");
         sb.Append("内容2");
         return sb.ToString();
     2) string[] arr = new string[n]; 将所有的字符串置入一个数组,这样可以减少内存分配的次数,适合大数据量
     3) 使用 字符串的 “+”或者“+=”运算,(使用“+=”会效率更高一些)
        这种在小数据量时效率较高,不适合大数据量,因为该操作必须分配很多的内存,然后复制,内存分配和复制是非常耗费资源和时间的,如:
        string s;
        s="aaa";
        s+="bbb";
        s+="ccc";
     4) 将多次重复不变的数据定义为常量,然后然后根据字符串的连接数据量来决定使用那种连接方法, 这种是最佳的字符串连接方案
        const string CONSTSTRING1 = "<TABLE>";
        StringBuilder sb = new StringBuilder();
        sb.Append(CONSTSTRING1);
        sb.Append("内容1");
        sb.Append("内容2");
        ...

        或者
        string str = CONSTSTRING1
        str += "内容1";
        str += "内容2";

  11.字符串截取
     String.Substring (int start)   // 从指定的字符位置开始截取,直到最后。(字符位置从0算始,包括起始字符)
     String.Substring (int start, int length)   // 从指定的字符位置开始截取,取到指定的长度。
     如:
        string s = "Hello C# World!";
        string s0 = s.Substring(0); // 不变
        string s1 = s.Substring(3); // 结果为: lo C# World!
        string s2 = s.Substring(6, 2); // 结果为: C#

    字符串比较
        string strA = "Hello";
        string strB = string.Copy(strA);    // 创建两个不同的实例,但他们的值相等
        Console.WriteLine(strA == strB);    //True, 双等号跟 Equals 功能一样了
        Console.WriteLine(strA.Equals(strB));   //True
        Console.WriteLine(object.Equals(strA, strB));   //True
        Console.WriteLine(object.ReferenceEquals(strA, strB));  //False, 他们是不同实例


  12.枚举类
    public enum LogActionEnum
    {
        /// <summary>
        /// 不限
        /// </summary>
        None=0,
        /// <summary>
        /// 添加
        /// </summary>
        Add = 1,
        /// <summary>
        /// 修改
        /// </summary>
        Update = 2,
        /// <summary>
        /// 删除
        /// </summary>
        Delete = 3,
        /// <summary>
        /// 查看
        /// </summary>
        View = 4,
        /// <summary>
        /// 其他
        /// </summary>
        Other = 5
    }

    枚举 和 int 之间的相互转换
    1) 把 枚举 转换成 int, 枚举可以默认转换为int，或者来一个Int强制转换就OK了，比如 (int)MyEnum
    2) 把 int 转成 枚举,如下写法，注意 int 值要用字符串类型，而不是直接 int, 像下面的"2"
       (LogActionEnum) Enum.Parse(typeof(LogActionEnum),"2")
       (LogActionEnum) Enum.Parse(typeof(LogActionEnum),"name") // 这里写枚举的值的字符串也可以
    3) 获取 枚举 的值的字符串
       Enum.GetName(typeof(LogActionEnum),2); // 2 是对应这枚举的值，返回对应枚举值的字符串


  13.using
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
            }
        }

  14. decimal 保留小数位数
    默认变成字符串时是3位小数
    想改成保留两位小数是: decimal n = 71.546; string v = n.ToString("f2"); // 保留几位小数就写f几


  15. is 和 as
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


二、WEB控件

  1) 控件不能遗漏 runat="server" 字样，而且所有的WEB控件都要包含在<form runat="server"></form>中间
    下面看一个完整的例子，在程序里面修改Label的Text属性，以此改变网页的显示。
    <%@ Page Language="C#" AutoEventWireup="true"%>
    <%@ Import Namespace="System.Collections.Generic"%>
    <%@ Import Namespace="Com.Everunion.Sysmgr"%>
    <%@ Import Namespace="Com.Everunion.Sysmgr.Dao"%>
    <%@ Import Namespace="Com.Everunion.Util"%>
    <%@ Import Namespace="NHibernate"%>
    <script runat="server" language="c#">
      // <asp:Button> 控件的onclick事件
      void Counter(object sender, EventArgs e)
      {
          if ( "Clicked" == Button1.Text )
            Button1.Text = "UnClicked";
          else
            Button1.Text = "Clicked";
      }

      void Page_Load()
      {
          // 给 ID="Label1" 的控件赋值
          Label1.Text = "Label1 Message";
          // 给 ID="TextBox1" 的控件赋值。在 html 上生成“value="hello"”
          TextBox1.Text = "hello";
          // 文本框可以添加的最多的字符数（多行文本框无效）；在 htnl 上生成“maxlength="6"”
          TextBox1.MaxLength = 6;
          // 设置只读属性，在 html 上生成“readonly="readonly"”
          TextBox1.ReadOnly = true;
      }
    </script>
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head><title>Label.aspx</title></head>
    <body>
      <form id="Form1" runat="server">
            <!-- 生成：<span id="Label1">Label1 Message</span> -->
          <asp:Label ID="Label1" runat="server"/><br />
            <!-- 生成：<input name="TextBox1" type="text" id="TextBox1" /> -->
          <asp:TextBox ID="TextBox1" runat="server"/><br />
            <!-- 生成：<input type="submit" name="Button1" value="UnClicked" id="Button1" /> -->
          <asp:Button ID="Button1" Text="UnClicked" runat="server" OnClick="Counter"/><br />
            <!-- 生成：<input type="image" name="ImageButton1" id="ImageButton1" src="" /> -->
          <asp:ImageButton ID="ImageButton1" runat="server" /><br />
            <!-- 生成：<a id="LinkButton1" href="javascript:__doPostBack('LinkButton1','')">LinkButton</a> -->
          <asp:LinkButton ID="LinkButton1" runat="server">LinkButton</asp:LinkButton><br />
      </form>
    </body>
    </html>


  2) WEB控件 验证
    <asp:textbox id="username" runat="server" cssclass="textbox"/>
    <asp:requiredfieldvalidator ID="reg" controltovalidate="username"
     display="dynamic" forecolor="#ff0000" font-name="宋体" font-size="9pt" text="请填写" runat="server"/>

    这是检验表单控件，验证有没有填写。
    controltovalidate就是你想检验的控件的ID；
    默认情况下不显示错误消息，地方也会被保留，如果使用了display="dynamic" 那么不显示错误消息的地方不会被空出；
    forecolor="#ff0000" font-name="宋体" font-size="9pt" 就是设定错误消息字体的颜色，字体，大小的；
    text="请填写" 就是当没有填写内容时候显示的错误消息；别忘记最后的runat="server"。
    现在这个检验控件是放在了textbox的后面，那么错误消息也在textbox后面显示，也可以放在其他地方。
    生成的 html 如下：
    <span id="reg" style="color:Red;font-family:宋体;font-size:9pt;display:none;">请填写</span>

    // 下面是 没填写验证 + 比较验证
    <asp:textbox id="password1" runat="server" textmode="password" cssclass="textbox"/>
    <asp:requiredfieldvalidator controltovalidate="password1" text="请填写" runat="server"/>
    <asp:textbox id="password2" runat="server" textmode="password" cssclass="textbox"/>
    <asp:requiredfieldvalidator controltovalidate="password2" text="请填写" runat="server"/>
    <asp:comparevalidator controltovalidate="password2" controltocompare="password1" operator="equal" text="确认失败" runat="server"/>

    在<asp:comparevalidator>中的 controltocompare="password1" 就是需要比较的控件；
    operator="equal" 就是设定比较操作是：是否相等（还有NotEqual：不相等,LessThan：少于,GreaterThan：大于，当不符合这个比较操作的时候显示错误消息）。

  3) 下拉菜单
    1.有： ListBox 控件 和 DropDownList 控件。功能几乎是一样，只是 ListBox 控件是一次将所有的选项都显示出来。
      SelectionMode属性可以设置是单选还是多选，默认是Single。
      ListBox 控件中的可选项目是通过 ListItem 元素定义的。
    2.语法：
      <ASP:ListBox Id="控件名称" Runat="Server" AutoPostBack="True | False" DataSource="<%数据源%>"
          DataTextField="数据源的字段" DataValueField="数据源的字段" Rows="一次要显示的列数"
          SelectionMode="Single | Multiple" OnSelectedIndexChanged="事件程序名称" >
          <ASP:ListItem Value="1" Enabled="True | False" Selected="True | False">text内容</ASP:ListItem>
      </ASP:ListBox>
      注：在 ListItem 里面还有一个 Text 属性，可指定显示的内容；同时使用 Text 属性和写“text内容”，显示“text内容”。
      同时不写 Text 属性和“text内容”，显示 Value 属性值；如果连 Value 也没有，则显示空白选项。


  4) 补充说明的地方
    1.每一个可以显示的控件都有是否显示的属性，比如username.Visible=false;就是隐藏了前面的username控件；
    2.如果要对控件应用CSS的话就这么写：cssclass=""，而不是 HTML 中的class=""。


三、连接数据库
    using System;
    using MySql.Data.MySqlClient;
    public partial class Default3 : System.Web.UI.Page
    {
      protected void Page_Load(object sender, EventArgs e)
      {
          // 数据库连接；
          // "server=数据库连接;uid=用户名;pwd=密码;database=数据库名字";
          String connStr = "server=127.0.0.1;uid=root;pwd=root;database=ftc";
          // 这里是SQL语句
          String sql = "select distinct years from ft_running_status";
          // 查询结果
          string bookres = "";
          try
          {
              MySqlConnection myConnection = new MySqlConnection(connStr);
              myConnection.Open();
              MySqlCommand myCommand = new MySqlCommand(sql, myConnection);
              myCommand.ExecuteNonQuery();
              MySqlDataReader myDataReader = myCommand.ExecuteReader();
              // 读取内容
              while ( myDataReader.Read() )
              {
                  bookres += myDataReader["years"] + " ";
              }
              // 关闭资源
              myDataReader.Close();
              myConnection.Close();
              // 写出内容
              loginname.Text = bookres;
              Response.Write("链接成功！");
          }
          catch
          {
              Response.Write("链接失败！");
          }
      }
    }


    如果是读取一条记录的数据或者少量的数据，我们用 DATAREADER 采集数据，然后赋值给WEB控件的Text属性即可；
    如果是读取大量数据我们就采用 DATAGRID。

    注意：上面是连接 MySQL 数据库，需要把“MySql.Data.dll”复制到 工程目录下的bin目录下.
    “MySql.Data.dll”的下载地址：http://dev.mysql.com/downloads/connector/net/5.1.html
    需要加上 using Mysql.Data.MysqlClient;
    然后使用 MySqlConnection 替换 SqlConnection ，其他和 Sqlserver 相似.


    // SqlServer 数据库链接举例：
    using System;
    using System.Data.SqlClient;

    public partial class Default3 : System.Web.UI.Page
    {
      protected void Page_Load(object sender, EventArgs e)
      {
          // SQL SERVER的连接数据库并打开；
          String connStr = "server=192.168.0.133;uid=sa;pwd=sa;database=nissan";
          SqlConnection myConnection = new SqlConnection(connStr);
          String sql = "select * from userInfo"; //这里是SQL语句
          SqlCommand objCommand = new SqlCommand(sql, myConnection);
          myConnection.Open();
          SqlDataReader objDataReader = objCommand.ExecuteReader();
          //只读取第一行的数据; 如果需要读取所有行,用“while ( objDataReader.Read() )”
          if ( objDataReader.Read() )
          {
            loginname.Text = Convert.ToString(objDataReader["loginname"]);
            username.Text = Convert.ToString(objDataReader["username"]);
            email.Text = Convert.ToString(objDataReader["email"]);
            password.Text = Convert.ToString(objDataReader["password"]);
            /*
             * 转换为字符串：Convert.ToString()
             * 转换为数字：Convert.ToInt64()，Convert.ToInt32()，Convert.ToInt16()
             * 是按照数字位数由长到短
             * 转换为日期：Convert.ToDateTime()
             */
          }
          Response.Write("链接成功！");
      }
    }


简摘：
    1.修改 <asp:TextBox>标签 的值
      由于 <asp:TextBox>标签 里面无法用 <% %> ，所以不能像下面这样：
      <asp:TextBox ID="PartnerName" runat="server" checkType="R" mess="请选择<%= ParamType == 1 ? "客戶" : "廠商" %>" >
      而可以这样：
      <asp:TextBox ID="PartnerName" runat="server" checkType="R" >
      然后在 Page_Load 方法里面写：
      PartnerName.Attributes.Add("mess", "請選取" + (ParamType == 1 ? "客戶" : "供貨廠商"));

    2.页面跳转
      Server.Transfer(url); //内部跳转: 在实现页面跳转的同时将页面处理的控制权进行移交。页面A跳转到页面B后可以继续使用页面A中提交的数据信息。此方法由页面A跳转到页面B后，浏览器的地址仍保持页面A的URL信息。
      Response.Redirect("/user/login.aspx"); //客户端地址改变:首先发送一个HTTP响应到客户端，通知客户端跳转到一个新的页面，然后客户端再发送跳转请求道服务器端。在页面跳转后内部控件保存的所有数据信息将丢失，因此当页面A跳转到页面B，页面B将无法访问页面A中提交的数据信息，跳转页面后浏览器地址栏的URL信息转变。
      Server.Execute()  //允许当前页面执行同一Web服务器上的另一页面，当另一页面执行完毕后，控制流程重新返回到原页面发出Server.Execute的调用位置。

    3.getter 和 setter
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

    4.代码段
      在“cs”文件(c#)的类里面，使用“#region”和“#endregion”可括起多个成员变量或函数，并说明他们的功能，方便阅读。
      如：
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

    5.Hashtable (类似java的HashMap)
      using System.Collections; //使用Hashtable时，必须引入这个命名空间
      Hashtable ht=new Hashtable(); //创建一个Hashtable实例
      ht.Add("E","e");//添加key/键值对
      ht.Add("A","Ass");//添加key/键值对
      string s=(string)ht["A"]; //取值
      if(ht.Contains("E")) //判断哈希表是否包含特定键,其返回值为true或false
      ht.Remove("C");//移除一个key/键值对
      ht.Clear();//移除所有元素

      遍历 HashTable
      方法一
      foreach ( System.Collections.DictionaryEntry objDE in objHasTab )
      {
          Console.WriteLine(objDE.Key.ToString());
          Console.WriteLine(objDE.Value.ToString());
      }
      方法二
      System.Collections.IDictionaryEnumerator enumerator = objHashTablet.GetEnumerator();
      while ( enumerator.MoveNext() )
      {
          Console.WriteLine(enumerator.Key);
          Console.WriteLine(enumerator.Value);
      }

      遍历 List
      方法一
      IList<Apprise> list = AppriseDao.GetInstance().SelectApprise();
      foreach ( Apprise a in list )
      {
          Response.Write("物件:" + a.Url + "  " + a.Pname + "  " + a.Email + "<br/>");
      }
      方法二
      for ( int i = 0; i < list.Count; i++ )
      {
          Apprise a = list[i];
          Response.Write("物件:" + a.Url + "  " + a.Pname + "  " + a.Email + "<br/>");
      }

    6.随机数
      using System;
      Random ran = new Random();
      int a = ran.Next(101, 999);

    7.UrlEncode
      Response.Redirect("/user/login.aspx?burl=" + Server.UrlEncode(Request.Url.ToString()));

    8.正则表达式替换
      using System.Text.RegularExpressions;
      str = Regex.Replace(str, @"\s*(>?[^<]*?)>", "$1&gt;");

    9.日期格式化
      string date = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
      DateTime date1 = DateTime.Parse("2012-02-01"); // 直接将字符串反序列化成时间,但需要用标准格式
      DateTime date2 = DateTime.ParseExact("20120201", "yyyyMMdd", null); // 遇到不是标准格式的字符串,需要自己指定格式再转成时间

      时间运算
      DateTime d1 = DateTime.Now.AddDays(1); // 一天后
      DateTime d2 = DateTime.Now.AddDays(-1); // 一天前
      double days = d1.Subtract(d2).TotalDays; // 返回日期差

    10.“@”字符串
      @"字符串"  这种格式的字符串，斜杠没有转义符功能，编写正则表达式时非常方便
      如果这种字符串中需要用到双引号，则这样写: @"string1""string2"  //字符串中两个双引号表示一个双引号

    11.多线程
       using System.Threading;
       // 多线程调用,参数 DownloadHotRepost 是被调用的函数
       new Thread(new ThreadStart(DownloadHotRepost)).Start();
       // 被多线程调用的函数
       private void DownloadHotRepost()
       {
           //........
       }

       // 发起带参数的多线程
       ThreadPool.QueueUserWorkItem(new WaitCallback(delegate { AddLog(log); }));

       // 可以直接写个匿名函数，参数和返回都还可以保证
       var arrayList = new ArrayList();
       Thread thread = new Thread(new ThreadStart(delegate
       {
            Console.WriteLine(Thread.CurrentThread.Name + "启动了");
            for (var j = 0; j < 10; j++)
            {
                Monitor.Enter(arrayList);//锁定，保持同步
                arrayList.Add(j);
                Console.WriteLine(Thread.CurrentThread.Name + "添加了" + j);
                Monitor.Exit(arrayList);//取消锁定
            }
            Console.WriteLine(Thread.CurrentThread.Name + "结束了");
       }));
       thread.Name = "线程" + i;
       thread.Start(); // 启动线程


      Thread类有几个至关重要的方法，描述如下：
        Start():    启动线程；
        Sleep(int): 静态方法，暂停当前线程指定的毫秒数；
        Abort():    通常使用该方法来终止一个线程；
        Suspend():  该方法并不终止未完成的线程，它仅仅挂起线程，以后还可恢复；
        Resume():   恢复被Suspend()方法挂起的线程的执行；

      Thread.ThreadState 属性
        这个属性代表了线程运行时状态，在不同的情况下有不同的值，我们有时候可以通过对该值的判断来设计程序流程。
        ThreadState 属性的取值如下：
        Aborted：线程已停止；
        AbortRequested：线程的Thread.Abort()方法已被调用，但是线程还未停止；
        Background：线程在后台执行，与属性Thread.IsBackground有关；
        Running：线程正在正常运行；
        Stopped：线程已经被停止；
        StopRequested：线程正在被要求停止；
        Suspended：线程已经被挂起（此状态下，可以通过调用Resume()方法重新运行）；
        SuspendRequested：线程正在要求被挂起，但是未来得及响应；
        Unstarted：未调用Thread.Start()开始线程的运行；
        WaitSleepJoin：线程因为调用了Wait(),Sleep()或Join()等方法处于封锁状态；

        上面提到了Background状态表示该线程在后台运行，那么后台运行的线程有什么特别的地方呢？其实后台线程跟前台线程只有一个区别，那就是后台线程不妨碍程序的终止。一旦一个进程所有的前台线程都终止后，CLR（通用语言运行环境）将通过调用任意一个存活中的后台进程的Abort()方法来彻底终止进程。

    12.List排序
        List<int> list = new List<int>(new int[] { 2, 3, 1, 4 });
        list.Sort();                                                        // 1,2,3,4
        // 排序时, 0:相等, -1:第一个排前面, 1:第二个排前面
        list.Sort(delegate(int left, int right) { return right - left; });  // 4,3,2,1

        List<BlogInfo> list2 = new List<BlogInfo>();
        // AsQueryable表示linq的可查询类型, OrderBy表示升序, OrderByDescending表示降序
        list2 = list2.AsQueryable().OrderBy(i => i.Id).OrderByDescending(i => i.Transmits).ToList();
        list2.Sort(CompareTransmits); // 调用排序函数
        /// <summary>
        /// 排序(按转发数，从大到小排)
        /// </summary>
        /// <param name="obj1"></param>
        /// <param name="obj2"></param>
        /// <returns>0:相等, -1:第一个类排前面, 1:第二个类排前面</returns>
        public int CompareTransmits(BlogInfo obj1, BlogInfo obj2)
        {
            if (obj1 == null && obj2 == null) return 0;
            if (obj1 != null && obj2 == null) return -1;
            if (obj1 == null && obj2 != null) return 1;

            if (obj1.Transmits < obj2.Transmits) return 1;
            if (obj1.Transmits > obj2.Transmits) return -1;
            return 0;
        }

    13.路径
        // 网页上,将虚拟（相对）路径转换为物理路径
        string path = System.Web.HttpContext.Current.Server.MapPath("~/script/home/index.js"); // 返回如: "D:\\wwwfiles\\script\\home\\index.js"
        // 站点的硬盘地址
        string domain = System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase; // 返回如: "D:\\wwwfiles\\myApp\\"
        // 站点的虚拟目录
        string dir = System.Web.HttpContext.Current.Request.ApplicationPath; // 返回如: "/myApp"

    14.图片转成字符串
        string filePath = "E:\\work_webapp\\DebrierImg\\20130318121323.png";
        // 先将图片转成二进制
        byte[] bytes = System.IO.File.ReadAllBytes(filePath);
        // 将二进制转成字符串,成功实现图片转成字符串功能
        string imgStr = Convert.ToBase64String(bytes);

        // 反过来生成图片
        byte[] bytes2 = Convert.FromBase64String(imgStr); // 字符串先转成二进制
        System.IO.File.WriteAllBytes(filePath, bytes2); // 二进制输出成图片


Request的使用
    //在cs文件里获取 HTTP的 request请求(同理可获取 response, session 等)
    using System.Web;
    HttpContext context = HttpContext.Current;
    HttpRequest Request = HttpContext.Current.Request; // 这个即是 request请求
    HttpResponse Response = HttpContext.Current.Response;
    HttpServerUtility Server = HttpContext.Current.Server;
    System.Web.SessionState.HttpSessionState Session = HttpContext.Current.Session;

    //基本参数
    private log4net.ILog log = log4net.LogManager.GetLogger(typeof(OrderHandler));
    public void ProcessRequest (HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        HttpRequest Request = context.Request;
        HttpResponse Response = context.Response;
    }

    //所有参数
    log.Error("-------- Request.Params ---------");
    for (int i = 0; i < Request.Params.Count; i++ )
        log.Error( Request.Params.Keys[i].ToString() + " === " + Request.Params[i].ToString());

    //post传來的参数
    log.Error("-------- Request.Form ---------");
    for (int i = 0; i < Request.Form.Count; i++ )
        log.Error( Request.Form.Keys[i].ToString() + " === " + Request.Form[i].ToString());

    //URL传参
    log.Error("-------- Request.QueryString ---------");
    for (int i = 0; i < Request.QueryString.Count; i++ )
        log.Error( Request.QueryString.Keys[i].ToString() + " === " + Request.QueryString[i].ToString());
    log.Error( Request.QueryString ); // 显示整个URL参数

    //Cookies
    log.Error("-------- Request.Cookies ---------");
    for (int i = 0; i < Request.Cookies.Count; i++ )
        log.Error( Request.Cookies.Keys[i].ToString() + " === " + Request.Cookies[i].ToString());

    //Session
    for (int i = 0; i < Session.Count; i++ )
        Response.Write(Session.Keys[i].ToString() + " : " + Session[i].ToString() + "\r\n");

    或者这样写：
    foreach ( string a in Request.Form.AllKeys )
        log.Error(a + "===" + Request.Form[a]);
    foreach ( string a in Request.QueryString.AllKeys )
        log.Error(a + "===" + Request.QueryString[a]);



 // ***********************************

Default.aspx 相当于 index.jsp
    在 aspx 的页面上写代码，如：
    <% Response.Write("Hello World!"); %>
    <%= "Hello World!" %> 则直接在页面上打印出内容

Default.aspx.cs 相当于 **.java 供页面调用

Default.aspx.cs 里面的 “Page_Load”方法
    protected void Page_Load(object sender, EventArgs e)
    {
      // 页面上打印内容
        Response.Write("5566655");
    }
在“Default.aspx”加载时先运行，然后再运行“Default.aspx”
在“Default.aspx”里面的 <%@ Page Language="C#" CodeFile="Default.aspx.cs" %>
CodeFile 属性指明 cs 加载文件




//资料库操作
ISession session = HibernateTemplate.SessionFactory.GetCurrentSession(); //最后别忘记关闭连接
//原生SQL 查询
ISQLQuery isq = session.CreateSQLQuery(String sql);
// HSQ 查询
IQuery iqu    = session.CreateQuery(" from Depreciable as a where a.Oid=:Oid").SetParameter("Oid", oid);
object t = isq.UniqueResult(); //取得单一结果
IList il = isq.List(); //取得多笔资料

//执行原生SQL
string sql = "Update ev_asset set aamt=( :amount + aamt ) where oid=:Oid";
session.CreateSQLQuery(sql).SetParameter("amount", amount).SetParameter("Oid", oid).ExecuteUpdate();


/// <summary>
/// 查詢折舊日期那天有沒有資料
/// </summary>
/// <param name="dDate">折舊日期</param>
/// <returns>有多少筆資料</returns>
public int CountDdate(string dDate)
{
    //打开连结
    ISession session = HibernateHelper.GetCurrentSession();
    try
    {
        //执行原生SQL
        string sql = "select count(*) from ev_depreciable where ddate='" + dDate + "'";
        return StringUtil.ToInt(session.CreateSQLQuery(sql).UniqueResult());
    }
    finally
    {
        //关闭连结
        HibernateHelper.CloseSession();
    }
}


/// <summary>
/// 查詢客戶是否有虛擬倉
/// </summary>
/// <param name="custid">客戶編號</param>
/// <returns>有多少筆資料</returns>
public int CountWarehouse(string custid)
{
    //打开连结
    ISession session = HibernateHelper.GetCurrentSession();
    try
    {
        //执行HQL
        string sql = "select count(*) from Warehouse where CustId=:CustId";
        return StringUtil.ToInt(session.CreateQuery(sql).SetParameter("CustId", custid).UniqueResult());
    }
    finally
    {
        //关闭连结
        HibernateHelper.CloseSession();
    }
}


在“aspx”文件里面使用“<!-- #include file="../common/head_js_css.inc" -->”可以把文件内容包括进来




在“cs”(c#)文件里，打印出后台内容可用：
private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(当前类名));
log.Error(String message);
类似java的System.out.println();但它输出到log文件



传递参数乱码解决方案
1.设置web.config文件。
    <system.web>
    ......
    <globalization requestEncoding="gb2312" responseEncoding="gb2312" culture="zh-CN" fileEncoding="gb2312" />
    ......
    </system.web>

2.传递中文之前，将要传递的中文参数进行编码，在接收时再进行解码。
    >> 进行传递
    string Name = "中文参数";
    Response.Redirect("B.aspx?Name="+Server.UrlEncode或進HttpUtility.UrlEncodeUnicode (Name));
    >> 进行接收
    string Name = Request.QueryString["Name"];
    Response.Write(Server.UrlDecode(Name));

3.如果是从 .HTML 文件向 .Aspx 文件进行传递中文参数的话（即不从后台用 Redirect()方法进行 Url 转换）。一样要将传递的中文参数进行编码，在接收时再进行解码。
    >> 进行传递
    <script language="JavaScript">
    function GoUrl()
    {
        var Name = "中文参数";
        location.href = "B.aspx?Name="+escape(Name);
    }
    </script>
    <body onclick="GoUrl()">

    >> 进行接收
    string Name = Request.QueryString["Name"];
    Response.Write(Server.UrlDecode(Name));

    一般来说。设置web.config文件就可以了。但是如果你用 JavaScript 调用 webservice 方法的话（往webservice里面传递中文参数）。设置 web.config 文件好象无效。

4、html文件向aspx页面传递中文参数
     >> 进行传递
     <script language="JavaScript">
     function GoUrl()
     {
          var Name = "中文参数";
          location.href =OnlineSend.aspx?Name =" + encodeURI(Name）+ "&sid="                                                                                                               + Math.random().toString();
          //在请求某个页面并传递参数时，请在后面再加个传递参数(值为随机数) ，以保存下次请求时IE
          //浏览器认为不是请求的同一个页面，否则IE浏览器认为是请求的统一页面，会从缓存中打开该页
          //面,导致参数不能正确传递过去    sid=" + Math.random().toString();
     }
     </script>
    <body onclick="GoUrl()">
    >> 进行接收
    string Name =Request.QueryString["Name "].ToString();








遍历类的属性
Response.Write(getProperties(l1.Quote)); //项目中的代码。这样也没有遍历所有的 属性的属性吧，，
public string getProperties<T>(T t)
{
    string tStr = string.Empty;
    if (t == null)
    {
        return tStr;
    }
    System.Reflection.PropertyInfo[] properties = t.GetType().GetProperties(System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public);
    if (properties.Length <= 0)
    {
        return tStr;
    }
    foreach (System.Reflection.PropertyInfo item in properties)
    {
        string name = item.Name;
        object value = item.GetValue(t, null);
        if (item.PropertyType.IsValueType || item.PropertyType.Name.StartsWith("String"))
        {
            tStr += string.Format("{0}:{1},", name, value);
        }
        else
        {
           getProperties(value);
        }
    }
    return tStr;
}


利用.NET反射機制實現IList到DataTable轉換
using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Collections;
using System.Reflection;

namespace KycBaseModule
{
    public class KycFunction
    {
        public KycFunction() { }
        /// <summary>
        /// 實現對IList到DataSet的轉換
        /// </summary>
        /// <param name="ResList">待轉換的IList</param>
        /// <returns>轉換后的DataSet</returns>
        public static DataSet ListToDataSet(IList ResList)
        {
            DataSet RDS=new DataSet();
            DataTable TempDT = new DataTable();

            //此處遍歷IList的结構并建立同樣的DataTable
            System.Reflection.PropertyInfo[] p = ResList[0].GetType().GetProperties();
            foreach (System.Reflection.PropertyInfo pi in p)
            {
                TempDT.Columns.Add(pi.Name,System.Type.GetType(pi.PropertyType.ToString()));
            }

            for (int i = 0; i < ResList.Count; i++)
            {
                IList TempList = new ArrayList();
                //將IList中的一條記錄寫入ArrayList
                foreach (System.Reflection.PropertyInfo pi in p)
                {
                    object oo = pi.GetValue(ResList[i], null);
                    TempList.Add(oo);
                }

                object[] itm=new object[p.Length];
                //遍歷ArrayList向object[]里放数據
                for (int j = 0; j < TempList.Count; j++)
                {
                    itm.SetValue(TempList[j], j);
                }
                //將object[]的內容放入DataTable
                    TempDT.LoadDataRow(itm, true);
            }
            //將DateTable放入DataSet
            RDS.Tables.Add(TempDT);
            //返回DataSet
            return RDS;
        }
    }
}


在nhibernate中执行SQL语句的方法ExecuteSQL。
public IList ExecuteSQL( string query ) {
   IList result = new ArrayList();

   ISessionFactoryImplementor s = (ISessionFactoryImplementor)cfg.BuildSessionFactory();
   IDbCommand cmd = s.ConnectionProvider.Driver.CreateCommand();
   cmd.CommandText = query;

   IDbConnection conn = s.OpenConnection();
   try {
      cmd.Connection = conn;
      IDataReader rs = cmd.ExecuteReader();

      while ( rs.Read() ) {
         int fieldCount = rs.FieldCount;
         object[] values = new Object[ fieldCount ];
         for ( int i = 0; i < fieldCount; i ++ )
            values[i] = rs.GetValue(i);
         result.Add( values );
      }
   }
   finally {
      s.CloseConnection(conn);
   }

   return result;
}


/// <summary>
/// 取得資料庫資料(本地sql)
/// </summary>
/// <param name="sql">資料庫查詢SQL(本地sql)</param>
/// <returns>结果集</returns>
public IList<Hashtable> SelectNativeSQL(string sql)
{
    IList<Hashtable> list = new List<Hashtable>();
    //打开连结
    ISession session = HibernateHelper.GetCurrentSession();
    IDbConnection conn = session.Connection;
    IDbCommand cmd = conn.CreateCommand();
    try
    {
        //查詢SQL
        cmd.CommandText = sql;
        cmd.Connection = conn;
        //查詢结果
        IDataReader result = cmd.ExecuteReader();
        while ( result.Read() )
        {
            Hashtable ht = new Hashtable();
            for ( int i = 0; i < result.FieldCount; i++ )
            {
                ht.Add(result.GetName(i), result.GetValue(i).ToString());
            }
            //加入資料
            list.Add(ht);
        }
        //关闭result
        if ( result != null )
            result.Close();
    }
    finally
    {
        //关闭连结
        HibernateHelper.CloseSession();
    }
    return list;
}

执行存储过程的方法. public IList ExecuteStoredProc( string spName, ICollection paramInfos ) {
   IList result = new ArrayList();

   ISessionFactoryImplementor s = (ISessionFactoryImplementor)cfg.BuildSessionFactory();
   IDbCommand cmd = s.ConnectionProvider.Driver.CreateCommand();

   cmd.CommandText = spName;
   cmd.CommandType = CommandType.StoredProcedure;

   // 加入参数
   if ( paramInfos != null ) {
      foreach( ParamInfo info in paramInfos ) {
         IDbDataParameter parameter = cmd.CreateParameter();
         parameter.ParameterName = info.name; // driver.FormatNameForSql( info.Name );
         parameter.Value = info.Value;
         cmd.Parameters.Add( parameter );
      }
   }

   IDbConnection conn = s.OpenConnection();
   try {
      cmd.Connection = conn;
      IDataReader rs = cmd.ExecuteReader();

      while ( rs.Read() ) {
         int fieldCount = rs.FieldCount;
         object[] values = new Object[ fieldCount ];
         for ( int i = 0; i < fieldCount; i ++ )
            values[i] = rs.GetValue(i);
         result.Add( values );
      }
   }
   finally {
      s.CloseConnection(conn);
   }

   return result;
}

其中ParamInfo为存储参数信息的结构, 定义如下:
 public struct ParamInfo {
    public string Name;
    public object Value;
 }

返回结果与nhibernate的query的结果保存一致（返回object[]的情况）。



添加引用:
加入外部dll文件,如“MySql.Data.dll”
在项目的“Service”上右键 -> Add Reference... -> Browse -> 找到要引用的文件 -> OK
然后，外部的dll文件即可使用


构造函数
    //继承父类,使用“:”
    class ProductType : ServerType, OtherObject
    {
        //空参构造方法
        public ProductType()
        {
        }

        //构建父类，使用 base
        //调用这个构造方法时，会先调用父类相应的构造方法
        public ProductType(Timer timer1, Timer timer2) : base( timer1, timer2, "file/producttype.aspx")
        {
            .... //执行完父类构造函数之后再执行这里
        }

        //构造本类的，使用 this
        //调用这个构造方法时，会先调用本类相应的构造方法
        public ProductType(string mdbPath) : this()
        {
            ..... //执行完调用的构造函数之后，再执行这里
            this.mdbPath = mdbPath;
        }

    }

//让程序暂停 1 秒
System.Threading.Thread.Sleep(1000);


可变长参数
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


在C#中使用ADOX创建Access数据库和表
由于在程序中使用了ADOX，所以先要在解决方案中引用之，方法如下：
解决方案资源管理器-->引用-->(右键)添加引用-->COM-->Microsoft ADO Ext. 2.8 for DDL and Security

private void btnCreate_Click(object sender, EventArgs e)
{
    //如果文件已经存在，会出错
    string dbName = "E:\\Temp\\" + DateTime.Now.Millisecond.ToString() + ".mdb";
    ADOX.CatalogClass cat = new ADOX.CatalogClass();
    cat.Create("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + dbName + ";");
    MessageBox.Show("数据库：" + dbName + "已经创建成功！");

    //新建一个表
    ADOX.TableClass tbl = new ADOX.TableClass();
    tbl.ParentCatalog = cat;
    tbl.Name = "MyTable";

    //增加一个自动增长的字段
    ADOX.ColumnClass col = new ADOX.ColumnClass();
    col.ParentCatalog = cat;
    col.Type = ADOX.DataTypeEnum.adInteger; // 必须先设置字段类型
    col.Name = "id";
    col.Properties["Jet OLEDB:Allow Zero Length"].Value = false;
    col.Properties["AutoIncrement"].Value = true;
    tbl.Columns.Append(col, ADOX.DataTypeEnum.adInteger, 0);

    //增加一个文本字段
    ADOX.ColumnClass col2 = new ADOX.ColumnClass();
    col2.ParentCatalog = cat;
    col2.Name = "Description";
    col2.Properties["Jet OLEDB:Allow Zero Length"].Value = false;
    tbl.Columns.Append(col2, ADOX.DataTypeEnum.adVarChar, 25);
    cat.Tables.Append(tbl);   //这句把表加入数据库(非常重要)
    MessageBox.Show("数据库表：" + tbl.Name + "已经创建成功！");
    tbl = null;
    cat = null;
}


泛型：
    // 使用 <> 把泛型括起来,用 where 来限制泛型,冒号表示泛型继承什么, new() 表示泛型可以new
    public class BaeHelper<T> where T : IBaseEntity, new()
    {
        // 函数里面使用泛型,跟这个类的没关
        public static BaeResult<U> DownLoad<U>(string method, Hashtable postData) where U : IBaseEntity, new()
        {
            var obj = new U();
            string url = string.Format("{0}/{1}{2}", obj.URI, method, obj.TABLE);
            var content = DownLoader.GetContent(url, postdata);
            return JsonUtility.FromJson<BaeResult<U>>(content);
        }

        // 函数里面使用泛型,引用这个类定义的
        public static List<T> Find(Hashtable condition, string[] fields)
        {
            var obj = new T(); // 因为定义了 new(),所以这泛型可以 new
            string url = string.Format("{0}/find_{1}", obj.URI, obj.TABLE);
            var result = DownLoad<List<T>>(url, condition);
            return result.result.info;
        }
    }


父类函数调用子类函数
--  情况1 : 方法的覆盖
    class FatherObject
    {
        // 虚方法,关键字: virtual
        public virtual void Test()
        {
            Console.Write("Father Test()");
        }

        public void runTest()
        {
            this.Test();
        }
    }

    class SonObject : FatherObject
    {
        // 实现覆盖..这个是JAVA的默认的动作, 关键字: override
        public override void Test()
        {
            Console.Write("Son Test()");
        }
    }

 SonObject Obj = new SonObject();
 Obj.runTest();  // 得到结果 Son Test()


-- 情况2 : 方法的隐藏
    class FatherObject
    {
        // 无所谓是不是虚方法
        public void Test()
        {
            Console.Write("Father Test()");
        }

        public void runTest()
        {
            this.Test();
        }
    }

    class SonObject : FatherObject
    {
        //  对父类方法隐藏
        public new void Test()
        {
            Console.Write("Son Test()");
        }
    }

 SonObject Obj = new SonObject();
 Obj.runTest();  // 得到结果 Father Test()



控件:
使RichTextBox的垂直滚动条一直位于底部
方法一：
    (没有获得焦点时屏幕照样会滚。这是做聊天软件的最佳方案)
    richTextBox1.HideSelection = false;
    再用 richTextBox1.AppendText(string message) 方法增加内容
    如果用 richTextBox1.Text += string; 方法增加内容,则没有一直位于底部的效果
方法二：
    this.richTextBox1.Focus();
    this.richTextBox1.Select(historyRichTextBox.TextLength,0);
    this.richTextBox1.ScrollToCaret();
方法三：
    (该方法比较简单，但是有个问题，就是会让当前焦点处于richTextBox中，这在很多情况下是我们不愿意看到的)
    private void richTextBox1_TextChanged(object sender, EventArgs e)
    {
        richTextBox1.SelectionStart = richTextBox1.Text.Length;
        richTextBox1.Focus();
    }


控件定位:
    控件的位置默认与上、左对齐
    以浏览器为例,即: webBrowser1.Anchor = AnchorStyles.Top | AnchorStyles.Left;
    若要浏览器的大小随上下左右变化，可: webBrowser1.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
    同时设置 Top 和 Bottom, 或者同时设置 Left 和 Right, 则会让大小也变化
    若只需控制位置,  Top 和 Bottom 只能选一个, 同理 Left 和 Right 只能选一个
    如,某按钮的位置始终保持在右下角: button1.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;


设置下拉选单只读
    要令下拉选单只读,即只可以选取原本下拉选单里的内容,不可以编辑(原本是可以编辑的)
    comboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;

设置控件颜色:
    背景颜色:
    richTextBox1.BackColor = System.Drawing.Color.White;
    richTextBox1.BackColor = System.Drawing.Color.FromRGB(100,100,100);


菜单栏控件, 快捷方式
    菜单的Text属性改成:“菜单名称(&A)”这样“A”就成为快捷方式了, 显示成:“菜单名称(A)”,
    使用快捷方式: 按下“Alt” + 快捷方式的字母


打开窗口,控制窗口的大小
 在加载完网页后的事件里面写代码,获得网页宽高同时调整Form窗体大小:
   void wb_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
   {
       int width=wb.Document.ScrollWidth;
       int height=wb.Document.ScrollHeight;
       this.Form1.Size=new Size(width,height);
   }


双问号( ?? )在检测 null 方面的带来的方便
   避免 NullReferenceException 可以用双问号(??)的单元运算符，方便得很。
   首先，既然双问号(??)是一个单元运算符，那么其左右两边数据类型必须是相同类型或能隐形转换类型的。它表示的意思是，首先检测左边的值，若其为 null,那么整个表达式取值为右侧的值，否则为左侧的值。
   例如: string s = null; Console.Write(s ?? "abc"); // 将打印出"abc"。
   例如: string s = "a"; Console.Write(s ?? "abc");  // 将打印出"a"。




Visual Studio 2005 编写的项目可以编译，但不能调试，错误信息：
Error while trying to run project: Unable to start debugging 绑定句柄无效
可以这样解决：
    1、打开项目属性，在“Debug”一项里，把“Enable the Visual Studio hosting process”前的钩去掉。
    2、打开计算机管理，在服务里将“Terminal Services”改成Manual，或者直接启动此服务。


让VS2005,vs2008代替iis以根目录浏览"~/"
在使用vs 2005 / 2008时,F5生成时总是以端口形式进行测试浏览,类似http://localhost:10010/项目名/
但在有些项目中,想有"/"顶目录形式进行开发.除了用IIS,还有另一个方法,就是直接改动VS设置即可.
 vs:2005基本步骤如下:
    1、工具/外部工具,在菜单内容中点击“添加”，名称任填，如：项目一
       英文版是: “Tools -> External Tools”, 点击“Add”, Title 随意填
    2、在“命令”框输入：C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\WebDev.WebServer.EXE，其中C:\WINDOWS\为系统目录。
       在“Command”中输入: “C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\WebDev.WebServer.EXE”
    3、在“参数”中输入：/port:10088 /path:$(ProjectDir)，其中10010是你需要的端口号。$(ProjectDir)是项目路径。
       在“Arguments”中输入如：“/port:10088 /path:D:\vs\pili”  其中“D:\vs\pili”是项目地址
    4、勾选“使用输出窗口”。点击确定。
       勾上“Use Output Window”，点“OK”
    5、右击项目/属性页。在启动选项中选择“使用自定义服务器”，在URL中输入：http://localhost:10088/。
       右键项目，选“Property Pages -> Start Options”点击“Use custom server”“Base URL”填入：“http://localhost:10088/”
    6、点击工具/项目一(多出来的菜单,自己刚才定义的名称)，即可以根目录进行调试。
       点菜单的“Tools”,在“External Tools”上面会多出一个刚才“Title”填写的名称，点击它，就可以进行调试。
  vs:2008 基本步骤如下:
    1、工具/外部工具,在菜单内容中点击“添加”，名称任填，如：项目一
    2、在“命令”框输入：C:\Program Files\Common Files\Microsoft Shared\DevServer\9.0\WebDev.WebServer.EXE，其中C:\Program Files为系统目录。
    3、在“参数”中输入/port:10086 /path:"f:\admin_myhc\myhc",其中10086是你需要的端口号。:"f:\admin_myhc\myhc",为你的项目地址
    4、右击项目/属性页。在启动选项中选择“使用自定义服务器”，在URL中输入：http://localhost:10086/。
    5、点击工具/项目一(多出来的菜单)，即可以根目录进行调试。


IIS 安装问题
    1.服务器不可用
      引起这个的原因大概是现安装了.Net Framework后装的IIS导致.Net没有在IIS里注册。
      从.net命令行工具里运行 aspnet_regIIS /i 就可以了(或者在类似下面的目录：C:\WINDOWS\Microsoft.NET\Framework\v1.1.4322\aspnet_regiis.exe -i)即可


