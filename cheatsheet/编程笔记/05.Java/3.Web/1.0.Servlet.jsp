
"*"表示重要性，星号越多越重要

day1 
一、 Web应用基础
1.B-S架构(***) 
  架构的发展
  c/s vs. b/s
    c/s架构 (client客户端-server服务端) 
        (胖客户端:要求客户端运行业务；把业务放到服务器端，则是瘦客户端) 
        典型的c/s应用：ftp工具、QQ、邮件系统、杀毒软件...
        1.建立在tcp/ip协议之上，有自己的通信规则(建立业务) 
        2.需要相互配合才能完成一个完整业务逻辑
        3.允许多个客户端程序同时接入一个server程序(并发) 
        4.每一个client(机器)都必须安装客户软件
        5.修改了server程序，通常client程序都要修改(升级) 
        优点：利用客户端的计算能力，分担服务器的负荷(大型网络游戏就利用这点) 
        缺点：用户必须安装客户端程序；客户端需要升级(麻烦) 
    b/s架构 (browser - web server(cluster集群)) 
        (极瘦客户端:最低限度地减少客户端程序，只需要browser(浏览器)) 
        1.基于http协议(应用层) 
        2.几乎所有的业务逻辑处理都在server完成
        3.支持并发
        4.client要求很少，只需要安装browser(浏览器) 
        5.修改server之后，client不需要任何变化
        6.server端开发技术：html/js,xhtml,... php,asp,jsp,servlet
        缺点：所有业务都在服务器端完成，服务器负荷大。
        优点：支持高并发访问；不需另外安装软件(只需浏览器)，免去更新的麻烦。

2.开发一个静态的Web应用(*) 
  1)下载一个tomcat服务器
  2)web服务器-Tomcat的启动和配置(熟练使用和配置) 
    先进入Tomcat主目录下的bin目录      // %catalina_home%/bin
    window平台：启动---startup.bat
               关闭---shutdown.bat
    Linux平台：启动---startup.sh 或 catalina.sh run //catalina单次启动；startup启动直至shutdown
              关闭---shutdown.sh 或 Ctrl+C
    测试： 打开浏览器，访问 Tomcat 首页：http://localhost:8080 或者 http://127.0.0.1:8080/
    获取进程Id强行杀死tomcat进程
       ps ef|grep tomcat ---查看tomcat的进程id
       kill -9 tomcat进程Id号 --- 强行杀死tomcat进程
  3)介绍Web应用的结构
      严格定义为两部分
      Web应用的根目录下有一个特定的子目录称为WEB-INF，其中包含不能被客户访问的专用Web应用程序软件，
      包括Servlet类文件、部署描述符web.xml、外部库以及其它任何由此应用程序使用的专用文件。
      所有位于WEB-INF之外的文件都被看作是公共的，它们可以从客户端被访问。资源包括HTML页面、JSP页面和图像等。
    web.xml的模板(一个web.xml中可以配置多个Servlet)：

        <?xml version="1.0" encoding="UTF-8"?>
        <web-app version="2.5" 
         xmlns="http://java.sun.com/xml/ns/javaee" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee 
         http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">
          <servlet>
            <servlet-name>servlet的名字1</servlet-name>   //servlet的逻辑名
            <servlet-class>servlet类全名1</servlet-class> //类的完全限定名
          </servlet>
          <servlet>
            <servlet-name>servlet的名字2</servlet-name>
            <servlet-class>servlet类全名2</servlet-class>
          </servlet>
         
          <servlet-mapping>
            <servlet-name>servlet的名字1</servlet-name> //要和servlet标签中的相同
            <url-pattern>指定servlet相对于应用目录的路径</url-pattern> //servlet的访问路径
          </servlet-mapping>
          <servlet-mapping>
            <servlet-name>servlet的名字2</servlet-name>
            <url-pattern>指定servlet相对于应用目录的路径</url-pattern>
          </servlet-mapping>
          <welcome-file-list>
            <welcome-file>index.jsp</welcome-file>//指定默认的欢迎页面
          </welcome-file-list>
        </web-app>
  4)注意事项


3.介绍Web服务器的一些特点  
    什么是静态内容？什么是动态内容？
      静态：返回页面每个客户端都相同。  动态：各个客户端的页面各不相同。
    产生动态内容的Web辅助应用：CGI & Servlet
      CGI(Common Gateway Interface): 可以产生动态内容，跨语言(C/C++, Perl, python...) 
          1.本身是一个进程(数据共享，跨进程调用) --性能较差
          2.可移植性很差(本地语言) 
          3.安全性差--可以访问本地的操作系统，容易受黑客攻击
      web server / servlet container
          1.性能好 --多线程(而不是进程) 
          2.可移植性 --相对好
          3.安全性

4.Http基础(**) 
  HTTP(Hyper Text Transfer Protocol)是超文本传输协议的缩写，它用于传送 WWW 方式的数据。
  HTTP 协议采用了请求/响应模型。基于 TCP/IP 之上的协议，在 Web 上广泛使用。无状态。
  如果来自服务器的响应是 html 页面，那么 html 内容会嵌入到 Http 响应中。
  Http 会话：是一个简单的请求-响应序列。
  1)请求响应模型
    请求的关键要素：1.http方法(要完成的动作) 2.要访问的页面(URL请求) 3.表单参数
    响应的关键要素：1.状态码(请求是否成功) 2.内容类型(txt,img,html等) 3.返回内容(具体资源:html,图片等) 
  2)URL的分析
    URL(Uniform Resoure Locator)统一资源定位器。Web 上的每一个资源都有唯一的地址，采用的就是 url 格式
  3)使用Http Monitor截获http的请求与响应信息
    Http 请求方法包括：Get()方法;Post()方法; 其它方法：Head, Trace, Put, Delete, Connect 等
    Get()方法： Http 最简单的方法，其最主要的任务：从服务器上获取资源
    Post()方法：更强大的请求方法，不仅可以请求资源，还可以向服务器发送表单数据
  4)分析http请求的信息
    客户端向服务器发送一个请求，请求头包含：
    1.请求的方法； 2.URI； 3.协议版本； 4.以及包含请求修饰符；
    5.客户信息和内容的类似于 MIME 的消息结构
  5)分析http响应的信息
    截获内容：
        HTTP/1.1 200 OK      // HTTP/1.1 是web服务器使用的版本；200 是状态码；OK 是状态码的文本版本
        ETag: W/"472-1198101802343"
        Last-Modified: Wed, 19 Dec 2007 22:03:22 GMT
        Content-Type: text/html  // MIME类型：告诉浏览器所要接收的是哪一类型的数据。以供浏览器显示。
        Content-Length: 472
        Date: Wed, 19 Dec 2007 22:05:44 GMT
        Server: Apache-Coyote/1.1
        //以上是Http响应的首部
        //响应体中包含了Html以及其它要显示的内容
        <html><head><title>User Login</title></head>
        <body><center>……</center></body></html>
    Http 响应状态码分析(具体代码含义参看 http 代码对照表)：
        1xx:信息响应类，表示接收到请求并且继续处理
        2xx:处理成功响应类，表示动作被成功接收、理解和接受
        3xx:复位向响应类，为了完成指定的动作，必须接受进一步处理
        4xx:客户端错误，客户请求包含语法错误或者是不能正确执行
            如：404——无法找到，表示无法找到指定位置的资源。
        5xx:服务端错误，服务器不能正确执行一个正确的请求


二、Servlet基础
1.介绍Servlet的基本概念(***) 
    (Servlet、Servlet容器、Servlet vs. CGI)——————图示
  1)它是由 java 编写的、服务端的小程序。相对而言，Applet和javaScript是客户端小程序。
  2)基于Http协议的，运行在web服务器内的。Servlet和CGI都是运行在Web服务器上,用来生成Web页面。
  3)没有 main 方法。是接受来自网络的请求(form表单，以及其它的请求)，并对不同请求作出不同的响应。
  4)由容器管理和调用。这个web容器可以控制Servlet对象的生命周期，控制请求由Servlet对象处理。
  5)Web 服务器的辅助应用，处理特定的用户请求，并返回响应。
    web服务器，这里的服务器不是硬件概念，而是软件，常用的web服务器有 Tomcat，Jboss等
    Tomcat是一个用java语言编写的web服务器，所以需要有相应的java运行环境，也就是JVM，还要配置tomcat的具体路径。
  6)继承 java 的优点，与协议、平台无关

2.开发第一个Servlet应用(**) 
    Web应用的结构 
    开发一个Servlet应用的步骤 
    1)建立 Web 应用目录(注意细节:各目录的位置、名称与包含的内容) 
    2)编写 Java 代码，如：HelloWorld.java
      把生成的.class 文件放置到 WebRoot/WEB-INF/classes 目录下
    3)编写配置文件：web.xml
      放置到 WebRoot/WEB-INF/  目录下
    4)把整个 web 应用放到 %catalina_home%/webapps  //放到 tomcat的 webapps目录下

3.分析Servlet应用(***) 
  1)Servlet的继承体系 
    javax.servlet.Servlet接口 --> GenericServlet抽象类 --> HttpServlet  -->  自定义类
    所有的servlet都必须实现该接口    处理各种协议(包括http)   专职处理http协议  也可继承GenericServlet
  2)Servlet接口；GenericServlet抽象类；HttpServlet类
    Servlet接口(位置：javax.servlet.Servlet) 定义了特定的生命周期方法：
        init(ServletConfig config) 
        service(HttpServletRequest request, HttpServletResponse response) 
        destroy() 
    GenericServlet implements Servlet
        实现了 init(ServletConfig config)、destroy()等方法；并提供了 init()方法。
        还实现了 ServletConfig 接口。由于这是抽象类，所以必须实现抽象方法：service() 
    HttpServlet extends GenericServlet   (位置：javax.servlet.http.HttpServlet) 
        具有父类 GenericServlet 类似的方法和对象，是使用 Servlet 编程常用的类
        支持 HTTP 的 post 和 get 等方法。
  3)容器如何找到指定的Servlet？(图示) 
    Servlet有 3 个"名字"： url 名、 应用中的逻辑名、 实际的名字
    配置文件 web.xml 都把这几个名字一一对应起来了
  Servlet是受容器管理的
    request对象、response对象都是容器根据客户端请求而产生的。
    容器根据url请求，通过DD(web.xml)配置(url名，内部逻辑名，完全限定名)定位具体的servlet。
    容器根据客户请求创建/分配一个线程，并调用servlet的service()方法，把request对象、respone对象作为参数传过去
    service()方法会根据客户端请求的Http方法调用不同的HttpServlet的方法(doGet(),doPost(),...);
    Servlet使用response对象把处理完的结果响应到客户端。
    service()方法结束后，线程要么撤销，要么返回容器的线程池；request对象、response对象都被gc回收。

4.使用Servlet来发送用户输入的信息 
  1)开发用户登录的应用
  2)如何使用Form表单来提交数据
     <form action="login" method="POST" enctype="multipart/form-data">
     (1)action: 表单提交给服务器的哪个资源处理
       "login" 为在 web.xml 中配置的 url-pattern 或者是 jsp、html 文件等。
     (2)Get vs. Post方法的比较(使用Http Monitor) 
       GET---->通过 URL 提交表单信息，由于受到 URL 长度的限制,只能传递大约 1024(1K)字节。
          通过 http monitor 工具截获请求信息(下面仅写出请求行，请求首部略)：
          GET /welcome/login.html?username=zhangsan&password=lisi HTTP/1.1 
          //GET是请求方式； /welcome/login.html是请求路径； ?号后面是参数列表，以&分隔； 最后是协议版本
       POST--->通过 Http Body 提交表单信息，传输的数据量大，可以达到 2M。
          由请求行、请求首部、消息体 三部分组成。数据包的形式发送。
          参数放在消息体中，长度不再受限，更安全；而 GET 必须把参数放在请求行。
          通过 http monitor 工具截获请求信息(大略)：
          POST /welcome/login.html HTTP/1.1     //请求行
          Accept: ...
          Accept-Language: zh-cn,en-us;q=0.5
          .....
          Host: 127.0.0.1
          .....                                 //从请求行以下到这行，都是请求首部
          username=zhangsan&password=zhangsan   //消息体(有效负载) 
       enctype: multipart/form-data ：在form中设置此属性后，传输的就是二进制数据，常可用于上传文件

5.如何在服务器端获得表单提供的数据
  1)HttpServletRequest 对象
    由 Web Container 封装了用户的 Http 请求数据包而生成，可通过它获得所有跟用户请求数据报相关的信息。
    getProtocol():String                     ——返回对应的协议       (如：HTTP/1.1) 
    getMethod():String                       ——返回 http 对应的方法 (Get|Post) 
    getRemoteHost():String                   ——返回远程主机名       (如：127.0.0.1) 
    getRemotePort():int                      ——返回远程端口号       (如：55013) 
    getHeader(String config):String          ——返回http对应的首部信息(参数如Accept-Language) 
    getParameter(String name):String         ——返回指定参数(name)的值(value)   (如：zhangsan) 
    getParameterValues(String name):String[] ——返回指定输入参数(名为 name)的所有值(输入的参数列表) 
    getParameterNames():Enumeration          ——返回请求对象中全部输入参数的名称
                                               (如：java.util.Hashtable$Enumerator@1ff395a) 
  2)解决 Servlet 的中文乱码问题
    (1)响应输出静态页面时，处理中文信息乱码： response.setContentType("text/html; charset=utf-8");
    (2)获取数据过程中，处理中文输入乱码(3 种方法):
       方法一：设置字符编码来解决 post 方法提交表单中文乱码问题。
             request.setCharacterEncoding("gbk"); 
             response.setContentType("text/html;charset=utf-8");
             必须在第一个 request.getParameter("name"); 之前执行上面的语句。
       方法二：重新生成指定编码的字符串
             String name = new String(request.getParamete("name").getBytes("iso-8859-1"));
       方法三：修改服务器的编码设置——解决 get 方法提交表单中文乱码问题
             例如：Tomcat，通过修改%TOMCAT%/conf/server.xml
             加入 URIEncoding="utf-8"
    (3)静态 html 页面的中文化问题
       <head>
            <meta http-equiv="content-type" content="text/html; charset=gbk">
       </head>

6.请求路径
  请求路径是把请求导向到一个 servlet 来响应服务。它是由几个重要的部分来组成的。
  通过 HttpRequest 对象，暴露了如下信息(对照应用的目录结构)：
  1)上下文路径(Context Path) 
    该路径的前缀是和 ServletContext 相关的。
    如果 Context 就是 Web 服务器的 URL 命名空间的缺省的根上下文时，那么上下文路径将会是一个空的字符串。
    如果上下文并不是服务器的命名空间的根，则上下文路径就以“/”开始，但不能以“/”结束。
  2)Servlet 路径(Servlet Path) 
    该路径就是直接与激活该请求的相应映像，它也是以“/”开头。
    但要注意的是，如果指定的请求是与“/＊”模式相匹配，则此时 Servlet 路径就是一个空字符串。
  3)路径信息(PathInfo) 
    请求路径中除了上下文路径和 Servlet 路径以外的部分。
    当没有额外的路径时路径信息就是空的(null)，或者它会以“/”开始的字符串。
  在 HttpServletRequest 接口中定义如下的方法来访问请求路径的相应信息：
    getContextPath();
    getServletPath();
    getPathInfo();
    值得注意的是，请求 URI 和路径的各部分之间的 URL 编码的不同之外，下面的等式恒成立：
    requestURI = contextPath + servletPath + pathInfo








Day2
1.配置开发环境
  如何利用IDE开发(构建)一个web project
  部署web project到Tomcat
    ————结果是把WebRoot下的内容打成包，发布到webapps中
2.在集成环境开发过程中的注意事项
  如果修改了Java文件(修改了方法签名除外)，无需重启，也无需重部署
  如果修改了html文件，无需重启，但需要重部署
  修改了web.xml，系统会自动重部署

3.Servlet的生命周期
  生命周期有哪几个过程(4个)?
  每个过程都对应有特殊的生命周期方法
    装载&实例化————构造方法
    初始化————————init()       只调用一次，并且在service()之前完成
    处理请求———————service()   处理客户的请求，每个请求都在单独的线程中完成，可多次调用
    销毁——————————destroy()   只调用一次，通常在停止WEB应用或者是Web应用重启时

  1)实例化(两种时机)：
    A.配置了<load-on-startup>元素，启动应用时实例化
      其中，配置数值建议从1开始计数，值越小，载入的优先级越高。
      优先级提倡从1开始，1以下的数字，有些容器不理会。负数则被认为是“默认”。
    B.如果没有配置，则在第一次请求时才实例化
  2)初始化——init()/init(ServletConfig config) 
    实例化之后，容器马上调用init()方法来初始化。
    对 Servlet 将要使用的资源作初始化,如读入配置文件信息等(只执行一次)。
    在初始化过程中，容器会创建 ServletConfig 对象并把它作为 init 方法的参数传入。
    该配置对象允许 servlet 从访问 Web 应用的配置信息中读取出初始化参数的名-值对。
    Servlet 提供2个初始化方法：  init()  和  init(ServletConfig config) 。
  3)请求处理——service() 
    初始化后，容器会调用 servlet 的 service()方法，向客户端提供服务
    service()能够被多客户端多次调用(每个请求都要执行一次) 
  4)销毁——destroy() 
    在Web Container停止 Web App 或 WebApp 被停止/reload 时调用此方法。

4.ServletConfig & ServletContext
  1)ServletConfig
    servlet访问配置数据的一个对象，由容器创建，每个servlet独享
    仅对本 servlet 有效，一个 servlet 的 ServletConfig 对象不能被另一个 servlet 访问。
    主要用来读取 web.xml 中配置的Servlet初始信息，不能被其它 Servlet 共享。还可以用于访问 ServletContext。
  2)ServletContext
    ServletContext 是多个 Servlet 共享数据的对象。
    对同一个 Web 应用中的任何 servlet，在任何时间都有效。
    对应整个 Web Application 运行环境，可以用来读取 web.xml 中配置的应用初始信息，写日志，共享数据等
    ServletContext 被所有 Servlet 共享。可以理解为真正意义上的全局对象
  3)如何获取ServletConfig
    A.init(ServletConfig config){.....} 
      容器在Servlet初始化之前已经创建了ServletConfig
      但如果Override此方法，需要记得调用：super.init(config);//其实是调用GenericServlet的init(config) 
      //这里的config只是方法内部的变量。如果其它方法中需调用，还得：this.config=config;给成员变量的config赋值
    B.其它地方(包括在init()方法中)，可以使用Servlet API本身的方法
      this.getServletConfig();  //任何方法中都可以调用，包括init(ServletConfig config)方法
    注：这也是为什么把这个知识点放在这里的原因
  4)如何获取ServletContext
    A.config.getServletContext();//前提是config在之前已获取
    B.Servlet API提供了  this.getServletContext();//没有config也可以用
  5)注意：不能在Servlet中使用this.getServletConfig或者this.getServletContext()来初始化成员变量
    因为创建成员变量优先于构造方法和init方法；而 config 和 context 只有调用了 init 方法之后才初始化
  6)利用ServletContext.log()来写日志
    如：this.log("String"+(new Date()));
  7)例子
    使用ServletContext来获取<context-param>参数
    使用SerlvetConfig来获取Servlet的<init-param>

5.产生动态内容的另一个方面：根据业务逻辑进行请求传递(页面跳转) 
  RequestDispatcher(请求分发器)
    ————forward(request, response)//跳转到其它资源
    ————include(request, response)//包含其它资源
  如何获取RequestDispatcher
    request.getRequestDispatcher(page)
    servletcontext.getRequestDispatcher(page);
    两者之间的区别？(后面会详细讲述)
6.网上书店(打折优惠) 
  SerlvetConfig来获取Servlet的<init-param>
  ServletContext来获取<context-param>参数
  RequestDispatcher进行页面包含








Day3——————访问资源，Servlet如何与数据库构建应用系统
1.两种访问DB的方法
  1)直接连接DB，通过JDBC API
  2)配置Tomcat的连接池
    server.xml配置<Resource>
    web.xml：应用引用资源
    init()：通过JNDI API来获取DB Connection
    两种方法都需要在Servlet的init()方法中，把DB Connection注入到Servlet中

2、用Tomcat的jndi服务获取数据源
    第一步：为 Tomcat 配置连接池：
        修改tomcat/conf/server.xml
        在<host>节点中加入 Resource 配置
        <Context path="/usermanager">            //Web应用的根 
        <Resource 
        name="jdbc/tarena"                       //JNDI名字，用于查找 
        type="javax.sql.DataSource"              //资源类型 
        username="root"
        password="11111111" 
        driverClassName="com.mysql.jdbc.Driver"  //JDBC驱动 
        maxIdle="10"                             //最大空闲连接数
        maxWait="5000"                           //等待时间,配置为-1就是无限等待,直到有空闲连接为止
        url="jdbc:mysql://localhost/tarena"      //连接的 URL 
        maxActive="10"/>
        </Context>
    第二步：在应用中配置资源引用 (此步骤可以省略)
        修改web.xml
        <resource-ref> 
        <res-ref-name>jdbc/tarena</res-ref-name>    //资源引用名 
        <res-type>javax.sql.DataSource</res-type>   //资源的类型 
        <res-auth>Container</res-auth>               //Application 
        <res-sharing-scope>Shareable</res-sharing-scope> //Unshareable 
        </resource-ref>
     第三步：在 Servlet 的 init 方法中通过 JNDI 接口来获取 DataSource
        Context ctx=new InitialContext(); 
        DataSource ds=(DataSource)ctx.lookup("java:comp/env/jdbc/tarena"); 
        Connection con=ds.getConnection();

3.如何构建一个Web应用系统(Servlet + JDBC + DB) 
  分层设计的思想：表示层(view) + Dao层
  Servlet层的设计：
    废弃“为每个请求提供一个Servlet”的做法，引入Action接口与参数控制
  Dao模式
  工厂模式:DaoFactory









day4 会话管理
     Cookie机制  Session机制
   HTTP协议与状态保持：Http是一个无状态协议

1. 实现状态保持的方案：
   1)修改Http协议，使得它支持状态保持(难做到) 
   2)Cookies：通过客户端来保持状态信息
     Cookie是服务器发给客户端的特殊信息
     cookie是以文本的方式保存在客户端，每次请求时都带上它
   3)Session：通过服务器端来保持状态信息
     Session是服务器和客户端之间的一系列的交互动作
     服务器为每个客户端开辟内存空间，从而保持状态信息
     由于需要客户端也要持有一个标识(id)，因此，也要求服务器端和客户端传输该标识，
     标识(id)可以借助Cookie机制或者其它的途径来保存

2. COOKIE机制
   1)Cookie的基本特点
     Cookie保存在客户端
     只能保存字符串对象，不能保存对象类型
     需要客户端浏览器的支持：客户端可以不支持，浏览器用户可能会禁用Cookie
   2)采用Cookie需要解决的问题
     Cookie的创建
       通常是在服务器端创建的(当然也可以通过javascript来创建) 
       服务器通过在http的响应头加上特殊的指示，那么浏览器在读取这个指示后就会生成相应的cookie了
     Cookie存放的内容
       业务信息("key","value") 
       过期时间
       域和路径
     浏览器是如何通过Cookie和服务器通信？
       通过请求与响应，cookie在服务器和客户端之间传递
       每次请求和响应都把cookie信息加载到响应头中；依靠cookie的key传递。

3. COOKIE编程
   1)Cookie类
     Servlet API封装了一个类：javax.servlet.http.Cookie，封装了对Cookie的操作，包括：
     public Cookie(String name, String value)  //构造方法，用来创建一个Cookie
     HttpServletRequest.getCookies()           //从Http请求中可以获取Cookies，返回cookie[]
     HttpServletResponse.addCookie(Cookie)     //往Http响应添加Cookie
     public int getMaxAge()                    //获取Cookie的过期时间值
     public void setMaxAge(int expiry)         //设置Cookie的过期时间值
   2)Cookie的创建
     Cookie是一个名值对(key=value)，而且不管是key还是value都是字符串
        如： Cookie visit = new Cookie("visit", "1");
   3)Cookie的类型——过期时间
     会话Cookie
        Cookie.setMaxAge(-1);//负整数
        保存在浏览器的内存中，也就是说关闭了浏览器，cookie就会丢失
     普通cookie
        Cookie.setMaxAge(60);//正整数，单位是秒
        表示浏览器在1分钟内不继续访问服务器，Cookie就会被过时失效并销毁(通常保存在文件中) 
     注意：
        cookie.setMaxAge(0);//等价于不支持Cookie；

4. SESSION机制
   每次客户端发送请求，服务断都检查是否含有sessionId。
   如果有，则根据sessionId检索出session并处理；如果没有，则创建一个session，并绑定一个不重复的sessionId。
   1)基本特点
     状态信息保存在服务器端。这意味着安全性更高
     通过类似与Hashtable的数据结构来保存
     能支持任何类型的对象(session中可含有多个对象) 
   2)保存会话id的技术(1) 
     Cookie
        这是默认的方式，在客户端与服务器端传递JSeesionId
        缺点：客户端可能禁用Cookie
     表单隐藏字段
        在被传递回客户端之前，在 form 里面加入一个hidden域，设置JSeesionId：
        <input type=hidden name=jsessionid value="3948E432F90932A549D34532EE2394" />
     URL重写
        直接在URL后附加上session id的信息
        HttpServletResponse对象中，提供了如下的方法：
         encodeURL(url); //url为相对路径
        如：http://www.163.com/myApp/Shopping.html;jsessionid=12345

5. SESSION编程
   1)HttpSession接口
     Servlet API定义了接口：javax.servlet.http.HttpSession， Servlet容器必须实现它，用以跟踪状态。
     当浏览器与Servlet容器建立一个http会话时，容器就会通过此接口自动产生一个HttpSession对象
   2)获取Session
     HttpServletRequest对象获取session，返回HttpSession：
       request.getSession();        //表示如果session对象不存在，就创建一个新的会话
       request.getSession(true);    //等价于上面这句；如果session对象不存在，就创建一个新的会话
       request.getSession(false);   //表示如果session对象不存在就返回 null，不会创建新的会话对象
   3)Session存取信息
     session.setAttribute(String name,Object o)  //往session中保存信息
     Object session.getAttribute(String name)    //从session对象中根据名字获取信息
   4)设置Session的有效时间
     public void setMaxInactiveInterval(int interval)
        设置最大非活动时间间隔，单位秒；
        如果参数interval是负值，表示永不过时。零则是不支持session。
     通过配置web.xml来设置会话超时，单位是分钟
        <session-config>
             <session-timeout>1</session-timeout>
        </session-config>
     允许两种方式并存，但前者优先级更高
   5)其它常用的API
     HttpSession.invalidate()     //手工销毁Session
     boolean HttpSession.isNew()  //判断Session是否新建
         如果是true，表示服务器已经创建了该session，但客户端还没有加入(还没有建立会话的握手) 
     HttpSession.getId()          //获取session的id

6. 两种状态跟踪机制的比较
       Cookie                             Session 
    保持在客户端                       保存在服务器端
    只能保持字符串对象                 支持各种类型对象
    通过过期时间值区分Cookie的类型     需要sessionid来维护与客户端的通信
       会话Cookie——负数                Cookie(默认) 
       普通Cookie——正数                表单隐藏字段
       不支持Cookie——0                 url重写


7. RequestDispatcher.forward(req, resp);    vs.   HttpServletResponse.sendRedirect("url");
   请求分发器 rd.forward(req, resp); 只能访问内部资源。浏览器地址不变。针对同一个请求。
      可获取表单传递过来的信息req.getParameter("name");
      应用内部数据共享的方式  req.getAttribute("name");
   复位向 resp.sendRedirect("url"); 可以跨网站访问资源。浏览器地址会改变。变成另外的一个请求。

8. 相对路径 与 绝对路径
   1)形式：
     绝对路径：以/开头的路径
     相对路径：不是以/开头的路径
   2)绝对路径：
     运行在客户端时：请求的参考点是站点(站台)本身；即是 http://localhost:8080/
        如： <form action="/WebTest/login" ...> ...
            路径等于 http://localhost:8080/WebTest/login
     运行在服务器时：请求相对于应用的根 http://localhost:8080/工程/
        web.xml, servlet, jsp... 这些都是运行在服务器端
        如：RequestDispatcher rd = request.getRequestDispatcher(url); //相对路径，也可以绝对路径
           RequestDispatcher rd = servletcontext.getRequestDispatcher(url); //只能绝对路径
   3)相对路径：
     运行在客户端时：请求的参考点是应用的当前路径；即是页面所在的目录 http://localhost:8080/工程/页面所在目录/
        主要用在两处：
        一是表单中的 action="..."  如： <form action="login" ...> ...
            路径等于 http://localhost:8080/工程/页面当前目录/login
        二是在复位向中用 resp.SendRedirect("logon/er.html");
            路径等于 http://localhost:8080/工程/页面当前目录/logon/er.html
     运行在服务器时：都是相对于应用的当前路径；可认为是直接在当前url后面加上相对路径
        如： rd.forward("target");

9. 范围对象   context > session > request > config
   对比HttpSession、HttpServletRequest、ServletContext、ServletConfig的作用范围
   1)ServletConfig：在一个Servlet实例化后，就创建了一个ServletConfig对象。
     主要用来读取web.xml中配置的Servlet初始信息，不能被其它Servlet共享。
     作用范围：处于同一个Servlet中，均起作用。
   2)HttpServletRequest：这是由Web容器对客户Http请求数据封装而成的对象，可通过它获得所有跟客户请求相关的信息。
     比如Http请求方法(Get or Post)。 注意：request是可以跨Servlet的。
     作用范围：只要处于同一个请求中，均起作用。
   3)HttpSession： 当浏览器与Servlet容器建立一个Http会话时，容器就会通过此接口自动产生一个HttpSession对象。
     作用范围：处于同一个会话中，均起作用。(用JsessionId标识同一个会话) 
   4)ServletContext：对同一个Web应用中的任何Servlet，在任何时候都有效，是一个全局的对象。
     作用范围：处于同一个Web应用中，均起作用。(不同的session和请求都可用)     














Day5 
一、 过滤器 Filter
1. why Filter?
   针对通用WEB服务、功能，透明的处理

2. 什么是 Servlet Filter?
     过滤是 Servlet 2.3 版才引入的新特性。过滤器可以认为是实现 Http 请求、响应以及头信息等内容的传送的代码片断。
     过滤器并不能创建响应，但它可以“过滤”传给 servlet 的请求，还可以“过滤”从 servlet发送到客户端的响应；
     它不仅能处理静态内容，还可以处理动态内容。换而言之，filter 其实是一个“servlet chaining”(servlet 链)。
   一个 filter 包括:
    1) 在 servlet 被调用之前截获;
    2) 在 servlet 被调用之前检查 servlet request;
    3) 根据需要修改 request 头和 request 数据;
    4) 根据需要修改 response 头和 response 数据;
    5) 在 servlet 被调用之后截获.

3. 过滤器的生命周期
   Filter 组件的生命周期与 Servlet 的类似。
   过滤器有四个阶段(与servlet类似)：
    1) 实例化;
    2) 初始化(调用init()方法);
    3) 过滤(调用doFilter()方法);
    4) 销毁(调用destroy()方法);

4. Filter编程
   1)定义Filter(implements Filter) 
   2)配置Filter
     配置对哪些资源进行过滤(url) 

     <filter>
        <filter-name>Logger</filter-name>                   //过滤器名
        <filter-class>com.LoggerFilter</filter-class>       //具体过滤器类
        <init-param>                                        //初始化参数
           <param-name>xsltfile</param-name>
           <param-value>/xsl/stockquotes.xsl</param-value>
        </init-param>
     </filter>
     <filter-mapping>                 
         <filter-name>Logger</filter-name>
         <url-pattern>/*</url-pattern> /*将过滤器应用于Web应用中的每个Web资源；可以只指定某个资源*/
     </filter-mapping>

    3)目前<url-pattern>的“*”匹配时，只能用在开头和结尾，中间会出异常，如下用法:
     <url-pattern>*.jsp</url-pattern> //匹配每个jsp页面
     <url-pattern>/admin/*</url-pattern> //匹配项目的admin目录下的所有文件
     <url-pattern>/admin/*.jsp</url-pattern> //发生异常,错误用法

5. FilterChain
   1) chain是如何配置，顺序
      当同一个应用中配置了多个 filter 时，其执行顺序是如何的呢？
      答：按 web.xml 中<filter-mapping>的顺序来执行的
   2) chain.doFilter(req, resp) 
      调用下一个Filter，到最后一个Filter则正式调用 TargetServlet
   3) 调用过程(类似于递归调用) 

6. Filter的类型
   Filter 有4种类型，主要体现在<filter-mapping>中的<dispatcher>属性：
   <dispatcher>REQUEST</dispatcher>       默认,客户端的直接的请求，才触发该过滤器
   <dispatcher>FORWARD</dispatcher>       servlet 调用 rd.forward(req,resp)时触发
   <dispatcher>INCLUDE</dispatcher>       servlet 调用 rd.include(req,resp)时触发
   <dispatcher>ERROR</dispatcher>         发生错误，跳转到错误页面时触发

二、监听器 Listener
    Listener 是 Servlet 的监听器，它可以监听客户端的请求、服务端的操作等。通过监听器，可以自动激发一些操作。
    如：监听在线的用户数量。当增加一个session时，就激发sessionCreated(HttpSessionEvent se)，给在线人数加1
1. 监听器的种类
   一共分三大类型，有 8 种 listener：
    a.监听 servlet context
      1)生命周期事件
        接口： javax.servlet.ServletContextListener
        内容： servlet 上下文已经被创建，并且可以用来向其第一个请求提供服务，或者 servlet 上下文即将关闭
      2)属性的改变
        接口： javax.servlet.ServletContextAttributeListener
        内容： 在 servlet 上下文中，增加、删除或者替换属性
    b.监听 servlet session
      1)生命周期事件
        接口： javax.servlet.http.HttpSessionListener
        内容： 对一个 HttpSession 对象进行创建、失效处理或者超时处理
      2)属性改变
        接口： javax.servlet.http.HttpSessionAttributeListener
        内容： 在 servlet 会话中，增加、删除或者替换属性
      3)会话迁移
        接口： javax.servlet.http.HttpSessionActivationListener
        内容： HttpSession 被激活或者钝化
      4)对象绑定
        接口： javax.servlet.http.HttpSessionBindingListener
        内容： 对 HttpSession 中的对象进行绑定或者解除绑定
    c.监听 servlet request
      1)生命周期
        接口： javax.servlet.ServletRequestListener
        内容： 一个 servlet 请求开始由 web 组件处理
      2)属性改变
        接口： javax.servlet.ServletRequestAttributeListener
        内容： 在 ServletRequest 中，增加、删除或者替换属性




摘录：
    1.项目配置
      1) 在 %catalina_home%/conf/server.xml 文件中
        可配置项目的信息,如 <Server><Service><Engine><Host> 里面配置 <Context> 来设定项目的JNDI和项目指向路径,如下:
        <Context path="/culture" docBase="D:/workspace/culture/WebRoot" reloadable="true"/>
            <Resource name="jdbc/ftcpool" auth="Container" type="javax.sql.DataSource"
                           maxActive="100" maxIdle="30" maxWait="10000"
                           username="root" password="root" driverClassName="com.mysql.jdbc.Driver"
                           url="jdbc:mysql://192.168.0.10:3306/ftc?characterEncoding=UTF-8&amp;characterSetResults=UTF-8&amp;zeroDateTimeBehavior=convertToNull"/>
        </Context>
        上面的参数说明: 
          path: 指定项目名称,发布时访问地址为: http://localhost:8080/culture
          docBase: 指定项目地址,这里指向eclipse工作目录,以便修改
                   默认为项目名,即指向 %catalina_home%/webapps/项目名
          reloadable: 为true时,每当 .class 文件修改都会重启项目，让更新的内容生效; 默认为false
          <Resource>: JNDI信息

      2) 如果不希望修改 %catalina_home%/conf/server.xml 文件,
	     可以在 %catalina_home%/conf/Catalina/localhost/ 目录下，建立一个“项目名.xml”的文件来写上面的项目信息
		 如 culture.xml 的内容:
		 <?xml version='1.0' encoding='utf-8'?>
		 <Context docBase="D:/workspace/culture/WebRoot" path="/culture" reloadable="true">
            <Resource name="jdbc/ftcpool" auth="Container" type="javax.sql.DataSource"
                           maxActive="100" maxIdle="30" maxWait="10000"
                           username="root" password="root" driverClassName="com.mysql.jdbc.Driver"
                           url="jdbc:mysql://192.168.0.10:3306/ftc?characterEncoding=UTF-8&amp;characterSetResults=UTF-8&amp;zeroDateTimeBehavior=convertToNull"/>
		 </Context>











