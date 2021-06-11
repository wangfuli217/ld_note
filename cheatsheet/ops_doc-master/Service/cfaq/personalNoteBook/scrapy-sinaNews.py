# -*- coding: utf-8 -*-
"""
Created on Wed Mar 21 22:56:42 2018

@author: lianzeng
"""

# 获取新闻的标题，内容，时间和评论数
import requests
from bs4 import BeautifulSoup
import re

#df = pandas.DataFrame(result)
#df.to_excel('news2.xlsx')
url='http://roll.news.sina.com.cn/s/channel.php?ch=01#col=89&spec=&type=&ch=01&k=&offset_page=0&offset_num=0&num=60&asc=&page=1'    
res = requests.get(url)
res.encoding = 'gb2312' #F12--Sources:<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
soup = BeautifulSoup(res.text,'html.parser')
newsTitle = soup.select('.c_tit')[0].text.strip()
newsTime = soup.select('.c_time')[0].text.strip()
urlinfo = str(soup.select('.c_tit')[0])
link=re.findall(r'<span class="c_tit"><a href="(.*?)" target="_blank">.*?</a></span>', urlinfo, re.S)
print(newsTitle)
print(newsTime)
print(link[0])
