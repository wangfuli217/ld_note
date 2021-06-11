/**     
 * <P> Title: 編碼資訊                          </P>    
 * <P> Description: Base64編碼                  </P>    
 * <P> Copyright: Copyright (c) 2008/05/31      </P>    
 * <P> Company:Everunion Tech. Ltd.             </P>    
 * @author kevin
 * @version 0.1 Original Design from design document.   
 */
package com.everunion.encode;

import java.io.PrintWriter;

/**
 * Base64編碼
 */
public final class Base64 
{
	/**
     * 建構方法
     */
    public Base64()
    {
        // TODO Auto-generated constructor stub
    }

    /**
     * 方塊化字元
     * @param pw PrintWriter
     * @param data 待轉比特流
     * @return char[] 轉後字元組
     * @throws Exception 例外
	 */
    public static  char[] MagicDump(PrintWriter pw, byte[] data) throws Exception 
	{
		char[] res = encode(data);
		int step = 72;
		for (int i = 0; i < res.length; i += step ) 
		{
			String s  = null;
			if ( i + step >= res.length ) {
				s = new String(res, i, res.length - i) ;
			} else {
				s =  new String(res, i, step) ;
			}
			pw.println(s);
		}
		return res;
	}

    /**
     * 編碼
     * @param data 待編碼比特流
     * @return char[] 編碼後字元組
     */
	public static  char[] encode(byte[] data) 
	{
		char[] out = new char[((data.length + 2) / 3) * 4];
		for (int i=0, index=0; i<data.length; i+=3, index+=4) 
		{
			boolean quad = false;
			boolean trip = false;

			int val = (0xFF & (int) data[i]);
			val <<= 8;
			if ((i+1) < data.length) {
				val |= (0xFF & (int) data[i+1]);
				trip = true;
			}
			val <<= 8;
			if ((i+2) < data.length) {
				val |= (0xFF & (int) data[i+2]);
				quad = true;
			}

			out[index+3] = alphabet[(quad? (val & 0x3F): 64)];
			val >>= 6;
			out[index+2] = alphabet[(trip? (val & 0x3F): 64)];
			val >>= 6;
			out[index+1] = alphabet[val & 0x3F];
			val >>= 6;
			out[index+0] = alphabet[val & 0x3F];
		}
		return out;
	}

    /**
     * 解碼
     * @param data 待解碼字元組
     * @return byte[] 解碼後比特流
     * @throws Exception 例外
     */
	public static byte[] decode(char[] data) throws Exception 
	{
		int tempLen = data.length;
		int value = 0;
		for ( int ix=0; ix<data.length; ix++ ) 
		{
			value = codes[ data[ix] & 0xFF ];
			if ( (value < 0) && (data[ix] != 61) )
				--tempLen;
		}
		int len = ((tempLen + 3) / 4) * 3;
		if ( tempLen>0 && data[tempLen-1] == '=')
			--len;
		if ( tempLen>1 && data[tempLen-2] == '=')
			--len;
		byte[] out = new byte[len];
 
		int bitRemain = 0;
		int buf = 0;
		int index = 0;

		for (int ix=0; ix<data.length; ix++) 
		{
			value = codes[ data[ix] & 0xFF ];
			if ( value < 0 )
				continue;
			buf <<= 6;
			bitRemain += 6;
			buf |= value;
			if ( bitRemain >= 8 ) {
				bitRemain -= 8;
				out[index++] =  (byte) ((buf >> bitRemain) & 0xff);
			}
		}
 
		if ( index != out.length) {
			throw new Exception("Decoding error! no EOF found");
		}
		return out;
	}

    /**
     * 是否已解碼
     * @param data 待解碼字元組
     * @return boolean 成功與否
     * @throws Exception 例外
     */
	public static boolean isDecode(char[] data)	throws Exception 
	{ 
		int tempLen = data.length;
		int value = 0;
		for ( int ix=0; ix<data.length; ix++ ) {
			value = codes[ data[ix] & 0xFF ]; // ignore
			if ( (value < 0) && (data[ix] != 61) )
				--tempLen;
		}
		int len = ((tempLen + 3) / 4) * 3;
		if ( tempLen>0 && data[tempLen-1] == '=')
			--len;
		if ( tempLen>1 && data[tempLen-2] == '=')
			--len;
		byte[] out = new byte[len];

		// start decode
		int bitRemain = 0;
		int buf = 0;
		int index = 0;

		for (int ix=0; ix<data.length; ix++) {
			value = codes[ data[ix] & 0xFF ];
			if ( value < 0 )
				continue;
			buf <<= 6;
			bitRemain += 6;
			buf |= value;
			if ( bitRemain >= 8 ) {
				bitRemain -= 8;
				out[index++] =  (byte) ((buf >> bitRemain) & 0xff);
			}
		}
 
		if ( index != out.length) { 
			return false;
		}
		else
			return true;
	}

    
	private static char[] alphabet =
	    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".toCharArray();

	private static byte[] codes = new byte[256];
	static 
	{
		for (int i=0; i<256; i++)
			codes[i] = -1;
		for (int i = 'A'; i <= 'Z'; i++)
			codes[i] = (byte)(     i - 'A');
		for (int i = 'a'; i <= 'z'; i++)
			codes[i] = (byte)(26 + i - 'a');
		for (int i = '0'; i <= '9'; i++)
			codes[i] = (byte)(52 + i - '0');
		codes['+'] = 62;
		codes['/'] = 63;
	}
}
