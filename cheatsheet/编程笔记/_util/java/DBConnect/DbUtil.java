/**
 * <P> Title: 公用类别                                      </P>
 * <P> Description: 数据库操作工具                          </P>
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
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSource;


/**
 * 数据库操作工具
 * @author <a href='daillow@gmail.com'>Holer</a>
 * @version 0.2
 */
public final class DbUtil
{
    /**
     * Connection Pool
     */
    private static DataSource dataSource = null;


    /**
     * 取得 Connection Pool
     */
    private synchronized static void setupDataSource()
    {
        // 读取配置文件(位于: 项目/WEB-INF/classes/database.properties)
        ResourceBundle actionDB = ResourceBundle.getBundle("database");
        // 取得对应的属性值
        String driverName = actionDB.getString("DriverName");
        String DBUrl = actionDB.getString("DBUrl");
        String Username = actionDB.getString("Username");
        String Password = actionDB.getString("Password");

        // 最大等待时间
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


    /**
     * 取得 数据库链接
     * @return 数据库链接
     * @throws SQLException 数据库操作异常
     */
    public static Connection getConn() throws SQLException
    {
        Connection conn = null;
        try
        {
            if ( dataSource == null )
            {
                // 取得Connection Pool
                setupDataSource();
            }
            // 取得数据库链接
            conn = dataSource.getConnection();
        }
        // 抛出 数据库操作异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.getConn -> SQLException:" + e.toString());
            throw e;
        }
        return conn;
    }


    /**
     * 获取数据库连结
     * @param driverName 数据库驱动名
     * @param url 数据库链接地址
     * @param username 数据库登录名
     * @param password 数据库登录密码
     * @return Connection 数据库链接
     * @throws ClassNotFoundException 数据库驱动找不到异常
     * @throws SQLException 数据库操作异常
     */
    public static Connection getConn(String driverName, String url, String username, String password)
        throws ClassNotFoundException, SQLException
    {
        Connection conn = null;
        try
        {
            // 加载驱动
            Class.forName(driverName);
            // 取得连结
            conn = DriverManager.getConnection(url, username, password);
        }
        // 抛出 数据库驱动找不到异常
        catch ( ClassNotFoundException e )
        {
            System.out.println("DbUtil.getConn -> ClassNotFoundException:" + e.toString());
            throw e;
        }
        // 抛出 数据库操作异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.getConn -> SQLException:" + e.toString());
            throw e;
        }
        return conn;
    }


    /**
     * 还原事务处理
     * @param conn 数据库链接
     */
    public static void rollback(Connection conn)
    {
        try
        {
            boolean isAutoCommit = conn.getAutoCommit();
            if ( false == isAutoCommit )
            {
                // 还原事务处理
                conn.rollback();
            }
        }
        // 捕获异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.rollback -> SQLException:" + e.toString());
        }
    }


    /**
     * 设定交易送出模式
     * @param conn 数据库链接
     * @param isAutoCommit 是否自动送出
     */
    public static void setAutoCommit(Connection conn, boolean isAutoCommit)
    {
        try
        {
            conn.setAutoCommit(isAutoCommit);
        }
        // 捕获异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.setAutoCommit -> SQLException:" + e.toString());
        }
    }


    /**
     * 关闭数据库链接
     * @param conn 数据库链接
     */
    public static void close(Connection conn)
    {
        try
        {
            if ( conn != null )
            {
                // 如果不是自动送出模式,交易送出
                if ( false == conn.getAutoCommit() )
                {
                   conn.commit();
                }
                // 关闭数据库链接
                conn.close();
                conn = null;
            }
        }
        // 捕获异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.close -> SQLException:" + e.toString());
        }
    }


    /**
     * 关闭数据库操作链接
     * @param statement 数据库Statement
     */
    public static void close(Statement statement)
    {
        try
        {
            if ( statement != null )
            {
                // 关闭资源
                statement.close();
                statement = null;
            }
        }
        // 捕获异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.close -> SQLException:" + e.toString());
        }
    }


    /**
     * 关闭结果集连结
     * @param resultSet 结果集连结
     */
    public static void close(ResultSet resultSet)
    {
        try
        {
            if ( resultSet != null )
            {
                // 关闭资源
                resultSet.close();
                resultSet = null;
            }
        }
        // 捕获异常
        catch ( SQLException e )
        {
            System.out.println("DbUtil.close -> SQLException:" + e.toString());
        }
    }


    /**
     * 关闭连结
     * @param conn 数据库链接
     * @param stmt 数据库操作链接
     * @param resultSet 结果集连结
     */
    public static void close(Connection conn, Statement stmt, ResultSet resultSet)
    {
        close(resultSet);
        close(stmt);
        close(conn);
    }


    /**
     * 取得资料
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return ArrayList 数据集,查不到数据时传回size为0的ArrayList
     * @throws SQLException 数据库操作异常
     */
    public static ArrayList<HashMap<String, String>> getData(Connection conn, String sql, List<Object> valueList)
            throws SQLException
    {
        ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
        // 数据库资源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        try
        {
            // 操作数据库
            pstmt = conn.prepareStatement(sql);
            // 如果需要传参数
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsMetaData = rs.getMetaData();
            int col = rsMetaData.getColumnCount();
            // 加入数据
            while ( rs.next() )
            {
                HashMap<String, String> map = new LinkedHashMap<String, String>();
                for ( int i = 1; i <= col; i++ )
                {
                    map.put(rsMetaData.getColumnLabel(i).toLowerCase(), rs.getString(i));
                }
                list.add(map);
            }
        }
        catch ( SQLException e )
        {
            // 输出异常
            System.out.println("DbUtil.getData -> SQLException: " + e.toString());
            System.out.println("DbUtil.getData -> sql: " + sql);
            throw e;
        }
        // 关闭连结
        finally
        {
            close(rs);
            close(pstmt);
        }
        return list;
    }


    /**
     * 取得资料
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @return ArrayList 数据集,查不到数据时传回size为0的ArrayList
     * @throws SQLException 数据库操作异常
     */
    public static ArrayList<HashMap<String, String>> getData(Connection conn, String sql) throws SQLException
    {
        return getData(conn, sql, null);
    }


    /**
     * 取得资料 <br />
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return ArrayList 数据集,查不到数据时传回size为0的ArrayList
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static ArrayList<HashMap<String, String>> getData(String sql, List<Object> valueList)
    {
        Connection conn = null;
        try
        {
            // 开启数据库链接
            conn = getConn();
            return getData(conn, sql, valueList);
        }
        // 发生数据库异常时,抛出,可以不捕获
        catch ( SQLException e )
        {
            throw new RuntimeException("DbUtil.getData -> SQLException: " + e.toString());
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 取得资料 <br />
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param sql 查询的SQL
     * @return ArrayList 数据集,查不到数据时传回size为0的ArrayList
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static ArrayList<HashMap<String, String>> getData(String sql)
    {
        return getData(sql, null);
    }


    /**
     * 取得资料，number 从1开始
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return ArrayList 数据集,查不到数据时传回size为0的ArrayList
     * @throws SQLException 数据库操作异常
     */
    public static ArrayList<HashMap<String, String>> getDataByNum(Connection conn, String sql, List<Object> valueList)
            throws SQLException
    {
        ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
        // 数据库资源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        try
        {
            // 操作数据库
            pstmt = conn.prepareStatement(sql);
            // 如果需要传参数
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsMetaData = rs.getMetaData();
            int col = rsMetaData.getColumnCount();
            // 加入数据
            while ( rs.next() )
            {
                HashMap<String, String> map = new LinkedHashMap<String, String>();
                for ( int i = 1; i <= col; i++ )
                {
                    map.put("" + i, rs.getString(i));
                }
                list.add(map);
            }
        }
        catch ( SQLException e )
        {
            // 输出异常
            System.out.println("DbUtil.getDataByNum -> SQLException: " + e.toString());
            System.out.println("DbUtil.getDataByNum -> sql: " + sql);
            throw e;
        }
        // 关闭连结
        finally
        {
            close(rs);
            close(pstmt);
        }
        return list;
    }


    /**
     * 取得资料，number 从1开始
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @return ArrayList 数据集,查不到数据时传回size为0的ArrayList
     * @throws SQLException 数据库操作异常
     */
    public static ArrayList<HashMap<String, String>> getDataByNum(Connection conn, String sql) throws SQLException
    {
        return getDataByNum(conn, sql, null);
    }


    /**
     * 取得资料，number 从1开始 <br/>
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return ArrayList 数据集,查不到数据时传回size为0的ArrayList
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static ArrayList<HashMap<String, String>> getDataByNum(String sql, List<Object> valueList)
    {
        Connection conn = null;
        try
        {
            // 开启数据库链接
            conn = getConn();
            return getDataByNum(conn, sql, valueList);
        }
        // 发生数据库异常时,抛出,可以不捕获
        catch ( SQLException e )
        {
            throw new RuntimeException("DbUtil.getDataByNum -> SQLException: " + e.toString());
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 取得资料，number 从1开始 <br />
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param sql 查询的SQL
     * @return ArrayList 数据集,查不到数据时传回size为0的ArrayList
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static ArrayList<HashMap<String, String>> getDataByNum(String sql)
    {
        return getDataByNum(sql, null);
    }


    /**
     * 取得一笔资料
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return HashMap 数据集,查不到数据时传回size为0的HashMap
     * @throws SQLException 数据库操作异常
     */
    public static HashMap<String, String> getOneData(Connection conn, String sql, List<Object> valueList)
            throws SQLException
    {
        // 数据库资源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        HashMap<String, String> map = new LinkedHashMap<String, String>();
        try
        {
            // 操作数据库
            pstmt = conn.prepareStatement(sql);
            // 如果需要传参数
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsMetaData = rs.getMetaData();
            int col = rsMetaData.getColumnCount();
            // 加入数据
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
            // 输出异常
            System.out.println("DbUtil.getOneData -> SQLException: " + e.toString());
            System.out.println("DbUtil.getOneData -> sql: " + sql);
            throw e;
        }
        // 关闭连结
        finally
        {
            close(rs);
            close(pstmt);
        }
        return map;
    }


    /**
     * 取得一笔资料
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @return HashMap 数据集,查不到数据时传回size为0的HashMap
     * @throws SQLException 数据库操作异常
     */
    public static HashMap<String, String> getOneData(Connection conn, String sql) throws SQLException
    {
        return getOneData(conn, sql, null);
    }


    /**
     * 取得一笔资料 <br/>
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return HashMap 数据集,查不到数据时传回size为0的HashMap
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static HashMap<String, String> getOneData(String sql, List<Object> valueList)
    {
        Connection conn = null;
        try
        {
            // 开启数据库链接
            conn = getConn();
            return getOneData(conn, sql, valueList);
        }
        // 发生数据库异常时,抛出,可以不捕获
        catch ( SQLException e )
        {
            throw new RuntimeException("DbUtil.getOneData -> SQLException: " + e.toString());
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 取得一笔资料 <br />
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param sql 查询的SQL
     * @return HashMap 数据集,查不到数据时传回size为0的HashMap
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static HashMap<String, String> getOneData(String sql)
    {
        return getOneData(sql, null);
    }


    /**
     * 查询一个字段
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return String 结果；查无数据，以及数据为 null 时，传回 null
     * @throws SQLException 数据库操作异常
     */
    public static String queryOne(Connection conn, String sql, List<Object> valueList) throws SQLException
    {
        // 数据库资源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        try
        {
            // 操作数据库
            pstmt = conn.prepareStatement(sql);
            // 如果需要传参数
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            // 只查询一个字段
            if ( rs.next() )
                return rs.getString(1);
        }
        catch ( SQLException e )
        {
            // 输出异常
            System.out.println("DbUtil.queryOne -> SQLException: " + e.toString());
            System.out.println("DbUtil.queryOne -> sql: " + sql);
            throw e;
        }
        // 关闭连结
        finally
        {
            close(rs);
            close(pstmt);
        }
        // 查不到内容时，传回null
        return null;
    }


    /**
     * 查询一个字段
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @return String 结果； 查无数据，以及数据为 null 时，传回 null
     * @throws SQLException 数据库操作异常
     */
    public static String queryOne(Connection conn, String sql) throws SQLException
    {
        return queryOne(conn, sql, null);
    }


    /**
     * 查询一个字段
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return String 结果；查无数据，以及数据为 null 时，传回 null
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static String queryOne(String sql, List<Object> valueList)
    {
        Connection conn = null;
        try
        {
            // 开启数据库链接
            conn = getConn();
            return queryOne(conn, sql, valueList);
        }
        // 发生数据异常时,抛出异常,但可以不捕获
        catch ( SQLException e )
        {
            throw new RuntimeException("DbUtil.queryOne -> SQLException: " + e.toString());
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 查询一个字段
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @return String 结果；查无数据，以及数据为 null 时，传回 null
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static String queryOne(String sql)
    {
        return queryOne(sql, null);
    }


    /**
     * 取得数据, 要求每笔数据只有两个字段
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return HashMap 数据集，查不到数据时传回size为0的HashMap
     * @throws SQLException 数据库操作异常
     */
    public static HashMap<String, String> getMap(Connection conn, String sql, List<Object> valueList)
            throws SQLException
    {
        // 数据库资源
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        HashMap<String, String> map = new LinkedHashMap<String, String>();
        try
        {
            // 操作数据库
            pstmt = conn.prepareStatement(sql);
            // 如果需要传参数
            putSQLParams(pstmt, valueList);
            rs = pstmt.executeQuery();
            // 加入数据
            while ( rs.next() )
            {
                map.put(rs.getString(1), rs.getString(2));
            }
        }
        catch ( SQLException e )
        {
            // 输出异常
            System.out.println("DbUtil.getMap -> SQLException: " + e.toString());
            System.out.println("DbUtil.getMap -> sql: " + sql);
            throw e;
        }
        // 关闭连结
        finally
        {
            close(rs);
            close(pstmt);
        }
        return map;
    }


    /**
     * 取得数据, 要求每笔数据只有两个字段
     * @param conn 数据库链接
     * @param sql 查询的SQL
     * @return HashMap 数据集，查不到数据时传回size为0的HashMap
     * @throws SQLException 数据库操作异常
     */
    public static HashMap<String, String> getMap(Connection conn, String sql) throws SQLException
    {
        return getMap(conn, sql, null);
    }


    /**
     * 取得数据, 要求每笔数据只有两个字段 <br />
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param sql 查询的SQL
     * @param valueList 查询的SQL的参数数据集
     * @return HashMap 数据集，查不到数据时传回size为0的HashMap
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static HashMap<String, String> getMap(String sql, List<Object> valueList)
    {
        Connection conn = null;
        try
        {
            // 取得数据库链接
            conn = getConn();
            return getMap(conn, sql, valueList);
        }
        // 发生数据库异常时,抛出,可以不捕获
        catch ( SQLException e )
        {
            throw new RuntimeException("DbUtil.getMap -> SQLException: " + e.toString());
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 取得数据, 要求每笔数据只有两个字段 <br />
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param sql 查询的SQL
     * @return HashMap 数据集，查不到数据时传回size为0的HashMap
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static HashMap<String, String> getMap(String sql)
    {
        return getMap(sql, null);
    }


    /**
     * 执行数据库操作SQL，如 INSERT、UPDATE 或 DELETE 等
     * @param conn 数据库链接
     * @param sql 操作数据库的SQL
     * @param valueList 操作数据库的SQL的参数数据集
     * @return int 新增、修改或删除 等所影响的笔数(如果是新增,且主键是自动增长的,传回主键)
     * @throws SQLException 数据库操作异常
     */
    public static int execute(Connection conn, String sql, List<Object> valueList) throws SQLException
    {
        // 数据库资源
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try
        {
            // 取得数据库 Statement
            pstmt = conn.prepareStatement(sql);
            // 传递参数
            putSQLParams(pstmt, valueList);
            int affect = pstmt.executeUpdate();

            // 操作成功时
            if ( affect >= 1 )
            {
                sql = sql.trim().toLowerCase();
                // 确定是新增,新增时传回主键
                if ( sql.startsWith("insert ") )
                {
                    // 检索由于执行此 Statement 对象而建立的所有自动生成的键
                    rs = pstmt.getGeneratedKeys();
                    if ( rs.next() )
                    {
                        // 仅有一列，故取得第一列
                        long oid = rs.getLong(1);
                        if ( oid > 0 )
                        {
                            return Integer.parseInt("" + oid);
                        }
                    }
                }
            }
            return affect;
        }
        catch ( SQLException e )
        {
            // 输出异常
            System.out.println("DbUtil.execute -> SQLException: " + e.toString());
            System.out.println("DbUtil.execute -> sql: " + sql);
            throw e;
        }
        // 关闭连结
        finally
        {
            close(rs);
            close(pstmt);
        }
    }


    /**
     * 执行无传回值的 SQL，如 INSERT、UPDATE 或 DELETE 等
     * @param conn 数据库链接
     * @param sql 操作数据库的SQL
     * @return int 新增、修改或删除 等所影响的笔数
     * @throws SQLException 数据库操作异常
     */
    public static int execute(Connection conn, String sql) throws SQLException
    {
        return execute(conn, sql, null);
    }


    /**
     * 执行数据库操作SQL，如 INSERT、UPDATE 或 DELETE 等 <br />
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param sql 操作数据库的SQL
     * @param valueList 操作数据库的SQL的参数数据集
     * @return int 新增、修改或删除 等所影响的笔数
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static int execute(String sql, List<Object> valueList)
    {
        Connection conn = null;
        try
        {
            // 取得数据库链接
            conn = getConn();
            return execute(conn, sql, valueList);
        }
        // 发生数据库异常时,抛出,可以不捕获
        catch ( SQLException e )
        {
            throw new RuntimeException("DbUtil.execute -> SQLException: " + e.toString());
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 执行数据库操作SQL，如 INSERT、UPDATE 或 DELETE 等 <br />
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param sql 操作数据库的SQL
     * @return int 新增、修改或删除 等所影响的笔数;
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static int execute(String sql)
    {
        return execute(sql, null);
    }


    /**
     * 验证字段的某值是否已经存在(通常用来验证主键是否重复)
     * @param conn 数据库链接
     * @param tableName 数据库操作的表名
     * @param key 字段名
     * @param value 字段的值
     * @return boolean 验证结果:字段此值已经存在时传回true，不存在时传回false
     * @throws SQLException 数据库操作异常
     */
    public static boolean isHave(Connection conn, String tableName, String key, String value) throws SQLException
    {
        // 防呆
        if ( tableName != null && key != null )
        {
            // 验证 主键 是否已经存在
            List<Object> valueList = new ArrayList<Object>();
            valueList.add(value);
            String sql = "select " + key + " from " + tableName + " where " + key + "= ? ";
            // 如果字段此值已经存在，传回true
            if ( getOneData(conn, sql, valueList).size() > 0 )
            {
                return true;
            }
        }
        return false;
    }


    /**
     * 验证字段的某值是否已经存在(通常用来验证主键是否重复) 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param tableName 数据库操作的表名
     * @param key 字段名
     * @param value 字段的值
     * @return boolean 验证结果:字段此值已经存在时传回true,不存在时传回false
     * @throws RuntimeException 数据库操作异常,可以不 catch
     */
    public static boolean isHave(String tableName, String key, String value)
    {
        Connection conn = null;
        try
        {
            // 取得数据库链接
            conn = getConn();
            return isHave(conn, tableName, key, value);
        }
        // 发生数据库异常时,抛出,可以不捕获
        catch ( SQLException e )
        {
            throw new RuntimeException("DbUtil.isHave -> SQLException: " + e.toString());
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 传递参数到 PreparedStatement, 仅供本类内部使用 (注:此方法有待改善,目前仅字符串且不为空情况下测试过)
     * @param pstmt PreparedStatement
     * @param valueList 参数列表
     * @return PreparedStatement连结
     * @throws SQLException 数据库操作异常
     */
    public static PreparedStatement putSQLParams(PreparedStatement pstmt, List<Object> valueList) throws SQLException
    {
        try
        {
            // 查询的参数数据集的笔数
            int valueListSize = (valueList == null) ? 0 : valueList.size();
            for ( int i = 0; i < valueListSize; i++ )
            {
                // 取得参数
                Object obj = valueList.get(i);
                // 根据参数类型来赋值
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
        }
        catch ( SQLException e )
        {
            // 输出异常
            System.out.println("DbUtil.putSQLParams -> SQLException: " + e.toString());
            throw e;
        }
        return pstmt;
    }


    /**
     * 增加SQL查询条件，和对应的值 <br />
     * 动作为 like 时，使用模糊查询，忽略大小写，空格转变成匹配任意内容; “%”、“_”将被转义 <br />
     * @param name 需要增加的SQL的域名
     * @param action 需要增加的SQL的对应动作，如 like, =, >= 等
     * @param value 对应的值
     * @param valueList 参数列表
     * @param canNull 空值参数是否加入查询,为true时""和null都将加入查询条件,否则不加入查询条件;预设为false
     * @return SQL条件
     * @example sql = "select * from tableName a where 1=1 "; <br />
     *          sql += DbUtil.addSqlCondition("a.aporder", "like", request.getParameter("aporder"), valueList, false);  <br />
     *     结果: sql = "select * from tableName a where 1=1 and a.aporder like ? "; <br />
     *           valueList.add("%value%");
     */
    public static String addSqlCondition(String name, String action, String value, List<Object> valueList,
            boolean canNull)
    {
        // 防呆 和 去除前后空格
        name = (name == null) ? "" : name.trim();
        // 动作,转成小写并且删除中间的空格
        action = (action == null) ? "" : action.trim().toLowerCase().replaceAll("\\s+", " ");
        // 如果 name,action 值为空的话, 不用加上; value为空是有可能的
        if ( "".equals(name) || "".equals(action) )
            return "";
        // 参数为空时，不加入查询条件
        if ( !canNull && (value == null || "".equals(value)) )
            return "";

        // value为null值时
        if ( value == null )
        {
            // 等于 null
            if ( "like".equals(action) || "=".equals(action) || "is".equals(action) )
                return (" and " + name + " is null ");
            // 不等于null
            else if ( "!=".equals(action) || "<>".equals(action) || "^=".equals(action)
                    || "is not".equals(action) || "not like".equals(action) )
                return (" and " + name + " is not null ");
            else
                return "";
        }
        // 删除前后空格
        value = value.trim();

        // 如果动作是"like",则使用多个 instr 来代替模糊查询;效率更高
        if ( "like".equals(action) || "not like".equals(action) )
        {
            // 如果 value 值为空的话, 不用加上
            if ( "".equals(value) )
                return "";

            // 传回值
            String returnSQL = "";
            // not like 时
            String notLike = ("not like".equals(action) ? "<=0" : "");

            // 按空格分隔
            String[] values = value.toUpperCase().replaceAll("\\s+", " ").split(" ");
            for ( int i = 0; i < values.length; i++ )
            {
                // 如果有参数列表
                if ( valueList != null )
                {
                    // 为参数列表加上 value 值
                    valueList.add(values[i]);
                    // 传回的字符串结果，例如： and instr(UPPER(name), ?)
                    // 由于本项目使用MySQL,他本身已经忽略大小写,不必徒增UPPER()
                    returnSQL += " and instr(" + name + ", ?)";
                }
                else
                {
                    // 传回的字符串结果，例如： and instr(UPPER(name), ?)
                    returnSQL += " and instr(" + name + ", '" + StringUtil.toSqlStr(values[i]) + "')";
                }
                returnSQL += notLike;
            }
            return returnSQL;
        }

        // 如果有参数列表
        if ( valueList != null )
        {
            // 为参数列表加上 value 值
            valueList.add(value);
            // 传回的字符串结果，例如： and col = value
            return (" and " + name + " " + action + " ? ");
        }
        // 没有参数列表，则传回查询SQL条件
        value = StringUtil.toSqlStr(value);
        return (" and " + name + " " + action + " '" + value + "' ");
    }


    /**
     * 增加SQL查询条件，和对应的值 <br />
     * 动作为 like 时，使用模糊查询，忽略大小写，空格转变成匹配任意内容; “%”、“_”将被转义 <br />
     * @param name 需要增加的SQL的域名
     * @param action 需要增加的SQL的对应动作，如 like, =, >= 等
     * @param value 对应的值
     * @param valueList 参数列表
     * @param canNull 空值参数是否加入查询,为true时""和null都将加入查询条件,否则不加入查询条件;预设为false
     * @return SQL条件
     * @example sql = "select * from tableName a where 1=1 "; <br />
     *          sql += DbUtil.addSqlCondition("a.aporder", "like", request.getParameter("aporder"), valueList, false);  <br />
     *     结果: sql = "select * from tableName a where 1=1 and a.aporder like ? "; <br />
     *           valueList.add("%value%");
     */
    public static String addLikeSql(String name, String action, String value, List<Object> valueList,
            boolean canNull)
    {
        // 防呆 和 去除前后空格
        name = (name == null) ? "" : name.trim();
        // 动作,转成小写并且删除中间的空格
        action = (action == null) ? "" : action.trim().toLowerCase().replaceAll("\\s+", " ");
        // 如果 name,action 值为空的话, 不用加上; value为空是有可能的
        if ( "".equals(name) || "".equals(action) )
            return "";
        // 参数为空时，不加入查询条件
        if ( !canNull && (value == null || "".equals(value)) )
            return "";

        // value为null值时
        if ( value == null )
        {
            // 等于 null
            if ( "like".equals(action) || "=".equals(action) || "is".equals(action) )
                return (" and " + name + " is null ");
            // 不等于null
            else if ( "!=".equals(action) || "<>".equals(action) || "^=".equals(action)
                    || "is not".equals(action) || "not like".equals(action) )
                return (" and " + name + " is not null ");
            else
                return "";
        }
        // 删除前后空格
        value = value.trim();

        // 如果动作是"like",则使用多个 instr 来代替模糊查询;效率更高
        if ( "like".equals(action) || "not like".equals(action) )
        {
            // 如果 value 值为空的话, 不用加上
            if ( "".equals(value) )
                return "";

            // 传回值
            String returnSQL = "";
            // not like 时
            String notLike = ("not like".equals(action) ? "<=0" : "");

            // 按空格分隔
            String values = value.toUpperCase().replaceAll("\\s+", "%");
            // 如果有参数列表
            if ( valueList != null )
            {
                // 为参数列表加上 value 值
                valueList.add(values + "%");
                // 传回的字符串结果，例如： and instr(UPPER(name), ?)
                // 由于本项目使用MySQL,他本身已经忽略大小写,不必徒增UPPER()
                //returnSQL += " and instr(" + name + ", ?)";
                returnSQL += " and " + name + " like ? ";
            }
            else
            {
                // 传回的字符串结果，例如： and instr(UPPER(name), ?)
                //returnSQL += " and instr(" + name + ", '" + StringUtil.toSqlStr(values[i]) + "')";
                returnSQL += " and " + name + " like '" + StringUtil.toSqlStr(values) + "%'";
            }
            returnSQL += notLike;
            return returnSQL;
        }

        // 如果有参数列表
        if ( valueList != null )
        {
            // 为参数列表加上 value 值
            valueList.add(value);
            // 传回的字符串结果，例如： and col = value
            return (" and " + name + " " + action + " ? ");
        }
        // 没有参数列表，则传回查询SQL条件
        value = StringUtil.toSqlStr(value);
        return (" and " + name + " " + action + " '" + value + "' ");
    }


    /**
     * 增加查询SQL，和对应的值； <br />
     * 如果参数值为空，就不加上去 动作为 like 时，使用模糊查询，忽略大小写，空格转变成匹配任意内容; “%”、“_”将被转义 <br />
     * @param name 需要增加的SQL的域名
     * @param action 需要增加的SQL的对应动作，如 like, =, >= 等
     * @param value 对应的值
     * @param valueList 参数列表
     * @param canNull 空值参数是否加入查询,为true时""和null都将加入查询条件,否则不加入查询条件;预设为false
     * @return SQL条件
     * @example sql = "select * from tableName a where 1=1 ";  <br />
     *          sql += DbUtil.addSqlCondition("a.aporder", "like", request.getParameter("aporder"), valueList); <br />
     *     结果: sql = "select * from tableName a where 1=1 and a.aporder like ? "; <br />
     *          valueList.add("%value%");
     */
    public static String addSqlCondition(String name, String action, String value, List<Object> valueList)
    {
        return addSqlCondition(name, action, value, null, false);
    }


    /**
     * 增加查询SQL，和对应的值； <br />
     * 如果参数值为空，就不加上去 动作为 like 时，使用模糊查询，忽略大小写，空格转变成匹配任意内容; “%”、“_”将被转义 <br />
     * @param name 需要增加的SQL的域名
     * @param action 需要增加的SQL的对应动作，如 like, =, >= 等
     * @param value 对应的值
     * @param valueList 参数列表
     * @param canNull 空值参数是否加入查询,为true时""和null都将加入查询条件,否则不加入查询条件;预设为false
     * @return SQL条件
     * @example sql = "select * from tableName a where 1=1 ";  <br />
     *          sql += DbUtil.addSqlCondition("a.aporder", "like", request.getParameter("aporder"), valueList); <br />
     *     结果: sql = "select * from tableName a where 1=1 and a.aporder like ? "; <br />
     *          valueList.add("%value%");
     */
    public static String addLikeSql(String name, String action, String value, List<Object> valueList)
    {
        return addLikeSql(name, action, value, null, false);
    }


    /**
     * 增加查询SQL，和对应的值； <br />
     * 如果值为空的，就不加上去 动作为 like 时，使用模糊查询，忽略大小写，空格转变成匹配任意内容 <br />
     * 如果含有特殊符号，请在条件的最后面加上“escape'\'”
     * @param name 需要增加的SQL的域名
     * @param action 需要增加的SQL的对应动作，如 like, =, >= 等
     * @param value 对应的值
     * @return SQL条件
     * @example sql = "select * from tableName a where 1=1 "; <br />
     *          sql += DbUtil.addSqlCondition("a.aporder", "like", request.getParameter("aporder")); <br />
     *     结果: sql = "select * from tableName a where 1=1 and a.aporder like '%value%'"; <br />
     */
    public static String addSqlCondition(String name, String action, String value)
    {
        return addSqlCondition(name, action, value, null);
    }


    /**
     * 新增资料
     * @param conn 数据库链接
     * @param table 表名称
     * @param data 数据集
     * @return int 操作讯息(>0：为主键,否则失败)
     * @example table:album,data:{id:1,name:2};result:1
     */
    public static int insert(Connection conn, String table, HashMap<String, Object> data) throws SQLException
    {
    	//取得SQL和参数列表
    	Object[] datas = getInsertSQL(table, data);
    	String sql = (String)datas[0];
        //参数列表
        List<Object> valueList = (List)datas[1];
		//新增
        return execute(conn, sql, valueList);
    }


    /**
     * 新增资料 <br />
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param table 表名称
     * @param data 数据集
     * @return int 操作讯息(>0：为主键,否则失败)
     * @throws RuntimeException 数据库操作异常,可以不 catch
     * @example table:album, data:{id:1,name:2}; result:1
     */
    public static int insert(String table, HashMap<String, Object> data)
    {
        Connection conn = null;
        try
        {
            // 取得数据库链接
            conn = getConn();
            return insert(conn, table, data);
        }
        // 发生数据库异常时,可以不捕获
        catch ( SQLException e )
        {
            throw new RuntimeException("DbUtil.insert -> SQLException: " + e.toString());
        }
        finally
        {
            close(conn);
        }
    }


    /**
     * 取得新增的SQL 和 参数列表
     * @param table 表名称
     * @param datalist 数据集
     * @return Object[]{String, ArrayList} 第一个是SQL,第二个是参数列表
     */
    private static Object[] getInsertSQL(String table, HashMap<String, Object> data)
    {
        String sql1 = "insert into " + table + "(", sql2 = ")values(";
        //为空
        if ( data == null || data.isEmpty() || data.size() == 0 )
        {
            throw new RuntimeException("DbUtil.getInsertSQL -> data is Empty!");
        }
        //为空
        if ( table == null || table.length() == 0 )
        {
            throw new RuntimeException("DbUtil.getInsertSQL -> table is Empty!");
        }
        //参数列表
        List<Object> valueList = new ArrayList<Object>();
        //增加参数
        for ( Iterator<Map.Entry<String, Object>> iter = data.entrySet().iterator(); iter.hasNext(); )
        {
            Map.Entry<String, Object> entry = iter.next();
            String key = entry.getKey();
            Object value = entry.getValue();
            //设定系统默认时间,需与其它程序约定这种写法
            if ( "default_type_datetime".equals(StringUtil.toString(value).toLowerCase()) )
            {
            	sql1 += key + ",";
                sql2 += "now(),";
                continue;
            }
            sql1 += key + ",";
            sql2 += "?,";
            valueList.add(value);
        }
        //删除SQL最后的逗号
        sql1 = sql1.substring(0, sql1.length() - 1);
        sql2 = sql2.substring(0, sql2.length() - 1);
        String sql = sql1 + sql2 + ")";
        //传回值
        return new Object[]{sql, valueList};
    }


    /**
     * 批次新增资料; 其中一笔新增失败时,还原处理
     * @param conn 数据库链接
     * @param table 表名称
     * @param datalist 数据集
     * @return int 操作讯息,新增多少笔
     */
    public static int insert(Connection conn, String table, ArrayList<HashMap<String,Object>> datalist)
        throws SQLException
    {
        //记录插入多少笔数据
        int recode = 0;
        //参数列表为空
        if ( datalist == null || datalist.isEmpty() || datalist.size() == 0 )
        {
            throw new RuntimeException("DbUtil.insert -> data is Empty!");
        }

        String sql = "";
        //用字符串类型,而不是Boolean,防止取的时候发生异常
        String autoCommit = "";
        //批次更新,如果多次用同一个SQL,建立PreparedStatement会更高效率
        PreparedStatement pstmt = null;
        try
        {
            // 储存原本的交易送出模式
            autoCommit = ("" + conn.getAutoCommit()).toLowerCase();
            if ( "true".equals(autoCommit) )
            {
                //设定不可 以自动送出
                conn.setAutoCommit(false);
            }

            // 逐行新增
            for ( int i = 0; i < datalist.size(); i++ )
            {
                //取得SQL和参数列表
                Object[] datas = getInsertSQL(table, datalist.get(i));
                String this_sql = (String)datas[0];
                List<Object> valueList = (List)datas[1];
                //当与上一次的SQL相同时,使用上次的PreparedStatement,以提高批次操作的效率
                //不相同时,重新建立PreparedStatement
                if ( false == sql.equals(this_sql) )
                {
                    close(pstmt);
                    sql = this_sql;
                    pstmt = conn.prepareStatement(sql);
                }
                // 传递参数
                putSQLParams(pstmt, valueList);
                // 执行,并记录插入数量
                int efferRows = pstmt.executeUpdate();
                // 如果新增失败
                if ( efferRows < 1 )
                {
                    throw new SQLException("新增失败!!");
                }
                recode += efferRows;
            }

            // 如果原本是自动送出模式,送出交易; 否则让外层来送出
            if ( "true".equals(autoCommit) )
            {
                conn.commit();
            }
        }
        //抛出异常
        catch ( SQLException e )
        {
            rollback(conn);
            //输出异常
            System.out.println("DbUtil.insert -> SQLException:" + e);
            throw e;
        }
        finally
        {
            //关闭 PreparedStatement
            close(pstmt);
            // 还原原本的交易送出模式
            if ( "true".equals(autoCommit) )
            {
                conn.setAutoCommit(true);
            }
        }
        //操作讯息
        return recode;
    }


    /**
     * 更新数据
     * @param conn 数据库链接
     * @param table 表名称
     * @param keyCondition 主键条件; 没有则更新整个表格
     * @param data 数据集
     * @return int 操作讯息(更新的笔数)
     * @example table:album,keyCondition:oid=102,data:{id:1,name:2};result:1
     */
    public static int update(Connection conn, String table, String keyCondition, HashMap<String, Object> data) throws SQLException
    {
        //更新结果
        int result = 0;
        String sql = "update " + table + " set ";
        //table为空
        if ( table == null || table.length() == 0 )
        {
            throw new SQLException("table is Empty!");
        }
        //数据集为空
        if ( data == null || data.isEmpty() || data.size() == 0 )
        {
            throw new SQLException("data is Empty!");
        }
        //参数列表
        List<Object> valueList = new ArrayList<Object>();
        //增加参数
        for ( Iterator<Map.Entry<String, Object>> iter = data.entrySet().iterator(); iter.hasNext(); )
        {
            Map.Entry<String, Object> entry = iter.next();
            String key = entry.getKey();
            Object value = entry.getValue();
            //设定系统默认时间,需与其它程序约定这种写法
            if ( "default_type_datetime".equals(StringUtil.toString(value).toLowerCase()) )
            {
                sql += key + "=now(),";
                continue;
            }
            sql += key + "=?,";
            valueList.add(value);
        }
        //更新
        if ( valueList.size() > 0 )
        {
            sql = sql.substring(0, sql.length() - 1);
            // 有主键条件时,加上
            if ( keyCondition != null && !"".equals(keyCondition) )
            {
                sql += " where " + keyCondition;
            }
            return execute(conn, sql, valueList);
        }
        //操作讯息
        return result;
    }


    /**
     * 更新数据 <br />
     * 建议当仅有一次数据库操作时使用,需多次操作的建议建立 Connection
     * @param table 表名称
     * @param keyCondition 主键条件; 没有则更新整个表格
     * @param data 数据集
     * @return int 操作讯息(更新的笔数)
     * @throws RuntimeException 数据库操作异常,可以不 catch
     * @example table:album,keyCondition:oid=102,data:{id:1,name:2};result:1
     */
    public static int update(String table, String keyCondition, HashMap<String, Object> data)
    {
        Connection conn = null;
        try
        {
            // 取得数据库链接
            conn = getConn();
            return update(conn, table, keyCondition, data);
        }
        // 发生数据库异常时,可以不捕获
        catch ( SQLException e )
        {
            throw new RuntimeException("DbUtil.update -> SQLException: " + e.toString());
        }
        finally
        {
            close(conn);
        }
    }

}
