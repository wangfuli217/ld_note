/**
 * <P> Title: ftc											</P>
 * <P> Description: 取得郵件訊息及發送郵件	       			</P>
 * <P> Copyright: Copyright (c) 2009/12/09					</P>
 * <P> Company:Everunion Tech. Ltd. 						</P>
 * @author jackter
 * @version 0.1 Original Design from design document.
 */ 
package com.everunion.util;

import java.io.*;
import java.sql.Connection;
import java.util.*;

import javax.activation.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.http.HttpServletRequest;

import com.everunion.Memo.MemoDao;
import com.everunion.dao.*;

public class MailContent {
		
	//標題
	private String subject = "";
	//郵件內容
	private String body = "";
	//上傳路徑
	private String attach_path = "";	
	//附檔數量
	private int fileCount = 0;
	//附檔路徑
	private String[] attach_fnm=new String[1];
	//寫入內容
	private String memos = null;
	//是否處在審核關卡
	private boolean isCheck = false;
	//郵件代號
	private int mail_id;
	//HttpServletRequest對象
	private HttpServletRequest request=null;
	
	
	/**
	 * 取得更新內容
	 * @return String 更新內容
	 */
	public String getMemos() 
	{
		return memos;
	}
	

	/**
	 * 建構
	 * @param req HttpServletRequest物件
	 * @param conn Connection連結
	 * @param company_id 公司別
	 * @param mailId 郵件代碼
	 * @throws Exception 例外
	 */
	public MailContent(HttpServletRequest req,Connection conn,String company_id,int mailId) throws Exception
	{
		try
		{
			//郵件代碼
			this.mail_id=mailId;
			//request對象
			this.request = req;
			//取得上傳路徑
			this.attach_path = request.getRealPath("/mail");
			
			//取得參數
			TypeUtil.MemoVars memoVar = TypeUtil.setMemoVars(conn,company_id,false);
			String mStr = "^.*○.*$";	
			TypeUtil.MemoVars default_memo= new TypeUtil.MemoVars();
			//資料錯誤
			if ( memoVar.company_name.matches(mStr)|| memoVar.company_ceo.matches(mStr) 
					|| Arrays.equals(memoVar.audit_date,default_memo.audit_date) 
					|| Arrays.equals(memoVar.start_date,default_memo.start_date) )
			{
				throw new Exception("資料庫(enterprise)錯誤，找不到相關資料！");
			}
			//是否處在審查關卡
			isCheck = ( mail_id == 5 || mail_id==6 || mail_id==7 || mail_id==8 || mail_id==11 || mail_id==12 );
			//報備部份
			if ( !this.isCheck )
			{
				memos = formContent(conn,company_id,memoVar);
			}
			//審核部份
			else
			{
				//取得session
				String ftc_audit_date= (String)request.getSession().getAttribute("FTC_AUDIT_DATE");	
				formContent(conn,company_id,ftc_audit_date,memoVar.company_name);
			}	
		}
		//例外
		catch ( Exception ex )
		{
			System.out.println("MailContent ---err: "+ex.toString());
			ex.printStackTrace();
			throw ex;
		}
	}	
	
	
	/**
	 * 生成郵件內容(報備部份)
	 * @param conn Connection連結
	 * @param company_id 公司別
	 * @param memoVar TypeUtil.MemoVars物件
	 * @return String 內容
	 * @throws Exception 例外
	 */
	private String formContent(Connection conn,String company_id,TypeUtil.MemoVars memoVar) throws Exception
	{
		String tmpPlate = "";
		FileInputStream fi;
		FileOutputStream fo;
		BufferedReader br;
		String line=null;
		String _now = memoVar.mail_date[0] + "年" + memoVar.mail_date[1] 
		           + "月" + memoVar.mail_date[2] + "日";		
		
		//取得文稿說明資料
		String REMARK_LIST=""; 
		String sql="select orderby, remark from ev_contributions  where company_id='" 
			+ company_id + "' order by orderby";		
		List rs = new ArrayList();
		rs = Dao.getData(conn,sql);
		if ( !rs.isEmpty() )
		{
			int base = ( mail_id==3 ? 2 : 0 );
			for ( int rsnum=0; rsnum<rs.size(); rsnum++ )
			{
				HashMap hm = (HashMap)(rs.get(rsnum));
				int orderInt = StringUtil.toInt(hm.get("orderby")) + base;
				//超出限制時不顯示
				if ( orderInt > 10 )
					break;
				String orderStr = MemoDao.selectOrd(orderInt);	
		  
				//說明資料
				REMARK_LIST += "<tr><td valign=\"top\"><font face=\"標楷體\" size=\"4\">" 
					+ orderStr + "、</font></td>" 
					+ "<td ><pre><font face=\"標楷體\" size=\"4\"><SPAN style=\"FONT-FAMILY: 標楷體;" 
					+ " COLOR: black; FONT-SIZE: 13.5pt; mso-bidi-font-size: 12.0pt\">" 
					+ TypeUtil.breakLine(StringUtil.toStr(hm.get("remark")),54) 
					+ "</span></font></pre></td></tr>";		 
			}		  
		}
		//切換
		switch ( mail_id)
		{
			//報備	
			case 1: 				
				//----報備書(附檔)-----------
				tmpPlate=attach_path+"/data_load.html";
				attach_fnm[0]=attach_path+"/"+company_id+"_2.html";
				fi =new FileInputStream(tmpPlate);
				fo =new FileOutputStream(attach_fnm[0], true);
				br = new BufferedReader(new InputStreamReader(fi,"Big5"));
				line=null; 
				while ( (line=br.readLine())!=null ) 
				{
					line=line.replace("$(AUDIT_START_YEAR)",memoVar.start_date[0]);
					line=line.replace("$(AUDIT_START_MONTH)",memoVar.start_date[1]);
					line=line.replace("$(AUDIT_START_DAY)",memoVar.start_date[2]);
					line=line.replace("$(COMPANY_ID)",memoVar.company_id);
					line=line.replace("$(COMPANY_NAME)",memoVar.company_name);
					line=line.replace("$(COMPANY_MONEY)",memoVar.company_money);
					line=line.replace("○年○月○日",_now);      
					line=line.replace("$(COMPANY_ISSUE_DATE)",memoVar.issue_date[0]
					      + "年"+memoVar.issue_date[1]+"月"+memoVar.issue_date[2]+"日");
					line=line.replace("$(COMPANY_CEO)",memoVar.company_ceo);
					line=line.replace("$(AUDIT_DATE)",memoVar.audit_date[0]
					      + "年"+memoVar.audit_date[1]+"月"+memoVar.audit_date[2]+"日");
					fo.write(line.getBytes("big5"));
				}
				br.close(); 
				fi.close();
				fo.close(); 
				//正文
				tmpPlate=attach_path+"/first_load.html";
				this.subject="多層次傳銷資料報備";
				this.body="敬啟者：檢送多層次資料報備函，請查照！";
				this.fileCount=1;
			break;
			//報備補正
			case 2:
				//正文
				tmpPlate=attach_path+"/reload.html";			
				this.subject="多層次傳銷資料報備補正";
				this.body="敬啟者：檢送多層次資料報備補正函，請查照！";
			break;
			//變更報備
			case 3:
				//正文
				tmpPlate=attach_path+"/update.html";			    
			    this.subject="多層次傳銷資料變更報備";
				this.body="敬啟者：檢送多層次資料變更報備函，請查照！";			
			break;
			//變更報備補正
			case 4:
				//正文
				tmpPlate=attach_path+"/reupdate.html";			
				this.subject="多層次傳銷資料變更報備補正";
				this.body="敬啟者：檢送多層次資料變更報備補正函，請查照！";
			break;
			//補登報備
			case 9:
				//----補登書(附檔)-----------
				tmpPlate=attach_path+"/data_repair.html";
			 	attach_fnm[0]=attach_path+"/"+company_id+"_2.html";
				fi =new FileInputStream(tmpPlate);
			 	fo =new FileOutputStream(attach_fnm[0], true);
			  	br = new BufferedReader(new InputStreamReader(fi,"Big5"));
			 	line=null; 
				while ( (line=br.readLine())!=null ) 
			 	{
					line=line.replace("$(AUDIT_START_YEAR)",memoVar.start_date[0]);
					line=line.replace("$(AUDIT_START_MONTH)",memoVar.start_date[1]);
			     	line=line.replace("$(AUDIT_START_DAY)",memoVar.start_date[2]);
			      	line=line.replace("$(COMPANY_ID)",company_id);
			      	line=line.replace("$(COMPANY_NAME)",memoVar.company_name);
			      	line=line.replace("$(COMPANY_MONEY)",memoVar.company_money);			      	 
					line=line.replace("$(COMPANY_ISSUE_DATE)",memoVar.issue_date[0]+
						"年"+memoVar.issue_date[1]+"月"+memoVar.issue_date[2]+"日");
			       	line=line.replace("$(COMPANY_CEO)",memoVar.company_ceo);
			       	line=line.replace("$(AUDIT_DATE)",memoVar.audit_date[0]+
			       		"年"+memoVar.audit_date[1]+"月"+memoVar.audit_date[2]+"日");
			      	fo.write(line.getBytes("big5"));
			 	}
			   	br.close(); 
			   	fi.close();
			  	fo.close(); 

				//正文
			  	tmpPlate=attach_path+"/first_repair.html";
			  	this.subject="多層次傳銷資料補登";
				this.body="敬啟者：檢送多層次資料補登函，請查照！";
			    this.fileCount=1;			      
			break;
			//補登補正
			case 10:
				tmpPlate=attach_path+"/repair.html";		 	
			  	this.subject="多層次傳銷資料補登補正";
				this.body="敬啟者：檢送多層次資料補登補正函，請查照！";
			break;
			//錯誤
			default: 
				throw new Exception("郵件編號錯誤，無法獲取郵件發文內容！");
		}		
	    
		/***********取得郵件正文****************/
	 	fi =new FileInputStream(tmpPlate);
	 	br = new BufferedReader(new InputStreamReader(fi,"Big5"));
	  	line=null; 
	  	String Body = "";	  	
	  	//逐行讀取
	  	while ( (line=br.readLine())!=null ) 
	  	{
	  		line=line.replace("$(COMPANY_NAME)",memoVar.company_name);
	    	line=line.replace("$(AUDIT_YEAR)",memoVar.audit_date[0]);
	    	line=line.replace("$(AUDIT_MONTH)",memoVar.audit_date[1]);
	     	line=line.replace("$(AUDIT_DAY)",memoVar.audit_date[2]);
	     	line=line.replace("$(AUDIT_START_YEAR)",memoVar.start_date[0]);
	     	line=line.replace("$(AUDIT_START_MONTH)",memoVar.start_date[1]);
	      	line=line.replace("$(AUDIT_START_DAY)",memoVar.start_date[2]);
			line=line.replace("$(REMARK_LIST)",REMARK_LIST);
	    	line=line.replace("$(COMPANY_CEO)",memoVar.company_ceo);
			line=line.replace("○年○月○日",_now);
			//變更報備時
			if ( mail_id==3 )
			{
				line=line.replace("$(CHANG_DATE)",memoVar.change_date);
				//有變更的項目列表
				String update_project = StringUtil.toStr(CompareChange.getChangeItems(conn,company_id,false));
				//checkBox是否選中
				String[] repStr = {"1","2","4","5","6","7","A"};
				for ( String str : repStr )
				{
					line=line.replace("$(P"+str+")",update_project.indexOf(str)>-1 ? "checked" : "");		 
				}				
			}
			Body += line;
	   	}
	  	br.close(); 
	  	fi.close();
	   	/***************************/
	  	
	  	String re_memo = Body;
	  	
	  	this.body = "";
	  	this.body += Body;	 	
		//傳回文稿說明
		return re_memo;	
	}	
	
	
	/**
	 * 生成郵件內容(審核部份)
	 * @param conn Connection連結
	 * @param company_id 公司別
	 * @param ftc_audit_date 申報日期
	 * @param company_name 公司名稱
	 * @throws Exception 例外
	 */
	private void formContent(Connection conn,String company_id,String ftc_audit_date,String company_name) throws Exception
	{
		String Body = "";
		String sql = null;
		HashMap hm = new HashMap();
		String[] law_id= new String[]{"",""};
		
		//若為初次報備，則由 enterprise 讀取 收文號，否則由 formal_no 讀取 收文號   
		//報備審查
		if ( mail_id==5 )  
		{
			sql="select * from enterprise where 統編='"+company_id+"'";
			hm = Dao.getOneData(conn,sql);
			if ( !hm.isEmpty() )
			{
				law_id[0]=StringUtil.toStr(hm.get("總收文號一")); 
				law_id[1]=StringUtil.toStr(hm.get("總收文號二")); 
			}
		}
		//其他審查
		else
		{
			sql="select * from formal_no where 統編='"+company_id+"' and 申報日期='"+ ftc_audit_date+"'" ;
			hm = Dao.getOneData(conn,sql);
			if ( !hm.isEmpty() )
			{
				law_id[0]=StringUtil.toStr(hm.get("收文號一")); 
				law_id[1]=StringUtil.toStr(hm.get("收文號二")); 
			}
		}
		String text = "";
		int auditNum=0;
		switch ( mail_id )
		{
			//報備審查	
			case 5:
				auditNum=1;
				text = "報備";			
			break;
			//報備補正審查
			case 6:
				auditNum=2;
				text = "報備補正";
			break;
			//變更報備審查
			case 7:
				auditNum=3;
				text = "變更報備";
			break;
			//變更報備補正審查
			case 8:
				auditNum=4;
				text = "變更報備補正";
			break;
			//補登審查
			case 11:
				auditNum=5;			  
				text = "補登";
			break;
			//補登補正審查
			case 12:
				auditNum=6;			 
				text = "補登補正";
			break;	
			//錯誤
			default: 
				throw new Exception("郵件編號錯誤，無法獲取郵件發文內容！");
		}
		//取得文稿內容
		sql="select * from audit_log where 統編='" + company_id 
			+ "' and 申報類別='" + auditNum + "' and 申報日期='"+ftc_audit_date+"' and 承辦狀態='6'";		
		List rs = Dao.getData(conn,sql);
		if ( !rs.isEmpty() )
		{
			hm = (HashMap)(rs.get(rs.size()-1));
			Body = StringUtil.toStr(hm.get("文稿內容"),"");
		}
		
		this.subject = "多層次傳銷資料" + text + "審核(" + company_name + ")(本會編號：" + law_id[0] + "-" + law_id[1] + ")";
		//this.body="敬啟者：檢送多層次資料" + text + "審核結果，請查照！";		
		this.body = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=big5'></head><body><pre>";
		this.body += Body;
		this.body += "</pre></body></html>";
	}
	
	
	/**
	 * 更新
	 * @param conn Connection連結
	 * @param company_id 公司別
	 * @param re_memo 更新內容
	 * @throws Exception 例外
	 */
	public void updateAudit(Connection conn,String company_id,String re_memo) throws Exception
	{
		if ( !re_memo.trim().equals("") )
		{
			//替換html標籤
			//re_memo = StringUtil.removeHTMLTag(re_memo);
			Dao.execute(conn,
				"update audit set re_memo='" + StringUtil.toSqlStr(re_memo) + "' where 統編='"+company_id+"'");
		}
	}
	
	
	/**
	 * 刪除檔案
	 * @param filename 檔案名
	 */
	private void delFile(String filename)
	{
	   try
	   {
			//檔案名不為空
		   if ( filename != null && !filename.equals("") )
		   {
				File file=new File(filename);
				//存在
				if ( file.exists()&&file.isFile() )
				{ 
					file.delete(); 
				}		
			}		
	   }
	   //例外
	   catch ( Exception eex )
	   {		   
	   }
	   finally
	   {		   
	   }	   
	}
	
		
	/**
	 * 發送email
	 * @return String 操作結果訊息
	 */
	public String sendMail()
	{
		String mess = "";
		//代碼錯誤
		if ( mail_id<=0 || mail_id >12 )
		{
			mess = "錯誤的郵件代碼！";
			return mess;					
		}
		try
		{
			String Recipient = "";
			Properties p = new Properties();
			//取得郵件配置參數
			p.load(request.getSession().getServletContext().getResourceAsStream("/config.properties"));
			HashMap hm = new HashMap();
			//取得參數
			hm.put("MailServer", p.getProperty("mail_host"));
			hm.put("MailAccount", p.getProperty("mail_account"));
			hm.put("MailPassword", p.getProperty("mail_password"));
			hm.put("SenderEmail", p.getProperty("mail_sender"));
			hm.put("Email_FTC",p.getProperty("mail_ftc")); 
			hm.put("strBcc", p.getProperty("mail_Bcc"));
			hm.put("Email_3d",p.getProperty("mail_3d"));
			
			//加載
			Class.forName(p.getProperty("dbclass")).newInstance();
			
			Properties props = System.getProperties();
			props.put("mail.smtp.host", hm.get("MailServer"));
			props.put("mail.transport.protocol", "smtp");
			//開啟驗證
			props.put("mail.smtp.auth", "true");
			//驗證
			EmailAuthenticator _auth = new EmailAuthenticator(StringUtil.toStr(hm.get("MailAccount")),
			StringUtil.toStr(hm.get("MailPassword")));
			javax.mail.Session _mailSession = javax.mail.Session.getDefaultInstance(props,_auth);
			//是否調試
			_mailSession.setDebug(false);
			
			MimeMessage message = new MimeMessage(_mailSession);
			InternetAddress from = new InternetAddress(StringUtil.toStr(hm.get("SenderEmail")));
			 
			message.setFrom(from);
			//message.setRecipients(Message.RecipientType.TO, Recipient);		 
			
			//報備
			if( !this.isCheck )
			{ 
				message.setRecipients(Message.RecipientType.TO, StringUtil.toStr(hm.get("Email_FTC")));
				//附送
				if ( !StringUtil.toStr(hm.get("Email_FTC")).equals(StringUtil.toStr(hm.get("Email_User"))) )
				{
					message.setRecipients(Message.RecipientType.CC, StringUtil.toStr(hm.get("Email_User")));
				}
				//暗送
				if ( StringUtil.toStr(hm.get("strBcc"))!="" 
						&& StringUtil.toStr(hm.get("strBcc")).equals(StringUtil.toStr(hm.get("Email_FTC"))) 
						&& StringUtil.toStr(hm.get("strBcc")).equals(StringUtil.toStr(hm.get("Email_User"))) )
				{
					message.setRecipients(Message.RecipientType.BCC, StringUtil.toStr(hm.get("strBcc")));	
				}				
			}
			//審核
			else
			{
				message.setRecipients(Message.RecipientType.TO, StringUtil.toStr(hm.get("Email_User")));
				if ( !StringUtil.toStr(hm.get("Email_User")).equals(StringUtil.toStr(hm.get("Email_3d"))) )
				{
					message.setRecipients(Message.RecipientType.CC, StringUtil.toStr(hm.get("Email_3d")));	
				}			
				if ( StringUtil.toStr(hm.get("strBcc"))!="" 
						&& StringUtil.toStr(hm.get("strBcc")).equals(StringUtil.toStr(hm.get("Email_3d"))) 
						&& StringUtil.toStr(hm.get("strBcc")).equals(StringUtil.toStr(hm.get("Email_User"))) )
				{
					message.setRecipients(Message.RecipientType.BCC, StringUtil.toStr(hm.get("strBcc")));	
				}							
			}
			 
			//標頭
			MimeBodyPart messageBodyPart = new MimeBodyPart();
			messageBodyPart.setContent(this.body, "text/html;charset=big5");
			
			Multipart multipart = new MimeMultipart();
			multipart.addBodyPart(messageBodyPart);
			 
			//報備及補正時,添加附件
			if ( mail_id==1 || mail_id==9 ) 
			{
				//取得時間戳
				Calendar now = Calendar.getInstance();
				long ndate = now.get(Calendar.YEAR)*10000+(now.get(Calendar.MONTH)+1)*100+
				now.get(Calendar.DAY_OF_MONTH);
				long ntime = now.get(Calendar.HOUR_OF_DAY)*10000+now.get(Calendar.MINUTE)*100+
				now.get(Calendar.SECOND);
				String getDateTimeStrWithT=String.valueOf(ndate)+"T"+ String.valueOf(ntime);
				//加入附件
				BodyPart messageBodyPart1 = new MimeBodyPart();
				DataSource source1 = new FileDataSource(attach_fnm[0]);
				messageBodyPart1.setDataHandler(new DataHandler(source1));
				//設定附檔名
				messageBodyPart1.setFileName(
						MimeUtility.encodeWord((mail_id==1?"多層次傳銷報備書_":"多層次傳銷補登報備書_")
								+ getDateTimeStrWithT+".htm","big5", "B"));
				messageBodyPart1.setHeader("Content-Type", "text/html;charset=big5");
				//messageBodyPart1.setHeader("Content-Transfer-Encoding", "base64");
				multipart.addBodyPart(messageBodyPart1); 
			}     
			 
			//主題
			message.setSubject(MimeUtility.encodeWord(subject,"big5", "B"));
			message.setHeader("X-Mailer", "smtpsend");
			//正文
			message.setContent(multipart);
			//發送日期
			message.setSentDate(new java.util.Date());
			//儲存
			message.saveChanges();
			//伺服器
			Transport _trans = _mailSession.getTransport("smtp");
			//連結
			_trans.connect(StringUtil.toStr(hm.get("MailServer")), 
					StringUtil.toStr(hm.get("MailAccount")),StringUtil.toStr(hm.get("MailPassword")) );
			//發送
			_trans.send(message);
			System.out.println("成功發送一條消息" + System.currentTimeMillis());
			//提示訊息
			mess = !this.isCheck ? "請由 貴公司電子信箱接收相關信息，謝謝！" : "審核郵件寄送成功！";
		} 
		//例外(如果郵件發送失敗時需要回滾,請將此處exception拋出)
		catch ( Exception e ) 
		{  
			mess = "郵件發送失敗！\n1.可能是由於伺服器連結中斷！2.請洽系統管理員！";
			System.out.println("MailContent.sendMail --err:"+e.toString());
			e.printStackTrace();			
			//throw e;
		}
		//刪除附檔
		finally
		{
			// 寄信完成，刪除檔案
			for ( int i=0; i<fileCount; i++ )
			{
				delFile(attach_fnm[i]);
			}
		}
		//返回操作訊息
		return mess;
	}
	
	
	/**
	 * 郵件驗證內部類
	 */
	protected class EmailAuthenticator extends Authenticator 
	{
		//用戶名
		private String strUser;   
	    //密碼
		private String strPwd;
		
		
	    /**
	     * 建構
	     * @param user 用戶名
	     * @param password 密碼
	     */
		public EmailAuthenticator(String user, String password)   
	    {   
			this.strUser = user;   
			this.strPwd = password;   
	    } 
		
		
	    /**
	     * 驗證
	     * @return PasswordAuthentication
	     */
		protected PasswordAuthentication getPasswordAuthentication()   
	    {   
			return new PasswordAuthentication(strUser, strPwd);   
	    }   
	}	
}