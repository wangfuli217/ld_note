#!python
# -*- coding:utf-8 -*-
'''
公用函数(数据库处理) mysql_util.py 的测试
Created on 2014/7/16
Updated on 2016/3/1
@author: Holemar
'''
import logging
import unittest
import threading
import time, datetime

import __init__
from libs_my import mysql_util


def test_init(DB_CONFIG):
    mysql_util.init(db=DB_CONFIG)
    assert mysql_util.ping()

    # 建表
    mysql_util.execute('drop table if exists `test_table`')
    mysql_util.execute(u"""
        CREATE TABLE if not exists `test_table` (
          `id` int(10) unsigned NOT NULL auto_increment, -- 自增
          `playlist_id` int(10) NOT NULL default '0', -- 整形
          `vuchnl_provider_id` int(10) unsigned NOT NULL default '4', -- 非负整型
          `circle_code` varchar(8) character set utf8 NOT NULL default '-', -- 字符串
          `status` enum('active','inactive') character set utf8 NOT NULL default 'active', -- 枚举
          `last_use_time` datetime DEFAULT NULL COMMENT '最后一次使用时间', -- datetime 类型
          `update_date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP, -- 更新时间(更新时自动变值)
          PRIMARY KEY  (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT '账户余额';
    """)

    assert mysql_util.ping()


def test_end():
    # 删除表，避免遗留测试痕迹
    mysql_util.execute('drop table if exists `test_table`')


class MysqlTools_Test(unittest.TestCase):
    db = mysql_util

    def setUp(self):
        u"""初始化"""
        super(MysqlTools_Test, self).setUp()
        assert self.db.ping()

    def tearDown(self):
        u"""销毁"""
        logging.info(u'%s 类清空数据表,避免影响别的测试用例。。。', self.class_name)
        assert self.db.ping()
        self.db.execute("TRUNCATE TABLE test_table")
        result = self.db.select('select * from test_table')
        assert len(result) == 0
        super(MysqlTools_Test, self).tearDown()


    def test_insert_select_get(self):
        # 插入一条
        logging.warn('execute 测试')
        rows = self.db.execute("insert into test_table(playlist_id, status) values(1, 'inactive')")
        assert rows == 1

        logging.warn('select 测试')
        result = self.db.select('select * from test_table')
        assert len(result) == 1

        logging.warn('get 测试')
        result = self.db.get('select * from test_table')
        assert isinstance(result, dict)

        logging.warn('execute 插入时间 测试')
        rows = self.db.execute("INSERT INTO test_table(playlist_id,status,update_date) VALUES (%(playlist_id)s, %(status)s, %(update_date)s)", {'status':'active', 'playlist_id':66, 'update_date':datetime.datetime.now()})
        assert rows == 1

        # py 2.7 时 time.localtime() 失败
        rows = self.db.execute("INSERT INTO test_table(playlist_id,status,update_date) VALUES (%(playlist_id)s, %(status)s, %(update_date)s)", {'status':'inactive', 'playlist_id':55, 'update_date':time.strftime('%Y-%m-%d %H:%M:%S')})
        assert rows == 1


    def test_rowid_select(self):
        # 获取 rowid
        logging.warn('execute 获取 rowid 测试')
        now = datetime.date.today()
        rowid = self.db.execute("insert into test_table(status, playlist_id, last_use_time) values(%s, %s, %s)", ('active',1011,now), rowid=True)
        assert rowid == 1

        rowid = self.db.execute("insert into test_table(status, playlist_id, last_use_time) values(%(status)s, %(playlist_id)s, %(last_use_time)s)", {'status':'active','playlist_id':1011, 'last_use_time':now}, rowid=True)
        assert rowid == 2

        rowid = self.db.execute("insert into test_table(status, playlist_id, last_use_time) values(%s, %s, %s)", ('active',1011,now), rowid=True)
        assert rowid == 3

        rows = self.db.execute("insert into test_table(playlist_id, status, last_use_time) values(1, 'inactive', '" + now.strftime('%Y-%m-%d %H:%M:%S') + "')")
        assert rows == 1

        result = self.db.select('select * from test_table')
        assert len(result) == 4

        # 查询参数
        logging.warn('select 参数测试')
        result = self.db.select('select * from test_table where playlist_id=%s', 1011)
        assert len(result) == 3

        result = self.db.select("SELECT * FROM test_table WHERE status=%(status)s AND playlist_id=%(playlist_id)s", param={'status':'active', 'playlist_id':1})
        assert len(result) == 0

        result = self.db.select("SELECT * FROM test_table WHERE status=%s AND playlist_id=%s", param=['active', 1011])
        assert len(result) == 3


        # fetchone 指定查询结果返回数量
        result = self.db.select("SELECT * FROM test_table ")
        assert len(result) == 4
        result = self.db.select("SELECT * FROM test_table ", fetchone=2)
        assert len(result) == 2
        # True 与 1 的区分
        result = self.db.select("SELECT * FROM test_table ", fetchone=True)
        assert isinstance(result, dict)
        result = self.db.select("SELECT * FROM test_table ", fetchone=1)
        assert isinstance(result, dict)
        # False 与 0 的区分
        result = self.db.select("SELECT * FROM test_table ", fetchone=0)
        assert len(result) == 4
        result = self.db.select("SELECT * FROM test_table ", fetchone=False)
        assert len(result) == 4


    def test_executemany(self):
        # executemany
        logging.warn('executemany 测试')
        rows = self.db.executemany("INSERT INTO test_table(circle_code,playlist_id) VALUES (%s,%s)", [(u"a'e''呵呵", 11),('a', 12), ('a', 13)])
        assert rows == 3
        result = self.db.select('select * from test_table where circle_code=%s', 'a')
        assert len(result) == 2
        result = self.db.select('select * from test_table where circle_code=%s', '-')
        assert len(result) == 0

        rows = self.db.executemany("INSERT INTO test_table(playlist_id,status,update_date) VALUES (%(playlist_id)s, %(status)s, %(update_date)s)", [{'status':'inactive', 'playlist_id':55, 'update_date':time.strftime('%Y-%m-%d %H:%M:%S')}, {'status':'active', 'playlist_id':66, 'update_date':datetime.datetime.now()}])
        assert rows == 2

        result = self.db.select('select * from test_table where circle_code=%s', '-')
        assert len(result) == 2


    def test_execute_list(self):
        # execute_list
        logging.warn('execute_list 测试')
        rows = self.db.execute_list([("insert into test_table(playlist_id, status) values(33, 'inactive')",None),("insert into test_table(playlist_id, status) values(44, 'inactive')",None)], must_rows=True)
        assert rows == 2

        result = self.db.select("SELECT * FROM test_table ")
        assert len(result) == 2


    def test_threads(self):
        # 异步测试
        logging.warn('异步 测试')
        th1 = self.db.execute("insert into test_table(playlist_id, status) values(2233, 'inactive')", threads=True)
        th2 = self.db.execute("insert into test_table(playlist_id, status) values(2233, 'inactive')", threads=True)
        assert isinstance(th1, threading.Thread)
        assert isinstance(th2, threading.Thread)
        logging.warn('异步请求发送完毕')
        th1.join()
        th2.join()

        result = self.db.select('select * from test_table where playlist_id=%s', 2233)
        assert len(result) == 2


    def test_format_sql(self):
        # 格式化字符串函数测试
        logging.warn('格式化字符串函数 测试')
        assert self.db.format_sql(',', None) == '1=1'
        assert self.db.format_sql(',', {}) == '1=1'
        assert self.db.format_sql(',', {'c':u"哈'哈"}) == u"`c`=%(c)s"
        assert self.db.format_sql(' AND ', {'a':u'a', 'b':1, 'c':u"哈'哈"}) == u"`a`=%(a)s AND `c`=%(c)s AND `b`=%(b)s" # 生成字符串的排序有点难理解
        assert self.db.add_sql('test_table', {'a':u'a', 'b':1, 'c':u"哈'哈"}) == "INSERT INTO `test_table` (`a`, `c`, `b`) VALUES (%(a)s, %(c)s, %(b)s)"


    def test_query_data(self):
        rows = self.db.execute("insert into test_table(playlist_id, status) values(2233, 'inactive')")
        assert rows == 1
        rows = self.db.execute("insert into test_table(playlist_id, status) values(2233, 'inactive')")
        assert rows == 1

        # query_data 测试
        logging.warn('query_data 测试')
        results = self.db.query_data('test_table', {"playlist_id":2233})
        assert len(results) == 2
        assert results[0].get('id') < results[1].get('id')
        # 排序查询
        results2 = self.db.query_data('test_table', {"playlist_id":2233}, 'id desc')
        assert len(results2) == 2
        assert results2[0].get('id') > results2[1].get('id')


    def test_add_data(self):
        # add_data
        logging.warn('add_data 测试')
        # 添加单条
        rows = self.db.add_data('test_table', {'circle_code':"e'e''e",'playlist_id':331, 'last_use_time':datetime.datetime.now()}) # 参数含单引号
        assert rows == 1
        result = self.db.query_data('test_table', {"circle_code":"e'e''e"})
        assert len(result) == 1

        # 添加多条
        rows = self.db.add_data('`test_table`', [{'circle_code':"e'e''e",'playlist_id':332, 'last_use_time':datetime.datetime.now()}, {'circle_code':"e'e''e",'playlist_id':333, 'last_use_time':datetime.datetime.now()}])
        assert rows == 2
        result = self.db.query_data('test_table', {"circle_code":"e'e''e"})
        assert len(result) == 3


    def test_add_datas(self):
        # add_datas (是 add_data 函数的多条执行模式)
        logging.warn('add_datas 测试')
        rows = self.db.add_datas([('test_table',{"circle_code":"e'e''e",'playlist_id':221, 'update_date':datetime.datetime.now()}),('test_table',{'playlist_id':443,'circle_code':u"哎f'f''哈", 'update_date':time.strftime('%Y-%m-%d %H:%M:%S')})])
        assert rows == 2

        result = self.db.query_data('test_table', {"circle_code":u"哎f'f''哈"}) # 中文参数+特殊符号
        assert len(result) == 1


    def test_update_data(self):
        rows = self.db.add_datas([('test_table',{"circle_code":"e'e''e",'playlist_id':221, 'update_date':datetime.datetime.now()}),('test_table',{'playlist_id':443,'circle_code':u"哎f'f''哈", 'update_date':time.strftime('%Y-%m-%d %H:%M:%S')})])
        assert rows == 2
        result = self.db.query_data('test_table', {"playlist_id":221})
        assert len(result) == 1
        data = result[0]
        assert data.get('status') == 'active'
        assert data.get('circle_code') == "e'e''e"

        # update_data
        logging.warn('update_data 测试')
        rows = self.db.update_data('test_table', {'status':'inactive','circle_code':"eee"}, {'playlist_id':221})
        assert rows == 1
        result = self.db.query_data('test_table', {"playlist_id":221})
        assert len(result) == 1
        data = result[0]
        assert data.get('status') == 'inactive'
        assert data.get('circle_code') == "eee"

        # update_data 条件与修改参数的字段名相同,区别度测试
        assert len(self.db.query_data('test_table', {"playlist_id":1443})) == 0
        assert len(self.db.query_data('test_table', {"playlist_id":443})) == 1
        rows = self.db.update_data('test_table', {'playlist_id':1443}, {'playlist_id':443})
        assert rows == 1
        assert len(self.db.query_data('test_table', {"playlist_id":1443})) == 1
        assert len(self.db.query_data('test_table', {"playlist_id":443})) == 0


    def test_del_data(self):
        rows = self.db.add_data('test_table',{"circle_code":"e'e''e",'playlist_id':221, 'update_date':datetime.datetime.now()})
        assert rows == 1
        result = self.db.query_data('test_table', {"playlist_id":221})
        assert len(result) == 1
        # del_data
        logging.warn('del_data 测试')
        rows = self.db.del_data('test_table', {'playlist_id':221})
        assert rows == 1
        result = self.db.query_data('test_table', {"playlist_id":221})
        assert len(result) == 0


class Test_Atom1(MysqlTools_Test):
    db = None

    def setUp(self):
        u"""初始化"""
        self.class_name = self.__class__.__name__
        logging.info(u'%s 类的 %s 函数测试开始...', self.class_name, self._testMethodName)
        self.db = mysql_util.Atom()
        assert self.db.ping()

    def tearDown(self):
        u"""销毁"""
        logging.info(u'%s 类清空数据表,避免影响别的测试用例。。。', self.class_name)
        assert self.db.ping()
        self.db.execute("TRUNCATE TABLE test_table")
        result = self.db.select('select * from test_table')
        assert len(result) == 0

        self.db.dispose()
        self.db = None
        logging.info(u'%s 类的 %s 函数测试完毕。。。\r\n', self.class_name, self._testMethodName)


    def test_doc(self):
        # 每个变量都有文档
        logging.warn('Atom 文档 测试')
        functions = dir(mysql_util.Atom)
        #logging.info(functions)
        for function in functions:
            #logging.info("%s.__doc__: %s", (function, getattr(mysql_util.Atom, function).__doc__))
            assert not not getattr(mysql_util.Atom, function).__doc__


    def test_threads(self):
        # 异步 测试
        logging.warn('Atom 异步测试, 此功能已去掉, 故无法测试')


    def test_rollback(self):
        logging.warn('Atom rollback 测试')
        # 插入一条
        rows = self.db.execute("insert into test_table(playlist_id, status) values(1, 'inactive')")
        assert rows == 1
        # 类内查询
        result = self.db.select('select * from test_table')
        assert len(result) == 1
        # 类外查询
        result = mysql_util.select('select * from test_table')
        assert len(result) == 0
        # 回滚
        self.db.rollback(dispose=False)
        # 类外查询
        result = mysql_util.select('select * from test_table')
        assert len(result) == 0


    def test_commit(self):
        logging.warn('Atom commit 测试')
        # 插入一条
        rows = self.db.execute("insert into test_table(playlist_id, status) values(%s, %s)", (1, 'inactive'))
        assert rows == 1
        # 类内查询
        result = self.db.select('select * from test_table where playlist_id=%s', 1)
        assert len(result) == 1
        # 类外查询
        result = mysql_util.select('select * from test_table where playlist_id=%(playlist_id)s', {'playlist_id':1})
        assert len(result) == 0
        # 提交
        self.db.commit(dispose=False)
        # 类外查询
        result = mysql_util.select('select * from test_table')
        assert len(result) == 1


class Test_Atom2(unittest.TestCase):
    # 原子操作类 Atom 的测试2:连接多个数据库
    def test_Atom2(self):
        fail = False
        try:
            mydb = mysql_util.Atom(**{
                 'host':'127.1.1.3',
                 'port':3306,
                 'user':'root',
                 'passwd':'keepc@2014..',
                 'db': 'test',
                 'charset':'utf8',
                 })
            assert mydb.ping()
        except:
            fail = True
            logging.warn('Atom连接不上,测试通过, 上面报错是必须的。。。')
        assert fail


if __name__ == "__main__":
    # 数据库配置
    DB_CONFIG = {
         'maxconnections':1,
         'host':'127.0.0.1',
         'port':3306,
         'user':'root',
         'passwd':'root',
         'db': 'test',
         'charset':'utf8',
         }

    test_init(DB_CONFIG) # 数据库初始化连接、建表
    unittest.main()
    test_end() # 删除表，避免遗留测试痕迹
