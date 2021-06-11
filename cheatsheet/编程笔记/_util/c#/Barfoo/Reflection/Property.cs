/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称     对象属性实用类
创建日期：  2011-11-1
作者：      陈振兴
内容摘要： 
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace Barfoo.Library.Reflection
{
    public static class Property
    {
        #region Field

        private static Dictionary<Type, PropertyInfo[]> propertyCache;

        #endregion

        #region Constructor

        static Property()
        {
            propertyCache = new Dictionary<Type, PropertyInfo[]>();
        }

        #endregion

        #region Public Method

        public static PropertyInfo[] GetProperties(Type type)
        {
            if (!propertyCache.ContainsKey(type))
            {
                propertyCache[type] = type.GetProperties();
            }

            return propertyCache[type];
        }

        public static T GetValue<T>(object obj, PropertyInfo prop)
        {
            return (T)GetValue(obj, prop);

        }

        public static T GetValue<T>(object obj, string propertyName)
        {
            T value = default(T);
            var property = GetProperties(obj.GetType()).FirstOrDefault(p => p.Name == propertyName);
            if (property != null)
            {
                value = GetValue<T>(obj, property);
            }
            return value;
        }

        public static object GetValue(object obj, PropertyInfo prop)
        {
            return prop.GetValue(obj, null);
        }

        public static void SetValue(object obj, PropertyInfo prop, object value)
        {
            prop.SetValue(obj, value, null);
        }

        #endregion
    }
}
