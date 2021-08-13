
/**
 * <P> Title: pili                      	</P>
 * <P> Description: 業務邏輯物件        	</P>
 * <P> Copyright: Copyright (c) 2009-06-26	</P>
 * <P> Company:Everunion Tech. Ltd.         </P>
 * @author ANDY
 * @version 0.9 Original Design from design document.	
*/
using System;
using System.Text.RegularExpressions;
using System.Data;
using System.Data.OleDb;
using System.Web;
using System.Collections.Generic;
using System.Collections;
using Com.Everunion.Util;
using Com.Everunion.Stock;
using Com.Everunion.Stock.Dao;
using NHibernate;
using Com.Everunion.File.Service;
using Com.Everunion.File;
using Com.Everunion.Purchase.Dao;
using Com.Everunion.Purchase;
using Com.Everunion.Purchase.Service;
using Com.Everunion.Config;
using Com.Everunion.Config.Dao;
using System.Configuration;

namespace Com.Everunion.Stock.Service
{
    /// <summary>
    ///	業務邏輯物件
    /// </summary>
    public sealed class TradeDetailService
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(TradeDetailService));
        private static TradeDetailService _instance = null;

        /// <summary>
        /// excel 匯入
        /// </summary>
        /// <param name="filePath">路徑</param>
        /// <param name="paramType">類型</param>
        public int ImportFromExcel(String filePath)
        {
            OleDbDataReader result = null;
            OleDbConnection conn = null;
            try
            {
               string strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath  + ";Extended Properties=\"Excel 8.0;HDR=NO;IMEX=1\"";
               conn = new OleDbConnection(strConn);              
               conn.Open();
               DataTable dt = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[] { null, null, null, "TABLE" });
               //迭代所有標籤頁
               foreach ( DataRow dr in dt.Rows )
               {
                   //標籤頁 名稱
                   String sheetName = dr["TABLE_NAME"].ToString();
                   log.Error("tableName :" + sheetName);//********************************

                   OleDbCommand myCommand = new OleDbCommand("SELECT * FROM [" + sheetName + "]", conn);
                   result = myCommand.ExecuteReader(CommandBehavior.CloseConnection);

                   //逐行讀取
                   for (int line = 0; result.Read(); line++)
                   {
                       Hashtable lineData = new Hashtable();
                       //逐列讀取
                       for (int row = 0; row < result.FieldCount; row++)
                       {
                           lineData.Add("F" + row, result.GetValue(row).ToString());
                           log.Error("result[" + line + "," + row + "] :" + result.GetValue(row).ToString());//********************************
                       }
                   }
               }
               return 1;
            }
            //例外
            catch (Exception e)
            {
                HibernateHelper.RollbackTransaction();
                log.Error("從 excel中導入失敗 :" + e.Message);
                HttpContext.Current.Items["Message"] = e.Message;
                return -1;
            }
            //關閉
            finally
            {
                HibernateHelper.CloseSession();
                if (result != null)
                    result.Close();
                //關閉
                if (conn != null)
                    conn.Close();
            }
        }


    }
}
