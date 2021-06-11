# .bashrc

# User specific aliases and functions

alias rm='rm -i'

alias cdlms='cd /root/rtu/lms'
alias cdsvn='cd /root/rtu/svn'
alias cdrtu='cd /root/rtu/otdr/rtu'

alias cdt='cd /root/rtu/lms/lmsevent/t'

alias cdqueue='cd /root/rtu/queue'

alias cdsrv='cd /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/Service'

alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias shfmt='shfmt -l -w -i 2 -ci'

alias nmaphost='nmap -sP'
alias nmapport='nmap -sT'

alias lsofsock='lsof -i'              # netCons:      Show all open TCP/IP sockets
alias lsofnet='lsof -i -P'            # lsock:        Display open sockets
alias lsofudp='lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsoftcp='lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets


historys(){
  history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head -20
}

manman(){
cat <<'EOF' -
man readline # 命令行快捷键 
man -t errno | ps2pdf - ~/errno.pdf
man epoll | col -b > epoll.txt 

man builtins # bash 内置命令
man iptables | col -b | grep iptables
man -M/usr/share/man:/usr/share/man/local ftp

man -a printf  # 在所有section中查找主题为printf的手册页 
man -k printf  # 在所有manual的简述中查找printf关键词 
man -K printf  # 正文中查找
man 3 printf   # 直接查看系统调用类帮助文档中主题名为printf的手册页 
EOF
}

cppcheat(){
cat <<'EOF' -
https://zh.cppreference.com
https://github.com/EthsonLiu/stackoverflow-top-cpp
https://github.com/Algorithms-in-cpp/CUJ-1990-2000
http://freshsources.com/HTML/11.11/ALLISON/
https://github.com/cirosantilli/cpp-cheat
https://github.com/cirosantilli/linux-cheat
https://github.com/cirosantilli/algorithm-cheat
EOF
}

ccheat(){
cat <<'EOF' -
http://c-faq.com/
https://github.com/Algorithms-in-cpp/CUJ-1990-2000
http://freshsources.com/HTML/11.11/ALLISON/
https://github.com/cirosantilli/cpp-cheat
https://github.com/cirosantilli/linux-cheat
https://github.com/cirosantilli/algorithm-cheat
https://github.com/nixawk/hello-c
https://github.com/bradfa/tlpi-dist
EOF
}


bashcheat(){
cat <<'EOF' -
http://mywiki.wooledge.org/BashFAQ
https://github.com/cirosantilli/bash-cheat
https://github.com/cirosantilli/ubuntu-cheat
https://github.com/cirosantilli/networking-cheat
EOF
}

# https://github.com/cirosantilli/android-cheat
# https://github.com/cirosantilli/sys-prog-examples

####### cpprun crun #######
cpprun() {
  g++ -o "$1" "$1.cpp"
  ./"$1"
}

crun() {
  gcc -o "$1" "$1.c"
  ./"$1"
}

####### astyle #######
cppstyle() {
  astyle --style=google *.cpp > /dev/null 2>&1
  astyle --style=google *.hpp > /dev/null 2>&1
  astyle --style=google *.h   > /dev/null 2>&1
  find -name "*.orig" | xargs rm -f
}

cpprstyle() {
  astyle --recursive --style=google *.cpp > /dev/null 2>&1
  astyle --recursive --style=google *.hpp > /dev/null 2>&1
  astyle --recursive --style=google *.h   > /dev/null 2>&1
  find -name "*.orig" | xargs rm -f
}

cstyle() {
  astyle --style=google *.c  > /dev/null 2>&1
  astyle --style=google *.h  > /dev/null 2>&1
  find -name "*.orig" | xargs rm -f        
}

crstyle() {
  astyle --recursive --style=google *.c > /dev/null 2>&1
  astyle --recursive --style=google *.h > /dev/null 2>&1
  find -name "*.orig" | xargs rm -f
}

javastyle(){
  astyle --style=google *.java  > /dev/null 2>&1
  find -name "*.orig" | xargs rm -f
}

javarstyle(){
  astyle --recursive --style=google *.java > /dev/null 2>&1
  find -name "*.orig" | xargs rm -f
}

####### shfmt #######
shstyle(){
  shfmt -l -w -i 2 -ci *.sh > /dev/null 2>&1
  if [ $# -ge 1 ]; then
    shfmt -l -w -i 2 -ci $1 > /dev/null 2>&1
  fi
}

####### make #######
makec(){
cat <<'EOF' > ./Makefile
warning-flags := \
		-Wall \
		-Wextra \
		-Wformat=2 \
		-Wunused-variable \
		-Wold-style-definition \
		-Wstrict-prototypes \
		-Wno-unused-parameter \
		-Wmissing-declarations \
		-Wmissing-prototypes \
		-trigraphs \
		-Wpointer-arith 

optim-flags := -O0 -g3 -std=gnu99 -lm -pthread

CFLAGS := $(warning-flags) $(optim-flags)

sources := $(wildcard *.c)

# $(basename <names...>)  
bin := $(basename $(sources))

all: $(bin)
	echo $(bin)

clean:
	rm -f $(bin)
codestyle:
	@indent -kr -i4 -ts4 -sob -ss -sc -npsl -pcs -bs -l130 -nut -npro -brf *.[ch] > /dev/null 2>&1
	-rm -f *.c~  > /dev/null 2>&1
	-rm -f *.h~  > /dev/null 2>&1

.PHONY: clean
.PHONY: codestyle
EOF
}

makecpp(){
cat <<'EOF' > ./Makefile
warning-flags := \
		-Wall \
		-Wextra \
		-Wformat=2 \
		-Wunused-variable \
		-Wold-style-definition \
		-Wstrict-prototypes \
		-Wno-unused-parameter \
		-Wmissing-declarations \
		-Wmissing-prototypes \
		-trigraphs \
		-Wpointer-arith 

optim-flags := -O0 -g3 -lm -pthread

CFLAGS := $(warning-flags) $(optim-flags)

sources := $(wildcard *.cpp)

# $(basename <names...>)  
bin := $(basename $(sources))

all: $(bin)
	echo $(bin)

clean:
	rm -f $(bin)
codestyle:
	@astyle --style=google *.cpp > /dev/null 2>&1
	@astyle --style=google *.hpp > /dev/null 2>&1
	-rm -f *.orig	  > /dev/null 2>&1

.PHONY: clean
.PHONY: codestyle
EOF
}

clanglint(){
  scan-build clang -c *.[ch] *.cpp *.hpp > /dev/null 2>&1
}

complexitylint(){
  complexity --histogram --score --thresh=3 *.[ch] *.cpp *.hpp > /dev/null 2>&1
}

####### bash #######
makebash(){
cd /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/bash/bash-script-template-stable
echo "https://github.com/ralish/bash-script-template"
echo "---- bash automatic test tools ----"
echo "/root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/bash/bats"
echo "/root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/bash/shunit2"
}

makesh(){
cd /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/bash/shunit2
echo "openwrt"
}

monitsh(){
cat <<'EOF' > ./monit.sh
#!/bin/sh

prog=shellinaboxd
vsftpd=/sbin/shellinaboxd
pidfile=/var/run/shellinaboxd.pid
RETVAL=0
PID=0

start() {
  echo -n $"Starting $prog: "
  
  while true ; do
    shellinaboxd -t -u root -g root -b --pidfile=/var/run/shellinaboxd.pid
    PID=$(/sbin/ss -l -p -n | awk '/:23/{ print $5 }' | awk -F ','  '{ print $2 }')
    echo ${PID} > ${pidfile}
  done
}

stop() {
  echo -n $"Stopping $prog: "
  PID=$(/sbin/ss -l -p -n | awk '/:4200/{ print $5 }' | awk -F ','  '{ print $2 }')
  kill ${PID}
}

restart() {
  stop
  start
}



case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    PID=$(/sbin/ss -l -p -n | awk '/:4200/{ print $5 }' | awk -F ','  '{ print $2 }')
    echo ${PID}
    ;;
  *)
    echo $"Usage: $prog {start|stop|restart|status}"
    RETVAL=2
esac

exit $RETVAL
EOF
}

####### command #######
makeiptales(){
  cp /root/rtu/otdr/crosstool/cheatsheet/firewall/c6-iptables_standalone_optimized.sh $1
}

mangcc(){
  vim /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/makefile/gcc.sh
}
manshell(){
  vim /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/shell实例手册.sh
}
manbash(){
  vim /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/bash编程手册.sh
}
maniptables(){
  vim /root/rtu/otdr/crosstool/cheatsheet/iptables.sh
}
mansed(){
  vim /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/ONE-LINE-SCRIPTS-FOR-sed-cn.txt
}
manawk(){
  vim /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/ONE-LINE-SCRIPTS-FOR-sed-awk-cn.txt
}


####### cpp #######
manIO(){
  vim /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/Service/IO处理参考说明.sh
}

manc(){
  vim /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/Service/CStyle.sh
}

manqueue(){
  vim /root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/Service/libevent/queue.txt
}


demoqueue(){
echo "---- style 1 ----"
cat <<'EOF' -
TAILQ_HEAD (tailq_head, char_node);

struct char_node {
    TAILQ_ENTRY (char_node) node;
    char data;
};
EOF

echo "---- style 2 ----"
cat <<'EOF' -
typedef struct animal_ {
    TAILQ_ENTRY (animal_) link;
    char name[32];
} animal;

TAILQ_HEAD (animal_head_, animal_);
typedef struct animal_head_ animal_head;
EOF

echo "---- style 3 ----"
cat <<'EOF' -
struct spdk_log_flag {
	TAILQ_ENTRY(spdk_log_flag) tailq;
	const char *name;
	bool enabled;
};
static TAILQ_HEAD(, spdk_log_flag) g_log_flags = TAILQ_HEAD_INITIALIZER(g_log_flags);
EOF
}

rsync_server(){

cat <<'EOF' > ./rsyncd.conf
uid = root
gid = root
use chroot = no
max connections = 200
timeout = 300
motd file = /var/rsyncd/rsync.motd
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
dont compress = *.gz *.tgz *.zip *.z *.Z *.rpm *.deb *.bz2

#[longshuai]
#path = /longshuai/
#ignore errors
#read only = true
#write only = false
#list = false
#hosts allow = 192.168.0.0/16
#auth users = rsync_backup,wangfuli
#secrets file = /etc/rsyncd.passwd
[crosstool]
path=/root/rtu/otdr/crosstool/
read only = true
hosts allow = 192.168.0.0/16
ignore errors
comment = anyone can access
[lmsdata]
path=/root/rtu/lms/
read only = true
hosts allow = 192.168.0.0/16
ignore errors
comment = anyone can access
[rtu]
path=/root/rtu/
read only = true
hosts allow = 192.168.0.0/16
ignore errors
comment = anyone can access
EOF

cat <<'EOF' > ./rsyncd.conf
rsync_backup:123456
EOF
}

rsync_client(){
echo "crontab -e"
echo "21 23 * * 2 /usr/bin/rsync -az  192.168.10.107::svndata /home/svndata/"
}

tunec(){
cat <<'EOF' -
#!/bin/bash

for file in $@ ; do
# V:\rtu\otdr\crosstool\cheatsheet\ops_doc-master\Service\代码大全\编程的智慧.txt
  grep -w -n if ${file} | grep -v "\{"              # if {
  grep -w -n else ${file} | grep -v "\{"            # else {  ->使用了else子句并加以说明吗？
  grep -w -n else ${file} | grep -v "\}"            # } else  ->else子句用的对吗？
  grep -w -n for ${file} | grep -v "\{"             # for {
  grep -w -n while ${file} | grep -v "\{"           # while {
  grep -n "++" ${file} | grep "retrun"              # return ++
  grep -n "++" ${file} | grep -v "for" | grep "("  | grep ")"            # (++)
# V:\rtu\otdr\crosstool\cheatsheet\ops_doc-master\Service\cfaq.txt  cfaq(stdint)
  grep -n "unsigned" ${file}                       # uint8_t uint16_t uint32_t uint64_t
  grep -n "long" ${file}                           # intptr_t uintptr_t
#  grep -n -w "for"  ${file} | grep "++" | grep -v "uint"   # for(uint_xt, ,) need -std=gnu99 -> 每个变量都有且仅有一项用途吗？
  grep -n -w "malloc"  ${file}                       # malloc alter calloc(1, sizeof)
  grep -n -w "memset"  ${file}                       # initialize {0} and calloc(1, sizeof)
done



# uint8_t uint16_t uint32_t uint64_t int8_t int16_t int32_t int64_t
# float double
# uintptr_t intptr_t ptrdiff_t intmax_t uintmax_t
# PRIdPTR PRIuPTR PRIdMAX PRIuMAX

# 声明但未定义变量
# 最小的作用域
# const char* | const uint8_t*
# 如果循环的长度超过了一两行代码或者出现了嵌套循环，那么就应该是i、j或者k以外的其他名字
# default 默认子句用得合法吗？
# 在C、C++或者Java里，每一个case的末尾都有一个break吗？
# 为了捕捉错误，可以使用case语句中的default子句(默认子句)，或者使用if-then-else语句串中的最后那个else子句

# <stdbool.h> false true  -> 表达式中用的是true和false，而不是1和0吗？

# 允许静态自动分配初始化数组    uint32_t numbers[64] = {0};
# 允许静态自动分配初始化结构体  struct thing localThing = {0}; 或 localThing = (struct thing){0};

# -Wall -Wextra -pedantic -Wshadow -Wstrict-overflow -fno-strict-aliasing
# -std=gnu99
# -D
#### moosefs
# CFLAGS="-O0 -fno-omit-frame-pointer -g -DMFSDEBUG -std=c99 -Wall -Wextra -Wshadow -pedantic -fwrapv"
# CFLAGS="-O2 $CFLAGS -g -std=c99 -Wall -Wextra -Wshadow -pedantic -fwrapv"
# CPPFLAGS="$CPPFLAGS -DGPERFTOOLS"
# LDFLAGS="$LDFLAGS -L/opt/local/lib -lprofiler"
# CPPFLAGS="$CPPFLAGS -D_GNU_SOURCE -DDEFAULT_SUGID_CLEAR_MODE_EXT"

# 别让多个全局变量分布在一个函数中，更别使全局变量在多个文件中。
# ((())) 超过3个都需要关注 {{{}}} 超过3层都需要管制
# grep ")))" -rn ./* | grep "&&"
# grep ")))" -rn ./* | grep "||"
# grep "(((" -rn ./* | grep "&&"
# grep "(((" -rn ./* | grep "||"
# grep "(((" -rn ./*
# grep ")))" -rn ./*

# 限定宏字面常量值类型
#. l/L 表示整型常量为long，比如33L
#  u/U 表示整型常量为unsigned int 比如33U
#  ul UL LU lu 表示 unsigned long 比如 33UL  
#  F
EOF
}

# Handy extract function
# unzips everything with one command
function extract(){
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi
JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/lib/tool.jar

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Load Bash It
