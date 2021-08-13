/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  String扩展类
创建日期：  2012-2-10
作者：      刘付春彬
内容摘要： 
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;
using System.IO;

namespace Barfoo.Library.Text
{
    public static class StringExtensions
    {
        #region Microsoft

        public static TValue As<TValue>(this string value)
        {
            return value.As<TValue>(default(TValue));
        }

        public static TValue As<TValue>(this string value, TValue defaultValue)
        {
            try
            {
                TypeConverter converter = TypeDescriptor.GetConverter(typeof(TValue));
                if (converter.CanConvertFrom(typeof(string)))
                {
                    return (TValue)converter.ConvertFrom(value);
                }
                converter = TypeDescriptor.GetConverter(typeof(string));
                if (converter.CanConvertTo(typeof(TValue)))
                {
                    return (TValue)converter.ConvertTo(value, typeof(TValue));
                }
            }
            catch (Exception)
            {
            }
            return defaultValue;
        }

        /// <summary>
        /// 将字符串true或者false(不区分大小写)转换成bool类型，转换失败返回false
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool AsBool(this string value)
        {
            return value.As<bool>(false);
        }

        /// <summary>
        /// 将字符串true或者false(不区分大小写)转换成bool类型，转换失败返回defaultValue
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool AsBool(this string value, bool defaultValue)
        {
            return value.As<bool>(defaultValue);
        }

        /// <summary>
        /// 将字符串表示的的时间格式转换相对应的DateTime，转换失败返回DateTime.MinValue
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static DateTime AsDateTime(this string value)
        {
            return value.As<DateTime>();
        }

        /// <summary>
        /// 将字符串表示的的时间格式转换相对应的DateTime，转换失败返回defaultValue
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static DateTime AsDateTime(this string value, DateTime defaultValue)
        {
            return value.As<DateTime>(defaultValue);
        }

        public static decimal AsDecimal(this string value)
        {
            return value.As<decimal>();
        }

        public static decimal AsDecimal(this string value, decimal defaultValue)
        {
            return value.As<decimal>(defaultValue);
        }

        public static float AsFloat(this string value)
        {
            return value.As<float>();
        }

        public static float AsFloat(this string value, float defaultValue)
        {
            return value.As<float>(defaultValue);
        }

        public static int AsInt(this string value)
        {
            return value.As<int>();
        }

        public static int AsInt(this string value, int defaultValue)
        {
            return value.As<int>(defaultValue);
        }
        /// <summary>
        /// 相当于String.IsNullOrEmpty(value)
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool IsEmpty(this string value)
        {
            return string.IsNullOrEmpty(value);
        }

        #endregion

        #region Extension

        public static double AsDouble(this string value)
        {
            return value.As<double>();
        }

        public static double AsDouble(this string value, double defaultValue)
        {
            return value.As<double>(defaultValue);
        }

        public static long AsLong(this string value)
        {
            return value.As<long>();
        }

        public static long AsLong(this string value, long defaultValue)
        {
            return value.As<long>(defaultValue);
        }

        /// <summary>
        /// 将字符串转换成相对应的Guid，转换失败返回Guid.Empty (00000000-0000-0000-0000-000000000000)
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static Guid AsGuid(this string value)
        {
            return value.As<Guid>();
        }
        /// <summary>
        /// 将字符串转换成相对应的Guid，转换失败返回defaultValue
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static Guid AsGuid(this string value, Guid defaultValue)
        {
            return value.As<Guid>(defaultValue);
        }
        /// <summary>
        /// 将字符串表示的的时间格式转换相对应的DateTime，转换失败返回TimeSpan.MinValue(00:00:00)
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static TimeSpan AsTimeSpan(this string value)
        {
            return value.As<TimeSpan>();
        }

        /// <summary>
        /// 将字符串表示的的时间格式转换相对应的DateTime，转换失败返回defaultValue
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static TimeSpan AsTimeSpan(this string value, TimeSpan defaultValue)
        {
            return value.As<TimeSpan>(defaultValue);
        }

        /// <summary>
        /// 格式化字符串，等效于String.Format(value,args)
        /// </summary>
        /// <param name="value"></param>
        /// <param name="args"></param>
        /// <returns></returns>
        public static string Format(this string value, params object[] args)
        {
            return string.Format(value, args);
        }

        #endregion

        #region Common
        /// <summary>
        /// 去除所有html标签
        /// </summary>
        public static string ClearAllHtmlTag(this string strText)
        {
            if (string.IsNullOrEmpty(strText))
            {
                return strText;
            }
            try
            {
                string html = strText;
                html = Regex.Replace(html, @"<script([\s\S]+?)/script>", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"<style([\s\S]+?)/style>", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"<[^>]+/?>|</[^>]+>", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"<!--.*-->", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"-->", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"<!--.", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"&(nbsp|#160);", " ", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"&#(\d+);", "", RegexOptions.IgnoreCase);
                html = html.Replace("\r\n\r\n", "");
                html = html.Replace("\n\n", "");
                html = html.Replace("     ", "");
                html = html.Replace("\t\t", "");
                html = html.Replace("<strong>", "");
                html = html.Replace("</strong", "");
                html = Regex.Replace(html, @"<", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @">", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"\0", "", RegexOptions.IgnoreCase);

                return html;
            }
            catch
            {
                return strText;
            }
        }

        ///// <summary>
        ///// 转换成 JSON
        ///// </summary>
        ///// <param name="o"></param>
        ///// <returns></returns>
        //public static string ToJson(this object o)
        //{
        //    var serializer = new JavaScriptSerializer();
        //    return serializer.Serialize(o);
        //}

        ///// <summary>
        ///// 将 JSON 转换为对象
        ///// </summary>
        ///// <typeparam name="T"></typeparam>
        ///// <param name="s"></param>
        ///// <returns></returns>
        //public static T FromJson<T>(this string s)
        //{
        //    var serializer = new JavaScriptSerializer();
        //    serializer.MaxJsonLength = 10240000;
        //    return serializer.Deserialize<T>(s);
        //}

        //public static T FromJson<T>(this Stream stream)
        //{
        //    StreamReader reader = new StreamReader(stream);
        //    string temp = reader.ReadToEnd();

        //    var serializer = new JavaScriptSerializer();
        //    serializer.MaxJsonLength = 10240000;
        //    return serializer.Deserialize<T>(temp);
        //}

        ///// <summary>
        ///// 将 JSON 转换为对象
        ///// </summary>
        ///// <param name="s"></param>
        ///// <returns></returns>
        //public static object FromJson(this string s)
        //{
        //    var serializer = new JavaScriptSerializer();
        //    serializer.MaxJsonLength = 10240000;
        //    return serializer.DeserializeObject(s);
        //}

        public static string SliceWithLength(this string s, int start, int maxLength)
        {
            int length = Math.Min(maxLength, s.Length - start);
            if (!string.IsNullOrEmpty(s) && (length > 0))
            {
                return s.Substring(start, length);
            }
            return null;
        }



        /// <summary>
        /// 截断字符串(按length)
        /// </summary>
        /// <param name="content"></param>
        /// <param name="len"></param>
        /// <returns></returns>
        public static string GetContentByLen(this string content, int len)
        {
            return GetContentByLen(content, len, "");
        }

        /// <summary>
        /// 截断字符串(按length)
        /// </summary>
        /// <param name="content"></param>
        /// <param name="len"></param>
        /// <param name="etcString">截取字段后跟的省略字符</param>
        /// <returns></returns>
        public static string GetContentByLen(this string content, int len, String etcString)
        {
            if (content == null) return string.Empty;
            if (len < 1) { return content; }
            if (content.Length > len)
            {
                content = content.Substring(0, len) + etcString;
            }
            return content;
        }

        /// <summary>
        /// 截取字符串(按byte)
        /// </summary>
        /// <param name="mText">要截取的字串</param>
        /// <param name="byteCount">长度</param>
        /// <returns>被截取过的字串</returns>
        public static string GetContentByByteLen(this string mText, int byteCount)
        {
            return GetContentByByteLen(mText, byteCount, "");
        }

        /// <summary>
        /// 截取字符串(按byte)
        /// </summary>
        /// <param name="mText">要截取的字串</param>
        /// <param name="byteCount">截取长度</param>
        /// <param name="etcString">截取字段后跟的省略字符</param>
        /// <returns>被截取过的字串</returns>
        public static string GetContentByByteLen(this string mText, int byteCount, String etcString)
        {
            if (byteCount < 4)
                return mText;

            if (System.Text.Encoding.Default.GetByteCount(mText) <= byteCount)
            {
                return mText;
            }
            else
            {
                byte[] txtBytes = System.Text.Encoding.Default.GetBytes(mText);
                byte[] newBytes = new byte[byteCount - 4];

                for (int i = 0; i < byteCount - 4; i++)
                {
                    newBytes[i] = txtBytes[i];
                }
                string OutPut = System.Text.Encoding.Default.GetString(newBytes) + etcString;
                if (OutPut.EndsWith("?" + etcString) == true)
                {
                    OutPut = OutPut.Substring(0, OutPut.Length - 4);
                    OutPut += etcString;
                }
                return OutPut;
            }
        }


        /// <summary>
        /// 获取字符串的长度(按byte)
        /// </summary>
        /// <param name="mText">字符串</param>
        /// <returns>字符串长度</returns>
        public static Int32 GetContentByteLen(this string mText)
        {
            return System.Text.Encoding.Default.GetByteCount(mText);
        }
        #endregion
    }
}
