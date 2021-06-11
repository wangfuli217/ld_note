#!/bin/sh   
### 判断指定的年份是否为闰年 ### 

year=$1
if [ "$((year % 4))" -ne 0 ]; then
  echo "This is not a leap year."
  exit 1
elif [ "$((year % 400))" -eq 0 ]; then
  echo "This is a leap year."
  exit 0
elif [ "$((year % 100))" -eq 0 ]; then
  echo "This is not a leap year."
  exit 1
else
  echo "This is a leap year."
  exit 0
fi

# 这里我们先列出闰年的规则:
# 1. 不能被4整除的年一定不是闰年；
# 2. 可以同时整除4和400的年一定是闰年；
# 3. 可以整除4和100，但是不能整除400的年，不是闰年；
# 4. 其他可以整除的年都是闰年。