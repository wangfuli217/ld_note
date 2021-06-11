名字
       rpmbuild - 创建 RPM 包

语法
   创建包
       rpmbuild {-ba|-bb|-bp|-bc|-bi|-bl|-bs} [rpmbuild-options] SPECFILE ...
       rpmbuild {-ta|-tb|-tp|-tc|-ti|-tl|-ts} [rpmbuild-options] TARBALL ...
       rpmbuild {--rebuild|--recompile} SOURCEPKG ...

   其他
       rpmbuild --showrc

   rpmbuild-options
        [--buildroot DIRECTORY] [--clean] [--nobuild]
        [--rmsource] [--rmspec] [--short-circuit]
        [--noclean] [--nocheck] [--target PLATFORM]


描述
       rpmbuild 用于创建软件的二进制包和源代码包。
       一个"包"包括文件的归档以及用来安装和卸载归档中文件的元数据。
       元数据包括辅助脚本、文件属性、以及相关的描述性信息。
       软件包有两种：
       二进制包，用来封装已经编译好的二进制文件；
       源代码包，用来封装源代码和要构建二进制包需要的信息。

       必须选择下列"模式"之一：
       (1)从 spec 构建, (2)从 Tar 构建, (3)重新构建, (4)重新编译, (5)显示配置

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
   (1,2)构建选项
       构建命令的一般形式是

       rpmbuild -bSTAGE|-tSTAGE [rpmbuild-options] FILE ...

       如果需要根据某个 spec 文件构建，那么使用 -b 参数。
       如果需要根据某个 tar 归档(可能是压缩过的)中的 spec 文件构建，那么使用 -t 参数。
       STAGE 指定了要完成的构建和打包的阶段，必须是下列其中之一：

       a    构建二进制包和源代码包(在执行 %prep, %build, %install 之后)
       b    构建二进制包(在执行 %prep, %build, %install 之后)
       p    执行 spec 文件的"%prep"阶段。这通常等价于解包源代码并应用补丁。
       c    执行 spec 文件的"%build"阶段(在执行了 %prep 之后)。这通常等价于执行了"make"。
       i    执行 spec 文件的"%install"阶段(在执行了 %prep, %build 之后)。这通常等价于执行了"make install"。
       l    执行一次"列表检查"。spec 文件的"%files"段落中的宏被扩展，检测是否每个文件都存在。
       s    只构建源代码包

       此外，还可以使用下列选项：

       --buildroot DIRECTORY
              在构建时，使用 DIRECTORY 目录覆盖默认的 BuildRoot 值

       --clean
              在打包完成之后删除构建树

       --nobuild
              不执行任何实际的构建步骤。可用于测试 spec 文件。

       --noclean
              不执行 spec 文件的"%clean"阶段(即使它确实存在)。

       --nocheck
              不执行 spec 文件的"%check"阶段(即使它确实存在)。

       --nodeps
              不检查编译依赖条件是否满足

       --rmsource
              在构建后删除源代码(也可以单独使用，例如"rpmbuild --rmsource foo.spec")

       --rmspec
              在构建之后删除 spec 文件(也可以单独使用，例如"rpmbuild --rmspec foo.spec")

       --short-circuit
              直接跳到指定阶段(也就是跳过指定阶段前面的所有步骤)，只有与 c 或 i 或 b 连用才有意义。
              仅用于本地调试。以此种方法构建出的包将被标记为"依赖关系不满足"，以阻止其被正常使用。

       --target PLATFORM
              在构建时，将 PLATFORM 解析为 arch-vendor-os ，并以此设置宏 %_target, %_target_cpu, %_target_os 的值。

   (3,4)重新构建和重新编译选项
       有两种构建方法：

       rpmbuild --rebuild|--recompile SOURCEPKG ...

       使用 --recompile 的话，rpmbuild 将安装指定的源代码包(SOURCEPKG)，然后进行准备、编译、安装。
       而使用 --rebuild 的话，还会在 --recompile 的基础上再额外构建一个新的二进制包。
       在构建结束时，构建目录将被删除(就好像用了 --clean)，源代码和 spec 文件也将被删除。

   (5)显示配置

       rpmbuild --showrc

       将显示 rpmbuild 使用的、在 rpmrc 和 macros 配置文件中定义的选项的值。

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

   临时文件
       /var/tmp/rpm*

参见
       gendiff(1),
       popt(3),
       rpm(8),
       rpm2cpio(8),
       rpmkeys(8)
       rpmspec(8),
       rpmsign(8),

       rpmbuild --help

       http://www.rpm.org/


Red Hat, Inc.                                   13 February 2014                                     RPMBUILD-4.11.2(8)