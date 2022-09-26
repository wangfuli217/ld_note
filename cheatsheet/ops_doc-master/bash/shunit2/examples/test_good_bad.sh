#!/bin/bash
# test_good_bad.sh
# 可以参考标准形式
  
good() { echo "Wohoo!!"; }
bad() { echo "Booo :-("; return 123; }

#  shunit2要求标准形式 
test_functions() { # 测试函数以test名字开头
  # Naively hope that all functions return true.
  while read desc fn; do # 数据驱动
    output=$(${fn} 2>&1); rtrn=$? #1. 子进程执行， 2. 输出具有调试功能 2.1 错误输出重定向到标准输出 3. 关注返回值
    assertTrue "${desc}: unexpected error (${rtrn}); ${output}" ${rtrn}
  done <<EOF
good() good
bad()  bad
EOF
}

. ../shunit2
