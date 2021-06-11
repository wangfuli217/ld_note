#!/bin/bash
# This template may be used in any bash script file.
# It enables SIG handling (update respective functions)
# It enables logging with levels (LOG functions)

set -euo pipefail # Unofficial Bash Strict Mode
IFS=$'\n\t'
# set -x  # uncomment this line for dev-debug purposes


### Initial variables and constants  (optional)
__VERBOSE=7 # 7=DEBUG


###################################


############################ LOG Functions ############################
# eg:
# .info "info message"
# .error "error message"
declare -A LOG_LEVELS
LOG_LEVELS=([0]="EMERG" [1]="ALERT" [2]="CRIT" [3]="ERROR" [4]="WARNING" [5]="NOTICE" [6]="INFO" [7]="DEBUG")
function .log () {
  local LEVEL=${1}
  shift
  local LINE=${1}
  shift

  if [ "${__VERBOSE:-7}" -ge "${LEVEL}" ]; then
    message=$(IFS=" " ; echo "$*")
    echo "[${LOG_LEVELS[$LEVEL]}:${LINE}] - $(date +%Y-%m-%dT%H:%M:%S%z) - " "$message"
  fi
}
function .debug () { .log 7 "${BASH_LINENO[0]}" "$*" ; }
function .info () { .log 6 "${BASH_LINENO[0]}" "$*" ; }
function .warn () { .log 5 "${BASH_LINENO[0]}" "$*" ; }
function .error () { .log 3 "${BASH_LINENO[0]}" "$*" ; }
###############################################################################

############################ Trap SIGs ############################

_onexit() {
  .info "Cleanup..."
  .info "Removing files any temp file"
  exit "${__return_code:-1}"
}
trap _onexit EXIT

_term() {
  .info "Caught SIGTERM signal! Going to terminate"
  __return_code=${__return_code:-0}
  exit
}
trap _term SIGTERM

_reload() {
  .info "Caught SIGHUP signal! Going to reload"
  # set +e
  # kill "$_SLEEP_PID"
  # unset _SLEEP_PID
  # set -e
}
trap _reload SIGHUP

_debug_mode_toggle() {
  set +u
  if [[ -z "$_TOGGLE_DEBUG_MODE" ]]; then
    _TOGGLE_DEBUG_MODE="${__VERBOSE}"
    __VERBOSE="7"
  else
    __VERBOSE="${_TOGGLE_DEBUG_MODE}"
    unset _TOGGLE_DEBUG_MODE
  fi
  .info "Caught SIGUSR1 signal! Toggelling Debug mode. VERBOSITY = ${__VERBOSE}"
  set -u
}
trap _debug_mode_toggle SIGUSR1

###############################################################################