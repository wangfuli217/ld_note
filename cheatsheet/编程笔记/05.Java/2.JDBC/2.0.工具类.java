// ******************************* DbUtil.java *************************************
/**
 * <P> Title: 公用類別                                      </P>
 * <P> Description: 資料庫操作工具                          </P>
 * <P> Copyright: Copyright (c) 2010/07/31                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */

package com.everunion.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.ResourceBundle;

import javax.sql.DataSource;
import org.apache.commons.dbcp.BasicDataSource;


/**
 * 資料庫操作工具
 * @author Holer W. L. Feng
 * @version 0.1
 */
public final class DbUtil
{
    /**
     * Connection Pool
     */
    private static DataSource dataSource = null;


    /**
     * 取得 Connection Pool
     * @throws Exception 例外
     */
    private synchronized static void setupDataSource() throws Exception
    {
        try
        {
            if ( dataSource == null )
            {
                // 讀取配置檔(位於: 項目/WEB-INF/classes/database.properties)
                ResourceBundle actionDB = ResourceBundle.getBundle("database");
                // 取得對應的屬性值
                String driverName = actionDB.getString("DriverName");
                String DBUrl = actionDB.getString("DBUrl");
                String Username = actionDB.getString("Username");
                String Password = actionDB.getString("Password");

                // 最大等待時間
                String MaxWaitStr = actionDB.getString("MaxWait");
                if ( MaxWaitStr == null || "".equals(MaxWaitStr) )
                    MaxWaitStr = "3000";
                long MaxWait = (new Long(MaxWaitStr)).longValue();

                String MaxIdleStr = actionDB.getString("MaxIdle");
                if ( MaxIdleStr == null || "".equals(MaxIdleStr) )
                    MaxIdleStr = "10";
                int MaxIdle = (new Integer(MaxIdleStr)).intValue();

                String MaxActiveStr = actionDB.getString("MaxActive");
                if ( MaxActiveStr == null || "".equals(MaxActiveStr) )
                    MaxActiveStr = "100";
                int MaxActive = (new Integer(MaxActiveStr)).intValue();

                // 建立 Connection Pool
                BasicDataSource bds = new BasicDataSource();
                bds.setDriverClassName(driverName);
                bds.setUrl(DBUrl);
                bds.setUsername(Username);
                bds.setPassword(Password);
                bds.setMaxWait(MaxWait);
                bds.setMaxIdle(MaxIdle);
                bds.setMinIdle(2);
                bds.setMaxActive(MaxActive);
                dataSource = bds;
            }
        }
        // 拋出例外
        catch ( Exception e )
        {
            dataSource = null;
            System.out.println("DbUtil.setupDataSource:" + e.toString());
            throw e;
        }
    }


    /**
     * 取得 資料庫連結
     * @return 資料庫連結
     * @throws Exception 資料庫開啟連結例外
     */
    public static Connection getConn() throws Exception
    {
        Connection conn = null;
        try
        {
            if ( dataSource == null )
            {
                //取得Connection Pool
                setupDataSource();
            }
            //取得資料庫連結
            conn = dataSource.getConnection();
        }
        //拋出例外
        catch ( Exception e )
        {
            System.out.println("DbUtil.getConn:" + e.toString());
            throw e;
        }
        return conn;
    }


    /**
     * 取得資料庫連結
     * @param driverName 資料庫驅動名
     * @param url 資料庫連結地址
     * @param username 資料庫登錄名
     * @param password 資料庫登錄密碼
     * @return Connection 資料庫連結
     * @throws Exception 資料庫開啟連結例外
     */
    public static Connection getConn(String driverName, String url, String username,
            String password) throws Exception
    {
        Connection conn = null;
        //取得連結
        try
        {
            Class.forName(driverName);
            conn = DriverManager.getConnection(url, username, password);
        }
        // 拋出例外
        catch ( Exception e )
        {
            System.out.println("DbUtil.getConn:" + e.toString());
            throw e;
        }
        return conn;
    }


    /**
     * 還原處理
     * @param conn
     */
    public static void rollback(Connection conn)
    {
        try
        {
            if ( conn != null )
            {
                conn.rollback();
            }
        }
        catch ( Exception e )
        {
            System.out.println("DbUtil.rollback:" + e.toString());
        }
    }


    /**
     * 關閉資料庫連結
     * @param conn 資料庫連結
     */
    public static void close(Connection conn)
    {
        try
        {
            if ( conn != null )
            {
                // conn.commit();
                conn.close();
                conn = null;
            }
        }
        catch ( Exception e )
        {
            System.out.println("DbUtil.close:" + e.toString());
        }
    }


    /**
     * 關閉資料庫操作連結
     * @param statement 資料庫操作連結
     */
    public static void close(Statement statement)
    {
        try
        {
            if ( statement != null )
            {
                statement.close();
                statement = null;
            }
        }
        catch ( Exception e )
        {
            System.out.println("DbUtil.close:" + e.toString());
        }
    }


    /**
     * 關閉結果集連結
     * @param resultSet 結果集連結
     */
    public static void close(ResultSet resultSet)
    {
        try
        {
            if ( resultSet != null )
            {
                resultSet.close();
                resultSet = null;
            }
        }
        catch ( Exception e )
        {
            System.out.println("DbUtil.close:" + e.toString());
        }
    }


    /**
     * 關閉連結
     * @param conn 資料庫連結
     * @param stmt 資料庫操作連結
     * @param resultSet 結果集連結
     */
    public static void close(Connection conn, Statement stmt, ResultSet resultSet)
    {
        close(resultSet);
        close(stmt);
        close(conn);
    }


    /**
     * 取得資料
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @param valueList 查詢的SQL的參數資料集
     * @return ArrayList 資料集,查不到資料時傳回size為0的ArrayList
     * @throws SQLException 資料庫操作例外
     */
    public static ArrayList<HashMap<String,String>> getData( Connection conn,
            String sql, List<Object> valueList ) throws SQLException
    {
        ArrayList<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
        //資料庫資源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        try
        {
            //操作資料庫
            pstmt = conn.prepareStatement(sql);
            //如果需要傳參數
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsMetaData = rs.getMetaData();
            int col = rsMetaData.getColumnCount();
            //加入資料
            while ( rs.next() )
            {
                HashMap<String,String> map = new LinkedHashMap<String,String>();
                for ( int i = 1; i <= col; i ++ )
                {
                    map.put(rsMetaData.getColumnLabel(i).toLowerCase(), rs.getString(i));
                }
                list.add(map);
            }
        }
        catch ( SQLException e )
        {
            //輸出例外
            System.out.println("DbUtil.getData: " + e.toString());
            System.out.println("DbUtil.getData.sql: " + sql);
            throw e;
        }
        //關閉連結
        finally
        {
            close( rs );
            close( pstmt );
        }
        return list;
    }


    /**
     * 取得資料
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @return ArrayList 資料集,查不到資料時傳回size為0的ArrayList
     * @throws SQLException 資料庫操作例外
     */
    public static ArrayList<HashMap<String,String>> getData( Connection conn,
            String sql ) throws SQLException
    {
        return getData( conn, sql, null );
    }


    /**
     * 取得資料
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param sql 查詢的SQL
     * @param valueList 查詢的SQL的參數資料集
     * @return ArrayList 資料集,查不到資料時傳回size為0的ArrayList; 發生資料例外時傳回 null
     */
    public static ArrayList<HashMap<String,String>> getData( String sql, List<Object> valueList )
    {
        Connection conn = null;
        try
        {
            conn = getConn();
            return getData(conn, sql, valueList);
        }
        //發生資料例外時傳回 null
        catch ( Exception e )
        {
            return null;
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 取得資料
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param sql 查詢的SQL
     * @return ArrayList 資料集,查不到資料時傳回size為0的ArrayList; 發生資料例外時傳回 null
     */
    public static ArrayList<HashMap<String,String>> getData( String sql )
    {
        return getData(sql, null);
    }


    /**
     * 取得資料，number 從1開始
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @param valueList 查詢的SQL的參數資料集
     * @return ArrayList 資料集,查不到資料時傳回size為0的ArrayList
     * @throws SQLException 資料庫操作例外
     */
    public static ArrayList<HashMap<String,String>> getDataByNum( Connection conn,
            String sql, List<Object> valueList ) throws SQLException
    {
        ArrayList<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
        //資料庫資源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        try
        {
            //操作資料庫
            pstmt = conn.prepareStatement(sql);
            //如果需要傳參數
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsMetaData = rs.getMetaData();
            int col = rsMetaData.getColumnCount();
            //加入資料
            while ( rs.next() )
            {
                HashMap<String,String> map = new LinkedHashMap<String,String>();
                for ( int i = 1; i <= col; i ++ )
                {
                    map.put("" + i, rs.getString(i));
                }
                list.add(map);
            }
        }
        catch ( SQLException e )
        {
            //輸出例外
            System.out.println("DbUtil.getDataByNum: " + e.toString());
            System.out.println("DbUtil.getDataByNum.sql: " + sql);
            throw e;
        }
        //關閉連結
        finally
        {
            close( rs );
            close( pstmt );
        }
        return list;
    }


    /**
     * 取得資料，number 從1開始
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @return ArrayList 資料集,查不到資料時傳回size為0的ArrayList
     * @throws SQLException 資料庫操作例外
     */
    public static ArrayList<HashMap<String,String>> getDataByNum( Connection conn, String sql )
        throws SQLException
    {
        return getDataByNum( conn, sql, null );
    }


    /**
     * 取得資料，number 從1開始
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param sql 查詢的SQL
     * @param valueList 查詢的SQL的參數資料集
     * @return ArrayList 資料集,查不到資料時傳回size為0的ArrayList; 發生資料例外時傳回 null
     */
    public static ArrayList<HashMap<String,String>> getDataByNum( String sql, List<Object> valueList )
    {
        Connection conn = null;
        try
        {
            conn = getConn();
            return getDataByNum(conn, sql, valueList);
        }
        //發生資料例外時傳回 null
        catch ( Exception e )
        {
            return null;
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 取得資料，number 從1開始
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param sql 查詢的SQL
     * @return ArrayList 資料集,查不到資料時傳回size為0的ArrayList; 發生資料例外時傳回 null
     */
    public static ArrayList<HashMap<String,String>> getDataByNum( String sql )
    {
        return getDataByNum( sql, null);
    }


    /**
     * 取得一筆資料
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @param valueList 查詢的SQL的參數資料集
     * @return HashMap 資料集,查不到資料時傳回size為0的HashMap
     * @throws SQLException 資料庫操作例外
     */
    public static HashMap<String,String> getOneData( Connection conn,
            String sql, List<Object> valueList ) throws SQLException
    {
        //資料庫資源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        HashMap<String,String> map = new LinkedHashMap<String,String>();
        try
        {
            //操作資料庫
            pstmt = conn.prepareStatement(sql);
            //如果需要傳參數
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsMetaData = rs.getMetaData();
            int col = rsMetaData.getColumnCount();
            //加入資料
            if ( rs.next() )
            {
                for ( int i = 1; i <= col; i++ )
                {
                    map.put(rsMetaData.getColumnLabel(i).toLowerCase(), rs.getString(i));
                }
            }
        }
        catch ( SQLException e )
        {
            //輸出例外
            System.out.println("DbUtil.getOneData: " + e.toString());
            System.out.println("DbUtil.getOneData.sql: " + sql);
            throw e;
        }
        //關閉連結
        finally
        {
            close( rs );
            close( pstmt );
        }
        return map;
    }


    /**
     * 取得一筆資料
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @return HashMap 資料集,查不到資料時傳回size為0的HashMap; 發生資料例外時傳回 null
     * @throws SQLException 資料庫操作例外
     */
    public static HashMap<String,String> getOneData( Connection conn, String sql )
        throws SQLException
    {
        return getOneData( conn, sql, null );
    }


    /**
     * 取得一筆資料
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param sql 查詢的SQL
     * @param valueList 查詢的SQL的參數資料集
     * @return HashMap 資料集,查不到資料時傳回size為0的HashMap; 發生資料例外時傳回 null
     */
    public static HashMap<String,String> getOneData( String sql, List<Object> valueList )
    {
        Connection conn = null;
        try
        {
            conn = getConn();
            return getOneData(conn, sql, valueList);
        }
        //發生資料例外時傳回 null
        catch ( Exception e )
        {
            return null;
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 取得一筆資料
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param sql 查詢的SQL
     * @return HashMap 資料集,查不到資料時傳回size為0的HashMap; 發生資料例外時傳回 null
     */
    public static HashMap<String,String> getOneData( String sql )
    {
        return getOneData( sql, null);
    }


    /**
     * 查詢一個欄位
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @param valueList 查詢的SQL的參數資料集
     * @return String 結果；查無資料，以及資料為 null 時，傳回 null
     * @throws SQLException 資料庫操作例外
     */
    public static String queryOne(Connection conn, String sql, List<Object> valueList )
        throws SQLException
    {
        //資料庫資源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        try
        {
            //操作資料庫
            pstmt = conn.prepareStatement(sql);
            //如果需要傳參數
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            // 只查詢一個欄位
            if ( rs.next() )
                return rs.getString(1);
        }
        catch ( SQLException e )
        {
            //輸出例外
            System.out.println("DbUtil.queryOne: " + e.toString());
            System.out.println("DbUtil.queryOne.sql: " + sql);
            throw e;
        }
        //關閉連結
        finally
        {
            close( rs );
            close( pstmt );
        }
        // 查不到內容時，傳回null
        return null;
    }


    /**
     * 查詢一個欄位
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @return String 結果； 查無資料，以及資料為 null 時，傳回 null
     * @throws SQLException 資料庫操作例外
     */
    public static String queryOne(Connection conn, String sql) throws SQLException
    {
        return queryOne(conn, sql, null);
    }


    /**
     * 查詢一個欄位
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @param valueList 查詢的SQL的參數資料集
     * @return String 結果；查無資料，以及資料為 null 時，傳回 null
     * @throws NullPointerException 資料庫操作例外,可以不 catch
     */
    public static String queryOne( String sql, List<Object> valueList )
    {
        Connection conn = null;
        try
        {
            conn = getConn();
            return queryOne(conn, sql, valueList);
        }
        //發生資料例外時,拋出例外,但可以不捕獲
        catch ( Exception e )
        {
            throw new RuntimeException("DbUtil.queryOne: 資料庫操作例外!");
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 查詢一個欄位
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @return String 結果；查無資料，以及資料為 null 時，傳回 null
     * @throws NullPointerException 資料庫操作例外,可以不 catch
     */
    public static String queryOne(String sql)
    {
        return queryOne( sql, null );
    }


    /**
     * 取得資料, 要求每筆資料只有兩個欄位
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @param valueList 查詢的SQL的參數資料集
     * @return HashMap 資料集，查不到資料時傳回size為0的HashMap
     * @throws SQLException 資料庫操作例外
     */
    public static HashMap<String,String> getMap ( Connection conn,
            String sql, List<Object> valueList ) throws SQLException
    {
        //資料庫資源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        HashMap<String,String> map = new LinkedHashMap<String,String>();
        try
        {
            //操作資料庫
            pstmt = conn.prepareStatement(sql);
            //如果需要傳參數
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            //加入資料
            while ( rs.next() )
            {
                map.put(rs.getString(1), rs.getString(2));
            }
        }
        catch ( SQLException e )
        {
            //輸出例外
            System.out.println("DbUtil.getMap: " + e.toString());
            System.out.println("DbUtil.getMap.sql: " + sql);
            throw e;
        }
        //關閉連結
        finally
        {
            close( rs );
            close( pstmt );
        }
        return map;
    }


    /**
     * 取得資料, 要求每筆資料只有兩個欄位
     * @param conn 資料庫連結
     * @param sql 查詢的SQL
     * @return HashMap 資料集，查不到資料時傳回size為0的HashMap
     * @throws SQLException 資料庫操作例外
     */
    public static HashMap<String,String> getMap( Connection conn, String sql )
        throws SQLException
    {
        return getMap( conn, sql, null );
    }


    /**
     * 取得資料, 要求每筆資料只有兩個欄位
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param sql 查詢的SQL
     * @param valueList 查詢的SQL的參數資料集
     * @return HashMap 資料集，查不到資料時傳回size為0的HashMap; 發生資料例外時傳回 null
     */
    public static HashMap<String,String> getMap( String sql, List<Object> valueList )
    {
        Connection conn = null;
        try
        {
            conn = getConn();
            return getMap(conn, sql, valueList);
        }
        //發生資料例外時傳回 null
        catch ( Exception e )
        {
            return null;
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 取得資料, 要求每筆資料只有兩個欄位
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param sql 查詢的SQL
     * @return HashMap 資料集，查不到資料時傳回size為0的HashMap; 發生資料庫例外時傳回 null
     */
    public static HashMap<String,String> getMap( String sql )
    {
        return getMap( sql, null );
    }


    /**
     * 執行資料庫操作SQL，如 INSERT、UPDATE 或 DELETE 等
     * @param conn 資料庫連結
     * @param sql 操作資料庫的SQL
     * @param valueList 操作資料庫的SQL的參數資料集
     * @return int 新增、修改或刪除 等所影響的筆數(如果是新增,且主鍵是自動增長的,傳回主鍵)
     * @throws SQLException 資料庫操作例外
     */
    public static int execute( Connection conn, String sql, List<Object> valueList )
        throws SQLException
    {
        //資料庫資源
        PreparedStatement pstmt = null;
        try
        {
            //操作資料庫
            pstmt = conn.prepareStatement(sql);
            //如果需要傳參數
            putSQLParams(pstmt, valueList);
            int affect = pstmt.executeUpdate();
            //新增時傳回主鍵
            if ( affect >= 1 )
            {
                sql = sql.trim().toLowerCase();
                //確定是新增
                if ( sql.startsWith("insert ") )
                {
                    //檢索由於執行此 Statement 物件而建立的所有自動生成的鍵
                    ResultSet rs = pstmt.getGeneratedKeys();
                    if ( rs.next() )
                    {
                        //僅有一列，故取得第一列
                        Long oid = rs.getLong(1);
                        if ( oid > 0 )
                        {
                            return NumberUtil.toInt(oid, affect);
                        }
                    }
                }
            }
            return affect;
        }
        catch ( SQLException e )
        {
            //輸出例外
            System.out.println("DbUtil.execute: " + e.toString());
            System.out.println("DbUtil.execute.sql: " + sql);
            throw e;
        }
        //關閉連結
        finally
        {
            close( pstmt );
        }
    }


    /**
     * 執行無傳回值的 SQL，如 INSERT、UPDATE 或 DELETE 等
     * @param conn 資料庫連結
     * @param sql 操作資料庫的SQL
     * @return int 新增、修改或刪除 等所影響的筆數
     * @throws SQLException 資料庫操作例外
     */
    public static int execute( Connection conn, String sql ) throws SQLException
    {
        return execute( conn, sql, null );
    }


    /**
     * 執行資料庫操作SQL，如 INSERT、UPDATE 或 DELETE 等
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param sql 操作資料庫的SQL
     * @param valueList 操作資料庫的SQL的參數資料集
     * @return int 新增、修改或刪除 等所影響的筆數; 發生資料庫例外時傳回-1
     */
    public static int execute( String sql, List<Object> valueList )
    {
        Connection conn = null;
        try
        {
            conn = getConn();
            return execute(conn, sql, valueList);
        }
        //發生資料庫例外時傳回 -1
        catch ( Exception e )
        {
            return -1;
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 執行資料庫操作SQL，如 INSERT、UPDATE 或 DELETE 等
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param sql 操作資料庫的SQL
     * @return int 新增、修改或刪除 等所影響的筆數; 發生資料庫例外時傳回-1
     */
    public static int execute( String sql )
    {
        return execute( sql, null );
    }


    /**
     * 驗證欄位的某值是否已經存在(通常用來驗證主鍵是否重複)
     * @param conn 資料庫連結
     * @param tableName 資料庫操作的表名
     * @param key 欄位名
     * @param value 欄位的值
     * @return boolean 驗證結果:欄位此值已經存在時傳回true，不存在時傳回false
     * @throws SQLException 資料庫操作例外
     */
    public static boolean isHave ( Connection conn, String tableName,
            String key, String value ) throws SQLException
    {
        // 防呆
        if ( tableName != null && key != null )
        {
            //驗證  主鍵 是否已經存在
            List<Object> valueList = new ArrayList<Object>();
            valueList.add(value);
            String sql = "select " + key + " from " + tableName + " where " + key + "= ? ";
            //如果欄位此值已經存在，傳回true
            if ( getOneData(conn, sql, valueList).size() > 0 )
                return true;
        }
        return false;
    }


    /**
     * 驗證欄位的某值是否已經存在(通常用來驗證主鍵是否重複)
     * 建議當僅有一次資料庫操作時使用,需多次操作的建議建立 Connection
     * @param tableName 資料庫操作的表名
     * @param key 欄位名
     * @param value 欄位的值
     * @return boolean 驗證結果:欄位此值已經存在時傳回true,不存在時傳回false
     * @throws NullPointerException 資料庫操作例外,可以不 catch
     */
    public static boolean isHave( String tableName, String key, String value )
    {
        Connection conn = null;
        try
        {
            conn = getConn();
            return isHave( conn, tableName, key, value );
        }
        //發生資料庫例外時,拋出,可以不捕獲
        catch ( Exception e )
        {
            throw new NullPointerException();
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 傳遞參數到 PreparedStatement, 僅供本類內部使用
     * (註:此方法有待改善,目前僅字串且不為空情況下測試過)
     * @param pstmt PreparedStatement
     * @param valueList 參數列表
     * @return PreparedStatement連結
     * @throws SQLException 資料庫操作例外
     */
    private static PreparedStatement putSQLParams ( PreparedStatement pstmt,
            List<Object> valueList ) throws SQLException
    {
        try
        {
            //查詢的參數資料集的筆數
            int valueListSize = (valueList == null) ? 0 : valueList.size();
            for ( int i = 0; i < valueListSize; i++ )
            {
                if ( valueList.get(i) == null )
                    pstmt.setNull(i + 1, java.sql.Types.NULL);
                else if ( valueList.get(i) instanceof String )
                    pstmt.setString(i + 1, "" + valueList.get(i));
                else if ( valueList.get(i) instanceof Integer )
                    pstmt.setInt(i + 1, Integer.parseInt(""+valueList.get(i)));
                else if ( valueList.get(i) instanceof Long )
                    pstmt.setLong(i + 1, Long.parseLong(""+(valueList.get(i))));
                else if ( valueList.get(i) instanceof Double )
                    pstmt.setDouble(i + 1, Double.parseDouble(""+(valueList.get(i))));
                else if ( valueList.get(i) instanceof java.util.Date )
                    pstmt.setDate(i + 1, new java.sql.Date(((java.util.Date)valueList.get(i)).getTime()) );
                else if ( valueList.get(i) instanceof java.sql.Blob )
                    pstmt.setBlob(i + 1, (java.sql.Blob) valueList.get(i) );
                else
                    pstmt.setObject(i + 1, valueList.get(i) );
            }
        }
        catch ( SQLException e )
        {
            //輸出例外
            System.out.println("DbUtil.putSQLParams: " + e.toString());
            throw e;
        }
        return pstmt;
    }


    /**
     * 增加SQL查詢條件，和對應的值
     * 動作為 like 時，使用模糊查詢，忽略大小寫，空格轉變成匹配任意內容
     * 如果是 oracle資料庫，請在條件的最後面加上“escape'\'”
     * @param name 需要增加的SQL的欄位名稱
     * @param action 需要增加的SQL的對應動作，如 like, =, >= 等
     * @param value 對應的值
     * @param valueList 參數列表
     * @param canNull 空值參數是否加入查詢,為true時""和null都將加入查詢條件,否則不加入查詢條件;預設為false
     * @return SQL條件
     * @example  sql = "select * from tableName a where 1=1 ";
     *           sql += DbUtil.addSQL("a.aporder", "like", request.getParameter("aporder"), valueList, false);
     *           結果: sql = "select * from tableName a where 1=1 and a.aporder like ? "; valueList.add("kk%kk");
     */
    public static String addSqlCondition ( String name, String action, String value,
            List<String> valueList, boolean canNull )
    {
        // 防呆 和 去除前後空格
        name   = (name   == null) ? "" : name.trim();
        action = (action == null) ? "" : action.trim().toLowerCase();
        // 如果 name,action 值為空的話, 不用加上; value為空是有可能的
        if ( "".equals(name) || "".equals(action) )
            return "";
        // 參數為空時，不加入查詢條件
        if ( !canNull && (value == null || "".equals(value)) )
            return "";

        //value為null值時
        if ( value == null )
        {
            //等於 null
            if ( "like".equals(action) || "=".equals(action) || "is".equals(action) )
                return (" and " + name + " is null ");
            //不等於null
            else if ( "!=".equals(action) || "<>".equals(action) || "^=".equals(action) || action.contains("not") )
                return (" and " + name + " is not null ");
            else
                return "";
        }
        //刪除前後空格
        value = value.trim();

        // 如果動作是"like"，則使用模糊查詢
        if ( "like".equals(action) )
        {
            // 如果 value 值為空的話, 不用加上
            if ( "".equals(value) )
                return "";
            // 傳回的字串結果，例如： and UPPER(col) like %value%
            name = "UPPER(" + name + ")";
            // 一個斜杠轉成4個斜杠(MySQL語法)
            value = value.replaceAll("\\\\", "\\\\\\\\\\\\\\\\");
            // 處理特殊符號，這裡用“\”做轉義符號；如果含有特殊符號，Oracle請在條件的最後面加上“escape'\'”
            value = value.replaceAll("%", "\\\\%");
            value = value.replaceAll("_", "\\\\_");
            // 將空格轉變成匹配任意內容
            value = value.replaceAll("\\s", "%");
            value = "%" + value.toUpperCase() + "%";
        }
        // 如果有參數列表
        if ( valueList != null )
        {
            // 為參數列表加上 value 值
            valueList.add( value );
            // 傳回的字串結果，例如： and col = value
            return (" and " + name + " " + action + " ? ");
        }
        // 沒有參數列表，則傳回查詢SQL條件
        value = StringUtil.toSqlStr(value);
        return (" and " + name + " " + action + " '" + value + "' ");
    }


    /**
     * 增加查詢SQL，和對應的值；如果參數值為空，就不加上去
     * 動作為 like 時，使用模糊查詢，忽略大小寫，空格轉變成匹配任意內容
     * 如果含有特殊符號，請在條件的最後面加上“escape'\'”
     * @param name 需要增加的SQL的欄位名稱
     * @param action 需要增加的SQL的對應動作，如 like, =, >= 等
     * @param value 對應的值
     * @param valueList 參數列表
     * @param canNull 空值參數是否加入查詢,為true時""和null都將加入查詢條件,否則不加入查詢條件;預設為false
     * @return SQL條件
     * @example  sql = "select * from tableName a where 1=1 ";
     *           sql += DbUtil.addSQL("a.aporder", "like", request.getParameter("aporder"), valueList);
     *           結果: sql = "select * from tableName a where 1=1 and a.aporder like ? "; valueList.add("kk%kk");
     */
    public static String addSqlCondition( String name, String action, String value, List<String> valueList )
    {
        return addSqlCondition( name, action, value, null, false );
    }


    /**
     * 增加查詢SQL，和對應的值；如果值為空的，就不加上去
     * 動作為 like 時，使用模糊查詢，忽略大小寫，空格轉變成匹配任意內容
     * 如果含有特殊符號，請在條件的最後面加上“escape'\'”
     * @param name 需要增加的SQL的欄位名稱
     * @param action 需要增加的SQL的對應動作，如 like, =, >= 等
     * @param value 對應的值
     * @return SQL條件
     * @example  sql = "select * from tableName a where 1=1 ";
     *           sql += DbUtil.addSQL("a.aporder", "like", request.getParameter("aporder"));
     *           結果: sql = "select * from tableName a where 1=1 and a.aporder like 'kk%kk'";
     */
    public static String addSqlCondition( String name, String action, String value )
    {
        return addSqlCondition( name, action, value, null );
    }


}
