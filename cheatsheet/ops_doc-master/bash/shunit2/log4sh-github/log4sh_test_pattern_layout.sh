#! /bin/sh
# $Id$
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
# Author: kate.ward@forestent.com (Kate Ward)
#
# log4sh unit test for pattern layouts in appender output.

# load test helpers
. ./log4sh_test_helpers

APP_NAME='stdout'

#------------------------------------------------------------------------------
# custom asserts
#

assertPattern()
{
  msg=''
  if [ $# -eq 3 ]; then
    msg=$1
    shift
  fi
  pattern=$1
  expected=$2

  appender_setPattern ${APP_NAME} "${pattern}"
  appender_activateOptions ${APP_NAME}
  actual=`logger_info 'dummy'`
  ${DEBUG} "pattern='${pattern}' expected='${expected}' actual='${actual}'"
  msg=`eval "echo \"${msg}\""`
  assertEquals "${msg}" "${expected}" "${actual}"
}

#------------------------------------------------------------------------------
# suite tests
#

testCategoryPattern()
{
  pattern='%c'
  expected='shell'
  msg="category '%c' pattern failed: '\${expected}' != '\${actual}'"
  assertPattern "${msg}" "${pattern}" "${expected}"
}

commonDatePatternAssert()
{
  pattern=$1
  regex=$2

  appender_setPattern ${APP_NAME} "${pattern}"
  appender_activateOptions ${APP_NAME}
  result=`logger_info 'dummy'`
  matched=`echo ${result} |sed "s/${regex}//"`
  ${DEBUG} "pattern='${pattern}' result='${result}' regex='${regex}' matched='${matched}'"

  assertNotNull \
    "date pattern '${pattern}' failed: empty result '${result}'" \
    "${result}"
  assertNull \
    "date pattern '${pattern}' failed: result '${result}' did not match the regex '${regex}'" \
    "${matched}"
}

testDatePattern()
{
  # without conversion specifier (Unix date format '+%Y-%m-%d %H:%M:%S')
  pattern='%d'
  regex='^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}'
  commonDatePatternAssert "${pattern}" "${regex}"

  # ISODATE conversion specifier
  pattern='%d{ISODATE}'
  regex='^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}'
  commonDatePatternAssert "${pattern}" "${regex}"

  # custom conversion specifier
  pattern='%d{HH:mm:ss,SSS}'
  regex='^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}'
  commonDatePatternAssert "${pattern}" "${regex}"
}

testFileNamePattern()
{
  pattern='%F'
  expected="${TH_ARGV0}"
  msg="file name '%F' pattern failed: '\${expected}' != '\${actual}'"
  assertPattern "${msg}" "${pattern}" "${expected}"
}

testLineNumberPattern()
{
  pattern='%L'
  expected=''
  msg="line number '%L' pattern failed: '\${expected}' != '\${actual}'"
  assertPattern "${msg}" "${pattern}" "${expected}"
}

testLineSeparatorPattern()
{
  pattern='%n'
  expected=''
  msg="line separator '%n' pattern failed: '\${expected}' != '\${actual}'"
  assertPattern "${msg}" "${pattern}" "${expected}"
}

testMessagePattern()
{
  pattern='%m'
  expected='dummy'
  msg="message '%m' pattern failed: '\${expected}' != '\${actual}'"
  assertPattern "${msg}" "${pattern}" "${expected}"
}

# note: this function using the base log() function rather than the logger_*()
# functions as the functionality is effectively the same
testPriorityPattern()
{
  currPriority=`appender_getLevel ${APP_NAME}`

  pattern='%p'
  appender_setPattern ${APP_NAME} "${pattern}"
  for priority in TRACE DEBUG INFO WARN ERROR FATAL; do
    appender_setLevel ${APP_NAME} ${priority}
    appender_activateOptions ${APP_NAME}
    result=`log ${priority} 'dummy'`
    ${DEBUG} "pattern='${pattern}' priority='${priority}' result='${result}'"
    assertEquals \
      "priority pattern '${pattern}' failed: the requested priority of '${priority}' does not match the returned priority of '${result}'" \
      "${priority}" "${result}"
  done

  appender_setLevel ${APP_NAME} ${currPriority}
  appender_activateOptions ${APP_NAME}
}

testRunningTimePattern()
{
  pattern='%r'
  regex='^[0-9]*(\.[0-9]*){0,1}$'

  appender_setPattern ${APP_NAME} "${pattern}"
  appender_activateOptions ${APP_NAME}
  result=`logger_info 'dummy'`
  matched=`echo "${result}" |egrep "${regex}"`
  ${DEBUG} "pattern='${pattern}' result='${result}' regex='${regex}' matched='${matched}'"

  assertNotNull \
    "running time pattern '${pattern}' failed: empty result '${result}'" \
    "${result}"
  assertNotNull \
    "running time pattern '${pattern}' failed: result '${result}' did not match the regex '${regex}'" \
    "${matched}"
}

testThreadNamePattern()
{
  pattern='%t'
  expected=${__LOG4SH_THREAD_DEFAULT}
  msg="thread name '%t' pattern failed: '\${expected}' != '\${actual}'"
  assertPattern "${msg}" "${pattern}" "${expected}"
}

# NDC (Nested Diagnostic Context)
testNDCPattern()
{
  pattern='%x'
  expected=''
  msg="NDC '%x' pattern failed: '\${expected}' != '\${actual}'"
  assertPattern "${msg}" "${pattern}" "${expected}"
}

# MDC (Mapped Diagnostic Context)
testMDCPattern()
{
  msg="MDC '\${pattern}' pattern failed: '\${expected}' != '\${actual}'"

  pattern='%X{USER}'
  expected=${USER}
  assertPattern "${msg}" "${pattern}" "${expected}"

  # the %X pattern should not parse unless it has an environment variable name
  # enclosed in {} chars following the 'X'
  pattern='%X'
  expected=${pattern}
  assertPattern "${msg}" "${pattern}" "${expected}"
}

testPercentPattern()
{
  pattern='%%'
  expected='%'
  msg="percent '\${pattern}' pattern failed: '\${expected}' != '\${actual}'"
  assertPattern "${msg}" "${pattern}" "${expected}"
}

testDefaultPattern()
{
  # the pattern should be '%d %p - %m%n'
  pattern=${__LOG4SH_PATTERN_DEFAULT}
  regex='^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} INFO - dummy'
  result=`logger_info 'dummy'`
  matched=`echo ${result} |sed "s/${regex}//"`
  ${DEBUG} "pattern='${pattern}' result='${result}' regex='${regex}' matched='${matched}'"

  assertNotNull \
    "default pattern '${pattern}' failed: empty result '${result}'" \
    "${result}"
  assertNull \
    "default pattern '${pattern}' failed: result '${result}' did not match the regex '${regex}'" \
    "${matched}"
}

#------------------------------------------------------------------------------
# suite functions
#

oneTimeSetUp()
{
  LOG4SH_CONFIGURATION='none'
  th_oneTimeSetUp

  logger_setLevel INFO
  appender_setLayout ${APP_NAME} PatternLayout
}

# need working egrep. the one for Solaris is in /usr/xpg4/bin, so we will add
# that to the path
[ -d '/usr/xpg4/bin' ] && PATH="/usr/xpg4/bin:${PATH}"

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${TH_SHUNIT}
