
sys模块(标准库模块)
    sys模块包含了与Python解释器和它的环境有关的函数。

    例:
    import sys  # 输入 sys模块。基本上，这句语句告诉Python，我们想要使用这个模块。
    print('The command line arguments are:')
    # 打印调用文件的命令行参数
    for i in sys.argv:
        print(i)

    print('\nThe PYTHONPATH is', sys.path)

    输出:
    $ python using_sys.py we are arguments
    The command line arguments are:
    using_sys.py
    we
    are
    arguments

    The PYTHONPATH is ['/home/swaroop/byte/code', '/usr/lib/python23.zip',
    '/usr/lib/python2.3', '/usr/lib/python2.3/plat-linux2',
    '/usr/lib/python2.3/lib-tk', '/usr/lib/python2.3/lib-dynload',
    '/usr/lib/python2.3/site-packages', '/usr/lib/python2.3/site-packages/gtk-2.0']

    注:
    执行 import sys 语句的时候，它在 sys.path 变量中所列目录中寻找 sys.py 模块。
    如果找到了这个文件，这个模块的主块中的语句将被运行，然后这个模块将能够被你使用。
    注意，初始化过程仅在我们 第一次 输入模块的时候进行。另外，“sys”是“system”的缩写。
    脚本的名称总是sys.argv列表的第一个参数。所以，在这里，'using_sys.py'是sys.argv[0]、'we'是sys.argv[1]。

    sys.path包含输入模块的目录名列表。
    可以观察到sys.path的第一个字符串是空的——这个空的字符串表示当前目录也是sys.path的一部分，这与PYTHONPATH环境变量是相同的。
    这意味着你可以直接输入位于当前目录的模块。否则，你得把你的模块放在sys.path所列的目录之一。

    另外:
    sys.exit() # 程序结束
    sys.stdin、 sys.stdout 和 sys.stderr 分别对应你的程序的标准输入、标准输出和标准错误流。


导入上一层的模块
    import sys
    sys.path.append("..")
    sys.path.append("../..") # 导入上上一层

    # 写在模块下的 __init__.py 文件里则整个模块都生效


解决文件编码问题
    import sys
    reload(sys)
    sys.setdefaultencoding("utf-8")

