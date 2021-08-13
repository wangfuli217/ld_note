
import os
import _winreg

OPEN_URL = 'http://www.baidu.com'


def get_default_browser():
    '''
       功能：获取默认的浏览器
       返回：返回一个元组:(默认的浏览器文件地址, 浏览器类型)； 注意：没有设置默认浏览器时返回IE浏览器
    '''
    root = _winreg.HKEY_CLASSES_ROOT
    name_path = r"http\shell\open\command"
    key = _winreg.OpenKey(root, name_path)
    default_path,type = _winreg.QueryValueEx(key,"") # 获取默认值，返回： (value,type)
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
        return ('"C:/Program Files/Internet Explorer/iexplore.exe" ', 'IE',)


def open_default_browser():
    '''
       功能：打开默认的浏览器,修改默认浏览器的代理
    '''
    default_path, browser_type = get_default_browser()
    # 如果默认浏览器是火狐,则设置火狐的代理
    if 'firefox' == browser_type:
        # firefox_proxy(1) ....
        pass
    # 不是上面的，则设置IE的代理
    else:
        # ie_proxy(1) ....
        pass

    # 打开默认浏览器
    os.system('start "" ' + default_path + OPEN_URL)


if __name__ == "__main__":
    os.system('start "" "C:/Program Files/Internet Explorer/iexplore.exe" ' + OPEN_URL) # 打开IE,指定网址
    os.system('start "" "C:/Program Files/Internet Explorer/iexplore.exe"') # 打开IE,不带网址
    os.system('start "" "iexplore.exe" ' + OPEN_URL) # 打开IE(可以不用写路径，因为系统变量里面已经有了),指定网址

    os.system(r'start "" "D:\Program\2.Browser\Firefox\firefox.exe" ' + OPEN_URL) # 打开火狐,指定网址

    # 打开默认的浏览器
    open_default_browser()

