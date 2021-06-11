====== Template Script ======

A template script with some common functionality:

<code bash template.sh>
#!/usr/bin/env bash

# exit if any command returns non-zero return code
# set -e
# fail if unset variable used
# set -u

readonly ACTIONS=(hop skip jump trapme release help)
readonly VERSION=1.0.0
readonly ACTIVITY=$((RANDOM % ${#ACTIONS[*]}))
readonly PROGRAM=$(basename "${0}")

function usage () {
  cat <<EOF

USAGE ${PROGRAM} [options]

  Array example program.
  There are only ${#ACTIONS[*]} valid actions: ${ACTIONS[@]}

OPTIONS

  -a action   - action to test
  -h help     - this help message
  -r release  - test this release (default = 4.7.1)
  -v version  - version information

EXAMPLE

  ${PROGRAM} -a ${ACTIONS[${ACTIVITY}]}

VERSION

  ${VERSION}
EOF
}

# error message
function error () {
    echo
    # show error message if provided
    if [ ! -z "$1" ]; then
        echo "$1"
    fi
    # show usage message
    usage
    # return code default is 1
    exit 1
}

# show release and version information
function release () {
    # examples of array splicing of a version
    echo
    v=${RELEASE:-4.7.1}
    echo "Given version (as major.minor.release) ...: ${v}"
    # split version at separator into array
    v_array=( ${v//\./ } )
    # show array elements
    echo "Convert string to array ..............: ${v_array[@]}"
    echo "Explicitly reference to major ........: ${v_array[0]}"
    echo "Implicit reference to major ..........: ${v_array[${#v_array[*]}-3]}"
    echo "Explicitly reference to minor ........: ${v_array[1]}"
    echo "Implicit reference to minor ..........: ${v_array[${#v_array[*]}-2]}"
    echo "Explicitly reference to release ......: ${v_array[2]}"
    echo "Implicit reference to release ........: ${v_array[${#v_array[*]}-1]}"
}

# sleep waiting for a signal
function trapme () {
    echo Script $(basename "$0") started with PID of $$
    while true ; do
        sleep 30
    done
}

function sigint () {
    echo 'INT(2) signal received'
}

function sigquit () {
    echo 'QUIT(3) signal received'
    exit 0
}

function sigterm () {
    echo 'TERM(15) signal received'
    exit 0
}

##########################################################################
# MAIN
##########################################################################

# trap signals
trap 'sigint'  INT
trap 'sigquit' QUIT
trap 'sigterm' TERM
trap ':'       HUP      # ignore specified signals

# process command line options
while getopts "?hva:r:" option; do
    case "$option" in
        a) ACTION=$(tr [A-Z] [a-z] <<< ${OPTARG} | xargs) ;; # lowercase, trim whitespace
        r) RELEASE=${OPTARG} ;;
        v) echo ${PROGRAM} version ${VERSION} && exit 0 ;;
        h|?|*) usage && exit 0 ;;
    esac
done
shift $((OPTIND-1))

# is action blank or invalid?
if [[ -z ${ACTION} || ! ${ACTIONS[*]} =~ ${ACTION} ]]; then
  error "ERROR: action '${ACTION}' is not allowed!"
fi

# do action, release, signal trap or help
echo INFO: Processing action ${ACTION}
case ${ACTION} in
    hop|skip|jump)
        echo ${ACTION} ;;
    release)
        release ;;
    trapme)
        trapme ;;
    help)
        usage ;;
    *)
        echo ERROR: should never get here! ;;
esac

#EOF
</code>

{{tag>bash template}}