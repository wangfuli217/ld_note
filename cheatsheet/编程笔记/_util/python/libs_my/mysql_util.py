#!python
# -*- coding:utf-8 -*-
'''
公用函数(mysql数据库的操作)
Created on 2014/7/16
Updated on 2016/3/1
@author: Holemar

依赖第三方库:
    MySQL-python==1.2.3
    DBUtils==1.1

使用前必须先设置mysql数据库的连接
'''

import time
import logging
import threading

import MySQLdb
from MySQLdb.cursors import DictCursor
from DBUtils.PooledDB import PooledDB


__all__=('init', 'set_conn', 'get_conn', 'ping', 'select', 'get', 'execute', 'execute_list', 'executemany',
         'query_data', 'add_data', 'add_datas', 'del_data', 'update_data', 'format_sql', 'get_table', 'add_sql', 'Atom')

# 数据库线程池
dbpool = None

# 请求默认值
CONFIG = {
    'db':{ # {dict} 数据库连接配置
         'mincached':2,
         'maxcached':5,
         'maxshared':0,
         'maxconnections':50,
         'host':'127.0.0.1',
         'port':3306,
         'user':'root',
         'passwd':'',
         'db': 'test',
         'charset':'utf8',
         'cursorclass' : DictCursor,
     },
    'warning_time' : 5, # {int} 运行时间过长警告(超过这时间的将会警告,单位:秒)
    'log_max' : None, # {int} 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制)
    'log_tag' : '', # {string} 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了)
    'threads' : False, # {bool} 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间)
    'raise_error' : True, # {bool} 遇到操作异常时,是否抛出异常信息(默认抛出)。为 True则会抛出异常信息,否则不抛出
}

def init(**kwargs):
    '''
    @summary: 设置各函数的默认参数值
    @param {dict} db: 数据库连接配置
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒,默认5秒)
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息(默认抛出)。为 True则会抛出异常信息,否则不抛出
    '''
    global CONFIG
    default_db = CONFIG.get('db', {})
    CONFIG.update(kwargs)
    conn_config = kwargs.get('db')
    if conn_config != None:
        default_db.update(conn_config)
        CONFIG['db'] = default_db
        set_conn(default_db)

def set_conn(conn_config):
    '''
    @summary: 设置数据库连接,使用前必须先设置
    @param {dict} conn_config: redis数据库连接配置
    @return {bool}: 是否成功连接上数据库,失败时会报异常
    '''
    global CONFIG
    global dbpool
    CONFIG['db'].update(conn_config)
    try:
        dbpool = PooledDB(MySQLdb, **conn_config)
    except Exception, e:
        logging.error('[red]mysql connection error:%s[/red]', e, exc_info=True, extra={'color':True})
        raise
    return True

def ping(**kwargs):
    '''
    @summary: 探测mysql数据库是否连上
    @return {bool}: 能连上则返回True, 否则报异常
    '''
    try:
        conn = kwargs.get('conn', None)
        cursor = kwargs.get('cursor', None)
        if not conn:
            conn, cursor = get_conn()
        conn.ping(True)
        return True
    finally:
        close_conn(conn, cursor)

def get_conn(repeat_time=3):
    '''
    @summary: 获取数据库连接
    @return {tuple}: conn, cursor
    '''
    conn = None
    cursor = None
    global dbpool
    if dbpool is None:
        try:
            global CONFIG
            dbpool = PooledDB(MySQLdb, **CONFIG['db'])
        except Exception, e:
            logging.error('[red]mysql connection error:%s[/red]', e, exc_info=True, extra={'color':True})
            raise
    # 允许出错时重复提交多次,只要设置了 repeat_time 的次数
    while repeat_time > 0:
        try:
            conn = dbpool.connection()
            # 尝试连接数据库
            conn.ping(True)
            cursor = conn.cursor()
            return conn, cursor
        # 数据库连接,默认8小时没有使用会自动断开,这里捕获这异常
        except Exception, e:
            repeat_time -= 1
            logging.error('[red]mysql connection error:%s[/red]', e, exc_info=True, extra={'color':True})
            try:
                if cursor:cursor.close()
            except:pass
            try:
                if conn:conn.close()
            except:pass
    return conn, cursor

def close_conn(conn=None, cursor=None):
    '''
    @summary: 关闭数据库连接
    '''
    # 每次请求都关闭连接的话,在多线程高并发时会导致报错,性能也会下降。
    # 这里不关闭连接,每次使用时探测可用性,并捕获连接超时断开的异常
    try:
        #if cursor:cursor.close()
        pass
    except:pass
    try:
        #if conn:conn.close()
        pass
    except:pass

def _init_execute(func):
    '''处理获取数据库连接、超时记日志问题'''
    def wrapper(*args, **kwargs):
        start_time = time.time()
        global CONFIG
        threads = kwargs.pop('threads', CONFIG.get('threads', False))
        log_tag = kwargs.get('log_tag', CONFIG.get('log_tag', ''))
        # 提交异步请求(不处理返回结果)
        if threads:
            kwargs['threads'] = False # 避免递归发起线程
            kwargs['function'] = func # 为了传递给线程
            kwargs['log_tag'] = u'异步执行%s' % log_tag
            th = threading.Thread(target=wrapper, args=args, kwargs=kwargs)
            th.start() # 启动这个线程
            return th # 返回这个线程,以便 join 多个异步请求

        log_max = kwargs.pop('log_max', CONFIG.get('log_max', None))
        warning_time = kwargs.pop('warning_time', CONFIG.get('warning_time', 5))
        kwargs['raise_error'] = kwargs.get('raise_error', CONFIG.get('raise_error', True))
        # 数据库连接(没有则获取, 有则不用)
        conn = kwargs.get('conn', None)
        cursor = kwargs.get('cursor', None)
        if conn is None and cursor is None:
            conn, cursor = get_conn()
            kwargs['conn'] = conn
            kwargs['cursor'] = cursor
        # 执行SQL
        method = kwargs.pop('function', None) or func
        result =  method(*args, **kwargs)
        # 关闭数据库连接
        close_conn(conn, cursor)
        # 判断运行时间是否太长
        use_time = float(time.time() - start_time)
        # 如果参数超出指定的长度限制,则截取(避免参数太大,导致日志太大、太难阅读)
        log_param = str((args, kwargs.get('param', '')))
        if log_max and log_param and len(log_param) > log_max:
            log_param = u"%s......" % log_param[:log_max]
        # 如果返回值超出指定的长度限制,则截取(避免返回值太大,导致日志太大、太难阅读)
        log_res = str(result)
        if log_max and log_res and len(log_res) > log_max:
            log_res = u"%s......" % log_res[:log_max]
        log_msg = u"%s 执行:%s, 返回:%s" % (log_tag, log_param, log_res)
        # 为了更方便阅读,执行SQL的结果如果很短,则将它提前写
        if len(log_res) <= 10:
            log_msg = u"%s 返回:%s, 执行:%s" % (log_tag, log_res, log_param)
        if use_time >= warning_time:
            logging.warn(u"[yellow]SQL执行时间太长[/yellow], 耗时 %.4f 秒, %s" , use_time, log_msg, extra={'color':True})
        else:
            logging.info(u"SQL, 耗时 %.4f 秒, %s" , use_time, log_msg)
        return result
    return wrapper


@_init_execute
def __select(sql, param=None, fetchone=False, **kwargs):
    try:
        result = None
        cursor = kwargs.get('cursor', None)
        if param is None:
            count = cursor.execute(sql)
        else:
            count = cursor.execute(sql, param)
        # 查不到时
        if count <= 0:
            return None if fetchone == True else tuple()
        # 只返回1行(True 与 1 一样)
        elif fetchone == True:
            return cursor.fetchone()
        # 返回所有
        elif fetchone == False:
            return cursor.fetchall()
        # 返回指定行数
        elif isinstance(fetchone, (int, long)):
            return cursor.fetchmany(fetchone)
        else:
            return cursor.fetchall()
    except:
        logging.error(u"[red]查询失败[/red]:%s, %s, 返回:%s" , sql, param, result, exc_info=True, extra={'color':True})
        global CONFIG
        raise_error = kwargs.get('raise_error', CONFIG.get('raise_error', True))
        if raise_error:
            raise
        else:
            return False

def select(sql, param=None, fetchone=False, **kwargs):
    '''
    @summary: 查询SQL结果
    @param {string} sql: 要查询的 SQL 语句，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
    @param {tuple|list|dict} param: 可选参数，条件列表值
    @param {bool|int} fetchone: 为 True则只返回第一条结果, 为False则返回所有的查询结果, 为 int 类型则返回指定的条数
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出,默认抛出,默认抛出
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了,默认为空字符串)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒,默认5秒)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param conn: 数据库连接(有传则使用传来的,没有则自动获取,便于使用事务)
    @param cursor: 数据库连接的 Cursor Object(有传则使用传来的,没有则自动获取,便于使用事务)
    @return {tuple<dict> | dict}:
        当 参数 fetchone 为 True 时, 返回SQL查询的结果(dict类型),查不到返回 None
        当 参数 fetchone 为 False 时, 返回SQL查询结果集,查不到时返回空的 tuple
    @example
        results = select("SELECT * FROM product_log WHERE flag=%s AND v=%s", param=('n','1.2.0',))
        或者 results = select("SELECT * FROM product_log WHERE flag=%(flag)s AND v=%(v)s", param={'flag':'n', 'v':'1.2.0'})
    '''
    return __select(sql, param=param, fetchone=fetchone, **kwargs)


def get(sql, param=None, **kwargs):
    '''
    @summary: 查询SQL结果
    @param {string} sql: 要查询的 SQL 语句，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
    @param {tuple|list|dict} param: 可选参数，条件列表值
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出,默认抛出
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了,默认为空字符串)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param conn: 数据库连接(有传则使用传来的,没有则自动获取,便于使用事务)
    @param cursor: 数据库连接的 Cursor Object(有传则使用传来的,没有则自动获取,便于使用事务)
    @return {dict}: 返回SQL查询的结果(dict类型),查不到返回 None,执行有异常时返回 False
    @example
        results = get("SELECT * FROM product_log WHERE flag=%s AND v=%s", param=('n','1.2.0',))
        或者 results = get("SELECT * FROM product_log WHERE flag=%(flag)s AND v=%(v)s", param={'flag':'n', 'v':'1.2.0'})
    '''
    kwargs.pop('fetchone', None)
    return select(sql, param=param, fetchone=True, **kwargs)


@_init_execute
def __execute(sql, param=None, clash=1, rowid=False, transaction=True, **kwargs):
    try:
        conn = kwargs.get('conn', None)
        cursor = kwargs.get('cursor', None)
        # 开启事务
        #if transaction: conn.autocommit(0)
        if param is None:
            row = cursor.execute(sql)
        else:
            row = cursor.execute(sql, param)
        # 插入,返回主键
        if rowid and sql.strip().lower().startswith('insert '):
            row = cursor.lastrowid or row # 如果表没有主键,则 lastrowid 会为0
        #else:
        #    row = cursor.rowcount # 其实这行不写也行,前面已经返回了影响行数
        if transaction: conn.commit()
        return row
    #主键冲突,或者唯一键冲突,重复insert,忽略错误
    except MySQLdb.IntegrityError:
        logging.warn(u"[yellow]主键冲突[/yellow]:%s, %s" , sql, param, extra={'color':True})
        return clash
    except Exception, e:
        logging.error(u"[red]执行失败[/red]:%s, SQL:%s, 参数:%s" , e, sql, param, exc_info=True, extra={'color':True})
        if transaction and conn: conn.rollback()
        global CONFIG
        raise_error = kwargs.get('raise_error', CONFIG.get('raise_error', True))
        if raise_error:
            raise
        else:
            return  -1

def execute(sql, param=None, clash=1, rowid=False, transaction=True, **kwargs):
    '''
    @summary: 执行SQL语句(增删改操作)
    @param {string} sql: 要执行的 SQL 语句，如果有执行条件，请只指定条件列表，并将条件值使用参数[param]传递进来
    @param {tuple|list|dict} param: 可选参数，条件列表值
    @param {int} clash: 发生主键冲突,或者唯一键冲突时的返回值,默认1
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出,默认抛出
    @param {bool} rowid: 为 True则在insert语句时返回新增主键(没有主键则返回影响的行数),为False则只返回影响行数(默认False)
    @param {bool} transaction: 为  True 则开启事务(成功会commit,失败会rollback),为 False 则不开启事务(默认开启)
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了,默认为空字符串)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒,默认5秒)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param conn: 数据库连接(有传则使用传来的,没有则自动获取,便于使用事务)
    @param cursor: 数据库连接的 Cursor Object(有传则使用传来的,没有则自动获取,便于使用事务)
    @return {int}: 返回执行SQL影响的行数(插入则返回新增的主键值/影响行数),执行有异常时返回 -1
    @example
        row = execute("INSERT INTO product_log(uid,v) VALUES (%s,%s)", (20125412, '1.2.3', ))
        或者 row = execute("INSERT INTO product_log (uid,v) VALUES (%(uid)s, %(v)s)", {'uid':20125412, 'v':'1.2.3'})
    '''
    return __execute(sql, param=param, clash=clash, rowid=rowid, transaction=transaction, **kwargs)


@_init_execute
def __executemany(sql, param, clash=1, transaction=True, **kwargs):
    try:
        conn = kwargs.get('conn', None)
        cursor = kwargs.get('cursor', None)
        # 开启事务
        #if transaction: conn.autocommit(0)
        if param is None:
            row = cursor.executemany(sql)
        else:
            row = cursor.executemany(sql, param)
        if transaction: conn.commit()
        return row
    #主键冲突,或者唯一键冲突,重复insert,忽略错误
    except MySQLdb.IntegrityError:
        logging.warn(u"[yellow]主键冲突[/yellow]:%s, %s" , sql, param, extra={'color':True})
        return clash
    except Exception, e:
        logging.error(u"[red]执行失败[/red]:%s, SQL:%s, 参数:%s" , e, sql, param, exc_info=True, extra={'color':True})
        if transaction and conn: conn.rollback()
        global CONFIG
        raise_error = kwargs.get('raise_error', CONFIG.get('raise_error', True))
        if raise_error:
            raise
        else:
            return -1

def executemany(sql, param, clash=1, transaction=True, **kwargs):
    '''
    @summary: 执行SQL语句(增删改操作), 同一个SQL语句,执行不同的多个参数
    @param {string} sql: 要执行的 SQL 语句，如果有执行条件，请只指定条件列表，并将条件值使用参数[param]传递进来
    @param {tuple|list|dict} param: 可选参数，条件列表值
    @param {int} clash: 发生主键冲突,或者唯一键冲突时的返回值,默认1
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出,默认抛出
    @param {bool} transaction: 为  True 则开启事务(成功会commit,失败会rollback),为 False 则不开启事务(默认开启)
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了,默认为空字符串)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒,默认5秒)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param conn: 数据库连接(有传则使用传来的,没有则自动获取,便于使用事务)
    @param cursor: 数据库连接的 Cursor Object(有传则使用传来的,没有则自动获取,便于使用事务)
    @return {int}: 返回执行SQL影响的行数(插入则返回新增的主键值/影响行数),执行有异常时返回 -1
    @example
        row = executemany("INSERT INTO product_log(uid,v) VALUES (%s,%s)", [(20125412, '1.2.3', ),(20125413, '2.0.3', ),(56721, '2.32.3', )])
        或者 row = executemany("INSERT INTO product_log (uid,v) VALUES (%(uid)s, %(v)s)", [{'uid':20125412, 'v':'1.2.3'},{'uid':56721, 'v':'2.32.3'}])
    '''
    return __executemany(sql, param=param, clash=clash, transaction=transaction, **kwargs)


def execute_list(sql_list, must_rows=False, transaction=True, **kwargs):
    '''
    @summary: 执行多条SQL语句，并且是一个原子事件(任何一条SQL执行失败，或者返回结果为0，都会全体回滚)
    @param {list<tuple<string,dict>>} sql_list: 形式为 [(sql1, param1),(sql2, param2),(sql3, param3),...]
    @param {bool} must_rows: 为 True则要求每个SQL语句影响的行数都必须大于1,影响行数为0会认为执行出错。为False则允许执行影响数为0
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出,默认抛出
    @param {bool} transaction: 为  True 则开启事务(成功会commit,失败会rollback),为 False 则不开启事务(默认开启)
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了,默认为空字符串)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒,默认5秒)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param conn: 数据库连接(有传则使用传来的,没有则自动获取,便于使用事务)
    @param cursor: 数据库连接的 Cursor Object(有传则使用传来的,没有则自动获取,便于使用事务)
    @return {int}: 返回执行SQL影响的行数,执行有异常时返回 -1
    '''
    conn = None
    cursor = None
    try:
        # 数据库连接(没有则获取, 有则不用)
        conn = kwargs.get('conn', None)
        cursor = kwargs.get('cursor', None)
        if conn is None and cursor is None:
            conn, cursor = get_conn()
            kwargs['conn'] = conn
            kwargs['cursor'] = cursor
        # 开启事务
        #if transaction: conn.autocommit(0)
        row = 0
        kwargs.pop('rowid', None)
        for sql, param in sql_list:
            this_row = execute(sql, param, clash=1, raise_error=True, rowid=False, transaction=False, **kwargs)
            if must_rows and this_row <= 0:
                raise RuntimeError(u'其中一条执行失败,影响行数为%s, SQL:%s, %s' % (this_row, sql, param))
            row += this_row
        if transaction: conn.commit()
        return row
    except Exception, e:
        logging.error(u"[red]执行失败[/red]:%s, SQL:" % (e, sql_list), exc_info=True, extra={'color':True})
        if transaction and conn: conn.rollback()
        global CONFIG
        raise_error = kwargs.get('raise_error', CONFIG.get('raise_error', True))
        if raise_error:
            raise
        else:
            return -1
    finally:
        close_conn(conn, cursor)


def query_data(table, condition=None, orderby=None, **kwargs):
    '''
    @summary: 查询一个表
    @param {string} table: 要查询的表的名称(注意:表名的前缀"t_"也要求写,如果有的话)
    @param {dict} condition: 要查询的条件
    @param {string} orderby: 要排序的条件
    @param {bool|int} fetchone: 为 True则只返回第一条结果, 为False则返回所有的查询结果, 为 int 类型则返回指定的条数
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出,默认抛出
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了,默认为空字符串)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒,默认5秒)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param conn: 数据库连接(有传则使用传来的,没有则自动获取,便于使用事务)
    @param cursor: 数据库连接的 Cursor Object(有传则使用传来的,没有则自动获取,便于使用事务)
    @return {tuple<dict> | dict}:
        当 参数 fetchone 为 True 时, 返回SQL查询的结果(dict类型),查不到返回 None
        当 参数 fetchone 为 False 时, 返回SQL查询结果集,查不到时返回空的 tuple
    @example
        results = query_data('service_conf', {"bid":333, "category":"cc"})
        实际执行: SELECT * FROM service_conf WHERE bid=333 AND category ='cc'
    '''
    sql = u"SELECT * FROM `%s` " % get_table(table)
    if condition:
        condition_sql = format_sql(' AND ', condition)
        sql += u" WHERE %s" % (condition_sql)
    if orderby:
        sql += u" ORDER BY %s" % (orderby)
    rows = select(sql, param=condition, **kwargs)
    return rows

def add_data(table, param, **kwargs):
    '''
    @summary: 插入数据到一个表
    @param {string} table: 要插入的表的名称(注意:表名的前缀"t_"也要求写,如果有的话)
    @param {dict} param: 要插入的内容
    @param {int} clash: 发生主键冲突,或者唯一键冲突时的返回值,默认1
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出,默认抛出
    @param {bool} rowid: 为 True则在insert语句时返回新增主键(没有主键则返回影响的行数),为False则只返回影响行数(默认False)
    @param {bool} transaction: 为  True 则开启事务(成功会commit,失败会rollback),为 False 则不开启事务(默认开启)
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了,默认为空字符串)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒,默认5秒)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param conn: 数据库连接(有传则使用传来的,没有则自动获取,便于使用事务)
    @param cursor: 数据库连接的 Cursor Object(有传则使用传来的,没有则自动获取,便于使用事务)
    @return {int}: 返回执行SQL影响的行数(插入则返回新增的主键值/影响行数),执行有异常时返回 -1
    @example
        # 添加一行
        rows = add_data('goods_log', {'bid':'kc','name':"e'ee"})
            实际执行: INSERT INTO goods_log (bid, name) VALUES ('kc', 'e''ee')

        # 添加多行
        rows = add_data('goods_log', [{'bid':'kc','name':"哈哈"}, {'bid':'kc','name':"呵呵"}])
           实际执行: INSERT INTO goods_log (bid, name) VALUES ('kc', '哈哈'), ('kc', '呵呵')
    '''
    # 只添加一行数据
    if isinstance(param, dict):
        sql = add_sql(table, param)
        row = execute(sql, param=param, **kwargs)
        return row
    # 添加多行数据
    elif isinstance(param, (list,tuple,set)) and len(param)>=1:
        if isinstance(param, set):
            param = list(param)
        sql = add_sql(table, param[0])
        row = executemany(sql, param=param, **kwargs)
        return row

def add_datas(table_list, **kwargs):
    '''
    @summary: 一起插入多个语句,原子操作，其中任意一个操作语句失败都会全体回滚
    @param {list<tuple<string,dict>>} table_list: 形式为 [(table_name1, param1),(table_name2, param2),(table_name3, param3),...]
    @param {bool} must_rows: 为 True则要求每个SQL语句影响的行数都必须大于1,影响行数为0会认为执行出错。为False则允许执行影响数为0
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出,默认抛出
    @param {bool} transaction: 为  True 则开启事务(成功会commit,失败会rollback),为 False 则不开启事务(默认开启)
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了,默认为空字符串)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒,默认5秒)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param conn: 数据库连接(有传则使用传来的,没有则自动获取,便于使用事务)
    @param cursor: 数据库连接的 Cursor Object(有传则使用传来的,没有则自动获取,便于使用事务)
    @return {int}: 返回执行SQL影响的行数,执行有异常时返回 -1
    @example
        rows = add_datas([('goods_log',{'bid':'333','orderid':"e''ee"}),('product_log',{'bid':'444','orderid':u"哎f'f"})])
    '''
    sql_list =  []
    for table, params in table_list:
        sql = add_sql(table, params)
        sql_list.append((sql, params,))
    row = execute_list(sql_list, **kwargs)
    return row

def del_data(table, condition, **kwargs):
    '''
    @summary: 删除一个表的数据
    @param {string} table: 要删除数据的表的名称(注意:表名的前缀"t_"也要求写,如果有的话)
    @param {dict} condition: 要删除的条件,必须传此参数
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出,默认抛出
    @param {bool} transaction: 为  True 则开启事务(成功会commit,失败会rollback),为 False 则不开启事务(默认开启)
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了,默认为空字符串)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒,默认5秒)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param conn: 数据库连接(有传则使用传来的,没有则自动获取,便于使用事务)
    @param cursor: 数据库连接的 Cursor Object(有传则使用传来的,没有则自动获取,便于使用事务)
    @return {int}: 返回执行SQL影响的行数(插入则返回新增的主键值/影响行数),执行有异常时返回 -1
    @example
        rows = del_data('goods_log', {'bid':333,'orderid':"eee"})
        实际执行: DELETE FROM goods_log WHERE  bid=333 AND orderid ='eee'
    '''
    if not condition:
        return 0
    condition_sql = format_sql(' AND ', condition)
    sql = u"DELETE FROM `%s` WHERE %s" % (get_table(table), condition_sql)
    row = execute(sql, param=condition, **kwargs)
    return row

def update_data(table, param, condition, **kwargs):
    '''
    @summary: 修改一个表的数据
    @param {string} table: 要修改数据的表的名称(注意:表名的前缀"t_"也要求写,如果有的话)
    @param {dict} param: 要修改的数据,必须传此参数
    @param {dict} condition: 要修改的条件,必须传此参数
    @param {bool} raise_error: 遇到操作异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出,默认抛出
    @param {bool} transaction: 为  True 则开启事务(成功会commit,失败会rollback),为 False 则不开启事务(默认开启)
    @param {int} log_max: 返回结果输出到日志的最大字符长度，超过次长度的将不输出(值设为 0 或者 None 将不限制, 默认按日志模块的最大限制)
    @param {string} log_tag: 日志标志,用来标明这请求的日志是哪个发出的(没有这标志则只能根据参数来猜了,默认为空字符串)
    @param {int} warning_time: 运行时间过长警告(超过这时间的将会警告,单位:秒,默认5秒)
    @param {bool} threads: 是否发起多线程去请求,将会不再接收返回值(可节省等待请求返回的时间,默认不发起)
    @param conn: 数据库连接(有传则使用传来的,没有则自动获取,便于使用事务)
    @param cursor: 数据库连接的 Cursor Object(有传则使用传来的,没有则自动获取,便于使用事务)
    @return {int}: 返回执行SQL影响的行数(插入则返回新增的主键值/影响行数),执行有异常时返回 -1
    @example
        rows = update_data('goods_log', {'bid':333,'orderid':"eee"}, {'id':223})
        实际执行: UPDATE goods_log SET bid=333, orderid ='eee' WHERE id=223
    '''
    if not param:
        return 0
    up_sql = format_sql(' , ', param, keys_prefix='up_')
    condition_sql = format_sql(' AND ', condition, keys_prefix='cond_')
    sql = u"UPDATE `%s` SET %s WHERE %s" % (get_table(table), up_sql, condition_sql)
    # 参数合并(由于修改的数据字段名与条件的字段名有可能完全一样,所以得用前缀区分)
    sql_param = {}
    for k, v in param.items():
        sql_param[u'up_%s' % k] = v
    if condition:
        for k, v in condition.items():
            sql_param[u'cond_%s' % k] = v
    row = execute(sql, param=sql_param, **kwargs)
    return row


def format_sql(sep, param, keys_prefix='', **kwargs):
    '''
    @summary: 格式化SQL语句
    @param {string} seq: 分隔符
    @param {dict} param: 条件或值dict
    @param {list} keys_prefix: 替位符前缀(条件里面由于有相同的字段名,所以替位符得加上特殊前缀来标识)
    @return {string}: 语句拼接后的结果,如:
            format_sql(' AND ', {'flag':'xxx', 'v':2.56}) 返回: "flag=%(flag)s AND v=%(v)s"
            format_sql(', ', {'flag':'xxx', 'v':2.56}) 返回: "flag=%(flag)s, v=%(v)s"
    '''
    if not param or not isinstance(param, dict):
        return '1=1'
    return (u"%s" % sep).join(u"`%s`=%%(%s%s)s" % (unicode(x), keys_prefix, unicode(x)) for x in param.keys())

def get_table(table):
    '''
    @summary: 转化表格名
    @param {string} table: 表格名
    @return {string}: 转化后的表格名
    '''
    table = table.replace('`', '')
    return table


def add_sql(table, param, **kwargs):
    '''
    @summary: 转成SQL插入语句
    @param {string} table: 表格名
    @param {dict} param: 条件或值dict
    @return {string}: 语句拼接后的结果,如:   INSERT INTO tableName (...) VALUES (...)
    '''
    column = u", ".join(u"`%s`" % unicode(x) for x in param.keys())
    value = u", ".join(u"%%(%s)s" % unicode(x) for x in param.keys())
    sql = u"INSERT INTO `%s` (%s) VALUES (%s)" % (get_table(table), column, value)
    return sql


class Atom:
    u'''
    @summary: 使用事务,原子地操作多个语句时,可使用本类
    注:同一个实例无法完美支持多线程操作,故去掉多线程
    '''
    #连接池对象
    __pool = {}
    __lock = threading.Lock()

    def __init__(self, **kwargs):
        u"""
        @summary: 本类的构造,会打开连接、设置事务等。 需要手动提交
        @param 其他参数,连接 MySQL 数据库的连接参数,跟 MySQLdb.connect 的一致。 有传则用传来的连接, 没有则用本文件预设或默认的。
            如: host, port, user, passwd, db, charset, cursorclas ...
        """
        conn, cursor, db_key = Atom.__get_conn(**kwargs)
        if not conn:
            logging.error('[red]mysql connection error[/red], new Atom() fail', extra={'color':True})
            raise RuntimeError(u"mysql 数据库连接不上")
        # 开启事务
        conn.autocommit(0)
        self.conn = conn
        self.cursor = cursor
        self.db_key = db_key
        self.other_params = {'conn' : conn, 'cursor': cursor, 'transaction':False, 'threads':False} # 额外参数

    @staticmethod
    def __get_conn(repeat_time=3, **kwargs):
        """
        @summary: 静态方法，从连接池中取出连接
        @return MySQLdb.connection
        """
        conn = None
        cursor = None
        db_key = repr(kwargs)
        pool = Atom.__pool.get(db_key)
        if pool is None:
            # 锁定, 避免并发访问时改变连接池的引用,保证同一个 db_key 只有一个连接池
            Atom.__lock.acquire()
            pool = Atom.__pool.get(db_key)
            if pool is None:
                pool = set()
                Atom.__pool[db_key] = pool
            # 释放锁
            Atom.__lock.release()
        # 允许出错时重复提交多次,只要设置了 repeat_time 的次数
        while repeat_time > 0 or len(pool) > 0:
            try:
                conn = pool.pop()
                # 尝试连接数据库
                conn.ping(True)
                cursor = conn.cursor()
                return conn, cursor, db_key
            # set 内容为空时, pop 会抛异常
            except KeyError:
                # 数据库连接配置
                global CONFIG
                db_config = CONFIG['db'].copy()
                db_config.pop('mincached', None)
                db_config.pop('maxcached', None)
                db_config.pop('maxshared', None)
                db_config.pop('maxconnections', None)
                db_config.update(kwargs)
                try:
                    conn = MySQLdb.connect(**db_config)
                    cursor = conn.cursor()
                    return conn, cursor, db_key
                except Exception, e:
                    logging.error(u'[red]mysql connection error[/red]:%s' , e, exc_info=True, extra={'color':True})
                    raise
            # 连接超时或已断开
            except Exception, e:
                repeat_time -= 1
                logging.error(u'[red]mysql connection error[/red]:%s' , e, exc_info=True, extra={'color':True})
                try:
                    if cursor: cursor.close()
                    if conn: conn.close()
                except:pass
        return conn, cursor, db_key

    @staticmethod
    def __release(db_key, conn=None, cursor=None):
        '''使用完数据库连接,放回线程池'''
        if conn: Atom.__pool[db_key].add(conn)
        try:
            if cursor: cursor.close()
        except:pass

    def commit(self, dispose=True):
        u"""
        @summary: 提交
        @param {bool} dispose: 是否需要消耗此对象(默认销毁)
        """
        self.conn.commit()
        if dispose:
            self.dispose()
        logging.info(u'事务提交完成,销毁对象:%s' , dispose)

    def rollback(self, dispose=True):
        u"""
        @summary: 回滚
        @param {bool} dispose: 是否需要消耗此对象(默认销毁)
        """
        self.conn.rollback()
        if dispose:
            self.dispose()
        logging.info(u'事务回滚完成,销毁对象:%s' , dispose)

    def dispose(self):
        u"""
        @summary: 释放连接资源
        """
        Atom.__release(self.db_key, conn=self.conn, cursor=self.cursor)
        self.conn = None
        self.cursor = None

    def __del__(self):
        """Delete the db connection."""
        try:
            self.dispose()
        except:pass

    # 下面动态加入本文件的所有函数作为类里面的函数
    # 即:  'ping', 'select', 'get', 'execute', 'execute_list', 'executemany', 'query_data', 'add_data', 'add_datas', 'del_data', 'update_data', 'format_sql', 'add_sql'
    for __function in __all__:
        # 下面函数无法实现,就不再加了
        if __function in ('init', 'set_conn', 'get_conn', 'Atom'):
            continue
        # 获取 docstring
        __doc = eval(u"%s.__doc__" % __function) or ''
        # 动态加入函数
        exec u"""def %(function)s (self, *args, **kwargs):
        u'''%(doc)s'''; # 生成 docstring
        kwargs.update(self.other_params); # 设置额外参数
        res = %(function)s(*args, **kwargs); # 调用本文件的对应操作函数
        return res;""" % {'function': __function, 'doc':__doc}
    # 删除上面产生的临时变量,避免遗留在这类里面
    del __doc
    del __function

