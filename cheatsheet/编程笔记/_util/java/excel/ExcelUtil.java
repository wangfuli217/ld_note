/**
 * <P> Title: 公用類別                                      </P>
 * <P> Description: Excel處理                               </P>
 * <P> Copyright: Copyright (c) 2010/09/24                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.everunion.util;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WritableFont.FontName;

/**
 * Excel處理
 * @author Dennis
 * @version 0.1
 */
public final class ExcelUtil
{
	/**
     * 取得Excel資料
     * @param fileName 檔案名稱
     * @return ArrayList 傳回資料集
     */
    public static ArrayList<HashMap<String,String>> getExcelData(String fileName)
    {
        //引用ArrayList
    	ArrayList<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
    	Workbook wb = null;
        try
        {
        	//取得Workbook
        	wb = Workbook.getWorkbook(new File(fileName));
            //取得第一個工作表物件
            Sheet sheet = wb.getSheet(0);
            //列數
            int col = sheet.getColumns();
            //行數
            int row = sheet.getRows();
            //取得資料
            for ( int i = 0; i < row; i++ )
            {
                //引用HashMap
            	HashMap<String,String> hm = new HashMap<String,String>();
                //取得行資料
                for ( int j = 0; j < col; j++ )
                {
                    //得到單位格
                    Cell cell = sheet.getCell(j, i);
                    //加入值
                    hm.put("" + j, cell.getContents().trim());
                }
                //加入map
                list.add(hm);
            }
        }
        //捕捉錯誤
        catch ( Exception e )
        {
            //輸出例外
            System.out.println("ExcelUtil.getExcelData: " + e.toString());
        }
        finally
        {
        	//不爲空
        	if ( wb != null )
        	{
        		//關閉wb
        		wb.close();
        	}
        }
        //傳回資料集
        return list;
    }
    
    
    /**
     * 取得Excel資料
     * @param is InputStream物件
     * @return ArrayList 傳回資料集
     */
    public static ArrayList<HashMap<String,String>> getExcelData(InputStream is)
    {
        //引用ArrayList
    	ArrayList<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
    	Workbook wb = null;
        try
        {
        	//取得Workbook
        	wb = Workbook.getWorkbook(is);
            //取得第一個工作表物件
            Sheet sheet = wb.getSheet(0);
            //列數
            int col = sheet.getColumns();
            //行數
            int row = sheet.getRows();
            //取得資料
            for ( int i = 0; i < row; i++ )
            {
                //引用HashMap
            	HashMap<String,String> hm = new HashMap<String,String>();
                //取得行資料
                for ( int j = 0; j < col; j++ )
                {
                    //得到單位格
                    Cell cell = sheet.getCell(j, i);
                    //加入值
                    hm.put("" + j, cell.getContents().trim());
                }
                //加入map
                list.add(hm);
            }
        }
        //捕捉錯誤
        catch ( Exception e )
        {
            //輸出例外
            System.out.println("ExcelUtil.getExcelData: " + e.toString());
        }
        finally
        {
        	//不爲空
        	if ( wb != null )
        	{
        		//關閉wb
        		wb.close();
        	}
        }
        //傳回資料集
        return list;
    }
    
    
    /**
     * 産生Excel檔案
     * @param fileName 檔案名稱
     * @param ArrayList 資料集
     * @return boolean (true:産生成功;false:産生失敗)
     */
    public static boolean CreateExcelFile(String fileName, ArrayList<HashMap<String,String>> list)
    {
    	//初始化
    	WritableWorkbook workbook = null;
    	boolean recode = false;
    	try
        {
    		//引用writableWorkbook類
             workbook = Workbook.createWorkbook(new File(fileName));
             //新建sheet
             WritableSheet sheet = workbook.createSheet("data", 0);
             //字體
             FontName fn = WritableFont.createFont("新細明體");
             WritableFont wf = new WritableFont(fn, 12, WritableFont.NO_BOLD, false);
             WritableCellFormat wbcf = new WritableCellFormat(wf);
             //初始化
             int i = 0;
             Label lr;
             //把資料加入excel中
             for ( HashMap<String,String> hm : list )
             {
            	 //加入資料
            	 for ( int j = 0; j < hm.size(); j ++ )
            	 {
            		 //取得資料
                     lr = new Label(j, i, hm.get("" + j), wbcf);
                     //加入
                     sheet.addCell(lr);
            	 }
            	 //累加
            	 i ++;
             }
             //寫入workbook
             workbook.write();
             recode = true;
        }
        //捕捉錯誤
    	catch ( Exception e )
        {
             //輸出例外
             System.out.println("ExcelUtil.CreateExcelFile: " + e.toString());
        }
        finally
        {
         	//不爲空
        	if ( workbook != null )
        	{
        		//關閉wb
        		try
				{
					//關閉
        			workbook.close();
				}
				catch ( Exception e )
				{
				}
        	}
        }
        //操作訊息
        return recode;
    }
    
    
    /**
     * 産生Excel檔案
     * @param fileName 檔案名稱
     * @param ArrayList 資料集
     * @return boolean (true:産生成功;false:産生失敗)
     */
    public static boolean CreateExcelFile(String fileName, ArrayList<HashMap<String,String>> list, int columnRow)
    {
    	//初始化
    	WritableWorkbook workbook = null;
    	boolean recode = false;
    	try
        {
    		//引用writableWorkbook類
             workbook = Workbook.createWorkbook(new File(fileName));
             //新建sheet
             WritableSheet sheet = workbook.createSheet("data", 0);
             //字體
             FontName fn = WritableFont.createFont("新細明體");
             WritableFont wf = new WritableFont(fn, 12, WritableFont.NO_BOLD, false);
             WritableCellFormat wbcf = new WritableCellFormat(wf);
             //初始化
             int i = 0;
             Label lr;
             //把資料加入excel中
             for ( HashMap<String,String> hm : list )
             {
            	 //加入資料
            	 for ( int j = 0; j < columnRow; j ++ )
            	 {
            		 //取得資料
                     lr = new Label(j, i, hm.get("" + j), wbcf);
                     //加入
                     sheet.addCell(lr);
            	 }
            	 //累加
            	 i ++;
             }
             //寫入workbook
             workbook.write();
             recode = true;
        }
        //捕捉錯誤
    	catch ( Exception e )
        {
             //輸出例外
             System.out.println("ExcelUtil.CreateExcelFile: " + e.toString());
        }
        finally
        {
         	//不爲空
        	if ( workbook != null )
        	{
        		//關閉wb
        		try
				{
					//關閉
        			workbook.close();
				}
				catch ( Exception e )
				{
				}
        	}
        }
        //操作訊息
        return recode;
    }
    
    
    /**
     * 取得列的名稱
     * @param row 第幾列,從0開始, 最大255
     * @return 列的名稱; 按Excel的列名規則,列名是:A,B,C...IV (目前最大是256列)
     */
    public static String getRowName(int row)
    {
        char value = 'A';
        // 防呆
        if ( row < 0 || row > 255 )
            return "";
        
        // AA ~ ZZ 中的第一個字元
        int firstChar = (row / 26) - 1;
        char first = value;
        first += firstChar;
        
        // 第二個字元
        int secondChar = row % 26;
        char second = value;
        second += secondChar;
        
        // A ~ Z
        if ( row <= 25 )
        {
            return "" + second;
        }
        return "" + first + second;
    }
    
}