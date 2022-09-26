#! /bin/sh
# $Id$
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
# Author: kate.ward@forestent.com (Kate Ward)
#
# log4sh unit test for output of messages based on priority.

# load test helpers
. ./log4sh_test_helpers

APP_NAME='stdout'
TESTDATA="${TH_TESTDATA_DIR}/priority_matrix.dat"

#------------------------------------------------------------------------------
# suite tests
#

testPriorityMatrix()
{
  PRIORITY_NAMES='TRACE DEBUG INFO WARN ERROR FATAL'
  PRIORITY_POS='1 2 3 4 5 6'

  while read priority outputs; do
    # ignore comment lines or blank lines
    echo "${priority}" |egrep -v '^(#|$)' >/dev/null || continue

    ${DEBUG} "setting appender priority to '${priority}' priority"
    appender_setLevel ${APP_NAME} ${priority}
    appender_activateOptions ${APP_NAME}

    # the number of outputs must match the number of priority names and
    # positions for this to work
    for pos in ${PRIORITY_POS}; do
      testPriority=`echo ${PRIORITY_NAMES} |cut -d' ' -f${pos}`
      shouldOutput=`echo ${outputs} |cut -d' ' -f${pos}`

      ${DEBUG} "generating '${testPriority}' message"
      result=`log ${testPriority} 'dummy'`
      ${DEBUG} "result=${result}"

      if [ ${shouldOutput} -eq 1 ]; then
        assertTrue \
          "'${priority}' priority appender did not emit a '${testPriority}' message" \
          "[ -n \"${result}\" ]"
      else
        assertFalse \
          "'${priority}' priority appender emitted a '${testPriority}' message" \
          "[ -n \"${result}\" ]"
      fi
    done
  done <"${TESTDATA}"
}

testInvalidPriority()
{
  # validate that requesting an invalid logging level (i.e. priority) will fail
  log INVALID 'some message'
  assertTrue \
      "logging with an invalid logging level did not properly fail" \
      "[ $? -eq ${LOG4SH_ERROR} ]"
}

#------------------------------------------------------------------------------
# suite functions
#

oneTimeSetUp()
{
  LOG4SH_CONFIGURATION='none'
  th_oneTimeSetUp
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${TH_SHUNIT}
