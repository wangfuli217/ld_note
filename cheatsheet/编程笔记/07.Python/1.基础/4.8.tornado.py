from tornado.httpclient import AsyncHTTPClient
from tornado.ioloop import IOLoop
count = 10000
done = 0
def handle_request(response):
  global done
  done += 1
  if (done == count):
    #结束循环
    IOLoop.instance().stop()
 
  if response.error:
    print "Error:", response.error
  #else:
    #print response.body
#默认client是基于ioloop实现的，配置使用Pycurl
AsyncHTTPClient.configure("tornado.curl_httpclient.CurlAsyncHTTPClient",max_clients=20)
http_client = AsyncHTTPClient()
for i in range(count):
  http_client.fetch("http://www.haiyun.me/", handle_request)
#死循环
IOLoop.instance().start()