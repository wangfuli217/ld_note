
一、概述JDBC
    JDBC从物理结构上说就是Java语言访问数据库的一套接口集合。
    从本质上来说就是调用者(程序员)和实现者(数据库厂商)之间的协议。

    JDBC API 使得开发人员可以使用纯Java的方式来连接数据库，并进行操作。
    ODBC：基于C语言的数据库访问接口。
    JDBC：是Java版的ODBC。
    JDBC 特性：高度的一致性、简单性(常用的接口只有4、5个)。

驱动程序按照工作方式分为四类：
    1、JDBC-ODBC bridge + ODBC 驱动
       JDBC-ODBC bridge桥驱动将JDBC调用翻译成ODBC调用，再由ODBC驱动翻译成访问数据库命令。
       优点：可以利用现存的ODBC数据源来访问数据库。
       缺点：从效率和安全性的角度来说的比较差。不适合用于实际项目。
    2、基于本地API的部分Java驱动
       我们应用程序通过本地协议跟数据库打交道。然后将数据库执行的结果通过驱动程序中的Java部分返回给客户端程序。
       优点：效率较高。
       缺点：安全性较差。
    3、纯Java的网络驱动
       (中间协议)            (本地协议)
       app    JDBC     纯Java                 中间服务器               DB
       缺点：两段通信，效率比较差
       优点：安全性较好
    4、纯Java本地协议：通过本地协议用纯Java直接访问数据库。
       特点：效率高，安全性好。

二、JDBC 编程的步骤
        import java.sql.*;
    0.参数化
        String driverName = "com.mysql.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/test"; //协议；库或服务器名称；服务器IP，端口
        String username = "root";
        String password="";
            /* Oracle的连接
            String driverName = "oracle.jdbc.driver.OracleDriver";
            String url = "jdbc:oracle:thin:@192.168.0.23:1521:ora10g";
            SQL Server 的连接
            String driverName = "com.microsoft.jdbc.sqlserver.SQLServerDriver";
            String url = "jdbc:microsoft:sqlserver://127.0.0.1:1433;DatabaseName=test"; */
        //以下这些都需要写在有异常的代码块里，所以需要提取出来。
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;       // 建议用PreparedStatement
    1.加载和注册数据库驱动
        Class.forName(driverName);//自动注册；需要把驱动的jar包导进来；需处理异常
            /*方法二：实例化具体的Driver驱动，这写法一般不用(不能参数化驱动名，不够灵活)
            Driver driver = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(driver); //将驱动交于DriverManager托管*/
            /*方法三：Dos运行时，java -Djdbc.drives = oracle.jdbc.driver.OracleDriver; --可多个 */
    2.连接数据库
        conn = DriverManager.getConnection(url, username, password);//需处理异常
        //Connection返回数据库连接，如：“com.mysql.jdbc.Connection@1ffb8dc”；连接不成功则返回 null
    3.创建Statement对象
        stmt = conn.createStatement();//需处理异常，返回其生成结果的对象
        /*为了类型安全和批量更新的效率，建议用PreparedStatement
         String sql = "insert into tableName values(?,?)"; // "?"占位符
         stmt = conn.prepareStatement(sql); */
    4.操作数据库，执行SQL语句
        String sql = "select * from tableName";//SQL语句里不需要写分号
        rs = stmt.executeQuery(sql); //executeQuery(sqlString) 查询 返回查询结果集
            /* String sql = "insert into tableName values(?,?)"; // "?"占位符
            int number = stmt.executeUpdate(sql);//更新，再返回int(更新、修改影响的条数)
            //executeUpdate(sql) 执行给定 SQL 语句，如 INSERT、UPDATE 或 DELETE 等不返回任何内容的语句*/
       //用PreparedStatement时,已经有语句: rs = stmt.executeQuery();
    5.处理数据(游标)
        StringBuffer sb = new StringBuffer(); //缓存；用它可提高读取速度。当然，不用也可以。
        ResultSetMetaData md = rs.getMetaData(); //ResultSetMetaData可获取列的类型和属性信息
        int col = md.getColumnCount(); //获取列的数目
        while(rs.next()){ //rs.next()使游标下移一位，返回boolean，没有下一个结果则返回false
            for(int i=1; i<=col;i++){ // index(JDBC 的下标从1开始)
                sb.append(md.getColumnName(i)+"="+rs.getString(i)+"  ");
            } sb.append("\n");
        }System.out.println(sb);
            //1.游标的初始位置在第一条记录的前面，使第一次调用next()后，刚好拿到第一个结果。
            //2.游标的最终位置在最后一条记录的后面(结果集的前面和后面留空，真正存在)
    6.释放资源，断开与数据库的连接
        //先判断是否有引用资源，再释放(释放空资源会抛异常)；注意顺序
        if(rs!=null)try{rs.close();}catch(Exception e){e.printStackTrace();}
        if(stmt!=null)try{stmt.close();}catch(Exception e){e.printStackTrace();}
        if(conn!=null)try{conn.close();}catch(Exception e){e.printStackTrace();}
        //这些异常没法处理，处理只为方便调试。所以这些异常处理也只是打印。
        /*要按先ResultSet结果集，后Statement，最后Connection的顺序关闭资源，
        因为ResultSet需要Statement和Connection连接时才可以用的；Statement也需要Connection才可用；
        结束Statement之后有可能其它的Statement还需要连接，因此不能先关闭Connection。ResultSet同理。*/

    步骤 1、2、6 每次都一样，可以重构。
       因为加载驱动是个一次性工作，所以可以采用静态初始化块来加载驱动；
       连接数据库的方法应该自己负责，获取数据库连接信息和驱动的信息，并处理相关异常；
       释放数据库资源的方法要考虑到ResultSet、Statement、Connection的不同情况，并处理相关异常。

       使用 preparedStatement 的例子：
/*************************************/
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
public class test{
     public static void main(String[] args) {
            String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
            String url = "jdbc:odbc:URIAGE";
            String username = "root";
            String password = "root";
            Connection con = null;
            PreparedStatement stmt = null;
        try{
            Class.forName(driverName);
            con = DriverManager.getConnection(url,username,password);
            String query = "insert into tableName(col1,col2,col3) values (?,?,?)";
            stmt = con.prepareStatement(query);
            //在数组中增加数据
            String col1[] = {"10","20","30"};
            String col2[] = {"01","02","03"};
            int col3[] = {100,200,300};
            //添加数据
            for(int i=0; i<col1.length; i++){
                stmt.setString(1, col1[i]);
                stmt.setString(2, col2[i]);
                stmt.setInt(3, col3[i]);
                stmt.executeUpdate();
            }
        } catch (Exception e){
            e.printStackTrace();
        } finally {
            if(stmt!=null)try{stmt.close();}catch(Exception e){e.printStackTrace();}
            if(con!=null)try{con.close();}catch(Exception e){e.printStackTrace();}
}}}
/*************************************/


三、JDBC几个重要接口重点讲解
    在JDBC 中包括了两个包：java.sql和javax.sql。
        ① java.sql   基本功能。
           这个包中的类和接口主要针对基本的数据库编程服务，如生成连接、执行语句以及准备语句和运行批处理查询等。
           同时也有一些高级的处理，比如批处理更新、事务隔离和可滚动结果集等。
        ② javax.sql  扩展功能。
           它主要为数据库方面的高级操作提供了接口和类。
           如为连接管理、分布式事务和旧有的连接提供了更好的抽象，它引入了容器管理的连接池、分布式事务和行集等。

        API                        说明
    Connection            与特定数据库的连接(会话)。能够通过getMetaData方法获得数据库提供的信息、
                          所支持的SQL语法、存储过程和此连接的功能等信息。代表了数据库。
    Driver                每个驱动程序类必需实现的接口，每个数据库驱动程序也都应该提供一个实现Driver接口的类。
    DriverManager(Class)  管理一组JDBC驱动程序的基本服务。作为初始化的一部分，此接口会尝试加载
                          在”jdbc.drivers”系统属性中引用的驱动程序。只是一个辅助类，是工具。
    Statement             用于执行静态SQL语句并返回其生成结果的对象。
    PreparedStatement     继承Statement接口，表示预编译的SQL语句的对象，SQL语句被预编译并且存储
                          在PreparedStatement对象中。然后可以使用此对象高效地多次执行该语句。
    CallableStatement     用来访问数据库中的存储过程。它提供了一些方法来指定语句所使用的输入/输出参数。
    ResultSet             指的是查询返回的数据库结果集。
    ResultSetMetaData     可用于获取关于ResultSet对象中列的类型和属性信息的对象。
    注：除了标出的Class,其它均为接口。每个都是“java.sql.”包下的。


    1. Statement  —— SQL语句执行接口
       代表了一个数据库的状态，在向数据库发送相应的SQL语句时，都需要创建Statement接口或PreparedStatement接口。
       在具体应用中，Statement主要用于操作不带参数(可以直接运行)的SQL语句，比如删除语句、添加或更新。

    2. PreparedStatement:预编译的Statement
        第一步：通过连接获得PreparedStatement对象，用带占位符(?)的sql语句构造。
            PreparedStatement  pstm = con.preparedStatement(“select * from test where id=?”);
        第二步：设置参数
            pstm.setString(1，“ganbin”);//第一个字段是“ganbin”；需一个个字段写
        第三步：执行sql语句
            Rs  =  pstm.excuteQuery();
        statement发送完整的Sql语句到数据库不是直接执行而是由数据库先编译，再运行。每次都需要编译。
        而PreparedStatement是先发送带参数的Sql语句，由数据库先编译，再发送一组组参数值。(同构时不需重复编译)
        如果是同构的sql语句，PreparedStatement的效率要比statement高。而对于异构的sql则两者效率差不多。
        一般都用PreparedStatement代替Statement，因为它是类型安全的。Statement对参数类型不作检查，故不够安全。
            同构：两个Sql语句可编译部分是相同的，只有参数值不同。
            异构：整个sql语句的格式是不同的
        注意点：1、使用预编译的Statement编译多条Sql语句一次执行
              2、可以跨数据库使用，编写通用程序
              3、能用预编译时尽量用预编译
              4、如果第二个SQL语句与前一个是异构的，需要再次编译“ps = con.prepareStatement(sql);“

    3. ResultSet —— 结果集操作接口
       ResultSet接口是查询结果集接口，它对返回的结果集进行处理。ResultSet是程序员进行JDBC操作的必需接口。

    4. ResultSetMetaData —— 元数据操作接口
       ResultSetMetaData是对元数据进行操作的接口，可以实现很多高级功能。
       Hibernate运行数据库的操作，大部分都是通过此接口。可以认为，此接口是SQL查询语言的一种反射机制。
       ResultSetMetaData接口可以通过数组的形式，遍历数据库的各个字段的属性，对于开发者来说，此机制的意义重大。

       JDBC通过元数据(MetaData)来获得具体的表的相关信息，例如，可以查询数据库中有哪些表，表有哪些字段，以及字段的
       属性等。MetaData中通过一系列getXXX将这些信息返回给我们。
       数据库元数据 Database MetaData 用connection.getMetaData()获得；包含了关于数据库整体元数据信息。
       结果集元数据 ResultSet MetaData 用resultSet.getMetaData()获得;比较重要的是获得表的列名,列数等信息。
                结果集元数据对象：ResultSetMetaData meta = rs.getMetaData();
                字段个数：meta.getColomnCount();
                字段名字：meta.getColumnName();
                字段JDBC类型：meta.getColumnType();
                字段数据库类型：meta.getColumnTypeName();

       数据库元数据对象：DatabaseMetaData dbmd = con.getMetaData();
                数据库名：dbmd.getDatabaseProductName();
                数据库版本号：dbmd.getDatabaseProductVersion()；
                数据库驱动名：dbmd.getDriverName()；
                数据库驱动版本号：dbmd.getDriverVersion()；
                数据库Url：dbmd.getURL()；
                该连接的登陆名：dbmd.getUserName()；

四、JDBC 中使用Transaction编程(事务编程)
     1. 事务是具备以下特征(ACID)的工作单元：
        原子性(Atomicity)—— 如果因故障而中断，则所有结果均被撤消；
        一致性(Consistency)—— 事务的结果保留不变；
        孤立性(Isolation)—— 中间状态对其它事务是不可见的；
        持久性(Durability)—— 已完成的事务结果上持久的。
        原子操作，也就是不可分割的操作，必须一起成功一起失败。

     2. 事务处理三步曲：(事务是一个边界)
        ① connection.setAutoCommit(false); //把自动提交关闭；在创建Statement对象之前。
        ② 正常的DB操作                       //若有一条SQL语句失败了，自动回滚
        ③ connection.commit()              //主动提交
        和 connection.rollback()            //主动回滚，一般写在catch语句里，而前三个都写在try语句里

/*********事务的代码片段：*************/
try{
    con.setAutoCommit(false);   //step① 把自动提交关闭
    Statement stm = con.createStatement();    //step② 正常的DB操作
    stm.executeUpdate("insert into person(id, name, age) values(520, 'X-Man', 18)");
    stm.executeUpdate("insert into Person(id, name, age) values(521, 'Super', 19)");
    con.commit();               //step③ 成功主动提交
} catch(SQLException e){
    try{con.rollback();        //如果中途发生异常，则roolback；这语句也会抛异常
    }catch(Exception e){e.printStackTrace();}    //step③ 失败则主动回滚
}
/************************************/

     3.JDBC事务并发产生的问题和事务隔离级别(难，建议用例子学习)
     JDBC事务并发产生的问题:
        ① 脏读(Dirty Reads) 一个事务读取了另一个并行事务还未提交的数据。(产生原因：读-写)
        ② 不可重复读(UnPrpeatable Read)一个事务前后两次读取数据时,得到的数据不一致,被另一个已提交的事务修改。
        ③ 幻读(Phantom Read) 一个事务再次查询，记录中的量变化了。(仅对统计有影响)
     为了避免以上三种情况的出现，则采用事务隔离级别:
        TRANSACTION_NONE                不使用事务(不可能用，只是理论的)
        TRANSACTION_READ_UNCOMMITTED    可以读取未提交数据(允许脏读，也不可能)
        TRANSACTION_READ_COMMITTED      只读提交的数据：可防止脏读；大部分数据库的默认隔离级别
        TRANSACTION_REPEATABLE_READ     重复读取；只可以避免脏读
        TRANSACTION_SERIALIZABLE        事务串行化：可以避免脏读，重复读取和幻读，但会降低数据库效率(最常用)
     以上的五个事务隔离级别都是在Connection类中定义的静态常量。隔离级别越高，数据越安全，并发能力越差。
     使用setTransactionIsolation(int level) 方法可以设置事务隔离级别。
        比如：con.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);

五、JDBC 2.0新特性：
    1、 Scrollability 结果集可滚动
        滚动：可双向支持绝对与相对滚动，对结果集可进行多次迭代。
            Con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
            //上句的 SCROLL 再到 CONCUR；不可以写反，编译器无法检测到，因为他们都是int类型的。
        TYPE_FORWARD_ONLY：(单向，一般不用)该常量指示指针只能向前移动的 ResultSet 对象的类型。
        TYPE_SCROOL_INSENSITIVE：(双向、不敏感)可滚动但不受其他更改影响的 ResultSet 对象的类型。
        TYPE_SCROLL_SENSITIVE：(双向、敏感)该常量指示可滚动并且通常受其他的更改影响的 ResultSet 对象的类型。
        CONCUR_READ_ONLY：(只读)该常量指示只可以读取的 ResultSet 对象的并发模式。
        CONCUR_UPDATABLE：(可更新)该常量指示可以更新的 ResultSet 对象的并发模式。

        绝对定位：boolean absolute(int row)将游标移动到指定位置。(row指记录的序号，没有这位置则返回false)
                void afterLast() 将游标指向最后一条记录的后一位(有这位置，但记录为空)。
                void beforeFirst()将游标指向最前一条记录的前一位。
                boolean first()将游标移动到结果集最前。
                boolean last()将游标移动到结果集末尾。
        相对定位：boolean next()指向下一个。
                boolean previous()指向前一个。
                boolean relative(int) 向next()方向移动 int 位(int 可负)。
        判位函数：boolean isAfterLast() 是否在最后一条的后一位。
                boolean isBeforeFirst() 是否最前一条记录的前一位。
                boolean isFirst() 是否最前位置。
                boolean isLast() 是否最后位置。

    2、 Updatability 结果集可更新。(主要应用于桌面应用)
        更新：rs.updateString(“name”,”Tony”);//前面一个是字段的名字或者序号
        rs.updateInt(1,”122323”);修改
        rs.deleteRow();删除
        rs.updateRow();
     注：只有在必要的时候(如桌面应用)才用结果集更新数据库，因为使用结果集更新数据库效率低下。
        可更新结果集还要看数据库驱动程序是否支持，如Oracle就支持，MySql不支持。
        并且只能针对一张表做结果集更新(不能子查询)。而且不能有join操作。
        必须有主健，必须把所有非空没有默认值的字段查出。
        处理可更新结果集时不能用select *来查询语句，必须指出具体要查询的字段。(不能使用通配符)

    3、 Batch updates 可批量更新。
        将多组对数据库的更新操作发送到数据库统一执行(数据库支持并发执行操作)，以提高效率。
        主要是通过减少数据(Sql语句或参数)在网络上传输的次数来节省时间。//数据有两组以上都应该用这批量更新

        (1)对于Statement的批量更新处理：
            stm.addBatch(Sql);
            int[] ResultSet=stm.executeBatch();

        (2)对于PreparedStatement的批量更新处理
             pstm.setInt(1,12);pstm.setString(2,”gaga”);……..
             pstm.addBatch();
             if(i%100==0) int[] ResultSet=pstm.executeBatch();//每个包50～200组数据，包太大也影响速度

        注：int[] 中每一个数表示该Sql语句影响到的记录条数。
        PreparedStatement的更新操作比Statement的更新操作多了一个设置参数的过程。

六、SQL 3.0规范中的新类型：
        Blob，大的二进制数据文件，最多存储2G。
        Clob，大文本文件对象，最多存储2G。
    在使用上述大对象的时候，在使用JDBC插入记录时要先插入一个空的占位对象，
        "insert into tableName valuse(?,?,empty_blob())"//在数据库制造一个空的blob对象字段值
        然后使用"select blobdata from t_blob where id = ? for update"对获得的大对象进行实际的写入操作
        Blod通过getBinaryOutputStream()方法获取流进行写入。
        getBinaryStream()方法获得流来获取Blob中存储的数据。
    Clob的操作也和、Blob相同。
        getAsciiStream()用于读取存储的文本对象，getAsciiOutputStream()方法之获得流用来向文件对象写入的。

    BLOB与CLOB的异同点：
        ① 都可以存储大量超长的数据；
        ② BLOB (Binary Large Object) 以二进制格式保存，特别适合保存图片、视频文件、音频文件、程序文件等；
        ③ CLOB (Character Large Object) 以Character格式保存于数据库中，适合保存比较长的文本文件。

七、JDBC 2.0扩展
    （一）JNDI（命名目录服务器）:
        定义:是Java的命名目录服务器。而JDBC是Java的数据库访问接口。
            跟JDBC是平级的关系，是两个独立的JNDI；JDBC存储的数据都是以二维表的接口来大规模存储数据。
            而JNDI存储的是差异性比较大的Java对象。JDBC取数据时用Sql语言访问数据。JNDI只用lookup和bind读写
            JDBC API依赖于驱动程序，而JNDI依赖于服务提供者。
            JDBC一般把数据存储到关系型数据库，而JNDI一般把数据存储到小型数据库、文件、甚至是注册表中。
            JNDI相当于一个电话本。允许程序将一个对象和一个命名绑定到目录树上。
               (JNDI的方法是在javax.naming包下，接口是Context实现类是InitialContext)

        bind(String name, Object obj) 将名称绑定到对象资源，建立指定的字符串和对象资源的关联
        lookup(String name) ，通过指定的字符串获得先前绑定的资源

        /*********以下是将资源和JNDI命名绑定的方法**************/
        public static void bind(String context, Object obj) throws NamingException{
            Properties pro = new Properties();
            //Weblogic的JNDI服务器参数
        pro.put(InitialContext.INITIAL_CONTEXT_FACTORY,"weblogic.jndi.WLInitialContextFactory");
            pro.put(InitialContext.PROVIDER_URL, "t3://localhost:7001");
            Context ctx = new InitialContext(pro);//连接服务器
            ctx.bind(context, obj);//存储
        }

    （二）DataSourse（数据源）
        1、包含了连接数据库所需的信息，可以通过数据源获得数据库连接，
           有时由于某些连接数据库的信息会变更，所以经常使用包含数据库连接信息的数据源。
        2、一个标准的数据库连接工厂，作为DriverManager的替代项，保存与数据库相关的信息，
           可以将数据库的连接信息放在一个共享的空间进行提取，不用在本地安装。
           支持JNDI的绑定，支持连接池，支持分布式服务，用getConnection方法可获得与数据库的连接。
           数据源应该由管理员创建（目的是为了保证数据库的安全）。所以数据源对象一般放在JNDI服务器中。

        /*********通过JNDI获得绑定的资源**************/
        public static Object lookup(String context) throws NamingException{
            Properties pro = new Properties();
            //Weblogic的JNDI服务器参数
        pro.put(InitialContext.INITIAL_CONTEXT_FACTORY,"weblogic.jndi.WLInitialContextFactory");
            pro.put(InitialContext.PROVIDER_URL, "t3://localhost:7001");
            Context ctx = new InitialContext(pro);
            return ctx.lookup(context);//查找；通过指定的字符串获得先前绑定的资源。
        }

    （三）连接池：
        在内存中用来保存一个个数据库连接的对象。
        访问数据库时，建立连接和拆连接需要花费较长时间，通过以连接池直连的方式获取连接，不需要注册驱动程序，可以大量
        的节省销毁和创建连接的资源消耗，提高访问数据库的效率。
     注：通过连接池获得的Connection，当执行con.close()时，不是关闭连接，而是表示将连接释放回连接池。
         连接池是一个很复杂的算法，由服务器厂商实现。

    （四）分布式的事务管理器JTA
        分布式事务是通过多个异地数据库执行一组相关的操作，要保证原子操作的不可分，
        也不用再自己写commit，和rollback，全部都交给中间服务器(TM)来处理。
        （两阶段提交），也就是在中间服务器发送sql语句等待数据库回应，都回应操作成功才提交，否则同时回滚。
                         ----------------   commit
            con1 ------->| TM(事务管理器) | -----------> DB1
            con2 ------->|    commit    | -----------> DB2
                         ----------------   commit
        1、regester
        2、TM->execute()
        3、commit->TM
        4、TM->commit->DB

    （五）RowSet
                行集，这是一个JavaBean（事件机制），它增强了ResultSet的功能，包装了Connection、Statement、
        ResultSet、DriverManage。通过RowSet可以获得数据源，设置隔离级别，也可以发送查寻语句，也实现了离线的操
        作遍历，RowSet也支持预编译的Statement。是结果集的子接口，为快速开发而设(目前还不够成熟，没人用)。
        RowSet中的方法大致上和ResultSet相同，当需要使用时请查阅JAVA API参考文档。

八、JDBC应用的分层(DAO)
    分层就是对功能的隔离，降低层与层之间的耦合性。

    软件的分层初步：
        JSP          Struts
      View(界面) --> Controlle --> Atio ---> Service/Biz --> DAO ---->  DB
       重新封装        可复用       封装信息      懂业务逻辑    数据访问层    数据层
                                  调业务       无技术难度    与业务无关
    谁依赖谁就看谁调用谁。
    软件的分层设计，便于任务的划分、降低层间的耦合。
    结合PMS的设计方法，思考这样分层的好处。
    并且，使代码尽量减少重复，可复用性好，扩展余地加大，而且尽量减少硬编码。
    需求：实现对Person类的数据库持久化基本操作（CRUD）。

    BS架构和CS架构：
    C－S架构：两层体系结构，主要应用于局域网中。
    B－S架构：三层体系结构，表现层＋业务逻辑层＋数据存储层
         注：层面越多，软件越复杂，但更灵活。分层是必须的但是要有个度。
            层次一但确定，数据必须按层访问，不能跨层访问。
            层与层之间最好时单向依赖（单向调用）。

    纵向划分：按功能划分。分成三层体系结构(也有两层的)。
    横向划分：按抽象划分。分成抽象部分和实现部分。



============================================
一、JDBC异常处理：
   JDBC中，和异常相关的两个类是SQLException和SQLWarning。
      1.SQLException类：用来处理较为严重的异常情况。
        比如：① 传输的SQL语句语法的错误；
             ② JDBC程序连接断开；
             ③ SQL语句中使用了错误的函数。
        SQLException提供以下方法：
          getNextException() —— 用来返回异常栈中的下一个相关异常；
          getErrorCode() —— 用来返回代表异常的整数代码 (error code)；
          getMessage() —— 用来返回异常的描述信息 (error message)。

      2.SQLWarning类：用来处理不太严重的异常情况，也就是一些警告性的异常。
        其提供的方法和使用与SQLException基本相似。

    结合异常的两种处理方式，明确何时采用哪种。
      A. throws        处理不了，或者要让调用者知道;
      B. try … catch   能自行处理，就进行异常处理。

二、JavaBean的定义：
    1、是一个普通的Java类
    2、在结构上没有预先的规定，不需要容器，不需要继承类或实现接口
    3、要求必须放在包中，要求实现Serializable接口
    4、要求有一个无参的构造方法.
    5、属性的类型必须保持唯一，get方法返回值必须和set方法参数类型一致
    6、对每个属性要有对应的get和set方法。注：隐藏属性可以没有
    7、可以有外观作为显示控制，事件机制。

三、SQL数据类型及其相应的Java数据类型
   SQL数据类型             Java数据类型              说明
  ---------------------------------------------------------------------------------------
   INTEGER或者INT            int               通常是个32位整数
   SMALLINT                 short             通常是个16位整数
   NUMBER(m,n)            Java.sql.Numeric    合计位数是m的定点十进制数，小数后面有n位数
   DECIMAL(m,n)              同上
   DEC(m,n)               Java.sql.Numeric    合计位数是m的定点十进制数，小数后面有n位数
   FLOAT(n)                  double           运算精度为n位二进制数的浮点数
   REAL                      float            通常是32位浮点数
   DOUBLE                    double           通常是64位浮点数
   CHAR(n)                   String           长度为n的固定长度字符串
   CHARACTER(n)              同上
   VARCHAR(n)                String           最大长度为n的可变长度字符串
   BOOLEAN                   boolean          布尔值
   DATE                   Java.sql.Date       根据具体设备而实现的日历日期
   TIME                   Java.sql.Time       根据具体设备而实现的时戳
   TIMESTAMP              Java.sql.Timestamp  根据具体设备而实现的当日日期和时间
   BLOB                   Java.sql.Blob       二进制大型对象
   CLOB                   Java.sql.Clob       字符大型对象
   ARRAY                  Java.sql.Array

四、 面向对象的数据库设计
    类的关联，继承在数据库中的体现：
      类定义―――>表定义
      类属性―――>表字段
      类关系―――>表关系
      对  象―――>表记录
    注： Oid（对象id）―――>业务无关
        在数据库中每一条记录都对应一个唯一的id；
        Id通常是用来表示记录的唯一性的，通常会使用业务无关的数字类型
        字段的个数不会影响数据库的性能，表则越多性能越低。

    （一）类继承关系对应表，
        1、 为每一个类建一张表。通过父类的Oid来体现继承关系。
            特点：在子类表中引用父类表的主建作为自己的外建。
            优点：方便查询。属性没有冗余。支持多态。
            缺点：表多，读写效率低。生成报表比较麻烦。
        2、 为每一个具体实现类建一个表
            特点：父类的属性被分配到每一个子类表中。
            优点：报表比较容易
            缺点：如果父类发生改变会引起所有子类表随之更改。并且不支持多态。数据有少量冗余。
        3、 所有的类在一张表中体现，加一个类型辨别字段
            特点：效率高，查询不方便，用于字段不多时。
            优点：支持多态，生成报表很简单。
            缺点：如果任何一个类发生变化，必须改表。字段多，难以维护。

    （二）类关联关系对应表
        1、 一对一关联，类关系对应成表时有两种做法：
            一是引用主键，也就是一方引用另一方的主键既作为外键有作为自身的主键。
            二是外键引用，一方引用另一方的主键作为自身的外键，并且自己拥有主键。
        2、 一对多关联，也就是多端引用一端的主键当作外键，多端自身拥有主键。
        3、 多对多关系，多对多关系是通过中间表来实现的，中间表引用两表的主键当作联合主键，就可以实现多对多关联。


