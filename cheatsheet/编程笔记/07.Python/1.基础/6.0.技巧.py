
交换变量

    x = 6
    y = 5

    x, y = y, x

    print x # 打印:5
    print y # 打印:6



if 语句在行内
    作用相当于 C/Java 的三目运算符

    a = "Hello" if True else "World"
    b = "Hello" if False else "World"

    print a # 打印:Hello
    print b # 打印:World


连接
    # 列表、元组 拼接
    nfc = ["Packers", "49ers"]
    afc = ["Ravens", "Patriots"]
    print nfc + afc  # 打印:['Packers', '49ers', 'Ravens', 'Patriots']

    # 字符串 拼接
    print str(1) + " world" # 打印:1 world

    # 数值的这种写法，我还不清楚是什么, 会当成字符串处理，却又不是真正的字符串
    print `1` + " world" # 打印:1 world


    # python2.x 的 print 可以这样打印多个不同类型的内容
    print 1, "world" # 打印:1 world
    print nfc, 1 # 打印:['Packers', '49ers'] 1

    # python3.x 的 print 可以这样打印多个不同类型的内容(效果同上面 2.x 的)
    print(1, "world", end=' ') # 打印:1 world
    print(nfc, 1, end=' ') # 打印:['Packers', '49ers'] 1


序列(包括:列表、元组、字符串)

带索引的 序列 迭代(很实用的获取索引的写法)

    teams = ["Packers", "49ers", "Ravens", "Patriots"]
    for index, team in enumerate(teams):
        print index, team  # 打印如:0 Packers

序列 的乘法
    items = [0]*3
    print(items)

序列 拼接为字符串
    teams = ["Packers", "49ers", "Ravens", "Patriots"]
    print(", ".join(teams))

序列 的子集
    teams = ["Packers", "49ers", "Ravens", "Patriots"]
    print(teams[-2])     # 最后两项(负数表示倒数几项)
    print(teams[:])      # 复制一份
    print(teams[::-1])   # 反序
    print(teams[::2])    # 奇数项
    print(teams[1::2])   # 偶数项


数值比较
    这是我见过诸多语言中很少有的如此棒的简便法

    x = 2
    if 3 > x > 1:
       print x # 打印:2

    if 1 < x > 0:
       print x # 打印:2


同时迭代两个列表

    nfc = ["Packers", "49ers"]
    afc = ["Ravens", "Patriots"]
    for teama, teamb in zip(nfc, afc):
         print teama + " vs. " + teamb
    # 打印1: Packers vs. Ravens
    # 打印2: 49ers vs. Patriots


60个字符解决FizzBuzz
    前段时间Jeff Atwood 推广了一个简单的编程练习叫FizzBuzz，问题引用如下：
    写一个程序，打印数字1到100，3的倍数打印“Fizz”来替换这个数，5的倍数打印“Buzz”，对于既是3的倍数又是5的倍数的数字打印“FizzBuzz”。

    这里就是一个简短的，有意思的方法解决这个问题：
    for x in range(1,101):print"fizz"[x%3*4:]+"buzz"[x%5*4:]or x


False == True
    比起实用技术来说这是一个很有趣的事，在python中, True 和 False 是全局变量(值允许改变)，因此：

    False = True
    if False:
       print "Hello"
    else:
       print "World"
    # 打印: Hello


