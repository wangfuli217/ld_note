//2009/10/06 jackter 加入取得資訊  行:326-434
//2009/09/25 jackter 添加判斷各項目是否已填寫  行:202-315
//2009/09/14 andy 添加函數 129-192
/**
 * <P> Title: ftc											</P>
 * <P> Description: 取得顯示標題及確認訊息       			</P>
 * <P> Copyright: Copyright (c) 2009/09/12					</P>
 * <P> Company:Everunion Tech. Ltd. 						</P>
 * @author jackter
 * @version 0.4 Original Design from design document.
 */ 
package com.everunion.util;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;


import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;

import com.everunion.dao.CompareChange;
import com.everunion.dao.Dao;
import com.everunion.pool.DBConnect;

/**
 * 取得顯示標題及確認訊息
 */
public class TypeUtil {

	//確認訊息
	private String mess;
	//顯示標題
	private String title;
	
	/**
	 * 取標題值
	 * @return 標題
	 */
	public String getTitle() {
		return title;
	}
	
	/**
	 * 設標題值
	 * @param title 標題
	 */
	public void setTitle(String title) {
		this.title = title;
	}
	/**
	 * 取訊息值
	 * @return 訊息
	 */
	public String getMess() {
		return mess;
	}
	
	/**
	 * 設訊息值
	 * @param mess 訊息
	 */
	public void setMess(String mess) {
		this.mess = mess;
	}
	
	/**
	 * 產生資料
	 * @param state Enterprise表的state欄位值
	 * @return 類型資訊
	 * @throws Exception 例外
	 */
	public static TypeUtil getInstance(int state) throws Exception 
	{		
		return new TypeUtil(state);
	}
	
	
	/**
	 * 建構
	 * @param state Enterprise表的state欄位值
	 * @throws Exception 例外
	 */
	private TypeUtil(int state) throws Exception
	{
		String _mess = "業者目前有編輯中尚未送出的{VALUE},請問是否確定要編輯?";
		switch ( state )
		{
			//報備	
			case 0: 
				this.title = "報備"; 
				this.mess = _mess.replace("{VALUE}", "報備書");
				break;
			case 2: 
				this.title = "報備補正";
				this.mess = _mess.replace("{VALUE}", "報備補正書");
				break;
			case 4:
			case 8:
				this.title = "變更報備";
				this.mess = _mess.replace("{VALUE}", "變更報備書");
				break;
			case 6: 
				this.title = "變更報備補正";
				break;
			case 10:
				this.title = "補登報備";
				this.mess = _mess.replace("{VALUE}", "補登報備書");
				break;
			case 12:
				this.title = "補登報備補正";
				this.mess = _mess.replace("{VALUE}", "補登報備補正書");
				break;
			//審核
			case 1: 
				this.title = "報備審核";
				break;
			case 3: 
				this.title = "報備補正審核";
				break;
			case 5: 
				this.title = "變更報備審核";
				break;			
			case 7: 
				this.title = "變更報備補正審核";
				break;
			case 11: 
				this.title = "補登報備審核";
				break;
			case 13: 
				this.title = "補登報備補正審核";
				break;
			//退件
			case 98:
				this.mess = "已退件報備禁止{VIEW}";				
				break;
			//撤消
			case 99:
				this.title = "已撤消報備";
				this.mess = "已撤銷報備禁止{VIEW}";				
				break;
			default:
				throw new Exception("錯誤的(Enterprise)狀態碼!");				
		}
	}
	
	
	//2009/09/15 andy start 添加函數
	/**
	 * 是否編輯
	 * @param conn　連結
	 * @param company　統編
	 * @return　是否編輯
	 */
	public static boolean isEditState(Connection conn, String company) throws Exception
	{
		Statement state = null;
		int st = 0;
		try
		{
			state = conn.createStatement();
			//查詢
			ResultSet re = state.executeQuery("SELECT 狀態 FROM enterprise where 統編='" + company + "'");
			if ( re.next() )
			{
				st = StringUtil.toInt(re.getString("狀態"));
			}
			//是否編輯
			if ( st == 0 || st == 4 || st == 6  || st == 8 || st == 2 || st == 12 || st == 10 )
			{
				return true;
			}
			else 
				return false;
		}
		//例外
		catch ( Exception e )
		{
			throw e;
		}
		finally
		{
			//關閉
			if ( state != null )
				state.close();
		}
	}
	
	
	/**
	 * 計算方式轉換
	 * @param type 計算方式
	 * @return 計算方式
	 */
	public static String bonusType(String type)
	{
		if ( "0".equals(type) )
        	return "不歸零制";
        else if ( "1".equals(type) )
        	return "歸零制--按月";
        else if ( "2".equals(type) )
        	return "歸零制--按季";
        else if ( "3".equals(type) )
        	return "歸零制--按年";
        else if ( "4".equals(type) )
        	return "歸零制--按其他";
        else if ( "5".equals(type) )
        	return "歸零與不歸零混合制";
		return "";
	}
	//2009/09/15 andy end
	
	
	
	
	//2009/09/25 jackter 加入判斷各項目是否已填寫 start
	/**
	 * 判斷各項目是否已填寫
	 * @param stepList 項目列表
	 * @param conn connection連結
	 * @param isTemp 是否查詢暫存檔
	 * @param comid 統編
	 * @param mess 資訊
	 * @throws Exception 
	 */
	public static void ifFillIn(String[] stepList,Connection conn,boolean isTemp,String comid,String mess) throws Exception
	{		
		comid = StringUtil.toSqlStr(comid);
		String tmp = isTemp ? "_t" : "";
		String changeDate = "",update_project=null;
		int state = 0;
		HashMap hm = new HashMap();		
		boolean[] isUpload = new boolean[5];
		//附件
		String sql = "select * from upload" + tmp +" where 統編='" + comid + "'";
		hm = Dao.getOneData(conn, sql);
		if ( !hm.isEmpty() )
		{
			 if ( !StringUtil.toStr(hm.get("營利事業登記證")).equals("") )
				 isUpload[0] = true;
			 if ( !StringUtil.toStr(hm.get("組織規範")).equals("") )
				 isUpload[1] = true;
			 if ( !StringUtil.toStr(hm.get("商品資料")).equals("") )
				 isUpload[2] = true;
			 if ( !StringUtil.toStr(hm.get("參加契約")).equals("") )
				 isUpload[3] = true;
			 if ( !StringUtil.toStr(hm.get("契約附件")).equals("") )
					 isUpload[4] = true;
		}		
		//項目一
		sql="SELECT 統編,狀態,事業名稱,預定營業日期,變更實施日期,update_project from enterprise" + tmp +" where 統編='" + comid + "'";
		hm = Dao.getOneData(conn,sql);
		if ( !hm.isEmpty() )
		{			 
			 state = StringUtil.toInt(hm.get("狀態"),0); 
			 //變更報備實施日期
			 changeDate = StringUtil.toStr(hm.get("變更實施日期"));
			 //變更項目列表
			 update_project = StringUtil.toStr(hm.get("update_project"));
			 //項目一
			 if ( isUpload[0] )
				 stepList[1]=mess;			 
			 //項目三
			 if ( StringUtil.toStr(hm.get("預定營業日期")).length() == 10 )
				 stepList[3]=mess;			 
		}
		//無資料
		else if ( isTemp )
		{			
			sql="SELECT 狀態  from enterprise where 統編='" + comid + "'";
			state = StringUtil.toInt(Dao.queryOne(conn, sql));			
		}
		
		//項目二
		sql="SELECT 1 from office" + tmp +" where 統編='"+comid+"'";
		hm = Dao.getOneData(conn,sql);
		if ( !hm.isEmpty() ) 
		{   
			stepList[2]=mess;
		}	   
		//項目四
		sql="SELECT 1 from level" + tmp +" where 統編='"+comid+"'";
		hm = Dao.getOneData(conn,sql);		
		if ( !hm.isEmpty() )	
		{  
			sql="SELECT 1 from level_global" + tmp +" where 統編='"+comid+"'";
			hm = Dao.getOneData(conn,sql);
			if ( !hm.isEmpty() ) 
			{ 
				stepList[4]=mess;
			}
		}
		//項目五
		sql="SELECT 1 from bonus" + tmp +" where FILE2 is not null and FILE2<>'' and 計算方式 is not null "+
			" and 計算方式<>'' and 計算基準 is not null and 計算基準<>'' and 獎金一 is not null and 獎金一<>'' "+
			" and 發放比率 is not null  and 統編='"+comid+"'";
	    hm = Dao.getOneData(conn,sql);
		if ( !hm.isEmpty() ) {  stepList[5]=mess; }    
		//項目六/八
		sql="SELECT * from contract" + tmp +" where 統編='"+comid+"'";
		hm = Dao.getOneData(conn,sql);
		if ( !hm.isEmpty() )
		{  	   
			//項目六
			if ( !StringUtil.toStr(hm.get("file3")).equals("") && !StringUtil.toStr(hm.get("傳銷法令")).equals("") &&
				 !StringUtil.toStr(hm.get("file4")).equals("") && !StringUtil.toStr(hm.get("瑕疵擔保")).equals("") &&
				 !StringUtil.toStr(hm.get("file5")).equals("") && !StringUtil.toStr(hm.get("解除契約")).equals("") &&
				 !StringUtil.toStr(hm.get("file6")).equals("") && !StringUtil.toStr(hm.get("退貨處理")).equals("") &&
				 !StringUtil.toStr(hm.get("file7")).equals("") && !StringUtil.toStr(hm.get("違約處理")).equals("") &&			    
				((!StringUtil.toStr(hm.get("file8")).equals("") &&  StringUtil.toStr(hm.get("isjoin")).equals("Y")) ||
				 !StringUtil.toStr(hm.get("isjoin")).equals("Y")) )
		    {
				stepList[6]=mess;
		    }
			
			String isdetraction = StringUtil.toStr(hm.get("isdetraction"));
			//項目八
			if ( isdetraction.equals("N") || (isdetraction.equals("Y") 
					&& !StringUtil.toStr(hm.get("file9")).equals("") 
					&& !StringUtil.toStr(hm.get("減損標準")).equals("")) )								
		    {
			   stepList[8]=mess;
		    }		   
	   }
	   //項目七
	   sql="SELECT 1 from product" + tmp +" where 統編='"+comid+"'";
	   hm = Dao.getOneData(conn,sql);
	   if ( !hm.isEmpty() && isUpload[2] )
	   {
		   //至少要有一筆明細
		   if ( "1".equals(Dao.queryOne(conn,"select 1 from product_detail" + tmp +" where 統編='"+comid+"'")) )
			{
			   stepList[7]=mess;
			}
	   }		   
	   //項目九
	   if ( isUpload[1] && isUpload[3] && isUpload[4] )
	   {
		   stepList[9]=mess;
	   } 		
	   //項目十(變更實施日期不為空)
	   sql = " SELECT 1 FROM ev_contributions_t t WHERE company_id='"+ comid +"'";
	   hm = Dao.getOneData(conn,sql);
	   if ( !hm.isEmpty() ) 
	   { 	   
		   //變更報備時(變更實施日期不可為空)==公司檔無資料時不做處理
		   if ( state==4 || state == 8 )
		   {			   
			   //有填寫變更實施日期
			   if ( changeDate.length() == 10 )
			   { 
				   //有變更項目
				   if ( !update_project.equals("") )
					   stepList[10]=mess; 
			   } 
		   }
		   //其它
		   else
			   stepList[10]=mess; 
	   }	   
	   	//傳回
		//return stepList;
	}
	//2009/09/25 jackter end
	
	
	
	/**
	 * 取得資訊
	 * @param companyid 統編
	 * @return MemoVars 資訊
	 * @throws Exception 例外
	 */
	public static MemoVars setMemoVars(String companyid) throws Exception
	{
		return setMemoVars(companyid,true);
	}
	
	
	/**
	 * 取得資訊
	 * @param companyid 統編
	 * @param isTemp 是否查暫存檔
	 * @return MemoVars 資訊
	 * @throws Exception 例外
	 */
	private static MemoVars setMemoVars(String companyid,boolean isTemp) throws Exception
	{
		return setMemoVars(null,companyid,isTemp);
	}
	
	
	//2009/10/06 jackter 加入取得資訊 start
	/**
	 * 取得資訊
	 * @param in_conn Connection連結
	 * @param companyid 統編
	 * @param isTemp 是否查暫存檔
	 * @return MemoVars 資訊
	 * @throws Exception 例外
	 */
	public static MemoVars setMemoVars(Connection in_conn,String companyid,boolean isTemp) throws Exception
	{
		MemoVars memo = new MemoVars();
		memo.company_id=companyid;
		String sql = "";
		HashMap hm = new HashMap();
		Connection conn = in_conn;
		try
		{
			//無連結時創建
			if ( in_conn == null )
				conn = DBConnect.getConn();		

			//文稿說明處郵件日期取audit_log表結案時的異動日期
			sql = "select DATE(異動日期) from audit_log where 承辦狀態='6' and 統編='" + StringUtil.toSqlStr(companyid) 
				+ "' order by 異動日期 desc limit 1";
			String mail_date = Dao.queryOne(conn, sql);
			//文稿說明處郵件日期
			if ( mail_date.length() == 10 )
			{	
				if ( mail_date.indexOf("/") > -1 )
					memo.mail_date = mail_date.split("/");
				else
					memo.mail_date = mail_date.split("-");
				memo.mail_date[0] = Integer.toString(Integer.parseInt(memo.mail_date[0])-1911);
				memo.mail_date[1] = Integer.toString(Integer.parseInt(memo.mail_date[1]));
				memo.mail_date[2] = Integer.toString(Integer.parseInt(memo.mail_date[2]));
			}
			
			//查暫存檔
			if ( isTemp )
			{
				sql = "select * from enterprise_t where 統編='" + StringUtil.toSqlStr(companyid) + "'";
				hm = Dao.getOneData(conn, sql);
				//無資料查實體檔
				if ( hm.isEmpty() )
				{
					sql = "select * from enterprise where 統編='" + StringUtil.toSqlStr(companyid) + "'";
					hm = Dao.getOneData(conn, sql);
				}
			}
			//查實體檔
			else
			{
				sql = "select * from enterprise where 統編='" + StringUtil.toSqlStr(companyid) + "'";
				hm = Dao.getOneData(conn, sql);
			}				
			
			//有資料
			if ( !hm.isEmpty() )
			{
				memo.company_name=StringUtil.toStr(hm.get("事業名稱"),memo.company_name);
				memo.company_ceo=StringUtil.toStr(hm.get("負責人姓名"),memo.company_ceo);
				memo.company_money=StringUtil.toStr(hm.get("實收資本額"),memo.company_money);
				memo.contact_name=StringUtil.toStr(hm.get("聯絡人姓名"),memo.contact_name);
				memo.contact_tel=StringUtil.toStr(hm.get("聯絡人電話"),memo.contact_tel);
				memo.email_user = StringUtil.toStr(hm.get("公司電子信箱"),memo.email_user);
				//最新報備日期
				String audit_date = StringUtil.toStr(hm.get("最新報備日期"));
				//預定營業日期
				String start_date = StringUtil.toStr(hm.get("預定營業日期"));
				//登記日期
				String issue_date = StringUtil.toStr(hm.get("登記日期"));	
				//變更實施日期
				String changeDate = StringUtil.toStr(hm.get("變更實施日期"));
				//狀態
				String state = StringUtil.toStr(hm.get("狀態"));
				//變更實施日期
				if ( changeDate.length() == 10 )
				{					
					changeDate=changeDate.replaceAll("/", "-");
					String[] changes = changeDate.split("-");
					//非二次變更報備時
					if ( !(state.equals("8") && is2Reload(conn,companyid,false)) )
					{
						memo.mgChange_date = StringUtil.gy2mg(changeDate);
						memo.change_date = Integer.toString(Integer.parseInt(changes[0])-1911) + "年"
							+ Integer.toString(Integer.parseInt(changes[1])) + "月"
							+ Integer.toString(Integer.parseInt(changes[2])) + "日";	
					}								
				}
				//最新報備日期
				if ( audit_date.length() == 10 )
				{					
					memo.creation_date = audit_date;
					if ( audit_date.indexOf("/") > -1 )
						memo.audit_date = audit_date.split("/");
					else
						memo.audit_date = audit_date.split("-");
					memo.audit_date[0] = Integer.toString(Integer.parseInt(memo.audit_date[0])-1911);
					memo.audit_date[1] = Integer.toString(Integer.parseInt(memo.audit_date[1]));
					memo.audit_date[2] = Integer.toString(Integer.parseInt(memo.audit_date[2]));
					
					//無值取最新報備日期
					if (  mail_date.length() != 10 )
					{
						memo.mail_date[0] = memo.audit_date[0];
						memo.mail_date[1] = memo.audit_date[1];
						memo.mail_date[2] = memo.audit_date[2];
					}
					
				}
				//預定營業日期
				if ( start_date.length() == 10 )
				{					
					if ( audit_date.indexOf("/") > -1 )
						memo.start_date = start_date.split("/");
					else
						memo.start_date = start_date.split("-");
					memo.start_date[0] = Integer.toString(Integer.parseInt(memo.start_date[0])-1911);
					memo.start_date[1] = Integer.toString(Integer.parseInt(memo.start_date[1]));
					memo.start_date[2] = Integer.toString(Integer.parseInt(memo.start_date[2]));
				}
				//登記日期
				if ( issue_date.length() == 10 )
				{					
					if ( issue_date.indexOf("/") > -1 )
						memo.issue_date = issue_date.split("/");
					else
						memo.issue_date = issue_date.split("-");
					memo.issue_date[0] = Integer.toString(Integer.parseInt(memo.issue_date[0])-1911);
					memo.issue_date[1] = Integer.toString(Integer.parseInt(memo.issue_date[1]));
					memo.issue_date[2] = Integer.toString(Integer.parseInt(memo.issue_date[2]));
				}		
			}
			//無資料
			else
			{
				sql = "select 單位 from user_info where 帳號='" + StringUtil.toSqlStr(companyid) + "'";
				hm = Dao.getOneData(conn,sql);
				if ( !hm.isEmpty() )
				{
					memo.company_name = StringUtil.toStr(hm.get("單位"),memo.company_name);
				}
			}			
			
			return memo;			
		}
		//關閉
		finally
		{
			//自建連結時釋放
			if ( in_conn == null )
				DBConnect.freeConn(conn);
		}
		
	}
	
	
	/**
	 * memo資訊
	 */
	public static class MemoVars
	{
		//事業名稱
		public String company_name = "○○○○○";
		//聯絡人姓名
		public String contact_name = "○○○";
		//聯絡人電話
		public String contact_tel = "○";
		//最新報備日期
		public String[] audit_date = {"○","○","○"};
		//電子郵件通知日期
		public String[] mail_date = {"○","○","○"};
		//預定營業日期
		public String[] start_date = {"○","○","○"};
		//負責人姓名
		public String company_ceo = "○○○";
		//實收資本額
		public String company_money = "○";
		//統編
		public String company_id = "○";
		//登記日期
		public String[] issue_date = {"○","○","○"};	
		//最新報備日期(原始格式)
		public String creation_date = null;
		//變更實施日期
		public String change_date = "○年○月○日";
		//變更實施日期(民國格式)
		public String mgChange_date = "";
		//公司電子信箱
		public String email_user = "";
	}
	//2009/10/06 jackter end
	
	
	/**
	 * 當天是否已審查
	 * @param conn Connection連結
	 * @param audit_id 統編
	 * @param audit_type 申報類別
	 * @param audit_date 申報日期
	 * return true or false
	 */
	public boolean isBeanCheckedToday(Connection conn,String audit_id,String auidt_type,String audit_date) throws Exception
	{
		String sql = "select 1 from formal_no where 統編='" + StringUtil.toSqlStr(audit_id)
			+ "' and 申報日期='" + StringUtil.toSqlStr(audit_date) + "' and 申報類別='"
			+ StringUtil.toSqlStr(auidt_type)+"'";
		//已存在
		if ( "1".equals(Dao.queryOne(conn, sql)) )
		{
			return true;
		}
		//不存在
		return false;
	}
	
	
	
	/**
	 * 按unicode編碼取子字串
	 * @param s 待處理字串
	 * @param length 所取長度
	 * @return String 子字串
	 * @throws UnsupportedEncodingException 例外
	 */
	public static String bSubstring(String s, int length) throws UnsupportedEncodingException
    {
		byte[] bytes = s.getBytes("Unicode");
		//目前字節數
		int n = 0; 
		//要截取的字節數,從第3個字節開始
		int i = 2; 
		for ( ; i < bytes.length && n < length; i++ )
		{
			//奇數位置,為UCS2編碼中兩個字節的第二個字節
			if ( i % 2 == 1 )
			{
				//在UCS2第二個字節時n加1
				n++; 
			}
			else
			{
				//UCS2編碼第一個字節不等於0時,該UCS2字符為漢字,一個漢字算兩個字節
				if ( bytes[i] != 0 )
				{
					n++;
				}
			}
		}
		//為奇數時,處理成偶數
		if ( i % 2 == 1 )
		{
			//為漢字時,去掉這個截一半的漢字
			if ( bytes[i - 1] != 0 )
				i = i - 1;
			//非漢字時,保留
			else
				i = i + 1;
		}
		//傳回
		return new String(bytes, 0, i, "Unicode");
	}
	
	
	/**
	 * 換行
	 * @param s 待處理字串
	 * @param num 換行位置
	 * @return String 結果
	 * @throws Exception 例外
	 */
	public static String breakLine(String s,int num) throws Exception
	{
		String output = "";
		for ( String tmp : s.split("\\n") )
		{			
			//零長字串
			if ( tmp.length() == 0 )
			{
				output += "\n";
				continue;
			}				
			String newTmp = tmp;
			String subTmp = bSubstring(newTmp,num);
			do 
			{				
				//相同
				if ( newTmp.length() == subTmp.length() )
					break;	
				output += subTmp + "\n";
				newTmp = newTmp.substring(subTmp.length());
				//截取
				subTmp = bSubstring(newTmp,num);
			} while ( subTmp.length() < newTmp.length() );			
			//最後一筆
			if ( subTmp.length() ==  newTmp.length() )
			{
				output += subTmp;
			}	
			//換行
			output += "\n";
		}
		//移除最後一個換行符
		output = output.substring(0, output.length()-1);
		//傳回
		return output; 
	}
	
	
	/**
     * 是否是二次以上變更報備
     * @param conn Connection連結
     * @param companyid 公司別
     * @param tmp 是否查臨時檔
     * @return boolean 是否屬二次變更報備
     */
    public static boolean is2Reload(Connection conn,String companyid,boolean isTemp)
    {    	
    	//已填寫文稿說明變更項目時,不繼續判斷
    	if ( !isSameUpdateProjects(conn,companyid) )
    	{
    		return false;
    	}
    	String tmp = isTemp ? "_t" : "";
    	String sql = "select a.統編  from enterprise"+tmp+" a where a.統編='" 
    		+ StringUtil.toSqlStr(companyid) + "' and a.狀態 in (4,8)"
	    	+ " and exists(select 1 from formal_no b where b.統編=a.統編"
	    	+ " and a.最新報備日期=b.申報日期  and b.申報類別='3')";
    	HashMap hm = Dao.getOneData(conn, sql);
    	//傳回
    	return !hm.isEmpty();    	
    }
    
    
    /**
     * 是否已填寫文稿說明之變更項目
     * @param conn Connection連結
     * @param companyid 公司別
     * @return true:未填寫;false:已填寫
     */
    public static boolean isSameUpdateProjects(Connection conn,String companyid)
    {
    	String sql = "select a.update_project as aupdate,b.update_project as bupdate "
    			+ " from enterprise_t a,enterprise b "
    			+ " where a.統編=b.統編 and a.統編='" + StringUtil.toSqlStr(companyid) + "'";
    	HashMap hm = Dao.getOneData(conn,sql);
    	return StringUtil.toStr(hm.get("aupdate")).equals(StringUtil.toStr(hm.get("bupdate")));    	
    }
}