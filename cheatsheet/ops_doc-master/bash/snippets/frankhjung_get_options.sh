====== Get options ======

This page provides a shell for passing parameters to a
[[http://linux.die.net/man/1/bash|Bash(1)]] script.

===== getopts =====

The following example uses the [[http://linux.die.net/man/1/getopts|getopts(1)]]
internal bash command.

<file bash>
#!/usr/bin/env bash

readonly OPTIONS="?hvf:"
readonly PROGRAM=$(basename ${0})
readonly VERSION=1.0.0

usage () {
    cat <<HELP

USAGE ${PROGRAM} [options] -f <name> ...

    An example to show how getopts is used.

OPTIONS

    -h        - this help message
    -f <name> - a normal file
    -v        - version information

EXAMPLES

    # test against a file
    ${PROGRAM} -f ~/.bashrc

VERSION

    ${VERSION}
HELP
}

# show usage
if [ $# -eq 0 ]; then
    usage
    exit 0
fi

# process command line options
while getopts "${OPTIONS}" option; do
    case ${option} in
        f)
            FILE=${OPTARG}
            ;;
        v)
            echo "${PROGRAM} version ${VERSION}"
            exit 0
            ;;
        h|\?)
            usage
            exit 0
            ;;
    esac
done
shift $((OPTIND-1))
[ "$1" == "--" ] && shift
</file>

{{tag>bash getopts}}