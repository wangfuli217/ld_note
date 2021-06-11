
logging 模块
    # 1. 直接使用 logging, 会受到前面对 logging 的设置的影响,默认情况下窗口显示
    import logging
    # logging提供多种级别的日志信息，如: NOTSET(值为0), DEBUG(10), INFO(20), WARNING(默认值30), ERROR(40), CRITICAL(50)等。每个级别都对应一个数值。
    logging.basicConfig(level=logging.INFO,
                format='%(asctime)s %(module)s.%(funcName)s %(lineno)s: %(levelname)s : %(message)s', # 日志显示格式
                datefmt='%Y-%m-%d %X', # 日期时间格式
                filename='log.log', # 日志会被存储在指定的文件中
                filemode='w', # 文件打开方式，在指定了filename时使用这个参数，默认值为“a”还可指定为“w”
                )
    logging.info('logging message')


    # 2. 按自己需要设置 log 后再使用
    def initlog():
        import logging
        logger = logging.getLogger() # 生成一个日志对象，可以带一个名字，可以缺省
        hdlr = logging.FileHandler('crawl.log') # 生成一个Handler。logging支持许多Handler，象FileHandler, SocketHandler, SMTPHandler等，我由于要写文件就使用了FileHandler。
        # 生成一个格式器，用于规范日志的输出格式。
        # 如果没有这行代码，那么缺省的格式就是："%(message)s"。也就是写日志时，信息是什么日志中就是什么，没有日期，没有信息级别等信息。
        # logging支持许多种替换值，详细请看Formatter的文档说明。这里有三项：时间，信息级别，日志信息。
        formatter = logging.Formatter('%(asctime)s %(levelname)s: %(message)s')
        hdlr.setFormatter(formatter) # 将格式器设置到处理器上

        #logger.addHandler(hdlr) # 将处理器加到日志对象上
        # 上面使用 addHandler 会有两份日志输出,一份输出到文件(新加的 handler),一份输出到屏幕(默认的 handler)。
        logger.handlers = [hdlr] # 这样写则只有一份日志输出,消耗更少、效率更高。

        # 设置日志信息输出的级别。如果不执行此句，缺省为30(WARNING)。
        # 可以执行：logging.getLevelName(logger.getEffectiveLevel())来查看缺省的日志级别。日志对象对于不同的级别信息提供不同的函数进行输出,如:info(), error(), debug()等。
        # 当写入日志时，小于指定级别的信息将被忽略。因此为了输出想要的日志级别一定要设置好此参数。这里我设为NOTSET（值为0），也就是想输出所有信息。
        logger.setLevel(logging.NOTSET)
        return logger

    # 使用日志对象：
    logger = initlog()
    logger.info('message info')
    logger.error('message error')


logging介绍
    Python的 logging 模块提供了通用的日志系统，可以方便第三方模块或者是应用使用。
    这个模块提供不同的日志级别，并可以采用不同的方式记录日志，比如文件，HTTP GET/POST，SMTP，Socket等，甚至可以自己实现具体的日志记录方式。

    logging模块与log4j的机制是一样的，只是具体的实现细节不同。模块提供logger，handler，filter，formatter。
    logger：提供日志接口，供应用代码使用。
    logger最常用的操作有两类：配置和发送日志消息。
    可以通过logging.getLogger(name)获取logger对象，如果不指定name则返回root对象，多次使用相同的name调用getLogger方法返回同一个logger对象。

    handler：将日志记录（log record）发送到合适的目的地（destination），比如文件，socket等。
    一个logger对象可以通过addHandler方法添加0到多个handler，每个handler又可以定义不同日志级别，以实现日志分级过滤显示。
    filter：提供一种优雅的方式决定一个日志记录是否发送到handler。
    formatter：指定日志记录输出的具体格式。formatter的构造方法需要两个参数：消息的格式字符串和日期字符串，这两个参数都是可选的。
    与log4j类似，logger，handler和日志消息的调用可以有具体的日志级别（Level），只有在日志消息的级别大于logger和handler的级别。

    示例(log_test.py 文件)：
        import logging
        import logging.handlers

        LOG_FILE = 'tst.log'

        # 注意,按大小拆分、按时间拆分,是两个不同的 handler 类
        handler = logging.handlers.RotatingFileHandler(LOG_FILE, maxBytes = 1024*1024, backupCount = 5) # 实例化handler,文件到达一定大小时拆分
        handler = logging.handlers.TimedRotatingFileHandler(LOG_FILE, when='midnight', backupCount = 10) # 凌晨时拆分log文件，以免文件太大
        # 上面的 backupCount参数 用于指定保留的log备份文件的个数,如写 10 表示最多保留 10 个 log备份文件
        fmt = '%(asctime)s - %(filename)s:%(lineno)s - %(name)s - %(message)s'

        formatter = logging.Formatter(fmt)   # 实例化formatter
        handler.setFormatter(formatter)      # 为handler添加formatter

        logger = logging.getLogger('tst')    # 获取名为tst的logger
        logger.addHandler(handler)           # 为logger添加handler
        logger.setLevel(logging.DEBUG)

        logger.info('first info message')    # 输出到 log 文件
        logger.debug('first debug message')

    输出结果：
        2012-03-04 23:21:59,682 - log_test.py:16 - tst - first info message
        2012-03-04 23:21:59,682 - log_test.py:17 - tst - first debug message


关于 formatter 的配置，采用的是%(<dict key>)s的形式，就是字典的关键字替换。提供的关键字包括：
      Format	                Description
    %(name)s	            Logger 的名字。 Name of the logger (logging channel).
    %(levelno)s	            数字形式的日志级别。 Numeric logging level for the message (DEBUG, INFO, WARNING, ERROR, CRITICAL).
    %(levelname)s	        文本形式的日志级别。 Text logging level for the message ('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL').
    %(pathname)s	        调用日志输出函数的模块的完整路径名，可能没有。 Full pathname of the source file where the logging call was issued (if available).
    %(filename)s	        调用日志输出函数的模块的文件名。 Filename portion of pathname.
    %(module)s	            调用日志输出函数的模块名。 Module (name portion of filename).
    %(funcName)s	        调用日志输出函数的函数名。 Name of function containing the logging call.
    %(lineno)d	            调用日志输出函数的语句所在的代码行。 Source line number where the logging call was issued (if available).
    %(created)f	            当前时间，用UNIX标准的表示时间的浮点数表示。 Time when the LogRecord was created (as returned by time.time()).
    %(relativeCreated)d	    输出日志信息时的，自Logger创建以来的毫秒数。 Time in milliseconds when the LogRecord was created, relative to the time the logging module was loaded.
    %(asctime)s	            字符串形式的当前时间。默认格式是“2003-07-08 16:49:45,896”。逗号后面的是毫秒。 Human-readable time when the LogRecord was created.
                            By default this is of the form “2003-07-08 16:49:45,896” (the numbers after the comma are millisecond portion of the time).
    %(msecs)d	            Millisecond portion of the time when the LogRecord was created.
    %(thread)d	            线程ID。可能没有。 Thread ID (if available).
    %(threadName)s	        线程名。可能没有。 Thread name (if available).
    %(process)d	            进程ID。可能没有。 Process ID (if available).
    %(message)s	            用户输出的消息。 The logged message, computed as msg % args.
    这个是摘自官网，提供了很多信息。


日志的格式化字符串
    # 用 logging 提供的格式化
    logging.warning('name:%s msg:%s','BeginMan','Hi')                                  #方式一
    logging.warning('name:%(who)s msg:%(what)s', {'who':'BeginMan', 'what':'Hi'})      #方式二
    # 用 字符串 提供的格式化
    logging.warning('name:%s msg:%s' %('BeginMan','Hi'))                               #方式三
    logging.warning('name:{0} msg:{1}'.format('BeginMan','Hi'))                        #方式四
    logging.warning('name:{who} msg:{what}'.format(who='BeginMan',what='Hi'))          #方式五
    logging.warning('name:%(who)s msg:%(what)s' % {'who':'BeginMan', 'what':'Hi'})     #方式六
    # 导入格式化的库
    from string import Template                                                        #方式七
    msg = Template('name:$who msg:$what')
    logging.warning(msg.substitute(who='BeginMan',what='Hi'))
    #推荐使用方式一或者二，因为其它几种可能会导致报错(字符串格式化错误)，而这种报错的话会影响后面执行(除非你捕获了，而一般不会每次写日志都捕获一下)。
    #方式一或者二的写法，一旦发生字符串格式化错误，会由logging自行捕获错误，不影响后面的执行


logging的配置
    logging的配置可以采用python代码或是配置文件。
    python代码的方式就是在应用的主模块中，构建handler，handler，formatter等对象。
    而配置文件的方式是将这些对象的依赖关系分离出来放在文件中。比如前面的例子就类似于python代码的配置方式。

    示例(采用配置文件的方式)：
        import logging
        import logging.config

        logging.config.fileConfig("logging.conf")    # 采用配置文件

        # create logger
        logger = logging.getLogger("simpleExample")  # 获取名为 simpleExample 的 logger, 对应配置文件的 [logger_simpleExample]

        # "application" code
        logger.debug("debug message")
        logger.info("info message")
        logger.warn("warn message")
        logger.error("error message")
        logger.critical("critical message")

    配置文件 logging.conf 的内容:
        [loggers]
        keys=root,simpleExample

        [handlers]
        keys=consoleHandler

        [formatters]
        keys=simpleFormatter

        [logger_root]
        level=DEBUG
        handlers=consoleHandler

        [logger_simpleExample]
        level=DEBUG
        handlers=consoleHandler
        qualname=simpleExample
        propagate=0

        [handler_consoleHandler]
        class=StreamHandler
        level=DEBUG
        formatter=simpleFormatter
        args=(sys.stdout,)

        [formatter_simpleFormatter]
        format=%(asctime)s - %(name)s - %(levelname)s - %(message)s
        datefmt=

    loggin.conf采用了模式匹配的方式进行配置，正则表达式是r'^[(.*)]$'，从而匹配出所有的组件。
    对于同一个组件具有多个实例的情况使用逗号','进行分隔。
    对于一个实例的配置采用componentName_instanceName配置块。
    使用这种方式还是蛮简单的。

    在指定handler的配置时，class是具体的handler类的类名，可以是相对logging模块或是全路径类名，比如需要RotatingFileHandler，则class的值可以为: RotatingFileHandler 或者logging.handlers.RotatingFileHandler 。
    args就是要传给这个类的构造方法的参数，就是一个元组，按照构造方法声明的参数的顺序。

     这里还要明确一点，logger对象是有继承关系的，比如名为a.b和a.c的logger都是名为a的子logger，并且所有的logger对象都继承于root。
     如果子对象没有添加handler等一些配置，会从父对象那继承。这样就可以通过这种继承关系来复用配置。


多模块使用 logging
    logging模块保证在同一个python解释器内，多次调用logging.getLogger('log_name')都会返回同一个logger实例，即使是在多个模块的情况下。
    所以典型的多模块场景下使用logging的方式是在main模块中配置logging，这个配置会作用于多个的子模块，然后在其他模块中直接通过getLogger获取Logger对象即可。

    示例:
    配置文件 logging.conf 的内容:
        [loggers]
        keys=root,main

        [handlers]
        keys=consoleHandler,fileHandler

        [formatters]
        keys=fmt

        [logger_root]
        level=DEBUG
        handlers=consoleHandler

        [logger_main]
        level=DEBUG
        qualname=main
        handlers=fileHandler

        [handler_consoleHandler]
        class=StreamHandler
        level=DEBUG
        formatter=fmt
        args=(sys.stdout,)

        [handler_fileHandler]
        class=logging.handlers.RotatingFileHandler
        level=DEBUG
        formatter=fmt
        args=('tst.log','a',20000,5,)

        [formatter_fmt]
        format=%(asctime)s - %(name)s - %(levelname)s - %(message)s
        datefmt=

    主模块 main.py 的内容：
        import logging
        import logging.config

        logging.config.fileConfig('logging.conf')
        root_logger = logging.getLogger('root')
        root_logger.debug('test root logger...')

        logger = logging.getLogger('main')
        logger.info('test main logger')
        logger.info('start import module \'mod\'...')
        import mod

        logger.debug('let\'s test mod.testLogger()')
        mod.testLogger()

        root_logger.info('finish test...')

    子模块 mod.py 的内容：
        import logging
        import submod

        logger = logging.getLogger('main.mod')
        logger.info('logger of mod say something...')

        def testLogger():
            logger.debug('this is mod.testLogger...')
            submod.tst()

    子子模块 submod.py 的内容：
        import logging

        logger = logging.getLogger('main.mod.submod')
        logger.info('logger of submod say something...')

        def tst():
            logger.info('this is submod.tst()...')

    运行python main.py，控制台输出所有log信息
    但 tst.log 中没有root logger输出的信息，因为logging.conf中配置了只有main logger及其子logger使用RotatingFileHandler，而root logger是输出到标准输出。



出错时发邮件
    import os
    import logging
    import logging.handlers

    def init_log(logfile, backupCount, debug=True):
        '''初始化日志'''
        log_path = os.path.dirname(logfile)
        if not os.path.isdir(log_path):
            os.makedirs(log_path)

        logger = logging.getLogger()
        formatter = logging.Formatter("[%(asctime)s]: %(module)s %(levelname)s %(message)s ")

        # 文件 log 输出
        #handler_record = logging.FileHandler(logfile)
        handler_record = logging.handlers.TimedRotatingFileHandler(logfile, when='midnight', backupCount=backupCount)
        handler_record.setFormatter(formatter)
        logger.addHandler(handler_record)
        if debug:
            logger.setLevel(logging.DEBUG)
            handler_record.setLevel(logging.DEBUG)
        else:
            logger.setLevel(logging.WARNING)
            handler_record.setLevel(logging.WARNING)

        # 邮件 log 输出
        handler_email = logging.handlers.SMTPHandler(
                        "mail.guoling.com", # 邮件服务器
                        "backend_program@guoling.com", # 发出邮件的地址
                        "fengwanli@guoling.com", # 接收邮件的地址。 发给多个人则用列表(如：['292598441@qq.com','fengwanli@guoling.com']),用字符串则只发给第一个
                        "test email logging", # 邮件主题
                        ("backend_program@guoling.com", "guoling") # 凭证(CREDENTIALS)
                        )
        handler_email.setFormatter(formatter)
        handler_email.setLevel(logging.ERROR)
        email_logger = logging.getLogger('email') # 定义发邮件的 logger
        email_logger.addHandler(handler_email)
        email_logger.setLevel(logging.ERROR)

        # http 的 log 输出
        http_handler = logging.handlers.HTTPHandler('127.0.0.1:3333','/log/', method='GET')
        http_handler.setFormatter(formatter)
        http_handler.setLevel(logging.ERROR)


    # 调用 logger
    init_log('./log/run.log', 30, False) # 初始化
    #os.remove('./log/run.log')

    logging.error(u"logging.error 测试。。。") # 普通的 log,写到文件上

    email_logger = logging.getLogger('email') # 需要发邮件的 log
    msg = "email_logger.error gbk 测试 2..."
    msg = msg.decode(sys.stdin.encoding).encode('gbk') # 处理中文,让 foxmail 显示正常
    email_logger.error(msg) # 会发出邮件,并且也写到文件上




第三方模块 mlogging
====================================
https://pypi.python.org/pypi/mlogging/

使用好处:
    发起多线程写log，性能优化

缺点:
    windows 下貌似不能用
    多进程下虽然可以用，但是会在日志文件分割时卡死系统(看并发量，量低时不卡，量高时卡死)


安装:
    # linux 下 easy_install
    sudo easy_install mlogging
