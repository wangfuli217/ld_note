    pip的意思是破蛋而出，继承了python的思维，呵呵～python的包有以egg命名的，意思是蛇蛋，
如此便自然而然的明白如此命名的原因。
pip用来安装和管理python包的命令，可以代替easy_install。

pip用法
安装python包
  $ pip install simplejson  
  [... progress report ...]  
  Successfully installed simplejson  
升级包
  $ pip install --upgrade simplejson  
  [... progress report ...]  
  Successfully installed simplejson  
删除包
  $ pip uninstall simplejson  
  Uninstalling simplejson:  
    /home/me/env/lib/python2.7/site-packages/simplejson  
    /home/me/env/lib/python2.7/site-packages/simplejson-2.2.1-py2.7.egg-info  
  Proceed (y/n)? y  
    Successfully uninstalled simplejson  
从指定文件中安装指定的包、模块
  pip install -r requirements.txt  
      
  requirements.txt中的格式是：     
  django-coverage==1.2.2  
  django-permissions==1.0.3  
  django==1.3.1  
  MySQL-python==1.2.3  
  South==0.7.5
  
----------------------------------------------------------------------
一、方法1： 单文件模块
直接把文件拷贝到 $python_dir/Lib

二、方法2： 多文件模块，带setup.py
下载模块包，进行解压，进入模块文件夹，执行：
    python setup.py install

三、 方法3：easy_install 方式
先下载ez_setup.py,运行python ez_setup 进行easy_install工具的安装，之后就可以使用easy_install进行安装package了。
    easy_install  packageName
    easy_install  package.egg

四、 方法4：pip 方式
先进行pip工具的安裝：easy_install pip（pip 可以通过easy_install 安裝，而且也会装到 Scripts 文件夹下。）
    安裝：pip install PackageName
    更新：pip install -U PackageName
    移除：pip uninstall PackageName
    搜索：pip search PackageName
    帮助：pip help

注：虽然Python的模块可以拷贝安装，但是一般情况下推荐制作一个安装包，即写一个setup.py文件来安装。setup.py文件的使用如下:
    % python setup.py build     #编译
    % python setup.py install    #安装
    % python setup.py sdist      #制作分发包
    % python setup.py bdist_wininst    #制作windows下的分发包
    % python setup.py bdist_rpm

setup.py文件的编写
setup.py中主要执行一个 setup函数，该函数中大部分是描述性东西，最主要的是packages参数，列出所有的package，可以用自带的find_packages来动态获取package。所以setup.py文件的编写实际是很简单的。
setup.py示例文件：
    from setuptools import setup, find_packages
    setup(
           name = " mytest " ,
           version = " 0.10 " ,
           description = " My test module " ,
           author = " Robin Hood " ,
           url = " http://www.csdn.net " ,
           license = " LGPL " ,
           packages = find_packages(),
           scripts = [ " scripts/test.py " ],
           )
    mytest.py
    import sys
    def get():
         return sys.path
    scripts/test.py
    import os
    print os.environ.keys() 

setup中的scripts表示将该文件放到 Python的Scripts目录下，可以直接用。OK，简单的安装成功，可以运行所列举的命令生成安装包，或者安装该python包。

# pip使用国内源
pip install mitmproxy -i http://pypi.mirrors.ustc.edu.cn/simple --trusted-host pypi.mirrors.ustc.edu.cn
全局，~/.pip/pip.conf添加：
[global]
timeout = 6000
index-url = http://pypi.douban.com/simple/ 
[install]
use-mirrors = true
mirrors = http://pypi.douban.com/simple/
trusted-host = pypi.douban.com
阿里源：
http://mirrors.aliyun.com/pypi/simple/

virtualenv的使用举例
    # 安装virtualenv
    sudo pip install virtualenv
    # 为虚拟环境创建目录
    mkdir /PATH/TO/YOUR/VIRTUAL_ENV
    cd /PATH/TO/YOUR/VIRTUAL_ENV
    # 创建一个虚拟环境，不使用系统的site-packages中的模块
    virtualenv --no-site-packages ENV_NAME
    # 激活虚拟环境，注意激活后命令行的提示符变化
    source /PATH/TO/YOUR/VIRTUAL_ENV/ENV_NAME/bin/active
    # 在虚拟环境安装需要的模块
    pip install MODULE_NAME
    # 进行一些操作
    # ...
    # 退出虚拟环境
    deactivate


pip有一个子命令pip freeze，可以查看当前环境中包的清单，比如：
    Django==1.3
    distribute==0.6.14
    wsgiref==0.1.2
    yolk==0.4.1
我们可以将该内容重定向到一个文本文件：pip freeze > req.txt,
然后在另一个环境中按照该文件中的内容安装需要的包：pip install -r req.txt。
