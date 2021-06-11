
1.建立模型
    一个模型通常域一个数据库表对应, 而每个属性和数据库表的一列对应
    属性名对应列名, 属性的类型(如CharField)对应数据库列类型
    Django自己可以生成SQL语句(如 create table 等等)
    如果表是多对多关系, 但是数据表并没有多对多对应的列；Django会创建一个附加的多对多连接表来处理映射关系
    除非你自己定义一个主键, Django会自动为每个模型生成一个integer主键域id(模型中不需要定义主键, 他会隐式创建)
    每个Django模型都必须有一个单列的主键

    # 在上一步用 startapp 命令创建的 models.py 中输入下面的内容:
    from django.db import models

    class Publisher(models.Model):
        name = models.CharField('出版社名称', max_length=30) # 字符串类型, 定义长度30；第一个字符串参数是字段说明
        address = models.CharField(max_length=50)
        total = models.IntegerField('总量', default=0, blank=True) # 数值类型
        salutation = models.CharField(max_length=10, blank=True, null=True) # 允许为空值(默认是 not null)；默认为空值
        publication_date = models.DateField()  # 日期类型(date)
        website = models.URLField() # URL 类型(字符串保存, 200位)
        file_path = models.FilePathField('新闻文件路径') # 文件路径,路径符号会被自动转换
        email = models.EmailField() # email 类型(字符串 保存, 75位)
        headshot = models.ImageField(upload_to='/tmp') # 图片类型,定义上传路径（字符串保存, 100位）
        # 图片类型需安装模块, 地址:  http://www.pythonware.com/products/pil/   可以导入“import ImageFile”才算成功

    class Author(models.Model):
        code = models.CharField('作者编号', max_length=20, primary_key=True) # 显式定义主键,字符串类型
        name = models.CharField(max_length=30)

    # 指定可选的值(下面的 confirm_status 字段使用)
    CONFIRM_STATUS = ( ('待审核','待审核'), ('已通过','已通过'), ('未通过','未通过'), )
    class Book(models.Model):
        no = models.AutoField('书编号', primary_key=True) # 显式定义主键,自增长类型(整数类型)
        title = models.CharField(max_length=100)
        publish_time = models.DateTimeField('发布时间', auto_now_add = True) # 时间类型(datetime), 会自动赋值为当前时间
        confirm_note = models.CharField('审核意见', max_length=100, blank=True, null=True) # 设定允许为空
        # 指定固定值, 并设置预设值
        confirm_status = models.CharField('审核状态',max_length=10, choices=CONFIRM_STATUS, default='待审核')
        full_content_path = models.FilePathField('封面文件路径') # 文件路径类型(字符串保存, 100位)
        full_content = models.TextField('全部内容') # text 类型
        authors = models.ManyToManyField(Author) # 对应一个或多个authors(many-to-many)；会创建关联表来维护
        publisher = models.ForeignKey(Publisher) # 对应一个单独的publisher(one-to-many)；会创建外键来维护
        # 以下是一一对应关系的写法, 第一个参数是关联的对象,  verbose_name 是说明
        # place = models.OneToOneField(Place, verbose_name="related place")


2.model操作
    # 执行命令
    python manage.py shell  # 先进入django的shell, 以加载设置后再运行

    ####################### 执行python ######################
    from books.models import Publisher,Book # import模型类

    # 新增、保存
    p = Publisher(name='Apress', address='2560 Ninth St.', website='http://www.apress.com/') # 创建模型类对象,并赋值
    print( p._state.adding ) # 打印:True 。实例的“._state.adding”属性当此实例还没有保存到数据库前都是 True， 由数据库查询出来的是 False。 用来判断对象是否需要 insert
    p.save() # 将一个对象保存到数据库, 后台Django在这里执行了一条 INSERT SQL语句
    p = Publisher(name="O'Reilly", address='10', website='http://www.oreilly.com/')
    p.save(force_insert=True) # save 函数加上 force_insert=True 时会强制执行 insert，新增时减少一次 update(不加则会先试试update再insert)
    Joe = Publisher.objects.create(name="Joe", address='10 N') # 直接保存到数据库, 并返回这个对象
    print( Joe._state.adding ) # 打印:False 。实例的“._state.adding”当数据已经存到数据库都返回 False
    book = Book.objects.get(title="ddkk")
    book.publisher.add(Joe) # 添加关联类(调用它的 add 函数)
    obj, result = Publisher.objects.get_or_create(name='Apress', address='Ninth St.', website='http://www.xx.com/')
    # get_or_create 有则返回查询结果(返回: 结果类, False)， 没有则新增一个(返回: 新增后的结果类,True)

    # 更新
    publisher = Publisher.objects.get(id=1) # 这只获取到一个对象
    publisher.name = 'test_name'
    publisher.save() # 执行更新语句(会更新除了主键之外的所有字段)
    publisher.save(update_fields=['name']) # 执行更新语句(只更新指定字段，update_fields列表里可以指定多个字段)
    Publisher.objects.filter(name='Joe').update(city='haha..') # 执行条件更新(更新多行)；返回更新的行数
    Publisher.objects.select_related().filter(name='www').update(city='haha..') # select_related 函数会查询所有外键表
    Publisher.objects.update(city='kk.') # 没有条件, 则整表更新

    # 删除
    publisher = Publisher.objects.get(id=1)
    publisher.delete() # 执行删除语句,没返回值
    Publisher.objects.filter(name='Joe').delete()  # 执行条件删除语句(会删除多行)
    '''注意： django 执行的删除语句，不是直接按传来的条件删，而是先查询出来再按主键删除。
    比如上面的 filter(name='Joe').delete() 实际执行了两次 SQL，先执行 SELECT id,name,... FROM tableName WHERE name='Joe'
    然后再执行 DELETE FROM tableName WHERE id IN (id1, id2, ...)
    这避免了脏数据，在平常是没什么问题的，但有缓存的时候就遇到问题了。当缓存的数据跟真正数据库不一致时，往往不能有效删除。我就因此掉过坑。
    '''

    # 查询一个
    # 按条件查询, 查不到时会报错
    publisher_list = Publisher.objects.get(name="Apress")
    publisher_list = Publisher.objects.get(name="Apress", address='2560 N') # 多条件查询(各条件是 and 关系)
    # 使用 first 查不到时返回 None，查到多个返回其中一个。 而 get 要求查询到一个值，查到多个或者查不到都会报错。
    publisher_list = Publisher.objects.filter(name="Apress").first()

    # 查询列表
    # 使用 模型类.objects 属性从数据库得到对象, 使用 模型类.objects.all() 得到 模型类 的所有的对象列表
    publisher_list = Publisher.objects.all() # 后台Django在这里执行了一条 SELECT SQL语句；找出所有
    print(publisher_list) # 打印: [<Publisher: Publisher object>, <Publisher: Publisher object>]
    print(publisher_list[0].name) # 使用对象的某个值, 打印: Apress
    # order_by 函数排序查询(负号表示倒序)； values 函数只查询指定字段(返回一个列表,列表里面各行数据是一个字典)
    p_list = Publisher.objects.all().order_by('-publication_date').values('name', 'address', 'email')
    p_list = Publisher.objects.order_by('name') # 直接排序, 返回跟all函数一样的结果, 只是有排序
    # 过滤出等于或不等于此值的内容, 找不到返回空列表, 不报错
    Publisher.objects.filter(name='Joe').exclude(address='10 N').filter(email='tt') # filter 函数找出等于此值的；exclude 函数找出不等于此值的
    Publisher.objects.filter(name='Joe', email='tt') # filter 函数的多条件查询, and 关系
    # limit 查询(注: 调用all语句前不会立即执行,故不用担心消耗过大)
    publisher_list = Publisher.objects.all()[:10] # 找出前10条记录
    publisher_list = Publisher.objects.all()[5:10] # 找出第5到第10条记录
    publisher_list = Publisher.objects.all()[5] # 找出第5条记录
    publisher_list = Publisher.objects.all()[:10:3] # 找出前10条记录中的每3条记录取1条(即是取第1,4,7,10条记录)
    publisher_list = Publisher.objects.all()[-5] # 报错, 不支持此用法
    publisher = Publisher.objects.all()[0:1].get() # 只有一条记录时, 可以用 get 函数来取
    # 查询总数
    count = Publisher.objects.all().count()
    # 比较条件(在字段名后面加上比较的后缀,两个下划线做连接)
    publisher_list = Publisher.objects.filter(name__lte='Joe') # 查找 name <= 'Joe' 的内容
    publisher = Publisher.objects.get(name__exact='Joe')  # 用 get 函数也可以查找, 只是要求结果是一个的, 不然报错；多了或者少了都报错
    publisher_list = Publisher.objects.filter(name__isnull=True)  # 查找 name 为空的内容
    publisher_list = Publisher.objects.filter(name__contains='joe') # like 查询(特殊符号会被自动转义, 如“%”转成“\%”)
    publisher_list = Publisher.objects.exclude(id__in=[1,3,4]) # in 查询, 找出 id not in( 1, 3, 4 ) 的
    # __lt  <  (小于)      __lte <= (小于等于)
    # __gt  >  (大于)      __gte >= (大于等于)
    # __exact  (等于)      __iexact (忽略大小写的等于)
    # __contains (like)    __icontains (忽略大小写的 like )
    # __isnull = True      __isnull = False  (是否为空)
    # __in (in 列表)       __range = (开始值, 结束值) 相当于 >= 开始值 AND <= 结束值
    # __startswith (开始于,相当于 like 'value%' )   __istartswith (忽略大小写的 )
    # __endswith (结尾于,相当于 like '%value' )     __iendswith (忽略大小写的 )
    # __year 日期字段的年份      __month 日期字段的月份      __day 日期字段的日   __week_day 星期几

    # 多表的条件查询
    book_list = Book.objects.filter(publisher__name="Joe") # 多表查询, 查询 book表的 publisher 关联表的 name 字段
    book_list = Book.objects.filter(publisher__name__isnull=False) # 多表查询的条件查询, 条件拼接跟前面一样

    # 关联查询 select_related
    book_list = Book.objects.select_related('publisher').filter(title__isnull=False) # 会连 publisher 字段的内容都一次性查询出来,默认下是当使用到的情况下再单独查询
    # 上面相当于: SELECT Book.*, Publisher.* FROM `Book` INNER JOIN `Publisher` ON (`Book`.`publisher_id` = `Publisher`.`id`) WHERE `Book`.`title` is not null;
    book_list = Book.objects.select_related() # select_related 函数指定参数时会关联查询对应的外键表，没有参数时会关联查询出所有的外键表。
    # 如果关联的外键表还有外键表，可以用双下划线再次关联查询
    Book.objects.select_related('publisher', 'publisher__author') # 这里假设 publisher 外键表里面有一个 author 外键

    # distinct 查询
    publisher_names = Publisher.objects.filter(...).values('name').distinct() # 生成 SQL 语句： SELECT DISTINCT `name` FROM Publisher WHERE ...
    # 上句取出来的是 [{'name':'xxx'}, {'name':'xxx2'}, ...]  如果希望用列表列出这一个值，则需要再读取一下：
    publisher_names = list(set([item.get('name') for item in publisher_names]))

    # 判断是否存在/是否有这样的记录
    Book.objects.filter(publisher__name="Joe").exists()

    # 原生SQL查询,使用:  Manager.raw(raw_query, params=None, translations=None)
    for p in Publisher.objects.raw('SELECT * FROM books_publisher'): print(p) # 直接使用原生SQL

    # F 模型(各字段之间的比较)
    from django.db.models import F
    publisher_list = Publisher.objects.filter(name__gte=F('address')) # 两字段比较:  select ... where name >= address
    publisher_list = Publisher.objects.filter(name=F('address')*3)  # 可以加减乘除, 只是不知道怎么用
    publisher_list = Publisher.objects.filter(name=F('address')+F('address')-F('id'))
    Publisher.objects.filter(name='Joe').update(total=F('total')+1) # update set total=total+1 ...
    # order by 使用 F 模型
    publisher_list = Publisher.objects.order_by(F('total')+F('id')) # 多个字段相加的 ASC 排序
    publisher_list = Publisher.objects.order_by((F('total')*-1)-F('id')) # 多个字段相加的 DESC 排序， 由于第一个F用负号开头报错，只能写成乘负一

    # Q 模型(多条件查询)
    from django.db.models import Q
    Publisher.objects.filter(Q(name__startswith='d')) # 语句如:  select ... where name like 'd%'
    Publisher.objects.filter(~Q(user=1)) # user != 1
    Publisher.objects.filter(Q(name='dd') | Q(name__in=['joe','www'])) # or 用法, 语句如:  select ... where name='dd' or name in ('joe','www')
    Publisher.objects.filter(Q(id__gt=8), Q(name='dd') | Q(name__in=['joe','www'])) # and 和 or 合用:  where id>8 and name='dd' or name in ('joe','www')
    # 上一句注意, 一旦条件里面有 Q, 就得所有条件都用 Q, 不能这样写:  Publisher.objects.filter(id__gt=8, Q(name='dd') | Q(name__in=['joe','www']))

    # group by (聚合函数, 分组)
    from django.db.models import Max
    # 查询从 2015-09-16 发表以来,发表总量最大的出版社
    publisher_list = Publisher.objects.filter(publication_date__gt='2015-09-16').values('name').annotate(total_max=Max('total')).order_by('-total_max')
    # 生成 SQL: SELECT name, MAX(total) AS total_max FROM publisher WHERE publication_date >= '2015-09-16' GROUP BY name ORDER BY total_max DESC
    # 返回一个列表，如： [{'name': u'xxww', 'total_max': 1.0029997825622559}, {'name': u'测试用户', 'total_max': 2342}]

    # 纯聚合
    publisher_list2 = Publisher.objects.filter(publication_date__gt='2015-09-16').aggregate(total_max=Max('total'))
    # 生成 SQL： SELECT MAX(total) AS total_max FROM publisher WHERE publication_date >= '2015-09-16';
    # 返回一个 dict 字典，如： {'total_max': 2342}

    # 强制查询所有出来
    # 由于 Django 查询会被延迟求值，因此，.all() 函数返回的只是一个 QuerySet ，并没有真的去查询数据库，直到真正用到的时候。
    Publisher.objects.filter(user=1).all() # 返回一个 QuerySet
    list(Publisher.objects.filter(user=1).all()) # 使用 list 强制查询结果集出来
    list(Publisher.objects.values('name', 'address', 'email').all()) # 即使用 values 依然是延迟查询的，也可使用 list 强制查询出结果集

    # 字段重命名
    datas = Publisher.objects.extra(select={'renamed_value': 'name'}).values('renamed_value') # 把 name 字段重命名成 renamed_value
    # SQL 如： SELECT name AS renamed_value FROM publisher
    # 方法二，代码重命名
    datas = Publisher.objects.filter(...).all()
    datas = [{'renamed_id': obj.id, 'renamed_value' : obj.name} for obj in datas]


3.批量插入数据
    做法1:
        # 将会 commit 一次，而不是每次都 save
        from django.db import transaction

        @transaction.commit_manually # 告诉Django我们将自己控制函数中的事务处理。没有调用commit() 或rollback()，那么将抛出TransactionManagementError异常
        def viewfunc(request):
            ...
            try:
                for item in items:
                    entry = Entry(a1=item.a1, a2=item.a2)
                    entry.save()
            except:
                transaction.rollback()
            else:
                transaction.commit()

    做法2:
        # django 1.3+
        from django.db import transaction

        def viewfunc(request):
            ...
            with transaction.commit_on_success(): # 成功则提交事务，否则回滚。 django 1.8 木有这函数 =_=!!
                for item in items:
                    entry = Entry(a1=item.a1, a2=item.a2)
                    entry.save()

    做法3:
        # django 1.4+,  加入 bulk_create, 允许一次性插入多个类
        Entry.objects.bulk_create([
            Entry(headline="Django 1.0 Released"),
            Entry(headline="Django 1.1 Announced"),
            Entry(headline="Breaking: Django is awesome")
        ])


4.获取生成的 SQL 语句
    1) 利用 django Query 提供的方法
        queryset = Publisher.objects.filter(user=1).all()
        print queryset.query  # 可打印出查询语句

5.附加 Model 的 save 事件
    from django.db.models.signals import post_save
    def register_user(sender, instance, **kwargs):
        # 新增时
        if kwargs.get('created', False):
            print '*'*100
            print kwargs # 新增时，打印如: {'update_fields': None, 'raw': False, 'signal': <django.db.models.signals.ModelSignal object at 0x00000000035BBF60>, 'using': 'default', 'created': True}
        else:
            print '-'*100
            print kwargs # 修改时，打印如: {'update_fields': None, 'raw': False, 'signal': <django.db.models.signals.ModelSignal object at 0x00000000034FCF60>, 'using': 'default', 'created': False}

    # 这句话给 model 加上事件
    post_save.connect(register_user, sender=Book)

