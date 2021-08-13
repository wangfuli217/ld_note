/**
 * <P> Title: pili                          </P>
 * <P> Description: 公用函數                </P>
 * <P> Copyright: Copyright (c) 2009/4/2    </P>
 * <P> Company:Everunion Tech. Ltd.         </P>
 * @author Andy
 * @version 0.4 Original Design from design document.
 */
using System;
using System.Data;
using System.Collections;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Reflection;

using System.Text;


namespace Com.Everunion.Util
{
    /// <summary>
    /// 函數傳回值
    /// </summary>
    public class ReturnData
    {
        public const int Fail = -1;
        public const int Exists = 0;
        public const int Succ = 1;
    }


    /// <summary>
    /// 工具類
    /// </summary>
    public class StringUtil
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(StringUtil));
        /// <summary>
        /// 轉換成字串
        /// </summary>
        /// <param name="o">原資料</param>
        /// <param name="init">預設值</param>
        /// <returns> 轉換后的資料</returns>
        public static string ToStr(object o, String init)
        {
            string str = Convert.ToString(o);
            if (str != null && str.Length > 0)
                return str.Trim();
            //傳回預設
            else
                return init;
        }


        /// <summary>
        /// 傳回值轉換成訊息
        /// </summary>
        /// <param name="actionName">作業名稱(如：新增、修改等，預設為"作業")</param>
        /// <param name="returnValue">傳回值</param>
        /// <returns> 訊息</returns>
        public static string ReturnValue2Mess(string actionName, int returnValue)
        {
            actionName = String.IsNullOrEmpty(actionName) ? "作業" : actionName;
            //資料相同的訊息
            if ( ReturnData.Exists == returnValue )
                return "存在相同的資料," + actionName + "失敗!";
            //失敗訊息
            else if ( ReturnData.Fail == returnValue )
                return actionName + "失敗!";
            //成功訊息(新增時，傳回主鍵，所以會大於1)
            else if ( ReturnData.Succ <= returnValue )
                return actionName + "成功!";
            //無
            else
                return "ReturnData中無此訊息!";
        }


        /// <summary>
        /// 傳回值轉換成訊息
        /// </summary>
        /// <param name="returnValue">傳回值</param>
        /// <returns> 訊息</returns>
        public static string ReturnValue2Mess(int returnValue)
        {
            return ReturnValue2Mess("作業", returnValue);
        }


        /// <summary>
        /// 提示訊息
        /// </summary>
        /// <param name="response">回應物件</param>
        /// <param name="mess">訊息</param>
        /// <returns> 提示訊息</returns>
        public static void AlertMessage(string mess)
        {
            mess = mess.Replace("'", "&#39;");
			callJsFunction("alert('" + mess + "!');");
        }


        /// <summary>
        /// 提示訊息
        /// </summary>
        /// <param name="actionName">作業名稱(如：新增、修改、刪除等，預設為"作業")</param>
        /// <param name="dataName">資料主鍵名稱</param>
        /// <param name="rd">結果狀態</param>
        /// <returns> 提示訊息</returns>
        public static void AlertMessage(string actionName, string dataName, int rd)
        {
            string mess = "";
            actionName = String.IsNullOrEmpty(actionName) ? "作業" : actionName;
            dataName = String.IsNullOrEmpty(dataName) ? "資料" : dataName;
            //主鍵重複
            if ( ReturnData.Exists == rd )
            {
                mess = "已經存在相同的 " + dataName + ", " + actionName + "失敗";
            }
            //操失敗
            else if ( ReturnData.Fail == rd )
            {
                mess = actionName + "失敗";
            }
            //操作成功(新增時，傳回主鍵，所以會大於1)
            else if ( ReturnData.Succ <= rd )
            {
                mess = actionName + "成功";
            }
            AlertMessage(mess);
        }



        /// <summary>
        /// 提示訊息
        /// </summary>
        /// <param name="dataName">資料主鍵名稱</param>
        /// <param name="rd">結果狀態</param>
        /// <returns> 提示訊息</returns>
        public static void AlertMessage(string dataName, int rd)
        {
            AlertMessage(null, dataName, rd);
        }


        /// <summary>
        /// 執行js函數
        /// </summary>
        /// <param name="response">回應物件</param>
        /// <param name="mess">訊息</param>
        public static void callJsFunction(string jsFunction)
        {
            HttpResponse response = HttpContext.Current.Response;
            response.Write("<script defer language='javascript' type='text/javascript'>" + jsFunction + "</script>");
        }


        /// <summary>
        /// 轉從合法的SQLCommand
        /// </summary>
        /// <param name="o">原字串</param>
        /// <returns>SQLCommand</returns>
        public static string ToSqlStr(String o)
        {
            string str = ToStr(o);
            return str.Replace("'", "''");
        }


        /// <summary>
        /// 過濾模糊查詢關鍵字符，并過濾單引號
        /// </summary>
        /// <param name="o">次序參數</param>
        /// <returns>處理了'%','['等</returns>
        public static string ToLikeSqlStr(String o)
        {
            return ToLikeSqlStr(o, true);
        }


        /// <summary>
        /// 轉成合法的SQLCommand
        /// </summary>
        /// <param name="o">原字串</param>
        /// <param name="filterSql">為True時過濾單引號（'）</param>
        /// <returns>SQLCommand</returns>
        public static string ToLikeSqlStr(String o, bool filterSql)
        {
            string str;
            //過濾＇
            if (filterSql)
            {
                str = ToSqlStr(o);
            }
            //不過濾＇
            else
            {
                str = ToStr(o);
            }
            //MySQL
            if ( HibernateHelper.Dialect.GetType().FullName.IndexOf("MySQLDialect") > -1 )
            {
                return str.Replace("%", @"\%").Replace("_", @"\_").Replace("[", @"\[");
            }
            //SqlServer2000
            else if ( HibernateHelper.Dialect.GetType().FullName.IndexOf("MsSql2000Dialect") > -1 )
            {
                return str.Replace("%", @"[%]").Replace("_", @"[_]").Replace("[", @"[[]");
            }
            //其他，待完成
            else
            {
                return str.Replace("%", "").Replace("_", @"").Replace("[", @"");
            }
        }


        /// <summary>
        /// 設定表單資料
        /// </summary>
        /// <param name="paramObj">參數物件</param>
        /// <param name="destObj">表單物件</param>
        public static void SetPageValue(Object paramObj, Object destObj)
        {
            //無資料
            if (paramObj == null)
            {
                return;
            }
            //屬性
            PropertyInfo[] propertys = paramObj.GetType().GetProperties();
            //取參數
            foreach (PropertyInfo p in propertys)
            {
                string name = p.Name.ToString();
                FieldInfo destField = destObj.GetType().GetField(name, BindingFlags.Instance | BindingFlags.NonPublic);
                if ( destField != null )
                {
                    PropertyInfo destPro1 = destField.FieldType.GetProperty("SelectedValue");
                    PropertyInfo destPro2 = destField.FieldType.GetProperty("Text");
                    PropertyInfo destPro3 = destField.FieldType.GetProperty("Value");
                    //radio或checkbox
                    if ( destPro1 != null )
                    {
                        destPro1.SetValue(destField.GetValue(destObj), ToStr(p.GetValue(paramObj, null)), null);
                    }
                    //text
                    else if ( destPro2 != null )
                    {
                        destPro2.SetValue(destField.GetValue(destObj), ToStr(p.GetValue(paramObj, null)), null);
                    }
                    //hidden
                    else if ( destPro3 != null )
                    {
                        destPro3.SetValue(destField.GetValue(destObj), ToStr(p.GetValue(paramObj, null)), null);
                    }
                }
            }
        }


        /// <summary>
        /// 參數設定
        /// </summary>
        /// <typeparam name="T">傳回的類型</typeparam>
        /// <param name="type">實例類型</param>
        /// <param name="request">HTTP伺服器請求</param>
        /// <returns>該類型實例</returns>"Id:WareId","Oid:id"
        public static T GetInstanceByParam<T>(Type type, params String[] aliasArray)
        {
            if ( HttpContext.Current == null )
                throw new Exception("非http請求不可呼叫此函數");
            //別名
            Hashtable ht = new Hashtable();
            if ( aliasArray != null && aliasArray.Length > 0 )
            {
                //迭代別名
                foreach ( string alias in aliasArray )
                {
                    String[] al = alias.Split(':');
                    ht.Add(al[0], al[1]);
                }
            }
            //HTTP伺服器請求
            HttpRequest request = HttpContext.Current.Request;
            object obj = Activator.CreateInstance(type);
            PropertyInfo[] prop = type.GetProperties();
            //參數

            foreach ( PropertyInfo pi in prop )
            {
                if ( pi.CanWrite )
                {
                    try
                    {
                        switch ( pi.PropertyType.ToString() )
                        {
                            case "System.SByte":
                                pi.SetValue(obj, Convert.ToSByte(request.Form[StringUtil.ToStr(ht[pi.Name], pi.Name)]), null);
                                break;
                            case "System.Byte":
                                pi.SetValue(obj, Convert.ToByte(request.Form[StringUtil.ToStr(ht[pi.Name], pi.Name)]), null);
                                break;
                            case "System.String":
                                pi.SetValue(obj, StringUtil.ToStr(request.Form[StringUtil.ToStr(ht[pi.Name], pi.Name)]), null);
                                break;
                            //時間
                            case "System.DateTime":
                                pi.SetValue(obj, StringUtil.ToDateForStr(request.Form[StringUtil.ToStr(ht[pi.Name], pi.Name)]), null);
                                break;
                            case "System.Int16":
                                pi.SetValue(obj, StringUtil.ToShort(request.Form[StringUtil.ToStr(ht[pi.Name], pi.Name)]), null);
                                break;
                            case "System.Int32":
                                pi.SetValue(obj, StringUtil.ToInt(request.Form[StringUtil.ToStr(ht[pi.Name], pi.Name)]), null);
                                break;
                            //長整形
                            case "System.Int64":
                                pi.SetValue(obj, StringUtil.ToLong(request.Form[StringUtil.ToStr(ht[pi.Name], pi.Name)]), null);
                                break;
                            case "System.Single":
                                pi.SetValue(obj, StringUtil.toFloat(request.Form[StringUtil.ToStr(ht[pi.Name], pi.Name)]), null);
                                break;
                            case "System.Double":
                                pi.SetValue(obj, StringUtil.toDouble(request.Form[StringUtil.ToStr(ht[pi.Name], pi.Name)]), null);
                                break;
                            //decimal
                            case "System.Decimal":
                                pi.SetValue(obj, StringUtil.toDecimal(request.Form[StringUtil.ToStr(ht[pi.Name], pi.Name)]), null);
                                break;
                            default:
                                log.Error("沒有取到參數:" + pi.PropertyType.ToString());
                                break;
                        }
                    }
                    catch
                    {
                    }
                }
            }
            //傳回
            return (T)obj;
        }


        /// <summary>
        /// 轉換成字串
        /// </summary>
        /// <param name="o">原資料</param>
        /// <returns> 轉換后的資料</returns>
        public static string ToStr(object o)
        {
            return ToStr(o, "");
        }


        /// <summary>
        /// 轉成int
        /// </summary>
        /// <param name="o">待轉換之資料</param>
        /// <returns> 轉換后的資料</returns>
        public static int ToInt(object o)
        {
            return ToInt(o, 0);
        }


        // <summary>
        /// 轉成短整形
        /// </summary>
        /// <param name="o">待轉換之資料</param>
        /// <returns> 轉換后的資料</returns>
        public static short ToShort(object o)
        {
            try
            {
                //轉換 
                return Convert.ToInt16(ToStr(o, "0"));
            }
            catch
            {
                //格式錯誤
                return 0;
            }
        }


        // <summary>
        /// 轉成長整形
        /// </summary>
        /// <param name="o">待轉換之資料</param>
        /// <returns> 轉換后的資料</returns>
        public static long ToLong(object o)
        {
            try
            {
                //轉換 
                return Convert.ToInt64(ToStr(o, "0"));
            }
            catch
            {
                //格式錯誤
                return 0;
            }
        }


        // <summary>
        /// 轉成單精度
        /// </summary>
        /// <param name="o">待轉換之資料</param>
        /// <returns> 轉換后的資料</returns>
        public static float toFloat(object o)
        {
            try
            {
                //轉換 
                return Convert.ToSingle(ToStr(o, "0"));
            }
            catch
            {
                //格式錯誤
                return 0;
            }
        }


        // <summary>
        /// 轉成雙精度
        /// </summary>
        /// <param name="o">待轉換之資料</param>
        /// <returns> 轉換后的資料</returns>
        public static double toDouble(object o)
        {
            try
            {
                //轉換 
                return Convert.ToDouble(ToStr(o, "0"));
            }
            catch
            {
                //格式錯誤
                return 0;
            }
        }


        /// <summary>
        /// 轉成Decimal型
        /// </summary>
        /// <param name="o">待轉換之資料</param>
        /// <returns>轉換后的資料</returns>
        public static decimal toDecimal(object o)
        {
            try
            {
                //轉換
                return Convert.ToDecimal(ToStr(o, "0"));
            }
            catch
            {
                //格式錯誤
                return 0;
            }
        }

        /// <summary>
        /// 轉成int
        /// </summary>
        /// <param name="o">待轉換之資料</param>
        /// <param name="init">預設資料</param>
        /// <returns> 轉換后的資料</returns>
        public static int ToInt(object o, int init)
        {
            try
            {
                //轉換 
                return Convert.ToInt32(ToStr(o, "" + init));
            }
            catch
            {
                //格式錯誤
                return init;
            }

        }


        /// <summary>
        /// 判断存在
        /// </summary>
        /// <param name="o">待驗證的參數</param>
        /// <returns>有資料傳回TRUE</returns>
        public static bool Requied(object o)
        {
            string str = ToStr(o);
            //有資料
            if (str != null && str.Length > 0)
                return true;
            else
                return false;
        }


        /// <summary>
        /// 格式化時間到字串
        /// </summary>
        /// <param name="date">待轉時間</param>
        /// <param name="format">時間格式</param>
        /// <returns>格式化后的字串</returns>
        public static string ToStrForDate(string date, string format)
        {
            return ToStrForDate(DateTime.Parse(date), format);
        }


        /// <summary>
        /// 格式化時間到字串
        /// </summary>
        /// <param name="date">待轉時間</param>
        /// <param name="format">時間格式</param>
        /// <returns>格式化后的字串</returns>
        public static string ToStrForDate(DateTime date, string format)
        {
            format = ToStr(format, "d");
            return string.Format("{0:" + format + "}", date);
        }



        /// <summary>
        /// 格式化時間到字串
        /// </summary>
        /// <param name="dateStr">待轉時間</param>
        /// <returns>格式化后的字串</returns>
        public static DateTime ToDateForStr(string dateStr)
        {
            return Convert.ToDateTime(dateStr);
        }


        /// <summary>
        /// 格式納秒時間到字串
        /// </summary>
        /// <param name="ticks">納秒</param>
        /// <param name="format">時間格式</param>
        /// <returns>格式化后的字串<</returns>
        public static string ToLongForDate(long ticks, string format)
        {
            return (new DateTime(ticks)).ToString(format);
        }


        /// <summary>
        /// 格式納秒時間到字串
        /// </summary>
        /// <param name="ticks">納秒</param>
        /// <returns>格式化后的字串<</returns>
        public static string ToLongForDate(long ticks)
        {
            return ToLongForDate(ticks, "yyyy/MM/dd hh:mm");
        }


        /// <summary>
        /// 格式納秒時間到字串
        /// </summary>
        /// <param name="ticks">納秒字串</param>
        /// <returns>格式化后的字串<</returns>
        public static string ToLongForDate(string ticks)
        {
            return ToLongForDate(ToLong(ticks), "yyyy/MM/dd hh:mm");
        }



        /// <summary>
        /// MD5加密
        /// </summary>
        /// <param name="o">原資料</param>
        /// <returns>加密結果</returns>
        public static string ToStrByMD5(object o)
        {
            string str = ToStr(o);
            //不為空才加密
            if ( str.Length > 0 )
                return System.Web.Security.FormsAuthentication.
                    HashPasswordForStoringInConfigFile(str, "MD5");
            else
                return "";
        }


        /// <summary>
        /// 取得時間差
        /// </summary>
        /// <param name="begin">開始納秒</param>
        /// <param name="end">結束納秒</param>
        /// <returns>格式化后的字串</returns>
        public static string ToTimeSpan(long begin, long end)
        {
            //操作訊息
            string recode = "";
            TimeSpan ts = new TimeSpan(end - begin);
            //天
            if ( ts.Days > 0 )
            {
                recode += ts.Days + "天 ";
            }
            //小時
            if ( ts.Hours > 0 )
            {
                recode += ts.Hours + "小時 ";
            }
            //分
            if ( ts.Minutes > 0 )
            {
                recode += ts.Minutes + "分 ";
            }
            //秒
            if ( ts.Seconds > 0 )
            {
                recode += ts.Seconds + "秒 ";
            }
            //操作訊息
            return recode;
        }


        /// <summary>
        /// 取得時間差
        /// </summary>
        /// <param name="begin">開始納秒字串</param>
        /// <param name="end">結束納秒字串</param>
        /// <returns>格式化后的字串</returns>
        public static string ToTimeSpan(string begin, string end)
        {
            return ToTimeSpan(ToLong(begin), ToLong(end));
        }


        /// <summary>
        /// 驗證EMAIL
        /// </summary>
        /// <param name="email">待驗證的EMAIL</param>
        /// <returns>合法傳回true</returns>
        public static bool ValidateEmail(string email)
        {
            Match m = Regex.Match(email, "\\w+([-+.\']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*");
            //傳回結果
            return m.Success;
        }


        /// <summary>
        /// 日期轉納秒字串
        /// </summary>
        /// <param name="date">日期(yyyy/mm/dd)</param>
        /// <returns>納秒字串</returns>
        public static long ToTicks(string date)
        {
            DateTime dt = Convert.ToDateTime(date);
            return dt.Ticks;
        }


        /// <summary>
        /// 驗證 Sql Injection
        /// </summary>
        /// <param name="inputs">輸入字符</param>
        /// <returns>True表示存在關鍵字</returns>
        public static bool SqlValidate(string inputs)
        {
            /*
           "要求驗證偵測到具有潛在危險的用戶端輸入值，對這個要求的處理已經中止。", _
           "具有潛在危險 "& RequestType &" 的值已從用戶端"&key&"="& Server.UrlEncode(Collection(key)) &"偵測到。" & _
           "這個值可能表示有人嘗試危害應用程式的安全性，例如SQL的注入攻擊。我們強烈建議您的應用程式應該明確地檢查所有這類的輸入。"
            */
            //參照include/module/config.asp
            string pattern = @"\s*select\s+|\s*update\s+|\s*insert\s+|\s*delete\s+|\s*drop\s+|and\s+\d+=\d+|\s*sp_|\s*declare\s+|\s*(Exec|Char|Cast|Convert)\s*\(";
            if ( Regex.Match(inputs, pattern, RegexOptions.IgnoreCase).Success )
                return true;
            else
                return false;
        }


        /// <summary>
        /// 過濾html標簽和JS
        /// </summary>
        /// <param name="str">待過濾資料</param>
        /// <returns>編碼后的結果</returns>
        public static String ToHtml(string str)
        {
            //該表達式待改進";
            string pattern = @"<([\s]*?/?[\s]*?(meta|iframe|script|frame|style|embed|object)[\s\S]*?/?[\s]*?)>";
            string destination = "&lt;$1&gt;";
            return Regex.Replace(Regex.Replace(Regex.Replace(str, @"(>?[^<]*?)>", "$1&gt;"), @"<([^>]*?<?)", "&lt;$1"), pattern, destination, RegexOptions.IgnoreCase);
            //return Regex.Replace(str, pattern, destination, RegexOptions.IgnoreCase);
        }



        /// <summary>
        /// 取得流水號前的日期字串
        /// </summary>
        /// <returns></returns>
        public static String GetNowaDateInSerial()
        {
            return DateTime.Now.ToString("yyMMdd");
        }
    }
}
