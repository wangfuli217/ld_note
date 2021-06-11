#!python
# -*- coding:utf-8 -*-
'''
公用函数(日志处理) log_util.py 的测试
Created on 2014/7/16
Updated on 2016/8/17
@author: Holemar
'''
import os
import logging
import unittest

import __init__
from libs_my import log_util, file_util

logfile = './_log_util.log'
log_format = "[%(asctime)s] %(name)s [%(module)s.%(funcName)s:%(lineno)s] %(levelname)s: %(message)s"

class TestLogUtil(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        u'''测试这个类前的初始化动作'''
        super(TestLogUtil, cls).setUpClass()
        log_util.init(log_file=logfile, level='DEBUG', format=log_format, log_max=None, to_read=False, color=False, append=False) # 会先删除旧日志

    @classmethod
    def tearDownClass(cls):
        u'''测试这个类所有函数后的结束动作'''
        log_util.init(log_file=None, level='DEBUG', format=log_format, log_max=None, to_read=False, color=False, append=False)
        logger = logging.getLogger()
        logger.handlers[:] = [h for h in logger.handlers if not (type(h) is log_util.fileHandler and h.baseFilename == os.path.abspath(logfile))] # 去掉文件输出，还原日志打印
        file_util.remove(logfile) # 删除日志文件
        super(TestLogUtil, cls).tearDownClass()

    def tearDown(self):
        u"""销毁"""
        # 还原默认的 logger， 以免修改过 log init 的影响其它测试用例
        log_util.init(log_file=logfile, level='DEBUG', format=log_format, log_max=None, to_read=False, color=False, append=True)
        super(TestLogUtil, self).tearDown()

    # 基础测试
    def test_base(self):
        log_util.info('基础测试')
        log_util.debug(u'请求url:%s', u'http://哈22哈')
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue(' DEBUG: ' in log_msg2)
        self.assertTrue('请求url:http://哈22哈' in log_msg2)

        log_util.info('请求url:%s, 返回:%s', u'http://哈哈', '112')
        log_msg3 = file_util.get_last_lines(logfile)
        self.assertTrue(' INFO: ' in log_msg3)
        self.assertTrue('请求url:http://哈哈, 返回:112' in log_msg3)

        log_util.error(u'请求url:%(url)s, 返回:%(res)s', {'url':u'http://error哈哈', 'res':(1,2,'112',)})
        log_msg4 = file_util.get_last_lines(logfile)
        self.assertTrue(' ERROR: ' in log_msg4)
        self.assertTrue("请求url:http://error哈哈, 返回:(1, 2, '112')" in log_msg4)

        # exception 会多打印一行 None 日志出来,不知道什么原因
        log_util.exception(u'请求url:%(url)s, 返回:%(res)s', {'url':u'http://11哈哈', 'res':(1,2,'112',)})
        log_msg5 = file_util.get_last_lines(logfile, 2)[0]
        self.assertTrue(' ERROR: ' in log_msg5) # exception 是 ERROR 级别的日志
        self.assertTrue("请求url:http://11哈哈, 返回:(1, 2, '112')" in log_msg5)

        log_util.warn(u'请求url:%(url)s, 返回:%(res)s', {'url':u'http://xx哈哈', 'res':(1,2,'112',)})
        log_msg6 = file_util.get_last_lines(logfile)
        self.assertTrue(' WARNING: ' in log_msg6)
        self.assertTrue("请求url:http://xx哈哈, 返回:(1, 2, '112')" in log_msg6)

        log_util.warning(u'请求url:%(url)s, 返回:%(res)s', {'url':u'http://warning哈哈', 'res':(1,2,'112',)})
        log_msg7 = file_util.get_last_lines(logfile)
        self.assertTrue(' WARNING: ' in log_msg7)
        self.assertTrue("请求url:http://warning哈哈, 返回:(1, 2, '112')" in log_msg7)

        log_util.critical('请求url:%s cc')
        log_msg8 = file_util.get_last_lines(logfile)
        self.assertTrue(' CRITICAL: ' in log_msg8)
        self.assertTrue("请求url:%s cc" in log_msg8) # %s 没有可替换的内容,保持原样

    # log 函数测试(可自定义级别)
    def test_log(self):
        log_util.info('log函数测试')
        log_util.log(log_util.INFO, '这是 info 级别日志')
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' INFO: ' in log_msg)
        self.assertTrue('这是 info 级别日志' in log_msg)

        log_util.log(log_util.DEBUG, '这是 debug 级别日志 %s', '哈哈')
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' DEBUG: ' in log_msg)
        self.assertTrue('这是 debug 级别日志 哈哈' in log_msg)

        log_util.log(log_util.WARNING, '这是 WARNING 级别日志 %s %s %s', 1,2,3)
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' WARNING: ' in log_msg)
        self.assertTrue('这是 WARNING 级别日志 1 2 3' in log_msg)

        log_util.log(log_util.NOTSET, '这日志不会输出')
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' WARNING: ' in log_msg)
        self.assertTrue('这是 WARNING 级别日志 1 2 3' in log_msg)

        log_util.debug('请求url:%s', u'http://哈哈')
        log_msg1 = file_util.get_last_lines(logfile)
        self.assertTrue(' DEBUG: ' in log_msg1)
        self.assertTrue('请求url:http://哈哈' in log_msg1)

        logging.info(u'原生logging测试, 请求url:%s' % u'http://哈哈')
        log_msg1 = file_util.get_last_lines(logfile)
        self.assertTrue(' INFO: ' in log_msg1)
        self.assertTrue('原生logging测试, 请求url:http://哈哈' in log_msg1)

    # 获取模块名、函数名和行号测试
    def test_findCaller(self):
        first_line = 116
        log_util.info('findCaller测试')

        # log_util 的获取
        log_util.debug(u'请求url:%s', u'http://哈22哈')
        first_line += 4
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue('请求url:http://哈22哈' in log_msg2)
        self.assertTrue(' [test_log_util.test_findCaller:%d] ' % first_line in log_msg2)

        # 原生 logging 的获取
        logging.info(u'原生logging测试, 请求url:%s' % u'http://哈哈')
        first_line += 7
        log_msg1 = file_util.get_last_lines(logfile)
        self.assertTrue('原生logging测试, 请求url:http://哈哈' in log_msg1)
        self.assertTrue(' [test_log_util.test_findCaller:%d] ' % first_line in log_msg1)

        # logger 的获取
        logger = log_util.getLogger('libs_my.log_util')
        logger.error(u'请求url:%(url)s, 返回:%(res)s', {'url':u'http://error哈哈', 'res':(1,2,'112',)})
        first_line += 8
        log_msg4 = file_util.get_last_lines(logfile)
        self.assertTrue("请求url:http://error哈哈, 返回:(1, 2, '112')" in log_msg4)
        self.assertTrue(' [test_log_util.test_findCaller:%d] ' % first_line in log_msg4)

    # 非字符串测试
    def test_no_str(self):
        log_util.info('非字符串测试')
        log_util.debug({u'请求url:': u'http://哈22哈'}, extra={'to_read':True})
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{u'请求url:': u'http://哈22哈'}" in log_msg2)

        log_util.debug({u'请求url:': u'http://哈22哈'})
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{u'\u8bf7\u6c42url:': u'http://\u54c822\u54c8'}" in log_msg2)

        logging.debug({'请求url:': 'http://哈22哈'})
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{u'\u8bf7\u6c42url:': u'http://\u54c822\u54c8'}" in log_msg2)

        logging.debug({'请求url:': 'http://哈22哈'}, extra={'to_read':True})
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{u'请求url:': u'http://哈22哈'}" in log_msg2)

        log_util.debug({u'请求url:': u'http://哈22哈'}, extra={'to_read':True, 'log_max':13})
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{u'请求url:': u..." in log_msg2)

        logging.debug({u'请求url:': u'http://哈22哈'}, extra={'log_max':13})
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{u'\u8bf7\u6c..." in log_msg2)

    # to_read 测试
    def test_to_read(self):
        log_util.info('to_read 参数测试')

        # 没有设置 to_read 参数时，不能擅自改变传入内容
        log_util.debug("{u'\u8bf7\u6c42url:': u'http://\u54c822\u54c8'}")
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{u'\u8bf7\u6c42url:': u'http://\u54c822\u54c8'}" in log_msg2)

        log_util.debug("{'\xe8\xaf\xb7\xe6\xb1\x82url:': 'http://\xe5\x93\x8822\xe5\x93\x88'}")
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{'\xe8\xaf\xb7\xe6\xb1\x82url:': 'http://\xe5\x93\x8822\xe5\x93\x88'}" in log_msg2)
        self.assertTrue("{'请求url:': 'http://哈22哈'}" in log_msg2) # 其实这样写，会内部自动转换

        log_util.debug("{'\\xe8\\xaf\\xb7\\xe6\\xb1\\x82url:': 'http://\\xe5\\x93\\x8822\\xe5\\x93\\x88'}")
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{'\\xe8\\xaf\\xb7\\xe6\\xb1\\x82url:': 'http://\\xe5\\x93\\x8822\\xe5\\x93\\x88'}" in log_msg2)

        # 设置 to_read 参数时，需要改变传入内容
        log_util.debug("{u'\u8bf7\u6c42url:': u'http://\u54c822\u54c8'}", extra={'to_read':True})
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{u'请求url:': u'http://哈22哈'}" in log_msg2)

        # 原生 logging 也同样需要支持 to_read
        logging.debug("{u'\u8bf7\u6c42url:': u'http://\u54c822\u54c8'}", extra={'to_read':True})
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{u'请求url:': u'http://哈22哈'}" in log_msg2)

        log_util.debug("{'\xe8\xaf\xb7\xe6\xb1\x82url:': 'http://\xe5\x93\x8822\xe5\x93\x88'}", extra={'to_read':True})
        log_msg2 = file_util.get_last_lines(logfile)
        self.assertTrue("{'\xe8\xaf\xb7\xe6\xb1\x82url:': 'http://\xe5\x93\x8822\xe5\x93\x88'}" in log_msg2)
        self.assertTrue("{'请求url:': 'http://哈22哈'}" in log_msg2) # 其实这样写，会内部自动转换

        #log_util.debug("{'\\xe8\\xaf\\xb7\\xe6\\xb1\\x82url:': 'http://\\xe5\\x93\\x8822\\xe5\\x93\\x88'}", extra={'to_read':True})
        #log_msg2 = file_util.get_last_lines(logfile)
        #self.assertTrue("{'请求url:': 'http://哈22哈'}" in log_msg2)

    # 长度限制测试
    def test_length(self):
        log_util.info('长度测试')
        log_util.info('12345678901234567890')
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('12345678901234567890' in log_msg)

        # 日志截取
        log_util.init(log_file=None, log_max=10, level='info', append=True)
        log_util.info('12345678901234567890')
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('1234567890...' in log_msg) # 截取到 init 设置的 10 位,后面拼接上“...”

        log_util.debug('12345678901234567890', extra={'log_max':11})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('12345678901...' in log_msg)

        log_util.info('12345678901234567890', extra={'log_max':11})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('12345678901...' in log_msg) # 截取到 11 位,而不是 init 设置的 10 位

        # 中文计算
        log_util.info(u'一二三四五六七八九十零一二三四五六七八九十零', extra={'log_max':11})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('一二三四五六七八九十零...' in log_msg)

        log_util.info('一二三四五六七八九十零一二三四五六七八九十零', extra={'log_max':11})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' INFO: ' in log_msg)
        self.assertTrue('一二三四五六七八九十零...' in log_msg)

        # 无限制
        log_util.error('12345678901234567890', extra={'log_max':0})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('12345678901234567890' in log_msg)

        log_util.info('12345678901234567890', extra={'log_max':None})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('12345678901234567890' in log_msg)

        # 参数截取
        log_util.info('%s1234456789', u'abcdefghijklmnopq', extra={'log_max':11})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('abcde...123...' in log_msg)

        log_util.info('%s%s1234456789', u'abcdefghijklmnopq', 99, extra={'log_max':11})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('abcde...991...' in log_msg)

        # 中文参数截取
        log_util.info('%s一二三四五六七八九', u'甲乙丙丁哈哈哈', extra={'log_max':11})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('甲乙丙丁哈...一二三...' in log_msg)

        log_util.info('%s%s一二三四五六七八九', u'甲乙丙丁哈哈哈', 'xx', extra={'log_max':11})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('甲乙丙丁哈...xx一...' in log_msg)

        # 还原日志设置,避免影响下面的测试
        log_util.init(log_file=None, log_max=None, level='DEBUG', append=True)

    # 错误日志输入
    def test_error(self):
        log_util.info('错误格式化测试')
        log_util.info('错误格式化测试 %s', 1,'2',u'哈哈')
        error_log_msg = file_util.get_last_lines(logfile)
        self.assertTrue('TypeError: ' in error_log_msg)
        log_util.info('错误格式化测试完成，测试通过，上面报错是必须的。。。')

    # 颜色输出的测试
    def test_change_color(self):
        log_util.info('颜色测试')
        self.assertTrue(log_util.change_color('[red]红色显示的内容[/red]') == '\033[1;31;40m红色显示的内容\033[0m')
        self.assertTrue(log_util.change_color(u'哈哈[black]黑色显示的内容[/black]xxx') == u'哈哈\033[7;30;47m黑色显示的内容\033[0mxxx')
        self.assertTrue(log_util.change_color(u'哈哈[green]显示的内容[53125][/正常吗][/color][/green]呵呵') == u'哈哈\033[1;32;40m显示的内容[53125][/正常吗][/color]\033[0m呵呵')
        self.assertTrue(log_util.change_color(u'哈哈[[yellow]黄色[/yellow]]xx[blue][/color][/blue]呵呵') == u'哈哈[\033[1;33;40m黄色\033[0m]xx\033[1;34;47m[/color]\033[0m呵呵')
        self.assertTrue(log_util.change_color(u'哈哈[fuchsia][紫红色][/fuchsia]x[cyan]{[dd]}[/cyan]x[white]e[/white]') == u'哈哈\033[1;35;40m[紫红色]\033[0mx\033[1;36;40m{[dd]}\033[0mx\033[1;37;40me\033[0m')

        log_util.info(u'哈哈[black]黑色显示的内容[/black]xxx', extra={'color':True})
        log_util.info(u'哈哈[green]绿色显示的内容[/green]xxx', extra={'color':True})
        log_util.info(u'哈哈[yellow]黃色显示的内容[/yellow]xxx', extra={'color':True})
        log_util.info(u'哈哈[blue]蓝色显示的内容[/blue]xxx', extra={'color':True})
        log_util.info(u'哈哈[fuchsia]紫红色显示的内容[/fuchsia]xxx', extra={'color':True})
        log_util.info(u'哈哈[cyan]青蓝色显示的内容[/cyan]xxx', extra={'color':True})
        log_util.info(u'哈哈[white]白色显示的内容[/white]xxx', extra={'color':True})
        log_util.info(u'哈哈[red]红色显示的内容[/red]xxx', extra={'color':True})
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' INFO: ' in log_msg)
        self.assertTrue('哈哈\033[1;31;40m红色显示的内容\033[0mxxx' in log_msg)
        log_util.info('颜色输出测试通过')

    # 多个 logger_name 测试
    def test_logger_name(self):
        first_line = 298
        log_util.info('多个 logger_name 测试')

        # 定义测试 logger
        log_util.init(log_file=logfile, level='DEBUG', format=log_format, log_max=12, to_read=False, color=False, append=True)
        log_util.init(log_file=logfile, level='DEBUG', format=log_format, log_max=10, to_read=False, color=False, append=True, logger_name='log1')
        log_util.init(log_file=logfile, level=log_util.INFO, format=log_format, log_max=15, to_read=False, color=False, append=True, logger_name='log2')
        logger0 = log_util.getLogger()
        logger1 = log_util.getLogger('log1')
        logger2 = logging.getLogger('log2')
        logger3 = logging.getLogger('log3') # 这里没定义的，即默认的 logger
        logger11 = log_util.getLogger('log1.a') # 子 logger 测试

        logger0.debug("{'请求url:': 'http://哈22哈'}")
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' DEBUG: ' in log_msg)
        self.assertTrue("{'请求url:': '..." in log_msg) # 截取长度 12

        logger1.debug("{'请求url:': 'http://哈22哈'}")
        first_line += 18
        log_msg = file_util.get_last_lines(logfile, num=2)
        log_msg1 = log_msg[1]
        self.assertTrue(' DEBUG: ' in log_msg1)
        self.assertTrue("{'请求url:':..." in log_msg1) # 截取长度 10
        self.assertTrue(' [test_log_util.test_logger_name:%d] ' % first_line in log_msg1)
        self.assertTrue(' [test_log_util.test_logger_name:%d] ' % first_line not in log_msg[0]) # 同一个日志文件，不能输出两次

        logger2.debug("{'请求url:': 'http://哈22哈'}")
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' [test_log_util.test_logger_name:%d] ' % first_line in log_msg) # 日记级别是 INFO，所以没有输出

        logger2.info("{'请求url:': 'http://哈22哈'}")
        first_line += 13
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' INFO: ' in log_msg)
        self.assertTrue("{'请求url:': 'htt..." in log_msg) # 截取长度 15
        self.assertTrue(' [test_log_util.test_logger_name:%d] ' % first_line in log_msg)

        logger3.info("{'请求url:': 'http://哈22哈'}")
        first_line += 7
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' INFO: ' in log_msg)
        self.assertTrue("{'请求url:': '..." in log_msg) # 截取长度 12，用了默认的 root 的 logger
        self.assertTrue(' [test_log_util.test_logger_name:%d] ' % first_line in log_msg)

        logger11.debug("{'请求url:': 'http://哈22哈'}")
        first_line += 7
        log_msg = file_util.get_last_lines(logfile)
        self.assertTrue(' DEBUG: ' in log_msg)
        self.assertTrue("{'请求url:':..." in log_msg) # 截取长度 10， 继承父级 log1 的
        self.assertTrue(' [test_log_util.test_logger_name:%d] ' % first_line in log_msg)

        # 定义子日志，看会不会多写一份日志
        log_util.init(log_file=logfile, level='DEBUG', format=log_format, log_max=11, to_read=False, color=False, append=True, logger_name='log1.b')
        logger12 = log_util.getLogger('log1.b.c') # 子 logger 测试
        logger12.debug("{'请求url:': 'http://哈22哈'}")
        first_line += 10
        log_msg = file_util.get_last_lines(logfile, num=2)
        log_msg1 = log_msg[1]
        self.assertTrue(' DEBUG: ' in log_msg1)
        self.assertTrue("{'请求url:': ..." in log_msg1) # 截取长度 11，用 log1.b 的设置，而不是 root 或者 log1 的
        self.assertTrue(' [test_log_util.test_logger_name:%d] ' % first_line in log_msg1)
        self.assertTrue(' [test_log_util.test_logger_name:%d] ' % first_line not in log_msg[0]) # 同一个日志文件，不能输出两次

        # 获取从未定义的子日志，看会不会多写一份日志
        logger33 = log_util.getLogger('aa.bbb.cc') # 子 logger 测试
        logger33.debug("{'请求url:': 'http://哈22哈'}")
        first_line += 11
        log_msg = file_util.get_last_lines(logfile, num=2)
        log_msg1 = log_msg[1]
        self.assertTrue(' DEBUG: ' in log_msg1)
        self.assertTrue("{'请求url:': '..." in log_msg1) # 截取长度 12，用了默认的 root 的 logger
        self.assertTrue(' [test_log_util.test_logger_name:%d] ' % first_line in log_msg1)
        self.assertTrue(' [test_log_util.test_logger_name:%d] ' % first_line not in log_msg[0]) # 同一个日志文件，不能输出两次


    # init 定义先后顺序 测试
    def test_init_file(self):
        first_line = 376
        logfile2 = './_log_util2.log'
        log_util.info('init 定义先后顺序 测试')

        # 先获取 logger 后定义，看是否会生效
        logger1 = log_util.getLogger('test_init1')
        log_util.init(log_file=logfile2, level=log_util.INFO, format=log_format, log_max=None, logger_name='test_init1', append=False) # 会先删除旧日志

        logger1.info("{'请求url:': 'http://哈22哈test_init1'}")
        first_line += 8
        log_msg1 = file_util.get_last_lines(logfile2)
        self.assertTrue(' INFO: ' in log_msg1)
        self.assertTrue("{'请求url:': 'http://哈22哈test_init1'}" in log_msg1) # 不截取长度
        self.assertTrue(' [test_log_util.test_init_file:%d] ' % first_line in log_msg1)

        logger1.debug("一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十")
        log_msg1 = file_util.get_last_lines(logfile2)
        self.assertTrue(' INFO: ' in log_msg1)
        self.assertTrue("{'请求url:': 'http://哈22哈test_init1'}" in log_msg1) # 日志写不进去
        self.assertTrue(' [test_log_util.test_init_file:%d] ' % first_line in log_msg1)

        # 再次定义
        log_util.init(log_file=logfile2, level=log_util.DEBUG, log_max=12, logger_name='test_init1')

        logger1.debug("一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十")
        first_line += 16
        log_msg1 = file_util.get_last_lines(logfile2)
        self.assertTrue(' DEBUG: ' in log_msg1)
        self.assertTrue("一二三四五六七八九十一二..." in log_msg1) # 日志写进去了
        self.assertTrue(' [test_log_util.test_init_file:%d] ' % first_line in log_msg1)

        # 又再次定义
        log_util.init(log_file=logfile2, level=log_util.INFO, log_max=15, logger_name='test_init1')

        logger1.debug("一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十")
        log_msg1 = file_util.get_last_lines(logfile2)
        self.assertTrue(' DEBUG: ' in log_msg1)
        self.assertTrue("一二三四五六七八九十一二..." in log_msg1) # 日志写不进去
        self.assertTrue(' [test_log_util.test_init_file:%d] ' % first_line in log_msg1)

        logger1.info("一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十")
        first_line += 16
        log_msg1 = file_util.get_last_lines(logfile2)
        self.assertTrue(' INFO: ' in log_msg1)
        self.assertTrue("一二三四五六七八九十一二三四五..." in log_msg1) # 日志写进去了
        self.assertTrue(' [test_log_util.test_init_file:%d] ' % first_line in log_msg1)

        logger1.handlers[:] = [] # 去掉文件输出，还原日志打印
        file_util.remove(logfile2) # 删除日志文件


    # init 定义多个 socket 测试
    def test_init_socket(self):
        remote_host = '218.17.157.25'
        my_host = '127.0.0.1'
        port1 = 9022
        port2 = 9023

        log_util.init(log_file=None, level=log_util.INFO, socket_host=remote_host, socket_port=port1) # 全局日志
        log_util.init(log_file=None, level=log_util.WARNING, socket_host=remote_host, socket_port=port1, logger_name='tasks', log_max=0) # 定义 logger_name 的
        log_util.init(log_file=None, level=log_util.WARNING, socket_host=my_host, socket_port=[port1, port2, port1], logger_name='tasks.my', log_max=0) # 定义多个端口

        root_logger = logging.getLogger()
        root_handlers = [h for h in root_logger.handlers if type(h) is log_util.SocketHandler]
        self.assertEqual(len(root_handlers), 1) # 定义了1个全局的 socket
        self.assertEqual(root_handlers[0].host, remote_host)
        self.assertEqual(root_handlers[0].port, port1)
        self.assertEqual(root_handlers[0].level, log_util.INFO)

        tasks_logger = log_util.getLogger('tasks')
        tasks_handlers = [h for h in tasks_logger.handlers if type(h) is log_util.SocketHandler]
        self.assertEqual(len(tasks_handlers), 0) # 由于已经定义了全局的，所以子级的相同 socket 不用重复发

        my_logger = log_util.getLogger('tasks.my')
        my_handlers = [h for h in my_logger.handlers if type(h) is log_util.SocketHandler]
        self.assertEqual(len(my_handlers), 2) # 定义了2个 socket
        self.assertEqual(my_handlers[0].host, my_host)
        self.assertEqual(my_handlers[1].host, my_host)
        self.assertEqual(my_handlers[0].level, log_util.WARNING)
        self.assertEqual(my_handlers[1].level, log_util.WARNING)
        self.assertEqual(set([my_handlers[0].port, my_handlers[1].port]), set([port1, port2]))

        # 定义多个端口，且其中包含父级的
        log_util.init(log_file=None, level=log_util.INFO, socket_host=remote_host, socket_port=[port1, port2], logger_name='tasks.my2', log_max=0)
        my2_logger = logging.getLogger('tasks.my2')
        my2_handlers = [h for h in my2_logger.handlers if type(h) is log_util.SocketHandler]
        self.assertEqual(len(my2_handlers), 1) # 定义了1个 socket， 另一个端口由于父级已经包含，不再重复发
        self.assertEqual(my2_handlers[0].host, remote_host)
        self.assertEqual(my2_handlers[0].port, port2)
        self.assertEqual(my2_handlers[0].level, log_util.INFO)

        # 多次定义测试
        log_util.init(log_file=None, level=log_util.DEBUG, socket_host=remote_host, socket_port=[port1, port2], logger_name='tasks.my2', log_max=0)
        my2_handlers = [h for h in my2_logger.handlers if type(h) is log_util.SocketHandler]
        self.assertEqual(len(my2_handlers), 2) # 定义了2个 socket， 父级的级别高，这里需要继续发
        self.assertEqual(my2_handlers[0].host, remote_host)
        self.assertEqual(my2_handlers[0].level, log_util.DEBUG)
        self.assertEqual(my2_handlers[1].host, remote_host)
        self.assertEqual(my2_handlers[0].level, log_util.DEBUG)
        self.assertEqual(set([my2_handlers[0].port, my2_handlers[1].port]), set([port1, port2]))


    # init 定义多个 socket 测试
    def test_remove_screen(self):
        # 去掉屏幕输出
        log_util.init(log_file=logfile, level='DEBUG', remove_screen=True)
        log_util.init(log_file=logfile, level='DEBUG', remove_screen=True, logger_name='test_remove1')

        root_logger = logging.getLogger()
        root_handlers = [h for h in root_logger.handlers if type(h) is logging.StreamHandler]
        self.assertEqual(len(root_handlers), 0)

        tasks_logger = log_util.getLogger('test_remove1')
        tasks_handlers = [h for h in tasks_logger.handlers if type(h) is logging.StreamHandler]
        self.assertEqual(len(tasks_handlers), 0)

        # 加上屏幕输出
        log_util.init(log_file=logfile, level='DEBUG', remove_screen=False)
        log_util.init(log_file=logfile, level='DEBUG', remove_screen=False, logger_name='test_remove1')

        root_logger = logging.getLogger()
        root_handlers = [h for h in root_logger.handlers if type(h) is logging.StreamHandler]
        self.assertEqual(len(root_handlers), 1)

        tasks_logger = log_util.getLogger('test_remove1')
        tasks_handlers = [h for h in tasks_logger.handlers if type(h) is logging.StreamHandler]
        self.assertEqual(len(tasks_handlers), 0) # 子日志不会加上，只有 root 才会



if __name__ == "__main__":
    unittest.main()

