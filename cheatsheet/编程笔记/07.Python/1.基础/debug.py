日志
    print  -> logging.debug
跟踪
    python -m trace --trace script.py
    python -m trace --trace script.py | egrep '^(mod1.py|mod2.py)'
调试器
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
    
更好的调试器
    pdb的直接替代者：
    ipdb(easy_install ipdb) – 类似ipython(有自动完成，显示颜色等)
    pudb(easy_install pudb) – 基于curses（类似图形界面接口），特别适合浏览源代码