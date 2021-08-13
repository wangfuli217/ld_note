

pwd   显示当前所在目录, 查看当前所在目录的完整路径(绝对路径)。

cd    进入某目录, 显示或改变当前目录。
      CD 回车/cd ~    都是回到自己的主目录。
      cd .            当前目录(空格再加一个点)。
      cd -            去到上一次访问的目录。
      cd ..           回到上一级目录(空格再加两个点)。    cd ../..  向上两级。
      cd /user/s0807  从绝对路径去到某目录。
      cd ~/s0807      直接进入主目录下的某目录(“cd ~”相当于主目录的路径的简写)。


touch 如果文件/目录不存在, 则创建新文件/目录；如果文件存在, 那么就是更新该文件的最后访问时间,
      用法 touch [-acm] [-r ref_file] 文件...
           touch [-acm] [MMDDhhmm[yy]] 文件...
           touch [-acm] [-t [[CC]YY]MMDDhhmm[.SS]] file...

dir   —查看当前路径下的所有文件

mkdir 创建目录(必须有创建目录的权限)
      用法 mkdir [-m 模式] [-p] dirname ...
      mkdir dir1/dir2          在dir1下建dir2
      mkdir dir13 dir4 dir5    连建多个
      mkdir ~/games            用户主目录下建(默认在当前目录下创建)
      mkdir -p dir6/dir7/dir8  强制创建dir8；若没有前面的目录, 会自动创建dir6和dir7。
                               不用-p时, 若没有dir6/dir7, 则创建失败。

cp   复制文件/目录
     cp  源文件   目标文件     复制文件；若已有文件则覆盖
     cp -r 源目录 目标目录     复制目录；若已有目录则把源目录复制到目标目录下,
                               没有目标目录时, 相当于完全复制源目录, 只是文件名不同。
    参数解释:
        -a 做一个备份，这里可以不用这个参数，我们可以先备份整个test目录
		-a 该选项通常在拷贝目录时使用。它保留链接、文件属性，并递归地拷贝目录，其作用等于dpR选项的组合。
		-d 拷贝时保留链接。
        -f 强制覆盖，不询问yes/no（-i的默认的，即默认为交互模式，询问是否覆盖）
		-i 和f选项相反，在覆盖目标文件之前将给出提示要求用户确认。回答y时目标文件将被覆盖，是交互式拷贝。
        -r 递归复制，包含目录
        -p 保持新文件的属性不变

     如:
     cp beans apple dir2       把beans、apple文件复制到dir2目录下
     cp 1.c netseek/2.c        将1.c拷到netseek目录下并命名为2.c
     cp -i beans apple         增加是否覆盖的提示
     cp filename{,.bak}        快速备份或复制文件。
     cp -frp new/* old/        把 new 目录下的所有目录及文件覆盖 old 目录下的


mv 移动或重命名文件/目录
    用法 mv [-f] [-i] f1 f2
        mv [-f] [-i] f1 ... fn d1
        mv [-f] [-i] d1 d2
    mv 源文件名 目标文件名   若目标文件名还没有,则是源文件重命名为目标文件；若目标文件已存在, 则源文件覆盖目标文件。
    mv 源文件名 目标目录     移动文件
    mv 源目录 目标目录       若目标目录不存在, 则源目录重命名；若目标目录已存在, 则源目录移动到目标目录下。
 如: mv qib.tgz ../qib.tgz   移到上一级目录


rm  删除文件/目录
    用法 rm [-fiRr] 文件/目录,参数说明如下:
      -f, --force        强制删除。忽略不存在的文件, 不提示确认
      -i            在删除前需要确认
      -I            在删除超过三个文件或者递归删除前要求确认。此选项比-i 提示内容更少, 但同样可以阻止大多数错误发生
          --interactive[=WHEN]    根据指定的WHEN 进行确认提示：never, once (-I),
                    或者always (-i)。如果此参数不加WHEN 则总是提示
          --one-file-system        递归删除一个层级时, 跳过所有不符合命令行参
                    数的文件系统上的文件
          --no-preserve-roo    不特殊对待"/"
          --preserve-root    不允许删除"/"(默认)
      -r, -R, --recursive    递归删除目录及其内容
      -v, --verbose        详细显示进行的步骤
          --help        显示此帮助信息并退出
          --version        显示版本信息并退出

    用例:
    rm -rf 文件名    删除文件。
    rm -rf 目录名    删除目录。
    rm -f 文件       强制删除文件或者目录,无论是否有权限都可以
    rm -rf *         删除所有文件及目录

    要删除第一个字符为"-"的文件 (例如"-foo"), 请使用以下方法之一:
      rm -- -foo
      rm ./-foo


rmdir 删除空目录。只可以删除空目录。


ln 创建硬链接或软链接, 硬链接＝同一文件的多个名字；软链接＝快捷方式
    用法   ln [-f] [-n] [-s] f1 [f2]
          ln [-f] [-n] [-s] f1 ... fn d1
          ln [-f] [-n] -s d1 d2
    ln file1 file1.ln      创建硬链接。感觉是同一文件, 删除一个, 对另一个没有影响；须两个都删除才算删除。
    ln -s ../m/file1 file1.sln  创建软链接。可跨系统操作, 冲破操作权限；也是快捷方式。


ls    查看目录或者文件的属性, 列举出任一目录下面的文件
      用法  ls [-aAbcCdeEfFghHilLmnopqrRstux1@] [file...]
      语　　法：ls [-1aAbBcCdDfFgGhHiklLmnNopqQrRsStuUvxX][-I <范本样式>][-T <跳格字数>][-w <每列字符数>][--block-size=<区块大小>][--color=<使用时机>][--format=<列表格式>][--full-time][--help][--indicator-style=<标注样式>][--quoting-style=<引号样式>][--show-control-chars][--sort=<排序方式>][--time=<时间戳记>][--version][文件或目录...]

      补充说明：执行ls指令可列出目录的内容，包括文件和子目录的名称。
    参　　数：
      -1   每列仅显示一个文件或目录名称。
      -a或--all   下所有文件和目录。
      -A或--almost-all   显示所有文件和目录，但不显示现行目录和上层目录。
      -b或--escape   显示脱离字符。
      -B或--ignore-backups   忽略备份文件和目录。
      -c   以更改时间排序，显示文件和目录。
      -C   以又上至下，从左到右的直行方式显示文件和目录名称。
      -d或--directory   显示目录名称而非其内容。
      -D或--dired   用Emacs的模式产生文件和目录列表。
      -f   此参数的效果和同时指定"aU"参数相同，并关闭"lst"参数的效果。
      -F或--classify   在执行文件，目录，Socket，符号连接，管道名称后面，各自加上"*","/","=","@","|"号。
      -g   次参数将忽略不予处理。
      -G或--no-group   不显示群组名称。
      -h或--human-readable   用"K","M","G"来显示文件和目录的大小。
      -H或--si   此参数的效果和指定"-h"参数类似，但计算单位是1000Bytes而非1024Bytes。
      -i或--inode   显示文件和目录的inode编号。
      -I<范本样式>或--ignore=<范本样式>   不显示符合范本样式的文件或目录名称。
      -k或--kilobytes   此参数的效果和指定"block-size=1024"参数相同。
      -l   使用详细格式列表。
      -L或--dereference   如遇到性质为符号连接的文件或目录，直接列出该连接所指向的原始文件或目录。
      -m   用","号区隔每个文件和目录的名称。
      -n或--numeric-uid-gid   以用户识别码和群组识别码替代其名称。
      -N或--literal   直接列出文件和目录名称，包括控制字符。
      -o   此参数的效果和指定"-l" 参数类似，但不列出群组名称或识别码。
      -p或--file-type   此参数的效果和指定"-F"参数类似，但不会在执行文件名称后面加上"*"号。
      -q或--hide-control-chars   用"?"号取代控制字符，列出文件和目录名称。
      -Q或--quote-name   把文件和目录名称以""号标示起来。
      -r或--reverse   反向排序。
      -R或--recursive   递归处理，将指定目录下的所有文件及子目录一并处理。
      -s或--size   显示文件和目录的大小，以区块为单位。
      -S   用文件和目录的大小排序。
      -t   用文件和目录的更改时间排序。
      -T<跳格字符>或--tabsize=<跳格字数>   设置跳格字符所对应的空白字符数。
      -u   以最后存取时间排序，显示文件和目录。
      -U   列出文件和目录名称时不予排序。
      -v   文件和目录的名称列表以版本进行排序。
      -w<每列字符数>或--width=<每列字符数>   设置每列的最大字符数。
      -x   以从左到右，由上至下的横列方式显示文件和目录名称。
      -X   以文件和目录的最后一个扩展名排序。
      --block-size=<区块大小>   指定存放文件的区块大小。
      --color=<列表格式>   培植文件和目录的列表格式。
      --full-time   列出完整的日期与时间。
      --help   在线帮助。
      --indicator-style=<标注样式>   在文件和目录等名称后面加上标注，易于辨识该名称所属的类型。
      --quoting-syte=<引号样式>   把文件和目录名称以指定的引号样式标示起来。
      --show-control-chars   在文件和目录列表时，使用控制字符。
      --sort=<排序方式>   配置文件和目录列表的排序方式。
      --time=<时间戳记>   用指定的时间戳记取代更改时间。
      --version   显示版本信息。

      ls /etc/   显示某目录下的所有文件和目录, 如etc目录下的。
      ls -l      (list)列表显示文件(默认按文件名排序),
                 显示文件的权限、硬链接数(即包含文件数,普通文件是1, 目录1+)、用户、组名、大小、修改日期、文件名。
      ls -t      (time)按修改时间排序, 显示目录和文件。
      ls -lt     是“-l”和“-t”的组合, 按时间顺序显示列表。
      ls -F      显示文件类型, 目录“/ ”结尾；可执行文件“*”结尾；文本文件(none), 没有结尾。
      ls -R      递归显示目录结构。即该目录下的文件和各个子目录下的文件都一一显示。
      ls -a      显示所有文件, 包括隐藏文件。

    文件权限
        r    读权限。对普通文件来说, 是读取该文件的权限；对目录来说, 是获得该目录下的文件信息。
        w    写权限。对文件, 是修改；对目录, 是增删文件与子目录。
            (注 删除没有写权限的文件可以用 rm -f , 这是为了操作方便, 是人性化的设计)。
        x    执行权限；对目录, 是进入该目录
        -    表示没有权限
       形式 - rw- r-- r--
    其中 第一个是文件类型(-表普通文件, d表目录(directory), l表软链接文件(link))
    第2~4个是属主, 生成文件时登录的人, 权限最高, 用u表示(user)
    第5~7个是属组, 系统管理员分配的同组的一个或几个人, 用g表示(group)
    第8~10个是其他人, 除属组外的人, 用o表示(other)
    所有人, 包括属主、属组及其他人, 用a表示(all)

chmod  更改权限；
    用法    chmod [-fR] <绝对模式> 文件 ...
            chmod [-fR] <符号模式列表> 文件 ...
      其中  <符号模式列表> 是一个用逗号分隔的表     [ugoa]{+|-|=}[rwxXlstugo]
    chmod u+rw  给用户加权限。同理, u-rw也可以减权限。
    chmod u=rw  给用户赋权限。与加权限不一样, 赋权限有覆盖的效果。
    主要形式有如下几种
    chmod u+rw       chmod u=rw
    chmod u+r, u+w   chmod u+rw,g+w, o+r
    chmod u+x filenmame   # 只想给自己运行, 别人只能读
    chmod 777 (用数字的方式设置权限是最常用的)
    数字表示权限时, 各数位分别表示属主(user)、属组(group)及其他人(other)；
      其中, 1是执行权(Execute), 2是写权限(Write), 4是读权限(Read),
      具体权限相当于三种权限的数相加, 如7＝1+2+4, 即拥有读写和执行权。
    另外,临时文件/目录的权限为rwt, 可写却不可删,关机后自动删除；建临时目录:chmod 777 目录名, 再chmod +t 目录名。

df 查看文件系统, 查看数据区
    用法 df [-F FSType] [-abeghklntVvZ] [-o FSType 特定选项] [目录 | 块设备 | 资源]
    df -k   以kbytes显示文件大小的查看文件系统方式


echo  显示一行内容。

more  分屏显示文件的内容。适合于看大文件。
      用法   more [-cdflrsuw] [-行] [+行号] [+/模式] [文件名 ...]。
      显示7个信息:用户名 密码 用户id(uid) 组id(gid) 描述信息(一般为空) 用户主目录  login shell(登录shell)

cat   显示文件内容, 不分屏(一般用在小文件, 大文件显示不下)；合并文件, 仅在屏幕上合并, 并不改变原文件。
      用法 cat [ -usvtebn ] [-|文件] ...
      如:cat>1.c    //就可以把代码粘帖到1.c文件里, 按ctrl+d 保存代码。
      cat 1.c 或more 1.c     //都可以查看里面的内容。
      一般用作将很多小文件连成一个大文件: cat file* >newFile
head  输出文件的开头部分的内容
      如: head -3 a.txt # 显示最上面的3行。缺省是10行
      参数：
       -c, --bytes=[-]K  显示每个文件的前多少字节; 以“-”开头, 则显示到后多少字节; 数字后面可带k等参数表示大小,则显示多少个(一个中文算2～3个字节)。
                         如： head -c 10 test.txt # 显示文件的前10字节
                         head -c -1k test.txt # 显示到文件的后1K的内容
       -n, --lines=[-]K  显示每个文件的多少行;以“-”开头, 则显示到后多少行。
       -q, --quiet, --silent  不显示文件名(默认)。
       -v, --verbose     总是显示文件名。即在显示文件内容前多显示一行内容： ==> 文件名 <==
       --help 显示帮助信息
       --version   显示版本信息

tail  实时监控文件, 一般用在日志文件, 可以只看其中的几行。
      用法 tail [+/-[n][lbc][f]] [文件]
          tail [+/-[n][l][r|f]] [文件]
      如: tail -3 a.txt # 显示最下面的3行, 一般用作查看日志信息
      tail -f run.log  # 实时监控查看此文件

    长选项必须使用的参数对于短选项时也是必需使用的。
      -c, --bytes=K        输出最后K 字节；另外，使用-c +K 从每个文件的第K 字节输出
      -f, --follow[={name|descriptor}]
            即时输出文件变化后追加的数据。
                -f, --follow 等于--follow=descriptor
      -F        即--follow=name --retry
      -n, --lines=K    输出最后K 行，代替最后10 行；使用-n +K 从每个文件的第K 字节输出
          --max-unchanged-stats=N
                使用--follow=name, 重新打开一个在N(默认为5)
                    次迭代后没有改变大小的文件来看它是否被解除连
                    接或重命名(这是循环日志文件的通常情况)
          --pid=PID        同 -f 一起使用，当 PID 所对应的进程死去后终止
      -q, --quiet, --silent    不输出给出文件名的头
          --retry        即使目标文件不可访问依然试图打开；在与参数
                --follow=name 同时使用时常常有用。
      -s, --sleep-interval=秒数    同-f 一起使用，在迭代间暂停约指定秒数的时间
                    (默认1.0 秒)
      -v, --verbose        总是输出给出文件名的头
          --help        显示此帮助信息并退出
          --version        显示版本信息并退出


查找
find   查找文件(文件或者目录名以及权限属主等匹配搜索)
    用法 find  [-H | -L] 路径列表 谓词列表
    精确匹配: find . -name file1
    模糊匹配: find . -name "file*"  # 使用通配符要用双引号
    -name     按文件名查找
    -mtime 10 修改时间距今10天那天的文件, -10表10天以内, +10表超过10天的(10天前的)
    -user 0   表userid=0的文件, 即root的文件 （按用户查找）。如: find / -user 0 # 显示所有root用户的文件
    -size +400 表文件大小超过400个blok, 一个blok是512字节的文件, 即200K
    -print    打印
    -perm 777 权限是777的文件 （按文件权限查找）
    -type f   只查普通文件, （按文件类型查找）
    -atime +365 访问时间超过一年的 （按访问时间查找）
    -exec rm {} 执行删除操作, {}表示将前面的结果作为rm的参数
    如：
    find / -name perl 从根目录开始查找名为perl的文件。
    find . -mtime 10 -print 从当前目录查找距离现在10天时修改的文件, 显示在屏幕上。
           (注 “10”表示第10天的时候；如果是“+10”表示10天以外的范围；“-10”表示10天以内的范围。)

finger 可以让使用者查询一些其他使用者的资料
       如:finger     查看所用用户的使用资料
       finger root   查看root的资料

grep 文件中查找字符；有过滤功能, 只列出想要的内容
    用法  grep -hblcnsviw 模式 文件 . . .
    -?   同时显示匹配行上下的？行, 如：grep -2 pattern filename # 同时显示匹配行的上下2行。
    -b, --byte-offset            打印匹配行前面打印该行所在的块号码。
    -c, --count                  只打印匹配的行数, 不显示匹配的内容。
    -f File, --file=File         从文件中提取模板。空文件中包含0个模板, 所以什么都不匹配。
    -h, --no-filename            当搜索多个文件时, 不显示匹配文件名前缀。
    -i, --ignore-case            忽略大小写差别。
    -q, --quiet                  取消显示, 只返回退出状态。0则表示找到了匹配的行。
    -l, --files-with-matches     打印匹配模板的文件清单。
    -L, --files-without-match    打印不匹配模板的文件清单。
    -n, --line-number            在匹配的行前面打印行号。
    -s, --silent                 不显示关于不存在或者无法读取文件的错误信息。
    -v, --revert-match           反检索, 只显示不匹配的行。
    -w, --word-regexp            如果被\<和\>引用, 就把表达式做为一个单词搜索。
    -V, --version                显示软件版本信息。
    -r,                          显示文件名

    如:
    grep abc /etc/passwd    # 在passwd文件下找abc字符
    grep success * 　　        # 查找当前目录下面所有文件里面含有success字符的文件
    grep -ins -r "文件内容" *   # 查找文件(进入到文件里面, 查询包含此内容的文件)
    grep -l 'boss' *        # 显示所有包含boss的文件名。
    grep -n 'boss' file     # 在匹配行之前加行号。
    grep -i 'boss' file     # 显示匹配行，boss不区分大小写。
    grep -v 'boss' file     # 显示所有不匹配行。
    grep -q 'boss' file     # 找到匹配行，但不显示，但可以检查grep的退出状态。（0为匹配成功）
    grep -c 'boss' file     # 只显示匹配行数（包括0）。
    grep   "$boss" file     # 扩展变量boss的值再执行命令。
    ps -ef|grep "^*user1"   # 搜索user1的命令，即使它前面有零个或多个空格。
    ps -e|grep -E 'grant_server|commsvr|tcpsvr|dainfo' # 查找多个字符串的匹配（grep -E相当于egrep）

    # 输出匹配前后多行
    grep的A(after,后)和B(before,前)、C(center,前后)选项可以同时输出其匹配行的前后几行。
    grep -B1 -A2 "DMA" message.txt
    grep -C 5 foo file  显示file文件中匹配foo字串那行以及上下5行


wc 对单词进行统计
    -l 统计行数
    -w 统计单词数
    -c 统计字符数
    如  grep wang /etc/passwd|wc -l   # 统计passwd文件含“wang”的行数
    who | wc -l  # 当前登陆的用户数
    wc -l /etc/passwd # 当前注册的用户数


df 查看文件系统, 查看数据区
    用法 df [-F FSType] [-abeghklntVvZ] [-o FSType 特定选项] [目录 | 块设备 | 资源]
    df -k   以kbytes显示文件大小的查看文件系统方式


du 统计磁盘容量
    用法 du [-a] [-d] [-h|-k] [-r] [-o|-s] [-H|-L] [文件...]
    df -k 是对文件系统进行统计
    du 单位是512字节
    du -k 单位是K, 即1024字节
    du -s blog
    如: du -sk *   # 不加-s会显示子目录, -k按千字节排序


mount 加载一个硬件设备
      用法:mount [参数] 要加载的设备 载入点
      如: mount /dev/cdrom
      cd /mnt/cdrom  //进入光盘目录

    # 挂载到别人机上
    sudo mount //192.168.1.137/PythonProject/led /home/holemar/program/led -o iocharset=utf8 -o programrname="zxp",pa==
    sudo mount //192.168.1.101/Holemar/1.notes /home/holemar/program/notes -o iocharset=utf8 -o programrname="holemar",password="123"

    Mount挂载命令使用方法
    语法： mount -t 类型 -o 挂接方式 源路径 目标路径
    -t 详细选项:
          光盘或光盘镜像：iso9660
          DOS fat16文件系统：msdos
          Windows 9x fat32文件系统：vfat
          Windows NT ntfs文件系统：ntfs
          Mount Windows文件网络共享：smbfs（需内核支持）推荐cifs
          UNIX(LINUX) 文件网络共享：nfs
    -o 详细选项:
         loop ：用来把一个文件当成硬盘分区挂接上系统
         ro ：采用只读方式挂接设备
         rw ：采用读写方式挂接设备
         iocharset ：指定访问文件系统所用字符集,例如iocharset=utf8
         remount ：重新挂载
    使用实例:
        挂载windows文件共享:
          mount -t smbfs -o username=admin,password=888888 //192.168.1.2/c$ /mnt/samba
          mount -t cifs -o username=xxx,password=xxx //IP/sharename /mnt/dirname
        挂载Linux文件nfs共享:
          mount -t nfs -o rw 192.168.1.2:/usr/www /usr/www
        挂载ISO镜像:
          mount -o loop -t iso9660 /usr/mydisk.iso /home/ping.bao/cd
        挂载USB移动硬盘:
          mount -t ntfs /dev/sdc1 /root/usb
        挂载CDROM:
          mount /dev/cdrom /home/ping.bao/cd
        取消挂载:
          umount /dev/cdrom /home/ping.bao/cd
        单用户模式重新挂载根分区：
          mount -o remount,rw /

if 判断目录、文件是否存在
    myPath="/var/log/httpd/"
    myFile="/var/log/httpd/access.log"

    #这里的-x 参数判断$myPath是否存在并且是否具有可执行权限
    if [ ! -x "$myPath"]; then
    mkdir "$myPath"
    fi

    #这里的-d 参数判断$myPath是否存在
    if [ ! -d "$myPath"]; then
    mkdir "$myPath"
    fi
    # 判断当前目录下,是否有“logs”目录,没有则创建这目录
    if [ ! -d "logs" ]; then mkdir "logs"; fi;

    #这里的-f参数判断$myFile是否存在
    if [ ! -f "$myFile" ]; then
    touch "$myFile"
    fi

    #其他参数还有-n,-n是判断一个变量是否是否有值
    if [ ! -n "$myVar" ]; then
    echo "$myVar is empty"
    exit 0
    fi

    #两个变量判断是否相等
    if [ "$var1" = "$var2" ]; then
    echo '$var1 eq $var2'
    else
    echo '$var1 not eq $var2'
    fi


