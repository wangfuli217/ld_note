Struts 2.x初阶

1.MVC原理
2.Struts框架的介绍
3.Struts2.x快速上手
4.Struts2.x框架的分析

*******************************************************************************
一、MVC原理
   1. Model1---> Model2 ---> MVC Framework

   2. Html/JavaScript --> dynamic web content
                          动态，可交互；

   3. CGI --> Servlet     -->   JSP  -->  MVC (Model1 --> Model2)--> Framework
     进程调用  线程调用，性能提高               静态内容与动态内容分离；         框架
     本地语言  可移植           页面中嵌入java    javabean --> 控制器
*******************************************************************************
二、Struts框架的起源和发展
   设计理念：基于请求(http request)---struts,WebWork....
           基于事件驱动，组件编程    ---JSF,Tapestry,ZK,echo

   1.Struts1.x
     M：没有定义设计方法
     C：ActionServlet + struts-config.xml(核心控制器)
        Action：业务逻辑的控制器
     V：JSP实现(EL)+ Tags +Tiles .....

   2.WebWork
        open source (开源组织：opensymphony)
        Rickard Oberg --- Jboss/XDoclet(annotation)
     C：核心控制器(ServletDispatcher)
        业务控制器(Action)
         --- 使用拦截器链
     V：支持JSP模板，FreeMarker, Velocity 等....

   3.Struts2.x
     Struts1.x + WebWork 的整合(血统来自于WebWork)
     ServletDiapatcher --> FilterDispatcher 

   4.Struts1.x    vs.  Struts2.x
     1)Struts1.x：
       非常依赖Servlet API 
       execute(mapping,form,request,response){...}
     2)WebWork
       拦截器链设计，摆脱对Servlet API的依赖
       Action
     3)Struts2.x：
       控制器更加彻底：业务控制器Action---支持POJO
       不再支持内置的IoC容器(Spring)

*******************************************************************************
三、Struts2.x快速上手
    itcompany系统的部分功能:
    登录模块
    公司信息查询


  1.登录应用————struts2.x快速上手
  1)创建web工程，设置环境
    A.WEB-INF/lib/
    +Struts2.x需要的基本.jar


    B.web.xml：
        <filter>
            <filter-name>struts2</filter-name>
            <filter-class>
                org.apache.struts2.dispatcher.FilterDispatcher
            </filter-class>
        </filter>
        <filter-mapping>
            <filter-name>struts2</filter-name>
            <url-pattern>/*</url-pattern>
        </filter-mapping>
        <filter>
            <filter-name>struts-cleanup</filter-name>
               <filter-class>
                 org.apache.struts2.dispatcher.ActionContextCleanUp
               </filter-class>
        </filter>
        <filter-mapping>
            <filter-name>struts-cleanup</filter-name>
            <url-pattern>/*</url-pattern>
        </filter-mapping>

    C.在classpath下添加struts.xml
      src/    + struts.xml (手工做时，则发布在WebRoot/WEB-INF/classes/)

    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE struts PUBLIC 
        "-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"
        "http://struts.apache.org/dtds/struts-2.0.dtd">
    <struts>
        <package name="login" extends="struts-default">
            <action name=""></action>
        </package>
    </struts>


  2)login.jsp
        使用基本的<html>标签

    <%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
    <html>
      <head>
        <title>login</title>
      <body><center>
              <h3>请输入用户名和密码</h3>
              <form action="Login.action" method="post">
                  <table border=1>
                      <tr><td>user name:</td>
                      <td><input type=text name="username"></td>
                      </tr>
                      <tr><td>password:</td>
                      <td><input type=password name="password"></td>
                      </tr>
                      <tr><td colspan=2 align=center>
                              <input type=submit value="Login">
                          </td>
                      </tr>
                  </table>
              </form>
      </center></body>
    </html>


  3)Controller的开发(POJO)
    package com.login;
    public class LoginAction {
        private String username;
        private String password;

        //getter,setter方法

        public String execute() throws Exception {
            //处理登录逻辑
            if("holer".equals(username) && "123".equals(password)) {
                return "success";
            } else {
                return "error";
    }}}

    注释：
        execute方法：普通的方法，没有任何的Servlet API、Struts2.x API的耦合
        跳转： "success"，"fail"

  4)配置Controller Action
    struts.xml
        +Action的配置
    <struts>
        <package name="login" extends="struts-default">
            <action name="Login" class="com.LoginAction">
                <result name="success">/successful.jsp</result>
                <result name="fail">/login.jsp</result>
            </action>
        </package>
    </struts>











********************************************
*通过不断重构demo，来深入了解Struts应用。*
********************************************

2.改进Controller Action
  implements Action(Interface of xwork)

3.使用Servlet API添加状态跟踪(HttpSession)
  1)在LogonAction的execute方法添加：
    ActionContext.getContext().getSession().put("username", getUsername());

  ActionContext
    +getSession()
    注意：返回的不是HttpSession，而是一个Map的封装，
    Struts2.x框架的内置拦截器实现了Session和HttpSession之间的转换

  2)在目标页面successful.jsp添加
    ${username }
  输出该Session中key为"username"的值

login.java:
  import com.opensymphony.xwork2.Action;
  import com.opensymphony.xwork2.ActionContext;
  public class LoginAction implements Action {

    private String username;
    private String password;
    //getter, setter
    
    public String execute() throws Exception {
        //处理逻辑
        if("holer".equals(username) && "123".equals(password)) {
            // Struts2.x框架使用拦截器来完成： HttpSession.setAttribute("user", username);
            ActionContext.getContext().getSession().put("user", username);
            // return "success"; 
            return this.SUCCESS;
        } else {
            System.out.println("can not login...");
            //return "error";
            return this.ERROR;
  }}}

  success.jsp页面上可以使用 ${user } 来接收参数 username 
   注释：阅读Action接口的源码


4.实现系统的另外一个功能：
    点击链接，查询并列举出所有的Company信息

  1)successful.jsp
    <a href="ListComp.action">查看公司信息</a>

  2)提供处理查德询公司信息的Action:
    ListCompsAction
    private List comps;
    //其中，comps放置的是pojo.Company的列表

在execute()方法中，添加如下代码：
String username = (String)ActionContext.getContext().getSession().get("username");
if("maxwell".equals(username)){
    //从数据库查询出资料
    Company comp = new Company();
    comp.setCompName("Tarena"); comp.setAddress("天河区岗顶"); comp.setCity("广州市"); comp.setEmail("hr@tarena.com.cn");
    Company comp1 = new Company();
    comp1.setCompName("Tecent"); comp1.setAddress("深南路55号"); comp1.setCity("深圳市"); comp1.setEmail("hr@qq.com.cn");
    Company comp2 = new Company();
    comp2.setCompName("IBM(Chinese)"); comp2.setAddress("王府井3楼"); comp2.setCity("北京市"); comp2.setEmail("hr@ibm.com");

    companies.add(comp);  companies.add(comp1);  companies.add(comp2);
    this.setComps(companies);
    //跳转到显示页面   //return "success";
    return this.SUCCESS;
} else {
    return this.LOGIN;
}


3)提供配置(struts.xml)
<action name="ListComp" class="com.ListCompsAction">
    <result name="success">/viewCompanies.jsp</result>
    <result name="login">/login.jsp</result>
</action>
    

4)viewCompanies.jsp显示数据
<table border=1>
    <tr>
        <th>公司名</th>
        <th>城市</th>
        <th>地址</th>
        <th>邮箱</th>
    </tr>
    <%
        ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");
        List<Company> comps = (List)vs.findValue("comps");
        for(Company comp : comps){
    %>
        <tr>
            <td><%=comp.getCompName()%></td>
            <td><%=comp.getCity()%></td>
            <td><%=comp.getAddress()%></td>
            <td><%=comp.getEmail()%></td>
        </tr>
    <%
        }
     %>
</table>



注释：
    struts.valueStack
        Action中的成员属性，属性可能是
        (1)请求的参数
        (2)下一个页面显示的数据
        这些属性的值被封装起来，并放置在ValueStack对象中，

        ValueStack对象的获取：
        ValueStack vs = (ValueStack)request.getAttribute("struts.valueStack");

        开发人员可以通过属性名来从ValueStack中读取数据


5.对视图的改进(使用struts标签库)
    尽可能的消灭jsp中的Java代码
1)加入标签库：
<%@ taglib prefix="s" uri="/struts-tags"%>

2)logon.jsp---->logonPage.jsp
<table border=1>
    <s:form action="Logon" method="post">
        <tr><s:textfield name="username" label="username"></s:textfield></tr>
        <tr><s:password name="password" label="password"></s:password></tr>
        <tr><s:submit value="login"></s:submit></tr>
    </s:form>
</table>

注解：
<s:form/>标签
<s:textfield/>
<s:password/>
<s:submit/>



3)viewCompanies.jsp----->listCompanies.jsp
<h1>It公司信息列表</h1>
<table border=1>
    <tr>
        <th>公司名</th>
        <th>城市</th>
        <th>地址</th>
        <th>邮箱</th>
    </tr>
    <!-- 迭代输出ValueStack对象中的comps， 其中status为迭代索引 -->
    <s:iterator value="comps" status="index">
        <!-- 判断索引是否为奇数 -->
        <s:if test="#index.odd == true">
            <tr style="background-color:yellow">
        </s:if>
        <s:else>
            <tr style="background-color:red">
        </s:else>
            <td><s:property value="compName"/></td>
            <td><s:property value="city"/></td>
            <td><s:property value="address"/></td>
            <td><s:property value="email"/></td>
        </tr>
    </s:iterator>
</table>

注解：
<s:if test/>:判断标签
<s:else/>

<s:iterator/>迭代输出，等价于jstl中的<c:forEach/>






6.i18n的支持
1)定义资源文件
resource包下
+itcomps.properties   //默认语言
+itcomps_en.properties //英语
内容：
login.title=Please input your username and password
login.username=User Name
login.password=Password
login.submit=Login

login.success.msg=Congratulation, successfully Login!
view.comps.link=View the companies information
view.comps.title=View Companies
view.comps.compName=Company Name
view.comps.city=City
view.comps.addr=Address
view.comps.email=Email Box


+itcomps.txt

login.title=请输入用户名和密码
login.username=用户名
login.password=密码
login.submit=登录

login.success.msg=恭喜你，成功登录了！
view.comps.link=查看公司信息
view.comps.title=查看It公司信息
view.comps.compName=公司名字
view.comps.city=城市
view.comps.addr=地址
view.comps.email=邮箱

+使用native2ascii工具把itcomps.txt转换为itcomps_zh_CN.properties
内容：
login.title=\u8BF7\u8F93\u5165\u7528\u6237\u540D\u548C\u5BC6\u7801
login.username=\u7528\u6237\u540D
login.password=\u5BC6\u7801
login.submit=\u767B\u5F55

login.success.msg=\u606D\u559C\u4F60\uFF0C\u6210\u529F\u767B\u5F55\u4E86\uFF01
view.comps.link=\u67E5\u770B\u516C\u53F8\u4FE1\u606F
view.comps.title=\u67E5\u770BIt\u516C\u53F8\u4FE1\u606F
view.comps.compName=\u516C\u53F8\u540D\u5B57
view.comps.city=\u57CE\u5E02
view.comps.addr=\u5730\u5740
view.comps.email=\u90AE\u7BB1


2)添加struts.properties在类路径下(\WebRoot\WEB-INF\classes)，并加入如下设置：
struts.custom.i18n.resources=resource.itcomps
//上句是表明资源路径，资源在 \WebRoot\WEB-INF\classes\resource 目录下，且名字以 itcomps 开头

3)输出信息(2种方式)
方式一：
<s:text name="key"></s:text>
key:国际化信息的key，输出为其value

方式二：使用OGNL表达式
%{getText('key')}
例如：
<s:textfield name="username" label="%{getText('login.username')}"></s:textfield>
<s:property value="%{getText('key')}"/>



7.添加数据校验(编码式)
需求：登记用户
1)logon.jsp---->enroll.jsp
    <s:form action="enroll" method="post">

2)开发EnrollAction 
    extends ActionSupport

    添加校验方法
    @Override
    public void validate(){
        if(getUsername()== null || getUsername().equals("")){
            this.addFieldError("username", "username.required");
           //I18N时： this.addFieldError("username", this.getText("username.required"));
        }
        
        if(getPassword()== null || getPassword().equals("")){
            this.addFieldError("password", "password.required");
        }
    }

  注意：前提是要求输入域必须在<s:form/>中。


8.声明式验证
1)logon.jsp
    使用struts2标记

2)在Action下添加同名的校验配置
LogonAction-validation.xml  (跟LogonAction.java同名，同一目录下)

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE validators PUBLIC 
          "-//OpenSymphony Group//XWork Validator 1.0.2//EN" 
          "http://www.opensymphony.com/xwork/xwork-validator-1.0.2.dtd">
<validators>
    <field name="username">
        <field-validator type="requiredstring">
            <message key="username.required"></message>
        </field-validator>
    </field>
    <field name="password">
        <field-validator type="requiredstring">
            <message key="password.required"></message>
        </field-validator>
    </field>
</validators>







*******************************************************************************
四、Struts2.x框架的分析
1)框架架构

2)基本流程

3)Struts2.x的基本配置
web.xml
struts.xml
struts.properties





