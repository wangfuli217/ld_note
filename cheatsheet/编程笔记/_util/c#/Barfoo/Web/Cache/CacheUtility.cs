/*
版权所有：  邦富软件版权所有(C)
系统名称：  邦富基础类库
模块名称：  缓存管理
创建日期：  2010-8-6
作者：      刘付春彬
内容摘要： 
*/

using System;
using System.Web;


namespace Barfoo.Library.Web.Cache
{
    #region Cache 缓存管理类

    public class CacheCache<T> where T : class
    {
        public static T GetCache(string key)
        {
            T t = HttpRuntime.Cache[key] as T;
            return t;
        }

        public static void RemoveCache(string key)
        {
            HttpRuntime.Cache.Remove(key);
        }
        /// <summary>
        /// 绝对过期
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        public static void SetSlidingExpiration(string key, T value, double timeOut)
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
        public static void SetAbsoluteExpiration(string key, T value, double timeOut)
        {
            HttpRuntime.Cache.Insert(key, value, null,
                System.Web.Caching.Cache.NoAbsoluteExpiration,
                TimeSpan.FromSeconds(timeOut));
        }
    }
    #endregion
}
