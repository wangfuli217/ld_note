一、安装
pyinstaller安装比较简单，支持pip 安装，直接使用如下命令即可完成安装：

    pip install pyinstaller

不怕麻烦的也可以通过下载源码python setup.py install 进行安装 。

需要注意的是，pyinstaller在windows平台下依赖pywin32模块。在使用pyinstaller前，需要安装好pywin32模块（exe 的包，安装非常简单）。
二、使用

默认安装完成后，pyinstaller程序位于C:\Python27\Scripts目录下，可以通过执行pyinstaller  python_script.py 生成可执行文件 ，生成的可执行文件位于执行所在目录下的dist目录下。其高级参数如下：

    –distpath=path_to_executable 指定生成的可执行文件存放的目录，默认存放在dist目录下
    –workpath=path_to_work_files 指定编译中临时文件存放的目录，默认存放在build目录下
    –clean 清理编译时的临时文件
    -F, –onefile 生成单独的exe文件而不是文件夹
    -d, –debug 编译为debug模式，有助于运行中获取日志信息
    –version-file=version_text_file 为exe文件添加版本信息，版本信息可以通过运行pyi-grab_version加上要获取版本信息的exe文件的路径来生成，生成后的版本信息文件可以按需求修改并作为--version-file的参数添加到要生成的exe文件中去
    -i <FILE.ico>, -i <FILE.exe,ID>, –icon=<FILE.ico>, –icon=<FILE.exe,ID>
    为exe文件添加图标，可以指定图标路径或者从已存在的exe文件中抽取特定的ID的图标作为要生成的exe文件的图标

另外，还可以通过spec文件来生成可执行文件 。具体命令如下：

    pyinstaller specfile
    或者
    pyi-build specfile

注： spec文件每次通过命令生成时都会存在，可以通过简单的修改增加相应的功能，如加图标，指定版权文件 。

这里以之前写的程序为例，可以通过如下命令生成一个可执行文件

    C:\Users\thinkpad>cd /d C:\Users\thinkpad\Desktop\monitor
    C:\Users\thinkpad\Desktop\monitor>C:\Python27\Scripts\pyinstaller.exe -F monitor.py

在monitor增加一个ico图标文件，操作方法如下：

    C:\Users\thinkpad\Desktop\monitor>C:\Python27\Scripts\pyinstaller.exe -i alert.ico  -F  monitor.py

增加版本信息文件方法如下：

    C:\Users\thinkpad\Desktop\monitor>C:\Python27\Scripts\pyinstaller.exe -i alert.ico --version-file=file_version_info.txt -F  monitor.py

版本信息的写法看后面 。

此时的spec文件内容如下：

    # -*- mode: python -*-
    block_cipher = None
    a = Analysis(['monitor.py'],
                 pathex=['C:\\Users\\thinkpad\\Desktop\\monitor'],
                 binaries=None,
                 datas=None,
                 hiddenimports=[],
                 hookspath=[],
                 runtime_hooks=[],
                 excludes=[],
                 win_no_prefer_redirects=False,
                 win_private_assemblies=False,
                 cipher=block_cipher)
    pyz = PYZ(a.pure, a.zipped_data,
                 cipher=block_cipher)
    exe = EXE(pyz,
              a.scripts,
              a.binaries,
              a.zipfiles,
              a.datas,
              name='monitor',
              debug=False,
              strip=False,
              upx=True,
              console=True , version-file=file_version_info.txt , icon='alert.ico')