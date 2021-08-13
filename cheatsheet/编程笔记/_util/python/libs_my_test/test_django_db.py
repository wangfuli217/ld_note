#!python
# -*- coding:utf-8 -*-
'''
公用函数(数据库处理) django_db.py 的测试
Created on 2016/2/26
Updated on 2016/3/8
@author: Holemar
'''
import logging
import unittest
import datetime

import __init__
from django.db import models
from django.conf import settings
from django.db import connection


# 定义数据库连接(使用 sqlite3 的内存数据库，避免外部依赖)
settings.DATABASES = {
        'default': {
            # sqlite3 测试
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': ':memory:', # 内存处理

            # MySQL 测试
            #'ENGINE': 'django.db.backends.mysql',
            #'NAME': 'test', 'HOST': '127.0.0.1', 'USER': 'root', 'PASSWORD': 'root', 'PORT': 3306,
        }
    }

# 必须先设配置，再导入 django_db，不然会报错
from libs_my import django_db

# 用 Filter 类获取日志信息
NOW_LOG_RECORD = None
class TestFilter(logging.Filter):
    def filter(self, record):
        global NOW_LOG_RECORD
        NOW_LOG_RECORD = record # 把 Filter 获取到的日志信息传递出去，供测试使用
        return True
django_db.logger.addFilter(TestFilter())

# 定义 model，以供测试用
class Person_DB(models.Model):
    class Meta:
        db_table = 't_persons'
        app_label = 'test_db'

    created_at = models.DateTimeField(u'添加时间', db_column='c_created_at', default=None, null=True, blank=True, auto_now_add = True)
    updated_at = models.DateTimeField(u'更新时间', db_column='c_updated_at', default=None, null=True, blank=True, auto_now = True)
    name = models.CharField(u'人名', db_column="c_name", max_length = 20, default=None, null=True, blank=True)
    age = models.IntegerField(u'年龄', db_column="c_age", default=None, null=True, blank=True)


class Test_Django_db(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        u'''测试这个类前的初始化动作'''
        super(Test_Django_db, cls).setUpClass()

        django_db.execute_sql("DROP TABLE IF EXISTS t_persons")
        # 创建表，这也同时测试了 create_table 创建表函数
        django_db.create_table(Person_DB)

    @classmethod
    def tearDownClass(cls):
        u'''测试这个类所有函数后的结束动作'''
        super(Test_Django_db, cls).tearDownClass()

        # 还原配置信息
        # 定义数据库连接(使用 sqlite3 的内存数据库，避免外部依赖)
        settings.DATABASES = {
                'default': {
                    # 使用 sqlite3 的内存数据库，避免外部依赖
                    'ENGINE': 'django.db.backends.sqlite3',
                    'NAME': ':memory:', # 内存处理
                }
            }
        # 删除表
        django_db.execute_sql("DROP TABLE t_persons")


    def setUp(self):
        u"""初始化"""
        super(Test_Django_db, self).setUp()
        django_db.execute_sql("DELETE FROM t_persons")


    def test_insert_select_get(self):
        u'''增删改查测试'''
        rows = 0 # 总行数

        # INSERT
        logging.info(u'execute_sql 测试')
        row = django_db.execute_sql("INSERT INTO t_persons(c_name, c_age) values('张三', 15)")
        assert row == 1
        rows += 1

        # SELECT
        logging.info(u'select_sql 查询结果集 测试')
        result = django_db.select_sql('select * from t_persons')
        assert len(result) == 1

        logging.info(u'select_sql 查询一条 测试')
        result = django_db.select_sql('select * from t_persons', fetchone=True)
        assert isinstance(result, dict)

        logging.info(u'execute_sql tuple/list 参数 测试')
        now = datetime.date.today()
        row = django_db.execute_sql(u"INSERT INTO t_persons(c_name, c_age, c_created_at) values(%s, %s, %s)", (u'李奇',1011,now))
        assert row == 1
        row = django_db.execute_sql(u"INSERT INTO t_persons(c_name, c_age, c_created_at) values(%s, %s, %s)", [u'李奇2',22,now])
        assert row == 1
        rows += 2

        # 获取新增 id
        rowid = django_db.execute_sql(u"INSERT INTO t_persons(c_name, c_age, c_created_at) values(%s, %s, %s)", [u'李奇3',33,now], rowid=True)
        assert rowid == 4
        rows += 1

        if 'mysql' in settings.DATABASES['default']['ENGINE']:
            logging.info(u'execute_sql dict 参数 测试') # dict 参数在 sqlite3 数据库插入失败，换 MySQL 则成功
            row = django_db.execute_sql(u"INSERT INTO t_persons(c_name, c_age) VALUES (%(c_name)s, %(c_age)s)", {'c_name':u'莫名', 'c_age':66})
            assert row == 1
            rows += 1

        # UPDATE
        row = django_db.execute_sql(u"UPDATE t_persons set c_name=%s, c_age=%s, c_created_at=%s WHERE c_name=%s AND c_age=%s", ['李奇2', 151, now, u'李奇2', 22])
        assert row == 1

        result2 = django_db.select_sql('select * from t_persons')
        assert len(result2) == rows

    def test_time_warn(self):
        u'''SQL超时警告测试'''
        global NOW_LOG_RECORD
        logging.info(u'SQL超时警告测试')

        # 超时时间改成必然超时的，以便测试
        _orig_warn_time = django_db.SQL_WARN_TIME
        django_db.SQL_WARN_TIME = -1

        # ORM 操作
        Person_DB(name = u"张三", age = 13).save()
        record = NOW_LOG_RECORD
        assert record is not None
        assert record.levelno == logging.WARNING
        assert u'SQL执行超时' in record.msg

        # 原生 SQL 测试(上面是ORM生成的SQL测试)
        row = django_db.execute_sql(u"INSERT INTO t_persons(c_name, c_age) values('张三', 15)")
        assert row == 1
        record = NOW_LOG_RECORD
        assert record is not None
        assert record.levelno == logging.WARNING
        assert u'SQL执行超时' in record.msg

        # 超时时间改成原时间，避免太多日志
        django_db.SQL_WARN_TIME = _orig_warn_time

    def test_except(self):
        u'''SQL出错日志测试'''
        global NOW_LOG_RECORD
        logging.info(u'SQL出错日志测试')
        has_error = False
        try:
            row = django_db.execute_sql(u"INSERT INTO t_persons(c_name c_age) values('张三', 15)")
        except Exception, e:
            has_error = True # 上面程序要求必须报错
        assert has_error
        record = NOW_LOG_RECORD
        assert record is not None
        assert record.levelno == logging.ERROR
        assert u'SQL执行失败' in record.msg


if __name__ == "__main__":
    unittest.main()

