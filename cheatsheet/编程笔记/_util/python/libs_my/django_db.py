# -*- coding: utf-8 -*-
'''
数据库公用函数(django数据库的操作,原生SQL模式)
Created on 2015/12/9
Updated on 2016/3/7
@author: Holemar

依赖第三方库:
    Django==1.8.1

'''
import logging
import itertools
from time import time

from django.conf import settings
from django.db import connection, transaction
from django.db.backends.utils import CursorDebugWrapper # 修改这个类的函数，用来输出 ORM 操作日志，主要是为了监控 SQL 执行效率
from django.core.management.color import no_style # Style是用来输出语句时着色的，没什么用
from django.db.backends.base.creation import BaseDatabaseCreation # 这个类就是用来生成SQL语句的。


__all__=('execute_sql', 'select_sql', 'create_table',)

# SQL 超时警告时间(单位：秒， 执行时间大于这个数值则发启警告， 配置成 0 或者 None 则关闭此警告)
SQL_WARN_TIME = getattr(settings, 'SQL_WARN_TIME', 1)
logger = logging.getLogger('libs_my.django.db')


def execute_sql(sql, param=None, rowid=False, connection=connection, transaction=transaction):
    '''
    @summary: 执行原生SQL语句(增删改操作)
    @param {string} sql: 要执行的 SQL 语句，如果有执行条件，请只指定条件列表，并将条件值使用参数[param]传递进来
    @param {tuple|list|dict} param: 可选参数，条件列表值
    @param {bool} rowid: 为 True则在insert语句时返回新增主键(没有主键则返回影响的行数),为False则只返回影响行数(默认False)
    @param connection: 数据库连接(有传则使用传来的,没有则用默认的,便于使用事务)
    @param transaction: 数据库连接的事务(有传则使用传来的,没有则用默认的)
    @return {int}: 返回执行SQL影响的行数/新增主键id
    @example
        row = execute_sql("INSERT INTO product_log(uid,v) VALUES (%s,%s)", (20125412, '1.2.3', ))
        或者 row = execute_sql("INSERT INTO product_log (uid,v) VALUES (%(uid)s, %(v)s)", {'uid':20125412, 'v':'1.2.3'}) # MySQL支持 dict 参数，但 sqlite3 不支持
    '''
    cursor = connection.cursor()
    # 数据修改操作——提交要求
    if param is None:
        row = cursor.execute(sql)
    else:
        row = cursor.execute(sql, param)
    # 提交事务
    transaction.commit()
    # sqlite3 数据库在前面执行时不直接返回影响行数，这里得再处理一下
    if not isinstance(row, int):
        row = cursor.rowcount
    # 插入,返回主键
    if rowid and sql.strip().lower().startswith('insert '):
        row = cursor.lastrowid or row # 如果表没有主键,则 lastrowid 会为0
    return row



def select_sql(sql, param=None, fetchone=False, connection=connection, transaction=transaction):
    '''
    @summary: 原生SQL语句查询
    @param {string} sql: 要执行的 SQL 语句，如果有执行条件，请只指定条件列表，并将条件值使用参数[param]传递进来
    @param {tuple|list|dict} param: 可选参数，条件列表值
    @param {bool|int} fetchone: 为 True则只返回第一条结果, 为False则返回所有的查询结果, 为 int 类型则返回指定的条数
    @param connection: 数据库连接(有传则使用传来的,没有则用默认的,便于使用事务)
    @param transaction: 数据库连接的事务(有传则使用传来的,没有则用默认的)
    @return {list<dict> | dict}:
        当 参数 fetchone 为 True 时, 返回SQL查询的结果(dict类型),查不到返回 None,执行有异常时抛出 RuntimeError 异常
        当 参数 fetchone 为 False 时, 返回SQL查询结果集,查不到时返回空的 tuple,执行有异常时抛出 RuntimeError 异常
    @example
        results = select("SELECT * FROM product_log WHERE flag=%s AND v=%s", param=('n','1.2.0',))
        或者 results = select("SELECT * FROM product_log WHERE flag=%(flag)s AND v=%(v)s", param={'flag':'n', 'v':'1.2.0'})
    '''
    cursor = connection.cursor()
    # 数据修改操作——提交要求
    if param is None:
        row = cursor.execute(sql)
    else:
        row = cursor.execute(sql, param)

    # 查不到时
    if row <= 0:
        result = None if fetchone == True else tuple()
    # 只返回1行
    elif fetchone == True:
        #result = [cursor.fetchone()]
        result = cursor.fetchmany(1)
    # 返回所有
    elif fetchone == False:
        result = cursor.fetchall()
    # 返回指定行数
    elif isinstance(fetchone, (int, long)):
        result = cursor.fetchmany(fetchone)
    else:
        result = cursor.fetchall()

    # 结果集转成 dict 类型
    if result:
        column_names = [d[0] for d in cursor.description]
        result = [Row(itertools.izip(column_names, row)) for row in result]
        if fetchone == True:
            result = result[0]
    return result


def create_table(model, connection=connection, transaction=transaction):
    '''
    @summary: 创建 model 所对应的表
    @param {django.db.models.Model} model: 生成表的 model 类
    @param connection: 数据库连接(有传则使用传来的,没有则用默认的,便于使用事务)
    @param transaction: 数据库连接的事务(有传则使用传来的,没有则用默认的)
    @raise : 执行有异常时抛出 RuntimeError 异常
    @return {string}: 建表语句
    '''
    c = BaseDatabaseCreation(connection)
    create_sql = c.sql_create_model(model(), no_style())[0][0] # 生成建表的SQL语句
    execute_sql(create_sql, connection=connection, transaction=transaction) # 执行SQL
    return create_sql


class Row(dict):
    """A dict that allows for object-like property access syntax."""
    def __getattr__(self, name):
        try:
            return self[name]
        except KeyError:
            raise AttributeError(name)


def run_log(run_time, sql, parm=None):
    '''
    @summary: 监控SQL的执行效率，执行超时的发起警告
    @param {int | long | float} run_time: SQL 执行时间，单位：秒
    @param {string} sql: 要执行的 SQL 语句，如果有执行条件，请只指定条件列表，并将条件值使用参数[param]传递进来
    @param {tuple|list|dict} param: 可选参数，条件列表值
    '''
    if SQL_WARN_TIME and run_time >= SQL_WARN_TIME:
        logger.warn(u'SQL执行超时，耗时:%.4f秒，SQL:%s， 参数:%s', run_time, sql, parm,
            extra={'duration': run_time, 'sql': sql, 'params': parm}
        )


def _execute(self, sql, params=None):
    start = time()
    try:
        return self._orig_execute(sql, params)
    except Exception, e:
        logger.error(u"SQL执行失败:%s, SQL:%s, 参数:%s", e, sql, params, exc_info=True)
        raise
    finally:
        duration = time() - start
        run_log(duration, sql, params)

def _executemany(self, sql, param_list):
    start = time()
    try:
        return self._orig_executemany(sql, param_list)
    except Exception, e:
        logger.error(u"SQL执行失败:%s, SQL:%s, 参数:%s", e, sql, param_list, exc_info=True)
        raise
    finally:
        duration = time() - start
        run_log(duration, sql, param_list)

# 修改 django 的 ORM SQL 日志输出, 以便监控性能
_orig_execute = getattr(CursorDebugWrapper, 'execute')
_orig_executemany = getattr(CursorDebugWrapper, 'executemany')
setattr(CursorDebugWrapper, '_orig_execute', _orig_execute)
setattr(CursorDebugWrapper, '_orig_executemany', _orig_executemany)
setattr(CursorDebugWrapper, 'execute', _execute)
setattr(CursorDebugWrapper, 'executemany', _executemany)
