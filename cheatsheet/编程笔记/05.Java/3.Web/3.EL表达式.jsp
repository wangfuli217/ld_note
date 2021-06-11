
一、EL(Expression Language----表达式语言)
 为网页美工而设，跟java语句相似；尽量减少java程序的依赖(不能要求美工使用java)
 1.语法
   表达式          vs.    EL表达式语言(JSP2.0)
   <%=name%>     <=>       ${name}
 2.文字
   在 EL 表达式中，数字、字符串、布尔值和 null 都可以被指定为文字值(常量)。
   字符串可以用单引号或双引号定界。布尔值被指定为 true 和 false 。
  例子：
   表达式                              值
   -----------------------------------------------------------------------
   ${-168.18}                         -168.18
   ${3.8e-18}                         3.8e-18           //科学计数法
   ${3.14159265}                      3.14159265
   ${"Hello JSP EL!"}                 Hello JSP EL!     等价于 <%="Hello JSP EL!"%>
   ${'Hello JSP EL...'}               Hello JSP EL...
   ${true}  //can be TRUE?            true
   ${false} //can be FALSE?           false
   ${str==null}                       true              //布尔值的表达式

 3.EL 运算符
   类别               运算符
   -------------------------------------------------------------
   算术运算符        +、  -、  *、  /(或 div)、    %(或 mod)
   关系运算符        ==(或 eq)、    !=(或 ne)、    <(或 lt)
                 >(或 gt)、     <=(或 le)、    >=(或 ge)
   逻辑运算符        &&(或 and)、   ||(或 or)、    !(或 not)
   验证运算符        empty
     其中，empty 判断一个变量是否为null或是否包含有效数据:
     if(name==null||name.equlas(""))  等价于  ${empty name} ->    true
  例子：
    表达式                              值
   -------------------------------------------------------------
    ${3+5.1}                           8.1
    ${"Hello"+",Tarena!"}              报错！  // EL的"+"没有字符串连接功能
    ${5*2}                             10
    ${9.3/3}                           3.1
    ${9.3 div 3}                       3.1
    ${8 div 0}                         Infinity // 表示无穷大
    ${9%2}                             1
    ${9 mod 2}                         1
    ${8*6>68 ? "Yes" : "No"}           No   //三目表达式
   <% String name="";
    request.setAttribute("name",name);      //如果没有 setAttribute ，则必定是空
   %>
    ${empty name}                      true //对范围对象内的变量或对象进行判空

 4.变量和JavaBean属性数据输出
   表达式语言输出变量，是到范围对象(pageContext,request,session,application)中查找相应属性。
   而非直接在页面中查找实例或局部变量。
  表达式语言查找变量的顺序是:
   pageContext -> request -> session->application， 所有范围都未找到时，赋值null

 5.存取器
   []    ->输出对象属性值，输出数组或集合中对应索引值
   .     ->输出对象属性值
  例子：
   <% SuperGirl girl = new SuperGirl();   girl.setName("Alice");
      session.setAttribute("girl",girl);  %>  //一定要有这句，设置成范围对象
   ${girl["name"]}
   ${girl['name']}   //拿属性时，单引跟双引等价
   ${girl.name}      //这种方法同样可以

   <%  List aList = new ArrayList();
       aList.add("China");  aList.add(girl);  aList.add(168.18);
       session.setAttribute("aList", aList); %>
   ${aList[0]}   //使用下标来取值 "China"
   ${aList[1]}   //取得对象的引用地址  还可以嵌套：${aList[1]['name']}
   ${aList[3]}   //下标越界，不会报错；只是取不出值

   <%  Map map = new HashMap();
       map.put("name", "Kitty");  map.put("age", "25");  map.put("date", new Date());
       map.put("aList", aList);
       request.setAttribute("map", map); %>
   ${map.date}     ${map["date"]}     //这两个等效
   ${map.aList[0]} ${map["aList"][0]} //这两个也等效
   ${map.aList[1][name]}              //嵌套取值

 6.隐含对象
   el提供了自己的一套隐含对象，方便在页面内对各种常用数据信息的访问.
    EL隐藏对象                         JSP隐藏对象
   --------------------------------------------------------------------------------
    pageScope                         pageContext
    requestScope                      request
    sessionScope                      session
    applicationScope                  appication

    param：               request.getParameter()
    paramValues：         在提交表单里，有多个输入域同名getParameterValues
    header：              request.getHeader() 按照key-value的形式取出；value:是一个String类型的值
    headerValues          按照key-value的方式取出，但是headerValues里面的value是一个String类型的数组
    cookie                request.getCookies()
    initParam             context param

  例子：
    1)超女登记信息
      enroll.html
      <form action="index.jsp" method="post">
        <table border="1">
        <tr><td>姓名：</td>
            <td><input type="text" name="name"></td></tr>
        <tr><td>年龄：</td>
            <td><input type="text" name="age"></td></tr>
        <tr><td>城市：</td>
            <td><input type="text" name="city"></td>  </tr>
        <tr><td align="center" colspan="2"><input type="submit" value="提交"></td></tr>
        </table>
      </form>

      index.jsp
      <jsp:useBean id="SuperGirl" class="vo.SuperGirl" scope="page"></jsp:useBean>
      <jsp:setProperty name="SuperGirl" property="name" value="${param.name}"/>
      <jsp:setProperty name="SuperGirl" property="age"  value="${param.age}"/>
      <jsp:setProperty name="SuperGirl" property="city" value="${param.city}"/>
      <table border="1">   <% //把设置输出出来 %>
        <tr><td>姓名：</td>
            <td>${SuperGirl.name}</td></tr>
        <tr><td>年龄：</td>
            <td>${SuperGirl.age}</td></tr>
        <tr><td>城市：</td>
            <td>${SuperGirl.city}</td></tr>
      </table>

    2)范围对象
      <%  pageContext.setAttribute("name", "page");
        request.setAttribute("name", "request");
        session.setAttribute("name", "session");
        application.setAttribute("name", "application"); %>

      ${name}    // pageContext -> request -> session->application
      ${pageScope.name}
      ${requestScope.name}
      ${sessionScope.name}
      ${applicationScope.name}

    3)paramValues
      在enroll.html加入： 兴趣
        <table>
      <input type="checkbox" name="habit" value="Reading"/>读书
      <input type="checkbox" name="habit" value="Game"/>游戏
      <input type="checkbox" name="habit" value="Music"/>音乐
        </table>
      //提交后，获取输入内容
      ${paramValues.habit[0]}
      ${paramValues.habit[1]}
      ${paramValues.habit[2]}

    4)initParam
      web.xml
      ...
      <context-param>
        <param-name>server</param-name>
        <param-value>Tomcat5.5</param-value>
      </context-param>
      ...
      ${initParam.server}

    5)header
      ${header["host"]}
      ${header["accept"]}
      ${header["user-agent"]}


 7.可以自由设置是否支持表达式语言
   <%@page isELIgnored="false"%> : default:false  可以使用EL，改成 true 之后，写EL就会报错

   配置web.xml也可达到同样的效果(同时存在，那种起作用？)
   (禁用脚本和EL)  默认都是false
   ...
   <jsp-config>
     <jsp-property-group>
       <url-pattern>*.jsp</url-pattern>
       <el-ignored>true</el-ignored>               //设置成所有jsp文件都禁用EL
       <scripting-invalid>true</scripting-invalid> //设置成禁用脚本
     </jsp-property-group>
   </jsp-config>
   ....
   页面的page指令设置isELIgnored属性的优先级比web.xml中<el-ignored>设置的高(当然是范围小的生效)
