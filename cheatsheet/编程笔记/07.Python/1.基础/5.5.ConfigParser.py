#!/usr/bin/env python
# -*- coding: utf_8 -*-

import ConfigParser

cf = ConfigParser.ConfigParser()
cf.read("E:\work\python project\project.conf")
oldfile_back_login = cf.get("oldfile", "oldfile_back_login")
newfile_back_login = cf.get("newfile", "newfile_back_login")
back_login_name = cf.get("back_login", "name")
back_login_url = cf.get("back_login", "url")
back_login_method = cf.get("back_login", "method")
back_login_pattern = cf.get("back_login", "pattern")


# 读取/写入配置文件,类似于Windows的INI文件

描述
    ConfigParser模块可以为你的应用程序创建用户可编辑的配置文件. 这个配置文件由一个个节组成, 每个节可以
包含配置数据的名字-值对. 支持通过使用Python的格式化字符串进行值的插入, 以此来构建那些依赖于其他值的数据值
(这对路径或URL来说是尤其方便的).
    在工作中,当我们把东西移动到svn和 trac 之前, 我们开发推出了自己的用于进行分布式代码复查的工具. 为了
 准备好需要复查的代码, 一个开发者常常需要写完一个”approach”摘要文件, 然后附上被修改后的代码(即和原代码有区别的地方). 这个approach文档支持通过Web页面添加注释, 因此开发者不在我们的主要办公室里也可以复查代码. 但是唯一的麻烦之处是, 发表代码的不同之处让人感到有点痛苦. 想要让部分处理过程变得简单些, 我写了一个命令行工具, 运行他可以针对CVS沙盒, 自动的寻找出并发表代码的不同之处.

    为了能够让这个工具即时更新approach文档中的区别, 需要知道怎样到达存放approach文档的网络服务器. 由于我们开发者不总是在办公室, 从任意给定主机到达服务器的URL可能是通过SSH端口转发过来的. 为了不强迫每个开发者都使用同样的端口转发协议?这个工具应使用一个简单的配置文件来记住这个URL.

    一个开发者的配置文件可能会是这个样子:
