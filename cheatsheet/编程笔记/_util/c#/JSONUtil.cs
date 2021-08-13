/**
 * <P> Title: pops                      	</P>
 * <P> Description: JSON工具類          	</P>
 * <P> Copyright: Copyright (c) 2009-05-06	</P>
 * <P> Company:Everunion Tech. Ltd.         </P>
 * @author andy
 * @version 0.6 Original Design from design document.
*/
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using Com.Everunion.Util;
using System.Web;
using System.Text.RegularExpressions;

namespace Com.Everunion.Util
{
    /// <summary>
    /// 資料交換工具類
    /// </summary>
    public class JSONUtil
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(JSONUtil));
        /// <summary>
        /// IDictionary到Json
        /// </summary>
        /// <param name="map">資料</param>
        /// <param name="fieldNames">序列化的欄位,可用別名方式,如{"ID:Comid","OID:Depid"}</param>
        /// <returns>序列化結果</returns>
        public static String Map2Json(IDictionary map, params String[] fieldNames)
        {
            if ( map.Count < 1 )
                return "{}";
            //初始化
            StringBuilder sb = new StringBuilder(map.Count << 4);
            sb.Append('{');
            String[] keyArray = null;
            //指定了欄位
            if ( fieldNames != null && fieldNames.Length > 0 )
            {
                keyArray = fieldNames;
            }
            else
            {
                //全部欄位
                keyArray = new String[map.Keys.Count];
                map.Keys.CopyTo(keyArray, 0);
            }
            //迭代
            foreach ( String key in keyArray )
            {
                //2009/05/09 jackter 加入用別名訪問
                //別名
                String key_alias = key;
                String key_column = key;
                //別名用:隔開,前為別名,後為欄位名
                if ( key.IndexOf(":") > -1 )
                {
                    key_column = key.Substring(0, key.IndexOf(":")).Trim();
                    key_alias = key.Substring(key.IndexOf(":") + 1).Trim();
                }
                //2009/05/09 jackter end

                //非第一筆
                if ( sb.Length > 1 )
                    sb.Append(",");

                String value = map[key_column] as string;
                sb.Append(key_alias + ":" + String2Json(value));
            }
            sb.Append('}');
            //傳回
            return sb.ToString();
        }


        /// <summary>
        /// Object到Json
        /// </summary>
        /// <param name="o">資料</param>
        /// <param name="fieldNames">序列化的欄位,可用別名方式,如{"Comid:ID","Depid:OID"}</param>
        /// <returns>序列化結果</returns>
        public static string Object2Json(Object o, params String[] fieldNames)
        {
            //無資料
            if ( o == null )
            {
                return "{}";
            }
            StringBuilder sb = new StringBuilder();
            //屬性
            PropertyInfo[] propertys = o.GetType().GetProperties();
            //開始
            sb.Append("{");

            //有指定欄位
            if ( fieldNames != null && fieldNames.Length > 0 )
            {
                //此屬性在輸出列表中
                foreach ( string field in fieldNames )
                {
                    string key_alias = field;
                    string key_column = field;
                    //存在別名
                    if ( field.IndexOf(":") > -1 )
                    {
                        key_column = field.Substring(0, field.IndexOf(":")).Trim();
                        key_alias = field.Substring(field.IndexOf(":") + 1).Trim();
                    }

                    //屬性名稱正確
                    foreach ( PropertyInfo p in propertys )
                    {
                        //欄位名稱相同
                        if ( key_column.Equals(p.Name) )
                        {
                            //非第一筆
                            if ( sb.Length > 1 )
                                sb.Append(",");
                            //根據類型抓資料
                            if ( p.CanRead )
                                sb.Append(key_alias + ":" + GetValue(p, o).ToString());
                            break;
                        }
                    }
                }
            }
            //沒有指定欄位
            else
            {
                foreach ( PropertyInfo p in propertys )
                {
                    //非第一筆
                    if ( sb.Length > 1 )
                        sb.Append(",");
                    //根據類型抓資料
                    if ( p.CanRead )
                        sb.Append(p.Name + ":" + GetValue(p, o).ToString());
                }
            }
            //結尾
            sb.Append("}");
            //傳回
            return sb.ToString();
        }


        /// <summary>
        /// List到Json
        /// </summary>
        /// <typeparam name="T">類型</typeparam>
        /// <param name="list">List</param>
        /// <param name="fieldNames">序列化的欄位</param>
        /// <returns>序列化結果</returns>
        public static string List2Json<T>(IList<T> list, params String[] fieldNames)
        {
            //有資料
            if ( list == null || list.Count < 1 )
            {
                return "[]";
            }
            //初始化
            StringBuilder sb = new StringBuilder();
            sb.Append("[");
            foreach ( T o in list )
            {
                //非第一筆
                if ( sb.Length > 1 )
                    sb.Append(",");
                //非Hashtable類型
                if ( !typeof(Hashtable).Equals(o.GetType()) )
                {
                    sb.Append(Object2Json(o, fieldNames));
                }
                else
                {
                    //Hashtable
                    sb.Append(Map2Json(o as Hashtable, fieldNames));
                }
            }
            sb.Append("]");
            //傳回
            return sb.ToString();
        }


        /// <summary>
        /// 取屬性值
        /// </summary>
        /// <param name="p">屬性</param>
        /// <param name="o">物件</param>
        /// <returns>值</returns>
        private static object GetValue(PropertyInfo p, Object o, params String[] fieldNames)
        {
            try
            {
                //不存在此屬性
                if ( p == null )
                {
                    return "\"\"";
                }
                //存在此屬性
                else
                {
                    switch ( p.PropertyType.ToString() )
                    {

                        //整形
                        case "System.SByte":
                        case "System.Byte":
                        case "System.Int16":
                        case "System.Int32":
                        case "System.Int64":
                        case "System.Single":
                        case "System.Double":
                        case "System.Decimal":
                        // 字串
                        case "System.String":
                            return String2Json(StringUtil.ToStr(p.GetValue(o, null)));
                            break;
                        //浮點
                        case "System.Boolean":
                            return p.GetValue(o, null).ToString().ToLower();
                            break;
                        // 時間
                        case "System.DateTime":
                            return "\"" + Convert.ToDateTime(p.GetValue(o, null)).ToString("yyyy/MM/dd hh:mm:ss") + "\"";
                            break;
                        //System.String
                        default:
                            if ( p.PropertyType.ToString().StartsWith("Com.Everunion.") )
                            {
                                return Object2Json(p.GetValue(o, null), fieldNames);
                            }
                            else
                            {
                                return "\"\"";
                            }
                            break;
                    }
                }
            }
            //例外
            catch ( Exception e )
            {
                log.Error("PropertyInfo.Name:" + p.Name + "\nPropertyInfo.GetValue()" + p.GetValue(o, null) + "\nErrormess" + e.Message);
                throw e;
            }
        }


        //2009/06/02 andy start 序列化List到JqGrid
        /// <summary>
        /// 序列化List到JqGrid
        /// </summary>
        /// <typeparam name="T">類型</typeparam>
        /// <param name="list">資料</param>
        /// <param name="idFieldName">主鍵</param>
        /// <param name="detailFields">明細,見example</param>
        /// <returns>符合JqGrid的JSON資料</returns>
        /// <example><![CDATA[
        /// string jqGridStr = List2JqGrid<Member>(MeberService.GetInstance().SelectMember(new Member(),true),
        ///          "Oid","Id","Name","Id(Name):IdName","Department.Id:DeptId",Deptname.Name:DeptName",
        ///          "Department.Id(Name):DepIdName");
        /// ]]>
        /// </example>
        public static String List2JqGrid<T>(IList<T> list, String idFieldName, params string[] detailFields)
        {
            StringBuilder sb = new StringBuilder();
            if ( list != null )
            {
                //迭代
                foreach ( T m in list )
                {
                    if ( sb.Length > 0 )
                        sb.Append(",");
                    String[] idAsArr = idFieldName.Split(':');
                    string idAs = "Oid";
                    //存在別名
                    if ( idAsArr.Length == 2 )
                        idAs = idAsArr[1];
                    //ID欄位
                    sb.Append("{" + idAs + ":" + GetValue(m.GetType().GetProperty(idAsArr[0]), m).ToString() + ",");
                    for ( int index = 0; index < detailFields.Length; index++ )
                    {
                        if ( index > 0 )
                            sb.Append(",");

                        //2009/06/22 dennis add 加入取得多個值
                        int pos = detailFields[index].IndexOf('(');
                        //取得位置碼
                        int end = detailFields[index].LastIndexOf(")");
                        //2009-06-23 Jackter add 修改內部實體類取值
                        //含有"()"
                        if ( pos > -1 && end > -1 )
                        {

                            //取得欄位名稱
                            string key = detailFields[index].Substring(0, pos);
                            string id = detailFields[index].Substring(pos + 1, end - pos - 1);

                            //別名以':'隔開,無指定時取key為別名
                            string alia = key;
                            int alia_pos = detailFields[index].LastIndexOf(':');
                            //別名
                            if ( alia_pos > -1 )
                            {
                                alia = detailFields[index].Substring(alia_pos + 1, detailFields[index].Length - alia_pos - 1);
                            }


                            //內部實體類以'.'號隔開
                            int inner_pos = key.IndexOf('.');
                            //含有內部類
                            if ( inner_pos > -1 )
                            {
                                //實體類名稱
                                string detail_class = key.Substring(0, inner_pos);
                                //key
                                key = key.Substring(inner_pos + 1, key.Length - inner_pos - 1);
                                //別名
                                if ( alia_pos == -1 )  alia = key;
                                //params
                                String[] detail_class_field = new String[]{ key,id };
                                //結果
                                string str = GetValue(m.GetType().GetProperty(detail_class), m, detail_class_field).ToString();
                                //去除首尾"{}"符號
                                str = str.Substring(1, str.Length - 2);
                                string key_value = "";
                                string id_value = "";
                                //分解
                                foreach ( string astr in str.Split(',') )
                                {
                                    int st = astr.IndexOf(':');
                                    int sg = astr.IndexOf('"');
                                    string astr_i = astr.Substring(st + 1, astr.Length - st - 1);
                                    //key
                                    if ( astr.IndexOf(key + ":") > -1 )
                                    {
                                        //有'"'
                                        if ( sg > -1 )
                                            key_value = astr_i.Substring(1, astr_i.Length - 2);
                                        else
                                            key_value =  astr_i;
                                    }
                                    //id
                                    else if ( astr.IndexOf(id +":") > -1 )
                                    {
                                        //有'"'
                                        if ( sg > -1 )
                                            id_value = "(" + astr_i.Substring(1, astr_i.Length - 2) + ")";
                                        else
                                            id_value = "(" + astr_i + ")";
                                    }
                                }
                                //明細欄位
                                sb.Append(alia + ":\"" + key_value + id_value + "\"");

                            }
                            //普通屬性
                            else
                            {
                                //字串
                                string ss = GetValue(m.GetType().GetProperty(key), m, null).ToString();
                                if ( ss.IndexOf('"') > -1 )
                                {
                                    ss = ss.Substring(0, ss.Length - 1);
                                }
                                //字串
                                string str = GetValue(m.GetType().GetProperty(id), m, null).ToString();
                                if ( str.IndexOf('"') > -1 )
                                {
                                    str = str.Substring(1, str.Length - 2);
                                }
                                //明細欄位
                                sb.Append(alia + ":" + ss + "(" + str + ")\"");
                            }
                        }
                        //不含有'()'
                        else
                        {
                            string detail_class = detailFields[index];
                            String detail_class_field = null;
                            pos = detailFields[index].IndexOf('.');
                            //指定內部實體類具體字段
                            if ( pos > -1 )
                            {
                                detail_class = detailFields[index].Substring(0, pos);
                                detail_class_field = detailFields[index].Substring(pos + 1,detailFields[index].Length - detail_class.Length - 1);

                                string str = GetValue(m.GetType().GetProperty(detail_class), m, detail_class_field).ToString();
                                str = str.Substring(1, str.Length - 2);
                                //為空
                                if ( str.Length == 0 )
                                {
                                    sb.Append(detail_class_field.Split(':')[detail_class_field.Split(':').Length - 1] + ":\"\"");
                                }
                                else
                                    sb.Append(str);
                            }
                            //普通屬性
                            else
                            {
                                string alia_key = detail_class;
                                //含有別名
                                if ( detail_class.IndexOf(':') > -1 )
                                {
                                    alia_key = detail_class.Split(':')[1];
                                    detail_class = detail_class.Split(':')[0];
                                }
                                //輸出
                                sb.Append( alia_key + ":" + GetValue(m.GetType().GetProperty(detail_class), m, null).ToString());
                            }
                        }
                        //2009-06-23 Jackter end
                        //2009/06/22 dennis end
                    }
                    sb.Append("}");
                }
            }
            //傳回
            return "{'total':" + StringUtil.ToInt(HttpContext.Current.Items["Page_total"]) + ",'page':"
                + StringUtil.ToInt(HttpContext.Current.Items["Page_page"]) + ",'records':"
                + StringUtil.ToInt(HttpContext.Current.Items["Page_records"]) + ",'rows':[" + sb.ToString() + "]}";
        }


        //2009/07/10 dennis add 加入List2JqGrid
        /// <summary>
        /// 序列化List到JqGrid
        /// </summary>
        /// <param name="list">資料</param>
        /// <param name="detailFields">明細,見example</param>
        /// <returns>符合JqGrid的JSON資料</returns>
        /// <example><![CDATA[
        /// string jqGridStr = List2JqGrid(IList<object[]>,"Oid","Id","Name");//object的長度要與detailFields的長度相同
        /// ]]>
        /// </example>
        public static String List2JqGrid(IList<object[]> list, params string[] detailFields)
        {
            //引用StringBuilder
            StringBuilder sb = new StringBuilder();
            //不為null
            if ( list != null )
            {
                //下標
                int num = 1;
                //迭代
                foreach ( object[] m in list )
                {
                    if ( sb.Length > 0 )
                        sb.Append(",");
                    //ID欄位
                    sb.Append("{");
                    for ( int index = 0; index < m.Length; index ++ )
                    {
                        if ( index > 0)
                            sb.Append(",");
                        //明細欄位
                        sb.Append(detailFields[index] + ":" + String2Json(StringUtil.ToStr(m[index])));
                    }
                    sb.Append("}");
                }
            }
            //傳回
            return "{'total':" + StringUtil.ToInt(HttpContext.Current.Items["Page_total"]) + ",'page':"
                + StringUtil.ToInt(HttpContext.Current.Items["Page_page"]) + ",'records':"
                + StringUtil.ToInt(HttpContext.Current.Items["Page_records"]) + ",'rows':[" + sb.ToString() + "]}";
        }


        /// <summary>
        /// 序列化List到JqGrid
        /// </summary>
        /// <param name="list">資料</param>
        /// <param name="oid">主鍵</param>
        /// <param name="detailFields">明細,見example</param>
        /// <returns>符合JqGrid的JSON資料</returns>
        /// <example><![CDATA[
        /// string jqGridStr = ListObjectJqGrid(IList<object[]>,"Mermber.Oid:Oid"", Member.Name:name","Member.Id:id");
        /// ]]>
        /// </example>
        public static String ListObjectJqGrid(IList<object[]> list, string oid, params string[] detailFields)
        {
            //引用StringBuilder
            StringBuilder sb = new StringBuilder();
            //不為null
            if ( list != null )
            {
                //下標
                int num = 1;
                //迭代
                foreach ( object[] m in list )
                {
                    //分隔
                    if ( sb.Length > 0 )
                        sb.Append(",");
                    //取得字段
                    string[] key = getField(oid);
                    //取得物件
                    object keyObj = getObjec(m, key[0]);
                    //ID欄位
                    sb.Append("{" + key[2] + ":" + GetValue(keyObj.GetType().GetProperty(key[1]), keyObj, null).ToString() + ",");
                    //輸出string
                    for ( int index = 0; index < detailFields.Length; index ++ )
                    {
                        //分隔
                        if ( index > 0 )
                            sb.Append(",");
                        //取得字段
                        string[] detailKey = getField(detailFields[index]);
                        //取得物件
                        object detailKeyObj = getObjec(m, detailKey[0]);
                        if ( StringUtil.ToStr(detailKey[3]).Length > 0 )
                        {
                            //取得字串
                            string str = GetValue(detailKeyObj.GetType().GetProperty(detailKey[3]),
                                detailKeyObj, detailKey[1] + ":" + detailKey[2]).ToString();
                            str = str.Substring(1, str.Length - 2);
                            //為空
                            if ( str.Length == 0 )
                            {
                                sb.Append(detailKey[2] + ":\"\"");
                            }
                            //加入資料
                            else
                                sb.Append(str);
                        }
                        else
                        {
                            //輸出string
                            sb.Append(detailKey[2] + ":" + GetValue(detailKeyObj.GetType().GetProperty(detailKey[1]),
                                detailKeyObj, null).ToString());
                        }
                    }
                    //輸出}
                    sb.Append("}");
                }
            }
            //傳回
            return "{'total':" + StringUtil.ToInt(HttpContext.Current.Items["Page_total"]) + ",'page':"
                + StringUtil.ToInt(HttpContext.Current.Items["Page_page"]) + ",'records':"
                + StringUtil.ToInt(HttpContext.Current.Items["Page_records"]) + ",'rows':[" + sb.ToString() + "]}";
        }


        /// <summary>
        /// 取得分化字段
        /// </summary>
        /// <param name="field">字段(Member.Name:name)</param>
        /// <returns></returns>
        private static string[] getField(string field)
        {
            //操作訊息
            string[] recode = new string[4];
            //查找.
            if ( field.IndexOf(".") > -1 )
            {
                string[] name = field.Split('.');
                recode[0] = name[0];
                //多層路徑
                if ( name.Length > 2 )
                {
                    recode[1] = name[2];
                    recode[2] = name[2];
                    recode[3] = name[1];
                }
                //兩層
                else
                {
                    recode[1] = name[1];
                    recode[2] = name[1];
                }
                //查找:
                if ( recode[1].IndexOf(":") > 0 )
                {
                    string[] key = Regex.Split(recode[1], ":");
                    recode[1] = key[0];
                    recode[2] = key[1];
                }
            }
            //操作訊息
            return recode;
        }


        /// <summary>
        /// 取得物件
        /// </summary>
        /// <param name="obj">物件陣列</param>
        /// <param name="className">class名稱</param>
        /// <returns></returns>
        private static object getObjec(object[] obj, string className)
        {
            //操作訊息
            object recode = null;
            for ( int i = 0; i < obj.Length; i ++ )
            {
                //取得物件
                if ( obj[i].GetType().Name.ToLower().Equals(className.ToLower()) )
                {
                    recode = obj[i];
                    break;
                }
            }
            ///操作訊息
            return recode;
        }
        //2009/07/10 dennis end

        //2009/07/02 jackter add 加入取得物件(公用方法)
        /// <summary>
        /// 取得物件(公用方法)
        /// </summary>
        /// <typeparam name="T">實體類物件</typeparam>
        /// <param name="obj">物件陣列</param>
        /// <returns>實體類物件</returns>
        public static T GetObjectVal<T>(object[] obj)
        {
            object keyObj = getObjec(obj, typeof(T).Name);
            //返回物件
            return (T)(keyObj);
        }

        //2009/07/02 jackter end




        /// <summary>
        /// 傳回訊息
        /// </summary>
        /// <param name="returnValue">狀態碼</param>
        /// <param name="mess">訊息</param>
        /// <returns>JSON訊息</returns>
        public static string ReturnValue(int returnValue, string mess)
        {
            return "{ReturnState:" + returnValue + ",mess:'" + mess + "'}";
        }


        /// <summary>
        /// 傳回訊息
        /// </summary>
        /// <param name="returnValue">狀態碼</param>
        /// <returns>JSON訊息</returns>
        public static string ReturnValue(int returnValue)
        {
            if ( HttpContext.Current.Items["Message"] == null )
            {
                return ReturnValue(returnValue, StringUtil.ReturnValue2Mess(returnValue));
            }
            else
            {
                return "{ReturnState:" + returnValue + ",mess:'" + HttpContext.Current.Items["Message"].ToString() + "'}";
            }
        }
        //2009/06/02 andy end


        /// <summary>
        /// String到Json
        /// </summary>
        /// <param name="s">資料</param>
        /// <returns>結果</returns>
        private static String String2Json(String s)
        {
            StringBuilder sb = new StringBuilder(s.Length + 20);
            sb.Append("\"");
            //存儲
            for ( int i = 0; i < s.Length; i++ )
            {
                char c = s[i];
                switch ( c )
                {
                    //轉義
                    case '\"':
                        sb.Append("\\\"");
                        break;
                    case '\\':
                        sb.Append("\\\\");
                        break;
                    //轉義
                    case '/':
                        sb.Append("\\/");
                        break;
                    case '\b':
                        sb.Append("\\b");
                        break;
                    //轉義
                    case '\f':
                        sb.Append("\\f");
                        break;
                    case '\n':
                        sb.Append("\\n");
                        break;
                    //轉義
                    case '\r':
                        sb.Append("\\r");
                        break;
                    case '\t':
                        sb.Append("\\t");
                        break;
                    //轉義
                    default:
                        sb.Append(c);
                        break;
                }
            }
            sb.Append("\"");
            //傳回
            return sb.ToString();
        }
    }
}
