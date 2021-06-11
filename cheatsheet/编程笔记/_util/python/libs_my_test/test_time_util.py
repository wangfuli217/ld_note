#!python
# -*- coding:utf-8 -*-
'''
公用函数 time_util.py 的测试
Created on 2014/10/16
Updated on 2016/8/18
@author: Holemar
'''
import time
import datetime
import calendar
import unittest

import __init__
from libs_my.time_util import *

class TimeUtilTest(unittest.TestCase):

    # to_string 测试
    def test_to_string(self):
        now_time = datetime.datetime.now()
        now_str = now_time.strftime('%Y-%m-%d %H:%M:%S')
        assert to_string() == now_str # 默认返回当前时间
        assert to_string(None) == now_str # 默认返回当前时间
        assert to_string('') == now_str # 默认返回当前时间
        assert to_string(time.time()) == now_str # 时间戳
        assert to_string(0) == to_string(time.localtime(0)) # 时间戳为0时
        assert to_string('2014-02-06 08:51:06') == '2014-02-06 08:51:06' # 字符串
        assert to_string('2014/02/06') == '2014-02-06 00:00:00' # 字符串
        assert to_string('2014/2/6 23:59:59') == '2014-02-06 23:59:59' # 字符串
        assert to_string(datetime.datetime(2014, 2, 6, 8, 51, 6)) == '2014-02-06 08:51:06' # datetime
        assert to_string(datetime.datetime(2014, 2, 6, 8, 51, 6), '%Y/%m/%dxx') == '2014/02/06xx' # datetime, 格式化测试
        assert to_string(time.strptime('2014/03/25 19:05:33', '%Y/%m/%d %H:%M:%S')) == '2014-03-25 19:05:33' # time
        assert to_string(datetime.date.today()) == now_time.strftime('%Y-%m-%d 00:00:00') # datetime.date

    # 公用测试
    def fun_test(self, fun, default_time, test_time, test_date):
        # 测试默认值及当前时间
        assert fun() == default_time # 默认返回当前时间
        assert fun(None) == default_time # 默认返回当前时间
        assert fun('') == default_time # 默认返回当前时间
        assert fun(time.time()) == default_time # 时间戳
        assert fun(0) == fun(time.localtime(0)) # 时间戳为0时
        # 测试指定时间
        assert fun('2014-02-06 08:51:06') == test_time # 字符串
        assert fun('2014/02-6 8xx51mm06::YY', '%Y/%m-%d %Hxx%Mmm%S::YY') == test_time # 格式化测试
        assert fun(datetime.datetime(2014, 2, 6, 8, 51, 6)) == test_time # datetime
        assert fun(time.strptime('2014-02-06 08:51:06','%Y-%m-%d %H:%M:%S')) == test_time # time
        assert fun(datetime.date(2014,2,6)) == test_date # datetime.date
        # 多种格式的日期格式
        assert fun('2014/02/06 08:51:06') == test_time
        assert fun('2014/2/6 8:51:6') == test_time
        assert fun('2014/2/06 08:51:6') == test_time
        assert fun('2014-02-06T08:51:06+08:00') == test_time
        # 测试日期
        assert fun('2014-02-06') == test_date
        assert fun('2014-2-6') == test_date
        assert fun('2014/02/06') == test_date
        assert fun('2014/2/6') == test_date

    # to_time 测试
    def test_to_time(self):
        now_time = time.localtime()
        test_time = time.strptime('2014-02-06 08:51:06','%Y-%m-%d %H:%M:%S') # 测试时间
        test_date = time.strptime('2014-02-06','%Y-%m-%d') # 测试日期
        self.fun_test(to_time, now_time, test_time, test_date)

    # to_datetime 测试
    def test_to_datetime(self):
        now_time = datetime.datetime.now()
        test_time = datetime.datetime(2014, 2, 6, 8, 51, 6) # 测试时间
        test_date = datetime.datetime(2014, 2, 6) # 测试日期
        self.fun_test(to_datetime, now_time, test_time, test_date)

    # to_date 测试
    def test_to_date(self):
        now_time = datetime.date.today()
        test_time = datetime.date(2014, 2, 6) # 测试时间
        test_date = datetime.date(2014, 2, 6) # 测试日期
        self.fun_test(to_date, now_time, test_time, test_date)

    # to_timestamp 测试
    def test_to_timestamp(self):
        now_time = time.time()
        test_time = time.mktime(time.strptime('2014-02-06 08:51:06','%Y-%m-%d %H:%M:%S')) # 测试时间
        test_date = time.mktime(time.strptime('2014-02-06','%Y-%m-%d')) # 测试日期
        self.fun_test(to_timestamp, now_time, test_time, test_date)

    # add 测试
    def test_add(self):
        now_time = datetime.datetime.now() # 上面运行这么久,有可能导致时间延后而报错
        test_time = datetime.datetime(2014, 10, 16) # 测试时间
        assert add() == now_time # 默认返回当前时间
        assert add(days=11) == now_time + datetime.timedelta(days=11)
        assert add(days=11, number=2) == now_time + datetime.timedelta(days=22)
        assert add(test_time) == test_time
        # 参数是否被修改测试
        tem_time = test_time
        assert id(add(tem_time, days=1)) != id(test_time) #  日期不同,不能修改传进去的参数值
        assert id(add(tem_time, months=1)) != id(test_time) #  日期不同,不能修改传进去的参数值
        assert id(tem_time) == id(test_time) # 传进去的参数不能被修改
        #add(years=1, months=0, days=0, hours=0, minutes=0, seconds=0)
        assert add(test_time, years=1) == datetime.datetime(2015, 10, 16) # 加 1 年
        assert add(test_time, years=-1) == datetime.datetime(2013, 10, 16) # 减 1 年
        assert add(test_time, months=1) == datetime.datetime(2014, 11, 16) # 加 1 月
        assert add(test_time, months=-1) == datetime.datetime(2014, 9, 16) # 减 1 月
        assert add(test_time, months=12) == add(test_time, years=1) # 加 12 月
        assert add(datetime.datetime(2014, 9, 30), days=1) == datetime.datetime(2014, 10, 1) # 加 1 天
        assert add(datetime.datetime(2014, 10, 1), days=-1) == datetime.datetime(2014, 9, 30) # 减 1 天
        assert add(datetime.datetime(2014, 10, 31), days=1) == datetime.datetime(2014, 11, 1) # 加 1 天
        assert add(datetime.datetime(2014, 2, 28), days=1) == datetime.datetime(2014, 3, 1) # 加 1 天
        assert add(datetime.datetime(2000, 2, 28), days=1) == datetime.datetime(2000, 2, 29) # 加 1 天
        assert add(datetime.datetime(2000, 2, 28), days=2) == datetime.datetime(2000, 3, 1) # 加 2 天
        assert add(test_time, days=365) == add(test_time, years=1) # 加 1 年
        assert add(test_time, days=-365) == add(test_time, years=-1) # 减 1 年
        assert add(test_time, hours=1) == datetime.datetime(2014, 10, 16, 1) # 加 1 小时
        assert add(test_time, hours=-1) == datetime.datetime(2014, 10, 15, 23) # 减 1 小时
        assert add(test_time, minutes=1) == datetime.datetime(2014, 10, 16, 0, 1) # 加 1 分钟
        assert add(test_time, minutes=-1) == datetime.datetime(2014, 10, 15, 23, 59) # 减 1 分钟
        assert add(test_time, seconds=1) == datetime.datetime(2014, 10, 16, 0, 0, 1) # 加 1 秒
        assert add(test_time, seconds=-1) == datetime.datetime(2014, 10, 15, 23, 59, 59) # 减 1 秒
        # 特殊日期(闰月)
        assert add(datetime.datetime(2000, 2, 1), months=1) == datetime.datetime(2000, 3, 1)
        assert add(datetime.datetime(2000, 2, 1), months=1, days=-1) == datetime.datetime(2000, 2, 29)
        assert add(datetime.datetime(1999, 2, 1), years=1, months=1) == datetime.datetime(2000, 3, 1)
        assert add(datetime.datetime(1999, 2, 1), years=1, months=1, days=-1) == datetime.datetime(2000, 2, 29)
        assert add(datetime.datetime(2000, 2, 1), years=1, months=1, days=-1) == datetime.datetime(2001, 2, 28)
        # 倍数计算
        assert add(test_time, years=1, number=2) == datetime.datetime(2016, 10, 16) # 加 1 年 * 2 倍
        assert add(test_time, years=-1, number=2) == datetime.datetime(2012, 10, 16) # 减 1 年 * 2 倍
        assert add(test_time, months=1, number=2) == datetime.datetime(2014, 12, 16) # 加 1 月 * 2 倍
        assert add(test_time, months=-1, number=2) == datetime.datetime(2014, 8, 16) # 减 1 月 * 2 倍
        assert add(datetime.datetime(2014, 9, 29), days=1, number=2) == datetime.datetime(2014, 10, 1) # 加 1 天 * 2 倍
        assert add(datetime.datetime(2014, 10, 1), days=-1, number=2) == datetime.datetime(2014, 9, 29) # 减 1 天 * 2 倍
        assert add(test_time, hours=1, number=2) == datetime.datetime(2014, 10, 16, 2) # 加 1 小时 * 2 倍
        assert add(test_time, hours=-1, number=2) == datetime.datetime(2014, 10, 15, 22) # 减 1 小时 * 2 倍
        assert add(test_time, hours=1, number=1.5) == datetime.datetime(2014, 10, 16, 1, 30) # 加 1 小时 * 1.5 倍

    # sub 测试
    def test_sub(self):
        now = datetime.datetime.now()
        # 没差异判断
        zero_secends = {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : 0,'sum_days':0, 'sum_seconds':0}
        assert sub() == zero_secends # 默认返回全是0
        assert sub(now, now) == zero_secends
        assert sub(None, now) == zero_secends
        assert sub(now, None) == zero_secends
        # 相差天数判断
        one_days = {'years' : 0, 'months' : 0, 'days' : 1, 'hours' : 0, 'minutes' : 0, 'seconds' : 0,'sum_days':1, 'sum_seconds':24 * 60 * 60} # 1 天的时间差
        assert sub(now, now - datetime.timedelta(days=1)) == one_days # 相差 1 天
        t1 = now + datetime.timedelta(days=1)
        assert sub(t1, now) == one_days # 相差 1 天
        assert sub(now, t1) == {'years' : 0, 'months' : 0, 'days' : -1, 'hours' : 0, 'minutes' : 0, 'seconds' : 0, 'sum_days':-1, 'sum_seconds':-24 * 60 * 60} # 相差 -1 天
        assert sub(now, t1, abs=True) == one_days # 绝对值相差 1 天
        # 时分秒判断
        assert sub(now, now - datetime.timedelta(hours=1)) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 1, 'minutes' : 0, 'seconds' : 0,'sum_days':0, 'sum_seconds':60 * 60} # 相差 1 小时
        assert sub(now, now + datetime.timedelta(hours=2)) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : -2, 'minutes' : 0, 'seconds' : 0,'sum_days':0, 'sum_seconds':-2*60 * 60} # 相差 -2 小时
        assert sub(now, now + datetime.timedelta(hours=2), abs=True) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 2, 'minutes' : 0, 'seconds' : 0,'sum_days':0, 'sum_seconds':2*60 * 60} # 相差 2 小时
        assert sub(now, now - datetime.timedelta(minutes=35)) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 0, 'minutes' : 35, 'seconds' : 0,'sum_days':0, 'sum_seconds':35 * 60} # 相差 35 分钟
        assert sub(now, now + datetime.timedelta(minutes=32)) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 0, 'minutes' : -32, 'seconds' : 0,'sum_days':0, 'sum_seconds':-32 * 60} # 相差 -32 分钟
        assert sub(now, now - datetime.timedelta(seconds=35)) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : 35,'sum_days':0, 'sum_seconds':35} # 相差 35秒
        assert sub(now, now + datetime.timedelta(seconds=32)) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : -32,'sum_days':0, 'sum_seconds':-32} # 相差 -32 秒
        assert sub(now, now - datetime.timedelta(minutes=62)) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 1, 'minutes' : 2, 'seconds' : 0, 'sum_days':0, 'sum_seconds':62*60} # 相差 62 分钟
        assert sub(now, now - datetime.timedelta(hours=2, minutes=3, seconds=2)) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 2, 'minutes' : 3, 'seconds' : 2, 'sum_days':0, 'sum_seconds':2*3600+3*60+2} # 相差 2 时 3 分 2 秒
        assert sub(now, now + datetime.timedelta(hours=2, minutes=3, seconds=2)) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : -2, 'minutes' : -3, 'seconds' : -2, 'sum_days':0, 'sum_seconds':-(2*3600+3*60+2)} # 相差 2 时 3 分 2 秒
        assert sub(now, now - datetime.timedelta(seconds=2.9)) == {'years' : 0, 'months' : 0, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : 2, 'sum_days':0, 'sum_seconds':2} # 相差 2 秒, 小数忽略
        # 年月判断
        res = sub(now, now - datetime.timedelta(days=32))
        assert res.get('sum_days')==32 and res.get('years')==0 and res.get('months')==1 and res.get('days') in (1,2,3,4) and res.get('hours')==0 and res.get('minutes')==0 and res.get('seconds')==0 and res.get('sum_seconds')==32*24*60*60
        assert sub(datetime.datetime(2014, 12, 18, 11, 8, 6), datetime.datetime(2013, 12, 16, 10, 7, 13)) == {'years' : 1, 'months' : 0, 'days' : 2, 'hours' : 1, 'minutes' : 0, 'seconds' : 53, 'sum_days':367, 'sum_seconds':367*24*60*60+3653}
        assert sub(datetime.datetime(2013, 12, 16, 10, 7, 13), datetime.datetime(2014, 12, 18, 11, 8, 6)) == {'years' : -1, 'months' : 0, 'days' : -2, 'hours' : -1, 'minutes' : 0, 'seconds' : -53, 'sum_days':-367, 'sum_seconds':-(367*24*60*60+3653)}
        assert sub(datetime.datetime(2014, 8, 30), datetime.datetime(2014, 7, 30)) == {'years' : 0, 'months' : 1, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : 0, 'sum_days':31, 'sum_seconds':31*24*60*60}
        assert sub(datetime.datetime(2014, 9, 16), datetime.datetime(2014, 8, 15)) == {'years' : 0, 'months' : 1, 'days' : 1, 'hours' : 0, 'minutes' : 0, 'seconds' : 0, 'sum_days':32, 'sum_seconds':32*24*60*60}
        assert sub(datetime.datetime(2014, 10, 30), datetime.datetime(2014, 9, 30)) == {'years' : 0, 'months' : 1, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : 0, 'sum_days':30, 'sum_seconds':30*24*60*60}
        assert sub(datetime.datetime(2014, 11, 1), datetime.datetime(2014, 10, 2)) == {'years' : 0, 'months' : 0, 'days' : 30, 'hours' : 0, 'minutes' : 0, 'seconds' : 0, 'sum_days':30, 'sum_seconds':30*24*60*60}
        assert sub(datetime.datetime(2014, 10, 2), datetime.datetime(2014, 11, 1)) == {'years' : 0, 'months' : 0, 'days' : -30, 'hours' : 0, 'minutes' : 0, 'seconds' : 0, 'sum_days':-30, 'sum_seconds':-30*24*60*60}
        # 特殊日期(闰月)
        assert sub(datetime.datetime(2000, 3, 1), datetime.datetime(2000, 2, 1)) == {'years' : 0, 'months' : 1, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : 0, 'sum_days':29, 'sum_seconds':29*24*60*60} # 闰月 29 天
        assert sub(datetime.datetime(2001, 3, 1), datetime.datetime(2001, 2, 1)) == {'years' : 0, 'months' : 1, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : 0, 'sum_days':28, 'sum_seconds':28*24*60*60} # 平月 28 天
        assert sub(datetime.datetime(2000, 3, 1), datetime.datetime(1999, 2, 1)) == {'years' : 1, 'months' : 1, 'days' : 0, 'hours' : 0, 'minutes' : 0, 'seconds' : 0, 'sum_days':394, 'sum_seconds':394*24*60*60} # 平月 28 天


    # get_week_range 测试
    def test_get_week_range(self):
        # 默认时间
        today = datetime.date.today()
        this_week_star, this_week_end = get_week_range() # 默认返回当前周的开始及结束时间
        assert this_week_star <= today
        assert this_week_end >= today
        assert this_week_star.weekday() == 0
        assert this_week_end.weekday() == 6
        # 指定测试时间
        test_time = datetime.date(2016, 8, 2)
        test_week_star, test_week_end = get_week_range(test_time)
        assert test_week_star == datetime.date(2016, 8, 1)
        assert test_week_end == datetime.date(2016, 8, 7)
        # 加上星期数,加1周
        test_week_star, test_week_end = get_week_range(test_time, add_weeks=1)
        assert test_week_star == datetime.date(2016, 8, 8)
        assert test_week_end == datetime.date(2016, 8, 14)
        # 加上星期数,加2周
        test_week_star, test_week_end = get_week_range(test_time, add_weeks=2)
        assert test_week_star == datetime.date(2016, 8, 15)
        assert test_week_end == datetime.date(2016, 8, 21)
        # 加上星期数,减1周
        test_week_star, test_week_end = get_week_range(test_time, add_weeks=-1)
        assert test_week_star == datetime.date(2016, 7, 25)
        assert test_week_end == datetime.date(2016, 7, 31)


    # get_month_range 测试
    def test_get_month_range(self):
        # 默认时间
        today = datetime.date.today()
        this_month_star, this_month_end = get_month_range() # 默认返回当前月的开始及结束时间
        assert this_month_star <= today
        assert this_month_end >= today
        assert this_month_star.day == 1
        assert this_month_end.day in (28, 29, 30, 31)
        assert this_month_star == datetime.date(today.year, today.month, 1)
        assert this_month_end == datetime.date(today.year, today.month, calendar.monthrange(today.year, today.month)[1])
        # 指定测试时间
        test_time = datetime.date(2016, 8, 2)
        test_month_star, test_month_end = get_month_range(test_time)
        assert test_month_star == datetime.date(2016, 8, 1)
        assert test_month_end == datetime.date(2016, 8, 31)
        # 加上月份数,加1个月
        test_month_star, test_month_end = get_month_range(test_time, add_months=1)
        assert test_month_star == datetime.date(2016, 9, 1)
        assert test_month_end == datetime.date(2016, 9, 30)
        # 加上月份数,加2个月
        test_month_star, test_month_end = get_month_range(test_time, add_months=2)
        assert test_month_star == datetime.date(2016, 10, 1)
        assert test_month_end == datetime.date(2016, 10, 31)
        # 加上月份数,减1个月
        test_month_star, test_month_end = get_month_range(test_time, add_months=-1)
        assert test_month_star == datetime.date(2016, 7, 1)
        assert test_month_end == datetime.date(2016, 7, 31)
        # 指定测试时间(特殊月份，闰年2月)
        test_time = datetime.date(2016, 2, 2)
        test_month_star, test_month_end = get_month_range(test_time)
        assert test_month_star == datetime.date(2016, 2, 1)
        assert test_month_end == datetime.date(2016, 2, 29)
        # 指定测试时间(特殊月份，平年2月)
        test_time = datetime.date(2015, 2, 2)
        test_month_star, test_month_end = get_month_range(test_time)
        assert test_month_star == datetime.date(2015, 2, 1)
        assert test_month_end == datetime.date(2015, 2, 28)


if __name__ == "__main__":
    unittest.main()
