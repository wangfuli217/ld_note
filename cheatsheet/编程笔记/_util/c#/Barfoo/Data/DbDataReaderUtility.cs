/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  DbDataReaderUtility datareader数据访问类
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/

using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Reflection;
using System.Linq;

namespace Barfoo.Library.Data
{
    public static class DbDataReaderUtility
    {
        #region Convert DBValue

        /// <summary>
        /// 数据值转换
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        /// <example>
        /// <code>
        /// <![CDATA[
        /// while (reader.Read())
        /// {
        ///		var id = Convert<int>(reader["Id"], -1);
        ///		// ...
        ///	}
        /// ]]>
        /// </code>
        /// </example>
        public static T Convert<T>(this object value, T defaultValue)
        {
            return value != DBNull.Value ? (T)global::System.Convert.ChangeType(value, typeof(T)) : defaultValue;
        }

        /// <summary>
        /// 数据值转换
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <returns></returns>
        public static T Convert<T>(this object value)
        {
            return Convert(value, default(T));
        }

        #endregion

        #region DbReader GetValue

        /// <summary>
        /// 读取字符串值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public static string GetString(this DbDataReader reader, string columnName)
        {
            return reader[columnName].Convert<string>();
        }

        /// <summary>
        /// 读取字符串值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static string GetString(this DbDataReader reader, string columnName, string defaultValue)
        {
            return reader[columnName].Convert<string>(defaultValue);
        }

        /// <summary>
        /// 读取整数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public static int GetInt32(this DbDataReader reader, string columnName)
        {
            return reader[columnName].Convert<int>();
        }

        /// <summary>
        /// 读取整数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static int GetInt32(this DbDataReader reader, string columnName, int defaultValue)
        {
            return reader[columnName].Convert<int>(defaultValue);
        }

        /// <summary>
        /// 读取长整数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public static long GetInt64(this DbDataReader reader, string columnName)
        {
            return reader[columnName].Convert<long>();
        }

        /// <summary>
        /// 读取长整数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static long GetInt64(this DbDataReader reader, string columnName, long defaultValue)
        {
            return reader[columnName].Convert<long>(defaultValue);
        }

        /// <summary>
        /// 读取短整数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public static short GetInt16(this DbDataReader reader, string columnName)
        {
            return reader[columnName].Convert<short>();
        }

        /// <summary>
        /// 读取短整数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static short GetString(this DbDataReader reader, string columnName, short defaultValue)
        {
            return reader[columnName].Convert<short>(defaultValue);
        }

        /// <summary>
        /// 读取布尔值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public static bool GetBoolean(this DbDataReader reader, string columnName)
        {
            return reader[columnName].Convert<bool>();
        }

        /// <summary>
        /// 读取布尔值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static bool GetString(this DbDataReader reader, string columnName, bool defaultValue)
        {
            return reader[columnName].Convert<bool>(defaultValue);
        }

        /// <summary>
        /// 读取浮点数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public static float GetFloat(this DbDataReader reader, string columnName)
        {
            return reader[columnName].Convert<float>();
        }

        /// <summary>
        /// 读取浮点数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static float GetString(this DbDataReader reader, string columnName, float defaultValue)
        {
            return reader[columnName].Convert<float>(defaultValue);
        }

        /// <summary>
        /// 读取双精度浮点值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public static double GetDouble(this DbDataReader reader, string columnName)
        {
            return reader[columnName].Convert<double>();
        }

        /// <summary>
        /// 读取双精度浮点值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static double GetString(this DbDataReader reader, string columnName, double defaultValue)
        {
            return reader[columnName].Convert<double>(defaultValue);
        }

        /// <summary>
        /// 读取货币数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public static decimal GetDecimal(this DbDataReader reader, string columnName)
        {
            return reader[columnName].Convert<decimal>();
        }

        /// <summary>
        /// 读取货币数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static decimal GetDecimal(this DbDataReader reader, string columnName, decimal defaultValue)
        {
            return reader[columnName].Convert<decimal>(defaultValue);
        }

        /// <summary>
        /// 读取日期数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        public static DateTime GetDateTime(this DbDataReader reader, string columnName)
        {
            return reader[columnName].Convert<DateTime>();
        }

        /// <summary>
        /// 读取日期数值
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="columnName"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static DateTime GetDateTime(this DbDataReader reader, string columnName, DateTime defaultValue)
        {
            return reader[columnName].Convert<DateTime>(defaultValue);
        }

        /// <summary>
        /// 直接从DbDataReader读取数据填充到实体
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="reader"></param>
        /// <param name="entity"></param>
        /// <returns></returns>
        public static T Read<T>(this DbDataReader reader, T entity) where T : new()
        {
            return Read<T>(reader, entity, typeof(T).GetPropertiesCached());
        }
        public static T Read<T>(this DbDataReader reader) where T : new()
        {
            return Read<T>(reader, typeof(T).GetPropertiesCached());
        }

        /// <summary>
        /// 直接从DbDataReader中根据指定的属性读取数据填充到实体
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="reader"></param>
        /// <param name="properties"></param>
        /// <returns></returns>
        public static T Read<T>(this DbDataReader reader, T entity, PropertyInfo[] properties) where T : new()
        {
            if (entity == null) entity = new T();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                var name = reader.GetName(i);
                // 传统数据库的字段忽略大小写
                var property = properties.Where(p => p.Name.ToLower() == name.ToLower()).FirstOrDefault();

                if (property == null) continue;
                //property.SetValue(entity, reader[i] == DBNull.Value ? null : reader[i], null);

                // 实体类与数据库的类型有可能不对等，需以实体类的为准, 类型转换时有可能出现异常
                try
                {
                    var value = reader[i];
                    if (value == DBNull.Value)
                    {
                        property.SetValue(entity, null, null);
                    }
                    else
                    {
                        var type = property.PropertyType;
                        string typeStr = type.ToString();
                        // 数据库的 int 类型转成实体类的 int? 类型会出错,解决类似问题
                        if (typeStr.StartsWith("System.Nullable") && typeStr.IndexOf("[") > 14 && typeStr.EndsWith("]"))
                        {
                            // 只取中括号里面的
                            typeStr = typeStr.Substring(typeStr.IndexOf("[") + 1);
                            typeStr = typeStr.Substring(0, typeStr.Length-1);
                        }
                        // 如果不是 System 开头,看看有没可能是枚举
                        if (!typeStr.StartsWith("System."))
                        {
                            var t1 = property.PropertyType.BaseType;
                            typeStr = t1.ToString();
                        }
                        switch (typeStr)
                        {
                            // 为基本类型的赋值
                            case "System.String": property.SetValue(entity, value.ToString(), null); break; // string 不用转类型
                            case "System.Boolean": property.SetValue(entity, System.Convert.ToBoolean(value), null); break;
                            case "System.Char": property.SetValue(entity, System.Convert.ToChar(value), null); break;
                            case "System.SByte": property.SetValue(entity, System.Convert.ToSByte(value), null); break;
                            case "System.Byte": property.SetValue(entity, System.Convert.ToByte(value), null); break;
                            case "System.Int16": property.SetValue(entity, System.Convert.ToInt16(value), null); break; // short
                            case "System.UInt16": property.SetValue(entity, System.Convert.ToUInt16(value), null); break; // ushort
                            case "System.Int32": property.SetValue(entity, System.Convert.ToInt32(value), null); break; // int
                            case "System.UInt32": property.SetValue(entity, System.Convert.ToUInt32(value), null); break; // uint
                            case "System.Int64": property.SetValue(entity, System.Convert.ToInt64(value), null); break; // long
                            case "System.UInt64": property.SetValue(entity, System.Convert.ToUInt64(value), null); break; // ulong
                            case "System.Single": property.SetValue(entity, System.Convert.ToSingle(value), null); break; // float
                            case "System.Double": property.SetValue(entity, System.Convert.ToDouble(value), null); break;
                            case "System.Decimal": property.SetValue(entity, System.Convert.ToDecimal(value), null); break;
                            case "System.DateTime": property.SetValue(entity, System.Convert.ToDateTime(value), null); break; // 日期
                            case "System.Enum": property.SetValue(entity, Enum.Parse(type, value.ToString()), null); break; // 枚举
                            // 最后是 object 类型
                            default: property.SetValue(entity, System.Convert.ChangeType(value, type), null); break;
                        }
                    }
                }
                catch
                {
                }
            }
            return entity;
        }
        public static T Read<T>(this DbDataReader reader, PropertyInfo[] properties) where T : new()
        {
            return Read<T>(reader, new T(), properties);
        }

        #endregion
        

        #region DbReader Other

        /// <summary>
        /// 去除数组里面的空值
        /// </summary>
        /// <typeparam name="T">指定类型</typeparam>
        /// <param name="args">数组</param>
        /// <returns>去除空值后的数组</returns>
        public static T[] RemoveNull<T>(T[] args)
        {
            if (args == null || args.Length == 0)
                return new T[0];

            // 用list来保存
            List<T> list = new List<T>();
            foreach (T t in args)
            {
                // 保证没有重复
                if (t != null && !"".Equals(t))
                {
                    list.Add(t);
                }
            }

            return list.ToArray<T>();
        }

        /// <summary>
        /// 去除数组里面的重复值
        /// </summary>
        /// <typeparam name="T">指定类型</typeparam>
        /// <param name="args">数组</param>
        /// <returns>去除重复值后的数组</returns>
        public static T[] RemoveDuplicate<T>(T[] args)
        {
            if (args == null || args.Length == 0)
                return new T[0];

            // 用list来保存
            List<T> list = new List<T>();
            foreach (T t in args)
            {
                // 保证没有重复
                if (!list.Contains(t))
                {
                    list.Add(t);
                }
            }

            return list.ToArray<T>();
        }

        /// <summary>
        /// 去除数组里面的空值和重复值
        /// </summary>
        /// <typeparam name="T">指定类型</typeparam>
        /// <param name="args">数组</param>
        /// <returns>去除空值和重复值后的数组</returns>
        public static T[] RemoveNullAndDuplicate<T>(T[] args)
        {
            if (args == null || args.Length == 0)
                return new T[0];

            // 用list来保存
            List<T> list = new List<T>();
            foreach (T t in args)
            {
                // 保证没有重复
                if (t != null && !"".Equals(t) && !list.Contains(t))
                {
                    list.Add(t);
                }
            }

            return list.ToArray<T>();
        }

        #endregion
    }
}
