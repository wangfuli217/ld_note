ctags -R *
ctags -R --fields=+iaS --extra=+q *
ctags --fields=+iaS --extra=+q -R -f ~/.vim/systags /usr/include /usr/local/include



command(ctags)
{

ctags-R --languages=c++ --langmap=c++:+.inl -h +.inl --c++-kinds=+px--fields=+aiKSz --extra=+q --exclude=lex.yy.cc --exclude=copy_lex.yy.cc

命令太长了，折成两行了，可以考虑把命令的各个参数写到文件里去了（具体做法就不谈了）。
-R
表示扫描当前目录及所有子目录（递归向下）中的源文件。并不是所有文件ctags都会扫描，如果用户没有特别指明，则ctags根据文件的扩展名来决定是否要扫描该文件——如果ctags可以根据文件的扩展名可以判断出该文件所使用的语言，则ctags会扫描该文件。
--languages=c++
只扫描文件内容判定为c++的文件——即ctags观察文件扩展名，如果扩展名对应c++，则扫描该文件。反之如果某个文件叫aaa.py（Python文件），则该文件不会被扫描。
--langmap=c++:+.inl
告知ctags，以inl为扩展名的文件是c++语言写的，在加之上述2中的选项，即要求ctags以c++语法扫描以inl为扩展名的文件。
-h +.inl
告知ctags，把以inl为扩展名的文件看作是头文件的一种（inl文件中放的是inline函数的定义，本来就是为了被include的）。这样ctags在扫描inl文件时，就算里面有static的全局变量，ctags在记录时也不会标明说该变量是局限于本文件的（见第一节描述）。
--c++-kinds=+px
记录类型为函数声明和前向声明的语法元素（见第三节）。
--fields=+aiKSz
控制记录的内容（见第四节）。
--extra=+q
让ctags额外记录一些东西（见第四、五节）。
--exclude=lex.yy.cc --exclude=copy_lex.yy.cc
告知ctags不要扫描名字是这样的文件。还可以控制ctags不要扫描指定目录，这里就不细说了。
-f tagfile：指定生成的标签文件名，默认是tags. tagfile指定为 - 的话，输出到标准输出。
}

desc(ctags_config)
{
Tlist_GainFocus_On_ToggleOpen : 为1则使用TlistToggle打开标签列表窗口后会获焦点至于标签列表窗口；为0则taglist打开后焦点仍保持在代码窗口
Tlist_Auto_Open : 为1则Vim启动后自动打开标签列表窗口
Tlist_Close_On_Select : 选择标签或文件后是否自动关闭标签列表窗口
Tlist_Exit_OnlyWindow : Vim当前仅打开标签列表窗口时，是否自动退出Vim
Tlist_Use_SingleClick : 是否将默认双击标答打开定义的方式更改为单击后打开标签
Tlist_Auto_Highlight_Tag : 是否高亮显示当前标签。命令":TlistHighlightTag"也可达到同样效果
Tlist_Highlight_Tag_On_BufEnter : 默认情况下，Vim打开/切换至一个新的缓冲区/文件后，标签列表窗口会自动将当前代码窗口对应的标签高亮显示。TlistHighlight_Tag_On_BufEnter置为0可禁止以上行为
Tlist_Process_File_Always : 为1则即使标签列表窗口未打开，taglist仍然会在后台处理vim所打开文件的标签
Tlist_Auto_Update : 打开/禁止taglist在打开新文件或修改文件后自动更新标签。禁止自动更新后，taglist仅在使用:TlistUpdate,:TlistAddFiles，或:TlistAddFilesRecursive命令后更新标签
Tlist_File_Fold_Auto_Close : 自动关闭标签列表窗口中非激活文件/缓冲区所在文档标签树，仅显示当前缓冲区标签树
Tlist_Sort_Type : 标签排序依据，可以为"name"（按标签名排序）或"order"（按标签在文件中出现的顺序，默认值）
Tlist_Use_Horiz_Window : 标签列表窗口使用水平分割样式
Tlist_Use_Right_Window : 标签列表窗口显示在右侧（使用垂直分割样式时）
Tlist_WinWidth : 设定水平分割时标签列表窗口的宽度
Tlist_WinHeight : 设定垂直分割时标签列表窗口的高度
Tlist_Inc_Winwidth : 显示标签列表窗口时允许/禁止扩展Vim窗口宽度
Tlist_Compact_Format : 减少标签列表窗口中的空白行
Tlist_Enable_Fold_Column : 是否不显示Vim目录列
Tlist_Display_Prototype : 是否在标签列表窗口用标签原型替代标签名
Tlist_Display_Tag_Scope : 在标签名后是否显示标签有效范围
Tlist_Show_Menu : 在图型界面Vim中，是否以下拉菜单方式显示当前文件中的标签
Tlist_Max_Submenu_Item : 子菜单项上限值。如子菜单项超出此上限将会被分隔到多个子菜单中。缺省值为25
Tlist_Max_Tag_Length : 标签菜单中标签长度上限
}

config(ctags)
{
"--ctags setting--
" 按下F5重新生成tag文件，并更新taglist
map :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q . :TlistUpdate
imap :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q . :TlistUpdate
set tags=tags
set tags+=./tags "add current directory's generated tags file
set tags+=~/arm/linux-2.6.24.7/tags "add new tags file(刚刚生成tags的路径，在ctags -R 生成tags文件后，不要将tags移动到别的目录，否则ctrl+］时，会提示找不到源码文件)

set tags+=./tags表示在当前工作目录下搜索tags文件
set tags+=~/arm/linux-2.6.24.7/tags表示在搜寻tags文件的时候，也要搜寻~/arm/linux-2.6.24.7/文件夹下的tags文件。


#####  example #####
" 按照名称排序 
let Tlist_Sort_Type = "name" 

" 在右侧显示窗口 
let Tlist_Use_Right_Window = 1 

" 压缩方式 
let Tlist_Compart_Format = 1 

" 如果只有一个buffer，kill窗口也kill掉buffer 
let Tlist_Exist_OnlyWindow = 1 

" 不要关闭其他文件的tags 
let Tlist_File_Fold_Auto_Close = 0 

" 不要显示折叠树 
let Tlist_Enable_Fold_Column = 0 

#####  example #####
"-- Taglist setting --
"自动更新taglist
let Tlist_Auto_Update = 1
"设置taglist宽度
let Tlist_WinWidth=40       
"因为我们放在环境变量里，所以可以直接执行
let Tlist_Ctags_Cmd='ctags' 
"让窗口显示在右边，0的话就是显示在左边
let Tlist_Use_Right_Window=1 
"让taglist可以同时展示多个文件的函数列表
let Tlist_Show_One_File=0 
"非当前文件，函数列表折叠隐藏
let Tlist_File_Fold_Auto_Close=1 
 "当taglist是最后一个分割窗口时，自动推出vim
let Tlist_Exit_OnlyWindow=1
"为1则即使标签列表窗口未打开，taglist仍然会在后台处理vim所打开文件的标签"
let Tlist_Process_File_Always=1 
let Tlist_Inc_Winwidth=0

}

hot_key(ctags)
{
<CR> : 代码窗口跳转到标签列表窗口中光标所在标签定义处
o : 在新建代码窗口中跳转到标签列表窗口中光标所在标签定义处
P : 跳转至上一个窗口的标签处
p : 代码窗口中内容跳转至标签定义处，光标保持在标签列表窗口中
t : 在Vim新标签窗口中跳转至标签定义处。如文件已经在Vim标签窗口中打开，则跳转至此标签窗口
Ctrl-t : 在Vim新标签窗口处跳转至标签定义处
 : 显示光标当前所在标签原型。对文件标签，显示文件的全路径名，文件类型和标签数量。对标签类型(指如variable/function等类别)，显示标签类型和拥有标签的数量;对函数/变量等普通标签，显示其定义的原型
u : 更新标签列表窗口中的标签信息
s : 切换标签排序类型(按名称序或出现顺序)
d : 移除当前标签所在文件的所有标签
x : 扩展/收缩标签列表窗口
+ : 展开折叠节点*
- : 折叠结点*
* : 展开所有结点
= : 折叠所有节点
[[ : 跳转至上一个文件标签的头部
<Backspace> : 跳转至上一个文件标签头部
]] : 跳转至下一个文件标签头部
<Tab> : 跳转至下一个文件标签头部
q : 关闭标签列表窗口
F1 : 显示帮助**
}

vimcmd(ctags)
{
:TlistAddFiles {files(s)} [file(s)...] 添加一或多个指定文件(的标签项)到标签列表窗口中。文件名表达式中可使用通配符(*);如文件名中带有空格，需要使用反斜杠对空格进行转义("\ ")
:TlistAddFilesRecursive {directory} [{pattern}] 遍历指定路径{directory}，将与模式{pattern}相匹配的文件加入标签列表窗口。如未指定pattern，则使用缺省值'*'。如路径中包含空格，需使用反斜杠'\'转义("\ ")
:TlistClose 关闭标签列表窗口
:TlistDebug [filename] 记录taglist插件的调试信息。如指定了filename，则调试信息将被写入此指定文件（如文件已存在，内容将被覆盖)；如未指定filename，则调试信息写入脚本的局部变量中
:TlistLock 锁定标签列表，并且不处理新打开的文件
:TlistMessage 仅当调试信息写入脚本局部变量时有效，显示记录的调试信息
:TlistOpen 打开并跳转至标签列表窗口
:TlistSessionSave {filename} 将当前打开文件及其标签信息写入指定文件
:TlistSessionLoad {filename} 从指定文件载入所保存的会话信息
:TlistShowPrototype [filename] [linenumber] 显示指定文件中指定代码行或之前的标签的原型。如未指定文件名/行号，则使用当前文件名/当前行号
:TlistShowTag [filename] [linenumber] 显示指定文件中指定代码行或之前标签名称。如未指定文件名/行号，则使用当前文件名/当前行号
:TlistHighlightTag 加亮显示标签窗口中的当前标签
:TlistToggle 在打开和关闭状态间切换标签窗口的状态。标签窗口切换至打开状态后仍然光标保持在代码窗口中
:TlistUndebug 停止记录taglist插件调试信息
:TlistUnlock 解锁标签列表，并处理新打开的文件
:TlistUpdate 更新当前缓冲区的标签信息

}

usage(ctags)
{
tag命令用法：
Ctrl＋］ 跳到当前光标下单词的标签
Ctrl＋O 返回上一个标签
Ctrl＋T 返回上一个标签
:tag TagName 跳到TagName标签
以上命令是在当前窗口显示标签，当前窗口的文件替代为包标签的文件，当前窗口光标跳到标签位置。如果不希望在当前窗口显示标签，可以使用以下命令：
:stag TagName 新窗口显示TagName标签，光标跳到标签处
Ctrl＋W + ］ 新窗口显示当前光标下单词的标签，光标跳到标签处
当一个标签有多个匹配项时（函数 (或类中的方法) 被多次定义），":tags" 命令会跳转到第一处。如果在当前文件中存在匹配，那它将会被首先使用。
可以用这些命令在各匹配的标签间移动：
:tfirst 到第一个匹配
:[count]tprevious 向前 [count] 个匹配
:[count]tnext 向后 [count] 个匹配
:tlast 到最后一个匹配
或者使用以下命令选择要跳转到哪一个
:tselect TagName
输入以上命令后，vim会为你展示一个选择列表。然后你可以输入要跳转到的匹配代号 (在第一列)。其它列的信息可以让你知道标签在何处被定义过。
以下命令将在预览窗口显示标签
:ptag TagName 预览窗口显示TagName标签，光标跳到标签处
Ctrl＋W + } 预览窗口显示当前光标下单词的标签，光标跳到标签处
:pclose 关闭预览窗口
:pedit file.h 在预览窗口中编辑文件file.h（在编辑头文件时很有用）
:psearch atoi 查找当前文件和任何包含文件中的单词并在预览窗口中显示匹配，在使用没有标签文件的库函数时十分有用。
}

config(NERDTree)
{
启动vim，自动打开NERDtree

autocmd vimenter * NERDTree
How can I open a NERDTree automatically when vim starts up if no files were specified?

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
映射快捷键

map <C-n> :NERDTreeToggle<CR>
如果只剩下NERDTree最后一个窗口，如何关闭NERDTree

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
}


vimcmd(cscope_add)
{
add ：增加一个新的cscope数据库/链接库

使用方法：
:cs add {file|dir} [pre-path] [flags]

其中：
[pre-path] 就是以-p选项传递给cscope的文件路径，是以相对路径表示的文件前加上的path，这样你不要切换到你数据库文件所在的目录也可以使用它了。
[flags] 你想传递给cscope的额外旗标
 
实例：
:cscope add /root/code/vimtest/ftpd
:cscope add /project/vim/cscope.out /usr/local/vim
:cscope add cscope.out /usr/local/vim –C

}

vimcmd(cscope_find)
{
find ：查询cscope。所有的cscope查询选项都可用除了数字5（“修改这个匹配模式”）
使用方法：
:cs find {querytype} {name}
其中：
{querytype} 即相对应于实际的cscope行接口数字，同时也相对应于nvi命令：
0或者s   —— 查找这个C符号
1或者g  —— 查找这个定义
2或者d  —— 查找被这个函数调用的函数（们）
3或者c  —— 查找调用这个函数的函数（们）
4或者t   —— 查找这个字符串
6或者e  —— 查找这个egrep匹配模式
7或者f   —— 查找这个文件
8或者i   —— 查找#include这个文件的文件（们）

实例：（#号后为注释）
cscope find c ftpd_send_resp                     # 查找所有调用这个函数的函数（们）
:cscope find 3 ftpd_send_resp                     # 和上面结果一样
:cscope find 0 FTPD_CHECK_LOGIN       # 查找FTPD_CHECK_LOGIN这个符号
}

vimcmd(cscope_help)
{
 help ：显示一个简短的摘要。

 使用方法：
:cs help
}

vimcmd(cscope_kill)
{
 kill  ：杀掉一个cscope链接（或者杀掉所有的cscope链接）

使用方法：
:cs kill {num|partial_name}
为了杀掉一个cscope链接，那么链接数字或者一个部分名称必须被指定。部分名称可以简单的是cscope数据库文件路径的一部分。要特别小心使用部分路径杀死一个cscope链接。
假如指定的链接数字为-1，那么所有的cscope链接都会被杀掉。
}

vimcmd(cscope_reset)
{
reset：重新初始化所有的cscope链接。

使用方法：
:cs reset
}

vimcmd(cscope_show)
{
 show：显示cscope的链接

 使用方法：
 :cs show
}