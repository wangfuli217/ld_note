pydoc name # name可以是关键字、主题、函数、模块或包名
           # 如果name中含有/则表示要显示的文档是一个特定的python文件的文档信息。
           # pydoc test/test.py
           # pydoc test.test
           
启动图形界面查找文档
    pydoc -g

纯文本帮助
    python -m pydoc atexit
    pydoc atexit
    
HTML帮助
    python -m pydoc -w atexit //在当前目录创建atexit.html 
    python -m pydoc -p 5000 //启动一个Web服务器监听http://localhost:5000/
    python -m pydoc open
    
    
    pydoc -w atexit
    pydoc -p 5000   # 很多很多
   
关键字搜索
    pydoc -k open
    
   
交互式帮助
    help()