https://github.com/likebeta/twisted-intro-cn/tree/gh-pages/zh

启动反应器是很简单的，从twisted.internet模块导入reactor对象。然后调用reactor.run()来启动反应器的事件循环。

---- BaseProtocol ----
class BaseProtocol:
connected=0 #是否已经连接了
transport=None #用于数据发送的传输对象
def makeConnection(self,transport): #建立连接的方法，不是事件方法，一般不要重载
def connectionMade(self): #连接成功事件，可重载
可以看到BaseProtocol可以理解为一个虚基类，实现的功能十分简陋。实际的应用程序一般也不是直接继承
BaseProtocol来实现协议，而是继承Protocol类。Protocol类提供了基本完善的协议功能，接口定义如下：
 
class Protocol(BaseProtocol):
def dataReceived(self,data): #接收到数据事件，可重载 接收到数据事件，可重载
def connectionLost(self,reason=connectionDone): #连接断开事件，可重载，依靠 连接断开事件，可重载，依靠reason区分断开类型 区分断开类型

从Protocol类继承就可以完成协议的基本处理了，包括连接的建立和断开事件，还有数据接收事件。

---- Factory ----
class Factory:
protocol=None #指向一个协议类 指向一个协议类
def startFactory(self): #开启工厂 开启工厂
def stopFactory(self): #关闭工厂 关闭工厂
def buildProtocol(self,addr): #构造协议对象，并给协议对象添加一个factory属性指向工厂，可以重载
从 这里可以看到，工厂类中最重要的部分就是protocol属性，将这个属性设置为一个协议类(注意不是协议对象)，就
可以将这个工厂设置为对应协议的工厂 了。前两个方法控制工厂的开启和关闭，用于资源的初始化和释放，可以重
载
。buildProtocol()方法可以控制协议对象的生成，(by gashero)如果需要多传递一个属性，可以重载，但是重载时应
该注意在方法内继承原方法内容。
 
工厂还分为客户端工厂和服务器工厂。服务器工厂继承自 工厂还分为客户端工厂和服务器工厂。服务器工厂继承自Factory，而没有任何修改，定义如下： ，而没有任何修改，定义如下：
class ServerFactory(Factory):
 
客户端工厂则有较多内容，接口定义如下： 客户端工厂则有较多内容，接口定义如下：
class ClientFactory(Factory):
def startedConnecting(self,connector): #连接建立成功时 连接建立成功时
def clientConnectionFailed(self,connector,reason): #客户端连接失败 客户端连接失败
def clientConnectionLost(self,connector,reason): #连接断开 连接断开
这三个方法都传递了一个connector对象，这个对象有如下方法可用：
connector.stopConnection() #关闭会话
connector.connect() #一般在连接失败时用于重新连接

---- ClientCreator ----
twisted.internet.protocol.ClientCreator是一个连接器，用来连接远程主机，接口定义如下：
class ClientCreator:
def __init__(self,reactor,protocolClass,*args,**kwargs):
def connectTCP(self,host,port,timeout=30,bindAddress=None):
def connectUNIX(self,address,timeout=30,checkPID=0):
def connectSSL(self,host,port,contextFactory,timeout=30,bindAddress=None):
三个连接方法都是返回Deferred对象作为Protocol实例，在不需要工厂时可以直接使用这个类来产生仅使用一次的客
户端连接。这时，协议对象之间没有共享状态，也不需要重新连接。

---- reactor ----
reactor.callLater方法用于设置定时事件：
reactor.callLater函数包含两个必须参数，等待的秒数，和需要调用的函数
意思是多少秒钟之后调用某个函数
在实际应用中，reactor.callLater是常用于超时处理和定时事件。可以设置函数按照指定的时间间隔来执行关闭非活
动连接或者保存内存数据到硬盘。
reactor.stop()停止循环，退出循环

1. 安装
pip install twisted		#安装Twisted
pip install PyOpenSSL	#使用SSL特性
pip install PyCrpyto	#使用SSH特性

2. 验证
import twisted
twisted.__version__

# 验证SSL特性
>>> import OpenSSL
>>> import twisted.internet.ssl
>>> twisted.internet.ssl.SSL

#验证SSL特性
>>> import Crypto
>>> import twisted.conch.ssh.transport
>>> twisted.conch.ssh.transport.md5

3. Echo Server & Client
# Echo Server
from twisted.internet import protocol, reactor

class Echo(protocol.Protocol):
    def dataReceived(self, data):
        self.transport.write(data)

class EchoFactory(protocol.Factory):
    def buildProtocol(self, addr):
        return Echo()

reactor.listenTCP(8000, EchoFactory())
reactor.run()

# Echo Client
from twisted.internet import reactor, protocol

class EchoClient(protocol.Protocol):
   def connectionMade(self):
       self.transport.write("Hello, world!".encode())

   def dataReceived(self, data):
       print("Server said:", data)
       self.transport.loseConnection()

class EchoFactory(protocol.ClientFactory):
   def buildProtocol(self, addr):
       return EchoClient()

   def clientConnectionFailed(self, connector, reason):
       print("Connection failed.")
       reactor.stop()

   def clientConnectionLost(self, connector, reason):
       print("Connection lost.")
       reactor.stop()

reactor.connectTCP("localhost", 8000, EchoFactory())
reactor.run()


事件驱动编程
事件驱动编程, 程序流是由外部事件控制. 通常来说, 会有个事件循环(event loop),并且当事件触发时, 调用callback函数.
除了事件驱动模型外, 还有单线程同步模型和多线程模型. 3种模型

1. Reactor
twisted的核心是reactor事件循环. 它会等待并派发事件到等待的事件处理器. Twsited会小心的处理不同系统的差异并使用正确的非阻塞API.
reactor实现的伪代码为:
while True:
	timeout = time_until_next_timed_event()
	events = wait_for_events(timeout)
	events += timed_events_until(now())
	for event in events:
		event.process()

reactor的listenTCP()和connectTCP()方法会在reactor中注册回调函数. reactor.run()方法会启动事件循环. 一旦启动, reactor就会轮询并派发事件直到reactor.stop()方法调用

2. Transport
transport代表网络两个终端之间的连接. transport描绘连接的细节: 比如TCP,UDP还是Unix Socket,连接端口等等.
Tansport继承自ITransport接口, 有如下方法:

    write: 以非阻塞方式往connection写入数据
    writeSequence:往connection中写入string list.在面向线性的协议中是否有用.
    loseConnection: 输出未定的数据并关闭连接
    getPeer: 获取连接对端地址
    getHost: 类似getPeer, 但返回连接本端地址

3. Protocol
protocol表示如何异步的处理网络事件. Twisted已经实现了很多应用协议,包括HTTP, Telnet, DNS, IMAP等等. Protocol实现IProtocol接口, 有如下方法:
    makeConnection: 创建传输两个端点的连接.
    connectionMode: 当连接建立时调用
    dataReceived: 当数据接收时调用
    connectionLost: 当连接关闭时调用

4. ProtocolFactory
每个连接都会创建一个protocol对象并在连接回收时释放.也就是说持久化的配置信息不会保存在protocol中,而会保存在protocol.Factory或protocol.ClientFactory类中,通过buildProtocol()方法来给每个连接创建protocol
解耦Transport和Protocol

twisted实现的一个主要决策是完全解耦Transport和Protocol.解耦将会使不同的Protocol使用相同的Transport


5. Writing Asynchronous Code with Deferreds

Deferred结构
一个Deferred有两个callback链. 一个对应成功, 另一个对应失败. 初始的时候, 这两个链都是空的. 你可以成对的添加成功和失败callback到deferred中. 当异步结果到来时, Deferred会依据添加到链中的callback进行触发 Deferred-Chain

from twisted.internet.defer import Deferred

def myCallback(result):
    print(result)

d = Deferred()
d.addCallback(myCallback)
d.callback("Triggering callback.")

from twisted.internet.defer import Deferred

def myErrback(failure):
    print(failure)

d = Deferred()
d.addErrback(myErrback)		#同时添加了一个pass-through callback
d.errback(ValueError("Triggering errback."))

from twisted.internet.defer import Deferred

def addBold(result):
    return "<b>%s</b>" % (result,)

def addItalic(result):
    return "<i>%s</i>" % (result,)

def printHTML(result):
    print(result)

d = Deferred()
d.addCallback(addBold)		#同时添加了一个pass-througherrback
d.addCallback(addItalic)
d.addCallback(printHTML)
d.callback("Hello World")

#输出
<i><b>Hello World</b></i>
callback链和在reactor中使用

    addCallbacks: 同时添加callback到callback链, errback到errback链, 且在同一层
    addCallback: 添加callback到callback链, 同时添加一个pass-through errback到errback链
    addErrback: 添加errback到errback链, 同时添加一个pass-through callback到callback链

添加callback和errback
总结
    一个Deferred由callback()或errback()方法触发
    一个Deferred只能被触发一次, 再次触发会抛出AlreadyCalledError
    在N层callback或errback抛出的异常将会被N+1层的errback处理; 同理, 在N层callback或errback返回的成功结果将会被N+1层的callback处理
    Deferred链中一个callback返回的结果将作为下一个callback的第一个参数. 这允许我们链式的处理结果,因此在callback函数中不要忘记返回结果
    如果传入errback并不是一个Failure(比如可能是个异常), 它会被包装成一个Failure.
    
    
6. Deploying Twisted Applications
Twisted应用结构
    Services: 一个服务是实现了IService接口,并且可以被启动和停止. Twisted已经实现的服务包括TCP, FTP, HTTP, SSH, DNS,和许多其他的协议. 许多服务可被注册到同一个应用中. IService接口方法包括:
        startService: 启动服务. 比如加载配置文件信息, 建立数据库连接, 端口监听等等
        stopService: 关闭服务.

    Applications: 应用是顶层的容器, 包含内部部署的一个或多个服务

    TAC文件: 当编写Twisted程序时,开发者写代码来启动或停止reactor.在Twisted应用中, 协议的实现在模块中, 使用这些协议的服务被注册成Twisted Application Configuration(TAC)文件,reactor和配置由外部工具管理

    twistd: twistd是个跨平台用于部署twisted应用的工具. 它运行TAC文件并处理应用的启动和停止.
     twistd -y echo.tac
    注: (1)在python3中, 这种方式会报错, 需要添加-n/--nodaemon参数; (2)windows下运行不了twistd命令

    plugins: 对于基于TAC文件启动另一种应用形式是使用插件系统. 使用方式为: twistd plugin方式

    并编写IPlugin,IServiceMaker的实现类.

7. Logging

Twisted有自己的日志系统. 日志系统能很好的和Twisted特性(比如Failure)一起工作, 也能兼容标准库中的日志工具

from twisted.internet import protocol, reactor
from twisted.python import log
import sys

class Echo(protocol.Protocol):
    def dataReceived(self, data):
        log.msg(data)
        self.transport.write(data)

class EchoFactory(protocol.Factory):
    def buildProtocol(self, addr):
        return Echo()

# log.startLogging(open('echo.log', 'w'))
log.startLogging(sys.stdout)
reactor.listenTCP(8000, EchoFactory())
reactor.run()

Twisted有一些方便的类用于日志文件的管理. 一个例子是twisted.python.logfile.LogFile,其能够手动的控制轮转或自动的根据日志大小自动轮转

from twisted.python import log
from twisted.python import logfile

# Log to /tmp/test.log ... test.log.N, rotating every 100 bytes.
f = logfile.LogFile("test.log", "/tmp", rotateLength=100)
log.startLogging(f)

log.msg("First message")

# rotate manually
f.rotate()

for i in range(5):
    log.msg("Test message", i)

log.msg("Last message")

twistd logging
twistd应用默认会使用Twisted的日志系统. 如果后台运行, 会打印到twistd.log日志文件中.
twistd内置的日志可通过命令行参数自定义: --logfile用于指定日志文件, -用于使用stdout, --syslog用于将日志输出到syslog中
如果要自定义Logging, 需要实现LogObserver类
总结

    使用log.startLogging来启动日志记录到文件, 要么直接使用, 要么通过一个很方便的类, 比如DailyLogFile
    通过log.msg或log.err来进行日志记录. 默认情况下, log.startLogging方法也会重定向stdout和stderr到日志文件.
    使用Use log.addObserver来注册自定义loggers
    当自定义log boservers时, 千万不要阻塞事件循环. 如果要在多线程环境中使用的话, observer要注意线程安全.
    twistd 应用具有自动日志记录功能. 可通过--logfile, --syslog, 和 --logger参数修改日志配置

8. Database
由于Twisted中, 事件循环处理是不能阻塞的. 而标准库中的dbapi接口都是阻塞API接口, 因此Twisted提供了twisted.enterprise.adbapi模块作为DB-API2.0接口的非阻塞实现.

**注:twisted.enterprise目前并非是Twisted官方的模块, 据说在16.4版本中会被添加进来. **

从阻塞到非阻塞的dbapi的转换是非常直接的: 使用adbapi.ConnectionPool来管理线程池的连接而不是创建独立的连接. 当你有个数据库游标时, 使用dbpool.runQuery而不是阻塞的execute和fetchall方法来查询结果.

from twisted.internet import reactor
from twisted.enterprise import adbapi

dbpool = adbapi.ConnectionPool("sqlite3", "users.db")

def getName(email):
    return dbpool.runQuery("SELECT name FROM users WHERE email = ?",
                           (email,))

def printResults(results):
    for elt in results:
        print((elt[0]))

def finish():
    dbpool.close()
    reactor.stop()

d = getName("jane@foo.com")
d.addCallback(printResults)

reactor.callLater(1, finish)
reactor.run()

8. Authentication
Twisted有个协议独立的, 插件式的,异步认证系统:Cred. 它可被添加到Twisted的各种认证服务中. 另外, Twisted还有很多公共的认证机制.

Cred组件
    Credentials: 用于确认用户认证的信息. 一般指用户名/密码等等. 实现twisted.cred.credentials.ICredentials接口
    Avatar: 服务器上表示用户可访问的动作或数据的业务逻辑对象. 比如, 如果是邮件服务器, 则为收件箱; 如果是web服务器, 则为一个访问资源.
    Avatar ID: 校验器对于用户访问Avatar进行身份校验返回的字符串标识符. 通常为一个用户名, 但可可以是唯一的标识符. 比如“Joe Smith”, “joe@localhost”, and “user926344”.
    Credential checker: credential的校验器. 如果校验成功, 返回Avatar ID. 其也支持匿名访问,返回twisted.cred.checkers.ANONYMOUS. 实现了twisted.cred.checker.ICredentialsCheck接口
    Realm: 一个应用中支持访问所有Avatar的对象. Realm 包含一个Avatar ID用于确认用户,以及返回用户需要访问的Avatar对象. 一个Realm支持多种类型的avatar. 运行不同的用户访问不同的资源. Realm对象实现了 twisted.cred.portal.IRealm 接口.
    Portal: portal协调中Cred各个组件之间的交互. 其不能被继承.
    
from zope.interface import implements, Interface, implementer
from twisted.cred import checkers, credentials, portal
from twisted.internet import protocol, reactor
from twisted.protocols import basic

class IProtocolAvatar(Interface):
    def logout():
        """
        Clean up per-login resources allocated to this avatar.
        """

@implementer(IProtocolAvatar)
class EchoAvatar(object):
    # implements(IProtocolAvatar)

    def logout(self):
        pass

class Echo(basic.LineReceiver):
    portal = None
    avatar = None
    logout = None

    def connectionLost(self, reason):
        if self.logout:
            self.logout()
            self.avatar = None
            self.logout = None

    def lineReceived(self, line):
        if not self.avatar:
            username, password = line.decode().strip().split(" ")
            self.tryLogin(username, password)
        else:
            self.sendLine(line)

    def tryLogin(self, username, password):
        self.portal.login(credentials.UsernamePassword(username,
                                                       password),
                          None,
                          IProtocolAvatar).addCallbacks(self._cbLogin,
                                                        self._ebLogin)

    def _cbLogin(self, xxx_todo_changeme):
        (interface, avatar, logout) = xxx_todo_changeme
        self.avatar = avatar
        self.logout = logout
        self.sendLine(b"Login successful, please proceed.")

    def _ebLogin(self, failure):
        self.sendLine(b"Login denied, goodbye.")
        self.transport.loseConnection()

class EchoFactory(protocol.Factory):
    def __init__(self, portal):
        self.portal = portal

    def buildProtocol(self, addr):
        proto = Echo()
        proto.portal = self.portal
        return proto

@implementer(portal.IRealm)
class Realm(object):
    # implements(portal.IRealm)

    def requestAvatar(self, avatarId, mind, *interfaces):
        if IProtocolAvatar in interfaces:
            avatar = EchoAvatar()
            return IProtocolAvatar, avatar, avatar.logout
        raise NotImplementedError(
            "This realm only supports the IProtocolAvatar interface.")

realm = Realm()
myPortal = portal.Portal(realm)
checker = checkers.InMemoryUsernamePasswordDatabaseDontUse()
checker.addUser("user", "pass")
myPortal.registerChecker(checker)

reactor.listenTCP(8000, EchoFactory(myPortal))
reactor.run()

认证过程