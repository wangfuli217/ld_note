

常用的 Python 调试工具

1.日志
    没错，就是日志。
    再多强调在你的应用里保留足量的日志的重要性也不为过。
    你应当对重要的内容打日志。如果你的日志打的足够好的话，单看日志你就能发现问题所在。那样可以节省你大量的时间。

    如果一直以来你都在代码里乱用 print 语句，马上停下来。换用logging.debug。以后你还可以继续复用，或是全部停用等等。


2.跟踪
    有时更好的办法是看执行了哪些语句。你可以使用一些IDE的调试器的单步执行，但你需要明确知道你在找那些语句，否则整个过程会进行地非常缓慢。
    标准库里面的 trace 模块，可以打印运行时包含在其中的模块里所有执行到的语句。(就像制作一份项目报告)
    参考: http://docs.python.org/2/library/trace.html#cmdoption-trace-t

        python -mtrace --trace script.py

    这会产生大量输出（执行到的每一行都会被打印出来，你可能想要用grep过滤那些你感兴趣的模块）.

        python -mtrace –trace script.py | egrep '^(mod1.py|mod2.py)'


3.调试器
    以下是如今应该人尽皆知的一个基础介绍：

        import pdb
        pdb.set_trace() # 开启pdb提示

    或者

        try:
        （一段抛出异常的代码）
        except:
            import pdb
            pdb.pm() # 或者 pdb.post_mortem()

    或者(输入 c 开始执行脚本)

        python -mpdb script.py

    在输入-计算-输出循环(注：REPL，READ-EVAL-PRINT-LOOP的缩写)环境下，可以有如下操作：

        c or continue
        q or quit
        l or list, 显示当前步帧的源码
        w or where,回溯调用过程
        d or down, 后退一步帧（注：相当于回滚）
        u or up, 前进一步帧
        (回车), 重复上一条指令

    其余的几乎全部指令（还有很少的其他一些命令除外）,在当前步帧上当作 python 代码进行解析。

    如果你觉得挑战性还不够的话，可以试下smiley，-它可以给你展示那些变量而且你能使用它来远程追踪程序。
    参考:https://github.com/dhellmann/smiley


4.更好的调试器
    pdb 的直接替代者：
    ipdb(easy_install ipdb) – 类似ipython(有自动完成，显示颜色等)
    pudb(easy_install pudb) – 基于curses（类似图形界面接口），特别适合浏览源代码



