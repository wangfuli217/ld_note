package guoling;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * 字串處理
 * @author Holer W. L. Feng
 * @version 0.1
 */
public final class MD5
{
    /**
     * 利用MD5進行加密,並用 16 進制的形式表示
     * @param source 待加密的字串
     * @return 加密後的字串
     */
    public static String encode(String source)
    {
        char hexDigits[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
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
    
    public static void test_main(String[] args) {
        System.out.println(encode("20121221")); // 1F69B3D54C2F95A014EA3CC131A34D5B
        System.out.println(encode("加密")); //56563EDF23B9D717DC63981B8836FC60
    }
}
