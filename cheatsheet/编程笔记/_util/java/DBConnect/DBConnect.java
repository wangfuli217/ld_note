/** 
 * <P> Title: 數據庫庫接池                              </P>
 * <P> Description: 數據庫庫接池              			</P>
 * <P> Copyright:Copyright (c) 2006/03/23               </p>
 * <P> Company: EverUnion Tech.                         </p>
 */ 
package com.everunion.util; 

import javax.naming.*; 
import java.sql.*;
import javax.sql.*;
import java.util.*; 
import org.apache.commons.dbcp.BasicDataSource;
import javax.servlet.http.HttpServletRequest; 

/** 
 * 數據庫庫接池
 * @author <a href='mailto:kevindeng@gmail.com'>kevin</a>
 */
public class DBConnect
{
    /**
     * DataSource
     */
    private static DataSource dataSource = null;
    
    /**
     * 構造函數
     */
    public DBConnect(){}
    
    /**
	 *	獲得一個連接
	 *	@param request request物件,用來檢查一個畫面是否有獲得多個連接
	 *  @return 返回一個連接
	 */
	public static Connection getConn(HttpServletRequest request) throws Exception
	{
	    Connection conn = null;  
	    try
	    { 
    		if ( dataSource == null ) 
            {
                setupDataSource();
            }  
            conn = dataSource.getConnection();
        }
    	catch ( Exception e ) 
    	{
    	    System.out.println("DBConnect.getConn:" + e.toString()); 
            throw e;     
    	}
    	return conn;        //返回連接
	}
	
	/**
	 *	獲得一個連接, 一般用在沒有request的地方,如多線程
	 *  @return 返回一個連接
	 */
	public static Connection getConn() throws Exception
	{
	    Connection conn = null;  
	    try
	    { 
    		if ( dataSource == null ) 
            {
                setupDataSource(); 
            }  
            conn = dataSource.getConnection();
        }
    	catch ( Exception e ) 
    	{
    	    System.out.println("DBConnect.getConn:" + e.toString()); 
            throw e;     
    	}
    	return conn;        //返回連接
	}

    /**
	 *	關閉連接.
	 *	@param conn 數據庫連接 
	 *	@param request request物件,用來檢查一個畫面是否有獲得多個連接
	 */
	public static void  freeConn(Connection conn, HttpServletRequest request) 
	{   
	    try 
	    { 
    		if ( conn != null ) //不為null時
    		{     
    		    conn.commit();
    			conn.close(); 
    			conn = null; 
    		}		
    	}
    	catch ( Exception e ) 
    	{
    	    System.out.println("DBConnect.freeConn:" + e.toString()); 
    	} 
	}
	
	/**
	 *	關閉連接.
	 *	@param conn 數據庫連接
	 */
	public static void  freeConn(Connection conn) 
	{   
	    try 
	    { 
    		if ( conn != null ) //不為null時
    		{     
    		    conn.commit();
    			conn.close(); 
    			conn = null; 
    		}		
    	}
    	catch ( Exception e ) 
    	{
    	    System.out.println("DBConnect.freeConn:" + e.toString()); 
    	} 
	}
	
	/**
	 *	關閉Statement.
	 *	@param stmt 數據庫Statement
	 */
	public static void  close(Statement stmt) 
	{   
	    try 
	    { 
    		if ( stmt != null ) //不為null時
    		{
    			stmt.close(); 
    			stmt = null; 
    		}		
    	}
    	catch ( Exception e ) 
    	{
    	    System.out.println("DBConnect.close:" + e.toString()); 
    	} 
	}
	
	/**
	 *	關閉ResultSet.
	 *	@param rs 數據庫ResultSet
	 */
	public static void close(ResultSet rs) 
	{   
	    try 
	    { 
    		if ( rs != null ) //不為null時
    		{
    			rs.close(); 
    			rs = null; 
    		}		
    	}
    	catch ( Exception e ) 
    	{
    	    System.out.println("DBConnect.close:" + e.toString()); 
    	} 
	}
	
    private synchronized static void setupDataSource() throws Exception
    {
        try 
		{
		    if ( dataSource == null )
		    {
				//讀取 server.xml 的設定訊息(方法一)
				InitialContext ctx = new InitialContext();
				dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/ftcpool");
				/*
				 <Resource name="jdbc/ftcpool" auth="Container" type="javax.sql.DataSource"
						   maxActive="100" maxIdle="30" maxWait="10000"
						   username="root" password="root" driverClassName="com.mysql.jdbc.Driver"
						   url="jdbc:mysql://127.0.0.1:3306/ftc?characterEncoding=UTF-8&amp;characterSetResults=UTF-8&amp;zeroDateTimeBehavior=convertToNull"/>
				*/

				//方法二
				// 讀取工程下 \WebRoot\WEB-INF\classes\database.properties 的配置信息
    		    ResourceBundle actionDB = ResourceBundle.getBundle("database"); 
    		    String DriverClassName = actionDB.getString("DriverClassName");
                String DBUrl = actionDB.getString("DBUrl");   
                String Username = actionDB.getString("Username"); 
                String Password = actionDB.getString("Password");   
                
				/*
				 * 配置檔內容如下：
				 * #sqlserver 2005
				 * DriverClassName=com.inet.tds.TdsDriver
				 * DBUrl=jdbc:inetdae:192.168.1.129:1433?database=jinjin&sql7=true&charset=big5
				 * Username=everunion
				 * Password=everunion
				 * MaxWait=3000
				 * MaxIdle=10
				 * MaxActive=100
				 */
                String MaxWaitStr = actionDB.getString("MaxWait");
                if(MaxWaitStr == null) MaxWaitStr = "3000";
                long MaxWait = (new Long(MaxWaitStr)).longValue();
                
                String MaxIdleStr = actionDB.getString("MaxIdle");
                if(MaxIdleStr == null) MaxIdleStr = "10";
                int MaxIdle = (new Integer(MaxIdleStr)).intValue();
                
                String MaxActiveStr = actionDB.getString("MaxActive");
                if(MaxActiveStr == null) MaxActiveStr = "100";
                int MaxActive = (new Integer(MaxActiveStr)).intValue();
                
                BasicDataSource bds = new BasicDataSource(); 
                bds.setDriverClassName(DriverClassName);
                bds.setUrl(DBUrl);
                bds.setUsername(Username);
                bds.setPassword(Password);                
                bds.setMaxWait(MaxWait);
                bds.setMaxIdle(MaxIdle);
                bds.setMinIdle(2);
                bds.setMaxActive(MaxActive);
                bds.setRemoveAbandoned(true);
                bds.setLogAbandoned(true);
                bds.setRemoveAbandonedTimeout(180);
                dataSource = bds;
            }
        }
		catch ( Exception e )   //拋出例外 
		{ 
			dataSource = null;
		    System.out.println("DBConnect.setupDataSource:" + e.toString()); 
		    throw e;
		} 		
    }

}
