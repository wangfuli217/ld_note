
mongo 是 MongoDB 自带的交互式 Javascript shell，用来对 Mongod 进行操作和管理的交互式环境。

0、常用命令：
  1. 数据库操作
    show dbs // 显示所有的数据库名称,类似 MySQL 的“show databases;”
    show collections // 显示集合，类似 MySQL 的“show tables;”
    use 数据库名 // 切换到工作数据库(没有这数据库则会自动创建)
    db // 显示当前数据库名称
    db.copyDatabase("源数据库名", "目标数据库名") // 复制数据库
    db.copyDatabase("源数据库名", "目标数据库名", "源数据库IP地址") // 从源服务器复制 数据库
    db.dropDatabase() // 删除当前所在的数据库
    db.cloneDatabase("源数据库IP地址") // 从源服务器克隆当前数据库(数据库名要相同)

    db.printCollectionStats()    // 查看各collection的状态
    db.printReplicationInfo()    // 查看主从复制状态
    db.repairDatabase()    // 修复数据库
    db.setProfilingLevel(1)    // 设置记录profiling，0=off 1=slow 2=all
    show profile    // 查看profiling

    db.集合名.dataSize() // 查看collection数据的大小
    db.集合名.stats() // 查看colleciont状态
    db.集合名.totalIndexSize() // 查询所有索引的大小
    db['集合名'].stats()  // 除了用点号来调用集合之外，也可以用下标来调用

    // 其它数据库的引用(变量 db 表示当前数据库)
    数据库名2 = db.getSisterDB("数据库名2")
    数据库名2.集合名1.insert({'键1' : "值1"})
    数据库名2.集合名1.find({'键1' : "值1"})

    账户管理:
    use admin // 以下操作必须先进入 admin 数据库里面
    db.addUser('admin', 'pwd')  // 增加或修改用户密码
    db.system.users.find()    // 查看用户列表
    show users    // 查看所有用户(显示跟上面类似)
    db.auth('admin', 'pwd')    // 用户认证(设置数据库连接验证)
    db.removeUser('mongodb')    // 删除用户

  2. 插入
    db.集合名.save({'键1' : 值1, '键2' : 值2}) // 插入数据(可以更新，也可以插入数据),返回新增的主键值
    db.集合名.insert({'键1' : 值1, '键2' : 值2}) // 插入数据(insert into),返回新增的主键值

  3. 更新
    // 更新指定一条记录
    名称1 = db.集合名.findOne({'键1':"值1"}) // 查询出一条记录
    名称1.键1 = 值1 // 改变记录的内容
    db.集合名.save(名称1)  // 返回更新的主键值

    // 更新多条记录,返回 null
    db.users.update({name:"user1"}, {$set:{age:100, sex:0}})  // update users set age = 100, sex = 0 where name = 'user1'
    db.users.update({}, {$inc:{age:10}}, false, true) // update users set age = age + 10
    db.users.update({name:"user1"}, {$inc:{age:10}, $set:{sex:1}}) // update users set age = age + 10, sex = 1 where name = 'user1'
    db.users.update({'_id':17}, {$unset:{'addUser':1}}) // 删除字段 "addUser"

    // update() 有几个参数需要注意。
    db.集合名.update(criteria, objNew, upsert, mult)
    criteria: 需要被更新的条件表达式
    objNew: 更新表达式
    upsert: 如目标记录不存在，是否插入新文档。
    multi: 是否更新多个文档。

  4. 删除
    db.集合名.drop()  // 删除集合

    // remove() 用于删除单个或全部文档，删除后的文档无法恢复。
    id = db.users.findOne({name:"user1"})._id
    db.users.remove(id) // 根据 id 删除一条记录
    db.users.remove() // 删除集合里的所有记录
    db.users.remove({'yy':5}) // 删除yy=5的记录

  5. 查询
    db.集合名.find() // 显示集合的所有内容
    db.集合名.find({"键1":{"$lt":值1}}) // 按条件查询，查询 键1小于值1的资料

  5.1 查询一条记录
    集合名1 = db.集合名.findOne({'键1':"值1"}) // 查询出一条记录
    db.集合名.find({"键1":'值1'}) // 按条件查询，查询 键1等于值1的资料

  5.2 查询特定键 (fields)
    db.集合名.find({"键1":"值1"}, {'键2':1, '键3':1}) // select 键2, 键3 from 集合名 where 键1 = '值1'
    db.集合名.find({}, {'键2':1, '键3':1}) // select 键2, 键3 from 集合名

  5.3 排序(SORT)
    db.集合名.find().sort({键1:1}) // select * from 集合名 order by 键1
    db.集合名.find().sort({键1:-1}) // select * from 集合名 order by 键1 desc
    db.集合名.find().sort({键1:1, 键2:-1}) // select * from 集合名 order by 键1 asc, 键2 desc

  5.4 从第几行开始读取(SLICE)，读取多少行(LIMIT)
    // select * from 集合名 skip 2 limit 3
    // MySQL 的写法： select * from 集合名 limit 2, 3
    db.集合名.find().skip(2).limit(3)

    // 单独的写
    db.集合名.find().skip(从第几行开始)
    db.集合名.find().limit(记录数)

  5.5 多条件查询(Conditional Operators)    // like 的可使用正则表达式查询
    db.集合名.find({'键1':"值1", '键2':'键2'}) // select * from 集合名 where 键1 = '值1' and 键2 = '值3'
    db.集合名.find({'键1': {'$gt': 值1, '$lt': 值2}, '键2': '值3'}) // select * from 集合名 where 键1     '值1' and  键1 < '值2' and 键2 = '值3'

  5.6 IN
    db.集合名.find({'键1':{'$in':[值1,值2,值3]}})  // select * from 集合名 where 键1 in (值1, 值2, 值3)
    db.集合名.find({'键1':{'$nin':[值1,值2,值3]}}) // select * from 集合名 where 键1 not in (值1, 值2, 值3)

  5.7 统计总数(COUNT)
    db.集合名.count() // 统计集合有多少条记录
    db.集合名.find({'键1':"值1", '键2':'值2'}).count()  // select count(*) from users where 键1='值1' and 键2='值2'

  5.8 OR
    db.集合名.find({$or:[{键1:值1}, {键1:值2}]}) //  select * from 集合名 where 键1 = 值1 or 键1 = 值2
    db.集合名.find({$or:[{键1:{$lte:值1}}, {键1:{$gte:值2}}]}) // select * from 集合名 where 键1 <= 值1 or 键1 >= 值2

  6. 是否存在 (exists)
    db.集合名.find({键1:{$exists:true}})  // select * from 集合名 where exists 键1
    db.集合名.find({键1:{$exists:false}}) // select * from 集合名 where not exists 键1

  7. 正则表达式查询
    db.集合名.find({name:/user[135]/i}, {name:1}) // 查询出 name 为 user1, user3, user5 的
    db.集合名.find({'name':{"$regex" : "(?i)user[135]"}}, {'name':1})  // 这样写也可以,结果同上式

    正则表达式标记:
        i: 忽略大小写。
        m: 默认为单行处理，此标记表示多行。
        x: 扩展。

  8. 多级路径的元素值匹配
    Document 采取 JSON-like 这种层级结构，因此我们可以直接用嵌入(Embed)代替传统关系型数据库的关联引用(Reference)。
    MongoDB 支持以 "." 分割的 namespace 路径，条件表达式中的多级路径须用引号

    // 如果键里面包含数组，只需简单匹配数组属性是否包含该元素即可查询出来
    db.集合名.findOne({'address':"address1"}) // address 是个数组，匹配时仅需包含有即可
    // 查询结果如：{"_id" : ObjectId("4c479885089df9b53474170a"), "name" : "user1", "address" : ["address1", "address2"]}

    // 条件表达式中的多级路径须用引号,以 "." 分割
    u = db.集合名.findOne({"im.qq":12345678})
    // 查询结果如：{"_id" : ObjectId("4c479885089df9b53474170a"), "name" : "user1", "im" : {"msn" : "user1@hotmail.com", "qq" : 12345678}}

    u.im.msn  //显示： user1@hotmail.com

    // 多级路径的更新
    db.集合名.update({"im.qq":12345678}, {$set:{"im.qq":12345}})

    // 查询包含特定键的
    u = db.集合名.find({"im.qq":{$exists:true}}, {"im.qq":1}) // 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "im" : { "qq" : 12345 } }


    db.集合名.find({data:"abc"})
    // 显示如： { "_id" : ObjectId("4c47a481b48cde79c6780df5"), "name" : "user8", "data" : [ { "a" : 1, "b" : 10 }, 3, "abc" ] }
    db.集合名.find({data:{$elemMatch:{a:1, b:{$gt:5}}}})
    // 显示如： { "_id" : ObjectId("4c47a481b48cde79c6780df5"), "name" : "user8", "data" : [ { "a" : 1, "b" : 10 }, 3, "abc" ] }
    {data:"abc"} 仅简单匹配数组属性是否包含该元素。$elemMatch 则可以处理更复杂的元素查找条件。当然也可以写成如下方式：
    db.集合名.find({"data.a":1, "data.b":{$gt:5}})

    还可以直接使用序号进行操作：
    db.集合名.find({"data.1":3}) // 序号从0开始


    // 如集合的一列内容
    {"classifyid":"test1",
          "keyword":[
                {"name":'test1', // 将修改此值为 test5 (数组下标从0开始,下标也是用点)
                "frequence":21,
                },
                {"name":'test2', // 子表的查询，会匹配到此值
                "frequence":50,
                },
          ]
    }
    // 子表的修改(子表的其它内容不变)
    db.集合名.update({"classifyid":"test1"}, {"$set":{"keyword.0.name":'test5'}})
    // 子表的查询
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
    $unset      与 $set 相反，表示移除文档属性。(删除字段)
    $inc        += (用于 update 语句)
    $exists     exists (判断是否存在，仅有 true 和 false 两个值)
    $all        属性值包含全部条件元素,注意和 $in 的区别
    $size       匹配数组属性元素的数量
    $type       判断属性类型
    $regex      正则表达式查询
    $elemMatch  子属性里的查询
    $not        取反
    $push       向数组属性添加元素
    $pushAll    向数组属性添加元素
    $addToSet   和 $push 类似，不过仅在该元素不存在时才添加 (Set 表示不重复元素集合)
    $each       添加多个元素用
    $pop        移除数组属性的元素(按数组下标移除)
    $pull       按值移除
    $pullAll    移除所有符合提交的元素
    $where      用 JS 代码来代替有些丑陋的 $lt、$gt


  注意:
    MongoDB 支持以 "." 分割的 namespace 路径，但需要注意 key 不能以 "$" 开头，不能包含 "." 字符 (条件表达式中的多级路径须用引号)。
    由于每篇文档都包含完整的 key 数据，因此使用尽可能短的 key 可以有效节省存储空间。



二、Operator
  (1) $all: 判断数组属性是否包含全部条件。
    db.users.insert({name:"user3", data:[1,2,3,4,5,6,7]})
    db.users.insert({name:"user4", data:[1,2,3]})

    db.users.find({data:{$all:[2,3,4]}})
    // 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "name" : "user3", "data" : [ 1, 2, 3, 4, 5, 6, 7 ] }
    注意和 $in 的区别。$in 是检查目标属性值是条件表达式中的一员，而 $all 则要求属性值包含全部条件元素。

  (2) $size: 匹配数组属性元素数量。
    db.users.find({data:{$size:3}})
    // 只显示匹配此数组数量的： { "_id" : ObjectId("4c47a13bb48cde79c6780df1"), "name" : "user4", "data" : [ 1, 2, 3 ] }

  (3) $type: 判断属性类型。
    db.users.insert({name:"user5", t:1})
    db.users.insert({name:"user6", t:1.34})
    db.users.insert({name:"user7", t:"abc"})

    db.users.find({t:{$type:1}}) // 查询数字类型的
    db.users.find({t:{$type:2}}) // 查询字符串类型的

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
    u = db.users.find({'name':{'$not':/user3/}}, {'name':1})

  (5) $unset: 和 $set 相反，表示移除文档属性。
    u = db.users.find({name:"user1"})
    // 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "name" : "user1", "age" : 15, "address" : [ "address1", "address2" ] }

    db.users.update({name:"user1"}, {'$unset':{'address':1, 'age':1}})
    u = db.users.find({name:"user1"})
    // 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "name" : "user1" }

  (6) $push: 和 $ pushAll 都是向数组属性添加元素。// 好像两者没啥区别
    u = db.users.find({'name':"user1"})
    // 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "age" : 15, "name" : "user1" }

    db.users.update({'name':"user1"}, {'$push':{'data':1}})
    u = db.users.find({'name':"user1"})
    // 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "age" : 15, "data" : [ 1 ], "name" : "user1" }

    db.users.update({'name':"user1"}, {'$pushAll':{'data':[2,3,4,5]}})
    u = db.users.find({'name':"user1"})
    // 显示如： { "_id" : ObjectId("4c479885089df9b53474170a"), "age" : 15, "data" : [ 1, 2, 3, 4, 5 ], "name" : "user1" }

  (7) $addToSet: 和 $push 类似，不过仅在该元素不存在时才添加 (Set 表示不重复元素集合)。
    db.users.update({'name':"user2"}, {'$unset':{'data':1}})
    db.users.update({name:"user2"}, {$addToSet:{data:1}})
    db.users.update({name:"user2"}, {$addToSet:{data:1}})
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1 ], "name" : "user2" }

    db.users.update({name:"user2"}, {$push:{data:1}})
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1, 1 ], "name" : "user2" }

    要添加多个元素，使用 $each。
    db.users.update({name:"user2"}, {$addToSet:{data:{$each:[1,2,3,4]}}})
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1, 2, 3, 4 ], "name" : "user2" }
    // 但貌似不会自动删除重复,我这里显示是： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1, 1, 2, 3, 4 ], "name" : "user2" }

  (8) $each 添加多个元素用。
    db.users.update({'name':"user2"}, {'$unset':{'data':1}})
    db.users.update({name:"user2"}, {$addToSet:{data:1}})
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1 ], "name" : "user2" }

    db.users.update({name:"user2"}, {$addToSet:{data:{$each:[1,2,3,4]}}})
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1, 2, 3, 4 ], "name" : "user2" }

    db.users.update({name:"user2"}, {$addToSet:{data:[1,2,3,4]}})
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c479896089df9b53474170b"), "data" : [ 1, 2, 3, 4, [ 1, 2, 3, 4 ] ], "name" : "user2" }

    db.users.update({'name':"user2"}, {'$unset':{'data':1}})
    db.users.update({name:"user2"}, {$addToSet:{data:[1,2,3,4]}})
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ [1, 2, 3, 4] ], "name" : "user2" }

  (9) $pop: 移除数组属性的元素(按数组下标移除)，$pull 按值移除，$pullAll 移除所有符合提交的元素。
    db.users.update({'name':"user2"}, {'$unset':{'data':1}})
    db.users.update({name:"user2"}, {$addToSet:{data:{$each:[1, 2, 3, 4, 5, 6, 7, 2, 3 ]}}})
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ 1, 2, 3, 4, 5, 6, 7, 2, 3 ], "name" : "user2" }

    db.users.update({name:"user2"}, {$pop:{data:1}}) // 移除最后一个元素
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ 1, 2, 3, 4, 5, 6, 7, 2 ], "name" : "user2" }

    db.users.update({name:"user2"}, {$pop:{data:-1}}) // 移除第一个元素
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ 2, 3, 4, 5, 6, 7, 2 ], "name" : "user2" }

    db.users.update({name:"user2"}, {$pull:{data:2}}) // 移除全部 2
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ 3, 4, 5, 6, 7 ], "name" : "user2" }

    db.users.update({name:"user2"}, {$pullAll:{data:[3,5,6]}}) // 移除 3,5,6
    u = db.users.find({name:"user2"})
    // 显示： { "_id" : ObjectId("4c47a133b48cde79c6780df0"), "data" : [ 4, 7 ], "name" : "user2" }

  (10) $where: 用 JS 代码来代替有些丑陋的 $lt、$gt。
    MongoDB 内置了 Javascript Engine (SpiderMonkey)。可直接使用 JS Expression，甚至使用 JS Function 写更复杂的 Code Block。

    db.users.remove() // 删除集合里的所有记录
    for (var i = 0; i < 10; i++) db.users.insert({name:"user"+i, age:i})
    db.users.find()
    /* 显示如下：
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
    */

    db.users.find({$where:"this.age > 7 || this.age < 3"})
    /* 显示如下：
    { "_id" : ObjectId("4c47b3372a9b2be866da226e"), "name" : "user0", "age" : 0 }
    { "_id" : ObjectId("4c47b3372a9b2be866da226f"), "name" : "user1", "age" : 1 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2270"), "name" : "user2", "age" : 2 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2276"), "name" : "user8", "age" : 8 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2277"), "name" : "user9", "age" : 9 }
    */

    db.users.find("this.age > 7 || this.age < 3") // 不写 $where 也可以
    /* 显示如下：
    { "_id" : ObjectId("4c47b3372a9b2be866da226e"), "name" : "user0", "age" : 0 }
    { "_id" : ObjectId("4c47b3372a9b2be866da226f"), "name" : "user1", "age" : 1 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2270"), "name" : "user2", "age" : 2 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2276"), "name" : "user8", "age" : 8 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2277"), "name" : "user9", "age" : 9 }
    */

    db.users.find({$where: function(){ return this.age > 7 || this.age < 3;}}) // 使用自定义的 function
    /* 显示如下：
    { "_id" : ObjectId("4c47b3372a9b2be866da226e"), "name" : "user0", "age" : 0 }
    { "_id" : ObjectId("4c47b3372a9b2be866da226f"), "name" : "user1", "age" : 1 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2270"), "name" : "user2", "age" : 2 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2276"), "name" : "user8", "age" : 8 }
    { "_id" : ObjectId("4c47b3372a9b2be866da2277"), "name" : "user9", "age" : 9 }
    */

  (11) 多表关联查询
    db.shops.insert({_id:3,name:'name3',t:2})
    db.shops.insert({_id:5,name:'name5',t:2})
    db.shops.insert({_id:7,name:'name7',t:2})
    db.shop_infos.insert({_id:3,addr:'addr3',type:3})
    db.shop_infos.insert({_id:7,addr:'addr7',type:3})
    db.shop_infos.insert({_id:9,addr:'addr9',type:3})
    // 关联查询(条件里面关联其它表,返回结果还是原表)
    db.shops.find({$where: function(){ return db.shop_infos.findOne({_id: this._id}); }})
    /* 显示如下：
    { "_id" : 3, "name" : "name3", "t" : 2 }
    { "_id" : 7, "name" : "name7", "t" : 2 }
    */


三、使用命令范例
(1) MongoDB 会自动创建数据库(db)和集合(collection)，无需显式执行。
(2) 还可以在多台服务器之间复制数据库。
    db.copyDatabase("blog", "blog", "192.168.1.202") // 从源服务器复制 blog 数据库
    use news
    db.cloneDatabase("192.168.1.202") // 从源服务器克隆当前数据库(news)

(3) 当我们使用 use 切换到某个数据库时，变量 db 表示当前数据库。还可以用 getSisterDB() 函数获取其他数据库的引用。
    use 数据库名1
    数据库名2 = db.getSisterDB("数据库名2")
    数据库名2.集合名1.insert({name : "abc"})
    数据库名2.集合名1.find({name : "abc"})

(4) 调用 fsync 命令，可以强制将内存中缓存数据写回数据库文件。如果不想等待，可添加 async 参数异步执行。
    use admin
    db.runCommand({fsync : 1})
    db.runCommand({fsync : 1, async : true})  // windows 不支持

(5) 某些时候需要锁定系统，阻塞所有写操作，诸如备份、整理数据库等等。锁定时读操作不受影响。
    use blog
    admin = db.getSisterDB("admin")
    admin.runCommand({fsync : 1, lock : 1}) // 锁定
    db.users.find() // 读操作正常
    db.users.save({name : "xyz" }) // 写操作被阻塞，等待 ...

    另开启一个终端，解除锁定:
    use admin
    db.$cmd.sys.unlock.findOne()

    解除后，前一终端被阻塞的写操作正确返回。


(6) 调用 validate() 验证集合是否存在错误。
    db.集合名.validate()

    // 显示内容如下：
    {
        "ns" : "blog.users",
        "result" : "
          validate
          firstExtent:0:2600 ns:blog.users
          lastExtent:0:23d00 ns:blog.users
          # extents:2
          datasize?:4640 nrecords?:116 lastExtentSize:9216
          padding:1
          first extent:
            loc:0:2600 xnext:0:23d00 xprev:null
            nsdiag:blog.users
            size:2304 firstRecord:0:26b0 lastRecord:0:2ec8
          116 objects found, nobj:116
          6496 bytes data w/headers
          4640 bytes data wout/headers
          deletedList: 0000000010000000000
          deleted: n: 1 size: 4672
          nIndexes:1
            blog.users.$_id_ keys:116
        ",
        "ok" : true,
        "valid" : true,
        "lastExtentSize" : 9216
    }

四、索引(Index)
    索引信息被保存在 system.indexes 中，且默认总是为 _id 创建索引。

  1.创建、删除、查看索引
    ensureIndex() 创建索引
    dropIndex() 删除索引
    dropIndexes() 删除全部索引(不包括 _id 等系统索引)
    reIndex() 重建索引

    db // 显示： test
    show collections
    /* 显示如下：
    system.indexes
    users
    */

    db.system.indexes.find()
    // 显示： { "name" : "_id_", "ns" : "test.users", "key" : { "_id" : 1 }, 'v': 0 }

    db.users.ensureIndex({name:1}) // 为 users 集合创建 name 索引
    db.users.ensureIndex({age:1})
    db.system.indexes.find()
    /* 显示如下：
    { "name" : "_id_", "ns" : "test.users", "key" : { "_id" : 1 }, 'v': 0 }
    {'_id': ObjectId('4ded990d788b9c27d6154b74'), 'v': 0, 'ns': 'test.users', 'key': {'name': 1.0}, 'name': 'name_1'}
    {'_id': ObjectId('4ded9930788b9c27d6154b75'), 'v': 0, 'ns': 'test.users', 'key': {'age': 1.0}, 'name': 'age_1'}
    */

    db.users.dropIndex({age:1})  // 删除指定索引
    db.system.indexes.find()
    /* 显示如下：
    { "name" : "_id_", "ns" : "test.users", "key" : { "_id" : 1 }, 'v': 0 }
    {'_id': ObjectId('4ded990d788b9c27d6154b74'), 'v': 0, 'ns': 'test.users', 'key': {'name': 1.0}, 'name': 'name_1'}
    */

    db.users.dropIndexes() // 删除全部自定义索引
    db.system.indexes.find()
    // 显示： { "name" : "_id_", "ns" : "test.users", "key" : { "_id" : 1 }, 'v': 0 }

    db.users.ensureIndex({name:1})
    db.users.ensureIndex({age:1})
    db.users.reIndex()


    当系统已有大量数据时，创建索引就是个非常耗时的活，我们可以在后台执行。
    db.users.dropIndexes()
    db.users.ensureIndex({age:1}, {backgroud:true})
    db.users.reIndex({backgroud:true})


  2. explain
    explain 命令让我们获知系统如何处理查询请求。
    利用 explain 命令，我们可以很好地观察系统如何使用索引来加快检索，同时可以针对性优化索引。

    db.users.ensureIndex({age:1})
    db.users.find({age:{$gt:4}}, {name:1, age:1})
    /* 查询结果如下：
    {u'age': 5, u'_id': ObjectId('4ded922eb66fe31588000005'), u'name': u'user5'}
    {u'age': 6, u'_id': ObjectId('4ded922eb66fe31588000006'), u'name': u'user6'}
    {u'age': 7, u'_id': ObjectId('4ded922eb66fe31588000007'), u'name': u'user7'}
    {u'age': 8, u'_id': ObjectId('4ded922eb66fe31588000008'), u'name': u'user8'}
    {u'age': 9, u'_id': ObjectId('4ded922eb66fe31588000009'), u'name': u'user9'}
    */

    db.users.find({age:{$gt:4}}, {name:1, age:1}).explain()
    /* 查询结果如下：
    {
        "cursor" : "BtreeCursor age_1",
        "nscanned" : 5,
        "nscannedObjects" : 5,
        "n" : 5,
        "millis" : 10,
        "nYields" : 0,
        "nChunkSkips" : 0,
        "isMultiKey" : false,
        "indexOnly" : false,
        "indexBounds" : {
                "age" : [
                        [
                                4,
                                1.7976931348623157e+308
                        ]
                ]
        }
    }
    */
    返回结果信息包括:
    cursor: 返回游标类型(BasicCursor 或 BtreeCursor)。
    nscanned: 被扫描的文档数量。
    n: 返回的文档数量。
    millis: 耗时(毫秒)。
    indexBounds: 所使用的索引。


    // 删除索引之后
    db.users.dropIndexes()
    db.users.find({age:{$gt:4}}, {name:1, age:1}).explain()
    /* 查询结果如下：
    {
        "cursor" : "BtreeCursor age_1",
        "nscanned" : 10,
        "nscannedObjects" : 10,
        "n" : 5,
        "millis" : 0,
        "nYields" : 0,
        "nChunkSkips" : 0,
        "isMultiKey" : false,
        "indexOnly" : false,
        "indexBounds" : {

        }
    }
    */


  3. 深层索引(Embedded Keys Index)
    我们可以创建深层索引，甚至直接用文档(sub-document)作为索引键。
    db.users.ensureIndex({"contact.postcode":1})

    我们直接用 contact 创建索引，查找其下属性时可使用该索引，但需注意语法。
    (附注: 在 1.5.4 mongo 中，一直无法使用 contact:{postcode:xxx} 这样的 SubObject 语法查询数据，只能用 "contact.postcode" DotNotation 语法)

    db.users.dropIndex({"contact.postcode":1}) // 删除索引
    db.users.ensureIndex({contact:1}) // 创建 contact 的索引
    db.users.find({contact:{postcode:{$lt:100009}}}).explain() // 可以使用索引,contact 的索引对这写法的子元素生效
    db.users.find({"contact.postcode":{$lt:100009}}).explain() // 无法使用索引,contact 的索引对这写法无效

    db.users.ensureIndex({"contact.postcode":1})
    db.users.find({"contact.postcode":{$lt:100009}}).explain() // 可以使用索引,这写法需定义 contact.postcode 的索引

  4. 复合索引(Compound Keys Index)
    创建复合索引也很简单 (1: ascending; -1: descending)。
    db.users.dropIndexes()
    db.users.ensureIndex({age:1}, {backgroud:true})
    db.users.ensureIndex({name:1, age:-1})
    db.system.indexes.find()
    // 显示如下：
    { "name" : "_id_", "ns" : "blog.users", "key" : { "_id" : 1 } }
    { "_id" : ..., "ns" : "blog.users", "key" : { "age" : 1 }, "name" : "age_1", "backgroud" : true, "v" : 0 }
    { "_id" : ..., "ns" : "blog.users", "key" : { "name" : 1, "age" : -1 }, "name" : "name_1_age_-1", "v" : 0 }

    db.users.find({age:{$lt:25}, name:"user2"}, {name:1, age:1}).explain() // 使用索引 {name:1, age:-1}
    db.users.find({age:{$lt:25}}).explain() // 使用索引 {age:1}
    db.users.find({name:{$lt:'user1'}}).explain() // 使用索引 {name:1, age:-1}

    // 复合索引同样可用于局部属性的搜索，但必须依照索引字段顺序。比如创建索引字段顺序 "a,b,c"，那么仅对 "a,b,c"、"a,b"、"a" 查询有效，而对 "b,c" 之类的组合无效。
    db.users.dropIndex({age:1})
    db.users.find({name:"user12"}).explain() // 索引有效, 使用索引 {name:1, age:-1}
    db.users.find({age:18}).explain() // 索引无效

    // 多个索引时，使用最先创建的
    db.users.ensureIndex({name:1})
    db.users.find({name:{$lt:'user1'}}).explain() // 依然使用索引 {name:1, age:-1}
    db.users.dropIndexes() // 删除所有索引，为了重新开始创建索引
    db.users.ensureIndex({name:1})
    db.users.ensureIndex({name:1, age:-1})
    db.users.find({name:{$lt:'user1'}}).explain() // 使用索引 {name:1}

  5. 唯一索引(Unique Index)
    只需在 ensureIndex 命令中指定 unique 即可创建唯一索引。
    如果创建唯一索引前已经有重复文档，那么可以用 dropDups 删除多余的数据。

    db.users.ensureIndex({name:1}, {unique:true})
    // 不允许重复，但之前已经重复的不会被删除
    db.system.indexes.find()
    // 显示如下：
    { "name" : "_id_", "ns" : "test.users", "key" : { "_id" : 1 } }
    { "_id" : ..., "ns" : "test.users", "key" : { "name" : 1 }, "name" : "name_1", "unique" : true }

    db.users.insert({name:"user1"})
    // 显示： E11000 duplicate key error index: blog.users.$name_1  dup key: { : "user1" }

    // dropDups 用法
    db.users.dropIndexes()
    db.users.insert({name:"user1"})
    db.users.find({name:"user1"}, {name:1})
    // 显示：
    { "_id" : ObjectId("4c4a9573eb257107735eb831"), "name" : "user1" }
    { "_id" : ObjectId("4c4a8edeeb257107735eb80d"), "name" : "user1" }

    db.users.ensureIndex({name:1}, {unique:true, dropDups:true}) // 会删除之前重复的资料
    // 显示： E11000 duplicate key error index: blog.users.$name_1  dup key: { : "user1" }

    db.users.find({name:"user1"}, {name:1})
    // 显示： { "_id" : ObjectId("4c4a9573eb257107735eb831"), "name" : "user1" }

  6. Multikeys
    对于数组类型属性，会自动索引全部数组元素。
    db.users.dropIndexes()
    db.users.ensureIndex({"contact.address":1})
    db.users.find({"contact.address":"address2_13"}).explain()

  7. hint
    hint 命令可以强制使用某个索引。

    db.users.dropIndexes()
    db.users.ensureIndex({name:1, age:1})
    db.users.find({age:{$lt:30}}).explain() // 索引无效
    db.users.find({age:{$lt:30}}).hint({name:1, age:1}).explain() // 索引有效

  8. 全部索引数据大小(totalIndexSize)
    MongoDB 会将索引数据载入内存，以提高查询速度。我们可以用 totalIndexSize 获取全部索引数据大小。
    db.users.totalIndexSize()



五、使用 "./mongo --help" 可查看相关连接参数。
  $ ./mongo --help   (linux 命令)
  mongo.exe --help   (windows 命令)

    MongoDB shell version: 1.8.1
    usage: mongo.exe [options] [db address] [file names (ending in .js)]
    db address can be:
      foo                   foo database on local machine
      192.169.0.5/foo       foo database on 192.168.0.5 machine
      192.169.0.5:9999/foo  foo database on 192.168.0.5 machine on port 9999
    options:
      --shell               run the shell after executing files
      --nodb                don't connect to mongod on startup - no 'db address'
                            arg expected
      --quiet               be less chatty
      --port arg            port to connect to
      --host arg            server to connect to
      --eval arg            evaluate javascript
      -u [ --username ] arg username for authentication
      -p [ --password ] arg password for authentication
      -h [ --help ]         show this usage information
      --version             show version information
      --verbose             increase verbosity
      --ipv6                enable IPv6 support (disabled by default)

    file names: a list of files to run. files have to end in .js and will exit after unless --shell is specified



六、相关命令很多，要习惯使用 "help"。
    MongoDB shell version: 1.8.1
    connecting to: test
        help
            db.help()                    help on db methods
            db.mycoll.help()             help on collection methods
            rs.help()                    help on replica set methods
            help connect                 connecting to a db help
            help admin                   administrative help
            help misc                    misc things to know
            help mr                      mapreduce help

            show dbs                     show database names // 显示所有的数据库名称,像 MySQL 的“show databases;”
            show collections             show collections in current database // 显示集合，像 MySQL 的“show tables;”
            show users                   show users in current database
            show profile                 show most recent system.profile entries wit
    h time >= 1ms
            use <db_name                   set current database // 进入某个数据库，像 MySQL、SQL Server 的“use 数据库名;”
            db.foo.find()                list objects in collection foo
            db.foo.find( { a : 1 } )     list objects in foo where a == 1
            it                           result of the last line evaluated; use to f
    urther iterate
            DBQuery.shellBatchSize = x   set default number of items to display on s
    hell
            exit                         quit the mongo shell // 退出


七、 数据库管理
  1. dbpath & port
    默认数据存储路径是 /data/db，默认端口 27017, 默认 HTTP 端口 28017 。用 --dbpath 和 --port 改吧。
    $ sudo ./mongod --dbpath /var/mongodb --port 1234   // 服务器端
    $ sudo ./mongo --port 1234   // 客户端

    默认时的网页访问： http://127.0.0.1:28017/
    网页查看某个集合： http://localhost:28017/blog/users/

    --bind_ip 用于设定监听绑定 IP。
    $ sudo ./mongod --bind_ip 127.0.0.1  // 服务器端,设置服务器IP
    $ sudo ./mongo --host 127.0.0.1   // 客户端


    默认情况下，所有的 DB 都存储到 --dbpath 指定的目录中。
    可以用 --directoryperdb 参数让系统为每个 DB 创建一个独立子目录：
    $ sudo ./mongod --dbpath /var/mongodb --fork --logpath /dev/null --directoryperdb

  2. daemon
    如果想以 Daemon 方式运行，需要同时使用 --fork、--logpath 参数。
    $ sudo ./mongod --dbpath /var/mongodb --fork --logpath /dev/null

    想要停止服务，可以发送 INT 或 TERM 信号。
    $ sudo kill -INT 1797

    或者使用 mongo 连接到服务器，然后执行 shutdownServer 命令。
    use admin
    db.shutdownServer()

    // v1.8.1 版本，不支持 fork 参数
    $ sudo ./mongod --logpath /dev/log.txt

  3. logging
    与 Logging 有关的参数除了 --logpath，还有 --logappend 和 --verbose。

    默认情况下，Logging 是覆盖模式(overwrite)，通过 --logappend 可以添加模式记录日志(不覆盖，追加上去)。
    参数 --verbose 设置记录等级，相当于 -v，更多的级别包括 -vv 直到 -vvvvv。与之相对的是 --quiet，生成最少的日志信息。
    还可以用 --cpu 记录 CPU 的相关信息。

  4. configuration file
    如果嫌命令行参数太长，可以考虑使用配置文件。

    $ cat test.conf
    dbpath = /var/mongodb
    logpath = /var/test.log
    logappend = true
    directoryperdb = true
    port = 1234

    $ sudo ./mongod --config test.conf
    forked process: 2262
    all output going to: /var/test.log

  5. db.serverStatus
    在 mongo 中执行 admin.serverStatus() 命令可以获取 MongoDB 的运行统计信息。

    use admin
    db.serverStatus()

    相关字段说明：
        uptime: 服务器运行时间(秒)。
        localTime: 服务器本地时间。
        mem: 服务器内存信息。
        connections: 当前连接数。
        opcounters: 操作统计。

  6. db.stats
    db.stats 查看数据库状态信息。

    db.stats()
    // 显示如：
    {
        "db" : "test",
        "collections" : 5,
        "objects" : 18,
        "avgObjSize" : 50.888888888888886,
        "dataSize" : 916,
        "storageSize" : 26112,
        "numExtents" : 5,
        "indexes" : 5,
        "indexSize" : 40960,
        "fileSize" : 201326592,
        "ok" : 1
    }

  7. http console
    Mongod 默认会打开一个 HTTP 监听端口，通过浏览器我们能获取 MongoDB 服务器的相关状态信息。如果不想启动 HTTP Listening，可以使用 --nohttpinterface 参数。

  8. 数据库备份和还原
     注：备份和还原时，需启动服务

     a.备份
        cd /program/mongodb-1.4/bin  // 进入 mongodb 安装目录
        ./mongodump -h IP地址:端口号 -d 集合名 -o 保存的目录路径   // 备份的写法
        ./mongodump -h 192.168.1.3:10000 -d test -o /home/abeen/work/ppf_web/dbback/`date '+%Y%m%d'`  // linux 下的示例

        window 的写法如：
        For /f "tokens=1, 2, 3, 4 delims=-/. " %%j In ('Date /T') do set "FILENAME=%~dp0dbback/%%j%%k%%l"
        cd C:\mongodb\bin
        mongodump.exe -h 127.0.0.1:27017 -d test -o %FILENAME%

     b.还原
        cd /program/mongodb-1.4/bin  // 进入 mongodb 安装目录
        ./mongorestore -h IP地址:端口号 -d 集合名 --drop --directoryperdb 保存的目录路径/集合名/   // 还原的写法
        ./mongorestore -d test /home/df/Project/mongodb/test/  // linux 下的示例

        window 的写法如：
        cd C:\mongodb\bin
        mongorestore.exe -h 127.0.0.1:27017 -d test %~dp0dbback/20110817/test/

        参数：
        --drop：恢复的时候，先删除当前数据，然后恢复备份的数据。就是说，恢复后，备份后添加修改的数据都会被删除，慎用哦！


八、 Optimization
  1. Profiler
    MongoDB 自带 Profiler，可以非常方便地记录下所有耗时过长操作，以便于调优。

    db.setProfilingLevel(n)
    n:
       0: Off; // 停止调优
       1: Log Slow Operations; // 记录最慢的情况
       2: Log All Operations.

    通常我们只关心 Slow Operation，Level 1 默认记录 >100ms 的操作，当然我们也可以自己调整 "db.setProfilingLevel(2, 300)"。
    Profiler 信息保存在 system.profile (Capped Collection) 中。

    准备 1000000 条数据测试一下：
    for (var i=0; i<1000000; i++) db.users.insert({name:"user"+i, age:parseInt(Math.random()*100)})

    开始调优操作。
    db.setProfilingLevel(1)
    db.users.find().sort({age:-1}).limit(10000)
    db.system.profile.find()
    // 显示如：
    {
        "ts" : "Thu Jul 29 2010 09:47:47 GMT+0800 (CST)",
        "info" : "query blog.users
            ntoreturn:10000 scanAndOrder
            reslen:518677
            nscanned:1000000
            query: { query: {}, orderby: { age: -1.0 } }
            nreturned:10000 1443ms",
        "millis" : 1443
    }

    system.profile 中记录下一条耗时过长的操作。
        ts: 操作执行时间。
        info: 操作详细信息。
        info.query: 查询目标(数据库.集合)。
        info.ntoreturn: 客户端期望返回的文档数量。
        info.nscanned: 服务器实际扫描的文档数量。
        info.reslen: 查询结果字节长度。
        info.nreturnned: 查询返回文档数。
        millis: 操作耗时(毫秒)。

    很显然，该操作扫描的文档过多(info.nscanned)，通常是没有使用索引造成的。我们用 explain() 看看服务器如何执行执行该命令。
    没有索引自然很慢了，建个索引看看效果。
    db.users.ensureIndex({age:-1})
    db.users.find().sort({age:-1}).limit(10000).explain()

    速度提升非常明显。最后别忘了 Profiler 本身也会影响服务器性能，不用的时候要关掉。
    db.setProfilingLevel(0)

    除了使用 setProfilingLevel 命令外，也可以在 mongod 参数中启用 profiler，不推荐。
    --profile arg             0=off 1=slow, 2=all
    --slowms arg (=100)       value of slow for profile and console log


  2. Optimization
    优化建议:
    如果 nscanned 远大于 nreturned，那么需要使用索引。
    如果 reslen 返回字节非常大，那么考虑只获取所需的字段。
    执行 update 操作时同样检查一下 nscanned，并使用索引减少文档扫描数量。
    使用 db.eval() 在服务端执行某些统计操作。
    减少返回文档数量，使用 skip & limit 分页。



九、Map/Reduce
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

    1.测试数据：
        db.users.drop(); // 先清空
        for (var i = 0; i < 1000; i++) {
            var u = { name : "user" + i, age : i % 40 + 1, sex : i % 2 };
            db.users.insert(u);
        }



十、性能
    1.分页问题
      db.集合名.find().skip(从第几笔开始).limit(每页显示多少)

      当数据量不大时，可以用 skip 和 limit, 但数据量很大时会严重影响性能，不再建议使用
      数据量很大时，建议按 id 排序,记录上一页的最后 id，然后从这id开始读取,使用 limit 即可









=============================================

基本操作
db.commandHelp(name)           //returns the help for the command
db.createCollection(name,{size:3333,capped:333,max:88888})  //创建一个数据集，相当于一个表
db.currentOp()                 //取消当前库的当前操作
db.dropDataBase()              //删除当前数据库
db.eval(func,args)             //run code server-side
db.getCollection(cname)        //取得一个数据集合，同用法：db['cname'] or
db.getCollenctionNames()       //取得所有数据集合的名称列表
db.getLastError()              //返回最后一个错误的提示消息
db.getLastErrorObj()           //返回最后一个错误的对象
db.getMongo()                  //取得当前服务器的连接对象get the server
db.getMondo().setSlaveOk()     //allow this connection to read from then nonmaster membr of a replica pair
db.getName()                   //返回当操作数据库的名称
db.getPrevError()              //返回上一个错误对象
db.getProfilingLevel()
db.getReplicationInfo()        //获得重复的数据
db.getSisterDB(name)           //get the db at the same server as this onew
db.killOp()                    //停止（杀死）在当前库的当前操作
db.printCollectionStats()      //返回当前库的数据集状态
db.printReplicationInfo()
db.printSlaveReplicationInfo()
db.printShardingStatus()       //返回当前数据库是否为共享数据库
db.removeUser(username)        //删除用户
db.repairDatabase()            //修复当前数据库
db.resetError()
db.runCommand(cmdObj)          //run a database command. if cmdObj is a string, turns it into {cmdObj:1}
db.setProfilingLevel(level)    //0=off,1=slow,2=all
db.shutdownServer()            //关闭当前服务程序
db.version()                   //返回当前程序的版本信息

数据集(表)操作
view sourceprint?
db.集合名.find({id:10})          //返回test数据集ID=10的数据集
db.集合名.find({id:10}).count()  //返回test数据集ID=10的数据总数
db.集合名.find({id:10}).limit(2) //返回test数据集ID=10的数据集从第二条开始的数据集
db.集合名.find({id:10}).skip(8)  //返回test数据集ID=10的数据集从0到第八条的数据集
db.集合名.find({id:10}).limit(2).skip(8)  //返回test数据集ID=1=的数据集从第二条到第八条的数据
db.集合名.find({id:10}).sort()   //返回test数据集ID=10的排序数据集
db.集合名.findOne([query])       //返回符合条件的一条数据
db.集合名.getDB()                //返回此数据集所属的数据库名称
db.集合名.getIndexes()           //返回些数据集的索引信息
db.集合名.group({key:...,initial:...,reduce:...[,cond:...]})  // group by 操作
db.集合名.mapReduce(mayFunction,reduceFunction,<optional params>)
db.集合名.remove(query)                      //在数据集中删除一条数据
db.集合名.renameCollection(newName)          //重命名些数据集名称
db.集合名.save(obj)                          //往数据集中插入一条数据
db.集合名.stats()                            //返回此数据集的状态
db.集合名.storageSize()                      //返回此数据集的存储大小
db.集合名.totalIndexSize()                   //返回此数据集的索引文件大小
db.集合名.totalSize()                        //返回些数据集的总大小
db.集合名.update(query,object[,upsert_bool]) //在此数据集中更新一条数据
db.集合名.validate()                         //验证此数据集
db.集合名.getShardVersion()                  //返回数据集共享版本号

MongoDB语法与现有关系型数据库SQL语法比较
view sourceprint?01 db.集合名.find({'name':'foobar'})  // SELECT * FROM test WHERE name='foobar'
db.集合名.find()  // SELECT * FROM test
db.集合名.find({'data_id':10}).count()  // SELECT COUNT(*) FROM test WHERE data_id=10
db.集合名.find().skip(10).limit(20)  // SELECT * FROM test LIMIT 10,20
db.集合名.find({'data_id':{$in:[25,35,45]}})  // SELECT * FROM test WHERE data_id IN (25,35,45)
db.集合名.find().sort({'data_id':-1})  // SELECT * FROM test ORDER BY data_id DESC
db.集合名.distinct('name',{'data_id':{$lt:20}})  // SELECT DISTINCT(name) FROM test WHERE data_id<20
db.集合名.group({key:{'name':true},cond:{'name':'foo'},reduce:function(obj,prev){prev.msum+=obj.marks;},initial:{msum:0}})  // SELECT name,SUM(marks) FROM test GROUP BY name
db.集合名.find('this.data_id<20',{name:1})  // SELECT name FROM test WHERE data_id<20
db.集合名.insert({'name':'foobar','age':25})  // INSERT INTO test ('name','age') VALUES('foobar',25)
db.集合名.remove({})  // DELETE * FROM test
db.集合名.remove({'age':20})  // DELETE test WHERE age=20
db.集合名.remove({'age':{$lt:20}})  // SELETE test WHERE age<20
db.集合名.remove({'age':{$lte:20}})  // DELETE test WHERE age<=20
db.集合名.remove({'age':{$gt:20}})  // DELETE test WHERE age>20
db.集合名.remove({'age':{$gte:20}})  // DELETE test WHERE age>=20
db.集合名.remove({'age':{$ne:20}})  // DELETE test WHERE age!=20
db.集合名.update({'name':'foobar'},{$set:{'age':36}})  // UPDATE test SET age=36 WHERE name='foobar'
db.集合名.update({'name':'foobar'},{$inc:{'age':3}})  // UPDATE test SET age=age+3 WHERE NAME='foobar'

/***************************************************************************/
时间检索
//检索 7月12 到 8月1号的数据
db.cpc_common.cpc_click_detail_log.count({date_created:{$gte:new Date(2010, 6,12), $lt:new Date(2010,7,1)}})
//删除 7月12 到 8月1号的数据
 db.cpc_common.cpc_click_detail_log.remove({date_created:{$gte:new Date(2010, 6,12), $lt:new Date(2010,7,1)}})
/*********************************************************************/

like 查询
query.put("search_keyword", Pattern.compile(search_word +"+"));
/*****************************************************************/


================
DBA操作命令  http://www.mongodb.org/display/DOCS/DBA+Operations+from+the+Shell
查询条件的表达式文档 http://www.mongodb.org/display/DOCS/Advanced+Queries
数据库命令集  http://www.mongodb.org/display/DOCS/List+of+Database+Commands
mongod命令行参数 http://www.mongodb.org/display/DOCS/Command+Line+Parameters
官方文档索引 http://www.mongodb.org/display/DOCS/Doc+Index

http://www.mongodb.org/display/DOCS/Aggregation

select a,b,sum(c) csum from coll where active=1 group by a,b
db.coll.group({key: { a:true, b:true },
            cond: { active:1 },
            reduce: function(obj,prev) { prev.csum += obj.c; },
            initial: { csum: 0 }
            });

db['count'].group({key:{siteid:true}, reduce:function(obj, prev){prev.csum += obj.archivecount}, initial: { csum: 0 }}).count();
