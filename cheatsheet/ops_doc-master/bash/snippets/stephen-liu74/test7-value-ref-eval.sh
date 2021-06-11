#!/bin/sh
### 非直接引用变量 ###
work_dir=$(pwd)
#1. 由于变量名中不能存在反斜杠，因此这里需要将其替换为下划线。
#2. work_dir和file_count两个变量的变量值用于构建动态变量的变量名。
work_dir=$( echo $work_dir | sed 's/\//_/g' )
file_count=$( ls | wc -l )
#3. 输出work_dir和file_count两个变量的值，以便确认这里的输出结果和后面构建的命令名一致。
echo "work_dir = " $work_dir
echo "file_count = " $file_count
#4. 通过eval命令进行评估，将变量名展开，如${work_dir}和$file_count，并用其值将其替换，如果不使用eval命令，将不会完成这些展开和替换的操作。最后为动态变量赋值。
eval BASE${work_dir}_$file_count=$(ls $(pwd) | wc -l)
#5. 先将echo命令后面用双引号扩住的部分进行展开和替换，由于是在双引号内，仅完成展开和替换操作即可。
#6. echo命令后面的参数部分，先进行展开和替换，使其成为$BASE_root_test_1动态变量，之后在用该变量的值替换该变量本身作为结果输出。
eval echo "BASE${work_dir}_$file_count = " '$BASE'${work_dir}_$file_count


# 在Shell中提供了三种为标准(直接)变量赋值的方式：
# 1. 直接赋值。
# 2. 存储一个命令的输出。
# 3. 存储某类型计算的结果。
# 然而这三种方式都是给已知变量名的变量赋值，如name=Stephen。
# 但是在有些情况下，变量名本身就是动态的，需要依照运行的结果来构造变量名，之后才是为该变量赋值。
# 这种变量被成为动态变量，或非直接变量。

# ./test7-value-ref-eval.sh
# work_dir =  _root_test
# file_count =  1
# BASE_root_test_1 = 1
      
      