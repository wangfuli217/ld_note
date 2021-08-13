/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  JsonUtility
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/


using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using Barfoo.Library.Net;
using Barfoo.Library.Configuration;

namespace Barfoo.Library.Serialization
{
    /// <summary>
    /// JSON 扩展，支持FromUrl
    /// </summary>
    public static class JsonUtility
    {
        public static CookieContainer Credence { get; set; }

        static JsonUtility()
        {
            RequestBuilder.DefaultEncode = Encoding.UTF8;
        }

        /// <summary>
        /// 转换成 JSON
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        public static string ToJson(this object o)
        {
            var serializer = new JavaScriptSerializer(); 
            return serializer.Serialize(o);
        }
        /// <summary>
        /// 转换成 JSON
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        public static string ToJson(this object o, int? recursionLimit)
        {
            var serializer = new JavaScriptSerializer();
            serializer.RecursionLimit = recursionLimit ?? serializer.RecursionLimit; 
            return serializer.Serialize(o);
        }
        /// <summary>
        /// 转换成 JSON
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        public static string ToJson(this object o, int? recursionLimit, int? maxJsonLengthMultiple=0)
        {
            var serializer = new JavaScriptSerializer();
            serializer.RecursionLimit = recursionLimit ?? serializer.RecursionLimit;
            if (maxJsonLengthMultiple!=null&&maxJsonLengthMultiple.Value>0)
            {
                serializer.MaxJsonLength = serializer.MaxJsonLength * maxJsonLengthMultiple.Value;
            }
            return serializer.Serialize(o);
        }

        /// <summary>
        /// 转换成 JSON
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        public static string ToUrlEncodeJson(this object o)
        {
            var serializer = new JavaScriptSerializer();
            var jason = serializer.Serialize(o);
            return HttpUtility.UrlEncode(jason, Encoding.UTF8);
        }

        /// <summary>
        /// 将 JSON 转换为对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="s"></param>
        /// <returns></returns>
        public static T FromJson<T>(this string s)
        {
            if (string.IsNullOrEmpty(s))
            {
                return default(T);
            }
            return FromJson<T>(s, 100);
            //var serializer = new JavaScriptSerializer();
            //return serializer.Deserialize<T>(s);
        }

        public static T FromJson<T>(this string s, int? recursionLimit)
        {
            if (string.IsNullOrEmpty(s))
            {
                return default(T);
            }
            var serializer = new JavaScriptSerializer();
            serializer.RecursionLimit = recursionLimit ?? serializer.RecursionLimit;
            return serializer.Deserialize<T>(s);
        }
        public static T FromJson<T>(this string s, int? recursionLimit, int? maxJsonLengthMultiple)
        {
            if (string.IsNullOrEmpty(s))
            {
                return default(T);
            }
            var serializer = new JavaScriptSerializer();
            serializer.RecursionLimit = recursionLimit ?? serializer.RecursionLimit;
            if (maxJsonLengthMultiple != null && maxJsonLengthMultiple.Value > 0)
            {
                serializer.MaxJsonLength = serializer.MaxJsonLength * maxJsonLengthMultiple.Value;
            }
            return serializer.Deserialize<T>(s);
        }
        /// <summary>
        /// 将 JSON 转换为对象
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static object FromJson(this string s)
        {
            if (string.IsNullOrEmpty(s))
            {
                return default(object);
            }
            var serializer = new JavaScriptSerializer();
            return serializer.DeserializeObject(s);
        }

        /// <summary>
        /// GET从URL返回对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="url"></param>
        /// <returns></returns>
        public static T FromUrl<T>(string url)
        {
            return FromUrl<T>(url, null);
        }

        /// <summary>
        /// GET从URL返回对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="url"></param>
        /// <returns></returns>
        public static T FromUrl<T>(string url, int recursionLimit)
        {
            return FromUrl<T>(url, null, recursionLimit);
        }

        /// <summary>
        /// POST从URL获取对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="url"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        public static T FromUrl<T>(string url, string data)
        {
            var message = new RequestMessage { Url = url, PostData = data };
            if (Credence != null) message.Cookies = Credence;
            string webProxy = ConfigurationUtility.AppSettings<string>("WebProxy", string.Empty);
            if (!string.IsNullOrEmpty(webProxy))
            {
                message.Proxy = new WebProxy(webProxy);
            }
            var content = DownLoader.GetContent(message, 3);
            return content.FromJson<T>();
        }

        /// <summary>
        /// POST从URL获取对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="url"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        public static T FromUrl<T>(string url, object parameterObject)
        {
            var data = UrlHelper.ObjectToUrlParameter(parameterObject);
            return FromUrl<T>(url, data);
        }
        /// <summary>
        /// POST从URL获取对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="url"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        public static T FromUrl<T>(string url, string data, int recursionLimit)
        {
            var message = new RequestMessage { Url = url, PostData = data };
            if (Credence != null) message.Cookies = Credence;

            var content = DownLoader.GetContent(message, 3);
            return content.FromJson<T>(recursionLimit);
        }

        /// <summary>
        /// POST从URL获取对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="url"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        public static T FromUrl<T>(string url, object parameterObject, int recursionLimit)
        {
            var data = UrlHelper.ObjectToUrlParameter(parameterObject);
            return FromUrl<T>(url, data,recursionLimit);
        }

    }
}