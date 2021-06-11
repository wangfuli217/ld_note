/*
版权所有：  邦富软件版权所有(C)
系统名称：  舆情系统
模块名称：  缓存管理类(RunTimeCache)
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
    public class RunTimeCache
    {

        public static object Get(string key)
        {
            return HttpRuntime.Cache[key];
           // return obj == null ? default(T) : (T)Convert.ChangeType(obj, typeof(T));
        }
     
        public static void Set(string key, object value, int timeOut, TimeOutType timeOutType)
        {
            if (timeOutType == TimeOutType.Absolute)
                SetAbsoluteExpiration(key, value, timeOut);
            else
                SetSlidingExpiration(key, value, timeOut);
        }

        /// <summary>
        /// 清除缓存
        /// </summary>
        /// <param name="key"></param>
        public static void RemoveCache(string key)
        {
            HttpRuntime.Cache.Remove(key);
        }

        /// <summary>
        /// 绝对过期
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        public static void SetSlidingExpiration(string key, object value, double timeOut)
        {
            HttpRuntime.Cache.Insert(key, value, null, System.DateTime.Now.AddSeconds(timeOut), System.Web.Caching.Cache.NoSlidingExpiration
                , System.Web.Caching.CacheItemPriority.Default,
              null);
        }
        /// <summary>
        /// 相对过期 timeOut(秒)
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        public static void SetAbsoluteExpiration(string key, object value, double timeOut)
        {
            HttpRuntime.Cache.Insert(key, value, null,
                System.Web.Caching.Cache.NoAbsoluteExpiration,
                TimeSpan.FromSeconds(timeOut));
        }
    }
}
