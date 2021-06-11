/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  ConfigurationUtility 配置文件资源类
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/


using System;
using System.Configuration;

namespace Barfoo.Library.Configuration
{
    public class ConfigurationUtility
    {
        /// <summary>
        /// 获取配置文件中当前键值对应的数据库连接
        /// </summary>
        /// <param name="key">键值</param>
        /// <returns>数据库连接字符串</returns>
        public static string ConnectionStrings(string key)
        {
            var setting =  ConfigurationManager.ConnectionStrings[key];
            if (setting == null) return string.Empty;
            return setting.ConnectionString;
        }

        /// <summary>
        /// 获取配置文件中当前键值对应的数据库连接
        /// </summary>
        /// <param name="key">键值</param>
        /// <param name="defaultValue">默认值</param>
        /// <returns>数据库连接字符串</returns>
        public static string ConnectionStrings(string key, string defaultValue)
        {
            var setting = ConfigurationManager.ConnectionStrings[key];
            if (setting == null || string.IsNullOrEmpty(setting.ConnectionString)) return defaultValue;
            return setting.ConnectionString;
        }

        /// <summary>
        /// 获取配置文件中当前键值对应的数据库设置
        /// </summary>
        /// <param name="key">键值</param>
        /// <returns>数据库设置</returns>
        public static ConnectionStringSettings ConnectionStringSettings(string key)
        {
            return ConfigurationManager.ConnectionStrings[key];
        }

        /// <summary>
        /// <para>获取配置文件中当前键值对应的值，并转换为相应的类型</para>
        /// <para>当配置项为空时，自动转换为该类型的默认值</para>
        /// </summary>
        /// <typeparam name="T">想要转换的类型</typeparam>
        /// <param name="key">键值</param>
        /// <returns>配置项值</returns>
        public static T AppSettings<T>(string key)
        {
            return AppSettings<T>(key, default(T));
        }

        /// <summary>
        /// <para>获取配置文件中当前键值对应的值，并转换为相应的类型</para>
        /// <para>当配置项为空，返回传入的默认值</para>
        /// </summary>
        /// <typeparam name="T">想要转换的类型</typeparam>
        /// <param name="key">键值</param>
        /// <param name="defaultValue">默认值</param>
        /// <returns>配置项值</returns>
        public static T AppSettings<T>(string key, T defaultValue)
        {
            var v = ConfigurationManager.AppSettings[key];
            return String.IsNullOrEmpty(v) ? defaultValue : (T)Convert.ChangeType(v, typeof(T));
        }
    }
}
