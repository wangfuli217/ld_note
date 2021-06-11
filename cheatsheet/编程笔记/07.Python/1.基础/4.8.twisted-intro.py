http://twistedmatrix.com/documents/10.0.0/core/howto/index.html
http://krondo.com/an-introduction-to-asynchronous-programming-and-twisted/
https://github.com/likebeta/twisted-intro-cn/blob/gh-pages/zh/SUMMARY.md


初识twisted
    from twisted.internet import reactor
    reactor.run()
    说明:
        Twisted的reactor只有通过调用reactor.run()来启动。
        reactor循环是在其开始的进程中运行，也就是运行在主进程中。
        一旦启动，就会一直运行下去。reactor就会在程序的控制下（或者具体在一个启动它的线程的控制下）。
        reactor循环并不会消耗任何CPU的资源。
        并不需要显式的创建reactor，只需要引入就OK了。
        
hello, Twisted
    def hello():
        print('Hello from the reactor loop!')
        print('Lately I feel like I\'m stuck in a rut.')
    
    from twisted.internet import reactor
    
    reactor.callWhenRunning(hello)
    
    print('Starting the reactor.')
    reactor.run()
    
    # 输出
    Starting the reactor.
    Hello from the reactor loop!
    Lately I feel like I'm stuck in a rut.
    一些说明:
        reactor模式是单线程的
        像Twisted这种交互式模型已经实现了reactor循环，意味无需我们亲自去实现它
        我们仍然需要框架来调用我们自己的代码来完成业务逻辑
        因为在单线程中运行，要想跑我们自己的代码，必须在reactor循环中调用它们
        reactor事先并不知道调用我们代码的哪个函数 这样的话，回调并不仅仅是一个可选项，而是游戏规则的一部分
        
退出twisted
    class Countdown(object):
    
        counter = 5
    
        def count(self):
            if self.counter == 0:
                reactor.stop()
            else:
                print(self.counter, '...')
                self.counter -= 1
                reactor.callLater(1, self.count)
    
    from twisted.internet import reactor
    
    reactor.callWhenRunning(Countdown().count)
    
    print('Start!')
    reactor.run()
    print('Stop!')
        
        
异常
    twisted并不会因为应用程序的异常而终止reactor的事件循环.看下面的代码
    def falldown():
        raise Exception('I fall down.')
    
    def upagain():
        print('But I get up again.')
        reactor.stop()
    
    from twisted.internet import reactor
    
    reactor.callWhenRunning(falldown)
    reactor.callWhenRunning(upagain)
    
    print('Starting the reactor.')
    reactor.run()
    
    falldown()抛出的异常并不会阻止upagain()方法的继续运行.
    
transport
    Transports抽象是通过Twisted中interfaces模块中ITransport接口定义的。一个Twisted的Transport代表一个可以收发字节的单条连接。
    对于我们的诗歌下载客户端而言，就是对一条TCP连接的抽象。但是Twisted也支持诸如Unix中管道和UDP。
    Transport抽象可以代表任何这样的连接并为其代表的连接处理具体的异步I/O操作细节。

    如果你浏览一下ITransport中的方法，可能找不到任何接收数据的方法。
    这是因为Transports总是在低层完成从连接中异步读取数据的许多细节工作，然后通过回调将数据发给我们。
    相似的原理，Transport对象的写相关的方法为避免阻塞也不会选择立即写我们要发送的数据。告诉一个Transport要发送数据，只是意味着：尽快将这些数据发送出去，别产生阻塞就行。当然，数据会按照我们提交的顺序发送。
    
    通常我们不会自己实现一个Transport。我们会去实现Twisted提供的类，即在传递给reactor时会为我们创建一个对象实例。
    
protocol
    Twisted的Protocols抽象由interfaces模块中的IProtocol定义。
    也许你已经想到，Protocol对象实现协议内容。也就是说，一个具体的Twisted的Protocol的实现应该对应一个具体网络协议的实现，像FTP、IMAP或其它我们自己规定的协议。
    我们的诗歌下载协议，正如它表现的那样，就是在连接建立后将所有的诗歌内容全部发送出去并且在发送完毕后关闭连接。
    
    严格意义上讲，每一个Twisted的Protocols类实例都为一个具体的连接提供协议解析。因此我们的程序每建立一条连接（对于服务方就是每接受一条连接），都需要一个协议实例。
    这就意味着，Protocol实例是存储协议状态与间断性（由于我们是通过异步I/O方式以任意大小来接收数据的）接收并累积数据的地方。
    
    因此，Protocol实例如何得知它为哪条连接服务呢？如果你阅读IProtocol定义会发现一个makeConnection函数。这是一个回调函数，Twisted会在调用它时传递给其一个也是仅有的一个参数，即就是Transport实例。这个Transport实例就代表Protocol将要使用的连接。
    
    Twisted包含很多内置可以实现很多通用协议的Protocol。你可以在twisted.protocols.basic中找到一些稍微简单点的。在你尝试写新Protocol时，最好是看看Twisted源码是不是已经有现成的存在。如果没有，那实现一个自己的协议是非常好的，正如我们为诗歌下载客户端做的那样。
    
protocol factory
    因此每个连接需要一个自己的Portocol，而且这个Protocol是我们自己定义类的实例。由于我们会将创建连接的工作交给Twisted来完成，Twisted需要一种方式来为一个新的连接制定一个合适的协议。制定协议就是Protocol Factories的 工作了。
    
    也许你已经猜到了，Protocol Factory的API由IProtocolFactory来定义，同样在interfaces模块中。Protocol Factory就是Factory模式的一个具体实现。buildProtocol方法在每次被调用时返回一个新Protocol实例。它就是Twisted用来为新连接创建新Protocol实例的方法。

    