
part1. Web Service概述
-----------------------------------------------------
一、 Web Service概述
  1.动机
     1) 今天，万维网的主要用途是交互式的访问文档和应用程序;
     2) 大多数时候，这些访问是通过浏览器、音频播放器或其它交互式的前-后端系统;
     3) W3C: “假如万维网支持应用程序间的交互，Web在能力及应用范围上能得到引人注目的增长”

  2.理念：构建应用程序的时候通过发现以及调用网络上现在的应用去实现某些功能;

二、 技术基础
    Web services = XML + HTTP
    XML：通用数据描述语言;
    HTTP：被浏览器和Web servers广泛支持的一种传输协议;

三、 What is web service
     1) 在互联网上，通过基于标准的互联网协议(例如HTTP、SMTP)访问的一段业务逻辑。或者叫Web服务组件。
     2) 承诺在一个分布式环境中，不同的平台的，不同语言的应用和应用组件之间能够互操作。
     3) Web service是自我包含、自我描述、模块化的程序，它能发布、定位以及通过Web调用;
     4) 一旦一个web service被布署，其它应用程序即可发现和调用这个服务。
     5) 技术上来说，Web Service也是一种远程方法调用

  1. 自我包含
     1) 在客户端，无须附加的软件;
     2) 只须XML和HTTP协议客户端支持即可开始;
     3) 在服务器端，仅需要一个Web服务器和servlet引擎;
     4) 对于Web service使一个既存的系统重新可用而无须写一行代码是可行的;
  2. 自我描述
     1) 无论是客户端还是服务器端除了格式和请求内容以及响应信息外无须关注任何事情;
     2) 信息格式定义通过消息传输;
     3) 无额外的无素贮藏库或代码产生工具需要;
  3. 模块化的程序
     1) Web services标准框架提供了一个组件模型;
     2) Web services是一种技术，用于部署和提供Web上的商业功能访问;
     3) J2EE、CORBA和其它标准是实现这些Web services的技术;
  4. 发布、定位以及通过Web调用所需的一些额外的标准：
     SOAP：Simple Object Access Protocol
          也可理解为 service-oriented architecture protocol，基于RPC和通讯协议的XML。
     WSDL：Web Service Description Language, 一个描述性的接口和协议绑定语言。 
     UDDI：Universal Description, Discovery and Integration，一种注册机制，用于查找Web service描述。
  5. 语言无关和互操作性
     1) 客户端和服务器端能在不同环境下被实现;
     2) 既存的环境为了实现 Web service 无须进行改动;
     3) 但是在现在，我们假设Java是Web service客户端和服务器端的实现语言;
  6. 基于开放的标准
     1) XML和HTTP是Web services的技术基础;
     2) 很大部分Web service技术使用开源项目构建;
     3) 因此，供应商无关以及互操作性是这时的现实目标。
  7. Web services是动态的
     通过使用Web Services，动态电子商务变得很现实。
     因为，使用UDDI和WSDL，Web service描述和发现可以自动进行。
  8. Web services是组合的、简单的
     Web services能组合成更复杂的Web services，无论是使用工作流技术或是调用更底层的Web services。
  9. 基于成熟技术构建
     1) XML + HTML
     2) 和其它分布式计算框架相比，有很多相同点也有很多基础性的不同。
        例如，传输协议基于文本而非二进制。

四、 Web Service可以解决的问题
    1) 异构应用系统之间的集成
       异构程序定位：使用URI标志软件程序
          传输协议：HTTP、FTP、SMTP等公共协议    
          数据格式：XML
          接口描述：XML
    2) 不同公司之间的系统集成
       公共的互联网协议HTTP、FTP、SMTP
    3) 需要集成的系统之间有防火墙
       使用公共的网络协议HTTP、FTP、SMTP
          传统的做法是，选择用浏览器作为客户端(大量跳转页面和控制程序) 
          新的做法(Ajax，Web Service) 
       区别于web应用
          web application： 人(浏览器)与应用的交互
          web service：     应用与应用的交互
    4) 代码重用的问题
       使用HTTP等服务，无需下载或安装服务程序的代码

  Web service的好处. 
      专注于核心商业逻辑，使用Web service应用于非核心商业逻辑从而以一个很低的成本快速发布新的IT解决方案; 
      通过使用Web service封装以前软件系统到当前系统中可保护既有投资; 
      以最少的费用将用户和伙伴的商业系统结合到一块; 
   1.好处——促进协同工作能力
     1) service provider和service requester之间的沟通设计为平台和语言无关;
     2) 这个交互需要一份WSDL文档，这份文档定义了接口以及描述了相应的服务，连同网络协议在一起(通常是HTTP); 
   2.好处——
     1) 当service requester 使用service broker寻找service provider，这种发现是自动发生的。
     2) 一旦requester和provider相互找到，provider的WSDL文档用于将requester和服务绑定到一块。
     3) 这意味着requester、provider和broker一块创建的系统是自我设置、自我适应以及强健的。 
   3.好处——通过封装降低了复杂性
     1) service requester和provider只关心必要的接口;
     2) service requester并不关心service provider如何实现服务;
     3) 这些细节都在requester和provider方封装好，这种封装对于降低复杂性非常重要; 
   4.好处——给遗留系统以新的生机
     1) 对于一个遗留系统、产生一个SOAP包装，然后产生一个WSDL文档将应用程序作为一个web service;
     2) 这意味着遗留系统能用于新的方面;
     3) 此外，与遗留系统相联系的基础设施能封装成一系列的服务;

五、 Web Service的特点
    1) 基于XML，异构应用集成容易
    2) 基于消息的(HTTP和SOAP消息) 
       松散耦合的(调用服务代码时无需下载和安装) 
       编程语言独立的(使用HTTP等协议，通信更加简单，使用XML的数据格式，程序更易识别) 
       提供异步和同步的能力(异步功能提高访问性能) 
       能动态装配和集成(可以使用更多服务) 
       通过互联网进行访问
    3) 基于工业标准的(W3C的 WSDL, SOAP, UDDI) 

六、 Web Service角色
     1) service provider 创建web service并发布它的接口和访问信息到服务登记处;
     2) service broker   (也称为service registry)
        有责任使Web service接口和实现访问信息对任何潜在的service requestor可用;
     3) service requestor
        为了使用Web service，使用各种查找操作在broker登记处定义入口以及绑定到service provider。

    Service provider子角色
     1) WSDL规范由二部分组成：服务接口和服务实现;
     2) 服务接口提供者和服务实现者是service provider的子角色;
     3) 二个角色可以，但非必须被同一个事务承担;

七、 Web services架构体系
     1) 通过 service provider 部署到Web上;
     2) 提供的功能使用WSDL描述;
     3) service broker 帮助 service provider 和 service requestor 能互相找到对方;
     4) service requestor 使用 UDDI API从service broker 处寻找它所需要的服务;
     5) 当service broker 返回查找的结果，service requestor 可使用这些结果绑定到一个特定服务;
     6) Web service 描述由service provider创建和发布; 
     7) 由service broker 组织和查找; 
     8) 由service requester 定位和调用; 

八、 Web services组件
    前面显示了Web service中用到的三种主要的组件： 
     1) Service provider:  提供服务并使这些服务可用;
     2) Service broker:    为service provider和service requestor配对;
     3) Service requester: 使用service broker查找Web service，然后调用这些服务去创建应用程序;

九、 Web service操作
     1) 发布/取消发布 
        发布服务至登记处; 
        移除这些登记的条款 
        service provider联系
        service broker发布/取消服务
     2) 查找操作由service requestor和service broker共同完成:
        service requestor描述他们查找的服务种类; 
        service broker递交最匹配的请求结果。
     3) 绑定发生在service requestor和service provider间
        他们会协议好以便requestor能访问和调用service provider提供的服务。

六、 SOA架构(Service-Oriented Architecture) 
    面向服务的体系结构(Service-Oriented Architecture，SOA)是一个分布式组件模型，用来将现有的应用集成
    1) 把组件都看做网络服务
        将现有的应用、组件、业务逻辑发布为服务
        对服务的要求：与平台无关(硬件，操作系统，语言)；基于 internet 的服务,采用公共的网络协议
    2) SOA系统原型的一个典型例子是通用对象请求代理体系结构
       (Common Object Request Broker Architecture，CORBA) 
    3) 现在的SOA以XML为基础的，也就是Web Service
       Web服务是技术规范，而SOA是设计原则，Web服务是实现SOA的方式之一




part2. Web Service关键技术  ----  SOAP协议
-----------------------------------------------------
一、 What is SOAP(Simple Object Access Protocol) ——简单对象访问协议
     1) SOAP是一个网络中立的、轻量级的协议，用于交换两个远端应用程序的信息;
     2) SOAP是一个基于XML的协议，由三部分组成： 
        envelope: 定义了一个框架，该框架用于描述信息内容以及处理说明;
        一系列的编码规则:用于表现系统定义的数据类型实例; 
        一个协定:用于表现远端处理调用和响应
     3) SOAP使用XML技术定义了一个可扩展的消息框架，底层可以通过各种协议进行数据交换(主要HTTP、FTP、SMTP) 
     4) SOAP定义为与特定的编程模型和实现语句无关(只要它能处理XML信息) 
        是一个与协议无关的传输器, 用和许多协议共同使用(这里我们描述如何和HTTP一起使用SOAP);
     5) SOAP是分布式环境下交换结构化信息的规范;
     6) SOAP代表了SOA中三种主要行动者
        (service provider、service requestor、service broker)间主要的沟通方式;
     7) 它的设计目标是应该简单以及可扩展;

   1.SOAP VS JRMP、IIOP
        SOAP：传递基于XML的文本数据(基于文本的协议易识别和理解，例如HTTP) 
        JRMP、IIOP：传递字节数据
   2.SOAP1.2 是 W3C 推荐标准
        W3C(万维网联盟)组织是一个制定网络标准的非赢利组织,像 HTML、XHTML、CSS、XML 的标准都是由W3C来定制
   3.defines1：
        SOPA信封      定义消息结构：一个信封内包含一个消息头和一个消息体
        协议绑定框架    定义了一组规则把SOAP消息绑定到其他的底层协议
        参看：http://www.w3.org/TR/soap12-part1/
   4.defines2：
        Data modle for SOAP
            定义SOAP消息中的XML数据，和具体编程实现的数据类型的对应关系(如：XML转换成Java数据类型) 
        Binding to Http
            定义了如何将SOPA消息绑定到HTTP协议
        参看：http://www.w3.org/TR/soap12-part2/
   5.需要知道SOAP的细节吗？
     需要：了解细节有助于你构建更好的应用(如提高效率和性能：这要求对XML和底层通信协议的了解) 
     无需：一般情况你应该使用一些高层的API(如JAX-WS)构建应用，SOAP的实现细节对开发者透明

二、 SOAP信封
    1) 一条 SOAP 消息就是一个普通的 XML 文档，包含下列元素：
       必需的 Envelope 元素，可把此 XML 文档标识为一条 SOAP 消息 
       可选的 Header 元素，包含头部信息 
       必需的 Body 元素，包含所有的调用和响应信息 
             包含可选的 Fault 元素，提供有关在处理此消息所发生错误的信息 
    2) 所有以上的元素均被声明于针对 SOAP 封装的默认命名空间中：
         http://www.w3.org/2001/12/soap-envelope
       以及针对 SOAP 编码和数据类型的encodingStyle属性：
         http://www.w3.org/2001/12/soap-encoding

    1. SOAP消息 语法规则:
        必须用 XML 来编码 
        必须使用 SOAP Envelope 命名空间 
        必须使用 SOAP Encoding 命名空间 
        不能包含 DTD 引用 
        不能包含 XML 处理指令 
    2. SOAP 消息的基本结构
        <?xml version="1.0"?>
        <soap:Envelope
        xmlns:soap="http://www.w3.org/2001/12/soap-envelope"
        soap:encodingStyle="http://www.w3.org/2001/12/soap-encoding">
          <soap:Header>   ...    </soap:Header>
          <soap:Body>     ...
            <soap:Fault>  ...   </soap:Fault>
          </soap:Body>
        </soap:Envelope>

三、 信息格式
     1) 一个SOAP信息是一个envelope，该envelope包含零至多个header以及一个body元素;
     2) 这个envelope是XML文档的根元素;
     3) envelope为以下内容提供了了一个容器： 
        控制信息; 消息的收件人; 消息本身;
     4) header包含控制信息，例如服务属性;
     5) body包含消息标签以及它的参数;

四、 编码规则
     1) 编码规则定义了一系列机制用于交换程序自定义数据类型的实例;
     2) SOAP基于XML schema描述符(XSD)定义了一个与编程语言无关的数据类型schema, 
        根据这个模型为所有定义的数据类型加上这个编码规则;

五、 RPC代表
     1) RPC代表是适用于表现远端过程调用以及相关响应消息的一个协定;
     2) 作为远端方法中的参数，我们通常使用相关的简单数据结构。当然，也可以传输更复杂的数据。
     3) 这个协定仅被SOAP执行，并非SOAP标准的一部分。
     4) 这个转换的使用是可选的，假如没有使用RPC转换，会话是纯粹面向消息的;

六、 URN
     1) URN代表统一资源名称(unified resource name);
     2) URN唯一地识别给客户端的服务;
     3) 在单个SOAP服务器的所有部署的服务中，它必须是唯一的，通过一个合适的网络地址确定;
     4) 一个URN被编码为一个通用资源标识符(URI);
     5) 我们通过使用格式：urn:UniqueServiceID

七、 SOAP envelope
     1) envelope是表示为下列结构的XML文档的根元素:   [message payload]  
     2) 一个SOAP消息有零至多个header和一个body;
     3) SOAP envelope同样定义了结构化信息的名域空间;
     4) 整个SOAP消息(header和body)都封装在envelope内;
     5) 注意消息body使用一个服务特定的名域空间，类似于urn:NextMessage;
     6) 这个名域空间不同于SOAP-ENV, 这个名域空间被envelope所使用，由SOAP规范所定义;
     7) 因此在创建消息体的时候，这个应用程序能使用它自己的域特定词汇;

八、 SOAP Header
     1) header是envelope中可选的元素，假如出现的话，这个元素必须是SOAP envelope中第一个出现的子元素;
     2) 所有header元素的子元素称为header条款;
     3) header也能装载认证数据，数字签名，编码信息以及传输设置;
     4) header也能装载客户端或项目-指定控制以及协议的扩展;header的定义并不取决于body。
   1.可选的，用于扩展SOAP消息，例如：
     调用的上下文        目前的应用模式基本上停留在远程过程/对象的调用上，
                       基于多次协调调用或者遵循上下文的调用模式尚很少使用，这其实是受简单的SOAP消息的制约
     安全认证           保存用户标识及密码信息或者其他鉴定证书    
     事务控制           利用SOAP Header条目进行事务控制
     其他高级语义功能
   2.SOAP Header由一些Header条目组成
      <env:Header xmlns:env="http://www.w3.org/2001/06/soap-envelope" >
        <auth:authentication xmlns:auth="http://example.org/authentication"
         env:role="authentication:signin_service"  env:mustUnderstand="1"   relay=""  >
           <auth:userID>testuserid</auth:userID>
           <auth:password>[encodedPassword]</auth:password>
           <auth:redirection>http://example.com/service/</auth:redirection>
        </auth:authentication>
      </env:Header>
    3.role属性：(next|none|ultimateReceiver) 
         指定这个条目必须被哪种角色处理
    4.mustUnderstand：(true|false) 
         处理节点必须被处理，如果处理节点理解不了，必须返回一个SOAP Fault. (此时relay无意义) 
    5.relay：(true|false) 
         处理节点理解的条目，将会保留，并转发给下一个SOAP节点处理

九、 SOAP Body
    必须的，包含传递给最终的节点的实际信息
     1) SOAP body元素提供了一种机制用以交换信息;
     2) body元素是SOAP envelope元素的下一级元素;
     3) 假如存在header元素，body元素应该紧跟header元素之后。否则它应该紧跟envelope元素之后。
     4) 所有body元素的下一级子元素称为body的条目，这些条目各自独立;
     5) 在大多数简单的情况下，基本SOAP消息的body组成： 
        一个消息名称; 
        一个服务实例的引用;
     6) 在Apache SOAP中，一个服务实例为它的URN所标识。这个引用编码为名域空间的属性。
     7) 一至多个参数里装载着值和可选的类型引用; 
     8) 典型的body元素使用包括用相应的参数调用RPC、返回结果及错误报告; 
     9) 消息可以包括几乎任何XML结构，除了DTD及处理说明。

      <soap:Body xmlns:m="http://www.example.org/stock">
        <m:GetStockPrice>
            <m:StockName>IBM</m:StockName>
        </m:GetStockPrice>
      </soap:Body>


十、 SOAP Fault
    可选的，元素用于存留 SOAP 消息的错误和状态信息。必须出现在SOAP Body中
    <soap:Body xmlns:m="http://www.example.org/stock">
        <soap:Fault>
            <faultcode>MustUnderstand</faultcode>
            <faultstring>
                一个或多个必须的soap头未被理解
            </faultstring>
        </soap:Fault
    </soap:Body>

    <faultcode> 供识别故障的代码 
    <faultstring> 可供人阅读的有关故障的说明 
    <faultactor> 有关是谁引发故障的信息 
    <detail> 存留涉及 Body 元素的应用程序专用错误信息 

    faultcode的值:
      VersionMismatch:   SOAP Envelope 元素的无效命名空间被发现 
      MustUnderstand:    Header 元素的一个直接子元素(带有设置为 "1" 的 mustUnderstand 属性)无法被理解。 
      Client:            消息被不正确地构成，或包含了不正确的信息。 
      Server:            服务器有问题，因此无法处理进行下去。 

十一、SOAP HTTP Binding
    HTTP + XML = SOAP
    SOAP 请求可能是 HTTP POST 或 HTTP GET 请求。
    HTTP POST 请求规定至少两个 HTTP 头：Content-Type 和 Content-Length。

  1. SOAP请求
     POST /soapsamples/servlet/rpcrouter HTTP/1.0
     Host: localhost 
     Content-Type: 
     text/xml:charset=utf-8 
     Content-Length: 460 
     SOAPAction: ""  IBM  
      1) SOAP请求表明getQuote方法从以下地址调用：http://localhost/soapsamples/servlet/rpcrouter
      2) SOAP协议并没有指定如何处理请求，服务提供者可运行一个CGI脚本，调用servlet或执行其它产生对应响应的处理;
      3) 响应包含于一个XML文档格式的表单内，该表单包含了处理的结果，在我们这个范例中是IBM的股价; 
  2. SOAP响应
     HTTP/1.1 200 OK 
     Server: IBM HTTP SERVER/1.3.19 Apache/1.3.20 (Win32) 
     Content-Length: 479 
     Connection: close 
     Content-Type: text/xml; charset = utf-8 
     Content-Language: en  108.53  
     1) 结果所位于的元素名称在请求方法名后加后缀“Response”,
        例请求方法名为：getQuote, 响应方法名为：getQuoteResponse。 
  3. Http响应状态
     1) 1XX——information
     2) 2XX——success
     3) 3XX——redirection
     4) 4XX——client error
     5) 5XX——sever error 








part3. Web Service关键技术  ---  WSDL
-----------------------------------------------------
1. What is WSDL(Web Service Description Language) ——Web服务描述语言
   WSDL既是机器可阅读的，又是人可阅读的，这将是一个很大的好处。
   一些最新的开发工具既能根据你的Web service生成WSDL文档，又能导入WSDL文档，生成调用相应Web service的代码
     1) WSDL是以XML为基础的接口定义语言，它提供了一种分类和描述Web service的方式;
        描述Web服务 和说明如何与Web服务通信的XML语言
     2) WSDL定义了 Web service的接口，包括：
        a. 操作方式(单向、通知、请求-响应); 
        b. 定义了Web service的消息; 
        c. 数据类型(XML schema); 
           Web service访问协议(SOAP over HTTP); 
           Web service联系的终点(Web service URL); 
           符合要求的服务端应用程序必须支持这些接口，客户端用户能从这份文档中得知如何访问一个服务。 

2. WSDL文档结构
   <definitions>
       <types>    definition of types........    </types>
       <message>  definition of a message....    </message>
       <portType> definition of a port.......    </portType> //代表interface:接口
       <binding>  definition of a binding....    </binding>
       <service>  service of a binding....       </service>
   </definitions>

   总体上可以分为两大部分：
    1)抽象定义
      定义要交换的数据格式(数据类型/参数/返回值/方法声明) 
      types      定义数据类型，使用XML Schema作为类型系统
      messages   定义要交换的数据，数据类型是types中定义的数据类型。对应方法的参数
                 包括若干个part，每个part 都对应types中定义一个元素。对应方法的一个参数
      porttype(接口) 包含若干 operation；定义一个服务，对应Java的接口
                 包含一些operation，operation对应Java的方法
                 operation 都包含一个input 和 output 消息(messages中定义) 
    2)具体描述
      定义要采用的互操作协议(soap)、传输协议(http,ftp,smtp 等)、声明服务的访问地址    
      binding 针对 porttype 定义协议绑定和数据格式的细节：
              首先是定义消息风格(style) 和 传输协议(transport) 
              然后是对操作的输入输出的 消息编码方式(use) 
      service 包含若干 port
              port 定义了一个通信端点，代表 binding(不同协议)到 address 的映射

使用XFire开发Web Service
    XFire是一个开源的Web Service框架
    
    operation的四种类型：
        单向: 端点接收请求消息
        请求/应答: 端点接收请求消息，然后返回一个响应消息
        通知: 断点发送一个消息 
        要求/响应: 端点发送请求消息，然后接收一个响应消息

    SOAP的两种消息风格
        style=[document|rpc]
        document: 客户端使用 XML 模式调用约定。优点：更松散的客户端和服务器端耦合性，跨平台互操作性更好
           分两种: bared(裸露)；  wrapped，模拟rpc(包装的) 
        rpc:      客户端使用远程过程调用约定。  优点：对开发人员更加简单. 

    binding的传输协议
        transport="http://schemas.xmlsoap.org/soap/http" 
        transport="http://schemas.xmlsoap.org/soap/smtp"
    binding中消息的编码方式
        user=[literal|encoded]
        literal: 使用types定义的数据类型
        encoded: 使用soap定义好的数据类型，不能使用自定义数据类型

    可能的style/user组合
        1. style="rpc" and use="encoded"
        2. style="rpc" and use="literal"
        3. style="document" and use="encoded"
        4. style="document" and use="literal"
        其中WS-I组织只支持(user=literal)格式；(user=encoded不被支持) 
        WS-I(Web Services Interoperability Organization) Web服务协同组织
        尽量使用第4种: style="document" and use="literal"









    
part4. Web Service关键技术  ---  UDDI
-----------------------------------------------------
一、 What is UDDI (Universal Description Discovery and Integration) 
     1) 即统一描述、发现和集成协议。
     2) UDDI提供了一种发布和查找Web服务的方式，使贸易伙伴彼此发现对方和查询对方。
     3) UDDI提供了一个全球的、平台无关的、开放式框架，使得商业应用能： 
        相互查找;
        定义它们通过Web交互的方式; 
        在一个全球注册场所共享信息;
     4) 在Web上存在三种开放的UDDI注册场所, 由IBM、Microsoft 和HP发起;
     5) 注册是免费的，在任一注册处注册的内容被其它注册处所复制;
     6) 在UDDI商业注册处提供的信息由三部分组成： 
        “白皮书”：(白页 White pages)包括地址、联系以及标识符、产品信息;
        “黄皮书”：(黄页 Yellow pages)包括基于标准分类学的各产业分类;
        “绿皮书”：(绿页 Green pages)所提供的service的详细信息;
     7) Web service provider 和 requester 使用SOAP API和UDDI注册处交流; 

预想的结构：发布者--注册服务--使用者
   不是必须的，公共的注册服务目前还没有被广泛接受

UDDI的数据结构
   1. businessEntity. 白页信息，公司的信息
　　2. businessService.黄页信息，Web服务的分类信息
　　3. bindingTemplate. 绿页信息，Web服务的技术信息，包括如何调用Web服务的信息
　　4. tModels. 调用细节信息，包含WSDL文档的引用。











XFire动态客户端
-----------------------------------------------------
    第一步：引入 XFire相关的类库
        Core Libraries
        JAXB Libraries 
        HTTP Client Libraries 

    第二步：
        Client client = new Client(new URL("WSDL文档URL"));            //创建一个动态客户端
        Object[] results = client.invoke("test", new Object[] { "Juliet" });    //调用方法
        System.out.println( results[0]);

XFire动态客户端2
		Service srvcModel = new ObjectServiceFactory().create(MathService.class);
		XFireProxyFactory factory = new XFireProxyFactory(XFireFactory.newInstance().getXFire());

		// HelloWorld 服务名称
		String helloWorldURL = "http://localhost:8081/Hello/services/HelloWorld";
		IHelloWorld srvc = (IHelloWorld) factory.create(srvcModel, helloWorldURL);
		System.out.println("结果 ：" + srvc.example("tarena"));











