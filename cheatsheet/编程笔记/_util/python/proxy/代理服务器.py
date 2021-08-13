# -*- coding:utf-8 -*-
# http代理服务器
# 1.ip限制,mac限制
#
# [email]socketref@hotmail.com[/email]
# [url]www.sw2us.com[/url]

"exec" "python" "-O" "$0" "$@"

__doc__ = """sw2us HTTP Proxy."""

__version__ = "0.2.1"

import BaseHTTPServer, select, socket, SocketServer, urlparse
import httplib,traceback,re
import os,sys,re,mimetools,zlib,StringIO,gzip,time,StringIO


class ConfigProperty:
   def __init__(self,owner):
       self.key=''
       self.value=''

   def create(self,text):
       #text -  key=value
       #@return: boolean
       pos = text.find('#')
       if(pos !=-1):
           text = text[:pos]
       pair = text.split('=')
       if len(pair) !=2:
           #print "Property Line Invalid:%s"%(text)
           return False
       self.key = pair[0].strip()
       self.value = pair[1].strip()

       return True

   def toString(self):
       try:
           return "%s=%s"%(self.key,self.value)
       except:
           return ''

   def toInt(self):
       try:
           return int(self.value)
       except:
           return 0

   def toFloat(self):
       try:
           return float(self.value)
       except:
           return 0.0


#@def SimpleConfig
# 简单配置信息文件，基本格式 : key=value
class SimpleConfig:
   def __init__(self):
       self._file=''
       self._props=[]
       self._strip = True

   def open(self,file,strip=True):
       #打开配置文件
       #@param strip - 是否裁剪不可见首尾两端的字符
       try:
           self._strip = strip
           self._props=[]
           fh = open(file,'r')
           lines = fh.readlines()
           for text in lines:
               prop = ConfigProperty(self)
               if prop.create(text) == False:
                   prop = None
               else:
                   self._props.append(prop)
           fh.close()
       except:
           return False
       return True

   def toString(self):
       s=''
       for p in self._props:
           s = s + p.toString() +"\n"
       return s

   def saveAs(self,file):
       #保存配置信息到文件
       try:
           fh = open(file,'w')
           fh.write(toString())
           fh.close()
       except:
           print "write File Failed!"
           return False
       return True

   def getProperty(self,name):
       #取属性值
       prop=None
       try:
           for p in self._props:
               if p.key == name:
                   prop = p
                   break
       except:
           pass

       return prop

   def getPropertyValue(self,key,default=''):
       prop = self.getProperty(key)
       if not prop:
           return default
       return prop.value

   def getPropertyValueAsInt(self,name,default=0):
       prop = self.getPropertyValue(name)

       if not prop:
           return default
       r=default
       try:
           r = int(prop)
       except:pass
       return r

   def getPropertyValueAsFloat(self,name,default=0.0):
       prop = self.getPropertyValue(name)
       if not prop:
           return default
       r = default
       try:
           r = float(r)
       except:pass
       return r


#===========================================#


#===========================================#

def getMacList():
   maclist=[]
   f = os.popen('arp -a','r')
   while True:
       line  = f.readline()
       if not line:
           break
       line = line.strip()
       rst = re.match('^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+([0-9a-fA-F]{1,2}\-[0-9a-fA-F]{1,2}\-[0-9a-fA-F]{1,2}\-[0-9a-fA-F]{1,2}\-[0-9a-fA-F]{1,2}\-[0-9a-fA-F]{1,2}).*',line)
       #rst = re.match('^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})',line)
       if rst:
           #print rst.groups()
           maclist.append(rst.groups())
   #print maclist
   return maclist



##########################################
confile = SimpleConfig()
confile.open('proxy.conf')
dbconn = None

##########################################
#初始化系统配置
def initConfiguration():
   r = True

   return r

##########################################

class ProxyHandler (BaseHTTPServer.BaseHTTPRequestHandler):
   __base = BaseHTTPServer.BaseHTTPRequestHandler
   __base_handle = __base.handle
   server_version = "TinyHTTPProxy/" + __version__
   rbufsize = 0                        # self.rfile Be unbuffered


#######################################################33

   #handle()是在单独线程中执行
   def handle(self): # 调用入口,线程刚进入，携带socket进入
       print 'client incoming'
       #self.__base_handle()
       #return
       (ip, port) =  self.client_address
       if hasattr(self, 'allowed_clients') and ip not in self.allowed_clients:
           self.raw_requestline = self.rfile.readline()
           if self.parse_request():
               self.send_error(403)
       else:
           self.__base_handle()

   def _connect_to(self, netloc, soc):
       i = netloc.find(':')
       if i >= 0:
           host_port = netloc[:i], int(netloc[i+1:])
       else:
           host_port = netloc, 80
       #print "\t" "connect to %s:%d" % host_port
       try: soc.connect(host_port)
       except socket.error, arg:
           try: msg = arg[1]
           except: msg = arg
           self.send_error(404, msg)
           return 0
       return 1

   def do_CONNECT(self):
       soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
       try:
           if self._connect_to(self.path, soc):
               self.log_request(200)
               self.wfile.write(self.protocol_version +
                                                 " 200 Connection established\r\n")
               self.wfile.write("Proxy-agent: %s\r\n" % self.version_string())
               self.wfile.write("\r\n")
               self._read_write(soc, 300)
       finally:
           print "\t" "bye"
           soc.close()
           self.connection.close()


   def do_GET(self):
       (scm, netloc, path, params, query, fragment) = urlparse.urlparse(
               self.path, 'http')
       piars = (scm, netloc, path, params, query, fragment)
       if not netloc:
           netloc = self.headers.get('Host', "")
       #print ">>requester:",self.connection.getpeername(),"path:",self.path
       #print '>>2. ',(scm, netloc, path, params, query, fragment)
       #print 'next host:',netloc
       if scm != 'http' or fragment or not netloc:
           self.send_error(400, "bad url %s" % self.path)
           return
       soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
       try:
           if self._connect_to(netloc, soc):
               self.log_request()
               soc.send("%s %s %s\r\n" % (
                       self.command,
                       urlparse.urlunparse(('', '', path, params, query, '')),
                       self.request_version))
               self.headers['Connection'] = 'close'
               del self.headers['Proxy-Connection']
               for key_val in self.headers.items():
                   soc.send("%s: %s\r\n" % key_val)
               soc.send("\r\n")
               #到此完成发送请求和头部信息
               self._read_write(soc)
       finally:
           print "\t" "bye"
           soc.close()
           self.connection.close()



   def insertTags(self,tag,body,insert):
       p1 = body.find('<%s'%tag)
       if p1!=-1 :
           p2 = body.find('>',p1)
           if p2!=-1:
               part1 = body[:p2+1]
               part2 = body[p2+1:]
               print '*-'*20
               body = part1 + insert + part2
       return body

   # google页面的数据请求时，返回的数据进行的是gzip压缩，所以过滤文本存在问题，先要解压缩之后才可以
   # 插入数据之后要重新计算 content-length 并返回给客户浏览器
   # 发现压缩的有很多 , content-encoding:gzip

   # 处理 'transfer-encoding': 'chunked'类型
   #gzip 有两种存储，一种是直接gzip压缩的数据跟在header之后；另外一种是采用chunck块存储
   #在这里将gzip数据全部解压，还原成原始数据传出到客户端
   def sendBackResponse(self,command,headers,body):

       insert='<h1>This is Test </h1>'
       if headers.has_key('content-encoding') and headers['content-encoding'].strip().lower()=='gzip':
           try:
               del headers['content-encoding']
               gzipdata=''
               if headers.has_key('transfer-encoding') and headers['transfer-encoding']=='chunked':
                   del headers['transfer-encoding']

                   pos = 0
                   while pos < len(body):
                       p = body.find('\x0d\x0a',pos)
                       sizewidth = p-pos

                       chuncksize = int(body[pos:p],16)
                       #print 'chunck size:',body[pos:p]
                       p +=2
                       gzipdata+=body[p:p+chuncksize]
                       pos= p+chuncksize+2
                       if chuncksize ==0 :
                           break
                   #
                   body = gzipdata

#

                   #ss = zlib.decompress(gzipdata)
               compressedstream = StringIO.StringIO(body)
               gzipper = gzip.GzipFile(fileobj=compressedstream)
               if gzipper == None:
                   print '*'*200
               body = gzipper.read()
               #f = open('body%s.txt'%time.time(),'wb')
               #f.write(body)
               #f.close()


                   #body = gzipdata
           except:
               print traceback.print_exc()
               print 'decompress failed!'
               #pos = body.find('\x0d\x0a')
               #pos = body.find('\x1f\x8b\x08\x00\x00\x00\x00\x00\x02\xff')
               #if pos!=-1:
               #    body = body[pos+9:]
               #
               #compressedstream = StringIO.StringIO(body)
               #gzipper = gzip.GzipFile(fileobj=compressedstream)
               #if gzipper == None:
               #    print '*'*200
               #body = gzipper.read()

               #body = zlib.decompressobj().decompress('x\x9c'+body)

       #m = re.search('(<body.*>)',body,re.I)
       #if m:
       #    pos = m.start(0)
       #    part1 = body[:pos+len(m.group(0))]
       #    part2 = body[pos+len(m.group(0)):]
       #    body = part1 + insert + part2
       #    print '-*'*20,insert,'-*'*20

       #self.insertTags('body',body,insert)

       css=""" <style>
#kk{
border:1px dotted red;
width:200px;
height:300px;
float:left;
background:#0x00ff00;
}
</style>
"""
       #body =self.insertTags('head',body,css)

       #body =self.insertTags('body',body,insert)
       div="""
       <div id="kk">
       This is Test DIV Block!!
</div>
       """

       #read external html tags
       try:
           #ff = open('head.tag','r')
           #div = ff.read()
           #ff.close()
           #body =self.insertTags('head',body,div)
           body = self.publish_advertisement(body) #插入配置的广告信息
       except:
           pass

       #p1 = body.find('<body')
       #if p1!=-1 :
       #    p2 = body.find('>',p1)
       #    if p2!=-1:
       #        part1 = body[:p2+1]
       #        part2 = body[p2+1:]
       #        print '*-'*20
       #        body = part1 + insert + part2
           #print m.group(0)
       headers['Content-Length'] = str(len(body))

       #if headers.has_key('content-length'):

       self.connection.send(command)
       self.connection.send('\r\n')
       for k,v in headers.items():
           self.connection.send("%s: %s\r\n"%(k,v))
       self.connection.send("\r\n")
       self.connection.sendall(body)



#----------------------------------------------------

   def _read_write(self, soc, max_idling=20):
       #getMacList()
       iw = [self.connection, soc] # self.connnection - 内网主机连接,soc - 向外连接
       ow = []
       count = 0
       #respfile = soc.makefile('rb', 1024)
       httpCommand=''
       httpBody=''
       httpHeaders={}
       isOkPageResponse=False
       nextReadBytes=0
       datacnt=0
       NoContentLength = False
       #print self.connection.getpeername()
       while 1:
           count += 1
           datacnt+=1
           (ins, _, exs) = select.select(iw, ow, iw, 3)
           if exs:
               print 'error occr!'
               break #异常产生
           if ins:
               for i in ins:
                   if i is soc:
                       out = self.connection
                   else:
                       out = soc

                   data = i.recv(8192)
                   if data:
                       out.send(data)
                       count = 0
                   else:
                       if not isOkPageResponse:
                           return
           else:
               pass #print "\t" "idle", count
           if count == max_idling:
               print 'idling exit'
               break  # 指定时间内都接收不到双向数据便退出循环 20*3 = 60 secs


   do_HEAD = do_GET
   do_POST = do_GET
   do_PUT  = do_GET
   do_DELETE=do_GET

class ThreadingHTTPServer (SocketServer.ThreadingMixIn,
                           BaseHTTPServer.HTTPServer): pass




def serving(HandlerClass,
       ServerClass, protocol="HTTP/1.0"):

   if len(sys.argv) <2  or sys.argv[1]!='www.sw2us.com':
       sys.exit()

   if sys.argv[2:]:
       port = int(sys.argv[2])
   else:

       port = confile.getPropertyValueAsInt('httpport',8000)

       #port = 8000

   server_address = ('', port)

   HandlerClass.protocol_version = protocol
   httpd = ServerClass(server_address, HandlerClass)

   sa = httpd.socket.getsockname()
   print "www.sw2us.com@2010 v.1.0.0"
   print "Serving HTTP on", sa[0], "port", sa[1], ""
   sys.stdout = buff
   sys.stderr = buff

   httpd.serve_forever()



if __name__ == '__main__':
   #getMacList()
   from sys import argv

   f = open('proxy.pid','w')
   f.write(str(os.getpid()))
   f.close()

   #ProxyHandler.allowed_clients = []
   try:
       allowed = []
       ss = confile.getPropertyValue('allowed_clients').strip()
       hosts = ss.split(',')
       for h in hosts:
           if h:
               client = socket.gethostbyname(h.strip())
               allowed.append(client)
       if len(allowed):
           ProxyHandler.allowed_clients = allowed
       buff = StringIO.StringIO()

       serving(ProxyHandler, ThreadingHTTPServer)
   except:
       pass
