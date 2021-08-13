/**
 * <P> Title: 公用類別                                      </P>
 * <P> Description: 分頁元件                                </P>
 * <P> Copyright: Copyright (c) 2010/08/07                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.everunion.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

/**
 * 分頁元件 <br />
 * 注意: <br />
 * 1.上下分頁模板必須放在form表單元件中,否則會有js錯誤; <br />
 * 2.占用的名稱全部使用“_PU_”開頭,為避免名稱衡突,請勿使用這個開頭的名稱 <br />
 * 3.SQL Server版本的需設置主鍵名稱為keyid <br />
 *   (如:select a.Id as keyid ,a.name from userTable a where ...),其中Id為userTable表的主鍵. <br />
 *   多主鍵,可採用下面方法(select a.Id+a.name as keyId from userTable a where ... )). <br />
 * 4.使用Ajax查詢時, 請在 genPageHtml(String, sEvent)方法的sEvent裡面的最後加上return,避免submit <br />
 * @author Holer W. L. Feng
 * @version 0.1
 */
public class PageUtil
{
    // 分頁條中的數字顯示多少個,預設9個
    private int pageNumber = 9;
    // 一頁顯示的記錄數，預設為10
    private int pageSize = 10;
    // 資料庫類型
    private String DbType = "mysql";
    
    // Connection
    private Connection conn = null;
    // sql
    private String sql = "";
    // 分頁SQL
    private String pageSql = "";
    // countSQL
    private String countSql = "";
    // 記錄總數
    private int rowCount = 0;
    // 總頁數
    private int pageCount = 0;
    // 待顯示頁碼
    private int pageNo = 0;
    //當前頁碼
    private String pageFlag = "";
    // 記錄是否為空
    private boolean pageSizeIsNull;
    // 從request中取得要排序的欄位名稱, 如item_id或item_ID desc
    private String realSortFields = "";
    // 控制ORDER by asc, order by desc用
    private String preSortFields = "";
    // 控制ORDER by asc, order by desc用
    private String preSortAscOrDesc = "";
    // 查詢的參數
    private List<Object> valueList = null;
    // 是否準備好
    private boolean isPrepare = false;
    // 是否已經輸入了隱藏域等信息
    private boolean hasOut = false;
    //查詢總數sql
    private String totalSql = "";
    
    /**
     * 從哪筆開始
     */
    public int StartNo = 0;
    
    /**
     * 按鈕html,可直接在此修改
     */
    //共用
    private String button = "<li {$class_name} >{$comm_name}</li>";
    private String button_comm = "<a href='#' NAME='_PU_button' onClick=\"{$onClick};\" title='{$name}'>{$name}</a>";
    
    //展開
    private String two_button_pre = "<img src='{$path}/images/expanded.gif'/><a {$href} NAME='{$pageFlag}_PU_button' id='{$pageFlag}_PU_bt_next' onClick=\"{$onClick};\" {$disabled} title='展開'>展開</a>";
    //縮排
    private String two_button_next = "<img src='{$path}/images/shrink.gif'/><a {$href} NAME='{$pageFlag}_PU_button' id='{$pageFlag}_PU_bt_prev' onClick=\"{$onClick};\" {$disabled} title='縮排'>縮排</a>";
    
    // 分頁條中的數字顯示
    private String tag_A = "<li class='join'><a name='_PU_A' href='#' onclick=\"{$onClick};\" title='第{$number}頁'>{$number}</a></a>";
    
    // 分頁條中,當時頁的數字顯示
    private String tag_span = "<li class='indicate'>{$number}</li>";
    
    
    /**
     * 構造方法
     * @param DBconn Connection
     * @param request HttpServletRequest
     * @param sql 分頁傳入的SQL
     * @param valueList SQL的參數列表
     * @param DbType 資料庫類型
     * @param pageFlag 多分頁區分符
     */
    public PageUtil(Connection DBconn, HttpServletRequest request, String sql, List<Object> valueList, String DbType, String pageFlag)
    {
        // 資料庫連結參數
        this.conn = DBconn;
        this.pageFlag = pageFlag;
        // 取得待顯示頁碼
        this.pageNo = request.getParameter(pageFlag + "_PU_pageNo") == null ? 1 : Integer.parseInt(request.getParameter(pageFlag + "_PU_pageNo"));
        // 設定和取得頁大小
        this.pageSize = request.getParameter(pageFlag + "_PU_pageSize") == null ? pageSize : Integer.parseInt(request.getParameter(pageFlag + "_PU_pageSize"));
        // 是否為null
        this.pageSizeIsNull = request.getParameter(pageFlag + "_PU_pageSize") == null;
        
        // 要排序的欄位名稱
        this.realSortFields = request.getParameter(pageFlag + "_PU_realSortFields") == null ? "" : request.getParameter(pageFlag + "_PU_realSortFields");
        // 控制ORDER by asc, order by desc用
        this.preSortFields = request.getParameter(pageFlag + "_PU_preSortFields") == null ? "" : request.getParameter(pageFlag + "_PU_preSortFields");
        // 控制ORDER by asc, order by desc用
        this.preSortAscOrDesc = request.getParameter(pageFlag + "_PU_preSortAscOrDesc") == null ? "" : request.getParameter(pageFlag + "_PU_preSortAscOrDesc");
        // 資料庫類型
        setDbType(DbType);
        
        // 設定查詢SQL
        this.sql = (sql == null || "".equals(sql.trim())) ? "" : sql;
        this.valueList = valueList;
        
        // 請求的路徑
        String path = request.getContextPath();
        // 更改背景圖片
        this.two_button_pre = this.two_button_pre.replace("{$path}", path);
        this.two_button_next = this.two_button_next.replace("{$path}", path);
    }
    
    
    /**
     * 構造方法
     * @param DBconn Connection
     * @param request HttpServletRequest
     * @param sql 分頁傳入的SQL
     * @param valueList SQL的參數列表
     * @param DbType 資料庫類型
     */
    public PageUtil(Connection DBconn, HttpServletRequest request, String sql, List<Object> valueList, String DbType)
    {
    	this(DBconn, request, sql, valueList, DbType, "");
    }
    

    /**
     * 構造方法
     * @param DBconn Connection
     * @param request HttpServletRequest
     * @param sql 分頁傳入的SQL
     * @param valueList 分頁用的SQL的參數列表
     */
    public PageUtil(Connection DBconn, HttpServletRequest request, String sql, List<Object> valueList)
    {
        this(DBconn, request, sql, valueList, null);
    }
    

    /**
     * 構造方法
     * @param DBconn Connection
     * @param request HttpServletRequest
     * @param sql 分頁傳入的SQL
     */
    public PageUtil(Connection DBconn, HttpServletRequest request, String sql)
    {
        this(DBconn, request, sql, null, null);
    }
    

    /**
     * 取得分頁的SQL
     * @return 分頁的SQL
     */
    public String getSQL()
    {
        return this.sql;
    }
    

    /**
     * 取得資料庫類型
     * @return 資料庫類型
     */
    public String getDbType()
    {
        return this.DbType;
    }
    

    /**
     * 設定資料庫類型
     * @param DbType 資料庫類型
     */
    public void setDbType(String DbType)
    {
        // 如果已經準備好,則不可以再改變資料庫類型
        checkPrepare();
        // 沒有參數時,由資料庫連結來取
        if ( DbType == null || "".equals(DbType.trim()) )
        {
            String driverName = this.conn.toString().toLowerCase();
            //MySQL 資料庫
            if ( driverName.indexOf("mysql") >= 0 )
            {
                this.DbType = "mysql";
            }
            //Oracle 資料庫
            else if ( driverName.indexOf("oracle") >= 0 )
            {
                this.DbType = "oracle";
            }
            //SQL Server 資料庫 跟 Access 資料庫, 同樣的分頁SQL
            else if ( driverName.indexOf("sqlserver") >= 0 || driverName.indexOf("access") >= 0 )
            {
                this.DbType = "sqlserver";
            }
        }
        // 有參數傳入,則使用參數的
        else
        {
            this.DbType = DbType.toLowerCase();
        }
    }
    
    /**
     * 設定查詢總頁數sql
     * @param totalSql 查詢總頁數sql
     */
    public void setTotalSql(String totalSql)
    {
        // 如果已經準備工作,則不可以再改變
        checkPrepare();
        this.totalSql = totalSql;
    }
    

    /**
     * 設定查詢總計多少筆資料的SQL
     * @exception 當select里有distinct的時,可能會出錯
     */
    private void setCountSql()
    {
        String sql = this.sql.trim().toLowerCase();
        //傳過來的sql
        if ( totalSql.length() > 0 )
        {
        	this.countSql = totalSql;
        }
        // 如果是簡單SQL直接修改,以提高效率
        else if ( sql.indexOf(" from ") == sql.lastIndexOf(" from ") && sql.indexOf(" distinct ") < 0
        	&& sql.indexOf(" avg(") < 0 && sql.indexOf(" count(") < 0 && sql.indexOf(" max(") < 0
        	&& sql.indexOf(" min(") < 0 && sql.indexOf(" sum(") < 0 && sql.indexOf(" group ") < 0 )
        {
            this.countSql = "SELECT COUNT(*) " + this.sql.substring(sql.indexOf(" from "));
        }
        else
        {
            // 此句效率很低,該盡量用上面的SQL來查詢
            this.countSql = "SELECT COUNT(*) FROM (" + this.sql + ") _PU_A";
        }
    }
    

    /**
     * 取得SQL
     * @return 已經產的SQL
     */
    public String getCountSql()
    {
        return this.countSql;
    }
    

    /**
     * 取得分頁SQL
     * @return 分頁SQL
     */
    public String getPageSql()
    {
        // 準備好
        setPrepare();
        return this.pageSql;
    }
    

    /**
     * 處理select 裡有 distinct 和 group by 以及排序
     */
    private void setPageSql()
    {
        // 傳入的SQL
        String strSql = this.sql.trim();
        
        // 設定頁碼(防呆)
        this.pageNo = (this.pageNo <= 0 ? 1 : this.pageNo);
        
        // 表示需要排序
        if ( !"".equals(this.realSortFields) )
        {
            // 排序,加上排序方向
            String order = this.realSortFields + " " + this.preSortAscOrDesc;
            
            // Mysql
            if ( "mysql".equals(this.DbType) )
            {
                int startRow = this.pageSize * (this.pageNo - 1);
                String tem_sql = strSql.toLowerCase().replaceAll("\\s+", " ");
                // 已經有 limit
                if ( tem_sql.indexOf(" limit ") > 0 )
                {
                    // 此句效率很低,非迫不得已則不使用
                    this.pageSql = " SELECT _PU_.* from (" + strSql + " ) _PU_ order by " + order + " limit "
                        + startRow + "," + this.pageSize;
                }
                // 已經有 order by
                else if ( tem_sql.indexOf(" order by ") > 0 )
                {
                    //  order by 後面沒有括號(即order by 不是子查詢),直接在後面補上排序
                    if ( tem_sql.lastIndexOf(")") < tem_sql.lastIndexOf(" order by ") )
                    {
                        this.pageSql = strSql + ", " + order + " limit " + startRow + "," + this.pageSize;
                    }
                    // order by 在子查詢裡面
                    else
                    {
                        // 此句效率很低,非迫不得已則不使用
                        this.pageSql = " SELECT _PU_.* from (" + strSql + " ) _PU_ order by "
                            + order + " limit " + startRow + "," + this.pageSize;
                    }
                }
                // 沒有 order by 和 limit,則直接在後面加上, 這樣效率更高
                else
                {
                    this.pageSql = strSql + " order by " + order + " limit " + startRow + "," + this.pageSize;
                }
            }
            // Sql Server2000
            else if ( "sqlserver".equals(this.DbType) )
            {
                // 顯示行數,最後一頁時不是 pageSize
                int showRows = (this.pageNo < this.pageCount ? this.pageSize : this.rowCount - (this.pageNo-1) * this.pageSize);
                // 查無資料時, top 0 會報錯
                showRows = (showRows > 0 ? showRows : 1);
                this.pageSql = "SELECT * FROM( SELECT TOP " + showRows + " * FROM (" 
                    + " SELECT TOP " + (this.pageSize * this.pageNo) + " * FROM ("
                    + strSql + ") ORDER BY keyID ASC "
                    + ") AS _PU_A ORDER BY keyID DESC )  as _PU_B ORDER BY " + order;
            }
            // Oracle
            else if ( "oracle".equals(this.DbType) )
            {
                // 已經有 order by 
                if ( strSql.toLowerCase().indexOf(" order ") > 0 )
                {
                    // 將 strSql ==> select a.* from ( strSql ) a ORDER BY 1,2
                    strSql = "select _PU_A.* from (" + strSql + ") _PU_A order by " + order;
                }
                // 沒有 order by,直接在後面加上, 這樣效率會更高
                else
                {
                    strSql += " order by " + order;
                }
                int startRow = (this.pageNo - 1) * this.pageSize + 1;
                int endRow = this.pageNo * this.pageSize;
                // 需要排序sql
                this.pageSql = "SELECT * FROM ( SELECT ROWNUM as _PU_ROWNUM, _PU_B.* from ("
                    + strSql + ") _PU_B where _PU_ROWNUM <= " + endRow 
                    + " ) WHERE _PU_ROWNUM >= " + startRow;
            }
        }
        // 表示不需要排序
        else
        {
            // Mysql
            if ( "mysql".equals(this.DbType) )
            {
                int startRow = this.pageSize * (this.pageNo - 1);
                // 已經有 limit
                if ( strSql.toLowerCase().indexOf(" limit ") > 0 )
                {
                    this.pageSql = "SELECT _PU_.* from (" + strSql + " ) _PU_ limit "
                        + startRow + "," + this.pageSize;
                }
                // 沒有 limit,則直接在後面加上, 這樣效率更高
                else
                {
                    this.pageSql = strSql + " limit " + startRow + "," + this.pageSize;
                }
            }
            // Sql Server 2000
            else if ( "sqlserver".equals(this.DbType) )
            {
                // 顯示行數,最後一頁時不是 pageSize
                int showRows = (this.pageNo < this.pageCount ? this.pageSize : this.rowCount - (this.pageNo-1) * this.pageSize);
                // 查無資料時, top 0 會報錯
                showRows = (showRows > 0 ? showRows : 1);
                this.pageSql = "SELECT * FROM( SELECT TOP " + showRows + " * FROM (" 
                    + " SELECT TOP " + (this.pageSize * this.pageNo) + " * FROM ("
                    + strSql + ") ORDER BY keyID ASC "
                    + ") AS _PU_A ORDER BY keyID DESC )  as _PU_B ORDER BY keyID ASC";
            }
            // Oracle
            else if ( "oracle".equals(this.DbType) )
            {
                int startRow = (this.pageNo - 1) * this.pageSize + 1;
                int endRow = this.pageNo * this.pageSize;
                this.pageSql = "SELECT * FROM ( SELECT ROWNUM as _PU_ROWNUM, _PU_A.* from ("
                    + strSql + ") _PU_A WHERE _PU_ROWNUM <= " + endRow + " ) WHERE _PU_ROWNUM >= " + startRow;
            }
        }
    }
    

    /**
     * 取得每頁產生的記錄數
     * @return 每頁產生的記錄數
     */
    public int getPageSize()
    {
        return pageSize;
    }
    

    /**
     * 設定一頁顯示多少筆資料
     * @param i 一頁顯示多少筆資料
     */
    public void setPageSize(int i)
    {
        // 如果已經準備工作,則不可以再改變一頁顯示多少筆資料
        checkPrepare();
        // 如果沒有傳入顯示多少筆資料的參數
        if ( this.pageSizeIsNull )
        {
            this.pageSize = i;
        }
    }
    

    /**
     * 取得分頁條中顯示的數字個數
     * @return 每頁產生的記錄數
     */
    public int getPageNumber()
    {
        return this.pageNumber;
    }
    

    /**
     * 設定分頁條中顯示的數字個數
     * @param i 分頁條中顯示的數字個數
     */
    public void setPageNumber(int i)
    {
        // 如果已經準備工作,則不可以再改變
        checkPrepare();
        this.pageNumber = i;
    }
    

    /**
     * 取得頁數
     * @return 頁數
     */
    public int getPageCount()
    {
        return pageCount;
    }
    

    /**
     * 取得第幾頁
     * @return 第幾頁
     */
    public int getPageNo()
    {
        return pageNo;
    }
    

    /**
     * 設定頁數
     * @param i 頁數
     */
    public void setPageNo(int pageNo)
    {
        // 如果已經準備工作,則不可以再改變頁數
        checkPrepare();
        this.pageNo = pageNo;
    }
    

    /**
     * 設定頁數為最大頁
     */
    public void setPageNoMax()
    {
        setPrepare();
        this.pageNo = this.pageCount;
    }
    

    /**
     * 取得顯示幾行
     * @return 顯示幾行
     */
    public int getRowCount()
    {
        return this.rowCount;
    }
    

    /**
     * 取得目前頁基准行號
     * @return 顯示幾行
     */
    public int getBaseRowNo()
    {
        return getPageSize() * (getPageNo() - 1);
    }
    

    /**
     * 檢查工作是否已經準備好
     * @throws RuntimeException 已經準備好則拋出例外,可以不捕獲的例外
     */
    private void checkPrepare()
    {
        // 如果已經準備好,則不可以再改變
        if ( this.isPrepare )
        {
            System.out.println("分頁SQL已經使用,不可再修改; 若要修改,請在genPageHtml(), getPageSql() 方法之前");
            throw new RuntimeException();
        }
    }
    

    /**
     * 產生分頁的準備工作
     */
    private void setPrepare()
    {
        // 如果已經準備好,不再執行
        if ( this.isPrepare )
            return;
        
        setCountSql();
        try
        {
            // 產生SQL表達式
            PreparedStatement pstmt = this.conn.prepareStatement(this.countSql);
            ResultSet rs = null;
            // 查詢的參數資料集的筆數
            int valueListSize = (this.valueList == null) ? 0 : this.valueList.size();
            // 如果需要傳參數
            for ( int i = 0; i < valueListSize; i++ )
            {
                if ( valueList.get(i) == null )
                    pstmt.setNull(i + 1, java.sql.Types.NULL);
                else if ( valueList.get(i) instanceof String )
                    pstmt.setString(i + 1, "" + valueList.get(i));
                else if ( valueList.get(i) instanceof Integer )
                    pstmt.setInt(i + 1, Integer.parseInt("" + valueList.get(i)));
                else if ( valueList.get(i) instanceof Long )
                    pstmt.setLong(i + 1, Long.parseLong("" + (valueList.get(i))));
                else if ( valueList.get(i) instanceof Double )
                    pstmt.setDouble(i + 1, Double.parseDouble("" + (valueList.get(i))));
                else if ( valueList.get(i) instanceof java.util.Date )
                    pstmt.setDate(i + 1, new java.sql.Date(((java.util.Date)valueList.get(i)).getTime()));
                else if ( valueList.get(i) instanceof java.sql.Blob )
                    pstmt.setBlob(i + 1, (java.sql.Blob)valueList.get(i));
                else
                    pstmt.setObject(i + 1, valueList.get(i));
            }
            rs = pstmt.executeQuery();
            if ( rs.next() )
            {
                // 記錄的總數
                this.rowCount = rs.getInt(1);
                this.pageCount = (this.rowCount + this.pageSize - 1) / this.pageSize;
            }

            // pageNo防呆
            this.pageNo = this.pageNo > this.pageCount ? this.pageCount : this.pageNo;
            this.pageNo = this.pageNo < 1 ? 1 : this.pageNo;
            // 沒有資料時重設pageNo為0
            this.pageNo = this.rowCount <= 0 ? 0 : this.pageNo;
            // 開始序號
            this.StartNo = (this.pageNo - 1) * this.pageSize;
            setPageSql();
            
            // 關閉資源
            rs.close();
            pstmt.close();
        }
        // 例外
        catch ( Exception e )
        {
            // 第幾頁
            this.pageNo = 0;
            // 共幾頁
            this.pageCount = 0;
            // 顯示幾頁
            this.rowCount = 0;
            e.printStackTrace();
            this.isPrepare = false;
        }
        this.isPrepare = true;
    }
    

    /**
     * 產生一個分頁導航條的HTML,不區分上下分頁條
     * @return 傳回分頁的html，預設為上分頁
     * @throws Exception
     */
    public String genPageHtml()
    {
        return genPageHtml("", "");
    }
    
    
    /**
     * 產生一個分頁導航條的HTML,不區分上下分頁條
     * @param beforeSubmit 處理送出前的Java Script,建議是送出的(如果使用 AJAX, 請在最後加上return,避免送出)
     * @return 傳回分頁導航條的HTML內容
     */
    public String genPageHtml(String beforeSubmit)
    {
        return genPageHtml("", beforeSubmit);
    }
    

    /**
     * 產生一個分頁導航條的HTML,不區分上下分頁條
     * @param check 處理送出前的Java Script,建議是表單檢查的
     * @param beforeSubmit 處理送出時的Java Script,建議是送出的(如果使用Ajax,請在最後加上return,避免送出)
     * @return 傳回分頁頭部的HTML
     */
    public String genPageHtml(String check, String beforeSubmit)
    {
        return genPageHtml_all(check, beforeSubmit, this.button, this.button_comm, this.pageNumber);
    }
    

    /**
     * 產生一個分頁導航條的HTML,不區分上下分頁條
     * @param check 處理送出前的Java Script,建議是表單檢查的
     * @param beforeSubmit 處理送出時的Java Script,建議是送出的(如果使用Ajax,請在最後加上return,避免送出)
     * @return 傳回分頁頭部的HTML
     */
    private String genPageHtml_all(String check, String beforeSubmit, String button, String button_comm, int showNumber)
    {
        // 準備工作
        setPrepare();
        // 按鈕及數字的操作
        String javascript = check;
        // 設定頁碼
        javascript += " ;document.getElementById('" + pageFlag + "_PU_pageNo').value='{$pageNo}'; ";
        // 讓按鈕不可點選
        javascript += "var name_button = document.getElementsByName('" + pageFlag + "_PU_button'); ";
        javascript += "for(var i=0; i<name_button.length; i++){name_button[i].disabled=true;name_button[i].onclick=null;} ";
        // 讓數字不可再點選
        javascript += "var name_a = document.getElementsByName('" + pageFlag + "_PU_A'); ";
        javascript += "for(var i=0; i<name_a.length; i++){name_a[i].removeAttribute('href');name_a[i].onclick=null;} ";
        javascript += beforeSubmit;
        // 送出
        javascript += " ;try{submit();}catch(e){document.getElementById('" + pageFlag + "_PU_pageSize').form.submit();} ";
        
        // 導航條的html
        StringBuffer sList = new StringBuffer();
        sList.append("<div class=\"pagination sabrosus\"><ul>\r\n");
        
        // 第一頁,上一頁
        String pre_button = "";
        // disabled; 注:disabled在firefox下無效,所以得把 onclick 也刪除
        if ( this.pageNo <= 1 )
        {
        	pre_button = button.replace("{$comm_name}", "第一頁");
            pre_button += button.replace("{$comm_name}", "上一頁");
        	pre_button = pre_button.replace("{$class_name}", "class=\"disabled\"");
        }
        // 可用
        else
        {
        	pre_button = button.replace("{$comm_name}", button_comm);
        	pre_button = pre_button.replace("{$name}", "第一頁");
        	pre_button = pre_button.replace("{$onClick}", javascript.replace("{$pageNo}", "1"));
            pre_button += button.replace("{$comm_name}", button_comm);
            pre_button = pre_button.replace("{$name}", "上一頁");
        	pre_button = pre_button.replace("{$onClick}", javascript.replace("{$pageNo}", "" + (this.pageNo - 1)));
        	pre_button = pre_button.replace("{$class_name}", "");
        }
        sList.append(pre_button + "\r\n");
        
        // 產生分頁條中的數字顯示
        // 跳到第一頁
        //sList.append(genpageNumber(1, javascript));
        
        int halfPageNumber = showNumber / 2;
        // 分頁條中的開始數字
        int pageNumBegin = 1;
        if ( (this.pageCount > showNumber) && (this.pageNo > halfPageNumber + 1) )
        {
            pageNumBegin = this.pageNo - halfPageNumber;
            if ( showNumber + pageNumBegin >= this.pageCount )
                pageNumBegin = this.pageCount - showNumber + 1;
        }
        // 分頁條中的結束數字
        int pageNumEnd = this.pageCount;
        if ( (this.pageCount > showNumber) && (this.pageCount > this.pageNo + halfPageNumber) )
        {
            pageNumEnd = this.pageNo + halfPageNumber;
            if ( pageNumEnd < showNumber )
                pageNumEnd = showNumber;
        }
        
        // 省略的部分
        if ( pageNumBegin > 2 )
        {
            sList.append("&nbsp;...&nbsp;");
        }
        // 中間的數字
        for ( int i = pageNumBegin; i <= pageNumEnd; i++ )
        {
            sList.append(genpageNumber(i, javascript));
        }
        // 省略的部分
        if ( pageNumEnd < this.pageCount - 1 )
        {
            sList.append("&nbsp;...&nbsp;");
        }
        
        // 跳到最後一頁(只有一頁時不再顯示)
        /*
        if ( this.pageCount > 1 )
        {
            sList.append(genpageNumber(pageCount, javascript));
        }
		*/
        
        //下一頁,最後一頁
        String next_button = "";
        // disabled; 注:disabled在firefox下無效,所以得把 onclick 也刪除
        if ( this.pageNo >= this.pageCount )
        {
        	next_button = button.replace("{$comm_name}", "下一頁");
        	next_button += button.replace("{$comm_name}", "最後一頁");
        	next_button = next_button.replace("{$class_name}", "class=\"disabled\"");
        }
        // 可用
        else
        {
        	next_button = button.replace("{$comm_name}", button_comm);
        	next_button = next_button.replace("{$name}", "下一頁");
        	next_button = next_button.replace("{$onClick}", javascript.replace("{$pageNo}", "" + (this.pageNo + 1)));
        	next_button += button.replace("{$comm_name}", button_comm);
        	next_button = next_button.replace("{$name}", "最後一頁");
        	next_button = next_button.replace("{$onClick}", javascript.replace("{$pageNo}", "" + pageCount));
        	next_button = next_button.replace("{$class_name}", "");

        }
        sList.append(next_button);
        // 共多少筆
        sList.append("<li>共" + this.rowCount + "筆</li>");
        
        // 如果還沒有這段的時候輸出,有則不輸出
        if ( !this.hasOut )
        {
            // 隱藏域,儲存分頁訊息
            sList.append("<INPUT TYPE='hidden' NAME='" + pageFlag + "_PU_realSortFields' ID='" + pageFlag + "_PU_realSortFields' VALUE='" + realSortFields + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='" + pageFlag + "_PU_preSortFields' ID='" + pageFlag + "_PU_preSortFields' VALUE='" + preSortFields + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='" + pageFlag + "_PU_preSortAscOrDesc' ID='" + pageFlag + "_PU_preSortAscOrDesc' VALUE='" + preSortAscOrDesc + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='" + pageFlag + "_PU_pageNo' ID='" + pageFlag + "_PU_pageNo' VALUE='" + this.pageNo + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='" + pageFlag + "_PU_pageSize' ID='" + pageFlag + "_PU_pageSize' VALUE='" + pageSize + "'/> \r\n ");
            
            // 輸出過這段之後不再輸出
            this.hasOut = true;
        }
        sList.append("</ul></div> \r\n ");
        return sList.toString();
    }
    
    
    /**
     * 產生一個分頁導航條的HTML,不區分上下分頁條
     * @param check 處理送出前的Java Script,建議是表單檢查的
     * @param beforeSubmit 處理送出時的Java Script,建議是送出的(如果使用Ajax,請在最後加上return,避免送出)
     * @return 傳回分頁頭部的HTML
     */
    public String genPageHtml_two(String beforeSubmit, String shrinkSubmit)
    {
        return genPageHtml_two("", beforeSubmit, this.two_button_pre, this.two_button_next, shrinkSubmit);
    }
    
    
    /**
     * 產生一個分頁導航條的HTML,不區分上下分頁條
     * @param check 處理送出前的Java Script,建議是表單檢查的
     * @param beforeSubmit 處理送出時的Java Script,建議是送出的(如果使用Ajax,請在最後加上return,避免送出)
     * @return 傳回分頁頭部的HTML
     */
    private String genPageHtml_two(String check, String beforeSubmit, String preButton, String nextButon, String shrinkSubmit)
    {
        // 準備工作
        setPrepare();
        // 按鈕及數字的操作
        String javascript = check;
        // 設定頁碼
        //javascript += " ;document.getElementById('" + pageFlag + "_PU_pageNo').value='{$pageNo}'; ";
        javascript += beforeSubmit;
        // 送出
        javascript += " ;try{submit();}catch(e){document.getElementById('" + pageFlag + "_PU_pageSize').form.submit();} ";
        //按鈕及數字的操作
        String shrink_javascript = check;
        // 設定頁碼
        //shrink_javascript += " ;document.getElementById('" + pageFlag + "_PU_pageNo').value='{$pageNo}'; ";
        shrink_javascript += shrinkSubmit;
        
        // 導航條的html
        StringBuffer sList = new StringBuffer();
        sList.append("<div id='" + pageFlag + "_PU_page' class='twopage'>\r\n");
        // 展開
        String pre_button = preButton;
        // disabled; 注:disabled在firefox下無效,所以得把 onclick 也刪除
        if ( this.pageNo >= this.pageCount )
        {
            pre_button = pre_button.replace("{$onClick}", "");
            pre_button = pre_button.replace("{$href}", "");
            pre_button = pre_button.replace("{$disabled}", "disabled='disabled' class=\"disabled\"");
        }
        // 可用
        else
        {
            pre_button = pre_button.replace("{$onClick}", javascript.replace("{$pageNo}", "" + (this.pageNo + 1)));
            pre_button = pre_button.replace("{$href}", " href='#' ");
            pre_button = pre_button.replace("{$disabled}", "");
        }
        pre_button = pre_button.replace("{$pageFlag}", pageFlag);
        sList.append(pre_button + "\r\n");
        // 縮排
        String next_button = nextButon;
        // disabled; 注:disabled在firefox下無效,所以得把 onclick 也刪除
        if ( this.pageNo <= 1 )
        {
            next_button = next_button.replace("{$onClick}", "");
            next_button = next_button.replace("{$href}", "");
            next_button = next_button.replace("{$disabled}", "disabled='disabled' class=\"disabled\"");
        }
        // 可用
        else
        {
            next_button = next_button.replace("{$onClick}", shrink_javascript.replace("{$pageNo}", "" + (this.pageNo - 1)));
            next_button = next_button.replace("{$disabled}", "");
            next_button = next_button.replace("{$href}", " href='#' ");
        }
        next_button = next_button.replace("{$pageFlag}", pageFlag);
        sList.append(next_button);
        //目前資料筆數
        int nowrow = (pageNo * pageSize) > rowCount ? rowCount : (pageNo * pageSize);
        // 共多少筆
        sList.append("<span id='" + pageFlag + "_PU_nowTitle'>目前顯示<span id='" + pageFlag + "_PU_nowTotalRow'>" + nowrow + "</span>筆,</span>共" + this.rowCount + "筆");
        // 如果還沒有這段的時候輸出,有則不輸出
        if ( !this.hasOut )
        {
            // 隱藏域,儲存分頁訊息
            sList.append("<INPUT TYPE='hidden' NAME='" + pageFlag + "_PU_realSortFields' ID='" + pageFlag + "_PU_realSortFields' VALUE='" + realSortFields + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='" + pageFlag + "_PU_preSortFields' ID='" + pageFlag + "_PU_preSortFields' VALUE='" + preSortFields + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='" + pageFlag + "_PU_preSortAscOrDesc' ID='" + pageFlag + "_PU_preSortAscOrDesc' VALUE='" + preSortAscOrDesc + "'/> \r\n ");
            //字串
            sList.append("<INPUT TYPE='hidden' NAME='" + pageFlag + "_PU_pageNo' ID='" + pageFlag + "_PU_pageNo' VALUE='" + this.pageNo + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='" + pageFlag + "_PU_pageSize' ID='" + pageFlag + "_PU_pageSize' VALUE='" + pageSize + "'/> \r\n ");
            // 輸出過這段之後不再輸出
            this.hasOut = true;
        }
        sList.append("</div> \r\n ");
        return sList.toString();
    }
    

    /**
     * 產生分頁條中的數字顯示
     * @param nuber 當時頁數
     * @param javascript 處理點選時的Java Script
     * @return 分頁條中的數字顯示的HTML
     */
    private String genpageNumber(int nuber, String javascript)
    {
        String pageNumber = "";
        if ( nuber != this.pageNo )
        {
            pageNumber += this.tag_A.replace("{$number}", "" + nuber);
            pageNumber = pageNumber.replace("{$onClick}", javascript.replace("{$pageNo}", "" + nuber));
        }
        // 當時頁
        else
        {
            pageNumber += this.tag_span.replace("{$number}", "" + nuber);
        }
        return pageNumber;
    }
    
}
