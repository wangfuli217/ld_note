#!/bin/bash
# test_date_cmd.sh
# 参数化输入形式

# Echo any provided arguments.
[ $# -gt 0 ] && echo "ARGC: $# 1:$1 2:$2 3:$3"

#  shunit2要求标准形式 
test_date_cmd() {   # 测试脚本以test开头
  ( date '+%a' >/dev/null 2>&1 ) #1. 子进程执行 2. 输出具有调试功能 2.1 错误输出重定向到标准输出  3. 关注返回值
  local rtrn=$?
  assertTrue "unexpected date error; ${rtrn}" ${rtrn}
}

# Eat all command-line arguments before calling shunit2.
shift $#
. ../shunit2