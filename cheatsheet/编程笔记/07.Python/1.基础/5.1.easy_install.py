
easy_install
    这是个很常用的python安装工具
    可以直接安装ez_setup.py脚本(下载网址： http://peak.telecommunity.com/dist/ez_setup.py):
        python ez_setup.py


windows 下的使用：
    安装：
        下载: http://peak.telecommunity.com/dist/ez_setup.py
        执行: python ez_setup.py
    使用：
        easy_install.exe 模块名      # 安装模块,已有则不再安装
        python ez_setup.py 模块名    # 安装模块,已有则不再安装
        easy_install.exe -U 模块名   # 安装模块到最新版本,已有则检查版本,低于最新版则更新
        python ez_setup.py -U 模块名 # 安装模块到最新版本,已有则检查版本,低于最新版则更新

linux 下：
    安装：
        sudo apt-get install python-setuptools
    或者,下面两个安装命令逐个运行:
        yum -y install python-setuptools
        yum -y install python-devel
    或者:
       1）下载setuptools：
           wget https://pypi.python.org/packages/2.6/s/setuptools/setuptools-0.6c11-py2.6.egg
       2）安装setuptools
           sh setuptools-0.6c11-py2.6.egg
    或者：
        wget -q http://peak.telecommunity.com/dist/ez_setup.py
        sudo python ez_setup.py
    使用：
        sudo easy_install 模块名
        sudo easy_install -U 模块名
    测试 easy_install 命令:
        easy_install --help


安装完后，最好确保easy_install所在目录已经被加到PATH环境变量里:
        Windows: C:\Python25\Scripts
        Linux: /usr/local/bin


更新已安装模块的版本
    python ez_setup.py -U 模块名
    sudo easy_install -U 模块名


删除通过 easy_install 安装的软件包
    比如说：MySQL-python，可以执行命令：
        easy_install -m MySQL-python

    此操作会从easy-install.pth文件里把MySQL-python的相关信息抹去，剩下的egg文件，你可以手动删除。


不能使用easy_install的特殊情况：
    a、安装默认版本的MySQL-python会报错，需要指定版本如下：
        easy_install "MySQL-python==1.2.2"
        sudo easy_install "redis==2.7.1"

    b、有些包直接easy_install会失败，需要自行下载安装：
           wxpython，pil要下载exe安装程序
           robotide因为在pypi上找不到，要下载后再easy_install

    c、报“gcc”没安装错误,需要先安装 gcc, 然后再安装要装的模块
        gcc 报错： error: Setup script exited with error: command 'gcc' failed with exit status 1
        yum install gcc

    d、发现 easy_install 还是装不上，可能依赖的库还没装,改用 yum, 如安装“lxml”模块：
        yum install python-lxml


    通过easy_install安装软件，相关安装信息会保存到easy-install.pth文件里，路径类似如下形式：
    Windows：C:\Python25\Lib\site-packages\easy-install.pth
    Linux：/usr/local/lib/python25/site-packages/easy-install.pth


遇到被墙的麻烦
    解决方式一：
        软件源的下载方式被墙之后自动换成 https 的，而本地却没有 https 的下载模块，所以要先yum install一个 openssl。
        # Linux 下安装：
        1.yum install openssl-devel
        2.重新编译安装python
        3.easy_install 模块名

    解决方式二：
        下载来源设置成没有被墙的地址
        easy_install -i http://pypi.douban.com/simple/ 模块名

    方式三：
           只使用网址来easy_install安装
           easy_install http://example.com/path/to/MyPackage-1.2.3.tgz

    方式四：
            easy_install安装下载好的egg文件（egg文件是用setup tools打包的压缩文件）
            easy_install /my_downloads/OtherPackage-3.2.1-py2.3.egg

    方式五：
             升级包，有时候你需要更新包的版本
             easy_install --upgrade PyProtocols

    方式六：
            翻墙后下载安装包并解压，然后CD到解压包内运行以下命令即可
            easy_install .

