
os 模块
    这个模块包含普遍的操作系统功能。如果你希望你的程序能够与平台无关的话，这个模块是尤为重要的。
    os.sep  获取操作系统特定的路径分割符。比如在Linux、Unix下它是'/'，在Windows下它是'\\'，而在Mac OS下它是':'。
    os.name 字符串指示你正在使用的平台。比如对于Windows，它是'nt'，而对于Linux/Unix用户，它是'posix'。
    os.getcwd() 函数得到当前工作目录，即当前Python脚本工作的目录路径。
    os.getenv(key) 函数用来读取环境变量。
    os.putenv(key, value) 函数用来设置环境变量。
    os.listdir(path) 返回指定目录下的所有文件和目录名。
    os.remove(filePath) 函数用来删除一个文件。
    os.system(shellStr) 函数用来运行shell命令，windows平台则是运行批处理命令。
    os.linesep  字符串给出当前平台使用的行终止符。例如，Windows使用'\r\n'，Linux使用'\n'而Mac使用'\r'。
    os.path.split(pathname)  函数返回一个路径的目录名和文件名。
    os.path.isfile(path) 函数检验给出的路径是否一个文件。
    os.path.isdir(path)  函数分别检验给出的路径是否目录。
    os.path.existe(path) 函数用来检验给出的路径是否真地存在。

    os.chdir(os.path.join("c:","My Documents", "images")) 
    filename = os.path.join("c:", "My Documents", "test", "myfile")
    
文件操作
  一、在pythony 3.0 已经废弃了 file 类。
  help(os.open) # open(filename, flag [, mode=0777]) -> fd
  二、pythony 3.0 内置 open() 函数的构造函数是:
    open(file, mode="r", buffering=None, encoding=None, errors=None, newline=None, closefd=True)
    1.mode(模式):
      r: 读，只能读文件，如果文件不存在，会发生异常
      w: 写，只能写文件，如果文件不存在，创建该文件；如果文件已存在，先清空，再打开文件
      a: 打开供追加
      b: 二进制模式；一般是组合写法,如: rb 以二进制读方式打开；wb 以二进制写方式打开
      t: 文本模式
      +: 打开一个磁盘文件供更新,一般是组合使用,如:
         rb+: 以二进制读方式打开，可以读、写文件，如果文件不存在，会发生异常
         wb+: 以二进制写方式打开，可以读、写文件，如果文件不存在，创建该文件；
              如果文件已存在，先清空，再打开文件
      u: 通用换行模式
      默认的模式是 rt，即打开供读取的文本模式。
    2.buffering 关键字参数的期望值是以下三个整数中的一个以决定缓冲策略：
      0: 关闭缓冲
      1: 行缓冲
      > 1: 所填的 int 数=缓冲区大小
      默认: 完全缓冲
    3.encoding 默认的编码方式独立于平台。
    4.关闭文件描述符 closefd 可以是 True 或 False 。
      如果是 False,此文件描述符会在文件关闭后保留。若文件名无法奏效的话，那么必须设为 True 。

      outfile=open(r'C:\filename','r')     读打开
      outfile=open(r'C:\filename','rb')    二进制读打开
      outfile=open(r'C:\filename','rb+',0) 二进制写打开，无缓存
      outfile=open(r'C:\filename','r+',0)
      读写文本文件时，默认的编码是utf-8，你也可以使用指定的编码：open(r'filename',encoding='latin-1')
      
    sys模块中有几个预先打开的文件对象：
    sys.stdout对象：标准输出对象
    sys.stdin对象：标准输入对象
    sys.stderr对象：标准错误输出对象
    stdin/stdout/stderr对象
    
    socket、pipe、FIFO文件对象可以用于网络通信与进行同步
    读写文本文件时，默认的编码是utf-8，你也可以使用指定的编码：open(r'filename',encoding='latin-1')
    文件的空行是含有换行符的字符串，而不是空字符串。因此如果读入操作返回空字符串，则表示已经到文件末尾了。
    
  三、清空文件内容
    f.truncate()
    注意：当以 "r+","rb+","w","wb","wb+"等模式时可以执行该功能，即具有可写模式时才可以。

  四、文件的指针定位与查询
    (1)文件指针：
         文件被打开后，其对象保存在 f 中， 它会记住文件的当前位置,以便于执行读、写操作，
         这个位置称为文件的指针( 一个从文件头部开始计算的字节数 long 类型 )。
    (2)文件打开时的位置:
         以"r","r+","rb+" 读方式, "w","w+","wb+"写方式 打开的文件，
         一开始，文件指针均指向文件的头部。
    (3)获取文件指针的值:
         L = f.tell()
    (4)移动文件的指针
         f.seek(偏移量, 选项) # 偏移量 是 long 或者 int 类型，计算偏移量时注意换行符是2,汉字可能是2或3
         选项 =0 时， 表示将文件指针指向从文件头部到 "偏移量"字节处。
         选项 =1 时， 表示将文件指针指向从文件的当前位置，向后移动 "偏移量"字节。
         选项 =2 时， 表示将文件指针指向从文件的尾部，，向前移动 "偏移量"字节。

  五、从文件读取指内容
    1.文本文件(以"rt"方式打开的文件)的读取
      s = f.readline()
      返回值： s 是字符串，从文件中读取的一行，含行结束符。
      说明: (1)如果 len(s) = 0 表示已到文件尾(换行符也是有长度的,长度为2)
            (2)如果是文件的最后一行，有可能没有行结束符
    2.二进制文件(以"rb"、"rb+"、"wb+" 方式打开的文件)的读取
      s = f.read(n)
      说明: (1)如果 len( s ) =0 表示已到文件尾
            (2)文件读取后，文件的指针向后移动 len(s) 字节。
            (3)如果磁道已坏，会发生异常。

    .read()：读取整个文件，作为一个字符串返回           # read([size]) 
    .read(n)：读取接下来的n个字节，作为一个字符串返回   # read([size]) 
    .readline()：读取下一行到一个字符串（包括行末的换行符） # readline([size])
    .readlines()：按行读取接下来的整个文件到字符串列表，每个字符串一行
    .xreadlines():返回一个生成器，来循环操作文件的每一行。循环使用时和readlines基本一样，但是直接打印就不同
    for line in open('data'):#每次循环迭代时，自动读取并返回一行
  六、向文件写入一个字符串
      f.write( s )
      参数: s 要写入的字符串
      说明: (1)文件写入后，文件的指针向后移动 len(s) 字节。
            (2)如果磁道已坏，或磁盘已满会发生异常。

        .write(str)：写入字符串到文件（并不会自动添加换行符以及其他任何字符，str是啥就写啥）， 返回写入的字符数
        .writelines(strlist)：将字符串列表内所有字符串依次写入文件（并不会自动添加换行符以及其他任何字符）
  七、常用文件操作参考
      [1.os]
        1.重命名：os.rename(old, new)
        2.删除：os.remove(file)
        3.列出目录下的文件：os.listdir(path)
        4.获取当前工作目录：os.getcwd()
        5.改变工作目录：os.chdir(newdir)
        6.创建多级目录：os.makedirs(r"c:\python\test")
        7.创建单个目录：os.mkdir("test")
        8.删除多个目录：os.removedirs(r"c:\python") #删除所给路径最后一个目录下所有空目录。
        9.删除单个目录：os.rmdir("test")
        10.获取文件属性：os.stat(file)
        11.修改文件权限与时间戳：os.chmod(file)
        12.执行操作系统命令：os.system("dir")
        13.启动新进程：os.exec(), os.execvp()
        14.在后台执行程序：osspawnv()
        15.终止当前进程：os.exit(), os._exit()
        16.分离文件名：os.path.split(r"c:\python\hello.py") --> ("c:\\python", "hello.py")
        17.分离扩展名：os.path.splitext(r"c:\python\hello.py") --> ("c:\\python\\hello", ".py")
        18.获取路径名：os.path.dirname(r"c:\python\hello.py") --> "c:\\python"
        19.获取文件名：os.path.basename(r"r:\python\hello.py") --> "hello.py"
        20.判断文件是否存在：os.path.exists(r"c:\python\hello.py") --> True
        21.判断是否是绝对路径：os.path.isabs(r".\python\") --> False
        22.判断是否是目录：os.path.isdir(r"c:\python") --> True
        23.判断是否是文件：os.path.isfile(r"c:\python\hello.py") --> True
        24.判断是否是链接文件：os.path.islink(r"c:\python\hello.py") --> False
        25.获取文件大小：os.path.getsize(filename)
        26.*******：os.ismount("c:\\") --> True
        27.搜索目录下的所有文件：os.path.walk()
        28.文件的访问时间 :  os.path.getatime(myfile) # 这里的时间以秒为单位，并且从1970年1月1日开始算起
        29.文件的修改时间:  os.path.getmtime(myfile)

      [2.shutil]
        1.复制单个文件：shultil.copy(oldfile, newfle) # newfile可以为目录
        # copy2()函数类似于copy()函数, 但还包括拷贝修改和访问时间 
        # copymode()函数会拷贝源文件的访问权限到目标文件 
        # copystat()函数会拷贝源文件的元信息到目标文件
        2.复制整个目录树：shultil.copytree(r".\setup", r".\backup")
        3.删除整个目录树：shultil.rmtree(r".\backup")
        4.复制单个文件：shutil.copyfile('shutil_copyfile.py', 'shutil_copyfile.py.copy')
        5.移动文件或目录：shutil.move()
        
      [3.tempfile]
        1.创建一个唯一的临时文件：tempfile.mktemp() --> filename
        2.打开临时文件：tempfile.TemporaryFile()

      [4.StringIO] #cStringIO是StringIO模块的快速实现模块
        1.创建内存文件并写入初始数据：f = StringIO.StringIO("Hello world!")
        2.读入内存文件数据： print f.read() #或print f.getvalue() --> Hello world!
        3.想内存文件写入数据：f.write("Good day!")
        4.关闭内存文件：f.close()

      [5.glob]
        1.匹配文件：glob.glob(r"c:\python\*.py")

3.文件上下文管理器：通过try/finally语句或者with/as语句来确保文件在退出后可以自动关闭。
（一般情况下python的垃圾收集功能会在对象没有引用的时候自动回收，即会自动关闭文件，但不确定时间，
通过上面两种语句可以控制文件的关闭。）

4. 启动一个程序，代替当前的进程，不会返回
os.execl(path, arg0, arg1, ...)
os.execle(path, arg0, arg1, ..., env)
os.execlp(file, arg0, arg1, ...)
os.execlpe(file, arg0, arg1, ..., env)
os.execv(path, args)
os.execve(path, args, env)
os.execvp(file, args)
os.execvpe(file, args, env)
通用参数说明
带l的，参数是逐个传进去，带v的，参数作为一个数组传进去。
带e的，env是一个map，表示新进程的环境变量。如果不带e，会使用当前进程的环境变量。
带p的，会在环境变量PATH中查找file的全路径。对于pe，会在新的环境变量下进行查找。
出错时会抛出OSError，有errno，strerror等属性，对于chdir()、unlink()等带文件参数的调用，还会有filename属性


启动一个子进程
# 启动新进程
启动一个程序，代替当前的进程，不会返回
    os.execl(path, arg0, arg1, ...)
    os.execle(path, arg0, arg1, ..., env)
    os.execlp(file, arg0, arg1, ...)
    os.execlpe(file, arg0, arg1, ..., env)
    os.execv(path, args)
    os.execve(path, args, env)
    os.execvp(file, args)
    os.execvpe(file, args, env)

启动一个子进程
    os.spawnl(mode, path, ...)
    os.spawnle(mode, path, ..., env)
    os.spawnlp(mode, file, ...)
    os.spawnlpe(mode, file, ..., env)
    os.spawnv(mode, path, args)
    os.spawnve(mode, path, args, env)
    os.spawnvp(mode, file, args)
    os.spawnvpe(mode, file, args, env)

    mode可以是P_NOWAIT/P_WAIT，如果是前者，函数会返回新进程的pid，后者会返回子进程的返回值或-signal，表示收到的signal。
通用参数说明
    带l的，参数是逐个传进去，带v的，参数作为一个数组传进去。
    带e的，env是一个map，表示新进程的环境变量。如果不带e，会使用当前进程的环境变量。
    带p的，会在环境变量PATH中查找file的全路径。对于pe，会在新的环境变量下进行查找。
    出错时会抛出OSError，有errno，strerror等属性，对于chdir()、unlink()等带文件参数的调用，还会有filename属性

########### 示例1 运行系统命令行 #################################
    import os
    os_command = 'echo haha...'
    # 运行命令行,返回运行结果(成功时返回0,失败返回1或以上的出错数字)
    result = os.system(os_command)
    if result == 0:
        print('run Successful')
    else:
        print('run FAILED')
    # 注:os.system()函数不推荐使用,它容易引发严重的错误。(可能是因为不具备可移植性)

    #os.system(os_command) # 这命令会弹出一个黑乎乎的cmd运行窗口,而且无法获得输出
    p = os.popen(os_command) # 捕获运行的屏幕输出，以文件类型接收，不再另外弹出窗口
    print(p.read()) # p 是个文件类型，可按文件的操作


########### 杀掉进程(windows) ###########
    def kill(pid):
        """ kill process by pid for windows """
        kill_command = "taskkill /F /T /pid %s" % pid
        os.system(kill_command)


########### 进程监视(windows) ###########

    # 定期监视某进程是否存在，不存在则执行
    import os,time

    def __Is_Process_Running(imagename):
        '''
           功能：检查进程是否存在
           返回：返回有多少个这进程名的程序在运行，返回0则程序不在运行
        '''
        p = os.popen('tasklist /FI "IMAGENAME eq %s"' % imagename) # 利用 windows 批处理的 tasklist 命令
        return p.read().count(imagename) # p 是个文件类型，可按文件的操作

    def test():
        '''
           功能：定期地监视测进程是否还在运行，不再运行时执行指定代码
        '''
        while True:
            time.sleep(10)
            pid = __Is_Process_Running('barfoo.exe')
            if pid <= 0:
                # code .....
                break

    if __name__ == "__main__":
        test()


########### 程序退出时执行 ###########
    import os

    # 运行另外一个进程
    proxy_server = os.popen('cmd.exe /c start "" barfoo_proxy.exe')
    # 等待这个进程结束(其实是读取程序的输出，但程序如果一直不停止的话，就一直阻塞)，再往下执行
    proxy_server.read()

    # 前面的程序结束后，才继续执行下面的代码
    test_file = open('test.txt', 'wb')
    test_file.write('hello')
    test_file.close()


########### 示例2 创建目录 #################################
    import os
    pathDir = r'D:\Work' # 不同系统的目录写法有所不同
    if not os.path.exists(pathDir):
        os.mkdir(pathDir) # 创建目录, os.makedirs(pathDir) 创建多个不存在的目录
    target = pathDir + os.sep + 'test.txt'
    print(target)
    # 注意os.sep变量的用法, os.sep 是目录分隔符,这样写方便移植。即在Linux、Unix下它是'/'，在Windows下它是'\\'，而在Mac OS下它是':'。



########### 示例3 文件操作(遍历目录和文件名) ########################
    import os
    import os.path
    rootdir = r"D:\Holemar\1.notes\28.Python\test"
    # os.walk 返回一个三元组，其中parent表示所在目录, dirnames是所有目录名字的列表, filenames是所有文件名字的列表
    for parent,dirnames,filenames in os.walk(rootdir):
        # 所在目录
        print("parent is:" + parent)
        # 遍历此目录下的所有目录(不包含子目录)
        for dirname in dirnames:
           print(" dirname is:" + dirname)
        # 遍历此目录下的所有文件
        for filename in filenames:
           print(" filename with full path:" + os.path.join(parent, filename))

    # 列表显示出某目录下的所有文件及目录(不包括子目录的内容)
    ls = os.listdir(rootdir)


########### 示例4 文件操作(分割路径和文件名) #################################
    import os.path
    #常用函数有三种：分隔路径，找出文件名，找出盘符(window系统)，找出文件的扩展名。
    spath = "d:/test/test.7z"

    # 下面三个分割都返回二元组
    # 分隔目录和文件名
    p,f = os.path.split(spath)  # 注意二元组的接收
    print("dir is:" + p)    # 打印: d:/test
    print(" file is:" + f)  # 打印: test.7z

    # 分隔盘符和文件名
    drv,left = os.path.splitdrive(spath)
    print(" driver is:" + drv)   # 打印: d:
    print(" left is:" + left)    # 打印: /test/test.7z

    # 分隔文件和扩展名
    f,ext = os.path.splitext(spath)
    print(" f is: " + f)    # 打印: d:/test/test
    print(" ext is:" + ext) # 打印: 7z


########### 示例4 文件操作(读写txt文件) #################################
    filePath = 'poem.txt'
    f = open(filePath, 'w') # 以写的模式打开文件,Python 2.x 需将 open() / io.open() 改成 file()
    for a in range( 0, 10 ):
        s = "%5d %5d\n" % (a, a*a)
        f.write( s ) # 把文本写入文件
    f.close() # 关闭io流

    f2 = open(filePath) # 没有提供模式，则默认是读取,即 'r'
    while True:
        line = f2.readline()
        if len(line) == 0: # 读取结束
            break
        print(line, end='') # 避免print自动换行, 此行Python2.x应该写：“print line,”
    f2.close() # close the file

    # 删除文件
    import os
    os.remove(filePath)


########### 示例5 文件操作(获取文件修改时间) #################################
    import os,os.path,time
    timestamp = os.path.getmtime(__file__) # 获取本文件
    time_tuple = time.localtime(timestamp)
    print time.strftime('%Y-%m-%d %H:%M:%S', time_tuple) # 2008-11-12 21:59:27
    # 下面简化成一行代码
    print time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(os.path.getmtime(__file__))) # 2008-11-12 21:59:27
