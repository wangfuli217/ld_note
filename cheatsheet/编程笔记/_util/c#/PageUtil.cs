//2011/01/21 holer add <li>標籤的分頁條html 632-754
//2009/06/30 dennis 加入GetObjectQuery 278-310
//2009/06/02 andy 修改分頁 89-159
//version 0.3
using System;
using System.Configuration;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Data;
using System.Web;
using NHibernate;

namespace Com.Everunion.Util
{


    /// <summary>
    /// 分頁組件
    /// </summary>
    public class PageUtil
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(PageUtil));
        /// <summary>
        /// 原始SQL
        /// </summary>
        private String _sql;
        /// <summary>
        /// 分頁SQL
        /// </summary>
        private String _pageSql;
        /// <summary>
        /// 查詢總行數
        /// </summary>
        private String countSql;
        /// <summary>
        /// 分頁HTML
        /// </summary>
        private String encodeHtml;
        /// <summary>
        /// 頁面的寬
        /// </summary>
        private string pageWidth = "100%";
        /// <summary>
        /// 記錄總數
        /// </summary>
        private int _rowCount;
        /// <summary>
        /// 一頁顯示的記錄數
        /// </summary>
        private int pageSize = 10;
        /// <summary>
        /// 總頁數
        /// </summary>
        private int pageCount;
        /// <summary>
        /// 待顯示頁碼
        /// </summary>
        private int pageNo;
        /// <summary>
        /// 下拉列表顯示最大頁數
        /// </summary>
        private int maxPage = 100;
        /// <summary>
        /// 顯示多少個頁面跳轉按鈕
        /// </summary>
        private int maxto = 7;
        /// <summary>
        /// even
        /// </summary>
        private String even;
        /// <summary>
        /// odd
        /// </summary>
        private String odd;
        /// <summary>
        /// 是否準備好
        /// </summary>
        private bool isPrepare;
        private String pageFlag = "";
        /// <summary>
        /// 資料庫類型
        /// </summary>
        private string dbType = "";

        /// <summary>
        /// 從request中獲取要排序的欄位名稱, 如item_id或item_ID desc 
        /// </summary>
        private String realSortFields = "";
        /// <summary>
        /// 控制ORDER by asc, order by desc用 
        /// </summary>
        private String preSortFields = "";
        /// <summary>
        /// 控制ORDER by asc, order by desc用 
        /// </summary>
        private String preSortAscOrDesc = "";



        /// <summary>
        /// 構造方法
        /// </summary>
        public PageUtil()
        {
            //準備好
            isPrepare = false;
        }


        /// <summary>
        /// 分頁元件
        /// </summary>
        /// <param name="sql">查詢</param>
        public PageUtil(ISession session, String sql)
        {
            this.Sql = sql;
            //計算總筆數
            this.RowCount = StringUtil.ToInt(session.CreateSQLQuery(this.CountSql).SetMaxResults(1).UniqueResult());
        }


        /// <summary>
        /// 分頁元件
        /// </summary>
        /// <param name="sql">查詢</param>
        public PageUtil(ISession session, string sql, int PageSize)
        {
            this.pageSize = PageSize;
            this.Sql = sql;
            //計算總筆數
            this.RowCount = StringUtil.ToInt(session.CreateSQLQuery(this.CountSql).SetMaxResults(1).UniqueResult());
        }


        /// <summary>
        /// 資料庫類型
        /// </summary>
        public string DbType
        {
            get
            {
                return this.dbType;
            }

            set
            {
                //沒參數傳進來時
                if ( string.IsNullOrEmpty(value) )
                {
                    //oracle
                    if ( HibernateHelper.Dialect.GetType().FullName.IndexOf("OracleDialect") > -1 )
                    {
                        this.dbType = "oracle";
                    }
                    //sql server2000
                    else if ( HibernateHelper.Dialect.GetType().FullName.IndexOf("MsSql2000Dialect") > -1 )
                    {
                        this.dbType = "sqlserver";
                    }
                    //MySQL
                    else if ( HibernateHelper.Dialect.GetType().FullName.IndexOf("MySQLDialect") > -1 )
                    {
                        this.dbType = "mysql";
                    }
                }
                else
                {
                    this.dbType = value.ToLowerInvariant();
                }
            }
        }

        //2009/06/02 andy start 修改分頁　
        /// <summary>
        /// 分頁的SQL
        /// </summary>
        public String PageSql
        {
            get
            {
                //驗證依賴
                if ( !isPrepare )
                    throw new Exception("非本地SQL查詢，不可呼叫此屬性！");
                //傳入的SQL
                String strSql = _sql.Trim();
                //表示需要排序
                if ( !string.IsNullOrEmpty(realSortFields) )
                {
                    //oracle
                    if ( "oracle".Equals(this.dbType) )
                    {
                        // 已經有 order by 
                        if ( strSql.ToLowerInvariant().IndexOf(" order ") > 0 )
                        {
                            // 將 strSql ==> select a.* from ( strSql ) a ORDER BY 1,2
                            strSql = "select _PU_A.* from (" + strSql + ") _PU_A order by " + realSortFields;
                        }
                        // 沒有 order by,直接在後面加上, 這樣效率會更高
                        else
                        {
                            strSql += " order by " + realSortFields;
                        }
                        int startRow = (this.pageNo - 1) * this.pageSize + 1;
                        int endRow = this.pageNo * this.pageSize;
                        // 需要排序sql
                        this._pageSql = "SELECT * FROM ( SELECT ROWNUM as _PU_ROWNUM, _PU_B.* from ("
                            + strSql + ") _PU_B where _PU_ROWNUM <= " + endRow
                            + " ) WHERE _PU_ROWNUM >= " + startRow;
                    }
                    //sql server2000
                    else if ( "sqlserver".Equals(this.dbType) )
                    {
                        realSortFields += ",keyID";
                        _pageSql = "SELECT TOP " + pageSize + " * FROM " + "(" + strSql + ") A  "
                               + " where (keyID NOT IN " + "(SELECT TOP " + (pageSize * (pageNo - 1))
                               + "	keyid from (" + strSql
                               + ") B order by " + realSortFields + ")) order by " + realSortFields;
                    }
                    //MySQL
                    else if ( "mysql".Equals(this.dbType) )
                    {
                        int startRow = this.pageSize * (this.pageNo - 1);
                        string tem_sql = strSql.ToLowerInvariant();
                        //多個空格取代成一個空格
                        tem_sql = Regex.Replace(tem_sql, @"\s+", " ");
                        // 已經有 limit
                        if ( tem_sql.IndexOf(" limit ") > 0 )
                        {
                            // 此句效率很低,非迫不得已則不使用
                            this._pageSql = "SELECT _PU_.* from (" + strSql + " ) _PU_ order by " + realSortFields + " limit "
                                + startRow + "," + this.pageSize;
                        }
                        // 已經有 order by
                        else if ( tem_sql.IndexOf(" order by ") > 0 )
                        {
                            //  order by 後面沒有括號(即order by 不是子查詢),直接在後面補上排序
                            if ( tem_sql.LastIndexOf(")") < tem_sql.LastIndexOf(" order by ") )
                            {
                                this._pageSql = strSql + ", " + realSortFields + " limit " + startRow + "," + this.pageSize;
                            }
                            // order by 在子查詢裡面
                            else
                            {
                                // 此句效率很低,非迫不得已則不使用
                                this._pageSql = "SELECT _PU_.* from (" + strSql + " ) _PU_ order by "
                                    + realSortFields + " limit " + startRow + "," + this.pageSize;
                            }
                        }
                        // 沒有 order by 和 limit,則直接在後面加上, 這樣效率更高
                        else
                        {
                            this._pageSql = strSql + " order by " + realSortFields + " limit " + startRow + "," + this.pageSize;
                        }
                    }
                }
                //表示不需要排序
                else
                {
                    //oracle
                    if ( "oracle".Equals(this.dbType) )
                    {
                        int startRow = (this.pageNo - 1) * this.pageSize + 1;
                        int endRow = this.pageNo * this.pageSize;
                        this._pageSql = "SELECT * FROM ( SELECT ROWNUM as _PU_ROWNUM, _PU_A.* from ("
                            + strSql + ") _PU_A WHERE _PU_ROWNUM <= " + endRow + " ) WHERE _PU_ROWNUM >= " + startRow;
                    }
                    //SqlServer2000
                    else if ( "sqlserver".Equals(this.dbType) )
                    {
                        _pageSql = "SELECT TOP " + pageSize + " * FROM (" + strSql + ") A "
                            + " where keyID>(select max(keyid) from (SELECT TOP " + (pageSize * (pageNo - 1))
                            + " keyid FROM (" + strSql + ") b ORDER BY keyid)) order by keyID";
                    }
                    //MySQL
                    else if ( "mysql".Equals(this.dbType) )
                    {
                        int startRow = this.pageSize * (this.pageNo - 1);
                        // 已經有 limit
                        if ( strSql.ToLowerInvariant().IndexOf(" limit ") > 0 )
                        {
                            this._pageSql = "SELECT _PU_.* from (" + strSql + " ) _PU_ limit "
                                + startRow + "," + this.pageSize;
                        }
                        // 沒有 limit,則直接在後面加上, 這樣效率更高
                        else
                        {
                            this._pageSql = strSql + " limit " + startRow + "," + this.pageSize;
                        }
                    }
                }
                return _pageSql;
            }
        }
        //2009/06/02 andy end


        /// <summary>
        /// 計算總行數
        /// </summary>
        public string CountSql
        {
            get
            {
                string temSql = this._sql.Trim().ToLowerInvariant();
                // 如果是簡單SQL直接修改,以提高效率
                if ( temSql.IndexOf(" from ") == temSql.LastIndexOf(" from ") && temSql.IndexOf(" distinct ") < 0
                    && temSql.IndexOf(" avg(") < 0 && temSql.IndexOf(" count(") < 0 && temSql.IndexOf(" max(") < 0
                    && temSql.IndexOf(" min(") < 0 && temSql.IndexOf(" sum(") < 0 && temSql.IndexOf(" group ") < 0 )
                {
                    this.countSql = "SELECT COUNT(*) " + this._sql.Substring(this._sql.IndexOf(" from "));
                }
                else
                {
                    // 此句效率很低,該盡量用上面的SQL來查詢
                    this.countSql = "SELECT COUNT(*) FROM (" + this._sql + ") _PU_A";
                }
                return countSql;
            }
        }


        /// <summary>
        /// 設定總行數
        /// </summary>
        public int RowCount
        {
            get
            {
                //取得總數
                return _rowCount;
            }
            set
            {
                //預設資料庫類型
                this.DbType = null;
                ProcessParam();
                //資料驗證                 
                _rowCount = value;
                pageCount = (_rowCount + pageSize - 1) / pageSize;
                //修改過,當時頁大於實際頁或小於1時重設pageNo為1
                pageNo = pageNo > pageCount ? pageCount : pageNo;
                pageNo = pageNo < 1 ? 1 : pageNo;
                //準備好
                isPrepare = true;
                HttpContext.Current.Items["PageTop"] = this.GenPageHtml("top", "");
                HttpContext.Current.Items["PageBottom"] = this.GenPageHtml("bottom", "");
                //總
                HttpContext.Current.Items["Page_total"] = pageCount;
                //2009-07-08 修改過,無資料時,重設pageNo為1,但顯示於頁面時為零
                HttpContext.Current.Items["Page_page"] = _rowCount <= 0 ? 0 : pageNo;
                HttpContext.Current.Items["Page_records"] = _rowCount;
            }
        }


        /// <summary>
        /// 總頁
        /// </summary>
        public int PageCount
        {
            get
            {
                //取得總頁數
                return pageCount;
            }
        }


        /// <summary>
        /// 設定原查詢
        /// </summary>
        public string Sql
        {
            set
            {
                //標志值
                isPrepare = false;
                _sql = value;
            }
        }


        /// <summary>
        /// hibernate系統分頁
        /// </summary>
        /// <param name="session">ISession連結會話</param>
        /// <param name="hql">hibernate查詢</param>
        /// <returns>IQuery元件</returns>
        public IQuery GetQuery(ISession session, String hql)
        {
            //計算總筆數           
            this.RowCount = StringUtil.ToInt(session.CreateQuery("select count(*) " + hql).SetMaxResults(1).UniqueResult());
            //排序
            if ( !"".Equals(realSortFields) )
            {
                hql += " Order by " + realSortFields;
            }
            return session.CreateQuery(hql).SetFirstResult(((pageNo - 1) * pageSize)).SetMaxResults(pageSize);
        }


        //2009/06/30 dennis add 加入GetObjectQuery
        /// <summary>
        /// hibernate系統分頁
        /// </summary>
        /// <param name="session">ISession連結會話</param>
        /// <param name="hql">hibernate查詢</param>
        /// <param name="isgroup">true or false</param>
        /// <returns>IQuery元件</returns>
        public IQuery GetObjectQuery(ISession session, String hql, bool isgroup)
        {
            //查詢sql
            string sql = hql;
            sql = " select count(*)  " + hql.Substring(sql.ToLower().IndexOf("from"));
            //為group by 查詢
            if ( isgroup )
            {
                //計算總筆數           
                this.RowCount = StringUtil.ToInt(session.CreateQuery(sql).List().Count);
            }
            //其它
            else
            {
                //計算總筆數           
                this.RowCount = StringUtil.ToInt(session.CreateQuery(sql).SetMaxResults(1).UniqueResult());
            }
            //排序
            if ( !"".Equals(realSortFields) )
            {
                hql += " Order by " + realSortFields;
            }
            //操作訊息
            return session.CreateQuery(hql).SetFirstResult(((pageNo - 1) * pageSize)).SetMaxResults(pageSize);
        }
        //2009/06/30 dennis end


        private void ProcessParam()
        {
            HttpRequest request = HttpContext.Current.Request;
            //顏色
            even = "#EEEEEE";
            odd = "#BBBBBB";
            //操作碼
            isPrepare = false;
            //設定和取得當時頁碼
            pageFlag = "".Equals(StringUtil.ToStr(request.Params["pageFlag"])) ? "" : StringUtil.ToStr(request.Params["pageFlag"]);
            if ( pageFlag.Equals("top") )
            {
                pageNo = "".Equals(StringUtil.ToStr(request.Params["top_pageNo"])) ? 1 : StringUtil.ToInt(request.Params["top_pageNo"]);
                //設定和取得頁大小
                pageSize = "".Equals(StringUtil.ToStr(request.Params["top_pageSize"])) ? pageSize : StringUtil.ToInt(request.Params["top_pageSize"]);
                //是否為null
            }
            //下分頁
            else if ( pageFlag.Equals("bottom") )
            {
                pageNo = "".Equals(StringUtil.ToStr(request.Params["bottom_pageNo"])) ? 1 : StringUtil.ToInt(request.Params["bottom_pageNo"]);
                //設定和取得頁大小
                pageSize = "".Equals(StringUtil.ToStr(request.Params["bottom_pageSize"])) ? pageSize : StringUtil.ToInt(request.Params["bottom_pageSize"]);
            }
            //jqGrid分頁
            else
            {
                pageNo = "".Equals(StringUtil.ToStr(request.Params["page"])) ? 1 : StringUtil.ToInt(request.Params["page"]);
                //設定和取得頁大小
                pageSize = "".Equals(StringUtil.ToStr(request.Params["rows"])) ? pageSize : StringUtil.ToInt(request.Params["rows"]);
            }
            //頁面大小小于1
            if ( pageSize < 1 )
                pageSize = 10;
            //排序
            realSortFields = StringUtil.ToStr(request.Params["realSortFields"]);
            preSortFields = StringUtil.ToStr(request.Params["preSortFields"]);
            preSortAscOrDesc = StringUtil.ToStr(request.Params["preSortAscOrDesc"]);
            //jqGrid分頁
            if ( StringUtil.ToStr(request.Params["sidx"]).Length > 0 )
                realSortFields = StringUtil.ToStr(request.Params["sidx"]) + " " + StringUtil.ToStr(request.Params["sord"]);
            //log.Info("realSortFields:" + realSortFields);
        }


        /// <summary>
        /// 取代"{...}
        /// </summary>
        /// <param name="strSRC">要取代的字串</param>
        /// <returns>已經取代好的字串</returns>
        private String strEncode(String strSRC)
        {
            //"第"   
            strSRC = strSRC.Replace("{ORDER}", "第");
            strSRC = strSRC.Replace("{ROW}", "筆");
            //"大小"
            strSRC = strSRC.Replace("{SIZE}", "每頁");
            //頁
            strSRC = strSRC.Replace("{PAGE}", "頁");
            strSRC = strSRC.Replace("{TOTAL}", "共");
            strSRC = strSRC.Replace("{FIRST}", "第一頁");
            strSRC = strSRC.Replace("{UP}", "上一頁");
            strSRC = strSRC.Replace("{DOWN}", "下一頁");
            strSRC = strSRC.Replace("{LAST}", "最後一頁");
            return strSRC;
        }


        /**
         * 產生一個分頁的html,button按鈕和輸入框的形式
         * @param sEvent 處理按下GO按鍵的Java Script
         * @return String 返回分頁頭部的HTML
         */
        public String GenPageHtml_old(String flag, String sEvent)
        {
            String changeSize = "";
            String changeNo = "";
            //頁數框的名字
            String text_pageNo = "";
            //多少筆資料大小框的名字
            String text_pageSize = "";
            String buttonName = "";
            //button
            String bu_1 = "";
            String bu_2 = "";
            String bu_3 = "";
            String bu_4 = "";
            //html
            String setPageFlag = "; var tem_pageFlag = document.getElementById('pageFlag'); tem_pageFlag.value='" + flag + "';" +
                   "tem_pageFlag.form.submit();$(':button[name^=bu]').attr('disabled','true');" +
                   "$('#goToPagen').attr('disabled','true');$('#bottom_button').attr('disabled','true');";
            //上面部分的html  
            if ( "top".Equals(flag) )
            {
                //pageNo,pageSize,button
                text_pageNo = "top_pageNo";
                text_pageSize = "top_pageSize";
                buttonName = "goToPagen";
                //button
                bu_1 = "bu1";
                bu_2 = "bu2";
                bu_3 = "bu3";
                bu_4 = "bu4";
                //頁面大小
                changeSize = "$('#bottom_pageSize').val(this.value);";
                changeNo = "$('#bottom_pageNo').val(this.value);";
            }
            //下面部分的html 
            if ( flag.Equals("bottom") )
            {
                //pageNo,pageSize,button
                text_pageNo = "bottom_pageNo";
                text_pageSize = "bottom_pageSize";
                buttonName = "bottom_button";
                //button
                bu_1 = "bu5";
                bu_2 = "bu6";
                bu_3 = "bu7";
                bu_4 = "bu8";
                //頁面大小
                changeSize = "$('#top_pageSize').val(this.value);";
                changeNo = "$('#top_pageNo').val(this.value);";
            }
            //html
            String sHtml1 = "";
            String sHtml2 = "";
            String sBttnTY = sEvent.ToUpper().IndexOf(".CLICK()") > 0
                          || sEvent.ToUpper().IndexOf(".SUBMIT()") > 0 ? "button" : "button";
            //StringBuffer
            StringBuilder sList = new StringBuilder();
            //html
            sHtml1 = "<DIV ID='pageControlID'>"
                   + "<table width=100% cellspacing='0' cellpadding='0' border='0' id='table_1'>"
                   + "<TR ALIGN='left' class='T12Gary'>"
                   + "<TD >{SIZE}&nbsp;<INPUT TYPE='text' NAME='" + text_pageSize + "' id='" + text_pageSize + "' CLASS='input' SIZE='1' MAXLENGTH='2' VALUE='" + pageSize + "' onBlur=\"this.value = parseInt(isNaN(parseInt(this.value)) || this.value == '' ? " + pageSize + " : this.value);" + changeSize + "\">&nbsp;{ROW}</TD>"
                //頁數
                   + "<TD align=center ID='pageTDRowCountInfo'><DIV ID='pageDIVRowCountInfo'>{ORDER}"
                   + (pageNo > 0 ? (pageNo - 1) * pageSize + 1 : pageNo) + "~"
                   + (pageNo * pageSize > _rowCount ? _rowCount : pageNo * pageSize)
                //筆數
                   + "{ROW}/{TOTAL}" + _rowCount + "{ROW}"
                   + "</DIV></TD>"
                   + "<TD align=right>"
                //首頁
                   + "<INPUT NAME='" + bu_1 + "' id='" + bu_1 + "' TYPE='" + sBttnTY + "' VALUE='|<' CLASS='small' onClick=\"" + sEvent + " $('#" + text_pageNo + "').val("
                   + 1 + ");" + setPageFlag + "\" " + ((pageNo == 1) ? "DISABLED" : "") + ">"
                //向上跳1頁
                   + "&nbsp;<INPUT NAME='" + bu_2 + "' id='" + bu_2 + "' TYPE='" + sBttnTY + "' VALUE='<' CLASS='small' onClick=\"" + sEvent + " $('#" + text_pageNo + "').val("
                   + (pageNo - 1) + ");" + setPageFlag + "\" " + ((pageNo <= 1) ? "DISABLED" : "") + ">"
                   + "&nbsp;{ORDER}";

            //輸入頁數TEXT
            sList.Append("&nbsp;<INPUT TYPE='text' NAME='" + text_pageNo + "' id='" + text_pageNo + "' CLASS='input' SIZE='3' MAXLENGTH='8' VALUE='" + pageNo + "' onBlur=\"this.value = parseInt(isNaN(parseInt(this.value)) || this.value == '' ? 1 : this.value);" + changeNo + "\">");
            //html
            sHtml2 = "&nbsp;{PAGE}/{TOTAL}" + pageCount + "{PAGE}"
                //向下跳1頁
                   + "&nbsp;<INPUT NAME='" + bu_3 + "' id='" + bu_3 + "'  TYPE='" + sBttnTY + "' VALUE='>' CLASS='small' onClick=\"" + sEvent + "$('#" + text_pageNo + "').val("
                   + (pageNo + 1) + ");" + setPageFlag + "\" " + (pageNo >= pageCount ? "DISABLED" : "") + ">"
                //尾頁
                   + "&nbsp;<INPUT NAME='" + bu_4 + "' id='" + bu_4 + "' TYPE='" + sBttnTY + "' VALUE='>|' CLASS='small' onClick=\"" + sEvent + "$('#" + text_pageNo + "').val("
                   + pageCount + ");" + setPageFlag + "\" " + (pageNo == pageCount ? "DISABLED" : "") + ">";
            //go按鈕
            sBttnTY = "top".Equals(flag) ? "submit" : sBttnTY;
            sHtml2 += "&nbsp;<INPUT TYPE='" + sBttnTY + "' id='" + buttonName + "' NAME='" + buttonName + "' VALUE='GO' CLASS='small' onClick=\"" + sEvent + setPageFlag + "\"" + (_rowCount > 0 ? "" : "DISABLED") + "/>"
                   + "</TD>";

            if ( "top".Equals(flag) )
            {	//html   
                sHtml2 += "<INPUT TYPE='hidden' NAME='realSortFields' id='realSortFields'  VALUE='" + realSortFields + "'/>"
                    //排序
                   + "<INPUT TYPE='hidden' NAME='preSortFields' id='preSortFields'   VALUE='" + preSortFields + "'/>"
                   + "<INPUT TYPE='hidden' NAME='preSortAscOrDesc' id='preSortAscOrDesc' VALUE='" + preSortAscOrDesc + "'/>"
                   + "<INPUT TYPE='hidden' NAME='pageFlag' id='pageFlag' VALUE=''/>"
                   + "</TR></TABLE></DIV>";
            }
            //下分頁
            else
            {
                sHtml2 += "</TR></TABLE></DIV>";
            }
            //// 寬度不夠隱藏 1~6筆/共6筆 這個欄位
            sHtml2 += " <SCRIPT type='text/javascript' language='JavaScript'>            " +
                      "   if ( $('#pageControlID').attr('offsetHeight') > 30 )           " +
                      "   {                                                              " +
                      "        $('#pageDIVRowCountInfo').hide();  " +
                      "        $('#pageTDRowCountInfo').hide;  " +
                      "   }                                                              " +
                      " </SCRIPT>                                                        ";
            //返回 
            return _rowCount == 0 ? "" : strEncode(sHtml1) + sList.ToString() + strEncode(sHtml2);
        }


        //2011/01/21 holer add <li>標籤的分頁條html start
        /**
         * 產生一個分頁的html
         */
        public String GenPageHtml()
        {
            return GenPageHtml("top", "");
        }


        /**
         * 產生一個分頁的html,li標籤按鈕樣式,沒有輸入框
         * @param sEvent 處理按下GO按鍵的Java Script
         * @return String 返回分頁頭部的HTML
         */
        public String GenPageHtml(string flag, string sEvent)
        {
            //button
            string bu_1 = "bu1";
            string bu_2 = "bu2";
            string bu_3 = "bu3";
            string bu_4 = "bu4";
            //防止為 null
            sEvent = string.IsNullOrEmpty(sEvent) ? "" : sEvent;
            sEvent = "javascript:" + sEvent + "; var tem_pageNo = document.getElementById('top_pageNo'); tem_pageNo.value=";
            //html
            string setPageFlag = "; try{submit();}catch(e){tem_pageNo.form.submit();} $(':button[name^=bu]').attr('href','javascript:void(0);');";
            //html
            string sHtml1 = "<DIV class='pager'><div class='pagination quotes'><ul>";
            //第一頁
            if ( pageNo <= 1 )
            {
                sHtml1 += "<li class='disabled'>{FIRST}</li>";
            }
            else
            {
                sHtml1 += "<li><a NAME='" + bu_1 + "' href=\"" + sEvent + 1 + setPageFlag + "\" >{FIRST}</a></li>";
            }
            //上一頁
            if ( pageNo <= 1 )
            {
                sHtml1 += "<li class='disabled'>{UP}</li>";
            }
            else
            {
                sHtml1 += "<li><a NAME='" + bu_2 + "' href=\"" + sEvent + (pageNo - 1) + setPageFlag + "\" >{UP}</a></li>";
            }

            int helfPage = maxto / 2;
            //最開始一個按鈕的顯示數字
            int for_begin = 1;
            if ( (pageCount > maxto) && (pageNo > (maxto / 2)) )
            {
                for_begin = (pageNo - helfPage);
                for_begin = (pageCount - for_begin < maxto - 1) ? (pageCount - maxto + 1) : for_begin;
            }
            //最後一個按鈕的顯示數字
            int for_end = pageCount;
            if ( (pageCount > maxto) && (pageCount > pageNo + helfPage) )
            {
                for_end = (pageNo + helfPage);
                for_end = (for_end < maxto) ? maxto : for_end;
            }

            //前3點
            if ( for_begin > 1 )
            {
                sHtml1 += "...";
            }
            //迴圈，拼接出各頁按鈕
            for ( int i = for_begin; i <= for_end; i++ )
            {
                if ( i != pageNo )
                {
                    sHtml1 += "<li><a NAME='bu_" + i + "' href=\"" + sEvent + i + setPageFlag + "\">" + i + "</a></li>";
                }
                else
                {
                    sHtml1 += "<li class='current'>" + i + "</li>";
                }
            }
            //後3點
            if ( for_end < pageCount )
            {
                sHtml1 += "...";
            }

            //下一頁
            if ( pageNo >= pageCount )
            {
                sHtml1 += "<li class='disabled'>{DOWN}</li>";
            }
            else
            {
                sHtml1 += "<li><a NAME='" + bu_3 + "' href=\"" + sEvent + (pageNo + 1) + setPageFlag + "\" >{DOWN}</a></li>&nbsp;";
            }
            //最後一頁
            if ( pageNo >= pageCount )
            {
                sHtml1 += "<li class='disabled'>{LAST}</li>";
            }
            else
            {
                sHtml1 += "<li><a NAME='" + bu_4 + "' id='" + bu_4 + "' href=\"" + sEvent + pageCount + setPageFlag + "\" >{LAST}</a></li>";
            }
            //共多少頁
            sHtml1 += "<li>{TOTAL}" + pageCount + "{PAGE}</li></ul>";
            //第一次輸出
            if ( "top".Equals(flag) )
            {	//html   
                sHtml1 += "<INPUT TYPE='hidden' NAME='realSortFields' id='realSortFields'  VALUE='" + realSortFields + "'/>"
                    //排序
                   + "<INPUT TYPE='hidden' NAME='preSortFields' id='preSortFields'   VALUE='" + preSortFields + "'/>"
                   + "<INPUT TYPE='hidden' NAME='preSortAscOrDesc' id='preSortAscOrDesc' VALUE='" + preSortAscOrDesc + "'/>"
                   + "<INPUT TYPE='hidden' NAME='top_pageNo' id='top_pageNo' VALUE=''/>"
                   + "<INPUT TYPE='hidden' NAME='pageFlag' id='pageFlag' VALUE='top'/>";
            }
            sHtml1 += "</div></div>";
            //返回 
            return _rowCount == 0 ? "" : strEncode(sHtml1);
        }
        //2011/01/21 holer end
    }

}
