====== Bash run commands (bashrc) ======

Here are default settings for shell sessions:

  * {{:frank:bash:bashrc|.bashrc}}

===== Program language settings =====

Some programming language settings:

<code bash>
# java development
export JAVA_HOME=/usr/lib/jvm/default-java
export JAVA_PATH=$JAVA_HOME/jre/bin:$JAVA_HOME/bin
export CLASSPATH=$JAVA_HOME/jre/lib:/usr/share/plantuml/plantuml.jar
export PATH=$PATH:$JAVA_PATH

# ruby development
export RBXOPT=-X19
source /etc/profile.d/rvm.sh
# source /usr/local/rvm/scripts/rvm
</code>

===== Sane ls(1) colours =====

When using ''ls --color=auto'' the default assumes a light coloured background.
This is not what I typically encounter, or use. Rather I use a dark background.
Consequently the colour map is all wrong. Try using these instead:

<code bash>
# enable colour support of ls and also add handy aliases
shopt -s dirspell
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
</code>

===== Coloured man pages =====

To colourise man pages Insert the following into ''.bashrc'':

<code bash>
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}
</code>

===== Bash aliases =====

Default session aliases:

<code bash .bash_aliases>
#!/bin/bash

# User specific aliases and functions
#
alias ,='ls -Fal'
alias H='fc -l -1000'
alias T='printf "\033];${PWD##*/}\007"'
alias backupxfce='tar jcvf $HOME/documents/etc/xfce4.tar.bz2 -C $HOME .config/user-dirs.dirs -C $HOME .config/user-dirs.locale -C $HOME .config/autostart -C $HOME .config/xfce4 -C $HOME .local/share/applications'
alias bu='journalctl | grep -P "rsnapshot\[\d+\]" | tail -36'
alias c='printf "\033];${PWD##*/}\007"; clear'
alias gitclean='git gc --aggressive --prune=now; git fsck --full --strict'
alias grep='grep --color=auto'
alias gvim='gvim -p'
alias h='history'
alias info='pinfo'
alias ipython='/usr/bin/ipython3 --term-title'
alias l='ls -Fl'
alias ls='ls --color=auto'
alias rvm-restart='rvm_reload_flag=1 source '\''/home/frank/.rvm/scripts/rvm'\'''
alias vimhelp='lynx /usr/share/doc/vim-doc/html/index.html'
alias xclip='xclip -in -selection clipboard'
</code>

{{tag>bash bashrc}}