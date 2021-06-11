
http://dongxicheng.org/search-engine/thrift-framework-intro/
http://dongxicheng.org/search-engine/thrift-guide/
http://dongxicheng.org/search-engine/thrift-rpc/


前言
    Thrift 是一个跨语言的服务部署框架，最初由Facebook于2007年开发，2008年进入Apache开源项目。
    Thrift 通过一个中间语言(IDL, 接口定义语言)来定义RPC的接口和数据类型，然后通过一个编译器生成不同语言的代码(目前支持C++,Java, Python, PHP, Ruby, Erlang, Perl, Haskell, C#, Cocoa, Smalltalk和OCaml),并由生成的代码负责RPC协议层和传输层的实现。

Thrift 安装
    下载:  http://incubator.apache.org/thrift/download/
    # 解压下载的压缩包
    tar -xvf thrift-0.8.0.tar.gz
    # 进入解压后的目录
    cd thrift-0.8.0
    # 编译安装:
    ./configure
    make
    sudo make install

    /* 安装 python thrift 模块 */
    # 使用 easy_install 来安装
    sudo easy_install -U thrift

    # 生成代码
    要生成 C++ 代码: ./thrift --gen cpp tutorial.thrift    # 结果代码存放在 gen-cpp 目录下
    要生成 java 代码: ./thrift --gen java tutorial.thrift  # 结果代码存放在 gen-java 目录下
    要生成 python 代码: thrift -gen py hello.thrift  # 结果代码存放在 gen-py 目录下
    要生成 C# 代码: thrift -gen csharp hello.thrift  # 结果代码存放在 gen-py 目录下
    ...
    各语言的参数名称,参考 thrift 安装目录下的 lib 目录里面的各目录名称



语法参考
   1. Types
       Thrift 类型系统包括预定义基本类型, 用户自定义结构体, 容器类型, 异常和服务定义

    (1) 基本类型
        bool:   布尔类型(true or value), 占一个字节
        byte:   有符号字节
        i16:    16位有符号整型
        i32:    32位有符号整型
        i64:    64位有符号整型
        double: 64位浮点数
        string: 未知编码或者二进制的字符串

        注意, thrift 不支持无符号整型, 因为很多目标语言不存在无符号整型(如java)。

    (2) 容器类型
        Thrift容器与类型密切相关, 它与当前流行编程语言提供的容器类型相对应, 采用java泛型风格表示的。
        Thrift提供了3种容器类型：
            List<t1>：一系列t1类型的元素组成的有序表, 元素可以重复
            Set<t1>：一系列t1类型的元素组成的无序表, 元素唯一
            Map<t1,t2>：key/value对(key的类型是t1且key唯一, value类型是t2)。

        容器中的元素类型可以是除了 service 以外的任何合法 thrift 类型(包括结构体和异常)。

    (3) 结构体和异常
        Thrift结构体在概念上同C语言结构体类型—— 一种将相关属性聚集(封装)在一起的方式。
        在面向对象语言中, thrift结构体被转换成类。

        异常在语法和功能上类似于结构体, 只不过异常使用关键字 exception 而不是 struct 关键字声明。
        但它在语义上不同于结构体——当定义一个RPC服务时, 开发者可能需要声明一个远程方法抛出一个异常。

    (4) 服务
        服务的定义方法在语法上等同于面向对象语言中定义接口。
        Thrift编译器会产生实现这些接口的 client 和 server 桩。

    (5) 类型定义
        Thrift支持C/C++风格的 typedef:
        作用是:为现有类型创建一个新的名字,使代码更美观和可读。

        typedef i32 MyInteger   // 末尾没有逗号
        typedef Tweet ReTweet   // struct 可以使用 typedef


   2. 枚举类型
      可以像C/C++那样定义枚举类型, 如:

        enum TweetType {
            TWEET,        // 编译器默认从0开始赋值
            RETWEET = 2,  // 可以赋予某个常量某个整数
            DM = 0xa,     // 允许常量是十六进制整数
            REPLY
        }                 // 末尾没有逗号

        struct Tweet {
            1: required i32 userId;
            2: required string userName;
            3: required string text;
            4: optional Location loc;
            5: optional TweetType tweetType = TweetType.TWEET  // 给常量赋缺省值时, 使用常量的全称
            16: optional string language = "english"
        }

    注意, 不同于 protocal buffer, thrift 不支持枚举类嵌套, 枚举常量必须是32位的正整数


   3. 注释
      Thrfit支持shell注释风格, C/C++语言中单行或者多行注释风格,如:
        # This is a valid comment.
        /*
        * This is a multi-line comment.
        * Just like in C.
        */
        // C++/Java style single-line comments work just as well.


   4. 命名空间
      Thrift中的命名空间同 C++ 中的 namespace 和 java 中的 package 类似, 它们均提供了一种组织(隔离)代码的方式。
      因为每种语言均有自己的命名空间定义方式(如python中有module), thrift允许开发者针对特定语言定义namespace：

        namespace cpp com.example.project    // c++风格: 转化成 namespace com { namespace example { namespace project {
        namespace java com.example.project   // java风格: 转换成 package com.example.project


   5. 文件包含
      Thrift允许thrift文件包含, 用户需要使用thrift文件名作为前缀访问被包含的对象, 如：

        include "tweet.thrift"            // thrift文件名要用双引号包含, 末尾没有逗号或者分号
        ...
        struct TweetSearchResult {
            1: list<tweet.Tweet> tweets;  // 注意tweet前缀
        }


   6. 常量
      Thrift 允许用户定义常量, 复杂的类型和结构体可使用 JSON 形式表示。

        const i32 INT_CONST = 1234;       // 行结尾的分号是可选的, 可有可无；支持十六进制赋值。
        const map<string,string> MAP_CONST = {"hello": "world", "goodnight": "moon"}


   7. 定义结构体
      结构体由一系列域组成, 每个域有唯一整数标识符、类型、名字和可选的缺省参数组成。 如：

        struct Tweet {
            1: required i32 userId;                  // 每个域有一个唯一的, 正整数标识符
            2: required string userName;             // 每个域可以标识为required或者optional (也可以不注明)
            3: required string text;
            4: optional Location loc;                // 结构体可以包含其他结构体
            16: optional string language = "english" // 域可以有缺省值
        }

        struct Location {                            // 一个thrift中可定义多个结构体, 并存在引用关系
            1: required double latitude;
            2: required double longitude;
        }

      规范的 struct 定义中的每个域均会使用 required 或者 optional 关键字进行标识。
      如果 required 标识的域没有赋值, thrift 将给予提示。
      如果 optional 标识的域没有赋值, 该域将不会被序列化传输。
      如果某个 optional 标识域有缺省值而用户没有重新赋值, 则该域的值一直为缺省值。

      与 service 不同, 结构体不支持继承, 即,一个结构体不能继承另一个结构体。

   8. 定义服务
      在流行的 序列化/反序列化 框架(如 protocal buffer)中, thrift 是少有的提供多语言间RPC服务的框架。
      Thrift 编译器会根据选择的目标语言为 server 产生服务接口代码, 为 client 产生桩代码。

        //“Twitter”与“{”之间需要有空格！！！
        service Twitter {
            // 方法定义方式类似于C语言中的方式, 它有一个返回值, 一系列参数和可选的异常
            // 列表. 注意, 参数列表和异常列表定义方式与结构体中域定义方式一致.
            void ping(),                                    // 函数定义可以使用逗号或者分号标识结束
            bool postTweet(1:Tweet tweet);                  // 参数可以是基本类型或者结构体, 参数是只读的(const), 不可以作为返回值！！！
            TweetSearchResult searchTweets(1:string query); // 返回值可以是基本类型或者结构体
            // “oneway”标识符表示 client 发出请求后不必等待回复(非阻塞)直接进行下面的操作, 返回值必须是void
            oneway void zip()                               // 返回值可以是void
        }

产生代码
   1. Transport
      Transport层提供了一个简单的网络读写抽象层。
      这使得thrift底层的transport从系统其它部分(如：序列化/反序列化)解耦。
      以下是一些Transport接口提供的方法：

        open
        close
        read
        write
        flush

      除了以上几个接口, Thrift使用ServerTransport接口接受或者创建原始 transport 对象。
      正如名字暗示的那样, ServerTransport用在server端, 为到来的连接创建 Transport 对象。

        open
        listen
        accept
        close


   2. Protocal
      Protocal抽象层定义了一种将内存中数据结构映射成可传输格式的机制。
      换句话说, Protocal 定义了 datatype 怎样使用底层的 Transport 对自己进行编解码。
      因此, protocal 的实现要给出编码机制并负责对数据进行序列化。
      Protocal 接口的定义如下：

        writeMessageBegin(name, type, seq)
        writeMessageEnd()
        writeStructBegin(name)
        writeStructEnd()
        writeFieldBegin(name, type, id)
        writeFieldEnd()
        writeFieldStop()
        writeMapBegin(ktype, vtype, size)
        writeMapEnd()
        writeListBegin(etype, size)
        writeListEnd()
        writeSetBegin(etype, size)
        writeSetEnd()
        writeBool(bool)
        writeByte(byte)
        writeI16(i16)
        writeI32(i32)
        writeI64(i64)
        writeDouble(double)
        writeString(string)
        name, type, seq = readMessageBegin()
        readMessageEnd()
        name = readStructBegin()
        readStructEnd()
        name, type, id = readFieldBegin()
        readFieldEnd()
        k, v, size = readMapBegin()
        readMapEnd()
        etype, size = readListBegin()
        readListEnd()
        etype, size = readSetBegin()
        readSetEnd()
        bool = readBool()
        byte = readByte()
        i16 = readI16()
        i32 = readI32()
        i64 = readI64()
        double = readDouble()
        string = readString()

    下面是一些对大部分thrift支持的语言均可用的 protocal:
        (1) binary: 简单的二进制编码
        (2) Compact
        (3) Json

   3. Processor
      Processor 封装了从输入数据流中读数据和向数据数据流中写数据的操作。
      读写数据流用 Protocal 对象表示。
      Processor的结构体非常简单:

        interface TProcessor {
            bool process(TProtocol in, TProtocol out) throws TException
        }

      与服务相关的 processor 实现由编译器产生。
      Processor主要工作流程如下：从连接中读取数据(使用输入protocol), 将处理授权给handler(由用户实现), 最后将结果写到连接上(使用输出protocol)。

   4. Server
      Server将以上所有特性集成在一起：
        (1) 创建一个transport对象
        (2) 为transport对象创建输入输出protocol
        (3) 基于输入输出protocol创建processor
        (4) 等待连接请求并将之交给processor处理


实践经验
    thrift 文件内容可能会随着时间变化的。
    如果已经存在的消息类型不再符合设计要求，比如，新的设计要在message格式中添加一个额外字段，但你仍想使用以前的 thrift 文件产生的处理代码。
    如果想要达到这个目的，只需：
    (1) 不要修改已存在域的整数编号
    (2) 新添加的域必须是optional的,以便格式兼容。
        对于一些语言，如果要为optional的字段赋值，需要特殊处理，比如对于C++语言，要为

        struct Example{
            1 : i32 id,
            2 : string name,
            3 : optional age,
        }

    中的 optional 字段 age 赋值，需要将它的 __isset 值设为 true, 这样才能序列化并传输或者存储(不然optional字段被认为不存在，不会被传输或者存储),如：
        Example example;
        ......
        example.age=10,
        example.__isset.age = true;  //__isset是每个 thrift 对象的自带的 public 成员，来指定 optional 字段是否启用并赋值。
        ......


    (3) 非 required 域可以删除，前提是它的整数编号不会被其他域使用。对于删除的字段，名字前面可添加“OBSOLETE_”以防止其他字段使用它的整数编号。
    (4) thrift 文件应该是 unix 格式的(windows下的换行符与unix不同，可能会导致你的程序编译不过)，如果是在window下编写的，可使用dos2unix转化为unix格式。
    (5) 貌似当前的thrift版本(0.6.1)不支持常量表达式的定义(如 const i32 DAY = 24 * 60 * 60)，这可能是考虑到不同语言，运算符不尽相同。




使用实例
    此实例建立在已安装 Thrift 的基础上,并且 thrift 在环境变量里面
    1. 建立运行所需的目录,如:
        mkdir ~/test1  # 创建目录
        cd ~/test1     # 进入此目录

    2. 创建并编辑 Thrift 文件(在刚才创建的目录下)
        如 hello.thrift：
        namespace csharp hi.test1
        service Hello
        {
            i32 helloworld()
        }

    3. python 生成代码
        thrift -gen py hello.thrift  # 生成 python 代码, 其它语言只有 -gen 的参数不同

        结果代码存放在此目录的 gen-py 目录下
        把 ~/test1/gen-py/hello 里面的代码复制到需要的目录,如 ~/test1 目录下

        自动生成的文件包括:
        __init__.py
        constants.py
        Hello.py
        Hello-remote
        ttypes.py

    4. python 服务端
        # 需要的功能，自行补上，如建立 helloimp.py 文件来实现接口的功能,内容如下：
        from Hello import Iface  # 导入接口
        class HelloHandler(Iface):
            def helloworld(self,):
                return 345

        # 修改 __init__.py 文件,把"helloimp"加入到 __all__ 的列表里面,如：
        __all__ = ['ttypes', 'constants', 'Hello', 'helloimp']

        # 运行服务端
        cd  ./ppf/service  # 进入目录
        python runthrift.py   # 启动服务程序, 服务代码(暂时未加入)....




