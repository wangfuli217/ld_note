#! /usr/bin/env python
#coding=utf-8
# -*- coding: utf-8 -*-
#
# 一个来回切换代理服务器的小脚本
#   用Chrome，切换代理不方便，--proxy-server好像也不顶用
#
# 使用方法:
#   proxytoggle 127.0.0.1:8118
#   执行一次开启，再执行就关闭，再执行又开启，循环往复
#   我自己用的时候改成x.py，放到系统Path下，每次用前用后x一次就行
#
# 有自己主机的，可以用Tohr Proxy:
#   http://blog.solrex.cn/articles/tohr-the-onion-http-router.html
#

import _winreg

# proxy = "127.0.0.1:8580"
proxy = "http=127.0.0.1:8580;https=127.0.0.1:8580;ftp=127.0.0.1:8580"
root = _winreg.HKEY_CURRENT_USER
proxy_path = r"Software\Microsoft\Windows\CurrentVersion\Internet Settings"

# 读取是否使用代理，以切换
kv_Enable = 1
hKey = _winreg.OpenKey(root, proxy_path)
value, type = _winreg.QueryValueEx(hKey, "ProxyEnable")
result = "Enabled"
if value:
    result = "Disabled"
    kv_Enable = 0

# 设置代理
hKey = _winreg.CreateKey (root, proxy_path)
_winreg.SetValueEx (hKey, "ProxyServer", 0, _winreg.REG_SZ, proxy)
_winreg.SetValueEx (hKey, "ProxyEnable", 0, _winreg.REG_DWORD, kv_Enable)


print result
