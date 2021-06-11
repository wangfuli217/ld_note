#!/home/98/46/2924698/bin/python
from SocketServer import BaseRequestHandler, TCPServer
from time import sleep
from xml.sax.saxutils import quoteattr
import sys, socket


def log_fields(line):
    start, stop = 0, 0
    while line[stop] <> " ": stop += 1
    ip = line[start:stop]
    start = stop
    while line[start] <> "[": start += 1
    stop = start+1
    while line[stop] <> "]": stop += 1
    timestamp = line[start+1:stop]
    start = stop+1
    while line[start] <> '"': start += 1
    stop = start+1
    while line[stop] <> '"': stop += 1
    request = line[start+1:stop]
    start, stop = stop, stop+1
    while line[stop] <> '"': stop +=1
    status, bytes = line[start+1:stop].split()
    stop += 1
    start = stop
    while line[stop] <> '"': stop += 1
    referrer = line[start:stop]
    agent = line[stop:].strip(' "\n\r')
    vals = [ip, timestamp, request, status, bytes, referrer, agent]
    return tuple(map(quoteattr, vals))
 
hit_tag = '''
<hit 
  ip=%s 
  timestamp=%s 
  request=%s 
  status=%s 
  bytes=%s 
  referrer=%s 
  agent=%s/>'''

class WebLogHandler(BaseRequestHandler):
    def handle(self):
        print "Connected from", self.client_address
        self.request.sendall('<hits>')
        try:
            while True:
                for hit in LOG.readlines():
                    self.request.sendall(hit_tag % log_fields(hit))
                sleep(5)
        except socket.error:
            self.request.close()
        print "Disconnected from", self.client_address

if __name__=='__main__':
    global LOG
    LOG = open('../access-log')
    LOG.seek(0, 2)     # Start at end of current access log
    srv = TCPServer(('',8888), WebLogHandler)
    srv.serve_forever()
