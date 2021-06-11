#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
[Filename]
crifanLib.py

[Function]
crifan's common functions, implemented by Python.

[Note]
1. install chardet and BeautifulSoup before use this crifanLib.

[TODO]
1. use htmlentitydefs instead of mannually made html entity table

[History]
[v2.4]
1. add another manuallyDownloadFile with headerDict support

[v2.3]
1. add removeSoupContentsTagAttr, findFirstNavigableString, soupContentsToUnicode

[v2.0]
1. add tupleListToDict

[v1.9]
1.add randDigitsStr

[v1.8]
1.bugfix-> isFileValid support unquoted & lower for compare filename

[v1.7]
1.bugfix-> isFileValid support quoted & lower for compare filename

[v1.6]
1.add getCurTimestamp

[v1.5]
1.add timeout for all urllib2.urlopen to try to avoid dead url link

[v1.4]
1.add support overwrite header for getUrlResponse
2.add gzip support for getUrlResponse and getUrlRespHtml

"""

__author__ = "Crifan Li (admin@crifan.com)"
#__version__ = ""
__copyright__ = "Copyright (c) 2012, Crifan Li"
__license__ = "GPL"

import os;
import re;
import sys;
import time;
import chardet;
import urllib;
import urllib2;
from datetime import datetime,timedelta;
from BeautifulSoup import BeautifulSoup,Tag,CData;
import logging;
#import htmlentitydefs;
import struct;
import zlib;

import random;

# from PIL import Image;
# from operator import itemgetter;


#--------------------------------const values-----------------------------------
__VERSION__ = "v2.4";

gConst = {
    'constUserAgent' : 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.3; .NET4.0C; .NET4.0E)',
    #'constUserAgent' : "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20100101 Firefox/15.0.1",
    
    # also belong to ContentTypes, more info can refer: http://kenya.bokee.com/3200033.html
    # here use Tuple to avoid unexpected change
    # note: for tuple, refer item use tuple[i], not tuple(i)
    'picSufList'   : ('bmp', 'gif', 'jpeg', 'jpg', 'jpe', 'png', 'tiff', 'tif'),
    
    'defaultTimeout': 20, # default timeout seconds for urllib2.urlopen
}

#----------------------------------global values--------------------------------
gVal = {
    'calTimeKeyDict'    : {},
    'picSufChars'       : '', # store the pic suffix char list
    
    'currentLevel'      : 0,
}

#### some internal functions ###
#------------------------------------------------------------------------------
# generate the suffix char list according to constont picSufList
def genSufList() :
    global gConst;
    
    sufChrList = [];
    for suffix in gConst['picSufList'] :
        for c in suffix :
            sufChrList.append(c);
    sufChrList = uniqueList(sufChrList);
    sufChrList.sort();
    joinedSuf = ''.join(sufChrList);

    swapedSuf = [];
    swapedSuf = joinedSuf.swapcase();

    wholeSuf = joinedSuf + swapedSuf;

    return wholeSuf;
    
################################################################################
# Time
################################################################################

#------------------------------------------------------------------------------
# get current time's timestamp
# 1351670162
def getCurTimestamp() :
    return datetimeToTimestamp(datetime.now());

#------------------------------------------------------------------------------
# convert datetime value to timestamp
# from "2006-06-01 00:00:00" to 1149091200
def datetimeToTimestamp(datetimeVal) :
    return int(time.mktime(datetimeVal.timetuple()));

#------------------------------------------------------------------------------
# convert timestamp to datetime value
# from 1149091200 to "2006-06-01 00:00:00"
def timestampToDatetime(timestamp) :
    #print "type(timestamp)=",type(timestamp);
    #print "timestamp=",timestamp;
    #timestamp = int(timestamp);
    timestamp = float(timestamp);
    return datetime.fromtimestamp(timestamp);

#------------------------------------------------------------------------------
#init for calculate elapsed time 
def calcTimeStart(uniqueKey) :
    global gVal

    gVal['calTimeKeyDict'][uniqueKey] = time.time();
    return

#------------------------------------------------------------------------------
# to get elapsed time, before call this, should use calcTimeStart to init
def calcTimeEnd(uniqueKey) :
    global gVal

    return time.time() - gVal['calTimeKeyDict'][uniqueKey];

#------------------------------------------------------------------------------
# convert local GMT8 to GMT time
# note: input should be 'datetime' type, not 'time' type
def convertLocalToGmt(localTime) :
    return localTime - timedelta(hours=8);

################################################################################
# String
################################################################################

#------------------------------------------------------------------------------
# generated the random digits number string
# max digit number is 12
def randDigitsStr(digitNum = 12) :
    if(digitNum > 12):
        digitNum = 12;

    randVal = random.random();
    #print "randVal=",randVal; #randVal= 0.134248340235
    randVal = str(randVal);
    #print "randVal=",randVal; #randVal= 0.134248340235
    
    randVal = randVal.replace("0.", "");
    #print "randVal=",randVal; #randVal= 0.134248340235
    
    # if last is 0, append that 0    
    if(len(randVal)==11):
        randVal = randVal + "0";
    #print "randVal=",randVal; #randVal= 0.134248340235
    
    #randVal = randVal.replace("e+11", "");
    #randVal = randVal.replace(".", "");
    #print "randVal=",randVal; #randVal= 0.134248340235
    randVal = randVal[0 : digitNum];
    #print "randVal=",randVal; #randVal= 0.134248340235
    
    return randVal;

#------------------------------------------------------------------------------
# get supported picture suffix list
def getPicSufList():
    return gConst['picSufList'];

#------------------------------------------------------------------------------
# get supported picture suffix chars
def getPicSufChars():
    return gVal['picSufChars'];

#------------------------------------------------------------------------------
# got python script self file name
# extract out xxx from:
# D:\yyy\zzz\xxx.py
# xxx.py
def extractFilename(inputStr) :
    argv0List = inputStr.split("\\");
    scriptName = argv0List[len(argv0List) - 1]; # get script file name self
    possibleSuf = scriptName[-3:];
    if possibleSuf == ".py" :
        scriptName = scriptName[0:-3]; # remove ".py"
    return scriptName;

#------------------------------------------------------------------------------
# replace the &#N; (N is digit number, N > 1) to unicode char
# eg: replace "&amp;#39;" with "'" in "Creepin&#39; up on you"
def repUniNumEntToChar(text):
    unicodeP = re.compile('&#[0-9]+;');
    def transToUniChr(match): # translate the matched string to unicode char
        numStr = match.group(0)[2:-1]; # remove '&#' and ';'
        num = int(numStr);
        unicodeChar = unichr(num);
        return unicodeChar;
    return unicodeP.sub(transToUniChr, text);

#------------------------------------------------------------------------------
# generate the full url, which include the main url plus the parameter list
# Note: 
# normally just use urllib.urlencode is OK.
# only use this if you do NOT want urllib.urlencode convert some special chars($,:,{,},...) into %XX
def genFullUrl(mainUrl, paraDict) :
    fullUrl = mainUrl;
    fullUrl += '?';
    for i, para in enumerate(paraDict.keys()) :
        if(i == 0):
            # first para no '&'
            fullUrl += str(para) + '=' + str(paraDict[para]);
        else :
            fullUrl += '&' + str(para) + '=' + str(paraDict[para]);
    return fullUrl;

#------------------------------------------------------------------------------
# check whether two url is similar
# note: input two url both should be str type
def urlIsSimilar(url1, url2) :
    isSim = False;

    url1 = str(url1);
    url2 = str(url2);

    slashList1 = url1.split('/');
    slashList2 = url2.split('/');
    lenS1 = len(slashList1);
    lenS2 = len(slashList2);

    # all should have same structure
    if lenS1 != lenS2 :
        # not same sturcture -> must not similar
        isSim = False;
    else :
        sufPos1 = url1.rfind('.');
        sufPos2 = url2.rfind('.');
        suf1 = url1[(sufPos1 + 1) : ];
        suf2 = url2[(sufPos2 + 1) : ];
        # at least, suffix should same
        if (suf1 == suf2) : 
            lastSlashPos1 = url1.rfind('/');
            lastSlashPos2 = url2.rfind('/');
            exceptName1 = url1[:lastSlashPos1];
            exceptName2 = url2[:lastSlashPos2];
            # except name, all other part should same
            if (exceptName1 == exceptName2) :
                isSim = True;
            else :
                # except name, other part is not same -> not similar
                isSim = False;
        else :
            # suffix not same -> must not similar
            isSim = False;

    return isSim;

#------------------------------------------------------------------------------
# found whether the url is similar in urlList
# if found, return True, similarSrcUrl
# if not found, return False, ''
def findSimilarUrl(url, urlList) :
    (isSimilar, similarSrcUrl) = (False, '');
    for srcUrl in urlList :
        if urlIsSimilar(url, srcUrl) :
            isSimilar = True;
            similarSrcUrl = srcUrl;
            break;
    return (isSimilar, similarSrcUrl);

#------------------------------------------------------------------------------
# remove non-word char == only retian alphanumeric character (char+number) and underscore
# eg:
# from againinput4@yeah to againinput4yeah
# from green-waste to greenwaste
def removeNonWordChar(inputString) :
    return re.sub(r"[^\w]", "", inputString); # non [a-zA-Z0-9_]

#------------------------------------------------------------------------------
# remove control character from input string
# otherwise will cause wordpress importer import failed
# for wordpress importer, if contains contrl char, will fail to import wxr
# eg:
# 1. http://againinput4.blog.163.com/blog/static/172799491201110111145259/
# content contains some invalid ascii control chars
# 2. http://hi.baidu.com/notebookrelated/blog/item/8bd88e351d449789a71e12c2.html
# 165th comment contains invalid control char: ETX
# 3. http://green-waste.blog.163.com/blog/static/32677678200879111913911/
# title contains control char:DC1, BS, DLE, DLE, DLE, DC1
def removeCtlChr(inputString) :
    validContent = '';
    for c in inputString :
        asciiVal = ord(c);
        validChrList = [
            9, # 9=\t=tab
            10, # 10=\n=LF=Line Feed=换行
            13, # 13=\r=CR=回车
        ];
        # filter out others ASCII control character, and DEL=delete
        isValidChr = True;
        if (asciiVal == 0x7F) :
            isValidChr = False;
        elif ((asciiVal < 32) and (asciiVal not in validChrList)) :
            isValidChr = False;
        
        if(isValidChr) :
            validContent += c;

    return validContent;

#------------------------------------------------------------------------------
# remove ANSI control character: 0x80-0xFF
def removeAnsiCtrlChar(inputString):
    validContent = '';
    for c in inputString :
        asciiVal = ord(c);
        isValidChr = True;
        if ((asciiVal >= 0x80) and (asciiVal <= 0xFF)) :
        #if ((asciiVal >= 0xB0) and (asciiVal <= 0xFF)) : # test
            isValidChr = False;
            #print "asciiVal=0x%x"%asciiVal;

        if(isValidChr) :
            validContent += c;
    return validContent;

#------------------------------------------------------------------------------
# convert the string entity to unicode unmber entity
# refer: http://www.htmlhelp.com/reference/html40/entities/latin1.html
# TODO: need later use this htmlentitydefs instead following
def replaceStrEntToNumEnt(text) :
    strToNumEntDict = {
        # Latin-1 Entities
        "&nbsp;"	:   "&#160;",
        "&iexcl;"	:   "&#161;",
        "&cent;"    :   "&#162;",
        "&pound;"	:   "&#163;",
        "&curren;"	:   "&#164;",
        "&yen;"	    :   "&#165;",
        "&brvbar;"	:   "&#166;",
        "&sect;"	:   "&#167;",
        "&uml;"	    :   "&#168;",
        "&copy;"	:   "&#169;",
        "&ordf;"	:   "&#170;",
        "&laquo;"	:   "&#171;",
        "&not;"	    :   "&#172;",
        "&shy;"	    :   "&#173;",
        "&reg;"	    :   "&#174;",
        "&macr;"	:   "&#175;",
        "&deg;"	    :   "&#176;",
        "&plusmn;"	:   "&#177;",
        "&sup2;"	:   "&#178;",
        "&sup3;"	:   "&#179;",
        "&acute;"	:   "&#180;",
        "&micro;"	:   "&#181;",
        "&para;"	:   "&#182;",
        "&middot;"	:   "&#183;",
        "&cedil;"	:   "&#184;",
        "&sup1;"    :   "&#185;",
        "&ordm;"    :   "&#186;",
        "&raquo;"	:   "&#187;",
        "&frac14;"	:   "&#188;",
        "&frac12;"	:   "&#189;",
        "&frac34;"	:   "&#190;",
        "&iquest;"	:   "&#191;",
        "&Agrave;"	:   "&#192;",
        "&Aacute;"	:   "&#193;",
        "&Acirc;"	:   "&#194;",
        "&Atilde;"	:   "&#195;",
        "&Auml;"	:   "&#196;",
        "&Aring;"	:   "&#197;",
        "&AElig;"	:   "&#198;",
        "&Ccedil;"	:   "&#199;",
        "&Egrave;"	:   "&#200;",
        "&Eacute;"	:   "&#201;",
        "&Ecirc;"	:   "&#202;",
        "&Euml;"    :   "&#203;",
        "&Igrave;"	:   "&#204;",
        "&Iacute;"	:   "&#205;",
        "&Icirc;"	:   "&#206;",
        "&Iuml;"    :   "&#207;",
        "&ETH;"	    :   "&#208;",
        "&Ntilde;"	:   "&#209;",
        "&Ograve;"	:   "&#210;",
        "&Oacute;"	:   "&#211;",
        "&Ocirc;"	:   "&#212;",
        "&Otilde;"	:   "&#213;",
        "&Ouml;"	:   "&#214;",
        "&times;"	:   "&#215;",
        "&Oslash;"	:   "&#216;",
        "&Ugrave;"	:   "&#217;",
        "&Uacute;"	:   "&#218;",
        "&Ucirc;"	:   "&#219;",
        "&Uuml;"	:   "&#220;",
        "&Yacute;"	:   "&#221;",
        "&THORN;"	:   "&#222;",
        "&szlig;"	:   "&#223;",
        "&agrave;"	:   "&#224;",
        "&aacute;"	:   "&#225;",
        "&acirc;"	:   "&#226;",
        "&atilde;"	:   "&#227;",
        "&auml;"	:   "&#228;",
        "&aring;"	:   "&#229;",
        "&aelig;"	:   "&#230;",
        "&ccedil;"	:   "&#231;",
        "&egrave;"	:   "&#232;",
        "&eacute;"	:   "&#233;",
        "&ecirc;"	:   "&#234;",
        "&euml;"	:   "&#235;",
        "&igrave;"	:   "&#236;",
        "&iacute;"	:   "&#237;",
        "&icirc;"	:   "&#238;",
        "&iuml;"	:   "&#239;",
        "&eth;"	    :   "&#240;",
        "&ntilde;"	:   "&#241;",
        "&ograve;"	:   "&#242;",
        "&oacute;"	:   "&#243;",
        "&ocirc;"	:   "&#244;",
        "&otilde;"	:   "&#245;",
        "&ouml;" 	:   "&#246;",
        "&divide;"	:   "&#247;",
        "&oslash;"	:   "&#248;",
        "&ugrave;"	:   "&#249;",
        "&uacute;"	:   "&#250;",
        "&ucirc;"	:   "&#251;",
        "&uuml;"	:   "&#252;",
        "&yacute;"	:   "&#253;",
        "&thorn;"	:   "&#254;",
        "&yuml;"	:   "&#255;",
        # http://www.htmlhelp.com/reference/html40/entities/special.html
        # Special Entities
        "&quot;"    : "&#34;",
        "&amp;"     : "&#38;",
        "&lt;"      : "&#60;",
        "&gt;"      : "&#62;",
        "&OElig;"   : "&#338;",
        "&oelig;"   : "&#339;",
        "&Scaron;"  : "&#352;",
        "&scaron;"  : "&#353;",
        "&Yuml;"    : "&#376;",
        "&circ;"    : "&#710;",
        "&tilde;"   : "&#732;",
        "&ensp;"    : "&#8194;",
        "&emsp;"    : "&#8195;",
        "&thinsp;"  : "&#8201;",
        "&zwnj;"    : "&#8204;",
        "&zwj;"     : "&#8205;",
        "&lrm;"     : "&#8206;",
        "&rlm;"     : "&#8207;",
        "&ndash;"   : "&#8211;",
        "&mdash;"   : "&#8212;",
        "&lsquo;"   : "&#8216;",
        "&rsquo;"   : "&#8217;",
        "&sbquo;"   : "&#8218;",
        "&ldquo;"   : "&#8220;",
        "&rdquo;"   : "&#8221;",
        "&bdquo;"   : "&#8222;",
        "&dagger;"  : "&#8224;",
        "&Dagger;"  : "&#8225;",
        "&permil;"  : "&#8240;",
        "&lsaquo;"  : "&#8249;",
        "&rsaquo;"  : "&#8250;",
        "&euro;"    : "&#8364;",
        }

    replacedText = text;
    for key in strToNumEntDict.keys() :
        replacedText = re.compile(key).sub(strToNumEntDict[key], replacedText);
    return replacedText;

#------------------------------------------------------------------------------
# convert the xxx=yyy into tuple('xxx', yyy), then return the tuple value
# [makesure input string]
# (1) is not include whitespace
# (2) include '='
# (3) last is no ';'
# [possible input string]
# blogUserName="againinput4"
# publisherEmail=""
# synchMiniBlog=false
# publishTime=1322129849397
# publisherName=null
# publisherNickname="\u957F\u5927\u662F\u70E6\u607C"
def convertToTupleVal(equationStr) :
    (key, value) = ('', None);

    try :
        # Note:
        # here should not use split with '=', for maybe input string contains string like this:
        # http://img.bimg.126.net/photo/hmZoNQaqzZALvVp0rE7faA==/0.jpg
        # so use find('=') instead
        firstEqualPos = equationStr.find("=");
        key = equationStr[0:firstEqualPos];
        valuePart = equationStr[(firstEqualPos + 1):];

        # string type
        valLen = len(valuePart);
        if valLen >= 2 :
            # maybe string
            if valuePart[0] == '"' and valuePart[-1] == '"' :
                # is string type
                value = str(valuePart[1:-1]);
            elif (valuePart.lower() == 'null'):
                value = None;
            elif (valuePart.lower() == 'false'):
                value = False;
            elif (valuePart.lower() == 'true') :
                value = True;
            else :
                # must int value
                value = int(valuePart);
        else :
            # len=1 -> must be value
            value = int(valuePart);

        #print "Convert %s to [%s]=%s"%(equationStr, key, value);
    except :
        (key, value) = ('', None);
        print "Fail of convert the equal string %s to value"%(equationStr);

    return (key, value);


################################################################################
# List
################################################################################

#------------------------------------------------------------------------------
# remove the empty ones in list
def removeEmptyInList(list) :
    newList = [];
    for val in list :
        if val :
            newList.append(val);
    return newList;

#------------------------------------------------------------------------------
# remove overlapped item in the list
def uniqueList(old_list):
    newList = []
    for x in old_list:
        if x not in newList :
            newList.append(x)
    return newList

#------------------------------------------------------------------------------
# for listToFilter, remove the ones which is in listToCompare
# also return the ones which is already exist in listToCompare
def filterList(listToFilter, listToCompare) :
    filteredList = [];
    existedList = [];
    for singleOne in listToFilter : # remove processed
        if (not(singleOne in listToCompare)) :
            # omit the ones in listToCompare
            filteredList.append(singleOne);
        else :
            # record the already exist ones
            existedList.append(singleOne);
    return (filteredList, existedList);
    
#------------------------------------------------------------------------------
# convert tuple list to dict value
# [(u'type', u'text/javascript'), (u'src', u'http://partner.googleadservices.com/gampad/google_service.js')]
# { u'type':u'text/javascript', u'src':u'http://partner.googleadservices.com/gampad/google_service.js' }
def tupleListToDict(tupleList):
    convertedDict = {};
    
    for eachTuple in tupleList:
        (key, value) = eachTuple;
        convertedDict[key] = value;
    
    return convertedDict;

################################################################################
# File
################################################################################

#------------------------------------------------------------------------------
# save binary data into file
def saveBinDataToFile(binaryData, fileToSave):
    saveOK = False;
    try:
        savedBinFile = open(fileToSave, "wb"); # open a file, if not exist, create it
        #print "savedBinFile=",savedBinFile;
        savedBinFile.write(binaryData);
        savedBinFile.close();
        saveOK = True;
    except :
        saveOK = False;
    return saveOK;


################################################################################
# Network: urllib/urllib2/http
################################################################################

#------------------------------------------------------------------------------
# check file validation:
# open file url to check return info is match or not
# with exception support
# note: should handle while the file url is redirect
# eg :
# http://publish.it168.com/2007/0627/images/500754.jpg ->
# http://img.publish.it168.com/2007/0627/images/500754.jpg
# other special one:
# sina pic url: 
# http://s14.sinaimg.cn/middle/3d55a9b7g9522d474a84d&690
# http://s14.sinaimg.cn/orignal/3d55a9b7g9522d474a84d
# the real url is same with above url
def isFileValid(fileUrl) :
    fileIsValid = False;
    errReason = "Unknown error";

    try :
        #print "original fileUrl=",fileUrl;
        origFileName = fileUrl.split('/')[-1];
        #print "origFileName=",origFileName;
        
        #old: https://ie2zeq.bay.livefilestore.com/y1mo7UWr-TrmqbBhkw52I0ii__WE6l2UtMRSTZHSky66-uDxnCdKPr3bdqVrpUcQHcoJLedlFXa43bvCp_O0zEGF3JdG_yZ4wRT-c2AQmJ_TNcWvVZIXfBDgGerouWyx19WpA4I0XQR1syRJXjDNpwAbQ/IMG_5214_thumb[1].jpg
        #new: https://kxoqva.bay.livefilestore.com/y1mQlGjwNAYiHKoH5Aw6TMNhsCmX2YDR3vPKnP86snuqQEtnZgy3dHkwUvZ61Ah8zU3AGiS4whmm_ADrvxdufEAfMGo56KjLdhIbosn9F34olQ/IMG_5214_thumb%5b1%5d.jpg
        unquotedOrigFilenname = urllib.unquote(origFileName);
        #print "unquotedOrigFilenname=",unquotedOrigFilenname
        lowUnquotedOrigFilename = unquotedOrigFilenname.lower();
        #print "lowUnquotedOrigFilename=",lowUnquotedOrigFilename;
        
        resp = urllib2.urlopen(fileUrl, timeout=gConst['defaultTimeout']); # note: Python 2.6 has added timeout support.
        #print "resp=",resp;
        realUrl = resp.geturl();
        #print "realUrl=",realUrl;
        newFilename = realUrl.split('/')[-1];
        #print "newFilename=",newFilename;
        
        #http://blog.sina.com.cn/s/blog_696e50390100ntxs.html
        unquotedNewFilename = urllib.unquote(newFilename);
        #print "unquotedNewFilename=",unquotedNewFilename;
        unquotedLowNewFilename = unquotedNewFilename.lower();
        #print "unquotedLowNewFilename=",unquotedLowNewFilename;
        
        respInfo = resp.info();
        #print "respInfo=",respInfo;
        respCode = resp.getcode();
        #print "respCode=",respCode;

        # special:
        # http://116.img.pp.sohu.com/images/blog/2007/5/24/17/24/11355bf42a9.jpg
        # return no content-length
        #contentLen = respInfo['Content-Length'];
        
        # for redirect, if returned size>0 and filename is same, also should be considered valid
        #if (origFileName == newFilename) and (contentLen > 0):
        # for redirect, if returned response code is 200(OK) and filename is same, also should be considered valid
        #if (origFileName == newFilename) and (respCode == 200):
        if (lowUnquotedOrigFilename == unquotedLowNewFilename) and (respCode == 200):
            fileIsValid = True;
        else :
            fileIsValid = False;
            
            # eg: Content-Type= image/gif, ContentTypes : audio/mpeg
            # more ContentTypes can refer: http://kenya.bokee.com/3200033.html
            contentType = respInfo['Content-Type'];
        
            errReason = "file url returned info: type=%s, len=%d, realUrl=%s"%(contentType, contentLen, realUrl);
    except urllib2.URLError,reason :
        fileIsValid = False;
        errReason = reason;
    except urllib2.HTTPError,code :
        fileIsValid = False;
        errReason = code;
    except :
        fileIsValid = False;
        errReason = "Unknown error";

    # here type(errReason)= <class 'urllib2.HTTPError'>, so just convert it to str
    errReason = str(errReason);
    return (fileIsValid, errReason);

#------------------------------------------------------------------------------
# download from fileUrl then save to fileToSave
# with exception support
# note: the caller should make sure the fileUrl is a valid internet resource/file
def downloadFile(fileUrl, fileToSave, needReport = False) :
    isDownOK = False;
    downloadingFile = '';

    #---------------------------------------------------------------------------
    # note: totalFileSize -> may be -1 on older FTP servers which do not return a file size in response to a retrieval request
    def reportHook(copiedBlocks, blockSize, totalFileSize) :
        #global downloadingFile
        if copiedBlocks == 0 : # 1st call : once on establishment of the network connection
            print 'Begin to download %s, total size=%d'%(downloadingFile, totalFileSize);
        else : # rest call : once after each block read thereafter
            print 'Downloaded bytes: %d' % ( blockSize * copiedBlocks);
        return;
    #---------------------------------------------------------------------------

    try :
        if fileUrl :
            downloadingFile = fileUrl;
            if needReport :
                urllib.urlretrieve(fileUrl, fileToSave, reportHook);
            else :
                urllib.urlretrieve(fileUrl, fileToSave);
            isDownOK = True;
        else :
            print "Input download file url is NULL";
    except urllib.ContentTooShortError(msg) :
        isDownOK = False;
    except :
        isDownOK = False;

    return isDownOK;

#------------------------------------------------------------------------------
# manually download fileUrl then save to fileToSave
def manuallyDownloadFile(fileUrl, fileToSave):
    isDownOK = False;
    downloadingFile = '';

    try :
        if fileUrl :
            # 1. find real address
            #print "fileUrl=",fileUrl;
            resp = urllib2.urlopen(fileUrl, timeout=gConst['defaultTimeout']);
            #print "resp=",resp;
            realUrl = resp.geturl(); # not same with original file url if redirect
            
            # if url is invalid, then add timeout can avoid dead
            respHtml = getUrlRespHtml(realUrl, useGzip=False, timeout=gConst['defaultTimeout']);
            
            isDownOK = saveBinDataToFile(respHtml, fileToSave);
        else :
            print "Input download file url is NULL";
    except urllib.ContentTooShortError(msg) :
        isDownOK = False;
    except :
        isDownOK = False;

    return isDownOK;

#------------------------------------------------------------------------------
# manually download fileUrl then save to fileToSave, with header support
def manuallyDownloadFile(fileUrl, fileToSave, headerDict):
    isDownOK = False;
    downloadingFile = '';

    try :
        if fileUrl :
            respHtml = getUrlRespHtml(fileUrl, headerDict=headerDict,useGzip=False, timeout=gConst['defaultTimeout']);
            if(respHtml):
                isDownOK = saveBinDataToFile(respHtml, fileToSave);
        else :
            print "Input download file url is NULL";
    except urllib.ContentTooShortError(msg) :
        isDownOK = False;
    except :
        isDownOK = False;

    return isDownOK;

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

################################################################################
# Image
################################################################################

# import Image,ImageEnhance,ImageFilter;


# def testCaptcha():
    # #http://www.pythonclub.org/project/captcha/python-pil
    
    # #image_name = "20120409_134346_captcha.jpg";
    # #image_name = "20120409_134531_captcha.jpg";
    # #image_name = "20120409_134625_captcha.jpg";
    # #image_name = "20120409_134928_captcha.jpg";
    # image_name = "20120409_135233_captcha.jpg";
    
    # im = Image.open(image_name);
    # print "open OK for=",image_name;
    # filter = ImageFilter.MedianFilter();
    # print "MedianFilter OK";
    # im = im.filter(filter);
    # print "filter OK";
    # enhancer = ImageEnhance.Contrast(im);
    # print "Contrast OK";
    # im = enhancer.enhance(2);
    # print "enhance OK"; 
    # im = im.convert('1');
    # print "convert OK"; 
    # #im.show()
    # #print "show OK"; 
    
    # im.save(image_name + "_new.gif"); 
    # print "save OK"; 
    
    # ooooooooooooooooo

# #------------------------------------------------------------------------------
# # [uncompleted]
# # parse input picture file to captcha(verify code)
# def parseCaptchaFromPicFile(inputCaptFilename):
    # #http://www.wausita.com/captcha/
    
    # parsedCaptchaStr = "";
    
    
    # # picFp = open(inputCaptFilename, "rb");
    # # print "open pic file OK,picFp=",picFp;
    # # picData = picFp.read();
    # # print "read pic file OK";
    # # picFp.close();
    # # print "len(picData)=",len(picData);


    # print "------------------capta test begin -----------------";
    # captchaDir = "captcha";
    # #inputCaptFilename = "returned_captcha.jpg";
    # #inputCaptFilename = "captcha.gif";
    # print "inputCaptFilename=",inputCaptFilename;
    # inputCaptFilename = inputCaptFilename.split("/")[-1];
    # captchaPicFile = captchaDir + "/" + inputCaptFilename;
    # print "captchaPicFile=",captchaPicFile;
    
    # im = Image.open(captchaPicFile);
    # im = im.convert("P");
    # im2 = Image.new("P", im.size, 255);

    # temp = {};

    # # 225 571
    # # 219 253
    # # 189 82
    # # 132 64
    # # 90 63
    # # 224 63
    # # 139 48
    # # 182 47
    # # 133 43
    # # 96 39



    # his = im.histogram();

    # print im.histogram();

    # values = {};

    # for i in range(256):
      # values[i] = his[i];

    # mostCommonColor = sorted(values.items(), key=itemgetter(1), reverse=True)[:10];
    # print type(mostCommonColor);
    
    # print "-----most 0-9:-----";
    # for key in mostCommonColor:
        # #print type(key);
        # print key;

    # startIdx = 0;
    # endIdx = 3;
    # outputGifName = captchaPicFile + "_from-%d_to-%d.gif"%(startIdx, endIdx);

    # #mostCommonColor = mostCommonColor[0:3]; # good result -> 0.8 similar
    # #mostCommonColor = mostCommonColor[0:2]; # not bad result -> 0.7 similar
    # mostCommonColor = mostCommonColor[startIdx:endIdx];
    
    # print "-----most %d-%d:-----"%(startIdx, endIdx);
    # for j,k in mostCommonColor:
      # print j,k;
    

    # mostCommonColorDict = dict(mostCommonColor);
    # print mostCommonColorDict;
    
    # for x in range(im.size[1]):
        # for y in range(im.size[0]):
            # pix = im.getpixel((y,x));
            # temp[pix] = pix;
            # #if pix == 220 or pix == 227: # these are the numbers to get
            # if pix in mostCommonColorDict:
                # #print pix;
                # im2.putpixel((y,x),0);

    # im2.save(outputGifName);    
   
    # print "------------------capta test done -----------------";

    # return parsedCaptchaStr;
    
    
################################################################################
# Functions that depend on third party lib
################################################################################

#------------------------------------------------------------------------------
# depend on chardet
# check whether the strToDect is ASCII string
def strIsAscii(strToDect) :
    isAscii = False;
    encInfo = chardet.detect(strToDect);
    if (encInfo['confidence'] > 0.9) and (encInfo['encoding'] == 'ascii') :
        isAscii = True;
    return isAscii;

#------------------------------------------------------------------------------
# get the possible(possiblility > 0.5) charset of input string
def getStrPossibleCharset(inputStr) :
    possibleCharset = "ascii";
    #possibleCharset = "UTF-8";
    encInfo = chardet.detect(inputStr);
    #print "encInfo=",encInfo;
    if (encInfo['confidence'] > 0.5):
        possibleCharset = encInfo['encoding'];
    return possibleCharset;
    #return encInfo['encoding'];
    
#------------------------------------------------------------------------------
# depend on BeautifulSoup
# translate strToTranslate from fromLanguage to toLanguage
# return the translated unicode string
# some frequently used language abbrv:
# Chinese Simplified:   zh-CN
# Chinese Traditional:  zh-TW
# English:              en
# German:               de
# Japanese:             ja
# Korean:               ko
# French:               fr    
# more can be found at: 
# http://code.google.com/intl/ru/apis/language/translate/v2/using_rest.html#language-params
def translateString(strToTranslate, fromLanguage="zh-CN", toLanguage="en"):
    transOK = False;
    translatedStr = strToTranslate;
    transErr = '';

    try :
        # following refer: http://python.u85.us/viewnews-335.html
        postDict = {'hl':'zh-CN', 'ie':'UTF-8', 'text':strToTranslate, 'langpair':"%s|%s"%(fromLanguage, toLanguage)};
        googleTranslateUrl = 'http://translate.google.cn/translate_t';
        resp = getUrlRespHtml(googleTranslateUrl, postDict);
        #logging.debug("---------------google translate resp html:\n%s", resp);
    except urllib2.URLError,reason :
        transOK = False;
        transErr = reason;
    except urllib2.HTTPError,code :
        transOK = False;
        transErr = code;
    else :
        soup = BeautifulSoup(resp);
        resultBoxSpan = soup.find(id='result_box');
        if resultBoxSpan and resultBoxSpan.span and resultBoxSpan.span.string :
            transOK = True;
            #translatedStr = resultBoxSpan.span.string.encode('utf-8');
            googleRetTransStr = resultBoxSpan.span.string;
            translatedStr = unicode(googleRetTransStr);
            
            # just record some special one:
            # from:
            #【转载】[SEP4020  u-boot]  start.s  注释
            # to:
            # The 【reserved] [the SEP4020 u-boot] start.s comment
        else :
            transOK = False;
            transErr = "can not extract translated string from returned result";

    transErr = str(transErr);
    
    if transOK :
        return (transOK, translatedStr);
    else :
        return (transOK, transErr);

#------------------------------------------------------------------------------
# translate the Chinese Simplified(Zh-cn) string to English(en)
def transZhcnToEn(strToTrans) :
    translatedStr = strToTrans;
    transOK = False;
    transErr = '';

    if strIsAscii(strToTrans) :
        transOK = True;
        translatedStr = strToTrans;
    else :
        (transOK, translatedStr) = translateString(strToTrans, "zh-CN", "en");

    return (transOK, translatedStr);


################################################################################
# BeautifulSoup
################################################################################

#------------------------------------------------------------------------------
#remove specific tag[key]=value in soup contents (list of BeautifulSoup.Tag/BeautifulSoup.NavigableString)
# eg:
# (1)
# removeSoupContentsTagAttr(soupContents, "p", "class", "cc-lisence")
# to remove <p class="cc-lisence" style="line-height:180%;">......</p>, from
# [
# u'\n',
# <p class="cc-lisence" style="line-height:180%;">......</p>,
# u'\u5bf9......\u3002',
#  <p>跑题了。......我争取。</p>,
#  <br />,
#  u'\n',
#  <div class="clear"></div>,
# ]
# (2)
#contents = removeSoupContentsTagAttr(contents, "div", "class", "addfav", True);
# remove <div class="addfav">.....</div> from:
# [u'\n',
# <div class="postFooter">......</div>, 
# <div style="padding-left:2em">
    # ...
    # <div class="addfav">......</div>
    # ...
# </div>,
 # u'\n']
def removeSoupContentsTagAttr(soupContents, tagName, tagAttrKey, tagAttrVal="", recursive=False) :
    global gVal;

    #print "in removeSoupContentsClass";

    #print "[",gVal['currentLevel'],"] input tagName=",tagName," tagAttrKey=",tagAttrKey," tagAttrVal=",tagAttrVal;
    
    #logging.debug("[%d] input, %s[%s]=%s, soupContents:%s", gVal['currentLevel'],tagName,tagAttrKey,tagAttrVal, soupContents);
    #logging.debug("[%d] input, %s[%s]=%s", gVal['currentLevel'],tagName, tagAttrKey, tagAttrVal);
    
    filtedContents = [];
    for singleContent in soupContents:
        #logging.debug("current singleContent=%s",singleContent);
    
        #logging.info("singleContent=%s", singleContent);
        #print "type(singleContent)=",type(singleContent);
        #print "singleContent.__class__=",singleContent.__class__;
        #if(isinstance(singleContent, BeautifulSoup)):
        #if(BeautifulSoup.Tag == singleContent.__class__):
        #if(isinstance(singleContent, instance)):
        #if(isinstance(singleContent, BeautifulSoup.Tag)):
        if(isinstance(singleContent, Tag)):
            #print "isinstance true";
            
            #logging.debug("singleContent: name=%s, attrMap=%s, attrs=%s",singleContent.name, singleContent.attrMap, singleContent.attrs);
            # if( (singleContent.name == tagName)
                # and (singleContent.attrMap)
                # and (tagAttrKey in singleContent.attrMap)
                # and ( (tagAttrVal and (singleContent.attrMap[tagAttrKey]==tagAttrVal)) or (not tagAttrVal) ) ):
                # print "++++++++found tag:",tagName,"[",tagAttrKey,"]=",tagAttrVal,"\n in:",singleContent;
                # #print "dir(singleContent)=",dir(singleContent);
                # logging.debug("found %s[%s]=%s in %s", tagName, tagAttrKey, tagAttrVal, singleContent.attrMap);

            # above using attrMap, but attrMap has bug for:
            #singleContent: name=script, attrMap=None, attrs=[(u'type', u'text/javascript'), (u'src', u'http://partner.googleadservices.com/gampad/google_service.js')]
            # so use attrs here
            #logging.debug("singleContent: name=%s, attrs=%s", singleContent.name, singleContent.attrs);
            attrsDict = tupleListToDict(singleContent.attrs);
            if( (singleContent.name == tagName)
                and (singleContent.attrs)
                and (tagAttrKey in attrsDict)
                and ( (tagAttrVal and (attrsDict[tagAttrKey]==tagAttrVal)) or (not tagAttrVal) ) ):
                #print "++++++++found tag:",tagName,"[",tagAttrKey,"]=",tagAttrVal,"\n in:",singleContent;
                #print "dir(singleContent)=",dir(singleContent);
                logging.debug("found %s[%s]=%s in %s", tagName, tagAttrKey, tagAttrVal, attrsDict);
            else:
                if(recursive):
                    #print "-----sub call";
                    gVal['currentLevel'] = gVal['currentLevel'] + 1;
                    #logging.debug("[%d] now will filter %s[%s=]%s, for singleContent.contents=%s", gVal['currentLevel'], tagName,tagAttrKey,tagAttrVal, singleContent.contents);
                    #logging.debug("[%d] now will filter %s[%s=]%s", gVal['currentLevel'], tagName,tagAttrKey,tagAttrVal);
                    filteredSingleContent = singleContent;
                    filteredSubContentList = removeSoupContentsTagAttr(filteredSingleContent.contents, tagName, tagAttrKey, tagAttrVal, recursive);
                    gVal['currentLevel'] = gVal['currentLevel'] -1;
                    filteredSingleContent.contents = filteredSubContentList;
                    #logging.debug("[%d] after filter, sub contents=%s", gVal['currentLevel'], filteredSingleContent);
                    #logging.debug("[%d] after filter contents", gVal['currentLevel']);
                    filtedContents.append(filteredSingleContent);
                else:
                    #logging.debug("not recursive, append:%s", singleContent);
                    #logging.debug("not recursive, now append singleContent");
                    filtedContents.append(singleContent);
            
            # name = singleContent.name;
            # if(name == tagName):
                # print "name is equal, name=",name;
                
                # attrMap = singleContent.attrMap;
                # print "attrMap=",attrMap;
                # if attrMap:
                    # if tagAttrKey in attrMap:
                        # print "tagAttrKey=",tagAttrKey," in attrMap";
                        # if(tagAttrVal and (attrMap[tagAttrKey]==tagAttrVal)) or (not tagAttrVal):
                            # print "++++++++found tag:",tagName,"[",tagAttrKey,"]=",tagAttrVal,"\n in:",singleContent;
                            # #print "dir(singleContent)=",dir(singleContent);
                            # logging.debug("found tag, tagAttrVal=%s, %s[%s]=%s", tagAttrVal, tagName, tagAttrVal, attrMap[tagAttrKey]);
                        # else:
                            # print "key in attrMap, but value not equal";
                            # if(recursive):
                                # print "-----sub call 111";
                                # gVal['currentLevel'] = gVal['currentLevel'] + 1;
                                # singleContent = removeSoupContentsTagAttr(singleContent.contents, tagName, tagAttrKey, tagAttrVal, recursive);
                                # gVal['currentLevel'] = gVal['currentLevel'] -1;
                            # filtedContents.append(singleContent);
                    # else:
                        # print "key not in attrMap";
                        # if(recursive):
                            # print "-----sub call 222";
                            # gVal['currentLevel'] = gVal['currentLevel'] + 1;
                            # singleContent = removeSoupContentsTagAttr(singleContent.contents, tagName, tagAttrKey, tagAttrVal, recursive);
                            # gVal['currentLevel'] = gVal['currentLevel'] -1;
                        # filtedContents.append(singleContent);
                # else:
                    # print "attrMap is None";
                    # if(recursive):
                        # print "-----sub call 333";
                        # gVal['currentLevel'] = gVal['currentLevel'] + 1;
                        # singleContent = removeSoupContentsTagAttr(singleContent.contents, tagName, tagAttrKey, tagAttrVal, recursive);
                        # gVal['currentLevel'] = gVal['currentLevel'] -1;
                    # filtedContents.append(singleContent);
            # else:
                # print "name not equal, name=",name," tagName=",tagName;
                # if(recursive):
                    # print "-----sub call 444";
                    # gVal['currentLevel'] = gVal['currentLevel'] + 1;
                    # singleContent = removeSoupContentsTagAttr(singleContent.contents, tagName, tagAttrKey, tagAttrVal, recursive);
                    # gVal['currentLevel'] = gVal['currentLevel'] -1;
                # filtedContents.append(singleContent);
        else:
            # is BeautifulSoup.NavigableString
            #print "not BeautifulSoup instance";
            filtedContents.append(singleContent);

    #print "filterd contents=",filtedContents;
    #logging.debug("[%d] before return, filtedContents=%s", gVal['currentLevel'], filtedContents);
    
    return filtedContents;

#------------------------------------------------------------------------------
# convert soup contents into unicode string
def soupContentsToUnicode(soupContents) :
    #method 1
    mappedContents = map(CData, soupContents);
    #print "mappedContents OK";
    #print "type(mappedContents)=",type(mappedContents); #type(mappedContents)= <type 'list'>
    contentUni = ''.join(mappedContents);
    #print "contentUni=",contentUni;
    
    # #method 2
    # originBlogContent = "";
    # logging.debug("Total %d contents for original soup contents:", len(soupContents));
    # for i, content in enumerate(soupContents):
        # if(content):
            # logging.debug("[%d]=%s", i, content);
            # originBlogContent += unicode(content);
        # else :
            # logging.debug("[%d] is null", i);
    
    # logging.debug("---method 1: map and join---\n%s", contentUni);
    # logging.debug("---method 2: enumerate   ---\n%s", originBlogContent);
    
    # # -->> seem that two method got same blog content
    
    #logging.debug("soup contents to unicode string OK");
    return contentUni;

#------------------------------------------------------------------------------
# find the first BeautifulSoup.NavigableString from soup contents
def findFirstNavigableString(soupContents):
    firstString = None;
    for eachContent in soupContents:
        # note here must import NavigableString from BeautifulSoup
        if(isinstance(eachContent, NavigableString)): 
            firstString = eachContent;
            break;

    return firstString;

#------------------------------------------------------------------------------
if __name__=="crifanLib":
    gVal['picSufChars'] = genSufList();
    #print "gVal['picSufChars']=",gVal['picSufChars'];
    print "Imported: %s,\t%s"%( __name__, __VERSION__);