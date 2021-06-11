#!/usr/bin/python
# -*- coding: UTF-8 -*-

import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr
 
my_sender='377051849@qq.com'    # 发件人邮箱账号
my_pass = 'wangfuli217'         # 发件人邮箱密码
my_user='377051849@qq.com'      # 收件人邮箱账号，我这边发送给自己
def mail():
    ret=True
    try:
        msg=MIMEText('xxxxxxx','plain','utf-8')

        msg['From']=formataddr(["377051849@qq.com",my_sender])  # 括号里的对应发件人邮箱昵称、发件人邮箱账号
        msg['To']=formataddr(["FK",my_user])              # 括号里的对应收件人邮箱昵称、收件人邮箱账号
        msg['Subject']="yyyyyyy"                # 邮件的主题，也可以说是标题
        server=smtplib.SMTP_SSL("smtp.qq.com", 465)  # 发件人邮箱中的SMTP服务器，端口是465,不是网上说的25，而且要使用SMTP_SSL不是SMTP
        print("邮件发送成功1")
        server.login(r'377051849@qq.com', 'wangfuli217')  # 括号中对应的是发件人邮箱账号、邮箱密码
        print("邮件发送成功2")
        server.sendmail(r'377051849@qq.com', r'377051849@qq.com',msg.as_string())  # 括号中对应的是发件人邮箱账号、收件人邮箱账号、发送邮件
        print("邮件发送成功3")
        server.quit()  # 关闭连接
    except Exception as e:  # 如果 try 中的语句没有执行，则会执行下面的 ret=False
        ret=False
    return ret
 
ret=mail()
if ret:
    print("邮件发送成功")
else:
    print("邮件发送失败:")
    
----------------------------------------------------------
qq邮箱需要授权码，可参考报错信息中的链接获取，然后将获取的授权码赋值给邮箱密码，
在flask-mail中是MAIL_PASSWORD=‘#授权码’。 
时隔一年半……希望可以帮到你

http://service.mail.qq.com/cgi-bin/help?subtype=1&&id=28&&no=1001256
