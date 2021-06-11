from twisted.internet import reactor
from twisted.internet.protocol import Protocol, Factory
from webloglib import hit_tag, log_fields
class WebLog(Protocol):
    def connectionMade(self):
        print"Connected from", self.transport.client
        self.transport.write('<hits>')
    def dataReceived(self, data):
        newhits = LOG.readlines()
        ifnot newhits:
            self.transport.write('<none/>')
        for hit in newhits:
            self.transport.write(hit_tag % log_fields(hit))
    def connectionLost(self, reason):
        print"Disconnected from", self.transport.client
factory = Factory()
factory.protocol = WebLog
if __name__=='__main__':
    global LOG
    LOG = open('access-log')
    LOG.seek(0, 2)     # Start at end of current access log
    reactor.listenTCP(8888, factory)
    reactor.run()