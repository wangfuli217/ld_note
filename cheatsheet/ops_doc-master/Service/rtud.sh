网络存在问题：连不上OTDR模块；
0. dmesg > dmesg.txt; cp /var/log/message ./message; cp /var/log/message.0 ./message.0
1. kill monit; /sbin/rtud stop; 
2. ping 192.168.0.252
3. ifconfig eth1 down; ifconfig eth1 up; ping 192.168.0.252
4. reboot; ping 192.168.0.252
5. rtu整体停电、重启 ping 192.168.0.252

---- > 定时重启
https://retropie.org.uk/docs/Debian/

##### 周期性测试 #####
syslogd -O /var/log/messages -s 20000 -b 98
nohup tcpdump -i eth0 dst port 5000 and not dst host 192.168.1.254 -w /etc/rtud/curvedata.pcap &
iptables -I OUTPUT -p tcp --dport 5000 -o eth0 -j LOG --log-prefix "curvedata" --log-tcp-options

##### monitrc #####
如何能定期启动rtud程序
如何确定rtud有问题只能重启
如何处理rtud的feeddog问题--- otdr_main.c 模块中

1. 怎样才能自动地查出这个错误？ 
2. 怎样才能避免这个错误？
编辑程序只是在自动地检查代码中的错误。
语法错误只是程序员可以使用的自动查错方法查出的一种最基本的错误类型。
错误
一类是开发某一功能时产生的错误，
一类是在程序员认为该功能已经开发完成之后仍然遗留在代码中的错误。

协议异常部分：
1. 有响应数据包；当相应数据包格式不正确；
2. 有响应数据包；响应数据报文标识请求异常；
3. 没有响应数据报文；超时； ---- 保活心跳

实现满足程序功能要求 只能说明     程序对外提供功能正常
程序对外提供功能正常 不能说明     程序按照设计要求执行

rtud(编码|设计...){
1. ols和osl这两个相似但意义一样的单词存在代码中，极大影响了代码可读性和编码性
2. tty_proto_type_get(tty_proto.c)的真实含义是tty_proto_cmd_get，当初不知道怎么想的，低级错误
3. ldproxy.c - otdr_task.c - rtu_tty.c - otdr_main.c 执行流程；
ldproxy.c    支持并发
otdr_task.c  根据优先级调用测试任务
rtu_tty.c    独占串口，控制光开关
otdr_main.c  独占网口，控制otdr模块
以上流程考虑：数据报文格式不正确；数据包请求异常响应和接收，超时未收到，重试发送和断链重连机制

4. 系统级别控制和进程级别控制：
4.1 那些控制是系统级别的，比如重启otdr板卡(otdr板卡如果处于测试状态，让它停止测试)；设置序列号
4.2 哪些控制是进程级别的，让进程可以处于守护状态的外部因素的就绪；otdr板卡停止测试。

掉电数据保护 ---- rtu设备掉电之后如何处理；当前没有提供特定引脚检测外部电是电池还是电源
}

cc -Wall -W -O2   -DVERSION='"2.78"'           -c arp.c
COPTS = # 设置各种 -DNO_AUTH -DNO_IPSET
MAKE_FLAGS := \                                                                                                                 
    $(TARGET_CONFIGURE_OPTS) \
    CFLAGS="$(TARGET_CFLAGS)" \
    LDFLAGS="$(TARGET_LDFLAGS)" \
    COPTS="$(COPTS)" \
    PREFIX="/usr"

日志是程序设计的灵魂之一         日志+断言+NDEBUG
协议是程序设计的灵魂之一         固定格式+可变格式
模块化是程序设计的灵魂之一       固定格式数据+可变格式数据+状态+API  -> 初始化+析构化
测试性是程序设计的灵魂之一       google mock
迭代开发是程序健壮性的必要条件   在路上


NDEBUG: Makefile传递给gcc,gcc传递给源文件
make -p                   # 输出信息将会告诉一些预定以变量的值
make OPTIMIZATION="-O0"   # 向makefile传递变量; 参变量
make USE_TCMALLOC=yes     # 向makefile传递变量; 开关变量

gcc -DUSE_VAR='NDEBUG'

print(输出内容体现系统之间的关系变化){
1. 代码内部打印：debug级别的打印，宏定义方式；不讲求可读性；打印内部细节。  -- 发布版本关闭
2. 代码外部打印；notice，warn，error级别的打印，属于日志文件，讲求可读性；打印关键判断细节 -- 发布版本不关闭
3. 协议记录打印：根据协议格式设计输出格式    -- 影响进程状态     SET DEL 
4. 协议不记录打印：根据协议格式设计输出格式  -- 不影响进程状态   GET LIST
5. 硬件|软件触发记录打印：当硬件状态发生变化 或者 进程状态死掉或启动；
6. 系统调用级别打印：系统资源的申请释放:socket fd fp memory; send|recv read|write; lock|unlock
7. 业务逻辑判错打印: 超过最大最小值判断，状态变更判断。


1. 日志应当可读性强且易于解析:
  如果有可能的话，你记录的日志最好能让人和计算机都能看明白,不要将数字格式化，用一些能让正则容易匹配的格式等等
2. 正确的记录异常
  异常记录是日志记录的最重要的职责之一，
3. 观察外部系统
  如果你和一个外部系统通信的话，记得记录下你的系统传出和读入的数据。
  有时候和外部系统交换的数据量决定了你不可能什么都记下来。另一方面，在测试阶段和发布初期，最好把所有东西都记到日志里，做好牺牲性能的准备。
4. 记录方法的参数和返回值
  这种日志最合适的级别就是DEBUG和TRACE了。
5. 调整你的格式
  当前时间(无日期，毫秒级精度)，日志级别，线程名，简单的日志名称(不用全称)还有消息.
  文件名，类名，行号，都不用列进来，尽管它们看起来很有用。
6. 描述要清晰
  每个日志记录都会包含数据和描述。日志文件应当是可读性强的，清晰的，自描述的。不要用一些魔数，记录值，数字，ID还有它们的上下文。
7. 不要忘了日志级别
  ERROR:发生了严重的错误，必须马上处理。这种级别的错误是任何系统都无法容忍的。比如：空指针异常，数据库不可用，关键路径的用例无法继续执行。
  WARN: 还会继续执行后面的流程，但应该引起重视。其实在这里我希望有两种级别：一个是存在解决方案的明显的问题（比如，"当前数据不可用，使用缓存数据"）
        另一个是潜在的问题和建议（比如"程序运行在开发模式下"或者"管理控制台的密码不够安全"）。应用程序可以容忍这些信息，不过它们应该被检查及修复。
  DEBUG: 开发人员关注的事。
  TRACE: 更为详尽的信息，只是开发阶段使用。在产品上线之后的一小段时间内你可能还需要关注下这些信息，不过这些日志记录只是临时性的，最终应该关掉。

8. why to log
  打印日志，那就要从我们的目的出发，我们是要检查问题，还是要记录代码执行顺序，还是要记录事件发生时间节点，还是要提供报警机制信息等。
  对于调试阶段，大都是为了处理逻辑时序和问题发生节点；
  对于线上项目，为了准确定位并解决处理问题；
9. when to log
  1.调试开发日志:目的是开发期调试程序使用，这种日志量比较大，且没有什么实质性的意义，只应该出现在开发期，而不应该在项目上线之后输出。
  2.用户行为日志:记录用户的操作行为.一般会有一定的格式要求，开发者应该按照这个格式来记录，便于其他团队的使用。
  3.程序运行日志:记录程序的运行状况，特别是非预期的行为、异常情况，这种日志，主要是给开发、维护人员使用。
  4.记录系统或者机器的状态:网络请求、系统CPU、内存、IO使用情况等等
10. what to log
  一条信息完整的日志，应该包含 when、where、level、what、who、context
  日志内容是对某个事件的描述。
  when，就是我们打印日志的时间(时间戳)。
  where，就是指日志是在哪里的被记录的，本质上来说，是事件的产生地点。
  level, 每一条日志都应该有log level，log level代表了日志的重要性、紧急程度。例如：debug，info，warn，error，fatal；
  what是日志的主体内容，应该简明扼要的描述发生的什么事情。要求可以通过日志本身，而不是重新阅读产生日志的代码，来大致搞清楚发生了什么事情。
  who代表了事件产生者的唯一标识(identity)，用于区分同样的事件。
  日志记录的事件发生的上下文环境直观重要，能告知事件是在什么样的情况发生的。当然，上面提到的when、where、who都属于上下文，这些都是固定的，通用的。
  context专指高度依赖于具体的日志内容的信息，这些信息，是用于定位问题的具体原因  
}

rtu(绘图){
https://blog.csdn.net/f_j_l/article/details/42428259
https://www.geeksforgeeks.org/basic-graphic-programming-in-c/
}
rtud(反思){
1. 激活码其实不需要缓存在内存中的，因为从业务角度看，被调用的次数足够少；
2. hostconfigrtu和monalarmlogger两个操作记录文件过于简单，最好能提供循环记录日志功能。
3. otdrd,hostd,slotd这三个工具有很多重复性的代码，如何消除彼此之间从重复--重构
4. otdr_main.c rtu_tty.c和otdr_task.c存在共享全局变量的情况，模块化不是很好。
5. 当前rtu和主站之间的通信协议为二进制格式，从扩展性上，文本格式的协议是否更好；
6. rtu本身有电池，当rtu设备双电源同时断电的时候，将内存中重要的信息保存起来，能连上服务器上报异常状态。
7. rtu中很多模块不能清晰的描述，关键还是没有将真实需求和数据结构很好的对应起来。
   SPOT原则就是提倡寻找一种数据结构，使得模型中的状态个真实世界系统的状态能够一一对应。
8. Makefile 在构建过程中设定变量对ARM X86_64 I386 或I686进行选择；
                                对是否进行debug功能进行选择
                                将配置文件作为Makefile的一部分进行设计.
                                支持更加严格的错误检查机制：
                                -Os -Wall -Werror --std=gnu99 -g3 -Wmissing-declarations
                                
9. bao(HTTP)支持升级功能：这样软件升级或者配置升级就简单的多了。

# https://blog.huzhifeng.com/2011/09/09/BOA%E6%95%99%E7%A8%8B/
10. .PHONY # Makefile
11. redis 中的V=1
12. 在程序中能够将_DATE_和_TIME_以及SVN的提交版本号编译到可执行代码中，会更美好。
2017-09-20 23:10:11 +0800 (Wed, 20 Sep 2017) @svnversion:r14528 
_DATE_ + _TIME_ + $user

svn co –r 30368 svn://svn.openwrt.org/openwrt/trunk/
svn co svn://svn.openwrt.org/openwrt/trunk/

13. busybox 下的testing.sh是一个很好的测试用例框架, shunit好像也有busybox版本
14. rtud应该将一些很少出现，但容易造成严重问题的日志打印到flash或磁盘上
15. 通过"/proc/sys/kernel/core_pattern" 可以很好的分析rtud以外崩溃的原因； 其实monitrc的配置文件也可以在崩溃时保留 messages

?. 将操作系统喂狗的功能合入rtu，异或通过watchdog程序检测rtu程序存活性
?. 每次代码便写完之后，使用indent或clang-format，dos2unix和clint静态工具测试一遍。 # 自动化些；独立调用
?. valgrind：尽量做些内存泄露之类检查。                                            # 自动化些；
?. spellcheck 数据字典
?. soundex    简化变量命名

16. 如果将上报曲线的缓存设计成：基于/var/rtud/内存的缓存文件会更好。 -- 增加了代码逻辑，方便后期调试
          可以使用mmap函数实现：或者直接创建文件实现；
          难点：1. 缓存文件设计成dat,curvedata和sor三个，这三个文件和rtud的上报模块如何关联
                2. 一个光开关可以缓存多条曲线，怎样对应起来多条曲线， uptime() 函数
                3. 进程意外崩溃后，如何重新加载这些曲线内容

./cppcheck test.c

14. 表格驱动编程+回调函数+事件驱动
15. bad argument #1 to 'mysin' (number expected, got string)
  注意看看luaL_checknumber是如何自动使用：参数number（1），函数名（"mysin"），期望的参数类型（"number"），实际的参数类型（"string"）来拼接最终的错误信息的。
或者
  函数abc访问释放的内存，文件xyz.c,行号nnn.
16. 通过bsearch和qsort可以快速查找日志打印内容。
17. 尽快实现自动化部署和google test
    a. 在svn环境下自动化生成升级包
    b. 在mcu单板中自动化解压，安装升级包；1. 确认是否保留原有数据； 2. 确定序列号是否自动生成 3. 确定是否进行自动化测试
18. 将monit输出数据包保存到可以记录的SD卡中，最好monit能记录rtud崩溃时的PC指针和rtud的版本号
19. otdr_main.c 中协议部分有太多的硬编码，没达到数据驱动 + 指针回调
    
    通过数据表定义处理过程；
    通过记录中字段标识控制接收报文处理方式；
    通过名称统一打印输出；
    
    如何保存接收数据报文数据 ... 
方法1：按照数组位置定义处理过程
    typedef struct otdr_main_test {
      uint32_t wls_val;            // otdr配置参数
      uint32_t ala_val;
      uint32_t stp_distance_val;
      uint32_t stp_pluse_val;
      double ior_val;
      
      double sendtime;
      double timeout;
      uint32_t reconnects;
      
      struct seqpacket *packet;   // otdr报文处理对象
    }otdr_main_test;
    
    typedef struct otdr_packet {   // 接收和发送缓冲区
    uint32_t send_len;
    char *send_buff;
    uint32_t recv_len;
    char *recv_buff;
    }otdr_packet;
    
    typedef struct packet_statistics {
    uint32_t send_bytes;
    uint32_t send_packets;
    uint32_t recv_bytes;
    uint32_t recv_packets;
    }packet_statistics；
    
    
    typedef struct seqpacket{
      int packet_func();    // 当前已发送packet构建函数; 
      int handle(buff,len); // 处理recv接收数据函数;    -> int 返回值说明recv的有效性
      char *mode;           // 发送策略: 1. status循环发送 2. env 循环发送
      char *seq;            // "conf" "control" "dat" "result"
      uint32_t status;      // 返回状态：1. 接收失败重发本次报文 2. 接收成功重发本次报文 3. 接收成功发送下个报文
                            // 4. otdr重新开始测试 5. 重新连接otdr板卡 6. 重新启动otdr板卡 7. 修改otdr板卡模式
      otdr_packet  *pkts;   // 发送数据包和接收数据包信息; 
    }seqpacket;
    
    struct seqpacket g_namedpacket = {
    {wls_send, wls_recv, "s", "conf", 0, NULL};
    {avg_send, avg_recv, "s", "conf", 0, NULL};
    
    ...
    };
    
    struct seqpacket g_initpacket = {
    {wls_send, wls_recv, "s", "conf", 0, NULL};
    {avg_send, avg_recv, "s", "conf", 0, NULL};
    
    ...
    };
    ----------------------------------------------------------------------------
方法2：按照数据报文关键字定义处理过程
    typedef struct otdr_main_test {
      uint32_t wls_val;            // otdr配置参数
      uint32_t ala_val;
      uint32_t stp_distance_val;
      uint32_t stp_pluse_val;
      double ior_val;
      
      double sendtime;
      double timeout;
      int packet_func(struct otdr_main_test *main, char *cmd, char *buff); // 当前已发送packet构建函数;
      int handle(char *cmd, char *buff, uint32_t len); // 处理recv接收数据函数;    -> int 返回值说明recv的有效性
      struct seqpacket *packet;   // otdr报文处理对象
    }otdr_main_test;
    
    typedef struct seqpacket{
    char *cmd;
    char *nextcmd;
    char *mode;           // 发送策略: 1. status循环发送 2. env 循环发送
    char *seq;            // "conf" "control" "dat" "result"
    uint32_t status;      // 返回状态：1. 接收失败重发本次报文 2. 接收成功重发本次报文 3. 接收成功发送下个报文
                          // 4. otdr重新开始测试 5. 重新连接otdr板卡 6. 重新启动otdr板卡 7. 修改otdr板卡模式
    struct otdr_packet *packet; // 
    }
    
    struct seqpacket g_namedpacket = {  // 完全过程
    {"wls",    "avg",     "s", "conf",    0, NULL};
    {"avg",    "stp",     "s", "conf",    0, NULL};
    {"stp",    "ala",     "s", "conf",    0, NULL};
    {"ala",    "ior",     "s", "conf",    0, NULL};
    {"ior",    "ths",     "s", "conf",    0, NULL};
    {"ths",    "thr2",    "s", "conf",    0, NULL};
    {"thr2",   "thf",     "s", "conf",    0, NULL};
    {"thf",    "ld",      "s", "conf",    0, NULL};
    {"ld",     "status",  "s", "control", 0, NULL};
    {"status", "dat",     "r", "status",  0, NULL};
    {"dat",    "ave",     "s", "result",  0, NULL};
    {"ave",    "smpinf",  "s", "result",  0, NULL};
    {"smpinf", "mkdr",    "s", "result",  0, NULL};
    {"mkdr",   "aut",     "s", "result",  0, NULL};
    {"aut",    "evn2",    "s", "result",  0, NULL};
    {"evn2",   "dat",     "r", "result",  0, NULL};
    {"dat",    "getfile", "s", "result",  0, NULL};
    {"getfile", NULL,     "s", "result",  0, NULL};
    };
    
    struct seqpacket g_namedpacket = {  // 优化过程
    {"wls",    "avg",     "s", "conf",    0, NULL};
    {"avg",    "stp",     "s", "conf",    0, NULL};
    {"stp",    "ala",     "s", "conf",    0, NULL};
    {"ala",    "ior",     "s", "conf",    0, NULL};
    {"ior",    "ld",      "s", "conf",    0, NULL};
    {"ld",     "status",  "s", "control", 0, NULL};
    {"status", "dat",     "r", "status",  0, NULL};
    {"dat",    "ave",     "s", "result",  0, NULL};
    {"ave",    "smpinf",  "s", "result",  0, NULL};
    {"smpinf", "mkdr",    "s", "result",  0, NULL};
    {"mkdr",   "aut",     "s", "result",  0, NULL};
    {"aut",    "evn2",    "s", "result",  0, NULL};
    {"evn2",   "dat",     "r", "result",  0, NULL};
    {"dat",    "getfile", "s", "result",  0, NULL};
    {"getfile", NULL,     "s", "result",  0, NULL};
    };
    
}

[ -e /proc/sys/kernel/core_pattern ] && {
        procd_set_param limits core="unlimited"
        echo '/tmp/%e.%p.%s.%t.core' > /proc/sys/kernel/core_pattern
    }


hostd(){
良好命名
容易理解
名字要短
容易记忆
必备选项:所有的命令行工具都应该提供=-v/–version=和=-h/–help=选项。
保持安静
    不要输出无关的信息，比如版本号、作者名——除非用户要求
    对于很明确的结果，不需要再提醒用户。只应提示例外(exception)情况
    不需要告诉用户输出的是什么东西——用户会知道的
    如有必要，可以提供=-v/–verbose=和=-q/–quiet=选项，供用户选择
    明确要求
    
支持管道
    
}
    
PARAM="-nbad -bap -bbo -nbc -br -brs -c33 -cd33 -ncdb -ce -ci4 -cli0 -cp33 -cs -d0 -di1 -nfc1 -nfca -hnl -i4 -ip0 -l75 -lp -npcs -nprs -npsl -saf -sai -saw -nsc -nsob -nss"
find -name "*.c" | xargs indent $PARAM 
find -name "*.c" | xargs clang-format-3.3 -i
find -name "*.h" | xargs indent $PARAM 
find -name "*.h" | xargs clang-format-3.3 -i

rtud(github){
https://github.com/sid5432/pyOTDR     # python
https://github.com/sid5432/pubOTDR    # perl
https://github.com/sid5432/jsOTDR     # js
https://github.com/agarb7/Profes.SOR  # beta
https://github.com/FileDecode/OTDR    # java

https://github.com/gazlan?tab=repositories  # new
}


Artistic Style(AStyle)
AStyle是一款开源、高效、精简的代码格式化工具，适用于C、C++、C#、Java等。官方地址在：http://astyle.sourceforge.net/。
AStyle支持Linux、Mac或者Windows，Windows下有预编译的exe文件，其他平台需要自己编译。
输入AStyle -h可以后去AStyle的详细使用介绍：
                     Artistic Style 3.0
                     Maintained by: Jim Pattee
                     Original Author: Tal Davidson
Usage:
------
            astyle [OPTIONS] File1 File2 File3 [...]
            astyle [OPTIONS] < Original > Beautified
将AStyle集成到SourceInsight，可以极大提高工作效率。
SourceInsight->Options->Custom Commands，设置如下：
Run部分如下：AStyle.exe  --style=linux  --mode=c -p -U  --suffix=none  %f
    指定格式化风格为linux.
    --mode=c 处理C/C++源文件
    -p 在操作符两边插入空格，如=、+、-等。
    -d 在括号外面插入空格。
    -U移除括号两边不必要的空格。
    none不备份文件，%f表示当前文件

PC-Lint
安装PC-Lint之后。
SourceInsight->Options->Custom Commands，设置如下：
C:/LINT/Lint-nt.exe -ic:/lint/std.lnt %f
如果在执行PC-Lint过程中出现头文件找不到情况，打开pc-lint安装目录下std.lnt文件，在文件尾以”-I ”方式加上所需的头文件所在的路径，如：-I C:/ISIPPC/diab/4.2b/include -IC:/Tornado/host/diab/include。

添加菜单或者快捷键
在设置好AStyle和PC-Lint两个命令之后，可以将其加入菜单中。或者进入Keys…设置快捷键。
[Menu Assignments]

# 使Code::Blocks适合ARM开发
http://blog.sina.com.cn/s/blog_4c451e0e0100ge3z.html

rtud(静思){
1. otdr.c 独立模块测试；2. otdr_task与otdr_main.c的联合测试。
3. rtud info功能，使得程序更加透明些；而可配置的打印使得程序后期更容易调试。
4. 错误的标准化和异常告警的标准化，使得程序对不接口更加文本化些。
}
rtu(协议：otdr协议){

}

rtu(协议：redis协议){

}

rtu(协议：libubox协议){

}

rtu(协议 ? json){

}

rtud(协议 ? 鼎新){

}

rtud(协议 ? 电力国标){

}

rtu(日志: redis){

}

rtu(日志: moosefs){

}

rtu(日志：busybox-logd){

}

rtu(logger:注册回调方式){

}

rtu(交叉编译){
PATH=$PATH:/usr/local/arm/arm-2009q3/bin/
./configure --host=arm CC=arm-none-linux-gnueabi-gcc prefix=/usr/local/arm/arm-2009q3/
libpcap-1.8.1.tar.gz
make && sudo make install -> =/usr/local/arm/arm-2009q3/bin/lib/[libpcap.a  libpcap.so  libpcap.so.1  libpcap.so.1.8.1]
ftp [libpcap.a  libpcap.so  libpcap.so.1  libpcap.so.1.8.1] -> /usr/lib (也可以建立符号链接)
tcpdump-4.9.2.tar.gz
make -> tcpdump
ftp [tcpdump] -> /sbin/tcpdump && chmod +x /sbin/tcpdump

tcpdump -i eth0 port 5000 -w curvedata.pcap
nohup tcpdump -i eth0 port 5000 -w curvedata.pcap &
}

http://www.binaryanalysis.org/en/home # 二进制文件查看

bats(反思){
1. google 编码格式 指导
2. 通过shellcheck进行检查
3. bats 或者 shunit2
}
shunit2(支持sh){
在mcu上只需少些修改即可满足自动化测试:tput

Cygwin (under Microsoft Windows XP)
}

win32(界面和后台网络线程){ -- 如何达到C++水平。
使用libevent的evutil_socketpair(int family, int type, int protocol, int fd[2])函数，
实现linux系统的socketpairs功能，这些就能实现MFC界面部分调用PostPacket()发送报文到
指定client。调用SendPacket()发送报文到指定client并等待指定client响应(指定超时时间和响应报文内容)

------------------> PostPacket 发送后不关心报文成功与否 (Pipe)
(只通知有数据，不发送真正数据，数据在指定消息队列中缓存)


------------------> PostPacket 发送报文
<-----------------  select超时等待回馈报文


而网络线程调用PostMessage发送消息给界面部分；通过SendMessage发送消息给界面。 
--- 原则上不使用SendMessage
}