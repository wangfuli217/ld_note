/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  URL 涉及的常用方法
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text.RegularExpressions;
using Barfoo.Library.Cryptography;
using Barfoo.Library.Text;

namespace Barfoo.Library.Net
{
    /// <summary>
    /// URL类
    /// </summary>
    [DebuggerDisplay("URL={Url}, Title={Title}")]
    public class URL
    {
        #region Field && Constructor

        /// <summary>
        /// 网页URL
        /// </summary>
        public string Url { get; set; }

        /// <summary>
        /// 链接的标题
        /// </summary>
        public string Title { get; set; }

        #endregion

        #region Property

        /// <summary>
        /// 获取URL的主体部分
        /// </summary>
        public string Body
        {
            get { return URL.GetUrlBody(this.Url); }
        }

        /// <summary>
        /// 获取URL的MD5编码
        /// </summary>
        public string Md5
        {
            get { return MD5Helper.Md5Hash(this.Url); }
        }

        /// <summary>
        /// 获取URL的参数部分
        /// </summary>
        public string Parameter
        {
            get { return URL.GetUrlParameter(this.Url); }
        }

        /// <summary>
        /// 获取URL的域名
        /// </summary>
        public string SecondDomainName
        {
            get { return URL.GetSecondDomainName(this.Url); }
        }

        /// <summary>
        /// 获取一级域名
        /// </summary>
        public string DomainName
        {
            get { return URL.GetDomainName(this.Url); }
        }

        /// <summary>
        /// 获取该URL对应的一级URL
        /// </summary>
        public string FirstLevelUrl
        {
            get { return URL.GetFirstLevelUrl(this.Url); }
        }

        #endregion

        #region IsUrl(string url)

        /// <summary>
        /// 判断该URL是否是标准的URL ^https?\://([\w-]+\.)+[\w-]+(/[^ ]*)?$
        /// </summary>
        private readonly static Regex regUrl = RegexUtility.CreateRegex(
            @"^https?\://([\s\S]+?\.)+[\s\S]+$");

        /// <summary>
        /// 是否是URL
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static bool IsUrl(string url)
        {
            return regUrl.IsMatch(url);
        }
        #endregion

        #region GetFirstLevelUrl(string url)
        /// <summary>
        /// <para>获取主域名 组名请不要轻易修改 </para>
        /// <para>因为其它组有可能利用组名获取捕获项</para>
        /// </summary>
        private readonly static Regex regGetFirstLevelUrl = RegexUtility.CreateRegex(
            @"(?<DomainName>^https?://[^/]+)/?");

        /// <summary>
        /// <para>获取URL中的一级域名</para> 
        /// <para>获取http://www.163.com/index.html的</para>
        /// <para>http://www.163.com</para>
        /// </summary>
        /// <param name="url">想要判断的URL字符串</param>
        /// <returns>一级域名</returns>
        public static string GetFirstLevelUrl(string url)
        {
            return regGetFirstLevelUrl.Matches(url)[0].Groups["DomainName"].Value;
        }

        #endregion

        #region IsAbsoluteUrl(string url)

        /// <summary>
        /// <para>判断该链接是否属于Https://或者http://开头的</para>
        /// <para>借以判断是否属于绝对链接</para>
        /// </summary>
        private readonly static Regex RegIsAbsoluteUrl = RegexUtility.CreateRegex(
            @"^https?://");

        /// <summary>
        /// 判断该链接是否属于绝对链接 是否属于Https://或者http://开头的
        /// </summary>
        /// <param name="url">想要判断的URL字符串</param>
        /// <returns>是否属于绝对链接</returns>
        public static bool IsAbsoluteUrl(string url)
        {
            return RegIsAbsoluteUrl.IsMatch(url);
        }

        #endregion

        #region string GetDomainName(string url)

        private static Regex reg = RegexUtility.CreateRegex(
             @"https?://www.(?<DomainName>[^/]*)(/|\b)|https?://(?<DomainName>[^/]*)(/|\b)");

        /// <summary>
        /// 获取域名 如：http://www.163.com ==>  163.com  http://gd.163.com ==>  gd.163.com
        /// </summary>
        /// <param name="url">想要获取域名的url</param>
        /// <returns>返回获取到的域名</returns>
        public static string GetSecondDomainName(string url)
        {
            if (url.ToLower().Trim().StartsWith("http"))
            {
                return reg.Matches(url)[0].Groups["DomainName"].Value;
            }
            return url;
        }

        private static Regex domainRegex = RegexUtility.CreateRegex(@"(?<Domain>([^:\./ ]+\.(com\.cn|net\.cn|org\.cn|gov\.cn|com|cn|mobi|tel|asia|net|org|name|me|tv|cc|hk|biz|info|in|[a-z]{2,}(\:\d+)?)|\d+\.\d+.\d+.\d+))($|\s|/)");

        /// <summary>
        /// 获取1级域名，gd.163.com ==>  163.com
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static string GetDomainName(string url)
        {
            var mc = domainRegex.Matches(url);
            if (mc.Count == 0) return String.Empty;

            return mc[0].Groups["Domain"].Value;
        }

        #endregion

        #region IsDomainUrl(string url)

        /// <summary>
        /// 判断URL是否是主域名
        /// </summary>
        private readonly static Regex RegIsDomainName = RegexUtility.CreateRegex(
            @"^https?://[^.]+\.[^/]+/?$");

        /// <summary>
        /// 判断是否是一级域名 ^https?://[^.]+\.[^/]+/?$
        /// </summary>
        /// <param name="url">想要判断的URL字符串</param>
        /// <returns>是否属于主域名</returns>
        public static bool IsDomainUrl(string url)
        {
            return RegIsDomainName.IsMatch(url);
        }

        #endregion

        #region HasParameter(string url)

        /// <summary>
        /// 通过"?"来判断该URL是否拥有参数
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static bool HasParameter(string url)
        {
            return url.IndexOf("?") > 0;
        }

        #endregion

        #region GetUrlBody(string url)

        /// <summary>
        /// 获取URL的主体部分
        /// </summary>
        /// <param name="url">想要判断的URL字符串</param>
        /// <returns>Url主体部分</returns>
        public static string GetUrlBody(string url)
        {
            if (!URL.HasParameter(url))
                return url;
            return url.Substring(0, url.IndexOf("?"));
        }
        #endregion

        #region GetUrlParameter(string url)
        /// <summary>
        /// 获取URL的参数部分
        /// </summary>
        /// <param name="url">URL</param>
        /// <returns>参数部分</returns>
        public static string GetUrlParameter(string url)
        {
            if (!URL.HasParameter(url))
                return string.Empty;
            return url.Substring(url.IndexOf("?") + 1);
        }
        #endregion

        #region RepairUrl(string childUrl, string parentUrl)

        /// <summary>
        /// 检查传入的URL是否属于绝对链接，如果不是的话修补该链接为绝对链接
        /// </summary>
        /// <param name="url">待检查的URL链接</param>
        /// <param name="parentUrl">该URL提取到的页面的URL</param>
        /// <returns>检查后的链接</returns>
        public static string AbsoluteUrl(string childUrl, string parentUrl)
        {
            if (childUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                return childUrl;

            try
            {
                return new Uri(new Uri(parentUrl), childUrl).AbsoluteUri;
            }
            catch
            {
                return String.Empty;
            }
        }
        #endregion

        #region ConvertToAbsoluteContent

        /// <summary>
        /// 利用该正则获取页面里的所有链接
        /// </summary>
        private static Regex RegGetAllUrls = RegexUtility.CreateRegex(
            @"((href)|(src))\s*=\s*['""]?(?<URL>[^'""> ]+?)[ '""}>]");

        /// <summary>
        /// 获取网站的所有相对路径
        /// </summary>
        /// <param name="pageContent">页面内容</param>
        /// <param name="pageUrl">页面对应的链接</param>
        /// <returns>相对路径链表</returns>
        public static IList<string> GetAllComparativeUrls(string pageContent, string pageUrl)
        {
            if (!URL.IsAbsoluteUrl(pageUrl))
                throw new ArgumentException();

            MatchCollection mc = RegGetAllUrls.Matches(pageContent);
            if (mc == null || mc.Count == 0)
                return null;

            IList<string> list = new List<string>();
            foreach (Match m in mc)
            {
                string tempUrl = m.Groups["URL"].Value.Trim();
                if (!URL.IsAbsoluteUrl(tempUrl) && !(tempUrl.ToLower().IndexOf("javascript:") >= 0))
                {
                    if (!list.Contains(tempUrl)) list.Add(tempUrl);
                }
            }
            return list;
        }

        /// <summary>
        /// 过滤一些可能引发歧义需要转义的正则字符
        /// </summary>
        /// <param name="reg"></param>
        /// <returns></returns>
        public static string FilterRegexCharacter(string reg)
        {
            return Regex.Escape(reg);
        }

        /// <summary>
        /// 将页面中的所有相对链接转换为绝对链接页面内容
        /// </summary>
        /// <param name="pageContent">原页面内容</param>
        /// <param name="pageUrl">图片链接</param>
        /// <returns>处理过后的链接</returns>
        public static string ConvertToAbsoluteContent(string pageContent, string pageUrl)
        {
            IList<string> urlList = GetAllComparativeUrls(pageContent, pageUrl);
            foreach (string url in urlList)
            {
                string reg = @"(\=\s*['""]?)" + FilterRegexCharacter(url);
                if (url.IndexOf("(") >= 0)
                    continue;

                pageContent = Regex.Replace(pageContent, reg, "$1" + URL.AbsoluteUrl(url, pageUrl));
            }
            return pageContent;
        }
        #endregion

        #region FilterOrientation

        /// <summary>
        /// 过滤掉URL中的一些定位信息如#top
        /// </summary>
        private readonly static Regex regOrientation = RegexUtility.CreateRegex(@"\#[\S]*$|\\$|\+$");

        /// <summary>
        /// 过滤掉URL中的一些定位信息如#top
        /// </summary>
        /// <param name="url">想要过滤的URL</param>
        /// <returns>整理完的URL</returns>
        public static string FilterOrientation(string url)
        {
            url = regOrientation.Replace(url, "");
            if (IsDomainUrl(url) && url.EndsWith("/"))
            {
                url = url.Substring(0, url.Length - 1);
            }
            return url;
        }
        #endregion

        #region GetIndex

        public static string GetIndex(string domainName)
        {
            if (domainName.IndexOf(".") != domainName.LastIndexOf(".") && !domainName.EndsWith(".com.cn"))
                return String.Concat("http://", domainName);
            else
                return String.Concat("http://www.", domainName);
        }

        #endregion

        public override string ToString()
        {
            return this.Url;
        }
    }
}