/**
 * <P> Title: 公用類別                                      </P>
 * <P> Description: 字串處理                                </P>
 * <P> Copyright: Copyright (c) 2010/07/31                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 字串處理
 * @author Holer W. L. Feng
 * @version 0.1
 */
public final class StringUtil
{

    /**
     * 轉成字串
     * @param sour 待轉資料
     * @param init 預設值
     * @param length 截取字串長度,超過此長度者,後面顯示“...”;不希望截取可填入0
     * @return String 字串
     */
    public static String toString(Object sour, String init, int length)
    {
        // 初始化
        String dest = null;
        try
        {
            // 為空
            if ( sour == null || "".equals(sour) )
            {
                dest = init;
            }
            else
            {
                dest = "" + sour;
            }
        }
        // 拋出例外
        catch ( Exception e )
        {
            dest = init;
        }
        // 需要截取時(由於超出部分顯示“...”，所以必須3位以上才截取)
        if ( length > 0 && dest != null && dest.length() > length && dest.length() > 3 )
        {
            dest = dest.substring(0, length - 3) + "...";
        }
        return dest;
    }


    /**
     * 轉成字串
     * @param sour 待轉資料
     * @param init 預設值
     * @return String 字串
     */
    public static String toString(Object sour, String init)
    {
        return toString(sour, init, 0);
    }


    /**
     * 轉成字串
     * @param sour 待轉資料
     * @return String 字串
     */
    public static String toString(Object sour)
    {
        return toString(sour, "");
    }


    /**
     * 取得物件裏的值
     * @param sour 儲存著所需內容的物件，可以是 Map, HttpServletRequest, HttpSession, ResultSet 類別
     * @param name 對應的值的名稱，如果這個值為null，則認為 sour 本身是值
     * @param init 預設值，如果沒有取得對應值時，則傳回此值
     * @param length 截取字串長度,超過此長度者,後面顯示“...”;不希望截取可填入0
     * @return String 物件裏的值的字串
     */
    public static String getValue(Object sour, String name, String init, int length)
    {
        // 如果變數 sour 為空
        if ( sour == null )
        {
            return toString(init, init, length);
        }
        // 如果變數 name 為空，則認為 sour 本身是值
        if ( name == null )
        {
            return toString(sour, init, length);
        }

        // 根據 sour 的不同類型來取值
        try
        {
            // 如果 sour 是 String 類別的物件
            if ( sour instanceof String )
            {
                return toString(sour, init, length);
            }
            // 如果 sour 是 Map 類別的物件
            if ( sour instanceof Map )
            {
                Map<String, String> map = (Map)sour;
                // 如果此映射包含指定鍵的映射關系
                if ( map.containsKey(name) )
                {
                    return toString(map.get(name), init, length);
                }
                // 查詢資料庫時，鍵都會自動轉成小寫
                if ( map.containsKey(name.toLowerCase()) )
                {
                    return toString(map.get(name.toLowerCase()), init, length);
                }
                // 如果此映射不包含指定鍵的映射關系，則忽略大小寫來取值
                for ( Iterator<Map.Entry<String, String>> iter = map.entrySet().iterator(); iter.hasNext(); )
                {
                    Map.Entry<String, String> entry = iter.next();
                    // 如果鍵忽略大小寫時與 name 相同
                    if ( name.equalsIgnoreCase(toString(entry.getKey())) )
                    {
                        return toString(entry.getValue(), init, length);
                    }
                }
            }
            // 如果 sour 是 HttpServletRequest 類別的物件
            if ( sour instanceof HttpServletRequest )
            {
                // Parameter裡面有,則取Parameter的
                if ( ((HttpServletRequest)sour).getParameterMap().containsKey(name) )
                {
                    return toString(((HttpServletRequest)sour).getParameter(name), init, length);
                }
                // 如果 Parameter 不包含對應的名稱; 取Attribute的
                return toString(((HttpServletRequest)sour).getAttribute(name), init, length);
            }
            // 如果 sour 是 HttpSession 類別的物件
            if ( sour instanceof HttpSession )
            {
                return toString(((HttpSession)sour).getAttribute(name), init, length);
            }
            // 如果 sour 是 ResultSet 類別的物件
            if ( sour instanceof ResultSet )
            {
                return toString(((ResultSet)sour).getString(name), init, length);
            }
            // 如果 sour 不是上述類別的物件，則認為它自身是值。
            return toString(sour, init, length);
        }
        // 取值時出現例外
        catch ( Exception e )
        {
            return toString(init, init, length);
        }
    }


    /**
     * 取得物件裏的值
     * @param sour 儲存著所需內容的物件，可以是 Map, HttpServletRequest, HttpSession, ResultSet 類別
     * @param name 對應的值的名稱，如果這個值為空，則認為 sour 本身是值
     * @param init 預設值，如果沒有取得對應值時，則傳回此值
     * @return String 物件裏的值的字串
     */
    public static String getValue(Object sour, String name, String init)
    {
        return getValue(sour, name, init, 0);
    }


    /**
     * 取得物件裏的值的字串
     * @param sour 儲存著所需內容的物件，可以是 Map, HttpServletRequest, HttpSession, ResultSet 類別
     * @param name 對應的值的名稱，如果這個值為null，則認為 sour 本身是值
     * @return String 物件裏的值的字串。取不到值，或者值為 null 則傳回""
     */
    public static String getValue(Object sour, String name)
    {
        return getValue(sour, name, "");
    }


    /**
     * 取得物件裏的值的字串
     * @param sour 儲存著所需內容的物件，相當於 toString(sour)
     * @param name 對應的值的名稱，如果這個值為空，則認為 sour 本身是值
     * @return String 物件裏的值的字串。取不到值，或者值為 null 則傳回""
     */
    public static String getValue(Object sour)
    {
        return getValue(sour, null, "");
    }


    /**
     * 從右取資料
     * @param str 原資料
     * @param length 長度
     * @return String 子資料
     */
    public static String right(String str, int length)
    {
        int lengthstr = str.length();
        return str.substring(lengthstr - length);
    }


    /**
     * 轉成SQL字串
     * @param sour 待轉資料
     * @return String 字串
     */
    public static String toSqlStr(Object sour)
    {
        return toString(sour).replaceAll("'", "''");
    }


    /**
     * 轉成資料庫的比較字串
     * @param sour 待轉資料
     * @param toSqlStr 是否需要先轉成資料庫字串,預設為true
     * @return String 字串
     */
    public static String toEqualsSql(Object sour, boolean toSqlStr)
    {
        String retValue = toString(sour);
        // 轉成資料庫字串
        if ( toSqlStr )
            retValue = toSqlStr(sour);
        // 一個斜杠需轉換成兩個斜杠(MySQL 資料庫使用)
        return retValue.replaceAll("\\\\", "\\\\\\\\");
    }


    /**
     * 轉成資料庫的比較字串
     * @param sour 待轉資料
     * @return String 字串
     */
    public static String toEqualsSql(Object sour)
    {
        return toEqualsSql(sour, true);
    }


    /**
     * 轉成資料庫的like字串
     * @param sour 待轉資料
     * @param toSqlStr 是否需要先轉成資料庫字串,預設為true
     * @return String 字串
     */
    public static String toLikeSql(Object sour, boolean toSqlStr)
    {
        // 一個斜杠轉成四個(MySQL語法,由於前面已經將1個斜杠轉成兩個,這裡只需再轉成兩個就行了)
        String value = toEqualsSql(sour, toSqlStr).replaceAll("\\\\", "\\\\\\\\");
        // 處理特殊符號，這裡用“\”做轉義符號(“%”轉成“\%”,“_”轉成“\_”)；
        // 如果含有特殊符號，Oracle請在條件的最後面加上“escape'\'”
        value = value.replaceAll("%", "\\\\%").replaceAll("_", "\\\\_");
        // 將空格轉變成匹配任意內容
        return value.replaceAll("\\s", "%");
    }


    /**
     * 轉成資料庫的like字串
     * @param sour 待轉資料
     * @return String 字串
     */
    public static String toLikeSql(Object sour)
    {
        return toLikeSql(sour, true);
    }


    /**
     * 利用MD5進行加密,並用 16 進制的形式表示
     * @param source 待加密的字串
     * @return 加密後的字串
     */
    public static String MD5(String source)
    {
        char hexDigits[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'A', 'B', 'C', 'D', 'E', 'F'};
        try
        {
            byte[] strTemp = source.getBytes();
            // 確定加密方法
            MessageDigest mdTemp = MessageDigest.getInstance("MD5");
            mdTemp.update(strTemp);
            // MD5 的計算結果是一個 128 位的長整數, 用字元表示就是 16 個字節
            byte[] md = mdTemp.digest();
            int j = md.length;
            // 每個字節用 16 進制表示的話, 使用兩個字節, 所以表示成 16 進制需要 32 個字節
            char str[] = new char[j * 2];
            // 表示轉換結果中對應的字節位置
            int k = 0;
            // 逐個將 MD5 的字節轉換成 16 進制字節
            for ( int i = 0; i < j; i++ )
            {
                byte byte0 = md[i];
                // 取字節中高 4 位的數字轉換, >>> 為邏輯右移, 將符號位一起右移
                str[k++] = hexDigits[byte0 >>> 4 & 0xf];
                // 取字節中低 4 位的數字轉換
                str[k++] = hexDigits[byte0 & 0xf];
            }
            return new String(str);
        }
        // 捕獲例外
        catch ( NoSuchAlgorithmException e )
        {
            return "";
        }
    }
}