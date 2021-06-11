#!/bin/bash

# Template to start a simple bash program.  This is designed only for the
# simplest of programs where all program parameters are positional, there is no
# help text, etc.

# Description of argument(s):
# parm1            Bla, bla, bla (e.g. "example data").


function get_parms {

  # Get program parms.

  parm1="${1}" ; shift

  return 0

}


function exit_function {

  return

}

function validate_parms {

  # Validate program parameters.

  # Your validation code here.

  if [ -z "${parm1}" ] ; then
    echo "**ERROR** You must provide..." >&2
    return 1
  fi

  trap "exit_function $signal \$?" EXIT

  return 0

}


function mainf {

  get_parms "$@" || return 1

  validate_parms || return 1

  # Your code here...

  return 0

}


# Main

  mainf "${@}"
  rc="${?}"
exit "${rc}"