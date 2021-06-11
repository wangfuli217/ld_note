from twisted.internet import reactor
from twisted.internet.protocol import Protocol, Factory
from webloglib import hit_tag, log_fields
import time
class WebLog(Protocol):
    def connectionMade(self):
        print"Connected from", self.transport.client
        self.transport.write('<hits>')
        self.ts = time.time()
        self.newHits()
    def newHits(self):
        for hit in self.factory.records:
            if self.ts <= hit[0]:
                self.transport.write(hit_tag % log_fields(hit[1]))
        self.ts = time.time()
        reactor.callLater(5, self.newHits)
    def connectionLost(self, reason):
        print"Disconnected from", self.transport.client
class WebLogFactory(Factory):
    protocol = WebLog
    def __init__(self, fname):
        self.fname = fname
        self.records = []
    def startFactory(self):
        self.fp = open(self.fname)
        self.fp.seek(0, 2) # Start at end of current access log
        self.updateRecords()
    def updateRecords(self):
        ts = time.time()
        for rec in self.fp.readlines():
            self.records.append((ts, rec))
        self.records = self.records[-100:]  # Only keep last 100 hits
        reactor.callLater(1, self.updateRecords)
    def stopFactory(self):
        self.fp.close()
if __name__=='__main__':
    reactor.listenTCP(8888, WebLogFactory('access-log'))
    reactor.run()