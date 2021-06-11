#!python
# -*- coding:utf-8 -*-


# 1 自己封装HTTP的POST数据包：http://stackoverflow.com/questions/680305/using-multipartposthandler-to-post-form-data-with-python
    #buld post body data
    boundary = '----------%s' % hex(int(time.time() * 1000))
    data = []
    data.append('--%s' % boundary)

    data.append('Content-Disposition: form-data; name="%s"\r\n' % 'username')
    data.append('jack')
    data.append('--%s' % boundary)

    data.append('Content-Disposition: form-data; name="%s"\r\n' % 'mobile')
    data.append('13800138000')
    data.append('--%s' % boundary)

    fr=open(r'/var/qr/b.png','rb')
    data.append('Content-Disposition: form-data; name="%s"; filename="b.png"' % 'profile')
    data.append('Content-Type: %s\r\n' % 'image/png')
    data.append(fr.read())
    fr.close()
    data.append('--%s--\r\n' % boundary)

    http_url='http://remotserver.com/page.php'
    http_body='\r\n'.join(data)
    try:
        #buld http request
        req=urllib2.Request(http_url, data=http_body)
        #header
        req.add_header('Content-Type', 'multipart/form-data; boundary=%s' % boundary)
        req.add_header('User-Agent','Mozilla/5.0')
        req.add_header('Referer','http://remotserver.com/')
        #post data to server
        resp = urllib2.urlopen(req, timeout=5)
        #get response
        qrcont=resp.read()
        print qrcont

    except Exception,e:
        print 'http error'


# 2 使用现有模块 MultipartPostHandler  http://pypi.python.org/pypi/MultipartPostHandler/
    import MultipartPostHandler, urllib2, cookielib

    cookies = cookielib.CookieJar()
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookies),
                                MultipartPostHandler.MultipartPostHandler)
    params = { "username" : "bob", "password" : "riviera",
             "file" : open("filename", "rb") }
    opener.open("http://wwww.bobsite.com/upload/", params)


# 3 使用现有模块 poster http://stackoverflow.com/questions/680305/using-multipartposthandler-to-post-form-data-with-python
    FROM_ADDR = 'my@email.com'

    try:
        data = open(file, 'rb').read()
    except:
        print "Error: could not open file %s for reading" % file
        print "Check permissions on the file or folder it resides in"
        sys.exit(1)

    # Build the POST request
    url = "http://somedomain.com/?action=analyze"
    post_data = {}
    post_data['analysisType'] = 'file'
    post_data['executable'] = data
    post_data['notification'] = 'email'
    post_data['email'] = FROM_ADDR

    # MIME encode the POST payload
    opener = urllib2.build_opener(MultipartPostHandler.MultipartPostHandler)
    urllib2.install_opener(opener)
    request = urllib2.Request(url, post_data)
    request.set_proxy('127.0.0.1:8080', 'http') # For testing with Burp Proxy

    # Make the request and capture the response
    try:
        response = urllib2.urlopen(request)
        print response.geturl()
    except urllib2.URLError, e:
        print "File upload failed..."
