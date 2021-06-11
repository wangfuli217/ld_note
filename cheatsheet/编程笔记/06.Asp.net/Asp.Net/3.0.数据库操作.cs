
1. 连接数据库
    using System;
    using MySql.Data.MySqlClient;
    public partial class Default3 : System.Web.UI.Page
    {
      protected void Page_Load(object sender, EventArgs e)
      {
          // 数据库连接；
          // "server=数据库连接;uid=用户名;pwd=密码;database=数据库名字";
          String connStr = "server=127.0.0.1;uid=root;pwd=root;database=ftc";
          // 这里是SQL语句
          String sql = "select distinct years from ft_running_status";
          // 查询结果
          string bookres = "";
          try
          {
              MySqlConnection myConnection = new MySqlConnection(connStr);
              myConnection.Open();
              MySqlCommand myCommand = new MySqlCommand(sql, myConnection);
              myCommand.ExecuteNonQuery();
              MySqlDataReader myDataReader = myCommand.ExecuteReader();
              // 读取内容
              while ( myDataReader.Read() )
              {
                  bookres += myDataReader["years"] + " ";
              }
              // 关闭资源
              myDataReader.Close();
              myConnection.Close();
              // 写出内容
              loginname.Text = bookres;
              Response.Write("链接成功！");
          }
          catch
          {
              Response.Write("链接失败！");
          }
      }
    }


2. 读取数据库里的内容
    如果是读取一条记录的数据或者少量的数据，我们用 DATAREADER 采集数据，然后赋值给WEB控件的Text属性即可；
    如果是读取大量数据我们就采用 DATAGRID。

    注意：上面是连接 MySQL 数据库，需要把“MySql.Data.dll”复制到 工程目录下的bin目录下.
    “MySql.Data.dll”的下载地址：http://dev.mysql.com/downloads/connector/net/5.1.html
    需要加上 using Mysql.Data.MysqlClient;
    然后使用 MySqlConnection 替换 SqlConnection ，其他和 Sqlserver 相似.


    // SqlServer 数据库链接举例：
    using System;
    using System.Data.SqlClient;

    public partial class Default3 : System.Web.UI.Page
    {
      protected void Page_Load(object sender, EventArgs e)
      {
          // SQL SERVER的连接数据库并打开；
          String connStr = "server=192.168.0.133;uid=sa;pwd=sa;database=nissan";
          SqlConnection myConnection = new SqlConnection(connStr);
          String sql = "select * from userInfo"; //这里是SQL语句
          SqlCommand objCommand = new SqlCommand(sql, myConnection);
          myConnection.Open();
          SqlDataReader objDataReader = objCommand.ExecuteReader();
          //只读取第一行的数据; 如果需要读取所有行,用“while ( objDataReader.Read() )”
          if ( objDataReader.Read() )
          {
            loginname.Text = Convert.ToString(objDataReader["loginname"]);
            username.Text = Convert.ToString(objDataReader["username"]);
            email.Text = Convert.ToString(objDataReader["email"]);
            password.Text = Convert.ToString(objDataReader["password"]);
            /*
             * 转换为字符串：Convert.ToString()
             * 转换为数字：Convert.ToInt64()，Convert.ToInt32()，Convert.ToInt16()
             * 是按照数字位数由长到短
             * 转换为日期：Convert.ToDateTime()
             */
          }
          Response.Write("链接成功！");
      }
    }


3. 使用ADOX创建Access数据库和表
    由于在程序中使用了ADOX，所以先要在解决方案中引用之，方法如下：
    解决方案资源管理器-->引用-->(右键)添加引用-->COM-->Microsoft ADO Ext. 2.8 for DDL and Security

    private void btnCreate_Click(object sender, EventArgs e)
    {
        //如果文件已经存在，会出错
        string dbName = "E:\\Temp\\" + DateTime.Now.Millisecond.ToString() + ".mdb";
        ADOX.CatalogClass cat = new ADOX.CatalogClass();
        cat.Create("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + dbName + ";");
        MessageBox.Show("数据库：" + dbName + "已经创建成功！");

        //新建一个表
        ADOX.TableClass tbl = new ADOX.TableClass();
        tbl.ParentCatalog = cat;
        tbl.Name = "MyTable";

        //增加一个自动增长的字段
        ADOX.ColumnClass col = new ADOX.ColumnClass();
        col.ParentCatalog = cat;
        col.Type = ADOX.DataTypeEnum.adInteger; // 必须先设置字段类型
        col.Name = "id";
        col.Properties["Jet OLEDB:Allow Zero Length"].Value = false;
        col.Properties["AutoIncrement"].Value = true;
        tbl.Columns.Append(col, ADOX.DataTypeEnum.adInteger, 0);

        //增加一个文本字段
        ADOX.ColumnClass col2 = new ADOX.ColumnClass();
        col2.ParentCatalog = cat;
        col2.Name = "Description";
        col2.Properties["Jet OLEDB:Allow Zero Length"].Value = false;
        tbl.Columns.Append(col2, ADOX.DataTypeEnum.adVarChar, 25);
        cat.Tables.Append(tbl);   //这句把表加入数据库(非常重要)
        MessageBox.Show("数据库表：" + tbl.Name + "已经创建成功！");
        tbl = null;
        cat = null;
    }


