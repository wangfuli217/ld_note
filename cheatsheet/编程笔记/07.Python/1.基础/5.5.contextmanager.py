模块简介
    with open("test/test.txt","w") as f_obj:
        f_obj.write("hello")

    f_obj = open("test/test.txt","w") 
    f_obj.write("hello") 
    f_obj.close()
    
模块使用 __enter__和__exit__
    import sqlite3
    
    class DataConn:
        def __init__(self,db_name):
            self.db_name = db_name
    
        def __enter__(self):
            self.conn = sqlite3.connect(self.db_name)
            return self.conn
    
        def __exit__(self,exc_type,exc_val,exc_tb):
            self.conn.close()
            if exc_val:
                raise
    
    if __name__ == "__main__":
        db = "test/test.db"
        with DataConn(db) as conn:
            cursor = conn.cursor()

利用contextlib创建一个上下文管理器
    from contextlib import contextmanager
    
    @contextmanager
    def file_open(path):
        try:
            f_obj = open(path,"w")
            yield f_obj
        except OSError:
            print("We had an error!")
        finally:
            print("Closing file")
            f_obj.close()
    
    if __name__ == "__main__":
        with file_open("test/test.txt") as fobj:
            fobj.write("Testing context managers")

    一旦with语句结束，控制就会返回给file_open函数，它继续执行yield语句后面的代码。这个最终会执行finally语句--
    关闭文件。如果我们在打开文件时遇到了OSError错误，它就会被捕获，最终finally语句依然会关闭文件句柄。
    
contextlib.closing(thing) 一旦代码块运行完毕，它就会将事件关闭。
    >>> from contextlib import contextmanager
    >>> @contextmanager
    ... def closing(db):
    ...     try:
    ...         yield db.conn()
    ...     finally:
    ...         db.close()
    
    可以在with语句中使用closing类本身，而非装饰器。让我们看如下的示例，
    >>> from contextlib import closing
    >>> from urllib.request import urlopen
    >>> with closing(urlopen("http://www.google.com")) as webpage:
    ...     for line in webpage:
    ...         pass
    在closing类中打开一个url网页。一旦我们运行完毕with语句，指向网页的句柄就会关闭。
    
    
contextlib.suppress(*exceptions) 上下文管理工具背后的理念就是它可以禁止任意数目的异常
    Python 3.4中加入的suppress类
    
    >>> with open("1.txt") as fobj:
    ...     for line in fobj:
    ...         print(line)
    ...
    Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    FileNotFoundError: [Errno 2] No such file or directory: '1.txt'
    
    这个上下文管理器没有处理这个异常，如果你想忽略这个错误，你可以按照如下方式来做，

    >>> from contextlib import suppress
    >>> with suppress(FileNotFoundError):
    ...     with open("1.txt") as fobj:
    ...         for line in fobj:
    ...             print(line)
    
    在这段代码中，我们引入suppress，然后将我们要忽略的异常传递给它，在这个例子中，就是FileNotFoundError。
    如果你想运行这段代码，你将会注意到，文件不存在时，什么事情都没有发生，也没有错误被抛出。请注意，这个上下文管理器是可重用的

contextlib.redirect_stdout/redirect_stderr
    contextlib模块还有一对用于重定向标准输出和标准错误输出的工具，分别在Python 3.4 和3.5 中加入
    import sys
    path = "test/test.txt"
    
    with open(path,"w") as fobj:
        sys.stdout = fobj
        help(sum)
    
    利用contextlib模块，你可以按照如下方式操作，
    
    from contextlib import redirect_stdout
    
    path = "test/test.txt"
    
    with open(path,"w") as fobj:
        with redirect_stdout(fobj):
            help(redirect_stdout)

ExitStack
    ExitStack是一个上下文管理器，允许你很容易地与其它上下文管理结合或者清除。这个咋听起来让人有些迷糊，我们来看一个Python官方文档的例子，或许会让我们更容易理解它。
    
    >>> from contextlib import ExitStack
    >>> filenames = ["1.txt","2.txt"]
    >>> with ExitStack as stack:
    ...     file_objects = [stack.enter_context(open(filename)) for filename in filenames]
    
    这段代码就是在列表中创建一系列的上下文管理器。ExitStack维护一个寄存器的栈。当我们退出with语句时，文件就会关闭，栈就会按照相反的顺序调用这些上下文管理器。
    
    Python官方文档中关于contextlib有很多示例，你可以学习到如下的技术点：
    
        从__enter__方法中捕获异常
        支持不定数目的上下文管理器
        替换掉try-finally
        其它
    