
/*
版权所有：  邦富软件版权所有(C)
系统名称：  舆情系统
模块名称：  缓存管理类
创建日期：  2012-2-8
作者：      刘付春彬
内容摘要： 
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using ServiceStack.Redis;
using Barfoo.Library.Data;

namespace Barfoo.Library.Cache
{
    public class CacheHelper
    {

        public CacheHelper()
        {
            cacheType = CacheType.Cache;
            timeOutType = TimeOutType.Absolute;
            TimeOut = 60 * 10;
        }

        /// <summary>
        /// 
        /// </summary>
        public string Key { get; set; }

        /// <summary>
        /// 缓存类型
        /// </summary>
        public CacheType cacheType { get; set; }

        /// <summary>
        /// 超时时间(秒)
        /// </summary>
        public int TimeOut { get; set; }

        /// <summary>
        /// 过期类型
        /// </summary>
        public TimeOutType timeOutType { get; set; }

        /// <summary>
        /// redis 连接
        /// </summary>
        private RedisClient redis { get; set; }

        /// <summary>
        /// 数据库名称, CacheType.File 时则是路径
        /// </summary>
        private string _databaseOrPath;
        public string DatabaseOrPath
        {
            get
            {
                if (!string.IsNullOrEmpty(_databaseOrPath)) return _databaseOrPath;
                switch (this.cacheType)
                {
                    case CacheType.Memcached: return "CacheHelperDb";
                    case CacheType.File: return "~/TempFiles/CacheFile/" + Key + ".txt";
                    default: return null;
                }
            }
            set { _databaseOrPath = value; }
        }

        /// <summary>
        /// 设值
        /// </summary>
        /// <param name="value"></param>
        public void Set(object value)
        {
            if (string.IsNullOrEmpty(Key)) return;
            switch (this.cacheType)
            {
                case CacheType.Cache:
                    RunTimeCache.Set(Key, value, TimeOut, this.timeOutType);
                    break;
                case CacheType.Memcached:
                    MemcachedCache.Set(this.DatabaseOrPath, Key, value, TimeOut, this.timeOutType);
                    break;
                case CacheType.File:
                    var filename = Barfoo.Library.IO.PathUtility.GetPhysicalPath(this.DatabaseOrPath);
                    FileCache.Set(filename, value);
                    break;
                case CacheType.Session:
                    SessionCache.Set(Key, value);
                    break;
                case CacheType.Redis:
                    if (redis == null) redis = RedisHelp.GetConnection();
                    redis.Set(Key, value);
                    break;
            }
        }

        /// <summary>
        /// 获取缓存的值
        /// </summary>
        /// <returns></returns>
        public object Get()
        {
            if (string.IsNullOrEmpty(Key)) return null;
            switch (this.cacheType)
            {
                case CacheType.Cache:
                    return RunTimeCache.Get(Key);
                case CacheType.Memcached:
                    return MemcachedCache.Get(this.DatabaseOrPath, Key, timeOutType, TimeOut);
                case CacheType.File:
                    var filename = Barfoo.Library.IO.PathUtility.GetPhysicalPath(this.DatabaseOrPath);
                    return FileCache.Get(filename, TimeOut);
                case CacheType.Session:
                    return SessionCache.Get(Key);
                case CacheType.Redis:
                    if (redis == null) redis = RedisHelp.GetConnection();
                    return redis.Get<object>(Key); // 类型会被转成 json 格式的字符串
                default:
                    return null;
            }
        }

        /// <summary>
        /// 清除缓存
        /// </summary>
        public void RemoveCache()
        {
            if (string.IsNullOrEmpty(Key)) return;
            switch (this.cacheType)
            {
                case CacheType.Cache:
                    RunTimeCache.RemoveCache(Key);
                    break;
                case CacheType.Memcached:
                    MemcachedCache.RemoveCache(this.DatabaseOrPath, Key); // 未经测试
                    break;
                case CacheType.File:
                    var filename = Barfoo.Library.IO.PathUtility.GetPhysicalPath(this.DatabaseOrPath);
                    FileCache.Remove(filename);
                    break;
                case CacheType.Session:
                    SessionCache.Remove(Key);
                    break;
                case CacheType.Redis:
                    if (redis == null) redis = RedisHelp.GetConnection();
                    redis.Remove(Key); // 未经测试
                    break;
            }
        }

    }
}
