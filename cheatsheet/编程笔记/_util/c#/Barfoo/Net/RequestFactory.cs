/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  RequestBuilder HTTP请求构建类
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/

using System;
using System.IO;
using System.Net;
using System.Text;

namespace Barfoo.Library.Net
{
    /// <summary>
    /// HttpWebRequest请求的构建类
    /// </summary>
    public class RequestBuilder
    {
        public static Encoding DefaultEncode = Encoding.Default;

        /// <summary>
        /// 根据传进来的请求参数返回响应对象
        /// <para>可能引发异常，请注意处理</para>
        /// </summary>
        /// <param name="message">请求信息封装实体类</param>
        /// <returns>目标URL的响应对象</returns>
        public HttpWebRequest CreateRequest(RequestMessage message)
        {
            var request = InitializeRequest(message);

            if (String.IsNullOrEmpty(message.PostData))
                return CreateGetRequest(request);
            else
                return CreatePostRequest(request, message.PostData);
        }

        /// <summary>
        /// 根据传进来的请求信息构造HttpWebRequest对象
        /// </summary>
        /// <param name="message">请求信息</param>
        /// <returns>Http请求实例</returns>
        private HttpWebRequest InitializeRequest(RequestMessage message)
        {

            var request = HttpWebRequest.Create(message.Url) as HttpWebRequest;
            request.AllowAutoRedirect = true;
            request.KeepAlive = true;

            request.Accept = "*/*";
            request.Headers.Add("Accept-Language", "zh-cn");

            request.Headers["Accept-Encoding"] = "gzip, deflate";
            request.AutomaticDecompression = DecompressionMethods.Deflate | DecompressionMethods.GZip;

            request.UserAgent = message.UserAgent;
            request.Referer = message.RefererUrl;
            request.CookieContainer = message.Cookies;
            request.Timeout = message.TimeOut;

            if (message.Proxy != null) request.Proxy = message.Proxy;

            return request;
        }

        /// <summary>
        /// 构造Get类型的http请求实例
        /// </summary>
        private HttpWebRequest CreateGetRequest(HttpWebRequest request)
        {
            request.Method = "GET";
            return request;
        }

        /// <summary>
        /// 构造post类型的http请求实例
        /// </summary>
        /// <param name="myRequest">具有一定参数的http请求实例</param>
        /// <param name="data">想要post的数据</param>
        /// <returns>构造好的附带了post数据的http请求对象</returns>
        private HttpWebRequest CreatePostRequest(HttpWebRequest request, string data)
        {
            byte[] Data = DefaultEncode.GetBytes(data);

            request.Method = "POST";
            request.ContentLength = Data.Length;
            request.ContentType = "application/x-www-form-urlencoded";

            using (Stream outStream = request.GetRequestStream())
            {
                outStream.Write(Data, 0, Data.Length);
            }

            return request;
        }
    }
}
