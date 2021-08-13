#coding=utf-8

# 修改代理,及打开浏览器

import _winreg
import ctypes
import re
import os,os.path


proxy_ip = "127.0.0.1" # 代理IP
proxy_port = 8000 # 代理端口
ProxyOverride = 'localhost;127.0.0.1;192.168.*;<local>' # 不使用代理服务器的IP段(仅IE有效)，或者域名段，可以用*代表任意长字符串,如: 192.168.*
OPEN_URL = 'http://www.barfoo.com.cn' # 要打开的网址

# 保存代理被修改的记录
proxy_change_list = []


def proxy_change(browser_type, proxy_open):
    '''
       功能：记录被修改代理的浏览器类型，以保证还原
       参数: browser_type 浏览器类型,目前仅有：ie, firefox 两个值
             proxy_open 是否开启代理,0为关闭代理,1为使用代理
    '''
    # 修改代理ip
    if proxy_open:
        if browser_type not in proxy_change_list:
            proxy_change_list.append(browser_type)
    # 还原代理
    else:
        if browser_type in proxy_change_list:
            proxy_change_list.remove(browser_type)


def set_ie_proxy(proxy_open):
    '''
       功能: 修改 IE 的代理
       参数: proxy_open 是否开启代理,0为关闭代理,1为使用代理
    '''

    HKLM = _winreg.HKEY_LOCAL_MACHINE
    proxy_path = r"System\CurrentControlSet\Hardware Profiles\0001\Software\Microsoft\windows\CurrentVersion\Internet Settings"
    hKey = _winreg.CreateKey(HKLM, proxy_path)
    # 修改代理设置
    _winreg.SetValueEx(hKey, "ProxyEnable", 0, _winreg.REG_DWORD, proxy_open)
    # 关闭
    _winreg.CloseKey(hKey)

    HKCC = _winreg.HKEY_CURRENT_USER
    proxy_path = r"Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    hKey = _winreg.CreateKey(HKCC, proxy_path)
    # 修改代理设置
    _winreg.SetValueEx(hKey, "ProxyEnable", 0, _winreg.REG_DWORD, proxy_open)
    # 代理IP
    # proxy = "http=%(ip)s:%(port)d;https=%(ip)s:%(port)d;" % {'ip':proxy_ip, 'port':proxy_port} # 这样写,逐个修改代理模式
    proxy = "%(ip)s:%(port)d" % {'ip':proxy_ip, 'port':proxy_port} # 这样写,所有协议均使用相同的代理
    _winreg.SetValueEx(hKey, "ProxyServer", 0, _winreg.REG_SZ, proxy)
    # 是否所有协议使用相同代理服务器: 0为否，1为是
    _winreg.SetValueEx(hKey, "MigrateProxy", 0,  _winreg.REG_DWORD, proxy_open)
    # 不使用代理服务器的IP段，或者域名段，可以用*代表任意长字符串
    _winreg.SetValueEx(hKey, "ProxyOverride", 0, _winreg.REG_SZ, ProxyOverride)
    # 关闭
    _winreg.CloseKey(hKey)

    # IE Reload注册表的信息,会导致 win7 的代理还原无效
    INTERNET_OPTION_REFRESH = 37
    INTERNET_OPTION_SETTINGS_CHANGED = 39
    internet_set_option = ctypes.windll.Wininet.InternetSetOptionW
    internet_set_option(0, INTERNET_OPTION_REFRESH, 0, 0)
    internet_set_option(0, INTERNET_OPTION_SETTINGS_CHANGED, 0, 0)

    # 保存修改记录
    proxy_change('ie', proxy_open)


def set_firefox_proxy(proxy_open):
    '''
       功能: 修改 火狐 的代理
       参数: proxy_open 是否开启代理,0为关闭代理,1为使用代理
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

    # 保存修改记录
    proxy_change('firefox', proxy_open)

    # 操作成功，返回 True
    return True


def reset_proxy():
    '''
       功能: 还原浏览器的代理设置
    '''
    if 'ie' in proxy_change_list:
        ie_proxy(0)
    if 'firefox' in proxy_change_list:
        kill_process('firefox.exe') # 火狐必须先关闭浏览器，否则修改无法生效，火狐会自动改回去
        firefox_proxy(0)

#    # 放弃使用按默认浏览器来还原代理的方式，让程序可自由打开IE或者火狐
#    default_path, browser_type = get_default_browser()
#    # 如果默认浏览器是火狐,则设置火狐的代理
#    if 'firefox' == browser_type:
#        kill_process('firefox.exe') # 火狐必须先关闭浏览器，否则修改无法生效，火狐会自动改回去
#        set_firefox_proxy(0)
#    # 不是上面的，则设置IE的代理
#    else:
#        set_ie_proxy(0)


def get_default_browser():
    '''
       功能: 获取默认的浏览器
       返回: 返回一个元组:(默认的浏览器文件地址, 浏览器类型)； 注意: 没有设置默认浏览器时返回IE浏览器
    '''
    root = _winreg.HKEY_CLASSES_ROOT
    name_path = r"http\shell\open\command"
    key = _winreg.OpenKey(root, name_path)
    default_path,type = _winreg.QueryValueEx(key,"") # 获取默认值，返回:  (value,type)
    if default_path:
        # 默认浏览器的地址
        default_browser = default_path.lower().split('.exe" ')[0] + '.exe" '

        # 如果默认浏览器是火狐
        if 'firefox' in default_path.lower():
            return (default_browser, 'firefox',)
        # 不是上面的，则认为是IE
        else:
            return (default_browser, 'IE',)

    # 没有默认浏览器，则认为是IE
    else:
        return ('"iexplore.exe" ', 'IE',)


def open_default_browser():
    '''
       功能: 打开默认的浏览器,修改默认浏览器的代理
    '''
    default_path, browser_type = get_default_browser()
    # 如果默认浏览器是火狐,则设置火狐的代理
    if 'firefox' == browser_type:
        kill_process('firefox.exe') # 火狐必须先关闭浏览器，否则无法修改代理
        result = set_firefox_proxy(1)
        # 设置代理不成功时
        if not result:
            print u'火狐浏览器的代理设置不成功，请手动设置'
            print u'代理IP为:' + proxy_ip
            print u'代理端口为:' + str(proxy_port)
    # 不是上面的，则设置IE的代理
    else:
        set_ie_proxy(1)

    # 打开默认浏览器
    os.system('start "" ' + default_path + OPEN_URL)


def kill_process_byname(name):
    """
       功能: 按名称杀死进程
       参数: name 进程名称
    """
    kill_command = 'taskkill /F /IM "%s"' % name
    #os.system(kill_command) # 这命令会弹出一个黑乎乎的cmd运行窗口
    os.popen(kill_command) # 捕获运行的返回，不再另外弹出窗口

def kill_process_bypid(pid):
    """
       功能: 按名称杀死进程
       参数: pid 进程名称
    """
    kill_command = 'taskkill /F /PID %s' % pid
    os.popen(kill_command)
    #os.system(kill_command)

def is_process_running(imagename):
    """
       功能：检查进程是否存在
       返回：返回有多少个这进程名的程序在运行，返回0则程序不在运行
    """
    p = os.popen('tasklist /FI "IMAGENAME eq %s"' % imagename) # 利用 windows 批处理的 tasklist 命令
    return p.read().upper().count(imagename.upper()) # p 是个文件类型，可按文件的操作； windows平台需忽略大小写


def readFile(filename):
    try:
        with open(filename, 'rb') as f:
            return f.read()
    except IOError:
        return None

def writeFile(filename, content):
    with open(filename, 'wb') as f:
        f.write(str(content))



if __name__ == "__main__":
    open_default_browser()
    #reset_proxy()


