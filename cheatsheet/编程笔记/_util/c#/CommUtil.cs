/**
 * <P> Title: PILI                      	</P>	
 * <P> Description: 公共工具類　　　      	</P>	
 * <P> Copyright: Copyright (c) 2009/07/03 	</P>	
 * <P> Company:Everunion Tech. Ltd.         </P>	
 * @author jackter
 * @version 0.1 Original Design from design document.	
*/
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

using System.Data;
using NHibernate;

namespace Com.Everunion.Util
{
    public class CommUtil
    {

        //log日誌
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(CommUtil));
        
        //存放各種單據的最新編號
        private static Hashtable _newInsertIdht = new Hashtable();


        /// <summary>
        /// 取得某實體類最新單號
        /// </summary>
        /// <typeparam name="T">實體類</typeparam>
        /// <param name="IdPro">Id屬性名</param>
        /// <param name="createdatePro">建檔日期屬性名</param>
        /// <param name="addType">子類型</param>
        /// <param name="addHQL">額外的HQL</param>
        /// <returns>最新單號</returns>
        /// <example><![CDATA[
        /// 有提供參數addHQL時,必須提供有效的(非null或零長字串)addType參數,否則addHQL視為無效
        /// string newid = CommUtil.GetNewInsertId<Check>("Id","Createdate","1","Type=1"); 
        /// ]]></example>
        public static string GetNewInsertId<T>(string IdPro, string createdatePro, string addType, string addHQL)
        {
            string key = typeof(T).Name;
            //子類
            if ( !String.IsNullOrEmpty(addType) )
            {
                key += "_" + addType;
            }
            else
            {
                addHQL = null;
            }

            //鎖定
            lock ( key )
            {

                //不含有該屬性值
                if ( !_newInsertIdht.ContainsKey(key) )
                {
                    _newInsertIdht.Add(key, null);
                }
                //取得參數值
                string _newInsertId = StringUtil.ToStr(_newInsertIdht[key]);

                //無值或最新編號不是目前日期
                if ( String.IsNullOrEmpty(_newInsertId) || !_newInsertId.Substring(0, 6).Equals(DateTime.Now.ToString("yyMMdd")) )
                {
                    _newInsertId = NewInsertId<T>(IdPro, createdatePro, addHQL);
                }
                //是目前日期
                else
                {
                    string newNumStr = StringUtil.ToStr(StringUtil.ToInt(_newInsertId.Substring(6)) + 1);
                    //組成新單號
                    _newInsertId = _newInsertId.Substring(0, 6).PadRight(_newInsertId.Length - newNumStr.Length, '0') + newNumStr;

                }

                //更新編號
                _newInsertIdht.Remove(key);
                _newInsertIdht.Add(key, _newInsertId);

                //返回最新單號
                return _newInsertId;
            }
        }



        /// <summary>
        /// 取得新增編號
        /// </summary>
        /// <typeparam name="T">實體類</typeparam>
        /// <param name="IdName">編號屬性名</param>
        /// <param name="createdateName">建檔日期屬性名</param>
        /// <param name="addHQL">額外HQL</param>
        /// <returns>最新的編號</returns>
        private static string NewInsertId<T>(string IdPro, string createdatePro, string addHQL)
        {
            //開啟連結
            ISession session = HibernateHelper.GetCurrentSession();
            string recode = DateTime.Now.ToString("yyMMdd");            
            try
            {
                StringBuilder hql = new StringBuilder();

                //hql
                hql.Append(" select max(a.").Append(IdPro).Append(") from ").Append(typeof(T).Name)
                    .Append(" a where a.").Append(createdatePro).Append("=:nowdate ");

                //補充倏件
                if ( !String.IsNullOrEmpty(addHQL) )
                {
                    hql.Append("and " + addHQL.Trim());
                }

                //取得最大序號
                string key = session.CreateQuery(hql.ToString())
                    .SetParameter("nowdate", DateTime.Now.ToString(@"yyyy\/MM\/dd"))
                    .SetMaxResults(1)
                    .UniqueResult<string>();


                //有單
                if ( !string.IsNullOrEmpty(key) )
                {
                    //加一
                    string newNumStr = StringUtil.ToStr(StringUtil.ToInt(key.Substring(6)) + 1);
                    //中間補零返回
                    recode = recode.PadRight(key.Length - newNumStr.Length,'0') + newNumStr;
                }
                //無單
                else
                {
                    recode += "0001";
                }
            }
            //拋出例外
            catch ( Exception e )
            {
                log.Error("CommUtil.cs取最大編號失敗! 可能是連結中斷! " + e.ToString());
                if ( recode.Length == 6 )
                    recode += "0001";
            }
            finally
            {
                //關閉
                HibernateHelper.CloseSession();
            }
            //操作訊息
            return recode;
        }        
    }
}