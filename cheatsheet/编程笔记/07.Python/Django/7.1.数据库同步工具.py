1、syncdb
    django自带的数据库同步工具：
    python manage.py syncdb       # 根据models.py创建数据库表
    python manage.py validate     # 检验数据模型代码是否正确
    python manage.py sql          # 显示表创建的sql脚本
    python manage.py sqlall       # sql命令的基础上，增加创建数据库sql脚本
    python manage.py sqlindexes   # 显示主键索引创建的sql脚本
    python manage.py sqlclear     # 显示表删除的sql脚本
    python manage.py sqlreset     # 删除表，然后重新创建表
    python manage.py sqlcustom    # 显示.sql文件中的自定义sql语句
    python manage.py loaddata     # 加载初始值
    python manage.py dumpdata     # 将数据备份到 JSON 或者 XML

    python manage.py flush        # 清空数据库
    python manage.py createsuperuser # 创建超级管理员

    # 导出数据 导入数据
    python manage.py dumpdata appname > appname.json
    python manage.py loaddata appname.json

    # django 项目环境终端
    python manage.py shell
    # 如果你安装了 bpython 或 ipython 会自动用它们的界面，强烈推荐用 bpython

    # 数据库命令行
    python manage.py dbshell
    # Django 会自动进入在settings.py中设置的数据库，如果是 MySQL 或 postgreSQL,会要求输入数据库用户密码。
    # 在这个终端可以执行数据库的SQL语句。如果您对SQL比较熟悉，可能喜欢这种方式。


2、south
    针对 django 自带的 syncdb 同步 models 和数据库的缺陷开发的数据迁移工具，可以作为 syncdb 的替代， South 能够检测对 models 的更改并同步到数据库。
    django 从 1.7 版本开始，增加了类似 South 的 migration 功能，修改 Model 后可以在不影响现有数据的前提下重建表结构。
    1）south安装
        >>> easy_install South
        >>> (sudo) apt-get install python-django-south
        >>> (sudo) pip install South # 利用pip安装

    2）配置
        在settings.py文件 INSTALLED_APPS 中添加south：
        INSTALLED_APPS = (
            'django.contrib.admin',
            'django.contrib.auth',
            'django.contrib.contenttypes',
            'django.contrib.sessions',
            'django.contrib.messages',
            'django.contrib.staticfiles',

            'articles', # 自定义 Model 模块
        )

3、Django 1.7 自带 migrations 用法
  1) makemigrations
    基于当前的 model 创建新的迁移策略文件
    makemigrations 命令生成的文件会存到 migrations/目录下
        >>> python manage.py makemigrations articles # articles 是自定义 Model 模块, 只检查这一块
        >>> python manage.py makemigrations # 检查所有 model

    新版 Django 执行下面命令会生成 migrations/目录
        >>> manager.py startapp

  2) migrate
    用于执行迁移动作
    之前的 makemigrations 操作只是生成 migration 文件，还没有对数据库进行操作，接下来执行 migrate 命令：
        >>> python manage.py migrate articles # 更新指定 model
        >>> python manage.py migrate # 更新所有 model 的内容

    如果你有一个外键循环引用， makemigrations 会不止一次执行初始化迁移，所以你需要像下面这样标记它为已经应用:
        >>> python manage.py migrate --fake yourappnamehere

  3) sqlmigrate
    显示迁移的SQL语句


注意这能正常工作需要2个条件：
    生成表之后没有变更过模型。为了迁移能工作，需要先做初始化迁移工作，然后再变更模型，因为django和迁移脚本做变更对比，而不是数据库。
    没有手动修改过数据库 - django不能检测到你的数据库和模型的不匹配，当使用迁移修改这些表时只能得到error。

