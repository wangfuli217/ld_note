/**
 * <P> Title: pops                      	</P>	
 * <P> Description: 資料訪問物件        	</P>	
 * <P> Copyright: Copyright (c) 2009-05-29	</P>	
 * <P> Company:Everunion Tech. Ltd.         </P>	
 * @author andy
 * @version 0.1 Original Design from design document.	
*/
using System;
using System.Collections.Generic;
using System.Text;
using NHibernate;
using NHibernate.Cfg;
using System.Web;
using System.IO;
using System.Web.Hosting;


namespace Com.Everunion.Util
{
    /// <summary>
    /// Hibernate連結工具類
    /// </summary>
    public class HibernateHelper
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(HibernateHelper));
        //系統HibernateHelper　const
        private const string CurrentSessionKey = "nhibernate.current_session";
        private const string CurrentTransactionKey = "nhibernate.current_transaction";
        private const string CurrentSessionAmount = "nhibernate.current_session_amount";
        private const string CurrentTransactionAmount = "nhibernate.current_transaction_amount";
        private const string RollbackTransactionFlag = "nhibernate.current_transaction_rollbackflag";        
        private static readonly ISessionFactory sessionFactory;

        /// <summary>
        /// 靜態構造函數
        /// </summary>
        static HibernateHelper()
        {
            sessionFactory = new Configuration()
                .SetDefaultAssembly(typeof(Com.Everunion.File.CustType).Assembly.FullName)
                .Configure()
                .BuildSessionFactory();
        }


        /// <summary>
        /// 取得資料庫方言
        /// </summary>
        public static NHibernate.Dialect.Dialect Dialect
        {
            get
            {
                //傳回
                return sessionFactory.Dialect;
            }
        }


        /// <summary>
        /// 取本地Session
        /// </summary>
        /// <returns>Session</returns>
        private static ISession LocalSession()
        {
            HttpContext context = HttpContext.Current;
            if ( context == null )
                new Exception("請求不能使用 HttpContext");
            //取得
            ISession currentSession = context.Items[CurrentSessionKey] as ISession;
            if ( currentSession == null )
                new Exception("沒有可用的 Session");
            return currentSession;
        }


        /// <summary>
        /// 取本地事務
        /// </summary>
        /// <returns>事務</returns>
        private static ITransaction LocalTransaction()
        {
            HttpContext context = HttpContext.Current;
            if ( context == null )
                new Exception("請求不能使用 HttpContext");
            //取得
            ITransaction currentTransaction = context.Items[CurrentTransactionKey] as ITransaction;
            if ( currentTransaction == null )
                new Exception("沒有可用的 ITransaction");
            return currentTransaction;
        }


        /// <summary>
        /// 取Session
        /// </summary>
        /// <returns>Session</returns>
        public static ISession GetCurrentSession()
        {
            HttpContext context = HttpContext.Current;
            if ( context == null )
                new Exception("請求不能使用 HttpContext");
            ISession currentSession = context.Items[CurrentSessionKey] as ISession;
            //第一次
            if ( currentSession == null )
            {
                currentSession = sessionFactory.OpenSession();
                context.Items[CurrentSessionKey] = currentSession;
                context.Items[CurrentSessionAmount] = 1;
            }
            else
            {
                //SessionAmount
                context.Items[CurrentSessionAmount] = 
                StringUtil.ToInt(context.Items[CurrentSessionAmount]) + 1;
            }
            //未開啟
            if ( !currentSession.IsConnected || !currentSession.IsOpen )
            {
                currentSession.Reconnect();
            }
            return currentSession;
        }


        /// <summary>
        /// 取Session
        /// </summary>
        /// <returns>Session</returns>
        public static IStatelessSession OpenStatelessSession()
        {
            return sessionFactory.OpenStatelessSession();             
        }


        /// <summary>
        /// 關閉Session
        /// </summary>
        /// <param name="sureClose">是否強制執行</param>
        public static void CloseSession(bool sureClose)
        {
            HttpContext context = HttpContext.Current;
            if ( context == null )
                new Exception("請求不能使用 HttpContext");
            ISession currentSession = context.Items[CurrentSessionKey] as ISession;
            //不存在
            if ( currentSession == null )
            {
                log.Warn("呼叫CloseSession()時，HttpContext中沒有可用的Session");
                return;
            }
            else
            {
                //關閉
                if ( StringUtil.ToInt(context.Items[CurrentSessionAmount]) == 1 || sureClose )
                {
                    currentSession.Close();
                    context.Items.Remove(CurrentSessionKey);
                    context.Items.Remove(CurrentTransactionKey);
                    //日志
                    if ( StringUtil.ToInt(HttpContext.Current.Items[CurrentSessionAmount]) > 1 )
                        log.Warn("強制關閉Session時存在" + 
                        (StringUtil.ToInt(HttpContext.Current.Items[CurrentSessionAmount]) - 1)
                         + "層Session未處理！");
                    if ( StringUtil.ToInt(HttpContext.Current.Items[CurrentTransactionAmount]) > 0 )
                        log.Error("關閉Session時存在" + HttpContext.Current.Items[CurrentTransactionAmount] 
                        + "個事務層次未處理！");
                    //移除計數器
                    context.Items.Remove(CurrentSessionAmount);
                    context.Items.Remove(CurrentTransactionAmount);
                }
                //開啟數減一
                else
                {
                    context.Items[CurrentSessionAmount] = StringUtil.ToInt(context.Items[CurrentSessionAmount]) - 1;
                }
            }
        }


        /// <summary>
        /// 關閉Session
        /// </summary>
        public static void CloseSession()
        {
            CloseSession(false);
        }


        /// <summary>
        /// 開啟Transaction
        /// </summary>
        /// <returns>事務</returns>
        public static ITransaction BeginTransaction()
        {
            ITransaction currentTransaction = HttpContext.Current.Items[CurrentTransactionKey] as ITransaction;
            //開啟新Transaction
            if ( currentTransaction == null || currentTransaction.WasRolledBack || currentTransaction.WasCommitted )
            {
                currentTransaction = LocalSession().BeginTransaction();
                HttpContext.Current.Items[CurrentTransactionKey] = currentTransaction;
                HttpContext.Current.Items[CurrentTransactionAmount] = 1;
            }
            //傳回已有Transaction
            else
            {
                HttpContext.Current.Items[CurrentTransactionAmount] = 
                StringUtil.ToInt(HttpContext.Current.Items[CurrentTransactionAmount]) + 1;
            }
            return currentTransaction;
        }


        /// <summary>
        /// Commit事務
        /// </summary>
        /// <param name="sureCommit">是否強制執行</param>
        public static void CommitTransaction(bool sureCommit)
        {
            ITransaction tx = LocalTransaction();
            //Commit
            if ( StringUtil.ToInt(HttpContext.Current.Items[CurrentTransactionAmount]) == 1 || sureCommit )
            {
                if ( "true".Equals(HttpContext.Current.Items[RollbackTransactionFlag]) )
                    log.Warn("請注意!標志為Rollback的事物被Commit了");
                tx.Commit();
                if ( StringUtil.ToInt(HttpContext.Current.Items[CurrentTransactionAmount]) > 1 )
                    log.Warn("強制提交CommitTransaction時存在" + 
                    (StringUtil.ToInt(HttpContext.Current.Items[CurrentTransactionAmount]) - 1) 
                    + "個事務層次未處理！");
                //移除
                HttpContext.Current.Items.Remove(CurrentTransactionAmount);
                HttpContext.Current.Items.Remove(CurrentTransactionKey);
            }
            //存在上層
            else
            {
                HttpContext.Current.Items[CurrentTransactionAmount] = 
                StringUtil.ToInt(HttpContext.Current.Items[CurrentTransactionAmount]) - 1;
            }
        }


        /// <summary>
        /// Commit事務
        /// </summary>
        public static void CommitTransaction()
        {
            CommitTransaction(false);
        }


        /// <summary>
        ///  Rollback事務
        /// </summary>
        public static void RollbackTransaction()
        {
            RollbackTransaction(false);
        }


        /// <summary>
        /// Rollback事務
        /// </summary>
        /// <param name="sureRollback">是否強制執行</param>
        public static void RollbackTransaction(bool sureRollback)
        {
            ITransaction tx = LocalTransaction();
            if ( !"true".Equals(HttpContext.Current.Items[RollbackTransactionFlag]) )
                HttpContext.Current.Items[RollbackTransactionFlag] = "true";
            //Rollback
            if ( StringUtil.ToInt(HttpContext.Current.Items[CurrentTransactionAmount]) == 1 || sureRollback )
            {
                tx.Rollback();
                if ( StringUtil.ToInt(HttpContext.Current.Items[CurrentTransactionAmount]) > 1 )
                    log.Warn("強制RollbackTransaction時存在" + (StringUtil.ToInt(HttpContext.Current.Items[CurrentTransactionAmount]) - 1)
                     + "個事務層次未處理！");
                //移除
                HttpContext.Current.Items.Remove(CurrentTransactionAmount);
                HttpContext.Current.Items.Remove(CurrentTransactionKey);
            }
            //存在上層
            else
            {
                HttpContext.Current.Items[CurrentTransactionAmount] = 
                StringUtil.ToInt(HttpContext.Current.Items[CurrentTransactionAmount]) - 1;
            }
        }


        /// <summary>
        /// 關閉SessionFactory
        /// </summary>
        public static void CloseSessionFactory()
        {
            if ( sessionFactory != null )
            {
                sessionFactory.Close();
            }
        }
    }
}
