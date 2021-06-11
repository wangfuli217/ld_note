#!/usr/bin/env bash
#
# Description:
#
# Usage:
#   --help Display this help message
# Examples:
#
# Options:
#   Required:
#     GITHUB_AUTH_TOKEN with 'repo' or 'repo:status' OAuth scope
#
#   Optional:
#

set -euo pipefail
IFS=$'\n\t'
# Influenced by https://dev.to/thiht/shell-scripts-matter
# And see https://github.com/bf4/Notes/wiki/Shell-Scripting

show_help() {
  abort=${abort:0}
  sed -ne '/^#/!q;s/.\{1,2\}//;1d;p' < "$0" >&$((abort+1))
  exit abort
}

# Always log finish, bash pseudo-signal: EXIT
# Usage:
#   trap finish EXIT
# Optional:
#   Will execute a 'cleanup' function if defined.
finish() {
  info "END Running script: ${0##*/}"
  command -v cleanup &>/dev/null && cleanup
  info "Killing any child processes"
  # shellcheck disable=SC2015
  pgrep -lP $$ && pkill -P $$ || true
}

# Log errors, if any, bash pseudo-signal: ERR
# Usage:
#   trap 'finish_error $LINENO' ERR
finish_error()  {
  errcode=$?
  error "END ERROR Running script: ${0##*/}:$1: exited with '${errcode}'." >&2
}

cleanup() {
  # Remove temporary files
  # Restart services
  unset cmd
  unset pr
}

logstamp() {
  # http://unix.stackexchange.com/a/162615
  if [ "$(uname)" = Linux ]; then
    printf "[%s]" "$(TZ='America/Chicago' date +'%Y-%m-%d %H:%M:%S.%N')"
  else
    printf "[%s]" "$(TZ='America/Chicago' date +'%Y-%m-%d %H:%M:%S')"
  fi
}

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO] timestamp='$(logstamp)' pid='$$'   $@" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] timestamp='$(logstamp)' pid='$$'  $@" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR] timestamp='$(logstamp)' pid='$$'   $@" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL] timestamp='$(logstamp)' pid='$$'  $@" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }
debug()   { if [ "$DEBUG" = "true" ]; then 
            echo "[DEBUG] timestamp='$(logstamp)' pid='$$'  $@" | tee -a "$LOG_FILE" >&2 ; fi ; }

#################################### init
abspath="$(cd "${0%/*}" 2>/dev/null || exit 1; echo "$PWD"/"${0##*/}")"
script_dir="$(dirname "$abspath")"
DEBUG="${DEBUG:-false}"


if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
################################### main
trap finish EXIT
trap 'finish_error $LINENO' ERR

abort=0
if [ -z "$GITHUB_AUTH_TOKEN" ]; then echo "GITHUB_AUTH_TOKEN not found in env"; abort=1; show_help; fi
if [ -z "$1" ]; then echo "No command given"; abort=1; show_help; fi

cmd="$1"
pr=""

while [ $# -gt 1 ]; do
  debug "Processing '$1'. All $# options are: ${*}"
  case "$1" in
    get|create)
      cmd="$1"; shift
      pr="$1"; shift
      debug "cmd=$cmd pr=$pr"
      ;;

    *)
      if [ $# -gt 1 ]; then
        debug "Skipping '$1'"
        true
      else
        echo "Missing [cmd] [pr number]. got ${*}" >&2
        exit 1
      fi
 esac
done

debug "Final $# Options are: ${*}"

case "$cmd" in
  get)
    shift
    get_status "$pr"
    ;;
  create)
    shift
    create_status "$pr"
    ;;
  help|-h|--help)
    show_help
    ;;

  *)
    echo "ERROR: Don't know $cmd"
    abort=1
    show_help
    ;;
esac
fi