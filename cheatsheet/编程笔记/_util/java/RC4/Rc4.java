package guoling;

/**
 * Rc4 加密
 *
 * @author Holer
 */
public class Rc4 {

	/**
	 * 将rc4加密后的密文，解密出来
	 * @param rc4Txt RC4加密后的密文
	 * @param key 加密/解密的key值
	 * @return 返回解密后的明文
	 */
    public static String decode(String rc4Txt, String key) {
        if (rc4Txt == null || key == null) {
            return null;
        }
        return new String(RC4Base(HexString2Bytes(rc4Txt), key));
    }

    /**
	 * 将rc4加密后的密文，解密出来
	 * @param rc4Txt RC4加密后的密文字节数组
	 * @param key 加密/解密的key值
	 * @return 返回解密后的明文
     */
    public static String decode(byte[] rc4Txt, String key) {
        if (rc4Txt == null || key == null) {
            return null;
        }
        return asString(RC4Base(rc4Txt, key));
    }


    /**
     * 将明文字符串，用RC4加密成密文
     * @param realText 明文的字符串
     * @param key 加密/解密的key值
     * @return 返回加密后的密文
     */
    public static String encode(String realText, String key) {
        if (realText == null || key == null) {
            return null;
        }
        return toHexString(asString(encry_RC4_byte(realText, key)));
    }

    /**
     * 将明文字符串，用RC4加密成密文
     * @param realText 明文的字符串
     * @param key 加密/解密的key值
     * @return 返回加密后的密文字节数组
     */
    public static byte[] encry_RC4_byte(String realText, String key) {
        if (realText == null || key == null) {
            return null;
        }
        byte b_data[] = realText.getBytes();
        return RC4Base(b_data, key);
    }

    private static String asString(byte[] buf) {
        StringBuffer strbuf = new StringBuffer(buf.length);
        for (int i = 0; i < buf.length; i++) {
            strbuf.append((char) buf[i]);
        }
        return strbuf.toString();
    }

    private static byte[] initKey(String aKey) {
        byte[] b_key = aKey.getBytes();
        byte state[] = new byte[256];

        for (int i = 0; i < 256; i++) {
            state[i] = (byte) i;
        }
        int index1 = 0;
        int index2 = 0;
        if (b_key == null || b_key.length == 0) {
            return null;
        }
        for (int i = 0; i < 256; i++) {
            index2 = ((b_key[index1] & 0xff) + (state[i] & 0xff) + index2) & 0xff;
            byte tmp = state[i];
            state[i] = state[index2];
            state[index2] = tmp;
            index1 = (index1 + 1) % b_key.length;
        }
        return state;
    }

    private static String toHexString(String s) {
        String str = "";
        for (int i = 0; i < s.length(); i++) {
            int ch = (int) s.charAt(i);
            String s4 = Integer.toHexString(ch & 0xFF);
            if (s4.length() == 1) {
                s4 = '0' + s4;
            }
            str = str + s4;
        }
        return str;// 0x表示十六进制
    }

    private static byte[] HexString2Bytes(String src) {
        int size = src.length();
        byte[] ret = new byte[size / 2];
        byte[] tmp = src.getBytes();
        for (int i = 0; i < size / 2; i++) {
            ret[i] = uniteBytes(tmp[i * 2], tmp[i * 2 + 1]);
        }
        return ret;
    }

    private static byte uniteBytes(byte src0, byte src1) {
        char _b0 = (char)Byte.decode("0x" + new String(new byte[] { src0 }))
                .byteValue();
        _b0 = (char) (_b0 << 4);
        char _b1 = (char)Byte.decode("0x" + new String(new byte[] { src1 }))
                .byteValue();
        byte ret = (byte) (_b0 ^ _b1);
        return ret;
    }

    private static byte[] RC4Base (byte [] input, String mKkey) {
        int x = 0;
        int y = 0;
        byte key[] = initKey(mKkey);
        int xorIndex;
        byte[] result = new byte[input.length];

        for (int i = 0; i < input.length; i++) {
            x = (x + 1) & 0xff;
            y = ((key[x] & 0xff) + y) & 0xff;
            byte tmp = key[x];
            key[x] = key[y];
            key[y] = tmp;
            xorIndex = ((key[x] & 0xff) + (key[y] & 0xff)) & 0xff;
            result[i] = (byte) (input[i] ^ key[xorIndex]);
        }
        return result;
    }

	public static void main(String[] args) {
	//public static void test_main(String[] args)	{
		System.out.println("36824f33ca5d6c".equals(Rc4.encode("01A0519", "1bb762f7ce24ceee")));
		System.out.println("01A0519".equals(Rc4.decode("36824f33ca5d6c", "1bb762f7ce24ceee")));

		System.out.println("e32086e66ce4".equals(Rc4.encode("哈哈", "1bb762f7ce24ceee")));
		System.out.println("哈哈".equals(Rc4.decode("e32086e66ce4", "1bb762f7ce24ceee")));
	}
}
