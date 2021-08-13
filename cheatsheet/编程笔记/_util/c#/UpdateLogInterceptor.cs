//2009/05/30　andy 添加新增，修改刪除SQLCommand日志 18-84
//v0.1
using System;
using System.Collections;
using NHibernate.SqlCommand;
using NHibernate.Type;
using NHibernate;
using System.Text;
using System.Text.RegularExpressions;

namespace Com.Everunion.Util
{
   /// <summary>
   /// 日志攔截器
   /// </summary>
    public class UpdateLogInterceptor :IInterceptor
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(UpdateLogInterceptor));
        //2009/05/30 andy start 添加新增，修改刪除SQLCommand日志
        /// <summary>
        /// 顯示物件資料
        /// </summary>
        /// <param name="state">值</param>
        /// <param name="propertyNames">屬性</param>
        /// <param name="types">類型</param>
        /// <returns>屬性\[類型,值\]*</returns>
        private string ShowValue(object[] state, string[] propertyNames, IType[] types)
        {
            StringBuilder sb = new StringBuilder();            
            if ( propertyNames != null )
            {
                //屬性資料
                for ( int index = 0; index < propertyNames.Length; index++ )
                {
                    sb.Append((index > 0 ? "," : "") + propertyNames[index] + "[" + types[index].Name + "," + state[index] + "]");
                }
            }
            //傳回
            return sb.ToString();
        }

        /// <summary>
        /// 刪除操作
        /// </summary>
        /// <param name="entity">物件</param>
        /// <param name="id">系統ID</param>
        /// <param name="state">值</param>
        /// <param name="propertyNames">屬性</param>
        /// <param name="types">類型</param>
        public  void OnDelete(object entity, object id, object[] state, string[] propertyNames, IType[] types)
        {
            log.Info("刪除物件:" + entity + ",id:"　+　 id+" .\t　屬性：" + ShowValue(state, propertyNames, types));
        }

       
        /// <summary>
        /// 新增物件
        /// </summary>
        /// <param name="entity">物件</param>
        /// <param name="id">系統ID</param>
        /// <param name="state">值</param>
        /// <param name="propertyNames">屬性</param>
        /// <param name="types">類型</param>
        /// <returns>false</returns>
        public  bool OnSave(object entity, object id, object[] state, string[] propertyNames, IType[] types)
        {
            //列印
            log.Info("新增物件:" + entity + "\t　屬性：" + ShowValue(state, propertyNames, types));
            return false;
        }


        /// <summary>
        /// PrepareStatement
        /// </summary>
        /// <param name="sql">sqlcommand</param>
        /// <returns>sqlcommand</returns>
        public SqlString OnPrepareStatement(SqlString sql)
        {
            //只顯示INSERT|UPDATE|DELETE類型的操作
            if ( Regex.Match(sql.ToString(), @"^\s*(INSERT|UPDATE|DELETE)\s+", RegexOptions.IgnoreCase).Success )
                log.Info("sql: " + sql.ToString());
            return sql;
        }
        //2009/05/30 andy end 


        public bool OnFlushDirty(object entity, object id, object[] currentState, object[] previousState,
                                        string[] propertyNames, IType[] types)
        {
            return false;
        }

        public bool OnLoad(object entity, object id, object[] state, string[] propertyNames, IType[] types)
        {
            return false;
        }


        public  void PostFlush(ICollection entities)
        {
        }

        public  void PreFlush(ICollection entitites)
        {
        }

        public  bool? IsTransient(object entity)
        {
            return null;
        }

        public  object Instantiate(string clazz, EntityMode entityMode, object id)
        {
            return null;
        }

        public  string GetEntityName(object entity)
        {
            return null;
        }

        public  object GetEntity(string entityName, object id)
        {
            return null;
        }

        public  int[] FindDirty(object entity, object id, object[] currentState, object[] previousState,
                                       string[] propertyNames, IType[] types)
        {
            return null;
        }

        public  void AfterTransactionBegin(ITransaction tx)
        {
        }

        public  void BeforeTransactionCompletion(ITransaction tx)
        {
        }

        public  void AfterTransactionCompletion(ITransaction tx)
        {
        }

        public  void SetSession(ISession session)
        {
        }
        public void OnCollectionRecreate(object collection, object key)
        {
        }

        public void OnCollectionRemove(object collection, object key)
        {
        }

        public void OnCollectionUpdate(object collection, object key)
        {
        }
    }
}
