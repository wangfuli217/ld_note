#!python
# -*- coding:utf-8 -*-
'''
公用函数(日志处理)
Created on 2014/7/16
Updated on 2016/8/17
@author: Holemar

使用范例：
    log_util.init(log_file='./logs/run.log', level=False, backupCount=30) # 初始化

    # log_util 打印日志跟 logging 一样用法
    log_util.debug(u'写日志的内容。。。') # 普通的日志写入
    logging.debug(u'写日志的内容。。。') # 使用原始的 logging 输出普通日志，跟用这文件的一样。 上面一句跟这句输出完全相同。

    log_util.debug({'a':1, 'b':[1,2,3]}) # 可写入任意类型,自动转存字符串

    log_util.info(u'请求url:%s, 参数:%s', 'http://xxx', {'a':1, 'b':'测'})
    log_util.debug(u'请求url:%(url)s, 返回:%(result)s', {'url':'http://xxx', 'result':112})

    # 输出带颜色的日志
        1.使用中括号括起来,里面写上颜色名称,颜色截止位置需要有收标签,类型 html 标签那样
        2.目前仅支持 black(黑色),red(红色),green(绿色),yellow(黃色),blue(蓝色),fuchsia(紫红色),cyan(青蓝色),white(白色)
        3.颜色标签，不支持内嵌
    # 正常用法
        log_util.info(u'其它内容[red]红色显示的内容[/red]其它内容', extra={'color':True})
        logging.info(u'其它内容[red]红色显示的内容[/red]其它内容', extra={'color':True})
    # 错误的写法(不支持内嵌)
        log_util.info(u'其它内容[red]红色显示的内容[green]绿色内嵌内容[/green]红色显示的内容[/red]其它内容', extra={'color':True})
    # 正确的多个颜色写法
        logging.info(u'其它内容[red]红色显示的内容[/red][green]绿色内嵌内容[/green][red]红色显示的内容[/red]其它内容', extra={'color':True})

注：使用多个 logger_name 时，请先 init 父级 logger_name 再 init 子级的，以免重复写日志文件或者发 socket
'''
import sys, os, string
import logging
from logging import _levelNames
from logging.handlers import SocketHandler
from logging.handlers import TimedRotatingFileHandler as fileHandler

# 方便外部把此文件当成 logging 调用
from logging import CRITICAL, FATAL, ERROR, WARNING, WARN, INFO, DEBUG, NOTSET
from logging import log, debug, info, warn, warning, error, exception, critical, fatal

from . import str_util


__all__=('init', 'log', 'debug', 'info', 'warn', 'warning', 'error', 'exception', 'critical')


# 预设 log 输出格式
format_str = "[%(asctime)s] [%(module)s.%(funcName)s:%(lineno)s] %(levelname)s: %(message)s"
logging.basicConfig(level=logging.INFO, format=format_str)

CONFIG = {
    #'log_file' : './logs/run.log', # {string} 日志文件的名称(为空则屏幕输出日志)
    'append' :True, # {bool} 是否追加日志，默认为 True (追加到旧日志文件后面)， 设置为 False 时会先删除旧日志文件
    'level' : 'INFO', # {bool | string} 日志级别,默认级别:INFO
                             # (为布尔值时True:DEBUG, False:INFO,为字符串时可选值为:"NOTSET"/"DEBUG"/"INFO"/"WARNING"/"ERROR"/"CRITICAL")
    'backupCount' : 30, # {int} 日志文件保留天数
    #'socket_host' : None, # {string} 把日志发往远程机器的ip/host(为空则不发)
    #'socket_port' : 0, # {int} 把日志发往远程机器的端口号(有 socket_host 参数时才会启用)
    'log_max' : 3996, # {int} 日志长度限制,此值为当条输出日志的最大长度(超出部分会被截取), 设为0则不限制大小，因为日志超过 4000 容易出问题
    'to_read': False, # {bool} 是否要将字符串转码成便于人阅读的编码(将 “\u65f6”,“\xE5\x8C\x85”等字符转为人可以阅读的文字), 默认不转换
    'color': False, # {bool} 是否输出有颜色的日志(颜色得按这里的规则指定), 默认不使用
    'format': format_str, # {string} 日志输出格式
    'remove_screen': False, # {bool} 是否去掉屏幕输出的日志, 默认不去除
}


class StringFilter(logging.Filter):
    '''用于修改日志的字符串'''

    def __init__(self, name='', **kwargs):
        super(StringFilter, self).__init__(name=name)
        global CONFIG
        self.log_max = kwargs.get('log_max', CONFIG.get('log_max', 0))
        self.to_read = kwargs.get('to_read', CONFIG.get('to_read', False))
        self.color = kwargs.get('color', CONFIG.get('color', False))

    def filter(self, record):
        msg = record.msg
        if not isinstance(msg, basestring):
            try:
                msg = unicode(str_util.deep_str(msg))
            except UnicodeError:
                msg = msg      #Defer encoding till later
        if isinstance(msg, basestring):
            try:
                # 转码后，再拼接参数，保证拼接不会因为编码问题报错
                msg = str_util.to_unicode(msg)
                to_read = getattr(record, 'to_read', self.to_read)
                log_max = getattr(record, 'log_max', self.log_max)
                if record.args:
                    max_args = (log_max / 2) if isinstance(log_max, (int,long,float)) else 0
                    try:
                        msg = msg % str_util.deep_str(record.args, max=max_args, str_unicode=str_util.to_str)
                        record.args = ()
                    except TypeError, e:
                        error_msg = change_color(u'[red]日志参数传递错误[/red], %s, 参数:%s')
                        logging.error(error_msg, msg, record.args, exc_info=True)
                        return False # 报异常就别再打印此日志了
                # 是否将日志展现为便于阅读的模式 / 日志长度限制
                if to_read or log_max:
                    msg = str_util.to_unicode(msg, to_read=to_read, max=log_max)
                #是否输出有颜色的日志
                if getattr(record, 'color', self.color):
                    msg = change_color(msg)
            # 捕获未知错误，有可能日志里包含二进制、错误编码等
            except:
                return False # 报异常就别再打印此日志了
        # 字符串处理完毕
        record.msg = msg
        return True


def init(**kwargs):
    '''
    @summary: 初始化日志
    @param {string} log_file: 日志文件的名称(为空则屏幕输出日志)
    @param {string} logger_name: 指定日志名称(默认为 root)
    @param {bool} append: 是否追加日志，默认为 True (追加到旧日志文件后面)， 设置为 False 时会先删除旧日志文件
    @param {bool | string} level: 日志级别,默认级别:INFO
                           (为布尔值时表示是否debug模式,True:DEBUG, False:INFO,为字符串时可选值为:"NOTSET"/"DEBUG"/"INFO"/"WARNING"/"ERROR"/"CRITICAL")
    @param {int} backupCount: 日志文件保留天数
    @param {string} socket_host: 把日志发往远程机器的ip/host(为空则不发)
    @param {int | list<int>} socket_port: 把日志发往远程机器的端口号，或者端口号列表(有 socket_host 参数时才会启用)
    @param {int} log_max: 单条日志长度限制(超出部分截取,设为0则不限制)
    @param {bool} to_read: 是否要将字符串转码成便于人阅读的编码(将 “\u65f6”,“\xE5\x8C\x85”等字符转为人可以阅读的文字), 默认不转换
    @param {bool} color: 是否输出有颜色的日志(颜色得按这里的规则指定)
                         目前仅支持 black(黑色),red(红色),green(绿色),yellow(黃色),blue(蓝色),fuchsia(紫红色),cyan(青蓝色),white(白色)
    @param {string} format: 日志输出格式
    @param {bool} remove_screen: 是否去掉屏幕输出的日志, 默认不去除
    '''
    global CONFIG
    logger_name = kwargs.get('logger_name', None)
    # root 日志时，保存到全局
    if not logger_name:
        CONFIG.update(kwargs)
    log_file = kwargs.get('log_file', None)
    append = kwargs.get('append', CONFIG.get('append', True))
    level = kwargs.get('level', CONFIG.get('level', 'INFO'))
    backupCount = kwargs.get('backupCount', CONFIG.get('backupCount', 30))
    socket_host = kwargs.get('socket_host', None)
    socket_port = kwargs.get('socket_port', 0)
    format = kwargs.get('format', CONFIG.get('format', format_str))
    remove_screen = kwargs.get('remove_screen', CONFIG.get('remove_screen', False))

    # logging提供多种级别的日志信息，如: NOTSET(值为0), DEBUG(10), INFO(20), WARNING(默认值30), ERROR(40), CRITICAL(50)等。每个级别都对应一个数值。
    logger = getLogger(logger_name, add_parent_filter=False)
    # 设置log级别
    logger_level = logging.INFO
    if level == True:
        logger_level = logging.DEBUG
    #传入字符串时的log级别
    elif isinstance(level, basestring):
        level = str(level).strip().upper()
        log_level = _levelNames.get(level, logging.INFO)
        logger_level = log_level
    # 传入 int 类型，则可以直接设置级别
    elif isinstance(level, (int, long)):
        logger_level = level
    else:
        logger_level = logging.INFO
    # 添加日志字符串过滤器(本过滤器已经添加过的话就先去掉，避免多次过滤字符串)
    logger_name = logger_name or ''
    logger.filters[:] = [filter for filter in logger.filters if not isinstance(filter, StringFilter)]
    logger.addFilter(StringFilter(name=logger_name, **kwargs))
    if logger_name:
        logger.setLevel(logger_level)
    # 设置log格式
    #formatter = logging.Formatter(format, '%d %H:%M:%S') # 为了显示毫秒数,最好不要自己另外设置日期格式,一旦设置就显示不出了
    formatter = logging.Formatter(format)
    # 去掉屏幕输出日志，提高效率
    remove_stream_handler(remove_screen, logger, level)
    # 发送socket日志
    add_socket_handler(socket_host, socket_port, logger_level, logger)
    # 设置log文件
    add_file_handler(log_file, logger_level, append, backupCount, formatter, logger)


def remove_stream_handler(remove_screen, logger, level=False):
    '''
    去掉屏幕日志输出(可提高效率)
    '''
    # debug 级别的,输出两份日志,屏幕上输出一份,日志文件也输出一份。其它级别的日志则直接去掉屏幕输出，以提高效率。
    #remove_screen = remove_screen or level not in (True, 'NOTSET', 'DEBUG', logging.NOTSET, logging.DEBUG)
    if remove_screen:
        #logger.handlers[:] = [handler] # 这样会把其它方式的日志处理给删除掉
        logger.handlers[:] = [h for h in logger.handlers if not type(h) is logging.StreamHandler] # 去掉屏幕输出日志，让效率更高
    else:
        # 加上屏幕日志(root日志时，且没有屏幕日志，才会加)
        if (not logger.name or logger.name == 'root') and not [h for h in logger.handlers if type(h) is logging.StreamHandler]:
            logger.addHandler(logging.StreamHandler())


def add_socket_handler(socket_host, socket_ports, level, logger):
    '''
    给 logger 加上 socket 日志处理
    @param {string} socket_host: 把日志发往远程机器的ip/host(为空则不发)
    @param {int | list<int>} socket_ports: 把日志发往远程机器的端口号，或者端口号列表(有 socket_host 参数时才会启用)
    @param {bool | string} level: 日志级别,默认级别:INFO
    @param {logging.Logger} logger: 指定日志实例(SocketHandler 会加入到这个 logger 里面)
    '''
    if not socket_host or not socket_ports: return

    socket_ports = [socket_ports] if isinstance(socket_ports, (int, long)) else socket_ports
    for socket_port in socket_ports:
        # 先移除旧的同socket处理器，省去修改旧处理器的麻烦
        logger.handlers[:] = [h for h in logger.handlers if not (type(h) is SocketHandler and h.host == socket_host and h.port == socket_port)]
        # 如果父级已经发了同一份socket日志，则没必要再发同样内容(避免同一个日志重复两次)
        parent_name = logger.name
        parent_handlers = []
        while parent_name.rfind('.') > 0:
            parent_name = parent_name[:parent_name.rfind('.')]
            parent_logger = getLogger(parent_name, add_parent_filter=False)
            parent_handlers.extend([h for h in parent_logger.handlers if type(h) is SocketHandler and h.host == socket_host and h.port == socket_port and h.level <= level])
            if parent_handlers: break
        else:
            parent_handlers.extend([h for h in logging.root.handlers if type(h) is SocketHandler and h.host == socket_host and h.port == socket_port and h.level <= level])
        if not parent_handlers:
            # 如果父级没有重复日志，则添加本级日志处理器
            handler = SocketHandler(socket_host, socket_port)
            handler.setLevel(level)
            logger.addHandler(handler)


def add_file_handler(log_file, logger_level, append, backupCount, formatter, logger):
    '''
    给 logger 加上 文件 日志处理
    @param {string} log_file: 日志文件的名称
    @param {bool | string} logger_level: 日志级别,默认级别:INFO
    @param {bool} append: 是否追加日志，默认为 True (追加到旧日志文件后面)， 设置为 False 时会先删除旧日志文件
    @param {int} backupCount: 日志文件保留天数
    @param {logging.Formatter} formatter: 日志输出格式
    @param {logging.Logger} logger: 指定日志实例(SocketHandler 会加入到这个 logger 里面)
    '''
    if not log_file: return

    logger.setLevel(logger_level)
    log_file = os.path.abspath(log_file)
    log_path = os.path.dirname(log_file)
    # 没有日志文件的目录，则先创建目录，避免因此报错
    if not os.path.isdir(log_path):
        os.makedirs(log_path)
    # 不追加日志，则先清空旧日志文件
    if append == False and os.path.isfile(log_file):
        try:
            open(log_file, mode="w").close()
        except:
            os.popen('echo""> "%s"' % log_file)
    # 先移除旧的同一文件处理器，省去修改旧处理器的麻烦
    logger.handlers[:] = [h for h in logger.handlers if not (type(h) is fileHandler and h.baseFilename == log_file)]
    # 如果父级已经写了同一份日志文件，则没必要再写(避免同一个日志重复两次)
    parent_name = logger.name
    parent_handlers = []
    while parent_name.rfind('.') > 0:
        parent_name = parent_name[:parent_name.rfind('.')]
        parent_logger = getLogger(parent_name, add_parent_filter=False)
        parent_handlers.extend([h for h in parent_logger.handlers if type(h) is fileHandler and h.baseFilename == log_file and h.level <= logger_level])
        if parent_handlers: break
    else:
        parent_handlers.extend([h for h in logging.root.handlers if type(h) is fileHandler and h.baseFilename == log_file and h.level <= logger_level])
    if not parent_handlers:
        # 如果父级没有重复日志，则添加本级日志处理器
        handler = fileHandler(log_file, when='midnight', backupCount=backupCount)
        handler.setFormatter(formatter)
        handler.setLevel(logger_level)
        logger.addHandler(handler)


def change_color(msg):
    '''
    @summary: 转换日志内容的颜色
    @param {string} msg: 日志内容
    这里是简单替换而输出 linux 系统上的有颜色日志内容
    颜色作下列限制:
    1.使用中括号括起来,里面写上颜色名称,颜色截止位置需要有收标签,类型 html 标签那样
    2.目前仅支持 black(黑色),red(红色),green(绿色),yellow(黃色),blue(蓝色),fuchsia(紫红色),cyan(青蓝色),white(白色)
    3.颜色标签，不支持内嵌
    使用范例: msg = change_color(u'默认颜色的内容[red]红色显示的内容[/red]默认颜色的内容')
    '''
    # 没有颜色设置时，直接返回
    if '[' not in msg or '[/' not in msg or ']' not in msg:
        return msg
    # 只有 黑色 和 蓝色 设置为白底色，其它颜色设置为黑底色
    msg = msg.replace('[black]', '\033[7;30;47m') # 30:黑色(白底色)
    msg = msg.replace('[red]', '\033[1;31;40m') # 31:红色
    msg = msg.replace('[green]', '\033[1;32;40m') # 32:绿色
    msg = msg.replace('[yellow]', '\033[1;33;40m') # 33:黃色
    msg = msg.replace('[blue]', '\033[1;34;47m') # 34:蓝色(白底色)
    msg = msg.replace('[fuchsia]', '\033[1;35;40m') # 35:紫红色
    msg = msg.replace('[cyan]', '\033[1;36;40m') # 36:青蓝色
    msg = msg.replace('[white]', '\033[1;37;40m') # 37:白色
    # 结束符(所有颜色的结束符都一样)
    end = '\033[0m'
    #msg = re.sub(r'\[/((black)|(red)|(green)|(yellow)|(blue)|(fuchsia)|(cyan)|(white))\]', '\033[0m', msg) # 为了提高效率，避免使用正则
    msg = msg.replace('[/black]', end).replace('[/red]', end).replace('[/green]', end)
    msg = msg.replace('[/yellow]', end).replace('[/blue]', end).replace('[/fuchsia]', end)
    msg = msg.replace('[/cyan]', end).replace('[/white]', end)
    return msg


# 其中调用时的变量 _srcfile 是这样
if hasattr(sys, 'frozen'): #support for py2exe
    _srcfile = "libs_my%slog_util%s" % (os.sep, __file__[-4:])
elif string.lower(__file__[-4:]) in ('.pyc', '.pyo'):
    _srcfile = __file__[:-4] + '.py'
else:
    _srcfile = __file__
_srcfile = os.path.normcase(_srcfile)

def _findCaller(self):
    u"""
    Find the stack frame of the caller so that we can note the source
    file name, line number and function name.
    返回被调用的 文件名、行号、函数名
    """
    rv = "(unknown file)", 0, "(unknown function)"
    try:
        f = logging.currentframe().f_back
        while hasattr(f, "f_code"):
            co = f.f_code
            filename = os.path.normcase(co.co_filename) # 被调用的文件名
            #if filename == _srcfile:
            if filename in (_srcfile, logging._srcfile):
                f = f.f_back
                continue
            rv = (filename, f.f_lineno, co.co_name)
            break
    except: # 多线程高并发时，会报错，这里捕获一下以免抛出去
        pass
    return rv

def getLogger(name=None, add_parent_filter=True):
    """
    Return a logger with the specified name, creating it if necessary.
    If no name is specified, return the root logger.
    获取 logger 的时候，给它加上父级的 StringFilter。
    因为这个文件就是靠这个 StringFilter 来处理日志字符串的，不加上则会让子 logger 的字符串处理不能生效。
    """
    if name:
        logger = logging.Logger.manager.getLogger(name)
        # 如果本 logger 里面没有 StringFilter，则取父级的
        if add_parent_filter and not [filter for filter in logger.filters if isinstance(filter, StringFilter)]:
            parent_name = name
            parent_filters = []
            while parent_name.rfind('.') > 0:
                parent_name = parent_name[:parent_name.rfind('.')]
                parent_logger = logging.Logger.manager.getLogger(parent_name)
                parent_filters.extend([filter for filter in parent_logger.filters if isinstance(filter, StringFilter)])
                if parent_filters: break
            else:
                parent_filters.extend([filter for filter in logging.root.filters if isinstance(filter, StringFilter)])
            logger.filters.extend(parent_filters)
        return logger
    else:
        return logging.root

# 修改 logging.Logger 的 findCaller 函数, 以便直接调用这文件的 info, error 等函数也可以获取到正确的模块名、函数名和行号
setattr(logging.Logger, 'findCaller', _findCaller)

# 修改 logging 的 getLogger 函数, 以便添加父级 StringFilter 给子 logger
setattr(logging, 'getLogger', getLogger)
