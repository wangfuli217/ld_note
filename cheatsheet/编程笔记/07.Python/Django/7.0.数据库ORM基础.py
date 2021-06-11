
连接数据库:
    例(直接连数据库):
    from django.shortcuts import render_to_response
    import MySQLdb as dbDraver # 没安装相关的数据库驱动会报错

    def book_list(request):
        db = dbDraver.connect(user='me', db='mydb', passwd='secret', host='localhost')
        cursor = db.cursor()
        cursor.execute('SELECT name FROM books ORDER BY name')
        names = [row[0] for row in cursor.fetchall()]
        db.close()
        return render_to_response('book_list.html', {'names': names})


    数据库配置在Django配置文件里面, 默认是settings.py, 配置内容:

    DATABASE_ENGINE = ''      # 使用哪个数据库引擎
    DATABASE_NAME = ''        # 数据库名字; 如果你使用SQLite, 指出数据库文件的完整的文件系统路径, 如'/home/django/mydata.db'
    DATABASE_USER = ''        # 连接数据库的用户名; 如果你使用SQLite, 这项为空
    DATABASE_PASSWORD = ''    # 连接数据库的密码; 如果你使用SQLite或者你的密码为空, 则这项为空
    DATABASE_HOST = ''        # 连接数据库的主机; 如果数据库和Django安装在同一台计算机上, 则这项为空; 如果你使用SQLite, 这项为空
    DATABASE_PORT = ''        # 连接数据库的端口, 如果你使用SQLite, 则这项为空

    1, DATABASE_ENGINE: 使用哪个数据库引擎, 必须是下面的字符串集合:

        设置                             数据库                                                    需要的适配器
        postgresql           PostgreSQL psycopg version 1.x,                                      http://initd.org/projects/psycopg1
        postgresql_psycopg2  PostgreSQL psycopg version 2.x,                                      http://initd.org/projects/psycopg2
        mysql                MySQL MySQLdb,                                                       http://sourceforge.net/projects/mysql-python
        sqlite3              SQLite No adapter needed if using Python 2.5+ Otherwise, pysqlite,   http://initd.org/tracker/pysqlite
        ado_mssql            Microsoft SQL Server adodbapi version 2.0.1+,                        http://adodbapi.sourceforge.net/
        oracle               Oracle cx_Oracle,                                                    http://www.python.net/crew/atuining/cx_Oracle/

    2, DATABASE_HOST: 连接数据库的主机, MySQL在这里很特殊, 如果这项的值以'/'开头并且你使用MySQL, MySQL会通过Unix socket连接特殊的socket
       例如DATABASE_HOST ＝ '/var/run/mysql/'; 如果你使用MySQL但这项的值不是以'/'开头, 那么这项的值就假设为所连接的主机




数据库操作
    1) 可在 Django 项目的 settings.py 里面写数据库配置信息, 以便调用(不用独立出来写)

        # Django 1.0 时的写法是:
        DATABASE_ENGINE = 'oracle' # 数据库类型: 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
        DATABASE_NAME = 'orcl'  # 数据库名, 或者是sqlite3数据库文件的路径
        DATABASE_USER = 'NEWSPBC' # 用户名, sqlite3不需用
        DATABASE_PASSWORD = 'dgxytspbc' # 密码, sqlite3不需用
        DATABASE_HOST = '172.16.2.20' # IP地址, 为空则认为是localhost; sqlite3不需用
        DATABASE_PORT = '1521'  # 端口, 为空则使用默认的; sqlite3不需用

        # Django 1.2.5 时的写法是:
        DATABASES = {
            'default': {
                'ENGINE': 'oracle',  # 数据库类型: 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
                'NAME': 'g315',      # 数据库名, 或者是sqlite3数据库文件的路径
                'USER': 'maomingtest', # 用户名, sqlite3不需用
                'PASSWORD': 'maomingtest', # 密码, sqlite3不需用
                'HOST': '192.168.1.240',  # IP地址, 为空则认为是localhost; sqlite3不需用
                'PORT': '1521',  # 端口, 为空则使用默认的; sqlite3不需用
            }
        }

    2)  常见的错误信息                                                    问题所在
        You haven’t set the DATABASE_ENGINE setting yet.            # DATABASE_ENGINE 不能为空
        Environment variable DJANGO_SETTINGS_MODULE is undefined.    # 需运行 python manage.py shell而不是python
        Error loading __ module: No module named __.                 # 还没有安装数据库相关的适配器(如psycopg或MySQLdb)
        __ isn’t an available database backend.                     # DATABASE_ENGINE 不是合法的数据库引擎, 拼写错误
        database __ does not exist                                   # DATABASE_NAME 指向一个不存在的数据库
        role __ does not exist                                       # DATABASE_USER 指向一个不存在的user
        could not connect to server              # DATABASE_HOST 或者 DATABASE_PORT 设置不正确, 也可能数据库没运行

    3) 建立app
        project和app的区别(区别就是配置和代码):
        1, 一个project是许多Django app的集合的实例, 加上那些app的的配置
           一个project唯一的前提是它提供一个settings文件, 里面定义了数据库连接信息, 安装的app, TEMPLATE_DIRS等等
        2, 一个app是Django的可移动功能集, 通常包括模型和视图, 存在于一个单独的Python包里面
           关键要注意的是它们是可移动并且可以在不同的project重用
           有一点需要重视app惯例, 如果你使用Django的数据库层(模型), 你必须创建Django app(模型必须存在于app)
        3, 在前面创建的mysite目录下面, 运行下面的命令来创建一个新的app:
           python manage.py startapp app名称

    4) 建立模型
        一个模型通常域一个数据库表对应, 而每个属性和数据库表的一列对应
        属性名对应列名, 属性的类型(如CharField)对应数据库列类型
        Django自己可以生成SQL语句(如 create table 等等)
        如果表是多对多关系, 但是数据表并没有多对多对应的列；Django会创建一个附加的多对多连接表来处理映射关系
        除非你自己定义一个主键, Django会自动为每个模型生成一个integer主键域id(模型中不需要定义主键, 他会隐式创建)
        每个Django模型都必须有一个单列的主键
        (范例参考另一文件： 7.3.ORM操作代码.py)

    5) 安装模型

       编辑首目录的 settings.py, 查找 INSTALLED_APPS 设置
        # 每个 app 都用完整的 Python PATH 来表示, 即包的PATH, 用小数点分隔来指向app包
        INSTALLED_APPS = (
            'django.contrib.auth',
            'django.contrib.contenttypes',
            'django.contrib.sessions',
            'django.contrib.sites',
            'mysite.books',                # 自定义的模型
        ) # 别忘了最后的逗号

        验证模型:  python manage.py validate
        validate命令检查我们的模型语法和逻辑正确与否
        如果一切正常, 我们会看到0 errors found的信息；否则, error输出会给你有用的信息来帮你找到错误的代码
        任何时候你认为你的模型代码有问题都可以运行python manage.py validate来捕捉模型错误

        生成CREATE TABLE语句:   python manage.py sqlall app名称
        运行完命令, 你将会看到建表语句
        sqlall命令事实上并没有接触数据库或建表, 它仅仅将输出打印到屏幕上

    6) 把模型同步到数据库
       python manage.py syncdb
       它检查数据库和你的INSTALLED_APPS中的所有app的所有模型, 看看是否有些表已经存在, 如果表不存在就创建表
       注意syncdb不会同步改动或删除了的模型, 如果你改动或删除了一个模型, syncdb不会更新数据库

    7) 操作数据库(参考另一文件： 7.3.ORM操作代码.py)


    8) 添加模型的 string 显示
        上面的例子中, 当我们打印publishers列表时我们得到的都是一些无用的信息, 我们很难将Publisher对象区别开:
        [<Publisher: Publisher object>, <Publisher: Publisher object>]
        我们可以通过给Publisher对象添加一个 __str__() 方法来轻松解决这个问题
        __str__()唯一的条件是返回一个string, 如果不返回 string 的话如返回一个 integer ,会触发一个TypeError异常
        __str__()方法告诉Python怎样显示对象的string显示:

        # 修改前面的 Author 类
        class Author(models.Model):
            name = models.CharField(max_length=30)
            salutation = models.CharField(max_length=10)

            def __str__(self):
                return self.name

            def __unicode__(self):
                return unicode(self.name)

       # 执行命令
       python manage.py shell

       # 执行python
       from books.models import Author # import模型类
       a = Author(name='Jhon', salutation='salutation1')
       a.save()
       a = Author(name='Kevin', salutation='salutation2')
       a.save()
       author_list = Author.objects.all()
       print(author_list) # 打印: [<Author: Jhon>, <Author: Kevin>]
       print(author_list[0].name) # 打印:  Jhon

    注意 __str__() 是给模型添加行为的好习惯
    一个Django模型描述的不仅仅是一个对象数据库表结构, 它也描述了对象知道怎样去做的功能

