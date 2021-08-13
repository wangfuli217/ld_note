/**
 * <P> Title: 公用類別                                      </P>
 * <P> Description: 分頁元件                                </P>
 * <P> Copyright: Copyright (c) 2010/08/07                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

/**
 * 分頁元件 <br />
 * 注意: <br />
 * 1.上下分頁模板必須放在form表單元件中,否則會有JS錯誤; <br />
 * 2.占用的名稱全部使用“_PU_”開頭,為避免名稱衡突,請勿使用這個開頭的名稱 <br />
 * 3.SQL Server版本的需設置主鍵為第一列 (如:select Id, name from userTable where ...),其中Id為主鍵. <br />
 *   多主鍵,可採用下面方法(select a.Id+a.name as keyId from userTable a where ... )). <br />
 * 4.使用AJAX查詢時, 請在 genPageHtml(check, beforeSubmit)方法的beforeSubmit裡面的最後加上return,避免submit <br />
 * 5.排序列,可使用  onClick="_PU_.sort('排序列');" <br />
 * 6.設定頁數 和 設定每頁顯示多少筆,必須在取分頁條HTML和取查詢SQL之前執行 <br />
 * @author <A HREF='daillow@gmail.com'>Holer</A>
 * @version 0.1
 */
public class PageUtil
{
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
    // 一頁顯示的記錄數，預設為10
    private int pageSize = 10;
    // 總頁數
    private int pageCount = 0;
    // 待顯示頁碼
    private int pageNo = 0;
    // 記錄是否為空
    private boolean pageSizeIsNull;
    // 從request中獲取要排序的欄位名稱, 如item_id或item_ID desc
    private String sortFields = "";
    // 控制ORDER by asc, order by desc用
    private String sortAscOrDesc = "";
    // 資料庫類型
    private String DbType = "mysql";
    // 查詢的參數
    private List<Object> valueList = null;
    // 是否準備好
    private boolean isPrepare = false;
    // 輸出分頁條的次數
    private int outTimes = 0;
    
    /**
     * 從哪筆開始
     */
    public int StartNo = 0;
    
    /**
     * 按鈕及輸入框html,可直接在此修改
     */
    // 第一頁
    private String button_first = "<INPUT NAME='_PU_button' TYPE='button' VALUE='|<' CLASS='_PU_btn' onClick='_PU_.setPageNo(1, true);' ${disabled} />";
    // 上一頁
    private String button_pre = "<INPUT NAME='_PU_button' TYPE='button' VALUE='<' CLASS='_PU_btn' onClick='_PU_.setPageNo(${thisPageNo}, true);' ${disabled} />";
    // 下一頁
    private String button_next = "<INPUT NAME='_PU_button' TYPE='button' VALUE='>' CLASS='_PU_btn' onClick='_PU_.setPageNo(${thisPageNo}, true);' ${disabled} />";
    // 最後一頁
    private String button_last = "<INPUT NAME='_PU_button' TYPE='button' VALUE='>|' CLASS='_PU_btn' onClick='_PU_.setPageNo(${pageCount}, true);' ${disabled} />";
    // go按鈕
    private String button_go = "<INPUT NAME='_PU_button' TYPE='button' VALUE='GO' CLASS='_PU_btn' onClick='_PU_.submit();' ${disabled} />";
    // 每頁多少筆的輸入框
    private String text_size = "<INPUT NAME='_PU_text_size' TYPE='text' CLASS='_PU_text' SIZE='2' MAXLENGTH='3' VALUE='${pageSize}' ${disabled} onChange='_PU_.textSize_change(this);' onkeydown='return _PU_.input(event);' />";
    // 跳轉到第幾頁的輸入框
    private String text_pageNo = "<INPUT NAME='_PU_text_pageNo' TYPE='text' CLASS='_PU_text' SIZE='2' MAXLENGTH='3' VALUE='${pageNo}' ${disabled} onChange='_PU_.textPageNo_change(this);' onkeydown='return _PU_.input(event);' />";
    
    
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
        // 數據庫連結參數
        this.conn = DBconn;
        
        // 取得待顯示頁碼
        this.pageNo = request.getParameter("_PU_pageNo") == null ? 1 : Integer.parseInt(request
                .getParameter("_PU_pageNo"));
        // 設定和取得頁大小
        this.pageSize = request.getParameter("_PU_pageSize") == null ? pageSize : Integer.parseInt(request
                .getParameter("_PU_pageSize"));
        // 是否為null
        this.pageSizeIsNull = request.getParameter("_PU_pageSize") == null;
        
        // 要排序的欄位名稱
        this.sortFields = request.getParameter("_PU_sortFields") == null ? "" : request
                .getParameter("_PU_sortFields");
        // 控制ORDER by asc, order by desc用
        this.sortAscOrDesc = request.getParameter("_PU_sortAscOrDesc") == null ? "" : request
                .getParameter("_PU_sortAscOrDesc");
        
        // 資料庫類型
        setDbType(DbType);
        
        // 設定查詢SQL
        this.sql = (sql == null || "".equals(sql.trim())) ? "" : sql;
        this.valueList = valueList;
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
        // 沒有參數時,由資料庫連接來取
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
     * 設定查詢總計多少筆資料的SQL
     * @exception 當select里有distinct的時,可能會出錯
     */
    private void setCountSql()
    {
        String sql = this.sql.trim().toLowerCase();
        // 如果是簡單SQL直接修改,以提高效率
        if ( sql.indexOf(" from ") == sql.lastIndexOf(" from ") && sql.indexOf(" distinct ") < 0
        	&& sql.indexOf(" avg(") < 0 && sql.indexOf(" count(") < 0 && sql.indexOf(" max(") < 0
        	&& sql.indexOf(" min(") < 0 && sql.indexOf(" sum(") < 0 && sql.indexOf(" group ") < 0 )
        {
            this.countSql = "SELECT COUNT(*)" + this.sql.substring(sql.indexOf(" from "));
        }
        else
        {
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
     * 處理select command裡有distinct和group by command以及排序
     */
    private void setPageSql()
    {
        // 傳入的SQL
        String strSql = this.sql.trim();
        // 設定頁碼(防呆)
        this.pageNo = (this.pageNo <= 0 ? 1 : this.pageNo);
        
        // 表示需要排序
        if ( !"".equals(this.sortFields) )
        {
            // 排序欄位和排序方向
            String order = this.sortFields + " " + this.sortAscOrDesc;
            
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
                    + strSql + ") AS _PU_A ORDER BY 1 ASC "
                    + ") AS _PU_B ORDER BY 1 DESC )  AS _PU_C ORDER BY " + order;
            }
            // Oracle
            else if ( "oracle".equals(this.DbType) )
            {
                // 將 strSql ==> select a.* from ( strSql ) a ORDER BY 1,2
                strSql = "select _PU_A.* from (" + strSql + ") _PU_A order by " + order;
                // 需要排序sql
                this.pageSql = "SELECT * FROM ( SELECT ROWNUM as _PU_ROWNUM, _PU_B.* from (" + strSql + ") _PU_B  ) "
                    + " WHERE _PU_ROWNUM BETWEEN " + ((this.pageNo - 1) * this.pageSize + 1) + " AND " + (this.pageNo * this.pageSize);
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
                    + strSql + ") AS _PU_A ORDER BY 1 ASC ) AS _PU_B ORDER BY 1 DESC ) as _PU_C ORDER BY 1 ASC";
            }
            // Oracle
            else if ( "oracle".equals(this.DbType) )
            {
                this.pageSql = "SELECT * FROM ( SELECT ROWNUM as _PU_ROWNUM, _PU_A.* from (" + strSql + ") _PU_A  ) "
                    + " WHERE _PU_ROWNUM BETWEEN " + ((this.pageNo - 1) * this.pageSize + 1) + " AND " + (this.pageNo * this.pageSize);
            }
        }
    }
    
    
    /**
     * 取得每頁產生的記錄數
     * @return 每頁產生的記錄數
     */
    public int getPageSize()
    {
        return this.pageSize;
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
     * 取得頁數
     * @return 頁數
     */
    public int getPageCount()
    {
        return this.pageCount;
    }
    
    
    /**
     * 取得第幾頁
     * @return 第幾頁
     */
    public int getPageNo()
    {
        return this.pageNo;
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
     * @return 成功傳回true,失敗傳回false
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
                // 取得參數
                Object obj = this.valueList.get(i);
                // 根據參數類型來賦值
                if ( obj == null )
                    pstmt.setNull(i + 1, java.sql.Types.NULL);
                else if ( obj instanceof String )
                    pstmt.setString(i + 1, "" + valueList.get(i));
                else if ( obj instanceof Integer )
                    pstmt.setInt(i + 1, Integer.parseInt("" + obj));
                else if ( obj instanceof Long )
                    pstmt.setLong(i + 1, Long.parseLong("" + obj));
                else if ( obj instanceof Double )
                    pstmt.setDouble(i + 1, Double.parseDouble("" + obj));
                else if ( obj instanceof java.util.Date )
                    pstmt.setDate(i + 1, new java.sql.Date(((java.util.Date)obj).getTime()));
                else if ( obj instanceof java.sql.Blob )
                    pstmt.setBlob(i + 1, (java.sql.Blob)obj);
                else
                    pstmt.setObject(i + 1, obj);
            }
            rs = pstmt.executeQuery();
            if ( rs.next() )
            {
                // 記錄的總數
                this.rowCount = rs.getInt(1);
                this.pageCount = (this.rowCount + this.pageSize - 1) / this.pageSize;
            }
            
            // 沒有資料時重設pageNo為0
            this.pageNo = this.pageNo > this.pageCount ? this.pageCount : this.pageNo;
            this.pageNo = this.pageNo < 1 ? 1 : this.pageNo;
            this.pageNo = this.rowCount <= 0 ? 0 : this.pageNo;
            // 開始序號
            this.StartNo = (this.pageNo - 1) * this.pageSize;
            setPageSql();
            
            // 關閉資源
            rs.close();
            pstmt.close();
            this.isPrepare = true;
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
    }
    
    
    /**
     * 產生一個分頁導航條的HTML,不區分上下分頁條
     * @return 傳回分頁導航條的HTML內容
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
     * 產生一個分頁導航條的HTML, 不區分上下分頁條
     * @param check 處理送出前的Java Script,建議是表單檢查的
     * @param beforeSubmit 處理送出前的Java Script,建議是送出的(如果使用 AJAX, 請在最後加上return,避免送出)
     * @return 傳回分頁導航條的HTML內容
     */
    public String genPageHtml(String check, String beforeSubmit)
    {
        // 準備工作
        setPrepare();
        
        // 導航條的html
        StringBuffer sList = new StringBuffer();
        sList.append("<DIV ID='_PU_pageControl" + this.outTimes + "'> \r\n");
        sList.append("<TABLE width='100%' cellspacing='0' cellpadding='0' border='0' class='_PU_table' id='_PU_table'> \r\n");
        sList.append("<TBODY><TR ALIGN='center'> \r\n");
        
        // 第一欄位(內容為: 每頁多少筆)
        sList.append("<TD align='left'>&nbsp;${EverPage}");
        // 輸入框:每頁多少筆
        sList.append(this.text_size.replace("${pageSize}", this.pageSize + "")
                .replace("${disabled}", ((this.pageCount <= 0) ? "DISABLED" : "")));
        sList.append("${ROW}&nbsp;</TD> \r\n");
        
        // 第二欄位(第1~10筆/共74筆)
        sList.append("<TD align='center' ID='_PU_TDRowCount" + this.outTimes + "'>&nbsp;${ORDER}<em>");
        sList.append(this.pageNo > 0 ? (this.rowCount > 0 ? ((this.pageNo - 1) * this.pageSize + 1) : 0) : this.pageNo);
        sList.append("</em>~<em>");
        sList.append((this.pageNo * this.pageSize > this.rowCount) ? this.rowCount : (this.pageNo * this.pageSize));
        sList.append("</em>${ROW}/${TOTAL}<em>");
        sList.append(this.rowCount);
        sList.append("</em>${ROW}&nbsp;</TD> \r\n");
        
        // 第三欄位(按鈕,及第幾頁輸入框)
        sList.append("<TD align='right'> \r\n");
        // 按鈕:第一頁
        sList.append(this.button_first.replace("${disabled}", ((this.pageNo == 1) ? "DISABLED" : "")));
        sList.append("&nbsp; \r\n");
        // 按鈕:上一頁
        sList.append(this.button_pre.replace("${disabled}", ((this.pageNo <= 1) ? "DISABLED" : ""))
                .replace("${thisPageNo}", (this.pageNo - 1) + ""));
        sList.append("&nbsp; \r\n");
        // 輸入框:第幾頁
        sList.append("&nbsp;${ORDER}");
        sList.append(this.text_pageNo.replace("${pageNo}", this.pageNo + "")
                .replace("${disabled}", ((this.pageCount <= 0) ? "DISABLED" : "")));
        // 共多少頁
        sList.append("${PAGE}/${TOTAL}<em>");
        sList.append(this.pageCount > 0 ? this.pageCount : 1);
        sList.append("</em>${PAGE}&nbsp;");
        // 按鈕:下一頁
        sList.append(this.button_next.replace("${disabled}", ((this.pageNo >= this.pageCount) ? "DISABLED" : ""))
                .replace("${thisPageNo}", (this.pageNo + 1) + ""));
        sList.append("&nbsp; \r\n");
        // 按鈕:最後一頁
        sList.append(this.button_last.replace("${disabled}", ((this.pageNo >= this.pageCount) ? "DISABLED" : ""))
                .replace("${pageCount}", "" + this.pageCount));
        sList.append("&nbsp; \r\n");
        // 按鈕:送出(go)
        sList.append(this.button_go.replace("${disabled}", ((this.pageCount <= 0) ? "DISABLED" : "")));
        sList.append("</TR></TBODY></TABLE></DIV>");
        
        
        // 如果還沒有這段的時候輸出,有則不輸出
        if ( this.outTimes == 0 )
        {
            // 儲存訊息的隱藏域
            sList.append("<INPUT TYPE='hidden' NAME='_PU_sortFields' ID='_PU_sortFields' VALUE='" + this.sortFields + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='_PU_sortAscOrDesc' ID='_PU_sortAscOrDesc' VALUE='" + this.sortAscOrDesc + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='_PU_pageNo' ID='_PU_pageNo' VALUE='" + this.pageNo + "'/> \r\n ");
            sList.append("<INPUT TYPE='hidden' NAME='_PU_pageSize' ID='_PU_pageSize' VALUE='" + this.pageSize + "'/> \r\n ");
            
            // js 函數
            sList.append(" <SCRIPT type='text/javascript' language='JavaScript'> \r\n");
            // js 分頁公用類,所有的js函數都包括在這類別裡面,以免佔用過多關鍵字
            sList.append(" var _PU_ = new Object(); \r\n");
            
            /**
             * 送出
             * @param pageNo 送出的頁碼
             * @param pageSize 每頁顯示多少筆
             */
            sList.append(" _PU_.submit = function () { \r\n");
            // js驗證
            check = (check == null || check.trim().length() == 0) ? "" : check + "; \r\n";
            // 先執行檢查的 js
            sList.append(check);
            // 讓按鈕不可點選
            sList.append("   var btnName = window.document.getElementsByName('_PU_button'); \r\n");
            sList.append("   for ( var i=0; i < btnName.length; i++ ) { btnName[i].disabled=true; } \r\n");
            // 讓每頁多少筆輸入框不可再輸入
            sList.append("   var text_sizeName = window.document.getElementsByName('_PU_text_size'); \r\n");
            sList.append("   for ( var i=0; i < text_sizeName.length; i++ ) { text_sizeName[i].disabled=true; } \r\n");
            // 讓第幾頁輸入框不可再輸入
            sList.append("   var text_pageNoName = window.document.getElementsByName('_PU_text_pageNo'); \r\n");
            sList.append("   for ( var i=0; i < text_pageNoName.length; i++ ) { text_pageNoName[i].disabled=true; } \r\n");
            // 執行送出前的動作(也可以是ajax送出)
            sList.append((beforeSubmit == null || beforeSubmit.trim().length() == 0) ? "" : beforeSubmit + "; \r\n");
            // 送出
            sList.append("   window.document.getElementById('_PU_pageSize').form.submit(); \r\n");
            sList.append("}; \r\n");
            
            /**
             * 設置頁碼
             * @param pageNo 跳轉到的頁碼
             * @param isSubmit 是否送出,為true時設定頁碼後送出,否則只設定頁碼不送出
             */
            sList.append(" _PU_.setPageNo = function (pageNo, isSubmit) { \r\n");
            // 設定頁碼
            sList.append("    window.document.getElementById('_PU_pageNo').value = parseInt(pageNo); \r\n");
            sList.append("    if ( true === isSubmit ) { this.submit(); } \r\n");
            sList.append(" }; \r\n");
            
            /**
             * 設定每頁顯示多少筆
             * @param pageSize 每頁顯示多少筆
             * @param isSubmit 是否送出,為true時設定顯示數後送出,否則只設定不送出
             */
            sList.append(" _PU_.setPageSize = function (pageSize, isSubmit) { \r\n");
            sList.append("    if ( 0 < parseInt(pageSize) ) { window.document.getElementById('_PU_pageSize').value=parseInt(pageNo); } \r\n");
            // 設定跳轉到第幾頁
            sList.append("    window.document.getElementById('_PU_pageSize').value = parseInt(pageSize); \r\n");
            sList.append("    if ( true === isSubmit ) { this.submit(); } \r\n");
            sList.append(" }; \r\n");
            
            /**
             * 過濾按鍵,只允許輸入數字
             * @param event 事件 (為兼容 IE 和 FireFox)
             * @example <input type="text" onkeydown="return _PU_.input(event);"/>
             */
            sList.append(" _PU_.input = function (event) { \r\n");
            // 兼容 IE 和 FireFox
            sList.append("   event = event || window.event; \r\n");
            // 不讓按下 Shift
            sList.append("   if ( event.shiftKey === true ) { return false; } \r\n");
            // 按下的鍵的編碼
            sList.append("   var code = event.charCode || event.keyCode; \r\n");
            // 輸入數字
            sList.append("   if ( (code >= 48 && code <= 57) || (code >= 96 && code <= 105) || ");
            // 輸入刪除按鍵,左右按鍵
            sList.append("     code === 8  || code === 46 || code === 39 || code === 37  ) { return true; } \r\n");
            // Enter 鍵,先執行 onchange 事件,再送出
            sList.append("   if ( code === 13 ) { \r\n");
            // 取得事件源
            sList.append("      var source = event.target || event.srcElement; \r\n");
            // 事件源的名稱
            sList.append("      var name = source.getAttribute('name'); \r\n");
            // 執行每頁多少筆的輸入框的 onchange 事件
            sList.append("      if ( '_PU_text_size' === name ) { this.textSize_change(source); } \r\n");
            // 執行跳轉到第幾頁的輸入框的 onchange 事件
            sList.append("      else if ( '_PU_text_pageNo' === name ) { this.textPageNo_change(source); } \r\n");
            // 送出
            sList.append("      this.submit(); \r\n");
            sList.append("   } \r\n");
            // 其它按鍵,不讓輸入
            sList.append("   return false; \r\n");
            sList.append(" }; \r\n");
            
            /**
             * 每頁多少筆的輸入框的 onchange 事件
             * @param inputer 輸入框物件
             */
            sList.append(" _PU_.textSize_change = function(inputer) { \r\n");
            // 設值,輸入不正確時預設為原本的值
            sList.append("   inputer.value = (parseInt(inputer.value) || " + this.pageSize + " ); \r\n");
            // 設值,總體的值
            sList.append("   window.document.getElementById('_PU_pageSize').value = inputer.value; \r\n");
            // 設值,其它的每頁多少筆的輸入框的值
            sList.append("   var text_size = window.document.getElementsByName('_PU_text_size'); \r\n");
            sList.append("   for ( var i = 0; i < text_size.length; i++ ) { text_size[i].value = inputer.value; } \r\n");
            sList.append(" }; \r\n");
            
            /**
             * 跳轉到第幾頁的輸入框的 onchange 事件
             * @param inputer 輸入框物件
             */
            sList.append(" _PU_.textPageNo_change = function(inputer) { \r\n");
            // 設值,輸入不正確時預設為原本的值
            sList.append("   inputer.value = (parseInt(inputer.value) || " + this.pageNo + " ); \r\n");
            // 設值,總體的值
            sList.append("   window.document.getElementById('_PU_pageNo').value = inputer.value; \r\n");
            // 設值,其它的每頁多少筆的輸入框的值
            sList.append("   var text_pageNo = window.document.getElementsByName('_PU_text_pageNo'); \r\n");
            sList.append("   for ( var i = 0; i < text_pageNo.length; i++ ) { text_pageNo[i].value = inputer.value; } \r\n");
            sList.append(" }; \r\n");
            
            /**
             * 調節寬度, 寬度不夠時隱藏 “第1~6筆/共6筆” 這個欄位
             * @param outTime 第幾個分頁導航條
             */
            sList.append(" _PU_.autoWidth = function(outTime) { \r\n");
            sList.append("   if ( window.document.getElementById('_PU_pageControl' + outTime).offsetHeight > 30 ) { \r\n");
            sList.append("      window.document.getElementById('_PU_TDRowCount' + outTime).style.display = 'none'; \r\n");
            sList.append("   } \r\n");
            sList.append(" }; \r\n");
            
            /**
             * 排序方法(供頁面引用)
             * @param filed 排序的欄位
             */
            sList.append(" _PU_.sort = function(filed) { \r\n");
            sList.append("   if ( !filed ) { return; } \r\n");
            // 排序欄位
            sList.append("   var sortElement = window.document.getElementById('_PU_sortFields'); \r\n");
            sList.append("   var preSortValue = sortElement.value; \r\n");
            sList.append("   sortElement.value = filed; \r\n");
            // 排序方向
            sList.append("   var ascDescElement = window.document.getElementById('_PU_sortAscOrDesc'); \r\n");
            sList.append("   var pre_order = ascDescElement.value.toLowerCase(); \r\n");
            sList.append("   if ( preSortValue === sortElement.value ) { ascDescElement.value = ( 'asc' === pre_order ) ? 'desc' : 'asc'; } \r\n");
            sList.append("   else { ascDescElement.value = 'asc' } \r\n");
            // 送出
            sList.append("   this.submit(); \r\n");
            sList.append(" }; \r\n");
            
            sList.append(" </SCRIPT> \r\n");
        }

        // 寬度不夠時隱藏 “第1~6筆/共6筆” 這個欄位
        sList.append(" <SCRIPT type='text/javascript' language='JavaScript'> \r\n");
        sList.append("   _PU_.autoWidth(" + this.outTimes + "); \r\n");
        sList.append(" </SCRIPT> \r\n");

        this.outTimes++;
        return strEncode(sList.toString());
    }
    
    
    /**
     * 取代固定的變量
     * @param strSRC 要取代的字串
     * @return 取代後的字串
     */
    private String strEncode(String strSRC)
    {
        strSRC = strSRC.replace("${ORDER}", "\u7B2C"); // 第
        strSRC = strSRC.replace("${PAGE}", "\u9801"); // 頁
        strSRC = strSRC.replace("${TOTAL}", "\u5171"); // 共
        strSRC = strSRC.replace("${ROW}", "\u7B46"); // 筆
        strSRC = strSRC.replace("${EverPage}", "\u6BCF\u9801"); // 每頁
        // strSRC = strSRC.replace("${GOTO}", "\u8DF3\u5230"); //跳到
        return strSRC;
    }
    
}
