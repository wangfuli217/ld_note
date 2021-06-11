:h Python :h Ruby :h Lua vim居然还支持这些语言的接口

echo(打印信息){ ec[ho] echom[sg] mes[sages] message-history
:help echo | echom | messages

:echo "Hello, world!"
:echom "Hello again, world!"
:messages
你应该会看到一些消息。Hello, world!应该不在其中，但是Hello again, world! 在。
}
option(选项){
1. 布尔选项
  :set number     # 打开
  :set nonumber   # 关闭
:set <name>打开选项、:set no<name>关闭选项
  :set number!    # 切换
  :set number?    # 查看
2. 键值选项
  :set numberwidth=10   # 行号的列宽
  :set numberwidth=4
  :set numberwidth?
:set <name>=<value>命令改变 非布尔选项的选项值，并使用:set <name>?命令查看选项的当前值
  :set wrap?
  :set shiftround?
  :set matchtime?
3. 一次性设置多个选项
  :set number numberwidth=6
}
map(noremap,unmap){
:map - x   # -执行x命令
:map - dd  # -执行dd命令
特殊字符
:map <space> viw # 移动光标到一个单词上，按下空格键。Vim将高亮选中整个单词
:map <c-d> dd    # Ctrl+d将执行dd命令

:map <space> viw " Select word # 键盘映射就无法使用注释"
}
nmap(normal,nnoremap){
:nmap \ dd        # 在normal模式下，按下\。Vim会删除当前行
:nnoremap <leader>d dd
}
vmap(visual,vnoremap){
:vmap \ U  # visual模式并选中一些文字，按下\。Vim将把选中文本转换成大写格式
}
imap(insert,inoremap){
:imap <c-d> <esc>ddi # 按键Ctrl+d删除整行,再回到insert模式
:inoremap <esc> <nop>
}

<leader>默认是\
leaders(mapleader, maplocalleader){
nnoremap <space> dd这样映射一个按键都会覆盖掉<space>的原有功能
:let mapleader = "-"
:let maplocalleader = "\\" # 注意我们使用\\而不是\，因为\在Vimscript中是转义字符
现在你就可以在映射中使用<localleader>了，使用方法和<leader>一样

vim还有种local leader，只作用于当前类型的文件，如py,html，用:lset maplocalleader="\\"来定义
}
vimrc(help myvimrc){
:nnoremap <leader>ev :vsplit $MYVIMRC<cr> 
  $MYVIMRC是指定你的~/.vimrc文件的特殊Vim变量。
  :vsplit打开一个新的纵向分屏。
:nnoremap <leader>sv :source $MYVIMRC<cr>
  source命令告诉Vim读取指定的文件，并将其当做Vimscript执行
  
让配置变更立即生效 
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
}
abbreviations(为你经常输入的文本添加abbreviations配置){
:iabbrev adn and  # adn之后输入空格键，Vim会将其替换为and
:iabbrev waht what
:set iskeyword? # 缩写会替换"非关键字符"
iskeyword=@,48-57,_,192-255,.的结果。这个格式很复杂，但本质上 "keyword characters"包含一下几种：
下划线字符 (_).
所有字母字符，包括大小写。
ASCII值在48到57之间的字符（数字0-9）。
ASCII值在192到255之间的字符（一些特殊ASCII字符）

:help isfname # 定义哪些字符可以成为文件名，注意里面没有空格和反斜杠\

:iabbrev @@    steve@stevelosh.com
:iabbrev ccopy Copyright 2013 Steve Losh, all rights reserved.

:inoremap ssig -- <cr>Steve Losh<cr>steve@stevelosh.com
mappings不管被映射字符串的前后字符是什么-- 它只在文本中查找指定的字符串并替换他们。
}
buffer(help setlocal){
:nnoremap          <leader>d dd
:nnoremap <buffer> <leader>x dd
如果我们需要设定一个只会用于特定缓冲区的映射，一般会使用<localleader>，而不是<leader>

:setlocal nonumber # :setlocal number
:setlocal nowrap   # :setlocal wrap

阅读:help local-options
阅读:help setlocal    # 只对当前窗口有效
阅读:help map-local
}
autocmd(autocmd-events){
:autocmd BufNewFile * :write
         ^          ^ ^
         |          | |
         |          | 要执行的命令
         |          |
         |          用于事件过滤的"模式(pattern)"
         |
         要监听的"事件"
事件：
  开始编辑一个当前并不存在的文件
  读取一个文件，不管这个文件是否存在
  改变一个缓冲区的filetype设置
  在某段时间内不按下键盘上面的某个按键
  进入插入模式
  退出插入模式

:autocmd BufNewFile *.txt :write
:autocmd BufWritePre *.html :normal gg=G

:autocmd BufWritePre,BufRead *.html :normal gg=G  # 多个事件
:autocmd BufNewFile,BufRead *.html setlocal nowrap # 无论你在什么时候编辑HTML文件自动换行都会被关闭
}

:echo has('python') # 若输出 1 则表示构建出的 vim 已支持 python，反之，0 则不支持
FileType(文件类型过滤器){
Vim设置一个缓冲区的filetype的时候触发
:autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
:autocmd FileType python     nnoremap <buffer> <localleader>c I#<esc>

自动命令和缩写 # snippet系统
:autocmd FileType python     :iabbrev <buffer> iff if:<left>
:autocmd FileType javascript :iabbrev <buffer> iff if ()<left>

filetype plugin indent on
这启动三个非常灵巧的机制：
1. 文件类型探测
    当你开始编辑一个文件的时候，Vim 会试图确定这个文件的类型。当编辑 "main.c"
    时，Vim 会根据扩展名 ".c" 认为这是一个 C 源文件。当你编辑一个文件前面是
    "#!/bin/sh" 的文件时，Vim 会把它认作 "sh" 文件。文件类型探测用于语法高亮
    和以下另两项。请参见 |filetypes|。
 
2. 使用文件类型相关的插件
    不同的文件需要不同的选项支持。例如，当你编辑一个 "c" 文件，用 'cindent' 选
    项来自动缩进就非常有用。这些文件类型相关的选项在 Vim 中是通过文件类型插件
    来实现的。你也可以加入自己的插件，请参见 |write-filetype-plugin|。
 
3. 使用缩进文件
    当编辑程序的时候，行缩进通常可以被自动决定。Vim 用不同的策略处理不同的文件                                                      
    类型。请参见 |:filetype-indent-on| 和 'indentexpr'。
}
augroup(autocmd-groups){
:augroup testgroup
:    autocmd BufWrite * :echom "Foo"
:    autocmd BufWrite * :echom "Bar"
:augroup END
当你多次使用augroup的时候，Vim每次都会组合那些组

:augroup testgroup
:    autocmd!        # 清除自动命令组
:    autocmd BufWrite * :echom "Cats"
:augroup END
}
Pending(补位映射){
常用到的Operator有d，y和c
按键   操作       移动
----   --------   -------------
dw     删除       到下一个单词
ci(    修改       在括号内
yt,    复制       到逗号

1. Movement映射(Operator-Movement) onoremap # 当它在等待一个要附加在operator后面的movement的时候
:onoremap p i(                              # movements都是从光标所在的位置开始
return person.get_pets(type="cat", fluffy_only=True) # dp 命令删除"()"中内容
                                                     # dp 命令删除"()"中内容，进入插入模式
把光标放到第二行的i上，然后按下db。Vim把整个函数体中直到return上面的内容都删除了，
return就是上面的映射使用Vim的通用查找得到的结果。

2. 改变开始位置
:onoremap in( :<c-u>normal! f(vi(<cr> # 在下一个括号内
print foo(bar) # 把光标放到单词print上面，然后敲击cin(
:onoremap il( :<c-u>normal! F)vi(<cr> # 在上一个括号内

:normal! F)vi(<cr>  <--> :<c-u>normal! F)vi(<cr>
:normal! -> 在常用模式下模拟按下按键
:normal! dddd会删除两行
<cr>    是用来执行:normal!命令

F)vi(
F): 向后移动到最近的)字符。
vi(: 进入可视模式选择括号内的所有内容。

一般规则
  如果你的operator-pending映射以在可视模式下选中文本结束，Vim会操作这些文本
  否则，Vim会操作从光标的原始位置到一个新位置之间的文本
  
help omap-info
<c-u> CTRL-U (<C-U>) 用于删除命令行上 Vim 可能插入的范围。普通模式命令寻找第一个 '('
     字符并选择之前的第一个单词。通常那就是函数名了
help normal。
help execute。
help expr-quote   
help pattern-overview

:onoremap ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
  execute命令后面会跟着一个Vim脚本字符串，然后把这个字符串当作一个命令执行。
  :execute "write"
  :execute "normal! gg"
  
:normal! ?^==\+$<cr>:nohlsearch<cr>kvg_
                ^^^^           ^^^^
                 ||             ||
这里的<cr>实际上是一个回车符，而不是由4个字符——“左尖括号”，“c“，”r“和“右尖括号”组成的字符串。
?^==\+$会向后搜索任何由两个或多个等号组成的行

k：向上移动一行。第一部分已经将光标定位到了等号符号组成的行的第一个字符，所以执行这个命令后光标就会被定位到标题的第一个字符上。
v：进入可视模式(characterwise)。
g_：移动到当前行的最后一个非空字符上
}
statusline(状态栏){
statusline=%F%m%r%h%w [FORMAT=%{&ff}] [TYPE=%Y] [POS=%l,%v][%p%%] %{strftime("%d/%m/%y - %H:%M")}
help statusline
}

“基本设置(Basic Settings)“
”文件类型相关设置(FileType-specific settings)”
“映射(Mappings)”
“状态条(Status Line)”
help foldlevelstart
variable(变量){
变量
:let foo = "bar"  # 字符串
:let foo = 42     # 整数
:echo foo         # 输出

作为变量的选项
:set textwidth=80  # 选项设置
:echo &textwidth   # 选项输出

:let &textwidth = 100 # let设置选项
:set textwidth?       # set显示选项内容

本地选项
:let &l:number = 1
:let &l:number = 0

作为变量的寄存器
:let @a = "hello!"
:echo @a
:echo @"  # 当前正使用寄存器 "
:echo @/  # 执行搜索/someword

:help registers
在set可以搞定的时候，永远都不要用let，这是因为let更难于阅读

变量作用域
:let b:hello = "world"
:echo b:hello

help internal-variables

前缀	含义
g:varname	变量为全局变量
s:varname	变量的范围为当前的脚本文件
w:varname	变量的范围为当前的编辑器窗口
t:varname	变量的范围为当前的编辑器选项卡
b:varname	变量的范围为当前的编辑器缓冲区
l:varname	变量的范围为当前的函数
a:varname	变量是当前函数的一个参数
v:varname	变量是 Vim 的预定义变量

前缀	含义
&varname	一个 Vim 选项（如果指定的话，则为本地选项，否则为全局选项）
&l:varname	本地 Vim 选项
&g:varname	全局 Vim 选项
@varname	一个 Vim 注册器
$varname	一个环境变量
}

separator(|){
:echom "foo" | echom "bar"
你可以用管道符(|)来隔开每一行。
}
if(){
if 1  # 整数1是"truthy"
    echom "ONE"
endif

if 0 # 整数0是"falsy"
    echom "ZERO"
endif

if "something" # Vim_不会_把非空字符串当作"truthy"
    echom "INDEED"
endif

if "9024" # 显示
    echom "WHAT?!"
endif

:echom "hello" + 10
:echom "10hello" + 10
:echom "hello10" + 10

1. 如有必要，Vim将强制转换变量(和字面量)的类型。在解析10 + "20foo"时，Vim将把"20foo"转换成一个整数(20)然后加到10上去。
2. 以一个数字开头的字符串会被强制转换成数字，否则会转换成0
3. 在所有的强制转换完成后，当if的判断条件等于非零整数时，Vim会执行if语句体。
}

compare(){
if 10 > 1  # 显示
    echom "foo"
endif

if 10 > 2001 # 不显示
    echom "bar"
endif

if 10 == 11
    echom "first"  # 不显示
elseif 10 == 10
    echom "second" # 显示
endif

if "foo" == "bar"     # 不显示
    echom "one"
elseif "foo" == "foo" # 显示
    echom "two"
endif


:set noignorecase  
:if "foo" ==? "FOO" # ==?是"无论你怎么设都大小写不敏感"比较操作符
:    echom "first"
:elseif "foo" ==? "foo"
:    echom "second"
:endif

:set ignorecase   # ==#是"无论你怎么设都大小写敏感"比较操作符
:if "foo" ==# "FOO"
:    echom "one"
:elseif "foo" ==# "foo"
:    echom "two"
:endif

set ignorecase和:set noignorecase
help ignorecase
help expr4
}
function(){
没有作用域限制的Vimscript函数必须以一个大写字母开头!
:function Meow()
:  echom "Meow!"
:endfunction

:call Meow()

function GetMeow()
:  return "Meow String!"
:endfunction

:echom GetMeow()

help :call
help E124
help return
}
function(arg){
:function DisplayName(name)
:  echom "Hello!  My name is:"
:  echom a:name # 表示一个变量的作用域
:endfunction

call DisplayName("Your Name")

可变参数
:function Varg(...)
:  echom a:0      # 2 
:  echom a:1      # a
:  echo a:000     # ['a', 'b']
:endfunction

:call Varg("a", "b")

赋值
:function Assign(foo)
:  let a:foo = "Nope"
:  echom a:foo
:endfunction

:call Assign("test")
Vim将抛出一个错误，因为你不能对参数变量重新赋值。现在执行下面的命令：
:function AssignGood(foo)
:  let foo_tmp = a:foo
:  let foo_tmp = "Yep"
:  echom foo_tmp
:endfunction

:call AssignGood("test")

help function-argument
help local-variables
}
Number(Float){
:echom 100   # 10进制
:echom 0xff  # 16进制
:echom 010   # 8 进制
1. 小数点和小数点后面的数字是_必须要有_的
2. 在10的幂前面的+或-是可选的
:echo 100.1     # 100.1
:echo 5.45e+3   # 5450.0
:echo 15.45e-2  # 0.1545
:echo 15.3e9    # 1.53e10

:echo 2 * 2.0  # 4.0
:echo 3 / 2    # 1
:echo 3 / 2.0  # 1.5
help Float
help floating-point-precision
}
string(){
echom "Hello"
连接
echom "Hello, " + "world"  # 0
echom "3 mice" + "2 cats"  # 5
echom "Hello, " . "world"  # Hello, World
echom 10 . "foo"           # 10foo
echom 10.1 . "foo" # Vim乐于让你在执行加法时把String当作Float， 却_不爽_你在连接字符串时把Float当作String

特殊字符
echom "foo \"bar\""  # foo "bar" 
echom "foo\\bar"     # foo\bar     

字符串字面量
:echom '\n\\'             # \n\\  
:echom 'That''s enough.'  # That's enough. 一行中连续两个单引号将产生一个单引号

help expr-quote
help literal-string
help i_CTRL-V
}
string(func){
echom strlen("foo") # 3
echom len("foo")    # 3
echo split("one two three")        # ['one','two','three']
echo split("one,two,three", ",")   # ['one','two','three']
echo join(["foo", "bar"], "...")   # foo..bar
echo join(split("foo bar"), ";")   # foo;bar
:echom tolower("Foo")              # foo
:echom toupper("Foo")              # FOO
help split()
help join()
help functions
}

:source /full/path/to/the/scriptfile.vim
:call MyBackupFunc(expand('%'), { 'all':1, 'save':'recent'})
:nmap ;s :source /full/path/to/the/scriptfile.vim<CR>
:nmap \b :call MyBackupFunc(expand('%'), { 'all': 1 })<CR>

execute(把一个字符串当作Vimscript命令执行){
execute "echom 'Hello, world!'"
:execute "rightbelow vsplit " . bufname("#")

help execute
:help leftabove，:help rightbelow，:help :split和:help :vsplit
}
normal(){
避免映射
  执行下面的命令来映射G键到别的东西：
  :nnoremap G dd
  现在在normal模式按下G将删除一整行。试试这个命令：
  :normal G
  Vim将删除当前行。normal命令将顾及当前的所有映射。
  
  在写Vim脚本时，你应该_总是_使用normal!，_永不_使用normal。不要信任用户在~/.vimrc中的映射。
  
特殊字符
  :normal! /foo<cr>
第一眼看上去它应该会开始搜索foo，但你将看到它不会正常工作。 问题在于normal!不会解析像<cr>那样的特殊字符序列。

help normal
:help helpgrep

:execute "normal! gg/foo\<cr>dd" # 将移动到文件的开头，查找foo的首次出现的地方，并删掉那一行
execute允许你创建命令，因而你能够使用Vim普通的转义字符串来生成你需要的"打不出"的字符

# execute "normal! mqA;\<esc>`q"
:execute "normal! ..."：执行命令序列，一如它们是在normal模式下输入的，忽略所有映射， 并替换转义字符串。
  # mq：保存当前位置到标记"q"。
  # A：移动到当前行的末尾并在最后一个字符后进入insert模式。
  # ;：我们现在位于insert模式，所以仅仅是写入了一个";"。
  # \<esc>：这是一个表示Esc键的转义字符串序列，把我们带离insert模式。
  # `q：回到标记"q"所在的位置。
:help expr-quote
}
search(){
:set hlsearch incsearch
  hlsearch让Vim高亮文件中所有匹配项
  incsearch则令Vim在你正打着搜索内容时就高亮下一个匹配项
  
/和?命令能接受正则表达式，而不仅仅是普通字符
execute "normal! gg/print\<cr>"   # 第一个print
execute "normal! gg/print\<cr>n"  # 第二个print
execute "normal! G?print\<cr>"    # 从尾倒数第一个
execute "normal! gg/for .+ in .+:\<cr>"
execute "normal! gg/for .\\+ in .\\+:\<cr>"
首先，execute接受一个字符串，在调用normal!命令时，双反斜杠将转换成单反斜杠。
Vim有四种不同的解析正则表达式的"模式"， 默认模式下需要在+前加上一个反斜杠来让它表示"一或多个之前的字符"而不是"一个字面意义上的加号"。

execute "normal! gg" . '/\vfor .+ in .+:' . "\<cr>" # \v 引导模式
:help magic
:help pattern-overview
:help match。尝试手动执行几次:match Error /\v.../
hlsearch和incsearch
help nohlsearch
}

escape(){
escape({string}, {chars})                               *escape()*
在 {string} 里用反斜杠转义 {chars} 里的字符。例如: 
:echo escape('c:\program files\vim', ' \')
返回: 
c:\\program\ files\\vim
}
shellescape(){
shellescape({string} [, {special}])                     shellescape()                                                               
  转义 {string} 以便用作shell命令的参数。   
  在 MS-Windows 和 MS-DOS 上，如果未设定 'shellslash'，用双引号
  包围 {string}，并给 {string} 内的双引号加倍。
  在其它系统上，用单引号包围，并把所有的 "'" 替换为 "'\''"。
  如果给出 {special} 参数且它是非零的数值或非空的字符串 
  (non-zero-arg)，则特殊项目如 "!"、"%"、"#" 和 "<cword>" 等会
  在前面加上反斜杠。:! 命令会再把反斜杠删除。
  如果 'shell' 以 "csh" 结尾，"!" 字符会被转义 (仍是当 {special}
  为 non-zero-arg 时)。这是因为 csh 和 tcsh 即使在单引号内仍然
  使用 "!" 用于历史替换。  
}
expand(){
expand({expr} [, {flag}])                               expand()                                                                    
扩展 {expr} 里的通配符和下列特殊关键字。返回的是字符串。
                                         
如果返回多个匹配，以 <NL> 字符分隔 [备注: 5.0 版本使用空格。但
是文件名如果也包含空格就会有问题]。      
                                         
如果扩展失败，返回空字符串。这不包括不存在文件的名字。
                                         
如果 {expr} 以 '%'、'#' 或 '<' 开始，以类似于
cmdline-special 变量的方式扩展，包括相关的修饰符。这里是一个
简短的小结:                              
                                         
        %               当前文件名       
        #               轮换文件名       
        #n              轮换文件名 n     
        <cfile>         光标所在的文件名 
        <afile>         自动命令文件名  
                               <abuf>          自动命令缓冲区号 (以字符串形式出现！)
        <amatch>        自动命令匹配的名字
        <sfile>         载入的脚本文件名
        <cword>         光标所在的单词  
        <cWORD>         光标所在的字串 (WORD)
        <client>        最近收到的消息的 {clientid}
                        server2client() 
修饰符:                                 
        :p              扩展为完整的路径
        :h              头部 (去掉最后一个部分)
        :t              尾部 (只保留最后一个部分)
        :r              根部 (去掉一个扩展名)
        :e              只有扩展名 
let &tags = expand("%:p:h") . "/tags"        
}
grep(){
:help :grep和:help :make
:help quickfix-window

grep ...将用你给的参数来运行一个外部的grep程序，解析结果，填充quickfix列表， 这样你就能在Vim里面跳转到对应结果

:vim[grep][!] /{pattern}/[g][j] {file} ... # 在文件 {file} ... 里搜索模式 {pattern}，并用匹配结果设                                                      置错误列表。
  :vimgrep /an error/ *.c
  :vimgrep /\<FileName\>/ *.h include/*
  :vimgrep /myfunc/ **/*.c
如果没有 'g' 标志位，每行只加一次。
如果有 'g'，每个匹配都被加入。
{pattern} 是 Vim 的搜索模式。除了用 / 之外，任何非 ID 字符 (见 |'isident') 都可以用来包围该模式，只要在{pattern} 里不出现就行了。    


:nnoremap <leader>g :grep -R something .<cr>
:nnoremap <leader>g :grep -R '<cword>' .<cr> # <cword>是一个Vim的command-line模式的特殊变量， Vim会在执行命令之前把它替换为"光标下面的那个词"。
:nnoremap <leader>g :grep -R '<cWORD>' .<cr> # 使用<cWORD>来得到大写形式(WORD)

转义Shell命令参数
:help escape()和:help shellescape()
:nnoremap <leader>g :exe "grep -R " . shellescape(expand("<cWORD>")) . " ."<cr>
echom shellescape(expand("<cWORD>")) # that' s  -> 'that'\''s'

整理整理
:nnoremap <leader>g :execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>
:nnoremap <leader>g :execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>
:nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>

help copen
help silent
help cnext
help cprevious
help cword
}
grep(plugin){
Vim plugin -> ~/.vim/plugin -> :source %

grep-operator.vim:
>> # 首先对函数设置了operatorfunc选项，然后执行g@来以运算符的方式调用这个函数。 
  nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@
  
  function! GrepOperator(type)
      echom "Test"
  endfunction

可视模式
vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>
用<c-u>来执行"从光标所在处删除到行首的内容"，移除多余文本
visualMode()
函数是Vim的内置函数，它返回一个单字符的字符串来表示visual模式的类型： 
  "v"代表字符宽度(characterwise)，
  "V"代表行宽度(linewise)，
  Ctrl-v代表块宽度(blockwise)
  
动作类型
nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>

function! GrepOperator(type)
    echom a:type
endfunction

按下viw<leader>g显示v，因为我们处于字符宽度的visual模式。
按下Vjj<leader>g显示V，因为我们处于行宽度的visual模式。
按下<leader>giw显示char，因为我们在字符宽度的动作(characterwise motion)中使用该运算符。
按下<leader>gG显示line，因为我们在行宽度的动作(linewise motion)中使用该运算符。

复制文本
nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>

function! GrepOperator(type)
    if a:type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:type ==# 'char'
        execute "normal! `[v`]y"
    else
        return
    endif

    echom @@
endfunction
函数的最后一行输出变量@@。不要忘了以@开头的变量是寄存器。@@是"未命名"(unnamed)寄存器： 
如果你在删除或复制文本时没有指定一个寄存器，Vim就会把文本放在这里。

nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>

function! GrepOperator(type)
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    silent execute "grep! -R " . shellescape(@@) . " ."
    copen
endfunction
}
保护寄存器
命名空间
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! '<v'>y
    elseif a:type ==# 'char'
        normal! '[v']y
    else
        return
    endif

    silent execute "grep! -R " . shellescape(@@) . " ."
    copen

    let @@ = saved_unnamed_register
endfunction
list(){
:echo ['foo', 3, 'bar']
:echo ['foo', [3, 'bar']]
索引
:echo [0, [1, 2]][1]  # Vimscript列表的索引从0开始
:echo [0, [1, 2]][-2] # Vim显示0。索引-1对应列表的最后一个元素，-2对应倒数第二个
切割
:echo ['a', 'b', 'c', 'd', 'e'][0:2]
:echo ['a', 'b', 'c', 'd', 'e'][0:100000] # 越过列表索引上界也是安全的
:echo ['a', 'b', 'c', 'd', 'e'][-2:-1] # 负数切割
:echo ['a', 'b', 'c', 'd', 'e'][:1]
:echo ['a', 'b', 'c', 'd', 'e'][3:]
:echo "abcd"[0:2]               # cd
:echo "abcd"[-1] . "abcd"[-2:]  # cd
连接
:echo ['a', 'b'] + ['c']
列表函数
:let foo = ['a']               # 
:call add(foo, 'b')            # 
:echo foo                      # ['a', 'b']

:echo len(foo)

:echo get(foo, 0, 'default')    # a
:echo get(foo, 100, 'default')  # default

echo index(foo, 'b')            # 1
echo index(foo, 'nope')         # -1

echo join(foo)                 # a b
echo join(foo, '---')          # a---b
echo join([1, 2, 3], '')       # 123

call reverse(foo)             #
echo foo                      # ['b', 'a']
call reverse(foo)             #
echo foo                      # ['a', 'b']

阅读:help List。看完它。注意大写L。
阅读:help add().
阅读:help len().
阅读:help get().
阅读:help index().
阅读:help join().
阅读:help reverse().
浏览:help functions
}
For(){
:let c = 0

:for i in [1, 2, 3, 4]
:  let c += i
:endfor

:echom c
}
While(){
:let c = 1
:let total = 0

:while c <= 4
:  let total += c
:  let c += 1
:endwhile

:echom total
}
dict(){
echo {'a': 1, 100: 'foo'}
echo {'a': 1, 100: 'foo',}

索引
:echo {'a': 1, 100: 'foo',}['a']   # 1
:echo {'a': 1, 100: 'foo',}[100]   # 'foo'
:echo {'a': 1, 100: 'foo',}.a      # 1
:echo {'a': 1, 100: 'foo',}.100    # 'foo'

赋值和添加
:let hao = {'a': 1}
:let hao.a = 100
:let hao.b = 200
:echo foo # {'a': 100, 'b': 200}
移除项
:let test = remove(foo, 'a')   # 函数将移除给定字典的给定键对应的项，并返回被移除的值
:unlet foo.b                   # unlet命令也能移除字典中的项，只是不返回值
:echo foo                      # {'b': 200}  
:echo test                     # 100
字典函数
:echom get({'a': 100}, 'a', 'default')  # 100
:echom get({'a': 100}, 'b', 'default')  # default
Vim显示100和default，如同列表版本的get函数.
你也可以检查给定字典里是否有给定的键。执行这个命令：
:echom has_key({'a': 100}, 'a')   # 1
:echom has_key({'a': 100}, 'b')   # 0

echo items({'a': 100, 'b': 200}) # [['a', 100], ['b', 200]]  
}
enable(Vimscript 切换){
:nnoremap <leader>N :setlocal number!<cr>

切换选项
nnoremap <leader>f :call FoldColumnToggle()<cr>

function! FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction
----------------------------------------------
nnoremap <leader>q :call QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

阅读:help foldcolumn.
阅读:help winnr()
阅读:help ctrl-w_w.
阅读:help wincmd.
}
func(){

}
path(){
:echom expand('%')                  # 我们正在编辑的文件的相对路径
:echom expand('%:p')                # 显示当前文件的完整的绝对路径名 
:echom fnamemodify('foo.txt', ':p') # 当前文件夹下的文件foo.txt的绝对路径，无论文件是否存在

echo globpath('.', '*')                  # 返回一个字符串， 其中每一项都用换行符隔开。
echo split(globpath('.', '*'), '\n')     # 为了得到一个列表，你需要自己去split()
echo split(globpath('.', '*.txt'), '\n') # 当前文件夹下的所有.txt文件组成的列表
echo split(globpath('.', '**'), '\n')    # **递归地列出文件
}

plugin(配置){
开启实时搜索功能   set incsearch
搜索时大小写不敏感 set ignorecase
关闭兼容模式       set nocompatible
vim 自身命令行模式智能补全 set wildmenu
四类配置不仅影响 vim，而且影响插件是否能正常运行
}

plugin(全局插件 文件类型插件){
Vim 中有两种插件：      
全局插件：用于所有类型的文件
文件类型插件：仅用于特定类型的文件

系统            插件目录  
Unix            ~/.vim/plugin/
mkdir ~/.vim  
mkdir ~/.vim/plugin
cp /usr/local/share/vim/vim60/macros/justify.vim ~/.vim/plugin

mv thefile ~/.vim/ftplugin/stuff.vim
ftplugin/<filetype>.vim
ftplugin/<filetype>_<name>.vim
ftplugin/<filetype>/<name>.vim
}

plugin(插件内容){
基本配置方式
~/.vim/colors/
Vim将会查找~/.vim/colors/mycolors.vim并执行它。 这个文件应该包括生成你的配色方案所需的一切Vimscript命令

~/.vim/plugin/
~/.vim/plugin/下的文件将在_每次_Vim启动的时候执行。 这里的文件包括那些无论何时，在启动Vim之后你就想加载的代码

~/.vim/ftdetect/
~/.vim/ftdetect/下的文件在每次你启动Vim的时候_也会_执行。
ftdetect是"filetype detection"的缩写。 这里的文件_仅仅_负责启动检测和设置文件的filetype类型的自动命令。

~/.vim/ftplugin/
一切皆取决于它的名字!当Vim把一个缓冲区的filetype设置成某个值时， 它会去查找~/.vim/ftplugin/下对应的文件。 比如：如果你执行set filetype=derp，Vim将查找~/.vim/ftplugin/derp.vim。 一旦文件存在，Vim将执行它。
Vim也支持在~/.vim/ftplugin/下放置文件夹。 再以我们刚才的例子为例：set filetype=derp将告诉Vim去执行~/.vim/ftplugin/derp/下的全部*.vim文件。 这使得你可以按代码逻辑分割在ftplugin下的文件。

~/.vim/indent/
~/.vim/indent/下的文件类似于ftplugin下的文件。加载时也是只加载名字对应的文件。
indent文件应该设置跟对应文件类型相关的缩进，而且这些设置应该是buffer-local的。

~/.vim/compiler/
~/.vim/compiler下的文件非常类似于indent文件。它们应该设置同类型名的当前缓冲区下的编译器相关选项。

~/.vim/after/
~/.vim/after文件夹有点神奇。这个文件夹下的文件会在每次Vim启动的时候加载， 不过是在~/.vim/plugin/下的文件加载了之后。
这允许你覆盖Vim的默认设置。

~/.vim/autoload/

~/.vim/autoload文件夹就更加神奇了。事实上它的作用没有听起来那么复杂。
简明扼要地说：autoload是一种延迟插件代码到需要时才加载的方法。 我们将在重构插件的时候详细讲解并展示它的用法。

~/.vim/doc/
最后，~/.vim/doc/文件夹提供了一个你可以放置你的插件的文档的地方。 Vim对文档的要求是多多益善(看看我们执行过的所有:help命令就知道)，所以为你的插件写文档是重要的。
}

:help ft
:help setfiletype
ftdetect(potion.vim){
au BufNewFile,BufRead *.pn set filetype=potion
}
syntax(potion.vim){
高亮关键字
syntax keyword potionKeyword loop times to while
syntax keyword potionKeyword if elsif else
syntax keyword potionKeyword class return

syntax keyword potionFunction print join string

highlight link potionKeyword Keyword
highlight link potionFunction Function
你首先要用syntax keyword或相关命令(我们待会会提到)，定义一组语法类型。
然后你要把这组类型链接到高亮组(highlighting groups)。 一个高亮组是你在配色方案里定义的东西，比如"函数名应该是蓝色的"。

浏览:help syn-keyword。注意提到iskeyword的部分。
阅读:help iskeyword.
阅读:help group-name来了解一些配色方案作者常用的通用高亮组

syntax match potionComment "\v#.*$"
highlight link potionComment Comment

阅读:help syn-match.
阅读:help syn-priority.

syntax region potionString start=/\v"/ skip=/\v\\./ end=/\v"/
highlight link potionString String

阅读:help syn-region
}

wrap(){
:help usr_28
zf      F-old creation (创建折叠)
zo      O-pen a fold (打开折叠)
zc      C-lose a fold (关闭折叠)  

Manual
你手动创建折叠并且折叠将被Vim储存在内存中。
Marker
Vim基于特定的字符组合折叠你的代码。
Diff
在diff文件时使用该特定的折叠类型。
Expr
这让你可以用自定义的Vimscript来决定折叠的位置。它是最为强大的方式，不过也需要最繁重的工作。
Indent
Vim使用你的代码的缩进来折叠。同样缩进等级的代码折叠到一块，空行则被折叠到周围的行一起去。

setlocal foldmethod=indent
setlocal foldignore=

阅读:help foldmethod.
阅读:help fold-manual.
阅读:help fold-marker和:help foldmarker.
阅读:help fold-indent.
阅读:help fdl和:help foldlevelstart.
阅读:help foldminlines.
阅读:help foldignore.
}
Omnicomplete(){

}
vundle(){
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
>> 在 .vimrc 增加相关配置信息
" vundle 环境设置
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
" vundle 管理的插件列表必须位于 vundle#begin() 和 vundle#end() 之间
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'vim-scripts/phd'
Plugin 'Lokaltog/vim-powerline'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'kshenoy/vim-signature'
Plugin 'vim-scripts/BOOKMARKS--Mark-and-Highlight-Full-Lines'
Plugin 'majutsushi/tagbar'
Plugin 'vim-scripts/indexer.tar.gz'
Plugin 'vim-scripts/DfrankUtil'
Plugin 'vim-scripts/vimprj'
Plugin 'dyng/ctrlsf.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-scripts/DrawIt'
Plugin 'SirVer/ultisnips'
Plugin 'Valloric/YouCompleteMe'
Plugin 'derekwyatt/vim-protodef'
Plugin 'scrooloose/nerdtree'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'gcmt/wildfire.vim'
Plugin 'sjl/gundo.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'suan/vim-instant-markdown'
Plugin 'lilydjwg/fcitx.vim'
" 插件列表结束
call vundle#end()
filetype plugin indent on
"
vundle 支持源码托管在 https://github.com/ 的插件，
vim 官网 http://www.vim.org/ 上的所有插件均在
https://github.com/vim-scripts/ 有镜像，

https://github.com/dyng/ctrlsf.vim.git # Plugin 'dyng/ctrlsf.vim'

:PluginInstall
:PluginClean
:PluginUpdate
}