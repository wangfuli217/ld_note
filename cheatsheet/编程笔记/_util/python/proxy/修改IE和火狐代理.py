#coding=utf-8
# 修改代理

import _winreg
import os.path
import re

proxy_ip = "127.0.0.1"
proxy_port = 8000
ProxyOverride = '<local>;192.168.*;127.0.0.1;' # 不使用代理服务器的IP段，或者域名段，可以用*代表任意长字符串,如: 192.168.*


def ie_proxy(proxy_open):
    '''修改 IE 的代理
       @param proxy_open 是否开启代理,0为关闭代理,1为使用代理
    '''
    root = _winreg.HKEY_CURRENT_USER
    proxy_path = r"Software\Microsoft\Windows\CurrentVersion\Internet Settings"

    hKey = _winreg.CreateKey(root, proxy_path)
    # 修改代理设置
    _winreg.SetValueEx(hKey, "ProxyEnable", 0, _winreg.REG_DWORD, proxy_open)

    # 代理IP
    proxy = "http=%(ip)s:%(port)d;https=%(ip)s:%(port)d;ftp=%(ip)s:%(port)d" % {'ip':proxy_ip, 'port':proxy_port}
    _winreg.SetValueEx(hKey, "ProxyServer", 0, _winreg.REG_SZ, proxy)

    # 不使用代理服务器的IP段，或者域名段，可以用*代表任意长字符串
    _winreg.SetValueEx(hKey, "ProxyOverride", 0, _winreg.REG_SZ, ProxyOverride)

    # 关闭
    _winreg.CloseKey(hKey)


def firefox_proxy(proxy_open):
    '''修改 火狐 的代理
       @param proxy_open 是否开启代理,0为关闭代理,1为使用代理
    '''
    # 获取 系统的用户目录地址，为了修改 火狐的代理设置文件
    root = _winreg.HKEY_CURRENT_USER
    proxy_path = r"Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"

    hKey = _winreg.OpenKey(root, proxy_path)
    # value 是用户的目录，仅需读取，不做修改
    firefox_AppData_path, type = _winreg.QueryValueEx(hKey, "AppData")
    # 关闭
    _winreg.CloseKey(hKey)

    # 获取配置文件的路径
    filePath = firefox_AppData_path + r'\Mozilla\Firefox\profiles.ini'
    # 判断文件是否存在,文件不存在则无法继续执行
    if not os.path.exists(filePath):
        return False

    profiles = open(filePath, 'rb+')
    profiles_content = profiles.read() # 读取全部的内容
    profiles.close() # 关闭io流
    file_paths = re.findall(r'(?im)\bPath=(.*)\n', profiles_content)
    # 没有配置档
    if len(file_paths) == 0:
        return False


    # 修改 火狐的 代理设置文件的文件内容修改
    def modify_content(file_content):
        # 如果没有内容，则返回空字符串
        if not file_content:
            return ''

        # 以替换形式来修改内容,替换IP地址
        def replace_ip(xy, file_content):
            if ('network.proxy.' + xy) in file_content:
                file_content = re.sub(r'user_pref\("network.proxy.' + xy + '", "(.*)"\);', 'user_pref("network.proxy.' + xy + '", "' + proxy_ip + '");', file_content)
            else:
                file_content += ';user_pref("network.proxy.' + xy + '", "' + proxy_ip + '");'
            return file_content

        # 替换端口
        def replace_port(xy, file_content):
            if ('network.proxy.' + xy) in file_content:
                file_content = re.sub(r'user_pref\("network.proxy.' + xy + '", (.*)\);', 'user_pref("network.proxy.' + xy + '", ' + str(proxy_port) + ');', file_content)
            else:
                file_content += ';user_pref("network.proxy.' + xy + '", ' + str(proxy_port) + ');'
            return file_content

        # 替换IP
        file_content = replace_ip('http', file_content)
        file_content = replace_ip('ftp', file_content)
        file_content = replace_ip('socks', file_content)
        file_content = replace_ip('ssl', file_content)
        # 替换端口
        file_content = replace_port('http_port', file_content)
        file_content = replace_port('ftp_port', file_content)
        file_content = replace_port('socks_port', file_content)
        file_content = replace_port('ssl_port', file_content)

        # 是否开启代理
        if 'network.proxy.type' in file_content:
            file_content = re.sub(r'user_pref\("network.proxy.type", (\d)\);', 'user_pref("network.proxy.type", ' + str(proxy_open) + ');', file_content)
        else:
            file_content += '\nuser_pref("network.proxy.type", ' + str(proxy_open) + ');'

        return file_content


    # 处理配置文件
    for path in file_paths:
        path = path.strip()
        filePath = firefox_AppData_path + '\\Mozilla\\Firefox\\' + path + '\\prefs.js'
        # 判断文件是否存在
        if not os.path.exists(filePath):
            return False

        f = open(filePath, 'rb+')
        file_content = f.read() # 读取全部的内容
        f.close() # 关闭io流

        # 修改配置文件的内容
        file_content = modify_content(file_content)

        f = open(filePath, 'wb+')
        f.write(file_content)
        f.close() # 关闭io流

    # 操作成功，返回 True
    return True


if __name__ == '__main__':
    proxy_open = 0 # 是否开启代理,0为不使用代理,1为使用代理
    #ie_proxy(proxy_open)
    firefox_proxy(proxy_open)



'''
ＦＦ的简单设置方法如下(以１９２网段为例，你可以改为你的所屏蔽的ＩＰ数字)：

如果屏蔽192.0.0.0 - 192.255.255.255　就这样设置 192.0.0.0/8
如果屏蔽192.168.0.0 - 192.168.255.255 这样设置 192.168.0.0/16
如果屏蔽192.168.1.0 - 192.168.1.255 这样设置 192.168.1.0/24


HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\  取值: AppData； 保存着用户文件的路径
%AppData%\Mozilla\Firefox\profiles.ini  取值: Path； 保留着配置文件的路径

最终如：
C:\Users\Administrator\AppData\Roaming\Mozilla\Firefox\Profiles\dvobly1u.default\prefs.js
'''
