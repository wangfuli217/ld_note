cat - <<'EOF'
Tmux 就是会话与窗口的"解绑"工具,将它们彻底分离. # 1.server服务器 2.session会话 3.window窗口 4.pane面板
解决问题:会话与窗口可以"解绑":窗口关闭时,会话并不终止,而是继续运行,等到以后需要的时候,再让会话"绑定"其他窗口.
1. 它允许在单个窗口中,同时访问多个会话.这对于同时运行多个命令行程序很有用.
2. 它可以让新窗口"接入"已经存在的会话.
3. 它允许每个会话有多个连接窗口,因此可以多人实时共享会话.
4. 它还支持窗口任意的垂直和水平拆分.

[面向对象]
一个远程服务器终端窗口可以管理多个tmux会话(session)
一个tmux会话里可以管理多个窗口(window), 窗口(window)之间是互相独立的, 并且可以切换到任一窗口
一个窗口(window)可以划分成多个窗格(pane), 窗格之间是互相独立的, 也可以切换到任一窗格

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
Ctrl+b ,:窗口重命名.                                                      # Ctrl+b , 	Rename tmux window
[pane]
Ctrl+b %:划分左右两个窗格.
# Ctrl+b ":划分上下两个窗格.
# Ctrl+b x:关闭当前窗格.
# Ctrl+b !:将当前窗格拆分为一个独立窗口.
# Ctrl+b o:光标切换到下一个窗格

http://louiszhai.github.io/2017/09/30/tmux/ # 完美一篇
EOF

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

[重新加载配置]
# 在tmux窗口中,先按下Ctrl+b指令前缀,然后按下系统指令:,进入到命令模式后输入source-file ~/.tmux.conf,回车后生效
# 绑定快捷键为r
bind r source-file ~/.tmux.conf \; display-message "Config reloaded.."


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

2. 自定义状态栏
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

tmux_i_conf
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