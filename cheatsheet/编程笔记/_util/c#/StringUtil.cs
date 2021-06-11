//2011/01/15 dennis 加入取得設定內容方法 1247-1385
//version 0.1
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
using System.Collections.Generic;

namespace Com.Everunion.Util
{
    /// <summary>
    /// 函數傳回值
    /// </summary>
    public class ReturnData
    {
        public const int Fail = -1;
        public const int Exists = 1;
        public const int Succ = 0;
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
            if ( str != null && str.Length > 0 )
                return str.Trim();
            //傳回預設
            else
                return init;
        }


        //2010/04/12 holer add 按作業名稱的傳回值轉換成訊息 start
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
            //成功訊息
            else if ( ReturnData.Succ == returnValue )
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
        //2010/04/12 holer end


        /// <summary>
        /// 提示訊息
        /// </summary>
        /// <param name="response">回應物件</param>
        /// <param name="mess">訊息</param>
        /// <returns> 提示訊息</returns>
        public static void AlertMessage(string mess)
        {
            //標題
            string title = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">";
            HttpResponse response = HttpContext.Current.Response;
            mess = mess.Replace("'", "&#39;");
            response.Write(title + "<script defer language='javascript' type='text/javascript'>alert('" + mess + "!')</script>");
        }


        /// <summary>
        /// 提示訊息
        /// </summary>
        /// <param name="response">回應物件</param>
        /// <param name="mess">訊息</param>
        /// <param name="method">方法</param>
        /// <returns> 提示訊息</returns>
        public static void AlertMessage(string mess, string method)
        {
            //標題
            string title = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">";
            HttpResponse response = HttpContext.Current.Response;
            mess = mess.Replace("'", "&#39;");
            response.Write(title + "<script defer language='javascript' type='text/javascript'>alert('" + mess + "!');" + method + "</script>");
        }


        //2010/05/15 holer add 按作業名稱的傳回值提示訊息 start
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
            //操作成功
            else if ( ReturnData.Succ == rd )
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
        //2010/05/15 holer end


        //2010/05/17 holer add 按作業名稱的傳回值提示訊息方法2 start
        //跟 AlertMessage(dataName, actionName, rd) 方法不同的是傳回值的比較，這裡：(大於等於1:成功,0:主鍵相同,-1失敗)
        /// <summary>
        /// 提示訊息
        /// </summary>
        /// <param name="actionName">作業名稱(如：新增、修改、刪除等，預設為"作業")</param>
        /// <param name="dataName">資料主鍵名稱</param>
        /// <param name="rd">結果狀態</param>
        /// <returns> 提示訊息</returns>
        public static void Alert(string actionName, string dataName, int rd)
        {
            //如果傳回值不合法，提示如下訊息
            string mess = "操作出錯,請聯繫管理員";
            //作業名稱(如：新增、修改、刪除等，預設為"作業")
            actionName = String.IsNullOrEmpty(actionName) ? "作業" : actionName;
            //資料主鍵名稱,預設為"資料"
            dataName = String.IsNullOrEmpty(dataName) ? "資料" : dataName;
            //主鍵重複
            if ( 0 == rd )
            {
                mess = "已經存在相同的 " + dataName + ", " + actionName + "失敗";
            }
            //操作成功
            else if ( rd >= 1 )
            {
                mess = actionName + "成功";
            }
            //操失敗
            else if ( -1 == rd )
            {
                mess = actionName + "失敗";
            }
            AlertMessage(mess);
        }
        //2010/05/17 holer end


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


        //2010/06/05 dennis add 加入ToEqualsSqlStr方法
        /// <summary>
        /// 過濾模糊查詢關鍵字符，并過濾單引號
        /// </summary>
        /// <param name="val">字串</param>
        /// <returns>處理了'\','''等</returns>
        public static string ToEqualsSqlStr(String val)
        {
            return ToSqlStr(val).Replace(@"\", @"\\");
        }
        //2010/06/05 dennis end


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
            if ( filterSql )
            {
                str = ToSqlStr(o);
            }
            //不過濾＇
            else
            {
                str = ToStr(o);
            }
            //2010/05/27 holer 修改轉義符,增加“\”的轉義,刪除“[”的轉義; “%”和“_”不讓匹配; 換成空格做匹配符號
            //MySQL
            if ( HibernateHelper.Dialect.GetType().FullName.IndexOf("MySQLDialect") > -1 )
            {
                return str.Replace(@"\", @"\\\\").Replace("%", @"\%").Replace("_", @"\_").Replace(" ", @"%");
            }
            //2010/05/27 holer end
            //SqlServer2000
            else if ( HibernateHelper.Dialect.GetType().FullName.IndexOf("MsSql2000Dialect") > -1 )
            {
                return str.Replace("[", @"[[]").Replace("%", @"[%]").Replace("_", @"[_]");
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
            if ( paramObj == null )
            {
                return;
            }
            //屬性
            PropertyInfo[] propertys = paramObj.GetType().GetProperties();
            //取參數
            foreach ( PropertyInfo p in propertys )
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
        /// 取得參數
        /// </summary>
        /// <typeparam name="key">參數的鍵</typeparam>
        /// <returns>該鍵的值</returns>"Id:WareId","Oid:id"
        public static string GetParamValue(string key)
        {
            if ( HttpContext.Current == null )
                throw new Exception("非http請求不可呼叫此函數");
            //HTTP伺服器請求
            HttpRequest request = HttpContext.Current.Request;

            string value = ToStr(request.Form[key]);
            //如果能取得值,傳回
            if ( !string.IsNullOrEmpty(value) )
                return value;

            //如果form取不到
            value = ToStr(request.Params[key]);
            //如果能取得值,並且不是多個值,傳回
            if ( !string.IsNullOrEmpty(value) && value.IndexOf(",") < 0 )
                return value;

            //如果這值有多個
            if ( value.IndexOf(",") >= 0 )
            {
                string[] values = value.Split(',');
                for ( int i = 0; i < values.Length; i++ )
                {
                    if ( !string.IsNullOrEmpty(values[i]) )
                        return values[i];
                }
            }

            //取不到時
            return "";
        }


        /// <summary>
        /// 參數設定
        /// </summary>
        /// <typeparam name="T">傳回的類型</typeparam>
        /// <param name="type">實作類型</param>
        /// <param name="request">HTTP伺服器請求</param>
        /// <returns>該類型實作</returns>"Id:WareId","Oid:id"
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
                                pi.SetValue(obj, Convert.ToSByte(GetParamValue(StringUtil.ToStr(ht[pi.Name], pi.Name))), null);
                                break;
                            case "System.Byte":
                                pi.SetValue(obj, Convert.ToByte(GetParamValue(StringUtil.ToStr(ht[pi.Name], pi.Name))), null);
                                break;
                            case "System.String":
                                pi.SetValue(obj, StringUtil.ToStr(GetParamValue(StringUtil.ToStr(ht[pi.Name], pi.Name))), null);
                                break;
                            //時間
                            case "System.DateTime":
                                pi.SetValue(obj, StringUtil.ToDateForStr(GetParamValue(StringUtil.ToStr(ht[pi.Name], pi.Name))), null);
                                break;
                            case "System.Int16":
                                pi.SetValue(obj, StringUtil.ToShort(GetParamValue(StringUtil.ToStr(ht[pi.Name], pi.Name))), null);
                                break;
                            case "System.Int32":
                                pi.SetValue(obj, StringUtil.ToInt(GetParamValue(StringUtil.ToStr(ht[pi.Name], pi.Name))), null);
                                break;
                            //長整形
                            case "System.Int64":
                                pi.SetValue(obj, StringUtil.ToLong(GetParamValue(StringUtil.ToStr(ht[pi.Name], pi.Name))), null);
                                break;
                            case "System.Single":
                                pi.SetValue(obj, StringUtil.toFloat(GetParamValue(StringUtil.ToStr(ht[pi.Name], pi.Name))), null);
                                break;
                            case "System.Double":
                                pi.SetValue(obj, StringUtil.toDouble(GetParamValue(StringUtil.ToStr(ht[pi.Name], pi.Name))), null);
                                break;
                            //decimal
                            case "System.Decimal":
                                pi.SetValue(obj, StringUtil.toDecimal(GetParamValue(StringUtil.ToStr(ht[pi.Name], pi.Name))), null);
                                break;
                            default:
                                //log.Error("沒有取到參數:" + pi.PropertyType.ToString());
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
        /// <param name="init">預設資料</param>
        /// <returns>轉換后的資料</returns>
        public static decimal toDecimal(object o, decimal init)
        {
            try
            {
                //轉換
                return Convert.ToDecimal(ToStr(o, "" + init));
            }
            catch
            {
                //格式錯誤
                return init;
            }
        }


        /// <summary>
        /// 轉成Decimal型
        /// </summary>
        /// <param name="o">待轉換之資料</param>
        /// <returns>轉換后的資料</returns>
        public static decimal toDecimal(object o)
        {
            return toDecimal(o, 0);
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
            if ( str != null && str.Length > 0 )
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


        //2010/07/26 holer add 將日期字串轉換成公元日期 start
        /// <summary>
        /// 將日期字串轉換成公元日期
        /// </summary>
        /// <param name="date">待轉日期</param>
        /// <returns>公元日期</returns>
        public static string ToGYDateStr(object Date)
        {
            string[] dates = new string[3];
            string date = StringUtil.ToStr(Date);
            string defaultDate = DateTime.Now.ToString(@"yyyy\/MM\/dd");

            //沒有日期時,傳回當天
            if ( string.IsNullOrEmpty(date) )
                return defaultDate;

            //6位數字,則認為前兩位是年份(認為是民國日期)
            //7位數字,則認為前三位是年份(認為是民國日期)
            //8位數字,則認為前四位是年份(認為是公元日期)
            if ( Regex.IsMatch(date, "^[0-9]{6,8}$") )
            {
                dates[0] = date.Substring(0, date.Length - 4);
                dates[1] = date.Substring(date.Length - 4, 2);
                dates[2] = date.Substring(date.Length - 2, 2);
            }
            //有分隔符的日期
            else if ( Regex.IsMatch(date, "^[0-9]{2,4}[年/-][0-9]{1,2}[月/-][0-9]{1,2}[日]?$") )
            {
                //分割
                if ( date.IndexOf("/") >= 0 )
                    dates = date.Split('/');
                else if ( date.IndexOf("-") >= 0 )
                    dates = date.Split('-');
                else
                {
                    dates[0] = date.Split('年')[0];
                    dates[1] = date.Split('年')[1].Split('月')[0];
                    dates[2] = date.Split('月')[1].Split('日')[0];
                }
            }
            //以上都不是時,傳回當天
            else
            {
                return defaultDate;
            }

            //如果年份不足4位,認為是民國日期
            if ( dates[0].Length < 4 )
                dates[0] = "" + (int.Parse(dates[0]) + 1911);
            //如果月份只有一位
            if ( dates[1].Length == 1 )
                dates[1] = "0" + dates[1];
            //如果日只有一位
            if ( dates[2].Length == 1 )
                dates[2] = "0" + dates[2];

            //傳回
            return dates[0] + "/" + dates[1] + "/" + dates[2];
        }
        //2010/07/26 holer end



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
        /// 執行js函數
        /// </summary>
        /// <param name="response">回應物件</param>
        /// <param name="mess">訊息</param>
        public static void callJsFunction(string jsFunction)
        {
            HttpResponse response = HttpContext.Current.Response;
            response.Write("<script defer language='javascript'>" + jsFunction + "</script>");
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


        /// <summary>
        /// 取銀行賬戶類別
        /// </summary>
        /// <param name="id">id</param>
        /// <param name="checkType">驗證類型</param>
        /// <param name="mess">驗證信息</param>
        /// <param name="defaultVal">預設值</param>
        /// <returns>SELECT HTMML</returns>
        public static String GetAccountTypeSelectHTML(string id, string checkType, string mess, int defaultVal)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("<SELECT id='" + id + "' name='" + id + "'");
            //驗證
            if ( checkType.Length > 0 )
                sb.Append(" checkType='" + checkType + "' mess='" + mess + "'");
            sb.Append(">");
            //選項
            sb.Append("<option value=''  " + (defaultVal < 1 || defaultVal > 8 ? "selected" : "") + ">請選擇</option>");
            sb.Append("<option value='1' " + (defaultVal == 1 ? "selected" : "") + ">活期存款</option>");
            sb.Append("<option value='2' " + (defaultVal == 2 ? "selected" : "") + ">活期儲蓄</option>");
            sb.Append("<option value='3' " + (defaultVal == 3 ? "selected" : "") + ">定期存款</option>");
            //選項
            sb.Append("<option value='4' " + (defaultVal == 4 ? "selected" : "") + ">支票存款</option>");
            sb.Append("<option value='5' " + (defaultVal == 5 ? "selected" : "") + ">甲存戶</option>");
            sb.Append("<option value='6' " + (defaultVal == 6 ? "selected" : "") + ">非甲存戶</option>");
            //選項
            sb.Append("<option value='7' " + (defaultVal == 7 ? "selected" : "") + ">票貼戶</option>");
            sb.Append("<option value='8' " + (defaultVal == 8 ? "selected" : "") + ">其它</option>");
            sb.Append("</SELECT>");

            //傳回
            return sb.ToString();
        }


        /// <summary>
        /// 刪除檔案
        /// </summary>
        /// <param name="Dir">刪除檔案目錄</param>
        public static void DeleteTempFiles(string Dir)
        {
            //目錄不存在
            if ( !System.IO.Directory.Exists(Dir) )
            {
                System.IO.Directory.CreateDirectory(Dir);
            }
            //目錄存在
            else
            {
                //檔案陣列
                string[] Files = System.IO.Directory.GetFiles(Dir);
                foreach ( string file in Files )
                {
                    //刪除
                    System.IO.File.Delete(file);
                }
            }
        }


        /// <summary>
        /// 是否為日期型字串
        /// </summary>
        /// <param name="strDate">字串(yyyy/MM/dd)</param>
        /// <returns>true:是日期,false:不是日期</returns>
        public static bool IsValidDate(string strDate)
        {
            //空日期
            if ( strDate.Length == 0 )
                return false;
            Regex r = new Regex("^([0-9]+)/([0-9]{1,2})/([0-9]{1,2})$");
            //引用Match
            Match m = r.Match(strDate);
            if ( m.Success )
            {
                Group g = m.Groups[1];
                //取得年
                int year = int.Parse(g.ToString());
                if ( year < 1 || year > 9999 )
                    return false;
                g = m.Groups[2];
                //取得月
                int month = int.Parse(g.ToString());
                if ( month < 1 || month > 12 )
                    return false;
                g = m.Groups[3];
                //取得日
                int day = int.Parse(g.ToString());
                if ( day < 1 || day > DateTime.DaysInMonth(year, month) )
                    return false;
                //引用DateTime
                DateTime dt = new DateTime(year, month, day);
                //年
                if ( dt.Year.ToString() != year.ToString() )
                    return false;
                //月
                if ( dt.Month.ToString() != month.ToString() )
                    return false;
                //日
                if ( dt.Day.ToString() != day.ToString() )
                    return false;
                //操作訊息
                return true;
            }
            //其它
            else
                return false;
        }

        /// <summary>
        /// 獲得售價
        /// </summary>
        public static decimal getPriceByType(string type, decimal quotiety, decimal stdsellprice, decimal bsellprice, decimal csellprice, decimal dsellprice, decimal discfactor)
        {
            decimal price = 0;
            if (type == "A") //一般經銷商
            {
                price = bsellprice*quotiety; //批售價*經銷商係數
            }
            else if (type == "B") //特售經銷商
            {
                price = csellprice*quotiety;//特售價*經銷商係數
            }
            else if (type == "C") //網站客戶
            {
                price = stdsellprice*discfactor;//標準售價*產品折扣係數;
            }
            else if (type == "D") //集團內客戶
            {
                price = dsellprice;//企業售價
            }
            else
            {
                price = stdsellprice;
            }
            return price;
        }


        /// <summary>
        /// 取得分割字串集
        /// </summary>
        /// <param name="source">字串</param>
        /// <param name="split">分割字串陣列</param>
        /// <returns>IList<String> 分割字串集</returns>
        public static IList<String> getSplitList(string source, string[] split)
        {
            //初始化
            IList<String> list = new List<String>();
            try
            {
                //大於零
                if ( ToStr(source).Length > 0 )
                {
                    for ( int i = 0; i < split.Length; i++ )
                    {
                        //查詢
                        if ( source.IndexOf(split[i]) > -1 )
                        {
                            //分割字串
                            string[] array = source.Split(new string[] { split[i] }, StringSplitOptions.None);
                            foreach ( string key in array )
                            {
                                //加入資料
                                list.Add(key);
                            }
                        }
                        //其它
                        else
                        {
                            list.Add(source);
                        }
                    }
                }
            }
            //捕捉例外
            catch ( Exception e )
            {
                log.Error("StringUtil.getSplitStr error:" + e.Message);
            }
            //操作訊息
            return list;
        }

        /// <summary>
        /// 刪除沒有值的參數
        /// </summary>
        /// <param name="source">字串</param>
        public static String handleCondition(string source)
        {
            string retValue = null;
            try
            {
                if (string.IsNullOrEmpty(source))
                {
                    retValue = "";
                }
                else
                {
                    string[] namevalue = source.Split('&');
                    foreach (string temp in namevalue)
                    {
                        string[] tempsplit = temp.Split('=');
                        if (tempsplit.Length == 2)
                        {
                            if (tempsplit[0] != "__VIEWSTATE" && !string.IsNullOrEmpty(tempsplit[1]))
                            {
                                if (retValue == null)
                                {
                                    retValue = temp;
                                }
                                else
                                {
                                    retValue += "&" + temp;
                                }
                            }
                        }
                    }
                }
            }
            //捕捉例外
            catch (Exception e)
            {
                log.Error("handleCondition:" + e.Message);
            }
            //操作訊息
            return retValue;
        }

        public static string DateTimeToUnix(DateTime dt)
        {
            DateTime dtStart = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
            TimeSpan toNow = dt.Subtract(dtStart);
            string timeStamp = toNow.Ticks.ToString();
            timeStamp = timeStamp.Substring(0, timeStamp.Length - 7);
            return timeStamp;
        }

        public static DateTime UnixToDateTime(string timeStamp)
        {
            DateTime dtStart = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
            TimeSpan toNow = new TimeSpan(long.Parse(timeStamp + "0000000"));
            return dtStart.Add(toNow);
        }

        /// <summary>
        /// 读cookie值
        /// </summary>
        /// <param name="strName">名称</param>
        /// <returns>cookie值</returns>
        public static string GetCookie(string name)
        {
            if (HttpContext.Current.Request.Cookies != null && HttpContext.Current.Request.Cookies[name] != null)
            {
                return HttpContext.Current.Request.Cookies[name].Value.ToString();
            }
            return "";
        }

        public static void AddCookie(string name, String value)
        {
            HttpCookie cookie = new HttpCookie(name);
            cookie.Value = value;
            cookie.Expires = DateTime.Now.AddYears(1);
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        public static void RemoveCookie(string name)
        {
            if (HttpContext.Current.Request.Cookies != null && HttpContext.Current.Request.Cookies[name] != null)
            {
                HttpContext.Current.Response.Cookies[name].Expires = DateTime.Now.AddDays(-1);
            }
        }

        public static void ClearCookie()
        {
            HttpCookie aCookie;
            string cookieName;
            int limit = HttpContext.Current.Request.Cookies.Count;
            for (int i = 0; i < limit; i++)
            {
                cookieName = HttpContext.Current.Request.Cookies[i].Name;
                aCookie = new HttpCookie(cookieName);
                aCookie.Expires = DateTime.Now.AddDays(-1);
                HttpContext.Current.Response.Cookies.Add(aCookie);
            }
        }

        public static string mailurl(string email)
        {
            if (DataValidate.IsEmail(email))
            {
                string sufix = email.Substring(email.IndexOf("@") + 1).ToLower();
                if (sufix == "gmail.com")
                {
                    return "https://mail.google.com/";
                }
                else if (sufix == "163.com")
                {
                    return "https://mail.163.com/";
                }
                else if (sufix == "126.com")
                {
                    return "https://mail.126.com/";
                }
                else if (sufix == "qq.com")
                {
                    return "https://mail.qq.com/";
                }
                else if (sufix == "sina.com")
                {
                    return "https://mail.sina.com/";
                }
                else if (sufix == "sohu.com")
                {
                    return "https://mail.sohu.com/";
                }
                else if (sufix == "yahoo.com.cn")
                {
                    return "https://mail.yahoo.com.cn/";
                }
                else if (sufix == "yahoo.com")
                {
                    return "https://mail.yahoo.com/";
                }
                else if (sufix == "everuniontech.com")
                {
                    return "https://mail.google.com/a/everuniontech.com/";
                }                    
                else
                {
                    return null;
                }
            }
            else
            {
                return null;
            }
        }


        //2011/01/15 dennis add 加入取得設定內容方法
        /// <summary>
        /// 取得建立目錄
        /// </summary>
        /// <param name="path">路徑</param>
        /// <returns>String:建立目錄</returns>
        public static String CreateUploadPath(String path)
        {
            //初始化
            string recode = "";
            try
            {
                //取得根目錄
                recode = getUploadPath();
                //沒有預設根目錄
                if ( recode.Length < 1 )
                {
                    recode = HttpContext.Current.Server.MapPath(path);
                }
                //其它
                else
                {
                    recode = recode + path;
                }
                //建立目錄
                if ( !System.IO.Directory.Exists(recode) )
                {
                    System.IO.Directory.CreateDirectory(recode);
                }
            }
            catch
            {
                //初始化
                recode = "";
            }
            //操作訊息
            return recode;
        }



        /// <summary>
        /// 取得儲存圖片路徑
        /// </summary>
        /// <returns>String:儲存圖片路徑</returns>
        public static String getUploadPath()
        {
            return ToStr(ConfigurationSettings.AppSettings["UploadPath"]);
        }



        /// <summary>
        /// 取得真實儲存圖片路徑
        /// </summary>
        /// <param name="path">路徑</param>
        /// <returns>String:真實儲存圖片路徑</returns>
        public static String getRealUploadPath(string path)
        {
            //初始化
            string recode = "";
            try
            {
                //取得路徑
                recode = getUploadPath();
                //不存在設定路徑
                if ( recode.Length < 1 )
                {
                    if ( ToStr(path).Length > 1 )
                        recode = HttpContext.Current.Server.MapPath(path);
                }
                //其它
                else
                {
                    recode = recode + path;
                }
            }
            catch
            {
            }
            //操作訊息
            return recode;
        }


        /// <summary>
        /// 取得上傳最大值
        /// </summary>
        /// <returns>int:上傳最大值(單位k)</returns>
        public static int getUploadFileMaxSize()
        {
            return ToInt(ConfigurationSettings.AppSettings["UploadFileMaxSize"], 1024);
        }


        /// <summary>
        /// 取得上傳最大值
        /// </summary>
        /// <returns>上傳最大值(單位mb)</returns>
        public static int getUploadFileMaxSizeMB()
        {
            return ToInt(ToInt(ConfigurationSettings.AppSettings["UploadFileMaxSize"], 1024) / 1024);
        }


        /// <summary>
        /// 取得上傳格式
        /// </summary>
        /// <returns></returns>
        public static string getUploadFileFormat()
        {
            return ToStr(ConfigurationSettings.AppSettings["UploadFileFormat"], "gif,jpg,bmp,png").ToUpper();
        }


        /// <summary>
        /// 取得上傳格式
        /// </summary>
        /// <param name="path">路徑</param>
        /// <param name="fromVal">要取代字串</param>
        /// <param name="toVal">被取代字串</param>
        /// <returns></returns>
        public static string getReplaceFilePath(string path, string fromVal, string toVal)
        {
            //初始化
            string recode = "";
            try
            {
                //取代
                recode = path.Replace("\\" + fromVal + "\\", "\\" + toVal + "\\");
                recode = recode.Replace("/" + fromVal + "/", "/" + toVal + "/");
            }
            catch
            {
            }
            //操作訊息
            return recode;
        }
        //2011/01/15 dennis end 
    }
}
