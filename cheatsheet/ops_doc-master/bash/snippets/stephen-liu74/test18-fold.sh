#!/bin/sh
### 将文件的输出格式化为指定的宽度 ###

#1. 这里我们将缺省宽度设置为75，如果超过该宽度，将考虑折行显示，否则直接在一行中全部打印输出。这里只是为了演示方便，事实上，你完全可以将该值作为脚本或函数的参数传入，那样你将会得到更高的灵活性。    
my_width=75
#2. for循环的读取列表来自于脚本的参数。
#3. 在获取lines和chars变量时，sed命令用于过滤掉多余的空格字符。
#4. 在if的条件判断中${#line}用于获取line变量的字符长度，这是Shell内置的规则。
#5. fmt -w 80命令会将echo输出的整行数据根据其命令选项指定的宽度(80个字符)进行折行显示，再将折行后的数据以多行的形式传递给sed命令。
#6. sed在收到fmt命令的格式化输出后，将会在折行后的第一行头部添加两个空格，在其余行的头部添加一个加号和一个空格以表示差别。
for input; do
    lines=$(wc -l < $input | sed 's/ //g')
    chars=$(wc -c < $input | sed 's/ //g')
    owner=$(ls -l $input | awk '{print $3}')
    echo "-------------------------------------------------------------------------------"
    echo "File $input ($lines lines, $chars characters, owned by $owner):"
    echo "-------------------------------------------------------------------------------"
    while read line; do
        if [ ${#line} -gt $my_width ]; then
            echo "$line" | fmt -w 80 | sed -e '1s/^/  /' -e '2,$s/^/+ /'
        else
            echo "  $line"
        fi
    done < $input
    echo "-------------------------------------------------------------------------------"
done | more