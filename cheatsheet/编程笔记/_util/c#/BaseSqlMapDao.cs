//2010/06/28 holer add 取得資料庫資料(本地sql) 行:434-475
//2009/07/30 jackter add 單一查詢(本地sql) 行:320-362
//2009/07/25 jackter add 查詢本地sql,分頁 行:276-305
//2009/07/01 dennis 加入SelectPageObjct方法 148-271
//2009/06/25 dennis 加入ExecuteAllDelete方法 116-145
/**
 * <P> Title: POPS                      	</P>	
 * <P> Description: DAO公共類　　　      	</P>	
 * <P> Copyright: Copyright (c) 2009/5/29 	</P>	
 * <P> Company:Everunion Tech. Ltd.         </P>	
 * @author Andy
 * @version 0.6 Original Design from design document.	
 */
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using NHibernate;
using NHibernate.Transform;

using System.Text;

namespace Com.Everunion.Util
{

    /// <summary>
    /// 所有的DAo將從他繼承
    /// </summary>
    public class BaseSqlMapDao
    {
        //log
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(BaseSqlMapDao));
        /// <summary>
        /// 新增
        /// </summary>
        /// <param name="newo">物件</param>
        /// <returns>主鍵</returns>
        public Object ExecuteInsert(Object newo)
        {
            ISession session = HibernateHelper.GetCurrentSession();
            ITransaction tx = HibernateHelper.BeginTransaction();
            try
            {
                //儲存  
                Object o = session.Save(newo);
                HibernateHelper.CommitTransaction();
                return o;
            }
            //例外
            catch
            {
                HibernateHelper.RollbackTransaction();
                log.Error("新增" + newo + "失敗！");
                throw;
            }
            //關閉
            finally
            {
                HibernateHelper.CloseSession();
            }
        }


        /// <summary>
        /// 更新物件
        /// </summary>
        /// <param name="o">待更新的物件</param>
        public void ExecuteUpdate(Object o)
        {
            ISession session = HibernateHelper.GetCurrentSession();
            ITransaction tr = HibernateHelper.BeginTransaction();
            try
            {
                session.Merge(o);
                HibernateHelper.CommitTransaction();
            }
            //例外
            catch
            {
                HibernateHelper.RollbackTransaction();
                log.Error("更新" + o + "失敗！");
                throw;
            }
            //關閉連結
            finally
            {
                HibernateHelper.CloseSession();
            }
        }


        /// <summary>
        /// 刪除物件
        /// </summary>
        /// <param name="id">主鍵</param>
        public void ExecuteDeleteById<T>(Object id)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            try
            {
                HibernateHelper.BeginTransaction();
                T temp = session.Load<T>(id);
                session.Delete(temp);
                HibernateHelper.CommitTransaction();
            }
            //例外
            catch ( Exception e )
            {
                HibernateHelper.RollbackTransaction();
                log.Error("刪除資料" + typeof(T) + "主鍵為："+ id + "失敗" + e.Message);
                throw e;
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
        }


        //2009/06/25 dennis add 加入ExecuteAllDelete方法
        /// <summary>
        /// 根據條件刪除資料
        /// </summary>
        /// <param name="sql">查詢sql(from test a where a.Id='1' )</param>
        public void ExecuteAllDelete(string sql)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            try
            {
                HibernateHelper.BeginTransaction();
                //刪除
                session.Delete(sql);
                HibernateHelper.CommitTransaction();
            }
            //例外
            catch ( Exception e )
            {
                HibernateHelper.RollbackTransaction();
                log.Error("刪除資料" + sql + "失敗" + e.Message);
                throw e;
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
        }
        //2009/06/25 dennis end


        //2009/07/01 dennis add 加入SelectPageObjct方法
        /// <summary>
        /// 單一查詢
        /// </summary>
        /// <param name="hql">hql</param>
        /// <returns>結果集</returns>
        public T SelectUnique<T>(string hql)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            try
            {
                //操作訊息
                return session.CreateQuery(hql).SetMaxResults(1).UniqueResult<T>();
            }
            //拋出例外
            catch ( Exception e )
            {
                log.Error("GetUniqueObjct.sql:" + hql);
                //輸出錯誤
                log.Error("GetUniqueObjct.error:" + e.ToString());
                throw e;
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
        }


        /// <summary>
        /// 取得T物件
        /// </summary>
        /// <param name="oid">主鍵</param>
        public T SelectByKey<T>(Object oid)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            try
            {
                return session.Get<T>(oid);
            }
            //例外
            catch (Exception e)
            {
                log.Error("SelectByKey.error " + e.Message);
                log.Error("SelectByKey.oid " + oid);
                throw e;
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
        }


        /// <summary>
        /// 群組分頁查詢
        /// </summary>
        /// <param name="sql">sql</param>
        /// <returns>結果集</returns>
        public IList<T> SelectGroupPage<T>(string sql)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            try
            {
                PageUtil pu = new PageUtil();
                IQuery query = pu.GetObjectQuery(session, sql, true);
                //操作訊息
                return query.List<T>();
            }
            //拋出例外
            catch ( Exception e )
            {
                log.Error("SelectGroupPage.sql:" + sql);
                //輸出錯誤
                log.Error("SelectGroupPage.error:" + e.ToString());
                throw e;
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
        }


        /// <summary>
        /// 分頁查詢
        /// </summary>
        /// <param name="sql">sql</param>
        /// <returns>結果集</returns>
        public IList<T> SelectPage<T>(string sql)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            try
            {
                PageUtil pu = new PageUtil();
                IQuery query = pu.GetObjectQuery(session, sql, false);
                //操作訊息
                return query.List<T>();
            }
            //拋出例外
            catch ( Exception e )
            {
                log.Error("SelectPage.sql:" + sql);
                //輸出錯誤
                log.Error("SelectPage.error:" + e.ToString());
                throw e;
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
        }


        /// <summary>
        /// 查詢(不分頁)
        /// </summary>
        /// <param name="hql">hql</param>
        /// <returns>結果集</returns>
        public IList<T> Select<T>(string hql)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            try
            {
                //操作訊息
                return session.CreateQuery(hql).List<T>();
            }
            //拋出例外
            catch ( Exception e )
            {
                log.Error("Select.hql:" + hql);
                //輸出錯誤
                log.Error("Select.error:" + e.ToString());
                throw e;
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
        }
        //2009/07/01 dennis end	

        //2009/07/25 jackter add 查詢本地sql,分頁
        /// <summary>
        /// 查詢(本地sql,分頁)
        /// </summary>
        /// <param name="nativeSql">本地sql</param>
        /// <returns>結果集</returns>
        public IList<T> SelectPageNativeSQL<T>(string nativeSql)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            try
            {
                //操作訊息
                ISQLQuery sqlQuery = session.CreateSQLQuery(new PageUtil(session,nativeSql).PageSql);
                //已定義的實體類
                if ( typeof(T).FullName.StartsWith("Com.Everunion") )
                {
                    return sqlQuery.SetResultTransformer(Transformers.AliasToBean(typeof(T))).List<T>();
                }
                //其它,如(T=object[])
                else
                {
                    return sqlQuery.List<T>();
                }
            }
            //拋出例外
            catch ( Exception e )
            {
                log.Error("SelectNativeSQL.sql:" + nativeSql);
                //輸出錯誤
                log.Error("SelectNativeSQL.error:" + e.ToString());
                throw e;
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
        }
        //2009/07/25 jackter end


        //2009/07/30 jackter add 單一查詢(本地sql)

        /// <summary>
        /// 單一查詢(本地sql)
        /// </summary>
        /// <param name="sql">sql</param>
        /// <returns>結果集</returns>
        public T SelectUniqueNativeSQL<T>(string sql)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            try
            {
                //操作訊息
                ISQLQuery sqlQuery = session.CreateSQLQuery(sql);
                //已定義的實體類
                if ( typeof(T).FullName.StartsWith("Com.Everunion") )
                {
                    return sqlQuery.SetMaxResults(1)
                        .SetResultTransformer(Transformers.AliasToBean(typeof(T)))
                        .UniqueResult<T>();                
                }
                //其它,如(T=object[])
                else
                    return sqlQuery.SetMaxResults(1).UniqueResult<T>();

            }
            //拋出例外
            catch ( Exception e )
            {
                log.Error("SelectUniqueNativeSQL.sql:" + sql);
                //輸出錯誤
                log.Error("SelectUniqueNativeSQL.error:" + e.ToString());
                throw e;
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
        }
        //2009/07/30 jackter end


        /// <summary>
        /// 不分頁查詢(本地sql)
        /// </summary>
        /// <param name="sql">sql</param>
        /// <returns>結果集</returns>
        public IList<T> SelectNativeSQL<T>(string sql)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            try
            {
                //操作訊息
                ISQLQuery sqlQuery = session.CreateSQLQuery(sql);
                //已定義的實體類
                if ( typeof(T).FullName.StartsWith("Com.Everunion") )
                {
                    return sqlQuery.SetResultTransformer(Transformers.AliasToBean(typeof(T)))
                        .List<T>();
                }
                //其它,如(T=object[])
                else
                    return sqlQuery.List<T>();

            }
            //拋出例外
            catch ( Exception e )
            {
                log.Error("SelectNativeSQL.sql:" + sql);
                //輸出錯誤
                log.Error("SelectNativeSQL.error:" + e.ToString());
                throw e;
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
        }

        //2010/06/28 holer add 取得資料庫資料(本地sql) start
        /// <summary>
        /// 取得資料庫資料(本地sql)
        /// </summary>
        /// <param name="sql">資料庫查詢SQL(本地sql)</param>
        /// <returns>結果集</returns>
        public IList<Hashtable> SelectNativeSQL(string sql)
        {
            IList<Hashtable> list = new List<Hashtable>();
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            IDbConnection conn = session.Connection;
            IDbCommand cmd = conn.CreateCommand();
            try
            {
                //查詢SQL
                cmd.CommandText = sql;
                cmd.Connection = conn;
                //查詢結果
                IDataReader result = cmd.ExecuteReader();
                while ( result.Read() )
                {
                    Hashtable ht = new Hashtable();
                    for ( int i = 0; i < result.FieldCount; i++ )
                    {
                        ht.Add(result.GetName(i), result.GetValue(i).ToString());
                    }
                    //加入資料
                    list.Add(ht);
                }
                //關閉result
                if ( result != null )
                    result.Close();
            }
            finally
            {
                //關閉連結
                HibernateHelper.CloseSession();
            }
            return list;
        }
        //2010/06/28 holer end

        public Hashtable SelectHTNativeSQL(string sql)
        {
            Hashtable ht = new Hashtable();
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            IDbConnection conn = session.Connection;
            IDbCommand cmd = conn.CreateCommand();
            try
            {
                //查詢SQL
                cmd.CommandText = sql;
                cmd.Connection = conn;
                //查詢結果
                IDataReader result = cmd.ExecuteReader();
                while (result.Read())
                {
                    ht.Add(result.GetString(0).Trim(), result.GetString(1).Trim());
                }
                //關閉result
                if (result != null)
                    result.Close();
            }
            finally
            {
                //關閉連結
                HibernateHelper.CloseSession();
            }
            return ht;
        }

        // <summary>
        /// 取得資料庫資料(本地sql)
        /// </summary>
        /// <param name="sql">資料庫查詢SQL(本地sql)</param>
        /// <returns>int 操作訊息(>0成功，否則失敗)</returns>
        public int insertNativeSQLGetKey(string sql)
        {
            int recode = -1;
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            IDbConnection conn = session.Connection;
            IDbCommand cmd = conn.CreateCommand();
            try
            {
                //查詢SQL
                cmd.CommandText = sql;
                cmd.Connection = conn;
                cmd.ExecuteNonQuery();
                cmd.CommandText = "select  LAST_INSERT_ID()";
                cmd.CommandType = CommandType.Text;
                recode = int.Parse(cmd.ExecuteScalar().ToString());
            }
            finally
            {
                //關閉連結
                HibernateHelper.CloseSession();
            }
            //操作訊息
            return recode;
        }

        // <summary>
        /// 取得資料庫資料(本地sql)
        /// </summary>
        /// <param name="sql">資料庫查詢SQL(本地sql)</param>
        /// <returns>int 操作訊息(>0成功，否則失敗)</returns>
        public int updateNativeSQL(string sql)
        {
            int recode = -1;
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            IDbConnection conn = session.Connection;
            IDbCommand cmd = conn.CreateCommand();
            try
            {
                //查詢SQL
                cmd.CommandText = sql;
                cmd.Connection = conn;
                recode = cmd.ExecuteNonQuery();
            }
            finally
            {
                //關閉連結
                HibernateHelper.CloseSession();
            }
            //操作訊息
            return recode;
        }


        /// <summary>
        /// 取得excel資料
        /// </summary>
        /// <param name="filePath">路徑</param>
        public IList<Hashtable> getExcel(String filePath, int beginRow)
        {
            //初始化
            OleDbDataReader result = null;
            OleDbConnection conn = null;
            int index = 0;
            IList<Hashtable> list = new List<Hashtable>();
            try
            {
                //讀取Excel
                string strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=NO;IMEX=1\"";
                conn = new OleDbConnection(strConn);
                OleDbCommand myCommand = new OleDbCommand("SELECT * FROM [Sheet1$]", conn);
                conn.Open();
                result = myCommand.ExecuteReader(CommandBehavior.CloseConnection);
                //迭代
                while ( result.Read() )
                {
                    index++;
                    //從開始筆數取資料
                    if ( index >= beginRow )
                    {
                        Hashtable ht = new Hashtable();
                        for ( int i = 0; i < result.FieldCount; i++ )
                        {
                            ht.Add("F" + i, result.GetValue(i).ToString());
                        }
                        //加入資料
                        list.Add(ht);
                    }
                }
            }
            //捕捉例外
            catch ( Exception e )
            {
                log.Error("BaseSqlMapDao.getExcel.error :" + e.Message);
            }
            //關閉
            finally
            {
                //關閉result
                if ( result != null )
                    result.Close();
                //關閉conn
                if ( conn != null )
                    conn.Close();
            }
            //操作訊息
            return list;
        }


        /// <summary>
        /// 取得excel資料
        /// </summary>
        /// <param name="filePath">路徑</param>
        /// <returns>Hashtable:excel資料</returns>
        public Hashtable getExcel(String filePath)
        {
            //資料儲存形式: Hashtable<string:標籤頁名稱, List<HashTable>>
            Hashtable data = new Hashtable();

            OleDbDataReader result = null;
            OleDbConnection conn = null;
            try
            {
                string strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=NO;IMEX=1\"";
                conn = new OleDbConnection(strConn);
                conn.Open();
                DataTable dt = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[] { null, null, null, "TABLE" });
                //迭代所有標籤頁
                foreach (DataRow dr in dt.Rows)
                {
                    //標籤頁 名稱
                    String sheetName = dr["TABLE_NAME"].ToString();

                    OleDbCommand myCommand = new OleDbCommand("SELECT * FROM [" + sheetName + "]", conn);
                    result = myCommand.ExecuteReader(CommandBehavior.CloseConnection);

                    IList<Hashtable> sheetData = new List<Hashtable>();
                    //逐行讀取
                    for ( int line = 0; result.Read(); line++ )
                    {
                        Hashtable lineData = new Hashtable();
                        //逐列讀取
                        for ( int row = 0; row < result.FieldCount; row++ )
                        {
                            lineData.Add("F" + row, result.GetValue(row).ToString());
                        }
                        sheetData.Add(lineData);
                    }
                    data.Add(sheetName, sheetData);
                }
                return data;
            }
            //例外
            catch ( Exception e )
            {
                log.Error("BaseSqlMapDao.getExcel.error :" + e.Message);
                return null;
            }
            //關閉
            finally
            {
                if ( result != null )
                    result.Close();
                //關閉
                if ( conn != null )
                    conn.Close();
            }
        }
        
    }
}