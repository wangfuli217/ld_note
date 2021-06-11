#!/bin/sh
### 验证输入信息是否合法 ### 

echo -n "Enter your input: "
read input
#1. 事实上，这里的巧妙之处就是先用sed替换了非法部分，之后再将替换后的结果与原字符串比较。这种写法也比较容易扩展。    
parsed_input=$(echo $input | sed 's/[^[:alnum:]]//g')
if [ "$parsed_input" != "$input" ]; then
  echo "Your input must consist of only letters and numbers."
else
  echo "Input is OK."
fi

# /> ./test15_letter_number_if.sh
# Enter your input: hello123
# Input is OK.
# /> ./test15_letter_number_if.sh
# Enter your input: hello world
# Your input must consist of only letters and numbers.