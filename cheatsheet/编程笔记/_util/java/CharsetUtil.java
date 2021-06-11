/**
 * <P> Title: GipAdmin </P>
 * <P> Description: 轉換字串編碼的工具類別 </P>
 * <P> Copyright: Copyright (c) 2010/03/05 </P>
 * <P> Company:Everunion Tech. Ltd. </P>
 */


package com.util;

import java.io.UnsupportedEncodingException;

/**
 * 轉換字串編碼的工具類別
 * @author Holer W. L. Feng
 * @version 0.1
 */
public class CharsetUtil
{
    /**
     * 7位元ASCII字元，也叫作ISO646-US、Unicode字元集的基本拉丁塊
     */
    public static final String US_ASCII = "US-ASCII";
    
    /**
     * ISO 拉丁字母表 No.1，也叫作 ISO-LATIN-1
     */
    public static final String ISO_8859_1 = "ISO-8859-1";
    
    /**
     * 8 位 UCS 轉換格式
     */
    public static final String UTF_8 = "UTF-8";
    
    /**
     * 16 位 UCS 轉換格式，Big Endian（最低位址存放高位位元組）位元組順序
     */
    public static final String UTF_16BE = "UTF-16BE";
    
    /**
     * 16 位 UCS 轉換格式，Little-endian（最高位址存放低位元位元組）位元組順序
     */
    public static final String UTF_16LE = "UTF-16LE";
    
    /**
     * 16 位元 UCS 轉換格式，位元組順序由可選的位元組順序標記來標識
     */
    public static final String UTF_16 = "UTF-16";
    
    /**
     * 中文超大字元集
     */
    public static final String GBK = "GBK";
    
    /**
     * 中文常用字元集
     */
    public static final String GB2312 = "GB2312";
    
    /**
     * 繁體(正體)中文字元集
     */
    public static final String BIG5 = "BIG5";
    
    
    /**
     * 將字元編碼轉換成US-ASCII碼
     * @param str 待轉換編碼的字串
     * @return String 轉換編碼後的字串
     * @throws UnsupportedEncodingException
     */
    public static String toASCII(String str) throws UnsupportedEncodingException
    {
        return changeCharset(str, US_ASCII);
    }
    

    /**
     * 將字元編碼轉換成ISO-8859-1碼
     * @param str 待轉換編碼的字串
     * @return String 轉換編碼後的字串
     * @throws UnsupportedEncodingException
     */
    public static String toISO_8859_1(String str) throws UnsupportedEncodingException
    {
        return changeCharset(str, ISO_8859_1);
    }
    

    /**
     * 將字元編碼轉換成UTF-8碼
     * @param str 待轉換編碼的字串
     * @return String 轉換編碼後的字串
     * @throws UnsupportedEncodingException
     */
    public static String toUTF_8(String str) throws UnsupportedEncodingException
    {
        return changeCharset(str, UTF_8);
    }
    

    /**
     * 將字元編碼轉換成UTF-16BE碼
     * @param str 待轉換編碼的字串
     * @return String 轉換編碼後的字串
     * @throws UnsupportedEncodingException
     */
    public static String toUTF_16BE(String str) throws UnsupportedEncodingException
    {
        return changeCharset(str, UTF_16BE);
    }
    

    /**
     * 將字元編碼轉換成UTF-16LE碼
     * @param str 待轉換編碼的字串
     * @return String 轉換編碼後的字串
     * @throws UnsupportedEncodingException
     */
    public static String toUTF_16LE(String str) throws UnsupportedEncodingException
    {
        return changeCharset(str, UTF_16LE);
    }
    

    /**
     * 將字元編碼轉換成UTF-16碼
     * @param str 待轉換編碼的字串
     * @return String 轉換編碼後的字串
     * @throws UnsupportedEncodingException
     */
    public static String toUTF_16(String str) throws UnsupportedEncodingException
    {
        return changeCharset(str, UTF_16);
    }
    

    /**
     * 將字元編碼轉換成GBK碼
     * @param str 待轉換編碼的字串
     * @return String 轉換編碼後的字串
     * @throws UnsupportedEncodingException
     */
    public static String toGBK(String str) throws UnsupportedEncodingException
    {
        return changeCharset(str, GBK);
    }
    

    /**
     * 將字元編碼轉換成BIG5碼
     * @param str 待轉換編碼的字串
     * @return String 轉換編碼後的字串
     * @throws UnsupportedEncodingException
     */
    public static String toBIG5(String str) throws UnsupportedEncodingException
    {
        return changeCharset(str, BIG5);
    }
    

    /**
     * 字串編碼轉換的實現方法
     * @param str 待轉換編碼的字串
     * @param newCharset 目標編碼
     * @return String 轉換編碼後的字串
     * @throws UnsupportedEncodingException
     */
    public static String changeCharset(String str, String newCharset)
            throws UnsupportedEncodingException
    {
        if ( str != null )
        {
            // 用預設字元編碼解碼字串。
            byte[] bs = str.getBytes();
            // 用新的字元編碼生成字串
            return new String(bs, newCharset);
        }
        return null;
    }
    

    /**
     * 字串編碼轉換的實現方法
     * @param str 待轉換編碼的字串
     * @param oldCharset 原編碼
     * @param newCharset 目標編碼
     * @return String 轉換編碼後的字串
     * @throws UnsupportedEncodingException
     */
    public static String changeCharset(String str, String oldCharset, String newCharset)
            throws UnsupportedEncodingException
    {
        if ( str != null )
        {
            // 用舊的字元編碼解碼字串。解碼可能會出現異常。
            byte[] bs = str.getBytes(oldCharset);
            // 用新的字元編碼生成字串
            return new String(bs, newCharset);
        }
        return null;
    }
    

    /**
     * 字串轉換成Unicode編碼
     * @param str 待轉換編碼的字串
     * @param allChanges 字母、數字和符號是否也需要轉換，為true也轉換，為false時不轉換
     * @return 轉換編碼後的字串(小寫形式) 如果希望得到大寫字母的形式，可使用：CharsetUtil.toUnicode(str).toUpperCase()
     */
    public static String toUnicode(String str, boolean allChanges)
    {
        // 防呆
        if ( str == null || "".equals(str.trim()) )
            return "";
        StringBuilder sb = new StringBuilder();
        // 逐個轉換
        for ( int i = 0; i < str.length(); i++ )
        {
            // 如果是斜杠
            if ( str.charAt(i) == '\\' )
            {
                sb.append("\\u00").append(Integer.toHexString(str.charAt(i)));
            }
            // 如果是3位的字串(中文字串的範圍：'\u4e00' ~ '\u9fa5' )
            else if ( str.charAt(i) >= '\u0100' && str.charAt(i) <= '\u0fff' )
            {
                sb.append("\\u0").append(Integer.toHexString(str.charAt(i)));
            }
            // 如果是4位的字串
            else if ( str.charAt(i) >= '\u1000' )
            {
                sb.append("\\u").append(Integer.toHexString(str.charAt(i)));
            }
            // 字母、數字、符號等，如果也需轉換
            else if ( allChanges )
            {
                // 兩位的字串
                if ( str.charAt(i) >= '\u0010' )
                    sb.append("\\u00").append(Integer.toHexString(str.charAt(i)));
                // 1位的字串(測試的例子最好是\t)
                else
                    sb.append("\\u000").append(Integer.toHexString(str.charAt(i)));
            }
            // 字母、數字、符號等，不改變
            else
            {
                sb.append(str.charAt(i));
            }
        }
        return sb.toString();
    }
    

    /**
     * 字串轉換成Unicode編碼
     * @param str 待轉換編碼的字串，不轉換字母、數字和符號
     * @return 轉換編碼後的字串(小寫形式) 如果希望得到大寫字母的形式，可使用：CharsetUtil.toUnicode(str).toUpperCase()
     */
    public static String toUnicode(String str)
    {
        return toUnicode(str, false);
    }
    

    /**
     * 將Unicode編碼的字串還原
     * @param str 待轉換編碼的字串
     * @return 還原後的字串(包括中文)
     */
    public static String decodeUnicode(String hex)
    {
        StringBuffer sb = new StringBuffer("");
        for ( int i = 0; i < hex.length(); i = i + 6 )
        {
            // 字符不夠長時，取字符的總長度
            int j = (i + 6 >= hex.length()) ? hex.length() : i + 6;
            String temp = hex.substring(i, j);
            // 結束符？？？(有待研究)
            if ( temp.equalsIgnoreCase("\\u0000") )
                break;
            // 如果是沒被轉換的字串
            if ( !temp.startsWith("\\") )
            {
                sb.append(temp.charAt(0));
                i = i - 5;
            }
            // 如果是轉換後的字串(\\u開頭的)
else
            {
                String temp2 = "" + temp.charAt(2) + temp.charAt(3) + temp.charAt(4)
                        + temp.charAt(5);
                char t = (char)Integer.parseInt(temp2, 16);
                sb.append(t);
            }
        }
        return sb.toString();
    }
    

    public static void main(String[] args) throws UnsupportedEncodingException
    {
        String str = "This is a 中文的 String!";
        System.out.println("str: " + str);
        String gbk = toBIG5(str);
        System.out.println("轉換成BIG5碼: " + gbk);
        
        // String s = new String("中文".getBytes("UTF-8"), "UTF-8");
        System.out.println(toUnicode("哈哈sdfsd1516~!@#$%^&*()_+| /\\", true));
        System.out.println(decodeUnicode(toUnicode("哦哦哦123ee", true)));
        System.out.println(decodeUnicode("\\u010f"));
        System.out.println(decodeUnicode("\\u0000"));
    }
}
