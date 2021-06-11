#!python
# -*- coding:utf-8 -*-
'''
公用函数(mysql数据库的操作)
Created on 2014/8/9
Updated on 2016/3/9
@author: Holemar

依赖第三方库:
    MySQL-python==1.2.3
    DBUtils==1.1

使用前必须先设置mysql数据库的连接
允许创建不同连接地址的连接池，只需 new Mysql对象时传入连接地址即可
'''

import time
import logging

import MySQLdb
from MySQLdb.cursors import DictCursor
from DBUtils.PooledDB import PooledDB

__all__=('Mysql', 'MyDb')

# 运行时间过长警告(超过这时间的将会警告,单位:秒)
TIME_OUT = 10

class Mysql(object):
    """
        @summary: MYSQL数据库对象，负责产生数据库连接 , 此类中的连接采用连接池实现
        获取连接对象：conn = Mysql.__getConn()
        释放连接对象;conn.close()或del conn
    """
    #连接池对象
    __pool_dict = {}
    def __init__(self, mincached=2 , maxcached=20, maxshared=0, maxconnections=50,
                              host='127.0.0.1', port=3306, user='root', passwd='password', db='test_db',
                              use_unicode=False,charset='utf8',cursorclass=DictCursor):
        """
        @summary: 数据库构造函数，从连接池中取出连接，并生成操作游标
        """
        self._conn = Mysql.__getConn(mincached=mincached , maxcached=maxcached, maxshared=maxshared, maxconnections=maxconnections,
                              host=host, port=port, user=user, passwd=passwd, db=db, use_unicode=use_unicode,charset=charset,cursorclass=cursorclass)
        self._cursor = self._conn.cursor()

    @staticmethod
    def __getConn(**kwargs):
        """
        @summary: 静态方法，从连接池中取出连接
        @return MySQLdb.connection
        """
        key = repr(kwargs)
        pool = Mysql.__pool_dict.get(key, None)
        if pool is None:
            pool = PooledDB(creator=MySQLdb, **kwargs)
            Mysql.__pool_dict[key] = pool
        return pool.connection()

    def getAll(self,sql,param=None):
        """
        @summary: 执行查询，并取出所有结果集
        @param {string} sql: 要查询的 SQL 语句，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
        @param {tuple|list|dict} param: 可选参数，条件列表值
        @return {tuple<dict>}: 返回SQL查询结果集,查不到时返回空的 tuple
        """
        start_time = time.time()
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql,param)
        if count>0:
            result = self._cursor.fetchall()
        else:
            result = ()
        # 判断运行时间是否太长
        use_time = float(time.time() - start_time)
        if use_time >= TIME_OUT:
            logging.warn(u"查询时间太长, 耗时 %.4f 秒, %s, %s" % (use_time, sql, param))
        return result

    def getOne(self,sql,param=None):
        """
        @summary: 执行查询，并取出第一条
        @param {string} sql: 要查询的 SQL 语句，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
        @param {tuple|list|dict} param: 可选参数，条件列表值
        @return {dict}: 返回SQL查询的结果(dict类型),查不到返回 None
        """
        start_time = time.time()
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql,param)
        if count>0:
            result = self._cursor.fetchone()
        else:
            result = None
        # 判断运行时间是否太长
        use_time = float(time.time() - start_time)
        if use_time >= TIME_OUT:
            logging.warn(u"查询时间太长, 耗时 %.4f 秒, %s, %s" % (use_time, sql, param))
        return result

    def getMany(self,sql,num,param=None):
        """
        @summary: 执行查询，并取出num条结果
        @param {string} sql: 要查询的 SQL 语句，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
        @param {int} num:取得的结果条数
        @param {tuple|list|dict} param: 可选参数，条件列表值
        @return {tuple<dict>}: 返回SQL查询结果集,查不到时返回空的 tuple
        """
        start_time = time.time()
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql,param)
        if count>0:
            result = self._cursor.fetchmany(num)
        else:
            result = ()
        # 判断运行时间是否太长
        use_time = float(time.time() - start_time)
        if use_time >= TIME_OUT:
            logging.warn(u"查询时间太长, 耗时 %.4f 秒, %s, %s" % (use_time, sql, param))
        return result

    def insertOne(self,sql,value):
        """
        @summary: 向数据表插入一条记录
        @param {string} sql:要插入的SQL格式
        @param {tuple|list|dict} value:要插入的记录数据
        @return: insertId 受影响的行数
        """
        row = self._cursor.execute(sql,value)
        return self.__getInsertId() or row

    def insertMany(self,sql,values):
        """
        @summary: 向数据表插入多条记录
        @param sql:要插入的SQL格式
        @param values:要插入的记录数据tuple(tuple)/list[list]
        @return: count 受影响的行数
        """
        count = self._cursor.executemany(sql,values)
        return count

    def __getInsertId(self):
        """
        获取当前连接最后一次插入操作生成的id,如果没有则为０
        """
        #self._cursor.execute("SELECT @@IDENTITY AS id")
        #return self._cursor.fetchone()['id']
        return self._cursor.lastrowid

    def __execute(self,sql,param=None):
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql,param)
        return count

    def update(self,sql,param=None):
        """
        @summary: 更新数据表记录
        @param sql: SQL格式及条件，使用(%s,%s)
        @param param: 要更新的  值 tuple/list
        @return: count 受影响的行数
        """
        return self.__execute(sql,param)

    def delete(self,sql,param=None):
        """
        @summary: 删除数据表记录
        @param sql: SQL格式及条件，使用(%s,%s)
        @param param: 要删除的条件 值 tuple/list
        @return: count 受影响的行数
        """
        return self.__execute(sql,param)

    def begin(self):
        """
        @summary: 开启事务
        """
        self._conn.autocommit(0)

    def end(self,option='commit'):
        """
        @summary: 结束事务
        """
        if option=='commit':
            self._conn.commit()
        else:
            self._conn.rollback()

    def dispose(self,isEnd=True):
        """
        @summary: 释放连接池资源
        """
        if isEnd:
            self.end('commit')
        else:
            self.end('rollback')
        self._cursor.close()
        self._conn.close()

class MyDb(object):
    """
        @summary: MYSQL数据库对象，只连固定一个数据库的，方便事务地回滚和提交多个请求
    """
    #连接池对象
    __pool_dict = {}
    def __init__(self, mincached=2 , maxcached=20, maxshared=0, maxconnections=50,
                              host='127.0.0.1', port=3306, user='root', passwd='password', db='test_db',
                              use_unicode=False,charset='utf8',cursorclass=DictCursor):
        """
        @summary: 数据库构造函数，从连接池中取出连接，并生成操作游标
        """
        self._conn = Mysql.__getConn(mincached=mincached , maxcached=maxcached, maxshared=maxshared, maxconnections=maxconnections,
                              host=host, port=port, user=user, passwd=passwd, db=db, use_unicode=use_unicode,charset=charset,cursorclass=cursorclass)
        self._cursor = self._conn.cursor()

    @staticmethod
    def __getConn(**kwargs):
        """
        @summary: 静态方法，从连接池中取出连接
        @return MySQLdb.connection
        """
        key = repr(kwargs)
        pool = Mysql.__pool_dict.get(key, None)
        if pool is None:
            pool = PooledDB(creator=MySQLdb, **kwargs)
            Mysql.__pool_dict[key] = pool
        return pool.connection()

    def getAll(self,sql,param=None):
        """
        @summary: 执行查询，并取出所有结果集
        @param {string} sql: 要查询的 SQL 语句，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
        @param {tuple|list|dict} param: 可选参数，条件列表值
        @return {tuple<dict>}: 返回SQL查询结果集,查不到时返回空的 tuple
        """
        start_time = time.time()
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql,param)
        if count>0:
            result = self._cursor.fetchall()
        else:
            result = ()
        # 判断运行时间是否太长
        use_time = float(time.time() - start_time)
        if use_time >= TIME_OUT:
            logging.warn(u"查询时间太长, 耗时 %.4f 秒, %s, %s" % (use_time, sql, param))
        return result

    def getOne(self,sql,param=None):
        """
        @summary: 执行查询，并取出第一条
        @param {string} sql: 要查询的 SQL 语句，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
        @param {tuple|list|dict} param: 可选参数，条件列表值
        @return {dict}: 返回SQL查询的结果(dict类型),查不到返回 None
        """
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql,param)
        if count>0:
            result = self._cursor.fetchone()
        else:
            result = None
        return result

    def getMany(self,sql,num,param=None):
        """
        @summary: 执行查询，并取出num条结果
        @param {string} sql: 要查询的 SQL 语句，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
        @param {int} num:取得的结果条数
        @param {tuple|list|dict} param: 可选参数，条件列表值
        @return {tuple<dict>}: 返回SQL查询结果集,查不到时返回空的 tuple
        """
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql,param)
        if count>0:
            result = self._cursor.fetchmany(num)
        else:
            result = ()
        return result

    def insertOne(self,sql,value):
        """
        @summary: 向数据表插入一条记录
        @param {string} sql:要插入的SQL格式
        @param {tuple|list|dict} value:要插入的记录数据
        @return: insertId 受影响的行数
        """
        row = self._cursor.execute(sql,value)
        return self.__getInsertId() or row

    def insertMany(self,sql,values):
        """
        @summary: 向数据表插入多条记录
        @param sql:要插入的SQL格式
        @param values:要插入的记录数据tuple(tuple)/list[list]
        @return: count 受影响的行数
        """
        count = self._cursor.executemany(sql,values)
        return count

    def __getInsertId(self):
        """
        获取当前连接最后一次插入操作生成的id,如果没有则为０
        """
        #self._cursor.execute("SELECT @@IDENTITY AS id")
        #return self._cursor.fetchone()['id']
        return self._cursor.lastrowid

    def __execute(self,sql,param=None):
        if param is None:
            count = self._cursor.execute(sql)
        else:
            count = self._cursor.execute(sql,param)
        return count

    def update(self,sql,param=None):
        """
        @summary: 更新数据表记录
        @param sql: SQL格式及条件，使用(%s,%s)
        @param param: 要更新的  值 tuple/list
        @return: count 受影响的行数
        """
        return self.__execute(sql,param)

    def delete(self,sql,param=None):
        """
        @summary: 删除数据表记录
        @param sql: SQL格式及条件，使用(%s,%s)
        @param param: 要删除的条件 值 tuple/list
        @return: count 受影响的行数
        """
        return self.__execute(sql,param)

    def begin(self):
        """
        @summary: 开启事务
        """
        self._conn.autocommit(0)

    def end(self,option='commit'):
        """
        @summary: 结束事务
        """
        if option=='commit':
            self._conn.commit()
        else:
            self._conn.rollback()

    def dispose(self,isEnd=True):
        """
        @summary: 释放连接池资源
        """
        if isEnd:
            self.end('commit')
        else:
            self.end('rollback')
        self._cursor.close()
        self._conn.close()
