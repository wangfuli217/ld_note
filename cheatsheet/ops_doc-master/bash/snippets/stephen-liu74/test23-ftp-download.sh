#!/bin/sh
### 通过FTP下载指定的文件 ### 

#1. 测试脚本参数数量的有效性。    
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 ftp://... username" >&2
  exit 1
fi
#2. 获取第一个参数的前六个字符，如果不是"ftp://"，则视为非法FTP URL格式。这里cut的-c选项表示按照字符的方式截取第一到第六个字符。
header=`echo $1 | cut -c1-6`
if [ "$header" != "ftp://" ]; then
  echo "$0: Invalid ftp URL." >&2
  exit 1
fi
#3. 合法ftp URL的例子：ftp://ftp.myserver.com/download/test.tar
#4. 针对上面的URL示例，cut命令通过/字符作为分隔符，这样第三个域字段表示server(ftp.myserver.com)。
#5. 在截取filename时，cut命令也是通过/字符作为分隔符，但是"-f4-"将获取从第四个字段开始的后面所有字段(download/test.tar)。
#6. 通过basename命令获取filename的文件名部分。
server=$(echo $1 | cut -d/ -f3)
filename=$(echo $1 | cut -d/ -f4-)
basefile=$(basename $filename)
ftpuser=$2
#7. 这里需要调用stty -echo，以便后面的密码输入不会显示，在输入密码之后，需要再重新打开该选项，以保证后面的输入可以恢复显示。
#8. echo ""，是模拟一次换换。
echo -n "Password for $ftpuser: "
stty -echo
read password
stty echo
echo ""
#9. 通过HERE文档，批量执行ftp命令。
echo ${0}: Downloading $baseile from server $server.
ftp -n << EOF
open $server
user $ftpuser $password
get $filename $basefile
quit
EOF
#10.Shell内置变量$?表示上一个Shell进程的退出值，0表示成功执行，其余值均表示不同原因的失败。
if [ $? -eq 0 ]; then
  ls -l $basefile
fi


# /> ./test25.sh  ftp://ftp.myserver.com/download/test.tar stephen
# Password for stephen:
# ./test25.sh: Downloading from server ftp.myserver.com.
# -rwxr-xr-x. 1 root root 678 Dec  9 11:46 test.tar
exit 0