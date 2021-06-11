/*
版权所有：  邦富软件版权所有(C)
系统名称：  舆情系统
模块名称：  缓存管理类(SessionCache)
创建日期：  2012-2-8
作者：      刘付春彬
内容摘要： 
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace Barfoo.Library.Cache
{
    public class SessionCache
    {  /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static object Get(string key)
        {
          return  HttpContext.Current.Session[key];
        }
      
        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        public static void Set(string key, object value)
        {
            HttpContext.Current.Session[key] = value;
        }

        /// <summary>
        /// 清除缓存
        /// </summary>
        /// <param name="key">要从会话状态集合中删除的项的名称</param>
        public static void Remove(string key)
        {
            HttpContext.Current.Session.Remove(key);
        }

    }
}
