#!/usr/bin/env bash

if [[ $DEBUG ]]; then
    set -x
fi

set -euo pipefail
IFS=$'\n\t'

#/ Usage:
#/ Description:
#/ Examples:
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

GREEN='\033[1;32m';RED='\033[1;31m';YELLOW='\033[1;33m';PURPLE='\033[1;36m';NC='\033[0m' # No Color
DATE_FMT='%Y-%m-%d %H:%M:%S'

readonly LOG_FILE="./$(basename "$0").log"
info()  { echo -e "$(date +${DATE_FMT}) $$ [${GREEN}INFO${NC}]   $*" | tee -a "$LOG_FILE" >&2 ; }
warn()  { echo -e "$(date +${DATE_FMT}) $$ [${YELLOW}WARN${NC}]   $*" | tee -a "$LOG_FILE" >&2 ; }
error() { echo -e "$(date +${DATE_FMT}) $$ [${RED}ERROR${NC}]  $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ;}
debug() { echo -e "$(date +${DATE_FMT}) $$ [${PURPLE}DEBUG${NC}]  $*" | tee -a "$LOG_FILE" >&2 ; }

cleanup() {
    # Remove temporary files
    # Restart services
    info "Cleanup finished"
}
trap cleanup EXIT

########################################## MAIN SCRIPT  ######################################################