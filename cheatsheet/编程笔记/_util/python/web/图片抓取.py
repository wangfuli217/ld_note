#!python
# -*- coding:utf-8 -*-

import logging
import re
import urllib

def getHtml(url):
    page = urllib.urlopen(url)
    html = page.read()
    return html

def getImg(html):
    reg = r'src="(.*?)" alt='
    imgre = re.compile(reg)
    imglist = re.findall(imgre,html)
    x = 1
    for imgurl in imglist:
        logging.error(imgurl)
        urllib.urlretrieve(imgurl,'%s.jpg' % x)
        logging.error("第%s张下载完成！" % x)
        x+=1

#html = getHtml("http://mm.taobao.com/json/request_top_list.htm?page=1&qq-pf-to=pcqq.group" )
#getImg(html)




#######################################

import urllib2
import time
# function downloadfile :用于下载文件
def downloadfile(file_url,filename,download_path):
    try:
        request = urllib2.Request(file_url)
        f=open(download_path+filename,'wb')
        start_time=time.time()
        #print 'time stamp is : ',time.time()
        print start_time
        size =0
        speed=0
        data_lines = urllib2.urlopen(request).readlines()
        #data = urllib2.urlopen(request).read()
        for data in data_lines:
            f.write(data)
            size = size + len(data)
            dural_time=float(time.time()) - float(start_time)
            if(dural_time>0):
                speed = float(size)/float(dural_time)/(1000*1000)
                while(speed >1):
                    print 'speed lagger than 1MB/s , sleep(0.1).....'
                    print 'sleep .....'
                    sleep(0.1)
                    dural_time=float(time.time()) - float(start_time)
                    speed = float(size)/float(dural_time)/(1000*1000)
        print 'total time is : ',dural_time ,'seconds'
        print 'size is       : ',size ,'B'
        print 'speed is      : ',speed ,'MB/s'
    except Exception,e:
        print 'download error: ',e
        return False
    return True

#downloadfile('http://img01.taobaocdn.com/sns_logo/i1/T1DHXoFMBXXXb1upjX.jpg_60x60.jpg','1.jpg','')
