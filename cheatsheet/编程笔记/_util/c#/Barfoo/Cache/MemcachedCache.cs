/*
版权所有：  邦富软件版权所有(C)
系统名称：  舆情系统
模块名称：  缓存管理类(MemcachedCache)
创建日期：  2012-2-8
作者：      刘付春彬
内容摘要： 
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BeIT.MemCached;
namespace Barfoo.Library.Cache
{
    public class MemcachedCache
    {
        /// <summary>
        ///内存数据库
        /// </summary>
        private static Dictionary<string, MemcachedClient> _mCaches = new Dictionary<string, MemcachedClient>();
        /// <summary>
        /// 
        /// </summary>
        static string ip = Barfoo.Library.Configuration.ConfigurationUtility.AppSettings<string>("MemcachedIp", "124.172.232.46:8041");
        /// <summary>
        /// 
        /// </summary>
        //static string ip2 = Barfoo.Library.Configuration.ConfigurationUtility.AppSettings<string>("MemcachedIp2", "124.172.232.48:8041");

        private static MemcachedClient GetService(string dbName)
        {
            if (_mCaches.ContainsKey(dbName) && _mCaches[dbName] != null)
            {
                return _mCaches[dbName];
            }
            var ips = new string[] { ip };
            /*
            if (!string.IsNullOrEmpty(ip2))
            {
                ips = new string[] { ip, ip2 };
            }*/
            MemcachedClient.Setup(dbName, ips);
            var _mCache = MemcachedClient.GetInstance(dbName);

            _mCache.SendReceiveTimeout = 5000;
            _mCache.ConnectTimeout = 5000;
            _mCache.MinPoolSize = 1;
            _mCache.MaxPoolSize = 100;
            if (!_mCaches.ContainsKey(dbName))
                _mCaches[dbName] = _mCache;
            return _mCache;
        }

        /// <summary>
        /// 获取
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static object Get(string dbName, string key)
        {
            try
            {
                return GetService(dbName).Get(key);
            }
            catch { }
            return null;
        }
        /// <summary>
        /// 获取
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static object Get(string dbName, string key, TimeOutType timeOutType, int timeOut)
        {
            try
            {
                var obj = GetService(dbName).Get(key);
                if (timeOutType == TimeOutType.Absolute && obj != null)
                {
                    Set(dbName, key, obj, timeOut);
                }
                return obj;
            }
            catch { }
            return null;
        }

        public static void Set(string dbName, string key, object value, int timeOut, TimeOutType timeOutType)
        {
            Set(dbName, key, value, timeOut);
        }


        /// <summary>
        /// 设置
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool Set(string dbName, string key, object value)
        {
            try
            {
                return GetService(dbName).Set(key, value);
            }
            catch (Exception ex) { Console.WriteLine(ex.Message); }
            return false;
        }
        /// <summary>
        /// 设置
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <param name="second">秒</param>
        /// <returns></returns>
        public static bool Set(string dbName, string key, object value, int second)
        {
            try
            {
                return GetService(dbName).Set(key, value, DateTime.Now.AddSeconds(second));
            }
            catch (Exception ex) { Console.WriteLine(ex.Message); }
            return false;
        }

        // RemoveCache 未经测试
        /// <summary>
        /// 清除缓存
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static bool RemoveCache(string dbName, string key)
        {
            try
            {
                return GetService(dbName).Delete(key);
            }
            catch (Exception ex) { Console.WriteLine(ex.Message); }
            return false;
        }

    }
}
