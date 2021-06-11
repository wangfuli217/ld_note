#
# .bash_functions
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about Bash startup files at: http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html
# Read more about Bash programming at: http://www.gnu.org/software/bash/manual/bash.html
# Read more about GNU CoreUtils at: http://www.gnu.org/software/coreutils/manual/coreutils.html

#
# see all current environment variables
#
show_env() {
    ( set -o posix ; set ) | less
}

#
# get a timestamp
#
timestamp() {
    case "$(uname -s)" in
        Darwin) date +"%s" ;;
        *) date +"%T" ;;
    esac
}

#
# Run a command quietly. Suppresses all output.
#
quietly() {
    "$@" >/dev/null 2>&1;
}

#
# prints a ruler the size of the terminal window
#
ruler() {
    PADDER=$(printf '%0.1s' "#"{1..1000})
    if [ $# -gt 0 ]; then
        _date=$(date +"%A %e %B %Y %H:%M")
        echo -e "\033[1;36m[=============== ${*} ===(${_date})===============]\033[m"
    else
        printf "%*.*s\n" 0 "$(tput cols)" "${PADDER}";
    fi
}

#-------------------------------
# Files manipulation functions
#-------------------------------

#
# Get the system appropriate temp directory
# @see https://github.com/Jaymon/.bash/blob/master/util.sh
#
get_tmp(){
    tmp_dir="/tmp/"
    if [ "$TMPDIR" != "" ]; then
        tmp_dir="$TMPDIR"
    elif [ "$TMP" != "" ]; then
        tmp_dir="$TMP"
    elif [ "$TEMP" != "" ]; then
        tmp_dir="$TEMP"
    fi

    # make sure last char is a /
    # http://www.unix.com/shell-programming-scripting/14462-testing-last-character-string.html
    [[ "$tmp_dir" != */ ]] && tmp_dir="${tmp_dir}/";

    # http://stackoverflow.com/questions/12283463/in-bash-how-do-i-join-n-parameters-together-as-a-string
    if [ $# -gt 0 ]; then
        IFS="/"
        tmp_dir="${tmp_dir}${*}"
        unset IFS
    fi

    echo "$tmp_dir"
}

#
# moves file to ~/.Trash
# (use instead of rm)
#
trash(){
    if [ $# -eq 0 ]; then
        echo "usage: trash <file or dir> [<file or dir 2> ...]"
        return 1
    fi
    local _date=$(date +%Y%m%d)
    [ -d "${HOME}/.Trash/${_date}" ] || mkdir -p "${HOME}/.Trash/${_date}";
    for f in "$@"; do
        mv "${f}" "${HOME}/.Trash/${_date}"
        echo "${f} trashed!"
    done
}

#
# Make a directory and change to it
#
mkcd() {
    if [ $# -ne 1 ]; then
        echo "usage: mkcd <dirname>"
        return 1
    fi
    mkdir -p "$@" && cd "$_";
}

#
# cd to a directory and ls
#
cdls() {
    cd "$@" && ls -ltr;
}

#
# duplicate a file or dir
#
duplicate() {
    if [ $# -eq 0 ]; then
        echo "usage: duplicate <file or dir> [<copy name>]"
        return 1
    fi
    _source=$(basename "$1")
    _ext="${_source##*.}"
    _name="${_source%.*}"
    if [ $# -gt 1 ]; then
        _copy="$2"
    else
        _copy="${_name}.copy"
        if [ "${_ext}" != '' ]; then _copy+=".${_ext}"; fi
    fi
    cp -R "$_source" "$_copy" && echo "$_copy" || echo "error while copying '${_source}' to '${_copy}'";
}

#
# Backup file(s)
#
dobackup(){
    if [ $# -eq 0 ]; then
        echo "usage: dobackup <file or dir> [<file or dir2> ...]"
        return 1
    fi
    _date=$(date "+%Y%m%d-%H%M")
    for i in "$@"; do
        cp -R "${i}" "${i}.${_date}" && echo "${i}.${_date}" || echo "error while copying '${i}' to '${i}.${_date}'";
    done
}

#
# add the BOM marker in a file's header
addbom(){
    if [ $# -eq 0 ]; then
        echo "usage: addbom <working_dir/file> [<mask=*.php>]"
        return 1
    fi
    _dir="$1"
    _mask="${2:-*.php}"
    for _f in $(find "${_dir}" -type f -name "${_mask}"); do
        _f_tmp="${_f}.tmp"
        printf '\xEF\xBB\xBF' > "${_f_tmp}"
        cat "${_f}" >> "${_f_tmp}"
        rm -f "${_f}" && mv "${_f_tmp}" "${_f}"
        echo "${_f}"
    done
}

#
# Extract an archive of any type
#
extract () {
   if [ $# -eq 0 ]; then
       echo "usage: extract <file>"
       return 1
   fi
   if [ -f "$1" ] ; then
       case "$1" in
           *.tar.bz2) tar -xvjf "$1" ;;
           *.tar.gz) tar -xvzf "$1" ;;
           *.bz2) bunzip2 "$1" ;;
           *.rar) unrar -x "$1" ;;
           *.gz) gunzip "$1" ;;
           *.tar) tar -xvf "$1" ;;
           *.tbz2) tar -xvjf "$1" ;;
           *.tgz) tar -xvzf "$1" ;;
           *.zip) unzip "$1" ;;
           *.war|*.jar) unzip "$1" ;;
           *.Z) uncompress "$1" ;;
           *.7z) 7z -x "$1" ;;
           *) echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

#
# Creates an archive
#
tarball () {
    if [ $# -eq 0 ]; then
        echo "usage: tarball <filename> <contents ...>"
        return 1
    fi
    FILE="$1"
    shift
    ARGS="$*"
    if [ $# -eq 0 ]; then
       ARGS=$(echo "$FILE" | cut -d'.' -f1)
    fi
    case "$FILE" in
        *.tar.bz2|*.tbz2) tar -cvjf "$FILE" "$ARGS" ;;
        *.tar.gz|*.tgz) tar -cvzf "$FILE" "$ARGS" ;;
        *.tar) tar -cvf "$FILE" "$ARGS" ;;
        *.zip) zip -r "$FILE" "$ARGS" ;;
        *.rar) rar "$FILE" "$ARGS" ;;
        *.7z) 7zr -a "$FILE" "$ARGS" ;;
        *) echo "'$FILE' cannot be rolled via tarball()" && return 1 ;;
    esac
    echo "$FILE"
}

#
# print duplicate lines in file
#
dupes() {
    sort "$@" | uniq -d
}

#
# find borken links in dir and subdirs
#
findbrokenlinks() {
    d="${1:-.}"
    find "$d" -type l -! -exec test -e {} \; -print
}

#
# read a csv file
#
readcsv() {
    if [ $# -eq 0 ]; then
        echo "usage: csv [delim] <filename>"
        exit 1
    fi
    delim=';'
    if [ $# -gt 1 ]; then
        delim="$1"
        shift
    fi
    awk -F "$delim" '{if(NR==1)split($0,arr);else for(i=1;i<=NF;i++)print arr[i]":"$i;print "";}' "$1"
}

#
# Create an HTML file to bookmark a page
#
makebookmark() {
    if [ $# -lt 2 ]; then
        echo "usage: makebookmark <file_path> <url>"
        exit 1
    fi
    echo "<html><head><meta http-equiv=\"refresh\" content=\"0; url=$2\" /></head></html>" > $1
}

#-------------------------------
# Quick encryption library
#-------------------------------
#
# the lib uses a password (prompted each time) - REMEMBER IT !!
#
# this can allow to write something like:
#   alias mysqltest='p=$(decrypt_string U2FsdGVkX19FuOPF3w3+GG8E4f3+v042BguJw7vetA8=) && mysql -uUSER -p$p DB'
#

get_encryption_password () {
    read -s -p "your encryption password: " && echo "$REPLY"
}

encrypt_string () {
    if [ $# -eq 0 ]; then
        echo "usage: encrypt_string <my string to encrypt>"
        echo "(a password will be prompted)"
        return 1
    fi
    local p=$(get_encryption_password)
    echo "$1" | openssl enc -aes-256-cbc -a -salt -pass "pass:$p" 2> /dev/null;
}

decrypt_string () {
    if [ $# -eq 0 ]; then
        echo "usage: decrypt_string <my string to decrypt>"
        echo "(a password will be prompted)"
        return 1
    fi
    local p=$(get_encryption_password)
    echo "$1" | openssl enc -aes-256-cbc -a -salt -d -pass "pass:$p" 2> /dev/null;
    if [ $? -ne 0 ]; then echo '! > wrong password' && return 1; fi
}

encrypt_file () {
    if [ $# -eq 0 ]; then
        echo "usage: encrypt_file <file_path_to_encrypt> [encrypted_file_path]"
        echo "(a password will be prompted)"
        return 1
    fi
    local ifile="$1"
    local ofile="${2:-${ifile}-$(date '+%s').enc}"
    local p=$(get_encryption_password)
    if [ -f "$ifile" ]; then
        openssl enc -aes-256-cbc -a -salt -pass "pass:$p" -in "$ifile" -out "$ofile" 2> /dev/null;
    else
        echo "! > input file '$ifile' not found" && return 1
    fi
    echo "$ofile";
}

decrypt_file () {
    if [ $# -eq 0 ]; then
        echo "usage: decrypt_file <file_path_to_decrypt> [decrypted_file_path]"
        echo "(a password will be prompted)"
        return 1
    fi
    local ifile="$1"
    local ofile="${2:-${ifile}-$(date '+%s').dec}"
    local p=$(get_encryption_password)
    if [ -f "$ifile" ]; then
        openssl enc -aes-256-cbc -a -salt -pass "pass:$p" -in "$ifile" -out "$ofile" -d 2> /dev/null;
        if [ $? -ne 0 ]; then rm -f "$ofile" && echo '! > wrong password' && return 1; fi
    else
        echo "! > input file '$ifile' not found" && return 1
    fi
    echo "$ofile";
}

#-------------------------------
# Machine info
#-------------------------------

#
# load in _IP & _ISP
#
getip () {
    _IP=$(ifconfig | awk '/inet / { print $2 } ' | sed -e s/addr:// 2>&-)
    export _IP="${_IP//127\.0\.0\.1/}"
    export _ISP=$(ifconfig | awk '/P-t-P/ { print $3 } ' | sed -e s/P-t-P:// 2>&-)
    echo "$_IP"
}

#
# Load computer's current ip address in _EIP
# http://www.coderholic.com/invaluable-command-line-tools-for-web-developers/
#
getextip(){
    if [ "$(which curl &> /dev/null; echo $?)" -eq 0 ]; then
        export _EIP=$(curl -s http://ifconfig.me/ip)
    else
        export _EIP=$(wget -qO- http://ifconfig.me/ip)
    fi
    echo "$_EIP"
}

#
# cf. <http://www.admin-linux.fr/?p=1965>
# can take a timestamp as argument
#
envdate() {
    [ ! -z "$1" ] && date -d "@${1}" +'%d/%m/%Y (%A) %X (UTC %z)' || date +'%d/%m/%Y (%A) %X (UTC %z)';
}

#
# device infos
#
getenvinfo () {
    getip;
    getextip;
    echo
    echo -e "# $(envdate)"
    echo -e "current user:     $(whoami)"
    echo -e "system info:      $(uname -n)"
    echo -e "device info:      $(uname -v)"
    echo -e "device stats:     $(uptime)"
    echo -n "Int. IP address:  "; echo "$_IP"
    echo -n "Ext. IP address:  "; echo "$_EIP"
    echo -n "ISP address:      "; echo "$_ISP"
    echo -e "#"
    echo
}

#-------------------------------
# Shortcuts
#-------------------------------

#
# Email me a short note
#
emailme(){
    if [ $# -eq 0 ]; then
        echo "usage: emailme <subject> [text]"
        return 1
    fi
    local subject="$1"
    shift
    [ "$USERMAIL" == '' ] && _to=$USER || _to=$USERMAIL;
    mailx -s "${subject}" "$_to" <<< "$@" && echo "email sent to ${_to}" || "email NOT sent!";
}

#-------------------------------
# Simple notepad
#-------------------------------

# personal notes (not under VCS) are stored in notes/perso/
note(){
    if [ -z "$NOTESDIR" ]; then
        echo "NOTESDIR is not defined, can't use the notepad!"
        return 1
    fi
    if [ $# -eq 0 ]; then
        echo "usage:   note ls"
        echo "           list all notes"
        echo "usage:   note <note name>"
        echo "           read a note"
        echo "usage:   note <note name> <action (+/-)> [note text ...]"
        echo "           action +  to write a note"
        echo "           action ++ to write a note with date header"
        echo "           action -  to clear note"
        echo "           action -- to remove a note"
        echo "           action vi to open a note with EDITOR"
        echo "NOTE : use the 'cheatsheet' cmd for cheat-sheets"
        return 1
    fi
    case $1 in
        ls) 
            which tree &> /dev/null && tree "$NOTESDIR" || ls "$NOTESDIR";
            return 0
            ;;
        *) notestack="$1"; shift;;
    esac
    append=1
    action=read
    if [ "$notestack" == '-' ]; then
        notestack=$(date +"%d-%m-%y")
    fi
    if [ "$1" == '++' ]; then
        action=add
        append=0
        shift
    elif [ "$1" == '+' ]; then
        action=add
        shift
    elif [ "$1" == '--' ]; then
        rm "${NOTESDIR}/${notestack}"
        echo "> note '${notestack}' deleted"
        return 0
    elif [ "$1" == '-' ]; then
        echo '' > "${NOTESDIR}/${notestack}"
        echo "> note '${notestack}' cleared"
        return 0
    elif [ "$1" == 'vi' ]; then
        "${EDITOR}" "${NOTESDIR}/${notestack}"
        return 0
    fi
    if [ "${action}" == 'read' ]; then
        if [ ! -f "${NOTESDIR}/${notestack}" ]; then
            echo "!! > note '${notestack}' not found!"
            return 1
        fi
        if which less &> /dev/null; then
            less "${NOTESDIR}/${notestack}"
        elif which more &> /dev/null; then
            more "${NOTESDIR}/${notestack}"
        else
            cat "${NOTESDIR}/${notestack}"
        fi
    else
        takenote="$*"
        if [ "$append" -eq 0 ]; then
            {   echo
                echo "## $(date '+%T, %a %d/%m/%y')"
                echo '------------------------'
            } >> "${NOTESDIR}/${notestack}"
        fi
        echo "${takenote}" >> "${NOTESDIR}/${notestack}"
        echo "> note added to '${notestack}'"
    fi
}

cheatsheet() {
    if [ $# -eq 0 ]; then
        echo "usage:   cheatsheet <note name>"
        echo "           read a cheatsheet"
        echo "usage:   cheatsheet <note name> [note text ...]"
        echo "           write a cheatsheet or add content in it"
        return 1
    fi
    _name="cheatsheets/${1}-cheatsheet.txt"
    shift
    note "${_name}" "$*"
}

_note_completion() {
    local cur prev opts finalopts otheropts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="- -- + ++ vi"
    case "${prev}" in
        note|-|--|+|++|vi)
            basedir="${NOTESDIR}"
            ;;
        cheatsheet)
            basedir="${NOTESDIR}/cheatsheets"
            ;;
    esac;
    if [ -z "$cur" ]; then
        finalopts=$(cd "${basedir}" && find * -maxdepth 0 -print)
    else
        curdir=$(dirname "$cur")
        curfile=$(basename "$cur")
        if [ "$curdir" == '.' -o -z "curdir" ]; then
            curdir=''
            curfile="$cur"
        elif [ -d "${basedir}/${cur}" ]; then
            cur="${cur}/"
            curdir="$cur"
            curfile=''
        fi
        finalopts=$(cd "${basedir}/${curdir}" && find * -name "${curfile}*" -maxdepth 1 -print)
    fi
    finalopts=$(echo "$finalopts" | sed "s:${basedir}::" | sed 's://*$:/:')
    [ "$prev" == 'cheatsheet' ] && finalopts=$(echo "$finalopts" | sed 's:-cheatsheet.txt::')
    COMPREPLY=( $(compgen -W "${finalopts}" -- "${cur}") )
    return 0
}
