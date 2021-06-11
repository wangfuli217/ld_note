#!/bin/sh
### 将单列显示转换为多列显示 ###
#1. passwd文件中，有可能在一行内出现一个或者多个空格字符，因此在直接使用cat命令的结果时，for循环会被空格字符切开，从而导致一行的文本被当做多次for循环的输入，这样我们不得不在sed命令中，将cat输出的每行文本进行全局替换，将空格字符替换为%20。事实上，我们当然可以将cat /etc/passwd的输出以管道的形式传递给cut命令，这里之所以这样写，主要是为了演示一旦出现类似的问题该如果巧妙的处理。
#2. 这里将for循环的输出以管道的形式传递给sort命令，sort命令将基于user排序。
#3. -xargs -n 2是这个技巧的重点，它将sort的输出进行合并，-n选项后面的数字参数将提示xargs命令将多少次输出合并为一次输出，并传递给其后面的命令。在本例中，xargs会将从sort得到的每两行数据合并为一行，中间用空格符分离，之后再将合并后的数据传递给后面的awk命令。事实上，对于awk而言，你也可以简单的认为xargs减少了对它(awk)的一半调用。
#4. 如果打算在一行内显示3行或更多的行，可以将-n后面的数字修改为3或其它更高的数字。你还可以修改awk中的print命令，使用更为复杂打印输出命令，以得到更为可读的输出效果。
for line in ${cat /etc/passwd | sed 's/ /%20/g'}; do
  user=$(echo $line | cut -d: -f1)
  echo $user
done | \
    sort -k1,1 | \
    xargs -n 2 | \
    awk '{print $1, $2}'

# /> ./test18.sh
# abrt adm
# apache avahi
# avahi-autoipd bin
# daemon daihw
# dbus ftp
# games gdm
# gopher haldaemon
# halt lp
# mail nobody
# ntp operator
# postfix pulse
# root rtkit
# saslauth shutdown
# sshd sync
# tcpdump usbmuxd
# uucp vcsa