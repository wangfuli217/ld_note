using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using ServiceStack.Redis;
using Barfoo.Library.Configuration;

namespace Barfoo.Library.Data
{
    public class RedisHelp
    {
        private static Dictionary<string, string> instances = new Dictionary<string, string>();
        //private static readonly string DefaultName = "default";

        /// <summary>
        /// Redis 的地址
        /// </summary>
        public static readonly string REDIS_HOST = ConfigurationUtility.AppSettings<string>("RedisHost", "192.168.1.200");

        /// <summary>
        /// Redis 的端口
        /// </summary>
        public static readonly int REDIS_PORT = ConfigurationUtility.AppSettings<int>("RedisPort", 6379);

        /// <summary>
        /// 获取 Redis 连接
        /// </summary>
        /// <returns></returns>
        public static RedisClient GetConnection()
        {
            return new RedisClient(REDIS_HOST, REDIS_PORT);
        }

    }
}
