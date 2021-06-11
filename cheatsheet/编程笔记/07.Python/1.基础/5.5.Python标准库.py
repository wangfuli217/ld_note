8.Python标准库（上）
正则表达式 (re包)
    import re
    m = re.search('[0-9]','abcd4ef')
    #re.search 第一个参数为正则表达式，第二个为源文件
    print(m.group(0))
    #m.group()可以查看搜索到的结果
    
    m = re.search(pattern, string)
    # 搜索整个字符串，直到发现符合的子字符串。
    m = re.match(pattern, string)
    # 从头开始检查字符串是否符合正则表达式。必须从字符串的第一个字符开始就相符。
    str = re.sub(pattern, replacement, string)
    # 在string中利用正则变换pattern进行搜索，对于搜索到的字符串，用另一字符串replacement替换。返回替换后的字符串。
    
    re.split()    # 根据正则表达式分割字符串， 将分割后的所有子字符串放在一个表(list)中返回
    re.findall()  # 根据正则表达式搜索字符串，将所有符合的子字符串放在一个表(list)中返回
    
时间与日期 (time, datetime包)
    time包 import time 
    print(time.time()) # wall clock time, unit: second 
    print(time.clock()) # processor clock time, unit: second
    
    import time 
    print('start') 
    time.sleep(10) # sleep for 10 seconds print('wake up')

    st = time.gmtime() # 返回struct_time格式的UTC时间 
    st = time.localtime() # 返回struct_time格式的当地时间, 当地时区根据系统环境决定。 
    s = time.mktime(st) # 将struct_time格式转换成wall clock time

    datetime包
    简介
          datetime可以理解为date和time两个组成部分。
          date是指年月日构成的日期，time是指时分秒微秒构成的一天24小时中的具体时间。
          你可以将这两个分开管理(datetime.date类，datetime.time类)，
          也可以将两者合在一起(datetime.datetime类)。

          import datetime
          t = datetime.datetime(2012,9,3,21,30)
          print(t)
    运算
          datetime包还定义了时间间隔对象(timedelta)。
          一个时间点(datetime)加上一个时间间隔(timedelta)可以得到一个新的时间点(datetime)。
          import datetime
          t      = datetime.datetime(2012,9,3,21,30)
          t_next = datetime.datetime(2012,9,5,23,30)
          delta1 = datetime.timedelta(seconds = 600)
          delta2 = datetime.timedelta(weeks = 3)
          print(t + delta1)
          print(t + delta2)
          print(t_next - t)

          print(t > t_next)#时间也可以比较

    datetime对象与字符串转换

          from datetime import datetime
          format = "output-%Y-%m-%d-%H%M%S.txt"
          str    = "output-1997-12-23-030000.txt"
          t      = datetime.strptime(str, format)
          print(t_next.strftime(format))
路径与文件 (os.path包, glob包)
    os.path包
        import os.path
        path = '/home/vamei/doc/file.txt'
        
        print(os.path.basename(path))    # 查询路径中包含的文件名
        print(os.path.dirname(path))     # 查询路径中包含的目录
        
        info = os.path.split(path)       # 将路径分割成文件名和目录两个部分，放在一个表中返回
        path2 = os.path.join('/', 'home', 'vamei', 'doc', 'file1.txt')
        # 使用目录名和文件名构成一个路径字符串
        
        p_list = [path, path2]
        print(os.path.commonprefix(p_list))    # 查询多个路径的共同部分
        
        os.path.normpath(path)   # 去除路径path中的冗余。比如'/home/vamei/../.'被转化为'/home'
        
        import os.path
        path = '/home/vamei/doc/file.txt'
        print(os.path.exists(path))    # 查询文件是否存在
        
        print(os.path.getsize(path))   # 查询文件大小
        print(os.path.getatime(path))  # 查询文件上一次读取的时间
        print(os.path.getmtime(path))  # 查询文件上一次修改的时间
        
        print(os.path.isfile(path))    # 路径是否指向常规文件
        print(os.path.isdir(path))     # 路径是否指向目录文件

    glob包
        glob包最常用的方法只有一个, glob.glob()。该方法的功能与Linux中的ls相似。
        import glob
        print(glob.glob('/home/vamei/*'))
        
文件管理 (部分os包，shutil包)
    os包
        mkdir(path) 创建新目录，path为一个字符串，表示新目录的路径。相当于$mkdir命令
        rmdir(path) 删除空的目录，path为一个字符串，表示想要删除的目录的路径。相当于$rmdir命令
        listdir(path) 返回目录中所有文件。相当于$ls命令。
        remove(path) 删除 path指向的文件。
        rename(src, dst) 重命名文件，src和dst为两个路径，分别表示重命名之前和之后的路径。
        chmod(path, mode) 改变path指向的文件的权限。相当于$chmod命令。
        chown(path, uid, gid) 改变path所指向文件的拥有者和拥有组。相当于$chown命令。
        stat(path) 查看path所指向文件的附加信息，相当于$ls -l命令。
        symlink(src, dst) 为文件dst创建软链接，src为软链接文件的路径。相当于$ln -s命令。
        getcwd() 查询当前工作路径 (cwd, current working directory)，相当于$pwd命令。
    shutil包
        copy(src, dst) 复制文件，从src到dst。相当于$cp命令。
        move(src, dst) 移动文件，从src到dst。相当于$mv命令。
存储对象 (pickle包，cPickle包)
    pickle包
    将内存中的对象转换成为文本流：
        
        import pickle
        
        # define class
        class Bird(object):
            have_feather = True
            way_of_reproduction  = 'egg'
        
        summer       = Bird()                 # construct an object
        picklestring = pickle.dumps(summer)   # serialize object
        
        使用pickle.dumps()方法可以将对象summer转换成了字符串picklestring。
        随后我们可以用普通文本的存储方法来将该字符串储存在文件(文本文件的输入输出)。
        
        当然，我们也可以使用pickle.dump()的方法，将上面两部合二为一:
        
        import pickle
        
        # define class
        class Bird(object):
            have_feather = True
            way_of_reproduction  = 'egg'
        
        summer       = Bird()                        # construct an object
        fn           = 'a.pkl'
        with open(fn, 'w') as f:                     # open file with write-mode
            picklestring = pickle.dump(summer, f)   # serialize and save object
        对象summer存储在文件a.pkl

    重建对象
        
        首先，我们要从文本中读出文本，存储到字符串 (文本文件的输入输出)。
        然后使用pickle.loads(str)的方法，将字符串转换成为对象。
        要记得，此时我们的程序中必须已经有了该对象的类定义。
        此外，我们也可以使用pickle.load()的方法，将上面步骤合并:
        
        import pickle
        
        # define the class before unpickle
        class Bird(object):
            have_feather = True
            way_of_reproduction  = 'egg'
        
        fn     = 'a.pkl'
        with open(fn, 'r') as f:
            summer = pickle.load(f)   # read file and build object
        
        
        cPickle包的功能和用法与pickle包几乎完全相同，不同在于cPickle是基于c语言编写的，速度是pickle包的1000倍。
        对于上面的例子，如果想使用cPickle包，我们都可以将import语句改为:
        
        import cPickle as pickle
        就不需要再做任何改动了。
        
9.Python标准库（中）
子进程 (subprocess包)
    subprocess包主要功能是执行外部的命令和程序，功能与shell类似。
    subprocess以及常用的封装函数
        在Python中，通过subprocess包来fork一个子进程，并运行一个外部的程序。
        subprocess.call() 父进程等待子进程完成，返回退出信息
        subprocess.check_call() 父进程等待子进程完成，返回0
        subprocess.check_output() 父进程等待子进程完成，返回子进程向标准输出的输出结果
    Popen()
        import subprocess
        child = subprocess.Popen(["ping","-c","5","www.google.com"])
        child.wait()
        print("parent process")
        
        还可以在父进程中对子进程进行其它操作
        child.poll() # 检查子进程状态
        child.kill() # 终止子进程
        child.send_signal() # 向子进程发送信号
        child.terminate() # 终止子进程
        子进程的PID存储在child.pid。
    子进程的文本流控制
        子进程的标准输入：child.stdin
        子进程的标准输出：child.stdout
        子进程的标准错误：child.stderr
        
        可以利用subprocess.PIPE将多个子进程的输入和输出连接在一起，构成管道(pipe)
        import subprocess
        child1 = subprocess.Popen(["ls","-l"], stdout=subprocess.PIPE)
        child2 = subprocess.Popen(["wc"], stdin=child1.stdout,stdout=subprocess.PIPE)
        out = child2.communicate()
        print(out)
信号 (signal包)
    定义信号名
        import signal
        print signal.SIGALRM
        print signal.SIGCONT
    预设信号处理函数
        singnal.signal(signalnum, handler)
        #signalnum为某个信号，handler为该信号的处理函数。
        signal.pause()
        #让该进程暂停以等待信号
    定时发出SIGALRM信号
        signal.alarm(5)
        #signal.alarm()在一定时间之后，向进程自身发送SIGALRM信号
    发送信号
        os.kill(pid, sid)
        os.killpg(pgid, sid)
        #向进程和进程组发送信号，sid为信号所对应的整数或者singal.SIG
多线程与同步 (threading包)
    threading.Thread对象：
        join()方法，调用该方法的线程将等待直到改Thread对象完成，再恢复运行。
        threading.Lock对象:
        mutex, 有acquire()和release()方法。
    -threading.Condition对象:
        condition variable，建立该对象时，会包含一个Lock对象。
        可以对Condition对象调用acquire()和release()方法，以控制潜在的Lock对象。
        wait()方法，相当于cond_wait()
        notify_all()，相当与cond_broadcast()
        nofify()，与notify_all()功能类似，但只唤醒一个等待的线程，而不是全部。
        threading.Semaphore对象:
        semaphore，也就是计数锁。
        创建对象的时候，可以传递一个整数作为计数上限 (sema = threading.Semaphore(5))。
        它与Lock类似，也有Lock的两个方法。
    threading.Event对象:
        与threading.Condition相类似，相当于没有潜在的Lock保护的condition variable。
        对象有True和False两个状态。
        可以多个线程使用wait()等待，直到某个线程调用该对象的set()方法，将对象设置为True。
        线程可以调用对象的clear()方法来重置对象为False状态。
进程信息 (部分os包)
    os包中相关函数：
        uname() 返回操作系统相关信息。类似于Linux上的uname命令。
        umask() 设置该进程创建文件时的权限mask。类似于Linux上的umask命令
        
    get() 查询 (由以下代替)
        uid, euid, resuid, gid, egid, resgid ：权限相关，其中resuid主要用来返回saved UID
        pid, pgid, ppid, sid                 ：进程相关
        
    put*() 设置 (*由以下代替)
        euid, egid： 用于更改euid，egid。
        uid, gid  ： 改变进程的uid, gid。只有super user才有权改变进程uid和gid (意味着要以$sudo python的方式运行Python)。
        pgid, sid ： 改变进程所在的进程组(process group)和会话(session)。
        
        getenviron()：获得进程的环境变量
        setenviron()：更改进程的环境变量
        
        例1，进程的real UID和real GID：
        
        import os
        print(os.getuid())
        print(os.getgid())
        
        saved UID和saved GID
        
    修改权限以设置set UID和set GID位
        $sudo chmod 6755 /usr/bin/python
        /usr/bin/python的权限成为:
        -rwsr-sr-x root root
多进程初步 (multiprocessing包)
    Queue(maxsize)创建，maxsize表示队列中可以存放对象的最大数量。- threading和multiprocessing
    Pipe
      Pipe可以是单向(half-duplex)，也可以是双向(duplex)。
      我们通过mutiprocessing.Pipe(duplex=False)创建单向管道 (默认为双向)。
      一个进程从PIPE一端输入对象，然后被PIPE另一端的进程接收，
      单向管道只允许管道一端的进程输入，而双向管道则允许从两端输入。
    Queue
      Queue与Pipe相类似，都是先进先出的结构。
      但Queue允许多个进程放入，多个进程从队列取出对象。
      Queue使用mutiprocessing.Queue(maxsize)创建，maxsize表示队列中可以存放对象的最大数量。
10.Python标准库（下）

    多进程探索 (multiprocessing包)
    数学与随机数 (math包，random包)
    循环器 (itertools)
    
数据库 (sqlite3)

    import sqlite3  # 导入SQLite驱动:
    
    # 连接到SQLite数据库
    # 数据库文件是test.db
    # 如果文件不存在，会自动在当前目录创建,如果有将报错
    conn = sqlite3.connect("test.db")
    cursor = conn.cursor()  # 创建一个Cursor,通过Cursor执行create insert select等sql语句
    cursor.execute("Create table user(domain VARCHAR(20), ip VARCHAR(20))")  # 执行一条SQL语句，创建user表
    cursor.execute("INSERT INTO user (domain, ip) VALUES ('1.cp4', '10.1.0.0')")  # 继续执行一条SQL语句，插入一条记录
    print("row count:", cursor.rowcount) # 通过rowcount获得插入的行数
    cursor.close()  # 关闭Cursor
    conn.commit()  # 提交事物
    conn.close()  # 关闭连接
    
    
    conn = sqlite3.connect("test.db") # 连接到SQLite数据库, 数据库文件是test.db
    cursor = conn.cursor()  # 创建一个Cursor,通过Cursor执行create insert select等sql语句
    cursor.execute("SELECT * FROM user WHERE domain=? ", ("1.cp4",))  # 执行一条SQL语句，查询结果
    value = cursor.fetchall()  # fetchall() 获得查询结果集
    print(value)
    cursor.close()
    conn.close()    