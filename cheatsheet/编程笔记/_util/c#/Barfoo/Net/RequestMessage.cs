/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  RequestMessage HTTP请求信息类
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/


using System;
using System.Diagnostics;
using System.Net;

namespace Barfoo.Library.Net
{
    /// <summary>
    /// Http请求的参数实体类
    /// </summary>
    /// <remarks>
    /// <para>Google蜘蛛代理：Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)</para>
    /// <para>百度蜘蛛代理：Baiduspider+(+http://www.baidu.com/search/spider.htm)</para>
    /// <para>NokiaN70-1/5.0705.3.0.1 Series60/2.8 Profile/MIDP-2.0 Configuration/CLDC-1.1</para>
    /// <para>Mozilla/5.0 (iPhone; U; CPU wie Mac OS X; en) AppleWebKit/420 + (KHTML, like Gecko) Version/3.0 Mobile/1C25 Safari/419.3</para>
    /// </remarks>
    [DebuggerDisplay("URL={Url}")]
    public class RequestMessage
    {
        public static string DefaultUserAgent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.2; .NET CLR 1.1.4322; .NET CLR 2.0.50727)";

        public static int DefaultTimeOut = 60000;

        /// <summary>
        /// 该请求的目标URL
        /// </summary>
        public string Url { get; set; }

        /// <summary>
        /// 该请求的源链接URL
        /// </summary>
        public string RefererUrl { get; set; }

        /// <summary>
        /// 跳转URL
        /// </summary>
        public Uri RedirectUrl { get; set; }

        /// <summary>
        /// 该请求的深度，顶级页面从0开始
        /// </summary>
        public int Depth { get; set; }
	
        /// <summary>
        /// 该请求要附加的post数据
        /// </summary>
        public string PostData { get; set; }

        /// <summary>
        /// 附加的cookie
        /// </summary>
        public CookieContainer Cookies { get; set; }

        /// <summary>
        /// 请求的代理信息
        /// </summary>
        public string UserAgent { get; set; }

        /// <summary>
        /// 该请求的超时时间
        /// </summary>
        public int TimeOut { get; set; }

        /// <summary>
        /// 代理服务器
        /// </summary>
        public IWebProxy Proxy { get; set; }

        /// <summary>
        /// 默认的构造函数，默认为IE的代理，一分钟的超时时间
        /// </summary>
        public RequestMessage()
        {
            UserAgent = DefaultUserAgent;
            TimeOut = DefaultTimeOut;
        }

        /// <summary>
        /// 根据传进来的URL生成请求实例
        /// </summary>
        /// <param name="url">想要请求的URL</param>
        /// <returns>请求实例</returns>
        public static RequestMessage CreateInstance(string url)
        {
            return new RequestMessage { Url = url };
        }

        /// <summary>
        /// 创建一个新的请求实例
        /// </summary>
        /// <param name="url"></param>
        /// <param name="refferMessage"></param>
        /// <returns></returns>
        public static RequestMessage CreateInstance(string url, RequestMessage refferMessage)
        {
            return new RequestMessage
            {
                Url = url,
                PostData = refferMessage.PostData,
                Cookies = refferMessage.Cookies,
                TimeOut = refferMessage.TimeOut,
                RefererUrl = refferMessage.Url,
                UserAgent = refferMessage.UserAgent,
                Proxy = refferMessage.Proxy
            };
        }
    }
}
