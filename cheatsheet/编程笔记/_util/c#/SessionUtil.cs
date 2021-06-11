
using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.SessionState;
using Com.Everunion.Config;
using Com.Everunion.Config.Service;
using Com.Everunion.User;

namespace Com.Everunion.Util
{
    public class SessionUtil
    {
        //log
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(SessionUtil));


        /// <summary>
        /// 取人員編號
        /// </summary>
        /// <param name="Session">HTTP伺服器會話</param>
        /// <returns>人員編號</returns>
        public static String GetMemId(HttpSessionState session)
        {
            Member member = GetMember(session);
            if (member == null)
            {
                return null;
            }
            else
            {
                return member.Id;
            }
        }


        /// <summary>
        /// 取人員編號
        /// </summary>
        /// <returns>人員編號</returns>
        public static String GetMemId()
        {
            return GetMemId(HttpContext.Current.Session);
        }


        /// <summary>
        /// 取登錄人
        /// </summary>
        /// <param name="Session">HTTP伺服器會話</param>
        /// <returns>人員</returns>
        private static Member GetMember(HttpSessionState session)
        {
            Member member = session["Member"] as Member;
            if ( member != null )
            {
                return member;
            }
            //例外
            else
            {
                return null;
            }
        }


        /// <summary>
        /// 取登錄人
        /// </summary>
        /// <param name="Session">HTTP伺服器會話</param>
        /// <returns>人員</returns>
        public static Member GetMember()
        {
            return GetMember(HttpContext.Current.Session);
        }


        /// <summary>
        /// 是否經銷商
        /// </summary>
        /// <param name="Session">HTTP伺服器會話</param>
        /// <returns>是否經銷商</returns>
        public static bool IsSeller(HttpSessionState session)
        {
            Member member = GetMember(session);
            if (member == null)
            {
                return true;
            }
            else
            {
                return member.Company.Name.IndexOf("台文") == -1;
            }            
        }


        /// <summary>
        /// 是否經銷商
        /// </summary>
        /// <returns>是否經銷商</returns>
        public static bool IsSeller()
        {
            return IsSeller(HttpContext.Current.Session);
        }

        /// <summary>
        /// 取登錄人姓名
        /// </summary>
        /// <param name="Session">HTTP伺服器會話</param>
        /// <returns>登錄人姓名</returns>
        public static string GetMemName(HttpSessionState session)
        {
            Member member = GetMember(session);
            if (member == null)
            {
                return null;
            }
            else
            {
                return member.Name;
            }              
        }


        /// <summary>
        /// 取登錄人姓名
        /// </summary>
        /// <returns>登錄人姓名</returns>
        public static string GetMemName()
        {
            return GetMemName(HttpContext.Current.Session);
        }
       

        /// <summary>
        /// 移除使用者
        /// </summary>
        /// <param name="session">HTTP伺服器會話</param>
        public static void RemoveMember(HttpSessionState session)
        {
            session.Remove("Member");
        }


        /// <summary>
        /// 驗證碼
        /// </summary>
        /// <param name="Context">HTTP伺服器頁面上下文</param>
        /// <returns>驗證碼正確傳回true</returns>
        public static bool ValidateCode(HttpContext Context)
        {
            //Session中的驗證碼
            string sess_Code = StringUtil.ToStr(Context.Session["validateCode"]);
            //驗證一次后就失效
            Context.Session.Remove("validateCode");
            string requ_Code = Context.Request.Form["ValidateCode"];
            return StringUtil.Requied(sess_Code) && sess_Code.Equals(requ_Code);
        }

        /// <summary>
        /// 取登錄人
        /// </summary>
        /// <param name="Session">HTTP伺服器會話</param>
        /// <returns>人員</returns>
        public static Com.Everunion.User.User getWebUser()
        {
            return getWebUser(HttpContext.Current.Session);
        }

        /// <summary>
        /// 取登錄人
        /// </summary>
        /// <param name="Session">HTTP伺服器會話</param>
        /// <returns>人員</returns>
        public static Com.Everunion.User.User getWebUser(HttpSessionState session)
        {
            Com.Everunion.User.User user = session["webuser"] as Com.Everunion.User.User;
            if (user != null)
            {
                return user;
            }
            else
            {
                return null;
            }
        }

    }
}
