/**
 * <P> Title: 産生資料                       </P>
 * <P> Description: 操作Access               </P>
 * <P> Copyright: Copyright (c) 2010-07-14   </P>
 * <P> Company:Everunion Tech. Ltd.          </P>
 * @author Holer
 * @version 0.1 Original Design from design document.
 */
using System;
using System.Collections.Generic;
using System.Text;
using System.Data.OleDb;
using System.Data;
using System.Collections;
using System.Runtime.InteropServices;
using System.IO;
using System.Threading;


namespace Com.Everunion.Util
{
    class AccessDao
    {
        /// <summary>
        /// 檔案路徑
        /// </summary>
        private string mdbPath = "";

        /// <summary>
        /// 連結訊息
        /// </summary>
        private string strConn = "";

        /// <summary>
        /// 連結
        /// </summary>
        OleDbConnection oledb = null;


        /// <summary>
        /// 构造函數
        /// </summary>
        /// <param name="mdbPath">檔案路徑(如果檔案已經存在,則保留舊檔案)</param>
        public AccessDao(string mdbPath) : this( mdbPath, false )
        {
        }


        /// <summary>
        /// 构造函數
        /// </summary>
        /// <param name="mdbPath">檔案路徑</param>
        /// <param name="deleteWhenExists">如果檔案已經存在,是否刪除舊檔案</param>
        public AccessDao(string mdbPath, bool deleteWhenExists)
        {
            this.mdbPath = mdbPath + ".mdb";
            this.strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + this.mdbPath + ";Jet OLEDB:Engine Type=5";

            //如果已存在檔案
            if ( File.Exists(this.mdbPath) )
            {
                //刪除
                if ( deleteWhenExists )
                {
                    File.Delete(this.mdbPath);
                }
                //不刪除
                else
                {
                    return;
                }
            }

            //新增資料檔案
            ADOX.CatalogClass cat = new ADOX.CatalogClass();
            cat.Create(this.strConn);
            //釋放資源
            Marshal.ReleaseComObject(cat);
            cat = null;
        }


        /// <summary>
        /// 取得連結
        /// </summary>
        /// <returns>OleDbConnection 連結</returns>
        public OleDbConnection getConn()
        {
            if (this.oledb != null)
                return this.oledb;
            try
            {
                //引用OleDbConnection
                this.oledb = new OleDbConnection(strConn);
                this.oledb.Open();
            }
            catch
            {
            }
            //操作訊息
            return this.oledb;
        }


        /// <summary>
        /// 釋放資源
        /// <summary>
        /// <param name="oledb">OleDbConnection 連結</param>
        public void Close(OleDbConnection oledb)
        {
            if ( oledb != null )
            {
                oledb.Close();
            }
        }


        /// <summary>
        /// 釋放資源
        /// <summary>
        /// <param name="dataReader">OleDbCommand 連結</param>
        public void Close(OleDbCommand cmd)
        {
            if (cmd != null)
            {
                cmd = null;
            }
        }


        /// <summary>
        /// 釋放資源
        /// <summary>
        /// <param name="dataReader">OleDbDataReader 連結</param>
        public void Close(OleDbDataReader dataReader)
        {
            if ( dataReader != null )
            {
                dataReader.Close();
            }
        }


        /// <summary>
        /// 釋放資源
        /// <summary>
        /// <param name="dataReader">OleDbDataReader 連結</param>
        public void Close(OleDbConnection oledb, OleDbCommand cmd, OleDbDataReader dataReader)
        {
            //釋放資源
            Close(dataReader);
            Close(cmd);

            /// ******** 為了提高效率,以下的暫時不執行 ************
            //Close(oledb);

            // 垃圾回收
            //GC.WaitForPendingFinalizers();
            //GC.Collect();
        }


        /// <summary>
        /// 新增table, 欄位都是字串類型的(2000字節)
        /// </summary>
        /// <param name="tableName">表名稱</param>
        /// <param name="list">欄位名稱集合</param>
        /// <param name="needID">是否創建自動增長的主鍵(名稱為oid)</param>
        /// <returns>bool:操作訊息(true:成功,false:失敗)</returns>
        public bool CreateTable(string tableName, List<string> list, bool needID)
        {
            //初始化
            bool recode = false;
            ADOX.CatalogClass cat = null;
            ADOX.TableClass table = null;
            try
            {
                // 資料檔案
                cat = new ADOX.CatalogClass();
                //引用Connection
                ADODB.Connection cn = new ADODB.Connection();
                cn.Open(strConn, null, null, -1);
                cat.ActiveConnection = cn;

                // 新增表
                table = new ADOX.TableClass();
                table.ParentCatalog = cat;
                table.Name = tableName;

                if (needID)
                {
                    //先增加一個自動增長的欄位
                    ADOX.ColumnClass id_col = new ADOX.ColumnClass();
                    id_col.ParentCatalog = cat;
                    //設置欄位類型
                    id_col.Type = ADOX.DataTypeEnum.adInteger;
                    //這欄位名稱設為“oid”
                    id_col.Name = "oid";
                    id_col.Properties["Jet OLEDB:Allow Zero Length"].Value = false;
                    id_col.Properties["AutoIncrement"].Value = true;
                    //表裡面增加一個字段
                    table.Columns.Append(id_col, ADOX.DataTypeEnum.adInteger, 0);
                    //釋放資源
                    if (id_col != null)
                    {
                        Marshal.ReleaseComObject(id_col);
                        id_col = null;
                    }
                }
                
                //逐個加入欄位,但都是字串類型的
                foreach (String key in list)
                {
                    //初始化
                    ADOX.ColumnClass col = new ADOX.ColumnClass();
                    col.ParentCatalog = cat;
                    col.Name = key;
                    col.Properties["Jet OLEDB:Allow Zero Length"].Value = true;
                    table.Columns.Append(col, ADOX.DataTypeEnum.adLongVarChar, 2000);
                    //釋放資源
                    if (col != null)
                    {
                        Marshal.ReleaseComObject(col);
                        col = null;
                    }
                }

                // 添加表
                cat.Tables.Append(table);
                recode = true;
            }
            //捕捉例外
            catch
            {
            }
            finally
            {
                //釋放資源
                if (table != null)
                {
                    Marshal.ReleaseComObject(table);
                    //清空
                    table = null;
                }
                //釋放資源
                if (cat != null)
                {
                    Marshal.ReleaseComObject(cat);
                    cat = null;
                }
                // 垃圾回收
                GC.WaitForPendingFinalizers();
                GC.Collect();
            }
            //操作訊息
            return recode;
        }


        /// <summary>
        /// 新增table, 欄位都是字串類型的(2000字節)
        /// </summary>
        /// <param name="tableName">表名稱</param>
        /// <param name="list">欄位名稱集合(會增加一個自動增長的主鍵,名稱為oid)</param>
        /// <returns>bool:操作訊息(true:成功,false:失敗)</returns>
        public bool CreateTable(string tableName, List<string> list)
        {
            return CreateTable( tableName, list, true );
        }


        /// <summary>
        /// 資料庫操作
        /// </summary>
        /// <param name="list">沒有資料傳回的資料庫操作SQL(如:新增,修改,修改等)</param>
        /// <returns>bool:操作訊息(true:成功,false:失敗)</returns>
        public bool excute(List<string> SQL_list)
        {
            //初始化
            bool recode = false;
            OleDbConnection oledb = null;
            OleDbCommand cmd = null;
            try
            {
                //開啟鎖定
                Monitor.Enter(this);
                //取得連結
                oledb = getConn();
                cmd = oledb.CreateCommand();
                //資料庫操作
                foreach (string sql in SQL_list)
                {
                    cmd.CommandText = sql;
                    cmd.ExecuteNonQuery();
                    //操作訊息
                    recode = true;
                }
            }
            catch
            {
                recode = false;
            }
            finally
            {
                //釋放鎖定
                Monitor.Exit(this);
                //釋放資源
                Close(oledb, cmd, null);
            }
            //操作訊息
            return recode;
        }


        /// <summary>
        /// 資料庫操作
        /// </summary>
        /// <param name="SQL">沒有資料傳回的資料庫操作SQL(如:新增,修改,修改等)</param>
        /// <returns>bool:操作訊息(true:成功,false:失敗)</returns>
        public bool excute(string SQL)
        {
            OleDbConnection oledb = null;
            OleDbCommand cmd = null;
            try
            {
                //開啟鎖定
                Monitor.Enter(this);
                //取得連結
                oledb = getConn();
                cmd = new OleDbCommand(SQL, oledb);
                cmd.ExecuteNonQuery();
                return true;
            }
            catch
            {
                return false;
            }
            finally
            {
                //釋放鎖定
                Monitor.Exit(this);
                //釋放資源
                Close(oledb, cmd, null);
            }
        }


        /// <summary>
        /// 資料庫讀取
        /// </summary>
        /// <param name="SQL">資料庫讀取SQL</param>
        /// <returns>List:結果集</returns>
        public List<Hashtable> select(string SQL)
        {
            List<Hashtable> list = new List<Hashtable>();
            OleDbConnection oledb = null;
            OleDbCommand cmd = null;
            OleDbDataReader dataReader = null;
            try
            {
                //開啟鎖定
                Monitor.Enter(this);
                //取得連結
                oledb = getConn();
                cmd = new OleDbCommand(SQL, oledb);
                dataReader = cmd.ExecuteReader();
                //讀取資料
                while ( dataReader.Read() )
                {
                    Hashtable ht = new Hashtable();
                    for (int i = 0; i < dataReader.FieldCount; i++)
                    {
                        ht.Add(dataReader.GetName(i), dataReader.GetValue(i).ToString());
                    }
                    //加入資料
                    list.Add(ht);
                }
            }
            finally
            {
                //釋放鎖定
                Monitor.Exit(this);
                //釋放資源
                Close(oledb, cmd, dataReader);
            }
            return list;
        }


    }
}
