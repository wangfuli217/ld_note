replace(:[范围]/[匹配字符串]/[替换字符串]/[行范围])
{

:s/Shell/shell             将当前行的第一个Shell字符串替换成为shell字符串
:s/Shell/shell/g           将当前行的所有Shell字符串替换成为shell字符串
:2,6s/Shell/shell/g        将第二行到第六行的所有Shell字符串替换成为shell字符串
:-1,+3s/Shell/shell/g      将当前行的上一行到下三行的Shell字符串替换成为shell字符串
:%s/Shell/shell/g          在整个文档中将Shell字符串替换成为shell字符串
:%s/Shell/shell/gc         在整个文档中将Shell字符串替换成为shell字符串时确认
:g/模式/s/Shell/shell/g    将拥有模式的所有的Shell字符串替换成为shell字符串

^       行的一个字符                $            行尾
.       表示任意个字符或一个字符    \            如实解析下一个字符
[]      []内的字符之一              \|           表示or
[^]     除绑定字符外的任意字符      \{min,max\}  min-max之间重复
\*      之前内容重复0次或以上       \+           之间内容重复1次以上
\<      词首                        \>           词尾
\n      换行字符                    \t           Tab字符
%       第一行到最后一行            [a-z]        a~z之间所有字符
[AB]    A或B                        [A-Z]        a~z之间所有字符
[0-9]   0~9之中的所有整数           p{aeiou}t    pat pet pit pot put之一
}

move()
{
(   移动到上一个语句的第一个字 
)   移动到下一个语句的第一个字 
{   移动到下一段
}   移动到上一段 
[[  移动到上一个节区的开始
]]  移动到下一个节区的开始
}

help()
{
vimtutor  进入教程
vim tutor 进入教程
    [数字] d 对象 或 d [数字] 对象
dw 删除一个单词(包括空格)
de 删除一个单词(不包括空格)
d$ 删除到词尾
dd 删除指定行
    [数字] 命令 对象 或 命令 [数字] 对象

输入r可以替换光标所在位置的字符
输入cw替换部分或全部单词

ctrl-g  显示文件中的当前位置和文件状态，
shift-g 输入SHIFT-G转到文件内的行。

:! 执行外部命令
:w FILENAME保存修改的文件
#,# FILENAME保存部分文件
:r 插入文件的内容


help w
help c_<T
help insert-index
help user-manual
}


