名字
       rpm - RPM 软件包管理器

语法
   查询软件包：
       rpm {-q|--query} [select-options] [query-options]

   校验软件包：
       rpm {-V|--verify} [select-options] [verify-options]

   安装软件包：
       rpm {-i|--install} [install-options] PACKAGE_FILE ...

   升级软件包：
       rpm {-U|--upgrade} [install-options] PACKAGE_FILE ...

   更新软件包：
       rpm {-F|--freshen} [install-options] PACKAGE_FILE ...

   卸载软件包：
       rpm {-e|--erase} [--allmatches] [--nodeps] [--noscripts] [--notriggers] [--test] PACKAGE_NAME ...

   其他杂项：
       rpm {--querytags|--showrc}
       rpm {--setperms|--setugids} PACKAGE_NAME ...


   select-options
        [PACKAGE_NAME] [-a,--all] [-f,--file FILE] [-g,--group GROUP] [-p,--package PACKAGE_FILE]
        [--hdrid SHA1] [--pkgid MD5] [--tid TID] [--querybynumber HDRNUM]
        [--triggeredby PACKAGE_NAME] [--whatprovides CAPABILITY] [--whatrequires CAPABILITY]

   query-options
        [--changelog] [-c,--configfiles] [--conflicts] [-d,--docfiles] [--dump] [--filesbypkg]
        [-i,--info] [--last] [-l,--list] [--obsoletes] [--provides] [--qf,--queryformat QUERYFMT]
        [-R,--requires] [--scripts] [-s,--state] [--triggers,--triggerscripts]

   verify-options
        [--nodeps] [--nofiles] [--noscripts] [--nodigest] [--nosignature] [--nolinkto] [--nofiledigest]
        [--nosize] [--nouser] [--nogroup] [--nomtime] [--nomode] [--nordev] [--nocaps]

   install-options
        [--allfiles] [--badreloc] [--excludepath OLDPATH] [--excludedocs] [--force] [-h,--hash]
        [--ignoresize] [--ignorearch] [--ignoreos] [--includedocs] [--justdb] [--nocollections] [--nodeps]
        [--nodigest] [--nosignature] [--noorder] [--noscripts] [--notriggers] [--oldpackage] [--percent]
        [--prefix NEWPATH] [--relocate OLDPATH=NEWPATH] [--replacefiles] [--replacepkgs] [--test]


描述
       rpm 是一个强大的软件包管理器，可以用来构建、安装、查询、校验、升级、卸载单独的软件包。
       一个"包"包括文件的归档以及用来安装和卸载归档中文件的元数据。
       元数据包括辅助脚本、文件属性、以及相关的描述性信息。
       软件包有两种：
       二进制包，用来封装已经编译好的二进制文件；
       源代码包，用来封装源代码和要构建二进制包需要的信息。

       必须选择下列"模式"之一：
       Query(查询), Verify(校验), Install/Upgrade/Freshen(安装/升级/更新), Uninstall(卸载),
       Set Owners/Groups(设置属主/属组), Show Querytags(显示查询标记), Show Configuration(显示配置)

   通用选项
       下列选项可以用于所有不同的模式。

       -?, --help
              打印详细的帮助信息

       --version
              打印一行详细的版本号信息

       --quiet
              输出尽可能少的信息，通常只有错误信息才会显示出来。

       -v     输出冗余信息，例如进度之类的信息。

       -vv    输出大量冗长的调试信息

       --rcfile FILELIST
              FILELIST 中冒号分隔的每个文件都被 rpm 按顺序读取，从中获得配置信息。
              只有列表中的第一个文件必须存在，波浪线将被替换为 $HOME 。默认值是：
              /usr/lib/rpm/rpmrc:/usr/lib/rpm/redhat/rpmrc:/etc/rpmrc:~/.rpmrc

       --pipe CMD
              将 rpm 的输出通过管道送到 CMD 命令。

       --dbpath DIRECTORY
              使用 DIRECTORY 中的数据库，而不是默认的 /var/lib/rpm

       --root DIRECTORY
              以 DIRECTORY 作为根文件系统进行操作。这意味着将使用 DIRECTORY 中的数据库来进行依赖性检测，
              并且任何操作(比如安装时的 %post 和构建时的 %prep)都将 chroot 到 DIRECTORY 下执行。

       -D, --define='MACRO EXPR'
              将 MACRO 宏的值定义为 EXPR

       --undefine='MACRO'
              撤销 MACRO 宏

       -E, --eval='EXPR'
              打印出值 EXPR 对应的宏

   安装/升级/更新选项
       下列选项中的 PACKAGE_FILE 既可以是二进制的 rpm 文件，
       也可以是 ASCII 格式的软件包清单文件(manifest)(参见"包选择选项")。
       并且可以指定为 ftp 或 http 的 URL ，在这种情况下，会在安装或升级前自动下载指定的文件。
       详见"FTP/HTTP 选项"以了解 rpm 内部对 ftp 与 http 客户端的支持。

       安装一个新软件包的一般形式是：

       rpm {-i|--install} [install-options] PACKAGE_FILE ...

       安装或升级软件包到新版本[与安装类似，只是所有其他版本都将被移除]：

       rpm {-U|--upgrade} [install-options] PACKAGE_FILE ...

       更新软件包到新版本[仅当系统中确实存在老版本时，才会升级软件包，否则什么也不做]：

       rpm {-F|--freshen} [install-options] PACKAGE_FILE ...

       [注意]下文中只要提到"升级"，就同时包含了"更新"在内。也就是说"更新"只是"升级"的一种特例。

       --allfiles
              安装或升级软件包中所有文件，即使它们可能应该被跳过。

       --badreloc
              与 --relocate 搭配使用，允许重新定位所有文件的路径，
              而不仅仅是二进制包中重定位提示(hint)包含的那些 OLDPATH 。

       --excludepath OLDPATH
              不安装名字以 OLDPATH 开头的文件。

       --excludedocs
              不安装任何被标记为文档的文件(包括手册页和 texinfo)。

       --force
              与同时使用 --replacepkgs, --replacefiles, --oldpackage 的效果相同。

       -h, --hash
              在包被解压时，输出50个井号(#)，与 -v|--verbose 配合使用，得到漂亮一点的输出。

       --ignoresize
              安装前不检查已挂载文件系统的空闲空间是否够用。

       --ignorearch
              允许安装或升级，即使二进制包的硬件架构与主机不匹配。

       --ignoreos
              允许安装或升级，即使二进制包的操作系统与主机不匹配。

       --includedocs
              安装文档文件。这是默认行为。

       --justdb
              只更新数据库，而不更新文件系统。

       --nodigest
              读取时不校验包或头部的摘要信息。

       --nomanifest
              不将非包文件(non-package file)当做软件包清单文件(manifest)处理。

       --nosignature
              读取时不校验包或头部的签名。

       --nodeps
              在安装或升级前，不进行依赖性检测。

       --noorder
              不为安装重排序。通常软件包列表会被重排序，以满足依赖关系。

       --noscripts
       --nopre
       --nopost
       --nopreun
       --nopostun
              不执行对应的程序/脚本。
              单独的一个 --noscripts 等价于同时使用 --nopre --nopost --nopreun --nopostun 的组合。
              它将会把 %pre, %post, %preun, %postun 段对应的程序/脚本全部关闭。

       --notriggers
       --notriggerin
       --notriggerun
       --notriggerprein
       --notriggerpostun
              不执行任何对应的触发程序/脚本。
              单独的一个 --notriggers 等价于同时使用 --notriggerprein --notriggerin --notriggerun --notriggerpostun 的组合。
              它将会把 %triggerprein, %triggerin, %triggerun, %triggerpostun 段对应的程序/脚本全部关闭。

       --oldpackage
              允许用旧软件包替换新软件包。

       --percent
              打印从软件包中解压文件的百分比。这是为了使 rpm 在其他工具中运行时更简单一些。

       --prefix NEWPATH
              对于可重定位的包，将把软件包重定位提示中所有以安装前缀(prefix)开头的文件路径转换为以 NEWPATH 开头。

       --relocate OLDPATH=NEWPATH
              对于可重定位的二进制包，将软件包重定位提示中所有以 OLDPATH 开头的文件路径转换为以 NEWPATH 开头。
              如果软件包中有多个 OLDPATH 要重定位的话，这一选项可以使用多次。

       --replacefiles
              强制安装软件包，即使它将覆盖其他已安装软件包的文件。

       --replacepkgs
              强制安装软件包，即使其中有些软件包已经被安装到了系统中。

       --test 不安装软件包，仅仅检测并报告可能的冲突。

   卸载选项
       卸载命令的一般形式是

       rpm {-e|--erase} [--allmatches] [--nodeps] [--noscripts] [--notriggers] [--test] PACKAGE_NAME ...

       同时还可以用下列选项：

       --allmatches
              删除匹配 PACKAGE_NAME 的软件包的所有版本。
              默认情况下，如果 PACKAGE_NAME 匹配多个软件包将导致错误。

       --nodeps
              在卸载前不检测依赖关系。

       --noscripts
       --nopreun
       --nopostun
              不执行对应的程序/脚本。
              单独的一个 --noscripts 等价于同时使用 --nopreun --nopostun 的组合。
              它将会把 %preun, %postun 段对应的程序/脚本全部关闭。

       --notriggers
       --notriggerun
       --notriggerpostun
              不执行任何对应的触发程序/脚本。
              单独的一个 --notriggers 等价于同时使用 --notriggerun --notriggerpostun 的组合。
              它将会把 %triggerun, %triggerpostun 段对应的程序/脚本全部关闭。

       --test 并不真正卸载任何东西，仅仅尝试它们。与 -vv 选项联合使用，在调试时很有用。

   查询选项
       查询命令的一般形式是

       rpm {-q|--query} [select-options] [query-options]

       还可以使用下面的选项指定软件包信息的输出格式：

        --qf|--queryformat QUERYFMT

       QUERYFMT 是格式字符串，是标准的 printf(3) 格式的修改版本。
       格式包括静态字符串(包括标准的C语言转义字符、新行符、跳格以及其他特殊字符)以及 printf(3) 类型标记。
       因为 rpm 已知输出类型，所以应当忽略类型标记，转而使用包含在 {} 中的头部标记名来代替。
       标记名是大小写无关的，并且标记名中以 RPMTAG_ 开头的部分可以被忽略。

       可选的输出格式可以使用":tag"这样格式的标记表示。当前支持的标记如下：

       :armor     以 ASCII 形式编码的公钥
       :arraysize 在数组标记中显示单元数目
       :base64    使用 base64 编码二进制数据
       :date      使用 strftime(3) 的 "%c" 格式
       :day       使用 strftime(3) 的 "%a %b %d %Y" 格式
       :depflags  格式化依赖比较操作符
       :deptype   格式化依赖类型
       :expand    对宏进行展开
       :fflags    格式化文件标记
       :fstate    格式化文件状态
       :fstatus   格式化文件校验状态
       :hex       以16进制格式化
       :octal     以八进制格式化
       :perms     格式化文件权限
       :pgpsig    显示签名指纹和时间
       :shescape  对单引号进行转义(为了可以在脚本中使用)
       :triggertype 显示触发器后缀
       :vflags    文件校验标记
       :xml       以 XML 格式编码数据

       例如，只输出所查询的软件包的名称，可以使用 %{NAME} 作为格式化字符串。
       要分两列输出软件包名称和发行版信息，可以用 %-30{NAME}%{DISTRIBUTION}
       如果使用 --querytags 参数，rpm 将输出它已知的所有标记列表。

       查询的选项有两个子集：选择选项和查询选项。

   包选择选项[子集1]

       PACKAGE_NAME
              查询名称为 PACKAGE_NAME 的已安装软件包

       -a, --all
              查询所有已安装的软件包

       -f, --file FILE
              查询 FILE 所属的软件包

       -g, --group GROUP
              查询属组为 GROUP 的软件包

       --hdrid SHA1
              查询包含特定头部标识符的软件包。也就是不可变头部区域的 SHA1 摘要信息。

       -p, --package PACKAGE_FILE
              查询未安装的软件包(PACKAGE_FILE)。
              如果 PACKAGE_FILE 是一个 ftp/http 协议的 URL ，软件包头部将被下载并查询。
              详见"FTP/HTTP 选项"以了解 rpm 内部对 ftp 与 http 客户端的支持。
              如果 PACKAGE_FILE 不是二进制文件，那么将被当作 ASCII 格式的软件包清单文件(除非使用了 --nomanifest 选项)。
              清单文件中以'#'开头的是注释行，其他每行都可以包含以空格分隔的 glob 表达式(包括 URL)，
              这些 glob 表达式将被扩展为路径，取代软件包清单文件，作为查询的附加 PACKAGE_FILE 参数。

       --pkgid MD5
              查询含有特定标识符的软件包。也就是包的头部以及有效内容的 MD5 摘要信息。

       --querybynumber HDRNUM
              直接查询第 HDRNUM 个数据库入口，仅用于调试。

       --specfile SPECFILE
              解析并查询 SPECFILE ，就好像它是一个软件包。尽管并非所有信息都可获得(比如文件清单)，
              但这种查询允许 rpm 从 spec 文件中抽取信息，而不必自己再去写一个解析器。

       --tid TID
              查询包含给定 TID 事务标识符的软件包。当前使用 unix 时间戳作为事务标识符。
              任何在一次事务中安装或卸载的软件包都拥有相同的标识符。

       --triggeredby PACKAGE_NAME
              查询被软件包 PACKAGE_NAME 触发的软件包。

       --whatprovides CAPABILITY
              查询提供了 CAPABILITY 功能的软件包。

       --whatrequires CAPABILITY
              查询所有需要 CAPABILITY 功能才能运行的软件包。

   包查询选项[子集2]

       --changelog
              显示软件包的变更信息

       -c, --configfiles
              只显示配置文件(隐含 -l)

       --conflicts
              显示此软件包与哪些功能有冲突

       -d, --docfiles
              只显示文档文件(隐含 -l)

       --dump 转储文件下列信息(隐含 -l)：path size mtime digest mode owner group isconfig isdoc rdev symlink

       --filesbypkg
              列出每个所选软件包中的文件

       -i, --info
              显示软件包信息，包括名称、版本、描述。
              如果同时还使用了 --queryformat 选项，那么就按照它指定的格式显示。

       --last 列出软件包时以安装时间排序，最新的在上面。

       -L, --licensefiles
              只显示许可证文件(隐含 -l)

       -l, --list
              列出软件包中的文件

       --obsoletes
              列出被此软件包废弃的软件包

       --provides
              列出软件包提供的功能

       -R, --requires
              列出此软件包所依赖的功能(通常是一个软件包)

       --scripts
              列出软件包自定义的小程序/脚本，他们是安装和卸载等过程的一部分。

       -s, --state
              显示软件包中文件的状态(隐含 -l)。状态是 normal, not installed, replaced 之一。

       --triggers, --triggerscripts
              显示软件包中包含的触发脚本，如果有的话。

   校验选项
       校验命令的一般形式是

       rpm {-V|--verify} [select-options] [verify-options]

       校验软件包，是指将已安装的文件信息与保存在 rpm 数据库中的元数据(来自于rpm包)进行比较。
       校验将会比较每个文件的大小、摘要信息(哈希值)、权限、类型、属主与属组。任何不一致的地方都将被显示出来。
       软件包中未安装的文件(例如在安装过程中使用"--excludedocs"跳过的文档)，将被忽略。

       软件包的选择选项与软件包查询选项是相同的(包括以清单文件作为参数)。其他独有的选项包括：

       --nodeps
              不校验软件包的依赖关系

       --nodigest
              读取时不校验软件包或头部的摘要信息(哈希值)

       --nofiles
              不校验文件的任何属性

       --noscripts
              不执行 %verifyscript 小程序/脚本(如果有的话)。

       --nosignature
              读取时不校验软件包或头部签名

       --nolinkto
       --nofiledigest (以前是 --nomd5)
       --nosize
       --nouser
       --nogroup
       --nomtime
       --nomode
       --nordev
              不校验相应的文件属性

       输出是9个字符的字符串，可能的属性标记为：

       c %config 配置文件
       d %doc 文档文件
       g %ghost 占位文件，也就是文件内容不包含在软件包有效内容里面
       l %license 许可证文件
       r %readme 说明文件

       从头部开始，接下来是文件名，每9个字符表示将文件属性与数据库中记录的值进行比较的结果。
       一个单独的"."表示测试通过了，一个单独的"?"表示测试可能无法进行(例如，文件禁止了读权限)。
       最后，粗体的字母表示相应的 --verify 测试失败了：

       S 大小不一致
       M 模式不一致(包括权限和文件类型)
       5 MD5校验和不一致
       D 主/次设备号不匹配
       L readLink(2) 路径不匹配
       U User 属主不一致
       G Group 属组不一致
       T mTime 不一致
       P 功能不一致


   杂项命令
       rpm --showrc
              显示 rpm 使用的、在 rpmrc 和 macros 配置文件中定义的选项的值。

       rpm --setperms PACKAGE_NAME
              设置 PACKAGE_NAME 软件包中的文件权限

       rpm --setugids PACKAGE_NAME
              设置 PACKAGE_NAME 软件包中的属主/属组


   FTP/HTTP 选项
       rpm 内置 FTP/HTTP 客户端，可以查询或安装互联网上的软件包。
       可以安装、升级、查询用 URL 指定的软件包文件，比如：

       ftp://USER:PASSWORD@HOST:PORT/path/to/package.rpm

       如果省略 :PASSWORD 部分，将为每个用户名/主机对提示一次密码。
       如果忽略了用户名和密码，将使用匿名FTP。在所有情况下，都会使用被动FTP(PSAV)。

       rpm 允许在使用 ftp URL 时使用下面的选项：

       --ftpproxy HOST
              使用主机 HOST 作为所有 FTP 传输的代理服务器，允许通过防火墙代理访问 FTP 。
              这个选项也可以用宏 %_ftpproxy 指定。

       --ftpport PORT
              连接到 FTP 代理服务器的 PORT 端口，而不是默认端口。
              这个选项也可以用宏 %_ftpport 指定。

       rpm 允许在使用 http URL 时使用下面的选项：

       --httpproxy HOST
              使用主机 HOST 作为所有 HTTP 传输的代理服务器，允许通过防火墙代理访问 HTTP 。
              这个选项也可以用宏 %_httpproxy 指定。

       --httpport PORT
              连接到 HTTP 代理服务器的 PORT 端口，而不是默认端口。
              这个选项也可以用宏 %_httpport 指定。

历史遗留问题
   执行 rpmbuild
       rpm "构建模式"以被移至 /usr/bin/rpmbuild 可执行文件中。
       请参见 rpmbuild(8) 文档了解详情。

文件
   rpmrc 配置文件
       /usr/lib/rpm/rpmrc
       /usr/lib/rpm/redhat/rpmrc
       /etc/rpmrc
       ~/.rpmrc

   Macro 配置文件
       /usr/lib/rpm/macros
       /usr/lib/rpm/redhat/macros
       /etc/rpm/macros
       ~/.rpmmacros

   数据库
       /var/lib/rpm/Basenames
       /var/lib/rpm/Conflictname
       /var/lib/rpm/Dirnames
       /var/lib/rpm/Group
       /var/lib/rpm/Installtid
       /var/lib/rpm/Name
       /var/lib/rpm/Obsoletename
       /var/lib/rpm/Packages
       /var/lib/rpm/Providename
       /var/lib/rpm/Requirename
       /var/lib/rpm/Sha1header
       /var/lib/rpm/Sigmd5
       /var/lib/rpm/Triggername

   临时文件
       /var/tmp/rpm*

参见
       popt(3),
       rpm2cpio(8),
       rpmbuild(8),
       rpmdb(8),
       rpmkeys(8),
       rpmsign(8),
       rpmspec(8),

       rpm --help

       http://www.rpm.org/


Red Hat, Inc.                                   13 February 2014                                          RPM-4.11.2(8)

