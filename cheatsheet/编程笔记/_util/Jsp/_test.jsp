<%--

/**
 * <P> Title: Holemar                                            </P>
 * <P> Description: 测试页面                                     </P>
 * <P> Copyright: Copyright (c) 2013/07/15                       </P>
 * <P> Company:Vuclip Tech. Ltd.                                 </P>
 * @author <A href='daillow@gmail.com'>Holer W. L. Feng</A>
 * @version 0.1
 */

--%><%@ page
    language = "java"
    pageEncoding = "UTF-8"
    contentType  = "text/html; charset=UTF-8"
    import = "java.util.*"
    import = "java.sql.*"
    import = "java.io.*"
    import = "java.lang.reflect.*"
    import = "javax.servlet.jsp.JspWriter"

%><%!

/**
 * 反射某类
 */
public void showReflection(JspWriter out, Object obj) throws Exception {
    if (obj == null) return;
    Class c = obj.getClass();
    showReflection(out, c, obj);
}
/**
 * 反射某类
 */
public void showReflection(JspWriter out, String objName) throws Exception {
    Class c = Class.forName(objName);// 字符串为类的全名,如 com.my.AA
    showReflection(out, c, null);
}
/**
 * 反射某类
 */
private void showReflection(JspWriter out, Class c, Object obj) throws Exception {
    if (c == null) return;

    out.println("<br /><br />*********** 反射类:" + c.getName() + "<br/>");
    System.out.println("\r\n\r\n*********** 反射类:" + c.getName());

    /* //读取构造函数
    java.lang.reflect.Constructor[] cons = c.getConstructors();
    for (int i=0; i<cons.length; i++) {
        java.lang.reflect.Constructor con = cons[i];
        String show = "";
    }*/
    //读取方法
    java.lang.reflect.Method[] m = c.getDeclaredMethods();// 读取它的全部方法(包括私有，但不包括父类的)
    for (int i=0; i<m.length; i++) {
        java.lang.reflect.Method m1 = m[i];// 拿其中的第i个方法
        m1.setAccessible(true);// 把private的属性设成可访问，否则不能访问
        String show = "方法: " + m1.toGenericString();
        show = show.replaceAll(" java[.]lang[.]", " ");
        out.println(show + "<br/>");
        System.out.println(show);
    }
    //反射出所有的字段
    java.lang.reflect.Field[] f = c.getDeclaredFields(); // 读取全部字段(包括私有，但不包括父类的)
    for (int i=0; i<f.length; i++) {
        java.lang.reflect.Field f1 = f[i];// 拿其中的第i个方法
        f1.setAccessible(true);// 把private的属性设成可访问，否则不能访问
        String show = "属性: " + f1.getName();
        if (obj != null) show += " : " + f1.get(obj);
        out.println(show + "<br/>");
        System.out.println(show);
    }

    out.println("**************** 反射类 end *******************<br/>");
    System.out.println("**************** 反射类 end *******************");
}

/**
 * 遍历 Map
 */
public void showMap(JspWriter out, Map map) throws Exception {
    if (map == null) return;
    out.println("<br /><br />*********** 遍历 Map *******************<br/>");
    System.out.println("\r\n\r\n*********** 遍历 Map *******************");

    //方法一： (会比方法二快很多)
    for ( Iterator iter = map.entrySet().iterator(); iter.hasNext(); )
    {
        Map.Entry entry = (Map.Entry) iter.next();
        Object key = entry.getKey();
        Object value = entry.getValue();
        String show = key + " = " + value;
        out.println(show + "<br />");
        System.out.println(show);
    }
    /*
    //方法二：
    for ( Iterator iter = map.keySet().iterator(); iter.hasNext(); )
    {
        Object key = iter.next();
        Object value = map.get(key);
        out.println( key + " = " + value + "<br />" );
    }*/
    out.println("**************** 遍历 Map end *******************<br/>");
    System.out.println("**************** 遍历 Map end *******************");
}

/**
 * 显示页面内容
 */
public void showPageAll(JspWriter out, HttpServletRequest request, HttpSession session) throws Exception {

    //查看 request
    out.println("<br /><br />**************** 显示页面内容 start *******************<br/>");
    System.out.println("\r\n\r\n**************** 显示页面内容 start *******************");

    // 页面 URL
    String queryString = request.getQueryString();
    queryString = (queryString == null ? "" : "?" + java.net.URLDecoder.decode(queryString, "UTF-8"));
    // ${pageContext.request.requestURI}?${pageContext.request.queryString}<br />
    out.println("来源页面: " + request.getRequestURI() + queryString + "<br />");
    System.out.println("来源页面: " + request.getRequestURI() + queryString);

    //遍历 session
    out.println("<br /><br />session:<br />");
    System.out.println("\r\n\r\nsession:");
    for (Enumeration e = session.getAttributeNames(); e.hasMoreElements();) {
        String key = (String)e.nextElement();
        String value = session.getAttribute(key).toString();
        String show = key + " = " + value;
        out.println(show + "<br />");
        System.out.println(show);
    }

    //遍历 request
    out.println("<br /><br />request:<br />");
    System.out.println("\r\n\r\nrequest:");
    for (Iterator<Map.Entry<String, Object>> it = request.getParameterMap().entrySet().iterator(); it.hasNext();) {
        // 引用Entry
        Map.Entry<String, Object> me = it.next();
        String key = me.getKey().toString();
        // 值为字符串数组
        String[] values = (String[])me.getValue();
        // 仅有一个值
        if ( 1 == values.length ) {
            String show = key + " = " + values[0];
            out.println(show + "<br />");
            System.out.println(show);
        }
        // 值为字符串数组
        else {
            for ( int i = 0; i < values.length; i++ ) {
                String show = key + "[" + i + "] = " + values[i];
                out.println(show + "<br />");
                System.out.println(show);
            }
        }
    }

    out.println("**************** 显示页面内容 end *******************<br/>");
    System.out.println("**************** 显示页面内容 end *******************");
}

%><%
try
{
    //清除cache
    response.setContentType("text/html;charset=UTF-8");
    request.setCharacterEncoding("UTF-8"); // 设置页面编码, 可以解决传参乱码问题
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");

%><html>
<head>
<title>数据库测试</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script language='javascript' type='text/JavaScript'>
/**
 * 这是错误调试程序
 * 当页面发生错误时, 提示错误信息；正式发布前, 请刪除此程序
 * @param msg   出错信息
 * @param url   出错文件的地址
 * @param sLine 发生错误的行
 * @return false
 */
window.onerror = function ( msg, url, sLine )
{
    var errorMsg = "There was an error on this page.\n\n";
    errorMsg += "Error: " + msg + "\n";
    errorMsg += "URL: " + url + "\n";
    errorMsg += "Line: " + sLine + "\n\n";
    errorMsg += "Click OK to continue.\n\n";
    alert( errorMsg );
    return false;
};

//form 遍历
window.onload = function () {
    var doc = "";
    for ( var i = 0; i < document.forms.length; i++ )
    {
        doc += "<br /><br /><br />form: " + document.forms[i].name + "<br />\n";
        for ( var j = 0; j < document.forms[i].elements.length; j++ )
        {
            doc += document.forms[i].elements[j].name + " = ";
            doc += document.forms[i].elements[j].value + "<br />\n";
        }
    }
    var div = document.createElement('div');
    div.innerHTML = doc;
    document.body.appendChild(div);
};
</script>
</head>

<body><%
    // 以下是测试时的内容
    showPageAll(out, request, session);


    //反射某类
    //showReflection(out, new Student());
    showReflection(out, "com.xinlab.blueapple.vodafone.alert.bean.PlaylistType");// 字符串为类的全名,如 com.my.AA

    //遍历 Map
    //showMap(out, map);

}
//异常
catch ( Exception e ) {
    out.println(request.getRequestURI() + " 出错:" + e.toString());
    System.out.println(request.getRequestURI() + " 出错:" + e.toString());
}
//关闭
finally {
}

%></body>
</html>