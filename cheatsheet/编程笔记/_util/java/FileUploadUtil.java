/**
 * <P> Title: 公用類別                                      </P>
 * <P> Description: 檔案上傳操作類別                        </P>
 * <P> Copyright: Copyright (c) 2010/08/20                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 * 
 * 使用說明,頁面的form表單必須使用 enctype="multipart/form-data" 如：
 * <form action="test.jsp" method="post" enctype="multipart/form-data">
 */


package com.everunion.util;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;

/**
 * 檔案上傳操作類別
 * @author Holer W. L. Feng
 * @version 0.1
 */
public class FileUploadUtil
{
    /**
     * request物件
     */
    private HttpServletRequest request = null;

    /**
     * 檔案上傳後的儲存路徑
     */
    private String uploadPath = null;
    
    /**
     * 檔案上傳後的儲存路徑的網址
     */
    private String uploadUrlPath = null;

    /**
     * 每次讀取字節的大小
     */
    private static final int BUFSIZE = 1024 * 8;

    /**
     * 編碼
     */
    private static final String encoding = "UTF-8";

    /**
     * 儲存form表單參數的HashMap<name, ArrayList<value>>
     */
    private HashMap<String, ArrayList<String>> paramHm = new HashMap<String, ArrayList<String>>();

    
    
    /**
     * 構造方法
     * @param request HttpServletRequest request物件
     * @throws RuntimeException 當Request為空,沒有設定正確的enctype, 檔案儲存路徑不正確時拋出
     */
    public FileUploadUtil(HttpServletRequest request)
    {
        this(request, null);
    }
    
    
    /**
     * 構造方法
     * @param request HttpServletRequest request物件
     * @param path 檔案上傳後的儲存路徑(物理路徑)
     * @throws RuntimeException 當Request為空,沒有設定正確的enctype, 檔案儲存路徑不正確時拋出
     */
    public FileUploadUtil(HttpServletRequest request, String path)
    {
        this.request = request;
        this.uploadPath = path;
        
        // 檔案上傳處理前,檢查 request
        if ( request == null )
        {
            throw new RuntimeException("FileUploadUtil: Request為空!");
        }
        // 檔案上傳處理前,檢查 enctype
        String contentType = request.getContentType();
        if ( contentType.indexOf("multipart/form-data") == -1 )
        {
            throw new RuntimeException("FileUploadUtil: 沒有設定正確的 enctype !");
        }
        
        // 設定儲存路徑，不存在時建立它
        setUploadPath();
        // 檔案上傳處理
        process();
    }
    

    /**
     * 設置檔案儲存路徑,有賦值則使用賦值的路徑,沒有則使用預設的;路徑不存在時自動建立
     * 預設檔案上傳後的儲存路徑為項目下 /upload/yyyy(年)/MM(月)/dd(日)/
     * @throws RuntimeException 當檔案儲存路徑不正確時拋出
     */
    private void setUploadPath()
    {
        //項目的物理路徑
        String basePath = this.request.getRealPath("/");
        //項目的網址
        String baseUrlPath = request.getScheme() + "://" + request.getServerName()
               + ":" + request.getServerPort() + request.getContextPath() + "/";
        
        //沒有路徑時使用預設值
        if ( this.uploadPath == null || "".equals(this.uploadPath.trim()) )
        {
            //相對於項目的路徑
            String path = "upload/";
            Calendar c = Calendar.getInstance();
            path += c.get(Calendar.YEAR) + "/";
            path += (1 + c.get(Calendar.MONTH)) + "/";
            path += c.get(Calendar.DATE) + "/";
            
            //物理路徑
            this.uploadPath = basePath + path;
            //取得網址
            this.uploadUrlPath = baseUrlPath + path;
        }
        //自定義路徑
        else 
        {
            //保證以檔案夾結尾
            if ( !this.uploadPath.endsWith("/") && !this.uploadPath.endsWith("\\") )
                this.uploadPath += "/";
            
            //在項目裡面的
            if ( this.uploadPath.startsWith(basePath.substring(0, basePath.length()-1)) )
            {
                this.uploadUrlPath = baseUrlPath + this.uploadPath.substring(basePath.length());
            }
            //不在項目裡面的
            else
            {
                this.uploadUrlPath = this.uploadPath;
            }
        }
        
        File file = new File(this.uploadPath);
        //如果找不到檔案儲存路徑,先建立目錄
        if ( !file.exists() || !file.isDirectory() )
        {
            file.mkdirs();
            //如果建立檔案儲存路徑失敗,拋出例外
            if ( !file.exists() || !file.isDirectory() )
            {
                throw new RuntimeException("FileUploadUtil.setUploadPath: 找不到檔案儲存路徑!");
            }
        }
    }
    

    /**
     * 檔案上傳處理主程式
     */
    private void process()
    {
        try
        {
            // 參數或者檔案名
            String name = null;
            // 參數的值
            String value = null;
            // 讀取的流是否為檔案的標誌位
            boolean fileFlag = false;
            // 上傳的檔案的名字
            String fileName = null;
            FileOutputStream baos = null;
            BufferedOutputStream bos = null;

            // 儲存參數的HashMap
            this.paramHm = new HashMap<String,ArrayList<String>>();
            int rtnPos = 0;
            byte[] buffs = new byte[BUFSIZE * 8];
            
            // 取得ContentType
            String contentType = request.getContentType();
            int index = contentType.indexOf("boundary=");
            
            // 1筆資料的開頭標誌
            String boundary = "--" + contentType.substring(index + 9);
            // 全部資料的結尾標誌
            String endBoundary = boundary + "--";
            
            // 從request中取得流
            ServletInputStream sis = request.getInputStream();
            
            // 逐行讀取資料
            while ( (rtnPos = sis.readLine(buffs, 0, buffs.length)) != -1 )
            {
                // 這行資料的內容
                String strBuff = new String(buffs, 0, rtnPos, encoding);

                // 1筆資料的開始(也用作判斷上一筆資料的結束,沒有結束標誌)
                if ( strBuff.startsWith(boundary) )
                {
                    // 標誌着上一筆資料的結束
                    if ( name != null && name.trim().length() > 0 )
                    {
                        // 檔案,則關閉資源
                        if ( fileFlag )
                        {
                            // 關閉流
                            bos.flush();
                            baos.close();
                            bos.close();
                            baos = null;
                            bos = null;
                            // 儲存檔案名,須加上網址路徑
                            value = this.uploadUrlPath + fileName;
                        }
                        
                        // 儲存form表單的參數
                        ArrayList<String> obj = this.paramHm.get(name);
                        // 如果有相同的name,加入陣列
                        ArrayList<String> al = ( obj == null ) ? new ArrayList<String>() : obj;
                        // 儲存form表單的元件的值
                        al.add(value);
                        this.paramHm.put(name, al);
                    }
                    
                    // 資料的最終結尾
                    if ( strBuff.startsWith(endBoundary) )
                    {
                        break;
                    }
                    
                    // 初始化
                    name = new String();
                    value = new String();
                    fileFlag = false;
                    fileName = new String();
                    
                    // 讀取下一行資料
                    rtnPos = sis.readLine(buffs, 0, buffs.length);
                    if ( rtnPos != -1 )
                    {
                        strBuff = new String(buffs, 0, rtnPos, encoding);
                        
                        // 取得資料的name
                        if ( strBuff.toLowerCase().startsWith("content-disposition: form-data; ") )
                        {
                            int nIndex = strBuff.toLowerCase().indexOf("name=\"");
                            int nLastIndex = strBuff.toLowerCase().indexOf("\"", nIndex + 6);
                            name = strBuff.substring(nIndex + 6, nLastIndex);
                        }
                        
                        // 判斷資料是否 檔案類型
                        int fIndex = strBuff.toLowerCase().indexOf("filename=\"");
                        if ( fIndex != -1 )
                        {
                            int fLastIndex = strBuff.toLowerCase().indexOf("\"", fIndex + 10);
                            // 檔案名稱
                            fileName = strBuff.substring(fIndex + 10, fLastIndex);
                            fileName = getFileName(fileName);
                            // 如果取不到得檔案名稱,則非檔案
                            if ( fileName == null || fileName.trim().length() == 0 )
                            {
                                sis.readLine(buffs, 0, buffs.length);
                            }
                            // 是檔案,則創建,並且做檔案標誌
                            else
                            {
                                // 要儲存的檔案
                                File tmpFile = new File(this.uploadPath + fileName);
                                baos = new FileOutputStream(tmpFile);
                                bos = new BufferedOutputStream(baos);
                                // 檔案標誌
                                fileFlag = true;
                            }
                            // 以下兩行不需讀取
                            sis.readLine(buffs, 0, buffs.length);
                            sis.readLine(buffs, 0, buffs.length);
                        }
                    }
                }
                // 1筆資料的中間
                else
                {
                    // 寫入檔案
                    if ( fileFlag )
                    {
                        bos.write(buffs, 0, rtnPos);
                    }
                    // 讀取值
                    else
                    {
                        //取得form表單的元件的值
                        value += strBuff;
                        //System.out.println("name:" + name + "  value :" + value + " source:" + strBuff);
                    }
                }
            }
        }
        //例外時,拋出
        catch ( IOException e )
        {
            System.out.println("FileUploadUtil.process: " + e.toString());
            throw new RuntimeException("FileUploadUtil.process: " + e.toString());
        }
    }
    

    /**
     * 取得檔案的名稱
     * @param input 檔案的路徑及名稱
     * @return String 檔案的名稱
     */
    private String getFileName(String input)
    {
        // 取出最後一個目錄的結束符號
        int fIndex = input.lastIndexOf("\\");
        if ( fIndex == -1 )
        {
            fIndex = input.lastIndexOf("/");
            if ( fIndex == -1 )
            {
                //沒有路徑時
                return input;
            }
        }
        // 截去檔案的路徑
        input = input.substring(fIndex + 1);
        // 傳回去除路徑後的檔案名
        return input;
    }
    

    /**
     * 根據name取得form表單中其它傳遞的參數的值(多個的話傳回其中一個)
     * @param name form表單中對應的name
     * @return String form表單中對應的值
     */
    public String getParameter(String name)
    {
        String value = "";
        //防呆
        if ( name == null || name.trim().length() == 0 )
            return value;
        
        //取值
        value = (paramHm.get(name) == null) ? "" : (String)(paramHm.get(name)).get(0);
        //去除開頭的換行符號
        value = (value.startsWith("\r\n")) ? value.substring(2) : value;
        //去除結尾的換行符號
        value = (value.endsWith("\r\n")) ? value.substring(0, value.length() - 2) : value;
        return value;
    }
    

    /**
     * 根據name取得form表單中其它傳遞的參數的值(傳回陣列，可有多個)
     * @param name form表單中對應的name
     * @return String[] form表單中對應的值的陣列
     */
    public String[] getParameters(String name)
    {
        //防呆
        if ( name == null || name.trim().length() == 0 )
            return null;
        if ( paramHm.get(name) == null )
            return null;
        
        //傳回陣列，可有多個值
        ArrayList<String> al = paramHm.get(name);
        String[] strArr = new String[al.size()];
        for ( int i = 0; i < al.size(); i++ )
        {
            strArr[i] = (String)al.get(i);
        }
        return strArr;
    }
    

    /**
     * 取得form表單中參數的名稱的陣列
     * @return String[] form表單中對應的值的陣列
     */
    public String[] getParameterNames()
    {
        //防呆
        if ( paramHm == null || paramHm.size() == 0 )
            return null;

        //傳回名稱陣列
        String[] nameArr = new String[paramHm.size()];
        Iterator<String> iter = paramHm.keySet().iterator();
        for ( int i = 0; iter.hasNext(); i++ )
        {
            nameArr[i] = (String)iter.next();
        }
        return nameArr;
    }
    
}