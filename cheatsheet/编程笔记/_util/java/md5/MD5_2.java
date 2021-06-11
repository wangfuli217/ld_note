/**
 * <P> Title: 公用類別                                      </P>
 * <P> Description: 字串處理                                </P>
 * <P> Copyright: Copyright (c) 2010/07/31                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.everunion.util;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import sun.misc.BASE64Encoder;


/**
 * 字串處理
 * @author Holer W. L. Feng
 * @version 0.1
 */
public final class MD5
{
    /**
     * 利用MD5進行加密
     * @param str 待加密的字串
     * @return 加密后的字串
     */
    public static String MD5Encoder(String str)
    {
        try
        {
            // 確定加密方法
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            BASE64Encoder base64en = new BASE64Encoder();
            // 加密後的字串
            String newstr = base64en.encode(md5.digest(str.getBytes("utf-8")));
            return newstr;
        }
        //沒有這種產生消息摘要的算法
        catch ( NoSuchAlgorithmException e )
        {
            System.out.println("StringUtil.EncoderByMd5 Exception: " + e);
        }
        catch ( UnsupportedEncodingException e )
        {
            System.out.println("StringUtil.EncoderByMd5 Exception: " + e);
        }
        return "";
    }
    

    /**
     * 利用MD5進行加密,並用 16 進制的形式表示
     * @param source 待加密的字串
     * @return 加密後的字串
     */
    public static String EncoderByMd5(String source)
    {
        char hexDigits[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
                'A', 'B', 'C', 'D', 'E', 'F'};
        try
        {
            byte[] strTemp = source.getBytes();
            //確定加密方法
            MessageDigest mdTemp = MessageDigest.getInstance("MD5");
            mdTemp.update(strTemp);
            //MD5 的計算結果是一個 128 位的長整數, 用字元表示就是 16 個字節
            byte[] md = mdTemp.digest();
            int j = md.length;
            //每個字節用 16 進制表示的話, 使用兩個字節, 所以表示成 16 進制需要 32 個字節
            char str[] = new char[j * 2];
            //表示轉換結果中對應的字節位置
            int k = 0;
            //逐個將 MD5 的字節轉換成 16 進制字節
            for ( int i = 0; i < j; i++ )
            {
                byte byte0 = md[i];
                //取字節中高 4 位的數字轉換,  >>> 為邏輯右移, 將符號位一起右移
                str[k++] = hexDigits[byte0 >>> 4 & 0xf];
                //取字節中低 4 位的數字轉換
                str[k++] = hexDigits[byte0 & 0xf];
            }
            return new String(str);
        }
        //捕獲例外
        catch ( NoSuchAlgorithmException e )
        {
            return "";
        }
    }
    
}
