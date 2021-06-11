#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

# PROMPT=$(echo '%{\033[36m%}%m>%{\033[30m%}')
RPROMPT=$(echo '%{\033[32m%}%~%{\033[30m%}')

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

autoload -U colors
#colors
 
if [[ $TERM == "xterm" ]] ; then
	export TERM=xterm-color
fi

export PATH=/opt/mpi/bin:~/.bin:~/.cabal/bin:${PATH}:~/.bin/xmind/XMind_Linux/

export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.zhistory
export PS1="%{${bg[white]}${fg[red]}%}%(?..(%?%))%{${fg[green]}${bg[grey]}%}%# "
#export PS1="%(?..(%?%))%# "


setopt INC_APPEND_HISTORY
# Remain 1 of the same cmds
setopt HIST_IGNORE_DUPS
# When u try to get out of the range, there's no beep to mention u
setopt NO_HIST_BEEP 
# If the cmd has no arg, zsh will try to regard it as a dir then to CD into it
setopt AUTO_CD
# Auto spell check for cmd
setopt CORRECT
# Multi redirections
setopt MULTIOS

# Type 'hash', see KEY=VALUE
# Finding cmds quickly by using hash table
# When add a duplicate cmd, need REHASH
setopt HASH_CMDS
# Hash all files in a certain dir
setopt HASH_ALL

# Neatly, put all aliases in a particular file
if [[ -r ~/.zaliasrc ]]; then
	# SOURCE == .
	. ~/.zaliasrc
fi

source /opt/intel/composerxe-2011.3.174/bin/compilervars.sh ia32

wiki () { dig +short txt $1.wp.dg.cx; }
cd ~

function wr()
{
    if (( $1 > 0 && $1 < 14)); then
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
