/**
 * <P> Title: 公用類別                                        </P>
 * <P> Description: 日期處理工具                            </P>
 * <P> Copyright: Copyright (c) 2010/07/31                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 日期處理工具
 * @author Holer W. L. Feng
 * @version 0.1
 */
public final class DateUtil 
{
    /**
     * 預設的時間格式
     */
    private static final String pattern = "yyyy/MM/dd HH:mm:ss";
    
    /**
     * 傳回時間格式,如果傳入的格式為空,則傳回預設值
     * @param pattern 時間格式
     * @return 時間格式
     */
    public static String getPattern(String pattern)
    {
        if ( pattern == null || "".equals(pattern) )
            pattern = DateUtil.pattern;
        return pattern;
    }
    
    /**
     * 傳回當時時間
     * @param pattern 時間格式
     * @return 當時時間字串
     */
    public static String now(String pattern)
    {
        pattern = getPattern(pattern);
        return dateToStr(new Date(), pattern);
    }
    
    
    /**
     * 傳回當時時間
     * @param pattern 時間格式
     * @return 當時時間字串
     */
    public static String now()
    {
        return now(null);
    }
    

    /**
     * 按指定格式傳回時間字串
     * @param date 時間
     * @param pattern 時間格式
     * @return 傳回時間字串
     */
    public static String dateToStr(Date date, String pattern) 
    {
        pattern = getPattern(pattern);
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        return sdf.format(date);
    }
    

    /**
     * 按指定格式傳回時間字串
     * @param date 時間
     * @param pattern 時間格式
     * @return 傳回時間字串
     */
    public static String dateToStr(Date date) 
    {
        return dateToStr( date, null ) ;
    }

    
    /**
     * 取得時間
     * @param strDate 時間字串
     * @param pattern 時間格式
     * @return Date 對應的時間
     */
    public static Date strToDate(String strDate, String pattern) throws ParseException 
    {
        pattern = getPattern(pattern);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
        return simpleDateFormat.parse(strDate);
    }
    

    /**
     * 取得時間
     * @param strDate 時間字串
     * @return Date 對應的時間
     */
    public static Date strToDate(String strDate)
    {
        Date date = null;
        //各種日期格式
        String[] pattern = new String[]{
                "yyyy-MM-dd hh:mm:ss.SSS", "yyyy/MM/dd hh:mm:ss.SSS",
                "yyyy-MM-dd hh:mm:ss.S", "yyyy-MM-dd hh:mm:ss", "yyyy-MM-dd",
                "yyyy/MM/dd hh:mm:ss.S", "yyyy/MM/dd hh:mm:ss", "yyyy/MM/dd"};
        //嘗試按多種日期格式轉換，能轉換的則轉換,全都不能轉換則傳回空
        for ( int i = 0; i < pattern.length; i++ )
        {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern[i]);
            try
            {
                //取得日期
                date = simpleDateFormat.parse(strDate);
                //如果日期格式正確（不發生例外），傳回日期
                return date;
            }
            catch( ParseException pe )
            {
            }
        }
        return date;
    }
    

    /**
     * 格式化時間
     * @param millistime 時間
     * @param format 格式
     * @return 格式化時間
     */
    public static String LongToDate(long millistime, String pattern) throws ParseException 
    {
        if ( millistime == 0 ) return "";
        pattern = getPattern(pattern);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
        Date dates = new Date(millistime); 
        return simpleDateFormat.format(dates);
    }

    
    /**
     * 格式化時間
     * @param dateStr 時間
     * @param format 格式
     * @return 格式化時間
     */
    public static long strToLong(String dateStr, String pattern) throws ParseException 
    {
        if ( dateStr == null || dateStr.equals("") ) 
            return 0;
        pattern = getPattern(pattern);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
        Date dates = simpleDateFormat.parse(dateStr);;
        return dates.getTime();
    }
    
    
    /**
     * 格式化時間
     * @param format 格式
     * @return 格式化時間
     */
    public static String toDateStr(String format) throws Exception
    {
        //傳回
        return toDateStr(format, new Date());            
    }
    
    
    /**
     * 格式化時間
     * @param format 格式
     * @param date 時間
     * @return 格式化時間
     */
    public static String toDateStr(String format, Date date) throws Exception
    {
        try
        {
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            //傳回
            return sdf.format(date);
        }
        //例外
        catch ( Exception e )
        {
            System.out.println(e.getMessage());
            throw e;
        }
    }
    
    
    /**
     * 公元到民國
     * @param date　時間
     * @return　String　民國
     */
    public static String gy2mg(String date)
    {
        return gy2mg(date, "-");
    }
    
    
    /**
     * 轉西元
     * @param date　日期
     * @return　String　西元
     */
    public static String mg2gy(String date)
    {
        return Integer.parseInt(date.split("-")[0]) + 1911 + date.substring(date.indexOf("-")); 
    }
    
    
    /**
     * 取民國
     * @return　String　民國
     */
    public static String toMg() throws Exception
    {       
        return gy2mg(toDateStr("yyyy-MM-dd"));
    }
    
   
    /**
     * 時間轉換
     * @param date 時間
     * @param spe　分隔
     * @return　String　時間
     */
    public static String gy2mg(String date, String spe)
    {
        if ( date == null || date.length() < 6 )
            return "";
        //分隔
        String[] dataArr = StringUtil.toString(date).split(spe);
        if ( dataArr == null && dataArr.length != 3 )
            return "";
        //傳回
        return (NumberUtil.toInt(dataArr[0])-1911)+ spe +  StringUtil.right("0" + dataArr[1],2) + spe + StringUtil.right("0" + dataArr[2],2);     
    }

    
    /**
     * 當前的民國日期
     * @return 當前的民國日期,如:990731
     */
    public static int nowmg()
    {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
        return Integer.parseInt(simpleDateFormat.format(new Date()))-19110000;
    }
   
    
    /**
     * 取得當時民國時間
     * @param strDate 要轉為民國時間的時間字串
     * @throws ParseException 
     * @return Date 民國時間
     */
    public static Date mgDate( String strDate ) throws ParseException
    {
        //取得當時公元時間的字串
        String gyTime = strDate;
        if ( strDate == null || strDate.equals("") ) 
        {    
            gyTime = now("yyyy-MM-dd hh:mm:ss");       
        }  
 
        //取得當時公元年份
        String SYear = gyTime.substring(0, gyTime.indexOf("-"));
        //取得民國年份
        int EYear= Integer.parseInt(SYear)-1911;
        //取得當時民國時間
        String mgNow = EYear+gyTime.substring(gyTime.indexOf("-"),gyTime.length());
        return strToDate(mgNow);
    }
    
    
    /**
     * 取得當時民國時間
     * @param  date 日期
     * @param  pattern 日期格式 
     * @throws ParseException 
     * @return String 去掉年份前面的0的時間字串
     */
    public static String mgStr( Date date, String pattern ) throws ParseException
    {
          String regdate = ""; 
          regdate = DateUtil.dateToStr(date,pattern);
          String regdate2 = regdate;
          //去掉年份前面的0
          for ( int i = 0; i < regdate.length(); i++ )
          {
              if ( regdate.charAt(i) != '0' )
              {
                  break; 
              }
              else
              {
                  regdate2 = regdate.substring(i+1); 
              }
          }
        return regdate2;
    }
    
    
}
