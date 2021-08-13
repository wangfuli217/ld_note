/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  PathUtility 路径资源类
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/

using System;
using System.IO;
using System.Web;

namespace Barfoo.Library.IO
{
    public class PathUtility
    {
        /// <summary>
        /// 应用程序路径
        /// </summary>
        /// <returns></returns>
        public static string ApplicationPath()
        {
            return HttpContext.Current != null ?
                HttpRuntime.AppDomainAppPath :
                AppDomain.CurrentDomain.BaseDirectory;
        }

        /// <summary>
        /// 获取物理路径
        /// </summary>
        /// <param name="path">路径(支持 ASP.NET "~/contents" 样式相对路径)</param>
        /// <returns></returns>
        /// <example>
        /// <code>
        /// <![CDATA[
        /// var s = PathUtility.GetPhysicalPath(@"\a\b\c\d\e");
        /// Console.WriteLine(s);
        /// 
        /// s = PathUtility.GetPhysicalPath(@"~/a/c/d/e");
        /// Console.WriteLine(s);
        /// ]]>
        /// </code>
        /// </example>
        public static string GetPhysicalPath(string path)
        {
            if (String.IsNullOrEmpty(path)) return path;

            if (HttpContext.Current != null)
            {
                if (path.StartsWith("~/"))
                    return HttpContext.Current.Server.MapPath(path);
                else
                    return Path.Combine(ApplicationPath(), path);
            }
            else
            {
                if (path.StartsWith("~/"))
                    return Path.GetFullPath(Path.Combine(ApplicationPath(), path.Substring(2)));
                else
                    return Path.GetFullPath(path);
            }
        }

        public static string ChangeExtension(string filename, string newExt)
        {
            string path = Path.GetDirectoryName(filename);
            string main = Path.GetFileNameWithoutExtension(filename);
            if (!newExt.StartsWith("."))
            {
                newExt = "." + newExt;
            }
            return Path.Combine(path, main + newExt);
        }

        public static string GetDirectoryName(string path)
        {
            var file = new FileInfo(path);
            return file.DirectoryName;
        }

        public static void CreateDirectory(string dir)
        {
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);
        }
    }
}
