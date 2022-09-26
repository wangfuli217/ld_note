#!/bin/sh
#
# This is the proverbial 'Hello, world!' script to demonstrate the most basic
# functionality of shFlags.
#
# This script demonstrates accepts a single command-line flag of '-n' (or
# '--name'). If a name is given, it is output, otherwise the default of 'world'
# is output.

# Source shflags.
. ../shflags

# Define a 'name' command-line string flag.
DEFINE_string 'name'           'world'        'name to say hello to'    'n'
#         'string' flag     default value      described the variable   short flag

# How to handle the short command-line option -n.
# How to handle the long command-line option --name Kate (not supported on all systems).
# How to describe the flag if -h (or --help) is given as an option.
# To accept and validate any input as a string value.
# To store any input (or the default value) in the FLAGS_name variable.

# 变量名: name，使用 --name 可以指定变量值FLAGS_name.
# 变量默认值: world，即没有指定时的默认值
# 变量描述: name to say hello to
# short变量名: n，使用 -n 可以指定变量值FLAGS_name

# Parse the command-line.
FLAGS "$@" || exit 1
# sends all command-line arguments into the shFlags library for processing
# return : ${FLAGS_TRUE} ${FLAGS_FALSE}  ${FLAGS_ERROR}
# output:$@  (shFlags didn't know how to process,)

# 类似于 google::ParseCommandLineFlags，FLAGS是内置函数

eval set -- "${FLAGS_ARGV}"
# eval set -- "${FLAGS_ARGV}" 重新设置了$@，留下未解析的参数 ${FLAGS_ARGV}.

# a FLAGS_name variable was defined
echo "Hello, ${FLAGS_name}!"
