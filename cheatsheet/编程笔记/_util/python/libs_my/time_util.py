#!python
# -*- coding:utf-8 -*-
'''
公用函数(时间处理)
Created on 2014/10/16
Updated on 2016/8/24
@author: Holemar
'''
import time
import datetime
import calendar

__all__=('init', 'add', 'sub', 'to_string', 'to_time', 'to_datetime', 'to_date', 'to_timestamp', 'is_dst', 'get_week_range', 'get_month_range')


CONFIG = {
    'format_str' : '%Y-%m-%d %H:%M:%S', # {string} 日期格式化的格式字符串

    # format_list: {list<string>} 各种支持的日期格式
    'format_list': ('%Y-%m-%d %H:%M:%S', '%Y-%m-%d %H:%M:%S.%f', '%Y-%m-%d',
                    '%Y/%m/%d %H:%M:%S', '%Y/%m/%d %H:%M:%S.%f', '%Y/%m/%d',
                    "%Y-%m-%dT%H:%M:%S", "%Y-%m-%dT%H:%M:%S+08:00", "%Y-%m-%dT%H:%M:%S.%f+08:00",
                    ),
}


def init(**kwargs):
    '''
    @summary: 初始化日期默认参数
    @param {string} format_str: 日期格式化的格式字符串(默认为: %Y-%m-%d %H:%M:%S)
    '''
    global CONFIG
    CONFIG.update(kwargs)


def to_string(value=None, format_str=None):
    '''
    @summary: 将日期格式化成字符串
    @param {time|datetime|int|long|float} value: 原时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {string} format_str: 日期格式化的格式字符串(默认为: %Y-%m-%d %H:%M:%S)
    @return {string}: 格式化后的时间字符串
    '''
    if format_str is None:
        global CONFIG
        format_str = CONFIG.get('format_str')
    if value in (None, ''):
        value = datetime.datetime.now()
    # 字符串类型,直接返回
    elif isinstance(value, basestring):
        value = to_datetime(value)
    # 纯数值类型,认为是时间戳
    elif isinstance(value, (int, long, float)):
        value = to_time(value)

    # datetime, datetime.date
    if isinstance(value, (datetime.datetime, datetime.date)):
        return value.strftime(format_str)
    # time
    elif isinstance(value, time.struct_time):
        return time.strftime(format_str, value)
    # 其它类型,无法格式化
    return None


def to_time(value=None, format_str=None):
    '''
    @summary: 将时间转成 time 类型
    @param {time|datetime|int|long|float|string} value: 原时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {string} format_str: 日期格式化的格式字符串(默认为: %Y-%m-%d %H:%M:%S)
    @return {time.struct_time}: 对应的时间
    '''
    if value in (None, ''):
        return time.localtime()
    # time
    elif isinstance(value, time.struct_time):
        return value
    # datetime, datetime.date
    elif isinstance(value, (datetime.datetime, datetime.date)):
        return value.timetuple()
    # 纯数值类型,认为是时间戳
    elif isinstance(value, (int, long, float)):
        return time.localtime(value)
    # 字符串
    elif isinstance(value, basestring):
        if format_str:
            return time.strptime(value, format_str)
        global CONFIG
        for format in CONFIG.get('format_list'):
            try:
                return time.strptime(value, format)
            except:
                pass
    # 其它类型,无法格式化
    return None


def to_datetime(value=None, format_str=None):
    '''
    @summary: 将时间转成 datetime.datetime 类型
        注: 由 time 转 datetime 类型时,只能精确到秒,无法精确到毫秒级别
    @param {time|datetime|int|long|float|string} value: 原时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {string} format_str: 日期格式化的格式字符串(默认为: %Y-%m-%d %H:%M:%S)
    @return {datetime.datetime}: 对应的时间
    '''
    if value in (None, ''):
        return datetime.datetime.now()
    # datetime
    elif isinstance(value, datetime.datetime):
        return value
    # datetime.date (与 datetime.datetime 类型不同,它不能添加时分秒)
    elif isinstance(value, datetime.date):
        return datetime.datetime(value.year, value.month, value.day)
        #return datetime.datetime.combine(value, datetime.datetime.min.time())
    # time
    elif isinstance(value, time.struct_time):
        return datetime.datetime(*value[:6]) # 只能精确到秒,无法精确到毫秒级别
        #value = time.mktime(value) # 先转成时间戳,交给下面专门处理时间戳的(实际上也是无法精确到毫秒)
    # 字符串
    elif isinstance(value, basestring):
        if format_str:
            return datetime.datetime.strptime(value, format_str)
        global CONFIG
        for format in CONFIG.get('format_list'):
            try:
                return datetime.datetime.strptime(value, format)
            except:
                pass
    # 纯数值类型,认为是时间戳(要注意此处的时间不能早于1970-01-01 00:00)
    if isinstance(value, (int, long, float)):
        return datetime.datetime.fromtimestamp(value)
    # 其它类型,无法格式化
    return None


def to_date(value=None, format_str=None):
    '''
    @summary: 将时间转成 datetime.date 类型
    @param {time|datetime|int|long|float|string} value: 原时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {string} format_str: 日期格式化的格式字符串(默认为: “%Y-%m-%d %H:%M:%S” 及 “%Y-%m-%d”)
    @return {datetime.date}: 对应的日期
    '''
    if value in (None, ''):
        return datetime.date.today()
    # datetime
    elif isinstance(value, datetime.datetime):
        #return datetime.date(value.year, value.month, value.day)
        return value.date()
    # datetime.date (与 datetime.datetime 类型不同,它不能添加时分秒)
    elif isinstance(value, datetime.date):
        return value
    # time
    elif isinstance(value, time.struct_time):
        return datetime.date(*value[:3]) # 只能精确到秒,无法精确到毫秒级别
        #value = time.mktime(value) # 先转成时间戳,交给下面专门处理时间戳的(实际上也是无法精确到毫秒)
    # 字符串
    elif isinstance(value, basestring):
        value = to_datetime(value, format_str=format_str)
        return datetime.date(value.year, value.month, value.day)
    # 纯数值类型,认为是时间戳
    if isinstance(value, (int, long, float)):
        return datetime.date.fromtimestamp(value)
    # 其它类型,无法格式化
    return None


def to_timestamp(value=None, format_str=None):
    '''
    @summary: 将时间转成时间戳(单位:秒)
        注: 只能精确到秒,无法精确到毫秒级别
    @param {time|datetime|int|long|float|string} value: 原时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {string} format_str: 日期格式化的格式字符串(默认为: %Y-%m-%d %H:%M:%S)
    @return {float}: 对应的时间戳(单位:秒)
    '''
    if value in (None, ''):
        return time.time()
    # 纯数值类型,认为是时间戳
    elif isinstance(value, (int, long, float)):
        return value
    # time
    elif isinstance(value, time.struct_time):
        return time.mktime(value)
    # datetime, datetime.date
    elif isinstance(value, (datetime.datetime, datetime.date)):
        return time.mktime(value.timetuple())
    # 字符串
    elif isinstance(value, basestring):
        value = to_time(value, format_str=format_str) # 先转成 time 类型再处理
        return time.mktime(value)
    # 其它类型,无法格式化
    return None


def is_dst(value=None, format_str=None):
    '''
    @summary: 判断传入时间是否夏令时
    @param {time|datetime|int|long|float|string} value: 需判断的时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {string} format_str: 日期格式化的格式字符串(默认为: %Y-%m-%d %H:%M:%S)
    @return {bool}: 是否夏令时
    '''
    timestamp = to_timestamp(value=value, format_str=format_str)
    return bool(time.localtime(timestamp).tm_isdst)


def add(original_time=None, years=0, months=0, days=0, hours=0, minutes=0, seconds=0, number=1):
    '''
    @summary: 添加时间
    @param {time|datetime|int|long|float|string} original_time: 原时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {int} years: 要添加多少年
    @param {int} months: 要添加多少个月
    @param {int} days: 要添加多少天 (允许负数表示减多少天)
    @param {int} hours: 要添加多少小时 (允许负数表示减多少小时)
    @param {int} minutes: 要添加多少分钟 (允许负数表示减多少分钟)
    @param {int} seconds: 要添加多少秒 (允许负数表示减多少秒)
    @param {int} number: 倍数(默认1个,如果值为2表示所有添加时间是其它时间参数的2倍)
    @return {datetime}: 添加完时间后的时间
    '''
    after_time = to_datetime(original_time)
    if after_time is None:
        raise RuntimeError(u"时间参数无法解析:%s" % original_time)

    # 添加倍数
    if number != 1:
        years *= number
        months *= number
        days *= number
        hours *= number
        minutes *= number
        seconds *= number
    # 系统自带有的添加时间
    if days != 0:
        after_time += datetime.timedelta(days=days)
    if hours != 0:
        after_time += datetime.timedelta(hours=hours)
    if minutes != 0:
        after_time += datetime.timedelta(minutes=minutes)
    if seconds != 0:
        after_time += datetime.timedelta(seconds=seconds)
    if not (years or months):
        return after_time
    # 年、月的添加,系统没有自带函数,只能另外计算
    original_months_count = after_time.year * 12 + after_time.month - 1 # 原日期共经历了多少个月
    after_months_count = original_months_count + months # 添加后日期，共经历了多少个月
    after_year = after_months_count / 12 + years # 添加后的年份
    after_month = after_months_count % 12 + 1 # 添加后的月份
    after_day = min(after_time.day, calendar.monthrange(after_year, after_month)[1]) # 添加后的日期
    # 最终时间
    return after_time.replace(year=after_year, month=after_month, day=after_day)


def sub(time1=None, time2=None, abs=False):
    '''
    @summary: 求出两个时间的差
    @param {time|datetime|int|long|float|string} time1: 被减时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {time|datetime|int|long|float|string} time2: 减去时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {bool} abs: 是否返回两个时间的差的绝对值。为 True 则返回绝对值；否则直接 time1 减去 time2, 默认False
    @return {dict}: 返回两个时间的差
       下面返回的各值都是整形。
       如两时间相差1年2个月,返回的值大概是 {'years' : 1, 'months' : 2, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : 0,'sum_days':791, 'sum_seconds':791*24*60*60}
       返回值为:
        {
            'years' : 0, # {int} 两时间相差多少年
            'months' : 0, # {int} 两时间相差多少个月,去掉前面年的部分
            'days' : 0, # {int} 两时间相差多少天,去掉前面年、月的部分
            'hours' : 0, # {int} 两时间相差多少小时,去掉前面年、月、日的部分
            'minutes' : 0, # {int} 两时间相差多少分钟,去掉前面年、月、日、时的部分
            'seconds' : 0, # {int} 两时间相差多少秒,去掉前面年、月、日、时、分的部分
            'sum_days' : 0 # {int} 两时间相差多少天,这是独立值,不包括其它参数的内容
            'sum_seconds' : 0 # {int} 两时间相差多少秒,这是独立值,不包括其它参数的内容
        }
    '''
    # 参数转成 datetime 类型
    time1 = to_datetime(time1)
    time2 = to_datetime(time2)
    if time1 is None or time2 is None:
        raise RuntimeError(u"时间参数无法解析, time1:%s, time2:%s" % (time1, time2))
    # 返回值
    res = {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : 0,'sum_days':0, 'sum_seconds':0}
    # 如果两时间相等,没必要再判断了
    if time1 == time2:
        return res
    plus = time1 > time2 # 正数标识, 正数时为 True
    _time1 = time1 if plus else time2
    _time2 = time2 if plus else time1
    timedelta = time1 - time2 if plus else time2 - time1 # 时间差
    # sum_days、sum_seconds 的差值计算
    sum_days = res['sum_days'] = timedelta.days
    sum_seconds = res['sum_seconds'] = timedelta.seconds + sum_days * 24 * 60 * 60
    # 时、分、秒 的差值计算
    res['seconds'] = sum_seconds % 60
    res['minutes'] = (sum_seconds % 3600) // 60
    res['hours'] = (sum_seconds % (24 * 60 * 60)) // 3600
    # 年、月、日 的差值计算
    months_count1 = _time1.year * 12 + _time1.month - 1 # 日期1共经历了多少个月
    months_count2 = _time2.year * 12 + _time2.month - 1 # 日期2共经历了多少个月
    months_count = months_count1 - months_count2
    days = res['days'] = _time1.day - _time2.day
    if days < 0 and months_count>0:
        res['days'] += calendar.monthrange(_time2.year, _time2.month)[1]
        months_count -= 1
    res['years'] = months_count // 12
    res['months'] = months_count % 12
    # 本身是正数或者要求绝对值的,不用判断负值
    if plus or abs:
        return res
    # 负数处理
    for k, v in res.items():
        res[k] = -v
    return res


def get_week_range(date=None, add_weeks=0):
    '''
    @summary: 获取指定日期所在的星期的开始日期及结束日期
    @param {time|datetime|int|long|float|string} date: 原时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {int} add_weeks: 要加上多少个星期(本星期则为0，下星期则为1，上星期则为-1，下下星期则为2。。。)
    @return {tuple<datetime.date, datetime.date>}: 对应的星期的开始日期及结束日期
    '''
    date = add(date, days=add_weeks * 7)
    this_weekday = date.weekday()
    start_date = add(date, days=-this_weekday)
    end_date = add(date, days=6-this_weekday)
    return to_date(start_date), to_date(end_date)


def get_month_range(date=None, add_months=0):
    '''
    @summary: 获取指定日期所在的月的开始日期及结束日期
    @param {time|datetime|int|long|float|string} date: 原时间(为空则默认为当前时间；纯数值则认为是时间戳,单位:秒)
    @param {int} add_months: 要加上多少个月(本月则为0，下个月则为1，上个月则为-1，下下个月则为2。。。)
    @return {tuple<datetime.date, datetime.date>}: 对应的月的开始日期及结束日期
    '''
    date = add(date, months=add_months)
    start_date = date.replace(day=1)
    end_date = date.replace(day=calendar.monthrange(date.year, date.month)[1])
    return to_date(start_date), to_date(end_date)
