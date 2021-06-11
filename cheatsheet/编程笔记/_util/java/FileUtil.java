/**
 * <P> Title: 公用類別                                      </P>
 * <P> Description: 檔案操作工具                            </P>
 * <P> Copyright: Copyright (c) 2010/08/20                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 * 檔案操作工具
 * @author Holer W. L. Feng
 * @version 0.1
 */
public class FileUtil
{
    /**
     * 創建此抽象路徑名指定的目錄，包括創建必需但不存在的父目錄
     * @param dir 指定的目錄
     * @return 當且僅當已創建該目錄以及所有必需的父目錄時，傳回 true；否則傳回 false 
     */
    public static boolean createDir(String dir)
    {
        boolean flag = false;
        File file = new File(dir);
        // 目錄不存在或者不是目錄時，創建
        if ( !file.exists() && !file.isDirectory() )
        {
            flag = file.mkdirs();
        }
        return flag;
    }
    

    /**
     * 建立檔案；如果之前已經有此檔案，則取代它；
     * @param fileName 檔案的檔案名；如果檔案的目錄不存在，則創建目錄
     * @param message 需要寫入到屬性檔案的內容
     * @param csn 建立此屬性檔案的字元集
     * @return boolean 是否操作成功：true則成功，false則操作不成功
     */
    public static boolean createFile ( String fileName, String message )
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
            System.out.println("FileUtil.createFile:" + e.toString());
            return false;
        }
        catch ( UnsupportedEncodingException e )
        {
            System.out.println("FileUtil.createFile:" + e.toString());
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
    

    public static boolean copyDir(String s, String s1) throws IOException
    {
        File file = new File(s);
        File file1 = new File(s1);
        if ( file.exists() )
        {
            if ( !file1.isDirectory() )
            {
                boolean flag = file1.mkdirs();
                if ( !flag )
                    return false;
            }
            String as[] = file.list();
            for ( int i = 0; i < as.length; i++ )
            {
                File file2 = new File(s + File.separator + as[i]);
                if ( file2.isFile() )
                    copyFile(s + File.separator + as[i], s1 + File.separator + as[i]);
                else if ( file2.isDirectory() && as[i].compareTo(".") != 0
                        && as[i].compareTo("..") != 0 )
                {
                    boolean flag1 = copyDir(s + File.separator + as[i], s1
                            + File.separator + as[i]);
                    if ( !flag1 )
                        return false;
                }
            }
        }
        return true;
    }
    

    public static void copyFile(String s, String s1) throws IOException
    {
        FileInputStream fileinputstream = null;
        FileOutputStream fileoutputstream = null;
        byte abyte0[] = new byte[8192];
        try
        {
            fileinputstream = new FileInputStream(s);
            fileoutputstream = new FileOutputStream(s1);
            int i;
            while ( (i = fileinputstream.read(abyte0)) != -1 )
                fileoutputstream.write(abyte0, 0, i);
        }
        finally
        {
            try
            {
                if ( fileinputstream != null )
                    fileinputstream.close();
                if ( fileoutputstream != null )
                    fileoutputstream.close();
            }
            catch ( IOException ioexception )
            {
            }
        }
    }
    

    public static boolean delFolder(String s)
    {
        File file = new File(s);
        if ( file.exists() && file.isDirectory() )
        {
            File afile[] = file.listFiles();
            for ( int i = 0; i < afile.length; i++ )
            {
                if ( afile[i].isFile() )
                {
                    if ( afile[i].exists() )
                        afile[i].delete();
                    continue;
                }
                if ( afile[i].isDirectory() )
                    delFolder(afile[i].toString());
            }
            file.delete();
        }
        file = null;
        return true;
    }
    

    public static final void delFile(String s) throws Exception
    {
        File file = new File(s);
        if ( file.exists() )
        {
            file.delete();
        }
    }
    

    public static boolean moveDir(String s, String s1) throws IOException
    {
        if ( copyDir(s, s1) )
            return delFolder(s);
        else
            return false;
    }
    

    public static String[] listFile(String s)
    {
        ArrayList<String> vector = new ArrayList<String>();
        File file = new File(s);
        if ( file.exists() )
        {
            File afile[] = file.listFiles();
            for ( int i = 0; i < afile.length; i++ )
            {
                if ( afile[i].isFile() )
                    vector.add(afile[i].getName());
            }
        }
        return (String[])vector.toArray(new String[0]);
    }
    

    public static String[] listFolder(String s)
    {
        ArrayList<String> vector = new ArrayList<String>();
        File file = new File(s);
        if ( file.exists() )
        {
            File afile[] = file.listFiles();
            for ( int i = 0; i < afile.length; i++ )
            {
                if ( afile[i].isDirectory() )
                    vector.add(afile[i].getName());
            }
            
        }
        return (String[])vector.toArray(new String[0]);
    }
    

    public static String readFile2String(String name) throws Exception
    {
        StringBuffer sb = new StringBuffer();
        FileInputStream fis = null;
        InputStreamReader isr = null;
        BufferedReader br = null;
        try
        {
            fis = new FileInputStream(name);
            isr = new InputStreamReader(fis, "utf-8");
            br = new BufferedReader(isr);
            String data = null;
            while ( (data = br.readLine()) != null )
            {
                sb.append(data);
                sb.append("\n");
            }
        }
        catch ( Exception e )
        {
            System.out.println("FileUtil.readFile2String:" + e.toString());
        }
        finally
        {
            if ( br != null )
            {
                br.close();
                br = null;
            }
            if ( isr != null )
            {
                isr.close();
                isr = null;
            }
            if ( fis != null )
            {
                fis.close();
                fis = null;
            }
        }
        return sb.toString();
    }
    

    /**
     * 在原檔案名的後面加上時間(以免名稱衡突)
     * @param input 檔案名
     * @return String 處理後的檔案名
     */
    public static String getFileNameByTime(String input)
    {
        // 取出副檔名
        int index = input.indexOf(".");
        Date dt = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        // 原檔案名(無副檔名) + 時間 + 副檔名
        return input.substring(0, index) + sdf.format(dt) + input.substring(index);
    }
    
}
