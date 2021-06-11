
一、MongoDB 数据库操作
  1. 连接数据库
    import pymongo
    conn = pymongo.Connection() # 连接本机数据库
    # conn = pymongo.Connection(host="192.168.1.202") # 连接指定IP的数据库
    db = conn.test # 进入指定名称的数据库
    users = db.users # 获取数据库里的 users 集合
    users = db['users'] # 获取数据库里的 users 集合,也可以用字典来获取

  2. 插入
    u = dict(name = "user1", age = 23)
    # db.users.save(u) # 用 save 也可以插入,返回新增的主键值
    db.users.insert(u) # 将数据插入到 users 集合,返回新增的主键值

  3. 更新
    # 更新指定一条记录
    u2 = db.users.find_one({"name":"user9"})
    u2['age'] += 3
    db.users.save(u2)  # 返回更新的主键值

    # 更新多条记录,返回 None
    db.users.update({"name":"user1"}, {"$set":{"age":100, "sex":0}}) # update users set age = 100, sex = 0 where name = 'user1'
    db.users.update({}, {"$inc":{"age":10}}, multi=True) # update users set age = age + 10
    db.users.update({"name":"user1"}, {"$inc":{"age":10}, "$set":{"sex":1}}) # update users set age = age + 10, sex = 1 where name = 'user1'

    # update() 有几个参数需要注意:
    db.集合名.update(criteria, objNew, upsert, mult)
    criteria: 需要被更新的条件表达式
    objNew: 更新表达式
    upsert: 如目标记录不存在，是否插入新文档。
    multi: 是否更新多个文档。

  4. 删除
    db.users.drop()  # 删除集合

    # remove() 用于删除单个或全部文档，删除后的文档无法恢复。
    id = db.users.find_one({"name":"user2"})["_id"]
    db.users.remove(id)  # 根据 id 删除一条记录
    db.users.remove()  # 删除集合里的所有记录
    db.users.remove({'yy':5}) # 删除yy=5的记录

  5. 查询
    # 查询 age 小于 15 的
    for u in db.users.find({"age":{"$lt":15}}): print u

  5.1 查询一条记录
    # 查询 name 等于 user8 的
    for u in db.users.find({"name":"user8"}): print u

    # 获取查询的一个
    u2 = db.users.find_one({"name":"user9"}) # 查不到时返回 None
    print u2

  5.2 查询特定键 (fields)
    # select name, age from users where age = 21
    for u in db.users.find({"age":21}, ["name", "age"]): print u
    for u in db.users.find(fields = ["name", "age"]): print u

  5.3 排序(SORT)
    pymongo.ASCENDING  # 也可以用 1 来代替
    pymongo.DESCENDING # 也可以用 -1 来代替
    for u in db.users.find().sort([("age", pymongo.ASCENDING)]): print u   # select * from 集合名 order by 键1
    for u in db.users.find().sort([("age", pymongo.DESCENDING)]): print u  # select * from 集合名 order by 键1 desc
    for u in db.users.find().sort([("键1", pymongo.ASCENDING), ("键2", pymongo.DESCENDING)]): print u # select * from 集合名 order by 键1 asc, 键2 desc
    for u in db.users.find(sort = [("键1", pymongo.ASCENDING), ("键2", pymongo.DESCENDING)]): print u # sort 的另一种写法
    for u in db.users.find({"name":"user9"}, sort=[['name',1],['sex',1]], fields = ["name", "age", 'sex']): print u  # 组合写法

  5.4 从第几行开始读取(SLICE)，读取多少行(LIMIT)
    # select * from 集合名 skip 2 limit 3
    # MySQL 的写法： select * from 集合名 limit 2, 3
    for u in db.users.find().skip(2).limit(3): print u
    for u in db.users.find(skip = 2, limit = 3): print u

    # 可以用切片代替 skip & limit (mongo 中的 $slice 貌似有点问题)。
    for u in db.users.find()[2:5]: print u

    # 单独的写
    for u in db.users.find().skip(2): print u
    for u in db.users.find(skip=1): print u
    for u in db.users.find().limit(5): print u
    for u in db.users.find(limit = 3): print u

  5.5 多条件查询(Conditional Operators)    # like 的可使用正则表达式查询
    # select * from users where name = 'user3' and age > 12 and age < 15
    for u in db.users.find({'age': {'$gt': 12, '$lt': 15}, 'name': 'user3'}): print u
    # select * from users where name = 'user1' and age = 21
    for u in db.users.find({"age":21, "name":"user1"}): print u

  5.6 IN
    for u in db.users.find({"age":{"$in":(23, 26, 32)}}): print u   # select * from users where age in (23, 26, 32)
    for u in db.users.find({"age":{"$nin":(23, 26, 32)}}): print u  # select * from users where age not in (23, 26, 32)

  5.7 统计总数(COUNT)
    print(db.users.count())  # select count(*) from users
    print(db.users.find({"age":{"$gt":30}}).count()) # select count(*) from users where age > 30

  5.8 OR
    for u in db.users.find({"$or":[{"age":25}, {"age":28}]}): print u  # select * from 集合名 where 键1 = 值1 or 键1 = 值2
    for u in db.users.find({"$or":[{"age":{"$lte":23}}, {"age":{"$gte":33}}]}): print u  # select * from 集合名 where 键1 <= 值1 or 键1 >= 值2

  6. 是否存在 (exists)
    db.users.find({'sex':{'$exists':True}})  # select * from 集合名 where exists 键1
    db.users.find({'sex':{'$exists':False}}) # select * from 集合名 where not exists 键1

  7. 正则表达式查询
    for u in db.users.find({"name" : {"$regex" : r"(?i)user[135]"}}, ["name"]): print u # 查询出 name 为 user1, user3, user5 的

  8. 多级路径的元素值匹配
    Document 采取 JSON-like 这种层级结构，因此我们可以直接用嵌入(Embed)代替传统关系型数据库的关联引用(Reference)。
    MongoDB 支持以 "." 分割的 namespace 路径，条件表达式中的多级路径须用引号

    # 如果键里面包含数组，只需简单匹配数组属性是否包含该元素即可查询出来
    db.集合名.find_one({'address':"address1"}) # address 是个数组，匹配时仅需包含有即可
    # 查询结果如：{"_id" : ObjectId("4c479885089df9b53474170a"), "name" : "user1", "address" : ["address1", "address2"]}

    # 条件表达式中的多级路径须用引号,以 "." 分割
    u = db.集合名.find_one({"im.qq":12345678})
    # 查询结果如：{"_id" : ObjectId("4c479885089df9b53474170a"), "name" : "user1", "im" : {"msn" : "user1@hotmail.com", "qq" : 12345678}}

    print u['im']['msn']  #显示： user1@hotmail.com

    # 多级路径的更新
    db.集合名.update({"im.qq":12345678}, {'$set':{"im.qq":12345}})

    # 查询包含特定键的
    for u in db.users.find({"im.qq":{'$exists':True}}, {"im.qq":1}): print u
    # 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "im" : { "qq" : 12345 } }


    for u in db.users.find({'data':"abc"}): print u
    # 显示如： { "_id" : ObjectId("4c47a481b48cde79c6780df5"), "name" : "user8", "data" : [ { "a" : 1, "b" : 10 }, 3, "abc" ] }
    for u in db.users.find({'data':{'$elemMatch':{'a':1, 'b':{'$gt':5}}}}): print u
    # 显示如： { "_id" : ObjectId("4c47a481b48cde79c6780df5"), "name" : "user8", "data" : [ { "a" : 1, "b" : 10 }, 3, "abc" ] }
    {data:"abc"} 仅简单匹配数组属性是否包含该元素。$elemMatch 则可以处理更复杂的元素查找条件。当然也可以写成如下方式：
    db.集合名.find({"data.a":1, "data.b":{'$gt':5}})

    对数组, 还可以直接使用序号进行操作：
    db.集合名.find({"data.1":3}) # 序号从0开始


    # 如集合的一列内容
    {"classifyid":"test1",
          "keyword":[
                {"name":'test1', # 将修改此值为 test5 (数组下标从0开始,下标也是用点)
                "frequence":21,
                },
                {"name":'test2', # 子表的查询，会匹配到此值
                "frequence":50,
                },
          ]
    }
    # 子表的修改(子表的其它内容不变)
    db.集合名.update({"classifyid":"test1"}, {"$set":{"keyword.0.name":'test5'}})
    # 子表的查询
    db.集合名.find({"classifyid":"test1", "keyword.0.name":"test2"})


  操作符
    $lt         小于
    $lte        小于等于
    $gt         大于
    $gte        大于等于
    $ne         不等于
    $in         in  检查目标属性值是条件表达式中的一员
    $nin        not in
    $set        set(用于 update 语句)
    $unset      与 $set 相反，表示移除文档属性。
    $inc        += (用于 update 语句)
    $exists     exists (判断是否存在，仅有 True 和 False 两个值)
    $all        属性值包含全部条件元素,注意和 $in 的区别
    $size       匹配数组属性元素的数量
    $type       判断属性类型
    $regex      正则表达式查询
    $elemMatch  子属性里的查询
    $push       向数组属性添加元素
    $pushAll    向数组属性添加元素
    $addToSet   和 $push 类似，不过仅在该元素不存在时才添加 (Set 表示不重复元素集合)
    $each       添加多个元素用
    $pop        移除数组属性的元素(按数组下标移除)
    $pull       按值移除
    $pullAll    移除所有符合提交的元素
    $where      用 JS 代码来代替有些丑陋的 $lt、$gt




二、Operator
  (1) $all: 判断数组属性是否包含全部条件。
    db.users.insert({'name':"user3", 'data':[1,2,3,4,5,6,7]})
    db.users.insert({'name':"user4", 'data':[1,2,3]})

    for u in db.users.find({'data':{'$all':[2,3,4]}}): print u
    # 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "name" : "user3", "data" : [ 1, 2, 3, 4, 5, 6, 7 ] }
    注意和 $in 的区别。$in 是检查目标属性值是条件表达式中的一员，而 $all 则要求属性值包含全部条件元素。

  (2) $size: 匹配数组属性元素数量。
    for u in db.users.find({'data':{'$size':3}}): print u
    # 只显示匹配此数组数量的： { "_id" : ObjectId("4c47a13bb48cde79c6780df1"), "name" : "user4", "data" : [ 1, 2, 3 ] }

  (3) $type: 判断属性类型。
    for u in db.users.find({'t':{'$type':1}}): print u  # 查询数字类型的
    for u in db.users.find({'t':{'$type':2}}): print u  # 查询字符串类型的

    类型值:
        double:1
        string: 2
        object: 3
        array: 4
        binary data: 5
        object id: 7
        boolean: 8
        date: 9
        null: 10
        regular expression: 11
        javascript code: 13
        symbol: 14
        javascript code with scope: 15
        32-bit integer: 16
        timestamp: 17
        64-bit integer: 18
        min key: 255
        max key: 127

  (4) $not: 取反，表示返回条件不成立的文档。
    似乎只能跟正则和 $mod 一起使用？？？？
    # 还不知如何使用

  (5) $unset: 和 $set 相反，表示移除文档属性。
    for u in db.users.find({'name':"user1"}): print u
    # 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "name" : "user1", "age" : 15, "address" : [ "address1", "address2" ] }

    db.users.update({'name':"user1"}, {'$unset':{'address':1, 'age':1}})
    for u in db.users.find({'name':"user1"}): print u
    # 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "name" : "user1" }

  (6) $push: 和 $ pushAll 都是向数组属性添加元素。# 好像两者没啥区别
    for u in db.users.find({'name':"user1"}): print u
    # 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "age" : 15, "name" : "user1" }

    db.users.update({'name':"user1"}, {'$push':{'data':1}})
    for u in db.users.find({'name':"user1"}): print u
    # 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "age" : 15, "data" : [ 1 ], "name" : "user1" }

    db.users.update({'name':"user1"}, {'$pushAll':{'data':[2,3,4,5]}})
    for u in db.users.find({'name':"user1"}): print u
    # 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "age" : 15, "data" : [ 1, 2, 3, 4, 5 ], "name" : "user1" }

  (7) $addToSet: 和 $push 类似，不过仅在该元素不存在时才添加 (Set 表示不重复元素集合)。
    db.users.update({'name':"user2"}, {'$unset':{'data':1}})
    db.users.update({'name':"user2"}, {'$addToSet':{'data':1}})
    db.users.update({'name':"user2"}, {'$addToSet':{'data':1}})
    for u in db.users.find({'name':"user2"}): print u
    # 显示： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1 ], "name" : "user2" }

    db.users.update({'name':"user2"}, {'$push':{'data':1}})
    for u in db.users.find({'name':"user2"}): print u
    # 显示： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1, 1 ], "name" : "user2" }

    要添加多个元素，使用 $each。
    db.users.update({'name':"user2"}, {'$addToSet':{'data':{'$each':[1,2,3,4]}}})
    for u in db.users.find({'name':"user2"}): print u
    # 显示： {u'age': 12, u'_id': ObjectId('4c479896089df9b53474170b'), u'data': [1, 1, 2, 3, 4], u'name': u'user2'}
    # 貌似不会自动删除重复

  (8) $each 添加多个元素用。
    db.users.update({'name':"user2"}, {'$unset':{'data':1}})
    db.users.update({'name':"user2"}, {'$addToSet':{'data':1}})
    for u in db.users.find({'name':"user2"}): print u
    # 显示： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1 ], "name" : "user2" }

    db.users.update({'name':"user2"}, {'$addToSet':{'data':{'$each':[1,2,3,4]}}})
    for u in db.users.find({'name':"user2"}): print u
    # 显示： {u'age': 12, u'_id': ObjectId('4c479896089df9b53474170b'), u'data': [1, 2, 3, 4], u'name': u'user2'}

    db.users.update({'name':"user2"}, {'$addToSet':{'data':[1,2,3,4]}})
    for u in db.users.find({'name':"user2"}): print u
    # 显示： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1, 2, 3, 4, [ 1, 2, 3, 4 ] ], "name" : "user2" }

    db.users.update({'name':"user2"}, {'$unset':{'data':1}})
    db.users.update({'name':"user2"}, {'$addToSet':{'data':[1,2,3,4]}})
    for u in db.users.find({'name':"user2"}): print u
    # 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ [1, 2, 3, 4] ], "name" : "user2" }

  (9) $pop: 移除数组属性的元素(按数组下标移除)，$pull 按值移除，$pullAll 移除所有符合提交的元素。
    db.users.update({'name':"user2"}, {'$unset':{'data':1}})
    db.users.update({'name':"user2"}, {'$addToSet':{'data':{'$each':[1, 2, 3, 4, 5, 6, 7, 2, 3 ]}}})
    for u in db.users.find({'name':"user2"}): print u
    # 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ 1, 2, 3, 4, 5, 6, 7, 2, 3 ], "name" : "user2" }

    db.users.update({'name':"user2"}, {'$pop':{'data':1}}) # 移除最后一个元素
    for u in db.users.find({'name':"user2"}): print u
    # 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ 1, 2, 3, 4, 5, 6, 7, 2 ], "name" : "user2" }

    db.users.update({'name':"user2"}, {'$pop':{'data':-1}}) # 移除第一个元素
    for u in db.users.find({'name':"user2"}): print u
    # 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ 2, 3, 4, 5, 6, 7, 2 ], "name" : "user2" }

    db.users.update({'name':"user2"}, {'$pull':{'data':2}}) # 移除全部 2
    for u in db.users.find({'name':"user2"}): print u
    # 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ 3, 4, 5, 6, 7 ], "name" : "user2" }

    db.users.update({'name':"user2"}, {'$pullAll':{'data':[3,5,6]}}) # 移除 3,5,6
    for u in db.users.find({'name':"user2"}): print u
    # 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ 4, 7 ], "name" : "user2" }

  (10) $where: 用 JS 代码来代替有些丑陋的 $lt、$gt。
    MongoDB 内置了 Javascript Engine (SpiderMonkey)。可直接使用 JS Expression，甚至使用 JS Function 写更复杂的 Code Block。

    db.users.remove() # 删除集合里的所有记录
    for i in range(10):
        db.users.insert({'name':"user" + str(i), 'age':i})
    for u in db.users.find(): print u
    # 显示如下：
    { "_id" : ObjectId("4c47b3372a9b2be866da226e"), "name" : "user0", "age" : 0 }
    { "_id" : ObjectId("4c47b3372a9b2be866da226f"), "name" : "user1", "age" : 1 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2270"), "name" : "user2", "age" : 2 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2271"), "name" : "user3", "age" : 3 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2272"), "name" : "user4", "age" : 4 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2273"), "name" : "user5", "age" : 5 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2274"), "name" : "user6", "age" : 6 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2275"), "name" : "user7", "age" : 7 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2276"), "name" : "user8", "age" : 8 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2277"), "name" : "user9", "age" : 9 }

    for u in db.users.find({"$where":"this.age > 7 || this.age < 3"}): print u
    # 显示如下：
    {u'age': 0.0, u'_id': ObjectId('4c47b3372a9b2be866da226e'), u'name': u'user0'}
    {u'age': 1.0, u'_id': ObjectId('4c47b3372a9b2be866da226f'), u'name': u'user1'}
    {u'age': 2.0, u'_id': ObjectId('4c47b3372a9b2be866da2270'), u'name': u'user2'}
    {u'age': 8.0, u'_id': ObjectId('4c47b3372a9b2be866da2276'), u'name': u'user8'}
    {u'age': 9.0, u'_id': ObjectId('4c47b3372a9b2be866da2277'), u'name': u'user9'}

    for u in db.users.find().where("this.age > 7 || this.age < 3"): print u
    # 显示如下：
    {u'age': 0.0, u'_id': ObjectId('4c47b3372a9b2be866da226e'), u'name': u'user0'}
    {u'age': 1.0, u'_id': ObjectId('4c47b3372a9b2be866da226f'), u'name': u'user1'}
    {u'age': 2.0, u'_id': ObjectId('4c47b3372a9b2be866da2270'), u'name': u'user2'}
    {u'age': 8.0, u'_id': ObjectId('4c47b3372a9b2be866da2276'), u'name': u'user8'}
    {u'age': 9.0, u'_id': ObjectId('4c47b3372a9b2be866da2277'), u'name': u'user9'}

    # 使用自定义的 function, javascript语法的
    for u in db.users.find().where("function() { return this.age > 7 || this.age < 3;}"): print u
    # 显示如下：
    {u'age': 0.0, u'_id': ObjectId('4c47b3372a9b2be866da226e'), u'name': u'user0'}
    {u'age': 1.0, u'_id': ObjectId('4c47b3372a9b2be866da226f'), u'name': u'user1'}
    {u'age': 2.0, u'_id': ObjectId('4c47b3372a9b2be866da2270'), u'name': u'user2'}
    {u'age': 8.0, u'_id': ObjectId('4c47b3372a9b2be866da2276'), u'name': u'user8'}
    {u'age': 9.0, u'_id': ObjectId('4c47b3372a9b2be866da2277'), u'name': u'user9'}



三、封装查询工具类

    {"age":{"$lt":15}} 这样的查询语法实在太另类，忒难看了。试试封装查询工具类吧。原理很简单，就是重载操作符。

    from pymongo import *
    conn = Connection()
    db = conn.test

    # 插入数据
    for i in range(10):
        u = dict(name = "user" + str(i), age = 10 + i)
        db.users.insert(u)

    # 查询 age 小于 15 的
    for u in db.users.find({"age":{"$lt":15}}): print u

    # 查询结果如下：
    {u'age': 10, u'_id': ObjectId('4c9b7465499b1408f1000000'), u'name': u'user0'}
    {u'age': 11, u'_id': ObjectId('4c9b7465499b1408f1000001'), u'name': u'user1'}
    {u'age': 12, u'_id': ObjectId('4c9b7465499b1408f1000002'), u'name': u'user2'}
    {u'age': 13, u'_id': ObjectId('4c9b7465499b1408f1000003'), u'name': u'user3'}
    {u'age': 14, u'_id': ObjectId('4c9b7465499b1408f1000004'), u'name': u'user4'}


    ################# 查询工具类 start #################################
    class Field(object):
        def __init__(self, name):
            self.name = name

        # 小于
        def __lt__(self, value):
            return { self.name: { "$lt":value } }
        # 小于等于
        def __le__(self, value):
            return { self.name: { "$lte":value } }

        # 大于
        def __gt__(self, value):
            return { self.name: { "$gt":value } }
        # 大于等于
        def __ge__(self, value):
            return { self.name: { "$gte":value } }

        # 等于
        def __eq__(self, value):
            return { self.name: value }
        # 不等于
        def __ne__(self, value):
            return { self.name: { "$ne":value } }

        # in (由于 in 是关键字，故该用首字母大写来避免冲突)
        def In(self, *value):
            return { self.name: { "$in":value } }
        # not in
        def not_in(self, *value):
            return { self.name: { "$nin":value } }

        def all(self, *value):
            '''
            注意和 in 的区别。in 是检查目标属性值是条件表达式中的一员，而 all 则要求属性值包含全部条件元素。
            '''
            return { self.name: { "$all":value } }

        def size(self, value):
            '''
            匹配数组属性元素的数量
            '''
            return { self.name: { "$size":value } }

        def type(self, value):
            '''
            判断属性类型
            @param value 可以是类型码数字，也可以是类型的字符串
            '''
            # int 类型，则认为是属性类型的编码，不再做其它处理
            if type(value) is int and value >= 1 and value <= 255:
                return { self.name: { "$type":value } }
            if type(value) is str:
                value = value.strip().lower()
                code = 2 # 默认为字符串类型
                # 数字类型
                if value in ("int", "integer", "long", "float", "double", "short", "byte", "number"):
                    code = 1
                # 字符串类型
                elif value in ("str", "string", "unicode"):
                    code = 2
                # object 类型
                elif value == "object":
                    code = 3
                # array 类型
                elif value in ("array", "list", "tuple"):
                    code = 4
                # binary data 类型
                elif value in ("binary data", "binary"):
                    code = 5
                # object id 类型
                elif value in ("object id", "id"):
                    code = 7
                # boolean 类型
                elif value in ("boolean", "bool"):
                    code = 8
                # date 类型
                elif value == "date":
                    code = 9
                # null 类型
                elif value in ("null", "none"):
                    code = 10
                # regular expression 类型
                elif value in ("regular expression", "regular"):
                    code = 11
                # javascript code 类型
                elif value in ("javascript code", "javascript", "script"):
                    code = 13
                # symbol 类型
                elif value == "symbol":
                    code = 14
                # javascript code with scope 类型
                elif value == "javascript code with scope":
                    code = 15
                # 32-bit integer 类型
                elif value in ("32-bit integer", "32-bit"):
                    code = 16
                # timestamp 类型
                elif value in ("timestamp", "time"):
                    code = 17
                # 64-bit integer 类型
                elif value in ("64-bit integer", "64-bit"):
                    code = 18
                # min key 类型
                elif value == "min key":
                    code = 255
                # max key 类型
                elif value == "max key":
                    code = 127
                return { self.name: { "$type":code } }


    # 查询工具类 使用范例
    age = Field("age")
    # 查询 age 小于 15 的
    for u in db.users.find(age < 15): print u

    # 查询结果如下：
    {u'age': 10, u'_id': ObjectId('4c9b7465499b1408f1000000'), u'name': u'user0'}
    {u'age': 11, u'_id': ObjectId('4c9b7465499b1408f1000001'), u'name': u'user1'}
    {u'age': 12, u'_id': ObjectId('4c9b7465499b1408f1000002'), u'name': u'user2'}
    {u'age': 13, u'_id': ObjectId('4c9b7465499b1408f1000003'), u'name': u'user3'}
    {u'age': 14, u'_id': ObjectId('4c9b7465499b1408f1000004'), u'name': u'user4'}

    # 其它查询写法例如：
    for u in db.users.find(age <= 12): print u
    for u in db.users.find(age > 17): print u
    for u in db.users.find(age == 15): print u
    for u in db.users.find(age != 15): print u
    # 查询 name 为 user2 的
    for u in db.users.find(Field("name") == "user2"): print u

    # in 和 not in 的写法较之前的不同(可考虑更优雅的写法)
    for u in db.users.find(age.In(13,14)): print u  # in
    for u in db.users.find(age.not_in(13,14)): print u  # not in
    for u in db.users.find(Field("data").all(1,2,3)): print u  # all: 查询data数组中至少包含 1、2、3 的
    for u in db.users.find(Field("data").size(3)): print u # size: 查询data数组的长度为3的
    # for u in db.users.find({'t':{'$type':1}}): print u
    for u in db.users.find(Field("t").type("number")): print u # 按类型查询，结果同上句

    ################# 查询工具类 end #################################


    ################# 多条件查询工具类 start #################################
    # (下面的 AND 函数很简陋，仅用于演示，不建议用于正式场合)
    import copy
    def AND(*args):
        ret = copy.deepcopy(args[0])

        for d in args[1:]:
            for k, v in d.items():
                if k in ret and type(v) is dict:
                    ret[k].update(v)
                else:
                    ret[k] = v

        return ret


    # 多条件查询工具类 使用范例
    age = Field("age")
    AND(name == "user3", age > 12, age < 15)
    # 相当于如下写法：
    {'age': {'$gt': 12, '$lt': 15}, 'name': 'user3'}

    # 使用多条件查询范例
    for u in db.users.find(AND(age > 12, age < 15)): print u
    for u in db.users.find(AND(name == "user3", age > 12, age < 15)): print u

    ################# 多条件查询工具类 end #################################




四、索引(Index)
    索引信息被保存在 system.indexes 中，且默认总是为 _id 创建索引。

  1. 创建、查看索引
    # 查看索引
    for u in db.system.indexes.find(): print u
    # 显示： { "name" : "_id_", "ns" : "test.users", "key" : { "_id" : 1 }, 'v': 0 }

    # 删除 集合的全部索引(不包括 _id 等系统索引)
    db.users.drop_indexes()

    # 创建索引
    db.users.ensure_index([("name", pymongo.ASCENDING)]) # 相当于js的： db.users.ensureIndex({name:1})
    db.users.ensure_index([("name", pymongo.ASCENDING), ("age", pymongo.DESCENDING)]) # 相当于js的： db.users.ensureIndex({name:1, age:-1})

    # 删除指定索引
    db.users.drop_index([("name", pymongo.ASCENDING)])
    db.users.drop_index([("name", pymongo.ASCENDING), ("age", pymongo.DESCENDING)])

    # 重建索引,在python里不知道怎么写
    db.users.reIndex() # 会报错


  2. explain
    explain 命令让我们获知系统如何处理查询请求。
    利用 explain 命令，我们可以很好地观察系统如何使用索引来加快检索，同时可以针对性优化索引。

    print db.users.find({'age':{'$gt':4}}).explain()
    # 显示如： {u'nYields': 0, u'allPlans': [{u'cursor': u'BtreeCursor age_1', u'indexBounds': {u'age': [[4, 1.7976931348623157e+308]]}}], u'nChunkSkips': 0, u'millis': 0, u'n': 0, u'cursor': u'BtreeCursor age_1', u'indexBounds': {u'age': [[4, 1.7976931348623157e+308]]}, u'nscannedObjects': 0, u'isMultiKey': False, u'indexOnly': False, u'nscanned': 0}

    # 深层索引
    print db.users.find({"contact":{"postcode":{"$lt":100009}}}).explain()
    # 显示如: {u'nYields': 0, u'allPlans': [{u'cursor': u'BtreeCursor contact_1', u'indexBounds': {u'contact': [[{u'postcode': {u'$lt': 100009}}, {u'postcode': {u'$lt': 100009}}]]}}], u'nChunkSkips': 0, u'millis': 0, u'n': 0, u'cursor': u'BtreeCursor contact_1', u'indexBounds': {u'contact': [[{u'postcode': {u'$lt': 100009}}, {u'postcode': {u'$lt': 100009}}]]}, u'nscannedObjects': 0, u'isMultiKey': False, u'indexOnly': False, u'nscanned': 0}

    print db.users.find({"contact.postcode":{"$lt":100009}}).explain()
    # 显示如: {u'nYields': 0, u'allPlans': [{u'cursor': u'BtreeCursor contact.postcode_1', u'indexBounds': {u'contact.postcode': [[-1.7976931348623157e+308, 100009]]}}], u'nChunkSkips': 0, u'millis': 0, u'n': 9, u'cursor': u'BtreeCursor contact.postcode_1', u'indexBounds': {u'contact.postcode': [[-1.7976931348623157e+308, 100009]]}, u'nscannedObjects': 9, u'isMultiKey': False, u'indexOnly': False, u'nscanned': 9}

    返回结果信息包括:
    cursor: 返回游标类型(BasicCursor 或 BtreeCursor)。
    nscanned: 被扫描的文档数量。
    n: 返回的文档数量。
    millis: 耗时(毫秒)。
    indexBounds: 所使用的索引。


  5. 唯一索引(Unique Index) # 未知怎样使用
    只需在 ensureIndex 命令中指定 unique 即可创建唯一索引。
    如果创建唯一索引前已经有重复文档，那么可以用 dropDups 删除多余的数据。

    # 不允许重复，但之前已经重复的不会被删除
    db.users.ensure_index({name:1}, {unique:true})
    # 还会删除之前重复的资料
    db.users.ensure_index({name:1}, {unique:true, dropDups:true})


  7. hint
    hint 命令可以强制使用某个索引。
    db.users.find({"age":{"$lt":30}}).hint([("name", pymongo.ASCENDING), ("age", pymongo.DESCENDING)]).explain()


  8. 全部索引数据大小(totalIndexSize) # 未知如何实现
    MongoDB 会将索引数据载入内存，以提高查询速度。我们可以用 totalIndexSize 获取全部索引数据大小。
    db.users.totalIndexSize()



五、Map/Reduce
    执行函数：
    db.runCommand(
    {
        mapreduce : <collection>,
        map : <mapfunction>,
        reduce : <reducefunction>
        [, query : <query filter object>]
        [, sort : <sort the query.  useful   optimization>] for
        [, limit : <number of objects to   from collection>] return
        [, out : <output-collection name>]
        [, keeptemp: < | >] true false
        [, finalize : <finalizefunction>]
        [, scope : <object where fields go into javascript global scope >]
        [, verbose :  ] true
    });

    参数说明:
    mapreduce: 要操作的目标集合。
    map: 映射函数 (生成键值对序列，作为 reduce 函数参数)。
    reduce: 统计函数。
    query: 目标记录过滤。
    sort: 目标记录排序。
    limit: 限制目标记录数量。
    out: 统计结果存放集合 (不指定则使用临时集合，在客户端断开后自动删除)。
    keeptemp: 是否保留临时集合。
    finalize: 最终处理函数 (对 reduce 返回结果进行最终整理后存入结果集合)。
    scope: 向 map、reduce、finalize 导入外部变量。
    verbose: 显示详细的时间统计信息。


    例：
    # 表如下：
    record = {
        "ci" : "test_classify",
        "si" : number,
        "ac" : random.randint(1, 50),
        "ic" : random.randint(1, 50),
        "cv" : random.randint(1, 50),
        "ao" : datetime.datetime.strptime('%Y-%m-%d %H:%M:%S'),
        "ssi" : number,
    }

    # map 生成 key 序列, 必须使用 emit 函数
    map = """function () {
             emit({classifyid: this.ci, siteid: this.si}, {archivecount: this.ac});
           }"""

    # 对 key 的处理，以及返回值
    reduce = """function (key, values) {
                var total = 0;
                for (var i = 0; i < values.length; i++) {
                  total += values[i].archivecount;
                }
                return {archivecount:total};
              }"""

    condition = {"ci" : "test_classify"}
    result = db[TABLE].map_reduce(map, reduce, "temp_top10", keeptemp=False, query=condition)
    result = result.find().sort('value.archivecount', -1).limit(10)



