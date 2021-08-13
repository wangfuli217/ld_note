using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServiceStack.Redis;
using System.Reflection;
namespace Barfoo.Library.Data
{
    public static class MongoObject
    {
        /// <summary>
        /// 获取自增ID
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static long GetNextSequence<T>()
        {
            using (var redis = RedisHelp.GetConnection())
            using(var typeClient = redis.As<T>())
            {
                return typeClient.GetNextSequence();
            }
        }

        public static int GetNextIntSequence<T>()
        {
            return Convert.ToInt32(GetNextSequence<T>());
        }

        public static decimal GetNextDecimalSequence<T>()
        {
            return Convert.ToDecimal(GetNextSequence<T>());
        }

        /// <summary>
        /// 将自增值赋值给带有MongoIdAutoIncr特性的属性
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="t"></param>
        public static void AutoIncrID<T>(this T t)
        {
            var autoAttr = (from pro in t.GetProperties()
                            let att = pro.GetCustomAttributes(typeof(MongoIdAutoIncrAttribute), true)
                            where att.Length > 0
                            select pro).SingleOrDefault();

            if (autoAttr == null)
                return;

            var protype = autoAttr.PropertyType;
            if(protype == typeof(int))
            {
                autoAttr.SetValue(t, GetNextIntSequence<T>(), null);
            }
            else if (protype == typeof(long))
            {
                autoAttr.SetValue(t, GetNextSequence<T>(), null);
            }
            else if (protype == typeof(decimal))
            {
                autoAttr.SetValue(t, GetNextDecimalSequence<T>(), null);
            }
            else
            {
                throw new ArgumentException("被自动递增的属性只能是 int, long 或者 decimal");
            }
        }
    }
}
