/*
��Ȩ���У�  ������Ȩ����(C)
ϵͳ���ƣ�  �������
ģ�����ƣ�  PathUtility ·����Դ��
�������ڣ�  2007-2-1
���ߣ�      ������
����ժҪ�� 
*/

using System;
using System.IO;
using System.Web;

namespace Barfoo.Library.IO
{
    public class PathUtility
    {
        /// <summary>
        /// Ӧ�ó���·��
        /// </summary>
        /// <returns></returns>
        public static string ApplicationPath()
        {
            return HttpContext.Current != null ?
                HttpRuntime.AppDomainAppPath :
                AppDomain.CurrentDomain.BaseDirectory;
        }

        /// <summary>
        /// ��ȡ����·��
        /// </summary>
        /// <param name="path">·��(֧�� ASP.NET "~/contents" ��ʽ���·��)</param>
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
