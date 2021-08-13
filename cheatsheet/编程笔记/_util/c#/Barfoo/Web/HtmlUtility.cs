/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  WEB 工具类
创建日期：  2012-02-27
作者：      冯万里
内容摘要：  
*/
using System;
using System.Web;
using System.Linq;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using HtmlAgilityPack;

namespace Barfoo.Library.Web
{
    public static class HtmlUtility
    {
        #region 解释meta中refresh
        /// <summary>
        /// http-equiv的分隔字符
        /// </summary>
        private static readonly string delimiters = "\'\"";
        
        /// <summary>
        /// 解析&lt;meta&gt;标签中的自动跳转url
        /// </summary>
        /// <param name="htmlNode"></param>
        /// <param name="pageEntity"></param>
        public static void Parse(HtmlNode htmlNode, ref List<string> pageEntity)
        {
            if (htmlNode.Name == "body")
            {
                return;
            }
            if (htmlNode.Name == "meta")
            {
                if (htmlNode.Attributes["content"] != null)
                {
                    string refreshUrl = GetRefreshUrl(htmlNode);
                    if (!string.IsNullOrEmpty(refreshUrl))
                    {
                        pageEntity.Add(refreshUrl);
                    }
                }
                return;
            }
            foreach (HtmlNode childNode in htmlNode.ChildNodes)
            {
                Parse(childNode, ref pageEntity);
            }
        }

        /// <summary>
        /// 解析&lt;meta&gt;标签中的自动跳转url
        /// </summary>
        /// <param name="htmlNode"></param>
        /// <returns></returns>
        private static string GetRefreshUrl(HtmlNode htmlNode)
        {
            if (htmlNode.Attributes["http-equiv"] != null && htmlNode.Attributes["http-equiv"].Value == "refresh")
            {
                string refresh = htmlNode.Attributes["content"].Value.ToLower();
                int pos = refresh.IndexOf("url=");
                if (pos != -1)
                {
                    pos += 4;
                    string url = refresh.Substring(pos);
                    if (url.Length > 0)
                    {
                        if (delimiters.IndexOf(url[0]) != -1)
                        {
                            return url.Substring(1, url.Length - 2);
                        }
                        else
                        {
                            return url;
                        }
                    }
                }
            }
            return null;
        }
        #endregion

        #region 获取Request信息
        /// <summary>
        /// 获取Request参数
        /// </summary>
        /// <typeparam name="T">返回值的类型</typeparam>
        /// <typeparam name="key">参数名</typeparam>
        /// <typeparam name="defaultValue">没获取到该值时返回的默认值</typeparam>
        /// <![CDATA[
        ///    int id = HtmlUtility.GetValue<int>("Id", 0);
        ///    string name = HtmlUtility.GetValue<string>("name", "");
        /// ]]>
        /// <returns>该参数的值</returns>
        public static T GetValue<T>(string key, T defaultValue)
        {
            if (HttpContext.Current == null) throw new Exception("非http请求不可调用此方法");
            // HTTP服务器请求
            HttpRequest Request = HttpContext.Current.Request;

            object value = Request.Form[key];
            if (value == null || "".Equals(value))
            {
                value = Request.QueryString[key];
                if (value == null || "".Equals(value))
                {
                    value = Request[key];
                    if (value == null || "".Equals(value))
                    {
                        // 取不到时
                        return defaultValue;
                    }
                }
            }

            try
            {
                return (T)Convert.ChangeType(value, typeof(T));
            }
            // 如果类型转换失败,返回默认值
            catch
            {
                return defaultValue;
            }
        }
        /// <summary>
        /// 获取Request参数
        /// </summary>
        public static T GetValue<T>(string key)
        {
            return GetValue<T>(key, default(T));
        }
        /// <summary>
        /// 获取Request参数,数组类型(按逗号分割)
        /// </summary>
        public static T[] GetValues<T>(string key)
        {
            var retValues = new T[0];
            string returnStr = GetValue<string>(key, string.Empty);
            // 如果获取值为空,则返回空数组
            if (string.IsNullOrEmpty(returnStr))
            {
                return retValues;
            }

            // 去掉前后的方括号
            if (returnStr.StartsWith("[")) returnStr = returnStr.Substring(1);
            if (returnStr.EndsWith("]")) returnStr = returnStr.Substring(0, returnStr.Length - 1);

            string[] values = returnStr.Split(',');
            retValues = new T[values.Length];
            // 逐个处理
            for (int i = 0; i < values.Length; i++)
            {
                string value = values[i];
                // 如果 T 不是字符串类型,则去除值的前后空格再转换
                if (value != null && value.GetType() != typeof(T))
                    value = value.Trim();
                try
                {
                    T t = (T)Convert.ChangeType(value, typeof(T));
                    retValues[i] = t;
                }
                // 如果类型转换失败,使用默认值
                catch
                {
                    retValues[i] = default(T);
                }
            }
            return retValues;
        }
        
        /// <summary>
        /// 获取Request参数并赋值到对象里面
        /// </summary>
        /// <typeparam name="T">对象的类型</typeparam>
        /// <typeparam name="obj">要赋值的对象</typeparam>
        public static T GetObject<T>() where T : new()
        {
            return GetObject(new T());
        }

        /// <summary>
        /// 获取Request参数并赋值到对象里面
        /// </summary>
        /// <typeparam name="T">对象的类型</typeparam>
        /// <typeparam name="obj">要赋值的对象</typeparam>
        public static T GetObject<T>(T obj) where T : new()
        {
            if (HttpContext.Current == null) throw new Exception("非http请求不可调用此方法");
            if (obj == null) obj = new T(); // 为空时必须接收参数,否则设的值无法传回

            // HTTP服务器请求
            HttpRequest Request = HttpContext.Current.Request;
            var atts = obj.GetProperties();
            foreach (var att in atts)
            {
                if (!att.CanWrite) continue;
                string name = att.Name;
                var type = att.PropertyType;
                // 获取请求里的值
                string value = Request.Form[name];
                if (value == null)
                {
                    value = Request.QueryString[name];
                    if (value == null)
                    {
                        value = Request[name];
                        if (value == null)
                        {
                            continue; // 取不到时,不用执行下面的赋值
                        }
                    }
                }
                // 能取到值, 则赋值
                try
                {
                    // 只为基本类型的赋值
                    switch (type.ToString())
                    {
                        case "System.String": att.SetValue(obj, value, null); break; // string 不用转类型
                        // bool 类型可能是 checkbox,radio 的值
                        case "System.Boolean":
                            value = value.Trim().ToLower();
                            bool b = ("true".Equals(value) || "yes".Equals(value) || "on".Equals(value) || "1".Equals(value));
                            att.SetValue(obj, b, null); break;
                        case "System.Char": att.SetValue(obj, Convert.ToChar(value), null); break;
                        case "System.SByte": att.SetValue(obj, Convert.ToSByte(value), null); break;
                        case "System.Byte": att.SetValue(obj, Convert.ToByte(value), null); break;
                        case "System.Int16": att.SetValue(obj, Convert.ToInt16(value), null); break; // short
                        case "System.UInt16": att.SetValue(obj, Convert.ToUInt16(value), null); break; // ushort
                        case "System.Int32": att.SetValue(obj, Convert.ToInt32(value), null); break; // int
                        case "System.UInt32": att.SetValue(obj, Convert.ToUInt32(value), null); break; // uint
                        case "System.Int64": att.SetValue(obj, Convert.ToInt64(value), null); break; // long
                        case "System.UInt64": att.SetValue(obj, Convert.ToUInt64(value), null); break; // ulong
                        case "System.Single": att.SetValue(obj, Convert.ToSingle(value), null); break; // float
                        case "System.Double": att.SetValue(obj, Convert.ToDouble(value), null); break;
                        case "System.Decimal": att.SetValue(obj, Convert.ToDecimal(value), null); break;
                        case "System.DateTime": att.SetValue(obj, Convert.ToDateTime(value), null); break; // 日期
                        // 最后是 object 类型
                        default: att.SetValue(obj, Convert.ChangeType(value, type), null); break;
                    }
                }
                catch
                {
                }
            }
            return obj;
        }
        #endregion

        #region 下拉菜单
        /// <summary>
        /// 拼接下拉菜单
        /// </summary>
        /// <typeparam name="T">数据的实体类</typeparam>
        /// <param name="list">下拉菜单的实体类列表</param>
        /// <param name="valueName">option里面的value在实体类里面的名称</param>
        /// <param name="textName">option显示的内容在实体类里面的名称</param>
        /// <param name="init">默认选项</param>
        /// <param name="selectedValue">被选中的选项值</param>
        /// <returns>实体类列表的option标签字符串</returns>
        public static string Options(IList list, string valueName, string textName, string init, string selectedValue)
        {
            StringBuilder menu = new StringBuilder();
            // 默认选项
            if (init != null) menu.Append("<option value=''>" + init + "</option>\r\n");
            if (list == null || list.Count == 0) return menu.ToString();

            // 拼接成 option 字符串
            foreach (var obj in list)
            {
                string value = obj.GetPropertyValue<string>(valueName).ChangeMarks();
                string text = obj.GetPropertyValue<string>(textName).ToHtml();
                string selected = value.Equals(selectedValue) ? " selected " : ""; // 是否选中
                menu.AppendFormat("<option value='{0}'{1}>{2}</option>\r\n", value, selected, text);
            }
            return menu.ToString();
        }
        /// <summary>
        /// 拼接下拉菜单
        /// </summary>
        public static string Options(IList list, string valueName, string textName, string init)
        {
            return Options(list, valueName, textName, init, null);
        }
        /// <summary>
        /// 拼接下拉菜单
        /// </summary>
        public static string Options(IList list, string valueName, string textName)
        {
            return Options(list, valueName, textName, "请选择");
        }

        /// <summary>
        /// 拼接 jqGrid 表格的下拉菜单
        /// </summary>
        /// <typeparam name="T">数据的实体类</typeparam>
        /// <param name="list">下拉菜单的实体类列表</param>
        /// <param name="valueName">option里面的value在实体类里面的名称</param>
        /// <param name="textName">option显示的内容在实体类里面的名称</param>
        /// <param name="initValue">默认选项的值,不能为空字符串</param>
        /// <param name="initText">默认选项的显示内容</param>
        /// <returns>实体类列表的option标签字符串</returns>
        public static string jqGridOptions(IList list, string valueName, string textName, string initValue, string initText)
        {
            StringBuilder menu = new StringBuilder();
            // 默认选项
            if (!string.IsNullOrEmpty(initValue) && !string.IsNullOrEmpty(initText)) menu.Append(initValue).Append(":").Append(initText);
            if (list == null || list.Count == 0) return menu.ToString();

            // 拼接成 option 字符串
            for (int i = 0; i < list.Count; i++)
            {
                var obj = list[i];
                if (menu.Length > 0) menu.Append(";"); // 拼接分隔符
                menu.Append(obj.GetPropertyValue<string>(valueName).ChangeMarks());
                menu.Append(":");
                menu.Append(obj.GetPropertyValue<string>(textName).ToHtml());
            }
            return menu.ToString();
        }
        /// <summary>
        /// 拼接 jqGrid 表格的下拉菜单
        /// </summary>
        public static string jqGridOptions(IList list, string valueName, string textName)
        {
            return jqGridOptions(list, valueName, textName, "0", "请选择");
        }

        /// <summary>
        /// 拼接一个按数值递增或递减的下拉菜单
        /// </summary>
        /// <param name="start">此下拉菜单的开始项(含)</param>
        /// <param name="end">此下拉菜单的结束项(含)</param>
        /// <param name="init">此下拉菜单的默认选中值</param>
        /// <param name="iterator">递增数(递减时请设为负数)</param>
        /// <param name="isFirstBlank">第一项是否为空</param>
        /// <returns>拼接成的option标签字符串</returns>
        public static string Options(int start, int end, int init, int iterator, bool isFirstBlank)
        {
            // 递增量
            int iter = iterator;
            // 避免出现死循环
            if (start <= end && iterator <= 0) iter = 1;
            if (start > end && iterator >= 0) iter = -1;

            StringBuilder menu = new StringBuilder();
            // 如果需要，则先添加一个空值的选项
            if (isFirstBlank) menu.Append("<option value=''>请选择</option>\r\n");

            // 拼接成 option 字符串
            for (int i = start; true; i += iter)
            {
                // 终止条件写"true"，然后用if来终止，为了控制顺序及倒序情况
                // 当 start == end 时，还是会执行一次
                if (start <= end && i > end) break;
                if (start > end && i < end) break;

                menu.AppendFormat("<option value='{0}'{1}>{2}</option>\r\n", i, (i == init ? " selected" : ""), i);
            }
            return menu.ToString();
        }
        /// <summary>
        /// 拼接一个按数值递增或递减的下拉菜单
        /// </summary>
        public static string Options(int start, int end, int init)
        {
            return Options(start, end, init, 0, true);
        }
        /// <summary>
        /// 拼接一个按数值递增或递减的下拉菜单
        /// </summary>
        public static string Options(int start, int end)
        {
            // 不选中任何一个
            int init = (start < end) ? (end + 1) : (start + 1);
            return Options(start, end, init);
        }
        #endregion

        #region 符号转换
        /// <summary>
        /// 符号转换，特殊符号都在前面加上斜杠(\)
        /// </summary>
        /// <param name="sour">被转换的字符串</param>
        /// <returns>转换后的字符串</returns>
        public static string ChangeMarks(this string sour)
        {
            if (string.IsNullOrEmpty(sour)) return "";

            // 斜杠(\)取代成(\\)
            sour = sour.Replace(@"\", @"\\");
            // 各符號，都在前面加上斜杠(\)
            sour = sour.Replace("\"", "\\\""); // 双引号变成 \"
            sour = sour.Replace("'", @"\'");
            sour = sour.Replace("/", @"\/");
            sour = sour.Replace("<", @"\<");
            sour = sour.Replace(">", @"\>");
            sour = sour.Replace(":", @"\:");
            sour = sour.Replace("#", @"\#");
            sour = sour.Replace("%", @"\%");
            sour = sour.Replace("&", @"\&");
            return sour;
        }

        /// <summary>
        /// 将需要显示的字符串转换成 HTML 格式的
        /// </summary>
        /// <param name="sour">被转换的字符串</param>
        /// <returns>转换后的字符串</returns>
        public static string ToHtml(this string sour)
        {
            if (string.IsNullOrEmpty(sour)) return "";

            // 以下逐一转换
            sour = sour.Replace("&", "&amp;"); // & 符號,最先转换
            sour = sour.Replace(" ", "&nbsp;");
            sour = sour.Replace("%", "&#37;");
            sour = sour.Replace("<", "&lt;");
            sour = sour.Replace(">", "&gt;");
            sour = sour.Replace("\n", "\n<br/>");
            sour = sour.Replace("\"", "&quot;");
            sour = sour.Replace("'", "&#39;");
            sour = sour.Replace("+", "&#43;");
            return sour;
        }

        /// <summary>
        /// 将 HTML 格式的字符串转换成正常显示的字符串(与 ToHtml 方法相反)
        /// </summary>
        /// <param name="sour">被转换的字符串</param>
        /// <returns>转换后的字符串</returns>
        public static String ToText(this string sour)
        {
            if (string.IsNullOrEmpty(sour)) return "";

            // 以下逐一转换
            // 先转换百分号
            sour = sour.Replace("&#37;", "%");
            // 小于号,有三种写法
            sour = sour.Replace("&lt;", "<");
            sour = sour.Replace("&LT;", "<");
            sour = sour.Replace("&#60;", "<");
            // 大于号,有三种写法
            sour = sour.Replace("&gt;", ">");
            sour = sour.Replace("&GT;", ">");
            sour = sour.Replace("&#62;", ">");
            // 单引号
            sour = sour.Replace("&#39;", "'");
            sour = sour.Replace("&#43;", "+");
            // 换行符,得用正则替换
            sour = Regex.Replace(sour, @"\n?<[Bb][Rr]\s*/?>\n?", "\n");
            // 双引号,有三种写法
            sour = sour.Replace("&quot;", "\"");
            sour = sour.Replace("&QUOT;", "\"");
            sour = sour.Replace("&#34;", "\"");
            // 空格,只有两种写法, &NBSP; 浏览器不承认
            sour = sour.Replace("&nbsp;", " ");
            sour = sour.Replace("&#160;", " ");
            // 中文引号
            sour = sour.Replace("&ldquo;", "“");
            sour = sour.Replace("&rdquo;", "”");
            // & 符號,最后才转换
            sour = sour.Replace("&amp;", "&");
            sour = sour.Replace("&AMP;", "&");
            sour = sour.Replace("&#38;", "&");
            return sour;
        }

        /// <summary>
        /// 将需要显示的字符串转换成 textarea 显示的字符串
        /// </summary>
        /// <param name="sour">被转换的字符串</param>
        /// <returns>转换后的字符串</returns>
        public static string ToTextarea(this string sour)
        {
            if (string.IsNullOrEmpty(sour)) return "";

            // 以下逐一转换
            sour = sour.Replace("&", "&amp;");
            sour = sour.Replace("<", "&lt;");
            sour = sour.Replace(">", "&gt;");
            return sour;
        }

        /// <summary>
        /// 清理字符串里面的 HTML 标签
        /// </summary>
        /// <param name="sour">被转换的字符串</param>
        /// <returns>转换后的字符串</returns>
        public static string RemoveHtmlTag(this string sour)
        {
            if (string.IsNullOrEmpty(sour)) return "";

            // 清楚注释
            sour = Regex.Replace(sour, @"<!--.*-->", "");
            // </title> 替换成 换行符
            sour = Regex.Replace(sour, @"</[Tt][Ii][Tt][Ll][Ee]>", "\n");
            // <br/> ==> 替换成 换行符
            sour = Regex.Replace(sour, @"<[Bb][Rr]\s*/?>", "\n");
            // </tr> 替换成 换行符
            sour = Regex.Replace(sour, @"</[Tt][Rr]>", "\n");
            // html 标签清除
            sour = Regex.Replace(sour, @"<[^>]+>", "");
            // 将 HTML 格式的字符串转换成正常显示的字符串
            sour = sour.ToText();
            return sour.Trim();
        }
        #endregion

        #region 带版本的web文件路径
        /// <summary>
        /// 是否本地访问(本机及局域网内都返回true,否则返回false)
        /// </summary>
        /// <returns></returns>
        public static bool IsLocal()
        {
            // 防止低级错误
            if (HttpContext.Current == null) throw new Exception("非http请求不可调用此方法");
            var url = HttpContext.Current.Request.Url.OriginalString;
            if (!string.IsNullOrEmpty(url))
            {
                url = url.Trim().ToLower();
                // 本机或局域网的,判断为本地访问
                if (url.StartsWith("http://localhost") || 
                    url.StartsWith("http://127.0.0.") ||
                    url.StartsWith("http://192.168."))
                {
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// 缓存文件的版本
        /// </summary>
        private static Dictionary<string, string> FileVersion = new Dictionary<string, string>();

        /// <summary>
        /// 将虚拟（相对）路径转换为应用程序绝对路径
        /// </summary>
        /// <param name="url">已呈现的页的 URL</param>
        /// <param name="contentPath">内容的虚拟路径</param>
        /// <returns>应用程序绝对路径</returns>
        public static string Content2(this System.Web.Mvc.UrlHelper url, string contentPath)
        {
            // 防止低级错误
            if (url == null || HttpContext.Current == null) throw new Exception("非http请求不可调用此方法");
            if (string.IsNullOrEmpty(contentPath))
            {
                return url.Content(contentPath);
            }
            string lowerUrl = contentPath.ToLower();
            // 给 js 和 css 文件加上版本号
            if (lowerUrl.EndsWith(".js") || lowerUrl.EndsWith(".css"))
            {
                // 读取缓存的(本地的不缓存，以便调试)
                if (FileVersion.ContainsKey(lowerUrl) && IsLocal() == false)
                {
                    return FileVersion[lowerUrl];
                }
                // 将虚拟路径，转换为物理路径
                var path = HttpContext.Current.Server.MapPath(contentPath);
                var file = new System.IO.FileInfo(path);
                // 获取文件的最后修改时间
                var Version = file.LastWriteTime.ToString("yyyyMMddHHmmss");
                if (string.IsNullOrEmpty(Version))
                {
                    return url.Content(contentPath);
                }
                // 生成压缩的js文件
                if (lowerUrl.EndsWith(".js") && !lowerUrl.EndsWith(".min.js"))
                {
                    // 当配置了需要压缩js时，执行压缩。否则保持原文件
                    var needjsMin = Barfoo.Library.Configuration.ConfigurationUtility.AppSettings<int>("JsMin", 0) == 1;
                    if (needjsMin)
                    {
                        // 保存原文件路径,压缩不成功时用原文件
                        var oldContent = contentPath;
                        try
                        {
                            var filePath = file.FullName;
                            // 生成压缩的js文件，结尾为".min.js"，前台访问的是压缩的版本
                            var minName = filePath.Substring(0, filePath.Length - 3) + ".min.js";
                            new JsMin().Minify(filePath, minName);
                            // 压缩成功，用压缩的js文件
                            contentPath = contentPath.Substring(0, contentPath.Length - 3) + ".min.js";
                        }
                        // 文件压缩会出现异常，这时候用回原文件
                        catch
                        {
                            contentPath = oldContent;
                        }
                    }
                }
                // 给文件加上版本号
                var newPath = url.Content(contentPath + "?" + Version);
                // 缓存起来
                FileVersion[lowerUrl] = newPath;
                return newPath;
            }
            return url.Content(contentPath);
        }

        /// <summary>
        /// 将虚拟（相对）路径转换为应用程序绝对路径
        /// </summary>
        /// <param name="url">已呈现的页的 URL</param>
        /// <param name="contentPath">内容的虚拟路径</param>
        /// <param name="Version">版本号</param>
        /// <returns>应用程序绝对路径</returns>
        public static string Content2(this System.Web.Mvc.UrlHelper url, string contentPath, string Version)
        {
            // 防止低级错误
            if (url == null) throw new Exception("非网页请求不可调用此方法");
            if (string.IsNullOrEmpty(contentPath) || string.IsNullOrEmpty(Version))
            {
                return url.Content(contentPath);
            }
            string cUrl = contentPath.ToLower();
            // 给 js 和 css 文件加上版本号
            if (cUrl.EndsWith(".js") || cUrl.EndsWith(".css"))
            {
                contentPath += "?" + Version;
            }
            return url.Content(contentPath);
        }
        #endregion

    }
}
