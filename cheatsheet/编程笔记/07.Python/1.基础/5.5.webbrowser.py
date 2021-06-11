webbrowser模块常用的方法有：
    webbrowser.open(url, new=0, autoraise=True)
    在系统的默认浏览器中访问url地址，如果new=0,url会在同一个浏览器窗口中打开；如果new=1，新的浏览器窗口会被打开;new=2新的浏览器tab会被打开。
        webbrowser.open_new(url)         # return open(url, 1)
        webbrowser.open_new_tab(url)     # open(url, 2)
        webbrowser.get()方法可以获取到系统浏览器的操作对象。
        webbrowser.register()方法可以注册浏览器类型，而允许被注册的类型可以参阅：
        http://www.cnblogs.com/hongten/p/hongten_python_webbrowser.html所列出的内容。

首先我还是讲一下网上看的比较多的打开浏览器的方法
    import webbrowser 
    webbrowser.open('www.baidu.com') 
这样就可以打开一个百度页面，但是很恼火的情况是，默认使用IE打开的，至少我的电脑是默认IE打开的。


下面就讲一下用别的浏览器打开的方法：
很神奇的是经过自己的尝试，发现#这段代码中 new=0 或者1或者2 都是在已打开浏览器打开的页面 ,按理说为1时不应该是新开一个浏览器窗口吗,迷之难题#
    import webbrowser 
    chromePath = r'你的浏览器目录'            #  例如我的：C:\***\***\***\***\Google\Chrome\Application\chrome.exe 
    webbrowser.register('chrome', None, webbrowser.BackgroundBrowser(chromePath))  #这里的'chrome'可以用其它任意名字，如chrome111，这里将想打开的浏览器保存到'chrome'
    webbrowser.get('chrome').open('www.baidu.com'，new=1,autoraise=True)

    webbrowser.register()方法可以注册浏览器类型，而允许被注册的类型名称如下：
    Type Name Class Name Notes 
    'mozilla' Mozilla('mozilla')   
    'firefox' Mozilla('mozilla')   
    'netscape' Mozilla('netscape')   
    'galeon' Galeon('galeon')   
    'epiphany' Galeon('epiphany')   
    'skipstone' BackgroundBrowser('skipstone')   
    'kfmclient' Konqueror() (1) 
    'konqueror' Konqueror() (1) 
    'kfm' Konqueror() (1) 
    'mosaic' BackgroundBrowser('mosaic')   
    'opera' Opera()   
    'grail' Grail()   
    'links' GenericBrowser('links')   
    'elinks' Elinks('elinks')   
    'lynx' GenericBrowser('lynx')   
    'w3m' GenericBrowser('w3m')   
    'windows-default' WindowsDefault (2) 
    'macosx' MacOSX('default') (3) 
    'safari' MacOSX('safari') (3) 
    'google-chrome' Chrome('google-chrome')   
    'chrome' Chrome('chrome')   
    'chromium' Chromium('chromium')   
    'chromium-browser' Chromium('chromium-browser')

    