using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Text.RegularExpressions;

namespace Barfoo.Library.Web
{
    public class IpUtility
    {
        /// <summary>
        /// 获取用户登录IP
        /// </summary>
        /// <returns></returns>
        public static string GetUserIP()
        {
            string userIP = string.Empty;
            try
            {
                userIP = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                //可能有代理
                if (!string.IsNullOrEmpty(userIP))
                {
                    //没有“.”肯定是非IPv4格式
                    if (userIP.IndexOf(".") == -1)
                    {
                        userIP = null;
                    }
                    else
                    {
                        if (userIP.IndexOf(",") != -1)
                        {
                            //有“,”，估计多个代理。取第一个不是内网的IP。 
                            userIP = userIP.Replace(" ", "").Replace("'", "");
                            string[] temparyip = userIP.Split(",;".ToCharArray());
                            for (int i = 0; i < temparyip.Length; i++)
                            {
                                //找到不是内网的地址
                                if (IsIPAddress(temparyip[i])
                                    && temparyip[i].Substring(0, 3) != "10."
                                    && temparyip[i].Substring(0, 7) != "192.168"
                                    && temparyip[i].Substring(0, 7) != "172.16.")
                                {
                                    return temparyip[i];
                                }
                            }
                        }
                        //代理即是IP格式
                        else if (IsIPAddress(userIP))
                            return userIP;
                        //代理中的内容 非IP，取IP
                        else
                            userIP = null;
                    }
                }

                if (string.IsNullOrEmpty(userIP))
                    userIP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];

                if (string.IsNullOrEmpty(userIP))
                    userIP = HttpContext.Current.Request.UserHostAddress;
            }
            catch { }
            return (IsIPAddress(userIP) ? userIP : string.Empty);
        }

        /// <summary>
        /// 判断是否是IP地址格式 0.0.0.0
        /// </summary>
        /// <param name="str1">待判断的IP地址</param>
        /// <returns>true or false</returns>
        public static bool IsIPAddress(string str1)
        {
            if (str1 == null || str1 == string.Empty || str1.Length < 7 || str1.Length > 15) return false;

            string regformat = @"^\d{1,3}[\.]\d{1,3}[\.]\d{1,3}[\.]\d{1,3}$";

            Regex regex = new Regex(regformat, RegexOptions.IgnoreCase);
            return regex.IsMatch(str1);
        }
    }
}
