/**
 * <P> Title: ftc                                           </P>
 * <P> Description: Json工具類                             </P>
 * <P> Copyright: Copyright (c) 2009/08/24                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 * @author Andy
 * @version 0.1 Original Design from design document.
 */
package com.util;

public class JsonUtil
{
    /**
     * 作業失敗
     * @param mess 訊息
     * @return 訊息
     */
    public static String ErrorAjax(String mess)
     {
         return "{\"state\":500,\"mess\":\"" + mess + "\"}";
     }

    
     /**
     * 作業成功
     * @param mess 訊息
     * @return 訊息
     */
     public static String SuccAjax(String mess)
     {
         return "{\"state\":200,\"mess\":\"" + mess + "\"}";
     }
     
     
     /**
      * 成功
      * @param mess 訊息
      * @param plug 其他
      * @return 訊息
      */
     public static String SuccAjax(String mess, String plug)
     {
         return "{\"state\":200,\"mess\":\"" + mess + "\""+(StringUtil.toString(plug).length()>0?"," + plug:"")+"}";
     }
     
    
     /**
      * 成功或失敗
      * @param flag 成功失敗
      * @param mess 訊息
      * @return Json資料
      */
      public static String ReturnAjax(boolean flag, String mess)
      {
          return "{\"state\":"+(flag?"200":"500")+",\"mess\":\"" + mess +(flag?"成功!":"失敗!") + "\"}";
      }
}
