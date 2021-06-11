
JSTL(JSP Standard Tag Library )
    减少java代码，简化页面编写；功能封装，提高可重用性
    将页面的逻辑代码全封装起来，让美工不用管逻辑；因而页面的逻辑需抽离页面。
    为使业务层程序员不用理会页面设计，因而含有页面显示的代码不能写在 javaBean 里面。

 1.如何使用JSTL
   1)对于Java EE之前(即J2EE规范1.4及之前版本)
     a、复制jstl的jar包(jstl.jar,standard.jar)到/WEB-INF/lib
     b、再使用jstl功能的jsp页面中增加指令
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>   //核心标签库
        <%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
        <%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>  //数据库标签库
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
        //prefix 表前缀(可改，但通常按这写的用)； uri 指向标签库的入口
   2)Java EE规范把jstl作为规范的一部分
     所以现在的jstl-1.2已经包含了原来的jstl.jar , standard.jar

 2.core:核心标签库
   一般用途
   在JSTL中，一般用途的标签主要是指具有输出，设置变量，和错误处理等功能的标签，他们在jsp中使用比较频繁，它们有：
  -----------
  |a、<c:set>|
  -----------
   语法：<c:set value="value" var="varName" [scope= "{page|request|session|application}"]/ >
        <c:set value="value" target="target" property="propertyName"/ >
   这个标签用于在某个范围(page,request,session,application)里面设置特定的值
   (默认为page)，或者设置某个已经存在的javabean的属性。
   例子：
     <c:set var="counter" value="200"/>
     ${counter}//输出

     <c:set var="tarena">Tarena It Traning Ltd.</c:set>
     ${tarena}

   可以指定范围，默认是page
    <c:set value="20" var="maxIdelTime" scope="session"/>
    ${maxIdelTime}

   设置JavaBean的值
    <jsp:useBean id="girl" class="vo.SuperGirl"/>
    <c:set value="Shirly" target="${girl}" property="name"/>
    <td>girl.name</td>
    <td>${girl.name}</td>

  --------------
  |b、<c:remove>|
  --------------
  语法：
    <c:remove var="varName" [scope= "{page|request|session|application}"]/ >
    它的作用是删除某个变量或者属性。
  例子：
    <c:set value="10000" var="maxUser" scope="application"/>
    <c:set value="10" var="count" scope="session"/>
    <c:set value="10" var="count"/>
    ${maxUser}
    ${count}
    <c:remove var="maxUser" scope="application"/>
    <c:remove var="count" scope="session"/>
    ${maxUser}
    ${count}

  -----------
  |c、<c:out>|
  -----------
  语法：<c:out value="value" [escapeXml]="{true|false}" [default="defaultValue"]/>
  注意:escapeXml的作用是是否将代码交给xml解析器解释，true为交给xml解析器解释(默认)，false为交给浏览器解释。
      default 定义缺省值。

  例子：
    <c:set var="sessionZhang3" value="zhang3-s" scope="session"/>
    <c:set var="table" value="<table><tr><td>sessionZhang</td></tr></table>" scope="page"/>
    <c:set var="requestZhang3" value="zhang3-r" scope="request"/>
    <c:out value="以下输出前面设置的属性<br>" escapeXml="false"/>

    <td colspan=2>
        <c:out value="${sessionZhang3}"/><br>
        <c:out value="${table}" escapeXml="false" /><br>//输出表格；escapeXml="true"时只显示字符串
        <c:out value="${requestZhang3}"/><br>
        <c:out value="${nodefined}" default="没有nodefined这个变量"/>
    </td>

  -------------
  |d、<c:catch>|
  -------------
  它的作用是捕捉由嵌套在它里面的标签所抛出来的异常。类似于<%try{}catch{}%>
  语法：<c:catch [var="varName"]>nested actions</c:catch>
  例子：
    <c:catch var="error"><% Integer.parseInt("abc"); %></c:catch>
    <% try{ Integer.parseInt("abc"); }catch(Exception error) {  } %> //等价

     <c:out value="${error}"/>
     <c:out value="${error.message}"/>
     <c:out value="${error.cause}"/>


  控制语句：
  -----------
  |a、 <c:if>|
  -----------
  语法：
    <c:if test="testCondition" var="varName"
    [scope="{page|request|session|application}"]>
       Body内容
    </c:if>  // 注：没有 else
  例子：
     <c:set var="age" value="16"/>
     <c:if test="${age<18}">
        <h1 align=center>您尚未成年，不能进入游戏中心！</h1>
     </c:if>

  --------------
  |b、<c:choose>|
  --------------
  例子：
    <c:set var="tax" value="5000" />
    <c:choose>
         <c:when test="${tax <=0}">
              您今年没有纳税！
         </c:when>
         <c:when test="${tax<=1000&&tax>0}">
           您今年缴纳的税款为${tax},加油！
         </c:when>
         <c:when test="${tax<=3000&&tax>1000}">
           您今年缴纳的税款为${tax},再接再励哦！
         </c:when>
         <c:otherwise>
           您今年纳税超过了3000元，多谢您为国家的繁荣富强作出了贡献！
         </c:otherwise>
     </c:choose>

  ---------------
  |c、<c:forEach>| 循环
  ---------------
  语法： <c:forEach [var="varName"] items="collection"  [varStatus="varStatusName"]
         [begin="begin"] [end="end"] [step="step"]>
           Body 内容
        </c:forEach>
   items：需要迭代的集合；var：迭代时取集合里的值；
  例子：
    <%  List aList=new ArrayList();
        aList.add("You");       aList.add("are");   aList.add("a");
        aList.add("beautiful"); aList.add("girl");
        request.setAttribute("aList",aList);  %>
    <center> <table border=1>
       <c:forEach var="word" items="${aList}">
         <tr><td>${word }</td></tr>
       </c:forEach>
    </table> </center>

    <c:forEach items='${header}' var='h'>
       <tr>
         <td><li>Header name:<c:out value="${h.key}"/></li></td>
         <td><li>Header value:<c:out value="${h.value}"/></li></td>
       </tr>
    </c:forEach>

  另外一种用法： (类似 for 循环)
   <c:forEach var="count" begin="10" end="100" step="10">
       <tr><td>
         <c:out value="${count}"/><br>
       </td></tr>
   </c:forEach>


  URL
  ---------------
  |a、<c:import> |
  ---------------
  相当于<jsp:include>
   <c:import url="footer.jsp" charEncoding="GBK">
      <c:param name="name" value="Java"/>
   </c:import>

  -----------
  |b、<c:url>|
  -----------
  用于构造URL，主要的用途是URL的重写。
    <c:url var="footer1" value="footer.jsp"/>
    <c:url var="footer2" value="footer.jsp" scope="page">
        <c:param name="name" value="Sofie"/>
    </c:url>
    <c:out value="${footer1}"/>
    <c:out value="${footer2}"/>

    <c:url var="next" value="next.jsp"/>
    <a href="${next}">next</a><br>
       等价于
    <a href="<c:url value='next.jsp'/>">next</a> //在 Html 里可嵌套 JSTL

  ----------------
  |c、<c:redirect>|
  ----------------
   //等价于 <jsp:forward>
    <c:redirect url="${footer2}"/>
  例如：
    <c:url var="next" value="next.jsp"/>
    <c:redirect url="${next}"/>


 3.SQL
   <sql:setDataSource>
   <sql:query>
   <sql:update>
   <sql:param>

    <!-- 设置数据源 -->
    <%@page contentType="text/html; charset=GBK"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
      <sql:setDataSource   var="ds"  driver="com.mysql.jdbc.Driver"
       url="jdbc:mysql://localhost:3306/tarena"
       user="root" password="11111111" />

  a、查询
    <sql:query var="rs" dataSource="${ds}" sql="select * from users" ></sql:query>
    <c:forEach var="user" items="${rs.rows}">
        <tr>
          <td>${user.userid}</td>
          <td>${user.username}</td>
          <td>${user.password}</td>
          <td>${user.role}</td>
        </tr>
    </c:forEach>

  b、插入记录
    <sql:update dataSource="${ds}" sql="insert into users values(101,'holemar','123','admin')"
     var="i"></sql:update>
    <hr>插入${i}条记录.

  c、更新记录
    <sql:update dataSource="${ds}"
     sql="UPDATE users SET username='Gavin King' WHERE userid=101" var="i"></sql:update>
    <hr>更新${i}条记录.

    <sql:param>
     作用：设置sql语句中"?"表示的占位符号的值。
    <sql:update dataSource="${ds}" sql="UPDATE users SET username=? WHERE userid=?" var="i">
    <sql:param value="Rod Johnson" /> //设第一个问号
    <sql:param value="100" />         //设第二个问号
  </sql:update>
  参数等价于
  //pstmt.setString(1,"Rod Johnson");
  //pstmt.setInt(2,100);

