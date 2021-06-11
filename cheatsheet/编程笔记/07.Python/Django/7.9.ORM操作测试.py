#python
# -*- coding:utf-8 -*-
''' django orm操作 测试
使用 sqlite3 且内存操作，使得测试时不再需要依赖具体数据库，省去了外部部署、配置的依赖。
'''

# 1.定义数据库连接
from django.conf import settings
settings.configure(DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            #'NAME': './db.sqlite',  # Or path to database file if using sqlite3.
            'NAME': ':memory:', # 内存处理
            #'USER': '', 'PASSWORD': '', 'HOST': '', 'PORT': '',
        }
    })

def create_table(model):
    u'''创建 model 所需的表'''
    from django.db import connection # 获取数据库连接
    from django.core.management.color import no_style # Style是用来输出语句时着色的，没什么用
    from django.db.backends.base.creation import BaseDatabaseCreation # 这个类就是用来生成SQL语句的。
    c = BaseDatabaseCreation(connection)
    create_sql = c.sql_create_model(model(), no_style())[0][0] # 生成建表的SQL语句
    #print create_sql
    cursor = connection.cursor()
    cursor.execute(create_sql) # 执行SQL


# 2.定义 model
from django.db import models
class Person(models.Model):
    class Meta:
        db_table = 'persons' # 此 model 在数据库对应的表名称
        app_label = 'test'

    created_at = models.DateTimeField('created_at', auto_now_add = True)
    updated_at = models.DateTimeField('updated_at', auto_now = True)
    name = models.CharField("name", max_length = 20)
    age = models.IntegerField("age")

# 3.创建表
create_table(Person)

# 4.ORM操作语句测试
p = Person(name = "a", age = 111)
p.save()

o = Person.objects.filter(name__in=('a',"b"))
print o
