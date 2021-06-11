tuple(解压一个N个元素的tuple到N个变量中){
# 使用tuple的pack和unpack特性
p = (4, 5)
x, y = p
注意:
    变量个数需要和tuple元素的个数一致.
    任何对象, 只要是可迭代的,都可使用这种方式. 比如string
    如果其中某个值不想要, 可赋值给变量"_"
     data = ( 'ACME', 50, 91.1, (2012, 12, 21) )
     _, shares, price, _ = data
}

tuple(如何解压一个N个元素的tuple到少于N个变量中){
# 使用星号(*)表达式   存在问题，功能不正常  Python3
record = ('Dave', 'dave@example.com', '773-555-1212', '847-555-1212')
name, email, *phone_numbers = record
注意:
    星号变量可以在第一个, 中间或最后一个.
    星号变量代表的是一个list; 当没有多余的值赋值给星号变量时,星号变量为空list
    当不需要某个星号变量时, 可将变量名定义为 *_
}
deque(在迭代操作或者其他操作的时候，怎样只保留最后有限几个元素的历史记录){
使用collections.deque
    deque有一个参数(maxlen), 用于创建长度固定的队列. 当队列满时,而有新的元素加入, 则最早的元素会被删除
    deque常用操作方法:append(添加到尾部), appendleft(添加到头部), pop(从尾部取出), popleft(从头部取出)
    
}
collections(namedtuple, deque, defaultdict, OrderedDict, Counter){
collections是Python内建的一个集合模块，提供了许多有用的集合类。
namedtuple: # 具备tuple的不变性，又可以根据属性来引用
>>>from collections import namedtuple
>>>Point = namedtuple('Point', ['x', 'y'])
>>>p = Point(1, 2)
>>>p.x
>>>p.y
    namedtuple是一个函数，它用来创建一个自定义的tuple对象，并且规定了tuple元素的个数，并可以用属性而
不是索引来引用tuple的某个元素。

deque: # 高效实现插入和删除操作的双向列表，适合用于队列和栈
>>> from collections import deque
>>> q = deque(['a', 'b', 'c'])
>>> q.append('x')
>>> q.appendleft('y')
>>> q
deque(['y', 'a', 'b', 'c', 'x'])

defaultdict: # 使用dict时，如果引用的Key不存在，就会抛出KeyError。如果希望key不存在时，返回一个默认值，就可以用defaultdict
>>> from collections import defaultdict 
>>> dd = defaultdict(lambda: 'N/A') 
>>> dd['key1'] = 'abc' 
>>> dd['key1'] # key1存在 'abc' 
>>> dd['key2'] # key2不存在，返回默认值 'N/A'

OrderedDict: # 使用dict时，Key是无序的。在对dict做迭代时，我们无法确定Key的顺序。如果要保持Key的顺序，可以用OrderedDict
>>> from collections import OrderedDict
>>> d = dict([('a', 1), ('b', 2), ('c', 3)])
>>> d # dict的Key是无序的
{'a': 1, 'c': 3, 'b': 2}
>>> od = OrderedDict([('a', 1), ('b', 2), ('c', 3)])
>>> od # OrderedDict的Key是有序的
# 注意，OrderedDict的Key会按照插入的顺序排列，不是Key本身排序：
OrderedDict可以实现一个FIFO（先进先出）的dict，当容量超出限制时，先删除最早添加的Key：

Counter: # Counter是一个简单的计数器，例如，统计字符出现的个数：
>>> from collections import Counter
>>> c = Counter()
>>> for ch in 'programming':
...     c[ch] = c[ch] + 1
...
>>> c
}
heapq(找出最大或最小的N个元素){
    堆是一个二叉树，其中每个父节点的值都小于或者等于其所有子节点的值。整个堆的最小元素总是位于二叉树的根节点。
Python的headq模块提供了对堆的支持。
使用heapq.nlargest / heapq.smallest 方法
import heapq
nums = [1, 8, 2, 23, 7, -4, 18, 23, 42, 37, 2]
print(heapq.nlargest(3, nums)) # Prints [42, 37, 23]
print(heapq.nsmallest(3, nums)) # Prints [-4, 1, 2]

heapq模块的nlargest/nsmallest方法工作原理为: 现将集合转变为排序heap, 再通过分片操作(:)进行截取
#heap为定义堆，item 增加的元素;
>>> heap=[] 
>>> heapq.heappush(heap, 2)
#将列表转换为堆
>>> list=[5,8,0,3,6,7,9,1,4,2]
>>> heapq.heapify(list) 
#删除最小的值
>>> list=[2, 4, 3, 5, 7, 8, 9, 6] 
>>> heapq.heappop(list) # list=[1, 2, 5, 3, 6, 7, 9, 8, 4]
#删除最小元素值，添加新的元素值
>>> heapq.heapreplace(list, 11) # list=[11, 2, 5, 3, 6, 7, 9, 8, 4]
#首判断添加元素值与堆的第一个元素值对比，如果大于则删除最小元素，然后添加新的元素值，否则不更改堆
条件：item >heap[0] 
heap=[2, 4, 3, 5, 7, 8, 9, 6] 
heapq.heappushpop(heap, 9) # heap=[3, 4, 5, 6, 8, 9, 9, 7] 
条件：item 
heap=[2, 4, 3, 5, 7, 8, 9, 6] 
heapq.heappushpop(heap, 9) # heap=[2, 4, 3, 5, 7, 8, 9, 6]
heapq.merge(...) #将多个堆合并
}
heapq(实现一个优先级队列){
利用heapq来实现
}
defaultdict(怎样实现一个键对应多个值的字典){
使用collections.defaultdict

from collections import defaultdict
d = defaultdict(list)       #value为list对象
d['a'].append(1)
d['a'].append(2)
d['b'].append(4)

d = defaultdict(set)        #value为set对象
d['a'].add(1)
d['a'].add(2)
d['b'].add(4)

如果不使用defaultdict, 代码可能会这么写:
d = {}
for key, value in pairs:
	if key not in d:
		d[key] = []
	d[key].append(value)
}
OrderedDict(如何创建一个保持元素插入顺序的dict){

使用collections.OrderedDict
from collections import OrderedDict
def ordered_dict():
    d = OrderedDict()
    d['foo'] = 2
    d['bar'] = 1
    d['spam'] = 3
    d['grok'] = 4
    # Outputs "foo 1", "bar 2", "spam 3", "grok 4"
    for key in d:
        print(key, d[key])
ordered_dict()
    OrderedDict 内部维护着一个根据键插入顺序排序的双向链表。每次当一个新的元素插入进来的时候,它会被放到链表的尾部。对于一个已经存在的键的重复赋值不会改变键的顺序。 ，
    一个 OrderedDict 的大小是一个普通字典的两倍，因为它内部维护着另外一个链表
}
zip(如何依据dict的值进行排序){
通过zip()方法将dict中的key和value反转来实现.
min_price = min(zip(prices.values(), prices.keys()))
max_price = max(zip(prices.values(), prices.keys()))
}
pickle(对象：序列化 - 反序列化){
import cPickle as pickle
d = dict(name='Bob', age=20, score=88)
pickle.dumps(d)    # 序列化对象到二进制Bytes
pickle.dump(d,f)   # #序列化后直接写入文件，f为文件句柄
#反序列化
>>> d = pickle.loads(b'...')
>>> d = pickle.load(f) #同理直接读并反序列化
}
json(JSON序列化){
使用内置的json模块。

>>> import json
>>> #序列化
>>> d = dict(name='Bob', age=20, score=88)
>>> json.dumps(d)
'{"age": 20, "score": 88, "name": "Bob"}'

#反序列化
>>> json_str = '{"age": 20, "score": 88, "name": "Bob"}'
>>> json.loads(json_str) #也有json.load(f)来从文件中读取
{'age': 20, 'score': 88, 'name': 'Bob'}

}
Celery(任务调度利器){
    Celery本身不含消息服务，它使用第三方消息服务来传递任务，
目前，Celery支持的消息服务有RabbitMQ、Redis甚至是数据库，当然Redis应该是最佳选择。
sudo pip install Celery
使用Redis作为Broker时，再安装一个celery-with-redis。

开始编写tasks.py：

# tasks.py
import time
from celery import Celery

celery = Celery('tasks', broker='redis://localhost:6379/0')

@celery.task
def sendmail(mail):
    print('sending mail to %s...' % mail['to'])
    time.sleep(2.0)
    print('mail sent.')

然后启动Celery处理任务：
$ celery -A tasks worker --loglevel=info
上面的命令行实际上启动的是Worker，如果要放到后台运行，可以扔给supervisor。
如何发送任务？
>>> from tasks import sendmail
>>> sendmail.delay(dict(to='celery@python.org'))
<AsyncResult: 1a0a9262-7858-4192-9981-b7bf0ea7483b>

然后，在Worker里就可以看到任务处理的消息：
[2013-08-27 19:20:23,363: WARNING/MainProcess] celery@MichaeliMac.local ready.
[2013-08-27 19:20:23,367: INFO/MainProcess] consumer: Connected to redis://localhost:6379/0.
[2013-08-27 19:20:45,618: INFO/MainProcess] Got task from broker: tasks.sendmail[1a0a9262-7858-4192-9981-b7bf0ea7483b]
[2013-08-27 19:20:45,655: WARNING/PoolWorker-4] sending mail to celery@python.org...
[2013-08-27 19:20:47,657: WARNING/PoolWorker-4] mail sent.
[2013-08-27 19:20:47,658: INFO/MainProcess] Task tasks.sendmail[1a0a9262-7858-4192-9981-b7bf0ea7483b] succeeded in 2.00266814232s: None
}
supervisor(后台进程管理利器){
supervisor就是用Python开发的一套通用的进程管理程序，能将一个普通的命令行进程变为后台daemon，并监控进程状态，异常退出时能自动重启。
apt-get install supervisor
然后，给我们自己开发的应用程序编写一个配置文件，让supervisor来管理它。每个进程的配置文件都可以单独分拆，放在/etc/supervisor/conf.d/目录下，以.conf作为扩展名，例如，app.conf定义了一个gunicorn的进程：

[program:app]
command=/usr/bin/gunicorn -w 1 wsgiapp:application
directory=/srv/www
user=www-data
其中，进程app定义在[program:app]中，command是命令，directory是进程的当前目录，user是进程运行的用户身份。

重启supervisor，让配置文件生效，然后运行命令supervisorctl启动进程：
# supervisorctl start app

停止进程：
# supervisorctl stop app

如果要在命令行中使用变量，就需要自己先编写一个shell脚本：
#!/bin/sh
/usr/bin/gunicorn -w `grep -c ^processor /proc/cpuinfo` wsgiapp:application
然后，加上x权限，再把command指向该shell脚本即可。
}
partial(可以将函数包装成更简洁的版本){
用 functools.partial() 可以将函数包装成更简洁的版本。
    from functools import partial
}
StringIO(cStringIO, BytesIO){
>>> from io import StringIO
>>> f = StringIO()
>>> f
<_io.StringIO object at 0x10b086948>
>>> f.write('alo')
3
>>> f.write('ha!')
3
>>> f.getvalue()
'aloha!'
>>>

# 用字符串初始化，并按需读取
>>> f = StringIO('Hello!\nHi!\nGoodbye!')
>>> for line in f.readlines():
...     print(line)
...
Hello!

Hi!

Goodbye!
}
sys(包含了与Python解释器和它的环境有关的函数){
sys.argv: 实现从程序外部向程序传递参数。
sys.exit([arg]): 程序中间的退出，arg=0为正常退出。
sys.getdefaultencoding(): 获取系统当前编码，一般默认为ascii。
sys.setdefaultencoding(): 设置系统默认编码，执行dir（sys）时不会看到这个方法，在解释器中执行不通过，可以先执行reload(sys)，在执行 setdefaultencoding('utf8')，此时将系统默认编码设置为utf8。（见设置系统默认编码 ）
sys.getfilesystemencoding(): 获取文件系统使用编码方式，Windows下返回'mbcs'，mac下返回'utf-8'.
sys.path: 获取指定模块搜索路径的字符串集合，可以将写好的模块放在得到的某个路径下，就可以在程序中import时正确找到。
sys.platform: 获取当前系统平台。
sys.stdin,sys.stdout,sys.stderr: stdin , stdout , 以及stderr 变量包含与标准I/O 流对应的流对象. 如果需要更好地控制输出,而print 不能满足你的要求, 它们就是你所需要的. 你也可以替换它们, 这时候你就可以重定向输出和输入到其它设备( device ), 或者以非标准的方式处理它们
}
OS(){

os.mknod("text.txt")：创建空文件
fp = open("text.txt",w):直接打开一个文件，如果文件不存在就创建文件
# 关于open的模式
w 写方式
a 追加模式打开（从EOF开始，必要时创建新文件）
r+ 以读写模式打开
w+ 以读写模式打开
a+ 以读写模式打开
rb 以二进制读模式打开
wb 以二进制写模式打开 (参见 w )
ab 以二进制追加模式打开 (参见 a )
rb+ 以二进制读写模式打开 (参见 r+ )
wb+ 以二进制读写模式打开 (参见 w+ )
ab+ 以二进制读写模式打开 (参见 a+ )

# 关于文件的函数
fp.read([size])                    
size为读取的长度，以byte为单位
fp.readline([size])                
读一行，如果定义了size，有可能返回的只是一行的一部分
fp.readlines([size])               
把文件每一行作为一个list的一个成员，并返回这个list。其实它的内部是通过循环调用readline()来实现的。如果提供size参数，size是表示读取内容的总长，也就是说可能只读到文件的一部分。
fp.write(str)                      
把str写到文件中，write()并不会在str后加上一个换行符
fp.writelines(seq)                  
把seq的内容全部写到文件中(多行一次性写入)。这个函数也只是忠实地写入，不会在每行后面加上任何东西。
fp.close()                        
关闭文件。python会在一个文件不用后自动关闭文件，不过这一功能没有保证，最好还是养成自己关闭的习惯。 如果一个文件在关闭后还对其进行操作会产生ValueError
fp.flush()                                      
把缓冲区的内容写入硬盘
fp.fileno()                                      
返回一个长整型的”文件标签“
fp.isatty()                                      
文件是否是一个终端设备文件（unix系统中的）
fp.tell()                                         
返回文件操作标记的当前位置，以文件的开头为原点
fp.next()                                       
返回下一行，并将文件操作标记位移到下一行。把一个file用于for … in file这样的语句时，就是调用next()函数来实现遍历的。
fp.seek(offset[,whence])              
将文件打操作标记移到offset的位置。这个offset一般是相对于文件的开头来计算的，一般为正数。但如果提供了whence参数就不一定了，whence可以为0表示从头开始计算，1表示以当前位置为原点计算。2表示以文件末尾为原点进行计算。需要注意，如果文件以a或a+的模式打开，每次进行写操作时，文件操作标记会自动返回到文件末尾。
fp.truncate([size])                       
把文件裁成规定的大小，默认的是裁到当前文件操作标记的位置。如果size比文件的大小还要大，依据系统的不同可能是不改变文件，也可能是用0把文件补到相应的大小，也可能是以一些随机的内容加上去。

# 目录操作
os.mkdir("file")                   
创建目录
复制文件:
shutil.copyfile("oldfile","newfile")       
oldfile和newfile都只能是文件
shutil.copy("oldfile","newfile")            
oldfile只能是文件夹，newfile可以是文件，也可以是目标目录
shutil.copytree("olddir","newdir")        
复制文件夹.olddir和newdir都只能是目录，且newdir必须不存在
os.rename("oldname","newname")       
重命名文件（目录）.文件或目录都是使用这条命令
shutil.move("oldpos","newpos")   
移动文件（目录）
os.rmdir("dir")
只能删除空目录
shutil.rmtree("dir")    
空目录、有内容的目录都可以删
os.chdir("path")
}
platform(){
platform.system() 获取操作系统类型，windows、linux等
platform.platform() 获取操作系统，Darwin-9.8.0-i386-32bit
platform.version() 获取系统版本信息 6.2.0
platform.mac_ver()
platform.win32_ver() ('post2008Server', '6.2.9200', '', u'Multiprocessor Free')
}
psutil(系统性能信息模块){
轻松实现获取系统运行的进程和系统利用率（包括CPU、内存、磁盘、网络等）信息。
主要用于系统监控，分析和限制系统资源及进程的管理
实现同等命令行工具提供的功能（ps、top、lsof、netstat、ifconfig、who、df、kill、free、nice、ionice， iostat、iotop、uptime、pidof、tty、taskset、pmap）等
# wget https://pypi.python.org/packages/source/p/psutil/psutil-2.0.0.tar.gz --no-check-certificate 
# tar -xzvf psutil-2.0.0.tar.gz 
# cd psutil-2.0.0.tar.gz 
# python setup.py install
}
itertools(){
itertools 模块提供的迭代器函数有以下几种类型：
    无限迭代器：生成一个无限序列，比如自然数序列 1, 2, 3, 4, ...；
    有限迭代器：接收一个或多个序列（sequence）作为参数，进行组合、分组和过滤等；
    组合生成器：序列的排列、组合，求序列的笛卡儿积等；
    
# 1 无限迭代器
itertools 模块提供了三个函数（事实上，它们是类）用于生成一个无限序列迭代器：
    1.1 count(firstval=0, step=1)创建一个从 firstval (默认值为 0) 开始，以 step (默认值为 1) 为步长的的无限整数迭代器
    1.2 cycle(iterable)对 iterable 中的元素反复执行循环，返回迭代器
    1.3 repeat(object [,times]反复生成 object，如果给定 times，则重复次数为 times，否则为无限
1.1 count() 接收两个参数，第一个参数指定开始值，默认为 0，第二个参数指定步长，默认为 1
>>> import itertools
>>>
>>> nums = itertools.count()
>>> for i in nums:
...     if i > 6:
...         break
...     print i

>>> nums = itertools.count(10, 2)    # 指定开始值和步长
>>> for i in nums:
...     if i > 20:
...         break
...     print i

1.2 cycle() 用于对 iterable 中的元素反复执行循环:
>>> import itertools
>>>
>>> cycle_strings = itertools.cycle('ABC')
>>> i = 1
>>> for string in cycle_strings:
...     if i == 10:
...         break
...     print i, string
...     i += 1
1.3 repeat() 用于反复生成一个 object
>>> for item in itertools.repeat('hello world', 3):
...     print item
>>> for item in itertools.repeat([1, 2, 3, 4], 3):
...     print item

# 有限迭代器
itertools 模块提供了多个函数（类），接收一个或多个迭代对象作为参数，对它们进行组合、分组和过滤等：
    chain()          chain(iterable1, iterable2, iterable3, ...)
    compress()       compress(data, selectors)
    dropwhile()      dropwhile(predicate, iterable)
    groupby()        groupby(iterable[, keyfunc])
    ifilter()        
    ifilterfalse()   
    islice()         
    imap()           
    starmap()        
    tee()            
    takewhile()      
    izip()           
    izip_longest()   
2.1 chain 接收多个可迭代对象作为参数，将它们『连接』起来，作为一个新的迭代器返回。
>>> for item in chain([1, 2, 3], ['a', 'b', 'c']):
...     print item

chain 还有一个常见的用法：
chain.from_iterable(iterable)

接收一个可迭代对象作为参数，返回一个迭代器：

>>> from itertools import chain
>>> string = chain.from_iterable('ABCD')
>>> string.next()

>>> from itertools import chain
>>> string = chain.from_iterable('ABCD')
>>> string.next()

2.2 compress 可用于对数据进行筛选，当 selectors 的某个元素为 true 时，则保留 data 对应位置的元素，否则去除：
>>> from itertools import compress
>>> list(compress('ABCDEF', [1, 1, 0, 1, 0, 1]))
>>> list(compress('ABCDEF', [1, 1, 0, 1]))
>>> list(compress('ABCDEF', [True, False, True]))
2.3 dropwhile(predicate, iterable)
其中，predicate 是函数，iterable 是可迭代对象。对于 iterable 中的元素，如果 predicate(item) 为 true，则丢弃该元素，否则返回该项及所有后续项。
list(dropwhile(lambda x: x < 5, [1, 3, 6, 2, 1]))
list(dropwhile(lambda x: x > 3, [2, 1, 6, 5, 4]))
2.4 groupby(iterable[, keyfunc])
其中，iterable 是一个可迭代对象，keyfunc 是分组函数，用于对 iterable 的连续项进行分组，如果不指定，则默认对 iterable 中的连续相同项进行分组，返回一个 (key, sub-iterator) 的迭代器
>>> from itertools import groupby
>>>
>>> for key, value_iter in groupby('aaabbbaaccd'):
...     print key, ':', list(value_iter)
>>> data = ['a', 'bb', 'ccc', 'dd', 'eee', 'f']
>>> for key, value_iter in groupby(data, len):    # 使用 len 函数作为分组函数
...     print key, ':', list(value_iter)
>>> data = ['a', 'bb', 'cc', 'ddd', 'eee', 'f']
>>> for key, value_iter in groupby(data, len):
...     print key, ':', list(value_iter)
2.5 ifilter(function or None, sequence)
将 iterable 中 function(item) 为 True 的元素组成一个迭代器返回，如果 function 是 None，则返回 iterable 中所有计算为 True 的项。
>>> from itertools import ifilter
>>> list(ifilter(lambda x: x < 6, range(10)))
>>> list(ifilter(None, [0, 1, 2, 0, 3, 4]))
2.6 ifilterfalse(function or None, sequence)
from itertools import ifilterfalse
list(ifilterfalse(lambda x: x < 6, range(10)))
list(ifilter(None, [0, 1, 2, 0, 3, 4]))
2.7 islice(iterable, [start,] stop [, step])
其中，iterable 是可迭代对象，start 是开始索引，stop 是结束索引，step 是步长，start 和 step 可选。
from itertools import count, islice
list(islice([10, 6, 2, 8, 1, 3, 9], 5))
list(islice(count(), 6))
list(islice(count(), 3, 10))
list(islice(count(), 3, 10 ,2))
2.8 imap 类似 map 操作，它的使用形式如下：
imap(func, iter1, iter2, iter3, ...)
imap 返回一个迭代器，元素为 func(i1, i2, i3, ...)，i1，i2 等分别来源于 iter, iter2。
>>> from itertools import imap
>>> list(imap(str, [1, 2, 3, 4]))
>>> list(imap(pow, [2, 3, 10], [4, 2, 3]))
2.9 tee 的使用形式如下：
tee(iterable [,n])
tee 用于从 iterable 创建 n 个独立的迭代器，以元组的形式返回，n 的默认值是 2。
>>> from itertools import tee
>>> iter1, iter2 = tee('abcde')
>>> list(iter1)
>>> list(iter2)
2.10 takewhile 的使用形式如下：
takewhile(predicate, iterable)
其中，predicate 是函数，iterable 是可迭代对象。对于 iterable 中的元素，如果 predicate(item) 为 true，则保留该元素，只要 predicate(item) 为 false，则立即停止迭代。
>>> from itertools import takewhile
>>> list(takewhile(lambda x: x < 5, [1, 3, 6, 2, 1]))
>>> list(takewhile(lambda x: x > 3, [2, 1, 6, 5, 4]))

# 组合生成器
itertools 模块还提供了多个组合生成器函数，用于求序列的排列、组合等：
    product
    permutations
    combinations
    combinations_with_replacement
3.1 product 用于求多个可迭代对象的笛卡尔积，它跟嵌套的 for 循环等价。它的一般使用形式如下：
product(iter1, iter2, ... iterN, [repeat=1])
其中，repeat 是一个关键字参数，用于指定重复生成序列的次数，
from itertools import product
for item in product('ABCD', 'xy'):
    print item
>>> list(product('ab', range(3)))
>>> list(product((0,1), (0,1), (0,1)))
>>> list(product('ABC', repeat=2))
3.2 permutations
permutations 用于生成一个排列，它的一般使用形式如下：
permutations(iterable[, r])
其中，r 指定生成排列的元素的长度，如果不指定，则默认为可迭代对象的元素长度。
from itertools import permutations
list(permutations('ABC', 2))
list(permutations('ABC'))
3.3 combinations 用于求序列的组合，它的使用形式如下：
combinations(iterable, r)
其中，r 指定生成组合的元素的长度。
>>> from itertools import combinations
>>> list(combinations('ABC', 2))


}
itertools(通过某个字段将记录分组){
使用itertools.groupby()

rows = [
{'address': '5412 N CLARK', 'date': '07/01/2012'},
{'address': '5148 N CLARK', 'date': '07/04/2012'},
{'address': '5800 E 58TH', 'date': '07/02/2012'},
{'address': '2122 N CLARK', 'date': '07/03/2012'},
{'address': '5645 N RAVENSWOOD', 'date': '07/02/2012'},
{'address': '1060 W ADDISON', 'date': '07/02/2012'},
{'address': '4801 N BROADWAY', 'date': '07/01/2012'},
{'address': '1039 W GRANVILLE', 'date': '07/04/2012'},
]

from operator import itemgetter
from itertools import groupby

# Sort by the desired field first
rows.sort(key=itemgetter('date'))

# Iterate in groups
for date, items in groupby(rows, key=itemgetter('date')):
	print(date)
	for i in items:
		print(' ', i)

#输出
07/01/2012
{'date': '07/01/2012', 'address': '5412 N CLARK'}
{'date': '07/01/2012', 'address': '4801 N BROADWAY'}
07/02/2012
{'date': '07/02/2012', 'address': '5800 E 58TH'}
{'date': '07/02/2012', 'address': '5645 N RAVENSWOOD'}
{'date': '07/02/2012', 'address': '1060 W ADDISON'}
07/03/2012
{'date': '07/03/2012', 'address': '2122 N CLARK'}
07/04/2012
{'date': '07/04/2012', 'address': '5148 N CLARK'}
{'date': '07/04/2012', 'address': '1039 W GRANVILLE'}
}