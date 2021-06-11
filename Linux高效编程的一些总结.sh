
ko(专业){菜鸟写一天的产出可能高不过高手一个小时，工具神马的都是浮云，自身的专业才是最重要的。}
ko(高效的核心技能——自动化){绝大部分时间，你觉得效率不高是因为你在不断的重复，把重复的东西自动化就是效率。}
ko(自动化的关键——脚本语言){

    脚本语言非常适合自动化的工作，可以大大的提供效率，比如说我有一个专门用于创建新的项目的
 cpds（cpp project directory structure），它可以用来初始化一个可以新项目的完整目录结构和基本的配置文件
    动静结合，动态语言 + 静态语言 = 编程效率 + 程序的效率
    我个人使用 Python，非常棒的一门语言，我用它写脚本，写爬虫，写VIM插件等等
}
ko(高效的 VIM){
好用的插件的推荐
YouCompleteMe

需要注意的地方：

    这个插件需要编译，记得在编译的时候加上 --clang-completer 选项

    这个插件需要你提供 .ycm_extra_conf.py 文件，每个项目都应该单独在根目录下放一个这样的文件。关键部分在于配置开头的 flags 选项中的中头文件路径。

这个配置文件不用手动生成，可以使用YCM-Generator自动生成，安装完成之后，在你的编译目录下（包含 Makefile 的那个目录）运行 YcmGenerateConfig 命令即可生成配置文件，然后调整配置文件中的相对路径（编译目录可能不是根目录）即可。

    这个插件超级难以安装，因为下载 clang 需要很长时间，耐心一点，欲速则不达。

UltiSnippet + vim-snippet

代码自动生成的另外一个神器，前者是引擎，后者是脚本，他们的关系在xxx一文中有提及，不再赘述。

需要注意的地方：

    你可以自己编辑代码块儿生成规则！你可以用它来插入你自己定制常用代码，相关教程参考xxx

NERDTree

强大的目录树，工程管理必备
ctrlp

快速的查找文件，这个功能来自 sublime，sublime 的用户应该会非常顺手。

需要注意的地方：

    你可以配置搜索程序，目前最快是不是 grep，也不是 ack，是 ag。

    你可以配置 ag，来忽略掉其中的某些你不想要的文件，只要在 HOME 目录下放一个 .agignore用力配置你想要忽略的文件即可

    它是一个框架有大量基于它的插件，比如 buffer，funky，mru，我自己基于它写过一个用于引入头文件的 ctrlp-header

vim-fswitch

快速的交换头文件和实现文件
vim-multiple-cursors

来自 sublime 的功能，多行同时编辑，重命名的得力助手
ctrlsf.vim

同样是来自 sublime 的功能，配置前面的 vim-multiple-cursors 可以同时修改多个文件中的名字。
vim-autoformat

代码格式化的工具
Ack.vim

需要注意的地方：

    它只是名字脚本 Ack，但是可以配置使用 ag 来进行搜索

不要再退出vim，使用 grep 搜索之后按照行号来打开文件，你完全可以在 Vim 中完成这项工作。
fugitive

你不要退出 vim 进行 git 操作，它的强大超乎你的想象。
}

ko(高效的终端){
tmux
一个 tmux 顶 N 个显示屏，丢掉鼠标，你的效率会直线上升。

zsh + oh-my-zsh + antigen
需要注意的地方：
    zsh 是可以配置插件的，它的插件管理器有很多，比如 antigen。

    非常好用的一些插件：
        zsh-syntax-highlighting
        zsh-autosuggestions

fzf
把模糊匹配带到你的终端上来，好用到爆
}

ko(build-essential){
大部分做开发的人会需要安装这个包，其中包含了做开发时编译所必须的软件包。使用下面命令安装：
sudo apt-get install build-essential
}

ko(clang-format)}{
}

ko(ctags){使用 vim 浏览代码，查找函数，生成 outline 的时候都会用到它。}

ko(fzf){
如果你经常使用 find 这样的工具查找文件，我推荐你使用 fzf，这是一个文件查找的模糊匹配工具，如果你使用过 vim-ctrlp 或者 sublime 中的相关功能，你一定会爱上这个工具。你可以用它过滤文件，过滤历史记录，过滤目录文件等等，非常好用。

安装完成之后，你可以试试 Ctrl-T，Ctrl-R， Alt-C 这些快捷键来感受一下它的强大。

此外 fzf 是一个可扩展的框架，你可以编写自己的想要的功能。
}

ko(hexo){
当你在为知笔记、evernot和有道云笔记之间纠结的时候，我推荐你使用 hexo + github pages 搭建自己的博客网站，把你的点点滴滴都记录下来，我的这篇博客这就是这样记录下来的。
}

ko(fzf + vim + tmux){
https://junegunn.kr/2014/04/fzf+vim+tmux/
}
