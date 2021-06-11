/**
 * <P> Title: 公用類別                                        </P>
 * <P> Description: 數字處理工具                            </P>
 * <P> Copyright: Copyright (c) 2010/07/31                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.util;


/**
 * 數字處理工具
 * @author Holer W. L. Feng
 * @version 0.1
 */
public class NumberUtil
{
    /**
     * 將數字格式化
     * @param source 需要進行轉換的字串或數字
     * @param decimal 結果要求保留多少位小數，小於等於0時，傳回整數
     * @param sign 分隔符號，例如逗號、空格等，預設為逗號
     * @param signNumber 每多少位數字分隔一次數值的整數字串
     * @return 轉換後的字串
     */
    public static String format(Object source, int decimal, String sign, int signNumber)
    {
        String retValue = "";
        // 將需要轉換的參數變成字串，以便處理
        String numberStr = "" + source;
        numberStr = numberStr.trim();
        //如果是加號開頭
        if ( numberStr.startsWith("+") )
        {
            numberStr = numberStr.substring(1);
            retValue += "+";
        }
        //如果是負數
        else if ( numberStr.startsWith("-") )
        {
            numberStr = numberStr.substring(1);
            retValue += "-";
        }
        //如果數值是0開頭的
        while( numberStr.startsWith("0") )
        {
            if ( numberStr.length() > 1 && '.' == numberStr.charAt(1) )
                break;
            numberStr = numberStr.substring(1);
        }
        // 去除數字中的逗號、空格等分隔符號
        numberStr = numberStr.replaceAll(",", "");
        numberStr = numberStr.replaceAll(" ", "");
        numberStr = numberStr.replaceAll(sign, "");
        // 四舍五入
        numberStr = round ( numberStr, decimal );
        //分解字串 number[0]為整數部分， number[1]為小數部分
        String[] number = new String[]{"", ""};
        number = numberStr.split("\\.");
        //如果字串是個整數
        if ( 1 == number.length )
            number = new String[]{number[0], ""};
        // 如果是科學記數法的數值
        if ( numberStr.indexOf("E") > 0 || numberStr.indexOf("e") > 0 )
        {
            double value = Double.parseDouble(numberStr);
            // 整數部分的值
            Double intValue = (value > 0) ? Math.floor(value) : Math.ceil(value);
            // 沒超過 double 的精度(18位有效數字)
            if ( Double.compare(value, 1.0E18-1) <= 0  )
            {
                long longValue = Math.round(intValue); 
                number[0] = "" + longValue;
                number[0] = number[0].split("\\.")[0];
                // 小數部分的值(不精確)
                String[] n = round( (value - intValue) + "", decimal ).split("\\.");
                number[1] = ( n.length == 1 )? "" : n[1];
            }
            // 超過 double 的精度
            else
            {
                number = intValue.toString().split("E");
                number[0] = number[0].replace(".", "");
                // 給結果補足上足夠的0
                for ( int i = number[0].length(); i < Integer.parseInt(number[1]); i++ )
                {
                    number[0] += "0";
                }
                // 小數部分只補足上足夠的0，因為小數部分早已不能精確了
                number[1] = "";
            }
            // 給小數部分補足上足夠的0
            for ( int i = number[1].length(); i < decimal; i++ )
            {
                number[1] += "0";
            }
        }
        // 格式化(分隔數字)
        if ( signNumber > 0 )
        {
            //整數的第一部分的長度
            int tem = number[0].length() % signNumber;
            String temStr = "";
            //如果整數部分的長度剛好是signNumber的倍數
            if ( 0 == tem )
                tem = signNumber;
            //整數的第一部分
            temStr = number[0].substring(0, tem );
            //整數的其他部分
            for ( int i = 1; i < (number[0].length() + signNumber - 1) / signNumber; i++ )
            {
                temStr += sign + number[0].substring( (i - 1) * signNumber + tem, i * signNumber + tem );
            }
            number[0] = temStr;
        }
        // 如果需要保留指定小數位
        if ( decimal > 0 )
            return retValue + number[0] + "." + number[1];
        //傳回
        return retValue + number[0];
    }


    /**
     * 將數字格式化
     * 預設每3位數字分隔一次數值的整數字串
     * @param source 需要進行轉換的字串或數字
     * @param decimal 結果要求保留多少位小數，小於等於0時，傳回整數
     * @param sign 分隔符號，例如逗號、空格等，預設為逗號
     * @return 轉換後的字串
     */
    public static String format(Object source, int decimal, String sign)
    {
        return format(source, decimal, sign, 3);
    }
    
    
    /**
     * 將字串轉換成帶逗號格式的數字字串
     * 預設分隔符號為逗號
     * @param source 需要進行轉換的字串或數字
     * @param decimal 結果要求保留多少位小數，小於等於0時，傳回整數
     * @return 轉換後的字串
     */
    public static String format(Object source, int decimal)
    {
        return format(source, decimal, ",");
    }
    

    /**
     * 將字串轉換成帶逗號格式的數字字串
     * 如果需要進行轉換的字串有小數，則預設保留兩位小數；如果需要進行轉換的字串沒有小數，則預設不保留小數
     * @param source 需要進行轉換的字串或數字
     * @param decimal 結果要求保留多少位小數，小於等於0時，傳回整數
     * @param sign 分隔符號，例如逗號、空格等，預設為逗號
     * @return 轉換後的字串
     */
    public static String format(Object source, String sign)
    {
        // 結果要求保留多少位小數
        int decimal = 0;
        // 判斷需要進行轉換的字串是否有小數
        String number = "" + source;
        if ( number.indexOf(".") > 0 )
            decimal = 2;
        return format(source, decimal, sign);
    }
    
    
    /**
     * 將字串轉換成帶逗號格式的數字字串
     * 如果需要進行轉換的字串有小數，則預設保留兩位小數；如果需要進行轉換的字串沒有小數，則預設不保留小數
     * 預設分隔符號為逗號, 預設每3位加一個分隔符號
     * @param source 需要進行轉換的字串或數字
     * @return 轉換後的字串
     */
    public static String format(Object source)
    {
        return format(source, ",");
    }
    
    
    /**
     * 將物件轉換成 double 類型數值
     * @param source 需轉換的物件
     * @param init 預設值
     * @return 轉換後的數值
     */
    public static double toDouble(Object source, double init)
    {
        try
        {
            // 數值轉換
            return Double.parseDouble("" + source);
        }
        catch ( Exception e )
        {
            // 數值轉換出現例外時，傳回預設值
            return init;
        }
    }
    

    /**
     * 將物件轉換成 double 類型數值，無法轉換時傳回0.0
     * @param source 需轉換的物件
     * @return 轉換後的數值
     */
    public static double toDouble(Object source)
    {
        return toDouble(source, 0.0);
    }
    

    /**
     * 將物件轉換成 float 類型數值
     * @param source 需轉換的物件
     * @param init 預設值
     * @return 轉換後的數值
     */
    public static float toFloat(Object source, float init)
    {
        try
        {
            // 數值轉換
            return Float.parseFloat("" + source);
        }
        catch ( Exception e )
        {
            // 數值轉換出現例外時，傳回預設值
            return init;
        }
    }
    

    /**
     * 將物件轉換成 float 類型數值，無法轉換時傳回0.0
     * @param source 需轉換的物件
     * @return 轉換後的數值
     */
    public static float toFloat(Object source)
    {
        return toFloat(source, 0.0F);
    }
    
    
    /**
     * 將物件轉換成 long 類型數值
     * @param source 需轉換的物件(可以是 String 或 Number 類型，小數部分直接省略)
     * @param init 預設值，類型無法轉換成 long 或者超出 long 範圍時傳回預設值
     * @return 轉換後的數值
     */
    public static long toLong(Object source, long init)
    {
        double value = toDouble(source, init);
        // 取出整數部分的值
        double intValue = (value > 0) ? Math.floor(value) : Math.ceil(value);
        // 如果數值超出 long 值的範圍
        if ( Double.compare( intValue, Long.MAX_VALUE ) > 0 )
            return init;
        return Math.round(intValue);
    }
    

    /**
     * 將物件轉換成 long 類型數值，類型無法轉換成 long 或者超出 long 範圍時傳回0
     * @param source 需轉換的物件(可以是 String 或 Number 類型，小數部分直接省略)
     * @return 轉換後的數值
     */
    public static long toLong(Object source)
    {
        return toLong(source, 0L);
    }
    

    /**
     * 將物件轉換成 int 類型數值
     * @param source 需轉換的物件(可以是 String 或 Number 類型，小數部分直接省略)
     * @param init 預設值，類型無法轉換成 int 或者超出 int 範圍時傳回預設值
     * @return 轉換後的數值
     */
    public static int toInt(Object source, int init)
    {
        double value = toDouble(source, init);
        // 取出整數部分的值
        double intValue = (value > 0) ? Math.floor(value) : Math.ceil(value);
        // 如果數值超出 Integer 值的範圍
        if ( Double.compare( intValue, Integer.MAX_VALUE ) > 0 )
            return init;
        return Integer.parseInt("" + Math.round(intValue));
    }
    

    /**
     * 將物件轉換成 int 類型數值，類型無法轉換成 int 或者超出 int 範圍時傳回0
     * @param source 需轉換的物件(可以是 String 或 Number 類型，小數部分直接省略)
     * @return 轉換後的數值
     */
    public static int toInt(Object source)
    {
        return toInt(source, 0);
    }
    
    
    /**
     * 對數值進行舍入
     * @param source 需要舍入的數值字串
     * @param decimal 結果要求保留多少位小數，小於等於0時，傳回整數
     * @return 舍入後的數值字串
     */
    public static String round ( Object source, int decimal )
    {
        String retValue = "";
        String numberStr = "" + source;
        // 如果是數值類型，交給數值的處理方法
        if ( source instanceof Number )
            return "" + round ( Double.parseDouble(numberStr), decimal );
        //去除數字中的逗號
        numberStr = numberStr.replaceAll(",", "");
        numberStr = numberStr.replaceAll(" ", "");
        //分解字串 number[0]為整數部分， number[1]為小數部分
        String[] number = new String[]{"", ""};
        number = numberStr.split("\\.");
        //如果字串是個整數
        if ( 1 == number.length )
            number = new String[]{number[0], ""};
        // 如果是加號開頭，刪除它
        if ( number[0].startsWith("+") )
            number[0] = number[0].substring(1, number[0].length()-1);
        try
        {
            Double.parseDouble(numberStr);
        }
        // 如果不是正確的數值
        catch ( Exception e )
        {
            number[0] = "0";
            number[1] = "0";
        }
        // 如果是科學計數法的數值
        if ( numberStr.indexOf("E") > 0 || numberStr.indexOf("e") > 0 )
        {
            return "" + round ( Double.parseDouble(numberStr), decimal );
        }
        // 如果需要保留指定小數位
        if ( decimal > 0 )
        {
            // 如果小數需要舍入
            if ( number[1].length() > decimal && Integer.parseInt("" + number[1].charAt(decimal)) >=5 )
            {
                int i = Integer.parseInt("" + number[1].charAt(decimal-1)) + 1;
                // 如果需要進位
                if ( i > 9 )
                {
                    long j = Long.parseLong(number[1].substring(0, decimal)) + 1;
                    int len = number[1].substring(0, decimal).length();
                    number[1] = "" + j;
                    // 如果需要進位到整數
                    if ( number[1].length() != len )
                    {
                        j = Long.parseLong(number[0]) + 1;
                        number[0] = "" + j;
                        number[1] = "";
                    }
                }
                // 舍入後不需要進位
                else
                    number[1] = number[1].substring(0, decimal-1) + i;
            }
            // 給結果補足要求保留的小數位
            for ( int i = number[1].length(); i < decimal; i++ )
            {
                number[1] += "0";
            }
            number[1] = number[1].substring(0, decimal);
            retValue = number[0] + "." + number[1];
        }
        // 如果只需傳回整數
        else
        {
            // 如果需要舍入
            if ( number[1].length() > 0 && Integer.parseInt("" + number[1].charAt(0)) >=5 )
            {
                long j = Long.parseLong(number[0]) + 1;
                number[0] = "" + j;
            }
            retValue = number[0];
        }
        return retValue;
    }
    

    /**
     * 對數值進行舍入
     * 如果數值包含有小數，則保留兩位小數；如果沒有小數，則傳回整數
     * @param source 需要舍入的數值字串
     * @return 舍入後的數值字串
     */
    public static String round ( Object source )
    {
        // 結果要求保留多少位小數
        int decimal = 0;
        // 判斷需要進行轉換的字串是否有小數
        String number = "" + source;
        if ( number.indexOf(".") > 0 )
            decimal = 2;
        return round(source, decimal);
    }
    
    /**
     * 對數值四舍五入
     * @param source 需要舍入的數值
     * @param decimal 結果要求保留多少位小數，小於等於0時，傳回整數
     * @return 舍入後的數值
     */
    public static double round ( double source, int decimal )
    {
        // 取出數值的整數部分
        double intValue = (source > 0) ? Math.floor(source) : Math.ceil(source);
        // 保留多少位小數的次冪
        double lay = (decimal > 0 ) ? Math.pow(10, decimal) : 1;
        // 舍入小數部分 
        long r = Math.round((source - intValue) * lay);
        return r / lay + intValue;
    }
    

    /**
     * 對數值四舍五入
     * @param source 需要舍入的數值
     * @param decimal 結果要求保留多少位小數，小於等於0時，傳回整數
     * @return 舍入後的數值
     */
    public static float round ( float source, int decimal )
    {
        try
        {
            return (float) round ( (double) source, decimal );
        }
        catch ( Exception e )
        {
            return 0F;
        }
    }
    
    
    /**
     * 計算總和值
     * @param args 需要求總和值得參數，要求參數是數字類型
     * @return 所有參數的總和值
     */
    public static String sum( String... args )
    {
        return sum( null, args );
    }


    /**
     * 計算總和值
     * @param sour 儲存著所需內容的物件
     * @param args 物件里對應的值的名稱，可以有多個
     * @return 所有參數的總和值
     */
    public static String sum( Object sours, String... args )
    {
        double sumDoub = 0.0;
        // 如果參數為空
        if ( args == null ) return "0";
        try
        {
            // 逐一加上參數的值
            for ( int i = 0; i < args.length; i++ )
            {
                    String tem = "";
                    // 如果需要取出物件里的值
                    if ( sours != null )
                        tem =  StringUtil.getValue(sours, args[i], "0");
                    // 如果沒有物件，直接用此值
                    else
                        tem = "" + args[i];
                    // 如果參數沒有值
                    if ( tem == null || "".equals(tem.trim()) || "null".equalsIgnoreCase(tem) || "NaN".equals(tem) )
                        tem = "0";
                    // 去除數字中的逗號、空格等分隔符號
                    tem = tem.replaceAll(",", "");
                    tem = tem.replaceAll(" ", "");
                    // 將參數轉成數字類型再相加
                    sumDoub += Double.parseDouble(tem);
            }
            // 如果結果為整數，傳回整數，否則傳回兩位小數的數值
            if ( 0 == Double.compare(sumDoub, Math.round(sumDoub)) )
                return format(sumDoub, 0);
        }
        // 出現例外，可能是 NumberFormatException 或者 NumberFormatException
        catch ( Exception e )
        {
            System.out.println(e.toString());
        }
        //回傳字串類型的總和值
        return format(sumDoub);
    }

    
    /**
     * 計算百分比
     * @param totalNum 被除數(總數)
     * @param number2 除數
     * @param totalName 總值的名稱
     * @return 兩數百分比的字串，字串結果為“（占 name 的 number％）”或“（占  number％）”
     */
    public static String getPercent( Object totalNum, Object number2, String totalName)
    {
        String retValue = "\uFF08\u5360" + totalName + "\u7684";
        //如果沒有總值的名稱
        if ( totalName == null || "".equals(totalName) )
            retValue = "\uFF08\u5360";
        //如果被除數為0，不可以計算
        if ( 0 == new Double("" + totalNum).compareTo(0.0) )
            retValue += "0";
        else
        {
            //相除的結果
            double d = new Double("" + number2) / new Double("" + totalNum) * 100;
            //變成只有兩位小數的字串
            retValue += format( d, 2 );
        }
        //傳回字串結果為:（占 totalName 的 number％）或 （占  number％）
        return (retValue + "\uFF05\uFF09");
    }

    
    /**
     * 計算百分比
     * @param totalNum 被除數(總數)
     * @param number2 除數
     * @return 兩數百分比的字串，字串結果為“（占  number％）”
     */
    public static String getPercent( Object totalNum, Object number2)
    {
        return getPercent( totalNum, number2, null );
    }
}
