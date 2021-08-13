using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Runtime.CompilerServices;
using System.Web;

using Barfoo.Library.Serialization;

namespace Barfoo.Library.Net
{
 /// <summary>
    /// by LixingTie
    /// </summary>
    public class UrlHelper
    {
        /// <summary>
        /// 首页关键字
        /// </summary>
        private static readonly string[] IndexKeys = { "^((http|https)://)?[^/]*?/?$" };

        /// <summary>
        /// 博客关键字
        /// </summary>
        private static readonly string[] BlogKeys = { "blog", "bokee" };

        /// <summary>
        /// 微博关键字
        /// </summary>
        private static readonly string[] MicroBlogKeys = { "weibo", "twritter", @"://t\.sina", @"://t\.163", @"://t\.sohu", @"://t\.qq", @"://t\.people", @"://t\.", "fanfou" };

        /// <summary>
        /// 新闻关键字
        /// </summary>
        private static readonly string[] NewsKeys = { "news", @"[^\d]\d{8}[^\d]", @"\d{4}[^\d]\d{1, 2}[^\d]{1, 2}", @"\d{1, 2}[^\d]\d{4}[^\d]{1, 2}" };

        /// <summary>
        /// 论坛关键字
        /// </summary>
        private static readonly string[] BBSKeys = { "bbs", "forum", "club", "post", "thread", "tieba", "tid", "fid", "board", "showtopic" };

        public static UrlHelper Instance { get; private set; }

        static UrlHelper()
        {
            Instance = new UrlHelper();
        }

        public URLType GetUrlType(string url)
        {
            if (Match(url, BlogKeys))
                return URLType.Blog;

            if (Match(url, MicroBlogKeys))
                return URLType.MicroBlog;

            if (Match(url, NewsKeys))
                return URLType.News;

            if (Match(url, BBSKeys))
                return URLType.BBS;

            if (Match(url, IndexKeys))
                return URLType.Index;

            return URLType.Other;
        }

        private bool Match(string url, string[] keys)
        {
            foreach (var key in keys)
            {
                if (Regex.IsMatch(url, key))
                    return true;
            }
            return false;
        }

        public string GetUrlTypeName(URLType type)
        {
            switch (type)
            {
                case URLType.BBS:
                    return "论坛";
                case URLType.Blog:
                    return "博客";
                case URLType.MicroBlog:
                    return "微博";
                case URLType.News:
                    return "新闻";
                case URLType.Index:
                    return "综合";
                default:
                    return "其它";
            }
        }

        private static Regex DomainRegex = RegexUtility.CreateRegex(@"(?<Domain>([^:\./ ]+\.(com\.cn|net\.cn|org\.cn|gov\.cn|com|cn|mobi|tel|asia|net|org|name|me|tv|cc|hk|biz|info|in|[a-z]{2,})|\d+\.\d+.\d+.\d+))($|\s|/)");

        public static string AbsoluteUrl(string baseUri, string childUri)
        {
            return new Uri(new Uri(baseUri), childUri).AbsoluteUri;
        }

        public static string GetDomainName(string url)
        {
            var matchs = DomainRegex.Matches(url);
            if (matchs.Count == 0)
            {
                return string.Empty;
            }
            return matchs[0].Groups["Domain"].Value;

        }

        /// <summary>
        /// 对象转为URL参数
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static string ObjectToUrlParameter(object obj)
        {
            if (obj == null) return string.Empty;
            var properties = obj.GetType().GetProperties();
            List<object> list = new List<object>();
            StringBuilder psb = new StringBuilder();
            string v = string.Empty;
            foreach (var p in properties)
            {
                var value = p.GetValue(obj, null);
                v = value != null ? value.ToString() : string.Empty;
                var type = p.PropertyType.FullName;
                var index = type.IndexOf("[");
                // 当值为复杂类型时(判断依据：v返回的值跟type值类似，都是表示类路径的)
                if (value != null && index > 0 && v.EndsWith("]") && type.EndsWith("]") &&
                    v.Length > index && v.Substring(0, index).Equals(type.Substring(0, index)))
                {
                    v = value.ToJson();
                    // 如果是数组，去掉数组的前后中括号
                    if (v.StartsWith("[") && v.EndsWith("]"))
                    {
                        v = v.Substring(1);
                        v = v.Substring(0, v.Length - 1);
                    }
                    // 如果里面包含的是字符串，去掉括号(字符串里面包含逗号时会引起歧义)
                    if (v.StartsWith("\"") && v.EndsWith("\""))
                    {
                        v = v.Trim('"').Replace("\",\"", ",");
                    }
                }

                // UrlEncode
                foreach (Attribute attr in p.GetCustomAttributes(true))
                {
                    if (attr is Attributes.FieldEncodingAttribute)
                    {
                        Attributes.FieldEncodingAttribute a = attr as Attributes.FieldEncodingAttribute;
                        if (a.Encod.ToLower() == "urlencode")
                        {
                            v = HttpUtility.UrlEncode(v);
                        }
                        break;
                    }
                }
                v = v.Replace("&", "%26");
                psb.AppendFormat("{0}={1}&", new object[] { p.Name, v });
            }
            return psb.ToString().TrimEnd(new char[] { '&' });
        }
    }

    public class RegexUtility
    {
        public static RegexOptions compiledIgnoreCaseExplicitCapture = RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture;

        private static Dictionary<string, Regex> regexCache = new Dictionary<string, Regex>();

        /// <summary>
        /// 构建编译，忽略大小写，忽略无组名的正则表达式
        /// </summary>
        /// <param name="pattern"></param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static Regex CreateRegex(string pattern)
        {
            Regex reg;
            if (!regexCache.TryGetValue(pattern, out reg))
            {
                reg = new Regex(pattern, compiledIgnoreCaseExplicitCapture);
                regexCache.Add(pattern, reg);
            }
            return reg;
        }

        /// <summary>
        /// 获取匹配的第一个组名里的所有匹配项
        /// </summary>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <param name="ms"></param>
        public static void GetFirstGroups(Regex reg, string content, IList<string> ms)
        {
            var mc = reg.Matches(content);
            var groupName = GetFirstGroupName(reg);
            foreach (Match m in mc)
            {
                var cs = m.Groups[groupName].Captures;
                foreach (var c in cs)
                {
                    ms.Add(c.ToString());
                }
            }
        }

        /// <summary>
        /// 获取匹配的第一个组名里的所有匹配项
        /// </summary>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <returns></returns>
        public static IList<string> GetFirstGroups(Regex reg, string content)
        {
            var list = new List<string>();
            GetFirstGroups(reg, content, list);
            return list;
        }

        /// <summary>
        /// 获取第一个组名里的第一个匹配项
        /// </summary>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <returns></returns>
        public static string GetFirstMatch(Regex reg, string content)
        {
            var mc = reg.Matches(content);
            if (mc.Count == 0) return string.Empty;

            var groupName = GetFirstGroupName(reg);
            return String.IsNullOrEmpty(groupName) ? mc[0].Value : mc[0].Groups[groupName].Value.Trim();
        }

        /// <summary>
        /// 获取第一个组名
        /// </summary>
        /// <param name="reg"></param>
        /// <returns></returns>
        public static string GetFirstGroupName(Regex reg)
        {
            return reg.GetGroupNames().Length >= 2 ? reg.GetGroupNames()[1] : string.Empty;
        }

        /// <summary>
        /// 利用正则匹配文本，同时装配到传进来的对象中
        /// </summary>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <param name="obj"></param>
        /// <![CDATA[
        ///    var content = "名字=李明 年龄=25";
        ///    var reg = new Regex(@"名字=(?<Name>[^ ]+)\s*年龄=(?<Age>\d+)");
        ///    var p = new People();
        ///    RegexUtility.Assemble(reg, content, p);
        ///    Console.WriteLine("{0}：{1}", p.Name, p.Age);
        /// ]]>
        public static void Assemble(Regex reg, string content, object obj)
        {
            if (reg == null || String.IsNullOrEmpty(content)) return;

            var mc = reg.Matches(content);
            if (mc.Count == 0) return;

            var groupNames = reg.GetGroupNames();
            Assemble(mc[0], groupNames, obj);
        }

        public static void Assemble(Match m, string[] groupNames, object obj)
        {
            var properties = obj.GetType().GetProperties();

            foreach (var p in properties)
            {
                if (groupNames.Contains(p.Name))
                {
                    if (m.Groups[p.Name].Success)
                    {
                        var capture = m.Groups[p.Name].Value;
                        object value;

                        if (p.PropertyType == typeof(String))
                            value = capture;
                        else if (p.PropertyType == typeof(DateTime))
                            value = Convert.ToDateTime(capture);
                        else
                            value = Convert.ChangeType(capture, p.PropertyType);

                        p.SetValue(obj, value, null);

                    }
                }
            }
        }
    }

    /// <summary>
    /// 博客类型
    /// </summary>
    public enum URLType
    {
        Blog,
        MicroBlog,
        News,
        BBS,
        Index,
        Other
    }

    
}
