

/**     
 * <P> Title: 編碼資訊                          </P>    
 * <P> Description: 編碼處理                    </P>    
 * <P> Copyright: Copyright (c) 2008/05/31      </P>    
 * <P> Company:Everunion Tech. Ltd.             </P>    
 * @author kevin
 * @version 0.1 Original Design from design document.
 * @example  String passord = UtilGlobals.Base64Encoding(str);
 */

package com.everunion.encode;

/**
 * 編碼處理
 */
public final class UtilGlobals
{

    /**
     * 建構方法
     */
    private UtilGlobals()
    {
    }

    /**
     * Base64編碼
     * @param str 待編碼字串
     * @return String 編碼後字串
     */
    public static String Base64Encoding(String str)
    {
        byte bytes[] = str.getBytes();
        char chars[] = Base64.encode(bytes);
        return new String(chars);
    }

    /**
     * Base64反編碼
     * @param str 待編碼字串
     * @return String 反編碼後字串
     */
    public static String Base64Decoding(String str)
    {
        String ret = str;
        try
        {
            if(isDecode(str)){
            	char chars[] = str.toCharArray();
            	byte bytes[] = Base64.decode(chars);
            	ret = new String(bytes);
            }
            
        }
        catch(Exception e)
        {
            System.out.println(e);
        }
        return ret;
    }

    /**
     * 是否已反編碼
     * @param str 字串
     * @return boolean 是或否
     */
    public static boolean isDecode(String str)
    {
        boolean ok = true;
        try
        {
            char chars[] = str.toCharArray();
            ok = Base64.isDecode(chars);
        }
        catch(Exception e)
        {
            System.out.println(e);
        }
        return ok;
    }
}