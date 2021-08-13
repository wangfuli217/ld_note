
实例：

1. 删除注册表信息：
    [-HKEY_CLASSES_ROOT\Applications\Excel.exe]

2.添加注册表信息：
    [HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Internet Settings]
    "MaxConnectionsPerServer"=dword:00000020
    "MaxConnectionsPer1_0Server"=dword:00000020

3.注释：
    ; 注释内容



1.打开注册表：
    点击“开始”菜单中的“运行”，在打开的“运行”对话框中输入“Regedit”，打开注册表编辑器。


实用：
1.禁止IE下载文件
  打开注册表编辑器
  找到HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3
  然后在右边找到1803这个DWORD值，将其键值修改为3即可。
  重新启动IE看看还能不能够下载的？
  如果要取消限制的话，只需要还原DWORD值为0即可。



-------------------------------------
一、注册表的由来
    PC 机及其操作系统的一个特点就是允许用户按照自己的要求对计算机系统的硬件和软件进行各种各样的配置。早期的图形操作系统，如Win3.x 中，对软硬件工作环境的配置是通过对扩展名为.ini 的文件进行修改来完成的，但INI 文件管理起来很不方便，因为每种设备或应用程序都得有自己的INI 文件，并且在网络上难以实现远程访问 。
    为了克服上述这些问题，在Windows 95 及其后继版本中，采用了一种叫做“ 注册表” 的数据库来统一进行管理，将各种信息资源集中起来并存储各种配置信息。按照这一原则，Windows 各版本中都采用了将应用程序和计算机系统全部配置信息容纳在一起的注册表，用来管理应用程序和文件的关联、硬件设备说明、状态属性以及各种状态信息和数据等。
    与INI 文件不同的是：
        1. 注册表采用了二进制形式登录数据；
        2. 注册表支持子键，各级子关键字都有自己的“键值” ；
        3. 注册表中的键值项可以包含可执行代码，而不是简单的字串；
        4. 在同一台计算机上，注册表可以存储多个用户的特性。

    注册表的特点有：
        1. 注册表允许对硬件、系统参数、应用程序和设备驱动程序进行跟踪配置，这使得修改某些设置后不用重新启动成为可能。
        2. 注册表中登录的硬件部分数据可以支持高版本Windows 的即插即用特性。当Windows 检测到机器上的新设备时，就把有关数据保存到注册表中，另外，还可以避免新设备与原有设备之间的资源冲突。
        3. 管理人员和用户通过注册表可以在网络上检查系统的配置和设置，使得远程管理 得以实现。

二、使用注册表
    1. 大家可以在开始菜单中的运行里输入 regedit
    2. 也可以在 DOS 下输入 regedit

三、注册表根键说明
    hkey_classes_root 包含注册的所有 OLE 信息和文档类型，是从 hkey_local_machine\software\classes 复制的。
    hkey_current_user 包含登录的用户配置信息，是从 hkey_users\ 当前用户子树复制的。
    hkey_local_machine 包含本机的配置信息。其中 config 子树是显示器打印机信息； enum 子树是即插即用设备信息； system 子树是设备驱动程序和服务参数的控制集合； software 子树是应用程序专用设置。
    hkey_users 所有登录用户信息。
    hkey_current_config 包含常被用户改变的部分硬件软件配置，如字体设置、显示器类型、打印机设置等。是从 hkey_local_machine\config 复制的。
    hkey_dyn_data 包含现在计算机 内存 中保存的系统信息。

四、注册表详细内容
    Hkey_local_machine\software\microsoft\windows\currentVersion\explorer\user shell folders 保存个人文件夹、收藏夹的路径
    Hkey_local_machine\system\currentControlSet\control\keyboard Layouts 保存键盘使用的语言以及各种中文输入法
    Hkey_users\.Default\software\microsoft\internet explorer\typeURLs 保存 IE 浏览器地址栏中输入的 URL 地址列表信息。清除文档菜单时将被清空。
    Hkey_users\.Default\so..\mi..\wi..\currentVersion\ex..\menuOrder\startMenu 保留程序菜单排序信息
    Hkey_users\.Default\so..\microsoft\windows\currentVersion\explorer\RunMRU 保存 “ 开始 * 运行 ...“ 中运行的程序列表信息。清除文档菜单时将被清空。
    Hkey_users\.Default\so..\microsoft\windows\currentVersion\explorer\ecent Doc s 保存最近使用的十五个文档的快捷方式 ( 删除掉可解决文档名称重复的毛病 ) ，清除文档菜单时将被清空。
    Hkey_local_machine\software\microsoft\windows\currentVersion\uninstall 保存已安装的 Windows 应用程序卸载信息。
    hkey_users\.default\software\microsoft\windows\currentVersion\applets 保存 Windows 应用程序的纪录数据。
    Hkey_local_machine\system\CurrentControlSet\services\class 保存控制面板 - 增添硬件设备 - 设备类型目录。
    Hkey_local_machine\system\CurrentControlSet\control\update 立即刷新设置。值为 00 设置为自动刷新， 01 设置为手工刷新 [ 在资源管理器中按 F5 刷新 ] 。
    HKEY_CURRENT_USER\Control Panel\Desktop 新建串值名 MenuShowDelay=0 可使 “ 开始 ” 菜单中子菜单的弹出 速度 提高。新建串值名 MinAnimate ，值为 1 启动动画效果开关窗口，值为 0 取消动画效果。
    Hkey_local_machine\software\microsoft\windows\currentVersion\run 保存由控制面板设定的计算机启动时运行程序的名称，其图标显示在任务条右边。 [ 启动文件夹程序运行时图标也在任务条右边 ]
    hkey_users\.default\software\microsoft\windows\currentVersion\run 保存由用户设定的计算机启动时运行程序的名称，其图标显示在任务条右侧。
    HKEY_CLASS_ROOT/Paint.Pricture/DefaultIcon 默认图片的图标。双击窗口右侧的字符串，在打开的对话框中删除原来的键值，输入 %1 。重新启动后，在 “ 我的电脑 ” 中打开 Windows 目录，选择 “ 大图标 “ ，然后你看到的 Bmp 文件的图标再也不是千篇一律的画板图标了，而是每个 Bmp 文件的略图。
    Hkey-local-machine\ software\ microsoft\ windows\ currentVersion\ Policies\ Ratings 保存 IE4.0 中文版 “ 安全 ”*“ 分级审查 ” 中设置的口令 ( 数据加密 ) 。
    Hkey-local-machine\ software\ microsoft\ windows\ currentVersion\ explorer\ desktop\nameSpace 保存桌面中特殊的图标 , 如回收站、收件箱、 MS Network 等。
    HEKY_CURRENT_USER＼Software＼Microsoft＼Windows＼CurrentVersion＼Explorer＼FileExts  文件打開方式信息

五、如何备份注册表
    利用注册表编辑器手工备份注册表
    注册表编辑器（ Regedit ）是操作系统自带的一款注册表工具，通过它就能对注册表进行各种修改。当然， " 备份 " 与 " 恢复 " 注册表自然是它的本能了。
    （ 1 ）通过注册表编辑器备份注册表
    由于修改注册表有时会危及系统的安全，因此不管是 WINDOWS 98 还是 WINDOWS 2000 甚至 WINDOWS XP ，都把注册表编辑器 " 藏 " 在了一个非常隐蔽的地方，要想 " 请 " 它出山，必须通过特殊的手段才行。点击 " 开始 " 菜单，选择菜单上的 " 运行 " 选项，在弹出的 " 运行 " 窗口中输入 "Regedit" 后，点击 " 确定 " 按钮，这样就启动了注册表编辑器。
    点击注册表编辑器的 " 注册表 " 菜单，再点击 " 导出注册表文件 " 选项，在弹出的对话框中输入文件名 "regedit" ，将 " 保存类型 " 选为 " 注册表文件 " ，再将 " 导出范围 " 设置为 " 全部 " ，接下来选择文件存储位置，最后点击 " 保存 " 按钮，就可将系统的注册表保存到硬盘上。
    完成上述步骤后，找到刚才保存备份文件的那个文件夹，就会发现备份好的文件已经放在文件夹中了。
    （ 2 ）在 DOS 下备份注册表
    当注册表损坏后， WINDOWS （包括 " 安全模式 " ）无法进入，此时该怎么办呢？在纯 DOS 环境下进行注册表的备份、恢复是另外一种补救措施，下面来看看在 DOS 环境下，怎样来备份、恢复注册表。
    在纯 DOS 下通过注册表编辑器备份与恢复注册表前面已经讲解了利用注册表编辑器在 WINDOWS 环境下备份、恢复注册表，其实 "Regedit.exe" 这个注册表编辑器不仅能在 WINDOWS 环境中运行，也能在 DOS 下使用。
    虽然在 DOS 环境中的注册表编辑器的功能没有在 WINDOWS 环境中那么强大，但是也有它的独到之处。比如说通过注册表编辑器在 WINDOWS 中备份了注册表，可系统出了问题之后，无法进入 WINDOWS ，此时就可以在纯 DOS 下通过注册表编辑器来恢复注册表。
    应该说在 DOS 环境中备份注册表的情况还是不多见的，一般在 WINDOWS 中备份就行了，不过在一些特殊的情况下，这种方式就显得很实用了。
    进入 DOS 后，再进入 C 盘的 WINDOWS 目录，在该目录的提示符下输入 "regedit" 后按回车键，便能查看 "regedit" 的使用参数。
    通过 "Regedit" 备份注册表仍然需要用到 "system.dat" 和 "user.dat" 这两个文件，而该程序的具体命令格式是这样的：
    Regedit /L:system /R:user /E filename.reg Regpath
    参数含义：
    /L ： system 指定 System.dat 文件所在的路径。
    /R ： user 指定 User.dat 文件所在的路径。
    /E ：此参数指定注册表编辑器要进行导出注册表操作，在此参数后面空一格，输入导出注册表的文件名。

    Regpath ：用来指定要导出哪个注册表的分支，如果不指定，则将导出全部注册表分支。在这些参数中， "/L ： system" 和 "/R ： user" 参数是可选项，如果不使用这两个参数，注册表编辑器则认为是对 WINDOWS 目录下的 "system.dat" 和 "user.dat" 文件进行操作。如果是通过从软盘启动并进入 DOS ，那么就必须使用 "/L" 和 "/R" 参数来指定 "system.dat" 和 "user.dat" 文件的具体路径，否则注册表编辑器将无法找到它们。

    比如说，如果通过启动盘进入 DOS ，则备份注册表的命令是 "Regedit /L:C:\windows\/R:C:\windows\/e regedit.reg", 该命令的意思是把整个注册表备份到 WINDOWS 目录下，其文件名为 "regedit.reg" 。而如果输入的是 "regedit /E D:\regedit.reg" 这条命令，则是说把整个注册表备份到 D 盘的根目录下（省略了 "/L" 和 "/R" 参数），其文件名为 "Regedit.reg" 。

    （ 3 ）用注册表检查器备份注册表
    在 DOS 环境下的注册表检查器 Scanreg.exe 可以用来备份注册表。
    命令格式为：
    Scanreg /backup /restore /comment

    参数解释
    /backup 用来立即备份注册表
    /restore 按照备份的时间以及日期显示所有的备份文件
    /comment 在 /restore 中显示同备份文件有关的部分

    注意：在显示备份的注册表文件时， 压缩 备份的文件以 .CAB 文件列出， CAB 文件的后面单词是 Started 或者是 NotStarted ， Started 表示这个文件能够成功启动 Windows ，是一个完好的备份文件， NotStarted 表示文件没有被用来启动 Windows ，因此还不能够知道是否是一个完好备份。

    比如：如果我们要查看所有的备份文件及同备份有关的部分，命令如下： Scanreg /restore /comment

六、使用技巧
    上面介绍的都是概念上的东东，下面让我们实际操作吧
    1. 加快开机及关机 速度
        在 [ 开始 ]-->[ 运行 ]--> 键入 [Regedit]-->[HKEY_CURRENT_USER]-->[Control Panel]-->[Desktop] ，将字符串值 [HungAppTimeout] 的数值数据更改为 [200], 将字符串值 [WaitToKillAppTimeout] 的数值数据更改为 1000. 另外在 [HKEY_LOCAL_MACHINE]-->[System]-->[CurrentControlSet]-->[Control] ，将字符串值 [HungAppTimeout] 的数值数据更改为 [200] ，将字符串值 [WaitToKillServiceTimeout] 的数值数据更改 1000

    2. 自动关闭停止响应程序
        在 [ 开始 ]-->[ 运行 ]--> 键入 [Regedit]-->[HKEY_CURRENT_USER]-->[Control Panel]-->[Desktop] ，将字符串值 [AutoEndTasks] 的数值数据更改为 1 ，重新启动即可

    3. 清除 内存 内被不使用的 DLL 文件
        在 [ 开始 ]-->[ 运行 ]--> 键入 [Regedit]-->[HKKEY_LOCAL_MACHINE]-->[SOFTWARE]-->[Microsoft]-->[Windows]-->[CurrentVersion] ，在 [Explorer] 增加一个项 [AlwaysUnloadDLL] ，默认值设为 1 。注：如由默认值设定为 [0] 则代表停用此功能

    4. 加快菜单显示速度
        在 [ 开始 ]-->[ 运行 ]--> 键入 [Regedit]-->[HKEY_CURRENT_USER]-->[Control Panel]-->[Desktop] ，将字符串值 [MenuShowDelay] 的数值数据更改为 [0] ，调整后如觉得菜单显示速度太快而不适应者可将 [MenuShowDelay] 的数值数据更改为 [200] ，重新启动即可

    5. 禁止修改用户文件夹
        找到 HKEY_CURRENT_USERSoftwareMicrosoftWindowsCurrentVersionPoliciesExplorer 。如果要锁定 “ 图片收藏 ” 、 “ 我的文档 ” 、 “ 收藏夹 ” 、 “ 我的音乐 ” 这些用户文件夹的物理位置，分别把下面这些键设置成 1 ： DisableMyPicturesDirChange ， DisablePersonalDirChange ， DisableFavoritesDirChange ， DisableMyMusicDirChange

    6. 减小浏览局域网的延迟时间
        和 Windows 2000 一样， XP 在浏览局域网时也存在烦人的延迟问题，但介绍这个问题的资料却很难找到。如果你浏览一台 Win 9x 的机器，例如，在网上邻居的地址栏输入 “\computername” ， XP 的机器会在它正在连接的机器上检查 “ 任务计划 ” 。这种搜索过程可能造成多达 30 秒的延迟。如果你直接打开某个共享资源，例如在网上邻居的地址栏输入 “\computernameshare” ，就不会有这个延迟过程。要想避免 XP 搜索 “ 任务计划 ” 的操作，提高浏览网络的 速度 ，你可以删除 HKEY_LOCAL_MACHINESOFTWAREMicrosoftWindowsCurrentVersionExplorerRemoteComputerNameSpace{D6277990-4C6A-11CF-8D87-00AA0060F5BF} 子键。该键的类型是 REG_SZ

    7. 屏蔽系统中的热键
        点击 “ 开始 ”→“ 运行 ” ，输入 Regedit ，打开注册表编辑器。然后依次打开到 HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer ，新建一个双 字节 值，键名为 “NoWindows Keys” ，键值为 “1” ，这样就可以禁止用户利用系统热键来执行一些禁用的命令。如果要恢复，只要将键值设为 0 或是将此键删除即可

    8. 关闭不用的共享
        安全问题一直为大家所关注，为了自己的系统安全能够有保证，某些不必要的共享还是应该关闭的。用记事本编辑如下内容的注册表文件，保存为任意名字的 .Reg 文件，使用时双击即可关闭那些不必要的共享

        Windows Registry Editor Version 5.00
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters]
        "AutoShareServer"=dword:00000000
        "AutoSharewks"=dword:00000000

        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa]
        "restrictanonymous"=dword:00000001

    9. 让 IE 支持多 线程 下载
        一般情况下，大家都使用 多线程 下载软件如 Flashget 等下载文件，其实 IE 也可以支持多线程下载的，只是微软将这个功能给藏了起来。我们把它给挖出来就可以使用了。打开注册表编辑器，在注册表 HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings 下新建双 字节 值项 “MaxConnectionsPerServer” ，它决定了最大同步下载的连线数目，一般设定为 5 ～ 8 个连线数目比较好。另外，对于 HTTP 1.0 服务器 ，可以加入名为 “MaxConnectionsPer1_0Server” 的双字节值项，它也是用来设置最大同步下载的数目，也可以设定为 5 ～ 8 。

    10. 让 WINDOWS XP 自动登陆
        打开： HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon ，在右边的窗口中的新建字符串 "AutoAdminlogon" ，并把他们的键值为 "1" ，并且把 “DefaultUserName” 的值设置为用户名，并且另外新建一个字符串值 “DefaultPassword” ，并设其值为用户的密码

七、我们来让我们的系统瘦瘦身
    删除多余的虚拟光驱图标
    当我们在系统中安装了虚拟光驱后， “ 我的电脑 ” 中就会多出一个光盘图标，即便日后你不再使用虚拟光驱，虚拟光驱图标还会继续保留，实在没有必要。我们动手来删除这个多余的虚拟光驱图标：单击 “ 开始 → 运行 ” ，输入 “regedit” ，按下 “ 确定 ” 键后打开注册表编辑器，依次展开 HKEY_LOCAL_MACHINE\Enum\ SCSI 分支，在 SCSI 子键下通常有两个子键，它们分别对应着虚拟光驱和物理光驱，把 SCSI 下的子键全部删除，重新启动电脑后虚拟光驱图标就会被删除。
    删除多余的系统级图标
    系统级图标是指在安装 Windows 时由系统自动创建的图标，如回收站、收件箱、网上邻居等，其中有些图标对用户来说并无用处，但这些图标无法直接删除。打开注册表编辑器，依次展开 HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\
    explorer\Desktop\NameSpace 分支，然后删除不需要的子键。关闭注册表编辑器，重新启动电脑后，你会发现桌面上不需要的系统级图标已经消失了。
    删除 “ 运行 ” 中多余的选项
    如果你多次使用 “ 开始 → 运行 ” 菜单，会发现它的 “ 打开 ” 窗口被一大堆不再需要的命令弄得凌乱不堪。打开注册表编辑器，依次展开 HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU 分支，将右侧窗口的相关键值删除即可。
    删除 “ 查找 ” 中多余的选项
    依次展开 HKEY_USER\.Default\Software\Microsoft\Windows\CurrentVersion\Explorer\ Doc -FindSpecMRU 分支，将右侧窗口中的相关键值删除即可。
    删除多余的键盘**
    Windows 试图成为世界的宠儿，因此其键盘**适合于各国各类人的使用习惯。打开注册表编辑器，依次展开 HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\KeyboardLayouts 分支，我们可以看到该分支下保存了西班牙语 ( 传统 ) 、丹麦语、德语 ( 标准 ) 等多种键盘**，如果你用不到这些语言的键盘**，完全可以直接删除这些子键。

    删除多余的区域设置
    与上述键盘**相类似的还有 Windows 的区域设置，在注册表编辑器中展开 HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Nls\Locale 分支，简体中文使用者完全可以只保留 “00000804” 键值，其他可以毫不留情地删除。

八、高级篇
    1 、自动清除登录窗口中上次访问者的用户名
        通常情况下，用户在进入 WINNT 网络之前必须输入自己的用户名称以及口令。但是当你重新启动计算机，登录 WINNT 时， WINNT 会在缺省情况下将上一次访问者的用户名自动显示在登录窗口的 “ 用户名 ” 文本框中。这样一来，有些非法用户可能利用现有的用户名来猜测其口令，一旦猜中的话，将会对整个计算机系统产生极大的安全隐患。为了保证系统不存在任何安全隐患，我们可以通过修改 WINNT 注册表的方法来也提供了启动时自动以某一个组的用户名称和口令进行访问 WINNT ，而不需要通过人工设置的方法来自动清除登录窗口中上次访问者的用户名信息。要实现自动清除功能，必须要进行如下配置：
          A 、在开始菜单栏中选择运行命令，在随后打开的运行对话框里输入 REGEDIT 命令，从而打开注册表编辑器。
        B 、在打开的注册表编辑器中，依次展开以下的键值：　 [HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\WINLOGON]
        C 、在编辑器右边的列表框中，选择 “DONTDISPLAYLASTUSERNAME” 键值名称，如果没有上面的键值，可以利用 “ 编辑 ” 菜单中的 “ 新建 ” 键值命令添加一个，并选择所建数据类型为 “REG_SZ” 。
        D 、选择指定的键值并双击，当出现 “ 字符串编辑器 ” 对话框时，在 “ 字符串 ” 文本框中输入 “1” ，其中 “1” 代表起用该功能， “0” 代表禁止该功能。
        E 、当用户重新启动计算机登录 WINNT 时， NT 登录对话框中的 “ 用户名 ” 文本框中将是空白的。

    2 、为一些非 SCSI 接口 光驱进行手工配置
        如果你想在 WINNT 上安装一个非 SCSI 接口的光驱，在 WINNT 版本较高的计算机中这中类型的光驱可能被自动识别并自动由计算机来完成其安装任务，不巧的是，你的计算机中安装了一个低版本的操作系统，例如安装了 WINNT3.5 ，还没有时间来升级，但现在就着急用光驱呢，那该怎么办才好呢？不急，虽然 Windows NT3.5 不能自动识别非 SCSI 接口的光驱，但我们可以通过手工安装的方式来帮你轻松搞定这个小问题，具体工作步骤为：
        A 、首先必须将你手中的对应的非 SCSI 接口的 CD- ROM 驱动程序从安装盘拷贝到 WINNT\SYSTEM32\DRIV ERS 目录下。
        B 、在 WINNT 主群组中打开 Setup 图标。
        C 、从 OPTION 菜单中选择 “Add/Remove SCSI Adapters” 。
        D 、用鼠标单击 ADD 按钮，为你的非 SCSI 接口 CD-ROM 选择对应的驱动程序。
        E 、接着单击 “INSTALL” 按钮进行一些相关参数的配置。
        F 、退出 Windows NT ，重新启动计算机后光驱就会有用了。
    3 、增加 NTFS 性能
        如果用户想增加 NTFS 的性能，也可以通过修改注册表的方法来达到目的，具体实现步骤如下：
        A 、打开注册表编辑器，并在编辑器中依次展开以下键值： HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
        B 、在注册表编辑器中用鼠标单击 “ 编辑 ” 菜单，并在下拉菜单中选择 “ 新建 ” 菜单项，并在其弹出的子菜单中单击 “DWORD 值 ” 。
        C 、 在编辑器右边的列表中输入 DWORD 值的名称为 “NtfsDisableLastAccessUpdate” 。
        D 、 接着用鼠标双击 NtfsDisableLastAccessUpdate 键值，编辑器就会弹出一个名为 “ 字符串编辑器 ” 的对话框，在该对话框的文本栏中输入数值 “1” ，其中 0 代表 “ 取消 ” 该项功能， 1 代表 “ 启用 ” 该项功能。
        E 、设置好后，重新启动计算机就会使上述功能有效。
    4 、修复镜像组
        A 、当镜像磁盘组中的驱动器发生故障时，系统自动向其余的驱动器发出发送数据请求，留下工作驱动器单独运行。此时，用户需要进入 Disk Administrator ，选择镜像组，再选择 FaultTolerance/Break Mirror ，将镜像组分为两个独立部分。
        B 、工作的驱动器得到磁盘组所用的驱动器盘符，故障驱动器得到系统的下一个有效盘符。关闭 NT Server ，更换一个相同型号的硬盘驱动器。
        C 、重新启动 NT Server ，运行 Disk Administor ，在新驱动器上选择分区和未用空间，选择 Fault Tolerance/Establish Mirror 即可对新驱动器作镜像。
    5 、自定义启动信息
        每次当 WINNT 启动时，它都会显示 “ 请按 CTRL+ALT+DELETE 键来登录 ” 的信息，而如果你希望用户在按完 CTRL+ALT+DELETE 键后，画面上自动显示用户自己希望所看到的信息，可以通过如下的相关设置来进行：
        A 、在开始菜单栏中选择运行命令，在随后打开的运行对话框里输入 REGEDIT 命令，从而打开注册表编辑器。
        B 、在打开的注册表编辑器中，依次展开以下的键值：　 [HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\WINLOGON]
        C 、在编辑器右边的列表框中，选择 “LEGALNOTICECAPTION” 键值名称，如果没有上面的键值，可以利用 “ 编辑 ” 菜单中的 “ 新建 ” 键值命令添加一个，并选择所建数据类型为 “REG_SZ” 。
        D 、选择指定的键值并双击，当出现 “ 字符串编辑器 ” 对话框时，在 “ 字符串 ” 文本框中输入用户希望看到的信息窗口的标题内容，例如输入 “WINNT 网络 ” 。
        E 、接着在下面一个 “ 字符串 ” 文本框中输入信息窗口要显示的具体内容，例如输入 “ 欢迎使用 WINNT 网络 ” 。
        F 、重新启动计算机后，再次登录进 WINNT 网络时，用户将会看到自己在上面设置的内容。
    6 、加速文件管理系统缓存
        大家知道计算机的速度 有很大一部分与内存 相关，如果内存容量大一点，计算机运行速度就会相应快一点。但是假设在内存一定的情况下，如何来提高计算机的运行速度呢？这就是我们下面通过注册表设置要实现的内容，具体步骤如下：
        A 、在开始菜单栏中选择运行命令，在随后打开的运行对话框里输入REGEDIT 命令，从而打开注册表编辑器。
        B 、在打开的注册表编辑器中，依次展开以下的键值：　 [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management] 。
        C 、在编辑器右边的列表框中，选择“IoPageLockLimit” 键值名称，如果没有上面的键值，可以利用“ 编辑” 菜单中的“ 新建” 键值命令添加一个，并选择所建数据类型为“DWORD” 。
        D 、选择指定的键值并双击，当出现“ 字符串编辑器” 对话框时，在“ 字符串” 文本框中输入用户需要的数值，系统默认缓存为512K ，其他的参考值如下：
        RAM (MB) IoPageLockLimit 　 32 　 4096000 　 64 　 8192000 　 128 　 16384000 　 256+ 　 65536000
        E 、当用户重新启动计算机登录WINNT 时，文件管理系统缓存将得到改善。
    7 、增加“ 关闭系统” 按钮
        在NT 计算机中，“ 关闭系统” 按钮作为缺省值在登陆对话框中提供，这个任务按钮允许用户不必先登陆即可关闭系统。在NT SERVER 中虽然没有这个功能，但可以通过修改注册表，使系统在登陆对话框中增加一个“ 关闭系统” 的按钮，具体操作方法如下：
        A 、打开注册表编辑器，并在编辑器中依次展开以下键值：　 [HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\WINLOGON] 。
        B 、在编辑器右边的列表中用鼠标选择“SHUTDOWNWITHOUTLOGON” 键值。
        C 、接着用鼠标双击“SHUTDOWNWITHOUTLOGON” 键值，编辑器就会弹出一个名为“ 字符串编辑器” 的对话框，在该对话框的文本栏中输入数值“1” ，其中0 代表取消“ 关闭系统” 按钮，1 代表增加“ 关闭系统” 按钮。
        D 、退出后重新登录，在登录的界面中会增加一个“ 关闭系统” 的按钮。
    8 、在NT 下创建一个镜像集
        A 、先用Disk Administerator 创建镜像集的第一个分区表，选中该分区，在另一个磁盘驱动器内的磁盘空间的未用区域上进行Ctrl ＋鼠标单击操作，以把未用的磁盘区域和第一个分区均选上。
        B 、从Disk Ad ministor 的Fault Tolerlance( 容错) 菜单中选中Establish Mirror( 建立镜像 ) ，Disk Administor 将在被选自由盘区外创建一个磁盘分区。该分区与原有分区一样大，并包含原分区表上所有数据的备份。
        C 、如果要取消镜像集( 并非删除镜像集) ，即仅仅停止两个分区之间的数据复制，只需从Disk Administor 中选择Fault Tolerance/Break Mirror 。
    9 、登录局域网 超时 自动断开
        在登录 Windows NT 网络时，有可能用户不小心输错了登录参数或其他原因，导致了登录网络可能需要花费好长时间，这种情况是我们不想看到的。为了解决这种问题，我们可以通过注册表，来配置为闲置超时断开，以分钟为单位，具体步骤为：
        A 、打开注册表编辑器，并在编辑器中依次展开以下键值： 　 [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters]
        B 、在编辑器右边的列表中用鼠标选择 “AUTOD ISC ONNECT” 键值。
        C 、接着用鼠标双击 “AUTODI SCO NNECT” 键值，编辑器就会弹出一个名为 “ 字符串编辑器 ” 的对话框，在该对话框的文本栏中输入数值 “1” ，其中 0 代表取消自动断开功能， 1 代表使用自动断开功能。
        D 、退出后重新登录网络，上述功能就会生效。
    10 、改变 远程访问 服务的缺省端口传输 速度
        Windows NT 远程访问服务为每个 RAS 串行端口设置两种 BPS 速度： 载波 BPS 与联接 BPS 速度，前者是指两个 Modem 通过电话线传输数据的速度，后者则指 Modem 与主机串口间的数据传输速度；当远程服务被启动时，计算机首先将其联接 BPS 速度值存放于 \System Root\\System32\RAS\Modem.INF 文件中，以 MAXC ARRIERBPS 参数形式存放，然后将该值保存在 RASSERIAL.INF 文件中，以后每次进行传输时对串口作初始化，只需改变 SERIAL.INI 文件，即可改变串口传输速度，具体操作方法如下：
        A 、将 SERIAL.INI 文件用编辑器打开。
        B 、将 INITIALBPS 参数改为自己所希望的数值。
        C 、将上述改动保存成一个文件，文件名仍为 SERIAL.INI 。
        D 、打开 “ 开始 ” 菜单，并单击 “ 运行 ” 命令，在运行栏中输入 RasAdmin 命令。
        E 、从 服务器 菜单中选择 “Stop Remote Access Service” ，再选择 “Start Remote Access Service” ，上述设置就会生效。 自动检测慢网登陆
    上面我们曾经说过，在登录 NT 网络时有可能很慢。同样地，如果 Windows NT 检测速度有困难，可以取消。具体实现步骤为：
        A 、打开注册表编辑器，并在编辑器中依次展开以下键值：
        [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
        B 、在编辑器右边的列表中用鼠标选择 “SlowLinkDetectEnabled” 键值，如果没有该键值，必须新建一个 DWORD 值，名称设置为 “SlowLinkDetectEnabled” 。
        C 、接着用鼠标双击 “SlowLinkDetectEnabled” 键值，编辑器就会弹出一个名为 “ 字符串编辑器 ” 的对话框，在该对话框的文本栏中输入数值 “1” ，其中 0 代表取消自动检测慢网登陆功能， 1 代表使用自动检测慢网登陆功能。
        D 、退出后重新登录网络，上述设置就会起作用。
    12 、加快网络传输 速度
        对于拨号用户来说，时间就是金钱，怎样才能节约时间，节省金钱呢？回答是提高网络传输速度。那又如何提高网络传输速度呢？大家知道，网络速度主要是受网络 带宽 限制的。增加带宽不是拨号用户所能做到的，他们唯一能做的就是把 调制 解调器的传输速度能够再提高一点。其实拨号用户还可以从计算机本身运行速度出发，尽量能挖掘计算机在网络加速方面最大的潜能。下面我们就通过一些设置来尽量加快网络传输速度，具体设置如下：
        A 、在开始菜单栏中选择运行命令，在随后打开的运行对话框里输入 REGEDIT 命令，从而打开注册表编辑器。
        B 、在打开的注册表编辑器中，依次展开以下的键值：　 [HKEY_LOCAL_MACHINE\System\Current Control Set\Services\Class\NetTrans00n ] ，其中 n 表示个别拔号网络连接项号码。
        C 、在编辑器右边的列表框中，选择 “MaxMTU” 键值名称，如果没有上面的键值，可以利用 “ 编辑 ” 菜单中的 “ 新建 ” 键值命令添加一个，并选择所建数据类型为 “DWORD” 值。
        D 、选择指定的键值并双击，当出现 “ 字符串编辑器 ” 对话框时，在 “ 字符串 ” 文本框中输入 “576” ， 576 代表最大传输 单元 值。
        E 、接着在编辑器菜单栏中依次选择 “ 编辑 ”→“ 新增 ”→“ 字符串值 ” ，右边列表窗口就会多出一个新字符串，把它 命名为 “MaxSSS” ，再双按这个字符串值并把它设定为 “536” 。
        F 、重新返回到编辑器的主操作界面，并依次展开如下键值： [HKEY_LOCAL_MACHINE\System\Current Control Set\Services\VxD\MS TCP ] 。
        G 、按照上述同样的操作方法，在编辑器右边的列表中依次添加字符串值 “DefaultRcvWindow” 、 “DefaultTTL” ，并且把它们的数值分别设置为 “2144” ， “64” 。
        H 、当用户重新启动计算机登录 WINNT 时，上述所有的设置将会生效，这样计算机将会发挥它在网络加速方面最大的能量。
    13 、自动登陆网络
        通常情况下，用户在进入 WINNT 网络之前必须输入自己的用户名称以及口令。但是 WINNT 也提供了启动时自动以某一个组的用户名称和口令进行访问 WINNT ，而不需要通过人工设置的方法来输入登陆网络的参数。要实现自动登陆功能，必须要进行如下配置：
        A 、打开注册表编辑器，并在编辑器中依次展开以下键值：
        [HKEY_LOCAL_MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENT VERSION\WINLOGON]
        B 、用鼠标单击右边的 “AUTOADMINLOGON” 键值名称，编辑器就会弹出一个名为 “ 字符串编辑器 ” 的对话框，在该对话框的文本栏中输入数值 “1” 。
        C 、接着再用鼠标选择右边的 “DEFAULTDOMAINNAME” 键值名称，并在随后弹出的文本栏中输入所要登陆的域名名称或所要访问的计算机名称，例如输入 “DOMAIN” 域或 “COM” 计算机名称，然后单击 “ 确定 ” 按钮。
        D 、按照同样的操作方法，选择右面的 “DEFAULTUSERNAME” 键值名称，并在 “ 字符串 ” 文本框中输入登陆网络的用户名称，例如输入管理员名称 “ADMINISTRATOR” ，并单击 “ 确定 ” 按钮。
        E 、最后在注册表编辑器中，用鼠标单击 “ 编辑 ” 菜单并在下拉菜单中选择 “ 新建键值 ” 命令，然后在注册表右边的列表中，输入键值名称为 “DEFAULTPASSWORD” ，键值类型为 “REG_SZ” ，接着单击 “ 确定 ” 按钮。
        F 、 用鼠标双击 “DEFAULTPASSWORD” 键值，在弹出的对话框中输入用户的密码，在这里我们输入系统管理员的口令作为登陆网络的密码，输入完成后单击 “ 确定 ” 按钮结束设置工作。
        G 、 让计算机重新启动，缺省设置的用户将会自动登陆到指定的网络中去。
        如果用户日后不再需要自动登陆功能时，只需要把 “AUTOADMINLOGON” 的键值改为数值 “0” 即可。
    14 、禁止光盘的自动运行功能
        大家都很清楚每当光盘放到计算机中时， WINNT 就会执行自动运行功能，光盘中的应用程序就会被自动运行，而我们在实际工作中有时不需要这项功能，那么如何屏蔽该功能呢。此时，我们同样可以修改注册表使此功能失效，具体做法如下：
        A 、打开注册表编辑器，并在编辑器中依次展开以下键值： 　 [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Cdrom] 。
        B 、在编辑器右边的列表中用鼠标选择 “AUTORUN” 键值。
        C 、接着用鼠标双击 “AUTORUN” 键值，编辑器就会弹出一个名为 “ 字符串编辑器 ” 的对话框，在该对话框的文本栏中输入数值 “0” ，其中 0 代表 “ 禁用 ” 光盘的自动运行功能， 1 代表 “ 启用 ” 光盘的自动运行功能。
        D 、设置好后，重新启动计算机就会使上述功能有效。
    15 、取消系统检测串口，提高 NT 系统启动 速度
        计算机每次启动都会对计算机的硬件要重新检测一遍，这需要花费一定的时间，也因此就减慢了计算机的启动速度。在这里笔者向大家介绍一下通过一些设置来取消系统检测串口，从而达到提高 NT 系统启动速度的目的，具体步骤如下：
        A 、在开始菜单中，用查找的方法将 Boot.INI 文件找出来，然后将该文件的 “ 只读 ” 属性屏蔽掉，以便于我们在其中进行一些相关改动。
        B 、接着用一个文本编辑器将 Boot.INI 文件打开，并修改 [operating system] 段的内容，将其中每一行后加上 NoserialMice 参数，如下所示：
        修改 Boot.INI 文件，
        　　 ……
        [operating system]
        multi(0) disk(0) rdisk(0)
        partition(1)\WINNT40="Windows NT
        Workstation Version4.0"/NoSerialMice 　 ……
        C 、把上述修改的内容保存起来，文件名仍为 Boot.INI 。
        D 、退出 Windows NT ，重新启动计算机后上述配置就会生效。
        为什么系统越来越慢？
        为了保障安全，笔者在机房中每台电脑上都安装了KV2004 杀毒软件。经过一段时间的使用，确实起到了防杀病毒的作用。但没过多久，老师和学生都纷纷向我抱怨，反映机器的运行速度 越来越慢，就连运行一些常用软件如Word 、Excel 都变得极其缓慢，有时需要等半分钟以上。
        笔者考虑故障可能是因为长时间没有进行磁盘碎片整理造成的，于是对每台计算机进行了碎片整理，问题并没有解决。以前未安装KV2004 杀毒软件时，从没出现过这样的问题，看来故障就是由杀毒软件引起的。在打开Word 、Excel 等应用程序时，KV2004 杀毒软件都要进行扫描 ，扫描完成后要运行的软件才能被完全打开。但是，也不能为了提高速度就卸载杀毒软件啊！这时，笔者突然想到了“ 任务管理器” 。Windows 2000/XP 中的“ 任务管理器” 是一个很实用的小工具，它可以结束没有响应的进程 、查询CPU 和内存 的使用情况，还有一个功能就是设置任务的优先级。我们机房里学生机的操作系统恰恰都是Windows 2000 ，教师机的操作系统是Windows XP 。这下有办法了，我们就用“ 任务管理器” 中设置优先级的功能解决前面的问题。
        以Windows XP 为例，首先打开“ 任务管理器” 。在“ 应用程序” 选项页中找到正在运行的Word 、Excel 或其他应用程序，单击鼠标右键选择“ 转到进程 ” 。当然，也可以直接在“ 进程” 选项页中找到正在运行的应用程序，并单击鼠标右键选择“ 设置优先级” （见附图），设置为“ 高于标准” 。再用同样的方法找到KV2004 杀毒软件的“ 优先级” ，将其设置为“ 低于标准” 即可。设置完成之后，再运行软件时，Word 、Excel 等应用软件就会先运行，然后再运行KV2004 。经测试，打开文档速度 果然加快了。
        　　“ 任务管理器” 的功能还有很多。当系统因运行某个软件而变慢，而结束该软件依然没有得到改善时，可以尝试“ 结束进程树” ，会有更好的效果，因为“ 结束进程树” 是把和这个软件相关的所有前台、后台的程序都结束了。在“ 进程” 中，我们还可以查看计算机是否被感染了病毒，例如在“ 进程” 中有“Msblaster.exe” 运行，那么你的电脑很可能被“ 冲击波” 感染了，赶快杀毒吧。
