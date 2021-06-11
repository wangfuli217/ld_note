

Day1:
1.MVC概述
2.Struts框架 (技术概览) 
3.Struts开发步骤
4.Struts新手上路
5.Struts详解
6.使用工具构建struts应用
**************************************************************

一 MVC概述
   1.名词解释
     MVC模式是“Model-View-Controller”的缩写，中文翻译为“模型-视图-控制器”。
   2.模式起源
     MVC模式最早是smalltalk语言研究团提出的，应用于用户交互应用程序中。
   3.设计思想
     即把一个应用的输入、处理、输出流程按照Model、View、Controller的方式进行分离，这样一个应用被分成三个层——模型层、视图层、控制层。

    1.2 视图
        代表用户交互界面
        对于Web应用来说，可以概括为HTML界面，但有可能为XHTML、XML和Applet。
    1.3 模型
        就是业务流程/状态的处理以及业务规则的制定
        业务流程的处理过程对其它层来说是黑箱操作，模型接受视图请求的数据，并返回最终的处理结果。
        业务模型还有一个很重要的模型那就是数据模型(JavaBean)
    1.4 控制器
        可以理解为从用户接收请求, 将模型与视图匹配在一起，共同完成用户的请求。
        控制层并不做任何的数据处理。因此，一个模型可能对应多个视图，一个视图可能对应多个模型。

    1.5 Jsp的模型1 (Model 1)
        以JSP为中心的开发模型
        在 JSP 页面中同时实现显示，业务逻辑和流程控制
        JSP页面中可以非常容易地结合业务逻辑(jsp:useBean)、服务端处理过程(jsp:scriplet)和HTML(<html>)，现在很多的Web应用就是由一组JSP页面构成的。

      Model 1 缺点:
        1)强耦合
          (1)难以维护、调试、更新、扩展、重用
             违背简单就是美丽的美学原则
          (2)JSP 文件的编写者必须既是网页设计者，又是Java 开发者
             通常结果是要么Java代码很糟，要么是网页很难看，甚至Java代码和网页脚本代码都很糟
             难以实现分层开发
        2)内嵌的流程逻辑
          要理解应用程序的整个流程，您必须浏览所有网页
          试想一下拥有1000个网页的Web应用的错综复杂的逻辑

    1.6 Model 2 
        以Servlet为中心的开发模型
        提供应用的处理过程控制(一个Servlet)，通过这种设计模型把应用逻辑，处理过程和显示逻辑分成不同的组件实现。这些组件可以进行交互和重用。从而弥补了Model 1的不足。
        具有组件化的优点从而更易于实现对大规模系统的开发和管理

      Model 2 缺点:
        原来通过建立一个简单的JSP页面就能实现的应用现在变成了多个步骤的设计和实现过程。
        所有的页面和组件必须在MVC框架中实现，所以必须进行附加地开发工作。
        MVC本身就是一个非常复杂的系统，所以采用MVC实现Web应用时，最好选一个现成的MVC框架，在此之下进行开发，从而取得事半功倍的效果。现在有很多可供使用的MVC框架。


  引入框架的作用
    A. 使得功能组件松散耦合，甚至可配置
    B. 提供公用的服务：
       例如：i18n，安全，表单的重复提交，文件上传……
    C. 简化开发模型——使得开发人员的精力集中在业务逻辑之上
  框架的分类
    A.设计的思路
      白盒框架(White-Box)：使用时，需要了解其内部结构(extends)；入侵性框架；基于继承的框架
      黑盒框架(Black-Box)：不需了解其代码细节，最多实现其接口；非入侵性框架；基于对象构件组装的框架
    B.功能、作用
      Web:Strusts1.x, WebWork, Strusts2.x(发展1.x和webwork), JSF(抗衡.net), Tapestry,
          Shale, ZK, Echo, Myfaces/ADF, (根本全是Servlet规范) ……
      Business:Spring, Seam
      Persistence(持久层):Hibernate, Toplink, OpenOJB, ……
  评价框架的优劣？
    A.设计理念    先进？
    B.编程模型    简单？
    C.是否拥抱规范、标准？
    D.社区是否庞大？第三方的支持程度？


程序设计思路
  可维护性：预见需求(预见多年后的事) 
  可重用： 
          代码可重用(最低级别)：粒度：方法(常用代码块)，类，包，组件(类库) 
          设计的可重用：框架(半成品，如Hibernate)；产品(开发软件)；算法、设计模式
          分析的可重用(最高级别，见不到代码)：文档、规范、标准(ISO：CMM，CMMI) 
  可扩展性：

*****************************************************

二、Struts框架 (技术概览) 
1.Struts简介
  Apache  OpenSource
  官方网站：http://jakarta.apache.org

    Struts 是Apache组织的一个开放源码项目。
    Struts是一个比较好的MVC框架,提供了对开发MVC系统的底层支持。
    它采用的主要技术是Servlet，JSP，资源文件和custom tag library。
  Struts优点
    利用Struts提供的taglib可以大大节约开发时间
    表现与逻辑分离，维护扩展比较方便
    国际化支持与完善的验证框架
    统一错误处理方法
    大量内置设计模式的使用: 单例模式、组合模式、命令模式、委派模式等
    便于团队开发
    巨大的用户社区
    稳定且成熟
    大量第三方工具的支持
  Struts缺点
    不适合小型应用开发，小型项目直接使用JSP和Servlet反而方便快捷
    基于请求的框架
      相对于基于组件事件驱动的框架来说设计理念已经相对落后，其可重用的粒度也相对比较小


2.Struts快速上手
需求描述：
    系统的登录

开发步骤
1) 创建项目、搭建环境
    下载Struts开发包
    把%STRUTS_HOME%/lib/＊.jar拷贝到WEB-INF/lib
    把%STRUTS_HOME%/contrib/struts-el/lib/＊.jar拷贝到WEB-INF/lib
    把%STRUTS_HOME%/lib/＊.tld拷贝到WEB-INF(新版本无需这么做) 
    将%STRUTS_HOME%/contrib/struts-el/lib/＊.tld 拷贝到WEB-INF(新版本无需这么做) 

    如果用MyEclipse，对着工程右键 -> MyEclips -> Add Struts Capabilities...
    也就可以搭建好所需的环境了，并且自动写好WEB-INF/web.xml文件、WEB-INF/struts-config.xml文件

2) 配置WEB-INF/web.xml文件
   实质是继承HttpServlet类(ActionServlet类)
<servlet>
    <servlet-name>action</servlet-name>
    <!-- 上句：把ActionServlet注册到web.xml中。ActionServlet控制所有的Action  -->
    <servlet-class>org.apache.struts.action.ActionServlet</servlet-class>
        <init-param>
          <param-name>config</param-name>
          <param-value>/WEB-INF/struts-config.xml</param-value>
        </init-param>
        <init-param>
          <param-name>debug</param-name>
          <param-value>3</param-value>
        </init-param>
        <init-param>
          <param-name>detail</param-name>
          <param-value>3</param-value>
        </init-param>
    <load-on-startup>0</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>action</servlet-name>
    <url-pattern>*.do</url-pattern>
</servlet-mapping>

3) 在WEB-INF创建struts-config.xml文件
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE struts-config PUBLIC "-//Apache Software Foundation//DTD Struts Configuration 1.3//EN"
 "http://struts.apache.org/dtds/struts-config_1_3.dtd">

<struts-config>
  <form-beans />
  <global-exceptions />
  <global-forwards />
  <action-mappings />
  <message-resources parameter="com.yourcompany.struts.ApplicationResources" />
</struts-config>

  说明：以上是默认的写法，系统可以自动生成。
        以下是具体的配置说明，当然现在不用加进去

    <struts-config>
        <!--  配置ActionForm -->
        <form-beans>
                <!--  一般的ActionForm -->
                <form-bean name="userLoginForm" type="data_model.UserBean" />

                <!--  动态的ActionForm -->
                <form-bean name="DynaUserBean" type="org.apache.struts.action.DynaActionForm">
                        <form-property name="userName" type="java.lang.String"/>
                        <form-property name="userPassword" type="java.lang.String"/>
                </form-bean>

                <!-- 动态数据验证的ActionForm -->
                <form-bean name="DynaValidationUserBean" 
                           type="org.apache.struts.validator.DynaValidatorForm">
                        <form-property name="userName" type="java.lang.String"/>
                        <form-property name="userPassword" type="java.lang.String"/>
                </form-bean>
        </form-beans>

        <action-mappings>
                <!-- 配置处理业务逻辑的Action -->
                <action path="/struts/UserLoginAction"
                        type="data_model.UserLoginAction" name="userLoginForm"
                        scope="request">
                        <forward name="success" path="/struts/welcome.jsp" />
                        <forward name="fail" path="/struts/error.jsp" />
                </action>
        </action-mappings>
                <!-- 配置国际化资源文件-->
                <message-resources parameter="myresources.EricResources_en" />
                <message-resources parameter="myresources.EricResources_zh_CN" />
                <!-- 配置验证框架，导入validation.xml 文件 -->
                <plug-in className="org.apache.struts.validator.ValidatorPlugIn">
                    <set-property property="pathnames"
                         value="/org/apache/struts/validator/validator-rules.xml, 
                                   /WEB-INF/validation.xml" />
                    <set-property property="stopOnFirstError" value="false"/>
                </plug-in>
        </struts-config>


4) 提供login.jsp

<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%  //上句引入struts的标签库  %>

<html:form action="/login">
 <%  /* 上面的 <html:form> 标签会自动生成：
       <form name="loginForm" method="post"
        action="/项目名/login.do;jsessionid=(16进制字符串，保存sessionID)">
       对应的是struts-config.xml里配置的Action的path的值  */
 %>
    <table>
        <tr>
            <td>用户名：</td>
            <td><html:text property="username"></html:text></td>
            <% //页面在遇到 <html:text> 标签时，会调用其 getter 方法 %>
        </tr>
        <tr>
            <td>密  码：</td>
            <td><html:password property="password"></html:password></td>
        </tr>
        <tr>
            <td colspan=2 align=center>
                <html:submit value="登录"></html:submit>
                <% //客户端提交时，会调用 setter，把页面请求的内容设到相应的 Bean 里以供调用 %>
            </td>
        </tr>
    </table>
</html:form>

5) 提供Form Bean
   路径如： com.form.LoginForm
   用途：保存页面所需的元素。 如页面需传递的 username 和 password

import org.apache.struts.action.ActionForm;
public class LoginForm extends ActionForm {
//必须继承ActionForm这个抽象类，这样才能被struts识别

    private String username;  //一定要和jsp页面的Form里的组件名称对应相同
    private String password;
    
    //getter, setter 方法 (供 Action 调用)
}

配置文件struts-config.xml更新：
  <form-beans>
    <form-bean name="loginForm" type="com.form.LoginForm"></form-bean>
  </form-beans>

  说明：<form-beans>里面可以有很多个<form-bean>
        <form-bean>的name属性要跟调用者的name相同，type是这个Bean的路径

6) 提供action：LoginAction extends Action
import javax.servlet.http.*;
import org.apache.struts.action.*;
public class LoginAction extends Action {
//必须继承Action抽象类，这样才能被struts识别

    @Override
    public ActionForward execute(ActionMapping mapping, ActionForm form,
           HttpServletRequest request, HttpServletResponse response)  throws Exception {
        //必须返回一个ActionForward类型，用于跳转页面使用

        // get the data from ActionForm
        LoginForm loginForm = (LoginForm)form;
        String username = loginForm.getUsername();
        String password = loginForm.getPassword();

        //本应去数据库查询的，这里简化了
        boolean isLogin = false;
        if("holemar".equals(username) && "123".equals(password)) {
            isLogin = true;
        }
        
        //页面跳转
        if(isLogin) {
            return mapping.findForward("success");
        } else {
            return mapping.findForward("error");
        }
    }

}

配置文件struts-config.xml更新：
  <action-mappings>
      <action path="/login" type="com.action.LoginAction" name="loginForm">
          <forward name="success" path="/success.jsp"></forward>
          <forward name="error" path="/error.jsp"></forward>
      </action>
  </action-mappings>

7) success.jsp 和 error.jsp 页面
   在 WebRoot 目录下创建这两个页面，内容随意写，能区别出就行。



3.Struts技术详解
  1) struts的MVC模型
  2) 主要组件详解
    a) ActionServlet
    继承HttpServlet类,需要在web.xml中配置 <servlet-name>和<servlet-class> 等资料

    b) Action
    开发人员必须继承这个Action类，供ActionServlet所驱动。
    职责：调用业务逻辑方法
          将控制权返回给ActionServlet并且提供相关的路由信息
    public class LoginAction extends Action {
    ......
    }
    步骤：
     (1) 继承Action类。
     (2) 覆盖 execute(...)方法。
     (3) 返回ActionForward对象 (提供决策信息给ActionServlet选择适当的视图响应用户) 。
     (4) 在struts-config.xml中配置:

    <action-mappings>
        <action input="/index.jsp"              ：ActionForm验证失败的跳转页面
            name="aForm"                        ：与Action对应的FormBean对象
            path="/myAction"                    ：请求URI(/myAction.do) 
            scope="session"                     ：FormBean作用域范围 
            type="action.LoginAction"           ：自定义的Action类
            validate="true"                     ：FormBean是否调用validate(...)方法
        >
            <forward name="success" path="/success.jsp" /> ：name对应的跳转的页面
        </action>
        ......
    </action-mappings>
    注：scope的值可以是request和session，默认是session

    c) ActionForm:封装HTTP请求中的数据
    将用户提交的数据自动填充(在相应的action的execute方法被调用之前)到form的属性中
    无需手工调用request.getParameter(…) 
    开发人员必须继承这个ActionForm类
    public class LoginForm extends ActionForm {
        ......
    }

  3) 处理流程(程序中的关系) 



4. Struts中的控制器
    1) ActionServlet
        在Struts 1.1中缺省采用ActionServlet类来充当控制器。
        当然如果ActionServlet不能满足你的需求，你也可以通过继承它来实现自己的类。这可以在/WEB-INF/web.xml中来具体指定。

    2) 用户定制的Action
        通过继承Action类来实现具体的用户定制的Action类。
        具体Action类的功能一般都在execute（以前是perform方法）方法中完成。

    3) ActionServlet
        继承HttpServlet类
        实质上就是一个Servlet

5. ActionServlet的职责
    接收客户端请求；从请求中获取数据，自动填充form
    根据客户端的URI将请求映射到一个相应的Action类
    调用Action类的execute()方法获取数据或者执行业务逻辑
    选择正确的视图响应客户
    负责初始化和清除应用配置信息的任务。
    读取web.xml中的(init-param)初始化参数，读取struts-config.xml中的配置信息

6. Action概述
    辅助ActionForm进行一些表单数据的检查。
    秉着MVC分离的原则，也就是视图级的验证工作放在ActionForm来完成，比如输入不能为空，email格式是否正确。而与具体业务相关的验证则放入Action中，这样就可以获得ActionForm最大重用性。
    执行必要的业务逻辑，比如存取数据库，调用实体bean等。
    业务逻辑应该分离到单独的JavaBean中，而Action只负责错误处理和流程控制。而且考虑到重用性的原因，在执行业务逻辑的JavaBean中不要引用任何与Web应用相关的对象，比如HttpServletRequest，HttpServletResponse等对象，而应该将其转化为普通的Java对象。
    更新服务器端的bean数据，后续对象中可能会用到这些数据，比如在JSP中利用bean:write来获得这些数据。
    根据处理结果决定程序的去处，并以ActionForward对象的形式返回给ActionServlet。

7. ActionForm
    自定义ActionForm
    必须继承ActionForm(抽象类)  org.apache.struts.action.ActionForm
    ActionForm必须为每个应该从请求中收集的HTML输入控件定义对应的属性及其getter/setter方法。
    重写validate方法实现验证(可选)
    如果想组装form前初始化属性，则需要重写reset方法(可选)
  * ActionForm作为数据缓冲
        ActionForm属性一般应该是String 类型，以便各种类型输入都可以捕获，不管有效还是无效。
        ActionForm字段不是输入的目的地，但它要缓冲数据，以便在提交之前进行校验。
    ActionForm作为数据校验器
        使用ActionForm的validate 方法来决定输入是否是正确的类型以及它们是否可以被业务过程使用。
        一旦这个阶段完成，Action 可以执行额外的校验，来决定输入是否满足业务层的其它要求。
    ActionForm作为类型转换器
        Struts 开发人员经常在ActionForm中包含一些helper方法，来进行类型转换。
    ActionForm作为传输对象(Transfer Object)
        象其它传输对象一样, 它承载的数据通常对应着持久层中的不止一个实体(比如不止一个数据库表)。
    ActionForm设计推论
        与业务逻辑bean共享属性名称
        因为它可以和业务逻辑bean进行交互, ActionForm通常可以使用业务逻辑bean中的一套相同的属性名称。业务逻辑bean表达的是模型的状态。form bean表达的是状态的改变。
    最小化用户代码
        ActionForm和Action 类都是设计来作为一个适配器，鼓励将业务代码保持在业务层，表现代码保持在表现层。

****************************************************************************









Day2:
1 视图选择
2 国际化
3 Struts中的异常处理
4 动态表单
5.标签库
*************************************************************************

一、视图选择
    局部转发与全局转发(优先级：局部转发的优先级比全局转发的优先级高)
    在 struts-config.xml 中配置：
    1) 局部转发:只对某个Action可见
       <action ... >
           <forward name="success" path="/success.jsp" />
           <forward name="error" path="/error1.jsp"></forward>
       </action>

    2) 全局转发：对所有的Action可见(共享) 
        <global-forwards>
            <forward name="success" path="/globalsuccessful.jsp"></forward>
        </global-forwards>

    尝试：把登录例子中的成功跳转设置为全局转发。看看其它 action 能不能用

二、Struts国际化
    I18N解决办法
    创建多个资源文件,根据用户设置选择不同资源文件
        ApplicationResources.properties
        ApplicationResources_en.properties
        ApplicationResources_zh.properties

    资源文件：
        用于映射页面中的静态信息、按钮标签、错误信息等，
        通过一个属性文件(.properties) 把所有页面的静态信息集中在一起，便于修改。

例子：
编写资源文件的步骤：
1) 编辑资源文件

login_en.properties
login.title=Login Page
login.success=Congratuation! You successfully login our System!
login.username=User Name
login.password=Password

添加对中文的支持txt(对应上面的名称)：
login.title=登录页面
login.success=恭喜你！你已经成功登录我们的系统了！
login.username=用户名
login.password=密码
login.submit=登录


转换本地编码为Unicode:
native2ascii login.txt login_zh.properties  ----->生成login_zh.properties文件
login.title=\u767b\u5f55\u9875\u9762
login.success=\u606d\u559c\u4f60\uff01\u4f60\u5df2\u7ecf\u6210\u529f\u767b\u5f55\u6211\u4eec\u7684\u7cfb\u7edf\u4e86\uff01
login.username=\u7528\u6237\u540d
login.password=\u5bc6\u7801
login.submit=\u767b\u5f55

  如果觉得 native2ascii 麻烦，可以直接在MyEclipse里建个空的login_zh.properties文件
  选“properties”图形界面，点“add”增加一条记录，name填login.title，value填"登录页面"就可直接生成。其余一个个加。

2)在struts-config.xml文件中配置资源文件<message-resources parameter="login" />
  parameter="***"  这里填写转码资源文件的地址和开头的名称。
  例如：文件地址com\yourcompany\struts\login_en.properties，则填：com.yourcompany.struts.login

3)在JSP文件中使用<bean:message key="login.title"/>标签输出资源文件中的值
  提交则写：<html:submit><bean:message key="login.submit"/></html:submit>

4)演示效果：
修改浏览器的设置，设为英文
英文界面少写了"login.submit"；则是找出中文的

5)图片国际化 和 按钮国际化
  1. 在资源文件中如下写：
     pic.show = /pic/2.jpg   //表示根路径下的pic/2.jpg图片
     中英的资源文件写上不同的图片地址，会根据语言找到不同的图片。
  2. 在页面中如下写：
     <html:img pageKey="pic.show"/>  //原理跟文字的国际化一样，只不过它找的是图片
  3. 按钮国际化
     资源文件如下写：
     button.submit = sure
     button.submit=\u767b\u5f55
     页面写：
     <html:submit>
         <bean:message key="button.submit" />
     </html:submit>



三、Struts中的异常处理
  java class: try/catch/finally/throws/throw/custom Exception class
  jsp: page指令 + web.xml配置<error-page>
  struts: try/catch/finally/throws/throw/custom Exception class

         声明方式(*)------->struts-config.xml
         定制异常处理器(*) 

  ActionErrors(或ActionMessages):异常的集合类
  ActionMessage:具体异常类


  方法一：
    在actionform的validate方法中处理(很少使用，一般用验证框架实现用户输入合法性验证) 
    通常只会象下面这样，做字符为空或超长的验证。
    (1)重写action form的validate方法

    @Override
    public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
        ActionErrors errors = new ActionErrors();
        if(username == null || username.equals("") || username.length() > 50) {
            ActionMessage msg = new ActionMessage("error.username");
            errors.add("errorusername", msg);
        }
        return errors;
    }
  
    (2)login_en.properties的内容:
    error.username=Please input the correct user name!
    login_zh.properties的内容:
    error.username=请输入正确的用户名信息！
    error.username=\u8bf7\u8f93\u5165\u6b63\u786e\u7684\u7528\u6237\u540d\u53ca\u5bc6\u7801\uff01

    (3)配置struts-config.xml文件
    在action标记内添加一个input属性和validate属性
    input属性的值-----表示发生错误后跳转到的页面
    validate属性的值-----表示ActionServlet是否去执行ActionForm的validate(...)方法，并且这个属性默认值是true
    <action-mappings>
        <action name="loginForm" path="/login" type="com.action.LoginAction" 
                input="/login.jsp" validate="true">
            <forward name="fail" path="/fail.jsp"></forward>
        </action>
    </action-mappings>

    (4)在login.jsp页面中加入<html:errors/>输出错误。


  方法二：
    在action的execute方法中处理(极少使用，知道这种方法就可以了) 
    (1)在action的execute方法中写错误处理的代码(和action form里valdiate方法的代码基本一致) 


例如：
对于登录用户例子----把narci的都列为黑名单。
Action:
ActionMessages errors = new ActionMessages();
    if("narci".equals(loginForm.getUsername())) {
        System.out.println("narci");
        ActionMessage msg = new ActionMessage("error.user.blacklist");
        errors.add("blacklist", msg);
        this.saveErrors(request, errors);      //比在form的validate方法多这两步
        return mapping.findForward("current"); //见上
}

    (2)并且在struts-config.xml中配置
    <forward name="current" path="/login.jsp"></forward>

    login_en.properties加入内容:
    error.user.blacklist=this user in blacklist!
    login_zh.properties加入内容:
    error.user.blacklist=该用户已被列入黑名单！
    error.user.blacklist=\u8be5\u7528\u6237\u5df2\u88ab\u5217\u5165\u9ed1\u540d\u5355\uff01
        
    (3) 在login.jsp页面中的 <html:errors/>  ---->用于页面中显示异常信息(通过资源文件映射) 


  方法三：
    通过抛出异常处理错误(推荐使用：处理业务逻辑方面出现的错误) 
    (1)在 com.exception 目录下创建 NoAuthorizationException 自定义异常类。
       在action的方法中抛出异常
       if("badboy".equals(loginForm.getUsername())) {
           throw new NoAuthorizationException();
       }
    (2)局部异常
    在struts-config.xml声明该异常的处理方法(通过exception标记)
    <action-mappings>
        <action name="loginForm" path="/login" type="com.action.LoginAction" 
                input="/login.jsp" validate="true">
            <exception key="errors.noauthorization" 
                type="com.exception.NoAuthorizationException" 
                path="/noauthorization.jsp">
            </exception>
            <forward name="fail" path="/fail.jsp"></forward>
            <forward name="current" path="/login.jsp"></forward>
        </action>
    </action-mappings>

    key="errors.noauthorization"    异常提示信息仍然通过资源文件作映射
    path="/noauthorization.jsp"     出现异常时的处理页面
    type="exception.NoAuthorizationException" Action处理业务过程中有可能出现的异常类型

    资源文件加入：
    errors.noauthorization=no authorization
    errors.noauthorization=当前用户没有授权！
    errors.noauthorization=\u5F53\u524D\u7528\u6237\u6CA1\u6709\u6388\u6743\uFF01

    创建 “/noauthorization.jsp” 页面，里面通过 <html:errors/> 放映出异常给客户端。

    (3)全局异常(对所有的action共享的，所以优先级应该比较低) 
    <global-exceptions>
        <exception key="errors.global" type="java.lang.Exception" path="/error.jsp"></exception>
    </global-exceptions>
    资源文件加入：
    errors.global=System Error! Please contact our administrators!
    errors.global=系统错误！请联系管理员！

    在LoginAction中加入
    if("admin".equals(loginForm.getUsername()) 
        && "".equals(loginform.getPassword())) {
        throw new Exception();
    }



四、动态表单
  可以减少ActionForm的数量(不用另外写)，完成对html form属性的动态映射，更便于应用维护。
  实现动态表单功能：通过struts-config.xml配置
    <form-beans >
        <form-bean name="dynForm" type="org.apache.struts.action.DynaActionForm">
            <form-property name="name" type="java.lang.String"></form-property>
            <form-property name="age" type="java.lang.String"></form-property>
            <!-- 虽然上面的 age 是整数，但用Integer会变0，还是用字符串接收比较好 -->
            <form-property name="city" type="java.lang.String"></form-property>
            <form-property name="gender" type="java.lang.String"></form-property>
            <form-property name="birthday" type="java.lang.String"></form-property>
            <!-- birthday 用java.util.Date会报错 -->
            <form-property name="email" type="java.lang.String"></form-property>
        </form-bean>
    </form-beans>

    <action-mappings >
      <action name="dynForm" path="/enroll" scope="request"
        type="com.tarena.struts.action.EnrollAction" >
        <forward name="success" path="/success.jsp" />
        <forward name="fail" path="/fail.jsp" />
       </action>
    </action-mappings>
    <message-resources parameter="com.tarena.struts.ApplicationResources" />

Struts中表单使用技巧：
  1)同类型或结构相近的html form通过一个ActionForm类型映射
  2)在都能满足需要的前提下，尽量使用动态表单
  3)ActionForm的作用域范围应尽量小，对于存放在session中的ActionForm，当不再使用时应销毁
  4)ActionForm主要用于控制器与视图之间传数据，不应包含任何业务逻辑

  实例：
    接收动态 ActionForm 的 Action:
        DynaActionForm dForm = (DynaActionForm)form;
        String name = (String)dForm.get("name");  //由于没有写ActionForm类，所以也没有其 getter
    设定动态ActionForm的某属性的值： dForm.set(name, value);














Day3:
1 定制Action
2 禁止表单重复提交
3 定制Controller
4 验证框架
************************************************************************

1 定制Action
1) DispatchAction：可以将相关的一组操作放在一个Action类中(同一模块功能) 
    特点(优点) ：
        1)一个 Action可以对应多个业务方法(CRUD)，而无需通过增加隐藏域的方式来处理。
        2)避免Action类数量随业务复杂度而膨胀，可以共享公共的业务逻辑代码。
        3)无需重写execute方法
        4)DispatchAction类本身已经重写了Action类的execute方法。

    实现DispatchAction的步骤：
        1) 继承DispatchAction
        2) 定义自己的处理方法，不要覆盖execute()方法。其实是被execute()方法调用，参数跟它一样。
            import javax.servlet.http.*;
            import org.apache.struts.action.*;
            public class MyDspatchAction extends DispatchAction {
                  public ActionForward doIt1( ActionMapping mapping, ActionForm form,
                           HttpServletRequest request, HttpServletResponse response ) {
                         String m = mapping.getParameter();
                         System.out.println( " *** doIt1(): " + m );
                         return null;
                  }
                  public ActionForward doIt2( ActionMapping mapping, ActionForm form,
                           HttpServletRequest request, HttpServletResponse response ) {
                         String m = mapping.getParameter();
                         System.out.println( " *** doIt2(): " + m );
                         return null;
                  }
           }
        3) struts-config.xml中action元素增加parameter属性
            <action path="/super" parameter="method"
                    type="com.tarena.action.MyDspatchAction">
                <forward name="success" path="/success.jsp"></forward>
            </action>
        用户请求URL应有如下格式：
            a)Get方法
               <a href="super.do?method=doIt1">1</a>
               <a href="super.do?method=doIt2">2</a>
            b) Post方法
               在表单中添加参数来完成

2) LookupDispatchAction: 
    特点：它是DispatchAction的子类，所以具备DispatchAction的所有特性，
        支持一个表单对应多个业务方法。

    实现LookupDispatchAction的步骤：
        (1) 继承LookupDispatchAction
        (2) 定义自己的处理方法，覆盖getKeyMethodMap()方法，不要覆盖execute()方法
           getKeyMethodMap()完成资源文件中Key与Action中方法映射
<%
          @Override
          protected Map getKeyMethodMap() {
            Map map = new HashMap();
            map.put("submit.modify", "modify");
            map.put("submit.add", "register");
            return map;
          }

          public ActionForward modify(ActionMapping mapping, 
                          ActionForm form,
                          HttpServletRequest request, 
                          HttpServletResponse response){
            ...
          }
          public ActionForward register(ActionMapping mapping, 
                          ActionForm form,
                          HttpServletRequest request, 
                          HttpServletResponse response){
            ...
          }
%>
        (3)struts-config.xml中为Action增加parameter属性
            <action path="/lookupAction"
                name="superForm"
                type="com.tarena.action.SuperGirlLookupAction"
                parameter="method">
                <forward name="success" path="/success.jsp"></forward>
            </action>

        (4) 提交页面按钮有如下格式
        html:submit的property属性值与Action中的parameter属性值映射
         <html:submit property="method">
             <bean:message key="submit.add"/>
         </html:submit>
         
        <html:submit property="method">
             <bean:message key="submit.modify"/>
        </html:submit>

3) Action编程技巧(建议) ：
    (1)尽量避免使用实例变量或静态变量
      (servlet是单实例多线程，所以要自己维护成员变量的同步问题) 
    (2)使用自己的BaseAction完成Action的公共操作，其余Action可从BaseAction派生
    (3)Action不要代替Model工作(只负责跳转)
      在设计多层架构时，使用Business Delegate可降低层与层之间的耦合度



2 禁止表单重复提交
    1)客户端实现(JavaScript) 


1.客户端方案(Java Script) 
使用js来实现禁止表单重复提交的方法很多，大体有如下几种：

1)提交时，使提交按钮不可用(disable)，或者隐藏按钮，使用进度条
参考实现：


/*
函数名称：disableButtons
函数功能：提交前,将所有表单中的button,reset,submit禁用disabled;
          如果是submit按钮，则添加与之相同隐藏文本框hidden对象,让提交的信息无一漏网
*/
function disableBtns() 
{
    for(k=0;k<document.all.length;k++ ) 
    {
        //当前节点对象
        var obj = document.all[k];
        if( obj.type=='button' || obj.type=='submit' || obj.type=='reset') 
        {
            obj.disabled = true;
            if (obj.type=='submit')
            {
                //添加隐藏节点
                var oNewNode = document.createElement("input");
                oNewNode.type = "hidden";
                oNewNode.name = obj.name;
                oNewNode.value = obj.value;
                obj.insertAdjacentElement("afterEnd",oNewNode);
            }
        }
    }
}


/*
函数名称：disButtons2
函数功能：提交前,将所有表单中的button,reset,submit禁用disabled;
          如果是submit按钮，则添加与之相同隐藏文本框hidden对象,让提交的信息无一漏网
函数说明：与上面的函数功能一样，但适用浏览器范围更广,推荐使用此函数。
*/
function disableBtns()
{
    for(k=0;k<document.forms.length;k++ ) 
    {
        //获取当前表单
        var frm = document.forms[k];
        for(i=0;i<frm.length;i++) 
        {
            var obj = frm.elements[i];
            if ( obj.type=='button' || obj.type=='submit' || obj.type=='reset' ) 
            {
                obj.disabled = true;
                if (obj.type=='submit') 
                {
                    var oNewNode = document.createElement("input");
                    oNewNode.type = "hidden";
                    oNewNode.name = obj.name;
                    oNewNode.value = obj.value;
                    //frm.insertAdjacentElement("beforeEnd",oNewNode);
                    obj.insertAdjacentElement("afterEnd",oNewNode);
                }
            }
        }
    }
}


/*
函数名称：hiddenForm
函数功能：提交时让表单自动隐藏，而不影响数据的提交
*/
function hideForm(form) 
{
    //waitStr 提交过程中出现的提示,可以自行设置
    var waiting = "<center><img src='progress.jpg'>数据正在提交中，请等候...</center>";
    form.innerHTML = "<div style='display:none;'>"+form.innerHTML+"</div>"+waiting;
}




2)使用标识来实现控制客户端多次点击

<script type="text/javascript">
    //控制标志
    var submitted = false;
    function checkSubmit() {
        if(submitted == true) {
            alert("submitted == true");
            return false;
        }
        submitted = true;
        return true;
    }
    
    //控制页面双击行为
    document.ondblclick = function docOnDblClick() {
        window.event.returnValue = false;
    }
    
    //控制页面单击行为
    document.onclick = function docOnClick() {
        if(submitted) {
            window.event.returnValue = false;
        }
    }
</script>



<html:form action="/logon" method="post" onsubmit="return checkSubmit();">
    <html:text property="name"></html:text>
    <html:submit value="login">
    </html:submit>
</html:form>


    2)JSP实现(脚本) 
        图解
        实现代码
    3)Struts实现
        (1)Struts内置实现，无需额外配置
        (2)需要在前一个action的方法中调用saveToken()方法
            this.saveToken(request);
        (3)在后一个执行业务逻辑的方法中使用isTokenValid(request)判断表单是否被重复提交
        if (isTokenValid(request)) {
            // invoke business method
            //......
            // reset transaction token after transaction success! //Token重置
            this.resetToken(request);
            return mapping.findForward("success");
        } else {
            System.out.println("duplicate token");
            return mapping.findForward("error");
        }

3 定制Controller(可选) 
    扩展控制器功能
        ActionServlet与RequestProcessor的作用
    1)继承RequestProcessor
    2)通过processPreprocess()增加定制功能
      //自定义控制器需要派生自RequestProcessor
      package com.controller;
      import javax.servlet.http.HttpServletRequest;
      import javax.servlet.http.HttpServletResponse;
      import org.apache.struts.action.RequestProcessor;
      public class SecurityRequestProcessor extends RequestProcessor {
          @Override
          protected boolean processPreprocess(HttpServletRequest request,
            HttpServletResponse response) {
            System.out.println("start controller ...");
            request.getSession().getServletContext().log("URL="+request.getRequestURL());//写日志
            String ip = request.getRemoteAddr();
            if (ip.equals("127.0.0.1")) {
                System.out.println("valid client: 127.0.0.1");
                return true; //只允许此IP登录
            }
            int lastPoint = ip.lastIndexOf(".");
            String fourth = ip.substring(lastPoint + 1);
            int fourthInt = Integer.parseInt(fourth);
            if (ip.startsWith("192.168.1.") && fourthInt > 50 && fourthInt < 60) {
                System.out.println("invalid client: 192.168.1.[50~60]");
                return false; //限制黑名单IP的登录
            }
            return false;
        }}
    3)struts-config.xml中配置 <controller .../> (一般只有一个controller) 
       写在<action-mappings /> 之后；<message-resources .../> 之前
       <controller processorClass="com.controller.SecurityRequestProcessor"/>

    补充说明：
        通常的一个struts-config.xml只能配置一个controller
        一般地，在开发时通过定制controller来增强系统功能，例如：日志、安全限制等。
        但在实际的应用中比较少使用。



4 验证(校验) 框架
    (1)有三种数据验证方式：
      a.在ActionForm.validate() 当中进行
      b.在Action.execute()方法中进行(这两种参看day2的异常处理，前两种) 
      c.引入validator框架(apache.jakata) 
    (2)声明式的数据验证(为什么能使用声明式？) --配置中定义验证规则
      原因：对于数据的验证有模式
    (3)validator框架已经定义了一部分通用的验证规则和逻辑
       开发者只需对特定数据指定具体的验证规则(业务)--使用 
       包含在validation.xml

    使用验证框架的步骤：
    1)在struts-config.xml配置校验插件(validate plugin) 
      放在<message-resources ../> 之后
       <plug-in className="org.apache.struts.validator.ValidatorPlugIn">
           <set-property property="pathnames" 
                value="/WEB-INF/validator-rules.xml,/WEB-INF/validation.xml"/>
       </plug-in>

      如果是使用1.3.x以上的版本，不需另外导入validator-rules.xml文件，只需写：
        <plug-in className="org.apache.struts.validator.ValidatorPlugIn">
            <set-property property="pathnames"
                value="/org/apache/struts/validator/validator-rules.xml, /WEB-INF/validation.xml"/>
        </plug-in>

      加上出错提示信息的资源文件配置，写在<plug-in>前
      <message-resources parameter="com.tarena.ApplicationResources" />

    注释：
        1.验证插件：
          1) validator-rules.xml :定义验证规则
            规则名(如：required, maxlength.....)；验证方法；验证失败时出错提示(放到上下文中) 
          2)validation.xml
            使用规则：对指定的表单属性进行校验
        2.基本的结构：
          1)验证逻辑：
            validateXxx()方法
          2)在validator-rule.xml中定义的都是校验规则
          3)在validation.xml中(声明式验证) 
            a.引入了struts-config.xml的表单名字(form-bean的名字) 
            b.声明域的验证依赖规则
              depends = "required,Integer" 

    2)add validator-rule.xml and validation.xml to /WEB-INF/
      copy validator-rule.xml from struts framework
      edit validation.xml
      注意版本的一致

    注意：如果是使用1.3.x以上的版本，可以不需复制validator-rules.xml文件，只需配置修改一下。

          validation.xml为：

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE form-validation PUBLIC
        "-//Apache Software Foundation//DTD Commons Validator Rules Configuration 1.3.0//EN"
        "http://jakarta.apache.org/commons/dtds/validator_1_3_0.dtd">

<form-validation>
    <formset>
        <form name="enrollForm"><!-- 可定义多个form -->
            <!-- required 表示不能为空 -->
            <field property="name" depends="required">
                <arg position="0" key="register.name"/>
                <!-- <arg>标签填写参数，出错则反应到资源文件。position表明第几个参数，可不写 -->
                <arg position="1" name="minlength" key="${var:minlength}" resource="false"/>
                <arg position="2" name="maxlength" key="${var:maxlength}" resource="false"/>
                <var><var-name>minlength</var-name> <var-value>6</var-value></var>
                <var><var-name>maxlength</var-name> <var-value>10</var-value></var>
                <!-- minlength 和 maxlength 定义字符串大小  -->
            </field>
            <field property="age" depends="required, integer">
            <!-- 上句表示不能为空，且必须是整数 -->
                <arg key="register.age"/>
                <arg position="1" name="intRange" key="${var:min}" resource="false"/>
                <arg position="2" name="intRange" key="${var:max}" resource="false"/>
                <var><var-name>min</var-name> <var-value>8</var-value></var>
                <var><var-name>max</var-name> <var-value>108</var-value></var>
            </field>
            <field property="email" depends="required,email">
            <!-- 上句表示不能为空，且必须是email形式，省去写验证邮件地址的正则表达式 -->
                <arg key="register.email"/>
            </field>
            <field property="birthday" depends="required, date">
                <arg key="register.birthday"/>
                <var>
                    <var-name>datePattern</var-name>
                    <var-value>yyyy-MM-dd</var-value>
                </var>
            </field>
        </form>
    </formset>
</form-validation>


    3)develop ur ActionForm (服务器端验证需要遵循的规范) 
      (1) 自定义ActionForm 要继承 ValidatorForm 
          最好不要重写validate方法！如果重写validate方法，则必须显式调用 return super.validate(...)方法
      (2) 动态form要继承 org.apache.struts.validator.DynaValidatorForm 

    4)(服务器端验证需要遵循的规范) 
        <action ..... validate="true"  input="假如出错的页面" >

    5)copy validation rules to ApplicationResources.properties

      register.title=Super Boy Register Form
      register.name=Name:
      register.gender=Gender:
      register.age=Age:
      register.city=City:
      register.email=Email:
      register.birthday=Birthday:

      # {0} 表示第一个参数
      errors.required={0} is required.
      errors.integer={0} must be an integer.
      errors.date={0} is not a date.
      errors.email={0} is an invalid e-mail address.

      errors.minlength={0} can not be less than {1} characters.
      errors.maxlength={0} can not be larged than {2} characters.

    6)active javaScript in Jsp page.(采用客户端验证才需要这一步)
      <html:javascript formName="enrollForm"/>
      <html:form action="/enroll" onsubmit="return validateEnrollForm(this)" method="post">


建议：(1) 客户端能做的验证，一般不要在服务器端验证。
         一般输入格式等方面的验证
      (2) 客户端实在没有能力进行验证的情况，发到服务器端做验证。

     事例见“./struts1.x/WorkSpace/day4/controllerWeb2”


















Day4:
一、 文件上传
    步骤：
    1)定义表单
     <html:form action="/fileupload" enctype="multipart/form-data">
      <table>
          <tr>
        <td><b>请选择上传的文件：</b></td>
        <td><html:file property="file"></html:file></td>
          </tr>
          <tr></tr>
          <tr>
          <td colspan=2 align=center>
              <html:submit>上传</html:submit>
          </td>
          </tr>
      </table>
     </html:form>
    2)配置stuts-config.xml
      *定义Form
      *定制Action

      a)form
        public class FileUploadForm extends ActionForm {
          private FormFile file;
          public FormFile getFile() { return file; }
          public void setFile(FormFile file) { this.file = file; }
        }
      b)action
        import java.io.*;
        import javax.servlet.http.*;
        import org.apache.struts.action.*;
        import org.apache.struts.upload.FormFile;
        public class FileAction extends Action {
            @Override
            public ActionForward execute(ActionMapping mapping, ActionForm form,
                    HttpServletRequest request, HttpServletResponse response)
                    throws Exception {
                FileUploadForm frm = (FileUploadForm)form;
                FormFile file = frm.getFile();
                InputStream is = file.getInputStream();
                String path = "d:\\temp\\" + file.getFileName(); //必须要先有这个文件夹存在
                byte[] databuffer = new byte[file.getFileSize()];
                try {
                    FileOutputStream fos = new FileOutputStream(path);
                    while(is.read(databuffer) != -1) {fos.write(databuffer);}
                } catch (IOException e) {}
                return mapping.findForward("success");
        }}








二、Struts Tiles----强大的页面模板与页面布局技术

1.作用：Tiles框架提供模板机制，完成页面布局和内容展示逻辑的解耦
    -------分离变与不变的元素：布局是不变的，而内容是变化的

2.如何使用tiles框架
步骤：
1) 在struts-config.xml配置tiles插件
    <plug-in className="org.apache.struts.tiles.TilesPlugin">
        <set-property property="definitions-config"
                  value="/WEB-INF/tiles-define.xml"/> <!-- 定义布局管理配置 -->
    </plug-in>

2) 定义tiles：tiles-define.xml
    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE tiles-definitions PUBLIC
           "-//Apache Software Foundation//DTD Tiles Configuration 1.3//EN"
           "http://struts.apache.org/dtds/tiles-config_1_3.dtd">
    <tiles-definitions>
        <definition name="definition1" page="/layout/baselayout.jsp">
            <put name="title" value="mainspace"></put>
            <put name="header" value="/layout/header.jsp"></put>
            <put name="footer" value="/layout/footer.jsp"></put>
            <put name="body" value="/layout/body.jsp"></put>
            <put name="navigator" value="/layout/navigator.jsp"></put>
        </definition>
        <definition name="user" extends="definition1">
            <put name="title" value="another mainspace"></put>
            <put name="body" value="/usermanager/user.jsp"></put>
        </definition>
    </tiles-definitions>

3) 定义布局以及所有的组成部分
    baselayout.jsp
    header.jsp
    footer.sjp
    body.jsp
    navigator.jsp


    变化的内容定义为：
    <tiles:getAsString name="title"/>
    <tiles:insert attribute="header">


    baselayout.jsp参考代码：
    -------------------------------------------------------------------------------------------------------
    <%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles"%>

    <html>
      <head>
        <title><tiles:getAsString name="title"/></title>
      </head>
      
      <body>
            <table border="0" width="100%" cellspacing="5">
                <tr><td colspan=2 align=center>
                        <tiles:insert attribute="header"></tiles:insert></td></tr>
                <tr><td width="15%" valign="top">
                        <tiles:insert attribute='navigator'></tiles:insert></td>
                    <td align="left">
                        <tiles:insert attribute='body'></tiles:insert></td></tr>

                <tr><td colspan="2"><hr></td></tr>
                <tr><td colspan=2 align=center>
                        <tiles:insert attribute="footer"></tiles:insert></td></tr>
            </table>
      </body>
    </html>
    -------------------------------------------------------------------------------------------------------


4) 在页面中引用 tiles：
    <tiles:insert definition="defall"/>
    也可以覆盖定义的属性值
    <tiles:insert definition="defall">
        <tiles:put name="title" value="my page"/>
    </tiles:insert>


3.使用tiles-define.xml定义tiles的好处：
    1) tiles可重用(被多个页面) 
    2) tiles的定义可以被"继承"和"覆盖"
    3) 使用已定义的definition































Struts 标签
************************************************************************************************

一、Struts标签库概述

1.回顾已经学了JSTL标签库
    标签库的作用：
    1.使得(jsp)页面开发人员不再依赖Java(EL表达式的作用也是如此) 
    2.功能封装：可重用

2.Struts的五类标签库
    Bean Tags ：用来创建bean、访问bean
    HTML Tags ：用来创建 html 页面的动态元素，对html进行了封装；
    Logic Tags：逻辑判断、集合迭代和流程控制。
    Nested Tags：该标签库建立在前三个标签库的基础上，具有前三个标签库的所有功能，只是允许标签间的嵌套。
    Tiles Tags ：该标签库包含的标签可以用来创建tiles样式的页面；布局专用。

3.重点学习前3类标签库



二、Bean标签
    可以看成 <jsp:useBean> 的增强版，
    它可以定义bean ：获取某些数据(cookie,请求参数，请求头)，将之定义成一个脚本变量，并同时置于某个作用域(缺省pagaContext) 中；

bean标签的公共属性：
    id - 定义一个变量
    name - 引用一个存在的bean或对象的名字
    property - 被引用的bean的属性
    scope - 放置或搜索bean的范围，若没有制定，则依次 page--request---session--application

1.<bean:define/>
    作用： 把一个bean 或其属性， 定义成一个变量

    * 通过<bean:define/>定义的变量可以通过JSP脚本、EL以及Struts本身的<bean:write/>标记访问。
    Example1:
    1) 定义一个Java bean:student，并且对其属性进行赋值
    2) 通过<bean:define/>定义stuName、stuAge、stuGender三个变量，将student这个对象的属性值赋值给这些变量
        <bean:define id="stuName" name="student" property="name"></bean:define>
        <bean:define id="stuAge" name="student" property="age"></bean:define>
        <bean:define id="stuGender" name="student" property="gender"></bean:define>
    3) 输出
        <%=stuName%>  //jsp形式
        ${stuAge }    //EL表达式
        <bean:write name="stuGender"/>  //Struts方式


    * 如果JavaBean的属性是List等类型，可以指定type属性
    Example2:
    1)在Java Bean中添加List属性，并提供get/set方法。
        private List songs;
        public List getSongs() {
            List list = new ArrayList();
            list.add("我爱北京天安门");
            list.add("我和你");
            list.add("我不做大哥好多年");
            return list;
        }
    2)<bean:define id="songs" name="student" property="songs"></bean:define>
    3)输出
        ${mySongs[0] }
    
    * 定义新变量，例如：
        <bean:define id="bookName" value="Effective Java"></bean:define>

2.<bean:write/>
    作用： 输出 bean 或bean属性；
    等价于:
    ${} 或者 <%= %>

3.<bean:message/>
    作用：读取属性静态文本内容，支持国际化(i18n) 
    Example:
    1)确认在类路径上含有
      com/ApplicationResources.properties
      配置路径： <message-resources parameter="com.ApplicationResources" />
    2)在文件中加入key,value对
      page.title=\u9875\u9762\u6807\u9898
    3)提供message.jsp
      使用<bean:message key="page.title"/>

4.<bean:size/>
    作用：获得一个集合或者数组的大小
    Example:
    1)定义Java Bean ： student
    2)读取student这个java bean的songs的size
        <jsp:useBean id="student" class="com.bean.Student"></jsp:useBean>
          <bean:size id="songsize" name="student" property="songs"/>
    3)输出songsize值

    Exapmple：定义一个列表，输出其size，要求使用<bean:size/>获取该值
    1)<%定义一个List,并初始化%>
    2)使用 <bean:size id="listsize1" collection="<%=list %>"/>  获取值
        注意：如果使用${}，必须要把list放置到范围对象中
    3)输出

5.<bean:cookie/>
    作用：读取请求头中cookie的信息
    * <bean:cookie id="cid" name="customid">
       获得指定的名为 "customid" 的coockie，并将其赋值给脚本变量 cid
    * 若找不到id为costCookie这个cookie，所以系统创建一个cookie，并将它的值设置为"uu11"
      <bean:cookie id="cost" name="costCookie" value="uu11"/>
     输出：  <bean:write name="cost" property="value"/>    //页面输出: uu11
    * <bean:cookie id="jsessionId" name="JSESSIONID"/>
     输出： <bean:write name="jsessionId" property="value"/> //页面输出JSESSIONID值，16进制的

6.<bean:header/>
    作用：获取请求头的属性信息
    <bean:header id="userAgent" name="User-Agent"/>
     //打印出：Mozilla/5.0 (X11; U; Linux i686; zh-CN; rv:1.8.0.7) Gecko/20061011....未完
    <bean:header id="host" name="host"/>
     //打印出：127.0.0.1:8080
    <bean:header id="dummy" name="UNKNOWN-HEAD" value="no defined Header"/>
     // no defined Header

7.<bean:include/>
    作用：对指定url(由forward、href或page确定)处的资源做一个请求，
    将响应数据作为一个String类型的bean绑定到page作用域，
    同时创建一个scripting变量。我们可以通过id值访问它们。

    Example:
    1)在根目录下定义一个文件：include.txt
    2)获取文件的内容数据，并赋于words
      <bean:include id="words" page="/include.txt"/>
    3)输出内容<bean:write name="words"/> 把include.txt的内容原样输出到页面

8.<bean:resource/>
    作用：获取指定的资源，以String或者InputStream的方式来读取，其中input属性是决定了对应的方式。
    默认(false)是以字符串的方式来读取。
    例如：
    <bean:resource id="r1" name="/include.txt" /> //打印文件原内容： Hello World!
    <bean:resource id="r2" name="/include.txt" input="true" />
     //打印出：java.io.ByteArrayInputStream@735f45    input="false"时同样这打印

9.<bean:parameter/>
    作用：取出url中queryString中指定参数名称的值
    例子：
        <bean:parameter id="target" name="action" />
        只会读取第一个名字为"action"的参数

        <bean:parameter id="ps" name="hobby" multiple="true" />
        把url中queryString中名字叫hobby的所有值赋值给变量ps,所以ps应该是一个数组

10.<bean:page/>
    作用：把pageContext中的特定的隐含对象(application, request, response, config, session) 取出来，
    绑定到某个id中，本页的其它地方就可以使用id来操纵这些隐含对象了。

    Example:
    <bean:page id="res" property="response" />
    <bean:page id="sess" property="session" />

    <bean:write name="res" property="contentType"/>
    <bean:write name="res" property="characterEncoding"/>
    <bean:write name="sess" property="id"/>
    <bean:write name="sess" property="maxInactiveInterval"/>
    

三、HTML标签库
使用taglib指令引入标签库
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>

通常是配合bean标签一起使用，是struts中最常用的标签之一。

1.<html:form/>
    作用：对html的form表单进行简单的封装，满足struts中表单请求的处理
    <html:form action="/login">
        
    </html:form>
    如果你有上述一个标签，那么你的Struts配置文件的元素中必须有一个如下内容：
    <action-mappings>
        <action input="/login.jsp" name="loginForm" path="/login"
            type="action.LoginAction" validate="true">
            <forward name="success" path="/success.jsp" />
            <forward name="error" path="/error.jsp" />
        </action>
    </action-mappings>
    这就是说一个form标签是和form bean相关联的。
    任何包含在<form>中用来接收用户输入的标签
    (<text>、<password>、<hidden>、<textarea>、<radio>、<checkbox>、<select>) 
    必须在相关的form bean中有一个指定的属性值。<form>标签中method属性的缺省值是POST 

2.<html:link>
    作用：超文本连接
    属性：page，指定一个页面的路径，必须以/开始。

    Example:
    当前页面跳转到/bean/parameter.jsp
    需要提供参数：
    <bean:define id="beanName" value="beanValue"></bean:define>
      <html:link page="/bean/parameter.jsp"
          paramId="action" paramName="beanName">
          <html:param name="hobby" value="sports"></html:param>
          跳转到bean/parameter.jsp
      </html:link>

    这等价于：
    http://localhost:8080/工程名/bean/parameter.jsp?hobby=sports&action=beanValue
    <a href="/工程名/bean/parameter.jsp?hobby=sports&amp;action=beanValue">跳转到parameter.jsp</a>



3.<html:errors/>
    作用：输出错误信息
    异常处理会介绍

    Example:
    1)在资源文件中定义
        property1.error1=Property1 Error1
        property2.error1=Property2 Error1
        property2.error2=Property2 Error2
        property2.error3=Property2 Error3
        property3.error1=Property3 Error1
        property3.error2=Property3 Error2

        globalError=Global Error

        property1.message1=Property1 Message1
        property2.message1=Property2 Message1
        property2.message2=Property2 Message2
        property2.message3=Property2 Message3
        property3.message1=Property3 Message1
        property3.message2=Property3 Message2

        globalMessage=Global Message

        messages.header=<table border=1><tr><td>错误变量</td><td>错误信息</td></tr>
        messages.footer=</table>
    2)添加jsp文件并编辑
        <%@ page import="org.apache.struts.action.*"%>
        <%@page import="org.apache.struts.Globals"%>
        <%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
        <%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>

        <%
            ActionMessages errors = new ActionMessages();
            errors.add("property1", new ActionMessage("property1.error1"));
            errors.add("property2", new ActionMessage("property2.error1"));
            errors.add("property2", new ActionMessage("property2.error2"));
            errors.add("property2", new ActionMessage("property2.error3"));
            errors.add("property3", new ActionMessage("property3.error1"));
            errors.add("property3", new ActionMessage("property3.error2"));
            errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("globalError"));
            request.setAttribute(Globals.ERROR_KEY, errors);

            ActionMessages messages = new ActionMessages();
            messages.add("property1", new ActionMessage("property1.message1"));
            messages.add("property2", new ActionMessage("property2.message1"));
            messages.add("property2", new ActionMessage("property2.message2"));
            messages.add("property2", new ActionMessage("property2.message3"));
            messages.add("property3", new ActionMessage("property3.message1"));
            messages.add("property3", new ActionMessage("property3.message2"));
            messages.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("globalMessage"));
            request.setAttribute(Globals.MESSAGE_KEY, messages);
        %>

    3)输出相应的(出错) 信息：
        <table border=1>
            <tr>
                <td>错误变量</td>
                <td>错误信息</td>
            </tr>
            <tr>
                <td>property1</td>
                <td><html:errors property="property1" /></td>
            </tr>
            <tr>
                <td>property2</td>
                <td><html:errors property="property2" /></td>
            </tr>
            <tr>
                <td>property3</td>
                <td><html:errors property="property3" /></td>
            </tr>
            <tr>
                <td>org.apache.struts.action.GLOBAL_MESSAGE</td>
                <td><html:errors
                    property="org.apache.struts.action.GLOBAL_MESSAGE" /></td>
            </tr>
            <tr>
                <td>All</td>
                <td><html:errors /></td>
            </tr>
        </table>

        <html:messages message="true" id="msg"
            header="messages.header" footer="messages.footer">
            <tr>
                <td></td>
                <td><bean:write name="msg" /></td>

            </tr>
        </html:messages>

4.<html:image>与<html:img>
    作用：在页面中产生图像的输出
    最重要的属性page：图象文件的路径，前面必须带有一个斜线。
    其它属性：height、width(只有 img 可以设置长和宽)、alt(图片描述)。

    Example：
    <html:image page="/f4icmu.jpg" alt="软件工程之通俗版"></html:image>
    <html:img page="/f4icmu.jpg"/>
    等价于：
    <input type="image" name="" src="/工程名/f4icmu.jpg" alt="软件工程详解">
      <img src="/工程名/f4icmu.jpg">


5.<html:checkbox/>
    生成一个checkbox。这里的value值可以是true，yes或on。
    checkboxForm的属性：
    private boolean one = false; 
    private boolean two = false; 
    private boolean three = false;

    <html:checkbox name="checkboxForm" property="one">One</html:checkbox> 
    <html:checkbox name="checkboxForm" property="two">Two</html:checkbox> 
    <html:checkbox name="checkboxForm" property="three">Three</html:checkbox> 
    如果选中后被提交则相应的属性的值为true。

6.<html:radio/>
    生成一个radio。主要的用法有两种。
    下面的代码示例了html:radio标签的一般用法，
    如果被提交则选中的radio的value值将被提交到radioForm中的id中。
    <html:radio name="radioForm" property="id" value="00001"> One </html:radio>
    <html:radio name="radioForm" property="id" value="00002"> Two </html:radio> 

7.<html:select>标签和<html:option>标签 
    作用：对html中的下拉选择标签与选项标签做了封装

    单选下拉
    Example1:
     <html:select property="singleSelect" size="3">
         <html:option value="Single 0">Single 0</html:option>
         <html:option value="Single 1">Single 1</html:option>
         <html:option value="Single 2">Single 2</html:option>
     </html:select>

     Example2:性别
     1)提供label和value的数组
         <% String[] label = { "男", "女", "未知" };
            String[] value = { "male", "female", "unknown" };
            pageContext.setAttribute("label", label);
            pageContext.setAttribute("value", value);
        %>
    2)标签使用：
            <html:select property="sex" size="1">
                <html:options labelName="label" name="value" />
            </html:select>
    
    Example3:兴趣爱好多选
    1)提供列表
        <%  List options = new ArrayList();
            options.add(new LabelValueBean("电脑游戏", "PCGame"));
            options.add(new LabelValueBean("看电视", "TV"));
            options.add(new LabelValueBean("阅读", "Reading"));
            options.add(new LabelValueBean("唱歌", "Singing"));
            pageContext.setAttribute("opt", options);
        %>

    其中，
        public class LabelValueBean {
            private String label;
            private String value;
            public LabelValueBean(String label, String value){}
        }

    2)提供多选标签
            <html:select property="favors" multiple="true">
                <html:options collection="opt" property="value"
                    labelProperty="label" />
            </html:select>
    
    Example4:联系方式多选
    1)提供多选列表
        <%  List myPhones=new ArrayList();
            myPhones.add(new LabelValueBean("小灵通","33213322"));
            myPhones.add(new LabelValueBean("固话","80512010"));
            myPhones.add(new LabelValueBean("手机","13711221113"));
            pageContext.setAttribute("myPhones",myPhones);
         %>
    2)标签的使用
        <html:select property="phones" multiple="true">
            <html:optionsCollection name="myPhones"/>
        </html:select>
    
8.<html:submit>标签
    <html:submit value="Submit" />


9.<hmtl:text>标签 
    文本输入框
    <html:text property="username" />

10.<html:password>标签
    <html:password property="password"/>

11.<html:cancel/>取消标签


四、Logic标记 : 
    该标签库包含的标签可以用来进行逻辑判断、集合迭代和流程控制。 
1.<logic:iterate/>
    作用：<logic:iterate/>标签用来迭代集合
    Example:
    <%
    List stuList=new ArrayList();
         Student stu=new Student();
         stu.setName("Alice");
         ...
         stuList.add(stu);
         request.setAttribute("stuList",stuList);
    %>
    <logic:iterate id="stu" name="stuList">
         <tr>
        <td>${stu.id }</td>
        <td>${stu.name }</td>
        <td>${stu.sex }</td>
        <td>${stu.age }</td>
        <td>${stu.desc }</td>
         </tr>
    </logic:iterate>

(2) logic:empty  
    用来判断是否为空的。如果为空，该标签体中嵌入的内容就会被处理。该标签用于以下情况：
    当Java对象为null时 
    当String对象为""时 
    当java.util.Collection对象中的isEmpty()返回true时 
    当java.util.Map对象中的isEmpty()返回true时 
    下面的代码示例了logic:empty标签判断集合persons是否为空：

    <logic:empty name="stu" property = "books"> 

    <div>集合books为空!</div> </logic:empty>
     logic:notEmpty标签的应用正好和logic:empty标签相反。



(3) logic:equal    
    这里要介绍的不只是logic:equal(=)标签，而是要介绍一类标签，这类标签完成比较运算，
    包括：
    logic:equal(=) 
    logic:notEqual(!=) 
    logic:greaterEqual(>=) 
    logic:lessEqual(<=) 
    logic:graterThan(>) 
    logic:lessThan(<) 

    Example:
        <logic:equal name="stu" property="name" value="Alice">
        I am Alice.
        </logic:equal>

        <bean:define id="count" value="168"/>
        <logic:equal name="count" value="168">
        Good lucky number.
        </logic:equal>













<Struts-config> 配置
************************************************************************************************
<Struts-config>的子组件
  set-property     指定额外javaBean组态属性的方法名称和初值。
  data-sources     指定一组DataSource对象(JDBC 2.0 标准扩充组件)
  data-source      指定一个要建立、组态的Datasource对象，而且可以作为服务件背景属性(或程序范围javaBean)





