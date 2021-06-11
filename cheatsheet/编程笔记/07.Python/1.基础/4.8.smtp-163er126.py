--------------------------------------- 实例1 From 163 To 126
import requests
import smtplib
import urllib
import threading
import time
import urllib2
import cookielib
import re
from email.mime.text import MIMEText
from email.MIMEMultipart import MIMEMultipart

mail_host="smtp.163.com"
mail_user="15102934974"
mail_pass="mamababa1981"

def sendsimplemail (information):
    msg = MIMEText(information)
    msg['Subject'] = 'iphone 6,information'
    msg['From'] = '15102934974@163.com'
    try:
        smtp = smtplib.SMTP()
        smtp.connect(r'smtp.163.com')
        print "11111111"
        smtp.login('15102934974@163.com', 'mamababa1981')
        print "xxxxxx"
        smtp.sendmail('15102934974@163.com',"wangfl217@126.com", msg.as_string())
        print "2222222222"
        smtp.close()
    except Exception, e:
                print e

if __name__ == '__main__':
    sendsimplemail(information= "iphone6 is available!!!")

--------------------------------------- 实例2 From 163 To QQ
    
#!/usr/bin/env python
# -*- coding: utf_8 -*-

from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.multipart import MIMEBase
from email import encoders
from email.header import Header
from email.utils import parseaddr, formataddr
import smtplib


class SendEmail:
    outbox = "15102934974@163.com"
    # 发件箱地址
    password = "mamababa1981"
    # 授权密码 不是邮箱登录密码
    inbox = "377051849@qq.com"
    # 收件箱地址
    smtp_server = "smtp.163.com"
    # 发件箱服务器地址

    def __init__(self):
        pass

    @classmethod
    def _format_address(cls, text):
        name, address = parseaddr(text)
        return formataddr((Header(name, "utf-8").encode(), address))

    @classmethod
    def send_email_text(cls):
        msg = MIMEText("测试smtp邮件发送功能", "plain", "utf-8")
        # 第一个参数：邮件正文
        # 第二个参数：邮件类型 纯文本
        # 第三个参数：编码

        msg["From"] = SendEmail._format_address("来自163的一封邮件 <%s>" % SendEmail.outbox)
        # 发件人姓名与发件箱地址
        msg["To"] = SendEmail._format_address("管理员 <%s>" % SendEmail.inbox)
        # 收件人姓名与收件箱地址
        msg["Subject"] = Header("来自SMTP的问候", "utf-8").encode()
        # 邮件标题

        try:
            server = smtplib.SMTP(SendEmail.smtp_server, 25)
            # 构造smtp服务器连接
            # server.set_debuglevel(1)
            # debug输出模式 默认关闭
            server.login(SendEmail.outbox, SendEmail.password)
            # 登录smtp服务器
            server.sendmail(SendEmail.outbox, [SendEmail.inbox], msg.as_string())
            # 发送邮件
            server.quit()
            print "邮件发送成功"
        except Exception, e:
            print str(e)
            print "邮件发送失败"
            
if __name__ == '__main__':
    SendEmail.send_email_text()
    
-------------------------------------------  附件
@classmethod
def send_email_multipart(cls):
    msg = MIMEMultipart()

    msg["From"] = SendEmail._format_address("来自163的一封邮件 <%s>" % SendEmail.outbox)
    # 发件人姓名与发件箱地址
    msg["To"] = SendEmail._format_address("管理员 <%s>" % SendEmail.inbox)
    # 收件人姓名与收件箱地址
    msg["Subject"] = Header("来自SMTP的问候", "utf-8").encode()
    # 邮件标题

    msg.attach(MIMEText("测试添加附件的smtp邮件发送功能", "plain", "utf-8"))

    with open("E:\\work\\python project\\CreateProject\\20160421140953.xml", "rb") as f:
        # 设置附件的MIME和文件名
        mime = MIMEBase("xml", "xml", filename="测试报告.xml")
        # 加上必要的头信息
        mime.add_header('Content-Disposition', 'attachment', filename="测试报告.xml")
        mime.add_header('Content-ID', '<0>')
        mime.add_header('X-Attachment-Id', '0')
        # 把附件的内容读进来:
        mime.set_payload(f.read())
        # 用Base64编码:
        encoders.encode_base64(mime)
        # 添加到MIMEMultipart:
        msg.attach(mime)

    try:
        server = smtplib.SMTP(SendEmail.smtp_server, 25)
        # 构造smtp服务器连接
        # server.set_debuglevel(1)
        # debug输出模式 默认关闭
        server.login(SendEmail.outbox, SendEmail.password)
        # 登录smtp服务器
        server.sendmail(SendEmail.outbox, [SendEmail.inbox], msg.as_string())
        # 发送邮件
        server.quit()
        print "邮件发送成功"
    except Exception, e:
        print str(e)
        print "邮件发送失败"