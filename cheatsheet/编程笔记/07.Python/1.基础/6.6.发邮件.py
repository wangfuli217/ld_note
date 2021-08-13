#!python
# -*- coding:utf-8 -*-
import os
import logging
import smtplib
import sys

from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.mime.image import MIMEImage

# python 2.3.*: email.Utils email.Encoders
from email.utils import COMMASPACE,formatdate
from email import encoders

__all__ = ("send_mail",)

def send_mail(host, user, password, fro, to_list, subject, text, files=None, **kwargs):
    '''
    @summary: 发邮件
    @param {String} host: 连接smtp服务器
    @param {String} user: 登陆账号
    @param {String} password: 登陆密码
    @param {String} fro: 收到信时显示的发信人设置
    @param {list} to_list: 收信人列表
    @param {String} subject: 邮件主题
    @param {String} text: 邮件内容(html格式)
    @param {list} files: 附件列表(填入附件路径,如：d:\\123.txt)
    @return {bool}: 发信成功则返回 True,否则返回 False
    '''
    charset = 'utf-8'
    if isinstance(to_list, basestring):
        to_list = [to_list]
    assert type(to_list) == list
    # 转编码,以免客户端看起来是乱码的
    fro = to_unicode(fro)
    subject = to_unicode(subject)
    text = to_unicode(text).encode(charset)

    # 添加邮件内容
    msg = MIMEMultipart()
    msg['From'] = fro
    msg['Subject'] = subject
    msg['To'] = COMMASPACE.join(to_list) #COMMASPACE==', '
    msg['Date'] = formatdate(localtime=True)
    msg.attach(MIMEText(text,_subtype='html',_charset=charset)) #这里设置为html格式邮件

    # 添加附件
    files = files or []
    for file_path in files:
        # 文件路径
        file_path = to_unicode(file_path)
        # 文件名(不包含路径)
        file_name = os.path.basename(file_path)
        disposition = u'attachment; filename="%s"' % file_name
        disposition = to_unicode(disposition).encode(charset)
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
        #reason = e.reason if e and e.reason else 'unknown'
        logging.error(u'发邮件错误, subject:%s, text:%s' % (subject, text), exc_info=True)
        return False


def to_unicode(value):
    """将字符转为 unicode 编码
    @param {string} value 将要被转码的值
    @return {unicode} 返回转成 unicode 的字符串
    """
    if value == None:
        return None
    if isinstance(value, unicode):
        return value
    # 字符串类型,需要按它原本的编码来解码出 unicode,编码不对会报异常
    if isinstance(value, str):
        for encoding in ("utf-8", "gbk", "cp936", sys.getdefaultencoding(), "gb2312", "gb18030", "big5", "latin-1", "ascii"):
            try:
                value = value.decode(encoding)
                break # 如果上面这句执行没错，说明是这种编码
            except:
                pass
    # 其它类型
    return value


if __name__ == '__main__':
    #错误信息邮件通知配置
    host = "mail.guoling.com"
    user = "backend_program@guoling.com"
    password = "guoling"
    fro = u"发货系统错误汇报<backend_program@guoling.com>"   #这里可以任意设置，收到信后，将按照设置显示收件人
    mail_to_list = ["fengwanli@guoling.com", '292598441@qq.com'] # 收信人,发多个人需要用列表,只用字符串则只发第一个
    subject = u"发货系统有错误，请求处理"
    text = u'''这是测试内容,见到请忽略...<br/>
    现有发货不成功<font color='red'>红色字体</font>
    '''
    files = [u"E:\\WebDisk\\编程资料\\notes\\03.Web[HTML,CSS,JS]\\HTTP状态码.txt",
              u"E:\\WebDisk\\picture\\bb\\手机照\\2012.08.27_在保健院出生\\IMG_20120827_第1天.jpg"
              ]
    res = send_mail(host, user, password, fro, mail_to_list, subject, text, files=files)
    if res:
        print "发送成功"
    else:
        print "发送失败"

