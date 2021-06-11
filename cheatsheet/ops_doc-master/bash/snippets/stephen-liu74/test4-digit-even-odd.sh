#!/bin/sh
### 判断整数变量的奇偶性 ### 
#1. 这里的重点主要是sed命令中正则表达式的写法，它将原有的数字拆分为两个模式(用圆括号拆分)，
#   一个前面的所有高位数字，另一个是最后一位低位数字，之后再用替换符的方式(\2)，
#   将原有数字替换为只有最后一位的数字，最后将结果返回为last_digit变量。
last_digit=$( echo $1 | sed 's/\(.*\)\(.\)$/\2/' )
#2. 如果last_digit的值为0,2,4,6,8，就表示其为偶数，否则为奇数。
case $last_digit in
0|2|4|6|8)
  echo "This is an even number." ;;
*)
  echo "This is not an even number." ;;
esac

# /> ./test4-digit-even-odd.sh 34
# This is an even number.
# /> ./test4-digit-even-odd.sh 345
# This is not an even number.
      