#!python
# -*- coding:utf-8 -*-
'''
邮件公用函数(发邮件用)
Created on 2015/1/15
Updated on 2016/3/7
@author: Holemar

本模块专门供发邮件用,支持html内容
'''
import os
import logging
import smtplib

from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.mime.image import MIMEImage

# python 2.3.*: email.Utils email.Encoders
from email.utils import COMMASPACE,formatdate
from email import encoders

import str_util

__all__ = ("send_mail",)
logger = logging.getLogger('libs_my.email_util')


def send_mail(host, user, password, fro, to_list, subject, text, files=None, **kwargs):
    '''
    @summary: 发邮件
    @param {string} host: 连接smtp服务器
    @param {string} user: 登陆账号
    @param {string} password: 登陆密码
    @param {string} fro: 收到信时显示的发信人设置
    @param {list} to_list: 收信人列表
    @param {string} subject: 邮件主题
    @param {string} text: 邮件内容(html格式)
    @param {list} files: 附件列表(填入附件路径,如：d:\\123.txt)
    @return {bool}: 发信成功则返回 True,否则返回 False
    '''
    if isinstance(to_list, basestring):
        to_list = [to_list]
    assert type(to_list) == list
    # 转编码,以免客户端看起来是乱码的
    fro = str_util.to_unicode(fro)
    subject = str_util.to_unicode(subject)
    text = str_util.to_str(text)

    # 添加邮件内容
    msg = MIMEMultipart()
    msg['From'] = fro
    msg['Subject'] = subject
    msg['To'] = COMMASPACE.join(to_list) #COMMASPACE==', '
    msg['Date'] = formatdate(localtime=True)
    msg.attach(MIMEText(text,_subtype='html',_charset='utf-8')) #这里设置为html格式邮件

    # 添加附件
    files = files or []
    for file_path in files:
        # 文件路径
        file_path = str_util.to_unicode(file_path)
        # 文件名(不包含路径)
        file_name = os.path.basename(file_path)
        disposition = str_util.to_unicode(u'attachment; filename="%s"') % str_util.to_unicode(file_name)
        disposition = str_util.to_str(disposition)
        # 处理图片附件
        suffix = file_path.split('.')[-1]
        if suffix.lower() in ('jpg', 'jpeg', 'bmp', 'png', 'gif',):
            image = MIMEImage(open(file_path,'rb').read())
            image.add_header('Content-ID','<image1>')
            image.add_header('Content-Disposition', disposition)
            msg.attach(image)
        # 其它附件
        else:
            part = MIMEBase('application', 'octet-stream') #'octet-stream': binary data
            part.set_payload(open(file_path, 'rb').read())
            encoders.encode_base64(part)
            part.add_header('Content-Disposition', disposition)
            msg.attach(part)

    # 发送邮件
    try:
        smtp = smtplib.SMTP()
        smtp.connect(host)  #连接smtp服务器
        smtp.login(user,password)  #登陆服务器
        smtp.sendmail(fro, to_list, msg.as_string())  #发送邮件
        smtp.close()
        return True
    except Exception, e:
        logger.error(u'发邮件错误, subject:%s, text:%s', subject, text, exc_info=True)
        return False

if __name__ == '__main__':
    #错误信息邮件通知配置
    host = "smtp.163.com"
    user = "daillo@163.com"
    password = ""
    fro = u"测试邮件<daillo@163.com>"   #这里可以任意设置，收到信后，将按照设置显示收件人
    mail_to_list = ["292598441@qq.com",] # 收信人,发多个人需要用列表,只用字符串则只发第一个
    subject = u"发货系统有错误，请求处理"
    text = '''这是测试内容,见到请忽略...<br/>
    html代码测试：<font color='red'>红色字体</font>
    '''
    files = [u"C:\\WebDisk\\_同步\\picture_bb_2016\\2016.01.10_多多自拍\\IMG_5242.JPG",
             __file__
            ]
    res = send_mail(host, user, password, fro, mail_to_list, subject, text, files=files)
    if res:
        print "发送成功"
    else:
        print "发送失败"

