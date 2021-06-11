
本笔记以 Python2.6, Django-1.2.5 为开发基础

Django 优点
    在 python 的 web 框架中, 目前算最大的一个。
    1.拥有完美的文档, Django 的成功, 我觉得很大一部分原因要归功于 Django 近乎完美的官方文档(包括Django book)。
    2.全套的解决方案,(比如：cache、session、feed、orm、geo、auth), 而且全部Django自己造, 开发网站应手的工具Django基本都给你做好了,
      因此开发效率是不用说的, 出了问题也算好找, 不在你的代码里就在Django的源码里。
    3.强大的URL路由配置, Django让你可以设计出非常优雅的URL, 在Django里你基本可以跟丑陋的GET参数说拜拜。(其它web框架也有这功能)
    4.自助管理后台, admin interface 是Django里比较吸引眼球的一项contrib, 让你几乎不用写一行代码就拥有一个完整的后台管理界面。

Django 缺点
    Django 的缺点主要源自 Django 坚持自己造所有的轮子, 整个系统相对封闭
    1.系统紧耦合, 如果你觉得 Django 内置的某项功能不是很好, 想用喜欢的第三方库来代替是很难的, 比如ORM、Template。
    2.Django自带的ORM远不如 SQLAlchemy 强大, 除了在Django这一亩三分地, SQLAlchemy是Python世界里事实上的ORM标准, 其它框架都支持SQLAlchemy了, 唯独Django仍然坚持自己的那一套。
      Django的开发人员对 SQLAlchemy 的支持也是有过讨论和尝试的, 不过最终还是放弃了, 估计是代价太高且跟Django其它的模块很难合到一块。
    3.Template功能比较弱, 不能插入Python代码, 要写复杂一点的逻辑需要另外用Python实现Tag或Filter。关于模板这一点, 一直以来争论比较多。
    4.URL配置虽然强大, 但全部要手写, 这一点跟Rails的Convention over configuration的理念完全相左, 高手和初识Django的人配出来的URL会有很大差异。
    5.让人纠结的auth模块, Django的auth跟其它模块结合紧密, 功能也挺强的, 就是做的有点过了,
      用户的数据库schema都给你定好了, 这样问题就来了, 比如很多网站要求email地址唯一, 可schema里这个字段的值不是唯一的, 纠结是必须的了。
    6.Python文件做配置文件, 而不是更常见的ini、xml或yaml等形式。
      这本身不是什么问题, 可是因为理论上来说settings的值是能够动态的改变的(虽然大家不会这么干), 但这不是最佳实践的体现。

    总的来说, Django大包大揽, 用它来快速开发一些Web运用是很不错的。如果你顺着Django的设计哲学来, 你会觉得Django很好用, 越用越顺手；
    相反, 你如果不能融入或接受Django的设计哲学, 你用Django一定会很痛苦, 趁早放弃的好。所以说在有些人眼里Django无异于仙丹,  但对有一些人来说它又是毒药且剧毒。


安装 Django
   安装官方发布版本的Django 下载tarball的“Django-*.tar.gz”
   http://www.djangoproject.com/download/

   Linux 的安装命令
   # 解压
   tar xzvf Django-*.tar.gz
   # 进入解压的目录(目录名的“*”需要改成对应的名称)
   cd Django-*
   # 安装 Django
   sudo python setup.py install

   Windows 下安装则是直接解压“Django-*.tar.gz”并运行
   # 进入解压的目录(目录名的“*”需要改成对应的名称)
   cd Django-*
   # 安装 Django
   python setup.py install

   安装完以后, 在Python交互环境下应该可以 import django 模块
   import django; print(django.VERSION)  # 打印:  (1, 0, 'official')


Django 卸载
    通过执行命令“ setup.py install ”来安装 Django, 只要在“site-packages”目录下删除“django”目录就可以了.
    使用 Python egg 来安装 Django, 直接删除 Django “.egg” 文件, 并且删除 “easy-install.pth”中的 egg 引用就可以了.这个文件应当可以在“site-packages”目录中.

    提示: 如何找到“site-packages”目录?
    “site-packages” 目录的位置取决于使用何种操作系统以及 Python 的安装位置.
    可以通过如下的命令来显示:
        python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"
    (注意,上面的命令请在shell 中执行,不是在 Python中执行.) 结果如：
    /usr/lib/python2.6/dist-packages   (linux 的时候, 而实际上需要删除的是“/usr/local/lib/python2.6/dist-packages”目录的, 他显示那个目录没有django)
    D:\Program\1.Work_soft\Python26\Lib\site-packages  (windows 的时候)
