
Django中内置的权限控制
    参考博客:  http://www.cnblogs.com/esperyong/

1. User 模型(Model)
    在 Django 的世界中, 在权限管理中有内置的 Authentication 系统。
    用来管理帐户, 组, 和许可。还有基于 cookie 的用户 session 。

    Django内置的权限系统包括以下三个部分:

    用户(Users)
    许可(Permissions): 用来定义一个用户(user)是否能够做某项任务(task)
    组(Groups): 一种可以批量分配许可到多个用户的通用方式
    消息(Messages)
    首先需要在Django中安装这个组件:

    将'django.contrib.auth'和'django.contrib.contenttypes'放到 settings.py 中的 INSTALLED_APPS 中。
    (使用 contenttypes 的原因是 auth 中的 Permission 模型依赖于 contenttypes)
    执行manage.py syncdb
    装好了就可以开始使用了；我们可以执行 manage.py shell 来启动脚本, 对其中的一些API进行学习和使用。


    User 模型
        User 模型对应于一个用户, 一个帐户, 位于'django.contrib.auth.models'模块中。
        User对象有两个多对多的属性分别是:  groups 和 user_permissions :

            from django.contrib.auth.models import User
            es = User.objects.create_user('esperyong','esperyong@gmail.com','123456')
            print es.groups # 打印: <django.db.models.fields.related.ManyRelatedManager at 0x10d0642d0>
            print es.user_permissions # 打印: <django.db.models.fields.related.ManyRelatedManager at 0x10d014c50>

        从上面的代码中的后两行输出我们可以看到,  User 的这两个多对多属性, 都是关于 ManyRelatedManager 的引用。
        因此我们可以像对所有对多关系属性一样使用:

            直接将一个列表赋值给该属性:
            es.groups = [group_list]
            es.user_permissions = [permission_list]

            使用add方法将对象加入:
            es.groups.add(group, group, ...)
            es.user_permissions.add(permission, permission, ...)

            使用remove方法将对象删除:
            es.groups.remove(group, group, ...)
            es.user_permissions.remove(permission, permission, ...)

            使用clear方法将所有对象删除:
            es.groups.clear()
            es.user_permissions.clear()


    User 对象有以下几个属性:
        username: 字符串类型。必填。30个字符以内。
        first_name: 字符串类型。可选。30个字符以内。
        last_name: 字符串类型。可选。30个字符以内。
        email: 可选。
        password: 明文密码的hash或者是某种元数据。该属性不应该直接赋值明文密码, 而应该通过 set_password() 方法进行赋值。
        is_staff: Boolean 类型。用这个来判断是否用户可以登录进入admin site。
        is_active: Boolean 类型。用来判断该用户是否是可用激活状态。在删除一个帐户的时候, 可以选择将这个属性置为 False, 而不是真正删除。这样如果应用有外键引用到这个用户, 外键就不会被破坏。
        is_superuser: Boolean 类型。该属性用来表示该用户拥有所有的许可, 而无需明确的赋予给他。
        last_login: datetime 类型。最近一次登陆时间。
        date_joined: datetime 类型。创建时间。

    User 对象有以下特有方法(除了 Django Model 对象的通用方法之外的方法):
        1. is_anonymous():
            永远返回 False 。 用来将 User 对象和 AnonymousUser (未登录的匿名用户)对象作区分用的识别方法。通常, 最好用 is_authenticated()方法。
        2. is_authenticated():
            永远返回 True 。该方法不代表该用户有任何的许可, 也不代表该用户是 active 的, 而只是表明该用户提供了正确的 username 和 password 。
        3. get_full_name():
            返回一个字符串, 是first_name和last_name中间加一个空格组成。
        4. set_password(raw_password):
            调用该方法时候传入一个明文密码, 该方法会进行hash转换。该方法调用之后并不会保存User对象。
        5. check_password(raw_password):
            如果传入的明文密码是正确的返回 True 。该方法和 set_password 是一对, 也会考虑hash转换。
        6. set_unusable_password():
            将用户设置为没有密码的状态。调用该方法后, check_password()方法将会永远返回 False 。但是如果, 调用 set_password()方法重新设置密码后, 该方法将会失效,  has_usable_password()也会返回 True 。
        7. has_usable_password():
            在调用set_unusable_password()方法之后, 该方法返回False, 正常情况下返回True。
        8. get_group_permissions(obj=None):
            返回该用户通过组所拥有的许可(字符串列表每一个代表一个许可)。obj如果指定, 将会返回关于该对象的许可, 而不是模型。
        9. get_all_permissions(obj=None):
            返回该用户所拥有的所有的许可, 包括通过组的和通过用户赋予的许可。
        10. has_perm(perm,obj=None):
            如果用户有传入的 perm, 则返回 True 。 perm 可以是一个格式为: '<app label>.<permission codename>'的字符串。如果 User 对象为 inactive , 该方法永远返回 False 。和前面一样, 如果传入obj, 则判断该用户对于这个对象是否有这个许可。
        11. has_perms(perm_list,obj=None):
            和 has_perm 一样, 不同的地方是第一个参数是一个 perm 列表, 只有用户拥有传入的每一个perm, 返回值才是 True 。
        12. has_module_perms(package_name):
            传入的是Django app label, 按照'<app label>.<permission codename>'格式。当用户拥有该app label下面所有的 perm 时, 返回值为 True 。如果用户为 inactive , 返回值永远为 False 。
        13. email_user(subject,message,from_email=None):
            发送一封邮件给这个用户, 依靠的当然是该用户的email属性。如果from_email不提供的话,  Django 会使用 settings 中的 DEFAULT_FROM_EMAIL 发送。
        14. get_profile():
            返回一个和 Site 相关的 profile 对象, 用来存储额外的用户信息。

    User 对象的 Manager, UserManager:
        和其他的模型一样, User 模型类的 objects 属性也是一个 Manager 对象, 但是 User 的 Manager 对象是自定义的, 增加了一些方法:
        1. create_user(username,email=None,password=None):
            该方法创建保存一个 is_active=True 的 User 对象并返回。username 不能够为空, 否则抛出 ValueError 异常。 email 和 password 都是可选的。email 的 domain 部分会被自动转变为小写。 password 如果没有提供, 则 User 对象的 set_unusable_password()方法将会被调用。
        2. make_random_password(length=10,allowed_chars='abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'):
            该方法返回一个给定长度和允许字符集的密码。其中默认的 allowed_chars 有一些字符没有, 比如o,i,l,O,I,0,l等等。


2. User Profile 存储用户的额外信息
    上面我们引出了 Django 内置的权限控制系统, 讲了安装, 和最核心和基本的 User 模型的API和其 Manager 的API。
    接下来我们继续深入下去, 使用 User 对象做一些事情, 首先当然就是创建一个 User 对象了。
    让我们执行 python manage.py shell 启动 Django 的 shell:

    创建 User:
        from django.contrib.auth.models import User
        user = User.objects.create_user('esperyong', 'esperyong@gmail.com', '123456')
        # 现在一个 is_active 属性(是否是可用激活状态)为 True 的 User 对象已经创建并存入数据库中了。
        # 接下来我们可以对其属性进行修改, 然后存入数据库。
        user.is_staff = True # 让用户可以登录进入 admin site
        user.save()

    修改密码:
        1.用代码的方式, 可以使用上面讲过的 set_password 方法进行设置, 最后存入数据库的将是进行过hash转换的密文。
            from django.contrib.auth.models import User
            u = User.objects.get(username__exact='esperyong')
            u.set_password('new password')
            u.save()

        2. 用 python manage.py changepassword *username* 来进行修改, 需要输入两次密码。
            千万不要直接给 User 的 password 属性赋值, 因为里面保存的不是明文密码。


    匿名用户, AnonymousUser:
        django.contrib.auth.models.AnonymousUser 是实现了 User 接口的类。
        在用户还没有用权限系统登陆的时候, 在 request.user 中使用的就是该对象, 用户可以通过调用 is_anonymous()方法来验证是否为匿名用户。
        以下是该对象和 User 对象的差异:
            id 永远是 None
            is_staff 和 is_superuser 永远为 False
            groups 和 user_permissions 永远为空
            is_anoymous() 为 True
            is_authenticated() 为 False
            set_password(),check_password(),save(),delete(),set_groups() 和 set_permissions() 抛出 NotImplementedError.


    使用 UserProfile 存储用户的额外信息 :
        在 Django 中, 有一种机制可以让你存储和 User 在某个 Site 相关的一些信息到一个对象中, 这个对象就是 UserProfile。

        1.首先, 我们需要定义这个模型, 这个模型需要一个和User模型相关的一对一关系属性, 如下:

            from django.contrib.auth.models import User
            class UserProfile(models.Model):
                # 和User的一对一关系属性, 该属性必填.
                user = models.OneToOneField(User)

                # 其他需要存储的属性
                # User 因为是 Django 提供的, 如果想要在其上增加一些自己需要的字段和方法, 不太好加入, 因此 UserProfile 是达成这个目标的一个有利工具
                accepted_eula = models.BooleanField()
                favorite_animal = models.CharField(max_length=20, default="Dragons.")

        2.接下来要在 settings 中声明一个变量, 变量名为 AUTH_PROFILE_MODULE, 值为 appname.profile 类名, 如下:

            AUTH_PROFILE_MODULE = 'accounts.UserProfile'

        这样, 我们的 User 对象的 get_profile() 方法就会返回这个对象了。
        需要注意的一点是, UserProfile 对象不会和 User 一起自动创建, 需要以某种方式自己搞定这件事情。
        最合理的最 Djangoist 的方式就是注册一个 handler 到 User 的 post_save signal 了。
        具体请参阅Django的文档, 例:

            # 在 models.py

            from django.contrib.auth.models import User
            from django.db.models.signals import post_save

            # 定义了 UserProfile 类
            # ...

            def create_user_profile(sender, instance, created, **kwargs):
                if created:
                    UserProfile.objects.create(user=instance)

            post_save.connect(create_user_profile, sender=User)


3. 登陆(login) 和 登出(logout)
    在Web应用中, 任何的权限系统要做的第一步就是用户识别, 也就是我们常说的登陆(login)。
    只有正确的登陆校验, 知道用户是谁了, 才能够知道用户能干什么, 那就是许可(Permission)需要负责解决的事情, 而Group则是批量设置许可的时候的一个便利手段了。

    Web请求的认证:
        django 有一套方法, 可以在每个 view 方法能够接收到的 request 对象中增加权限验证相关的方法。
        要做到这一点, 首先需要安装 SessionMiddleware 和 AuthenticationMiddleware 。
        安装方法在 settings 文件中对 MIDDLEWARE_CLASSES 变量增加上述两个 Middleware 类。

        Middleware 的设计几乎在任何web框架中都有体现, 只不过叫法和具体实现的手段不尽相同, 例如在struts2中叫做interceptor拦截器, 采用函数递归Stack的方式实现(其它框架没见过有这么干的)。
        设计思路都是在 request 进入最后的处理方法之前经过一个个前处理, 在处理方法处理完之后再经过一个个后处理, 前后的次序恰好相反。有点点走题, 请看例子:
            MIDDLEWARE_CLASSES = (
                'django.contrib.sessions.middleware.SessionMiddleware',
                'django.middleware.locale.LocaleMiddleware',
                'django.middleware.common.CommonMiddleware',
                'django.middleware.csrf.CsrfViewMiddleware',
                'django.contrib.auth.middleware.AuthenticationMiddleware',
                'django.contrib.messages.middleware.MessageMiddleware',
                'django.middleware.transaction.TransactionMiddleware',
            )

        一旦安装好了之后, 在 view 中, 我们就可以使用 request.user 获取当前的登陆用户 User 对象。
        如果当前用户没有登陆, 那么 request.user 将会是我们之前所说的 AnonymousUser 对象。
        我们可以用 User 对象的 is_authenticated() 方法将这两者区分开来:

            if request.user.is_authenticated():
                # 做一些事情针对验证用户.
            else:
                # 做一些事情对于匿名未登录用户.

    如何登陆一个用户呢？
        需要两个函数结合使用: authenticate(username,password)和 login(request,user),位于 django.contrib.auth 模块中；

        1. authenticate(username,password)
            如果校验通过则返回 User 对象, 如果校验不通过返回 None, 例如:

            from django.contrib.auth import authenticate
            user = authenticate(username='john', password='secret')
            if user is not None:
                if user.is_active:
                    print "You provided a correct username and password!"
                else:
                    print "Your account has been disabled!"
            else:
                print "Your username and password were incorrect."

        2. login 接受两个参数, 第一个 request 对象, 第二个是 user 对象。
            login 方法使用 SessionMiddleware 将 userID 存入 session 当中。
            注意, 在用户还未登录的时候, 也存在着匿名用户的 session, 在其登陆之后, 之前在匿名 Session 中保留的信息, 都会保留下来。
            这两个方法要结合使用, 而且必须要先调用 authenticate(), 因为该方法会 User 的一个属性上纪录该用户已经通过校验了, 这个属性会被随后的 login 过程所使用,例如:

            from django.contrib.auth import authenticate, login

            def my_view(request):
                username = request.POST['username']
                password = request.POST['password']
                user = authenticate(username=username, password=password)
                if user is not None:
                    if user.is_active:
                        login(request, user)
                        # 跳转到成功页面.
                    else:
                        # 返回一个无效帐户的错误
                else:
                    # 返回登录失败页面。


        我们也可以不用 authenticate()进行特定于一个用户的身份校验, 直接使用和 User 无关的几个函数进行密码相关的校验, 在Django1.4中以及新版本中提供以下方法, 位于模块 django.contrib.auth.hashers:
            1. check_password(password,encoded):
                第一个参数是明文密码, 第二个参数是加密过的密码。如果通过校验返回 True, 不通过返回 False ；
            2. make_password(password[,salt,hashers]):
                根据给定的明文密码, salt, 和 Django 支持的加密算法, 返回一个加密的密码。如果 password 提供的值为 None, 那么该返回值将永远通不过check_password()方法。这个返回值是一个特定的约定值, 目前是'!';
            3. is_password_usable(encoded_password):
                判断是否给定字符串是一个hashed密码, 有机会通过 check_password()函数的校验。


    如何登出(logout)一个用户？
        我们使用 django.contrib.auth.logout 函数来登出用 django.contrib.auth.login 函数登入的用户。

        logout(requet)
            函数只有一个参数, 就是 request 。没有返回值, 而且即使当前用户没有登陆也不会抛出任何异常。

                from django.contrib.auth import logout

                def logout_view(request):
                    logout(request)
                    # 重定向到成功登出界面

            这个方法, 会将存储在用户 session 的数据全部清空, 这样避免有人用当前用户的浏览器登陆然后就可以查看当前用户的数据了, 回想一下 login 会保留 anonymous 用户的 session 数据。
            如果需要将一些东西加入到登出之后的用户 session, 那么需要在 logout 方法调用之后再进行。


    Login 和 Logout 的两个 signal
        Django 的 signal 体系是一套简单实用的事件定义、事件产生、事件监听、事件处理框架, 具体可以参看 Django 关于 signal 的文档。
        在登陆和登出这两个重要的点上, 提供了两个signal:
            1. django.contrib.auth.signals.user_logged_in
            2. django.contrib.auth.signals.user_logged_out

        有三个参数会随 singal 传过来:
            1. sender:  user 的 class, 如果是 logout 事件该值有可能是 None 如果用户根本就没有验证通过。
            2. request: HttpRequest 对象
            3. user: user 对象, 如果是 logout 事件该值有可能是 None 如果用户根本就没有验证通过。


        一个经常性的简单需求就是控制某些 view 只对登陆用户开放, 如果未登录用户请求该 view 则跳转到登录界面让其登陆。
        要做到这一点, 我们可以这样做:

            from django.http import HttpResponseRedirect

            def my_view(request):
                if not request.user.is_authenticated():
                    return HttpResponseRedirect('/login/?next=%s' % request.path)
                # ...

        也可以这样做, 返回一个错误的页面:

            def my_view(request):
                if not request.user.is_authenticated():
                    return render_to_response('myapp/login_error.html')
                # ...

        更为优雅的方式是用 decorator:
            django.contrib.auth.decorators.login_required([redirect_field_name=REDIRECT_FIELD_NAME,login_url=None])
            login_required()装饰器函数做了以下事情:
                1. 如果当前用户没有登陆, 跳转到settings.LOGIN_URL,并传递当前的绝对路径到URL请求参数中, 例如: /accounts/login/?next=/polls/3/
                2. 如果当前用户已经登陆了, 执行view方法。在view中的方法可以认为当前用户已经登陆了
                。

            login_required方法接受两个参数:
                1. redirect_field_name:默认值是next。用来定义登陆成功之后的跳回之前访问界面的url。
                2. login_url:默认值是settings.LOGIN_URL。用来指定登陆界面的url。如果不传入改参数, 就需要确保settings.LOGIN_URL的值是正确设置的。

        没有参数的 login_required 装饰器使用方法:
            from django.contrib.auth.decorators import login_required

            @login_required
            def my_view(request):
                ...

        传递参数的方法:
            from django.contrib.auth.decorators import login_required

            @login_required(redirect_field_name='my_redirect_field')
            def my_view(request):
                ...


            from django.contrib.auth.decorators import login_required

            @login_required(login_url='/accounts/login/')
            def my_view(request):
                ...


4. Authorization 授权
    许可(Permissions)
        Permissions 设置, 主要通过 Django 自带的 Admin 界面进行维护。
        主要通过设置某些用户对应于某类模型的 add\change\delete 三种类型的权限, 即是设置某些人对某些模型能够增加、修改、删除的权限设置。
        Permission不仅仅能够设置某类模型, 还可以针对一个模型的某一个对象进行设置。

        其实, 当我们在 django 中安装好了 auth 应用之后, Django 就会被每一个你安装的 app 中的 Model 创建三个权限: add,change,delete;相应的数据, 就是在你执行python manage.py syncdb之后插入到数据库中的。
        每一次你执行syncdb,Django都会为每个用户给新出现的Model增加这三个权限。

        例如, 你创建了一个应用叫做school,里面有一个模型叫做StudyGroup,那么你可以用任何一个user对象执行下面的程序, 其结果都返回 True:

            user.hash_perm('school.add_studygroup')
            user.hash_perm('school.change_studygroup')
            user.hash_perm('school.delete_studygroup')

        当然, 我们也可以自己定义一些许可。方法很简单, 就是在 Model 类的 meta 属性中添加 permissions 定义。
        比方说, 创建了一个模型类叫做Discussion, 我们可以创建几个权限来对这个模型的权限许可进行控制, 控制某些人可以发起讨论、发起回复, 关闭讨论。

            class Discussion(models.Model):
                ...
                class Meta:
                    permissions = (
                        ("open_discussion", "Can create a discussion"),
                        ("reply_discussion", "Can reply discussion"),
                        ("close_discussion", "Can remove a discussion by setting its status as closed"),
                    )

        接下来要做的就是最后一步, 执行manage.py syncdb, 这样数据库中就有了这三个许可了。

        我们可以将上面的权限赋予用户, 方法有两种:

            1. 通过某一个user的user_permissions属性(文章1中有提及):
            user.user_permissions.add(permission, permission, ...)

            2. 通过user的一个组, 然后通过Group的permissions属性:
            group.permissions.add(permission, permission, ...)


        比如我们要判断一个用户是否有发讨论的权限, 我们可以用下面的代码:

            user.has_perm('school.open_discussion')

        Permission 类和 User 类没什么特殊的, 都是普通的DjangoModel。在第一篇文章中我们详细探讨了 User 模型的属性和方法。在这里我们探讨一下 Permission 模型和如何用编程的方式而不是通过预定义然后 syncdb 的方式创建 permission 。因为也许在某些时候, 需要动态创建并分配权限。


    用户组(Group)


