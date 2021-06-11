/**
 * <P> Title: 公用类                        </P>
 * <P> Description: 数据库操作工具          </P>
 * <P> Copyright: Copyright (c) 2011/05/14  </P>
 * <P> Company:ZhongKu Tech. Ltd.           </P>
 * @author <A href="daillow@gmail.com">Holer</A>
 */
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.Common;

using MySql.Data.MySqlClient;

namespace Com.Util
{
    public class DbUtil
    {

        /// <summary>
        /// 数据库连接字符串(web.config来配置, 信息如: "server=127.0.0.1;uid=root;pwd=root;database=zk_shop")
        /// </summary>
        private static string connectionString = null;

        /// <summary>
        /// 获取数据库连结
        /// </summary>
        /// <returns>数据库连结</returns>
        public static DbConnection Open_Conn()
        {
            // 读取数据库连结信息
            if (string.IsNullOrEmpty(connectionString))
            {
                connectionString = ConfigurationManager.AppSettings["Db_Connection"];
            }
            return Open_Conn(connectionString);
        }


        /// <summary>
        /// 获取数据库连结
        /// </summary>
        /// <param name="connStr">数据库连结信息</param>
        /// <returns>数据库连结</returns>
        public static DbConnection Open_Conn(string connStr)
        {
            DbConnection conn = null;
            try
            {
                // 获取数据库连结
                conn = new MySqlConnection(connStr);
                conn.Open();
            }
            // 抛出 数据库驱动找不到例外
            catch (Exception e)
            {
                LogUtil.log("数据库连接出错：" + e);
                throw e;
            }
            return conn;
        }


        /// <summary>
        /// 关闭数据库连结
        /// </summary>
        /// <returns>数据库连结</returns>
        public static void Close(DbConnection conn)
        {
            try
            {
                if (conn != null)
                {
                    // 关闭数据库链接
                    conn.Close();
                    conn.Dispose();
                    conn = null;
                }
                //GC.Collect();
            }
            // 捕获异常
            catch (Exception e)
            {
                LogUtil.log("关闭数据库连接出错：" + e);
            }
        }


        /// <summary>
        /// 生成Command对象
        /// </summary>
        /// <param name="SQL">数据库操作语句</param>
        /// <param name="Conn">数据库连接</param>
        /// <returns>数据库执行的基类</returns>
        public static DbCommand Create_Cmd(string SQL, DbConnection Conn)
        {
            // DbCommand Cmd = new MySqlCommand(SQL, (MySqlConnection)Conn);
            DbCommand Cmd = Conn.CreateCommand();
            Cmd.CommandText = SQL;
            // Cmd.CommandType = CommandType.StoredProcedure; // 存储过程
            return Cmd;
        }


        /// <summary>
        ///  运行Sql语句返回 DbDataAdapter对象
        /// </summary>
        /// <param name="SQL">数据库操作语句</param>
        /// <param name="Conn">数据库连接</param>
        /// <returns>数据库执行的基类</returns>
        public static DbDataAdapter Get_Adapter(string SQL, DbConnection Conn)
        {
            DbDataAdapter Da = new MySqlDataAdapter(SQL, (MySqlConnection)Conn);
            return Da;
        }


        /// <summary>
        /// 执行SQL语句
        /// </summary>
        /// <param name="SQL">需要执行的SQL语句</param>
        /// <returns>执行影响的条数</returns>
        public static int Run_SQL(string SQL)
        {
            DbConnection Conn = Open_Conn();
            try
            {
                DbCommand Cmd = Create_Cmd(SQL, Conn);
                int result_count = Cmd.ExecuteNonQuery();
                return result_count;
            }
            catch (Exception e)
            {
                LogUtil.log("执行数据库操作出错：" + e);
                LogUtil.log("数据库操作出错语句：" + SQL);
                throw e;
            }
            finally
            {
                Close(Conn);
            }
        }


        /// <summary>
        ///  查询SQL
        /// </summary>
        /// <param name="SQL">数据库查询语句</param>
        /// <returns>数据库资料集合</returns>
        public static IList<Hashtable> Get_Data(string SQL)
        {
            IList<Hashtable> list = new List<Hashtable>();
            DbConnection Conn = Open_Conn();
            try
            {
                DbCommand Cmd = Create_Cmd(SQL, Conn);
                //查询结果
                IDataReader result = Cmd.ExecuteReader();
                while ( result.Read() )
                {
                    Hashtable ht = new Hashtable();
                    //一行资料中，逐个读取
                    for ( int i = 0; i < result.FieldCount; i++ )
                    {
                        ht.Add(result.GetName(i), result.GetValue(i));
                    }
                    //加入一行资料
                    list.Add(ht);
                }
                //关闭result
                if ( result != null )
                    result.Close();
                return list;
            }
            catch (Exception e)
            {
                LogUtil.log("执行数据库操作出错：" + e);
                LogUtil.log("数据库操作出错语句：" + SQL);
                throw e;
            }
            finally
            {
                Close(Conn);
            }
        }


        /// <summary>
        ///  查询SQL
        /// </summary>
        /// <param name="SQL">数据库查询语句</param>
        /// <returns>数据库资料集合</returns>
        public static Hashtable Get_One_Line(string SQL)
        {
            Hashtable ht = new Hashtable();
            DbConnection Conn = Open_Conn();
            try
            {
                DbCommand Cmd = Create_Cmd(SQL, Conn);
                //查询结果
                IDataReader result = Cmd.ExecuteReader();
                if (result.Read())
                {
                    //一行资料中，逐个读取
                    for (int i = 0; i < result.FieldCount; i++)
                    {
                        ht.Add(result.GetName(i), result.GetValue(i));
                    }
                }
                //关闭result
                if (result != null)
                    result.Close();
                return ht;
            }
            catch (Exception e)
            {
                LogUtil.log("执行数据库操作出错：" + e);
                LogUtil.log("数据库操作出错语句：" + SQL);
                throw e;
            }
            finally
            {
                Close(Conn);
            }
        }


        /// <summary>
        ///  查询一个结果
        /// </summary>
        /// <param name="SQL"></param>
        /// <returns>返回SQL语句执行结果的一个结果; 查询不到时返回null</returns>
        public static object Get_One_Value(string SQL)
        {
            DbConnection Conn = Open_Conn();
            IDataReader Dr = null;
            try
            {
                Dr = Create_Cmd(SQL, Conn).ExecuteReader();
                if (Dr.Read())
                {
                    //读取第一行的第一列的结果
                    return Dr[0];
                }
                //查询不到时返回null
                return null;
            }
            catch (Exception e)
            {
                LogUtil.log("执行数据库操作出错：" + e);
                LogUtil.log("数据库操作出错语句：" + SQL);
                throw e;
            }
            finally
            {
                Dr.Close();
                Close(Conn);
            }
        }


        /// <summary>
        ///  运行SQL语句,返回DataSet对象，将数据进行了分页
        /// </summary>
        /// <param name="SQL">数据库查询语句</param>
        /// <param name="Ds"></param>
        /// <param name="StartIndex">从第几行开始查询(从零开始)</param>
        /// <param name="PageSize">每页显示多少笔</param>
        /// <param name="tablename">用于表映射的源表的名称</param>
        /// <returns>查询结果集</returns>
        public static DataSet Get_DataSet(string SQL, DataSet Ds, int StartIndex, int PageSize, string tablename)
        {
            DbConnection Conn = Open_Conn();
            DbDataAdapter Da = Get_Adapter(SQL, Conn);
            try
            {
                Da.Fill(Ds, StartIndex, PageSize, tablename);
                return Ds;
            }
            catch(Exception e)
            {
                LogUtil.log("执行数据库操作出错：" + e);
                LogUtil.log("数据库操作出错语句：" + SQL);
                throw e;
            }
            finally
            {
                Close(Conn);
            }
        }


        /// <summary>
        /// 传递参数
        /// </summary>
        /// <param name="Conn">数据库连接</param>
        /// <param name="cmd">Command对象</param>
        /// <param name="trans">事务</param>
        /// <param name="SQL">数据库操作语句</param>
        /// <param name="parameters">参数列表</param>
        private static void PrepareCommand(DbConnection Conn, DbCommand cmd, DbTransaction trans, string SQL, IList<DbParameter> parameters)
        {
            //开连接
            if (Conn.State != ConnectionState.Open)
                Conn.Open();
            cmd.Connection = Conn;
            cmd.CommandText = SQL;
            if (trans != null)
                cmd.Transaction = trans;
            //给Command添加参数
            if (parameters != null)
            {
                foreach (MySqlParameter parm in parameters)
                    cmd.Parameters.Add(parm);
            }
        }


        /// <summary>
        /// 执行Sql语句,同时进行事务处理
        /// </summary>
        /// <param name="sqlstr">传入的Sql语句</param>
        public static void Transaction(string sqlstr)
        {
            if (sqlstr == null || sqlstr == "")
                throw new Exception();

            DbConnection Conn = Open_Conn();
            //可以在事务中创建一个保存点，同时回滚到保存点
            DbTransaction trans = Conn.BeginTransaction();
            try
            {
                DbCommand Cmd = Create_Cmd(sqlstr, Conn);
                Cmd.Transaction = trans;
                Cmd.CommandType = CommandType.Text;
                Cmd.CommandText = sqlstr;
                Cmd.ExecuteNonQuery();
                trans.Commit();
            }
            catch (Exception e)
            {
                LogUtil.log("执行数据库操作出错：" + e);
                LogUtil.log("数据库操作出错语句：" + sqlstr);
                trans.Rollback();
            }
            finally
            {
                trans.Dispose();
                Close(Conn);
            }
        }


    }
}