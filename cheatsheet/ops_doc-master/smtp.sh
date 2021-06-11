Linux/Centos下mail连接到smtp服务器发送邮件

自架邮件服务器麻烦还容易被拦截，可以使用Linux下mail命令连接到第三方邮件服务器商的smtp服务器发送邮件。
#/bin/bash
mailaddr=onovps@www.haiyun.me   # 15102934974@163.com
smtpserver=smtp.www.haiyun.me   # smtp.163.com
user=15102934974
passwd="mamababa1981"
cat >> /etc/mail.rc <<EOF
set from=$mailaddr
set smtp=$smtpserver
set smtp-auth=login
set smtp-auth-user=$user
set smtp-auth-password=$passwd
EOF


发送邮件：
mail -v -s "主题" wangfl@126.com #Enter键后输入正文
mail -v -s "主题" wangfl@126.com < file #file内容为正文
echo "正文"|mail -v -s "主题" wangfl@126.com #以重定向输入为正文


# -------------------------------------------------------------------------------
#!/bin/bash
#Created by http://www.haiyun.me
#set -x
while true
do
    list=(www.haiyun.me cp.www.haiyun.me)
    mail=onovps@www.haiyun.me
    date=$(date -d "today" +"%Y-%m-%d-%H:%M:%S")
    i=0
    id=${#list[*]}
    while [ $i -lt $id ] 
    do
        if ping -c1 ${list[$i]} >/dev/null
        then
            echo  $date:服务器${list[$i]}能ping通。
        else
            if curl -m 10  ${list[$i]} > /dev/null
            then
                echo  $date:服务器${list[$i]} ping不通,能打开网页。
            else
                echo  "您好，据系统监测服务器${list[$i]}不能访问且ping不通,请及时处理!故障发生时间：$date"|mail -s "服务器${list[$i]}不能连接! 故障发生时间：$date" $mail
                until
                    date=$(date -d "today" +"%Y-%m-%d-%H:%M:%S")
                    ping -c1 ${list[$i]} >/dev/null && echo "恭喜！服务器${list[$i]}已恢复正常，恢复时间：$date"|mail -s "服务器${list[$i]}已恢复正常! 恢复时间：$date" $mail
                do
                    sleep 5
                done
            fi
        fi
        let i++
    done
    sleep 60
done

执行：
nohup sh /path/file.sh & #放到后台运行，程序60秒检查一次网站。

开机运行：
echo "nohup sh /path/file.sh & " >> /etc/rc.local