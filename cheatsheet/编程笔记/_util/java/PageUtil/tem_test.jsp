<%-- // 此文件可以独立完成整个sql查询(处理获取数据库连接之外)

/**
 * <P> Title: Holemar                                            </P>
 * <P> Description: 数据库操作页面                               </P>
 * <P> Copyright: Copyright (c) 2010/01/13                       </P>
 * <P> Company:Everunion Tech. Ltd.                              </P>
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
    import = "com.everunion.util.DbUtil"

%><%
    //清除cache
    response.setContentType("text/html;charset=UTF-8");
    request.setCharacterEncoding("UTF-8"); // 设置页面编码, 可以解决传参乱码问题
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache");


    // 源SQL
    String sourceSQL = getValue(request, "SQL");
    // SQL的执行类型
    ExcutType sqlType = getSqlType(sourceSQL);
    // 是否使用分页
    String directSearch = getValue(request,"directSearch", "true");
    // 实际执行SQL
    String sql = toSQL(sourceSQL);

    // 操作影响结果数
    int rows = 0;
    // 结果集
    List rslist = null;
    // 分页条
    String topHTML = "";
    String bottomHTML = "";

    // 数据库连结信息
    Connection conn = null;
/*
    // MySQL
    String username = "root";
    String password="root";
    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://127.0.0.1:3306/culture?characterEncoding=UTF-8&amp;characterSetResults=UTF-8";

    //SQL Server
    username = "sa";
    password = "test";
    driverName = "com.microsoft.jdbc.sqlserver.SQLServerDriver";
    url = "jdbc:microsoft:sqlserver://192.168.0.55:1433;databaseName=lianxi";

    // Access
    driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
    url = "jdbc:odbc:driver={Microsoft Access Driver (*.mdb)};DBQ=D:\\database.mdb";
*/

try
{
    if ( sourceSQL != null && !"".equals(sourceSQL) )
    {
        // 打开数据库连结
        conn = DbUtil.getConn();
        //conn = getConn(driverName, url, username, password);

        // 直接查询
        if ( "false".equals(directSearch) || ExcutType.directSearch == sqlType )
        {
            rslist = getData(conn, sql);
        }
        // 可分页查询
        else if ( ExcutType.Select == sqlType )
        {
            // 使用分页
            PageUtil PU = new PageUtil(conn, request, sql);
            // 默认每页显示100行
            PU.setPageSize(100);
            topHTML = PU.genPageHtml();
            bottomHTML = PU.genPageHtml();
            sql = PU.getPageSql();
            rslist = getData(conn, sql);
        }
        // 执行数据库操作
        else
        {
            rows = execute(conn, sql);
        }
    }
}
//异常
catch ( Exception e )
{
    out.println(request.getRequestURI() + " 出错:" + e.toString());
}
//关闭
finally
{
    close(conn);
}

%><html>
<head>
<title>数据库测试</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
</head>

<body>
<form name="listPage" id="listPage" action="#" method="post">
    <div align="center">
        <%-- // 查询或执行语句输入 --%>
        <textArea name="SQL" id="SQL" cols="95" rows="5"><%= toTextarea(sourceSQL) %></textArea><br />
        <input type="submit" value="执行" />
        <input type="button" value="清空" onclick="var field=document.getElementById('SQL'); field.value=''; field.focus();"/>
        <input type="hidden" value="true" name="directSearch" />
        <input type="button" value="直接查询" onclick="var form=this.form; form.directSearch.value='false';
        form.submit();"/>
    </div>

<%

    // ********************* 循环程序 *************************** //

    //列印出 查询SQL 和操作SQL
    int listSize = ( rslist == null ? 0 : rslist.size());
    if ( !"".equals(sourceSQL) )
    {
        // 直接查询
        if ( "false".equals(directSearch) || ExcutType.directSearch == sqlType )
        {
            out.println("查询数据 " + listSize + " 行 <br>");
        }
        else if ( ExcutType.Select == sqlType || ExcutType.directSearch == sqlType )
        {
            out.println("查询数据 " + listSize + " 行 <br>" + toHtml(sql));
        }
        // 执行数据库操作
        else
        {
            out.println("操作影响 " + rows + " 行 <br>");
        }
    }

    // 数据表格
    if ( listSize > 0 )
    {
        // 上分页
        out.println(topHTML);
        out.println("<br /><table border='1' align='center'><tbody>");
        out.println("<tr>");
        //标题栏
        for ( Iterator iter = ((Map)rslist.get(0)).keySet().iterator(); iter.hasNext(); )
        {
            Object key = iter.next();
            out.println("<th title='" + toHtml(key) + "'>" + toHtml(key) + "</th>");
        }
        out.println("</tr>");
    }
    //各行数据
    for ( int i = 0; i < listSize; i++ )
    {
        out.println("<tr>");
        //各字段数据
        for ( Iterator iter = ((Map)rslist.get(i)).entrySet().iterator(); iter.hasNext(); )
        {
            Map.Entry entry = (Map.Entry) iter.next();
            Object value = entry.getValue();
            value = value == null ? null : value.toString();
            //为""时,加上空格
            String titleValue = ( "".equals(value) ? "&nbsp;" : toHtml(value) );
            //为空时,红色显示
            String showValue = ( value == null ? "<font color='red'>null</font>" : titleValue );
            out.println( "<td title='" + titleValue + "'>" + showValue + "</td>" );
        }
        out.println("</tr>");
    }
    // 数据表格结束
    if ( listSize > 0 )
    {
        out.println("</tbody></table><br />");
        // 下分页
        out.println(bottomHTML);
    }

%></form>
</body>
</html><%!

    /**
     * 执行类型4种: 直接查询,分页查询,数据库操作,未知类型
     */
    enum ExcutType
    {
        directSearch, Select, Excute, None;
    }


    /**
     * 判断SQL的执行类型
     * @param sourceSQL 需要执行的SQL
     * @return 枚举类的对应类型
     */
    public static ExcutType getSqlType(String sourceSQL)
    {
        // 为空时
        if ( sourceSQL == null || "".equals(sourceSQL) )
        {
            return ExcutType.None;
        }

        // 检查SQL
        String sql = sourceSQL.trim().toLowerCase().replaceAll("\r|\n", " ").replaceAll("\\s+", " ");
        // 分页查询
        if ( sql.startsWith("select ") )
        {
            return ExcutType.Select;
        }
        // 直接查询的类型
        String[] selectKeys = new String[]{"show", "desc", "describe"};
        for ( int i = 0; i < selectKeys.length; i++ )
        {
            if ( sql.startsWith(selectKeys[i] + " ") )
            {
                return ExcutType.directSearch;
            }
        }
        // 操作的类型,由於类型太多, 不再检查
        return ExcutType.Excute;
    }


    /**
     * 將需字符串转换成 可执行的SQL字符串
     * @param sour 需要進行转换的对象
     * @return 转换后的字符串
     */
    public static String toSQL(String sour)
    {
        // 为空时
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }
        // 执行的SQL
        String sql = sour.trim().replaceAll(";+$", "");
        // 避免换行没有加空格的错误
        sql = sql.replaceAll("\n", " \n");
        // 刪除行后面的注釋,以“--”和“#”为行注釋符号
        sql = sql.replaceAll("--.*", "").replaceAll("#.*", "");
        return sql;
    }


    /**
     * 取得数据库类型
     * @param conn 数据库连结
     * @return 数据库类型
     */
    public String getDbType(Connection conn)
    {
        // 默认值
        String init = "mysql";
        if ( conn != null )
        {
            // 数据库驱动名
            String driverName = conn.toString().toLowerCase();
            // MySQL 数据库
            if ( driverName.indexOf("mysql") >= 0 )
            {
                return "mysql";
            }
            // Oracle 数据库
            if ( driverName.indexOf("oracle") >= 0 )
            {
                return "oracle";
            }
            // SQL Server 数据库
            if ( driverName.indexOf("sqlserver") >= 0 )
            {
                return "sqlserver";
            }
            // Access 数据库
            if ( driverName.indexOf("access") >= 0 )
            {
                return "access";
            }
        }
        // 传回默认值
        return init;
    }


    /**
     * 取得数据库连结
     * @param driverName 数据库驱动名
     * @param url 数据库连结地址
     * @param username 数据库登陆名
     * @param password 数据库登陆密码
     * @return Connection 数据库连结
     * @throws ClassNotFoundException 数据库驱动找不到异常
     * @throws SQLException 数据库操作异常
     */
    public static Connection getConn(String driverName, String url, String username, String password)
        throws ClassNotFoundException, SQLException
    {
        Connection conn = null;
        try
        {
            // 加载驱动
            Class.forName(driverName);
            // 取得连结
            conn = DriverManager.getConnection(url, username, password);
        }
        // 拋出 数据库驱动找不到异常
        catch ( ClassNotFoundException e )
        {
            System.out.println("DbUtil.getConn -> ClassNotFoundException:" + e.toString());
            throw e;
        }
        // 拋出 数据库操作异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.getConn -> SQLException:" + e.toString());
            throw e;
        }
        return conn;
    }


    /**
     * 关闭数据库连结
     * @param conn 数据库连结
     */
    public static void close(Connection conn)
    {
        try
        {
            if ( conn != null )
            {
                // 如果不是自动提交模式,交易提交
                if ( false == conn.getAutoCommit() )
                {
                   conn.commit();
                }
                // 关闭数据库连结
                conn.close();
                conn = null;
            }
        }
        // 捕获异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.close -> SQLException:" + e.toString());
        }
    }


    /**
     * 关闭数据库操作连结
     * @param statement 数据库Statement
     */
    public static void close(Statement statement)
    {
        try
        {
            if ( statement != null )
            {
                // 关闭资源
                statement.close();
                statement = null;
            }
        }
        // 捕获异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.close -> SQLException:" + e.toString());
        }
    }


    /**
     * 关闭结果集连结
     * @param resultSet 结果集连结
     */
    public static void close(ResultSet resultSet)
    {
        try
        {
            if ( resultSet != null )
            {
                // 关闭资源
                resultSet.close();
                resultSet = null;
            }
        }
        // 捕获异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.close -> SQLException:" + e.toString());
        }
    }


    /**
     * 关闭连结
     * @param conn 数据库连结
     * @param stmt 数据库操作连结
     * @param resultSet 结果集连结
     */
    public static void close(Connection conn, Statement stmt, ResultSet resultSet)
    {
        close(resultSet);
        close(stmt);
        close(conn);
    }


    /**
     * 取得数据
     * @param conn 数据库连结
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return ArrayList 数据集,查不到数据时传回size为0的ArrayList
     * @throws SQLException 数据库操作异常
     */
    public static ArrayList<HashMap<String, String>> getData(Connection conn, String sql, List<Object> valueList)
            throws SQLException
    {
        ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
        // 数据库资源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        try
        {
            // 操作数据库
            pstmt = conn.prepareStatement(sql);
            // 如果需要传参数
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsMetaData = rs.getMetaData();
            int col = rsMetaData.getColumnCount();
            // 加入数据
            while ( rs.next() )
            {
                HashMap<String, String> map = new LinkedHashMap<String, String>();
                for ( int i = 1; i <= col; i++ )
                {
                    map.put(rsMetaData.getColumnLabel(i).toLowerCase(), rs.getString(i));
                }
                list.add(map);
            }
        }
        catch ( SQLException e )
        {
            // 输出异常
            System.out.println("DbUtil.getData -> SQLException: " + e.toString());
            System.out.println("DbUtil.getData -> sql: " + sql);
            throw e;
        }
        // 关闭连结
        finally
        {
            close(rs);
            close(pstmt);
        }
        return list;
    }


    /**
     * 取得数据
     * @param conn 数据库连结
     * @param sql 查询的SQL
     * @return ArrayList 数据集,查不到数据时传回size为0的ArrayList
     * @throws SQLException 数据库操作异常
     */
    public static ArrayList<HashMap<String, String>> getData(Connection conn, String sql) throws SQLException
    {
        return getData(conn, sql, null);
    }


    /**
     * 执行数据库操作SQL, 如 INSERT、UPDATE 或 DELETE 等
     * @param conn 数据库连结
     * @param sql 操作数据库的SQL
     * @param valueList 操作数据库的SQL的参数数据集
     * @return int 新增、修改或刪除 等所影响的行数(如果是新增,且主键是自增长的,传回主键)
     * @throws SQLException 数据库操作异常
     */
    public static int execute(Connection conn, String sql, List<Object> valueList) throws SQLException
    {
        // 数据库资源
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try
        {
            // 取得数据库 Statement
            pstmt = conn.prepareStatement(sql);
            // 传递参数
            putSQLParams(pstmt, valueList);
            int affect = pstmt.executeUpdate();

            return affect;
        }
        catch ( SQLException e )
        {
            // 输出异常
            System.out.println("DbUtil.execute -> SQLException: " + e.toString());
            System.out.println("DbUtil.execute -> sql: " + sql);
            throw e;
        }
        // 关闭连结
        finally
        {
            close(rs);
            close(pstmt);
        }
    }


    /**
     * 执行无传回值的 SQL, 如 INSERT、UPDATE 或 DELETE 等
     * @param conn 数据库连结
     * @param sql 操作数据库的SQL
     * @return int 新增、修改或刪除 等所影响的行数
     * @throws SQLException 数据库操作异常
     */
    public static int execute(Connection conn, String sql) throws SQLException
    {
        return execute(conn, sql, null);
    }


    /**
     * 传递参数到 PreparedStatement, 仅供本类內部使用 (注:此方法有待改善,目前仅字符串且不为空情況下测试过)
     * @param pstmt PreparedStatement
     * @param valueList 参数列表
     * @return PreparedStatement连结
     * @throws SQLException 数据库操作异常
     */
    public static PreparedStatement putSQLParams(PreparedStatement pstmt, List<Object> valueList) throws SQLException
    {
        try
        {
            // 查询的参数数据集的行数
            int valueListSize = (valueList == null) ? 0 : valueList.size();
            for ( int i = 0; i < valueListSize; i++ )
            {
                // 取得参数
                Object obj = valueList.get(i);
                // 根據参数类型来賦值
                if ( obj == null )
                    pstmt.setNull(i + 1, java.sql.Types.NULL);
                else if ( obj instanceof String )
                    pstmt.setString(i + 1, "" + valueList.get(i));
                else if ( obj instanceof Integer )
                    pstmt.setInt(i + 1, Integer.parseInt("" + obj));
                else if ( obj instanceof Long )
                    pstmt.setLong(i + 1, Long.parseLong("" + obj));
                else if ( obj instanceof Double )
                    pstmt.setDouble(i + 1, Double.parseDouble("" + obj));
                else if ( obj instanceof java.util.Date )
                    pstmt.setDate(i + 1, new java.sql.Date(((java.util.Date)obj).getTime()));
                else if ( obj instanceof java.sql.Blob )
                    pstmt.setBlob(i + 1, (java.sql.Blob)obj);
                else
                    pstmt.setObject(i + 1, obj);
            }
        }
        catch ( SQLException e )
        {
            // 输出异常
            System.out.println("DbUtil.putSQLParams -> SQLException: " + e.toString());
            throw e;
        }
        return pstmt;
    }


    /**
     * 转成字符串
     * @param sour 待转数据
     * @param init 默认值
     * @param length 截取字符串长度,超过此长度者,后面显示“...”;不希望截取可填入0
     * @return String 字符串
     */
    public static String toString(Object sour, String init, int length)
    {
        // 初始化
        String dest = null;
        try
        {
            dest = (String)sour;
            // 为空
            if ( dest == null || "".equals(dest) )
            {
                dest = init;
            }
        }
        // 拋出异常
        catch ( Exception e )
        {
            dest = init;
        }
        // 需要截取时(由於超出部分显示“...”, 所以必须3位以上才截取)
        if ( length > 0 && dest != null && dest.length() > length && dest.length() > 3 )
        {
            dest = dest.substring(0, length - 3) + "...";
        }
        return dest;
    }


    /**
     * 转成字符串
     * @param sour 待转数据
     * @param init 默认值
     * @return String 字符串
     */
    public static String toString(Object sour, String init)
    {
        return toString(sour, init, 0);
    }


    /**
     * 转成字符串
     * @param sour 待转数据
     * @return String 字符串
     */
    public static String toString(Object sour)
    {
        return toString(sour, "");
    }


    /**
     * 取得对象里的值
     * @param sour 储存着所需內容的对象, 可以是 Map, HttpServletRequest, HttpSession, ResultSet 类別
     * @param name 对应的值的名称, 如果这个值为null, 则认为 sour 本身是值
     * @param init 默认值, 如果没有取得对应值时, 则传回此值
     * @param length 截取字符串长度,超过此长度者,后面显示“...”;不希望截取可填入0
     * @return String 对象里的值的字符串
     */
    public static String getValue(Object sour, String name, String init, int length)
    {
        // 如果变量 sour 为空
        if ( sour == null )
        {
            return toString(init, init, length);
        }
        // 如果变量 name 为空, 则认为 sour 本身是值
        if ( name == null )
        {
            return toString(sour, init, length);
        }

        // 根據 sour 的不同类型来取值
        try
        {
            // 如果 sour 是 String 类別的对象
            if ( sour instanceof String )
            {
                return toString(sour, init, length);
            }
            // 如果 sour 是 Map 类別的对象
            if ( sour instanceof Map )
            {
                Map<String, String> map = (Map)sour;
                // 如果此映射包含指定键的映射关系
                if ( map.containsKey(name) )
                {
                    return toString(map.get(name), init, length);
                }
                // 查询数据库时, 键都会自动转成小写
                if ( map.containsKey(name.toLowerCase()) )
                {
                    return toString(map.get(name.toLowerCase()), init, length);
                }
                // 如果此映射不包含指定键的映射关系, 则忽略大小写来取值
                for ( Iterator<Map.Entry<String, String>> iter = map.entrySet().iterator(); iter.hasNext(); )
                {
                    Map.Entry<String, String> entry = iter.next();
                    // 如果键忽略大小写时与 name 相同
                    if ( name.equalsIgnoreCase(toString(entry.getKey())) )
                    {
                        return toString(entry.getValue(), init, length);
                    }
                }
            }
            // 如果 sour 是 HttpServletRequest 类別的对象
            if ( sour instanceof HttpServletRequest )
            {
                // Parameter里面有,则取Parameter的
                if ( ((HttpServletRequest)sour).getParameterMap().containsKey(name) )
                {
                    return toString(((HttpServletRequest)sour).getParameter(name), init, length);
                }
                // 如果 Parameter 不包含对应的名称; 取Attribute的
                return toString(((HttpServletRequest)sour).getAttribute(name), init, length);
            }
            // 如果 sour 是 HttpSession 类別的对象
            if ( sour instanceof HttpSession )
            {
                return toString(((HttpSession)sour).getAttribute(name), init, length);
            }
            // 如果 sour 是 ResultSet 类別的对象
            if ( sour instanceof ResultSet )
            {
                return toString(((ResultSet)sour).getString(name), init, length);
            }
            // 如果 sour 不是上述类別的对象, 则认为它自身是值。
            return toString(sour, init, length);
        }
        // 取值时出现异常
        catch ( Exception e )
        {
            return toString(init, init, length);
        }
    }


    /**
     * 取得对象里的值
     * @param sour 储存着所需內容的对象, 可以是 Map, HttpServletRequest, HttpSession, ResultSet 类別
     * @param name 对应的值的名称, 如果这个值为空, 则认为 sour 本身是值
     * @param init 默认值, 如果没有取得对应值时, 则传回此值
     * @return String 对象里的值的字符串
     */
    public static String getValue(Object sour, String name, String init)
    {
        return getValue(sour, name, init, 0);
    }


    /**
     * 取得对象里的值的字符串
     * @param sour 储存着所需內容的对象, 可以是 Map, HttpServletRequest, HttpSession, ResultSet 类別
     * @param name 对应的值的名称, 如果这个值为null, 则认为 sour 本身是值
     * @return String 对象里的值的字符串。取不到值, 或者值为 null 则传回""
     */
    public static String getValue(Object sour, String name)
    {
        return getValue(sour, name, "");
    }


    /**
     * 將需显示的字符串转换成 textarea 显示的字符串
     * @param sour 需要進行转换的对象
     * @return 转换后的字符串
     */
    public static String toTextarea(String sour)
    {
        // 为空时
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }

        // 以下逐一转换
        sour = sour.replaceAll("&", "&amp;");
        sour = sour.replaceAll("<", "&lt;");
        sour = sour.replaceAll(">", "&gt;");
        return sour;
    }


    /**
     * 將需显示的字符串转换成HTML格式的字符串
     * @param sour 需要進行转换的对象
     * @return 转换后的字符串
     */
    public static String toHtml(String sour)
    {
        // 为空时
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }

        // 以下逐一转换
        sour = sour.replaceAll("&", "&amp;");
        sour = sour.replaceAll(" ", "&nbsp;");
        sour = sour.replaceAll("%", "&#37;");
        sour = sour.replaceAll("<", "&lt;");
        sour = sour.replaceAll(">", "&gt;");
        sour = sour.replaceAll("\n", "\n<br/>");
        sour = sour.replaceAll("\"", "&quot;");
        sour = sour.replaceAll("'", "&#39;");
        sour = sour.replaceAll("[+]", "&#43;");
        return sour;
    }


    /**
     * 將需显示的对象转换成HTML格式的字符串
     * @param sour 需要進行转换的对象
     * @return 转换后的字符串
     */
    public static String toHtml(Object sour)
    {
        // 为空时
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }
        return toHtml(toString(sour));
    }

%><%!

/**
 * 分页组件 <br />
 * 注意: <br />
 * 1.上下分页模板必须放在form表单组件中,否则会有JS错误; <br />
 * 2.占用的名称全部使用“_PU_”开头,为避免名称冲突,请勿使用这个开头的名称 <br />
 * 3.SQL Server版本的需设置主键为第一列 (如:select Id, name from userTable where ...),其中Id为主键. <br />
 *   多主键,可採用下面方法(select a.Id+a.name as keyId from userTable a where ... )). <br />
 * 4.使用AJAX查询时, 请在 genPageHtml(check, beforeSubmit)方法的beforeSubmit里面的最后加上return,避免submit <br />
 * 5.排序列,可使用  onClick="_PU_.sort('排序列');" <br />
 * 6.设置页数 和 设置每页显示多少行,必须在取分页条HTML和取查询SQL之前执行 <br />
 * @author <A HREF='daillow@gmail.com'>Holer</A>
 * @version 0.1
 */
class PageUtil
{
    // Connection
    private Connection conn = null;
    // sql
    private String sql = "";
    // 分页SQL
    private String pageSql = "";
    // countSQL
    private String countSql = "";
    // 记录总数
    private int rowCount = 0;
    // 一页显示的记录数, 默认为10
    private int pageSize = 10;
    // 总页数
    private int pageCount = 0;
    // 待显示页码
    private int pageNo = 0;
    // 记录是否为空
    private boolean pageSizeIsNull;
    // 从request中获取要排序的字段名称, 如item_id或item_ID desc
    private String sortFields = "";
    // 控制ORDER by asc, order by desc用
    private String sortAscOrDesc = "";
    // 数据库类型
    private String DbType = "mysql";
    // 查询的参数
    private List<Object> valueList = null;
    // 是否准备好
    private boolean isPrepare = false;
    // 输出分页条的次数
    private int outTimes = 0;

    /**
     * 从哪行开始
     */
    public int StartNo = 0;

    /**
     * 按钮及输入框html,可直接在此修改
     */
    // 第一页
    private String button_first = "<INPUT NAME='_PU_button' TYPE='button' VALUE='|<' CLASS='_PU_btn' onClick='_PU_.setPageNo(1, true);' ${disabled} />";
    // 上一页
    private String button_pre = "<INPUT NAME='_PU_button' TYPE='button' VALUE='<' CLASS='_PU_btn' onClick='_PU_.setPageNo(${thisPageNo}, true);' ${disabled} />";
    // 下一页
    private String button_next = "<INPUT NAME='_PU_button' TYPE='button' VALUE='>' CLASS='_PU_btn' onClick='_PU_.setPageNo(${thisPageNo}, true);' ${disabled} />";
    // 最后一页
    private String button_last = "<INPUT NAME='_PU_button' TYPE='button' VALUE='>|' CLASS='_PU_btn' onClick='_PU_.setPageNo(${pageCount}, true);' ${disabled} />";
    // go按钮
    private String button_go = "<INPUT NAME='_PU_button' TYPE='button' VALUE='GO' CLASS='_PU_btn' onClick='_PU_.submit();' ${disabled} />";
    // 每页多少行的输入框
    private String text_size = "<INPUT NAME='_PU_text_size' TYPE='text' CLASS='_PU_text' SIZE='2' MAXLENGTH='5' VALUE='${pageSize}' ${disabled} onChange='_PU_.textSize_change(this);' onkeydown='return _PU_.input(event);' />";
    // 跳转到第几页的输入框
    private String text_pageNo = "<INPUT NAME='_PU_text_pageNo' TYPE='text' CLASS='_PU_text' SIZE='2' MAXLENGTH='5' VALUE='${pageNo}' ${disabled} onChange='_PU_.textPageNo_change(this);' onkeydown='return _PU_.input(event);' />";


    /**
     * 构造方法
     * @param DBconn Connection
     * @param request HttpServletRequest
     * @param sql 分页传入的SQL
     * @param valueList SQL的参数列表
     * @param DbType 数据库类型
     */
    public PageUtil(Connection DBconn, HttpServletRequest request, String sql, List<Object> valueList, String DbType)
    {
        // 数据库连结参数
        this.conn = DBconn;

        // 取得待显示页码
        this.pageNo = request.getParameter("_PU_pageNo") == null ? 1 : Integer.parseInt(request
                .getParameter("_PU_pageNo"));
        // 设置和取得页大小
        this.pageSize = request.getParameter("_PU_pageSize") == null ? pageSize : Integer.parseInt(request
                .getParameter("_PU_pageSize"));
        // 是否为null
        this.pageSizeIsNull = request.getParameter("_PU_pageSize") == null;

        // 要排序的字段名称
        this.sortFields = request.getParameter("_PU_sortFields") == null ? "" : request
                .getParameter("_PU_sortFields");
        // 控制ORDER by asc, order by desc用
        this.sortAscOrDesc = request.getParameter("_PU_sortAscOrDesc") == null ? "" : request
                .getParameter("_PU_sortAscOrDesc");

        // 数据库类型
        setDbType(DbType);

        // 设置查询SQL
        this.sql = (sql == null || "".equals(sql.trim())) ? "" : sql;
        this.valueList = valueList;
    }


    /**
     * 构造方法
     * @param DBconn Connection
     * @param request HttpServletRequest
     * @param sql 分页传入的SQL
     * @param valueList 分页用的SQL的参数列表
     */
    public PageUtil(Connection DBconn, HttpServletRequest request, String sql, List<Object> valueList)
    {
        this(DBconn, request, sql, valueList, null);
    }


    /**
     * 构造方法
     * @param DBconn Connection
     * @param request HttpServletRequest
     * @param sql 分页传入的SQL
     */
    public PageUtil(Connection DBconn, HttpServletRequest request, String sql)
    {
        this(DBconn, request, sql, null, null);
    }


    /**
     * 取得分页的SQL
     * @return 分页的SQL
     */
    public String getSQL()
    {
        return this.sql;
    }


    /**
     * 取得数据库类型
     * @return 数据库类型
     */
    public String getDbType()
    {
        return this.DbType;
    }


    /**
     * 设置数据库类型
     * @param DbType 数据库类型
     */
    public void setDbType(String DbType)
    {
        // 如果已经准备好,则不可以再改变量据库类型
        checkPrepare();
        // 没有参数时,由数据库连接来取
        if ( DbType == null || "".equals(DbType.trim()) )
        {
            String driverName = this.conn.toString().toLowerCase();
            //MySQL 数据库
            if ( driverName.indexOf("mysql") >= 0 )
            {
                this.DbType = "mysql";
            }
            //Oracle 数据库
            else if ( driverName.indexOf("oracle") >= 0 )
            {
                this.DbType = "oracle";
            }
            //SQL Server 数据库 跟 Access 数据库, 同样的分页SQL
            else if ( driverName.indexOf("sqlserver") >= 0 || driverName.indexOf("access") >= 0 )
            {
                this.DbType = "sqlserver";
            }
        }
        // 有参数传入,则使用参数的
        else
        {
            this.DbType = DbType.toLowerCase();
        }
    }


    /**
     * 设置查询总计多少行数据的SQL
     * @exception 当select里有distinct的时,可能会出错
     */
    private void setCountSql()
    {
        String sql = this.sql.trim().toLowerCase();
        // 如果只有一个 from; 直接修改SQL
        if ( sql.indexOf(" from ") == sql.lastIndexOf(" from ") && sql.indexOf(" distinct ") < 0 )
        {
            this.countSql = "SELECT COUNT(1) " + this.sql.substring(sql.indexOf(" from "));
        }
        else
        {
            this.countSql = "SELECT COUNT(1) FROM (" + this.sql + ") _PU_A";
        }
    }


    /**
     * 取得SQL
     * @return 已经产的SQL
     */
    public String getCountSql()
    {
        return this.countSql;
    }


    /**
     * 取得分页SQL
     * @return 分页SQL
     */
    public String getPageSql()
    {
        // 准备好
        setPrepare();
        return this.pageSql;
    }


    /**
     * 处理select command里有distinct和group by command以及排序
     */
    private void setPageSql()
    {
        // 传入的SQL
        String strSql = this.sql.trim();
        // 设置页码(防呆)
        this.pageNo = (this.pageNo <= 0 ? 1 : this.pageNo);

        // 表示需要排序
        if ( !"".equals(this.sortFields) )
        {
            // 排序字段和排序方向
            String order = this.sortFields + " " + this.sortAscOrDesc;

            // Mysql
            if ( "mysql".equals(this.DbType) )
            {
                int startRow = this.pageSize * (this.pageNo - 1);
                String tem_sql = strSql.toLowerCase().replaceAll("\\s+", " ");
                // 已经有 limit
                if ( tem_sql.indexOf(" limit ") > 0 )
                {
                    // 此句效率很低,非迫不得已则不使用
                    this.pageSql = " SELECT _PU_.* from (" + strSql + " ) _PU_ order by " + order + " limit "
                        + startRow + "," + this.pageSize;
                }
                // 已经有 order by
                else if ( tem_sql.indexOf(" order by ") > 0 )
                {
                    //  order by 后面没有括号(即order by 不是子查询),直接在后面補上排序
                    if ( tem_sql.lastIndexOf(")") < tem_sql.lastIndexOf(" order by ") )
                    {
                        this.pageSql = strSql + ", " + order + " limit " + startRow + "," + this.pageSize;
                    }
                    // order by 在子查询里面
                    else
                    {
                        this.pageSql = " SELECT _PU_.* from (" + strSql + " ) _PU_ order by "
                            + order + " limit " + startRow + "," + this.pageSize;
                    }
                }
                // 没有 order by 和 limit,则直接在后面加上, 这样效率更高
                else
                {
                    this.pageSql = strSql + " order by " + order + " limit " + startRow + "," + this.pageSize;
                }
            }
            // Sql Server2000
            else if ( "sqlserver".equals(this.DbType) )
            {
                // 显示行数,最后一页时不是 pageSize
                int showRows = (this.pageNo < this.pageCount ? this.pageSize : this.rowCount - (this.pageNo-1) * this.pageSize);
                // 查无数据时, top 0 会报错
                showRows = (showRows > 0 ? showRows : 1);
                this.pageSql = "SELECT * FROM( SELECT TOP " + showRows + " * FROM ("
                    + " SELECT TOP " + (this.pageSize * this.pageNo) + " * FROM ("
                    + strSql + ") AS _PU_A ORDER BY 1 ASC "
                    + ") AS _PU_B ORDER BY 1 DESC )  AS _PU_C ORDER BY " + order;
            }
            // Oracle
            else if ( "oracle".equals(this.DbType) )
            {
                // 已经有 order by
                if ( strSql.toLowerCase().indexOf(" order ") > 0 )
                {
                    // 將 strSql ==> select a.* from ( strSql ) a ORDER BY 1,2
                    strSql = "select _PU_A.* from (" + strSql + ") _PU_A order by " + order;
                }
                // 没有 order by,直接在后面加上, 这样效率会更高
                else
                {
                    strSql += " order by " + order;
                }
                int startRow = (this.pageNo - 1) * this.pageSize + 1;
                int endRow = this.pageNo * this.pageSize;
                // 需要排序sql
                this.pageSql = "SELECT * FROM ( SELECT ROWNUM as _PU_ROWNUM, _PU_B.* from ("
                    + strSql + ") _PU_B where _PU_ROWNUM <= " + endRow
                    + " ) WHERE _PU_ROWNUM >= " + startRow;
            }
        }
        // 表示不需要排序
        else
        {
            // Mysql
            if ( "mysql".equals(this.DbType) )
            {
                int startRow = this.pageSize * (this.pageNo - 1);
                // 已经有 limit
                if ( strSql.toLowerCase().indexOf(" limit ") > 0 )
                {
                    this.pageSql = "SELECT _PU_.* from (" + strSql + " ) _PU_ limit "
                        + startRow + "," + this.pageSize;
                }
                // 没有 limit,则直接在后面加上, 这样效率更高
                else
                {
                    this.pageSql = strSql + " limit " + startRow + "," + this.pageSize;
                }
            }
            // Sql Server 2000
            else if ( "sqlserver".equals(this.DbType) )
            {
                // 显示行数,最后一页时不是 pageSize
                int showRows = (this.pageNo < this.pageCount ? this.pageSize : this.rowCount - (this.pageNo-1) * this.pageSize);
                // 查无数据时, top 0 会报错
                showRows = (showRows > 0 ? showRows : 1);
                this.pageSql = "SELECT * FROM( SELECT TOP " + showRows + " * FROM ("
                    + " SELECT TOP " + (this.pageSize * this.pageNo) + " * FROM ("
                    + strSql + ") AS _PU_A ORDER BY 1 ASC ) AS _PU_B ORDER BY 1 DESC ) as _PU_C ORDER BY 1 ASC";
            }
            // Oracle
            else if ( "oracle".equals(this.DbType) )
            {
                int startRow = (this.pageNo - 1) * this.pageSize + 1;
                int endRow = this.pageNo * this.pageSize;
                this.pageSql = "SELECT * FROM ( SELECT ROWNUM as _PU_ROWNUM, _PU_A.* from ("
                    + strSql + ") _PU_A WHERE _PU_ROWNUM <= " + endRow + " ) WHERE _PU_ROWNUM >= " + startRow;
            }
        }
    }


    /**
     * 取得每页产生的记录数
     * @return 每页产生的记录数
     */
    public int getPageSize()
    {
        return this.pageSize;
    }


    /**
     * 设置一页显示多少行数据
     * @param i 一页显示多少行数据
     */
    public void setPageSize(int i)
    {
        // 如果已经准备工作,则不可以再改变一页显示多少行数据
        checkPrepare();
        // 如果没有传入显示多少行数据的参数
        if ( this.pageSizeIsNull )
        {
            this.pageSize = i;
        }
    }


    /**
     * 取得页数
     * @return 页数
     */
    public int getPageCount()
    {
        return this.pageCount;
    }


    /**
     * 取得第几页
     * @return 第几页
     */
    public int getPageNo()
    {
        return this.pageNo;
    }


    /**
     * 设置页数
     * @param i 页数
     */
    public void setPageNo(int pageNo)
    {
        // 如果已经准备工作,则不可以再改变页数
        checkPrepare();
        this.pageNo = pageNo;
    }


    /**
     * 设置页数为最大页
     */
    public void setPageNoMax()
    {
        setPrepare();
        this.pageNo = this.pageCount;
    }


    /**
     * 取得显示几行
     * @return 显示几行
     */
    public int getRowCount()
    {
        return this.rowCount;
    }


    /**
     * 取得目前页基准行号
     * @return 显示几行
     */
    public int getBaseRowNo()
    {
        return getPageSize() * (getPageNo() - 1);
    }


    /**
     * 检查工作是否已经准备好
     * @throws RuntimeException 已经准备好则拋出异常,可以不捕获的异常
     */
    private void checkPrepare()
    {
        // 如果已经准备好,则不可以再改变
        if ( this.isPrepare )
        {
            System.out.println("分页SQL已经使用,不可再修改; 若要修改,请在genPageHtml(), getPageSql() 方法之前");
            throw new RuntimeException();
        }
    }


    /**
     * 产生分页的准备工作
     * @return 成功传回true,失敗传回false
     */
    private void setPrepare()
    {
        // 如果已经准备好,不再执行
        if ( this.isPrepare )
            return;

        setCountSql();
        try
        {
            // 产生SQL表達式
            PreparedStatement pstmt = this.conn.prepareStatement(this.countSql);
            ResultSet rs = null;
            // 查询的参数数据集的行数
            int valueListSize = (this.valueList == null) ? 0 : this.valueList.size();
            // 如果需要传参数
            for ( int i = 0; i < valueListSize; i++ )
            {
                // 取得参数
                Object obj = this.valueList.get(i);
                // 根據参数类型来賦值
                if ( obj == null )
                    pstmt.setNull(i + 1, java.sql.Types.NULL);
                else if ( obj instanceof String )
                    pstmt.setString(i + 1, "" + valueList.get(i));
                else if ( obj instanceof Integer )
                    pstmt.setInt(i + 1, Integer.parseInt("" + obj));
                else if ( obj instanceof Long )
                    pstmt.setLong(i + 1, Long.parseLong("" + obj));
                else if ( obj instanceof Double )
                    pstmt.setDouble(i + 1, Double.parseDouble("" + obj));
                else if ( obj instanceof java.util.Date )
                    pstmt.setDate(i + 1, new java.sql.Date(((java.util.Date)obj).getTime()));
                else if ( obj instanceof java.sql.Blob )
                    pstmt.setBlob(i + 1, (java.sql.Blob)obj);
                else
                    pstmt.setObject(i + 1, obj);
            }
            rs = pstmt.executeQuery();
            if ( rs.next() )
            {
                // 记录的总数
                this.rowCount = rs.getInt(1);
                this.pageCount = (this.rowCount + this.pageSize - 1) / this.pageSize;
            }

            // 没有数据时重设pageNo为0
            this.pageNo = this.pageNo > this.pageCount ? this.pageCount : this.pageNo;
            this.pageNo = this.pageNo < 1 ? 1 : this.pageNo;
            this.pageNo = this.rowCount <= 0 ? 0 : this.pageNo;
            // 开始序号
            this.StartNo = (this.pageNo - 1) * this.pageSize;
            setPageSql();

            // 关闭资源
            rs.close();
            pstmt.close();
            this.isPrepare = true;
        }
        // 异常
        catch ( Exception e )
        {
            // 第几页
            this.pageNo = 0;
            // 共几页
            this.pageCount = 0;
            // 显示几页
            this.rowCount = 0;
            e.printStackTrace();
            this.isPrepare = false;
        }
    }


    /**
     * 产生一个分页导航条的HTML,不区分上下分页条
     * @return 传回分页导航条的HTML內容
     */
    public String genPageHtml()
    {
        return genPageHtml("", "");
    }


    /**
     * 产生一个分页导航条的HTML,不区分上下分页条
     * @param beforeSubmit 处理提交前的Java Script,建议是提交的(如果使用 AJAX, 请在最后加上return,避免提交)
     * @return 传回分页导航条的HTML內容
     */
    public String genPageHtml(String beforeSubmit)
    {
        return genPageHtml("", beforeSubmit);
    }


    /**
     * 产生一个分页导航条的HTML, 不区分上下分页条
     * @param check 处理提交前的Java Script,建议是表单检查的
     * @param beforeSubmit 处理提交前的Java Script,建议是提交的(如果使用 AJAX, 请在最后加上return,避免提交)
     * @return 传回分页导航条的HTML內容
     */
    public String genPageHtml(String check, String beforeSubmit)
    {
        // 准备工作
        setPrepare();

        // 导航条的html
        StringBuffer sList = new StringBuffer();
        sList.append("<DIV ID='_PU_pageControl" + this.outTimes + "'> \r\n");
        sList.append("<TABLE width='100%' cellspacing='0' cellpadding='0' border='0' class='_PU_table' id='_PU_table'> \r\n");
        sList.append("<TBODY><TR ALIGN='center'> \r\n");

        // 第一字段(內容为: 每页多少行)
        sList.append("<TD align='left'>&nbsp;${EverPage}");
        // 输入框:每页多少行
        sList.append(this.text_size.replace("${pageSize}", this.pageSize + "")
                .replace("${disabled}", ((this.pageCount <= 0) ? "DISABLED" : "")));
        sList.append("${ROW}&nbsp;</TD> \r\n");

        // 第二字段(第1~10行/共74行)
        sList.append("<TD align='center' ID='_PU_TDRowCount" + this.outTimes + "'>&nbsp;${ORDER}<em>");
        sList.append(this.pageNo > 0 ? (this.rowCount > 0 ? ((this.pageNo - 1) * this.pageSize + 1) : 0) : this.pageNo);
        sList.append("</em>~<em>");
        sList.append((this.pageNo * this.pageSize > this.rowCount) ? this.rowCount : (this.pageNo * this.pageSize));
        sList.append("</em>${ROW}/${TOTAL}<em>");
        sList.append(this.rowCount);
        sList.append("</em>${ROW}&nbsp;</TD> \r\n");

        // 第三字段(按钮,及第几页输入框)
        sList.append("<TD align='right'> \r\n");
        // 按钮:第一页
        sList.append(this.button_first.replace("${disabled}", ((this.pageNo == 1) ? "DISABLED" : "")));
        sList.append("&nbsp; \r\n");
        // 按钮:上一页
        sList.append(this.button_pre.replace("${disabled}", ((this.pageNo <= 1) ? "DISABLED" : ""))
                .replace("${thisPageNo}", (this.pageNo - 1) + ""));
        sList.append("&nbsp; \r\n");
        // 输入框:第几页
        sList.append("&nbsp;${ORDER}");
        sList.append(this.text_pageNo.replace("${pageNo}", this.pageNo + "")
                .replace("${disabled}", ((this.pageCount <= 0) ? "DISABLED" : "")));
        // 共多少页
        sList.append("${PAGE}/${TOTAL}<em>");
        sList.append(this.pageCount > 0 ? this.pageCount : 1);
        sList.append("</em>${PAGE}&nbsp;");
        // 按钮:下一页
        sList.append(this.button_next.replace("${disabled}", ((this.pageNo >= this.pageCount) ? "DISABLED" : ""))
                .replace("${thisPageNo}", (this.pageNo + 1) + ""));
        sList.append("&nbsp; \r\n");
        // 按钮:最后一页
        sList.append(this.button_last.replace("${disabled}", ((this.pageNo >= this.pageCount) ? "DISABLED" : ""))
                .replace("${pageCount}", "" + this.pageCount));
        sList.append("&nbsp; \r\n");
        // 按钮:提交(go)
        sList.append(this.button_go.replace("${disabled}", ((this.pageCount <= 0) ? "DISABLED" : "")));
        sList.append("</TR></TBODY></TABLE></DIV>");


        // 如果还没有这段的时候输出,有则不输出
        if ( this.outTimes == 0 )
        {
            // 储存信息的隐藏域
            sList.append("<INPUT TYPE='hidden' NAME='_PU_sortFields' ID='_PU_sortFields' VALUE='" + this.sortFields + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='_PU_sortAscOrDesc' ID='_PU_sortAscOrDesc' VALUE='" + this.sortAscOrDesc + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='_PU_pageNo' ID='_PU_pageNo' VALUE='" + this.pageNo + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='_PU_pageSize' ID='_PU_pageSize' VALUE='" + this.pageSize + "'/> \r\n ");

            // js 函数
            sList.append(" <SCRIPT type='text/javascript' language='JavaScript'> \r\n");
            // js 分页公用类,所有的js函数都包括在这类別里面,以免佔用过多关键字
            sList.append(" var _PU_ = {}; \r\n");

            /**
             * 提交
             * @param pageNo 提交的页码
             * @param pageSize 每页显示多少行
             */
            sList.append(" _PU_.submit = function () { \r\n");
            // js验证
            check = (check == null || check.trim().length() == 0) ? "" : check + "; \r\n";
            // 先执行检查的 js
            sList.append(check);
            // 让按钮不可点击
            sList.append("   var btnName = window.document.getElementsByName('_PU_button'); \r\n");
            sList.append("   for ( var i=0; i < btnName.length; i++ ) { btnName[i].disabled=true; } \r\n");
            // 让每页多少行输入框不可再输入
            sList.append("   var text_sizeName = window.document.getElementsByName('_PU_text_size'); \r\n");
            sList.append("   for ( var i=0; i < text_sizeName.length; i++ ) { text_sizeName[i].disabled=true; } \r\n");
            // 让第几页输入框不可再输入
            sList.append("   var text_pageNoName = window.document.getElementsByName('_PU_text_pageNo'); \r\n");
            sList.append("   for ( var i=0; i < text_pageNoName.length; i++ ) { text_pageNoName[i].disabled=true; } \r\n");
            // 执行提交前的动作(也可以是ajax提交)
            sList.append((beforeSubmit == null || beforeSubmit.trim().length() == 0) ? "" : beforeSubmit + "; \r\n");
            // 提交
            sList.append("   window.document.getElementById('_PU_pageSize').form.submit(); \r\n");
            sList.append("}; \r\n");

            /**
             * 设置页码
             * @param pageNo 跳转到的页码
             * @param isSubmit 是否提交,为true时设置页码后提交,否则只设置页码不提交
             */
            sList.append(" _PU_.setPageNo = function (pageNo, isSubmit) { \r\n");
            // 设置页码
            sList.append("    window.document.getElementById('_PU_pageNo').value = parseInt(pageNo); \r\n");
            sList.append("    if ( true === isSubmit ) { this.submit(); } \r\n");
            sList.append(" }; \r\n");

            /**
             * 设置每页显示多少行
             * @param pageSize 每页显示多少行
             * @param isSubmit 是否提交,为true时设置显示数后提交,否则只设置不提交
             */
            sList.append(" _PU_.setPageSize = function (pageSize, isSubmit) { \r\n");
            sList.append("    if ( 0 < parseInt(pageSize) ) { window.document.getElementById('_PU_pageSize').value=parseInt(pageNo); } \r\n");
            // 设置跳转到第几页
            sList.append("    window.document.getElementById('_PU_pageSize').value = parseInt(pageSize); \r\n");
            sList.append("    if ( true === isSubmit ) { this.submit(); } \r\n");
            sList.append(" }; \r\n");

            /**
             * 过滤按键,只允许输入数字
             * @param event 事件 (为兼容 IE 和 FireFox)
             * @example <input type="text" onkeydown="return _PU_.input(event);"/>
             */
            sList.append(" _PU_.input = function (event) { \r\n");
            // 兼容 IE 和 FireFox
            sList.append("   event = event || window.event; \r\n");
            // 不让按下 Shift
            sList.append("   if ( event.shiftKey === true ) { return false; } \r\n");
            // 按下的键的編码
            sList.append("   var code = event.charCode || event.keyCode; \r\n");
            // 输入数字
            sList.append("   if ( (code >= 48 && code <= 57) || (code >= 96 && code <= 105) || ");
            // 输入刪除按键,左右按键
            sList.append("     code === 8  || code === 46 || code === 39 || code === 37  ) { return true; } \r\n");
            // Enter 键,先执行 onchange 事件,再提交
            sList.append("   if ( code === 13 ) { \r\n");
            // 取得事件源
            sList.append("      var source = event.target || event.srcElement; \r\n");
            // 事件源的名称
            sList.append("      var name = source.getAttribute('name'); \r\n");
            // 执行每页多少行的输入框的 onchange 事件
            sList.append("      if ( '_PU_text_size' === name ) { this.textSize_change(source); } \r\n");
            // 执行跳转到第几页的输入框的 onchange 事件
            sList.append("      else if ( '_PU_text_pageNo' === name ) { this.textPageNo_change(source); } \r\n");
            // 提交
            sList.append("      this.submit(); \r\n");
            sList.append("   } \r\n");
            // 其它按键,不让输入
            sList.append("   return false; \r\n");
            sList.append(" }; \r\n");

            /**
             * 每页多少行的输入框的 onchange 事件
             * @param inputer 输入框对象
             */
            sList.append(" _PU_.textSize_change = function(inputer) { \r\n");
            // 设值,输入不正確时默认为原本的值
            sList.append("   inputer.value = (parseInt(inputer.value) || " + this.pageSize + " ); \r\n");
            // 设值,总体的值
            sList.append("   window.document.getElementById('_PU_pageSize').value = inputer.value; \r\n");
            // 设值,其它的每页多少行的输入框的值
            sList.append("   var text_size = window.document.getElementsByName('_PU_text_size'); \r\n");
            sList.append("   for ( var i = 0; i < text_size.length; i++ ) { text_size[i].value = inputer.value; } \r\n");
            sList.append(" }; \r\n");

            /**
             * 跳转到第几页的输入框的 onchange 事件
             * @param inputer 输入框对象
             */
            sList.append(" _PU_.textPageNo_change = function(inputer) { \r\n");
            // 设值,输入不正確时默认为原本的值
            sList.append("   inputer.value = (parseInt(inputer.value) || " + this.pageNo + " ); \r\n");
            // 设值,总体的值
            sList.append("   window.document.getElementById('_PU_pageNo').value = inputer.value; \r\n");
            // 设值,其它的每页多少行的输入框的值
            sList.append("   var text_pageNo = window.document.getElementsByName('_PU_text_pageNo'); \r\n");
            sList.append("   for ( var i = 0; i < text_pageNo.length; i++ ) { text_pageNo[i].value = inputer.value; } \r\n");
            sList.append(" }; \r\n");

            /**
             * 调节宽度, 宽度不夠时隐藏 “第1~6行/共6行” 这个字段
             * @param outTime 第几个分页导航条
             */
            sList.append(" _PU_.autoWidth = function(outTime) { \r\n");
            sList.append("   if ( window.document.getElementById('_PU_pageControl' + outTime).offsetHeight > 30 ) { \r\n");
            sList.append("      window.document.getElementById('_PU_TDRowCount' + outTime).style.display = 'none'; \r\n");
            sList.append("   } \r\n");
            sList.append(" }; \r\n");

            /**
             * 排序方法(供页面引用)
             * @param filed 排序的字段
             */
            sList.append(" _PU_.sort = function(filed) { \r\n");
            sList.append("   if ( !filed ) { return; } \r\n");
            // 排序字段
            sList.append("   var sortElement = window.document.getElementById('_PU_sortFields'); \r\n");
            sList.append("   var preSortValue = sortElement.value; \r\n");
            sList.append("   sortElement.value = filed; \r\n");
            // 排序方向
            sList.append("   var ascDescElement = window.document.getElementById('_PU_sortAscOrDesc'); \r\n");
            sList.append("   var pre_order = ascDescElement.value.toLowerCase(); \r\n");
            sList.append("   if ( preSortValue === sortElement.value ) { ascDescElement.value = ( 'asc' === pre_order ) ? 'desc' : 'asc'; } \r\n");
            sList.append("   else { ascDescElement.value = 'asc' } \r\n");
            // 提交
            sList.append("   this.submit(); \r\n");
            sList.append(" }; \r\n");

            sList.append(" </SCRIPT> \r\n");
        }

        // 宽度不夠时隐藏 “第1~6行/共6行” 这个字段
        sList.append(" <SCRIPT type='text/javascript' language='JavaScript'> \r\n");
        sList.append("   _PU_.autoWidth(" + this.outTimes + "); \r\n");
        sList.append(" </SCRIPT> \r\n");

        this.outTimes++;
        return strEncode(sList.toString());
    }


    /**
     * 取代固定的变量
     * @param strSRC 要取代的字符串
     * @return 取代后的字符串
     */
    private String strEncode(String strSRC)
    {
        strSRC = strSRC.replace("${ORDER}", "\u7B2C"); // 第
        strSRC = strSRC.replace("${PAGE}", "\u9875"); // 页
        strSRC = strSRC.replace("${TOTAL}", "\u5171"); // 共
        strSRC = strSRC.replace("${ROW}", "\u884C"); // 行
        strSRC = strSRC.replace("${EverPage}", "\u6BCF\u9875"); // 每页
        // strSRC = strSRC.replace("${GOTO}", "\u8DF3\u5230"); //跳到
        return strSRC;
    }

}

%>