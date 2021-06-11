<F1>           帮助
<esc>          返回到正常模式
V              Visual模式
i              Insert模式
:              命令行命令
:set tw=72     设置文本宽为72
<F11>          Insert (paste) 模式
:r! date -R    Insert RFC-822 数据
qa             将键盘操作记录到注册表a
q              停止键盘操作记录
@a             播放注册表a中记录的键盘操作
:edit foo.txt  载入并编辑另一个文件foo.txt
:wnext         写入当前文件然后编辑下一个文件


<F1> 帮助 
<F10> 菜单 
C-u M-! date -R 插入RFC-822数据


打开编辑器：          emacs filename vim filename 
以vi兼容方式打开：    vim -C 
以vi不兼容方式打开：  vim -N 
默认编译方式打开：    emacs -q vim -N -u NONE

EmacsvsVim()
{
exit:                           C-x C-c         :qa /:wq /:xa /:q!
Get back/command mode:          C-g             <esc>
Backward(left):                 C-b             h
Forward(right):                 C-f             l
Next(down):                     C-n             j
Previous(up):                   C-p             k
stArt of line(^):               C-a             0
End of line($):                 C-e             $
mUltiple commands:              C-u nnn cmd     nnn cmd
Multiple commands:              M-digitkey cmd
save File:                      C-x C-s         :w file
beginning of buffer:            M-<             1G
end of buffer:                  M->             G
scroll forward 1 screen:        C-v             ^F
scroll forward 1/2 screen:                      ^D
scroll forward 1 line:                          ^E
scroll backward 1 screen:       M-v             ^B
scroll backward 1/2 screen:                     ^U
scroll backward 1 line:                         ^Y
scroll the other window:        M-C-v
delete under cursor:            C-d             x
delete from cursor to eol:      C-k             D
iSearch forward:                C-s
isearch Reverse:                C-r
Search forward:                 C-s enter       /
search Reverse:                 C-r enter       ?
isearch regexp:                 M-C-s
isearch backward regexp:        M-C-r
search regexp:                  M-C-s enter     /
search backward regexp:         M-C-r enter     ?
Help:                           C-h C-h         :help
Help Apropos:                   C-h a
Help key Bindings:              C-h b           :help [key]
Help Info:                      C-h i
Help Major mode:                C-h m
Help tutorial:                  C-h t           :help howto
Undo:                           C-_             u
Redo:                           C-f             ^R
Mark cursor position:           C-@             m{a-zA-Z}
eXchange Mark and position:     C-x C-x
goto mark in current file:                      '{a-z}
goto mark in any file:                          '{A-Z}
copy region:                    M-w             {visual}y
kill region:                    C-w             {visual}d
Yank and keep buffer:           C-y             
Yank from kill buffer:          M-y             p
convert region to Upper:        C-x C-u         {visual}U
convert region to Lower:        C-x C-l         {visual}u
Insert special char:            C-q octalnum/keystroke  
^V decimal/keystroke
replace:                        M-x replace-string      :%s/aaa/bbb/g
replace regexp:                 M-x replace-regexp      :%s/aaa/bbb/g
query replace:                  M-%                     :%s/aaa/bbb/gc
query replace:                  M-x query-replace
query replace regexp:           M-x query-replace-regexp
Open file:                      C-x C-f         :r file
Save file:                      C-x C-s         :w
Save all buffers:               C-x s           :wa
Save as:                        C-x C-w file    :w file
Prompt for buffer:              C-x b
List buffers:                   C-x C-b         :buffers
Toggle read-only:               C-x C-q         :set ro
Prompt and kill buffer:         C-x k
Split vertical:                 C-x 2           :split
Split horizontal:               C-x 3           :vsplit (ver. 6)
Move to other window:           C-x o           ^Wp
Delete this window:             C-x 0           :q
Delete other window(s):         C-x 1           ^Wo
run shell in bg:                M-x compile
kill shell run in bg:           M-x kill-compilation
run make:                                       :make Makefile
check error message:            C-x`            :echo errmsg
run shell and record:           M-x shell       :!script -a tmp
...clean BS, ...                                :!col -b <tmp >record
...save/recall shell record:    C-x C-w record  :r record
run shell:                      M-! sh          :sh
run command:                    M-! cmd         :!cmd
run command and insert:         C-u M-! cmd     :r!cmd
run filter:                     M-| file        {visual}:w file
run filter and insert:          C-u M-| filter  {visual}:!filter
show option                                     :se[t] {option}?
reset option to default                         :se[t] {option}&
reset boolean option                            :se[t] no{option}
toggle boolean option                           :se[t] inv{option}
wrap text at column 72                          :se tw=72
do not wrap                                     :se tw=0
autoindent                                      :se ai
expand tab                                      :se et
specify comment (mail)                          :se comments=n:>,n:\|

run GDB                         M-x gdb                        
describe GDB mode               C-h m                          
step one line                   M-s
next line                       M-n
step one instruction (stepi)    M-i                            
finish current stack frame      C-c C-f                        
continue                        M-c                            
up arg frames                   M-u                            
down arg frames                 M-d                            
copy number from point, insert at the end 
C-x &                          
set break point                 C-x SPC
}


