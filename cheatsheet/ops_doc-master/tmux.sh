cat - <<'EOF'
Tmux 就是会话与窗口的"解绑"工具，将它们彻底分离。 # 
解决问题：会话与窗口可以"解绑"：窗口关闭时，会话并不终止，而是继续运行，等到以后需要的时候，再让会话"绑定"其他窗口。
1. 它允许在单个窗口中，同时访问多个会话。这对于同时运行多个命令行程序很有用。
2. 它可以让新窗口"接入"已经存在的会话。
3. 它允许每个会话有多个连接窗口，因此可以多人实时共享会话。
4. 它还支持窗口任意的垂直和水平拆分。

[面向对象]
一个远程服务器终端窗口可以管理多个tmux会话(session)
一个tmux会话里可以管理多个窗口(window), 窗口(window)之间是互相独立的, 并且可以切换到任一窗口
一个窗口(window)可以划分成多个窗格(pane), 窗格之间是互相独立的, 也可以切换到任一窗格

[面向实例]
[30]  0:bash* 1:bash-      "root@agent109:~/rtu/o" 16:27 08-Oct-20
 1    2       2     3       4  
1：会话ID，默认从0开始，依次递增
2：窗口ID，默认从0开始，依次递增
3：当前用户命令目录
4：系统信息

[安装]
sudo apt-get install tmux
sudo yum install tmux
brew install tmux
 
Ctrl + B ? 帮助 # tmux list-keys
[session]
tmux new    -s <SESSION_NAME>  # New Session
tmux attach -t <SESSION_NAME>  # Attach to a particular tmux session
tmux ls                        # list all tmux sessions
Ctrl+b d：分离当前会话。
Ctrl+b s：列出所有会话。  # 
Ctrl+b $：重命名当前会话。
[windows]
Ctrl+b c：创建一个新窗口，状态栏会显示多个窗口的信息。
Ctrl+b p：切换到上一个窗口（按照状态栏上的顺序）。
Ctrl+b n：切换到下一个窗口。
Ctrl+b <number>：切换到指定编号的窗口，其中的<number>是状态栏上的窗口编号。 # Ctrl+b <0,1,2>
Ctrl+b w：从列表中选择窗口。 # 
Ctrl+b ,：窗口重命名。                                                      # Ctrl+b , 	Rename tmux window
[pane]
Ctrl+b %：划分左右两个窗格。
Ctrl+b "：划分上下两个窗格。
Ctrl+b x：关闭当前窗格。
Ctrl+b !：将当前窗格拆分为一个独立窗口。
Ctrl+b o：光标切换到下一个窗格
EOF

tmux_i_session_restore(){ cat - <<'tmux_i_session_restore'
https://github.com/tmux-plugins/tmux-resurrect
https://github.com/tmux-plugins/tmux-continuum

run-shell ~/tmp/resurrect.tmux
run-shell ~/tmp/continuum.tmux
两个插件都需要 Tmux >= 1.9 才行

保存状态：prefix + Ctrl-s
恢复状态：prefix + Ctrl-r
tmux_i_session_restore
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
    列出所有快捷键；按q返回
C-b d
    脱离当前会话；这样可以暂时返回Shell界面，输入tmux attach能够重新进入之前的会话
C-b D
    选择要脱离的会话；在同时开启了多个会话时使用
C-b Ctrl+z
    挂起当前会话
C-b r
    强制重绘未脱离的会话
C-b s
    选择并切换会话；在同时开启了多个会话时使用
C-b :
    进入命令行模式；此时可以输入支持的命令，例如kill-server可以关闭服务器
C-b [
    进入复制模式；此时的操作与vi/emacs相同，按q/Esc退出
C-b ~
    列出提示信息缓存；其中包含了之前tmux返回的各种提示信息
EOF
}

tmux_t_window(){ cat - <<'EOF'
除了将一个窗口划分成多个窗格，Tmux 也允许新建多个窗口。
选择窗口 的快捷键: Ctrl + B w

1. 新建窗口
tmux new-window命令用来创建新窗口。
$ tmux new-window
$ tmux new-window -n <window-name>

2. tmux select-window命令用来切换窗口。
# 切换到指定编号的窗口
$ tmux select-window -t <window-number>
# 切换到指定名称的窗口
$ tmux select-window -t <window-name>

3. 重命名窗口
tmux rename-window命令用于为当前窗口起名（或重命名）。
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
    重命名当前窗口；这样便于识别
C-b .
    修改当前窗口编号；相当于窗口重新排序
C-b f
    在所有窗口中查找指定文本
EOF
}

tmux_t_pane(){ cat - <<'EOF'
1. 划分窗格
tmux split-window命令用来划分窗格。
tmux split-window 命令可以把窗口划分成上下两个窗格      Ctrl + B "
tmux split-window -h 命令可以把窗口划分成左右两个窗格   Ctrl + B %

2.  移动光标
tmux select-pane命令用来移动光标位置。
$ tmux select-pane -U # 光标切换到上方窗格
$ tmux select-pane -D # 光标切换到下方窗格
$ tmux select-pane -L # 光标切换到左边窗格
$ tmux select-pane -R # 光标切换到右边窗格

3. 交换窗格位置
tmux swap-pane命令用来交换窗格位置。
$ tmux swap-pane -U # 当前窗格上移
$ tmux swap-pane -D # 当前窗格下移
EOF
}


tmux_i_pane(){ cat - <<'EOF'
2.3. 面板操作
C-b -
    将当前面板平分为上下两块(缺省使用"，配置中改为更好记的-)
C-b |
    将当前面板平分为左右两块(缺省使用"，配置中改为更好记的|)
C-b x
    关闭当前面板
C-b !
    将当前面板置于新窗口；即新建一个窗口，其中仅包含当前面板
C-b Ctrl+方向键
    以1个单元格为单位移动边缘以调整当前面板大小
C-b Alt+方向键
    以5个单元格为单位移动边缘以调整当前面板大小
C-b Space
    在预置的面板布局中循环切换；依次包括even-horizontal、even-vertical、main-horizontal、main-vertical、tiled
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