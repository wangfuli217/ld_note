#!python
# -*- coding:utf-8 -*-
'''
公用函数(字符串处理)
Created on 2014/7/16
Updated on 2016/5/12
@author: Holemar
'''
import sys
import json
import copy
import uuid
import types
import random
import string
import decimal
import logging
import time, datetime
import gzip, StringIO, zlib
from hashlib import md5

__all__=('to_unicode', 'to_str', 'deep_str', 'to_human', 'to_json', 'json2str', 'mod',
         'gzip_encode', 'gzip_decode', 'zlib_encode', 'zlib_decode',
         "MD5", 'is_MD5', 'is_mobile', "is_email", 'create_random')

def to_unicode(value, **kwargs):
    u"""
    @summary: 将字符转为 unicode 编码
    @param {basestring} value 将要被转码的值,类型可以是:str,unicode 类型
    @param {bool} to_read: 是否要将字符串转码成便于人阅读的编码(将 “\u65f6”,“\xE5\x8C\x85”等字符转为人可以阅读的文字), 默认不转换
    @param {string} from_code: 传入字符串的可能编码类型,如果有则优先按它解码
    @param {int} max: 字符串的最大长度,超出部分将会截取。注:仅截取原本是 str,unicode 类型的,其它类型的不会截取。
    @return {unicode}: 返回转成 unicode 类型的字符串
    """
    if isinstance(value, basestring):
        # str类型,需要按它原本的编码来解码出 unicode,编码不对会报异常
        if isinstance(value, str):
            from_code = kwargs.get('from_code')
            for encoding in (from_code, "utf-8", "gbk", "big5", sys.getdefaultencoding(), "ascii"):
                if not encoding or not isinstance(encoding, basestring): continue
                try:
                    value = value.decode(encoding)
                    break # 如果上面这句执行没报异常，说明是这种编码
                except:
                    pass
        # 上面已经转码成 Unicode 的
        if kwargs.get('to_read', False) and value:
            try:
                # eval 处理是为了让“\u65f6”,“\xE5\x8C\x85”等字符转为人可以阅读的文字
                if "'''" not in value:
                    value = eval(u"u'''%s'''" % value)
                elif '"""' not in value:
                    value = eval(u'u"""%s"""' % value)
                else:
                    value = json.dumps(value, ensure_ascii=False)
                    value = value.replace(r"\\u", r"\u") # json.dumps 会转换“\”,使得“\u65f6”变成“\\u65f6”
                    value = eval(u'u%s' % value)
            except Exception, e:
                logging.error(u'将字符串转成可阅读编码出错:%s, 字符串:%s', e, value)
        # 长度处理
        max_str = kwargs.get('max')
        max_str = int(max_str) if max_str and isinstance(max_str, basestring) and max_str.isdigit() else max_str
        if max_str and isinstance(max_str, (int,long,float)):
            if max_str > 0 and len(value) > max_str:
                value = u"%s..." % value[:max_str]
        return value
    # 其它类型
    else:
        return value

def to_str(value, encode="utf-8", **kwargs):
    u"""
    @summary: 将字符转为utf8编码
    @param {string} value: 将要被转码的值,类型可以是:str,unicode 类型
    @param {string} encode: 编码类型,默认是 utf-8 编码
    @param {bool} to_read: 是否要将字符串转码成便于人阅读的编码(将 “\u65f6”,“\xE5\x8C\x85”等字符转为人可以阅读的文字), 默认不转换
    @param {string} from_code: 传入字符串的可能编码类型,如果有则优先按它解码
    @param {int} max: 字符串的最大长度,超出部分将会截取。注:仅截取原本是 str,unicode 类型的,其它类型的不会截取。
    @return {str}: 返回转成 str 的字符串
    """
    # 字符串类型的,先转成 unicode,再转成 utf8 编码的 str,这样就可以避免编码错误了
    if isinstance(value, basestring):
        return to_unicode(value, **kwargs).encode(encode)
    # 其它类型
    return value

def deep_str(value, all2str='time', **kwargs):
    u"""
    @summary: 将 list,tuple,set,dict 等类型里面的字符转为 unicode 编码
    @param {任意} value 将要被转码的值,类型可以是:dict,list,tuple,set 等类型
    @param {bool} all2str: 是否要将数值、日期、布尔等类型也转成字符串,默认只转换时间类型。
                              值为 True 时,使用 unicode(value) 来转,值为 "time" 时会附加转换时间类型
    @param {bool} to_read: 是否要将字符串转码成便于人阅读的编码(将 “\u65f6”,“\xE5\x8C\x85”等字符转为人可以阅读的文字), 默认不转换
    @param {string} from_code: 传入字符串的可能编码类型,如果有则优先按它解码
    @param {int} max: list,tuple,set,dict 等类型里面的字符串的最大长度,超出部分将会截取。
    @param {function} str_unicode: 将 list,tuple,set,dict 等类型里面的字符串用什么函数转码,可选值: to_unicode, to_str 。 默认是: to_unicode
    @return {type(value)}: 返回原本的参数类型(list,tuple,set,dict等类型会保持不变)
    """
    str_deal = kwargs.get('str_unicode', to_unicode)
    if value == None:
        return '' if all2str == True else value
    # str/unicode 类型的
    elif isinstance(value, basestring):
        return str_deal(value, **kwargs)
    # 考虑是否需要转成字符串的类型
    elif isinstance(value, (bool,int,long,float,complex)):
        return str(value) if all2str == True else value
    # time, datetime 类型转成字符串,需要写格式(不能使用 json.dumps,会报错)
    elif isinstance(value, time.struct_time):
        return time.strftime('%Y-%m-%d %H:%M:%S', value) if all2str in (True, 'time') else value
    elif isinstance(value, datetime.datetime):
        return value.strftime('%Y-%m-%d %H:%M:%S') if all2str in (True, 'time') else value
    elif isinstance(value, datetime.date):
        return value.strftime('%Y-%m-%d') if all2str in (True, 'time') else value
    elif isinstance(value, decimal.Decimal):
        return str(value) if all2str == True else float(value)
    elif isinstance(value, uuid.UUID):
        return str(value).replace('-', '')
    # list,tuple,set 类型,递归转换
    elif isinstance(value, (list,tuple,set)):
        arr = [deep_str(item, all2str=all2str, **kwargs) for item in value]
        # 尽量不改变原类型
        if isinstance(value, list):  return arr
        if isinstance(value, tuple): return tuple(arr)
        if isinstance(value, set):   return set(arr)
    # dict 类型,递归转换(字典里面的 key 也会转成 unicode 编码)
    elif isinstance(value, dict):
        this_value = {} # 不能改变原参数
        for key1,value1 in value.iteritems():
            # 字典里面的 key 也转成 unicode 编码
            key1 = deep_str(key1, all2str=all2str, **kwargs)
            this_value[key1] = deep_str(value1, all2str=all2str, **kwargs)
        return this_value
    # 其它类型，可以遍历属性的
    elif hasattr(value, '__dict__'):
        if isinstance(value, (types.TypeType, types.ClassType, types.FileType, types.ModuleType,
            types.FunctionType, types.MethodType, types.GeneratorType, types.CodeType,
            types.BuiltinFunctionType, types.XRangeType)):
            return value
        try:
            this_object = copy.deepcopy(value) # 不能改变原类
            this_dict = {}
            for key1 in dir(value):
                if key1.startswith('__'): continue
                value1 = getattr(value, key1, None)
                if isinstance(value1, (types.FunctionType, types.MethodType, types.GeneratorType,
                    types.CodeType, types.BuiltinFunctionType, types.XRangeType)): continue
                # 字典里面的 key 也转成 unicode 编码
                key1 = deep_str(key1, all2str=all2str, **kwargs)
                this_dict[key1] = deep_str(value1, all2str=all2str, **kwargs)
            setattr(this_object, '__dict__', this_dict)
            return this_object
        # 并非所有类都可以转换，有可能出现异常
        except:
            return value
    # 其它类型
    else:
        str_deal = unicode if str_deal == to_unicode else str
        return str_deal(value) if all2str == True else value

def to_human(value, isJson = False, **kwargs):
    '''
    @summary: 将 字符串/其他值 按便于人阅读的形式展示
        类似于 repr 函数,但同时会将 “\u65f6”,“\xE5\x8C\x85”等字符转为人可以阅读的文字
    @param {任意} value: 将要被转码的值,类型可以是:str,unicode,int,long,float,double,dict,list,tuple,set,其它类型
    @param {bool} isJson: 返回结果是否需要反 json 化
    @return {unicode}: 返回转成 unicode 的字符串,且呈现便于人阅读的模式
        本函数与 to_unicode(value, to_human=True) 函数的区别是: to_unicode 只转换字符串。
        而本函数会将所有类型转成字符串,包括 (list,tuple,set, dict) 类型,且这些类型会尽量美化输出。
    '''
    # 先将可以转成字符串的都先转成字符串
    if isinstance(value, basestring):
        value = to_unicode(value.strip(), to_read=True)
        # json 格式的,尽量按 json 格式美化一下输出
        if isJson or (value.startswith('{') and value.endswith('}')) or (value.startswith('[') and value.endswith(']')):
            value = to_json(value)
    # list,tuple,set,dict 类型,按 json 格式美化一下输出
    if isinstance(value, (list,tuple,set, dict)):
        value = deep_str(value, to_read=True, **kwargs)
        return json.dumps(value, indent=2, ensure_ascii=False)
    # 其它类型,可以部分地交给 to_unicode 处理
    return value

def to_json(value, **kwargs):
    '''
    @summary: 将字符串转成json
    @param {string} value: 要转成json的字符串
    @param {bool} raise_error: 遇到解析异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出(默认抛出)
    @return {dict}: 返回转换后的类型
    '''
    if isinstance(value, basestring):
        try:
            value = json.loads(value)
        except Exception, e:
            #logging.warn(u'将字符串json反序列化出错,下面将转eval处理:%s, 参数:%s', e, value, exc_info=True)
            try:
                value = eval(value)
            except Exception, e:
                raise_error = kwargs.get('raise_error', True)
                if raise_error:
                    logging.error(u'将字符串json反序列化出错,无法处理:%s, 参数:%s', e, value, exc_info=True)
                    raise
    return value

def json2str(value, **kwargs):
    '''
    @summary: 将 dict 类型的内容转成json格式的字符串
    @param {dict} value: 要转成json字符串的内容
    @param {bool} raise_error: 遇到解析异常时,是否抛出异常信息。为 True则会抛出异常信息,否则不抛出(默认抛出)
    @return {string}: 返回转换后的字符串
    '''
    try:
        value = deep_str(value, **kwargs) # 兼容 GBK、big5 编码的中文字符
        value = json.dumps(value)
    except Exception, e:
        raise_error = kwargs.get('raise_error', True)
        if raise_error:
            logging.warn(u'将对象进行json序列化出错:%s, 参数:%s', e, value, exc_info=True)
            raise
        else:
            try:
                value = str(value)
            except Exception, e:
                pass
    return value

def mod(sour, *args, **kwargs):
    '''
    @summary: 相当于使用“%”格式化字符串
    @param {string} sour: 要格式化的字符串
    @param {任意} param: 要放入字符串的参数,多个则用 tuple 括起来
    @param {bool} to_read: 是否要将字符串转码成便于人阅读的编码(将 “\u65f6”,“\xE5\x8C\x85”等字符转为人可以阅读的文字), 默认不转换
    @return {string}: 返回格式化后的字符串,即返回: sour %  param
    '''
    # 参数 param 允许传 None,0,False 等值
    has_param = False
    if len(args) > 0:
        param = args[0]
        has_param = True
    elif 'param' in kwargs:
        param = kwargs.pop('param')
        has_param = True
    # 按 sour 的类型执行 mod
    if isinstance(sour, str):
        sour = to_str(sour, **kwargs)
        if has_param:
            kwargs['str_unicode'] = kwargs.get('str_unicode', to_str)
            return sour % deep_str(param, **kwargs)
        else:
            return sour
    elif isinstance(sour, unicode):
        if has_param:
            kwargs['str_unicode'] = kwargs.get('str_unicode', to_unicode)
            return sour % deep_str(param, **kwargs)
        else:
            return sour
    else:
        return unicode(sour)


def gzip_encode(content):
    '''
    @summary: 使用 gzip 压缩字符串
    @param {string} content: 明文字符串
    @return {string}: 压缩后的字符串
    '''
    if not isinstance(content, basestring):
        content = json2str(content)
    zbuf = StringIO.StringIO()
    zfile = gzip.GzipFile(mode='wb', compresslevel=9, fileobj=zbuf)
    zfile.write(content)
    zfile.close()
    return zbuf.getvalue()

def gzip_decode(content):
    '''
    @summary: 使用 gzip 解压字符串
    @param {string} content: 压缩后的字符串
    @return {string}: 解压出来的明文字符串
    '''
    zfile = gzip.GzipFile(fileobj=StringIO.StringIO(content))
    result = zfile.read()
    zfile.close()
    return result


def zlib_encode(content):
    '''
    @summary: 使用 zlib 压缩字符串
    @param {string} content: 明文字符串
    @return {string}: 压缩后的字符串
    '''
    if not isinstance(content, basestring):
        content = json2str(content)
    return zlib.compress(content, zlib.Z_BEST_COMPRESSION)

def zlib_decode(content):
    '''
    @summary: 使用 zlib 解压字符串
    @param {string} content: 压缩后的字符串
    @return {string}: 解压出来的明文字符串
    '''
    return zlib.decompress(content)


def MD5(data, key='', **kwargs):
    '''
    @summary: 返回字符串的 MD5 编码
    @param {string} data: 要 md5 编码的字符串
    @param {string} key: 要加入 md5 编码里面的混淆值
    @return {string}: md5 编码后的字符串
    '''
    if not isinstance(data, basestring):
        data = json2str(data)
    if not isinstance(data, str):
        data = to_str(data)
    if not isinstance(key, basestring):
        key = json2str(key)
    if not isinstance(key, str):
        key = to_str(key)
    return md5(data + key).hexdigest()

def is_MD5(data, **kwargs):
    '''
    @summary: 判断字符串是否已经是MD5编码之后的
    @param {string} data: 要判断的字符串
    @return {bool}: 是MD5编码的字符串则返回 True, 否则返回False
    '''
    if not isinstance(data, basestring):
        return False
    #if len(data) == 32 and re.match("^[0-9a-f]+$", data): # 为了提高效率，避免使用正则
    if len(data) == 32 and len([x for x in data if x in '0123456789abcdef']) == 32:
        return True
    return False


def is_mobile(phone, **kwargs):
    '''
    @summary: 检查字符串是否手机号码,是则返回 True,否则返回 False
    @param {string} phone: 要检查的手机号
    @return {bool}: 输入的字符串是否手机号格式,是则返回 True,否则返回 False
    '''
    # 允许 int, long 类型的判断
    if not isinstance(phone, basestring):
        if isinstance(phone, (int, long)):
            phone = str(phone)
        else:
            return False
    if not phone.isdigit() or len(phone) != 11:
        return False
    #if re.match("^1[3-9]\d{9}$", phone): # 为了提高效率，避免使用正则
    if phone[0] == '1' and int(phone[1]) >= 3:
        return True
    return False


def is_email(email, **kwargs):
    '''
    @summary: 检查字符串是否邮箱地址,是则返回 True,否则返回 False
    @param {string} email: 要检查的邮箱地址
    @return {bool}: 输入的字符串是否邮箱地址格式,是则返回 True,否则返回 False
    '''
    if not isinstance(email, basestring):
        return False
    if len(email) <= 7:
        return False
    # 为了提高效率，避免使用正则
    #if re.match("^([a-zA-Z\\d_\\.-]+)@([a-zA-Z\\d\\-]+\\.)+[a-zA-Z\\d]{2,6}$", email):
    #    return True
    # 没有@符号,或者@符号在开头、结尾,或者有多个@符号,则返回False
    es = email.split('@')
    if len(es) != 2 or es[0] == '' or es[1] == '':
        return False
    # 邮箱地址只能包含字母、数字、和下划线、点号、中划线三个符号
    estr = string.ascii_letters + string.digits + '_-.'
    if len([x for x in es[0] if x in estr]) != len(es[0]) or len([x for x in es[1] if x in estr]) != len(es[1]):
        return False
    # 结尾不能是符号
    if es[1][-1] in '_-.':
        return False
    return True


def create_random(k=16, repeat_fun=None):
    '''
    @summary: 生成随机字符串(包括字母和数字)
    @param {int} k: 要生成多少位的随机数
    @param {function} repeat_fun: 判断重复的函数，需接收生成的字符串，需返回是否重复
    @return {string}: 生成的随机字符串
    '''
    if k <= 0:
        raise ValueError(u"生成随机数的位数不正确！")
    population = string.ascii_letters + string.digits
    population = population * k
    result = ''.join(random.sample(population, k))
    # 判断是否重复
    if repeat_fun and isinstance(repeat_fun, types.FunctionType):
        # 重复时，递归重新生成
        if repeat_fun(result):
            return create_random(k=k, repeat_fun=repeat_fun)
    return result
