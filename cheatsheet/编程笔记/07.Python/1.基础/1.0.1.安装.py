
注:本笔记基于python2.6而编辑,尽量的兼顾3.x的语法


Python的特色
  1.是一种动态解释型的编程语言
  2.规范的代码: Python 采用强制缩进的方式使得代码具有极佳的可读性。
  3.免费、开源
  4.高层语言: 封装内存管理等
  5.可移植性: 程序如果避免使用依赖于系统的特性，那么无需修改就可以在任何平台上运行
  6.解释性: 直接从源代码运行程序,不再需要担心如何编译程序,使得程序更加易于移植。
  7.面向对象: 支持面向过程的编程也支持面向对象的编程。
  8.可扩展性: 需要保密或者高效的代码，可以用C或C++编写，然后在Python程序中使用它们。
  9.可嵌入性: 可以把Python嵌入C/C++程序，从而向你的程序用户提供脚本功能。
  10.丰富的库: 包括正则表达式、文档生成、单元测试、线程、数据库、网页浏览器、CGI、FTP、
     电子邮件、XML、XML-RPC、HTML、WAV文件、密码系统、GUI(图形用户界面)、Tk和其他与系统有关的操作。
     除了标准库以外，还有许多其他高质量的库，如wxPython、Twisted和Python图像库等等。
  11.概括: Python确实是一种十分精彩又强大的语言。它合理地结合了高性能与使得编写程序简单有趣的特色。
  12.Python使用C语言开发，但是Python不再有C语言中的指针等复杂的数据类型。
  13.ython具有很强的面向对象特性，而且简化了面向对象的实现。它消除了保护类型、抽象类、接口等面向对象的元素。
  14.Python仅有31个保留字，而且没有分号、大括号、begin、end等标记。


Python 下载地址
    http://www.python.org/download/


Python 安装：
    windows时，运行安装文件之后，还需要配置环境变量，在环境变量的“Path”后面加上英文的分号及python安装目录
    如：“;C:\promg\python2.6”
    不配置环境变量的话，没法在命令行直接使用python


有两种使用Python运行你的程序的方式
   1.使用交互式的带提示符的解释器
     直接双击运行“python.exe”，在里面输入内容，如： print 'haha...'
   2.使用源文件
     在Python的安装目录下，建一个批处理(test.bat)，写入：
     @echo off
     python.exe test.py
     pause

     而“test.py”里面的内容是需要执行的程序


Python命令行选项
    选项      作用
    -c cmd   在命令行直接执行python代码。如python -c print "hello world"。
    -d       脚本编译后从解释器产生调试信息。同PYTHONDEBUG=1。
    -E       忽略环境变量。
    -h       显示python命令行选项帮助信息。
    -i       脚本执行后马上进入交互命令行模式。同PYTHONINSPECT=1。
    -O       在执行前对解释器产生的字节码进行优化。同 PYTHONOPTIMIZE=1。
    -OO      在执行前对解释器产生的字节码进行优化，并删除优化代码中的嵌入式文档字符串。
    -Q arg   除法规则选项，-Qold(default)，-Qwarn，-Qwarnall，-Qnew。
    -S       解释器不自动导入site.py模块。
    -t       当脚本的tab缩排格式不一致时产生警告。
    -u       不缓冲stdin、stdout和stderr，默认是缓冲的。同PYTHONUNBUFFERED=1。
    -v       产生每个模块的信息。如果两个-v选项，则产生更详细的信息。同PYTHONVERBOSE=x。
    -V       显示Python的版本信息。
    -W arg   出错信息控制。(arg is action:message:category:module:lineno)
    -x       忽略源文件的首行。要在多平台上执行脚本时有用。
    file     执行file里的代码。
    -        从stdin里读取执行代码。


一句话命令
    python -m SimpleHTTPServer [port]  # 当前目录开启一个小的文件服务器, 默认端口8000
    # 另外，python 3,中是 python -m http.server
    python -m this               # python's Zen
    python -m calendar           # 显示一个日历
    echo '{"json":"obj"}' | python -mjson.tool  # 漂亮地格式化打印json数据
    echo '{"json":"obj"}' | python -mjson.tool | pygmentize -l json # 高亮地打印json格式化
    python -m antigravity       # 这个该自己试试
    python -m smtpd -n -c DebuggingServer localhost:20025  # mail server
    python -c "import tornado"  # 这句话用来探测是否能运行成功


环境变量
    1. python 安装之后，默认 windows 下不能直接使用 python 命令。需要配置环境变量。
       假设python的安装路径为c:\python2.6，则修改我的电脑->属性->高级->环境变量->系统变量中的PATH为:
       (为了在命令行模式下运行Python命令，需要将python.exe所在的目录附加到PATH这个环境变量中。)

        PATH=PATH;c:\python26

       上述环境变量设置成功之后，就可以在命令行直接使用python命令。或执行"python *.py"运行python脚本了。


    2.此时，还是只能通过"python *.py"运行python脚本，若希望直接运行*.py，只需再修改另一个环境变量PATHEXT:

        PATHEXT=PATHEXT;.PY;.PYM


第三方库的导入
    如何使Python解释器能直接import默认安装路径以外的第三方模块？
    为了能 import 默认安装路径以外的第三方的模块（如自己写的模块, 或者遇到第三方库版本冲突时）
    系统环境是一个list，可以将自己需要的库添加进入，例如mysql库，hive库等等。有三种方式添加，均验证通过：


    1.代码中添加:
        import sys
        sys.path
        sys.path.append(path)
        #sys.path.insert(1, './libs') # 这写法会让这库的优先级更高

        这写法只让这运行的代码内存中生效，不影响其它程序。

    2. 使用pth文件永久添加
        使用pth文件，在 site-packages 文件中创建 .pth 文件，将模块的路径写进去，一行一个路径，以下是一个示例，pth文件也可以使用注释：

            # .pth file for the  my project(这行是注释)
            E:\DjangoWord
            E:\DjangoWord\mysite
            E:\DjangoWord\mysite\polls

        这个不失为一个好的方法，但存在管理上的问题，而且不能在不同的python版本中共享,还会影响所有运行中的python程序。

    3.使用 PYTHONPATH 环境变量
        使用 PYTHONPATH 环境变量，在这个环境变量中输入相关的路径，不同的路径之间用逗号（英文的！)分开，如果 PYTHONPATH 变量还不存在，可以创建它！
        路径会自动加入到 sys.path 中，而且可以在不同的python版本中共享，应该是一样较为方便的方法

        linux 设置方法:
            命令行  export PYTHONPATH=/usr/lib/python2.5/site-packages/  本次对话生效

            vi ~/.bash_profile
            在最后添加 export PYTHONPATH=/usr/lib/python2.5/site-packages/
            重新登陆即可生效, 只对登陆用户生效

            vi /etc/profile
            在最后添加 export PYTHONPATH=/usr/lib/python2.5/site-packages/
            重新登陆即可生效, 对所有用户有效


        windows 设置方法:
            命令行  SET "PYTHONPATH=D:\Python26\Lib\site-packages"  本次对话生效

            “环境变量”，新建一个名为“PYTHONPATH”的变量，指向自己指定的目录即可整个电脑生效。


文件类型
    1 Python的文件类型分为3种，即源代码、字节代码和优化代码。这些都可以直接运行，不需要进行编译或连接。
    2 源代码以“.py”为扩展名，由python来负责解释；
    3 源文件经过编译后生成扩展名为“.pyc”的文件，即编译过的字节文件。
      这种文件不能使用文本编辑器修改。pyc文件是和平台无关的，可以在大部分操作系统上运行。

      如下语句可以用来产生pyc文件：
        import py_compile
        py_compile.compile('hello.py')

    4 经过优化的源文件会以“.pyo”为后缀，即优化代码。
      它也不能直接用文本编辑器修改，如下命令可用来生成pyo文件：
        python -O -m py_complie hello.py


字节编译的 .pyc 文件
    输入一个模块相对来说是一个比较费时的事情，所以Python做了一些技巧，以便使输入模块更加快一些。
    一种方法是创建 字节编译的文件，这些文件以 .pyc 作为扩展名。另外，这些字节编译的文件也是与平台无关的。
    当你在下次从别的程序输入这个模块的时候，.pyc 文件是十分有用的——它会快得多，因为一部分输入模块所需的处理已经完成了。
    注意：虽说 python 是源码公开的，但服务器上可以只保留 .pyc 文件，而不保留源码，照样正常运行。这样可以保证源码不被看到。
    pyc的内容，是跟python的版本相关的，不同版本编译后的pyc文件是不同的，2.5编译的pyc文件，2.4版本的 python是无法执行的。
    根据python源码中提供的opcode，可以根据pyc文件反编译出 py文件源码,2.6之后源码不提供反编译,不过可以另外设法做到。

    将 py 文件生成 pyc 文件：
    1.直接通过命令来运行,可以看到下面的命令中并没有用到 compile() 函数, 这是因为 py_compile 模块的 main() 函数中调用了 compile() .

        python -m py_compile test.py
        python -O -m py_compile test.py

        -O 优化成字节码
        -m 表示把后面的模块当成脚本运行
        -OO 表示优化的同时删除文档字符串

        如果想看 compile(), compile_dir(), compile_path() 具体每个参数用途，
        可以使用 print py_compile.compile().__doc__ 来查看，或者直接打开 py_compile.py，compileall.py 文件来看。

    2.通过写python代码来编译.py文件,然后运行这个python脚本即可，运行过程中输入你要编译的.py文件。

        import py_compile
        file=raw_input("Please enter filename: ")
        py_compile.compile(file)

    3.如果是在Linux环境下，可以通过写一个bash脚本编译.py。

        #! /bin/sh
        (echo 'import compileall'; echo 'compileall.compile_dir("./")') | python

        完成上述代码后用bash命令运行即可。

    4.禁止 python 在运行的时候自动生成 .pyc 文件
      python2.6 新增了一个特性，只要把环境变量 PYTHONDONTWRITEBYTECODE 设置为 x，就不再会生成 .pyc 文件了。

