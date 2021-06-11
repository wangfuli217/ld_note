
修改注册表(使用 _winreg, python3.x是 winreg 模块, 内置模块)
    官方的参考文档：
    http://docs.python.org/library/_winreg.html
    http://www.python.org/doc/2.6.2/library/_winreg.html

    1.  读取
        读取用的方法是OpenKey方法：打开特定的key
        hkey = _winreg.OpenKey(key,sub_key,res=0,sam=KEY_READ)
        _winreg.CloseKey(hkey) # 关闭之前打开的,如果不关闭则在对象被销毁时关闭

        例子：
        import _winreg
        key = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{0E184877-D910-4877-B 4C2-04F487B6DBB7}")

        #获取该键的所有键值，遍历枚举
        try:
            i=0
            while 1:
                # EnumValue方法用来枚举键值，EnumKey用来枚举子键
                print _winreg.EnumValue(key,i) # 打印： (name,value,type)
                i+=1
        except WindowsError:
            print

        #假如知道键名，也可以直接取值
        print _winreg.QueryValueEx(key,"ExplorerStartupTraceRecorded") # 打印： (value,type)

    2.  创建 修改注册表
        创建key：_winreg.CreateKey(key,sub_key)
        创建key：_winreg.CreateKeyEx(key, sub_key[, res[, sam]])
        删除key: _winreg.DeleteKey(key,sub_key)
        删除键值： _winreg.DeleteValue(key,value)
        给新建的key赋值： _winreg.SetValue(key,sub_key,type,value)

        例子：
        import _winreg

        key=_winreg.OpenKey(_winreg.HKEY_CURRENT_USER,r"Software\Microsoft\Windows\CurrentVersion\Explorer")
        # 删除键(没有时会报错)
        _winreg.DeleteKey(key, "Advanced")
        # 删除键值(没有时会报错)
        _winreg.DeleteValue(key, "IconUnderline")
        # 创建新的项
        newKey = _winreg.CreateKey(key,"MyNewkey")
        # 给新创建的项，添加键值(会多一个项:ValueName, 默认的值是ValueContent)
        _winreg.SetValue(newKey,"ValueName", _winreg.REG_SZ, "ValueContent")

    3.  访问远程注册表
        # 第二参数必须是HKEY_CURRENT_USER、HKEY_LOCAL_MACHINE等预先定义好的值，拿到返回的key后就可以进行操作了
        key = _winreg.ConnectRegisty("IP地址或者机器名", _winreg.HKEY_CURRENT_USER)

    实例： 修改IE代理服务器
        import _winreg # python3 则写 winreg
        import ctypes

        #proxy = "127.0.0.1:8000"
        proxy = "http=127.0.0.1:8580;https=127.0.0.1:8580;ftp=127.0.0.1:8580" # 代理服务器地址
        ProxyOverride = '<local>;192.168.*;127.*' # 不使用代理服务器的IP段，或者域名段，可以用*代表任意长字符串,如: 192.168.*
        root = _winreg.HKEY_CURRENT_USER
        proxy_path = r"Software\Microsoft\Windows\CurrentVersion\Internet Settings"

        hKey = _winreg.OpenKey(root, proxy_path)
        # value 是代理是否开启的标志，0表示不使用代理，1表示使用
        value, type = _winreg.QueryValueEx(hKey, "ProxyEnable")
        if value: # value 为 0 时
            print("原本已使用代理")
        else:
            print("原本还没使用代理")

        # 修改代理设置
        hKey = _winreg.CreateKey(root, proxy_path)
        _winreg.SetValueEx(hKey, "ProxyEnable", 0, _winreg.REG_DWORD, 0) # 最后的参数是代理的开关，0为关闭代理，1为开启
        _winreg.SetValueEx(hKey, "ProxyServer", 0, _winreg.REG_SZ, proxy)
        # 不使用代理服务器的IP段，或者域名段，可以用*代表任意长字符串
        _winreg.SetValueEx(hKey, "ProxyOverride", 0, _winreg.REG_SZ, ProxyOverride)
        _winreg.SetValueEx(hKey, "MigrateProxy", 0, _winreg.REG_DWORD, 1) # 是否所有协议使用相同代理服务器: 0为否，1为是
        # 最后，关闭注册表连接
        _winreg.CloseKey(hKey)

        # IE Reload注册表的信息, 因为修改注册表之后, ie不会马上生效, 需要这一段； 但在win7系统似乎有点问题
        INTERNET_OPTION_REFRESH = 37
        INTERNET_OPTION_SETTINGS_CHANGED = 39
        internet_set_option = ctypes.windll.Wininet.InternetSetOptionW
        internet_set_option(0, INTERNET_OPTION_REFRESH, 0, 0)
        internet_set_option(0, INTERNET_OPTION_SETTINGS_CHANGED, 0, 0)


修改注册表(使用 win32api, win32con 模块，需安装)
    1.  下载和安装模块： http://starship.python.net/crew/mhammond/downloads/
        下载像“pywin32-212.6.win32-py2.6.exe”来安装

    2.  注册表基本项
            项名                      描述
        HKEY_CLASSES_ROOT          是HKEY_LOCAL_MACHINE\Software 的子项，保存打开文件所对应的应用程序信息
        HKEY_CURRENT_USER          是HKEY_USERS的子项，保存当前用户的配置信息
        HKEY_LOCAL_MACHINE         保存计算机的配置信息，针对所有用户
        HKEY_USERS                 保存计算机上的所有以活动方式加载的用户配置文件
        HKEY_CURRENT_CONFIG        保存计算机的硬件配置文件信息

    3. 打开注册表
        win32api.RegOpenKey(key, subkey, reserved, sam)
        win32api.RegOpenKeyEx(key, subkey, reserved, sam)
        两个函数的参数用法一样。参数含义如下：
          Key：必须为表1中列出的项。
          SubKey：要打开的子项。
          Reserved：必须为0。
          Sam：对打开的子项进行的操作，包括 win32con.KEY_ALL_ACCESS、 win32con.KEY_READ、 win32con.KEY_WRITE 等

    4.  关闭注册表
        win32api.RegCloseKey(key)
        其参数只有一个，其含义如下：
          Key：已经打开的注册表项的句柄。

        如：
        key = win32api.RegOpenKey(win32con.HKEY_CURRENT_USER, 'Software', 0, win32con.KEY_READ)
        print key # 显示： <PyHKEY at 7670448 (220)>
        win32api.RegCloseKey(key)
        print key # 显示： <PyHKEY at 7670448 (0)>

    5.  读取项值
        win32api.RegQueryValue(key，subKey) # 读取项的默认值；其参数含义如下：
            Key：已打开的注册表项的句柄。
            subKey：要操作的子项。

        win32api.RegQueryValueEx(key，valueName) # 读取某一项值；其参数含义如下：
            Key：已经打开的注册表项的句柄。
            valueName：要读取的项值名称。

        win32api.RegQueryInfoKey(key)  # RegQueryInfoKey函数查询项的基本信息； 返回项的子项数目、项值数目，以及最后一次修改时间

      如：
        import win32api
        import win32con

        # 打开“HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer”项
        key = win32api.RegOpenKey(win32con.HKEY_LOCAL_MACHINE,'SOFTWARE\\Microsoft\\Internet Explorer',0, win32con.KEY_ALL_ACCESS)

        # 读取项的默认值''
        # 输出为空，表示其默认值未设置
        print win32api.RegQueryValue(key,'')

        #读取项值名称为Version的项值数据，也就是Internet Explorer的版本
        print win32api.RegQueryValueEx(key,'Version') # 显示如：('6.0.2900.2180', 1)
        print win32api.RegQueryInfoKey(key)  # 查询项的基本信息,显示如：(26, 7, 128178812229687500L)

    6.  设置项值
        win32api.RegSetValue(key，subKey，type，value) # 设置项的默认值
            Key：已经打开的项的句柄。
            subKey：所要设置的子项。
            Type：项值的类型，必须为 win32con.REG_SZ。
            Value：项值数据，为字符串。

        win32api.RegSetValueEx(key，valueName，reserved，type，value) # 要修改或重新设置注册表某一项的项值。如果项值存在，则修改该项值，如果不存在，则添加该项值。
            Key：要设置的项的句柄。
            valueName：要设置的项值名称。
            Reserved：保留，可以设为0。
            Type：项值的类型。
            Value：所要设置的值。

      如：
        # 将“HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer”的默认值设为python
        win32api.RegSetValue(key,'',win32con.REG_SZ,'python')
        # 修改“Version”的值
        win32api.RegSetValueEx(key,'Version',0,win32con.REG_SZ,'7.0.2900.2180')

    7.  添加、删除项
        win32api.RegCreateKey(key，subKey) # 向注册表中添加项
        win32api.RegDeleteKey(key，subKey) # 删除注册表中的项
        两个函数的参数用法一样。参数含义如下：
            Key：已经打开的注册表项的句柄。
            subKey：所要操作（添加或删除）的子项。

      如：
        # 向“HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer”添加子项“Python”
        win32api.RegCreateKey(key,'Python') # 此时会多一个“HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\\Python”
        # 删除刚才创建的子项“Python”
        win32api.RegDeleteKey(key,'Python') # 没有此项时，会抛出错误

    实例： 修改IE代理服务器
        # 注意，新设置好的代理服务器，不会对之前已经开启的IE起效，只对之后开启的IE有效。
        import win32api
        import win32con
        # 打开“HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings”项；代理设置在注册表中的位置
        key = win32api.RegOpenKey(win32con.HKEY_CURRENT_USER, r'Software\Microsoft\Windows\CurrentVersion\Internet Settings', 0, win32con.KEY_ALL_ACCESS)
        # "ProxyEnable"=dword:00000001       ;是否启用代理服务器，dword:00000001表示开启，dword:00000000表示失效
        win32api.RegSetValueEx(key, 'ProxyEnable', 0, win32con.REG_DWORD, 1)
        # "ProxyServer"="192.168.0.1:8088"   ;代理服务器的地址和端口
        win32api.RegSetValueEx(key, 'ProxyServer', 0, win32con.REG_SZ, '127.0.0.1:8000')
        # "ProxyOverride"="192.168.*"        ;不使用代理服务器的IP段，或者域名段，可以用*代表任意长字符串
        win32api.RegSetValueEx(key, 'ProxyOverride', 0, win32con.REG_SZ, '192.168.*')

        # 想把IE代理去掉，如：
        win32api.RegSetValueEx(key, 'ProxyEnable', 0, win32con.REG_DWORD, 0)
        # 最后，关闭注册表连接
        win32api.RegCloseKey(key)

