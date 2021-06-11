
数据库连接
    cx_Oracle : 是一个用来连接并操作 Oracle 数据库的 Python 扩展模块， 支持包括 Oracle 9.2 10.2 以及 11.1 等版本。
      安装：
        需先oracle安装客户端，并配置环境变量：
            ORACLE_HOME＝D:\Oracle\Ora81
            PATH=D:\Oracle\Ora81\bin;(其他path的地址)
        下载 cx_Oracle 安装包： http://www.python.net/crew/atuining/cx_Oracle/

      Oracle 示例：
        import cx_Oracle
        print(cx_Oracle.version) # 打印出版本信息
        # 建立连接, 3种不同写法
        conn = cx_Oracle.connect('username/pwssword@localhost:1521/db_name') # 参数连写
        conn = cx_Oracle.connect('username', 'pwssword', 'ip_address:1521/db_name') # 分开3个参数写
        dsn_tns = cx_Oracle.makedsn('localhost', 1521, 'db_name')
        conn = cx_Oracle.connect('username', 'pwssword', dsn_tns) # 分开5个参数写


    MySQLdb   : MySQL 数据库的 Python 扩展模块
        import MySQLdb
                下载地址(tar安装包)： http://sourceforge.net/projects/mysql-python
                 (exe安装文件) http://www.lfd.uci.edu/~gohlke/pythonlibs/

    mongodb:
        下载数据库安装文件： http://www.mongodb.org/downloads
        import pymongo


    其他数据库：
    postgresql PostgreSQL psycopg version 1.x, http://initd.org/projects/psycopg1
    postgresql_psycopg2 PostgreSQL psycopg version 2.x, http://initd.org/projects/psycopg2
    sqlite3 SQLite No adapter needed if using Python 2.5+ Otherwise, pysqlite, http://initd.org/tracker/pysqlite
    ado_mssql Microsoft SQL Server adodbapi version 2.0.1+, http://adodbapi.sourceforge.net/

     MySQL 示例：
        # 0. 导入模块(如果导入出错，说明安装驱动不成功)
        import MySQLdb
        import MySQLdb.cursors

        # 1. 数据库联结，默认host为本机, port为3306(各数据库的连接写法有所不同)
        conn = MySQLdb.connect(host="localhost", port=3306, user="root", passwd="root", db="testdb", unix_socket='/tmp/mysql.sock', charset='utf8')
        # conn = MySQLdb.Connection(host="localhost", port=3306, user="root", passwd="root", db="testdb") # 与上句一样
        # 加上参数 cursorclass=MySQLdb.cursors.DictCursor, 则查询的返回结果是 dict 类型,键是字段名(更方便查询)
        # conn = MySQLdb.Connection(host="localhost", port=3306, user="root", passwd="root", db="testdb", cursorclass=MySQLdb.cursors.DictCursor)

        # 2. 选择数据库(如果前面还没有选择数据库的话)
        conn.select_db('database name')

        # 3. 获得cursor
        cursor = conn.cursor()

        # 4.1 执行SQL，查询和增删改都这样写； 查询返回查询结果的行数，增删改返回影响的行数
        cursor.execute("SELECT * FROM tb_member")

        # 4.1.1. cursor位置设定及读取结果(仅查询时可这样用)
        # cursor.scroll(int, mode) # mode可为相对位置或者绝对位置，分别为relative和absolute。
        cursor.scroll(0)

        # 4.1.2. Fetch 及 获取结果(每次Fetch,结果集都会下移,下次获取的是剩下的结果集，除非再 cursor.scroll() 移动结果集)
        print(cursor.fetchone()) # 获取对应位置的资料,返回一个一维元组,读取不到则返回 None, 打印如：(1L, 'stu1', 'm')
        print(cursor.fetchall()) # 返回结果是个二维元组(所有结果),读取不到则返回一个空元组, 打印如：((1L, 'stu1', 'm'), (2L, 'stu2', 'f'))

        # 4.2 execute SQL, 返回影响的行数
        rows = cursor.execute("delete from tb_member where memid=2")
        print(rows) # 返回影响的行数(整数类型), 打印如：1

        # 5. 关闭连接
        cursor.close()
        conn.close()
