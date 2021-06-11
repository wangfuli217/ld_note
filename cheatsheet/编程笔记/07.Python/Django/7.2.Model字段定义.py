
model 字段类型清单
    AutoField:
        一个自动递增的整型字段, 添加记录时它会自动增长。
        你通常不需要直接使用这个字段；如果你不指定主键的话, 系统会自动添加一个主键字段到你的model。

    BooleanField:
        布尔字段,管理工具里会自动将其描述为checkbox。

    CharField:
        字符串字段, 单行输入, 用于较短的字符串, 如要保存大量文本, 使用 TextField, CharField有一个必填参数:
        max_length: 字符的最大长度, django会根据这个参数在数据库层和校验层限制该字段所允许的最大字符数。

    TextField:
        一个容量很大的文本字段,  admin 管理界面用 <textarea>多行编辑框表示该字段数据。

    CommaSeparatedIntegerField:
        用于存放逗号分隔的整数值。类似 CharField, 必须maxlength 参数。

    DateField:
        日期字段, admin 用一个文本框 <input type=”text”> 来表示该字段数据(附带一个 JavaScript 日历和一个”Today”快捷按键。有下列额外的可选参数:
        auto_now: 当对象被保存时,自动将该字段的值设置为当前时间.通常用于表示 “last-modified” 时间戳；
        auto_now_add: 当对象首次被创建时,自动将该字段的值设置为当前时间.通常用于表示对象创建时间。

    DateTimeField:
        类似 DateField 支持同样的附加选项。

    EmailField:
        一个带有检查 Email 合法性的 CharField, 不接受 maxlength 参数。

    FileField:
        一个文件上传字段。 要求一个必须有的参数:  upload_to,  一个用于保存上载文件的本地文件系统路径。 这个路径必须包含 strftime formatting,  该格式将被上载文件的 date/time 替换(so that uploaded files don’t fill up the given directory)。
        在一个 model 中使用 FileField 或 ImageField 需要以下步骤: 在你的 settings 文件中,  定义一个完整路径给 MEDIA_ROOT 以便让 Django在此处保存上传文件。 (出于性能考虑, 这些文件并不保存到数据库。) 定义 MEDIA_URL 作为该目录的公共 URL。 要确保该目录对 WEB 服务器用户帐号是可写的。
        在你的 model 中添加 FileField 或 ImageField,  并确保定义了 upload_to 选项, 以告诉 Django 使用 MEDIA_ROOT 的哪个子目录保存上传文件。你的数据库中要保存的只是文件的路径(相对于 MEDIA_ROOT)。
        出于习惯你一定很想使用 Django 提供的 get_<fieldname>_url 函数。举例来说, 如果你的 ImageField 叫作 mug_shot,  你就可以在模板中以 {{ object。get_mug_shot_url }} 这样的方式得到图像的绝对路径。

    FilePathField:
        选择指定目录按限制规则选择文件, 有三个参数可选,  其中”path”必需的, 这三个参数可以同时使用,  参数描述:
        path: 必需参数, 一个目录的绝对文件系统路径。 FilePathField 据此得到可选项目。 Example:  “/home/images”；
        match: 可选参数,  一个正则表达式,  作为一个字符串,  FilePathField 将使用它过滤文件名。 注意这个正则表达式只会应用到 base filename 而不是路径全名。 Example:  “foo。*\。txt^”,  将匹配文件 foo23.txt 却不匹配 bar.txt 或 foo23.gif；
        match 仅应用于 base filename,  而不是路径全名。 如: FilePathField(path=”/home/images”,  match=”foo.*”,  recursive=True)…会匹配 /home/images/foo.gif 而不匹配 /home/images/foo/bar.gif
        recursive: 可选参数,  是否包括 path 下全部子目录, True 或 False, 默认值为 False 。

    FloatField:
        浮点型字段。 必须提供两个 参数,  参数描述:
        max_digits: 总位数(不包括小数点和符号)
        decimal_places: 小数位数。如: 要保存最大值为 999 (小数点后保存2位), 你要这样定义字段: models.FloatField(…, max_digits=5,  decimal_places=2), 要保存最大值一百万(小数点后保存10位)的话, 你要这样定义: models.FloatField(…, max_digits=19,  decimal_places=10)

    ImageField:
        类似 FileField,  不过要校验上传对象是否是一个合法图片。它有两个可选参数: height_field 和 width_field, 如果提供这两个参数, 则图片将按提供的高度和宽度规格保存。 该字段要求 Python Imaging 库。

    IntegerField:
        用于保存一个整数。

    IPAddressField:
        一个字符串形式的 IP 地址,  (如 “202.1241.30″)。

    NullBooleanField:
        类似 BooleanField,  不过允许 NULL 作为其中一个选项。 推荐使用这个字段而不要用 BooleanField 加 null=True 选项。 admin 用一个选择框 <select> (三个可选择的值:  “Unknown”,  “Yes” 和 “No” ) 来表示这种字段数据。

    PhoneNumberField:
        一个带有合法美国风格电话号码校验的 CharField(格式: XXX-XXX-XXXX)。

    PositiveIntegerField:
        类似 IntegerField,  但取值范围为非负整数（这个字段应该是允许0值的…可以理解为无符号整数）

    PositiveSmallIntegerField:
        正小整型字段, 类似 PositiveIntegerField,  取值范围较小(数据库相关)SlugField“Slug” 是一个报纸术语。 slug 是某个东西的小小标记(短签),  只包含字母, 数字, 下划线和连字符。它们通常用于URLs。 若你使用 Django 开发版本, 你可以指定 maxlength。 若 maxlength 未指定,  Django 会使用默认长度:  50, 它接受一个额外的参数:
        prepopulate_from: 来源于slug的自动预置列表

    SlugField:
        是一个报纸术语. slug 是某个东西的小小标记(短签), 只包含字母,数字,下划线和连字符.它们通常用于URLs。

    SmallIntegerField:
        类似 IntegerField,  不过只允许某个取值范围内的整数。(依赖数据库)

    TimeField:
        时间字段, 类似于 DateField 和 DateTimeField。

    URLField:
        用于保存 URL。 若 verify_exists 参数为 True (默认),  给定的 URL 会预先检查是否存在(即URL是否被有效装入且没有返回404响应)。

    USStateField:
        美国州名缩写, 由两个字母组成（天朝人民无视）。

    XMLField:
        XML字符字段, 校验值是否为合法XML的 TextField, 必须提供参数:
        schema_path: 校验文本的 RelaxNG schema 的文件系统路径。


附: Field 选项

        null : 缺省设置为false.通常不将其用于字符型字段上, 比如CharField,TextField上.字符型字段如果没有值会返回空字符串。
        blank: 该字段是否可以为空。如果为假, 则必须有值
        choices: 一个用来选择值的2维元组。第一个值是实际存储的值, 第二个用来方便进行选择。如SEX_CHOICES= ((‘F’,'Female’),(‘M’,'Male’),)
        core: db_column, db_index 如果为真将为此字段创建索引
        default: 设定缺省值
        editable: 如果为假, admin模式下将不能改写。缺省为真
        help_text: admin模式下帮助文档
        primary_key: 设置主键, 如果没有设置django创建表时会自动加上:

        1	id = meta.AutoField('ID', primary_key=True)
        2	primary_key=True implies blank=False, null=False and unique=True. Only one primary key is allowed on an object.

    radio_admin: 用于admin模式下将select转换为radio显示。只用于ForeignKey或者设置了choices
    unique: 数据唯一
    unique_for_date: 日期唯一, 如下例中系统将不允许title和pub_date两个都相同的数据重复出现
    title = meta.CharField(maxlength=30,unique_for_date=’pub_date’)
    unique_for_month / unique_for_year: 用法同上
    validator_list: 有效性检查。非有效产生 django.core.validators.ValidationError 错误


Field 类的初始化
    def __init__(self, verbose_name=None, name=None, primary_key=False,
        max_length=None, unique=False, blank=False, null=False,
        db_index=False, rel=None, default=NOT_PROVIDED, editable=True,
        serialize=True, unique_for_date=None, unique_for_month=None,
        unique_for_year=None, choices=None, help_text='', db_column=None,
        db_tablespace=None, auto_created=False, validators=[],
        error_messages=None)

案例1(自定义字段)
    import time, datetime
    import random
    import hashlib
    import logging
    from decimal import Decimal
    from django.db import models
    from django.db.models import SlugField

    # 创建一种自定义字段类型
    class AutoMD5SlugField(SlugField):
        def __init__(self, *args, **kwargs):
            kwargs.setdefault('blank', True)

            populate_from = kwargs.pop('populate_from', None)
            if populate_from is None:
                logging.warning("missing 'populate_from' argument")
                self._populate_from = ''
            else:
                self._populate_from = populate_from

            self.hash_key = kwargs.pop('hash_key', time.time)
            super(AutoMD5SlugField, self).__init__(*args, **kwargs)

        def get_new_slug(self, model_instance, extra=''):
            slug_field = model_instance._meta.get_field(self.attname)

            hash_key = self.hash_key() if callable(self.hash_key) else self.hash_key
            populate_from = getattr(model_instance, self._populate_from) if self._populate_from and hasattr(model_instance, self._populate_from) else ''
            slug = hashlib.md5('%s%s%s' % (hash_key, populate_from, extra)).hexdigest()
            slug_len = slug_field.max_length
            if slug_len:
                slug = slug[:slug_len]

            return slug

        def create_slug(self, model_instance, add):
            # get fields to populate from and slug field to set
            slug = getattr(model_instance, self.attname)
            if slug:
                # slugify the original field content and set next step to 2
                return slug

            slug = self.get_new_slug(model_instance)

            # exclude the current model instance from the queryset used in finding
            # the next valid slug
            if hasattr(model_instance, 'gen_slug_queryset'):
                queryset = model_instance.gen_slug_queryset()
            else:
                queryset = model_instance.__class__._default_manager.all()
            if model_instance.pk:
                queryset = queryset.exclude(pk=model_instance.pk)

            kwargs = {}
            kwargs[self.attname] = slug

            while queryset.filter(**kwargs).count() > 0:
                slug = self.get_new_slug(model_instance, random.random())
                kwargs[self.attname] = slug

            return slug

        def pre_save(self, model_instance, add):
            value = unicode(self.create_slug(model_instance, add))
            setattr(model_instance, self.attname, value)
            return value

        def get_internal_type(self):
            return "SlugField"

    models.AutoMD5SlugField = AutoMD5SlugField


    class Product(models.Model):
        id = models.AutoField(primary_key=True, db_column='c_id', help_text=u'主键')
        id = models.UUIDField(primary_key=True, default=uuid.uuid4, db_column='c_id') # 用 UUID 作为主键(与上面主键不能同时出现)
        # models.AutoMD5SlugField 是自定义的一个类, 可以自动生成一个唯一标识符作为业务主键(包含字母及数字), 上面给出这个类的定义过程
        slug = models.AutoMD5SlugField(
            "唯一标识符", populate_from='title', max_length=8, unique=True, null=True, db_index=True, help_text=u'唯一标识符')

        title = models.CharField("产品名", max_length=100, unique=True, null=True, blank=True, db_index=True, help_text=u'产品名')
        classify = models.CharField("分类", max_length=100, null=True, blank=True)
        market_price = models.DecimalField("市场价", decimal_places=2, max_digits=8) # 单位:元, 使用 Decimal 保存
        personal_n = models.DecimalField('个人收费金额', default=0.00, max_digits=10, decimal_places=2, db_column='c_personal_n')
        per_n = models.DecimalField('医疗个人附加值', max_digits=10, decimal_places=4, db_column='c_b_per_n', blank=True, null=True)

        banner = CustomImageField(verbose_name='banner图', upload_to='yueban', width_field='banner_width', height_field='banner_height', null=True, max_length=255) # 图片, 数据库只保存url, 默认长度100字符(max_length)
        banner_width = models.PositiveIntegerField(verbose_name="banner宽", default=0, blank=True)
        banner_height = models.PositiveIntegerField(verbose_name="banner高", default=0, blank=True)

        intro = models.CharField(verbose_name="介绍/商品卖点", max_length=255, unique=True)
        user = models.ForeignKey(UserBase, verbose_name = u'点赞人', on_delete=models.DO_NOTHING) # 删除 user 时不级联删除此行记录

        status = models.PositiveIntegerField('状态', default=0)
        online_time = models.DateTimeField('上线时间', default=datetime.datetime.now, null=True, blank=True) # 指定默认为当前时间
        offline_time = models.DateTimeField('下线时间', default=None, null=True, blank=True)
        create_time = models.DateTimeField('创建时间', auto_now_add=True) # 创建时间,创建时加入,后续不变
        update_time = models.UnixTimestampField('修改时间', auto_now=True) # 更新时间,每次保存时自动更新到当前最新时间

        class Meta:
            db_table = 'tbl_product' # 对应的数据库表名字。  外部获取此表名时： Product._meta.db_table
            verbose_name = '产品' # 表名称/类名称
            verbose_name_plural = verbose_name
            unique_together = ('title', 'classify', 'user') # 联合唯一索引
            ordering = ('-market_price', ) # 按 market_price 字段倒叙

        def __str__(self):
            return self.title

        def __unicode__(self):
            return self.title

        # 保存这实体类时的动作(执行 Update,Insert 都会触发)
        def save(self, force_insert=False, force_update=False, using=None, update_fields=None):
            u'''
            @param {bool} force_insert: 是否强制执行 insert 操作(如果同时 force_update 为 True， 或者 update_fields 参数有值， 则报错)
            @param {bool} force_update: 是否强制执行 update 操作
            @param {?} using: 使用的数据库连接??
            @param {list<string>} update_fields: 指定只更新的字段列表
            '''
            queryset = self.__class__._default_manager
            code = queryset.filter(online_time__lte=datetime.datetime.now(), offline_time__gte=datetime.datetime.now()) # 查询本身的表,这两行只是示例

            if self.market_price is None:
                self.market_price = Decimal(0)
            if self.market_price and isinstance(self.market_price, (str, unicode, int, long)):
                self.market_price = Decimal(self.market_price)
            super(Product, self).save(using=using, force_insert=force_insert, force_update=force_update, update_fields=update_fields)

        # 更新时这实体类时的动作(执行 Update 时触发)
        #def _do_update(self, base_qs, using, pk_val, values, update_fields, forced_update):
        def _do_update(self, *args, **kwargs):
            return super(Product, self)._do_update(*args, **kwargs)

        # 新增时这实体类时的动作(执行 Insert 时触发)
        #def _do_insert(self, manager, using, fields, update_pk, raw):
        def _do_insert(self, *args, **kwargs):
            u"""添加一个点赞，也需要同步给对应的 Collocation 表里面的 praise_num字段加 1"""
            collocation = self.collocation
            if collocation.status != 1 or collocation.publish !=1:
                raise  TypeError('不存在')
            collocation.praise_num += 1
            collocation.save()
            return super(Product, self)._do_insert(*args, **kwargs)

        # 删除时的动作(执行 Delete 时触发)
        def delete(self, *args, **kwargs):
            collocation = self.collocation
            collocation.praise_num -= 1
            collocation.save()
            return super(Product, self).delete(*args, **kwargs)



案例2(指定不同的数据库)
  1.首先 setting 里面配置：

    # 数据库配置
    DATABASES = {
        'default': { # 默认数据库
            'NAME': 'ehr',
            'HOST': '10.10.83.67',
            'ENGINE': 'django.db.backends.mysql',
            'USER': 'root',
            'PASSWORD': 'Z2OrHKcVkS',
        },
        'admin': { # 指定第二个数据库
            'NAME': 'ehr-admin',
            'HOST': '10.10.83.67',
            'ENGINE': 'django.db.backends.mysql',
            'USER': 'root',
            'PASSWORD': 'Z2OrHKcVkS',
        },
    }

    # 指定数据库地址的路由
    DATABASE_ROUTERS = ['core.database.DatabaseSelectRouter']
    # 自定义需要转库的表
    DATABASE_ROUTERS_ADMIN_TABLES = ('auth_group', 'auth_group_permissions', 'auth_permission', 'auth_user_groups', 'auth_user_info', 'auth_user_user_permissions')


  2.数据库路由器(文件 core.database 里面的写法)
    class DatabaseSelectRouter(object):

        def db_for_read(self, model, **hints):
            database = getattr(model, "_database", model._meta.app_label) # _database 是自定义的一个指定库名的属性(默认是读取 model._meta.app_label)
            if database:
                return database
            else:
                if model._meta.db_table in settings.DATABASE_ROUTERS_ADMIN_TABLES:
                    return 'admin'
                return "default"

        def db_for_write(self, model, **hints):
            database = getattr(model, "_database", model._meta.app_label)
            if database:
                return database
            else:
                if model._meta.db_table in settings.DATABASE_ROUTERS_ADMIN_TABLES:
                    return 'admin'
                return "default"

        def allow_relation(self, obj1, obj2, **hints):
            """
            Relations between objects are allowed if both objects are
            in the master/slave pool.
            """
            db_list = ('default', 'admin', 'ucenter', 'common', 'employee')
            if obj1._state.db in db_list and obj2._state.db in db_list:
                return True
            return None

        def allow_migrate(self, db, model):
            """
            All non-auth models end up in this pool.
            """
            return True

  3.model 写法
    from django.db import models
    class Person(models.Model):
        _database = 'employee' # 自定义一个属性来指定库名

        created_at = models.DateTimeField('created_at', auto_now_add = True)
        updated_at = models.DateTimeField('updated_at', auto_now = True)
        name = models.CharField("name", max_length = 20)
        age = models.IntegerField("age")
        amount = models.DecimalField('账单总金额', max_digits=10, decimal_places=4, default=0.0, db_column='c_total_amount')

        class Meta:
            db_table = 'persons'
            app_label = 'employee' # 默认的指定库名的属性
            ordering = ('age',)
            unique_together = ('name', 'age') # 联合唯一索引


案例3(指定 Manager 的查询条件)
    from django.db import models

    # 自定义一种 Manager
    class MyManager(models.Manager):
        def get_queryset(self):
            return super(MyManager, self).get_queryset().filter(is_delete=False) # 指定查询提交(也可以执行其他操作)

    class DeleteManager(models.Manager):
        def get_queryset(self):
            return super(DeleteManager, self).get_queryset().filter(is_delete=True)

    class Department(models.Model):

        objects = MyManager() # 使用自定义的 Manager 代替原来的
        del_objects = DeleteManager() # 也可以多定义一种 Manager

        id = models.UUIDField(primary_key=True, default=uuid.uuid4, db_column='c_id')
        company = models.ForeignKey('ucenter.Company', verbose_name='企业ID', max_length=32, default='123', db_column='c_company_id')
        name = models.CharField(verbose_name='部门名称', max_length=30, db_column='c_name')
        sup_deparment = models.ForeignKey('self', verbose_name='上级部门', related_name='children', null=True, db_column='c_sup_deparment_id')
        level = models.SmallIntegerField(verbose_name="级别", default=1, db_column='c_level')
        is_delete = models.BooleanField(verbose_name="是否删除", default=False, db_column="c_is_delete")
        add_by = models.ForeignKey('ucenter.UserInfo', verbose_name='创建人', related_name='create_deps', db_column='c_add_by', on_delete=models.DO_NOTHING)
        add_dt = models.DateTimeField(auto_now_add=True, db_column='c_add_dt')
        update_by = models.ForeignKey('ucenter.UserInfo', verbose_name='修改人', related_name='update_deps', db_column='c_update_by', on_delete=models.DO_NOTHING)
        update_dt = models.DateTimeField(auto_now=True, verbose_name='更新时间', db_column='c_update_dt')

        class Meta:
            db_table = 't_department'
            verbose_name = '部门基础信息'

    # 使用时(使用自定义的 Manager)
    Department.objects.get(id=i.obj_id)
    Department.del_objects.filter(id=i.obj_id).values()

