/**
 * <P> Title: test                                          </P>
 * <P> Description: properties屬性檔案操作工具              </P>
 * <P> Copyright: Copyright (c) 2010/03/17                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.MissingResourceException;
import java.util.Properties;
import java.util.ResourceBundle;

/**
 * 對屬性檔案（xx.properties）的操作類別
 * @author Holer W. L. Feng
 * @version 0.1
 */
public class PropertiesUtil
{
    
    /**
     * 採用 Properties類別 取得屬性檔案對應值 <br />
     * 如果屬性檔案在運行時會改動，或者很少使用到的時候建議呼叫此方法 <br />
     * 註：屬性檔案的 key 不能有重複，如有重複只讀取最下麵的一個 <br />
     * @param file 屬性檔案的檔案名， <br />
     *            如工程目錄下/WEB-INF/classes/a.properties，則寫：WEB-INF/classes/a.properties
     * @param propertyName 屬性名
     * @return String 根據屬性名得到的屬性值，沒有值則傳回""，沒有指定的key傳回null
     */
    public static String getValue(String file, String propertyName)
    {
        // 防呆
        if ( file == null || propertyName == null )
            return null;
        String value = "";
        // 載入屬性檔案讀取類別
        Properties p = new Properties();
        FileInputStream in;
        try
        {
            // 以流的形式讀入屬性檔案
            in = new FileInputStream(file);
            p.load(in);
            // 讀完了關閉此流
            in.close();
            // 取得對應的屬性值
            value = p.getProperty(propertyName);
        }
        catch ( Exception e )
        {
            System.out.println("PropertiesUtil.getValue:" + e.toString());
        }
        return value;
    }
    

    /**
     * 採用 Properties類別 取得屬性檔案的所有 key - value 對 <br />
     * 如果屬性檔案在運行時會改動，或者很少使用時，建議呼叫此方法 註：屬性檔案的 key <br />
     * 不能有重複，如有重複只讀取最下麵的一個 <br />
     * @param file 屬性檔案的檔案名， <br />
     *            如工程目錄下/WEB-INF/classes/a.properties，則寫：WEB-INF/classes/a.properties
     * @return HashMap 所有 key - value 對的集合，沒有值的賦予""
     */
    public static HashMap<String, String> getValues(String file)
    {
        // 防呆
        if ( file == null )
            return null;
        // 載入屬性檔案讀取類別
        Properties p = new Properties();
        FileInputStream in;
        HashMap<String, String> hm = new LinkedHashMap<String, String>();
        try
        {
            // 以流的形式讀入屬性檔案
            in = new FileInputStream(file);
            p.load(in);
            // 讀完了關閉此流
            in.close();
            // 取得所有的屬性 key - value 對，放置到 HashMap 中
            Iterator<Map.Entry<Object, Object>> itr = p.entrySet().iterator();
            while ( itr.hasNext() )
            {
                Map.Entry<Object, Object> e = itr.next();
                hm.put(e.getKey().toString(), e.getValue().toString());
            }
        }
        catch ( Exception e )
        {
            System.out.println("PropertiesUtil.getValues:" + e.toString());
        }
        return hm;
    }
    

    /**
     * 採用 ResourceBundel類別 取得屬性檔案對應值 <br />
     * 此方法會將屬性檔案加載於緩存中，但無法及時更新；如果屬性檔案在運行時不會改動，並且多處需要使用時建議呼叫此方法 <br />
     * 註：屬性檔案的 key 不能有重複，如有重複只讀取最下麵的一個 <br />
     * @param fileWithoutPostfix 屬性檔案的檔案名，不帶副檔名； <br />
     *            如工程目錄下/WEB-INF/classes/com/database.properties，則寫：com/database
     * @param propertyName 屬性名
     * @return String 根據屬性名得到的屬性值，沒有值則傳回""
     * @throws NullPointerException - 如果 key 為 null
     * @throws MissingResourceException - 如果未找到指定 key 的物件
     * @throws ClassCastException - 如果為指定的 key 找到的物件不是字串
     * @throws MissingResourceException - 找不到指定的檔案
     */
    public static String getValueByBundle(String fileWithoutPostfix, String propertyName)
    {
        // 讀取屬性檔案
        ResourceBundle bundel = ResourceBundle.getBundle(fileWithoutPostfix);
        // 傳回指定的值
        return bundel.getString(propertyName);
    }
    

    /**
     * 採用 ResourceBundel類別 取得屬性檔案對應值 <br />
     * 此方法會將屬性檔案加載於緩存中，但無法及時更新；如果屬性檔案在運行時不會改動，並且多處需要使用時建議呼叫此方法 <br />
     * 註：屬性檔案的 key 不能有重複，如有重複只讀取最下麵的一個 <br />
     * @param fileWithoutPostfix properties檔案名，不帶副檔名； <br />
     *            如工程目錄下/WEB-INF/classes/com/database.properties，則寫：com/database
     * @return HashMap 所有 key - value 對的集合，沒有值的賦予""
     * @throws MissingResourceException - 找不到指定的檔案
     */
    public static HashMap<String, String> getValuesByBundle(String fileWithoutPostfix)
    {
        HashMap<String, String> hm = new HashMap<String, String>();
        // 讀取屬性檔案
        ResourceBundle bundel = ResourceBundle.getBundle(fileWithoutPostfix);
        // 取得所有的屬性 key - value 對，放置到 HashMap 中
        Iterator<String> itr = bundel.keySet().iterator();
        while ( itr.hasNext() )
        {
            String key = itr.next().toString();
            hm.put(key, bundel.getString(key));
        }
        return hm;
    }
    

    /**
     * 更改屬性檔案的值，如果對應的屬性名不存在，則自動增加該屬性；不更改的屬性保留原值 <br />
     * @param file 屬性檔案的檔案名， <br />
     *            如工程目錄下/WEB-INF/classes/a.properties，則寫：WEB-INF/classes/a.properties
     * @param propertyName 屬性名
     * @param propertyValue 更改對應屬性名的值為此值 <br />
     *            屬性值中的中文會轉換成Unicode編碼，另外 ! # = \ : 等符號會在前面加上\，最前面的空格也會加上\
     * @param headText 設置屬性頭(註釋的內容)，如不想設置，請寫 null
     * @return boolean 是否操作成功：true則成功，false則操作不成功
     */
    public static boolean setValue(String file, String propertyName, String propertyValue, String headText)
    {
        // 載入屬性檔案讀取類別
        Properties p = new Properties();
        FileInputStream in;
        try
        {
            // 以流的形式讀入屬性檔案
            in = new FileInputStream(file);
            p.load(in);
            // 讀完了關閉此流
            in.close();
            // 設置屬性值，如屬性不存在則創建
            p.setProperty(propertyName, propertyValue);
            // 輸出串流
            FileOutputStream out = new FileOutputStream(file);
            // 設置屬性頭
            p.store(out, headText);
            // 清空緩存，寫入磁盤
            out.flush();
            // 關閉輸出串流
            out.close();
        }
        catch ( Exception e )
        {
            System.out.println("PropertiesUtil.changeValue:" + e.toString());
            return false;
        }
        return true;
    }
    

    /**
     * 更改屬性檔案的值，如果對應的屬性名不存在，則自動增加該屬性；不更改的屬性保留原值
     * @param file 屬性檔案的檔案名， <br />
     *            如工程目錄下/WEB-INF/classes/a.properties，則寫：WEB-INF/classes/a.properties
     * @param propertyName 屬性名
     * @param propertyValue 更改對應屬性名的值為此值 屬性值中的中文會轉換成Unicode編碼，另外 ! # = \ : 等符號會在前面加上\，最前面的空格也會加上\
     * @return boolean 是否操作成功：true則成功，false則操作不成功
     */
    public static boolean setValue(String file, String propertyName, String propertyValue)
    {
        return setValue(file, propertyName, propertyValue, null);
    }
    

    /**
     * 更改屬性檔案的值，如果對應的屬性名不存在，則自動增加該屬性；不更改的屬性保留原值 <br />
     * @param file 屬性檔案的檔案名， <br />
     *            如工程目錄下/WEB-INF/classes/a.properties，則寫：WEB-INF/classes/a.properties
     * @param propertys 屬性名-屬性值 的集合 <br />
     *            屬性值中的中文會轉換成Unicode編碼，另外 ! # = \ : 等符號會在前面加上\，最前面的空格也會加上\
     * @param headText 設置屬性頭(註釋的內容)，如不想設置，請寫 null
     * @return boolean 是否操作成功：true則成功，false則操作不成功
     */
    public static boolean setValue(String file, Map<String, String> propertys, String headText)
    {
        // 載入屬性檔案讀取類別
        Properties p = new Properties();
        FileInputStream in;
        try
        {
            // 以流的形式讀入屬性檔案
            in = new FileInputStream(file);
            p.load(in);
            // 讀完了關閉此流
            in.close();
            // 設置屬性值，如屬性不存在則創建
            for ( Iterator<Map.Entry<String, String>> iter = propertys.entrySet().iterator(); iter.hasNext(); )
            {
                Map.Entry<String, String> entry = iter.next();
                String key = entry.getKey();
                String val = entry.getValue();
                p.setProperty(key, val);
            }
            // 輸出串流
            FileOutputStream out = new FileOutputStream(file);
            // 設置屬性頭
            p.store(out, headText);
            // 清空緩存，寫入磁盤
            out.flush();
            // 關閉輸出串流
            out.close();
        }
        catch ( Exception e )
        {
            System.out.println("PropertiesUtil.changeValues:" + e.toString());
            return false;
        }
        return true;
    }
    

    /**
     * 更改屬性檔案的值，如果對應的屬性名不存在，則自動增加該屬性；不更改的屬性保留原值 <br />
     * @param file 屬性檔案的檔案名， <br />
     *            如工程目錄下/WEB-INF/classes/a.properties，則寫：WEB-INF/classes/a.properties
     * @param propertys 屬性名-屬性值 的集合 <br />
     *            屬性值中的中文會轉換成Unicode編碼，另外 ! # = \ : 等符號會在前面加上\，最前面的空格也會加上\
     * @return boolean 是否操作成功：true則成功，false則操作不成功
     */
    public static boolean changeValues(String file, Map<String, String> propertys)
    {
        return setValue(file, propertys, null);
    }
    

    /**
     * 建立檔案；如果之前已經有此檔案，則取代它；
     * @param fileName 檔案的檔案名；如果檔案的目錄不存在，則創建目錄
     * @param message 需要寫入到屬性檔案的內容
     * @param csn 建立此屬性檔案的字元集
     * @return boolean 是否操作成功：true則成功，false則操作不成功
     */
    public static boolean createFile(String fileName, String message)
    {
        // 防呆
        if ( fileName == null )
            return false;
        PrintWriter pw = null;
        // 檔案的目錄
        File parentFile = new File(fileName).getParentFile();
        // 如果檔案的目錄不存在，則先創建目錄
        if ( !parentFile.exists() )
            parentFile.mkdirs();
        try
        {
            pw = new PrintWriter(fileName, "UTF-8");
            // 寫出內容
            if ( message != null && !"".equals(message) )
                pw.print(message);
        }
        catch ( FileNotFoundException e )
        {
            System.out.println("PropertiesUtil.createFile:" + e.toString());
            return false;
        }
        catch ( UnsupportedEncodingException e )
        {
            System.out.println("PropertiesUtil.createFile:" + e.toString());
            return false;
        }
        finally
        {
            // 清空緩存
            pw.flush();
            // 關閉輸出串流
            pw.close();
        }
        return true;
    }
    

    /**
     * @param args
     */
    public static void main(String[] args)
    {
        Map hm = getValues("src/database.properties");
        for ( Iterator iter = hm.entrySet().iterator(); iter.hasNext(); )
        {
            Map.Entry entry = (Map.Entry)iter.next();
            Object key = entry.getKey();
            Object value = entry.getValue();
            System.out.println(key + " = " + value);
        }
        System.out.println("***************************");
        String propertiesFile = "src/database.properties";
        String DBTypeUrl = PropertiesUtil.getValue(propertiesFile, "DBTypeUrl");
        String AccessPath = PropertiesUtil.getValue(propertiesFile, "AccessPath");
        setValue("src/database.properties", "DBUrl2", DBTypeUrl + AccessPath);
        System.out.println(getValue("src/database.properties", "DBUrl2"));
    }
}
