
来自:  http://www.cnblogs.com/holbrook/archive/2012/03/18/2405036.html

ORM的继承关系
    ORM中通常将对象引用映射到外键，但是对于继承，关系数据库中没有自然有效的方法来对应。
    从数据存储的角度来看，在映射继承关系时，可以采用几种方式（参考JPA中的InheritanceType.定义）：

    1.使用单个表，在JPA中称作 SINGLE_TABLE。整个继承树共用一张表。使用唯一的表，包含所有基类和子类的字段。
    2.每个具体类一张表，在JPA中称作 TABLE_PER_CLASS。 这种方式下，每张表都包含具体类和继承树上所有父类的字段。因为多个表中有重复字段，从整个继承树上来说，字段是冗余的。
    3.每个类一张表，继承关系通过表的JOIN操作来表示。在JPA中称作 JOINED。 这种方式下，每个表只包含类中定义的字段，不存在字段冗余，但是要同时操作子类和所有父类所对应的表。

    Django的ORM也支持上述三种继承策略，同时，得益于python的动态特性，还支持代理模型和多重继承关系的映射。


JOINED 映射
    如果在Django中实现了Model的继承关系，如下：

        from django.db import models

        class Person(models.Model):
            name = models.CharField(maxlength=10)

        class Man(Person):
            job = models.CharField(maxlength=20)

        class Woman(Person):
            makeup = models.CharField(maxlength=20)


    则使用 manage.py 执行sqlall命令时，会看到这样的结果：

        CREATE TABLE "uom_person" (
        "id" integer NOT NULL PRIMARY KEY,
        "name" varchar(10) NOT NULL
        );

        CREATE TABLE "uom_man" (
        "person_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "uom_person" ("id"),
        "job" varchar(20) NOT NULL
        );

        CREATE TABLE "uom_woman" (
        "person_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "uom_person" ("id"),
        "makeup" varchar(20) NOT NULL
        );

    可见，Django ORM中默认使用 JOINED 方式来实现继承关系的映射。


TABLE_PER_CLASS映射
    如果要实现每个具体类一张表，只需要将父类指定为抽象类(abstract)，这样就不会创建父类对应的表，而将父类的字段复制到子类中去映射。如下：

        from django.db import models

        class Person(models.Model):
            name = models.CharField(max_length=10)

            class Meta:
                abstract = True

        class Man(Person):
            job = models.CharField(max_length=20)

        class Woman(Person):
            makeup = models.CharField(max_length=20)

    sqlall 的结果：

        CREATE TABLE "uom_man" (
        "id" integer NOT NULL PRIMARY KEY,
        "name" varchar(10) NOT NULL,
        "job" varchar(20) NOT NULL
        );

        CREATE TABLE "uom_woman" (
        "id" integer NOT NULL PRIMARY KEY,
        "name" varchar(10) NOT NULL,
        "makeup" varchar(20) NOT NULL
        );

    将父类声明为 abstract 时，该类将没有 objects 属性，也就是说没有 Manager 方法，所有无法进行数据操作，只有子类才能进行。


SINGLE_TABLE映射
    在 TABLE_PER_CLASS 的基础上，如果进一步指定子类的映射表名与父类的相同，则子类和父类将映射到同一张表，对所有的子类都这样指定，就可以实现SINGLE—_TABLE映射：

        from django.db import models

        class Person(models.Model):
            name = models.CharField(max_length=10)
            class Meta:
                abstract = True

        class Man(Person):
            job = models.CharField(max_length=20)
            class Meta:
                db_table = 'oum_person'

        class Woman(User):
            makeup = models.CharField(max_length=20)

    sqlall 的结果：

        CREATE TABLE "oum_person" (
        "id" integer NOT NULL PRIMARY KEY,
        "name" varchar(10) NOT NULL,
        "job" varchar(20) NOT NULL
        );

        CREATE TABLE "uom_woman" (
        "user_ptr_id" integer NOT NULL PRIMARY KEY,
        "makeup" varchar(20) NOT NULL
        );

    上面的例子中只指定了一个子类，可以看出因为是在子类上指定，所以Django ORM更加灵活，可以控制单个子类的映射方式，从而实现任意的映射结构。


代理模型
    有这样一种常见的场景：使用某些库(lib)中的类，只是想扩展一些方法，而不想改变其数据存储结构。
    在Python中，可以通过在 Meta 类中增加约束 proxy=True 来实现。此时“子类”称为“父类”的代理类，子类中只能增加方法，而不能增加属性。
    比如上面的例子中，如果希望Person继承Django自带的User类，又不希望破坏User类的数据存储，则可以指定Person的proxy=True：

        from django.db import models
        from django.contrib.auth.models import User

        class Person(User):
        #    name = models.CharField(max_length=10)
            class Meta:
                proxy = True

            def do_something(self):
                ...

        class Man(Person):
            job = models.CharField(max_length=20)

        class Woman(Person):
            makeup = models.CharField(max_length=20)

    sqlall的结果为：

        CREATE TABLE "uom_man" (
        "user_ptr_id" integer NOT NULL PRIMARY KEY,
        "job" varchar(20) NOT NULL
        );

        CREATE TABLE "uom_woman" (
        "user_ptr_id" integer NOT NULL PRIMARY KEY,
        "makeup" varchar(20) NOT NULL
        );


多重继承(Multiple inheritance)
    python支持多重继承，尽管在Model层不推荐使用多重继承，但Django的ORM还是支持这样的使用方式：

        from django.db import models

        class Mixin1(models.Model):
            attr1 = models.CharField(max_length=10)

        class Mixin2(models.Model):
            attr1 = models.CharField(max_length=10)

        class Multiple(Mixin1, Mixin2):
            attr3 = models.CharField(max_length=10)

    sqlall的结果是：

        CREATE TABLE "uom_mixin1" (
        "id" integer NOT NULL PRIMARY KEY,
        "attr1" varchar(10) NOT NULL
        );

        CREATE TABLE "uom_mixin2" (
        "id" integer NOT NULL PRIMARY KEY,
        "attr1" varchar(10) NOT NULL
        );

        CREATE TABLE "uom_multiple" (
        "mixin2_ptr_id" integer NOT NULL UNIQUE REFERENCES "uom_mixin2" ("id"),
        "mixin1_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "uom_mixin1" ("id"),
        "attr3" varchar(10) NOT NULL
        );

    多重继承的时候，子类的ORM映射会选择第一个父类作为主键管理，其他的父类作为一般的外键管理。

    这里要记住 Python 的名称解析规则。如果某个特定名称 (例如，Meta) 出现在第一个基类当中，那么子类就会使用第一个基类的该特定名称。
    例如，如果多重父类都包含 Meta 内嵌类，只有第一个基类的 Meta 才会被使用，其他的都被会忽略。


Meta 继承
    创建抽象基类的时候，Django 会将你在基类中所声明的有效的 Meta 内嵌类做为一个属性。
    如果子类没有声明它自己的 Meta 内嵌类，它就会继承父类的 Meta 。
    子类的 Meta 也可以直接继承父类的 Meta 内嵌类，对其进行扩展。例如：

        from django.db import models

        class CommonInfo(models.Model):
            name = models.CharField(max_length=100)
            age = models.PositiveIntegerField()
            class Meta:
                abstract = True
                ordering = ['name']

        class Student(CommonInfo):
            home_group = models.CharField(max_length=5)
            class Meta(CommonInfo.Meta):
                db_table = 'student_info'

    sqlall结果：

        CREATE TABLE "student_info" (
            "id" integer NOT NULL PRIMARY KEY,
            "name" varchar(100) NOT NULL,
            "age" integer unsigned NOT NULL,
            "home_group" varchar(5) NOT NULL
        );

    按照我们指定的名称 student_info 生成了table。

    继承时，Django 会对基类的 Meta 内嵌类做一个调整：在安装 Meta 属性之前，Django 会设置 abstract=False。
    这意味着抽象基类的子类不会自动变成抽象类。当然，你可以让一个抽象类继承另一个抽象基类，不过每次都要显式地设置 abstract=True 。

    对于抽象基类而言，有些属性放在 Meta 内嵌类里面是没有意义的。
    例如，包含 db_table 将意味着所有的子类(是指那些没有指定自己的 Meta 内嵌类的子类)都使用同一张数据表，一般来说，这并不是我们想要的。


小心使用 related_name (Be careful with related_name)
    如果你在 ForeignKey 或 ManyToManyField 字段上使用 related_name 属性，你必须总是为该字段指定一个唯一的反向名称。
    但在抽象基类上这样做就会引发一个很严重的问题。因为 Django 会将基类字段添加到每个子类当中，而每个子类的字段属性值都完全相同 (这里面就包括 related_name)。
    注：这样使用 ForeignKey 或 ManyToManyField 反向指定时就无法确定是指向哪个子类了。

    当你在(且仅在)抽象基类中使用 related_name 时，如果想绕过这个问题，就要在属性值中包含  '%(app_label)s' 和 '%(class)s'字符串。
        1.'%(class)s'会被子类的名字取代。
        2.'%(app_label)s'会被子类所在的app的名字所取代。

    举例，在app common中，common/models.py：

        from django.db import models

        class Base(models.Model):
            m2m = models.ManyToManyField(OtherModel, related_name="%(app_label)s_%(class)s_related")

          class Meta:
            abstract = True

        class ChildA(Base):
            pass

        class ChildB(Base):
            pass


    在另外一个app中，rare/models.py：

        class ChildB(Base):
            pass

    那么 common.ChildA.m2m 字段的反向名称为 common_childa_related, common.ChildB.m2m字段的反向名称为 common_childb_related, rare app中rare.ChildB.m2m字段的反向名称为rare_childb_related.

    如果你没有在抽象基类中为某个关联字段定义 related_name 属性，那么默认的反向名称就是子类名称加上 '_set'，它能否正常工作取决于你是否在子类中定义了同名字段。
    例如，在上面的代码中，如果去掉 related_name 属性，在 ChildA 中，m2m 字段的反向名称就是 childa_set；而 ChildB 的 m2m 字段的反向名称就是 childb_set 。


不允许"隐藏"字段(Field name "hiding" is not permitted)

    普通的 Python 类继承允许子类覆盖父类的任何属性。但在 Django 中，重写 Field 实例是不允许的(至少现在还不行)。
    如果基类中有一个 author 字段，你就不能在子类中创建任何名为 author 的字段。

    重写父类的字段会导致很多麻烦，比如：初始化实例(指定在 Model.__init__ 中被实例化的字段) 和序列化。
    而普通的 Python 类继承机制并不能处理好这些特性。所以 Django 的继承机制被设计成与 Python 有所不同，这样做并不是随意而为的。

    这些限制仅仅针对做为属性使用的 Field 实例，并不是针对 Python 属性，Python 属性仍是可以被重写的。
    在 Python 看来，上面的限制仅仅针对字段实例的名称：如果你手动指定了数据库的列名称，那么在多重继承中，你就可以在子类和某个父类当中使用同一个列名称。(因为它们使用的是两个不同数据表的字段)。

    如果你在任何一个父类中重写了某个 model 字段，Django 都会抛出 FieldError 异常。


小结
    Django ORM 在映射继承关系时非常灵活，不仅能够实现 JPA 约定的 SINGLE_TABLE、 TABLE_PER_CLASS、 JOINED 三种方式，还可以灵活的自定义；甚至通过python的动态语言特性，支持代理模型和多重继承的功能。
    但是正因为灵活，所以在使用的时候一定要非常注意，通过manage.py的sqllall功能，观察产生的sql语句，可以验证继承的实现机制，避免带来意想不到的问题。


