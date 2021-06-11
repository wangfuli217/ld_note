#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Function:   Used to demostrate how to use Python code to emulate login baidu main page: http://www.baidu.com/
            Use the functions from crifanLib.py
Note:       Before try to understand following code, firstly, please read the related articles:
            (1)【整理】关于抓取网页，分析网页内容，模拟登陆网站的逻辑/流程和注意事项

http://www.crifan.com/summary_about_flow_process_of_fetch_webpage_simulate_login_website_and_some_notice/

            (2) 【教程】手把手教你如何利用工具(IE9的F12)去分析模拟登陆网站(百度首页)的内部逻辑过程

http://www.crifan.com/use_ie9_f12_to_analysis_the_internal_logical_process_of_login_baidu_main_page_website/

            (3) 【教程】模拟登陆网站 之 Python版

http://www.crifan.com/emulate_login_website_using_python

Version:    2012-11-07
Author:     Crifan
Contact:    admin (at) crifan.com
"""

import re;
import cookielib;
import urllib;
import urllib2;
import optparse;

#===============================================================================
# following are some functions, extracted from my python library: crifanLib.py
# for the whole crifanLib.py:
# online browser: http://code.google.com/p/crifanlib/source/browse/trunk/python/crifanLib.py
# download      : http://code.google.com/p/crifanlib/downloads/list
#===============================================================================

import zlib;

gConst = {
    'constUserAgent' : 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.3; .NET4.0C; .NET4.0E)',
    #'constUserAgent' : "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20100101 Firefox/15.0.1",
}

################################################################################
# Network: urllib/urllib2/http
################################################################################

#------------------------------------------------------------------------------
# get response from url
# note: if you have already used cookiejar, then here will automatically use it
# while using rllib2.Request
def getUrlResponse(url, postDict={}, headerDict={}, timeout=0, useGzip=False) :
    # makesure url is string, not unicode, otherwise urllib2.urlopen will error
    url = str(url);

    if (postDict) :
        postData = urllib.urlencode(postDict);
        req = urllib2.Request(url, postData);
        req.add_header('Content-Type', "application/x-www-form-urlencoded");
    else :
        req = urllib2.Request(url);

    if(headerDict) :
        #print "added header:",headerDict;
        for key in headerDict.keys() :
            req.add_header(key, headerDict[key]);

    defHeaderDict = {
        'User-Agent'    : gConst['constUserAgent'],
        'Cache-Control' : 'no-cache',
        'Accept'        : '*/*',
        'Connection'    : 'Keep-Alive',
    };

    # add default headers firstly
    for eachDefHd in defHeaderDict.keys() :
        #print "add default header: %s=%s"%(eachDefHd,defHeaderDict[eachDefHd]);
        req.add_header(eachDefHd, defHeaderDict[eachDefHd]);

    if(useGzip) :
        #print "use gzip for",url;
        req.add_header('Accept-Encoding', 'gzip, deflate');

    # add customized header later -> allow overwrite default header
    if(headerDict) :
        #print "added header:",headerDict;
        for key in headerDict.keys() :
            req.add_header(key, headerDict[key]);

    if(timeout > 0) :
        # set timeout value if necessary
        resp = urllib2.urlopen(req, timeout=timeout);
    else :
        resp = urllib2.urlopen(req);

    return resp;

#------------------------------------------------------------------------------
# get response html==body from url
#def getUrlRespHtml(url, postDict={}, headerDict={}, timeout=0, useGzip=False) :
def getUrlRespHtml(url, postDict={}, headerDict={}, timeout=0, useGzip=True) :
    resp = getUrlResponse(url, postDict, headerDict, timeout, useGzip);
    respHtml = resp.read();
    if(useGzip) :
        #print "---before unzip, len(respHtml)=",len(respHtml);
        respInfo = resp.info();

        # Server: nginx/1.0.8
        # Date: Sun, 08 Apr 2012 12:30:35 GMT
        # Content-Type: text/html
        # Transfer-Encoding: chunked
        # Connection: close
        # Vary: Accept-Encoding
        # ...
        # Content-Encoding: gzip

        # sometime, the request use gzip,deflate, but actually returned is un-gzip html
        # -> response info not include above "Content-Encoding: gzip"
        # eg: http://blog.sina.com.cn/s/comment_730793bf010144j7_3.html
        # -> so here only decode when it is indeed is gziped data
        if( ("Content-Encoding" in respInfo) and (respInfo['Content-Encoding'] == "gzip")) :
            respHtml = zlib.decompress(respHtml, 16+zlib.MAX_WBITS);
            #print "+++ after unzip, len(respHtml)=",len(respHtml);

    return respHtml;

################################################################################
# Cookies
################################################################################

#------------------------------------------------------------------------------
# check all cookies in cookiesDict is exist in cookieJar or not
def checkAllCookiesExist(cookieNameList, cookieJar) :
    cookiesDict = {};
    for eachCookieName in cookieNameList :
        cookiesDict[eachCookieName] = False;

    allCookieFound = True;
    for cookie in cookieJar :
        if(cookie.name in cookiesDict) :
            cookiesDict[cookie.name] = True;

    for eachCookie in cookiesDict.keys() :
        if(not cookiesDict[eachCookie]) :
            allCookieFound = False;
            break;

    return allCookieFound;

#===============================================================================

#------------------------------------------------------------------------------
# just for print delimiter
def printDelimiter():
    print '-'*80;

#------------------------------------------------------------------------------
# main function to emulate login baidu
def emulateLoginBaidu():
    print "Function: Used to demostrate how to use Python code to emulate login baidu main page: http://www.baidu.com/";
    print "Usage: emulate_login_baidu_python.py -u yourBaiduUsername -p yourBaiduPassword";
    printDelimiter();

    # parse input parameters
    parser = optparse.OptionParser();
    parser.add_option("-u","--username",action="store",type="string",default='',dest="username",help="Your Baidu Username");
    parser.add_option("-p","--password",action="store",type="string",default='',dest="password",help="Your Baidu password");
    (options, args) = parser.parse_args();
    # export all options variables, then later variables can be used
    for i in dir(options):
        exec(i + " = options." + i);

    printDelimiter();
    print "[preparation] using cookieJar & HTTPCookieProcessor to automatically handle cookies";
    cj = cookielib.CookieJar();
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj));
    urllib2.install_opener(opener);

    printDelimiter();
    print "[step1] to get cookie BAIDUID";
    baiduMainUrl = "http://www.baidu.com/";
    resp = getUrlResponse(baiduMainUrl);
    # here you should see: BAIDUID
    for index, cookie in enumerate(cj):
        print '[',index, ']',cookie;

    printDelimiter();
    print "[step2] to get token value";
    getapiUrl = "https://passport.baidu.com/v2/api/?getapi&class=login&tpl=mn&tangram=true";
    getapiRespHtml = getUrlRespHtml(getapiUrl);
    #bdPass.api.params.login_token='5ab690978812b0e7fbbe1bfc267b90b3';
    foundTokenVal = re.search("bdPass\.api\.params\.login_token='(?P<tokenVal>\w+)';", getapiRespHtml);
    if(foundTokenVal):
        tokenVal = foundTokenVal.group("tokenVal");
        print "tokenVal=",tokenVal;

        printDelimiter();
        print "[step3] emulate login baidu";
        staticpage = "http://www.baidu.com/cache/user/html/jump.html";
        baiduMainLoginUrl = "https://passport.baidu.com/v2/api/?login";
        postDict = {
            #'ppui_logintime': "",
            'charset'       : "utf-8",
            #'codestring'    : "",
            'token'         : tokenVal, #de3dbf1e8596642fa2ddf2921cd6257f
            'isPhone'       : "false",
            'index'         : "0",
            #'u'             : "",
            #'safeflg'       : "0",
            'staticpage'    : staticpage, #http%3A%2F%2Fwww.baidu.com%2Fcache%2Fuser%2Fhtml%2Fjump.html
            'loginType'     : "1",
            'tpl'           : "mn",
            'callback'      : "parent.bdPass.api.login._postCallback",
            'username'      : username,
            'password'      : password,
            #'verifycode'    : "",
            'mem_pass'      : "on",
        };
        loginRespHtml = getUrlRespHtml(baiduMainLoginUrl, postDict);
        cookiesToCheck = ['BDUSS', 'PTOKEN', 'STOKEN', 'SAVEUSERID'];
        loginBaiduOK = checkAllCookiesExist(cookiesToCheck, cj);
        if(loginBaiduOK):
            print "+++ Emulate login baidu is OK, ^_^";
        else:
            print "--- Failed to emulate login baidu !"
    else:
        print "Fail to extract token value from html=",getapiRespHtml;

if __name__=="__main__":
    emulateLoginBaidu();
