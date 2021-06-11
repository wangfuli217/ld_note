        operator   [number]   motion
operator - 操作符，代表要做的事情，比如 d 代表删除
[number] - 可以附加的数字，代表动作重复的次数
motion   - 动作，代表在所操作的文本上的移动，例如 w 代表单词(word)，$ 代表行末等等。
    
CTRL-G 显示当前编辑文件中当前光标所在行位置以及文件状态信息。

在一行内替换头一个字符串 old 为新的字符串 new，请输入  :s/old/new
在一行内替换所有的字符串 old 为新的字符串 new，请输入  :s/old/new/g
在两行内替换所有的字符串 old 为新的字符串 new，请输入  :#,#s/old/new/g
在文件内替换所有的字符串 old 为新的字符串 new，请输入  :%s/old/new/g
进行全文替换时询问用户确认每个替换需添加 c 标志        :%s/old/new/gc
          
v motion :w FILENAME ** # 具有选择性的保存命令
v motion 使用操作符 y 复制文本，使用 p 粘贴文本
 :r !dir 可以读取 dir 命令的输出并将其放置到当前文件的光标位置后面。

 colorscheme(){
:colorscheme            # 查看当前主题
:colorscheme space tab  # 列出所有主题
:colorscheme your-theme # 切换主题
 }

 
J(){
连接 [count] 行，但至少包含两行。删除缩进，插入不多于两个的空格。
}
U(){
输入 u 来撤消最后执行的命令，
输入 U 来撤消对整行的修改
} 
3a! == a!!!
":e!" 命令可以重新装载原来的文件
":q!" 放弃修改并退出

help vim-script-intro
help vimtutor # vimtutor zh
普通模式命令              (无)       :help x
可视模式命令               v_        :help v_u
插入模式命令               i_        :help i_<Esc>
命令行模式命令             :         :help :quit
命令行编辑                 c_        :help c_<Del>
Vim 命令参数               -         :help -r
选项                       ''         :help 'textwidth'

- 按下 <HELP> 键 (如果键盘上有的话)
- 按下 <F1> 键 (如果键盘上有的话)
- 输入  :help <回车>
vim --version # version 内部命令
help deleting 要知道如何删除文本
help index    要获得所有命令的帮助索引
help CTRL-A   控制字符的命令的帮助
help i_CTRL-H 插入模式的命令帮助
help -t       命令行参数
help 'number' 选项的帮助
help pattern<Tab>    寻找 "pattern" 开始的一个帮助标签
help pattern<Ctrl-D>  一次性列出所有匹配 "pattern" 的帮助标签
help 'subject' 选项 'subject'。 
help subject() 函数 "subject"。 
help -subject 命令行选项 "-subject"。 
help +subject 编译时特性 "+subject"
  :copen
  :cclose
  打开/关闭 quickfix 窗口；按 <Enter> 跳转到光标所在的项目上
Word(){
w 正向 [count] 个单词            [] 包括空格
W 正向 [count] 个字串
e 正向到第 [count] 个单词的尾部  () 不包括空格
E 正向到第 [count] 个字串的尾部
b 反向 [count] 个单词
B 反向 [count] 个字串
}
line(){
"$" 命令把光标移动到当前行行尾。
"^" 命令把光标移动到一行的第一个非空字符，
"0" 命令则移到一行的第一个字符
}
character(){ find to
"fx" 命令向前查找本行中的字符 x
"F" 命令用于向左查找
"tx" 命令只把光标移动到目标字符的前一个字符上
                Fh             fn
          <------------   ------------->
To err is human.  To really foul up you need a computer.                                                                    
           <------------  ------------->
                 Th              tn      
通过 ";" 命令重复，"," 命令则用于反向重复
}
parenthesis(){
"%" 是一个非常方便的命令： () [] 和 {} /* */  #if、#ifdef、#else、#elif、#endif
"50％" 移动到文件的中间，
"90%" 移到差不多结尾的位置
"H" 表示 "Home" (头)，"M" 表示 "Middle" (中) 而 "L" 表示 "Last" (尾)
}
position(){
使用 CTRL-G 命令
置位 'number' 选项
zt            将当前行移动到屏幕第一行
zz            将当前行移动到屏幕最中央
zb            将当前行移动到屏幕最下一行

zf      F-old creation (创建折叠):|zf| 操作符跟任何一个移动命令联用，为所经之处的文本创建一个折叠
zo      O-pen a fold (打开折叠) # 当前
zc      C-lose a fold (关闭折叠)# 当前
zr      这将减少 (R-educe) 折叠 # 本层
zm      这将折叠更多 (M-ore)    # 本层
zM      关闭所有折叠；          # 所有层
zR      打开所有折叠            # 所有层
za      打开或关闭当前折叠；
|zn| 命令快速禁止折叠功能。
|zN| 恢复原来的折叠
|zi| 切换于两者之间
打开所有光标行上的折叠用 |zO|。
关闭所有光标行上的折叠用 |zC|。
删除一个光标行上的折叠用 |zd|。
删除所有光标行上的折叠用 |zD|。

zfap 折叠一段
  :5,10fo  在vim中运行该命令会在折叠 5-10 行中的代码，可以用其它数字代替之。

foldmethod
当前窗口使用的折叠方式。可能的值是: 
|fold-manual|   manual      (不常用)手动建立折叠。
|fold-indent|   indent      (常用)相同缩进距离的行构成折叠。
|fold-expr|     expr        'foldexpr' 给出每行的折叠级别。 
|fold-marker|   marker      标志用于指定折叠。
|fold-syntax|   syntax      (不常用)语法高亮项目指定折叠。 
|fold-diff|     diff        (常用)没有改变的文本构成折叠。

:set foldcolumn=4
一个 "+" 表示某个关闭的折叠。
一个 "-" 表示每个打开的折叠的开头，
而 "|" 则表示该折叠内其余的行。
}

:set makeprg=nmake
:set makeprg=nmake\ -f\ project.mak
:set makeprg=make\ %
quickfix(makeprg,cindent,cinoptions){
:set cindent shiftwidth=4
==  gg=G

set cindent                                               # 使用 C/C++ 语言的自动缩进方式
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s     # 设置C/C++语言的具体缩进方式
cinoptions # http://vimcdoc.sourceforge.net/doc/indent.html#C-indenting

{directory}/indent/{filetype}.vim

:copen
:cclose
:cnext
:cprevious
:clist
:cfirst         到第一处错误
:clast          到最后一处错误
:cc 3           到第三处错误
}

au FileType perl,vim,c,cpp setlocal cinoptions=:0,g0,(0,w1 shiftwidth=4 tabstop=4 softtabstop=4
au FileType diff setlocal shiftwidth=4 tabstop=4

cpp(){
setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4

" cindent {{{
set cindent
set cinoptions=
set cinoptions+=t0
set cinoptions+=j1
set cinoptions+=m1
set cinoptions+=(s
set cinoptions+=N-s
" cindent }}}
}

c(){
setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4

" cindent {{{
set cindent
set cinoptions=
set cinoptions+=t0
set cinoptions+=j1
set cinoptions+=m1
set cinoptions+=(s
set cinoptions+=N-s
" cindent }}}
}
gnu(){
  setlocal expandtab
  setlocal sw=2 ts=8 tw=80
  setlocal cinoptions=>2s,e-s,n-s,{s,^-s,:s,=s,g0,+.5s,p2s,t0,(0,W2,u0,w1,m1,l1
  setlocal cindent
  setlocal fo-=t fo+=croql
  setlocal comments=sO:*\ -,mO:\ \ \ ,exO:*/,s1:/*,mb:\ ,ex:*/
  set cpo-=C
  # setlocal equalprg=~/src/gst/common/gst-indent\ 2>\ /dev/null
}

kernel(){

# linux kernel indenting style by default
setlocal tabstop=8
setlocal shiftwidth=8
setlocal softtabstop=8
setlocal textwidth=80
setlocal noexpandtab

setlocal cindent
setlocal formatoptions=tcqlron
setlocal cinoptions=:0,l1,t0,g0,(0
}
'ic' 'ignorecase'       查找时忽略字母大小写
'is' 'incsearch'        查找短语时显示部分匹配
'hls' 'hlsearch'        高亮显示所有的匹配短语
set nowrapscan 使得找到文件结尾后停止查找

CTAGS(){
$ sudo apt-get install exuberant-ctags
$ ctags --help  #检查ctags是否安装成功
$ ctags -R --languages=c --langmap=c:+.h -h +.h  #生成当前目录下所有C文件的标签文件tags
* :set tags?    查看VIM当前关联tags文件
* :set tags=... 设置VIM当前关联的tags文件，排在前面的tags文件优先级高
* :set tags+=.. 添加VIM当前关联的tags文件，排在前面的tags文件优先级高
* :set omnifunc=ccomplete#Complete
* CTRL+]        跳转到当前光标关键字的定义处
* gCTRL+]       如果有多个匹配位置，会提供选择跳转到哪个匹配处
* CTRL+t        回到上一个跳转处或回到最初位置
* :pop          反向遍历标签历史，相当于CTRL+t
* :tag          正向遍历标签历史
* :tselect      如果匹配不止一个，这个命令可查看匹配列表，并进行选择
* :tnext        跳转到下一个匹配位置
* :tprev        跳转到上一个匹配位置
* :tfirst       跳转到第一个匹配位置
* :tlast        跳转到最后一个匹配位置
* :tag keyword  无需移动光标版的CTRL+]，在输入keyword时，可以使用TAB键进行自动补全
* :tjump word   无需移动光标版的gCTRL+]
* :tag /phone$  关键字可以使用正则表达式，例如此处查找以phone结尾的关键字定义位置
* CTRL+n/CTRL+p 普通关键字补全，显示提示列表，同时有向下/下选择功能
* CTRL+xCTRL+n  当前缓冲区关键字补全
* CTRL+xCTRL+i  包含文件关键字补全
* CTRL+xCTRL+]  标签关键字补全
* CTRL+xCTRL+f  文件名补全
* CTRL+xCTRL+l  整行补全
* CTRL+xCTRL+k  字典补全
* CTRL+xCTRL+o  全能（Omni）补全，C语言可以补全结构体成员名称
* CTRL+e        放弃这次补全
}
SHELL(){
* :pwd :grep :make
* :vimgrep keyword **/*.c **/*.h   在当前以及所有子目录的.c和.h文件中查找keyword
* :copen        打开quickfix窗口,如果在某一项按Enter会打开对应的文件，如果这个文件已在某个窗口中打开，则会复用这个缓冲区
* :cclose       关闭quickfix窗口
* :colder       上一次quickfix结果
* :cnewer       新一次quickfix结果
* :cnext        跳转到quickfix列表的下一项，这个命令如此的常用，可将它映射成快捷键
* :cprev        跳转到quickfix列表的上一项
* :5cnext　　　　快速前进
* :5cprev       快速后退
* :cfirst       第一项
* :clast        最后一项
* :cnfile       下一个文件的第一项
* :cpfile       上一个文件的最后一项
* :cc N         跳转到第N项
* :lmake :lgrep :lvimgrep  会使用位置列表，区别在于在任意时刻，只能有一个quickfix列表，而位置列表要多少有多少重复
}

marker(){

# m<char>       用一个字符标记当前行
# '<char>       跳转到对应字符标记的行开头
# `<char>       跳转到对应字符标记所在行和列

# ``                          
# `用单引号 ' 也可以。  
# 如果再次执行这个命令你会跳回去原来的地方，这是因为 ` 记住了自己跳转前的位置。

`` 命令可以在两个位置上跳来跳去。
CTRL-O 命令则跳到一个 "较老" 的地方 older
CTRL-I 则跳到一个 "较新" 的地方 

# 命令 "ma" 用 a 标记当前的光标位置。你可以在文本中使用 26 个标记 (a 到 z)。
# 要跳到一个你定义的标记，可以使用命令 `{mark}，这里 {mark} 是指定义标记的那个字母 

# '       跳转前的光标位置
# "       最后编辑的光标位置
# [       最后修改的开始位置
# ]       最后修改的结束位置
}
"c"的作用方式与 "d" 操作符相似，只是完成后会切换到插入模式
输入 r 和一个字符替换光标所在位置的字符
输入大写的 R 可连续替换多个字符

按v选定后按=就是自动格式化代码,自动缩进,内部的递归的缩进
gg=G

通过计数前缀，"r" 命令可以使多个字符被同一个字符替换
To err is human  
  ------->
    c2wbe<Esc>
 c       修改操作符
 2w      移动两个单词的距离 (与操作符合起来，它删除两个单词并进入插入模式)
 be      插入 be 这个单词
 <Esc>   切换回普通模式  
 
 This is an examination sample of visual mode  
        ?     ---------->
                velllld
 This is an example of visual mode 
 
 
 要拷贝一行到剪贴板中：
        "*yy
要粘贴回来：
        "*p
这仅在支持剪贴板的 Vim 版本中才能工作

daw:"aw" 是一个文本对象。提示："aw" 表示 "A Word" (一个单词)
 "cis" 可以改变一个句子  "Inner Sentence" : as 包括句子后面的空白字符而 "is"不包括
 
:set tags=./tags,tags,/home/user/commontags

reg(){
"{a-zA-Z0-9.%#:-"}      指定下次的删除、抽出和放置命令使用的寄存器
#                        {a-zA-Z0-9.%#:-"} (大写字符使得删除和抽出命令附加到该
#                        寄存器) ({.%#:} 只能用于放置命令)。
#
#                                                        *:reg* *:registers*
#:reg[isters]            显示所有编号和命名寄存器的内容。但不列出用于 |:redir|
#                        目的地的寄存器。
#                        {Vi 无此功能}
#
#:reg[isters] {arg}      显示 {arg} 里提到的编号和命名寄存器的内容。
# ["x]yy                  抽出 [count] 行 [到寄存器 x] |linewise| 行动作。

无名寄存器("")
两个双引号，Vim中叫做无名寄存器。x,s,d,c,y等操作，如果不指定寄存器，都是将临时内容放到这个寄存器中，也就是相当于一个默认寄存器。

复制专用寄存器("0)
通过y命令复制的内容，会保存到寄存器0中。
寄存器的使用是通过"后面跟寄存器名字。

删除专用寄存器("1-"9)
通过d或c命令，删掉的内容，会保存打"1-"9这9个寄存器中。
最新删除的内容，会在"1中，其他顺延。

命名寄存器("a-"z)
可以将重要内容放到命名寄存器"a-"z中，一共26个。

黑洞寄存器("_d)
放到这个寄存器的内容，将不会放到任何其他寄存器中，相当于彻底删除内容。

系统剪贴板("+)
通过"+寄存器可以把内容复制到系统剪贴板，也可以从系统剪贴板粘贴内容但Vim中。

调取寄存器值

NORMAL Mode："{register_name}
COMMAND MODE：<C-r>+"寄存器名称 （输入<C-r>后VIM会自动打出"寄存器引用符号。
INSERT MODE：<C-r>+寄存器名称（无需输入寄存器引用符号"）

"% 当前文件名，包含文件路径。
"/ 上次查找的内容。
". 上次插入的内容。"


}