ipython notebook
iPython的安装，支持tab的自动补齐。安装命令sudo apt-get install ipython

?         -> ipython特性的介绍和概述
%quickref -> 一份手册，包含了所有的命令
object?   -> 关于object的详细信息，如果键入object??会更详细
help      -> python的帮助系统
 %lsmagic

b = [1，2，3]
    b.<tab> 查看b的方法(<tab = tab键>)
    b? 可以查看b的类型还有长度等一些信息
    b??  显示函数源代码 如果b是一段函数的话
    np.*load*? 列出模块包里面包含load的函数
    %run 01.py  直接运行python脚本
    运行完了python的脚本以后 可以直接运行里面调用出来的函数
    %cpaste
    直接黏贴代码查看

目录/书签
    %pwd: 显示当前工作目录。
    %cd: 切换工作目录。
    %bookmark: 工作目录书签。 (永久？) cd 和 bookmark 配合起来用，非常方便。
%bookmark test #为当前目录定义书签
%bookmark www /var/www #为其他目录定义书签
%bookmark -l # 显示书签列表
%bookmark -d text #删除书签
cd -b www #使用书签跳转，可省略 -b
 
%edit
    编辑器在ipython下使用得如此频繁，以至于ipython专门有一个%edit方法。
    不过默认效果估计会让您失望，因为没有指定的话，linux下默认会使用vi当作编辑器，windows下是notepad++（似乎？）。
    如果希望%edit打开自己喜爱的编辑器的话，需要在PATH中增加EDITOR项。

pwd
    如果您仔细看过前文，您会发现这个命令没有%，但是这个确实也是一个魔术方法，原因是，其实pwd这个命令只是一个链接，
    指向的是%pwd方法，%pwd指向系统的命令。当然这个命令含义很明显，就是打印当前路径。ipython把一些linux下常用
    的bash命令做了类似的处理，使用起来相当方便。我试了一下，大致有pwd,cd,whos,history,rm,ll,ls,mv,cp,alias,mkdir

%store
    默认的，别名只会存在于本次会话中，如果希望下次还能使用这个别名，使用%store方法存下来吧。%store latest
    另外，没保存也不要紧，%store -r会恢复上次会话的别名。

%hist
    ipython中history会保存所有会话中的记录，嘛，所以隔一年什么的记录就会相当多啦。
    虽然我知道你们都会用up，down来寻找历史记录……恩，试试ctrl+r，有惊喜。
    另外，类似于hist 3-7什么的，好像也不用我解释就是了。
    -g选项和grep类似，可以查找些东西出来，然后-n显示行号，-f保存历史记录到文件中去，-p把行号显示为n:>>>，-n把输入的结果显示出来（我猜没多少用这些个……


%run
    这是一个magic命令, 能把你的脚本里面的代码运行, 并且把对应的运行结果存入ipython的环境变量中:
    
    $cat t.py
    # coding=utf-8
    l = range(5)
    
    $ipython
    In [1]: %run t.py # `%`可加可不加
    
    In [2]: l # 这个l本来是t.py里面的变量, 这里直接可以使用了
    Out[2]: [0, 1, 2, 3, 4]

%alias
    In [3]: %alias largest ls -1sSh | grep %s
    In [4]: largest to
    total 42M
    20K tokenize.py
    16K tokenize.pyc
    8.0K story.html
    4.0K autopep8
    4.0K autopep8.bak
    4.0K story_layout.html
    
    PS 别名需要存储的, 否则重启ipython就不存在了:
    
    In [5]: %store largest
    Alias stored: largest (ls -1sSh | grep %s)
    
    下次进入的时候%store -r


字节码文件
    命令: python -m py_compile hello.py
    命令: python -O -m py_compile hello.py
        pyc文件（对比py源文件，提高程序的加载速度。运行效率是相同的，没有变化）
        pyo文件（是优化编译的pyc文件）
        
        