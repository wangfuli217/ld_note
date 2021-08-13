<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>数据库操作</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script runat="server">
        // SQL 语句
        protected string SQL = null;
        // 数据库连接
        protected string ConnStr = null;
        // 操作类型
        protected string Method = null;
        // 查询结果
        protected System.Collections.Generic.IList<SortedList> rslist = null;
        // 操作影响行数
        protected int rows = 0;

        /// <summary>
        /// 页面加载函数
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            // SQL 语句
            SQL = Request["SQL"];
            if (!string.IsNullOrEmpty(SQL)) SQL = System.Web.HttpUtility.UrlDecode(SQL);
            // 数据库连接
            ConnStr = Request["ConnStr"];
            if (!string.IsNullOrEmpty(ConnStr)) ConnStr = System.Web.HttpUtility.UrlDecode(ConnStr);
            // 操作类型
            Method = Request["Method"];

            if (!string.IsNullOrEmpty(SQL) && !string.IsNullOrEmpty(ConnStr) && !string.IsNullOrEmpty(Method))
            {
                try
                {
                    // SQL SERVER的连接数据库并打开；
                    System.Data.IDbConnection myConnection = new System.Data.SqlClient.SqlConnection(ConnStr);
                    if ("Execute".Equals(Method))
                    {
                        rows = excuteSQL(myConnection, SQL);
                    }
                    else if ("Select".Equals(Method))
                    {
                        rslist = SelectSQL(myConnection, SQL);
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<div style='color:red'>操作异常, 错误源:" + ex.Source + "<br/>\r\n");
                    if (!string.IsNullOrEmpty(ex.Message))
                    {
                        Response.Write("错误信息:" + ex.Message + "<br/>\r\n");
                    }
                    else
                    {
                        Response.Write("错误信息:" + ex.ToString() + "<br/>\r\n");
                    }
                    Response.Write("堆信息：" + ex.StackTrace.Replace("\r\n", "<br/>\r\n") + "</div><br/>\r\n\r\n\r\n");
                }
            }
        }

        #region 数据库操作
        /// <summary>
        /// 获取数据库信息
        /// </summary>
        /// <param name="sql">查询SQL</param>
        /// <returns>结果集</returns>
        public System.Collections.Generic.IList<SortedList> SelectSQL(System.Data.IDbConnection conn, string sql)
        {
            System.Collections.Generic.IList<SortedList> list = new System.Collections.Generic.List<SortedList>();
            OpenConn(conn);
            using (System.Data.IDbCommand cmd = conn.CreateCommand())
            {
                //查询SQL
                cmd.CommandText = sql;
                cmd.Connection = conn;
                //查询结果
                System.Data.IDataReader result = cmd.ExecuteReader();
                while (result.Read())
                {
                    SortedList ht = new SortedList();
                    // 逐个字段读取出来
                    for (int i = 0; i < result.FieldCount; i++)
                    {
                        // 取出来的值，要防止null而报错
                        object value = result.GetValue(i);
                        value = value == null ? null : value.ToString();
                        // 取出来的字段名，加上类型
                        string name = result.GetName(i);
                        ht.Add(name, value);
                    }
                    //加入结果集
                    list.Add(ht);
                }
                //关闭result
                if (result != null)
                {
                    result.Close();
                    result = null;
                }
            }
            //关闭连接
            CloseConn(conn);
            return list;
        }

        /// <summary>
        /// 执行数据库操作sql
        /// </summary>
        /// <param name="sql">数据库操作sql</param>
        /// <returns>操作影响行数</returns>
        public int excuteSQL(System.Data.IDbConnection conn, string sql)
        {
            int rows = 0;
            OpenConn(conn);
            using (System.Data.IDbCommand cmd = conn.CreateCommand())
            {
                //执行数据库操作SQL
                cmd.CommandText = sql;
                cmd.Connection = conn;
                rows = cmd.ExecuteNonQuery();
            }
            //关闭连接
            CloseConn(conn);
            return rows;
        }

        /// <summary>
        /// 打开数据库连接
        /// </summary>
        /// <param name="conn"></param>
        public void OpenConn(System.Data.IDbConnection conn)
        {
            if (conn.State == System.Data.ConnectionState.Closed)
            {
                conn.Open();
            }
        }

        /// <summary>
        /// 关闭数据库连接
        /// </summary>
        /// <param name="conn"></param>
        public void CloseConn(System.Data.IDbConnection conn)
        {
            //关闭连接
            if (conn != null && conn.State != System.Data.ConnectionState.Closed)
            {
                conn.Close();
                conn = null;
            }
        }
        #endregion

        #region 页面操作
        /// <summary>
        /// 将需要显示的字符串转换成 textarea 显示的字符串
        /// </summary>
        /// <param name="sour">被转换的字符串</param>
        /// <returns>转换后的字符串</returns>
        public string ToTextarea(string sour)
        {
            if (string.IsNullOrEmpty(sour)) return "";

            // 以下逐一转换
            sour = sour.Replace("&", "&amp;");
            sour = sour.Replace("<", "&lt;");
            sour = sour.Replace(">", "&gt;");
            return sour;
        }

        /// <summary>
        /// 将需要显示的字符串转换成 HTML 格式的
        /// </summary>
        /// <param name="sour">被转换的字符串</param>
        /// <returns>转换后的字符串</returns>
        public string ToHtml(object sour)
        {
            if (sour == null || "".Equals(sour)) return "";
            string text = sour.ToString();
            // 以下逐一转换
            text = text.Replace("&", "&amp;"); // & 符號,最先转换
            text = text.Replace(" ", "&nbsp;");
            text = text.Replace("%", "&#37;");
            text = text.Replace("<", "&lt;");
            text = text.Replace(">", "&gt;");
            text = text.Replace("\n", "\n<br/>");
            text = text.Replace("\"", "&quot;");
            text = text.Replace("'", "&#39;");
            text = text.Replace("+", "&#43;");
            return text;
        }
        #endregion
    </script>
</head>
<body>
    <form name='pageForm' id='pageForm' method='post' action='#'>
        操作类型：
        <select name='Method'>
            <option value='Select' <%= ("Select".Equals(Method) ? " selected " : "") %>>查询</option>
            <option value='Execute' <%= ("Execute".Equals(Method) ? " selected " : "") %>>执行</option>
        </select>
        &nbsp;&nbsp;&nbsp;&nbsp; 数据库连接：
        <select onchange='this.form.tc.value=this.value'>
            <%
                int connIndex = 0;
                // 遍历所有的数据库连接
                foreach (object conn in System.Configuration.ConfigurationManager.ConnectionStrings)
                {
                    string str = conn.ToString();
                    if (string.IsNullOrEmpty(str)) continue; // 空字符串的过滤掉
                    // 截取出database的部分
                    string database = str.Replace(" ", "").ToLower();
                    if (database.IndexOf("database=") < 0) continue; // 没包含数据库连接信息的，过滤掉
                    // 赋值默认的数据库连接
                    if (string.IsNullOrEmpty(ConnStr) && connIndex == 0)
                    {
                        ConnStr = str; connIndex++;
                    }
                    database = database.Substring(database.IndexOf("database=") + 9);
                    database = database.Substring(0, database.IndexOf(";"));
                    Response.Write("<option value='" + str + "'" + (str.Equals(ConnStr) ? " selected " : "") + ">" + database + "</option>\r\n");
                }
            %>
        </select>
        <input type='text' name='tc' value='<%= ConnStr %>' style='width: 70%' />
        <input type='hidden' name='ConnStr' value='' /><br />
        <%-- // SQL 语句输入框 --%>
        <textarea name='ts' id='ts' rows='5' cols='100' style='width: 98%'><%= ToTextarea(SQL) %></textarea><br />
        <input type='hidden' name='SQL' value='' />
        <%-- // 提交按钮(SQL输入的内容转码一下，以免被系统安全验证时屏蔽掉) --%>
        <input type='submit' value='提交' onclick='this.form.SQL.value = encodeURIComponent(this.form.ts.value);this.form.ConnStr.value = encodeURIComponent(this.form.tc.value);' />
    </form>

    <%
        //列印出 查詢SQL 和操作SQL
        int listSize = (rslist == null ? 0 : rslist.Count);
        if (!string.IsNullOrEmpty(SQL))
        {
            if (rslist != null)
            {
                Response.Write("查询资料 " + listSize + " 行 <br>\r\n");
            }
            else
            {
                Response.Write("操作影响 " + rows + " 行 <br>\r\n");
            }
        }

        // 序号记录
        int index = 0;
        // 数据表格
        if (listSize > 0)
        {
            Response.Write("<br />\r\n<table border='1' align='center'><tbody>\r\n");
            Response.Write("<tr>\r\n");
            Response.Write("<th title='序号'>序号</th>\r\n");
            foreach (System.Collections.DictionaryEntry de in rslist[0])
            {
                Response.Write("<th title='" + de.Key.ToString() + "'>" + de.Key.ToString() + "</th>");
            }
            Response.Write("</tr>\r\n\r\n");
        }
        //各行数据
        for (int i = 0; i < listSize; i++)
        {
            Response.Write("<tr>\r\n");
            Response.Write("<td title='" + (++index) + "'>" + index + "</td>\r\n");
            //各字段数据
            foreach (System.Collections.DictionaryEntry de in rslist[i])
            {
                object value = de.Value;
                value = value == null ? null : value.ToString();
                //为""时,加上空格
                string title = ("".Equals(value) ? "&nbsp;" : ToHtml(value));
                string showValue = (value == null ? "<font color='red'>null</font>" : title);
                //为null时,红色显示
                Response.Write("<td title='" + title + "'>" + showValue + "</td>\r\n");
            }
            Response.Write("</tr>\r\n\r\n");
        }
        // 表格结束
        if (listSize > 0)
        {
            Response.Write("</tbody></table><br />\r\n");
        }
    %>
</body>
</html>