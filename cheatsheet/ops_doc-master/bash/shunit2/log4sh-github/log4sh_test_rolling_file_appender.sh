#! /bin/sh
# $Id$
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
# Author: kate.ward@forestent.com (Kate Ward)
#
# log4sh unit test for standard ASCII character set support.

# load test helpers
. ./log4sh_test_helpers

MY_LOG4SH="${TH_TESTDATA_DIR}/rolling_file_appender.log4sh"

APP_NAME='R'
APP_MAX_FILE_SIZE='10KiB'
APP_MAX_FILE_SIZE_REAL=10240
APP_MAX_BACKUP_INDEX='1'

#------------------------------------------------------------------------------
# custom asserts
#

assertFileExists()
{
  ${DEBUG} "assertFileExists($@)"
  if [ $# -eq 2 ]; then
    assertTrue "$1" "[ -f '$2' ]"
  else
    assertTrue "[ -f '$1' ]"
  fi
}

assertFileNotExists()
{
  ${DEBUG} "assertFileNotExists($@)"
  if [ $# -eq 2 ]; then
    assertTrue "$1" "[ ! -f '$2' ]"
  else
    assertTrue "[ ! -f '$1' ]"
  fi
}

#------------------------------------------------------------------------------
# suite tests
#

loadLog4sh_runtime()
{
  # add a rolling file appender at the INFO level
  logger_addAppender ${APP_NAME}
  appender_setType ${APP_NAME} RollingFileAppender
  appender_file_setFile ${APP_NAME} "${appFile}"
  appender_file_setMaxFileSize ${APP_NAME} ${APP_MAX_FILE_SIZE}
  appender_file_setMaxBackupIndex ${APP_NAME} ${APP_MAX_BACKUP_INDEX}

  # activate the appender
  appender_activateOptions ${APP_NAME}
}

loadLog4sh_config()
{
  # load log4sh configuration
  log4sh_doConfigure "${MY_LOG4SH}"
}

createSizedFile()
{
  file=$1
  size=$2

  # this could be slow...
  ${DEBUG} "creating ${size} byte file..."
  if [ ${size} -gt 0 ]; then
    result=`dd if=/dev/zero of="${file}" bs=1 count=${size} 2>&1`
    if [ $? -ne 0 ]; then
      echo "ERROR: had problems creating the '${file}' of ${size} bytes"
      return 1
    fi
  else
    touch "${file}"
  fi
}

testEmptyFile_runtime()
{ testEmptyFile runtime; }
testEmptyFile_config()
{ testEmptyFile config; }
testEmptyFile()
{
  ${DEBUG} 'testing empty file'
  useLog4sh=$1

  # configure log4sh
  loadLog4sh_${useLog4sh}

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create file(s)
  createSizedFile "${appFile}" 0 \
      || return 1

  # log a message
  logger_error 'dummy message'

  # as we started with a empty file, writing a single logging message should
  # not have caused an overrun, nor a rotation
  assertFileNotExists \
      "the file rotated, but it shouldn't have" \
      "${appFile}.0"
}

testOneByteUnderSize_runtime()
{ testOneByteUnderSize runtime; }
testOneByteUnderSize_config()
{ testOneByteUnderSize config; }
testOneByteUnderSize()
{
  ${DEBUG} 'testing one byte under sized file'
  useLog4sh=$1

  # configure log4sh
  loadLog4sh_${useLog4sh}

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create file(s)
  createSizedFile "${appFile}" `expr ${APP_MAX_FILE_SIZE_REAL} - 1` \
      || return 1

  # log a message
  logger_error 'dummy message'

  # this time, the file was just under the limit for doing a rotation, so
  # again, no rotation should have occurred
  assertFileNotExists \
      "the file rotated, but it shouldn't have" \
      "${appFile}.0"
}

testExactlyRightSize_runtime()
{ testExactlyRightSize runtime; }
testExactlyRightSize_config()
{ testExactlyRightSize config; }
testExactlyRightSize()
{
  ${DEBUG} 'testing exactly right sized file'
  useLog4sh=$1

  # configure log4sh
  loadLog4sh_${useLog4sh}

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create file(s)
  createSizedFile "${appFile}" ${APP_MAX_FILE_SIZE_REAL} \
      || return 1

  # log a message
  logger_error 'dummy message'

  # this time, the file was exactly the right size for doing a rotation. a
  # rotation should have occurred
  assertFileExists \
      "the file didn't rotate, but it should have" \
      "${appFile}.0"
}

testOneByteOverSize_runtime()
{ testOneByteOverSize runtime; }
testOneByteOverSize_config()
{ testOneByteOverSize config; }
testOneByteOverSize()
{
  ${DEBUG} 'testing one byte oversize file'
  useLog4sh=$1

  # configure log4sh
  loadLog4sh_${useLog4sh}

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create file(s)
  createSizedFile "${appFile}" `expr ${APP_MAX_FILE_SIZE_REAL} + 1` \
      || return 1

  # log a message
  logger_error 'dummy message'

  # this time, the file was just above the threshold for rotation. a rotation
  # should have occurred
  assertFileExists \
      "the file didn't rotate, but it should have" \
      "${appFile}.0"
}

testOrderOfMagnitudeLarger_runtime()
{ testOrderOfMagnitudeLarger runtime; }
testOrderOfMagnitudeLarger_config()
{ testOrderOfMagnitudeLarger config; }
testOrderOfMagnitudeLarger()
{
  ${DEBUG} 'testing one byte oversize file'
  useLog4sh=$1

  # configure log4sh
  loadLog4sh_${useLog4sh}

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create file(s)
  createSizedFile "${appFile}" `expr ${APP_MAX_FILE_SIZE_REAL} \* 10` \
      || return 1

  # log a message
  logger_error 'dummy message'

  # this time, the file was way above the threshold for rotation. a rotation
  # should have occurred
  assertFileExists \
      "the file didn't rotate, but it should have" \
      "${appFile}.0"
}

testMaxBackupIndexOf2()
{
  ${DEBUG} 'testing a maximum backup index of 2'

  # configure log4sh
  logger_addAppender ${APP_NAME}
  appender_setType ${APP_NAME} RollingFileAppender
  appender_file_setFile ${APP_NAME} "${appFile}"
  appender_file_setMaxFileSize ${APP_NAME} ${APP_MAX_FILE_SIZE}
  appender_file_setMaxBackupIndex ${APP_NAME} 2
  appender_activateOptions ${APP_NAME}

  #
  # test with no existing .1 backup
  #

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create files
  touch "${appFile}.0"
  createSizedFile "${appFile}" ${APP_MAX_FILE_SIZE_REAL} \
      || return 1

  # log a message
  logger_error 'dummy message'

  # with a backup index of 2, there should be only two backups (.0 and .1)
  assertFileNotExists \
      'a backup file with a .2 extension should not exist' \
      "${appFile}.2"
  assertFileExists \
      'a backup file with a .1 extension should exist' \
      "${appFile}.1"
  assertFileExists \
      'a backup file with a .0 extension should exist' \
      "${appFile}.0"
  assertFileExists \
      'the log file should exist' \
      "${appFile}"

  # the .0 backup should have the same size as the file it was rotated from
  if [ -f "${appFile}.0" ]; then
    appFile0Size=`wc -c "${appFile}.0" |awk '{print $1}'`
  else
    appFile0Size=0
  fi
  assertTrue \
      "the backup file with a .0 extension wasn't properly rotated" \
      "[ ${APP_MAX_FILE_SIZE_REAL} -eq ${appFile0Size} ]"

  #
  # test with existing .1 backup
  #

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create files
  touch "${appFile}.1"
  touch "${appFile}.0"
  createSizedFile "${appFile}" ${APP_MAX_FILE_SIZE_REAL} \
      || return 1

  # log a message
  logger_error 'dummy message'

  # with a backup index of 2, there should be only two backups (.0 and .1)
  assertFileNotExists \
      'a backup file with a .2 extension should not have been created' \
      "${appFile}.2"
  assertFileExists \
      'a backup file with a .1 extension should exist' \
      "${appFile}.1"
  assertFileExists \
      'a backup file with a .0 extension should exist' \
      "${appFile}.0"
  assertFileExists \
      'the log file should exist' \
      "${appFile}"

  # the .0 backup should have the same size as the file it was rotated from
  if [ -f "${appFile}.0" ]; then
    appFile0Size=`wc -c "${appFile}.0" |awk '{print $1}'`
  else
    appFile0Size=0
  fi
  assertTrue \
      "the backup file with a .0 extension wasn't properly rotated" \
      "[ ${APP_MAX_FILE_SIZE_REAL} -eq ${appFile0Size} ]"
}

testMaxBackupIndexOf1()
{
  ${DEBUG} 'testing a maximum backup index of 1'

  # configure log4sh
  logger_addAppender ${APP_NAME}
  appender_setType ${APP_NAME} RollingFileAppender
  appender_file_setFile ${APP_NAME} "${appFile}"
  appender_file_setMaxFileSize ${APP_NAME} ${APP_MAX_FILE_SIZE}
  appender_file_setMaxBackupIndex ${APP_NAME} 1
  appender_activateOptions ${APP_NAME}

  #
  # test with no existing .1 backup
  #

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create files
  createSizedFile "${appFile}" ${APP_MAX_FILE_SIZE_REAL} \
      || return 1

  # log a message
  logger_error 'dummy message'

  # with a backup index of 1, there should be only one backup (.0)
  assertFileNotExists \
      'a backup file with a .1 extension should not exist' \
      "${appFile}.1"
  assertFileExists \
      'a backup file with a .0 extension should exist' \
      "${appFile}.0"
  assertFileExists \
      'the log file should exist' \
      "${appFile}"

  # the .0 backup should have the same size as the file it was rotated from
  if [ -f "${appFile}.0" ]; then
    appFile0Size=`wc -c "${appFile}.0" |awk '{print $1}'`
  else
    appFile0Size=0
  fi
  assertTrue \
      "the backup file with a .0 extension wasn't properly rotated" \
      "[ ${APP_MAX_FILE_SIZE_REAL} -eq ${appFile0Size} ]"

  #
  # test with existing .0 backup
  #

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create files
  touch "${appFile}.0"
  createSizedFile "${appFile}" ${APP_MAX_FILE_SIZE_REAL} \
      || return 1

  # log a message
  logger_error 'dummy message'

  # with a backup index of 1, there should be only one backup (.0)
  assertFileNotExists \
      'a backup file with a .1 extension should not exist' \
      "${appFile}.1"
  assertFileExists \
      'a backup file with a .0 extension should exist' \
      "${appFile}.0"
  assertFileExists \
      'the log file should exist' \
      "${appFile}"

  # the .0 backup should have the same size as the file it was rotated from
  if [ -f "${appFile}.0" ]; then
    appFile0Size=`wc -c "${appFile}.0" |awk '{print $1}'`
  else
    appFile0Size=0
  fi
  assertTrue \
      "the backup file with a .0 extension wasn't properly rotated" \
      "[ ${APP_MAX_FILE_SIZE_REAL} -eq ${appFile0Size} ]"
}

testMaxBackupIndexOf0()
{
  ${DEBUG} 'testing a maximum backup index of 0'

  # configure log4sh
  logger_addAppender ${APP_NAME}
  appender_setType ${APP_NAME} RollingFileAppender
  appender_file_setFile ${APP_NAME} "${appFile}"
  appender_file_setMaxFileSize ${APP_NAME} ${APP_MAX_FILE_SIZE}
  appender_file_setMaxBackupIndex ${APP_NAME} 0
  appender_activateOptions ${APP_NAME}

  #
  # test with no existing .0 backup
  #

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create files
  createSizedFile "${appFile}" ${APP_MAX_FILE_SIZE_REAL} \
      || return 1

  # log a message
  logger_error 'dummy message'

  # with a backup index of 0, there should no backups
  assertFileNotExists \
      'a backup file with a .0 extension should not exist' \
      "${appFile}.0"
  assertFileExists \
      'the log file should exist' \
      "${appFile}"

  #
  # test with existing .0 backup
  #

  # removing any previous files
  rm -f "${appFile}" "${appFile}".*

  # create files
  createSizedFile "${appFile}" ${APP_MAX_FILE_SIZE_REAL} \
      || return 1

  # log a message
  logger_error 'dummy message'

  # with a backup index of 0, there should be no backups
  assertFileNotExists \
      'a backup file with a .0 extension should not have been created' \
      "${appFile}.0"
  assertFileExists \
      'the log file should exist' \
      "${appFile}"
}

testMaxFileSizeGetterSetter()
{
  # setup
  logger_addAppender ${APP_NAME}
  appender_setType ${APP_NAME} RollingFileAppender
  appender_file_setFile ${APP_NAME} "${appFile}"
  appender_activateOptions ${APP_NAME}

  ### getter

  # check that the default size equals the default of log4sh
  size=`appender_file_getMaxFileSize ${APP_NAME}`
  assertEquals \
      "the returned MaxFileSize (${size}) did not equal the log4sh default" \
      "${size}" ${__LOG4SH_TYPE_ROLLING_FILE_MAX_FILE_SIZE}

  ### setter

  # test passing valid units; there should be no warnings or errors
  for unit in B KB KiB MB MiB GB GiB TB TiB; do
    appender_file_setMaxFileSize ${APP_NAME} 1${unit}
    assertTrue \
        "setter failed with the '${unit}' unit" \
        "[ $? -eq ${__LOG4SH_TRUE} ]"
  done

  # test passing an empty unit
  echo '- expecting one warning'
  appender_file_setMaxFileSize ${APP_NAME} 1
  assertTrue \
      "setter failed with an empty unit" \
      "[ $? -eq ${__LOG4SH_TRUE} ]"

  # test passing an invalid unit
  echo '- expecting one error'
  appender_file_setMaxFileSize ${APP_NAME} 1foo
  assertTrue \
      "setter succeeded with an invalid unit" \
      "[ $? -eq ${__LOG4SH_ERROR} ]"
}

#------------------------------------------------------------------------------
# suite functions
#

oneTimeSetUp()
{
  LOG4SH_CONFIGURATION='none'
  th_oneTimeSetUp

  appFile="${TH_TMPDIR}/rfa.log"
  resultFile="${TH_TMPDIR}/result.dat"
}

setUp()
{
  # reset log4sh
  log4sh_resetConfiguration
}

tearDown()
{
  rm -f "${appFile}" "${appFile}".*
}

suite()
{
  suite_addTest testEmptyFile_runtime
  suite_addTest testOneByteUnderSize_runtime
  suite_addTest testExactlyRightSize_runtime
  suite_addTest testOneByteOverSize_runtime
  suite_addTest testOrderOfMagnitudeLarger_runtime

  suite_addTest testEmptyFile_config
  suite_addTest testOneByteUnderSize_config
  suite_addTest testExactlyRightSize_config
  suite_addTest testOneByteOverSize_config
  suite_addTest testOrderOfMagnitudeLarger_config

  suite_addTest testMaxBackupIndexOf2
  suite_addTest testMaxBackupIndexOf1
  suite_addTest testMaxBackupIndexOf0
}

# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ${TH_SHUNIT}
