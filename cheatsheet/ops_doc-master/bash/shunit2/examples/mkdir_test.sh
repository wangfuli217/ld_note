#!/bin/sh
# vim:et:ft=sh:sts=2:sw=2
#
# Copyright 2008 Kate Ward. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: kate.ward@forestent.com (Kate Ward)
#
# Example unit test for the mkdir command.
#
# There are times when an existing shell script needs to be tested. In this
# example, we will test several aspects of the the mkdir command, but the
# techniques could be used for any existing shell script.

# test step 1.testMissingDirectoryCreation 2. testExistingDirectoryCreationFails 3. testRecursiveDirectoryCreation
# stdoutF标准输出文件   assertFalse|assertTrue "[ -s '${th_stdout_}' ]"  -- 格式
# stderrF错误输出文件   assertFalse|assertTrue "[ -s '${th_stderr_}' ]"  -- 格式
# rtrn命令执行返回状态  assertFalse|assertTrue ${rtrn}                   -- 格式

testMissingDirectoryCreation() {
  ${mkdirCmd} "${testDir}" >${stdoutF} 2>${stderrF}
  rtrn=$?
  th_assertTrueWithNoOutput ${rtrn} "${stdoutF}" "${stderrF}"

  assertTrue 'directory missing' "[ -d '${testDir}' ]"
}

testExistingDirectoryCreationFails() {
  # Create a directory to test against.
  ${mkdirCmd} "${testDir}"

  # Test for expected failure while trying to create directory that exists.
  ${mkdirCmd} "${testDir}" >${stdoutF} 2>${stderrF}
  rtrn=$?
  assertFalse 'expecting return code of 1 (false)' ${rtrn}
  assertNull 'unexpected output to stdout' "$(cat ${stdoutF})"
  assertNotNull 'expected error message to stderr' "$(cat ${stderrF})"

  assertTrue 'directory missing' "[ -d '${testDir}' ]"
}

testRecursiveDirectoryCreation() {
  testDir2="${testDir}/test2"

  ${mkdirCmd} -p "${testDir2}" >${stdoutF} 2>${stderrF}
  rtrn=$?
  th_assertTrueWithNoOutput ${rtrn} "${stdoutF}" "${stderrF}"

  assertTrue 'first directory missing' "[ -d '${testDir}' ]"
  assertTrue 'second directory missing' "[ -d '${testDir2}' ]"
}

# 内部函数，删除变量
th_assertTrueWithNoOutput() {
  th_return_=$1
  th_stdout_=$2
  th_stderr_=$3

  assertFalse 'unexpected output to STDOUT' "[ -s '${th_stdout_}' ]"
  assertFalse 'unexpected output to STDERR' "[ -s '${th_stderr_}' ]"

  unset th_return_ th_stdout_ th_stderr_
}

# 测试开始
oneTimeSetUp() {
  outputDir="${SHUNIT_TMPDIR}/output"
  mkdir "${outputDir}"
  stdoutF="${outputDir}/stdout"
  stderrF="${outputDir}/stderr"

  mkdirCmd='mkdir'  # save command name in variable to make future changes easy
  testDir="${SHUNIT_TMPDIR}/some_test_dir"
}
# 测试结束
tearDown() {
  rm -fr "${testDir}"
}

# Load and run shUnit2.
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ../shunit2
