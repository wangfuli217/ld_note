注释当前输入的命令（在开头添加#号)
ESC + # 或者 ALT + #

在文本编辑器中快速打开当前命令
CTRL + x CTRL + e # 当退出编辑器后，该命令会被自动执行。

esc . #使用上次命令的参数 
alt . #引用上次命令的参数，一直按. 继续向上查找参数

这些快捷键中, 有一个小规律, 对字符操作一般是C开头, 对单词操作一般是M开头.
SecureCRT：可以点 选项 -> 回话选项, 选择tab 终端->仿真->Emacs, 把"使用Alt键作为元键"打勾
gnome-terminal：编辑 -> 键盘快捷键, 把＂启用菜单快捷键＂前面的勾去掉.
cmd(功能强大){
% history |
> awk '{CMD[$2]++;count++;}END \
> { for (a in CMD)print CMD[a] " " \
> CMD[a]/count*100 "% " a;}' |
> grep -v "./" |
> column -c3 -s " " -t |
> sort -nr |
> nl |
> head -n10
}
ls -l | grep Mar

cmd(使用 ^ 删掉多余部分){
grep fooo /var/log/auth.log
^o
grep foo /var/log/auth.log
}
cmd(使用 ^old^new 换掉输错或输少的部分){
cat myflie
^li^il
cat myfile
ansible vod -m command -a 'uptim'
^im^ime
ansible vod -m command -a 'uptime'
}
cmd(使用 !:gs/old/new 将 old 全部换成 new){
ansible nginx -m command -a 'which nginx' 
!:gs/nginx/squid 
ansible squid -m command -a 'which squid' 
^nginx^squid^:G # zsh
}

^foo        #删除上一条命令中的foo
^foo^bar    #将上一条命令的第一个foo改为bar
    
cmd(忘记历史，就是背叛){
了解历史记录的大小
echo $HISTSIZE # 历史记录的保存位置
echo $HISTFILE # /home/xiaodong/.zhistory
echo $HISTFILESIZE # bash # 历史记录的保存大小
echo $SAVEHIST     # zsh

history                # 查看历史
history | less         # 查看历史
history 5              # 查看历史
history | grep string  # 查看历史

% (reverse-i-search)'h': history 5 # 使用 Ctrl + r 逆向搜索历史命令
[Ctrl + p] 使用 Ctrl + p 访问上一条命令
[Ctrl + n] 使用 Ctrl + n 访问下一条命令

!!        # 使用 !! 执行上一条命令
sudo !!   # 使用 !! 执行上一条命令

!his
history     # 使用 !foo 执行以 foo 开头的命令

% !?is
echo $histchars # 使用 !?foo 执行包含 foo 的命令

% !10 
vim lib/TunePage.pm # 使用 !n 执行第 n 个命令

% !-2
htop  # 使用 !-n 执行倒数第 n 个命令
}
关于历史引用，要记住的是：
    !!          #重新执行上一条命令
    !N          #重新执行第N条命令
    !-N         #重新执行倒数第N条命令
    !string     #重新执行以字符串开头的命令
    !?string?   #重新执行包含字符串的命令
    !$          #上一条命令的最后一个参数
    !^          #上一条命令的第一个参数
    !cmd:n      #上一条命令的第n个参数
    !*          #上一条命令的所有参数
    !*:x        # x表示修饰符
        :s/old/new/ 对第N条指令中第一次出现的new替换为old
        :gs/old/new/ 全部替换
        :n 取指令的第w个参数
        :p 回显命令而不是执行
        :h 选取路径部分dirname
        :t 选取文件名部分basename
        :r 选取文件名filename
        :e 选取扩展名
    
历史命令 Word 选取图
ansible vod -m command -a 'uptime'
   0     1   2    3     4    5
         ^   2    -     4    $
                  3          *
                  *
cmd(使用 !# 引用当前行){
cp filename filename.old
cp filename !#:1.old
}

cmd(通过 !$ 得到上一条命令的最后一位参数){
% mkdir videos 
% cd !$
}
cmd(通过 !^ 得到上一条命令的第一个参数){
% ls /usr/share/doc /usr/share/man
% cd !^
}
cmd(通过 !:n 得到上一条命令第 n 个参数){
% touch foo.txt bar.txt baz.txt 
% vim !:2 
vim bar.txt
}
cmd(通过 !:x-y 得到上一条命令从 x 到 y 的参数){
% touch foo.txt bar.txt baz.txt 
% vim !:1-2 
vim foo.txt bar.txt
}
cmd(通过 !:n* 得到上一条命令从 n 开始到最后的参数){
% cat /etc/resolv.conf /etc/hosts /etc/hostname
% vim !:2*
vim /etc/hosts /etc/hostname
}
cmd(通过 !* 得到上一条命令的所有参数){
% ls code src 
% cp -r !*
}
关于 Word 选取，要记住的是：
        n
        ^|$
        [n]*
        x-y
    % !an:$
    % !10:2-4
    % !{an}2
    
cmd(利用 :h 选取路径开头){
% ls /usr/share/fonts/truetype
% cd !$:h
cd /usr/share/fonts
    相当于 dirname
}    
cmd(利用 :t 选取路径结尾){
% wget http://nginx.org/download/nginx-1.4.7.tar.gz
% tar zxvf !$:t
tar zxvf nginx-1.4.7.tar.gz
    相当于 basename
}  
cmd(利用 :r 选取文件名){
% unzip filename.zip 
% cd !$:r 
cd filename
}  
cmd(利用 :e 选取扩展名){
% echo abc.jpg 
% echo !$:e 
echo .jpg # bash 
.jpg 
echo jpg # zsh 
jpg
}  
cmd(利用 :p 打印命令行){
% echo *
README.md css img index.html js
% !:p
echo *
}  
cmd(利用 :s 做替换){
% echo this that
% !:s/is/e
echo the that
    惯用法: ^is^e
}
cmd(利用 :g 做全局操作){
% echo abcd abef
% !:gs/ab/cd
echo cdcd cdef
cdcd cdef
}
关于修饰符，要记住的是：
    h|t
    r|e
    p
    s
    g
    
cmd(使用 {} 构造字符串){
% cp file.c file.c.bak
% cp file.c{,.bak}
% echo cp file.c{,.bak}
% vim {a,b,c}file.c
vim afile.c bfile.c cfile.c
% vim [abc]file.c  # ?
% vim {a..c}file.c # bash

% wget http://linuxtoy.org/img/{1..5}.jpg
1.jpg  2.jpg  3.jpg  4.jpg  5.jpg
% touch {01..5}.txt
01.txt  02.txt  03.txt  04.txt  05.txt
% touch {1..10..2}.txt
1.txt  3.txt  5.txt  7.txt  9.txt
% echo {1..10..-2} # zsh
9 7 5 3 1
% echo {9..1..2}   # bash
9 7 5 3 1

% mkdir -p 2014/{01..12}/{baby,photo}
% echo {{A..Z},{a..z},{0..9}}
}
使用括号扩展（{...}）来减少输入相似文本，并自动化文本组合。
例如 mv foo.{txt,pdf} some-dir（同时移动两个文件），
     cp somefile{,.bak}（会被扩展成 cp somefile somefile.bak）或者 
     mkdir -p test-{a,b,c}/subtest-{1,2,3}（会被扩展成所有可能的组合，并创建一个目录树）

cmd(使用 `` 或 $() 做命令替换){
% grep -l error *.pm # (1)
TunePage.pm
% vim TunePage.pm    # (2)
% vim `grep -l error *.pm`
% vim $(grep -l error *.pm)
    嵌套时，$() 可读性更清晰，而 `` 则较差
% vim $(grep -l failed $(date +'%Y%m%d').log)
% vim `grep -l failed \`date +'%Y%m%d'\`.log`
}
cmd(使用 for ... in 重复执行命令){
% figlet -f font-type-1 Linux # (1)
% figlet -f font-type-2 Linux # (2)
% figlet -f font-type-3 Linux # (3)
% ...

% cd /usr/share/figlet
% for font in *.flf
> do
>   echo $font
>   figlet -f $font Linux
> done

% for font in *.flf; do echo $font; figlet -f $font Linux; done

% for dev in /dev/sd{a..d}
> do
>   hdparm -t $dev
> done
}

esc+f: 往右跳一个词
esc+b: 往左跳一个词
Alt + f(orward) 右向按单词前移（以空格，斜线，点号作为word边界)）
Alt + b(ackward) 左向按单词后移（以空格，斜线，点号作为word边界)）
    
cmd(Alt+.){
cp /somewhere/foo.c /somewhere/foo.c.orig 
vi /somewhere/foo.c

mv /somewhere/file /your/folder/ 
vi Alt-.file     # vi /your/folder/file 补全最后一个参数

mv /somewhere/file /your/folder/ 
vi Alt-1+Alt-.   # vi /somewhere/file  补全第一个参数
vi Alt-2+Alt-.   # 补全第二个参数
}
把命令当做注释 -> 依次按下 ctrl-a， #， enter 

!!：执行上一条命令
!blah：执行最近的以 blah 开头的命令，如 !ls
!blah:p：仅打印输出，而不执行
!$：上一条命令的最后一个参数，与 Alt + . 相同
!$:p：打印输出 !$ 的内容
!*：上一条命令的所有参数
!*:p：打印输出 !* 的内容
^blah：删除上一条命令中的 blah
^blah^foo：将上一条命令中的 blah 替换为 foo
^blah^foo^：将上一条命令中所有的 blah 都替换为 foo

Tab 补全
使用通配符 (* ? [a-z] [0-9])
用快捷键编辑命令行
字符串处理
复合命令 (; && ||)
