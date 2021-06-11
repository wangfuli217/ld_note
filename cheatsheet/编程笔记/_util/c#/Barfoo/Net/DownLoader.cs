/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  Downloader HTTP下载器
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/

using System;
using System.Drawing;
using System.IO;
using System.Net;
using System.Text;
using System.Threading;
using System.Web;
using Barfoo.Library.IO;

namespace Barfoo.Library.Net
{
    /// <summary>
    /// <para>下载器.. </para>
    /// <para>在调用GetContent前请先调用Connect , 实例对象不支持多线程</para>
    /// <para>该类可能抛出异常，主要是Http请求和获取响应部分的异常</para>
    /// <example>
    /// <code>
    /// <![CDATA[
    /// using (DownLoader down = new DownLoader())
    /// {
    ///     var message = RequestMessage.CreateInstance("http://www.baidu.com/s?wd=IP");
    ///     message.Proxy = new WebProxy("128.112.139.75:3127");
    ///     down.Connect(message);
    ///     var content = down.GetContent();
    ///     Console.WriteLine(content);
    /// }
    /// ]]>
    /// </code>
    /// </example>
    /// </summary>
    public class DownLoader : IDisposable
    {
        #region Fileds && Properties && Constructor

        private static RequestBuilder factory = new RequestBuilder();
        private static ResponseEncodingDetector detector = new ResponseEncodingDetector();

        /// <summary>
        /// 默认超时时 重试等待时间
        /// </summary>
        public static int DefaultTimeoutWait = 0;

        /// <summary>
        /// 同一网站最大连接数，HTTP协议规定为2，此处默认设置为500
        /// </summary>
        public static int DefaultConnectionLimit
        {
            get { return ServicePointManager.DefaultConnectionLimit; }
            set { ServicePointManager.DefaultConnectionLimit = value; }
        }

        /// <summary>
        /// 获取当前请求对应的页面编码
        /// </summary>
        public Encoding Encode { get; private set; }

        /// <summary>
        /// 获取目标服务器对请求的响应
        /// </summary>
        public HttpWebResponse Response { get; private set; }

        /// <summary>
        /// 获取当前的Http请求
        /// </summary>
        public HttpWebRequest Request { get; private set; }

        /// <summary>
        /// 静态构造函数
        /// </summary>
        static DownLoader()
        {
            DefaultConnectionLimit = 500;
            ServicePointManager.Expect100Continue = false;
        }

        #endregion

        #region Methods

        /// <summary>
        /// 根据传进来的请求信息，构造Http请求，同时获取目标服务器响应
        /// </summary>
        /// <param name="message">请求信息</param>
        public void Connect(RequestMessage message)
        {
            Request = factory.CreateRequest(message);
            Response = Request.GetResponse() as HttpWebResponse;
        }

        /// <summary>
        /// 传递传递进来的URL 构建Http请求，同时获取目标服务器响应
        /// </summary>
        /// <param name="url">链接</param>
        public void Connect(string url)
        {
            this.Connect(new RequestMessage { Url = url });
        }

        /// <summary>
        /// 根据URL获取页面内容，请在调用此方法前先调用Connect
        /// </summary>
        /// <param name="url">URL名称</param>
        /// <returns>URL对应页面的内容</returns>
        public string GetContent()
        {
            Stream stream;
            Encode = detector.Detector(Response, out stream);
            return stream.ToString(Encode);
        }

        /// <summary>
        /// 根据图片URL获取Bitmap实例
        /// </summary>
        /// <param name="url">图片URL</param>
        /// <returns>Bitmap实例</returns>
        public Image GetImage()
        {
            using (var stream = Response.GetResponseStream())
            {
                return stream.ToBitmap();
            }
        }

        /// <summary>
        /// 获取返回流
        /// </summary>
        /// <returns></returns>
        public Stream GetStream()
        {
            return Response.GetResponseStream();
        }

        /// <summary>
        /// 将URL对应的资源下载下来并保存
        /// </summary>
        /// <param name="path">保存路径</param>
        public void Save(string path)
        {
            using (var stream = Response.GetResponseStream())
            {
                stream.Save(path);
            }
        }


        #region IDisposable 成员

        /// <summary>
        /// 将目标服务器返回流关闭
        /// </summary>
        public void Dispose()
        {
            if (this.Response != null) this.Response.Close();
        }

        #endregion

        #endregion

        #region Static Methods

        /// <summary>
        /// 根据URL获取页面内容
        /// </summary>
        /// <param name="url">URL名称</param>
        /// <returns>URL对应页面的内容</returns>
        public static string GetContent(string url)
        {
            return GetContent(new RequestMessage { Url = url });
        }

        /// <summary>
        /// 根据URL获取页面内容，当出现超时异常，将自动重新请求
        /// </summary>
        /// <param name="url">目标URL</param>
        /// <param name="retryNumber">超时时重试次数</param>
        /// <returns>页面内容</returns>
        public static string GetContent(string url, uint retryNumber)
        {
            return GetContent(new RequestMessage { Url = url }, retryNumber);
        }

        /// <summary>
        /// 根据URL获取页面内容
        /// </summary>
        /// <param name="url">URL名称</param>
        /// <param name="postData">附加post的内容</param>
        /// <returns>URL对应页面的内容</returns>
        public static string GetContent(string url, string postData)
        {
            return GetContent(new RequestMessage { Url = url, PostData = postData });
        }

        /// <summary>
        /// 根据URL获取页面内容
        /// </summary>
        /// <param name="url">URL名称</param>
        /// <param name="postData">附加post的内容</param>
        /// <param name="retryNumber">超时时重试次数</param>
        /// <returns>URL对应页面的内容</returns>
        public static string GetContent(string url, string postData, uint retryNumber)
        {
            return GetContent(new RequestMessage { Url = url, PostData = postData }, retryNumber);
        }

        /// <summary>
        /// 根据URL获取页面内容
        /// </summary>
        /// <param name="url">URL名称</param>
        /// <param name="parameterObject">附加post的内容</param>
        /// <param name="retryNumber">超时时重试次数</param>
        /// <returns>URL对应页面的内容</returns>
        public static string GetContent(string url, object parameterObject, uint retryNumber)
        {
            var postData = UrlHelper.ObjectToUrlParameter(parameterObject);
            return GetContent(new RequestMessage { Url = url, PostData = postData }, retryNumber);
        }

        /// <summary>
        /// 根据请求实例获取页面内容
        /// </summary>
        /// <param name="message">请求实例</param>
        /// <returns>页面内容</returns>
        public static string GetContent(RequestMessage message)
        {
            /*
            var start = DateTime.Now;
            var beginDate = DateTime.Parse("2011-7-25");
            var endDate = DateTime.Parse("2011-9-14");

            if (start < beginDate || start > endDate)
                return String.Empty;
            */
            using (DownLoader d = new DownLoader())
            {
                d.Connect(message);

                var contentType = d.Response.ContentType.ToLower();

                if (contentType.Contains("text/") || contentType.Contains("json") || contentType.Contains("xhtml"))
                {
                    var content = d.GetContent();
                    message.RedirectUrl = d.Response.ResponseUri;

                    return content;
                }
                else
                    return String.Empty;
            }
        }


        /// <summary>
        /// 根据请求实例获取页面内容，当出现超时异常，将自动重新请求
        /// </summary>
        /// <param name="message">请求实例</param>
        /// <param name="retryNumber">超时时重试次数</param>
        /// <returns>页面内容</returns>
        public static string GetContent(RequestMessage message, uint retryNumber)
        {
            uint i = 0;

            while (i < retryNumber)
            {
                try
                {
                    return GetContent(message);
                }
                catch (WebException exp)
                {
                    if (exp.Status == WebExceptionStatus.Timeout)
                    {
                        i++;
                        if (DefaultTimeoutWait >= 0) Thread.Sleep(DefaultTimeoutWait);
                    }
                    else
                    {
                        return String.Empty;
                    }
                }
                catch
                {
                    return String.Empty;
                }
            }

            return String.Empty;
        }

        /// <summary>
        /// 根据图片URL获取Bitmap实例
        /// </summary>
        /// <param name="url">图片URL</param>
        /// <returns>Bitmap实例</returns>
        public static Image GetImage(string url)
        {
            using (var d = new DownLoader())
            {
                d.Connect(new RequestMessage { Url = url });
                return d.GetImage();
            }
        }

        /// <summary>
        /// 获取解码后的Html
        /// </summary>
        /// <param name="message">请求信息</param>
        /// <returns>解码后的HTML</returns>
        public static string GetContentDecode(RequestMessage message)
        {
            return HttpUtility.HtmlDecode(GetContent(message, 1));
        }

        /// <summary>
        /// 下载URL对应的资源并保存到文件
        /// </summary>
        /// <param name="url">资源路径</param>
        /// <param name="path">文件保存路径</param>
        /// <example>
        /// <code>
        /// <![CDATA[
        ///    var url = "http://lmm.xchmetc.net/UploadFile/article/200731421952367.doc";
        ///    var path = @"c:\a.doc";
        ///    DownLoader.Save(url, path);
        /// ]]>
        /// </code>
        /// </example>
        public static void Save(string url, string path)
        {
            Save(new RequestMessage { Url = url }, path);
        }

        /// <summary>
        /// 下载请求信息相应的资源并保存到文件
        /// </summary>
        /// <param name="message">请求信息</param>
        /// <param name="path">保存路径</param>
        public static void Save(RequestMessage message, string path)
        {
            using (var d = new DownLoader())
            {
                d.Connect(message);
                d.Save(path);
            }
        }

        #endregion
    }
}
