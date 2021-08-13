
简摘：
    1.页面跳转
      Server.Transfer(url); //内部跳转: 在实现页面跳转的同时将页面处理的控制权进行移交。页面A跳转到页面B后可以继续使用页面A中提交的数据信息。此方法由页面A跳转到页面B后，浏览器的地址仍保持页面A的URL信息。
      Response.Redirect("/user/login.aspx"); //客户端地址改变:首先发送一个HTTP响应到客户端，通知客户端跳转到一个新的页面，然后客户端再发送跳转请求道服务器端。在页面跳转后内部控件保存的所有数据信息将丢失，因此当页面A跳转到页面B，页面B将无法访问页面A中提交的数据信息，跳转页面后浏览器地址栏的URL信息转变。
      Server.Execute()  //允许当前页面执行同一Web服务器上的另一页面，当另一页面执行完毕后，控制流程重新返回到原页面发出Server.Execute的调用位置。

    2.Hashtable (类似java的HashMap)
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


