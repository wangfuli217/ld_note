#!/bin/sh
### 整数验证 ###
# 整数的重要特征就是只是包含数字0到9和负号(-)。

#1. 判断变量number的第一个字符是否为负号(-)，如果只是则删除该负号，并将删除后的结果赋值给left_number变量。
#2. "${number#-}"的具体含义，可以参考该系列博客中"Linux Shell常用技巧(十一)"，搜索关键字"变量模式匹配运算符"即可。
number=$1
if [ "${number:0:1}" = "-" ]; then
    left_number="${number#-}"
else
    left_number=$number
fi
#3. 将left_number变量中所有的数字都替换掉，因此如果返回的字符串变量为空，则表示left_number所包含的字符均为数字。
nodigits=`echo $left_number | sed 's/[[:digit:]]//g'`
if [ "$nodigits" != "" ]; then
    echo "Invalid number format!"
else
    echo "You are valid number."
fi

# /> ./test16-number-if.sh -123
# You are valid number.
# /> ./test16-number-if.sh 123e
# Invalid number format!