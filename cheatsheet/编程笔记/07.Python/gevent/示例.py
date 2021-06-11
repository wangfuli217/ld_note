#python
# -*- coding:utf-8 -*-
import time

from gevent.pool import Pool
from gevent import monkey
#monkey.patch_all()
monkey.patch_time() # 这里只需要打上 time 补丁即可


def fetch_url(url):
    print "Fetching %s" % url
    time.sleep(1)
    print "Done fetching %s" % url

if __name__ == '__main__':
    urls = ["http://test.com", "http://bacon.com", "http://eggs.com"]

    p = Pool(10)

    start = time.time()
    p.map(fetch_url, urls)
    print 'use time:', time.time() - start
    # 3 次调用 fetch_url 函数，结果只用 1 秒， 说明等待过程中切换去做别的事了
