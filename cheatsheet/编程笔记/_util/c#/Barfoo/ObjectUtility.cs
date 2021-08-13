/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  ObjectUtility 对象资源类
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/

using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Runtime.Serialization.Formatters.Binary;

namespace Barfoo.Library
{
    /// <summary>
    /// 通用对象辅助类
    /// </summary>
    public static class ObjectUtility
    {
        //private static Dictionary<Type, PropertyInfo[]> anonymousCache = new Dictionary<Type, PropertyInfo[]>();
        private static Dictionary<Type, PropertyInfo[]> _anonymousCache;
        private static Dictionary<Type, PropertyInfo[]> anonymousCache
        {
            get
            {
                if (_anonymousCache == null)
                {
                    lock (anonymousCacheLock)
                    {
                        if (_anonymousCache == null)
                        {
                            _anonymousCache = new Dictionary<Type, PropertyInfo[]>();
                        }
                    }
                }
                return _anonymousCache;
            }
        } 
        static object anonymousCacheLock = new object();

        /// <summary>
        /// 获取对象属性值
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static PropertyInfo[] GetProperties(this object value)
        {
            var type = value.GetType();
            return type.GetPropertiesCached();
        }

        public static PropertyInfo[] GetPropertiesCached(this Type type)
        {
            PropertyInfo[] properties;

            if (!anonymousCache.TryGetValue(type, out properties))
            {
                properties = type.GetProperties();
                anonymousCache.Add(type, properties);
            }

            return properties;
        }

        /// <summary>
        /// 获取单个字段值
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="o"></param>
        /// <param name="propertyName"></param>
        /// <![CDATA[
        ///    foreach (var item in array as IEnumerable )
        ///    {
        ///        int id = item.GetValue<int>("Id");
        ///        string name = item.GetValue<string>("ChannelName");
        ///        Console.WriteLine("{0} : {1}", id, name);
        ///    }
        /// ]]>
        /// <returns></returns>
        public static T GetPropertyValue<T>(this object o, string propertyName)
        {
            var type = o.GetType();
            var p = type.GetProperty(propertyName);
            var v = p.GetValue(o, null);
            return (T)Convert.ChangeType(v, typeof(T));
        }
        public static object GetPropertyValue(this object o, string propertyName)
        {
            var type = o.GetType();
            var p = type.GetProperty(propertyName);
            return p.GetValue(o, null);
        }

        /// <summary>
        /// 深度克隆
        /// </summary>
        /// <param name="o"></param>
        public static Object DeepClone(this Object o)
        {
            var formater = new BinaryFormatter();
            using (var stream = new MemoryStream())
            {
                formater.Serialize(stream, o);
                stream.Seek(0, SeekOrigin.Begin);
                return formater.Deserialize(stream);
            }
        }

        /// <summary>
        /// 比较对象成员
        /// </summary>
        /// <param name="obj1"></param>
        /// <param name="obj2"></param>
        public static bool EqualsMembers(this object obj1, object obj2)
        {
            if (obj1 == null && obj2 == null) return true;
            if (obj1 == null || obj2 == null) return false;
            if (object.ReferenceEquals(obj1, obj2)) return true;

            var t1 = obj1.GetType();
            var t2 = obj2.GetType();
            if (t1 != t2) return false;

            var properties = t1.GetProperties(BindingFlags.Instance | BindingFlags.Public);
            foreach (var p in properties)
            {
                if (!p.CanRead) continue;

                var v1 = p.GetValue(obj1, null);
                var v2 = p.GetValue(obj2, null);

                if (p.Name == "Name")
                {
                    if (String.Compare((string)v1, (string)v2, true) != 0) return false;
                }
                else
                    if (!v1.Equals(v2)) return false;
            }

            return true;
        }

        /// <summary>
        /// 重置对象状态
        /// </summary>
        /// <param name="o"></param>
        public static void Reset(this Object o)
        {
            var ctor = o.GetType().GetConstructor(BindingFlags.Instance | BindingFlags.Public,
              null, new Type[0], null);

            ctor.Invoke(o, null);
        }
    }
}
