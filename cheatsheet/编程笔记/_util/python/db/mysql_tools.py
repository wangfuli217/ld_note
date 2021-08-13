# -*- coding: utf-8 -*-

import logging

import MySQLdb # 需安装第三方插件 MySQLdb
import MySQLdb.cursors
from DBUtils.PooledDB import PooledDB # 需安装第三方插件 DBUtils


# 数据库配置
DB_CONFIG = {
     'mincached':2,
     'maxcached':5,
     'maxshared':0,
     'maxconnections':100,
     'host':'127.0.0.1',
     'port':3306,
     'user':'root',
     'passwd':'guoling2013',
     'db': 'EXEC_DB',
     'charset':'utf8',
     }


# 数据库线程池
dbpool = PooledDB(MySQLdb, cursorclass=MySQLdb.cursors.DictCursor, **DB_CONFIG)


def select(sql, fetchall=True, param=None):
    '''查询SQL结果
    @param {string} sql: 要查询的 SQL 语句
    @param {bool} fetchall: 返回所有的查询结果则为 True, 否则只返回第一条结果
    @param {tuple|dict} param: 参数列表,或者参数字典
    @return {tuple<dict> | dict}:
        当 参数fetchall 为 True 时, 返回SQL查询结果集,查不到是返回空的 tuple
        当 参数fetchall 为 False 时, 返回SQL查询的结果(dict类型),查不到返回 None
    @example
        results = select("SELECT * FROM product_log WHERE flag=%s AND v=%s", param=('n','1.2.0',))
        或者 results = select("SELECT * FROM product_log WHERE flag=%(flag)s AND v=%(v)s", param={'flag':'n', 'v':'1.2.0'})
    '''
    try:
        conn = None
        cur = None
        logging.debug(sql)
        conn = dbpool.connection()
        cur = conn.cursor()
        if not param:
            cur.execute(sql)
        else:
            cur.execute(sql, param)
        if fetchall:
            return cur.fetchall()
        else:
            return cur.fetchone()
    except:
        logging.error(u"查询失败:%s, %s" % (sql, param))
        raise u"数据库查询异常:%s, %s" % (sql, param)
        #return  tuple() if fetchall else None
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

def execute(sql, param=None, clash=1):
    '''执行SQL语句(增删改操作)
    @param {string} sql: 要执行的 SQL 语句
    @param {tuple|dict} param: 参数列表,或者参数字典
    @param {int} clash: 发生主键冲突,或者唯一键冲突时的返回值,默认1
    @return {int}: 返回执行SQL影响的行数(插入则返回新增的主键值/影响行数),执行有异常时返回 None
    @example
        row = execute("INSERT INTO product_log(uid,v) VALUES (%s,%s)", (20125412, '1.2.3', ))
        或者 row = execute("INSERT INTO product_log (uid,v) VALUES (%(uid)s, %(v)s)", {'uid':20125412, 'v':'1.2.3'})
    '''
    try:
        conn = None
        cur = None
        logging.info("%s, %s" % (sql, param))
        conn = dbpool.connection()
        cur = conn.cursor()
        if not param:
            row = cur.execute(sql)
        else:
            row = cur.execute(sql, param)
        # 插入,返回主键
        if sql.strip().lower().startswith('insert '):
            row = cur.lastrowid or row # 如果表没有主键,则 lastrowid 会为0
        else:
            row = cur.rowcount # 其实这行不写也行,前面已经返回了影响行数
        conn.commit()
        return row
    #主键冲突,或者唯一键冲突,重复insert,忽略错误
    except MySQLdb.IntegrityError:
        logging.error(u"主键冲突:%s, %s" % (sql, param))
        return clash
    except:
        logging.error(u"执行失败:%s, %s" % (sql, param))
        conn.rollback()
        raise u"数据库更新失败:%s, %s" % (sql, param)
        #return 0
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

def executes(sql_list):
    '''执行多条SQL语句，并且是一个原子事件(任何一条SQL执行失败，或者返回结果为0，都会全体回滚)
    @param {list<tuple<string,dict>>} sql_list: 形式为 [(sql1, param1),(sql2, param2),(sql3, param3),...]
    @return {int}: 返回执行SQL影响的行数,执行有异常时返回 None
    '''
    try:
        conn = None
        cur = None
        conn = dbpool.connection()
        cur = conn.cursor()
        row = 0
        for sql, param in sql_list:
            logging.info("%s, %s" % (sql, param))
            try:
                if not param:
                    this_row = cur.execute(sql)
                else:
                    this_row = cur.execute(sql, param)
            except MySQLdb.IntegrityError:
                logging.error(u"主键冲突:%s, %s" % (sql, param))
                #主键冲突,重复insert,忽略错误
                this_row = 1
            if this_row <= 0:
                raise u'其中一条执行失败:%s, %s' % (sql, param)
            row += this_row
        conn.commit()
        return row
    except:
        logging.error(u"执行失败:%s" % sql_list)
        conn.rollback()
        raise u"数据库更新失败:%s" % sql_list
        #return 0
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

def executemany(sql, param, clash=1):
    '''执行SQL语句(增删改操作), 同一个SQL语句,执行不同的多个参数
    @param {string} sql: 要执行的 SQL 语句
    @param {tuple|dict} param: 参数列表,或者参数字典
    @param {int} clash: 发生主键冲突,或者唯一键冲突时的返回值,默认1
    @return {int}: 返回执行SQL影响的行数(插入则返回新增的主键值/影响行数),执行有异常时返回 None
    @example
        row = executemany("INSERT INTO product_log(uid,v) VALUES (%s,%s)", [(20125412, '1.2.3', ),(20125413, '2.0.3', ),(56721, '2.32.3', )])
        或者 row = executemany("INSERT INTO product_log (uid,v) VALUES (%(uid)s, %(v)s)", [{'uid':20125412, 'v':'1.2.3'},{'uid':56721, 'v':'2.32.3'}])
    '''
    try:
        conn = None
        cur = None
        logging.info("%s, %s" % (sql, param))
        conn = dbpool.connection()
        cur = conn.cursor()
        if not param:
            row = cur.executemany(sql)
        else:
            row = cur.executemany(sql, param)
        conn.commit()
        return row
    #主键冲突,或者唯一键冲突,重复insert,忽略错误
    except MySQLdb.IntegrityError:
        logging.error(u"主键冲突:%s, %s" % (sql, param))
        return clash
    except:
        logging.error(u"执行失败:%s, %s" % (sql, param))
        conn.rollback()
        raise u"数据库更新失败:%s, %s" % (sql, param)
        #return 0
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()


def query_data(table, condition=None, fetchall=True):
    '''查询一个表
    @param {string} table: 要查询的表的名称(注意:表名的前缀"t_"也要求写,如果有的话)
    @param {dict} condition: 要查询的条件
    @param {bool} fetchall: 返回所有的查询结果则为 True, 否则只返回第一条结果
    @return {tuple<dict>}: 返回SQL查询结果集,查不到是返回空的tuple
    @example
        results = query_data('service_conf', {"bid":333, "category":"cc"})
        实际执行: SELECT * FROM service_conf WHERE bid=333 AND category ='cc'
    '''
    sql = "SELECT * FROM %s " % table
    if condition:
        condition_sql = format_sql(' AND ', condition)
        sql += " WHERE %s" % (condition_sql)
    rows = select(sql, fetchall)
    return rows

def add_data(table, params, clash=1):
    '''插入数据到一个表
    @param {string} table: 要插入的表的名称(注意:表名的前缀"t_"也要求写,如果有的话)
    @param {dict} params: 要插入的内容
    @param {int} clash: 发生主键冲突,或者唯一键冲突时的返回值,默认1
    @return {int}: 返回执行SQL新增的主键值/影响行数
    @example
        rows = add_datas('goods_log', {'bid':333,'orderid':"e'ee"})
        实际执行: INSERT INTO goods_log (bid, orderid) VALUES (333, 'e''ee')
    '''
    sql = add_sql(table, params)
    row = execute(sql, clash=clash)
    return row

def add_datas(table_list):
    '''一起插入多个语句,原子操作，其中任意一个操作语句失败都会全体回滚
    @param {list<tuple<string,dict>>} table_list: 形式为 [(table_name1, param1),(table_name2, param2),(table_name3, param3),...]
    @return {int}: 返回总的影响行数
    @example
        rows = add_datas([('goods_log',{'bid':'333','orderid':"e''ee"}),('product_log',{'bid':'444','orderid':u"哎f'f"})])
    '''
    sql_list =  []
    for table, params in table_list:
        sql = add_sql(table, params)
        sql_list.append((sql, None,))
    row = executes(sql_list)
    return row

def del_data(table, condition):
    '''删除一个表的数据
    @param {string} table: 要删除数据的表的名称(注意:表名的前缀"t_"也要求写,如果有的话)
    @param {dict} condition: 要删除的条件,必须传此参数
    @return {int}: 返回执行SQL影响的条数
    @example
        rows = del_data('goods_log', {'bid':333,'orderid':"eee"})
        实际执行: DELETE FROM goods_log WHERE  bid=333 AND orderid ='eee'
    '''
    if not condition:
        return 0
    condition_sql = format_sql(' AND ', condition)
    sql = "DELETE FROM %s WHERE %s" % (table, condition_sql)
    row = execute(sql)
    return row

def update_data(table, params, condition):
    '''修改一个表的数据
    @param {string} table: 要修改数据的表的名称(注意:表名的前缀"t_"也要求写,如果有的话)
    @param {dict} params: 要修改的数据,必须传此参数
    @param {dict} condition: 要修改的条件,必须传此参数
    @return {int}: 返回执行SQL影响的条数
    @example
        rows = update_data('goods_log', {'bid':333,'orderid':"eee"}, {'id':223})
        实际执行: UPDATE goods_log SET bid=333, orderid ='eee' WHERE id=223
    '''
    if not params or not condition:
        return 0
    up_sql = format_sql(' , ', params)
    condition_sql = format_sql(' AND ', condition)
    sql = "UPDATE %s SET %s WHERE %s" % (table, up_sql, condition_sql)
    row = execute(sql)
    return row


def format_sql(sep, params):
    '''格式化SQL语句
    @param {string} seq: 分隔符
    @param {dict} params: 条件或值dict
    @return {string}: 语句拼接后的结果,如:  name='xx' AND price=5000
             name='xx' , price=5000
    '''
    res = []
    for k, v in params.iteritems():
        if isinstance(v, int) or isinstance(v, long) and v < 1000000000:
            pass
        # 字符串需要防止有单引号的情况,一个单引号替换成两个即可
        elif isinstance(v, (str, unicode)):
            v = "'%s'" % (v.replace("'","''"))
        else:
            v = "'%s'" % v
        res.append("%s=%s" % (k, v))
    if len(res) > 1:
        return ("%s" % sep).join(res)
    return res[0]

def add_sql(table, params):
    '''转成SQL插入语句
    @param {string} table: 表格名
    @param {dict} params: 条件或值dict
    @return {string}: 语句拼接后的结果,如:   INSERT INTO tableName (...) VALUES (...)
    '''
    column = ",".join(params.keys())
    # 防止值里面含单引号的情况,一个单引号替换成两个即可
    value = ",".join("'%s'" % unicode(x).replace("'","''") for x in params.values())
    sql = "INSERT INTO %s (%s) VALUES (%s)" % (table, column, value)
    return sql
