
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 14 18:23:34 2018

@author: lianzeng
"""
#refer to : https://github.com/lining0806/PythonSpiderNotes/blob/master/NewsSpider/NewsSpider.py
# and https://foofish.net/http-requests.html




#from bs4 import BeautifulSoup

import requests
import re
import os
from lxml import etree
import time

'''
myproxies = {
    'http' : '10.144.x.x:8080',
    'https': '10.144.x.x:8080'
    }
'''




target_url = 'http://news.163.com/rank/'

def Page_Info(myPage):
    '''return list [(title, url),(xx,xx)..]'''
    mypage_Info = re.findall(r'<div class="titleBar" id=".*?"><h2>(.*?)</h2><div class="more"><a href="(.*?)">.*?</a></div></div>', myPage, re.S)    
    return mypage_Info


def SavePageResults(save_path, filename, slist):
    ''' save (title: url) to file'''
    if not os.path.exists(save_path):
        os.makedirs(save_path)
    path = save_path+"/"+filename+".txt"
    with open(path, "w") as f:
        for s in slist:
            try:
                f.write("%s\t\t%s\n" % (s[0], s[1]))
            except:
                pass
            
            
def New_Page_Info(newPage):
    '''Regex(slowly) or Xpath(fast)'''
    #new_page_Info = re.findall(r'<td class=".*?">.*?<a href="(.*?)\.html".*?>(.*?)</a></td>', new_page, re.S)    
    # results = []
    # for url, item in new_page_Info:
    #     results.append((item, url+".html"))
    # return results
    dom = etree.HTML(new_page)
    new_items = dom.xpath('//tr/td/a/text()')
    new_urls = dom.xpath('//tr/td/a/@href')
    assert(len(new_items) == len(new_urls))
    return zip(new_items, new_urls)



if __name__ == '__main__':
    #set header to cheat server
    requestheaders = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36'} #F12--Network--Headers
    response = requests.get(target_url,headers = requestheaders, timeout=5)#response = requests.get(url, proxies=myproxies)
    if response.status_code != 200:
        print('error', response.status_code)
    #for name,value in response.headers.items():
    #    print("%s:%s" % (name, value))    
        
    myPage = response.content.decode("gbk")        
    myPageResults = Page_Info(myPage)
    save_path = u"??????????????????"
    filename = u"???????????????"
    SavePageResults(save_path, filename, myPageResults)
    
    i = 1
    for title,url in myPageResults:
        time.sleep(1)#to avoid frequently visit
        print('downloading ', url)
        new_page = requests.get(url).content.decode('gbk')
        newPageResults = New_Page_Info(new_page)
        filename = str(i)+"_"+title
        SavePageResults(save_path, filename, newPageResults)
        i +=1 
        
    print('scrapy ok !')
    
    
    
    
//////////////////////////////////output: 
???????????????.txt,???18????????????1??????????????????
??????		http://news.163.com/special/0001386F/rank_whole.html
??????		http://news.163.com/special/0001386F/rank_news.html
??????		http://news.163.com/special/0001386F/rank_ent.html
??????		http://news.163.com/special/0001386F/rank_sports.html
....
/////??????.txt
??????????????????????????????????????????????????????????????????		http://news.163.com/18/0318/08/DD5S14TQ0001875N.html
???????????????16?????????36???????????? ?????????????????????		http://news.163.com/18/0318/00/DD512PSS0001875P.html
???????????????????????????????????? ??????????????????		http://news.163.com/18/0318/15/DD6M38350001899N.html
?????????????????????????????? ????????????????????????????????? 		http://news.163.com/18/0318/16/DD6PD3500001899N.html
    
    
    
    
    
    
    
    
    
    
    
