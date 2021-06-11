
JSP 定义：
    1)Java Server Page, Java EE 组件，本质上是 Servlet。
    2)运行在 Web Container.接收 Http Request,生成 Http Response(默认协议是 Http 请求和响应)
    3)JSP 使得我们能够分离页面的静态 HTML 和动态部分——我们需要的技术。
    4)使页面可以混和html代码、Java代码以及JSP标签；允许访问组件

Servlet的缺陷(JSP出现的原因)：
    1)写静态页面必须部署后才能看到效果，很难控制页面的外观。
    2)从技术角度来说Servlet是Java代码和HTML静态代码的混合代码。
    3)从市场竞争角度来说，微软推出了ASP产品。

JSP的改进：
    1)JSP是标签式的文本文件(区Servlet是Java文件)
    2)JSP不需要编译(其实是由服务器监测JSP文件的变化，再将其翻译成 Servlet 代码)
    服务器对其进行编译并在第一次请求时创建一个Servlet实例。所以，第一次访问JSP页面时会后延迟
    3)JSP不用写配置文件
    4)JSP以静态代码为主，Java代码为辅。Servlet反之。
    5)是J2EE蓝图的一部分(Servlet、JSP以及EJB是J2EE的三大组件)
    JSP从本质上来说内核还是Servlet，但与Servlet不是替代关系而是一种互补的关系。
    JSP适合于写显示层的动态页面，而Servlet则适合写控制层的业务控制(页面转发)。
    JSP往纯标签方向发展，Servlet往纯代码方向发展，他们以Servlet内核(请求响应式的工作方式)往两个方向发展。


基本语法
一、JSP的声明(statement)
   用来定义在产生的类文件中的类的属性和方法(成员变量)。可声明类(即是内部类)。
   由于servlet是工作在多线程环境下，所以尽量不要在service方法体外声明成员变量。
   <%!.....%>  //声明时要加"!"，属于类成员，最先加载，可写于任何位置；不加则是脚本的局部变量，必须调用前写。能用局部变量则不要声明为成员变量。
   如：  <%!String hello="Hello, World!";%>  //变量的声明
        <%=hello%>   //变量的调用
        <%! private int counter=0;  public int count(){ return ++counter;} %> //函数的声明
        <h1><%=count()%></h1> //函数的调用

   声明规则：
    1) JSP中声明的变量和方法对应于Servlet中的实例方法和实例变量。这些将被同时请求该页面的所有用户所共享;
    2) 在使用变量或方法前须先定义(不是说声明变量的位置在页面中要处于使用变量的前面，而是指变量不声明不能使用);
    3) 声明的变量或方法的作用域为当前页面或包含的页面;
    4) 语句间以分号分隔。

二、JSP代码段(Scriptlet)
      <% java代码 %>
   是一段可以在处理请求时间执行的Java代码。可以产生输出，也可以是一些流程控制语句。
   在代码段中定义的变量为service方法中的局部变量。
   1._jspService()中的局部代码：
      <%  System.out.println("Hi,I like JSP."); %>   //在控制台打印出，网页上没显示
      <%  out.println("Hi,I like JSP."); %>          //打印在网页上
      <%  Connection conn=DriverManager.getConnection();  Statement st=conn.createStatement();
          String sql="select * from users";               ResultSet rs=st.executeQuery(sql);
          //……
       %>
    问：能否在JSP脚本里定义方法？
    答：不能！ //脚本相当于方法，不能在方法里定义方法
       <%!public void helloworld(){}%>  //可以声明方法
       <% public void helloworld(){}%>  //编译出错；脚本不能定义方法
   2.比较:
        <%! int i=100;%>     //成员变量
        <%  int i=101;%>     //_jspService()方法中的局部变量
        <%=i%>  //同一文件里，局部变量优先。范围越小，优先级越高。
   3.脚本小程序规则：
     1) 你使用的脚本语言决定了脚本小程序的规则;
     2) 语句间以分号分隔;
     3) 可以使用默认的对象、import进的类、declaration声明的方法和对象以及useBean tag中声明的对象。

三、JSP表达式(expression)
       <%=……%>   // "="号。一定程度上相当于 out.print();
   在JSP请求处理阶段计算他的值，表达式生成的代码是Service方法中的一个代码片断。
   JSP对于声明的处理：
       1、计算表达式的值
       2、将值转换成String
       3、用out.println发送标签；把数据输出至页面的当前位置
      <%="Hello,JSP world!"%>     //out.println("Hello,JSP world");
      <%=name%>                   //<%!String name="GiGi";%> out.println(name);
      <%=new java.util.Date()%>   //out.println(new java.util.Date());
  表达式规则：
     1) 你使用的脚本语言决定了脚本小程序的规则;
     2) 执行的顺序为从左到右;
     3) 分号不能用于表达式。

四、JSP指令(direction)
   指令用于从JSP发送信息到容器上。用来设置全局变量，声明类，要实现的方法和输出内容等。
   指令在JSP整个文件内有效。它为翻译阶段提供了全局信息。
       <%@......%>  // "@"符号
   指令包括：page、include、taglib
   1.page指令
     页面的语言、内容类型、字符集、页面编码等等，所有的属性都是可选的。
     page详情：
        <%@ page language="java"  extends="package.class" session="true|false"
            import="package.class, package.*, ..."
            buffer="none|default|sizekb"  //默认值是default,定义缓冲区大小至少为8kb
            autoFlush="true|false"        //默认true
            isThreadSafe="true|false"     //默认true
            info="Sample Jsp"             //自己写的，随意吧
            isErrorPage="true|false"      //默认false，只有专处理错误的页面才用true
            errorPage="ErrorPage.jsp"     //出错的处理页面
            contentType="TYPE|TYPE;charset=CHARSET|text/html; charset=ISO-8859-1"
            pageEncoding="default"        //默认default
        %>
       如：<%@page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
     language：java唯一值，表示脚本中使用的编程语言
     contentType：设置了内容的类型和静态页面的编码 (告诉浏览器以什么编码显示)
         默认是: contentType="text/html; charset=ISO-8859-1"
     pageEncoding：页面本身的编码格式 (写页面时用的编码格式)
        上面的代码等价于servlet里： response.setContentType("text/html; charset=gbk");
     import：导入其它的包和类； 其中，JSP默认导入的包是java.lang.*
        <%@page import="java.util.Date"%> //具体的包和类
        <%@page import="java.sql.*"%>     //包下的所有类
        <%@page import="java.util.*, java.io.*, java.net.*"%> //连写，逗号分隔
     Session：指示当前的jsp是否参与会话 (默认为true； 参与会话)
        通过指令使当前页面与session不可会话：    <%@page session="false"%>
        在JSP里，创建session用： session = request.getSession();
        而Servlet里则要写成：  HttpSession session = request.getSession();
        //上面两句效果一样。如果是第一次访问，就创建一个session对象。
        session="true"时，可用内建对象session直接访问会话，例如：
        <%  session.setAttribute("username","holemar");
            String name = (String)session.getAttribute("username"); %>
        <%=name%>
     errorPage：
        isErrorPage：Jsp页面中出现异常的处理方式
        对于有可能出现异常的页面：
            <%@page errorPage="error.jsp"%> //异常时会跳转到处理异常的页面；这页面自己写
            在有可能异常的地方打印原因：  throw new Exception("数据库连接出错");
        对于处理异常的页面(error.jsp)里：
            <%@page isErrorPage="true"%>，其中使用<%=exception.getMessage() %>把异常信息打印出来
     isThreadSafe——此属性已经不再使用(已废弃)
        当前Jsp页面是否线程安全    default--->true
        <%@page isThreadSafe="true"%>  //普通的Servlet,可以并发处理用户请求
        <%@page isThreadSafe="false"%> //相当于Servlet实现了SingleThreadModel

   2.include指令
        把目标页面的内容包含到当前页面,产生页面叠加以后的输出效果 //相当于将两个页面合并；编译时就包含进来
        <%@include file="foot.jsp"%> //可插入任意位置

   3.taglib指令
        留在JSTL里讲解。


五、JSP中的注释
   1.java格式注释
      编译器会忽略掉此类注释中的内容(客户端的源码看不见)
      <%-- JSP注释；可多行 --%>
      <%// java 单行注释 %>
      <%/* java multi lines comments */%>
      <%/**java 特有的注释*/%>
   2.html风格注释
      编译器会执行此类注释中的代码(客户端的源码看得见)
      <!-- html风格注释 -->  等价于out.println("<!-- html风格注释 -->")
      这种注释方式不好的地方就是当页面注释信息太多的时候会增大服务器的负荷。
      还有注释信息需要在网络上传输，从而降低效率；内部程序员的测试数据一般不能写在这种注释中，以免泄露。

六、动作(Action)
    <jsp:actionName attributeName=attributeValue/>
   JSP的动作包括：
     forward、include、useBean、setProperty、getProperty
   1.forward动作
     形式：<jsp:forward page="another.jsp"/>
          等价于 Servlet中通过RequestDispatcher.forward();
     可以传参数
         <jsp:forward  page="another.jsp">
            <jsp:param name="name" value="holemar"/>
            <jsp:param name="age" value="20" />
         </jsp:forward>

   2.Include动作
     形式：<jsp:include page="another.jsp"/>
          等价于 Servlet中通过RequestDispatcher.include();
      Include动作也可以传参数
          <jsp:include  page="b.jsp" flush="true">
             <jsp:param name="name" value="narci"/>
          </jsp:include>
      与<%@include file=""%>比较：
         include动作在运行期处理(include指令编译期)，jsp:include包含的是所包含URI的响应，而不是URI本身。
         这意味着：jsp:include 对所指出的 URI 进行解释，因而包含的是生成的响应。
         对于页面是静态内容，这没有太大的关系。但如果是动态内容，include动作可传参数。
      flush 属性
         flush 指示在读入包含内容之前是否清空任何现有的缓冲区。
         JSP 1.1 中需要 flush 属性，因此，如果代码中不用它，会得到一个错误。
         但是，在 JSP 1.2 中， flush 属性缺省为 false。
         建议：由于清空大多数时候不是一个重要的问题，因此，对于 JSP 1.1，将 flush 设置为 true；
              而对于 JSP 1.2 及更高版本，将其设置为 false 或不设置(用默认值)。

   3.plugin
     <jsp:plugin>可让JSP在用户端页中包含一个bean或一个applet。
     <jsp:plugin type="bean|applet"      code="class"
                 name="instanceName"     codebase="classDirectory"
                 archive="archiveURI"    align="bottom|top|middle|left|right"
                 height="inPixels"       hspace="leftRightPixels"
                 jreversion="1.2|number" vspace="topBottomPixels"
                 nspluginurl="pluginURL" iepluginurl="pluginURL" >
        <jsp:params>
            <jsp:param name="parameterName" value="parameterValue" >
        </jsp:params>
        <jsp:fallback>Problem with plugin</jsp:fallback>
     </jsp:plugin>

   4.接收 jsp动作的参数跟平常的页面传参一样，内容如:
      <%@ page language="java" pageEncoding="UTF-8"%>
      <%
        String name = request.getParameter("name");
        out.println(name);
      %>



JSP的生命周期
    1) 每一个JSP都会对应有一个servlet生成
    2) 在 %tomcat%/work/Catalina/localhost/工程名/org/apache/jsp 目录下可找到对应生成的 Servlet 文件
    3) 一般而言，每一个JSP对应的servlet都有如下的生命周期方法：

一、 _jspInit()方法
    JSP容器第一次装载jsp文件时调用一次
    public void _jspInit(){……}

二、 _jspService()方法
    每当服务器接收到对该jsp的请求，都需要调用一次该方法一次。
    public void _jspService(HttpServletRequest request, HttpServletResponse response)
       throws java.io.IOException, ServletException { ……}

三、 _jspDestroy()方法
    jsp文件被修改时，JSP容器会销毁旧的jsp文件对应的对象，重新装载一次更新后的jsp文件的内容(只调用一次)。
    public void _jspDestroy(){……}


JSP处理过程：JSP源文件处理分成二个阶段：
    1) JSP页面转换阶段：
       页面被编译成一个Java类，所有的HTML标记和JSP标记都被转换创建一个Servlet。这时，脚本和表达式还没有被执行;
    2) 请求处理阶段：发生在服务器，将一个客户端请求指向JSP页面。
       一个请求对象创建、解析以及提交给编译好的JSP对应的servlet。
       当这个servlet处理请求的时候它执行先前在JSP中定义的处理脚本小程序和表达式。

使用脚本代码的缺点和指导方针
    1) 缺点：
       a. 过度使用脚本代码使用JSP页面混乱和难以维护;
       b. 脚本代码降低JSP二个主要的优点：软件重用和代码分开
    2) 指导方针：只在组件功能无能为力或需要有限的脚本时使用。





  POJO： Plain Old Java Object  --> 简单传统的Java对象
  Java Bean： 组件、构件的规范(属性，提供get/set方法；还可包含其它方法)
JSP调用JavaBean
  通过引入JavaBean，JSP才能较好的把页面展示与业务逻辑分离。
  其中，业务逻辑放到后台的Java Bean中，减少JSP中的脚本代码，有利于程序的可维护性与可重用性。
一、Java Bean
     a.无参构造器(也是默认的构造方法)
     b.标准的getter、setter方法
     c.如要进行网络传输(支持RMI)，需实现Serializable接口
二、如何在JSP中使用JavaBean？
   1.定义Java Bean， <jsp：useBean>标签
        如果有一个指定类别的bean存在的话，便会以id来参照它，不然就是为它创建一个实例。
     形式：<jsp：useBean id = "Bean在页面的名字" sope="范围域" typeSpecification >
        有许多方式可以指定bean的类型：
           claee="package.class"
           type="typeName"
           claee="package.class"  type="typeName"
           beanName="beanName"    type="typeName"
           //beanName是这个bean的名称。typeName为id属性所定义的scripting变量的类，也就是bean实例的类。

     id   ——声明bean对象的标识符，方便其它地方使用
     class——bean对象的类型，注意要使用完全限定名
     cope——java bean对象的共享范围(page、request、session、application)
           page:当前页面范围(范围最小，生命周期最短)
           request:同一个请求范围 (forward,include)
           session:同一个会话(30分钟不使用，会自动结束)
           application:同一个应用(范围最大，生命周期最长)  ServletContext
     例如：  SuperGirl <jsp:useBean id="girl" class="com.tarena.vo.SuperGirl" scope="session"/>
     等价于：<% SuperGirl girl=(SuperGirl)session.getAttribute("girl");
           if(girl==null){
              girl = new SuperGirl(); //对应 id 和 class
              session.setAttribute("girl",girl);  //对应 scope 的值
           } %>
     可以用表达式获得bean的值：  <%=girl.getName();%>

   2.对JavaBean的属性赋值，<jsp:setProperty>标签
     形式：<jsp:setProperty name="JavaBean在页面的名字" property="JavaBean属性名" value="属性值"/>
        例子：   <jsp:setProperty name="girl" property="name" value="Lily"/>
        等价于： <% girl.setName("Lily");%>
     可以嵌套JSP表达式：
        <jsp:setProperty name="girl" property="name" value='<%=request.getParameter("name")%>'/>
     Java Bean中的属性名与form中输入域的名字保持一致的话，可以使用通配符*，一次设置所有字段的值。
        <jsp:setProperty name="" property="*"/>

   3.获取JavaBean的属性值，<jsp:getProperty>标签
     形式：<jsp:getProperty name="Bean在页面的名字" property="属性名"/>
        name：标识具体的Bean对象，这与<jsp:useBean>标准动作中的id值相匹配
        property：标识属性中的标识符。
     另外，由于<jsp:setProperty>标签和<jsp:getProperty>标签只对应javaBean的setter和getter方法，所以取得的属性并不一定要是bean的属性，只要是对应setter和getter方法的名称就行了。

JSP中的异常处理
一、try/catch/finally/throws/throw
    // 在局部代码里处理异常。
二、errorPage, isErrorPage
    // 在整个页面处理异常。
   1.errorPage
     形如： <%@page errorPage="error.jsp"%>
     表示：需要错误处理的页面
   2.isErrorPage
     形如： <%@page isErrorPage="true"%>
     指示：错误页面。其中，有一个隐式对象exception可用： <%=exception%>
          产生(隐含)内建对象exception,可通过它获得异常信息
          <%=exception.getMessage() %> //把异常信息打印出来
三、声明的方式处理异常
    // 在整个应用处理异常。(范围比前两种更大)
   1.配置： 在web.xml进行配置异常处理
      ……
      <error-page>
           <exception-type>java.lang.ArithmeticException</exception-type>
           <location>/MathError.jsp</location> //当发生上述异常时，跳转到这页面
      </error-page>
      <error-page>
           <error-code>404</error-code>
           <location>/404.jsp</location>  //当发生404错误时，跳转到 404.jsp 页面
      </error-page>
      <!-- 捕获所有页面的出错 -->
      <error-page>
           <exception-type>java.lang.Exception</exception-type>
           <location>/ErrorPage.jsp</location>
      </error-page>
      ……
   2.复习：Java中的异常——有2种
     受查异常(Checked Exception)
     非受查异常(Unchecked Exception)  Java中的RuntimeException及其子类是不需要处理的(try/catch)
        因为所有的RuntimeException总是可以通过优化代码来避免，因此，这种异常被称为"Unchecked Exception"。
   3.思考：
     三种异常处理方式同时启动用，那个优先级高？ 作用域越小，优先级越高。
   注意：要使得页面自动跳转到错误页面，必须关闭浏览器的"显示友好HTTP错误信息"选项。
      public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException { /*只处理这两种兼容的异常*/ …… }


安全的系统(企业级应用)：
   1.身份认证(合法用户)  --登录
   2.授权(静态)        --定义权限
   3.访问控制(动态)     --比较
   4.安全审计(日志)     --修复bug (只有敏感的部门需要)
JAAS实现安全
   JAAS——Java Authentication and Authorization Service
   (Java认证(Authentication)与授权(Authorization)服务)
   是Java EE规范之一，实现Java EE应用程序安全性的一个重要途径
   (要求：会使用，不必深入理解)
一、网络安全的4大要素
   认证——抵御假冒者(用户身份的合法性)
   授权——合法用户拥有的权限
   机密性——防止关键数据落入其它人手中
   数据完整性——抵御窃听者(篡改私有数据)
二、对于Http应用是如何进行认证的(Web端的认证方法)？
   四种安全认证： (http协议)basic, form, digest, certificate(证书) + ssl
   HttpMonitor监控受限资源的访问
三、容器是如何完成认证与授权的呢？
   图示(容器做了些什么事情)
   (容器的角度)
四、声明式安全以及分工
   Servlet的开发者
   应用的管理员
   部署人员

五、实战
  1.定义新用户与角色
    在Tomcat服务器中定义：    %TOMCAT_HOME%/conf/tomcat-user.xml
     <?xml version='1.0' encoding='utf-8'?>
     <tomcat-users>
        <role rolename="manager"/>
        <role rolename="admin"/>
        <user username="holemar" password="123" roles="admin,manager"/>
        <user username="lily" password="iloveyou" roles="manager"/>
     </tomcat-users>
    为什么tomcat可以使用tomcat-users.xml作为它保存用户和角色信息的文件？原因是在server.xml中，有以下配置：
     <Resource name="UserDatabase" auth="Container"  type="org.apache.catalina.UserDatabase"
         description="User database that can be updated and saved"
         factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
         pathname="conf/tomcat-users.xml" />
     在DD中指定角色，则需在 web.xml 中配置：
     <security-role>
        <description />
        <role-name>admin</role-name>
     </security-role>
   2.声明安全性约束(指明受限资源)
     在DD中加入<security-constraint>元素，其中包含了：
       Web资源集合：<web-resource-collection>
       其中包含了url资源以及http方法。
     授权约束：<auth-constraint>

     项目的web.xml的 <web-app> 标签里面写:
      <security-constraint>
        <display-name>Constraint-all</display-name>
        <web-resource-collection>
           <web-resource-name>all-resources</web-resource-name>
           <description />
           <url-pattern>/admin/*</url-pattern>    //被限制访问的目录或文件
           <url-pattern>/security/*</url-pattern>
           <http-method>GET</http-method>         //被限制访问的方式
           <http-method>POST</http-method>
        </web-resource-collection>
        <auth-constraint>                         //能访问受限资源的角色,不写这个则不受限制
           <description />
           <role-name>admin</role-name>           //能访问受限资源的角色
        </auth-constraint>
      </security-constraint>

     要注意的规则：
      不要认为：资源本身受到约束；其实，是资源 + Http方法组合受到约束
      如果配置中不指定<http-method>，说明所有的方法(Get,Post,Trace,Head,Delete,Put,Options等)都受约束；
      当指定了具体的<http-method>，那么约束只针对该方法，其它的http方法都不在约束之内；
      <auth-constraint>定义的是哪些角色可以做出受约束的请求；而不是定义访问<web-resource-collection>
      没有<auth-constraint>：任何角色都能访问；   空的<auth-constraint />任何角色都不能访问；
      对于不同的<security-constraint>，指定的url资源<url-pattern>在相同方法上定义了不同的<auth-constrain>，则存在合并规则。

     问题：为什么要设置<auth-constraint />元素，使得任何角色的任何人都不能访问受限资源呢？其意义何在？
        为了保护资源，只允许内部跳转去访问

   3.选择认证方式
     如果是BASIC认证：则无需指定Form表单的action。
     <login-config>
         <auth-method>BASIC</auth-method>
         <realm-name>UserDatabaseRealm</realm-name>
     </login-config>
     如果是FORM认证：
     <login-config>
       <auth-method>FORM</auth-method>
       <form-login-config>
          <form-login-page>/logon/loginForm.jsp</form-login-page>
          <form-error-page>/logon/loginErrorForm.jsp</form-error-page>
       </form-login-config>
     </login-config>

     对于Form表单认证
      action的值，用户名、密码字段的名称都是固定的(规范)
      <form method="POST" action="j_security_check">
        <input type="text" name="j_username">
        <input type="password" name="j_password">
        <input type="submit" value="Submit" name="B1">
      </form>
     标准的表单提交(固定不变)：
      action：j_security_check
      name:j_username
      password:j_password











内容要点： 1.隐含对象 2.欢迎文件 3 MVC
/********************************************************************************************/
一、隐含对象
 1.什么是隐含对象(9个)？
   ————JSP中的隐含对象:不用我们手工去创建的对象
   类型                    对象名            功能
   ---------------------------------------------------------------------
   JspWriter              out              往浏览器写内容
   HttpServletRequest     request          Http请求对象.
   HttpServletResponse    response         Http响应对象
   PageContext            pageContext      JSP的页面上下文
   HttpSession            session          会话对象
   ServletContext         application      应用上下文
   ServletConfig          config           JSP的ServletConfig
   Object                 page             页面实现类的对象(例如：this)
   Exception              exception        含有指令<%@page isErrorPage="true"%>

 2.范围对象
   其中，有4个是范围对象： pageContext,request,session,application
   对应<jsp:useBean/>指令的scope分别是：page,reqeust,session,application
   也就是说，指定不同scope的bean对象(Java Bean)会被绑定到不同的范围对象中
   // 选择范围对象的原则：作用域的范围越小越好；因为作用域小的生命周期短，有利于性能提高。
   例如：<jsp:useBean id="stu" class="vo.Student" scope="page"/>
   表示stu对象被绑定到javax.servlet.jsp.PageContext对象(pageContext)中，其等价的代码
   <%    Student stu = pageContext.getAttribute("stu");
         if(stu==null) {
          stu=new Student();
          pageContext.setAttribute("stu",stu);
   }%>

   1)pageContext对象：
     每一个jsp页面对应着一个pageContext。一般地，在实际应用中，主要是使用它来存取属性。
     另外，pageContext对象能够存取其它隐含对象。
    a.pageContext对象存取其它隐含对象属性的方法，此时需要指定范围的参数。
      Object getAttribute(String name, int scope)
      Enumeration getAttributeNamesInScope(int scope)
      void removeAttribute(String name, int scope)
      void setAttribute(String name, Object value, int scope)
     其中，范围参数有四个，分别代表四种范围：
      PAGE_SCOPE、REQUEST_SCOPE、SESSION_SCOPE、APPLICATION_SCOPE
    b.PageContext对象取得其它隐含对象的方法
      Exception getException()           回传目前网页的异常，不过此网页要为error page，
      JspWriter getOut()                 回传目前网页的输出流，例如：out
      Object getPage()                   回传目前网页的Servlet 实体(instance)，例如：page
      ServletRequest getRequest()        回传目前网页的请求，例如：request
      ServletResponse getResponse()      回传目前网页的响应，例如：response
      ServletConfig getServletConfig()   回传目前此网页的ServletConfig 对象，例如：config
      ServletContext getServletContext() 回传目前此网页的执行环境(context)，例如：application
      HttpSession getSession()           回传和目前网页有联系的会话(session)，例如：session
    c.PageContext对象提供取得属性的方法
      Object getAttribute(String name, int scope)    回传name 属性(范围为scope；类型为Object)
      Enumeration getAttributeNamesInScope(int scope)
                                       回传所有属性范围为scope 的属性名称，回传类型为Enumeration
      int getAttributesScope(String name)回传属性名称为name 的属性范围
      void removeAttribute(String name)  移除属性名称为name 的属性对象
      void removeAttribute(String name, int scope)   移除属性名称为name，范围为scope 的属性对象
      void setAttribute(String name, Object value, int scope)
                                       指定属性对象的名称为name、值为value、范围为scope
      Object findAttribute(String name)  寻找在所有范围中属性名称为name 的属性对象

   2)request 对象
     request 对象包含所有请求的信息，
     如：请求的来源、标头、cookies和请求相关的参数值等等。
     request 对象实现javax.servlet.http.HttpServletRequest接口的，
     所提供的方法可以将它分为四大类：
     (1)储存和取得属性方法；
      void setAttribute(String name, Object value)      设定name属性的值为value
      Enumeration getAttributeNamesInScope(int scope)   取得所有scope 范围的属性
      Object getAttribute(String name)   取得name 属性的值
      void removeAttribute(String name)  移除name 属性的值
     (2)取得请求参数的方法
      String getParameter(String name)   取得name 的参数值
      Enumeration getParameterNames()    取得所有的参数名称
      String [] getParameterValues(String name)    取得所有name 的参数值
      Map getParameterMap()              取得一个要求参数的Map
     (3)能够取得请求HTTP 标头的方法
      String getHeader(String name)      取得name 的标头
      Enumeration getHeaderNames()       取得所有的标头名称
      Enumeration getHeaders(String name) 取得所有name 的标头
      int getIntHeader(String name)      取得整数类型name 的标头
      long getDateHeader(String name)    取得日期类型name 的标头
      Cookie [] getCookies()             取得与请求有关的cookies
     (4)其它的方法
      String getContextPath()            取得Context 路径(即站台名称)
      String getMethod()                 取得HTTP 的方法(GET、POST)
      String getProtocol()               取得使用的协议 (HTTP/1.1、HTTP/1.0 )
      String getQueryString()            取得请求的参数字符串，不过，HTTP的方法必须为GET
      String getRequestedSessionId()     取得用户端的Session ID
      String getRequestURI()             取得请求的URL，但是不包括请求的参数字符串
      String getRemoteAddr()             取得用户的IP 地址
      String getRemoteHost()             取得用户的主机名称
      int getRemotePort()                取得用户的主机端口
      String getRemoteUser()             取得用户的名称
      void getCharacterEncoding(String encoding)    设定编码格式，用来解决窗体传递中文的问题

    3)session 对象
     session对象表示目前个别用户的会话(session)状况。
     session对象实现javax.servlet.http.HttpSession接口，HttpSession接口所提供的方法
      long getCreationTime()             取得session产生的时间，单位是毫秒
      String getId()                     取得session 的ID
      long getLastAccessedTime()         取得用户最后通过这个session送出请求的时间
      long getMaxInactiveInterval()      取得最大session不活动的时间，若超过这时间，session 将会失效
      void invalidate()                  取消session 对象，并将对象存放的内容完全抛弃
      boolean isNew()                    判断session 是否为"新"的会话
      void setMaxInactiveInterval(int interval)
                                       设定最大session不活动的时间，若超过这时间，session 将会失效
    4)application对象
     application对象最常被使用在存取环境的信息。
     因为环境的信息通常都储存在ServletContext中，所以常利用application对象来存取ServletContext中的信息。
     application 对象实现javax.servlet.ServletContext 接口，ServletContext接口容器所提供的方法
      int getMajorVersion()              取得Container主要的Servlet API版本
      int getMinorVersion()              取得Container次要的Servlet API 版本
      String getServerInfo()             取得Container的名称和版本
      String getMimeType(String file)    取得指定文件的MIME 类型
      ServletContext getContext(String uripath)        取得指定Local URL的Application context
      String getRealPath(String path)    取得本地端path的绝对路径
      void log(String message)           将信息写入log文件中
      void log(String message, Throwable throwable)    将stack trace 所产生的异常信息写入log文件中

 3.其它对象：
    1)page 对象
     page对象代表JSP本身，更准确地说page对象是当前页面转换后的Servlet类的实例。
     从转换后的Servlet类的代码中，可以看到这种关系： Object page = this;
     在JSP页面中，很少使用page对象。
    2)response 对象
     response 对象主要将JSP 处理数据后的结果传回到客户端。
     response 对象是实现javax.servlet.http.HttpServletResponse 接口。response对象所提供的方法。
    a.设定表头的方法
      void addCookie(Cookie cookie)                新增cookie
      void addDateHeader(String name, long date)   新增long类型的值到name标头
      void addHeader(String name, String value)    新增String类型的值到name标头
      void addIntHeader(String name, int value)    新增int类型的值到name标头
      void setDateHeader(String name, long date)   指定long类型的值到name标头
      void setHeader(String name, String value)    指定String类型的值到name标头
      void setIntHeader(String name, int value)    指定int类型的值到name标头
    b.设定响应状态码的方法
      void sendError(int sc)                       传送状态码(status code)
      void sendError(int sc, String msg)           传送状态码和错误信息
      void setStatus(int sc)                       设定状态码
    c.用来URL 重写(rewriting)的方法
      String encodeRedirectURL(String url)         对使用sendRedirect()方法的URL予以编码
    3)out 对象
     out对象的类型是javax.servlet.jsp.JspWriter，该类从java.io.Writer类派生，以字符流的形式输出数据。
     out对象实际上是PrintWriter对象的带缓冲的版本(在out对象内部使用PrintWriter对象来输出数据)，
     可以通过page指令的buffer属性来调整缓冲区的大小，默认的缓冲区是8kb。
     out 对象能把结果输出到网页上。
     out主要是用来控制管理输出的缓冲区(buffer)和输出流(output stream)。
      void clear( )               清除输出缓冲区的内容
      void clearBuffer( )         清除输出缓冲区的内容
      void close( )               关闭输出流，清除所有的内容
      int getBufferSize( )        取得目前缓冲区的大小(KB)
      int getRemaining( )         取得目前使用后还剩下的缓冲区大小(KB)
      boolean isAutoFlush( )      回传true表示缓冲区满时会自动清除；false表示不会自动清除并且产生异常处理
    4)exception对象
     若要使用exception 对象时，必须在page 指令中设定：<%@ page isErrorPage="true" %>才能使用。
     exception提供的三个方法：
      getMessage()
      getLocalizedMessage()
      printStackTrace(new java.io.PrintWriter(out))
    5)config 对象
     config 对象里存放着一些Servlet 初始的数据结构。
     config 对象实现于javax.servlet.ServletConfig 接口，它共有下列四种方法：
      public String getInitParameter(name)
      public java.util.Enumeration getInitParameterNames()
      public ServletContext getServletContext()
      public Sring getServletName()


例子：
1.范围对象比较
<% pageContext 或request 或session 或application.setAttribute("name", "holemar");
   pageContext.setAttribute("sex", "m");
%>

2.输出对象out
<%out.println("Hello JSP!");%>
<%System.out.println("Hello JSP!");%>
getBufferSize() //tomcat default:12k
getRemaining()
flush()
clearBuffer()

3.request对象
request:
getProtocol()
getMethod()
getHeader("User-Agent")
getCookies()
getRequestURI()
getRequestURL()
getContextPath()
getServletPath()
getPathInfo()
getQueryString()
isRequestedSessionIdFromCookie()
isRequestedSessionIdFromURL()
isRequestedSessionIdValid()
getLocalPort(),getRemotePort()
getRequestDispatcher(),setCharacterEncoding(),getInputStream()

4.session对象
session:
getId()
isNew()
invalidate()
setMaxInactiveInterval(10)


5.响应对象
response:
sendRedirect("third.jsp")
sendError(404, "400 Error!")

6.应用对象
application:
log("some body visit our website...");
getMajorVersion()
getMinorVersion()
getServerInfo()
getRequestDispatcher(),getResourceAsStream(),getInitParameter()

pageContext:
getAttribute("name")

config:
getInitParameter("classNo")
getServletName()

page:
getClass()



/************************************************************************************************/
二、欢迎文件

 1.缺省情况下,一个Web App中的  index.html, index.htm, index.jsp  可作为默认的欢迎文件.
   当用户请求没有指明要访问的资源时,Web Container会用欢迎文件响应客户端请求.
 2.手工设置欢迎文件：
   web.xml
   找welcome.jsp，没找到，继续往下找
   <welcome-file-list>
     <welcome-file>/welcome.jsp</welcome-file>
     <welcome-file>/welcome1.jsp</welcome-file>
     <welcome-file>/welcome2.jsp</welcome-file>
   </welcome-file-list>




三、MVC
 MVC:    Model-View-Controller (用户交互过程：输入、处理、输出)
 WEB应用的MVC；优化Web App的结构,使用MVC模式
 Model 1:    JSP + JavaBean(EJB)
 Model 2:    Servlet + JSP + JavaBean(EJB)------>MVC

体系结构

设计模式
  具体问题提出具体的解决办法

习惯用法











内容要点： 1 实现文件上传  2 数据验证  3 分页实现
/*****************************************************************************************/
一、文件上传
1.表单形式
<form action="" method="POST" enctype="multipart/form-data">
  file:<input type="file" name="file"/><br/>
  <input type="submit"/>
</form>

2.使用HttpMonitor工具：
查看文件上传时，请求的内容。



3.服务器端对上传文件的处理
例子
fileupload
处理步骤(待补充)



知识点：
1)通过HttpServletRequest来传送文件内容
2)处理request头，字符串的分析
3)java.io.File API的使用



*****************************************************************************************
二、数据验证

如何完成Web App中的数据验证工作

1)客户端校验：
输入域不能为空，只能是数字，数据长度大于5等等
JavaScript客户端完成(验证框架，负责客户端方面的验证)

2)服务器端校验：
例如：后台数据库要求提交数据唯一性
Java服务器端完成(没有现成的框架，因为不同的项目有不同的业务规则)


重点：
1)分清楚什么情况下使用客户端校验，什么情况下使用服务器端校验




/***************************************************************************************/
三、数据分页
查询数据库时，如果满足条件的记录很多，该如何返回给页面?
1.客户端分页
  同样地，使用html/javascript等技术处理。甚至可以封装成组件
2.服务器端分页
  非常重要的，在实际项目中非常需要————性能问题。
这需要结合JDBC/Hibernate/TopLink/EJB等技术实现。

查询分页
  1)一次性从数据库中查出所有信息，在内存中作分页(缓存)
      特点：速度非常快,消耗资源大(内存?)

  2)分多次查询数据库，一次查询的数据量就是一个页面可以显示的数据量
      特点：消耗资源少，相对来说速度慢

  3)折衷的方案(一次只取n页，1 < n < 总页数)(部分缓存)
      特点：中庸之道(实现中，置换算法较难)

常见的分页处理方法：定义如下几个参数
rows:数据库表中记录总行数   select count(*) from 表名;
  totalPage：总页数     (导出属性：可以由其它属性计算而得) int totalPage = rows / size + 1;
size：每页显示的记录数目    可定制，可写死
curPageNo：当前页         客户端决定
  startRowNo：当前页在数据库中的起始行号(导出属性)        int startRowNo = (curPageNo -1 ) * size;

练习：
重新改造Usermanager例子中的查询所有的用户的功能(使用分页)



















JSP中的自定义标签：
  1.什么是自定义标签
    1) 用户自定义的Java语言元素, 实质是运行一个或者两个接口的JavaBean;
    2) 可以非常机密地和JSP的表示逻辑联系在一起，又具有和普通JavaBean相同的业务逻辑处理能力;
    2) 当一个JSP页面转变为servlet时，其间的用户自定义标签转化为操作一个称为标签hander的对象;
    3) 可操作默认对象，处理表单数据，访问数据库以及其它企业服务;

  2.自定义标签库的特点
    1) 通过调用页面传递参数实现定制;
    2) 访问所有对JSP页面可能的对象;
    3) 修改调用页面生成的响应;
    4) 自定义标签间可相互通信;
    5) 在同一个JSP页面中通过标签嵌套，可实现复杂交互。

  3.如何使用自定义标签库
    1) 声明标签库
    2) 使标签库执行对Web应用程序可用

  4.声明标签库
    1) 使用taglib指令声明标签库
    2) 语法：<%@taglib uri="URI" prefix="pre" %>
       注意：a. uri属性可以是绝对的，也可以是相对URL，该URL指向标记库描述符(TLD)文件;
             b. uri属性也可以是一个并不存在的URL，该URL为web.xml文件中将标记库描述符(TLD)文件的绝对URL到本地系统的一个映射;
    3) 范例：<%@taglib uri="/WEB-INF/template.tld" prefix="test" %>
             <%@taglib uri="http://java.sun.com/jstl/core" prefix="core" %>

  5.使标签库执行可用
    方式一：在WEB-INF/classes目录下部署标记处理程序类;
    方式二：将标记处理程序类打包成jar文件并置于WEB-INF/lib目录。

  6.几种典型的标签(疑问：可以有带主体而没有属性的标签么？)
    1) 不带属性和主体的简单标签：<mytaglibs:SomeTag/>;
    2) 不带主体但有属性的标签：<mytaglibs:SomeTag user="TonyDeng"/>;
    3) 带有主体和属性的标签：<mytaglibs:SomeTag user="TonyDeng">  ...(标签体)  </mytaglibs:SomeTag>;
    注意：a. 属性列于start tag中，它是在标记库描述符(TLD)文件中指定，服务于标记库的自定义行为;
          b. 标签体位于start tag和end tag间，可以是任何合法的JSP内容或者标签;

  7.定义标签
    1) 开发实现tag的类(tag handler);
    2) 编辑标记库描述符(TLD)文件;
    3) 在web.xml中为标记库描述符(TLD)文件的绝对URL建立一个映射(该步骤可选);

  8.标记库描述符(TLD)文件
    1) 一个描述标记库的XML文件;
    2) 内容开始是整个库的描述，然后是tag的描述;
    3) 标记库描述符(TLD)文件用于Web Container确认tag以及JSP页面发展工具;

  9.实现tag的类(tag handler)
    1) 是一些在引用了标签的JSP页面执行期间被Web Container调用以求自定义标签值的对象;
    2) 必须实现Tag, SimpleTag和BodyTag之一;
    3) 可以继承TagSupport和BodyTagSupport之一。

 10.签库的接口和类的继承关系
    表现形式一：
    a. 接口的继承关系：
       ☉ interface javax.servlet.jsp.tagext.JspTag
          ☉ interface javax.servlet.jsp.tagext.SimpleTag
          ☉ interface javax.servlet.jsp.tagext.Tag
             ☉ interface javax.servlet.jsp.tagext.IterationTag
             ☉ interface javax.servlet.jsp.tagext.BodyTag
    b. 类的继承关系：
       ☉ class javax.servlet.jsp.tagext.TagSupport (implements javax.servlet.jsp.tagext.IterationTag, java.io.Serializable)
          ☉ class javax.servlet.jsp.tagext.BodyTagSupport (implements javax.servlet.jsp.tagext.BodyTag)
       ☉ class javax.servlet.jsp.tagext.SimpleTagSupport (implements javax.servlet.jsp.tagext.SimpleTag)

    表现形式二：
                  (Interface)
                    JspTag
                      ↑
              |ˉˉˉˉˉˉˉˉ|
           (Interface)      (Interface)
             Tag           SimpleTag ←－－SimpleTagSupport
              ↑
               |
         (Interface)
         IterationTag←－－TagSupport
              ↑             ↑
               |              |
         (Interface)            |
           BodyTag   ←－－BodyTagSupport

 11.一个Tag处理程序类必须实现的方法
    标签处理程序类型方法
    Simple                      doStartTag, doEndTag, release
    Attributes                  doStartTag, doEndTag, set/getAttribute...release
    Body,No Itrative and        doStartTag, doEndTag, release
    Evaluation
    Body, Itrative Evaluation   doStartTag, doAterTag, doEndTag, release
    Body, Interaction           doStartTag, doEndTag, release, doInitbody, doAfterBody

 12.简单的标签处理程序类
    1) 必须实现Tag接口的doStartTag()和doEndTag()方法;
    2) 因为不存在Body，doStartTag()方法必须返回SKIP_BODY;
    3) 如其余页面要执行，doEndTag()方法返回EVAL_PAGE, 否则返回SKIP_PAGE;
    4) 对于每一个标签属性，你必须在标签处理程序类里定义一个特性以及get和set方法以一致于JavaBeans体系惯例

 13.带Body的自定义标签
    1) 必须实现Tag接口的doStartTag()和doEndTag()方法;
    2) 可以实现IterationTag接口的doAfterBody()方法;
    3) 可以实现BodyTag接口的doInitBody和setBodyContent方法;
    4) doStartTag方法可以返回SKIP_BODY、EVAL_BODY_INCLUDE、或者EVAL_BODY_BUFFERED(当你想使用BodyContent);
    5) doEndTag方法可以返回SKIP_PAGE或EVAL_PAGE;
    6) doAfterBody方法可以返回EVAL_BODY_AGAIN, SKIP_BODY;

 14.定义脚本变量的标签(迭代的标签库)
    1) 定义脚本标签的二个步骤:
       a. 在标记库描述符(TLD)文件中列明脚本变量;
       b. 定义标签扩展信息类(TEI)并且在TLD文件中包括这个类元素(tei-class);
    2) 变量必须在标签处理程序类中使用pageContext.setAttribute()方法设置;
    3) 标签扩展信息类(TEI)必须继承TagExtraInfo以及覆盖getVariableInfo()方法;
    4) 变量的范围可以是AT_BEGIN, NESTED, AT_END(标签扩展信息类(TEI)的VariableInfo中定义)之一;
    3) 1.2的标签在内存中是可复用的。

 15.脚本变量的有效性
    变量     |   有效性
    ---------------------------------------
    NESTED   | 标签中的参数在starttag到endtag之间是有效的
    AT_BEGIN | 标签中的参数在标签的开始到JSP页面结束是有效的
    AT_END   | 标签中的参数在标签的结束到JSP页面结束是有效的

 16.Tag接口的方法
    interface javax.servlet.jsp.tagext.Tag
    ------------------------------------------------------
    +EVAL_BODY_INCLUDE:int
    +EVAL_PAGE:int
    +SKIP_BODY:int
    +SKIP_PAGE:int
    ------------------------------------------------------
    +release():void
    +getParent():javax.servlet.jsp.tagext.Tag
    +setParent(javax.servlet.jsp.tagext.Tag):void
    +doEndTag():int
    +doStartTag():int
    +setPageContext(javax.servlet.jsp.PageContext):void

 17.Tag的生命周期
    1) setPageContext(javax.servlet.jsp.PageContext):void
    2) setParent(javax.servlet.jsp.tagext.Tag):void
    3) //setAttribute:void
    4) doStartTag():int
    5) doEndTag():int
    6) release():void

 18.BodyTag和Tag接口的关系
    interface javax.servlet.jsp.tagext.BodyTag      -->     interface javax.servlet.jsp.tagext.Tag
    ------------------------------------------
    +EVAL_BODY_AGAIN:int
    ------------------------------------------
    +doInitBody():void
    +setBodyContent (javax.servlet.jsp.tagext.BodyContext):void
    +doAfterBody():int

 19.BodyTag的处理过程
    1) setPageContext(javax.servlet.jsp.PageContext):void
    2) setParent(javax.servlet.jsp.tagext.Tag):void
    3) //setParent()
    4) doStartTag():int
    5) setBodyContent(javax.servlet.jsp.tagext.BodyContent):void
    6) doInitBody():void
    7) doAfterBody():int
    8) doEndTag():int
    9) release():void

 20.SimpleTag接口的方法
    javax.servlet.jsp.tagext.SimpleTag
    ------------------------------------------
    +doTag():void
    +getParent():JspTag
    +setJspBody(JspFragment jspBody):void
    +setJspContext(JspContext pc):void
    +setParent(JspTag parent):void

 21.SimpleTage接口的生命周期
    1) new:
       每次遇到标签，容器构造一个SimpleTag的实例，这个构造方法没有参数。
       和红典的标签一样，SimpleTag不能缓冲，故不能重用，每次都需要构造新的实例。
    2) setJspContext()、setParent(): 只有这个标签在另一个标签之内时，才调用setParent()方法;
    3) 设置属性：调用每个属性的setter方法;
    4) setJspBody();
    5) doTag(): 所有标签的逻辑、迭代和Body计算，都在这个方法中;
    6) return





自定标签程序库
****************************************************************************
标签介绍：
    标签处理类(Tag Handler Classes)： 它提供了标签的功能。
    标签代码库叙述器(Tag Library Descriptor, TLD)： 叙述标签，并将标签配给标签处理类。
    标签指令(taglib Directive)： 这个指令会放在JSP的最上方，可以让您使用特殊的标签程序库。

    taglib中声明的 uri 需在 web.xml 中定义。告诉容器，相应的tag在什么目录下能找到。
    <web-app>
        ......
        <taglib>
             <taglib-uri>http://java.sun.com/jsp/jstl/core</taglib-uri>
             <taglib-location>/WEB-INF/core.tld</taglib-location>
        </taglib>
        <taglib>
             <taglib-uri>MyTaglib</taglib-uri>
             <taglib-location>/WEB-INF/classes/taglib/FlowringTaglib.tld</taglib-location>
        </taglib>
        ......
    </web-app>

    例： <%@ taglib uri="expTags" prefix="exp1" %>  使用：<exp1:time />
    自定标签在jsp中由 taglib 指令声明。
    这个指令必须使用有效的 URI ，标签程序库描述文件会将标签处理器联结到每一个自定标签去。
    在taglib指令之后，自定标签可以使用taglib指令提供的前置词。
    这些标签都有相同的前置词，但名称不同。范例中，前置词是exp1，标签名称是time。

    所有的标签必须支持一些方法，如：doStartTag() 与 doEndTag()。
    当读到开始标签(如<exp1:time>)时，调用 doStartTag() 方法，当读到结束标签(如</exp1:time>)时，调用 doEndTag() 方法。
    JSP 1.2 规格提供了三种标签处理接口： Tag,  IterationTag,  BodyTag


Tag 接口
    这个接口有6个方法：
    doStartTag(),  doEndTag(),  getParent(),  setParent(),  release(),  setPageContext()
    TagSupport(helper类)，它实现了 Tag 接口，继承这个类，就可以只写我们需要的方法。

    当读到开始标签时，调用 doStartTag() 方法;这个方法的返回值决定下一个要完成的是哪一个。
    有效的返回值包括 EVAL_BODY_INCLUDE 或 SKIP_BODY 。
    返回 EVAL_BODY_INCLUDE:将会处理标签的内容，并可供标签处理器使用。
    返回 SKIP_BODY 将会跳过文本内容。

    当读到结束标签时，调用 doEndTag() 方法。即使是空标签，这个方法仍会在doStartTag()之后被调用。
    这个方法的有效返回值是 EVAL_PAGE 或 SKIP_PAGE。
    返回EVAL_PAGE，JSP将会在自定标签之后如常运行。
    返回SKIP_PAGE，JSP将会跳过此标签后面的全部页面代码。小心使用。

标签代码库叙述器(Tag Library Descriptor, TLD)
    负责联结。是一个xml文件。例如：
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE taglib PUBLIC
          "-//Sun Microsystems, Inc.//DTD JSP Tag Library 1.2//EN"
          "http://java.sun.com/dtd/web-jsptaglibrary_1_2.dtd">
    <taglib>
        ....
        <tag>
          <name>time</name>
          <tag-class>com.tarena.timeTag</tag-class>  //对应的类地址
        </tag>
    </taglib>

<taglib>子元素：
    放置在 TLD的xml文件中，<taglib>标签内。
    <tlib-version> 标签库版本。开发者可随意自定。
    <jsp-version>  标签库使用的 JSP 版本。
    <short-name>   这个taglib的简短、易记名称。
    <uri>          可独特识别这个 taglib 的 URI 。
    <display-name> Taglib的简短名称，可由工具来显示。
    <tag>          可含有关于标签库的单一标签的资料。如果有一个以上的标签，可以用无穷个<tag>。
    <description>  叙述标签库目的的字符串。

<tag>元素：
    自定标签必须包含至少一个<tag>元素。所有<tag>元素都必须至少包含两个子元素：<name>,<tag-class>
    不可以有两个标签拥有相同的名称。
<tag>元素的子元素：(以下并不是全部)
    name           必要       标签的独特名称。对应到JSP中的自订标签的元素名称。
    tag-class      必要       实现Tag, IterationTag, BodyTag 接口的标签类。
    tei-class      不必       可选的“额外资源”，必须是TagExtranInfo的子类。
    display-name   必要       标签的简称，它将由工具显示出来。
    description    不必       此标签的简单描述。
    attribute      不必       有关标签的属性的信息。可以用无穷个<attribute>标签。
    variable       不必       可创建供标签使用的叙述变量。

IterationTag 接口:
    与Tag接口类似，在需要循环的时候用。
    通过doAfterBody()方法形成循环。当 doStartTag()返回EVAL_BODY_INCLUDE时，调用这方法。
    如果doAfterBody()返回EVAL_BODY_AGAIN，再次调用它自己；直到返回SKIP_BODY或EVAL_BODY_INCLUDE为止。
    TagSupport类也实现了IterationTag接口，继承这个类就可用了。

BodyTag 接口：
    三个接口中，功能最多的一个。继承了IterationTag接口。
javax.servlet.jsp.tagext.BodyContent 对象：
    BodyContent含有解析自定标签内容的能力。拥有清楚内容、读取内容及将内容转换成String的方法。
    可以循环操纵BodyContent对象，并重新解析标签内容，一直到返回SKIP_BODY为止。
    与IterationTag接口不同的是，它没有限制更改标签内容，而IterationTag限制了。
    有新方法doInitBody()，在doStartTag()返回EVAL_BODY_BUFFERED时调用。
    调用doInitBody()时，创建BodyContent对象，用来存储标签内容。

    BodyTagSupport(helper类)，如果需要更复杂的功能，就需要继承这个类，但一般用TagSupport就够了。



/********* 范例1 开始 ************/

   1.在Tomcat的 项目目录下 \WEB-INF\classes\yonglian\timeTag.java
     在Tomcat的 lib 目录下，需要有servlet-api.jar或servlet.jar
package yonglian;
import java.text.SimpleDateFormat;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

public class timeTag extends TagSupport {
    String format = "HH:mm:ss"; //默认值，不改属性时使用它。

    //set*** 方法名须对应属性的名称。象javaBean的。
    public void setFormat ( String newFormat ) { format = newFormat; }

    public int doEndTag() throws JspException {
        SimpleDateFormat sdf;
        sdf = new SimpleDateFormat ( format );
        String time = sdf.format( new java.util.Date () );
        try {
            //out.print() 在这不能直接用
            pageContext.getOut().print(time);
        } catch ( Exception e ) {
            throw new JspException ( e.toString() );
        }
        return EVAL_PAGE;
    }
}

    在Tomcat的 项目目录下 \WEB-INF\classes\yonglian\createArrayTag.java
package yonglian;
import javax.servlet.jsp.tagext.TagSupport;
public class createArrayTag extends TagSupport {
    public int doStartTag () {
        String[] strings = new String[] { "Alpha", "Bruce Lee", "Omega" };
        pageContext.setAttribute("strings", strings);
        return SKIP_BODY;
    }
}

    在Tomcat的 项目目录下 \WEB-INF\classes\yonglian\iterateTag.java
package yonglian;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;
public class iterateTag extends TagSupport {
    private int arrayCount = 0;
    private String[] strings = null;
    public int doStartTag () {
        strings = (String[]) pageContext.getAttribute("strings");
        return EVAL_BODY_INCLUDE;
    }
    public int doAfterBody () throws JspException {
        try {
            pageContext.getOut().print("" + strings[arrayCount] + "<br>");
        } catch ( Exception e ) {
            throw new JspException ( e.toString() );
        }
        arrayCount++;
        if ( arrayCount >= strings.length ) { return SKIP_BODY; }
        return EVAL_BODY_AGAIN;
    }
}


    2.在Tomcat的 项目目录下 \WEB-INF\exampleTags.tld
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE taglib PUBLIC "-//Sun Microsystems, Inc.//DTD JSP Tag Library 1.2//EN"
                        "http://java.sun.com/dtd/web-jsptaglibrary_1_2.dtd">
<taglib>
    <tlib-version>1.0</tlib-version>
    <jsp-version>1.2</jsp-version>
    <short-name>ExampleTags</short-name>
    <description>A set of example tag handlers.</description>
    <tag>
        <name>time</name>
        <tag-class>yonglian.timeTag</tag-class>
        <attribute>
            <name>format</name>
            <!-- 设置下面这个之后，可以动态设置：<exp:time format="<%= pageformat %>" /> -->
            <rtexprvalue>true</rtexprvalue>
        </attribute>
    </tag>
    <tag>
        <name>iterate</name>
        <tag-class>yonglian.iterateTag</tag-class>
    </tag>
    <tag>
        <name>createArray</name>
        <tag-class>yonglian.createArrayTag</tag-class>
        <variable>
            <name-given>strings</name-given>
            <variable-class>java.lang.String []</variable-class>
            <declare>true</declare>
            <scope>AT_END</scope>
        </variable>
    </tag>
</taglib>


    3.需使用的网页： 如项目目录下\index.jsp
<%@ taglib prefix="exp" uri="WEB-INF/exampleTags.tld" %>
<html>
  <head></head>
  <body>
    Welcom to my page.<br/> The current time is
     <exp:time format="yyyy/MM/dd HH:mm:ss" /><br/>
     <exp:createArray/>
     There are <%= strings.length %> Strings available.<br/>
     <exp:iterate>
      The string is:
     </exp:iterate>
  </body>
</html>

    页面显示：
Welcom to my page.
The current time is 2009/09/16 15:34:39
There are 3 Strings available.
The string is: Alpha
The string is: Bruce Lee
The string is: Omega

/******** 范例1 结束 *************/


延伸自定义标签的功能：
    延伸自定义标签的功能有三种方法：
    1.建立属性。
    2.建立描述变量。
    3.使用标签额外类别(Tag Extra Info, TEI)。

一、标签属性
    <attribute>元素
       标签的属性须先在TLD文件中声明。<attribute>元素是<tag>的子元素。
       每一个自定义标签都应该有一个<attribute>元素。
       <attribute>元素的子元素：(只有name是必须的)
       <name>        属性的名称
       <required>    指定标签是否需要属性。为true或yes时，将属性设为需要。
                     false或no则表示属性可有可无。默认为false。
       <rtexpralue>  指定属性是否可由scriptlet于运行期间动态设置。
                     值为true或yes时，允许拥有运行期的scriptlet数值；若为false或no则不允许。
       <description> 属性的简介。

二、标签变量
    <variable>元素
       以下元素只有<name-given>标签不是必需的，其它都是必需的。
       <name-given>       描述变量的名称。注意，还有另外一个描述变量名的选择。
       <variable-class>   这个元素的数值代表描述变量的java类型。
       <declared>         如果描述变量是新的，则这个元素的值必须是true或yes.
       <scope>            有三个值可以定义描述变量的范围。如果数值是AT_BEGIN,则描述变量在开始标签之后就在范围之内，如果是AT_END则在结尾标签之后，如果是NESTED则在开始与结尾标签之间。


三、使用TagExtraInfo(TEI)类声明描述变量
    除了建立描述变量之外，TEI类也可以执行自定标签的有效确认工作。
    1.TagData对象              含有有关标签属性的信息。
      1) getAttributes()       返回enum(枚举)类。包含所有值的集合。
      2) getAttribute()        用String属性名作参数，返回Object类型的属性值。
      3) getAttributeString()  用String属性名作参数，返回代表属性值的String。

    2.VariableInfo对象         它叙述了新的描述变量。
      使用VariableInfo对象:
      VariableInfo vi = new VariableInfo( varName, className, true, VariableInfo.AT_END );
      上式的varName是String类型的新变量名称。className是变量的完整类名称，也是String类型。
      第三的true是个布尔值，其描述变量对JSP是新的，所以必须声明。最后一个是代表变量的需要范围：
      VariableInfo.AT_BEGIN    新的描述变量将会在开始自定标签之后的范围之内。
      VariableInfo.AT_END      新的描述变量将会在结尾自定标签之后的范围之内。
      VariableInfo.NESTED      描述变量将只会在自定标签的本体之内的范围内。

      用getVariableInfo()方法定义新的变量。参数是TagData对象，返回VariableInfo对象的数组。
      当在TEI类里覆盖getVariableInfo()方法时，每个VariableInfo对象都由开发者自行定义。














技巧摘录:
1.检查提交方式(post或get)
    <%
    //url非法登入(页面上是用post提交的,防止别人用get的方式提交过来)
    if ( !"POST".equalsIgnoreCase(request.getMethod().toString()) )
    {
        %><script type="text/javascript" language="JavaScript" charset="UTF-8" >
            alert("非法登入, 請重新登入!!");
        </script>
        <%
    }
    %>

2.获取路径
   1) String dburl = String.valueOf(Thread.currentThread().getContextClassLoader().getResource(""));
      //上句得到路径  file:/工程路径/WEB-INF/classes/
      dburl += "database.mdb";

      //如果只是简单的去掉file:/，当路径含有空格的时候就会出错。用toURI()就解决了这问题。得到绝对路径
      try { dburl = new File(new URL(dburl).toURI()).toString(); } catch(Exception e){}

   2) 在jsp页面上
    <%
      //得到当前项目的绝对路径
      String filePath = new File(getServletContext().getRealPath("/")).getAbsolutePath();
      //获取跟上面同样的文件路径
      filePath += "/WEB-INF/database/database.mdb";
    %>

3.获取ip
    前提: 被访问的地址是 http://127.0.0.1:8080/test/database.jsp?a=1&b=2  (/test/ 是项目的虚拟目录)
    查看类型: javax.servlet.http.HttpServletRequest
    <%
    request.getRequestURL();  // http://127.0.0.1:8080/test/database.jsp
    request.getScheme();      // http
    request.getRemoteAddr();  // 127.0.0.1
    request.getServerName();  // 127.0.0.1
    request.getServerPort();  // 8080
    request.getContextPath(); // /test
    request.getRequestURI();  // /test/database.jsp
    request.getServletPath(); // /database.jsp
    request.getRemoteHost();  // 127.0.0.1   (当地址是localhost时显示： 0:0:0:0:0:0:0:1)
    request.getQueryString(); // a=1&b=2

    // 自动生成的jsp文件会有这样的两句：
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"+request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>

