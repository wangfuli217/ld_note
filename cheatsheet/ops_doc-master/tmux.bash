# 修改 ctrl+b 前缀为 ctrl+a
set -g prefix C-a
unbind C-b
bind C-a send-prefix
set-option -g prefix2 `
# 绑定重载 settings 的热键
bind r source-file ~/.tmux.conf \; display-message "Config reloaded.."

# 设置为vi编辑模式
setw -g mode-keys vi # 设置为vi编辑模式
bind Escape copy-mode # 绑定esc键为进入复制模式
bind -T copy-mode-vi v send-keys -X begin-selection # 绑定v键为开始选择文本
#bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel # 绑定y键为复制选中文本

set-option -g default-command 'exec reattach-to-user-namespace -l zsh'
bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel 'reattach-to-user-namespace pbcopy'
bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "pbcopy"

bind-key C-c run-shell 'tmux save-buffer - | reattach-to-user-namespace pbcopy'
bind-key C-v run-shell 'reattach-to-user-namespace pbpaste | tmux load-buffer - \; paste-buffer -d'

# 设置window的起始下标为1
set -g base-index 1
# 设置pane的起始下标为1
set -g pane-base-index 1

#-- base --#
set -g default-terminal "screen-256color"
set -g display-time 3000
set -g history-limit 65535

# 鼠标支持
set-option -g mouse on
# 关闭默认窗口标题
set -g set-titles off

#-- bindkeys --#
unbind '"'
bind - splitw -v -c '#{pane_current_path}'
unbind %
bind | splitw -h -c '#{pane_current_path}'

bind c new-window -c "#{pane_current_path}"

# 定义上下左右键为hjkl键
bind -r k select-pane -U
bind -r j select-pane -D
bind -r h select-pane -L
bind -r l select-pane -R

# 定义面板边缘调整的^k ^j ^h ^l快捷键
bind -r ^k resizep -U 10 # upward (prefix Ctrl+k)
bind -r ^j resizep -D 10 # downward (prefix Ctrl+j)
bind -r ^h resizep -L 10 # to the left (prefix Ctrl+h)
bind -r ^l resizep -R 10 # to the right (prefix Ctrl+l)

# 定义交换面板的键
bind ^u swap-pane -U
bind ^d swap-pane -D

bind e lastp
bind ^e last
# bind q killp

#bind '~' splitw htop
#bind ! splitw ncmpcpp
bind m command-prompt "splitw 'exec man %%'"
bind @ command-prompt "splitw 'exec perldoc -t -f %%'"
bind * command-prompt "splitw 'exec perldoc -t -v %%'"
bind % command-prompt "splitw 'exec perldoc -t %%'"
bind / command-prompt "splitw 'exec ri -T %% | less'"

# 输出日志到桌面
bind P pipe-pane -o "cat >>~/Desktop/#W.log" \; display "Toggled logging to ~/Desktop/#W.log"

#-- statusbar --#
set -g status-right-attr bright
set -g status-bg black
set -g status-fg yellow

# 设置状态栏高亮
setw -g window-status-current-attr bright
# 设置状态栏红底白字
setw -g window-status-current-bg red
setw -g window-status-current-fg white

# 设置状态栏列表左对齐
set -g status-justify left
# 非当前window有内容更新时在状态栏通知
setw -g monitor-activity on
set -g status-interval 1

#set -g visual-activity on

setw -g automatic-rename off
setw -g allow-rename off
# 最大化(默认为z,增加模拟的b指令)
unbind b
bind b run ". ~/.tmux/zoom"

set -g status-keys vi

# plugin-manager
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# plugins
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# load-plugins-without-manager
#run-shell ~/.tmux/tmux-resurrect/resurrect.tmux
#run-shell ~/.tmux/tmux-continuum/continuum.tmux

# plugins-settings
set -g @resurrect-strategy-vim 'session' # for vim
set -g @resurrect-strategy-nvim 'session' # for neovim
set -g @continuum-save-interval '0'
set -g @continuum-restore 'on'

set -g status-right 'Continuum status: #{continuum_status}'
set -wg window-status-format " #I:#W "
setw -g window-status-current-format " #I:#W "
set -wg window-status-separator ""
set -g message-style "bg=#202529, fg=#91A8BA"

set -g @resurrect-capture-pane-contents 'on' # 恢复面板内容
run '~/.tmux/plugins/tpm/tpm'