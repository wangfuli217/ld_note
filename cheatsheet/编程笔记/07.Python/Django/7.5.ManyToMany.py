
ManyToManyField 用法

####### 范例 1 ########
    from django.db import models

    class Person(models.Model):
        name = CharField(max_length=30)

    class Book(models.Model):
        auther = ManyToManyField(Person)

    class ForeignBook(models.Model):
        #当关联同一个模型的字段大于一个时，要使用related_name参数来指定表名
        auther = ManyToManyField(Person,related_name="auther")
        translater = ManyToManyField(Person,related_name="translater")


    # new 对象
    p = Person.objects.create(name='john')
    b = Book()

    # 添加关联
    b.auther = Person.objects.filter(name='Joe')[:3] # 可一次性添加多个关联
    b.auther.add(p) # 添加一个关联

    # 去除关联
    b.auther.remove(p)

    # 返回所有作者
    b.auther.all()

    # 反向查询 Book ，返回这个人写的所有书,book即为反向查询的模型名
    p.book_set.all()

    # 反向查询 ForeignBook 表 p.book_set.all() 不可用，取而代之的为
    # 返回该人写的所有书， book_set 被 related_name 中指定的表名代替
    p.auther.all()

    # 返回该人翻译的所有书
    p.translater.all()

    # 在模板中访问 ManyToManyField 的字段
    {% for i in b.auther.all %} # 不需要在 all 后面加“()”符号，也不允许这样做。
        {{ i.name }}
    {% endfor %}


####### 范例 2 ########

    # 上面会自动隐含地生成中介表， 用来关联 Person 与 Book 的关系， 而这中介表也可以自定义。
    # 通过在ManyToMany字段中指定through参数可以指定用作中介的中间模型。
    class Person(models.Model):
        name = models.CharField(max_length=128)

    class Group(models.Model):
        name = models.CharField(max_length=128)
        members = models.ManyToManyField(Person, through='Membership') # 指定中介模型

    class Membership(models.Model):
        person = models.ForeignKey(Person)
        group = models.ForeignKey(Group)
        date_joined = models.DateField()
        invite_reason = models.CharField(max_length=64)

    # new 对象
    p1 = Person.objects.create(name="Ringo Starr")
    p2 = Person.objects.create(name="Paul McCartney")
    g = Group.objects.create(name="The Beatles")

    # 加入到中介表
    m1 = Membership(person=p1, group=g, date_joined=date(1962, 8, 16),invite_reason= "Needed a new drummer.")
    m1.save()

    # 返回所有组员
    g.members.all() # 打印: [<Person: Ringo Starr>]

    # 返回此组员所在的所有组
    p1.group_set.all() # 打印: [<Group: The Beatles>]

    # 再一个组员到中介表
    m2 = Membership.objects.create(person=p2, group=g, date_joined=date(1960, 8, 1), invite_reason= "Wanted to form a band.")
    g.members.all() # 打印: [<Person: Ringo Starr>, <Person: Paul McCartney>]


    # 与普通的多对多字段不同的是，不能使用 add, create, remove 命令
    # 也不能通过直接赋值（例如 g.members = […]）的方式来创建关系
    # 下面操作是 不会被运行的：
    g.members = [p1, p2,]
    g.members.add(p1)
    g.members.remove(p1)
    g.members.create(name="George Harrison")

    # 因为你需要通过模型 Membership 指出多对多关系的所有细节，所以不能直接创建 Person 和 Group 之间的关系。
    # 简单地使用add，create命令，或者通过直接赋值这些方式并不能指明这些细节。
    # 因此，在通过中间模型表达多对多关系的情形中，这些命令是被禁用的。
    # 创建这种类型的关系的唯一方式就是只能通过创建中间模型的实例来实现。
    # 但是，可以使用 clear() 方法来移除一个实例的所有多对多关系：
    g.members.clear() # 移除一个实例的所有多对多关系, 可运行

    # 一旦通过创建中间模型的实例建立起了多对多关系，就可以执行查询了。
    # 就像对待普通的多对多关系一样，你可以使用多对多关系关联的模型的属性来执行查询：

    # 找出所有的组，这些组中含有成员名字以'Paul'开头的记录
    Group.objects.filter(members__name__startswith='Paul') # 打印: [<Group: The Beatles>]

    # 使用一个中间模型时，你也可以直接查询它的属性：
    # 找出1961年1月1日之后加入Beatles组的所有成员
    Person.objects.filter(group__name='The Beatles', membership__date_joined__gt=date(1961,1,1)) # 打印: [<Person: Ringo Starr]
