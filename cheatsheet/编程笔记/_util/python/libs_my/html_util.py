#!python
# -*- coding:utf-8 -*-
'''
公用函数(html字符串处理)
Created on 2015/1/19
Updated on 2016/2/16
@author: Holemar
'''
import re

__all__=('to_html', 'to_text', 'remove_htmlTag')


def to_html(sour, *args, **kwargs):
    '''
    @summary: 转换字符串成 Html 页面上显示的编码
    @param {string} sour: 需要转换的字符串
    @return {string}: 转换后的字符串
    @example to_html(" ") 返回: &nbsp;
    '''
    # 以下逐一转换
    sour = sour.replace("&", "&amp;")
    sour = sour.replace("%", "&#37;")
    sour = sour.replace("<", "&lt;")
    sour = sour.replace(">", "&gt;")
    sour = sour.replace("\n", "\n<br/>")
    sour = sour.replace('"', "&quot;")
    sour = sour.replace(" ", "&nbsp;")
    sour = sour.replace("'", "&#39;")
    sour = sour.replace("+", "&#43;")
    return sour

def to_text(sour, *args, **kwargs):
    '''
    @summary: 转换字符串由 Html 页面上显示的编码变回正常编码(以上面的方法对应)
    @param sour: 需要转换的字符串
    @return {string}:转换后的字符串
    @example to_text("&nbsp;") 返回: " "
    '''
    # 以下逐一转换
    # 先转换百分号
    sour = sour.replace("&#37;", "%")
    # 小于号,有三种写法
    sour = sour.replace("&lt;", "<")
    sour = sour.replace("&LT;", "<")
    sour = sour.replace("&#60;", "<")
    # 大于号,有三种写法
    sour = sour.replace("&gt;", ">")
    sour = sour.replace("&GT;", ">")
    sour = sour.replace("&#62;", ">")
    # 单引号
    sour = sour.replace("&#39;", "'")
    sour = sour.replace("&#43;", "+")
    # 转换换行符号
    sour = re.sub(r'\n?<[Bb][Rr]\s*/?>\n?', '\n', sour)
    # 双引号号,有三种写法
    sour = sour.replace("&quot;", '"')
    sour = sour.replace("&QUOT;", '"')
    sour = sour.replace("&#34;", '"')
    # 空格,只有两种写法, &NBSP; 浏览器不承认
    sour = sour.replace("&nbsp;", " ")
    sour = sour.replace("&#160;", " ")
    # & 符号,最后才转换
    sour = sour.replace("&amp;", "&")
    sour = sour.replace("&AMP;", "&")
    sour = sour.replace("&#38;", "&")
    return sour

def remove_htmlTag(text, *args, **kwargs):
    '''
    @summary: 清除HTML标签
    @return {string}:清除标签后的内容
    @example remove_htmlTag("<div>haha</div>") 返回: "haha"
    '''
    # 清除注释
    text = text.strip().replace("<!--.*-->", "")
    # 标题换行: </title> ==> 换行符
    text = re.sub(r'</[Tt][Ii][Tt][Ll][Ee]>', '\n', text)
    # 换行符换行: <br/> ==> 换行符
    text = re.sub(r'\n?<[Bb][Rr]\s*/?>\n?', '\n', text)
    # tr换行: </tr> ==> 换行符
    text = re.sub(r'</[Tt][Rr]>', '\n', text)
    # html標籤清除
    text = re.sub(r'<[^>]+>', '', text)
    # 转换字符串由 Html 页面上显示的编码变回正常编码
    text = to_text(text)
    return text.strip()

