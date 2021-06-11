#!python
# -*- coding:utf-8 -*-
'''
公用函数(获取启动参数)
Created on 2014/7/22
Updated on 2016/2/16
@author: Holemar
'''
import sys
from optparse import OptionParser

__all__=('get', 'get_args')


def get(version, port=8080, logfile='./logs/run_%s.log', backupCount=30, master=False, debug=False, **kwargs):
    '''
    @summary: 获取启动参数
    @param {string} version: 查看版本号时的返回值
    @param {int} port: 默认的端口号(只有启动时没有传这参数,才会返回这个默认值。如果启动时有传参数则返回启动时的参数值)
    @param {string} logfile: 默认的日志文件路径及文件名
    @param {int} backupCount: 默认的日志文件保留天数
    @param {bool} master: 是否主进程
    @param {bool} debug: 是否调试模式
    @return {object}:
        # 如果启动命令行没有传这些参数则返回默认值
        options.port: 启动时设置的端口号
        options.logfile: 启动时设置的日志文件路径和文件名
        options.backupCount: 启动时设置的日志文件保留天数
        options.master: 启动时设置的这进程是否主进程
        options.debug: 启动时设置的是否调试模式
    '''
    parser = OptionParser(usage="usage: python %prog [options] filename", version=version)
    parser.add_option("-p", "--port",  action="store",  type="int", dest="port",  default=port,  help="Listen Port")
    parser.add_option("-f", "--logfile",  action="store",  type="string",  dest="logfile",  default=logfile, help="LogFile Path and Name. default=./logs/run_8080.log")
    parser.add_option("-n", "--backupCount",  action="store",  type="int",  dest="backupCount",  default=backupCount,  help="LogFile BackUp Number")
    parser.add_option("-m", "--master", action="store_true", dest="master",  default=master,  help="master process")
    parser.add_option("-d", "--debug", action="store_true", dest="debug", default=debug, help="debug mode")
    options = parser.parse_args()[0]
    # 日志文件名加上端口号
    filename = options.logfile
    if '%s' in filename:
        options.logfile = filename % options.port
    return options

def get_args():
    '''
    @summary: 获取调用文件的命令行参数
    @return {dict}: 讲命令行参数里面带“-”开头的参数用字典返回
        如: python run.py -p1314 -v 1.5.2 -d --config 'config.py' aa
        返回: {'p':'1314', 'v':'1.5.2', 'd':True, 'config':'config.py'}
    '''
    res = {}
    arg_list = sys.argv
    length = len(arg_list)
    for i in range(length):
        arg = arg_list[i]
        # 只获取“-”和“--”开头的参数
        if arg.startswith('-'):
            arg = arg[1:]
            # “-”开头的参数,参数名只能是 1 位,其余是值
            if len(arg) > 1 and not arg.startswith('-'):
                value = arg[1:]
                arg = arg[0]
                res[arg] = value
                continue
            # “--”开头的参数
            if arg.startswith('-'):
                arg = arg[1:]
            # 参数的下一位，认为是值
            value = arg_list[i+1] if i < length-1 else True
            if isinstance(value, basestring):
                # 值有可能用引号括起来,需去掉引号
                if value.startswith("'") or value.startswith('"'):
                    value = value[1:]
                if value.endswith("'") or value.endswith('"'):
                    value = value[:-1]
                # “-”和“--”开头的,认为是一下个参数,而不是当前参数的值
                if value.startswith('-'):
                    value = True
            res[arg] = value
    return res


if __name__ == '__main__':
#    p = get(version='app_mobile 1.2.5', default_port=7999)
#    print p
#    print p.debug
#    print p.port
#    print

    print get_args()
