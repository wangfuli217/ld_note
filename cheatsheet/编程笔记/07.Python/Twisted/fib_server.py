from twisted.internet.app import Application
from twisted.internet.protocol import Protocol, Factory
class Fibonacci(Protocol):
    "Serve a sequence of Fibonacci numbers to all requesters"def dataReceived(self, data):
        self.factory.new = self.factory.a + self.factory.b
        self.transport.write('%d' % self.factory.new)
        self.factory.a = self.factory.b
        self.factory.b = self.factory.new
def main():
    import fib_server    # Use script as namespace
    f = Factory()
    f.protocol = fib_server.Fibonacci
    f.a, f.b = 1, 1
    application = Application("Fibonacci")
    application.listenTCP(8888, f)
    application.save()
if'__main__' == __name__:
    main()