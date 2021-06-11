Luarocks(什么是 Luarocks){
    Luarocks 是一个 Lua 包管理器，基于 Lua 语言开发，提供一个命令行的方式来管理 Lua 包依赖、安装第三方 Lua 包等，
社区比较流行的包管理器之一，另还有一个 LuaDist，Luarocks 的包数量比 LuaDist 多，更细节的两者对比可参阅 这里。


源码安装部署 Luarocks
（为何使用源码见 此文）
wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
tar zxvf luarocks-2.2.2.tar.gz
cd luarocks-2.2.2
./configure --help

configure help 查看所支持的安装配置，这里我们主要关注以下两个

--prefix=DIR                Prefix where LuaRocks should be installed.
                            Default is /usr/local
--with-lua=PREFIX           Use Lua from given prefix.
                            Default is auto-detected (the parent directory of $LUA_BINDIR).

--prefix 设置 Luarocks 安装路径，--with-lua 指定 Luarocks 依赖的 Lua 安装路径。
}

Luarocks(luarocks的详细信息){
命令行运行luarocks，或者luarocks help能看到相关luarocks的详细信息，大致分为以下6个段。

NAME/名称 显示 Luarocks 说明信息 - LuaRocks main command-line interface

SYNOPSIS/概要 显示luarocks命令参数使用格式：

luarocks [--from=<server> | --only-from=<server>] [--to=<tree>] [VAR=VALUE]... <command> [<argument>]

GENERAL OPTIONS/通用选项 被所有命令所支持的选项，包含指定搜索 rocks/rockspecs 的 server，默认的 server 搜寻顺序为：

https://luarocks.org
https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/
http://luafr.org/moonrocks/
http://luarocks.logiceditor.com/rocks

另外选项还设置是否仅仅下载源码、是否显示安装过程、指定超时时间等。

VARIABLES/变量 Variables from the "variables" table of the configuration file can be overriden with VAR=VALUE assignments.

COMMANDS/命令列表 luarocks 的常规操作命令 install、search、list 等

CONFIGURATION/相关配置信息 Lua 版本，rocks trees 等安装 luarocks 时的配置

在 luarocks 使用中我们主要关注 GENERAL OPTIONS、和 COMMANDS 两项。GENERAL OPTIONS 与其他 COMMANDS 配合使用。
}

luarocks(search){
luarocks search vanilla --verbose
}


https://segmentfault.com/a/1190000003920034