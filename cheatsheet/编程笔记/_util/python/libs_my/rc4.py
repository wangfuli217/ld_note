#!python
# -*- coding:utf-8 -*-
'''
公用函数(rc4加密)，兼容py2及py3
Created on 2014/5/26
Updated on 2016/5/25
@author: Holemar
'''
import sys
__all__ = ("decode", 'encode')

def RC4(data, key):
    '''rc4加密的核心算法'''
    x = 0
    box = list(range(256))
    for i in list(range(256)):
        x = (x + box[i] + ord(key[i % len(key)])) % 256
        box[i], box[x] = box[x], box[i]
    x = 0
    y = 0
    out = []
    for char in data:
        x = (x + 1) % 256
        y = (y + box[x]) % 256
        box[x], box[y] = box[y], box[x]
        out.append(chr(ord(char) ^ box[(box[x] + box[y]) % 256]))
    return ''.join(out)

def hex2str(s):
    '''16进制转字符串'''
    if s[:2] == '0x' or s[:2] == '0X':
        s = s[2:]
    res = ""
    for i in list(range(0, len(s), 2)):
        hex_dig = s[i:i + 2]
        res += (chr(int(hex_dig, base=16)))
    return res

def str2hex(string):
    '''字符串转16进制'''
    res = ""
    for s in string:
        hex_dig = hex(ord(s))[2:]
        if len(hex_dig) == 1:
            hex_dig = "0" + hex_dig
        res += hex_dig
    return res

def decode(rc4_txt, key):
    '''
    @summary: 将rc4加密后的密文，解密出来
    @param {string} rc4_txt: RC4加密后的密文
    @param {string} key: 加密/解密的key值
    @return {string}: 返回解密后的明文
    '''
    rc4_txt = to_str(rc4_txt)
    key = to_str(key)
    real_text = RC4(hex2str(rc4_txt), key)
    try:
        unicode # py2
        return real_text
    except NameError: # py3
        b = bytes((ord(s) for s in real_text))
        return b.decode()

def encode(real_text, key):
    '''
    @summary: 将明文字符串，用RC4加密成密文
    @param {string} real_text: 明文的字符串
    @param {string} key: 加密/解密的key值
    @return {string}: 返回加密后的密文
    '''
    real_text = to_str(real_text)
    key = to_str(key)
    rc4_txt = str2hex(RC4(real_text, key))
    return rc4_txt

defaultencoding = sys.getdefaultencoding()
def to_str(text):
    '''
    @summary: 中文转换，将 unicode、gbk、big5 编码转成 str 编码(utf-8)
    @param {string} text: 原字符串
    @return {string}: 返回转换后的字符串
    '''
    try:
        # py2 的处理
        if isinstance(text, unicode):
            return text.encode("utf-8")
        elif isinstance(text, str):
            for encoding in (defaultencoding, "utf-8", "gbk", "big5"):
                if not encoding or not isinstance(encoding, basestring): continue
                try:
                    text = text.decode(encoding)
                    return text.encode("utf-8")
                    break # 如果上面这句执行没报异常，说明是这种编码
                except:
                    pass
    except NameError:
        # py3 的处理
        return text.encode().decode("unicode-escape")
