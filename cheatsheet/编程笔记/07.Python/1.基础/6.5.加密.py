
加密方式:
    md5, base64, hmac

1. md5 加密:
    import hashlib

    def MD5(data, key=''):
        # 创建一个哈希对象
        md = hashlib.md5
        #md = hashlib.sha1
        #md = hashlib.sha224
        #md = hashlib.sha25  # 貌似这个没有
        #md = hashlib.sha384
        #md = hashlib.sha512
        obj = md(data + key)
        #return obj.digest() # 返回数字形式的哈希
        return obj.hexdigest() # 返回16进制的哈希,一般而言用 hexdigest() 就可以了

    s = "admin"
    s2 = MD5(s) # 加密后,没法加密,生成一个32位的字符串
    print(s2) # 打印:21232f297a57a5a743894a0e4a801fc3



2.Base64 编码和解码
    import base64
    s = '我是字符串'
    a = base64.b64encode(s) # base64 加密
    print a # 打印:ztLKx9fWt/u0rg==
    print base64.b64decode(a) # base64 解密

3.hmac 加密
#    hmac.new(key[, msg[, digestmod]])
#    hmac.update(msg)
#    hmac.digest()
#    hmac.hexdigest()
#    hmac.copy()
#    要注意，上面的message都要用bytes，使用string不可以

    # 示例
    import hmac
    s = "哈哈"
    s2 = hmac.new("mykey",s).hexdigest()
    print s2

