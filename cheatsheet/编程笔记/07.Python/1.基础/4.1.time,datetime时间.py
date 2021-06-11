datetime模块定义了下面这几个类：
datetime.date：表示日期的类。常用的属性有year, month, day
    class datetime.date(year, month, day)： # 对日期进行操作时,要防止日期超出它所能表示的范围。
    year的范围是[MINYEAR, MAXYEAR],即[1, 9999]
    month的范围是[1, 12]
    day的最大值根据给定的year, month参数来决定。例如闰年2月份有29天.

    date类定义一些常用的类方法与类属性l:
        date.max、date.min:date对象所能表示的最大、最小日期.     0001-01-01 -- 9999-12-31
        date.resolution: date对象表示日期的最小单位。            1 day, 0:00:00
        date.today():返回一个表示当前本地日期的date对象.         2017-10-22
        date.fromtimestamp(timestamp): 根据给定的时间戮,返回一个date对象.
        datetime.fromordinal(ordinal)：将Gregorian日历时间转换为date对象.
    date提供的实例方法和属性：
        date.year,date.month,date.day:年,月,日.
        date.replace(year, month, day)：生成一个新的日期对象,用参数指定的年,月,日代替原有对象中的属性。
        原有对象仍保持不变
        date.timetuple()： 返回日期对应的time.struct_time对象.
        date.toordinal()： 返回日期对应的Gregorian Calendar日期.
        date.weekday():    返回weekday,如果是星期一,返回0,如果是星期2,返回1,以此类推.
        data.isoweekday(): 返回weekday,如果是星期一,返回1,如果是星期2,返回2,以此类推.
        date.isocalendar():返回格式如(year,month,day)的元组;
        date.isoformat()： 返回格式如'YYYY-MM-DD' 的字符串;
        date.strftime(fmt)：自定义格式化字符串。
        date 还对某些操作进行了重载,它允许我们对日期进行如下一些操作：
        date2 = date1 + timedelta  # 日期加上一个间隔,返回一个新的日期对象（timedelta将在下面介绍,表示时间间隔）
        date2 = date1 - timedelta  # 日期隔去间隔,返回一个新的日期对象
        timedelta = date1 - date2  # 两个日期相减,返回一个时间间隔对象
        date1 < date2  # 两个日期进行比较
        
datetime.time：表示时间的类。常用的属性有hour, minute, second, microsecond
    class datetime.time(hour[ , minute[ , second[ , microsecond[ , tzinfo]]]] ) ：
    参数tzinfo,它表示时区信息。
    hour的范围为[0, 24),minute的范围为[0, 60),second的范围为[0, 60),microsecond的范围为[0, 1000000)。
    
    time类定义的类属性：
        time.min、time.max：time类所能表示的最小、最大时间。
        其中,time.min = time(0, 0, 0, 0), time.max = time(23, 59, 59, 999999).
        time.resolution：时间的最小单位,这里是1微秒.

    time类提供的实例方法和属性：
        time.hour、time.minute、time.second、time.microsecond：时、分、秒、微秒.
        time.tzinfo：时区信息.
        time.replace([ hour[ , minute[ , second[ , microsecond[ , tzinfo]]]]] )：创建一个新的时间对象,用参数指定的时、分、秒、微秒代替原有对象中的属性（原有对象仍保持不变）.
        time.isoformat()：返回型如"HH:MM:SS"格式的字符串表示.
        time.strftime(fmt)：返回自定义格式化字符串。
    像date一样,也可以对两个time对象进行比较,或者相减返回一个时间间隔对象。
    
datetime.datetime：表示日期时间。
    datetime.datetime (year, month, day[ , hour[ , minute[ , second[ , microsecond[ , tzinfo]]]]] )
    datetime类定义的类属性与方法：
        datetime.min、datetime.max：datetime所能表示的最小值与最大值；
        datetime.resolution：datetime最小单位；
        datetime.today()：返回一个表示当前本地时间的datetime对象；
        datetime.now([tz])：返回一个表示当前本地时间的datetime对象,如果提供了参数tz,则获取tz参数所指时区的本地时间；
        datetime.utcnow()：返回一个当前utc时间的datetime对象；
        datetime.fromtimestamp(timestamp[, tz])：根据时间戮创建一个datetime对象,参数tz指定时区信息；
        datetime.utcfromtimestamp(timestamp)：根据时间戮创建一个datetime对象；
        datetime.combine(date, time)：根据date和time,创建一个datetime对象；
        datetime.strptime(date_string, format)：将格式字符串转换为datetime对象；
    datetime类提供的实例方法与属性：
        datetime.year、month、day、hour、minute、second、microsecond、tzinfo：datetime.date()：获取date对象；
        datetime.time()：获取time对象；
        datetime.replace ([ year[ , month[ , day[ , hour[ , minute[ , second[ , microsecond[ , tzinfo]]]]]]]] )：
        datetime.timetuple()
        datetime.utctimetuple()
        datetime.toordinal()
        datetime.weekday()
        datetime.isocalendar()
        datetime.isoformat ([ sep] )
        datetime.ctime()：返回一个日期时间的C格式字符串,等效于time.ctime(time.mktime(dt.timetuple()))；
        datetime.strftime(format)
    
datetime.timedelta：表示时间间隔,即两个时间点之间的长度。
datetime.tzinfo：与时区有关的相关信息

# 打印时间
    import time,datetime
    print(time.strftime('%Y-%m-%d %H:%M:%S')) # time.strftime(format[, tuple]) 将指定的struct_time(默认为当前时间),根据指定的格式化字符串输出,打印如: 2011-04-13 18:30:10
    print(time.strftime('%Y-%m-%d %A %X', time.localtime(time.time()))) # 显示当前日期； 打印如: 2011-04-13 Wednesday 18:30:10
    print(time.strftime("%Y-%m-%d %A %X", time.localtime())) # 显示当前日期； 打印如: 2011-04-13 Wednesday 18:30:10
    print(time.time()) # 以浮点数形式返回自Linux新世纪以来经过的秒数； 打印如: 1302687844.7；  使用 time.localtime(time.time()) 可返转回 time 类型
    print(time.ctime(1150269086.6630149)) #time.ctime([seconds]) 把秒数转换成日期格式的字符串，如果不带参数，则显示当前的时间。打印如: Wed Apr 13 21:13:11 2011
    print(time.gmtime(1150269086.6630149)) # time.gmtime([seconds]) 将一个时间戳转换成一个UTC时区(0时区)的struct_time，如果seconds参数未输入，则以当前时间为转换标准
    print(time.gmtime()) # 打印如： time.struct_time(tm_year=2014, tm_mon=8, tm_mday=27, tm_hour=7, tm_min=28, tm_sec=19, tm_wday=2, tm_yday=239, tm_isdst=0)
    print(time.localtime(1150269086.6630149)) # time.localtime([seconds]) 将一个时间戳转换成一个当前时区的struct_time，如果seconds参数未输入，则以当前时间为转换标准
    print(time.mktime(time.localtime())) # time.mktime(tuple) 将一个以struct_time转换为时间戳(float类型),打印如：1409124869.0

    # 获取当前时间的具体值(年、月、日、时、分、秒)
    print(time.localtime()) # 打印如: time.struct_time(tm_year=2014, tm_mon=8, tm_mday=27, tm_hour=15, tm_min=10, tm_sec=16, tm_wday=2, tm_yday=239, tm_isdst=0)
    print(time.localtime()[:]) # 打印如: (2014, 8, 27, 15, 10, 16, 2, 239, 0)
    # 取上一月月份
    print(time.localtime()[1]-1) # 打印如: 7
    # 取两个月后的月份
    print(time.localtime()[1]+2) # 打印如: 10
    # 取去年年份
    print(time.localtime()[0]-1) # 打印如: 2013


# 时间暂停两秒
    import time
    time.sleep(2)


# 获取今天、昨天、前几或者后几小时(datetime实现)
    import datetime
    # 得到今天的日期
    print(datetime.date.today()) # 打印如: 2011-04-13
    print(datetime.datetime.now().date())
    print(datetime.datetime.today().date()) # 这3句返回的类型都是 <type 'datetime.date'>
    # 得到前一天的日期
    print(datetime.date.today() + datetime.timedelta(days=-1)) # 打印如: 2011-04-12
    print(datetime.date.today() - datetime.timedelta(days=1))  # 打印如: 2011-04-12
    # 得到10天后的时间
    print(datetime.date.today() + datetime.timedelta(days=10)) # 打印如: 2011-04-23
    # 得到10小时后的时间，上面的 days 换成 hours
    print(datetime.datetime.now() + datetime.timedelta(hours=10)) # 打印如: 2011-04-14 04:30:10.189000
    # 获取明天凌晨 1 点的时间
    d1 = datetime.datetime(*time.localtime()[:3]) + datetime.timedelta(days=1) + datetime.timedelta(hours=1) # 打印如: 2011-04-13 01:00:00
    print(time.mktime( d1.timetuple() )) # 获取时间戳打印如： 1409127119.0


    # 根据年月日，获取 time,datetime
    print(datetime.date(2016, 2, 29)) # 获取 datetime.date 类型，打印：2016-02-29
    print(datetime.datetime(2004, 12, 31)) # 获取 datetime.datetime 类型，打印：2004-12-31 00:00:00
    print(datetime.datetime(2004, 12, 31, 15, 31, 8)) # 获取 datetime.datetime 类型，打印：2004-12-31 15:31:08


# 获取今天、昨天、前几或者后几小时(time实现)
    import time
    # 取一天后的当前具体时间
    print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()+24*60*60)))
    # 取20天后的当前具体时间
    print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()+20*24*60*60)))
    # 取20天后当前具体时间的前2小时
    print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()+20*24*60*60-2*60*60)))


#两日期相减(也可以大于、小于来比较):
    import datetime
    # 指定具体时间的参数： datetime.datetime(year, month, day[, hour[, minute[, second[, microsecond[,tzinfo]]]]])
    d1 = datetime.datetime(2005, 2, 16)
    d2 = datetime.datetime(2004, 12, 31)
    print((d1 - d2).days) # 打印： 47


#运行时间：
    import time,datetime
    starttime = datetime.datetime.now()
    time.sleep(1) # 暂停1秒
    endtime = datetime.datetime.now()
    print((endtime - starttime).seconds) # 秒, 打印： 1
    print((endtime - starttime).microseconds) # 微秒(百万分之一秒)； 打印： 14000

# 精确计算函数的运行时间
    import time
    start = time.clock()
    func(*args, **kwargs) # 运行函数
    end =time.clock()
    print( 'used:' + str(end) ) # 耗时单位:秒

# 精确计算函数的运行时间2(实测发现 time.clock() 计算不严谨,前面用没用过很难确定)
    import time
    start = time.time()
    func(*args, **kwargs) # 运行函数
    end =time.time()
    print( 'used:' + str(end - start) ) # 耗时单位:秒

# time.clock() 用法
    clock() -> floating point number
    该函数有两个功能，
    在第一次调用的时候，返回的是程序运行的实际时间；
    以第二次之后的调用，返回的是自第一次调用后,到这次调用的时间间隔

    import time
    time.sleep(1)
    print "clock1:%s" % time.clock() # 打印如: clock1:2.17698990094e-06
    time.sleep(1)
    print "clock2:%s" % time.clock() # 打印如: clock2:1.00699529055
    time.sleep(1)
    print "clock3:%s" % time.clock() # 打印如: clock3:2.00698720459



# 字符串 转成 时间 time
    import time
    s2='2012-02-16';
    a=time.strptime(s2,'%Y-%m-%d')
    print a # time.struct_time(tm_year=2012, tm_mon=2, tm_mday=16, tm_hour=0, tm_min=0, tm_sec=0, tm_wday=3, tm_yday=47, tm_isdst=-1)
    print type(a) # <type 'time.struct_time'>
    print repr(a) # time.struct_time(tm_year=2012, tm_mon=2, tm_mday=16, tm_hour=0, tm_min=0, tm_sec=0, tm_wday=3, tm_yday=47, tm_isdst=-1)

# 字符串 转成 时间 datetime
    import datetime
    date_str = "2008-11-10 17:53:59"
    dt_obj = datetime.datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S")
    print dt_obj # 2008-11-10 17:53:59
    print dt_obj.strftime('%Y-%m-%d %H:%M:%S') # 2008-11-10 17:53:59
    print type(dt_obj) # <type 'datetime.datetime'>
    print repr(dt_obj) # datetime.datetime(2008, 11, 10, 17, 53, 59)

# timestamp to time tuple in UTC
    import time
    timestamp = 1226527167.595983
    time_tuple = time.gmtime(timestamp)
    print repr(time_tuple) # time.struct_time(tm_year=2008, tm_mon=11, tm_mday=12, tm_hour=21, tm_min=59, tm_sec=27, tm_wday=2, tm_yday=317, tm_isdst=0)
    print time.strftime('%Y-%m-%d %H:%M:%S', time_tuple) # 2008-11-12 21:59:27

# timestamp to time tuple in local time (返转 time.time() 生成的时间戳)
    import time
    timestamp = 1226527167.595983
    time_tuple = time.localtime(timestamp)
    print repr(time_tuple) # time.struct_time(tm_year=2008, tm_mon=11, tm_mday=13, tm_hour=5, tm_min=59, tm_sec=27, tm_wday=3, tm_yday=318, tm_isdst=0)
    print time.strftime('%Y-%m-%d %H:%M:%S', time_tuple) # 2008-11-13 05:59:27

# datetime 转成 time
    import time, datetime
    # datetime 的 timetuple 函数可直接转成 time.struct_time
    print(datetime.datetime.now().timetuple())
    # 上行打印如：time.struct_time(tm_year=2014, tm_mon=8, tm_mday=27, tm_hour=16, tm_min=7, tm_sec=37, tm_wday=2, tm_yday=239, tm_isdst=-1)
    print(time.localtime())
    # 上行打印如：time.struct_time(tm_year=2014, tm_mon=8, tm_mday=27, tm_hour=16, tm_min=7, tm_sec=37, tm_wday=2, tm_yday=239, tm_isdst=0)

# datetime 转成 date
    import datetime
    # 比较简单，直接使用datetime_object.date()即可
    a = datetime.datetime(2015, 6, 5, 11, 45, 45, 393548)
    b = a.date() # datetime.date(2016, 6, 5)
    print(b) # 打印: 2015-06-05
    print(type(b)) # 打印: <type 'datetime.date'>

# date 转成 datetime
    import datetime
    n_date = datetime.date(2015, 9, 8)
    b = datetime.datetime.combine(n_date, datetime.datetime.min.time()) # datetime.datetime(2015, 9, 8, 0, 0)
    print(b) # 打印: 2015-09-08 00:00:00
    print(type(b)) # 打印: <type 'datetime.datetime'>


# 获取时间戳
    import time, datetime
    print(time.time()) # 打印如： 1409127119.16
    print(long(time.time())) # 打印如： 1409127119
    print(time.mktime( datetime.datetime.now().timetuple() )) # 打印如： 1409127119.0
    print(long(time.mktime(time.strptime('2014-03-25 19:25:33', '%Y-%m-%d %H:%M:%S')))) # 打印如：1395746733

#获取当前的时间 
    print time.localtime() 
    print datetime.datetime.now() 

#计算两个日期之间的天数 
    d1=datetime.datetime(2012,4,9) 
    d2=datetime.datetime(2012,4,10) 
    print (d2-d1).days

#计算程序的运行时间 以秒为单位显示 
    startTime=datetime.datetime.now() # do something here 
    endTime=datetime.datetime.now() 
    print (endTime-startTime).seconds 
    
#计算n天后的日期 
    d1=datetime.datetime.now() 
    d2=d1=datetime.timedelta(days=10) 
    print str(d2) # 上例演示了计算当前时间向后10天的时间。 # 如果是小时 days 换成 hours

日期格式化符号:
%%: %号本身
%A: 本地星期(全称),如:Tuesday   %a: 本地星期(简称),如:Tue
%B: 本地月份(全称),如:February  %b: 本地月份(简称),如:Feb
                                %c: 本地相应的日期表示和时间表示,如:02/15/11 16:50:57
                                %d: 月内中的一天(0-31),如:15
                                %f: 微秒数值(仅 datetime 类型有, time 类型用会报错)
%H: 24进制小时数(0-23)
%I: 12进制小时数(01-12)
                                %j: 年内的一天(001-366),如:046
%M: 分钟(00-59),如:50           %m: 月份(01-12),如:02
                                %p: 上下午(本地A.M.或P.M.的等价符),如:PM
%S: 秒钟(00-59),如:57
%X: 本地的时间,如:16:50:57      %x: 本地的日期,如:02/15/11
%Y: 四位的年(000-9999)          %y: 两位数的年份表示(00-99)

%U: 年里的星期数(00-53)从星期天开始,如:07
%W: 年里的星期数(00-53)从星期一开始,如:07
%w: 星期(0-6),星期天为星期的开始,如:2 (星期天为0)
%Z: 当前时区的名称,如:中国标准时间
%z: 当前时区的名称,如:中国标准时间

