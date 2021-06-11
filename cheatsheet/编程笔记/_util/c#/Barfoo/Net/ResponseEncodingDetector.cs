/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  ResponseEncodingDetector 编码解析类
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/

using System;
using System.IO;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using Barfoo.Library.IO;
using Barfoo.Library.Text;

namespace Barfoo.Library.Net
{
    /// <summary>
    /// 获取流的编码
    /// </summary>
    public class ResponseEncodingDetector
    {
        #region Field

        private Regex reg = RegexUtility.CreateRegex(@"charset=\s*['""]?\s*(?<Encode>[^'"" ></]+)['""]?");
        public static Encoding DefaultEncoding = Encoding.GetEncoding("gb2312");

        #endregion

        #region Method

        /// <summary>
        /// 获取HttpWebResponse内流的编码格式并返回内含的流
        /// </summary>
        /// <param name="myResponse">Internet资源的响应</param>
        /// <param name="stream">返回流</param>
        /// <returns>流的编码</returns>
        public Encoding Detector(HttpWebResponse response, out Stream stream)
        {
            var encoding = Detect(response.CharacterSet);

            if (encoding == null) encoding = Detect(RegexUtility.GetFirstMatch(reg, response.ContentType));

            if (encoding != null)
            {
                stream = response.GetResponseStream();
                return encoding;
            }

            return ByHtmlCharset(response.GetResponseStream(), out stream);
        }

        #endregion

        #region Private Method

        /// <summary>
        /// 根据返回Response的Charset获取编码，如果为"ISO-8859-1"则需要重新判断
        /// </summary>
        private Encoding Detect(string s)
        {
            var charset = s == null ? String.Empty : s.ToLower();

            if (charset == "gb-2312" || charset == "zh-cn")
            {
                return DefaultEncoding;
            }
            else if (!String.IsNullOrEmpty(charset) && !charset.Contains("8859"))
            {
                return ConvertEncoding(charset);
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// 根据页面内容获取流的编码形式，如果没有则默认为系统编码
        /// </summary>
        /// <param name="memoryStream">内存流</param>
        private Encoding ByHtmlCharset(Stream rs, out Stream ms)
        {
            ms = rs.ToMemoryStream();

            var streamReader = new StreamReader(ms, Encoding.ASCII);
            var html = streamReader.ReadToEnd();

            var encode = DefaultEncoding;
            if (reg.IsMatch(html)) encode = ConvertEncoding(RegexUtility.GetFirstMatch(reg, html));

            ms.Seek(0, SeekOrigin.Begin);

            return encode;
        }

        /// <summary>
        /// 根据字符名称 转换为编码
        /// </summary>
        /// <param name="charset"></param>
        /// <returns></returns>
        private Encoding ConvertEncoding(string charset)
        {
            try { return Encoding.GetEncoding(charset); }
            catch { return null; }
        }

        #endregion
    }
}
