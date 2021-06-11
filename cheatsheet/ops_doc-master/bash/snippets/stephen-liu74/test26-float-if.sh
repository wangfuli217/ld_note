#!/bin/sh
### 浮点数验证 ###
# 浮点数数的重要特征就是只是包含数字0到9、负号(-)和点(.)，其中负号只能出现在最前面，点(.)只能出现一次。

#1. 之前的一个条目已经介绍了awk中match函数的功能，如果匹配返回匹配的位置值，否则返回0。
#2. 对于Shell中的函数而言，返回0表示成功，其他值表示失败，该语义等同于Linux中的进程退出值。调用者可以通过内置变量$?获取返回值，或者作为条件表达式的一部分直接判断。
validint() {
    ret=`echo $1 | awk '{start = match($1,/^-?[0-9]+$/); if (start == 0) print "1"; else print "0"}'`
    return $ret
}

validfloat() {
    fvalue="$1"
    #3. 判断当前参数中是否包含小数点儿。如果包含则需要将其拆分为整数部分和小数部分，分别进行判断。
    if [ ! -z  $(echo $fvalue | sed 's/[^.]//g') ]; then
        decimalpart=`echo $fvalue | cut -d. -f1`
        fractionalpart=`echo $fvalue | cut -d. -f2`
        #4. 如果整数部分不为空，但是不是合法的整型，则视为非法格式。
        if [ ! -z $decimalpart ]; then
            if ! validint "$decimalpart" ; then
                echo "decimalpart is not valid integer."
                return 1
            fi
        fi
        #5. 判断小数部分的第一个字符是否为-，如果是则非法。
        if [ "${fractionalpart:0:1}" = "-" ]; then
            echo "Invalid floating-point number: '-' not allowed after decimal point." >&2
            return 1
        fi
        #6. 如果小数部分不为空，同时也不是合法的整型，则视为非法格式。
        if [ "$fractionalpart" != "" ]; then
            if ! validint "$fractionalpart" ; then
                echo "fractionalpart is not valid integer."
                return 1
            fi
        fi
        #7. 如果整数部分仅为-，或者为空，如果此时小数部分也是空，则为非法格式。
        if [ "$decimalpart" = "-" -o -z "$decimalpart" ]; then
            if [ -z $fractionalpart ]; then
                echo "Invalid floating-point format." >&2
                return 1
            fi
        fi
    else
        #8. 如果当前参数仅为-，则视为非法格式。
        if [ "$fvalue" = "-" ]; then
            echo "Invalid floating-point format." >&2
            return 1
        fi
        #9. 由于参数中没有小数点，如果该值不是合法的整数，则为非法格式。
        if ! validint "$fvalue" ; then
            echo "Invalid floating-point format." >&2
            return 1
        fi
    fi
    return 0
}   
if validfloat $1 ; then
    echo "$1 is a valid floating-point value."
fi
exit 0