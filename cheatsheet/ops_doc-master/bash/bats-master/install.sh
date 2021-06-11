#!/usr/bin/env bash                                                             # &解释器说明
set -e                                                                          # &解释器配置
                                                                                
# 确定链接文件的目标文件(目标文件可能还是个链接文件)                            
resolve_link() {                                                                # &函数
  $(type -p greadlink readlink | head -1) "$1"  # $() 可以作为独立命令存在
}                                                  

# install.sh在文件系统的文件夹位置(确定递归链接文件的真实文件)
abs_dirname() {
  local cwd="$(pwd)"  # $(type -p greadlink readlink | head -1) 没有引号，而此处有引号。
  local path="$1"                                                               
                                                                                
  while [ -n "$path" ]; do # 判断字符串是否为空使用-n和-z,对应$path使用双引号，防止字符串内有空格和特殊字符
    cd "${path%/*}"        # 跳转到父目录
    local name="${path##*/}"  # 当前文件名或目录名
    path="$(resolve_link "$name" || true)" # true保证不会因为命令执行错误而退出；""可以嵌套
  done
                                                                                
  pwd  # 输出在pwd
  cd "$cwd"                                                                     
}

PREFIX="$1"                                                                     # &命令行解析
if [ -z "$1" ]; then # if和then， while until for和do在同一行，中间使用;分号隔开
  { echo "usage: $0 <prefix>"                                                   # &执行错误帮助
    echo "  e.g. $0 /usr/local"                                                 
  } >&2  # &指示不要把1当作普通文件,而是fd=1即标准输出来处理.
  # ()和{} 可以将多条命令作为一个命令组，命令组内的命令输入、输出重定向到相同的流内. -- 管理重定向->管道的使用
  # {} 不创建子shell的方式执行命令组，每条命令使用;或者换行分割。  -- 保留字
  # () 创建子shell的方式执行命令组，变量赋值在子shell结束后失效。  -- 操作符
  exit 1                                                                        
fi                                                                              

# 安装即拷贝，拷贝过程中最关键的 确定源目录和目的目录，以及要拷贝的文件
# 关键是确定当前目录和将要拷贝到的目录
BATS_ROOT="$(abs_dirname "$0")"                                                 # &数据处理
mkdir -p "$PREFIX"/{bin,libexec,share/man/man{1,7}} # {} 与 , 没有  {} 枚举扩展
cp -R "$BATS_ROOT"/bin/* "$PREFIX"/bin              # 匹配所有
cp -R "$BATS_ROOT"/libexec/* "$PREFIX"/libexec      # 匹配所有
cp "$BATS_ROOT"/man/bats.1 "$PREFIX"/share/man/man1
cp "$BATS_ROOT"/man/bats.7 "$PREFIX"/share/man/man7

echo "Installed Bats to $PREFIX/bin/bats"                                       # &处理结果说明
