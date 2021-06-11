using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Barfoo.Library.Text
{
    public class DomainUtility
    {
        private static Regex DomainRegex = RegexUtility.CreateRegex(@"(?<Domain>([^:\./ ]+\.(com\.cn|net\.cn|org\.cn|gov\.cn|com|cn|mobi|tel|asia|net|org|name|me|tv|cc|hk|biz|info|in|[a-z]{2,})|\d+\.\d+.\d+.\d+))($|\s|/)");
        /// <summary>
        /// 获取域名
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static string GetDomainByURL(string url)
        {
            var matchs = DomainRegex.Matches(url);
            if (matchs.Count == 0)
            {
                return string.Empty;
            }
            return matchs[0].Groups["Domain"].Value;
        }
    }
}
