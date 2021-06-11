# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# source bash_completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ $TERM == "xterm" ] ; then
	export TERM=xterm-color
fi

# Shutdown auto-recover. Using >| when recoving
set -o noclobber

# enable -n cd
#function cd { builtin cd; echo $PWD; }

# User specific aliases and functions

export PATH=$PATH:/folk/vlm/commandline:/folk/vlm/bin:~/bin:/lpg-build/cdc/bsp/wrlinux-4.0/dvd_install/lx28a_09fa/wrlinux-4/ldat/scripts:/folk/yzhang6/prj/export/sysroot/mindspeed_c1000-glibc_std/x86-linux2:/folk/yzhang6/prj/host-cross/toolchain/x86-linux2/bin

alias  ls='ls --color=auto'
alias  ll='ls -hil --color=auto'
alias  la='ls -hila --color=auto'
alias  rm='rm -i'
alias  mv='mv -i'
alias  grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias  bo='/usr/local/bin/bg -f bochsrc'
alias  bd='/usr/local/bin/bochs'
alias  bg='/usr/local/bin/bg -f bochsrc-gdb'
alias xmind='~/.bin/xmind/XMind_Linux/xmind'
alias cproto='cproto -f2 -e -s '
alias git-bin='cp ~/.bin/ ~/share -rf'
alias git-xmind='mv ~/.bin/xmind/XMind_Linux/*.xmind ~/share/xmind/'
alias git-logbak='git log > .gitlog'
alias git-conf='cp -rf ~/.*rc ~/.gitconfig ~/share'
alias git-arch='cp -fr /etc/rc.conf /etc/pacman.conf /etc/pacman.d/mirrorlist ~/share'
alias pacman='sudo pacman-color'


# History append
shopt -s histappend
# Spell check while using CD
shopt -s cdspell

# Saving history, showing prompts
PROMPT_COMMAND='history -a'

BLUE=`tput setf 1`
GREEN=`tput setf 2`
CYAN=`tput setf 3`
RED=`tput setf 4`
MAGENTA=`tput setf 5`
YELLOW=`tput setf 6`
WHITE=`tput setf 7`

# if \[$WHITE\] doesn't exist, $ will be a normal char that could be deleted
export PS1='\[$GREEN\]\u@\h \[$BLUE\]\w\[$GREEN\] \$\[$WHITE\] '
#PS1='\[\e[0;32m[\]\[\e[0;37m\]\u\[\e[m\] \[\e[0;34m\]\w\[\e[m\]\[\e[0;32m]\]\[\e[0;37m\]\$\[$WHITE\] '
#PS1='\[\e[0;32m[\]\[\e[0;37m\]\u\[\e[m\] \[\e[0;34m\]\w\[\e[m\] \[\e[0;32m]\]\[\e[0;37m\]\$ \[\e[m\]\[\e[0;32m\]'

# export PS1='`pwd` > '
export PS2='continue -- '
export PS3='choose: '
export PS4='|${BASH_SOURCE} ${LINENO}${FUNCNAME[0]:+ ${FUNCNAME[0]}()}|  '

# colorful man page
export PAGER="`which less` -s"
export BROWSER="$PAGER"
export LESS_TERMCAP_mb=$'\E[01;34m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;33m'

# git input completion
# copy /etc/bash_completion/git firstly
#source ~/.git_completion

# mkdir, then cd into it
mkcd () {
	mkdir -p "$*"
	cd "$*"
}

vlm_usage () {
    if [ "$1" = 2 ]; then
        echo "Usage: vlm FUNC TARGET"
    elif [ "$1" = 4 ]; then
        echo "Usage: vlm copyFile TARGET KERNEL ROOTFS"
    else
        echo "Wrong args !!"
    fi
}

vlm () {
    case $1 in
        reserve | unreserve | turnOn | turnOff | reboot)
            if [ "$#" != 2 ]; then 
                vlm_usage 2
            else
                vlmTool $1 -s amazon -t $2
            fi ;;
        getAttr)
            if [ "$#" != 2 ]; then 
                vlm_usage 2
            else
                vlmTool $1 -s amazon -t $2 all
            fi ;;
        findMine)
            vlmTool $1 -s amazon -l ;;
        copyFile)
            if [ "$#" != 4 ]; then
                vlm_usage 4
            else 
                vlmTool $1 -s amazon -t $2 -k $3 -r $4
            fi ;;
        *)
            vlm_usage 0
    esac
}

alias dirs='dirs -v -p'
pushd /buildarea2/ggao/sdk-comcerto-openwrt-6.0/package
pushd /buildarea2/ggao/sdk-comcerto-openwrt-6.0/dl
pushd /lpg-build/cdc/bsp/wrlinux-4.0/dvd_install/lx28a_09fa/wrlinux-4/layers/wrll-userspace/core/packages
pushd /lpg-build/cdc/bsp/wrlinux-4.0/dvd_install/lx28a_09fa/wrlinux-4/layers/wrll-userspace/core/dist
pushd /lpg-build/cdc/bsp/wrlinux-4.0/dvd_install/lx28a_09fa/ # install dir
pushd ~/prj
