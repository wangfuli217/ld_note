/*
版权所有：  邦富软件版权所有(C)
系统名称：  舆情系统
模块名称：  缓存管理类(FileCache)
创建日期：  2012-2-8
作者：      刘付春彬
内容摘要： 
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Barfoo.Library.Cache
{
    public class FileCache
    {
        /// <summary>
        /// 获取文件的内容
        /// </summary>
        /// <param name="key">文件路径</param>
        /// <returns></returns>
        public static string Get(string key)
        {
            return Barfoo.Library.IO.FileUtility.ReadText(key);
        }

        /// <summary>
        /// 获取文件的内容
        /// </summary>
        /// <param name="key">文件路径</param>
        /// <param name="timeOut">超时时间(单位:秒)</param>
        /// <returns></returns>
        public static string Get(string key, int timeOut)
        {
            System.IO.FileInfo fif = new System.IO.FileInfo(key);
            if (fif.Exists && fif.LastWriteTime >= DateTime.Now.AddSeconds(-timeOut))
            {
                return Barfoo.Library.IO.FileUtility.ReadText(key);
            }
            else
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// 设值
        /// </summary>
        /// <param name="key">文件路径</param>
        /// <param name="value">文件里面要保存的内容</param>
        public static void Set(string key, object value)
        {
            System.IO.FileInfo fif = new System.IO.FileInfo(key);
            if (!fif.Directory.Exists)
            {
                fif.Directory.Create();
            }
            Barfoo.Library.IO.FileUtility.WriteFile(key, value.ToString());
        }

        /// <summary>
        /// 清除缓存，即删除文件
        /// </summary>
        /// <param name="key">文件路径</param>
        public static void Remove(string key)
        {
            System.IO.FileInfo file = new System.IO.FileInfo(key);
            if (file.Exists)
            {
                file.Delete();
            }
        }

    }
}
