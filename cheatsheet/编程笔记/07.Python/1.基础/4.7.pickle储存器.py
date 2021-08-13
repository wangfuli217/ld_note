
pickle 标准模块。
它可以在一个文件中储存任何Python对象，之后又可以把它完整无缺地取出来。这被称为 持久地 储存对象。
在pythony 3.0 已经移除了 cPickle 模块，可以使用 pickle 模块代替。

存储：pickle.dump(obj,file)，其中obj是要存储的Python对象，file文件对象 （用二进制写打开）
加载：obj=pickle.load(file)，其中file文件对象（用二进制读打开）

################## 示例 #####################
    import pickle as p # 这里使用 as 简称,方便更改模块时只需改一行代码
    # import cPickle as p # Python 2.x 有这个模块(比pickle快1000倍)

    # 将会把资料保存在这个文件里面
    shoplistfile = 'shoplist.data'

    # 需要保存的资料
    shoplist = ['apple', 'mango', 'carrot', 2, 5]

    # 写入文件
    f = open(shoplistfile, "wb") # 以二进制写入,Python2.x时可不用二进制,但3.x必须
    p.dump(shoplist, f) # dump the object to a file
    f.close()

    # 取出资料
    f = open(shoplistfile, "rb") # 以二进制读取
    storedlist2 = p.load(f)
    print(storedlist2)
    f.close()

    # 删除文件
    import os
    os.remove(shoplistfile)



