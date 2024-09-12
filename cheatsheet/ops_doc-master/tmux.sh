cat - <<'EOF'
Tmux 就是会话与窗口的"解绑"工具,将它们彻底分离. # 1.server服务器 2.session会话 3.window窗口 4.pane面板
解决问题:会话与窗口可以"解绑":窗口关闭时,会话并不终止,而是继续运行,等到以后需要的时候,再让会话"绑定"其他窗口.
1. 它允许在单个窗口中,同时访问多个会话.这对于同时运行多个命令行程序很有用.
2. 它可以让新窗口"接入"已经存在的会话.
3. 它允许每个会话有多个连接窗口,因此可以多人实时共享会话.
4. 它还支持窗口任意的垂直和水平拆分.

[面向对象] client vs sessions(windows(panes == terminal))
多个client可以连接到用一个server上; 一个client可以切换多个session; 多个client可以attach到同一个session上
一个远程服务器终端窗口可以管理多个tmux会话(session)
一个tmux会话里可以管理多个窗口(window), 窗口(window)之间是互相独立的, 并且可以切换到任一窗口
一个窗口(window)可以划分成多个窗格(pane), 窗格之间是互相独立的, 也可以切换到任一窗格


通常通过session和windows index而非名称来识别window;
window中所有panes的大小和位置称为窗口布局
--------------------------------------------------------------------
1. 程序在terminal中以pane形式运行,每个pane属于一个window.
2. 每个window都有一个名称和一个活动pane.
3. window与一个或多个session相关联.
3. 每个session都有一个window列表,每个window都有一个索引.
4. session中的一个window就是当前window.
5. session连接到一个或多个client,或被分离(不连接到任何client).
6. 每个client只连接一个session.
--------------------------------------------------------------------
Client         | 从外部终端(如 xterm(1))连接 tmux 会话
Session        | 将一个或多个窗口组合在一起
Window         | 将一个或多个窗格组合在一起,并链接到一个或多个会话
Pane           | 包含终端和正在运行的程序,显示在一个窗口中
Active pane    | 当前窗口中输入内容的窗格;每个窗口一个
Current window | 附加会话中发送键入的窗口;每个会话一个
Last window    | 上一个当前窗口
Session name   | 会话名称,默认为从零开始的数字
Window list    | 会话中按编号顺序排列的窗口列表
Window name    | 窗口名称,默认为活动窗格中正在运行的程序名称
Window index   | 会话窗口列表中窗口的编号
Window layout  | 窗口中窗格的大小和位置
--------------------------------------------------------------------

C-M-x 表示同时按下Ctrl、Alt和 x

[面向实例]
[30]  0:bash* 1:bash-      "root@agent109:~/rtu/o" 16:27 08-Oct-20
 1    2       2     3       4
1:会话ID,默认从0开始,依次递增
2:窗口ID,默认从0开始,依次递增
3:当前用户命令目录
4:系统信息

[安装]
sudo apt-get install tmux
sudo yum install tmux
brew install tmux

Ctrl + B ? 帮助 # tmux list-keys
[session]
tmux new    -s <SESSION_NAME>  # New Session
tmux attach -t <SESSION_NAME>  # Attach to a particular tmux session
tmux ls                        # list all tmux sessions
Ctrl+b d:分离当前会话.
Ctrl+b s:列出所有会话.  #
Ctrl+b $:重命名当前会话.
[windows]
Ctrl+b c:创建一个新窗口,状态栏会显示多个窗口的信息.
Ctrl+b p:切换到上一个窗口(按照状态栏上的顺序).
Ctrl+b n:切换到下一个窗口.
Ctrl+b <number>:切换到指定编号的窗口,其中的<number>是状态栏上的窗口编号. # Ctrl+b <0,1,2>
Ctrl+b w:从列表中选择窗口. #
Ctrl+b ,:窗口重命名.                                                      # Ctrl+b ,  Rename tmux window
[pane]
Ctrl+b %:划分左右两个窗格.
# Ctrl+b ":划分上下两个窗格.
# Ctrl+b x:关闭当前窗格.
# Ctrl+b !:将当前窗格拆分为一个独立窗口.
# Ctrl+b o:光标切换到下一个窗格

http://louiszhai.github.io/2017/09/30/tmux/ # 完美一篇
EOF

fzf
bind -n F11 run-shell "tmux list-panes -as -F \"##I.##P ##{pane_current_command} . #{pane_current_path} (#W)#F\" | fzf-tmux | cut -d \" \" -f 1 | xargs tmux select-pane -t"
bind -n F11 run-shell "tmux list-windows -F \"##I:##W\" | fzf-tmux | cut -d \":\" -f 1 | xargs tmux select-window -t"
bind -n F11 run-shell "tmux list-sessions -F \"##S\" | fzf-tmux | xargs tmux switch -t"

web https://pityonline.gitbooks.io/tmux-productive-mouse-free-development_zh/content/

tmux_i_manual()(){ cat - <<'tmux_i_manual'
    tmux 是一个终端多路复用器:它可以在一个屏幕上创建、访问和控制多个终端.tmux 可以从屏幕上分离(detached),在后台继续运行,然后再重新连接(reattached). like nohup
    tmux 是一个在终端运行的程序,允许多个其他终端程序在其中运行.tmux 内的每个程序都有自己的终端,由 tmux 管理,可以从运行 tmux 的单个终端访问这些程序  like screen
这叫多路复用,tmux 就是一个终端多路复用器
    启动 tmux 时,它会创建一个带有单一窗口的新会话,并将其显示在屏幕上.屏幕底部的状态行显示当前会话的信息,并用于输入交互式命令.
    会话是 tmux 管理下的一组伪终端.每个会话都有一个或多个窗口与之相连.窗口占据整个屏幕,并可分割成矩形窗格,每个窗格都是一个独立的伪终端(pty(4)).
同一会话可连接任意数量的 tmux 实例,同一会话可存在任意数量的窗口.一旦所有会话都被杀死,tmux 就会退出.
    每个会话都是持久的,可以在意外断开(如 ssh(1) 连接超时)或有意分离(使用 "C-b d "键)后继续使用
    tmux attach
    在 tmux 中,会话由一个客户端显示在屏幕上,所有会话由一个服务器管理.服务器和每个客户端都是独立的进程,通过 /tmp 中的套接字进行通信

tmux命令, shell脚本, tmux配置文件, tmux脚本
#### tmux 特性
    1. 在 tmux 内运行远程服务器上的程序,防止连接中断.
    2. 允许从多台不同的本地电脑访问远程服务器上运行的程序.
    3. 在一个终端中同时运行多个程序和 shell,有点像窗口管理器.

Options可以控制tmux的行为和外观,tmux的options分为Sever options, Session options, Window options三种.
设置Window option就可以用 setw, set -w, set-window-option
set-option -s     设置sever option
set-option        设置session option
set-window-option 设置window option
set-option -g     设置全局option

tmux的外貌主要提现在status bar上,这里可以配置你想在status bar看到的东西,以及格式等.status bar主要有5个东西组成:
    window 列表
    左侧显示区
    右侧显示区 (1-3其实根据配置决定,比如右侧也可以不显示)
    message显示条(显示message的时候,会占据整个status bar)
    command输入的时候(这时也会占据整个status bar)

Message Style
上面这些东西显示的样式都可以通过style来指定.style是由逗号分割的一个list组成.fg设置前景style,bg设置背景style.
颜色可以使用三种方式来指定:
  black, red, green, yellow, blue, magenta, cyan, white
  从colour0到colour255之间(注意不要打成color),查看所有的颜色
  用css风格的那种 "#ffffff"
除了颜色之外还支持以下属性(前面加上no表示关掉,比如noblink):
bright(blob)
dim
underscore
blink
reverse
hidden
italics
strikethrough
# 命令模式的style设置为(其实是有闪烁效果的)
tmux set-option -g message-command-style fg=yellow,bold,underscore,blink
tmux set-option -g message-command-style bg=black,fg=default,noreverse

# tmux的bell就是如果窗口有活动,窗口就会变成bell的style,来提醒你这个窗口有进程活动已经结束了
widnow-status-style window默认的style
window-status-current-style 当前window的style
window-status-bell-style 有bell的window的style
设置format(但是我觉得用default的format就可以),默认的格式是#I:#W#F,其中I是窗口序号,W是窗口名字,F是窗口标志(例如当前窗口标志是*,最后打开的窗口标志是-,Zoom的窗口标志是Z)


# 增加状态栏的对比度
setw -g window-status-current-style fg=black,bg=yellow
# 将默认在底部的状态栏移动到上面去
set-option -g status-position top

#################### Command Parsing and Execution #### 被tmux和bash 先解析后执行
the shell prompt     # shell命令 tmux set-option -g status-style bg=cyan
a shell script       # shell脚本      命令     标识 参数1        参数2
a configuration file # 配置文件  bind-key C set-option -g status-style bg=cyan
the command prompt   # 交互命令  set-option -g status-style bg=cyan
##### tmux 区分命令解析和执行.为了执行命令,tmux 需要将其拆分成命令名和参数.这就是命令解析
1. 如果从 shell 运行命令,shell 会对其进行解析;
2. 如果从 tmux 内部或配置文件运行命令,tmux 会对其进行解析.
##### 如下位置的脚本会被tmux解析和执行
in a configuration file      # 配置文件
typed at the command prompt  # 交互命令
bind-key                     # 快捷键
if-shell or confirm-before.  # shell命令 run-shell/display-panes

每个客户端都有一个 "命令队列". 在启动时,一个不连接任何客户端的全局命令队列会被用于 ~/.tmux.conf 等配置文件
添加到队列中的已解析命令会按顺序执行. 有些命令(如 if-shell 和 confirm-before)会解析其参数以创建一条新命令,并紧接着插入.
这意味着参数可以被解析两次或更多次--一次是在解析父命令(如 if-shell)时,另一次是在解析并执行其命令时.
if-shell、run-shell 和 display-panes 等命令会停止执行队列中的后续命令,直到发生了什么--if-shell 和 run-shell 命令会停止执行直到 shell 命令结束,
而 display-panes 命令会停止执行直到按下某个键.

#### 如下命令可以被tmux解析,按顺序执行
new-session; new-window
if-shell "true" "split-window"
kill-session

#################### Parsing Syntax ####
命令如何被tmux解析?
; 命令分隔符
1. 如果序列中的某条命令出错,则不会执行后续命令
2. 建议将作为命令分隔符的分号写成一个单独的标记
3. 尾部的分号也被解释为命令分隔符
tmux neww \; splitw 或 tmux neww ';' splitw 或者 neww ; splitw 或者 tmux neww\; splitw 或者 tmux 'neww;' splitw
4. 从 shell 运行 tmux 时,必须特别注意正确引用分号
# tmux neww 'foo\\;' bar ==> tmux neww foo\\\\; bar  shell转义一次,tmux转义一次
# tmux neww 'foo-;-bar'  ==> tmux neww foo-\\;-bar

# 注释
\ 续行,适用于引号字符串内外和注释中,但不适用于大括号内
命令参数可以用单引号(')、双引号(")或大括号({})包围的字符串形式指定
当参数包含任何特殊字符时,必须使用此功能. 单引号和双引号字符串不能跨多行,除非使用续行符. 括号可跨多行
在引号外和双引号内,这些替换将被执行
1. 以 $ 开头的环境变量将被全局环境中的值取代
2. 前导 ~ 或 ~user 会扩展为当前用户或指定用户的主目录
3. \uXXXX 或 \uXXXXXXXX 会被与给定的四位或八位十六进制数相对应的 Unicode 编码点所替代
4. 当前面出现(转义)时,以下字符将被替换: \e由转义字符代替;\r由回车符代替;\n由换行符代替;\t由制表符代替
5. \ooooo 由八进制值 ooo 的字符代替. 需要三个八进制数字,例如 \001. 最大的有效字符是 377
6. 前面的任何其他字符都会被自己替换(即去掉 \),不会被视为有任何特殊含义,例如 \; 不会标记命令序列,\$ 不会扩展环境变量
括号将作为配置文件进行解析(因此"%if "等条件将被处理),然后转换为字符串. 在将一组 tmux 命令作为参数传递(例如传递给 if-shell)时,使用括号可以避免额外的转义
注意:使用 {} 时无需转义
if-shell true {
    display -p 'brace-dollar-foo: }$foo'
}
if-shell true "display -p 'brace-dollar-foo: }\$foo'"
注意:括号内可以包含括号
bind x if-shell "true" {
    if-shell "true" {
        display "true!"
    }
}

%hidden MYVAR=42
#### 多行控制语句
%if "#{==:#{host},myhost}"
set -g status-style bg=red
%elif "#{==:#{host},myotherhost}"
set -g status-style bg=green
%else
set -g status-style bg=blue
%endif
#### 单行控制语句
%if #{==:#{host},myhost} set -g status-style bg=red %endif

#################### Commands ####
session
以 $ 为前缀的会话 ID.
会话的确切名称(如 list-sessions 命令所列).
会话名称的开头,例如 "mysess "将匹配名为 "mysession "的会话.
与会话名称匹配的 fnmatch(3) 模式.

session:window
特殊标识符,如下所列
{start}     ^  The lowest-numbered window
{end}       $  The highest-numbered window
{last}      !  The last (previously current) window
{next}      +  The next window by number
{previous}  -  The previous window by number
窗口索引,例如 "mysession:1 "是会话 "mysession "中的窗口 1.
窗口 ID,例如 @1.
确切的窗口名称,例如 "mysession:mywindow".
窗口名称的起始部分,例如 "mysession:mywin". 与窗口名称匹配的 fnmatch(3) 模式

mysession:mywindow.1
特殊标识符,如下所列
{last}      !   The last (previously active) pane
{next}      +   The next pane by number
{previous}  -   The previous pane by number
{top}           The top pane
{bottom}        The bottom pane
{left}          The leftmost pane
{right}         The rightmost pane
{top-left}      The top-left pane
{top-right}     The top-right pane
{bottom-left}   The bottom-left pane
{bottom-right}  The bottom-right pane
{up-of}         The pane above the active pane
{down-of}       The pane below the active pane
{left-of}       The pane to the left of the active pane
{right-of}      The pane to the right of the active pane
select-window -t:+2

shell-command
new-window 'vi ~/.tmux.conf'       等价于 /bin/sh -c 'vi ~/.tmux.conf' 等价于 tmux new-window vi ~/.tmux.conf
bind-key F1 set-option status off  等价于 bind-key F1 { set-option status off }

[tmux解析]
refresh-client -t/dev/ttyp2
rename-session -tfirst newname
set-option -wt:0 monitor-activity on
new-window ; split-window -d
bind-key R source-file ~/.tmux.conf \; \
	display-message "source-file done"

[shell解析]
$ tmux kill-window -t :1
$ tmux new-window \; split-window -d
$ tmux new-session -d 'vi ~/.tmux.conf' \; split-window -d \; attach

########### Formats
如 "#S";"##"用单个 "#"代替,"#, "用", "代替,"#}"用"}"代替
#{session_name}                                              #
#{?session_attached,attached,not attached}                   # 在会话已连接的情况下将包含字符串 "attached",在未连接的情况下将包含字符串 "not attached".条件可以任意嵌套
#{?pane_in_mode,#[fg=white#,bg=red],#[fg=red#,bg=white]}#W . # 嵌套
字符串比较可以用"=="、"！="、"<"、">"、"<="或">="和冒号作为两个逗号分隔的前缀来表示
"#{==:#{host},myhost}"                      # 如果运行在 "myhost "上,则替换为 "1",否则替换为 "0"
"#{||:#{pane_in_mode},#{alternate_on}}"     # ||"和"&&"在两个用逗号分隔的选项中的一个或两个都为真的情况下会被置换为 true
m "表示 fnmatch(3) 或正则表达式比较.第一个参数是模式,第二个参数是要比较的字符串.可选参数指定了标志:r'表示模式是正则表达式,而不是默认的 fnmatch(3) 模式;'i'表示忽略大小写.
"#{m:*foo*,#{host}}"
"#{m/ri:^A,MYVAR}"

数字运算符可以通过在两个逗号分隔的选项前加上 "e "和运算符来执行.在运算符后可选择使用 "f "标志,否则将使用整数.运算符后还可以加上一个数字,表示运算结果的小数位数.可用的运算符有:加法运算符 "+"、减法运算符"-"、乘法运算符 "*"、除法运算符"/"、模数运算符 "m "或"%"
"#{e|*|f|4:5.5,3}"将 5.5 乘以 3,得到小数点后四位的结果
"#{e|%%:7,3}"返回 7 和 3 的模.c'用六位十六进制 RGB 值替换 tmux 颜色

通过在字符串前加上"="、数字和冒号,可以限制结果字符串的长度.正数从字符串的起点开始计数,负数从字符串的终点开始计数
"#{=5:pane_title}"最多包含窗格标题的前五个字符
"#{=-5:pane_title}"最多包含窗格标题的后五个字符

后缀或前缀可以作为第二个参数给出--如果提供了后缀或前缀,那么在长度被修剪后,后缀或前缀将被附加到字符串中
如果窗格标题超过 5 个字符,"#{=/5/...:pane_title}"将附加"..."
"p "会将字符串填充到给定的宽度,例如,"#{p10:pane_title}"的宽度至少为 10 个字符.宽度为正数的字符串会填充到左边,宽度为负数的字符串会填充到右边.n'扩展为变量的长度,'w'扩展为显示时的宽度,例如'#{n:window_name}'.

在时间变量前加上 "t: "会将其转换为字符串
"#{window_activity}"表示 "1445765102"
"#{t:window_activity}"表示 "Sun Oct 25 09:25:02 2015"
添加'p (' '`t/p`')后,过去的时间将使用更短但不太准确的时间格式
自定义格式可以使用后缀'f'(注意,如果格式单独通过 strftime(3) 传递,例如在 status-left 选项中,'%'必须转义为'%%'):'#{t/f/%%H#:%%M:window_activity}'

前缀 "b: "和 "d: "分别表示变量的 basename(3) 和 dirname(3)
q:'将转义 sh(1) 特殊字符,或以'h'为后缀转义哈希字符(因此'#'变为'##')
E:'会将格式扩展两次,例如'#{E:status-left}'是扩展 status-left 选项内容而不是选项本身的结果
T:'和'E:'一样,也会扩展 strftime(3) 参数.S:"、"W:"、"P: "或 "L: "将循环显示每个会话、窗口、窗格或客户端,并为每个会话、窗口、窗格或客户端插入一次格式
对于窗口和窗格,可以给出两个以逗号分隔的格式:第二个格式用于当前窗口或活动窗格
#{W:#{E:window-status-format} ,#{E:window-status-current-format} }

N:'检查是否存在窗口(不含后缀或后缀为'w')或会话(后缀为's')名称,例如,如果存在名为'foo'的窗口,'`N/w:foo`'将被替换为 1

前缀形式为 "s/foo/bar/: "的前缀会将 "foo "替换为 "bar".第一个参数可以是扩展正则表达式

使用 "#() "插入 shell 命令输出的最后一行.例如,"#(uptime) "将插入系统的运行时间.在构建格式时,tmux 不会等待 "#() "命令结束,而是使用运行同一命令的前一个结果,如果该命令之前未运行过,则使用占位符
如果命令尚未退出,则使用最新的输出行,但状态行每秒更新的次数不会超过一次.命令使用 /bin/sh 执行,并设置了 tmux 全局环境

l "表示字符串应按字面解释,而不应展开.例如,"#{l:#{?pane_in_mode,yes,no}}"将被替换为 "#{?pane_in_mode,yes,no}".


########### Styles
tmux 提供各种选项来指定界面各部分的颜色和属性,例如状态行的 status-style.此外,还可以通过 "#["和"]"来指定格式选项(如 status-left)中的嵌入式样式
fg=yellow bold underscore blink
bg=black,fg=default,noreverse

########### Status Line
status-left、status-left-length、status-right 和 status-right-length
window-status-format 和 window-status-current-format

Symbol  Meaning
*       Denotes the current window.
-       Marks the last window (previously selected).
#       Window activity is monitored and activity has been detected.
!       Window bells are monitored and a bell has occurred in the window.
~       The window has been silent for the monitor-silence interval.
M       The window contains the marked pane.
Z       The window's active pane is zoomed.

状态行的颜色和属性可以配置,整个状态行使用 status-style session 选项,单个窗口使用 window-status-style window 选项.
状态行每隔一段时间会自动刷新一次,如果状态行发生变化,可以使用 status-interval 会话选项控制刷新间隔.

display-menu
confirm-before
display-message
display-popup
show-prompt-history

########### Miscellaneous
if-shell [-bF] [-t target-pane] shell-command command [command]
run-shell [-bC] [-c start-directory] [-d delay] [-t target-pane] [shell-command]
wait-for [-L | -S | -U] channel

########### Control Mode
tmux 提供名为控制模式的文本接口.这允许应用程序使用简单的纯文本协议与 tmux 通信
在控制模式下,客户端在标准输入端发送以换行结束的 tmux 命令或命令序列.每条命令都会在标准输出上产生一个输出块.
输出块由 %begin 行和输出内容(可能为空)组成.输出块以 %end 或 %error 结束.%begin和与之匹配的%end或%error有三个参数:整数时间

##############
# Status bar #
##############
# set the style
set -g status-style bg=default,bold
set -g message-command-style fg=colour3,bg=colour8
set -g message-style bg=colour8
set -g pane-border-style fg=colour4,bg=default
set -g pane-active-border-style fg=colour3,bg=default
# statusline
set -g status-left "#{?client_prefix,[#S], #S }"
set -g status-left-style fg=colour14,bg=default
set -g status-right "#(whoami)@#H "
set -g status-right-length 120
setw -g window-status-separator "  "
setw -g window-status-style fg=colour7,bg=default
setw -g window-status-activity-style fg=colour1,bg=default
setw -g window-status-current-style fg=colour3,bg=default
setw -g window-status-format "#I#{?window_zoomed_flag,Z, }#W"
setw -g window-status-current-format "#I#{?window_zoomed_flag,Z, }#W"
set -g status-position "bottom"
set -g status-justify "centre"


######################
### DESIGN CHANGES ###
######################
# panes
set -g pane-border-fg black
set -g pane-active-border-fg brightred
## Status bar design
# status line
# set -g status-utf8 on
set -g status-justify left
set -g status-bg default
set -g status-fg colour12
set -g status-interval 2
# messaging
set -g message-fg black
set -g message-bg yellow
set -g message-command-fg blue
set -g message-command-bg black
#window mode
setw -g mode-bg colour6
setw -g mode-fg colour0
# window status
setw -g window-status-format " #F#I:#W#F "
setw -g window-status-current-format " #F#I:#W#F "
setw -g window-status-format "#[fg=magenta]#[bg=black] #I #[bg=cyan]#[fg=colour8] #W "
setw -g window-status-current-format "#[bg=brightmagenta]#[fg=colour8] #I #[fg=colour8]#[bg=colour14] #W "
setw -g window-status-current-bg colour0
setw -g window-status-current-fg colour11
setw -g window-status-current-attr dim
setw -g window-status-bg green
setw -g window-status-fg black
setw -g window-status-attr reverse
# Info on left (I don't have a session display for now)
set -g status-left ''
# loud or quiet?
set-option -g visual-activity off
set-option -g visual-bell off
set-option -g visual-silence off
set-window-option -g monitor-activity off
set-option -g bell-action none
set -g default-terminal "screen-256color"
# The modes {
setw -g clock-mode-colour colour135
setw -g mode-attr bold
setw -g mode-fg colour196
setw -g mode-bg colour238
# }
# The panes {
set -g pane-border-bg colour235
set -g pane-border-fg colour238
set -g pane-active-border-bg colour236
set -g pane-active-border-fg colour51
# }
# The statusbar {
set -g status-position bottom
set -g status-bg colour234
set -g status-fg colour137
set -g status-attr dim
set -g status-left ''
set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
set -g status-right-length 50
set -g status-left-length 20
setw -g window-status-current-fg colour81
setw -g window-status-current-bg colour238
setw -g window-status-current-attr bold
setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
setw -g window-status-fg colour138
setw -g window-status-bg colour235
setw -g window-status-attr none
setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
setw -g window-status-bell-attr bold
setw -g window-status-bell-fg colour255
setw -g window-status-bell-bg colour1
# }


tmux_i_manual
}
tmux_i_format(){ cat - <<'tmux_i_format'
tmux list-windows -F "#{window_id} #{window_name}"

tmux list-panes -F "pane: #{pane_id}, window: #{window_id}, \
      session: #{session_id}, server: #{socket_path}"

tmux list-windows -F "window: #{window_id}, panes: #{window_panes} \
      pane_id: #{pane_id}"

tmux list-panes -F "#{pane_id} #{pane_current_command} \
      #{pane_current_path} #{cursor_x},#{cursor_y}"

"#{session_name}: #{session_windows} windows (created #{t:session_created})\
#{?session_grouped, (group ,}#{session_group}#{?session_grouped,),}\
#{?session_attached, (attached),}"

tmux_i_format
}
tmux_i_style(){ cat - <<'tmux_i_format'
set -g status-right "#[fg=green] | #[fg=white]#(tmux-mem-cpu-load)#[fg=green] | #[fg=cyan]%H:%M #[default]"
set -g status-left "#[fg=red] #H#[fg=green]:#[fg=white]#S#[fg=green] |#[default]"

set-window-option -g window-status-current-format "#[fg=colour235, bg=colour27]⮀#[fg=colour255, bg=colour27] #I ⮁ #W #[fg=colour27, bg=colour235]⮀"

set-option -g default-terminal "screen-256color"        # Basic color support setting
set-option -g status-style bg='#1b1c36',fg='#ecf0c1'    # Default bar color
set -g pane-active-border-style "fg=#5ccc96"            # Active Pane
set -g pane-border-style "fg=#686f9a"                   # Inactive Pane
set-option -g window-status-current-style bg='#686f9a',fg='#ffffff' # Active window
set-option -g message-style bg='#686f9a',fg='#ecf0c1'   # Message
set-option -g message-command-style bg='#686f9a',fg='#ecf0c1'
set -g message-style "fg=#0f111b,bg=#686f9a"            # When Commands are run

# setw -g window-status-format '#[fg=8,bg=default]#I'    # set -g status off | on 不显示和显示状态栏
# Attribute       colors ##########
# Key             Description
# #[fg=1]         standard color
# #[fg=yellow]    yellow
# #[bold]         bold
# #[fg=colour240] 256 color
# #[fg=default]   default
# #[fg=1,bg=2]    combinations
# #[default]      reset
#### Colors         ##########
# black red green yellow blue magenta cyan white
# brightred (and so on)
# colour0 ... colour255
# #333 (rgb hex)
#### Attributes     ##########
# bold underscore blink noreverse hidden dim italics
tmux_i_format
}
tmux_i_wemux(){ cat - <<'tmux_i_wemux'
wemux 增强了 tmux 的功能,使多用户终端复用变得更简单、更强大. 它允许用户托管一个 wemux 服务器,并让客户端加入其中:
Mirror Mode  镜像模式允许客户端(你机器上的另一个 SSH 用户)只读访问会话,让他们看到你的工作;
Pair Mode    配对模式允许客户端和你自己在同一个终端(共享光标)中工作;
Rogue Mode   流氓模式允许客户端在同一个 tmux 会话中配对或在另一个窗口(独立光标)中独立工作.
它支持多服务器,还提供用户列表和用户加入/退出时的通知功能.

https://github.com/zolrath/wemux
tmux_i_wemux
}

tmux_i_xpanes(){ cat - <<'tmux_i_xpanes'
xpanes -c "ping {}" 192.168.0.{1..9}
xpanes --log=~/log --ssh user1@host1 user2@host2 user2@host3
xpanes -x -e "top" "vmstat 1" "watch -n 1 df"

xpanes 1 2 3 4
xpanes -c 'seq {}' 1 2 3 4
https://github.com/greymd/tmux-xpanes
tmux_i_xpanes
}
tmux_i_tmuxp(){ cat - <<'tmux_i_tmuxp'
tmux 的会话管理器,允许用户通过简单的配置文件保存和加载 tmux 会话. 由 libtmux 支持
https://github.com/tmux-python/tmuxp
https://github.com/tmuxinator/tmuxinator
tmux_i_tmuxp
}
tmux_i_twm(){ cat - <<'tmux_i_twm'
twm 是一款高性能、可定制的工具,用于将工作区作为 tmux 会话进行管理.合理的默认设置可以让你无需任何配置即可开始运行,你也可以将其设置为适合你喜欢的任何工作流程
https://github.com/vinnymeller/twm
tmux_i_twm
}
tmux_i_whichkey(){ cat - <<'tmux_i_whichkey'
https://github.com/jaclu/tmux-menus
https://github.com/alexwforsythe/tmux-which-key
tmux_i_whichkey
}


tmux_i_default_hotkey(){ cat - <<'tmux_i_default_hotkey'
分类     按键                         描述
基本操作 C-b                          命令按键前缀
基本操作 :                            进入tmux命令行提示
基本操作 ?                            显示所有的键盘绑定
基本操作 t                            显示时间
基本操作 ~                            从tmux中显示以前的消息,如果有的话
基本操作 C-z                          挂起tmux客户端
基本操作 D                            交互模式分离客户端
基本操作 d                            分离当前客客户端
基本操作 r                            强制重绘连接的客户端
会话     $                            重命名当前会话
会话     (                            将客户端切换到以前的会话
会话     )                            将客户端切换到下一个会话
会话     L                            将客户端切换回上一个会话
会话     s                            交互模式切换客户端会话
窗口     0 to 9                       根据选择的索引切换窗口
窗口     f                            在打开的窗口交互模式搜索窗口
窗口     w                            交互模式选择当前窗口
窗口     '                            交互模式切换窗口
窗口     ,                            重命名当前窗口
窗口     &                            杀死当前窗口
窗口     i                            显示当前窗口的一些信息
窗口     n                            切换到后一个窗口
窗口     p                            切换到前一个窗口
窗口     c                            创建新窗口
窗口     .                            重设当前窗口的索引
窗口     l                            切换到上一次的窗口
窗口     C-o                          将当前窗口向前移动
窗口     M-n                          移动到下一个窗口,响铃或激活标记
窗口     M-p                          移动到以前的窗口,响铃或激活标记
面板     z                            把当前pane最大化/恢复
面板     "                            将当前面板纵向分割为上下2个
面板     %                            将当前面板横向分割为左右2个
面板     !                            将当前面板拆离为一个窗口
面板     ;                            移动到以前激活的面板
面板     o                            切换到下一个面板
面板     q                            显示面板索引
面板     x                            杀死当前面板
面板     {                            把当前的面板移到左边
面板     }                            把当前的面板移到右边
面板     m                            标记当前pane(参见select-pane -m)
面板     M                            清除标记的pane
面板     Space                        切换到下一个系统默认布局
面板     Up, Down Left, Right         切换到当前面板的上下左右面板
面板     M-1 to M-5                   以五种预设布局之一排列窗格:偶数水平、偶数垂直、主水平、主垂直或平铺. 空格 以下一个预设布局排列当前窗口
面板     M-o                          向后旋转当前窗口中的窗格
面板     C-Up, C-Down C-Left, C-Right 调整面板的大小,每次1个单位
面板     M-Up, M-Down M-Left, M-Right 调整面板的大小,每次5个单位
文本操作 #                            列出所有粘贴buffers
文本操作 -                            删除最近靠拷贝的文本buffer
文本操作 =                            交互式从列表中选择粘贴哪一个buffer
文本操作 [                            进入复制模式或者显示历史
文本操作 ]                            进入粘贴模式
文本操作 Page Up                      进入拷贝模式并向上滚动一页

# https://github.com/tmux/tmux/blob/master/key-bindings.c
bind-key -T prefix C-k          send-prefix
bind-key -T prefix C-o          rotate-window
bind-key -T prefix C-x          confirm-before -p "kill-window #W?(y/n)" kill-window
bind-key -T prefix C-z          suspend-client
bind-key -T prefix Space        next-layout
bind-key -T prefix !            break-pane
bind-key -T prefix "            split-window -v
bind-key -T prefix #            select-pane -t .3 ; resize-pane -Z
bind-key -T prefix $            command-prompt -I #S "rename-session '%%'"
bind-key -T prefix %            split-window -h
bind-key -T prefix &            confirm-before -p "kill-window #W?" kill-window
bind-key -T prefix '            command-prompt -p index "select-window -t ':%%'"
bind-key -T prefix (            switch-client -p
bind-key -T prefix )            switch-client -n
bind-key -T prefix *            select-pane -t .8 ; resize-pane -Z
bind-key -T prefix ,            command-prompt -I #W "rename-window '%%'"
bind-key -T prefix -            delete-buffer
bind-key -T prefix .            command-prompt "move-window -t '%%'"
bind-key -T prefix 0            select-window -t :=0
bind-key -T prefix 1            select-window -t :=1
bind-key -T prefix 2            select-window -t :=2
bind-key -T prefix 3            select-window -t :=3
bind-key -T prefix 4            select-window -t :=4
bind-key -T prefix 5            select-window -t :=5
bind-key -T prefix 6            select-window -t :=6
bind-key -T prefix 7            select-window -t :=7
bind-key -T prefix 8            select-window -t :=8
bind-key -T prefix 9            select-window -t :=9
bind-key -T prefix :            command-prompt
bind-key -T prefix ;            last-pane
bind-key -T prefix =            choose-buffer
bind-key -T prefix ?            list-keys
bind-key -T prefix @            select-pane -t .2 ; resize-pane -Z
bind-key -T prefix D            choose-client
bind-key -r -T prefix H         resize-pane -L 5
bind-key -r -T prefix J         resize-pane -D 5
bind-key -r -T prefix K         resize-pane -U 5
bind-key -r -T prefix L         resize-pane -R 5
bind-key -T prefix M            select-pane -M
bind-key -T prefix [            copy-mode
bind-key -T prefix ]            paste-buffer
bind-key -T prefix ^            select-pane -t .6 ; resize-pane -Z
bind-key -T prefix _            split-window -v
bind-key -T prefix b            list-buffers
bind-key -T prefix c            new-window
bind-key -T prefix d            detach-client
bind-key -T prefix f            command-prompt "find-window '%%'"
bind-key -r -T prefix h         select-pane -L
bind-key -T prefix i            display-message
bind-key -r -T prefix j         select-pane -D
bind-key -r -T prefix k         select-pane -U
bind-key -r -T prefix l         select-pane -R
bind-key -T prefix m            select-pane -m
bind-key -T prefix n            next-window
bind-key -T prefix o            select-pane -t :.+
bind-key -T prefix p            previous-window
bind-key -T prefix q            display-panes
bind-key -T prefix r            source-file /home/walle/.tmux.conf ; display-message "Config reloaded.."
bind-key -T prefix s            choose-tree
bind-key -T prefix t            clock-mode
bind-key -T prefix w            choose-window
bind-key -T prefix x            confirm-before -p "kill-pane #P? (y/n)" kill-pane
bind-key -T prefix z            resize-pane -Z
bind-key -T prefix {            swap-pane -U
bind-key -T prefix |            split-window -h
bind-key -T prefix }            swap-pane -D
bind-key -T prefix ~            show-messages
bind-key -T prefix PPage        copy-mode -u
bind-key -T prefix Up           new-window -d -n tmp ; swap-pane -s tmp.1 ; select-window -t tmp
bind-key -T prefix Down         last-window ; swap-pane -s tmp.1 ; kill-window -t tmp
bind-key -r -T prefix Left      select-pane -L
bind-key -r -T prefix Right     select-pane -R
bind-key -T prefix M-1          select-pane -t .1
bind-key -T prefix M-2          select-pane -t .2
bind-key -T prefix M-3          select-pane -t .3
bind-key -T prefix M-4          select-pane -t .4
bind-key -T prefix M-5          select-pane -t .5
bind-key -T prefix M-6          select-pane -t .6
bind-key -T prefix M-7          select-pane -t .7
bind-key -T prefix M-8          select-pane -t .8
bind-key -T prefix M-9          select-pane -t .9
bind-key -T prefix M-n          next-window -a bind-key -T prefix M-o rotate-window -D
bind-key -T prefix M-p          previous-window -a
bind-key -r -T prefix M-Up      resize-pane -U 5
bind-key -r -T prefix M-Down    resize-pane -D 5
bind-key -r -T prefix M-Left    resize-pane -L 5
bind-key -r -T prefix M-Right   resize-pane -R 5
bind-key -T prefix C-1          select-pane -t .1 ; resize-pane -Z
bind-key -T prefix C-2          select-pane -t .2 ; resize-pane -Z
bind-key -T prefix C-3          select-pane -t .3 ; resize-pane -Z
bind-key -T prefix C-4          select-pane -t .4 ; resize-pane -Z
bind-key -T prefix C-5          select-pane -t .5 ; resize-pane -Z
bind-key -T prefix C-6          select-pane -t .6 ; resize-pane -Z
bind-key -T prefix C-7          select-pane -t .7 ; resize-pane -Z
bind-key -T prefix C-8          select-pane -t .8 ; resize-pane -Z
bind-key -T prefix C-9          select-pane -t .9 ; resize-pane -Z
bind-key -r -T prefix C-Up      resize-pane -U
bind-key -r -T prefix C-Down    resize-pane -D
bind-key -r -T prefix C-Left    resize-pane -L
bind-key -r -T prefix C-Right   resize-pane -R
bind-key -T root MouseDown1Pane select-pane -t = ; send-keys -M
bind-key -T root MouseDown1Status select-window -t =
bind-key -T root MouseDown3Pane select-pane -m -t =
bind-key -T root MouseDrag1Pane if-shell -F -t = #{mouse_any_flag} "if -Ft= "#{pane_in_mode}" "copy-mode -M" "send-keys -M"" "copy-mode -M"
bind-key -T root MouseDrag1Border resize-pane -M
tmux_i_default_hotkey
}

tmux_i_tpm(){ cat - <<'tmux_i_tpm'
tpm安装过程如下所示:
cd ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm

安装后需在~/.tmux.conf中增加如下配置:
# 默认需要引入的插件
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
# 引入其他插件的示例
# set -g @plugin 'github_username/plugin_name' # 格式:github用户名/插件名
# set -g @plugin 'git@github.com/user/plugin' # 格式:git@github插件地址
# 初始化tmux插件管理器(保证这行在~/.tmux.conf的非常靠后的位置)
run '~/.tmux/plugins/tpm/tpm'
然后按下prefix + r重载tmux配置,使得tpm生效.

[安装插件]
基于tpm插件管理器,安装插件仅需如下两步:
在~/.tmux.conf中增加新的插件,如set -g @plugin '...'.
按下prefix + I键下载插件,并刷新tmux环境.

[更新插件] 请按下prefix + U 键,选择待更新的插件后,回车确认并更新.

[卸载插件],需如下两步:
在~/.tmux.conf中移除插件所在行.
按下prefix + alt + u 移除插件.
tmux_i_tpm
}

tmux_i_tmate(){ cat - <<'tmux_i_tmate'
tmux多会话连接实时同步的功能,使得结对编程成为了可能,这也是开发者最喜欢的功能之一.现在就差一步了,就是借助tmate把tmux会话分享出去.
tmate是tmux的管理工具,它可以轻松的创建tmux会话,并且自动生成ssh链接.

1. 安装tmate
brew install tmate
2. 使用tmate新建一个tmux会话
tmate
3. 查看tmate生成的ssh链接
tmate show-messages

tmux_i_tmate
}

tmux_i_matryoshka(){ cat - <<'tmux_i_ttmux_i_matryoshkamate'
你在本地和非本地机器上都使用 tmux 执行工作流程,你想使用本地 tmux 连接远程机器.不幸的是,本地 tmux 会捕获所有 tmux 按键绑定,导致你无法与远程 tmux 实例通信.
解决方法 使用 tmux-matryoshka 暂时禁用外部的本地 tmux,并将其遗忘.现在所有的 tmux 键绑定都会转发到嵌套的远程 tmux 实例. 如果需要与本地或远程的其他嵌套 tmux 实例通信,可以重复此过程1

press F1 to disable the outer-most active tmux instance
press F2 to enable the inner-most inactive tmux instance
press F3 to recursively enable all tmux instances3

https://github.com/MunifTanjim/tmux-suspend
https://github.com/aleclearmind/nested-tmux


bind -T root F12  \
  set prefix None \;\
  set key-table off \;\
  set status-style "fg=$color_status_text,bg=$color_window_off_status_bg" \;\
  set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]" \;\
  set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg" \;\
  if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
  refresh-client -S \;\

bind -T off F12 \
  set -u prefix \;\
  set -u key-table \;\
  set -u status-style \;\
  set -u window-status-current-style \;\
  set -u window-status-current-format \;\
  refresh-client -S

wg_is_keys_off="#[fg=$color_light,bg=$color_window_off_indicator]#([ $(tmux show-option -qv key-table) = 'off' ] && echo 'OFF')#[default]"

set -g status-right "$wg_is_keys_off #{sysstat_cpu} | #{sysstat_mem} | #{sysstat_loadavg} | $wg_user_host"

tmux.conf 摘录,用于切换会话键绑和前缀处理的开/关
tmux_i_matryoshka
}


tmux_i_session_restore(){ cat - <<'tmux_i_session_restore'
https://github.com/tmux-plugins/tmux-resurrect   # 手动保存和恢复
https://github.com/tmux-plugins/tmux-continuum   # 自动保存和恢复
保存时,tmux会话的详细信息会以文本文件的格式保存到~/.tmux/resurrect目录,恢复时则从此处读取,由于数据文件是明文的,因此你完全可以自由管理或者编辑这些会话状态文件

run-shell ~/tmp/resurrect.tmux
run-shell ~/tmp/continuum.tmux
两个插件都需要 Tmux >= 1.9 才行

保存状态:prefix + Ctrl-s
恢复状态:prefix + Ctrl-r

[可选的配置] tmux-resurrect
Tmux Resurrec本身是免配置开箱即用的,但同时也提供了如下选项以便修改其默认设置.
set -g @resurrect-save 'S'      # 修改保存指令为S
set -g @resurrect-restore 'R'   # 修改恢复指令为R
# 修改会话数据的保持路径,此处不能使用除了$HOME, $HOSTNAME, ~之外的环境变量
set -g @resurrect-dir '/some/path'

[可选的配置] tmux-continuum
Tmux Continuum默认每隔15mins备份一次,我设置的是一天一次:
set -g @continuum-save-interval '1440'
关闭自动备份,只需设置时间间隔为 0 即可:
set -g @continuum-save-interval '0'
想要在tmux启动时就恢复最后一次保存的会话环境,需增加如下配置:
set -g @continuum-restore 'on' # 启用自动恢复

# 显示自动保存状态
set -g status-right 'Continuum status: #{continuum_status}'
tmux运行时,#{continuum_status} 将显示保存的时间间隔(单位为分钟),此时状态栏会显示:
Continuum status: 1440
如果其自动保存功能关闭了,那么状态栏会显示:
Continuum status: off
tmux_i_session_restore
}


tmux_i_conf(){ cat - <<'tmux_i_conf'
[修改快捷键前缀]
tmux的用户级配置文件为~/.tmux.conf(没有的话就创建一个),修改快捷指令,只需要增加如下三行即可.
set -g prefix C-a       #
unbind C-b              # C-b即Ctrl+b键,unbind意味着解除绑定
bind C-a send-prefix    # 绑定Ctrl+a为新的指令前缀
# 从tmux v1.6版起,支持设置第二个指令前缀
set-option -g prefix2 '# 设置一个不常用的'键作为指令前缀,按键更快些

[-f file] source-file
/etc/tmux.conf ->  ~/.tmux.conf, $XDG_CONFIG_HOME/tmux/tmux.conf or ~/.config/tmux/tmux.conf.
[-L socket-name] TMUX_TMPDIR or /tmp 1.default 2.in a directory tmux-UID 3.SIGUSR1 recreate
[-u] == -T UTF-8
[-v] tmux-client-PID.log and tmux-server-PID.log 1.-vv tmux-out-PID.log 2.SIGUSR2 on/off

[重新加载配置]
# 在tmux窗口中,先按下Ctrl+b指令前缀,然后按下系统指令:,进入到命令模式后输入source-file ~/.tmux.conf,回车后生效
# 绑定快捷键为r
bind     r source-file ~/.tmux.conf \; display-message "Config reloaded.."
bind-key R source-file ~/.tmux.conf \; display-message "source-file done"
[新增面板]
unbind '"'
bind - splitw -v -c '#{pane_current_path}' # 垂直方向新增面板,默认进入当前目录
unbind %
bind | splitw -h -c '#{pane_current_path}' # 水平方向新增面板,默认进入当前目录

[开启鼠标支持]
对于tmux v2.1(2015.10.28)之前的版本,需加入如下配置:
setw -g mode-mouse on           # 支持鼠标选取文本等
setw -g mouse-resize-pane on    # 支持鼠标拖动调整面板的大小(通过拖动面板间的分割线)
setw -g mouse-select-pane on    # 支持鼠标选中并切换面板
setw -g mouse-select-window on  # 支持鼠标选中并切换窗口(通过点击状态栏窗口名称)
# 对于tmux v2.1及以上的版本
set-option -g mouse on          # 等同于以上4个指令的效果

[快速面板切换]
# 绑定hjkl键为面板切换的上下左右键 ==> -r表示可重复按键,大概500ms之内,重复的h、j、k、l按键都将有效,完美支持了快速切换的Geek需求
bind -r k select-pane -U # 绑定k为↑
bind -r j select-pane -D # 绑定j为↓
bind -r h select-pane -L # 绑定h为←
bind -r l select-pane -R # 绑定l为→

除了上下左右外, 还有几个快捷指令可以设置.
bind -r e lastp     # 选择最后一个面板
bind -r ^e last     # 选择最后一个窗口
bind -r ^u swapp -U # 与前一个面板交换位置
bind -r ^d swapp -D # 与后一个面板交换位置

[面板大小调整]
# 绑定Ctrl+hjkl键为面板上下左右调整边缘的快捷指令
bind -r ^k resizep -U 10 # 绑定Ctrl+k为往↑调整面板边缘10个单元格
bind -r ^j resizep -D 10 # 绑定Ctrl+j为往↓调整面板边缘10个单元格
bind -r ^h resizep -L 10 # 绑定Ctrl+h为往←调整面板边缘10个单元格
bind -r ^l resizep -R 10 # 绑定Ctrl+l为往→调整面板边缘10个单元格

[窗口变为面板]
join-pane -s window01   # 合并名称为window01的窗口的默认(第一个)面板到当前窗口中
join-pane -s window01.1 # .1显式指定了第一个面板,.2就是第二个面板(我本地将面板编号起始值设置为1,默认是0)

格式为join-pane -s [session_name]:[window].[pane]
    如join-pane -s 2:1.1                         即合并第二个会话的第一个窗口的第一个面板到当前窗口,当目标会话的窗口和面板数量为0时,会话便会关闭.

[其他配置]
bind m command-prompt "splitw -h 'exec man %%'"         # 绑定m键为在新的panel打开man
# 绑定P键为开启日志功能,如下,面板的输出日志将存储到桌面
bind P pipe-pane -o "cat >>~/Desktop/#W.log" \; display "Toggled logging to ~/Desktop/#W.log"

[Tmux优化]
1. 设置窗口面板起始序号
set -g base-index 1         # 设置窗口的起始下标为1
set -g pane-base-index 1    # 设置面板的起始下标为1

2. 自定义状态栏  https://think.leftshadow.com/docs/tmux/config/
set -g status-utf8 on       # 状态栏支持utf8
set -g status-interval 1    # 状态栏刷新时间
set -g status-justify left  # 状态栏列表左对齐
setw -g monitor-activity on # 非当前窗口有内容更新时在状态栏通知

set -g status-bg black      # 设置状态栏背景黑色
set -g status-fg yellow     # 设置状态栏前景黄色
set -g status-style "bg=black, fg=yellow" # 状态栏前景背景色

set -g status-left "#[bg=#FF661D] ❐ #S " # 状态栏左侧内容
set -g status-right 'Continuum status: #{continuum_status}' # 状态栏右侧内容
set -g status-left-length 300   # 状态栏左边长度300
set -g status-right-length 500  # 状态栏左边长度500

set -wg window-status-format " #I #W "              # 状态栏窗口名称格式
set -wg window-status-current-format " #I:#W#F "    # 状态栏当前窗口名称格式(#I:序号,#w:窗口名称,#F:间隔符)
set -wg window-status-separator ""                  # 状态栏窗口名称之间的间隔
set -wg window-status-current-style "bg=red"        # 状态栏当前窗口名称的样式
set -wg window-status-last-style "fg=red"           # 状态栏最后一个窗口名称的样式
set -g message-style "bg=#202529, fg=#91A8BA"       # 指定消息通知的前景、后景色

3. 开启256 colors支持
默认情况下,tmux中使用vim编辑器,文本内容的配色和直接使用vim时有些差距,此时需要开启256 colors的支持,配置如下.
set -g default-terminal "screen-256color"
或者:
set -g default-terminal "tmux-256color"
或者启动tmux时增加参数-2:
alias tmux='tmux -2' # Force tmux to assume the terminal supports 256 colours

4. 关闭默认的rename机制
tmux默认会自动重命名窗口,频繁的命令行操作,将频繁触发重命名,比较浪费CPU性能,性能差的计算机上,问题可能更为明显.建议添加如下配置关闭rename机制.
setw -g automatic-rename off
setw -g allow-rename off

exit-empty [on | off]  # on:没有session退出tmux server. 1.start-server 启动tmux而不创建session 2. -D 设置exit-empty=off

[命令在shell,配置文件和命令行格式]
$ tmux set-option -g status-style bg=cyan       run from the shell prompt
set-option -g status-style bg=cyan              run from ~/.tmux.conf
bind-key C set-option -g status-style bg=cyan   bound to a key
command name:set-option
flag        :-g
arguments   :status-style bg=cyan

new-window 'vi ~/.tmux.conf' 等价于 /bin/sh -c 'vi ~/.tmux.conf' 等价于 tmux new-window vi ~/.tmux.conf -执行shell命令的命令-> new-window, new-session, split-window, respawn-window and respawn-pane

[条件执行和{}执行块]
bind x if-shell "true" {
    if-shell "true" {
        display "true!"
    }
}

[条件执行]
%if "#{==:#{host},myhost}"
set -g status-style bg=red
%elif "#{==:#{host},myotherhost}"
set -g status-style bg=green
%else
set -g status-style bg=blue
%endif                mysession       @1或mysession:1   mysession:mywindow.1   session IDs are prefixed with a '$', windows with a '@', and panes with a '%'
        list-clients, list-session,   list-window,      list-pane,             list-commands, list-keys, list-buffers
[-t|-s] target-client,target-session, target-window, or target-pane 命令影响的范围

[options]   -s:server options, 默认:session options, -w:window options, and -p:pane options. -g: the global session or window option: -u unset; -a|append:expects a string or a style
set-option -s   command
show-options -s command
set-option [-aFgopqsuUw] [-t target-pane] option value  (alias: set)
show-options [-AgHpqsvw] [-t target-pane] [option]      (alias: show) -A继承性属性
tmux show -s    显示服务器选项
tmux show -g    没有其他的旗标为显式全局会话选项
tmux show -wg   一起为显示全局窗口选项
tmux show -g status 指定显示 status 选项
set -g mode-keys vi    mode-keys 复制模式使用 vi 键
set -g status-keys vi  status-keys 命令提示使用 vi 键

[快捷键] tmux lsk -Tprefix 仅列出prefix表中的快捷键 1.-Troot 2.-Tprefix 3.-Tcopy-mode 3.-Tcopy-mode --> tmux lsk -Tcopy-mode C-a
'A' to 'Z'; 特殊按键: Up, Down, Left, Right, BSpace, BTab, DC (Delete), End, Enter, Escape, F1 to F12, Home, IC (Insert), NPage/PageDown/PgDn, PPage/PageUp/PgUp, Space, and Tab
Ctrl keys may be prefixed with 'C-' or '^',
Shift keys with 'S-'
Alt (meta) with 'M-'.
bind-key '"' split-window
bind-key "'" new-window
bind-key [-nr] [-N note] [-T key-table] key command [arguments]     # (alias: bind) 支持多表(因为支持多模式)
list-keys [-1aN] [-P prefix-string -T key-table] [key]              # (alias: lsk)
send-keys [-FHlMRX] [-N repeat-count] [-t target-pane] key ...      # (alias: send)
send-prefix [-2] [-t target-pane]
unbind-key [-anq] [-T key-table] key                                # (alias: unbind)

tmux 中的每个快捷键绑定都属于一个命名的快捷键表
有四个默认的快捷表:bind-key unbind-key
root        根       表包含不带前缀键的快捷键绑定
prefix      前缀     表包含在前缀键按下之后的快捷键绑定 就像进入到 tmux 的快捷键提到的那样
copy-mode   复制模式 表包含使用 emacs-style 的按键 在复制模式下使用快捷键绑定.
copy-mode-vi 表包含使用 vi-style 的按键在复制模式下使用快捷键绑定.
tmux_i_conf
}

tmux_i_server_options(){ cat - <<'tmux_i_server_options'
不适用于任何特定窗口、会话或窗格
set-option -s   设置或取消
show-options -s 列出

set -s command-alias[100] zoom='resize-pane -Z'  # command-alias别名
zoom -t:.1   == resize-pane -Z -t:.1
set-option -g default-terminal tmux

# Esc seems to work well.
set-option -s escape-time 20

tmux_i_server_options
}
tmux_i_session_options(){ cat - <<'tmux_i_session_options'
每个会话都可能有一组会话选项,还有一组单独的全局会话选项
没有配置特定选项的会话会继承全局会话选项的值
set-option   设置或取消
show-options 列出
tmux_i_session_options
}
tmux_i_window_options(){ cat - <<'tmux_i_window_options'
每个window都有一组window选项,每个pane也有一组pane选项.pane选项继承自window选项.这意味着任何pane选项都可以设置为windows选项,从而将该选项应用于window中未设置该选项的所有pane
# 除窗格0以外的所有窗格的背景颜色设置为红色
set -w     window-style bg=red
set -pt:.0 window-style bg=blue

set -g OPTION   # 为所有会话设置
setw -g OPTION  # 为所有窗口设置

一组全局window选项,任何未设置的window或pane选项都将从中继承
set-option -w  和 -p # 设置或取消 window 和 pane
show-option -w 和 -p # 列出       window 和 pane
show-option -wA      # -A包括从父选项集继承的选项,这些选项用星号标出
tmux 将根据选项名称推断类型,窗格选项假定使用-w.如果使用-g,则会列出全局会话或窗口选项

# Reset An Option Back To Its Default Value 默认情况下,tmux 会在按下 Esc 键时延迟 500 毫秒
tmux set-option -g escape-time 0  # 0  推荐
tmux set-option -u escape-time    # 0
tmux show-option escape-time      # 500

# -F扩展选项值中的格式.-u标志取消设置选项,会话将从全局选项中继承该选项
# -U 取消设置选项(类似于 -u),但如果选项是窗格选项,则还会取消设置窗口中任何窗格的选项
# -o标志可防止设置已设置的选项,-q标志可消除未知或模糊选项的错误信息
set -g status-left "foo"        # 给出-g, 设置了全局会话或窗口选项
set -ag status-left "bar"       # 使用 -a 时,如果选项希望使用字符串或样式,则会将值添加到现有设置中
set -g status-style "bg=red"    #
set -ag status-style "fg=blue"  # a red background and blue foreground vs the default background and a blue foreground
tmux_i_window_options
}

tmux_i_pane_options(){ cat - <<'tmux_i_pane_options'
一组全局window选项,任何未设置的window或pane选项都将从中继承
set-option -w  和 -p  # 设置或取消  window 和 pane
show-option -w 和 -p  # 列出        window 和 pane

:set pane-border-status top # Display Titles For Each Pane In A Window
tmux_i_pane_options
}
tmux_i_user_options(){ cat - <<'tmux_i_user_options'
tmux 还支持前缀为"@"的用户选项.用户选项可以有任何名称,只要前缀是"@",并且可以设置为任何字符串.
tmux set -wq @foo "abc123" # 如果选项不是用户选项,-w或 s可能没有必要
tmux show -wv @foo         # 如果选项不是用户选项,-w或 s可能没有必要
tmux_i_user_options
}
tmux_i_copy_paste(){ cat - <<'tmux_i_copy_paste'
[复制模式]
tmux中操作文本,自然离不开复制模式,通常使用复制模式的步骤如下:
1. 输入 [ 进入复制模式
2. 按下 空格键 开始复制,移动光标选择复制区域
3. 按下 回车键 复制选中文本并退出复制模式
4. 按下 ] 粘贴文本
查看复制模式默认的快捷键风格:
tmux show-window-options -g mode-keys # mode-keys emacs
默认情况下,快捷键为emacs风格.
为了让复制模式更加方便,我们可以将快捷键设置为熟悉的vi风格,如下:
setw -g mode-keys vi # 开启vi风格后,支持vi的C-d、C-u、hjkl等快捷键

[自定义复制和选择快捷键]
除了快捷键外,复制模式的启用、选择、复制、粘贴等按键也可以向vi风格靠拢.
bind Escape copy-mode # 绑定esc键为进入复制模式
bind -t vi-copy v begin-selection # 绑定v键为开始选择文本
bind -t vi-copy y copy-selection # 绑定y键为复制选中文本
bind p pasteb # 绑定p键为粘贴文本(p键默认用于进入上一个窗口,不建议覆盖)
以上,绑定 v、y两键的设置只在tmux v2.4版本以下才有效,对于v2.4及以上的版本,绑定快捷键需要使用 -T 选项,发送指令需要使用 -X 选项,请参考如下设置:
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

[Buffer缓存]
tmux复制操作的内容默认会存进buffer里,buffer是一个粘贴缓存区,新的缓存总是位于栈顶,它的操作命令如下:
tmux list-buffers # 展示所有的 buffers
tmux show-buffer [-b buffer-name] # 显示指定的 buffer 内容
tmux choose-buffer # 进入 buffer 选择页面(支持jk上下移动选择,回车选中并粘贴 buffer 内容到面板上)
tmux set-buffer # 设置buffer内容
tmux load-buffer [-b buffer-name] file-path # 从文件中加载文本到buffer缓存
tmux save-buffer [-a] [-b buffer-name] path # 保存tmux的buffer缓存到本地
tmux paste-buffer # 粘贴buffer内容到会话中
tmux delete-buffer [-b buffer-name] # 删除指定名称的buffer
以上buffer操作在不指定buffer-name时,默认处理是栈顶的buffer缓存.

[在Linux上使用粘贴板] @使用系统粘贴板
通常,Linux中可以使用xclip工具来接入系统粘贴板.
首先,需要安装xclip.
sudo apt-get install xclip
然后,.tmux.conf的配置如下.
# buffer缓存复制到Linux系统粘贴板
bind C-c run " tmux save-buffer - | xclip -i -sel clipboard"
# Linux系统粘贴板内容复制到会话
bind C-v run " tmux set-buffer \"$(xclip -o -sel clipboard)\"; tmux paste-buffer"
按下prefix + Ctrl + c 键,buffer缓存的内容将通过xlip程序复制到粘贴板,按下prefix + Ctrl + v键,tmux将通过xclip访问粘贴板,然后由set-buffer命令设置给buffer缓存,最后由paste-buffer粘贴到tmux会话中.

tmux_i_copy_paste
}

tmux_t_session(){ cat - <<'EOF'
1. 自定义创建会话
tmux new -s <session-name> # 创建一个自定义名字的会话
tmux new -s wangfl | makebash | makeshunit2 | makemake

2. 分离会话
tmux detach 命令或者使用快捷键 Ctrl + B d
tmux detach

3. 接入会话
tmux attach -t <session-name>
tmux attach -t 0

4. 转换会话
tmux switch -t <session-name>
tmux switch -t makebash
tmux switch -t 0

5. 重命名会话
tmux rename -t 旧会话名或会话ID 新会话名或会话ID
tmux rename -t wangfl makebash

6. 退出会话
tmux kill-seesion -t <session-name>
tmux kill-session -t 0
tmux kill-server 命令使所有会话全部退出

tmux ls # tmux list-session
EOF
}

tmux_i_session(){ cat - <<'EOF'
2.1. 系统操作
C-b ?
    列出所有快捷键;按q返回
C-b d
    脱离当前会话;这样可以暂时返回Shell界面,输入tmux attach能够重新进入之前的会话
C-b D
    选择要脱离的会话;在同时开启了多个会话时使用
C-b Ctrl+z
    挂起当前会话
C-b r
    强制重绘未脱离的会话
C-b s
    选择并切换会话;在同时开启了多个会话时使用
C-b :
    进入命令行模式;此时可以输入支持的命令,例如kill-server可以关闭服务器
C-b [
    进入复制模式;此时的操作与vi/emacs相同,按q/Esc退出
C-b ~
    列出提示信息缓存;其中包含了之前tmux返回的各种提示信息
EOF
}

tmux_t_window(){ cat - <<'EOF'
除了将一个窗口划分成多个窗格,Tmux 也允许新建多个窗口.
选择窗口 的快捷键: Ctrl + B w

1. 新建窗口
tmux new-window命令用来创建新窗口.
$ tmux new-window
$ tmux new-window -n <window-name>

2. tmux select-window命令用来切换窗口.
# 切换到指定编号的窗口
$ tmux select-window -t <window-number>
# 切换到指定名称的窗口
$ tmux select-window -t <window-name>

3. 重命名窗口
tmux rename-window命令用于为当前窗口起名(或重命名).
$ tmux rename-window <new-name>
EOF
}

tmux_i_window(){ cat - <<'EOF'
2.2. 窗口操作
C-b c
    创建新窗口
C-b &
    关闭当前窗口
C-b 数字键
    切换至指定窗口
C-b p
    切换至上一窗口
C-b n
    切换至下一窗口
C-b l
    在前后两个窗口间互相切换
C-b w
    通过窗口列表切换窗口
C-b ,
    重命名当前窗口;这样便于识别
C-b .
    修改当前窗口编号;相当于窗口重新排序
C-b f
    在所有窗口中查找指定文本
EOF
}

tmux_t_pane(){ cat - <<'EOF'
1. 划分窗格
tmux split-window命令用来划分窗格.
tmux split-window 命令可以把窗口划分成上下两个窗格      Ctrl + B "
tmux split-window -h 命令可以把窗口划分成左右两个窗格   Ctrl + B %

2.  移动光标
tmux select-pane命令用来移动光标位置.
$ tmux select-pane -U # 光标切换到上方窗格
$ tmux select-pane -D # 光标切换到下方窗格
$ tmux select-pane -L # 光标切换到左边窗格
$ tmux select-pane -R # 光标切换到右边窗格

3. 交换窗格位置
tmux swap-pane命令用来交换窗格位置.
$ tmux swap-pane -U # 当前窗格上移
$ tmux swap-pane -D # 当前窗格下移
EOF
}


tmux_i_pane(){ cat - <<'EOF'
2.3. 面板操作
C-b -
    将当前面板平分为上下两块(缺省使用",配置中改为更好记的-)
C-b |
    将当前面板平分为左右两块(缺省使用",配置中改为更好记的|)
C-b x
    关闭当前面板
C-b !
    将当前面板置于新窗口;即新建一个窗口,其中仅包含当前面板
C-b Ctrl+方向键
    以1个单元格为单位移动边缘以调整当前面板大小
C-b Alt+方向键
    以5个单元格为单位移动边缘以调整当前面板大小
C-b Space
    在预置的面板布局中循环切换;依次包括even-horizontal、even-vertical、main-horizontal、main-vertical、tiled
C-b q
    显示面板编号
C-b o
    在当前窗口中选择下一面板
C-b 方向键
    移动光标以选择面板
C-b {
    向前置换当前面板
C-b }
    向后置换当前面板
C-b Alt+o
    逆时针旋转当前窗口的面板
C-b Ctrl+o
    顺时针旋转当前窗口的面板

EOF
}