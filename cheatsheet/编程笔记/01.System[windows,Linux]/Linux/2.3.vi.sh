﻿
vi
    底行模式  / ?  命令模式  i a o 输入模式

vi 的使用方法
 1、光标    h 左    j 下        k 上    l 右
    set nu 显示行号(set nonu)  21  光标停在指定行
    21G             第N行  (G到文件尾，1G到文件头) 如果要将光标移动到文件第一行，那么就按 1G
    H               屏幕头
    M               屏幕中间
    L               屏幕底
    ^  或 shift+6   行首
    $  或 shift+4   行尾
    Ctrl+f          下翻
    Ctrl+b          上翻

2、输入 (输入模式)
    o       光标往下换一行(光标所在行下一行插入)
    O       (大写字母o)在光标所在行上插入一空行
    i       在光标所在位置的前面插入字母
    I       为在目前所在行的第一个非空格符处开始插入
    a       在光标所在位置的后面插入一个新字母
    A       为从光标所在行的最后一个字符处开始插入
    r       替换光标所在的那一个字符一次
    R       一直替换
    <Esc>   退出插入状态。
    ::      命令模式切换到插入模式


3、修改替换
    r        替换一个字符
    dd       删除行，剪切行    (5dd删除5行)
             5,10d  删除 5 至 10 行(包括第 5行和第 10 行)
    x        删除一个字符
    dw       删除词，剪切词。 ( 3dw删除 3 单词)
    cw       替换一个单词。 (cw 和 dw 的区别 cw 删除某一个单词后直接进入编辑模式，而dw删除词后仍处于命令模式)
    cc       替换一行
    C        替换从光标到行尾
    yy       复制行 (用法同下的 Y ，见下行)
    Y        将光标移动到要复制行位置，按yy。当你想粘贴的时候，请将光标移动到你想复制的位置的前一个位置，然后按 p
    yw       复制词
    p        当前行下粘贴
    1,2co3   复制行1，2在行3之后
    4,5m6    移动行4，5在行6之后
    u        当你的前一个命令操作是一个误操作的时候，那么可以按一下 u键，即可复原。只能撤销一次
    r file2  在光标所在处插入另一个文件

    ~        将字母变成大写
    J        可以将当前行与下一行连接起来
    /字符串   从上往下找匹配的字符串
    ?字符串   从下往上找匹配的字符串
    n        继续查找
    1,$s/旧串/新串/g   替换全文(或者  %s/旧串/新串/g)
                      (1表示从第一行开始)    没有g则只替换一次，加g替换所有

4、存盘和退出
     :w             存盘
     :w!            强制写入保存
     :q             离开vi
     :q!            强行退出不存盘
     :wq            存盘再退出VI(或者ZZ或 X)
     :w [filename]  存成新文件,filename 为新文件的文件名
     :!command      vi模式下显示shell命令
     :set nu        显示行号
     :set nonu      取消行号
