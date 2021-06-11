#!/bin/bash
#===============================================================================
#          FILE: conv.sh#
#         USAGE: ./conv.sh #
#   DESCRIPTION: 一个支持把整个目录递归转换gbk为UTF-8的脚本；
#
#       OPTIONS: ---
#  REQUIREMENTS: Linux内核的操作系统；
#          BUGS: 目前不支持传入参数中含有空格；
#         NOTES: 输入支持三种格式，随你的心意而定制；
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#       CREATED: 2013年03月06日 22时52分31秒 HKT
#     COPYRIGHT: Copyright (c) 2013, linkscue
#      REVISION: 0.1#  ORGANIZATION: ---
#===============================================================================
set -o nounset                              # Treat unset variables as an error
#-------------------------------------------------------------------------------
#  检查错误
#-------------------------------------------------------------------------------
if [[ $# == 0 ]] ; then
    echo ""
    echo "程序版本：0.1"
    echo "实现功能：批量转换gbk字符编码至UTF-8；"
    echo "使用方法：$(basename $0) <后缀名> <文件1> <文件2> <目录1> <目录2> .."
    echo "操作提示："
    echo "    1. 后缀名不需要'.'这个符号；"
    echo "    2. 当输入参数中无后缀名，将从传入文件中取后缀并提示是否进一步操作；"
    echo ""
    exit 1
fi
#-------------------------------------------------------------------------------
#  传入参数情形1
#  传入的是第一个参数是后缀名；
#  判断的依据是第一个参数传来的不是一个文件；
#-------------------------------------------------------------------------------
if [[ ! -f $1 ]]
then
    suffix=$1
fi
target=${@:2:$#}
for n in ${target[@]}
do
    # 判断是否是一个文件；
    if [[ -f $n ]] ; then
        iconv -f gbk -t UTF-8 $n -o $n 2> /dev/null
    fi
    #判断是否是一个目录
    if [[ -d $n ]] ; then
        find "$n" -name "*.$suffix" | while read line ;
    do
        iconv -f gbk -t UTF-8 "$line" -o "$line"  2> /dev/null
    done
fi
done
#-------------------------------------------------------------------------------
#  传入参数情形2
#  传入的第一个参数是一个文件；
#  若传入参数中无目录时，将直接把文件转码；
#  若传入参数中有目录时，将询问是否以第一个参数后缀作为搜索目录条件；
#-------------------------------------------------------------------------------
if [[ -f $1 ]] ; then
    # 判断传入参数中是否有目录；
    for n in $@ ; do
        if [[ -d "$n" ]]; then
            HAS_DIR=true
        fi
    done
    # 当传入参数中没有目录时，直接把传入文件转码；
    if [[ $HAS_DIR != "true" ]]; then
        for n in $@ ; do
            iconv -f gbk -t UTF-8 "$n" -o "$n" 2> /dev/null
        done
    else
        # 当传入参数中含有目录时，将使用第一个传入参数的后缀；
        suffix=${1##*.}
        if [[ $suffix != "" ]]; then
            read -p ">> 发现第一个传入参数的后缀名为$suffix，是否使用它作为搜索目录的条件?[y/N]"
            if [[ $REPLY == "y" ]]; then
                for n in $@ ; do
                    if [[ -f "$n" ]]; then
                        iconv -f gbk -t UTF-8 "$n" -o "$n" 2> /dev/null
                    fi
                    if [[ -d "$n" ]]; then
                        find "$n" -name "*.$suffix" | while read line ; do
                        iconv -f gbk -t UTF-8 "$line" -o "$line"  2> /dev/null
                    done
                fi
            done
        fi
    fi
fi
    fi
    #-------------------------------------------------------------------------------
    #  传入参数情形3
    #  传入第一个参数是目录；
    #  这时考虑到用户可能转换整个目录，却忘记输转换文件后缀名；
    #  此时将会提示用户输入后缀名；
    #  可以输入多个后缀名，比如Android的程序源代码含有xml与java后缀；
    #-------------------------------------------------------------------------------
    if [[ -d $1 ]]; then
        argvs=$@
        # 提示用户输入文件的后缀名；
        read -p ">> 发现尚未输入要转换的文件后缀名，请输入需转码的后缀[可输入多个]：" suffix_3
        for n in ${argvs[@]};do
            # 处理的是一般文件;
            if [[ -f "$n" ]]; then
                iconv -f gbk -t UTF-8 "$n" -o "$n" 2> /dev/null
            fi
            # 处理的是一个目录；
            if [[ -d "$n" ]]; then
                for suffix in ${suffix_3[@]} ; do
                    find "$n" -name "*.$suffix" | while read line ; do
                    iconv -f gbk -t UTF-8 "$line" -o "$line" 2> /dev/null
                done
            done
        fi
    done
fi

# 运行方法：将multiconv.sh放到需要批量修改编码的目录下，然后在这个目录下打开终端运行./multiconv.sh php * 即可将该目录下的所有文件编码转变为utf8格式。
# ./multiconv.sh php * 
# 如果是gb2312格式的就修改multiconv.sh中的gbk为gb2312。
