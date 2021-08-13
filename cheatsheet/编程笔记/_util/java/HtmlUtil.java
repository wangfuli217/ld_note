//2010/11/17 dennis 加入subStringHTML 1099-1139
/**
 * <P> Title: 公用類別                                      </P>
 * <P> Description: 頁面內容所需工具                        </P>
 * <P> Copyright: Copyright (c) 2010/07/31                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.everunion.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

/**
 * 頁面內容所需工具
 * @author <a href='daillow@gmail.com'>Holer</a>
 * @version 0.2
 */
public class HtmlUtil
{
    /**
     * 產生輸入框
     * @param sour 儲存著所需資料的物件
     * @param name 對應的 id, name 的值，且是sour物件裏對應的名稱
     * @param config 名稱框的其他屬性及事件等內容
     * @param init 名稱框的 value 的預設值
     * @param isNumber 是否按數字格式顯示
     * @return 一個輸入框
     */
    public static String inputText(Object sour, String name, String config, String init, boolean isNumber)
    {
        // 輸入框的名稱和ID
        String _name = "";
        if ( name != null && !"".equals(name) )
            _name = "id='" + name + "' name='" + name + "' ";
        // 輸入框的值
        String value = toHtml(StringUtil.getValue(sour, name, init));
        // 如果值是數值，按數值顯示格式
        if ( isNumber )
        {
            // 數值顯示格式：靠右，為0時點選自動清空，游標離開時自動格式化
            config += " style='text-align:right'" + " onfocus=\"if('0'==this.value)this.value='';\""
                    + " onfocusout=\"this.value=toNumStr(this.value);\"";
            value = NumberUtil.format(value);
        }
        // 輸入名稱框的內容
        String retValue = "<input type='text' " + _name + "value='" + value + "' " + config + " />";
        return retValue;
    }


    /**
     * 產生輸入框
     * @param sour 儲存著所需資料的物件
     * @param name 對應的 id, name 的值，且是sour物件裏對應的名稱
     * @param config 名稱框的其他屬性及事件等內容
     * @param init 名稱框的 value 的預設值
     * @return 一個輸入框
     */
    public static String inputText(Object sour, String name, String config, String init)
    {
        return inputText(sour, name, config, init, false);
    }


    /**
     * 產生輸入框
     * @param sour 儲存著所需資料的物件
     * @param name 對應的 id, name 的值，且是sour物件裏對應的名稱
     * @param config 名稱框的其他屬性及事件等內容
     * @return 一個輸入框
     */
    public static String inputText(Object sour, String name, String config)
    {
        return inputText(sour, name, config, "", false);
    }


    /**
     * 產生輸入框
     * @param sour 儲存著所需資料的物件
     * @param name 對應的 id, name 的值，且是sour物件裏對應的名稱
     * @return 一個輸入框
     */
    public static String inputText(Object sour, String name)
    {
        return inputText(sour, name, "", "", false);
    }


    /**
     * 產生選擇按鈕
     * @param sour 儲存著所需資料的集合
     * @param name 對應的 id, name 的值，且是資料庫裏對應的欄位名稱
     * @param value 此選擇按鈕的值(value)
     * @param type 選擇按鈕的類型(type)，有 radio, checkbox，預設為 checkbox
     * @param config 選擇按鈕的其他屬性及事件
     * @return 一個選擇按鈕
     */
    public static String selectBtn(Object sour, String name, String value, String type, String config)
    {
        // 防呆
        name = (name == null) ? "" : name.trim();
        type = (type == null) ? "" : type.trim();
        value = (value == null) ? "" : value.trim();
        config = (config == null) ? "" : config.trim();
        // 選擇按鈕的類型，有 radio, checkbox ；預設為 checkbox
        type = "radio".equalsIgnoreCase(type) ? "radio" : "checkbox";
        // 選擇按鈕的id值，如果是 radio類型，各選擇按鈕的id需不相同，而 name 又需相同
        String id = "radio".equals(type) ? (name + "_" + value) : name;
        // 選擇按鈕的 checked 屬性，如果變數 value 是之前選中的，則它需加上 checked
        String isChecked = value.equals(StringUtil.getValue(sour, name)) ? " checked " : "";
        return ("<input type='" + type + "' id='" + id + "' name='" + name + "' value='" + toHtml(value) + "' "
                + isChecked + config + " />");
    }


    /**
     * 產生選擇按鈕
     * @param sour 儲存著所需資料的集合
     * @param name 對應的 id, name 的值，且是資料庫裏對應的欄位名稱
     * @param value 此選擇按鈕的值(value)
     * @param type 選擇按鈕的類型(type)，有 radio, checkbox，預設為 checkbox
     * @return 一個選擇按鈕
     */
    public static String selectBtn(Object sour, String name, String value, String type)
    {
        return selectBtn(sour, name, value, type, "");
    }


    /**
     * 產生選擇按鈕
     * @param sour 儲存著所需資料的集合
     * @param name 對應的 id, name 的值，且是資料庫裏對應的欄位名稱
     * @param value 此選擇按鈕的值(value)
     * @return 一個選擇按鈕
     */
    public static String selectBtn(Object sour, String name, String value)
    {
        return selectBtn(sour, name, value, "checkbox", "");
    }


    /**
     * 取下拉選單
     * @param conn 資料庫連結
     * @param sql 查詢選單內容的SQL；注意：此SQL的第一個欄位將是value值，第二個欄位將是顯示內容
     * @param valueList 查詢的SQL的參數資料集，沒有時請填 null
     * @param init 此下拉選單的預設值，顯示時預設選中它，沒有時請填 null
     * @param length 顯示長度,超過此長度者,後面顯示“...”;不希望截取可填入0
     * @param isFirstBlank 此下拉選單的第一項是否增加一個空白，true則增加一個空白，否則不增加空白
     * @return String 此下拉選單的頁面內容
     */
    public static String options(Connection conn, String sql, List<Object> valueList, String init,
            int length, boolean isFirstBlank) throws SQLException
    {
        // 取得資料庫查詢的資料
        List<HashMap<String, String>> rslist = DbUtil.getDataByNum(conn, sql, valueList);
        // 選單
        StringBuffer menu = new StringBuffer();
        // 如果需要，則先增加一個空值的選項(顯示:請選擇)
        if ( isFirstBlank )
            menu.append("<option value=''>\u8ACB\u9078\u64C7</option>\r\n");

        // 迭代 選項內容
        for ( int i = 0; i < rslist.size(); i++ )
        {
            HashMap<String, String> hm = rslist.get(i);
            // 是否選中
            String isSelected = StringUtil.getValue(hm, "1").equals(init) ? "selected " : "";
            String value = changeMarks(StringUtil.getValue(hm, "1"));
            String text = toString(hm, "2", length);
            menu.append("<option value='" + value + "' " + isSelected + ">" + text + "</option>\r\n");
        }
        // 傳回
        return menu.toString();
    }


    /**
     * 取下拉選單
     * @param conn 資料庫連結
     * @param sql 查詢選單內容的SQL；注意：此SQL的第一個欄位將是value值，第二個欄位將是顯示內容
     * @param valueList 查詢的SQL的參數資料集，沒有時請填 null
     * @param init 此下拉選單的預設值，顯示時預設選中它，沒有時請填 null
     * @param length 顯示長度,超過此長度者,後面顯示“...”;不希望截取可填入0
     * @return String 此下拉選單的頁面內容
     */
    public static String options(Connection conn, String sql, List<Object> valueList, String init,
            int length) throws SQLException
    {
        return options(conn, sql, valueList, init, length, true);
    }


    /**
     * 取下拉選單，第一項增加一個空白
     * @param conn 資料庫連結
     * @param sql 查詢選單內容的SQL；注意：此SQL的第一個欄位將是value值，第二個欄位將是顯示內容
     * @param init 此下拉選單的預設值，顯示時預設選中它
     * @return String 此下拉選單的頁面內容
     */
    public static String options(Connection conn, String sql, String init) throws SQLException
    {
        return options(conn, sql, null, init, 0);
    }


    /**
     * 取下拉選單，第一項增加一個空白
     * @param conn 資料庫連結
     * @param sql 查詢選單內容的SQL；注意：此SQL的第一個欄位將是value值，第二個欄位將是顯示內容
     * @return String 此下拉選單的頁面內容
     */
    public static String options(Connection conn, String sql) throws SQLException
    {
        return options(conn, sql, "");
    }


    /**
     * 按數值增加下拉式選框的選項，可順序，也可倒序
     * @param start 此下拉選單的開始(含)
     * @param end 此下拉選單的結束(含)
     * @param init 此下拉選單的預設值，顯示時預設選中它
     * @param iter 此下拉選單的遞增量。當 start <= end 取 1；當 start > end 取 -1
     * @param isFirstBlank 此下拉選單的第一項是否增加一個空白，true則增加一個空白，否則不增加空白
     * @return String 此下拉選單的頁面內容
     */
    public static String options(int start, int end, int init, int iterator, boolean isFirstBlank)
    {
        // 遞增量
        int iter = iterator;
        // 避免因參數寫錯而出現死迴圈
        if ( start <= end && iterator <= 0 )
            iter = 1;
        if ( start > end && iterator >= 0 )
            iter = -1;
        StringBuffer menu = new StringBuffer("");
        // 如果需要，則先增加一個空值的選項(顯示:請選擇)
        if ( isFirstBlank )
            menu.append("<option value=''>\u8ACB\u9078\u64C7</option>\r\n");

        // 迴圈增加下拉選單的內容
        for ( int i = start; true; i += iter )
        {
            // 終止條件寫"true"，然後用if來終止，可控制順序及倒序情況，免得重複寫迴圈
            // 當 start == end 時，還是會運行一次
            if ( start <= end && i > end )
                break;
            if ( start > end && i < end )
                break;
            // 如果i小於等於9，則顯示"0i"
            String j = (i <= 9) ? ("" + 0 + i) : "" + i;
            menu.append("<option value=\"" + i + "\" ");
            if ( i == init )
                menu.append(" selected ");
            menu.append(">" + j + "</option>\r\n");
        }
        return menu.toString();
    }


    /**
     * 按數值增加下拉式選框的選項，可順序，也可倒序，第一項增加一個空白
     * @param start 此下拉選單的開始(含)
     * @param end 此下拉選單的結束(含)
     * @param init 此下拉選單的預設值，顯示時預設選中它
     * @param iter 此下拉選單的遞增量。當 start <= end 取 1；當 start > end 取 -1
     * @return String 此下拉選單的頁面內容
     */
    public static String options(int start, int end, int init, int iterator)
    {
        return options(start, end, init, iterator, true);
    }


    /**
     * 按數值增加下拉式選框的選項，可順序，也可倒序，第一項增加一個空白
     * @param start 此下拉選單的開始(含)
     * @param end 此下拉選單的結束(含) (start與end之間，每次遞增或遞減1)
     * @param init 此下拉選單的預設值，顯示時預設選中它
     * @return String 此下拉選單的頁面內容
     */
    public static String options(int start, int end, int init)
    {
        return options(start, end, init, 0, true);
    }


    /**
     * 按數值增加下拉式選框的選項，可順序，也可倒序，第一項增加一個空白
     * @param start 此下拉選單的開始(含)
     * @param end 此下拉選單的結束(含) (start與end之間，每次遞增或遞減1)
     * @return String 此下拉選單的頁面內容
     */
    public static String options(int start, int end)
    {
        // 預設不選中任何一個
        int init = (start < end) ? (end + 1) : (start + 1);
        return options(start, end, init);
    }


    /**
     * 按數值增加下拉式選框的選項
     * @param end 此下拉選單的結束(含)
     * @return String 此下拉選單的頁面內容
     */
    public static String options(int end)
    {
        return options(0, end);
    }


    /**
     * 取得下拉選單
     * @param list 資料集
     * @param valueName 儲存 Value 的鍵名稱，預設為"value"
     * @param textName 儲存 text 的鍵名稱，預設為"text"
     * @param init 此選單的選中值，沒有時請填 null
     * @return String 此下拉選單的頁面顯示字串
     */
    public static String options(List<Map<String, String>> list, String valueName, String textName, String init)
    {
        String recode = "";
        // 鍵的名稱
        valueName = (valueName == null || "".equals(valueName)) ? "value" : valueName;
        textName = (textName == null || "".equals(textName)) ? "text" : textName;
        // 取得資料
        for ( int i = 0; i < list.size(); i++ )
        {
            Map<String, String> map = (Map<String, String>)list.get(i);
            // 取得 value
            String value = changeMarks(StringUtil.getValue(map, valueName));
            // 取得 text
            String text = toHtml(StringUtil.getValue(map, textName));
            // 是否選中
            String selected = value.equals(init) ? " selected " : "";
            recode += "<option value='" + value + "'" + selected + ">" + text + "</option>\r\n";
        }
        // 操作訊息
        return recode;
    }


    /**
     * 取得下拉選單
     * @param list 資料集，要求 Map 裡面的value和text的鍵名為value和text
     * @param init 此選單的選中值，沒有時請填 null
     * @return String 此下拉選單的頁面顯示字串
     */
    public static String options(List<Map<String, String>> list, String init)
    {
        return options(list, "value", "text", init);
    }


    /**
     * 產生下拉選單
     * @param ource 來源資料
     * @param value 本選單的值
     * @param text 本選單顯示的內容
     * @return 一個選單
     */
    public static String option(Object ource, String name, String value, String text)
    {
        // 取值
        String realValue = StringUtil.getValue(ource, name);
        // 產生下拉選單
        return option(realValue, value, text);
    }


    /**
     * 產生下拉選單
     * @param ource 來源資料
     * @param value 本選單的值
     * @param text 本選單顯示的內容
     * @return 一個選單
     */
    public static String option(String ource, String value, String text)
    {
        // 防止特殊符號
        value = changeMarks(value);
        text = toHtml(text);
        // 是否選中
        String selected = value.equals(ource) ? " selected " : "";
        return "<option value='" + value + "'" + selected + ">" + text + "</option>";
    }


    /**
     * 增加空格
     * @param number 需要增加空格的數量
     * @return 指定數量的空格
     */
    public static String addSpace(int number)
    {
        return addSign("&nbsp;", number);
    }


    /**
     * 增加多個特定內容
     * @param element 特定的內容
     * @param number 需增加的內容的數量
     * @return 頁面顯示的內容
     */
    public static String addSign(String element, int number)
    {
        StringBuffer retValue = new StringBuffer("");
        // 為空時
        if ( element == null || "".equals(element) || number <= 0 )
            return "";
        // 增加指定的數量
        for ( int i = 0; i < number; i++ )
        {
            retValue.append(element);
        }
        return retValue.toString();
    }


    /**
     * 取得並截取字串,以html形式顯示出來
     * @param sour 儲存著所需內容的物件，可以是 Map, HttpServletRequest, HttpSession, ResultSet 類別
     * @param name 對應的值的名稱，如果這個值為null，則認為 sour 本身是值
     * @param length 顯示長度,超過此長度者,後面顯示“...”;不希望截取可填入0
     * @return String 物件裏的值的字串,
     */
    public static String toString(Object sour, String name, int length)
    {
        // 取值
        String value = StringUtil.getValue(sour, name, "", length);
        // 為空時顯示空格,不為空轉換成頁面顯示內容
        value = "".equals(value) ? "&nbsp;" : toHtml(value);
        return value;
    }


    /**
     * 取得並截取字串,以html形式顯示出來
     * @param sour 儲存著所需內容的物件，可以是 Map, HttpServletRequest, HttpSession, ResultSet 類別
     * @param name 對應的值的名稱，如果這個值為null，則認為 sour 本身是值
     * @return String 物件裏的值的字串,
     */
    public static String toString(Object sour, String name)
    {
        return HtmlUtil.toString(sour, name, 0);
    }


    /**
     * 將需顯示的字串轉換成 textarea 顯示的字串
     * @param sour 需要進行轉換的物件
     * @return 轉換後的字串
     */
    public static String toTextarea(String sour)
    {
        // 為空時
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }

        // 以下逐一轉換
        sour = sour.replaceAll("&", "&amp;");
        sour = sour.replaceAll("<", "&lt;");
        sour = sour.replaceAll(">", "&gt;");
        return sour;
    }


    /**
     * 將需顯示的物件轉換成 textarea 顯示的字串
     * @param sour 需要進行轉換的物件
     * @return 轉換後的字串
     */
    public static String toTextarea(Object sour)
    {
        // 為空時
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }
        return toTextarea(StringUtil.toString(sour));
    }


    /**
     * 將Map集合的內容全部轉換成 textarea 顯示的字串內容
     * @param sour 需要進行轉換的Map集合物件
     * @return 轉換後的字串的Map集合物件,原集合不改變
     */
    public static LinkedHashMap<String, String> toTextarea(Map<String, String> sour)
    {
        // 儲存轉碼後的資料(不改變原本的集合內容)
        LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
        // 為空時
        if ( sour == null || 0 == sour.size() )
        {
            return map;
        }

        // 迴圈map的資料
        for ( Iterator<Map.Entry<String,String>> iter = sour.entrySet().iterator(); iter.hasNext(); )
        {
            // 取值
            Map.Entry<String,String> entry = iter.next();
            String key = entry.getKey().toString();
            String value = (String)entry.getValue();
            // 轉碼
            value = toTextarea(value);
            // 賦值
            map.put(key, value);
        }
        return map;
    }


    /**
     * 將需顯示的字串轉換成HTML格式的字串
     * @param sour 需要進行轉換的物件
     * @return 轉換後的字串
     */
    public static String toHtml(String sour)
    {
        // 為空時
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }

        // 以下逐一轉換
        sour = sour.replaceAll("&", "&amp;");
        sour = sour.replaceAll(" ", "&nbsp;");
        sour = sour.replaceAll("%", "&#37;");
        sour = sour.replaceAll("<", "&lt;");
        sour = sour.replaceAll(">", "&gt;");
        sour = sour.replaceAll("\n", "\n<br/>");
        sour = sour.replaceAll("\"", "&quot;");
        sour = sour.replaceAll("'", "&#39;");
        sour = sour.replaceAll("[+]", "&#43;");
        return sour;
    }


    /**
     * 將需顯示的物件轉換成HTML格式的字串
     * @param sour 需要進行轉換的物件
     * @return 轉換後的字串
     */
    public static String toHtml(Object sour)
    {
        // 為空時
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }
        return toHtml(StringUtil.toString(sour));
    }


    /**
     * 將Map集合的內容全部轉換成HTML格式的字串內容
     * @param sour 需要進行轉換的Map集合物件
     * @return 轉換後的字串的Map集合物件,原集合不改變
     */
    public static LinkedHashMap<String, String> toHtml(Map<String, String> sour)
    {
        // 儲存轉碼後的資料(不改變原本的集合內容)
        LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
        // 為空時
        if ( sour == null || 0 == sour.size() )
        {
            return map;
        }

        // 迴圈map的資料
        for ( Iterator<Map.Entry<String,String>> iter = sour.entrySet().iterator(); iter.hasNext(); )
        {
            // 取值
            Map.Entry<String,String> entry = iter.next();
            String key = entry.getKey().toString();
            String value = (String)entry.getValue();
            // 轉碼
            value = toHtml(value);
            // 賦值
            map.put(key, value);
        }
        return map;
    }


    /**
     * 將HTML格式的字串轉換成常規顯示的字串
     * @param sour 需要進行轉換的物件
     * @return 轉換後的字串
     */
    public static String toText(String sour)
    {
        // 為空時
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }

        // 以下逐一轉換
        // 先轉換百分號
        sour = sour.replaceAll("&#37;", "%");
        // 小於號,有三種寫法
        sour = sour.replaceAll("&lt;", "<");
        sour = sour.replaceAll("&LT;", "<");
        sour = sour.replaceAll("&#60;", "<");
        // 大於號,有三種寫法
        sour = sour.replaceAll("&gt;", ">");
        sour = sour.replaceAll("&GT;", ">");
        sour = sour.replaceAll("&#62;", ">");
        // 單引號
        sour = sour.replaceAll("&#39;", "'");
        sour = sour.replaceAll("&#43;", "+");
        // 轉換換行符號
        sour = sour.replaceAll("\n?<[Bb][Rr]\\s*/?>\n?", "\n");
        // 雙引號號,有三種寫法
        sour = sour.replaceAll("&quot;", "\"");
        sour = sour.replaceAll("&QUOT;", "\"");
        sour = sour.replaceAll("&#34;", "\"");
        // 空格,只有兩種寫法, &NBSP; 瀏覽器不承認
        sour = sour.replaceAll("&nbsp;", " ");
        sour = sour.replaceAll("&#160;", " ");
        // & 符號,最後才轉換
        sour = sour.replaceAll("&amp;", "&");
        sour = sour.replaceAll("&AMP;", "&");
        sour = sour.replaceAll("&#38;", "&");
        return sour;
    }


    /**
     * 將HTML格式的物件轉換成常規顯示的字串
     * @param sour 需要進行轉換的物件
     * @return 轉換後的字串
     */
    public static String toText(Object sour)
    {
        // 為空時
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }
        return toText(StringUtil.toString(sour));
    }


    /**
     * 將Map集合的內容全部由HTML格式的字串轉換成常規顯示的字串
     * @param sour 需要進行轉換的Map集合物件
     * @return 轉換後的字串的Map集合物件,原集合不改變
     */
    public static LinkedHashMap<String, String> toText(Map<String, String> sour)
    {
        // 儲存轉碼後的資料(不改變原本的集合內容)
        LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
        // 為空時
        if ( sour == null || 0 == sour.size() )
        {
            return map;
        }

        // 迴圈map的資料
        for ( Iterator<Map.Entry<String,String>> iter = sour.entrySet().iterator(); iter.hasNext(); )
        {
            // 取值
            Map.Entry<String,String> entry = iter.next();
            String key = entry.getKey().toString();
            String value = (String)entry.getValue();
            // 轉碼
            value = toText(value);
            // 賦值
            map.put(key, value);
        }
        return map;
    }


    /**
     * 符號轉換，特殊符號都在前面加上斜杠(\)
     * @param sour 待轉資料
     * @return String 轉換後的字串
     */
    public static String changeMarks(String sour)
    {
        // 為空時
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }

        // 斜杠(\)取代成(\\)
        sour = sour.replaceAll("\\\\", "\\\\\\\\");
        // 各符號，都在前面加上斜杠(\)
        sour = sour.replaceAll("\"", "\\\\\"");
        sour = sour.replaceAll("'", "\\\\'");
        sour = sour.replaceAll("/", "\\\\/");
        sour = sour.replaceAll("<", "\\\\<");
        sour = sour.replaceAll(">", "\\\\>");
        sour = sour.replaceAll(":", "\\\\:");
        sour = sour.replaceAll("#", "\\\\#");
        sour = sour.replaceAll("%", "\\\\%");
        sour = sour.replaceAll("&", "\\\\&");
        return sour;
    }


    /**
     * 符號轉換，特殊符號都在前面加上斜杠(\)
     * @param sour 待轉資料
     * @return String 轉換後的字串
     */
    public static String changeMarks(Object sour)
    {
        // 為空時
        if ( sour == null || "".equals(sour) )
        {
            return "";
        }
        return changeMarks(StringUtil.toString(sour));
    }


    /**
     * 清理HTML標籤
     * @param sour 待處理數據
     * @return 清理後數據
     */
    public static String removeHTMLTag(Object sour)
    {
        // 為空時
        if ( sour == null )
            return "";
        String text = StringUtil.toString(sour);
        // 清除註解
        text = text.replaceAll("<!--.*-->", "");
        // 標題換行: </title> ==> 換行符號
        text = text.replaceAll("</[Tt][Ii][Tt][Ll][Ee]>", "\n");
        // 換行符換行: <br/> ==> 換行符號
        text = text.replaceAll("<[Bb][Rr]\\s*/?>", "\n");
        // tr換行: </tr> ==> 換行符號
        text = text.replaceAll("</[Tt][Rr]>", "\n");
        // html標籤清除
        text = text.replaceAll("<[^>]+>", "");
        // 將HTML格式的字串轉換成常規顯示的字串
        text = toText(text);
        return text.trim();
    }


    /**
     * 將字串轉換成URL格式的字串
     * @param str 需要進行轉換的字串
     * @param 字串編碼
     * @return 轉換後的字串
     */
    public static String toURL(String str, String encoding)
    {
        // 為空時
        if ( str == null || "".equals(str.trim()) )
            return "";
        // 編碼
        encoding = (encoding == null || "".equals(encoding.trim())) ? "UTF-8" : encoding;
        try
        {
            // 轉碼
            return java.net.URLEncoder.encode(String.valueOf(str.trim()), encoding);
        }
        // 轉碼例外
        catch ( java.io.UnsupportedEncodingException e )
        {
            // 輸出例外
            System.out.println("HtmlUtil.toURL -> UnsupportedEncodingException:" + e.toString());
            System.out.println("HtmlUtil.toURL -> str:" + str);
            return "";
        }
    }


    /**
     * 將字串轉換成URL格式的字串
     * @param str 需要進行轉換的字串
     * @return 轉換後的字串
     */
    public static String toURL(String str)
    {
        return java.net.URLEncoder.encode(String.valueOf(str.trim()));
    }


    /**
     * 將URL字串解碼
     * @param str 需要進行解碼的字串
     * @param 字串編碼
     * @return 解碼後的字串
     */
    public static String unURL(String str, String encoding)
    {
        // 為空時
        if ( str == null || "".equals(str.trim()) )
            return "";
        // 編碼
        encoding = (encoding == null || "".equals(encoding.trim())) ? "UTF-8" : encoding;
        try
        {
            // 轉碼
            return java.net.URLDecoder.decode(String.valueOf(str.trim()), encoding);
        }
        // 轉碼例外
        catch ( java.io.UnsupportedEncodingException e )
        {
            // 輸出例外
            System.out.println("HtmlUtil.unURL -> UnsupportedEncodingException:" + e.toString());
            System.out.println("HtmlUtil.unURL -> str:" + str);
            return "";
        }
    }


    /**
     * 將URL字串解碼
     * @param str 需要進行解碼的字串
     * @return 解碼後的字串
     */
    public static String unURL(String str)
    {
        return java.net.URLDecoder.decode(String.valueOf(str.trim()));
    }


    /**
     * 取得當時請求的路徑
     * @param request 頁面請求
     * @return 當時頁面的路徑
     */
    public static String getPath(HttpServletRequest request)
    {
        return request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                + request.getContextPath() + "/";
    }


    /**
     * 取得當時請求的檔案的副檔名(小寫形式)
     * @param request 頁面請求
     * @return 當時請求的檔案的副檔名
     */
    public static String getFilePostfix(HttpServletRequest request)
    {
        // 請求路徑
        String url = request.getRequestURL().toString();
        // 防呆,沒有檔案時
        if ( url.endsWith("/") )
        {
            return "";
        }
        // 取得檔案名
        String fileName = url.substring(url.lastIndexOf("/") + 1);

        int fileNameIndex = fileName.lastIndexOf(".");
        // 沒有副檔名時
        if ( fileNameIndex == -1 || fileNameIndex == fileName.length() - 1 )
        {
            return "";
        }
        // 取得副檔名及後面的參數
        String postfix = fileName.substring(fileNameIndex + 1);

        fileNameIndex = postfix.lastIndexOf("?");
        // 有參數時
        if ( fileNameIndex != -1 )
        {
            postfix = postfix.substring(0, fileNameIndex);
        }
        // “#”結尾時,刪除“#”
        if ( postfix.endsWith("#") )
        {
            postfix = postfix.substring(0, postfix.length() - 1);
        }
        // 傳回副檔名的小寫形式
        return postfix.toLowerCase();
    }


    /**
     * 取得檔案的名稱
     * @param input 檔案的路徑及名稱
     * @return String 檔案的名稱
     */
    public static String getFileName(String input)
    {
        // 防呆,沒有檔案時
        if ( input.endsWith("\\") || input.endsWith("/") )
        {
            return "";
        }
        // 截去檔案的路徑
        input = input.substring(input.lastIndexOf("\\") + 1);
        input = input.substring(input.lastIndexOf("/") + 1);
        // 傳回去除路徑後的檔案名
        return input;
    }


    /**
     * 將 Request 的變量轉換成 Map 的資料集 註: 如果 Request 裡的某個 key 所含的資料為陣列類型,只取第一個值
     * @param request http伺服件請求
     * @return HashMap 資料集
     */
    public static HashMap<String, String> getMap(HttpServletRequest request)
    {
        // 引用Map
        HashMap<String, String> map = new HashMap<String, String>();
        try
        {
            for ( Enumeration e = request.getParameterNames(); e.hasMoreElements(); )
            {
                String key = (String)e.nextElement();
                String value = request.getParameter(key).toString();
                // 資料值
                map.put(key, value);
            }
        }
        // 捕捉例外
        catch ( Exception e )
        {
            // 輸出例外
            System.out.println("HtmlUtil.getMap -> Exception:" + e.toString());
        }
        // 傳回操作訊息
        return map;
    }


    /**
     * 將 session 的變量轉換成 Map 的資料集
     * @param session 伺服器session
     * @return HashMap 資料集
     */
    public static HashMap<String, Object> getMap(HttpSession session)
    {
        // 引用Map
        HashMap<String, Object> map = new HashMap<String, Object>();
        try
        {
            Enumeration e = session.getAttributeNames();
            while ( e.hasMoreElements() )
            {
                String key = (String)e.nextElement();
                // 傳入資料值
                map.put(key, session.getAttribute(key));
            }
        }
        // 捕捉例外
        catch ( Exception e )
        {
            // 輸出例外
            System.out.println("HtmlUtil.getMap -> Exception:" + e.toString());
        }
        // 傳回操作訊息
        return map;
    }


    /**
     * 處理畫面上發生的例外
     * @param out 畫面上的 JspWriter 隱含物件
     * @param request 發生例外的畫面的請求
     * @param e 發生的例外
     * @return 畫面上表示發生例外的html內容
     */
    public static void doException(JspWriter out, HttpServletRequest request, Exception e)
    {
        // 後臺列印出錯訊息
        System.out.println(request.getRequestURI() + " -> " + e.toString());
        // 畫面上提示出錯訊息:此畫面出錯，請聯系管理員!
        String javaScript = "alert('\u6B64\u756B\u9762\u51FA\u932F, \u8ACB\u806F\u7CFB\u7BA1\u7406\u54E1!');";
        javaScript(out, javaScript);
    }


    /**
     * 在頁面上執行javaScript
     * @param out 畫面上的 JspWriter 隱含物件
     * @param javaScript 需要在頁面上執行的內容
     * @return 無
     */
    public static void javaScript(JspWriter out, String javaScript)
    {
        // 防呆
        if ( out == null || javaScript == null || "".equals(javaScript) )
            return;
        // 需要在頁面上顯示的內容
        String retValue = "<script language='javascript' type='text/JavaScript'>\r\n";
        retValue += "<!-- \r\n";
        retValue += javaScript + " \r\n";
        retValue += "//--> \r\n";
        retValue += "</script>";
        // 把內容輸出到頁面上
        pagePrint(out, retValue);
    }


    /**
     * 把內容顯示到頁面上
     * @param out 畫面上的 JspWriter 隱含物件
     * @param message 需要在頁面上顯示的內容
     * @return 無
     */
    public static void pagePrint(JspWriter out, String message)
    {
        // 防呆
        if ( out == null || message == null || "".equals(message) )
            return;
        try
        {
            // 把內容輸出到頁面上
            out.print(message);
        }
        // 處理例外
        catch ( IOException e )
        {
            System.out.println("HtmlUtil.print -> IOException:" + e.toString());
        }
    }


    /**
     * 給網址加上時間戳,避免瀏覽器緩存
     * @param url 網址
     * @return 加上時間戳後的網址
     */
    public static String timeStampURL(String url)
    {
        // 防呆
        if ( url == null || 0 == url.trim().length() )
        {
            return "";
        }

        // 判斷網址是否已經有時間戳(時間戳在第一個參數)
        if ( url.indexOf("?timeStamp=") > 0 )
        {
            // 刪除舊的時間戳
            url = url.replaceAll("timeStamp=\\d*[&]?", "");
        }
        // 判斷網址是否已經有時間戳(時間戳不是第一個參數)
        else if ( url.indexOf("&timeStamp=") > 0 )
        {
            // 刪除舊的時間戳
            url = url.replaceAll("[&]timeStamp=\\d*", "");
        }

        // 給網址增加時間戳參數
        url += (url.indexOf("?") > 0) ? "&" : "?";
        url += "timeStamp=" + new java.util.Date().getTime();
        return url;
    }


    /**
     * 設定頁面的值,把Map的值加入頁面上
     * @param pageContext 頁面上下文
     * @param map 頁面的資料的集合
     */
    public static void setPageValue(PageContext pageContext, Map<String, String> map)
    {
        // 將map裡面的值轉碼成頁面顯示的內容
        Map<String, String> htmlMap = toHtml(map);
        Map<String, String> textareaMap = toTextarea(map);

        // 頁面上儲存map的內容
        pageContext.setAttribute("htmlMap", htmlMap);
        pageContext.setAttribute("textareaMap", textareaMap);
    }

    //2010/11/17 dennis add 加入subStringHTML
    /**
     * 按長度截取字串(支持截取帶HTML代碼樣式的字串)
     * @param html html字串
     * @param len 截取長度
     * @param end 結束字串
     * @return String 字串
     */
    public static String subStringHTML(String html, int len, String end)
    {
    	//初始化
    	String recode = "";
    	try
    	{
	    	recode = removeHTMLTag(html);
	    	recode = recode.replaceAll("\n", "<br>");
	    	//截取字串
	    	if ( recode.length() > len )
	    		recode = recode.substring(0, len) + end;
    	}
    	//拋出例外
    	catch ( Exception e )
    	{
    		System.out.println("HtmlUtil.subStringHTML error:" + e);
    	}
    	//操作訊息
    	return recode;
    }


    /**
     * 按長度截取字串(支持截取帶HTML代碼樣式的字串)
     * @param html html字串
     * @param len 截取長度
     * @return String 字串
     */
    public static String subStringHTML(String html, int len)
    {
    	return subStringHTML(html, len, "...");
    }
    //2010/11/17 dennis end
}