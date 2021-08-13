/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  DbHelper 数据库帮助类
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.IO;
using Barfoo.Library.Configuration;

namespace Barfoo.Library.Data
{
    /// <summary>
    /// 数据库帮助类
    /// 2009-7-15   重构ExecuteReader增加IEnumerable接口，支持延迟加载
    /// </summary>
    /// <example>
    /// <code>
    /// <![CDATA[
    ///  var con = ConfigurationManager.ConnectionStrings["TempDbCon"].ConnectionString;
    ///  var sql2 = "DELETE FROM GuidePrice WHERE CarTypeName = @CarTypeName";
    ///  var o = new { CarTypeName = "FX35 超越版" };
    ///  
    ///  DbHelper db = new DbHelper(SqlClientFactory.Instance, con);
    ///  using(var conn = db.CreateConnection())
    ///  {
    ///      var tran = db.CreateTransaction(conn);
    ///      var deleteCmd = db.CreateCommand(tran, sql2, o);
    ///      var errCmd = db.CreateCommand(tran, "DELETE FROM GG", null);
    ///  
    ///      db.ExecuteNonQuery(deleteCmd);
    ///      db.ExecuteNonQuery(errCmd);
    ///      
    ///      tran.Commit();
    ///  } 
    ///  
    ///  //获取自增列
    ///  var sql = "INSERT INTO [Test] ([Name]) VALUES (@Name) SELECT @@identity";
    ///  var id = db.ExecuteScalar<int>(sql, new { Name = "美国" });
    ///  
    ///  private IEnumerable<DbDataReader> GetArchives(int[] ids)
    ///  {
    ///      var sql = String.Format("SELECT * FROM [Archive] WHERE [id] IN ({0}) ORDER BY CHARINDEX(','+LTRIM(RTRIM(STR(Id)))+',' ,',{0},')", String.Join(",", Array.ConvertAll(ids, i => i.ToString())));
    ///      return helper.ExecuteReader(sql);
    ///  }
    /// ]]>
    /// </code>
    /// </example>
    public class DbHelper
    {
        #region Field

        public static TextWriter Out { get; set; }
        public static readonly string ConnectionStringKey = "DefaultConnection";

        public DbProviderFactory DbProviderFactory { get; private set; }
        private string connectionString;
        public int DefaultTimeout { get; set; }

        #endregion

        #region Constructor

        public DbHelper(DbProviderFactory factory, string connection)
        {
            this.DbProviderFactory = factory;
            this.connectionString = connection;
        }

        public DbHelper(string configKey)
        {
            var connSetting = ConfigurationUtility.ConnectionStringSettings(configKey);
            this.DbProviderFactory = DbProviderFactories.GetFactory(connSetting.ProviderName);
            this.connectionString = connSetting.ConnectionString;
        }

        public DbHelper()
            : this(ConnectionStringKey)
        {
        }

        #endregion

        #region CreateConnection

        public DbConnection CreateConnection()
        {
            var con = DbProviderFactory.CreateConnection();
            con.ConnectionString = connectionString;

            if (Out != null) con.StateChange += new StateChangeEventHandler(DbConnection_StateChange);

            return con;
        }

        #endregion

        #region CreateCommand

        public DbCommand CreateCommand(DbConnection con, string sql, object paramters)
        {
            var cmd = PrepareCommand(con, sql, CommandType.Text);

            if (paramters is IDictionary<string, object>)
            {
                foreach (var item in paramters as IDictionary<string, object>)
                {
                    PreparePrameter(cmd, item.Key, item.Value);
                }
            }
            //barque
            else if (paramters is DbParameter[])
            {
                foreach (var p in paramters as DbParameter[])
                {
                    PreparePrameter(cmd, p.ParameterName, p.Value);
                }
            }
            else if (paramters != null)
            {
                var properties = paramters.GetProperties();
                foreach (var p in properties)
                {
                    PreparePrameter(cmd, p.Name, p.GetValue(paramters, null));
                }
            }

            return cmd;
        }

        public DbCommand CreateCommand(DbConnection con, string sql)
        {
            return this.CreateCommand(con, sql, null);
        }

        public DbCommand CreateCommand(DbTransaction transaction, string sql, object paramters)
        {
            var cmd = this.CreateCommand(transaction.Connection, sql, paramters);
            cmd.Transaction = transaction;
            return cmd;
        }

        public DbCommand CreateCommand(DbTransaction transaction, string sql)
        {
            return this.CreateCommand(transaction, sql, null);
        }

        #endregion

        #region CreateTransaction

        public DbTransaction CreateTransaction(DbConnection con)
        {
            this.Open(con);
            return con.BeginTransaction();
        }

        #endregion

        #region ExecuteNonQuery

        public int ExecuteNonQuery(DbCommand cmd)
        {
            this.Open(cmd.Connection);

            TraceCommandText(cmd);

            return cmd.ExecuteNonQuery();
        }

        public int ExecuteNonQuery(string sql)
        {
            return ExecuteNonQuery(sql, null);
        }

        public int ExecuteNonQuery(string sql, object paramters)
        {
            using (var con = CreateConnection())
            {
                var cmd = CreateCommand(con, sql, paramters);
                this.Open(con);
                return ExecuteNonQuery(cmd);
            }
        }

        #endregion

        #region ExecuteScalar

        public T ExecuteScalar<T>(DbCommand cmd)
        {
            this.Open(cmd.Connection);

            TraceCommandText(cmd);

            var obj = cmd.ExecuteScalar();
            return obj == DBNull.Value || obj == null ? default(T) : (T)Convert.ChangeType(obj, typeof(T));
        }

        public T ExecuteScalar<T>(string sql)
        {
            return ExecuteScalar<T>(sql, null);
        }

        public T ExecuteScalar<T>(string sql, object paramters)
        {
            using (var con = CreateConnection())
            {
                var cmd = CreateCommand(con, sql, paramters);
                this.Open(con);

                return ExecuteScalar<T>(cmd);
            }
        }

        #endregion

        #region ExecuteReader

        #region IEnumerable<DbDataReader>

        public IEnumerable<DbDataReader> ExecuteReader(DbCommand cmd)
        {
            using (cmd.Connection)
            {
                this.Open(cmd.Connection);

                TraceCommandText(cmd);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        yield return reader;
                    }
                }
            }
        }

        public IEnumerable<DbDataReader> ExecuteReader(string sql)
        {
            return ExecuteReader(sql, (object)null);
        }

        public IEnumerable<DbDataReader> ExecuteReader(string sql, object paramters)
        {
            var con = CreateConnection();
            var cmd = CreateCommand(con, sql, paramters);
            return ExecuteReader(cmd);
        }

        #endregion

        #region IEnumerable<DbDataReader>

        public IEnumerable<T> ExecuteReader<T>(DbCommand cmd) where T : new()
        {
            using (cmd.Connection)
            {
                this.Open(cmd.Connection);

                TraceCommandText(cmd);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        yield return reader.Read<T>();
                    }
                }
            }
        }

        public IEnumerable<T> ExecuteReader<T>(string sql) where T : new()
        {
            return ExecuteReader<T>(sql, (object)null);
        }

        public IEnumerable<T> ExecuteReader<T>(string sql, object paramters) where T : new()
        {
            var con = CreateConnection();
            var cmd = CreateCommand(con, sql, paramters);
            return ExecuteReader<T>(cmd);
        }

        #endregion

        #endregion

        #region Private Method

        private void Open(DbConnection con)
        {
            if (con.State != ConnectionState.Open)
                con.Open();
        }

        private DbCommand PrepareCommand(DbConnection con, string sql, CommandType type)
        {
            var cmd = DbProviderFactory.CreateCommand();
            cmd.Connection = con;
            cmd.CommandText = sql;
            cmd.CommandType = type;

            if (DefaultTimeout != 0)
                cmd.CommandTimeout = DefaultTimeout;

            return cmd;
        }

        private void PreparePrameter(DbCommand cmd, string key, object value)
        {
            DbParameter param = DbProviderFactory.CreateParameter();
            param.ParameterName = key.ToString();
            param.Value = value ?? DBNull.Value;
            cmd.Parameters.Add(param);
        }

        private void TraceCommandText(DbCommand cmd)
        {
            if (Out != null) Out.WriteLine(cmd.CommandText);
        }

        private void DbConnection_StateChange(object sender, StateChangeEventArgs e)
        {
            Out.WriteLine("DbConnection state：{0}", e.CurrentState);
        }

        #endregion
    }
}
