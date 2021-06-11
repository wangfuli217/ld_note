ubuntu 安装后配置记录

1.安装 MySQL
	sudo apt-get install mysql-server

2.安装 eclipse + pydev
	a.安装 eclipse
	   sudo apt-get install eclipse

应用软件：
  1.电影播放器不能播放rmvb格式的解决办法
    第一步 首先动手安装totem-xine。可以在新立得里面搜索后安装，安装时新立得会自动删除原来的totem-gsteamer
    第二步 安装w32codes的源有2005年的版本也可以自己去官方下载最新版本。
    具体:我把essential-20071007.tar.bz2解压，把解压后的所有文件拷贝到/usr/lib/win32文件夹下（如果没有就新建一个win32文件夹）。这样就可以播放rmvb格式咯。

  3.为firefox安装 flash插件
    首先安装flash播放插件，在终端输入：sudo apt-get install flashplugin-nonfree
    也可以到这里 下载，下载後安装：
    tar -zxvf install_flash_player_9_linux.tar.gz
    cd install_flash_player_9_linux/
    sudo ./flashplayer-installer

  4.更快速的打开网页，在firefox浏览器地址拦里输入about:config
    找下面的选项进行修改吧:
    network.dns.disableIPv6 -> true
    network.http.pipelining -> true
    network.http.pipelining.maxrequests -> 8(8－24这是我自己的设置）
    network.http.proxy.pipelining -> true

  5.安装 QQ, msn
    web版QQ：
        http://web.qq.com/
        安装软件可以在腾讯下载，只是用起来不爽
        可以使用系统自带的 Empathy 即时通讯程序

    web版MSN：
         https://login.live.com/login.srf
         http://webmessenger.live.cn/

    安装 Emesene :MSN客户端
        sudo add-apt-repository ppa:emesene-team/emesene-stable
        sudo apt-get update
        sudo apt-get install emesene

  6.chm 查看
    使用 firefox 插件, 安装了一个CHM reader的扩展 https://addons.mozilla.org/en-US/firefox/addon/3235
    打开方法: 打开firefox后，依次打开:  查看－侧栏－CHM reader，然后CHMreader浏览器的左侧，单击open就可以打开.chm文件了

    安装 kchmviewer:
      sudo apt-get install kchmviewer
    下载地址:
      http://sourceforge.net/projects/kchmviewer/files/kchmviewer/

    安装 FBReader
      sudo apt-get install fbreader

  7.安装 rar
    下载地址: http://www.onlinedown.net/soft/3.htm
    下载文件如: rarlinux-4.0.1.tar.gz

    解压:      tar xvfz rarlinux-4.0.1.tar.gz
    安装:      sudo make install

    需要的GLIBC_2.4。如果没有GLIBC_2.4可以复制:
      sudo cp ./rar解压目录/rar_static /usr/local/bin/rar

    rar_static 版是 static linking 版本，不会有 glibc 程式库版本不和的问题。

    使用的命令行(可以右键使用,不需命令行):
        解压文件:      rar x 文件名.rar 目录名/
        打包:     rar a install.rar ./install.log


  8.中文输入法
    sudo apt-get install language-support-zh
    是安装没有安装过的中文环境，ctrl+空格，还是没有中文输入法，要多试几次。

    安装SCIM，中文输入不可用，用以下命令更新：
    sudo apt-get install scim  # 没有安装 scim 的就安装(中文版的都默认安装了)
    sudo apt-get install scim scim-modules-socket scim-modules-table scim-pinyin scim-tables-zh scim-gtk2-immodule scim-qtimm
    sudo im-switch -s scim

    重启生效


    删除其它输入法，如ibus: sudo apt-get remove ibus


    解决让scim光标跟随的问题
    修改/etc/X11/xinit/xinput.d/scim：
    sudo gedit /etc/X11/xinit/xinput.d/scim

    改成这样：
    #GTK_IM_MODULE=xim
    #QT_IM_MODULE=xim
    GTK_IM_MODULE=scim
    QT_IM_MODULE=scim


  9.共享
    # 打开文件夹(nautilus),按 Ctrl + L, 地址栏输入： smb://192.168.1.101/
    # 需安装 smb:
    sudo apt-get install samba
    sudo apt-get install smbfs

    smbmount的用法：(smbmount也是mount的一个变种)
    smbmount -o username=用户名,password=密码, -l //ip地址或计算机名/共享文件夹名 挂载点
    smbmount //ip地址或计算机名/共享文件夹名 挂载点
    如： smbmount //192.168.1.113/Holemar/1.notes /home/holemar/program/notes


  10.apt-get 常用命令、参数
    apt-cache search package # 搜索包
    apt-cache show package # 获取包的相关信息，如说明、大小、版本等
    sudo apt-get install package # 安装包
    sudo apt-get install package -- reinstall # 重新安装包
    sudo apt-get -f install # 修复安装"-f = ――fix-missing"
    sudo apt-get remove package # 删除包
    sudo apt-get remove --purge package # 删除包，包括删除配置文件等
    sudo apt-get update 更新源
    sudo apt-get upgrade 更新已安装的包
    sudo apt-get dist-upgrade 升级系统
    sudo apt-get dselect-upgrade 使用 dselect 升级
    apt-cache depends package # 了解使用依赖
    apt-cache rdepends package # 是查看该包被哪些包依赖
    sudo apt-get build-dep package # 安装相关的编译环境
    apt-get source package # 下载该包的源代码
    sudo apt-get clean && sudo apt-get autoclean # 清理无用的包
    sudo apt-get check 检查是否有损坏的依赖
    其中：
    1 有 sudo 的表示需要管理员特权！
    2 在 ubuntu 中命令后面参数为短参数是用“-”引出，长参数用“――”引出
    3 命令帮助信息可用man 命令的方式查看或者
    命令 -H（――help）方式查看
    4 在MAN命令中需要退出命令帮助请按“q”键！！
    选项 含义 作用
    sudo -h Help 列出使用方法，退出。
    sudo -V Version 显示版本信息，并退出。
    sudo -l List 列出当前用户可以执行的命令。只有在sudoers里的用户才能使用该选项。
    sudo -u username|#uid User 以指定用户的身份执行命令。后面的用户是除root以外的，可以是用户名，也可以是#uid。
    sudo -k Kill 清除“入场卷”上的时间，下次再使用sudo时要再输入密码。
    sudo -K Sure kill 与-k类似，但是它还要撕毁“入场卷”，也就是删除时间戳文件。
    sudo -b command Background 在后台执行指定的命令。
    sudo -p prompt command Prompt 可以更改询问密码的提示语，其中%u会代换为使用者帐号名称，%h会显示主机名称。非常人性化的设计。
    sudo -e file Edit 不是执行命令，而是修改文件，相当于命令sudoedit。

    apt-file search filename——查找包含特定文件的软件包（不一定是已安装的），这些文件的文件名中含有指定的字符串。
    apt-file是一个独立的软件包。您必须先使用apt-get install来安装它，然後运行apt-file update。
    如果apt-file search filename输出的内容太多，您可以尝试使用apt-file search filename | grep -w filename 或者类似方法。

    sudo apt-get autoclean ——定期运行这个命令来清除那些已经卸载的软件包的.deb文件。通过这种方式，您可以释放大量的磁盘空间。
    如果您的需求十分迫切，可以使用 sudo apt-get clean 以释放更多空间。这个命令会将已安装软件包裹的.deb文件一并删除。
    大多数情况下您不会再用到这些.debs文件，因此如果您为磁盘空间不足而感到焦头烂额，这个办法也许值得一试。

    修改apt-get源
        第一是备份现有服务器列表
            sudo cp /etc/apt/sources.list /etc/apt/sources.list_back
        第二编辑，您可以使用自己喜爱的编辑器编辑，如:gedit, nano，kate，vim等
            sudo gedit /etc/apt/sources.list
        服务器：
            Archive.ubuntu.com (欧洲，此为官方源，推荐使用。)：
            Ubuntu.cn99.com (江苏省常州市电信，推荐电信用户使用。）：
            Mirror.lupaworld.com (浙江省杭州市电信，亚洲地区官方更新服务器，推荐全国用户使用。）：
            ftp.sjtu.edu.cn 上海市 上海交通大学（教育网，推荐校园网和网通用户使用。）：
            mirror9.net9.org 北京市清华大学（教育网，推荐校园网和网通用户使用。)：
            ubuntu.csie.ntu.edu.tw  台湾大学（推荐网通用户使用，电信PING平均响应速度41MS。）
            Mirror.vmmatrix.net （上海市电信，推荐电信网通用户使用。）:
            ubuntu.cnsite.org  (福建省福州市 电信):
            cn.archive.ubuntu.com 默认的源,速度较慢。
            mirrors.163.com  163的源，广州电信测试时更快。

    保存编辑好的文件，执行以下命令更新。
        sudo apt-get update
        sudo apt-get dist-upgrade

    通过apt-get install安装软件后，软件的安装目录
	通过apt-get install 命令安装了一些软件，但这些软件的源码以及那些安装完以后的文件放在哪个文件夹下面？
	可以通过以下两种方式查看：
	（1）.在terminal中输入命令：dpkg -L 软件名
		eg：dpkg -L gcc
		    dpkg -L gcc-4.4
		    dpkg -L g++
		    dpkg -L g++-4.4
	（2）.在新立得中搜索到你已经安装的软件包，选中点属性（或右键），点属性对话框中的“已安装的文件”即可看到。



系统权限：
  1.分配root用户管理权限的方法
    只要为root设置一个root密码就行了： $ sudo passwd root
    之后会提示要输入root用户的密码，连续输入root密码，再使用：$ su
    就可以切换成超级管理员用户登陆了！

  2.没有创建文件夹的权限的解决办法
    可以直接运行 sudo nautilus
    弹出来的nautilus可以直接GUI操作
    中途别关终端

  3.如果你发现右键点击文件夹却没有权限复制、重命名怎么办？
    在终端运行 sudo nautilus

  4.以root权限打开文件夹
    sudo apt-get install nautilus-gksu
    这样右键单击文件或文件夹，选择以管理员打开。

  5.开机自动运行某程序
    su  # 用超级管理员账户登录,不知道登录密码时参考下面的“十六、分配root用户管理权限的方法”
    chmod 777 /etc/rc.local  # 先给这文件赋以权限
    su - # 用回默认账户登录
    gedit /etc/rc.local  # 在这文件里面写入要执行的内容


其它：
  1.把终端加到右键菜单
    sudo apt-get install nautilus-open-terminal
    这样就把终端加到右键菜单中了。

  2.查看系统版本
    使用命令:  cat /etc/issue
    也可以使用 lsb_release 命令： sudo lsb_release -a

  3.如何修改桌面图标
    在终端下运行：gconf-editor
    依次打开：apps>nautilus>desktop，把右边窗口里的几个方框分别打上勾就行了。

  4.关于屏幕偏移问题
    1. sudo xvidtune
    2. 用left和right按钮调屏幕位置，再test按钮试一试满意没有，满意了，就下一步，不满意再用left和right按钮调整。
    3. 按show，好让终端有类似 "1024x768" 94.50 1024 1093 1168 1376 768 769 772 808 +hsync +vsync 的出现。
    4.sudo gedit /etc/X11/xorg.conf，先另存为，作一个备份。然後找到Section "Monitor"中当前分辨率的那段，你应该会看到类似 Modeline "1024x768" 94.50 1024 1093 1168 1376 768 769 772 808 +hsync +vsync这样的语句（没有的话就将记下来的东西在开头加Modeline，将它添加到EndSection的前面），按照刚才记下来的东西修改其中的相应位置的数值，改完後保存文件为原来的xorg.conf，注销，然後重起xwindow，搞定！

  5.如果存在性能方面的问题，那么非常有可能是你的计算机上运行的某个进程几乎消耗了所有的内存，要发现问题，运行下面的命令：
    代码:lucas@ubuntu:~$ top
    top命令会显示计算机当前消耗最多系统资源的进程。

  6.命令窗口的快捷键
    对命令窗口默认的 Ctrl + Shift + C 和  Ctrl + Shift + V 的复制粘贴有点不习惯，而 Ctrl + C 被用来作为中断命令。
    可以在菜单的编辑-键盘快捷键， 重设快捷键，可以根据自己的喜好来。

  7.Ubuntu下修改多系统默认开机启动顺序
    安装完Ubuntu后，通常是双系统（windows+ubuntu），以后每次启动系统之前会出现一个菜单列表提示选择进入哪一个系统，默认是进入Ubuntu。
    这里是多系统下,原本默认开机为ubuntu时，修改开机默认启动项为windows。
    如果windows重装过，或者是先装ubuntu，后装windows的，貌似默认开机为windows，可以在windows下修改默认开机为ubuntu。

    解决方案：
        进入Ubuntu，打开/etc/default/grub文件: sudo gedit /etc/default/grub
        修改GRUB_DEFAULT = X (默认为0,我的windows要设为6)

        计算 X 的值：
            打开/boot/grub/grub.cfg文件，其中包含了开机菜单中所有启动项的名称，所有启动项名称以 menuentry 打头。找到windows启动项的序号，这个序号减1的值即为X的值。
            格式如： menuentry 'Ubuntu, whith Linux 2.6.35-25-generic'， menuentry "Windows 7 (loader) (on /dev/sda1)"

        最后一步, sudo update-grub, 更新/boot/grub/grub.cfg文件

    其它解决方案：
        直接修改 /boot/grub/grub.cfg 文件, set default = X (X值的计算同上)。虽然更简单了，但是这里不建议直接修改该文件。
        另一种方法也是直接修改 /boot/grub/grub.cfg 文件, 把 menuentry "Windows ..." 的一段放在最前面,即 menuentry 'Ubuntu ...' 的前面。

    Note: 以上方法适用于grub 2，对应的Ubuntu版本为9.10以后。
    我的 ubuntu 11.10 版本,前两种方案不可行,用最后一种(即把windows的放最前面)


  8.默认启动为字符界面
    想切换成图形界面，使用命令: startx

  9.ubuntu下gcc/g++/gfortran的安装
    (1).gcc
	ubuntu下自带gcc编译器。可以通过“gcc -v”命令来查看是否安装。

    (2).g++
	安装g++编译器，可以通过命令“sudo apt-get install build-essential”实现。
	执行完后，就完成了gcc,g++,make的安装。build-essential是一整套工具，gcc，libc等等。
	通过“g++ -v”可以查看g++是否安装成功。

	注：“sudo apt-get install build-essential --fix-missing”，这个命令是修补安装build-essential，即已安装了部分build-essential，但没有安装完全，此时可以使用该命令继续安装build-essential。

    (3).gfortran
	输入命令：sudo apt-get install gfortran
	通过命令“gfortran -v”，可以查看gfortran是否安装成功。

