/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  MySqlHelper MySql数据库帮助类
创建日期：  2012-2-10
作者：      李永康
内容摘要： 
*/
using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using MySql.Data.MySqlClient;

namespace Barfoo.Library.Data
{
    /// <summary>
    /// MySQL utility
    /// </summary>
    public static class MySqlHelper
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="cs"></param>
        /// <returns></returns>
        public static MySqlConnection Connect(string cs)
        {
            MySqlConnection sqlcon = new MySqlConnection(cs);
            try
            {
                sqlcon.Open();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            return sqlcon;
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="sqlcon"></param>
        public static void Disconnect(MySqlConnection sqlcon)
        {
            try
            {
                if (sqlcon != null)
                {
                    sqlcon.Close();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sqlcon"></param>
        /// <param name="sql"></param>
        /// <returns></returns>
        public static DataTable Get(MySqlConnection sqlcon, string sql)
        {
            DataTable dt = new DataTable();
            MySqlDataAdapter sqlda = new MySqlDataAdapter(sql, sqlcon);
            try
            {
                sqlda.Fill(dt);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            return dt;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sqlcon"></param>
        /// <param name="sql"></param>
        /// <returns></returns>
        public static int Set(MySqlConnection sqlcon, string sql)
        {
            MySqlCommand sqlcom = new MySqlCommand(sql, sqlcon);
            try
            {
                return sqlcom.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            return -1;
        }


        /// <summary>
        /// 执行一条计算查询结果语句，返回查询结果（object）。
        /// </summary>
        /// <param name="SQLString">计算查询结果语句</param>
        /// <returns>查询结果（object）</returns>
        public static int ExecuteNonQuery(String connectionString,  string SQLString,CommandType  cmdType, params MySqlParameter[] cmdParms)
        {
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                using (MySqlCommand cmd = new MySqlCommand())
                {
                    try
                    {
                        PrepareCommand(cmd, connection, null,cmdType, SQLString, cmdParms);
                        int rows = cmd.ExecuteNonQuery();
                        cmd.Parameters.Clear();
                        cmd.Dispose();
                        connection.Close(); ;
                        return rows;
                    }
                    catch (MySqlException E)
                    {
                        cmd.Dispose();
                        connection.Close(); ;
                        throw new Exception(E.Message);
                    }
                    finally
                    {
                        cmd.Dispose();
                        connection.Close();
                    }
                }
            }
        }

        /**//// <summary>
        /// 执行一条返回结果集的SqlCommand命令，通过专用的连接字符串。
        /// 使用参数数组提供参数
        /// </summary>
        /// <remarks>
        /// 使用示例：  
        ///  SqlDataReader r = ExecuteReader(connString, CommandType.StoredProcedure, "PublishOrders", new SqlParameter("@prodid", 24));
        /// </remarks>
        /// <param name="connectionString">一个有效的数据库连接字符串</param>
        /// <param name="commandType">SqlCommand命令类型 (存储过程， T-SQL语句， 等等。)</param>
        /// <param name="commandText">存储过程的名字或者 T-SQL 语句</param>
        /// <param name="commandParameters">以数组形式提供SqlCommand命令中用到的参数列表</param>
        /// <returns>返回一个包含结果的SqlDataReader</returns>
        public static MySqlDataReader ExecuteReader(string connectionString, CommandType cmdType, string cmdText, params MySqlParameter[] commandParameters)
        {
            MySqlCommand cmd = new MySqlCommand();
            MySqlConnection conn = new MySqlConnection(connectionString);
            try
            {
                PrepareCommand(cmd, conn, null, cmdType, cmdText, commandParameters);
                MySqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                cmd.Parameters.Clear();
                return rdr;
            }
            catch
            {
                conn.Close();
                throw;
            }
        }
        public static MySqlDataReader ExecuteReader(string connectionString, string cmdText, params MySqlParameter[] commandParameters)
        {
            return ExecuteReader(connectionString, System.Data.CommandType.Text, cmdText, commandParameters);
        }

        /// <summary>
        /// 执行一条计算查询结果语句，返回查询结果（object）。
        /// </summary>
        /// <param name="SQLString">计算查询结果语句</param>
        /// <returns>查询结果（object）</returns>
        public static object ExecuteScalar(string connectionString, string SQLString, params MySqlParameter[] cmdParms)
        {
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                using (MySqlCommand cmd = new MySqlCommand())
                {
                    try
                    {
                        PrepareCommand(cmd, connection, null, CommandType.Text, SQLString, cmdParms);
                        object obj = cmd.ExecuteScalar();
                        cmd.Parameters.Clear();
                        if ((Object.Equals(obj, null)) || (Object.Equals(obj, System.DBNull.Value)))
                        {
                            cmd.Dispose();
                            connection.Close();
                            return null;
                        }
                        else
                        {
                            cmd.Dispose();
                            connection.Close();
                            return obj;
                        }
                    }
                    catch (System.Data.SqlClient.SqlException e)
                    {
                        connection.Close();
                        throw new Exception(e.Message);
                    }
                    finally
                    {
                        cmd.Dispose();
                        connection.Close();
                    }
                }
            }
        }
        private static void PrepareCommand(MySqlCommand cmd, MySqlConnection conn, MySqlTransaction trans, CommandType cmdType, string cmdText, MySqlParameter[] cmdParms)
        {
            if (conn.State != ConnectionState.Open)
                conn.Open();
            cmd.Connection = conn;
            cmd.CommandText = cmdText;
            cmd.CommandTimeout = 180;
            if (trans != null)
                cmd.Transaction = trans;
            cmd.CommandType = cmdType;
            if (cmdParms != null)
            {
                foreach (MySqlParameter parameter in cmdParms)
                {
                    if ((parameter.Direction == ParameterDirection.InputOutput || parameter.Direction == ParameterDirection.Input) &&
                        (parameter.Value == null))
                    {
                        parameter.Value = DBNull.Value;
                    }
                    cmd.Parameters.Add(parameter);
                }
            }
        }
    }
}