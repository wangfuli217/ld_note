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

export PATH=$HOME/.bin:$HOME/.cabal/bin:$PATH:/usr/local/texlive/2009/bin/i386-linux

alias  ls='ls --color=auto'
alias  ll='ls -hil --color=auto'
alias  la='ls -hila --color=auto'
alias  rm='rm -i --preserve-root'
alias  mv='mv -i'
alias  grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias  bo='/usr/local/bin/bg -f bochsrc'
alias  bd='/usr/local/bin/bochs'
alias  bg='/usr/local/bin/bg -f bochsrc-gdb'
alias  vim='vim -u ~/.vimrc'
alias gvim='gvim -u ~/.vimrc'
alias xmind='~/.bin/xmind/XMind_Linux/xmind'
alias cproto='cproto -f2 -e -s '
alias git-bin='cp ~/.bin/ ~/share -rf'
alias git-xmind='mv ~/.bin/xmind/XMind_Linux/*.xmind ~/share/xmind/'
alias git-logbak='git log > .gitlog'
alias git-conf='cp -rf ~/.*rc ~/.gitconfig ~/share'
alias git-arch='cp -fr /etc/rc.conf /etc/pacman.conf /etc/pacman.d/mirrorlist ~/share'
alias pacman='sudo pacman-color'
alias gfw='ssh -vv -CND 127.0.0.1:7070 -p 22 catvgfw48@69.163.129.147'

function wr()
{
    if (( $1 > 0 && $1 < 14 )); then
        ssh yzhang6@pek-lpgbuild${1}.wrs.com
    elif [ "$1" = "lab" ]; then
        ssh yzhang6@pek-tuxlab.wrs.com
    elif [ "$1" = "vlm" ]; then
        ssh -Y yzhang6@pek-tuxlab.wrs.com /folk/vlm/bin/vlmstart
    elif [ "$1" = "ssh" ]; then
        ssh -vv -CND 127.0.0.1:7070 -p 22 yzhang6@ala-lpggp3.wrs.com
    else
        echo "Unknown option, check please!"
    fi
}


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
export PS1='\[\e[01;32m\][\u@\[\e[01;33m\]\h\[\e[01;34m\]\W]\$ \[\e[00m\]'
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

echo "~/.bashrc"

# git input completion
# copy /etc/bash_completion/git firstly
#source ~/.git_completion

# mkdir, then cd into it
mkcd () {
	mkdir -p "$*"
	cd "$*"
}

wiki () { dig +short txt $1.wp.dg.cx; }

# OOO runs in GTK-2 mode
export OOO_FORCE_DESKTOP=gnome
export LOCALE="en_US.UTF-8"
