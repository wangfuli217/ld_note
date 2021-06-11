cat - <<'EOF'
重构开发和迭代开发：咨询的奥秘说：对一个模块进行第三次重构开发或者迭代开发的时候，才会使得代码更加完美。
EOF

IO_l_link(){ cat - <<'EOF'
https://github.com/taoste/Hello-World
https://github.com/taoste/open_source_team

http://www.dooccn.com/shell/ # 在线编译器 C bash lua等

http://emn178.github.io/online-tools/ # CRC等等
https://github.com/rby90/Project-Based-Tutorials-in-C # tutorials
https://github.com/tuvtran/project-based-learning     # tutorials
https://github.com/byuksel/Automake-Autoconf-Template-Project # 
https://github.com/byuksel/generator-c-c-plus-plus-project    # 
https://github.com/willis7/Programming-Tutorials              # 
http://perugini.cps.udayton.edu/teaching/courses/Fall2015/cps444/index.html # Book
http://perugini.cps.udayton.edu/teaching/courses/Fall2015/cps356/

https://www.cnblogs.com/stephen-liu74/archive/2012/03/09/2328757.html
http://www.cnblogs.com/f-ck-need-u/p/7048359.html

https://github.com/kippy620/Note/blob/59d69aae1c09a644a761b72bf974d970e7271a34/CodeComplete2/11.1_ConsiderationsInChoosingGoodName.md

https://github.com/isocpp/CppCoreGuidelines

https://en.wikipedia.org/wiki/Category:Free_software_programmed_in_C
https://en.wikipedia.org/wiki/Category:Cross-platform_free_software

https://github.com/zhangjincai/c_advance # 01_tinyhttpd 02_cJSON 03_webbench 04_http_load 05_cmockery 06_libev 07_libuv
https://unbug.github.io/codelf # 变量命名
http://qbnz.com/highlighter/   # https://www.cprogramming.com/

https://github.com/aleksandar-todorovic/awesome-c 

https://github.com/codekissyoung/markdown # 一般般
EOF
}

IO_p_assert(){ cat - <<'EOF'
libevent:libev和poll epoll存在的潜在因素是：CPU到内存总线的计算能力远远大于网线，串口和磁盘传输能力

强制逻辑处理:   无条件判断直接崩溃，标明逻辑走到此处即错误。常在switch最后default，或者if(test) abort | else abort。
                libuv函数逻辑不应退出而退出abort; # 无 __FILE__,__LINE__  多实现if(test) abort          少见default abort
                redis提供了redisPanic             # 有__FILE__,__LINE__   多实现if(test) do else abort  多见default abort
软强制逻辑处理: 打印函数调用栈，可用来 1. 调试代码 2. 追踪进程执行异常 3. 追踪进程崩溃异常
                monit中LogEmergency, LogAlert, LogCritical调用过backtrace之后继续执行;    # 无 __FILE__,__LINE__, 
                     LogError输出要输出的信息和backtrace,                                 # 系统调用未达到 目的
                     LogCritical用于ASSERT，在输出错误信息和backtrace之后，调用abort      # 函数输入未达到 目的
                redis中watchdog功能，监控redis服务器eventloop中那些调用会导致长时间阻塞。 # 无 __FILE__,__LINE__, 
                moosefs也有backtrace功能，但是只用于调试，调试结束就被注掉。仅见于 hddspacemgr.c 中。 # 无 __FILE__,__LINE__, 看做普通打印
                redis中进程接收到SIGSEGV，SIGBUS，SIGFPE，SIGILL信号时也会调用backtrace。 # 无 __FILE__,__LINE__, 有信号值和pc值
强制判断处理:   条件不满足就退出。1，入口条件不满足就退出， 2. 函数返回值不满足退出， 3. 函数返回值错误后，errno不满足退出
                1. monit中ASSERT，入口参数判断：模块接口或者内部关键函数入口参数判断。数据结构关联性，如父节点
                1. redis中assert，上下文状态判断：当前状态下能否继续执行后续代码
                1. moosefs中massert提供额外信息,一个是sassert不提供额外信息。
                2. moosefs中zassert, passert特定系统调用 pthread和free, mmap，eassert普通系统函数判断。
                3. libuv中abort， 系统调用不满足调用
需要关注的点：  1. 信号异常需要打印信号，         提供? signal  提供? pc
                2. 阻塞导致异常打印阻塞时长。     提供? timeout
                3. 系统调用或者条件不满足的异常， 提供? __FILE__，? 提供errno值
                4. 调试时，backtrace打印          提供? backtrace
                5. 如果将文件作为输出目标，需要关注 fflush 和 setvbuf(LOG, NULL, _IONBF, 0);

系统调用: 函数入参，函数出参，函数返回值，errno值 + 语义
功能上关注:先考虑函数入参，  再函数出参
逻辑上关注:先考虑函数返回值，再errno值
EOF
}


# 数据是设计的依据，数据结构说明了数据自身的依赖关系和递归关系。设计注重形式(可读性), 是语义性的数据和数据间关系被管理。
# 数据的申请、建立和查询、释放。数据关系的构建、使用和释放。所以，设计是描述数据和数据关系的逻辑。DRY(避免无效重复
# 数据可以有不同的形式化，协议格式，内存格式、存储格式等等

IO_l_doc(){ cat - <<'EOF'
socket: 五元组bind connect sendto recvfrom getpeername getsockname 资源 socket close 阻塞点 accept connect recv send listen
与moosefs中strerr.c  \crosstool\cheatsheet\ops_doc-master\Service\cfaq\strerr.c
回调函数设计：crosstool\cheatsheet\ops_doc-master\cii\enclosure_map_filter.txt
私有数据设计：crosstool\cheatsheet\ops_doc-master\Service\privdata.txt
数据结构设计: crosstool\cheatsheet\ops_doc-mstaer\Service\structdata.txt
TCP|UDP连接模式：crosstool\cheatsheet\ops_doc-mstaer\Service\connectmode.txt
thread 设计模式：crosstool\cheatsheet\ops_doc-mstaer\Service\threadmode.txt
模块   设计模式：crosstool\cheatsheet\ops_doc-mstaer\Service\module.txt
模块   接口模式：crosstool\cheatsheet\ops_doc-mstaer\Service\interface.txt
tabledriven 模式：crosstool\cheatsheet\ops_doc-mstaer\Service\tabledriven.txt
eventdriven 模式：crosstool\cheatsheet\ops_doc-mstaer\Service\eventdriven.txt
datastruct  模式：crosstool\cheatsheet\ops_doc-mstaer\Service\datastruct.txt
log_assert_debug  模式：crosstool\cheatsheet\ops_doc-mstaer\Service\log_assert_debug.txt
openssl上下层 模式：crosstool\cheatsheet\ops_doc-mstaer\Service\openssl\ssl\git\readme.txt & openssl节
协议 模式：crosstool\cheatsheet\ops_doc-mstaer\Service\protocol.sh
配置文件 环境变量 和 命令行 模式：crosstool\cheatsheet\ops_doc-mstaer\Service\UNIX编程艺术.sh
                                  crosstool\cheatsheet\ops_doc-mstaer\Service\cmdline_configure_evn.txt
                                  crosstool\cheatsheet\ops_doc-mstaer\Service\buffer.txt
Command 和 Process 命令行与进程状态: crosstool\cheatsheet\ops_doc-mstaer\Service\Command_Process.txt
EOF
}

process_group_termnial(){
    进程组是为了信号传递这样的目的而建立的进程集合。比如说，在终端运行一个进程，这个进程fork了一个子进程。
当我们在终端输入Ctrl+C。那么父进程和子进程都会收到这个中断信号，信号在这个进程组里面传递了。又比如说函数
kill(pid_ t pid, int signo)。当pid为负数时，表示向一个进程组发送信号。
    会话是为了作业控制而建立的一个进程组集合(注意，进程组是进程的集合)。一个控制终端只与一个会话有关，
一个会话中可能会有多个进程组，但任一时刻，只有一个进程组拥有控制终端(即可以从控制终端获取输入和输出到控制终端)，
拥有控制终端的进程称为前台进程组，其余的进程组称为后台进程。
    作业控制的主要目的是控制哪个进程组拥有控制终端。
注意，有些系统并不支持作业控制。
}

dict/dict_monit.txt
https://github.com/blueJpg/my_study

https://github.com/donnemartin/system-design-primer

接口设计的难点是：将阻塞型的同步调用，转变成非阻塞型的异步调用。而非阻塞型异步调用的难点在于多个接口之间的协议。
模块设计的难点是：将流程型的输入和输出，转变成有状态的，接口正交的点。
                  将业务和算法 正交到数据结构中，以输出为目标的代码设计。
                  由于输入内容是不确定，所有，接口和数据结构需要有很大弹性。

printf(C)   == printf(bash) crosstool\cheatsheet\ops_doc-mstaer\stat_fstat.txt (toybox) 格式化重新实现方法
toybox 中 seq.c 文件也有格式化输出。
monit 中 str模块的str_vcat 和 libubox 中__calloc_a 很有意思
monit 中 outputstream 中 OutputStream_vprint(T S, const char *fmt, va_list ap) 
monit 中 stringbuffer.c 中 void _append(T S, const char *s, va_list ap) 

printf(C)   == printf(bash) crosstool\cheatsheet\ops_doc-mstaer\bash实例手册.sh
strftime(C) == date(bash)   crosstool\cheatsheet\ops_doc-mstaer\shell实例手册.sh 和 datatime.sh
printf: inotifywait, find, bash, seq, units, hexdump, ps -eo "%p %y %x %c", gawk, gcov, csplit
        expect wget killall
        libevent(event) syslog, eventfd
        man 3p sprintf | getopt | select_tut | select | _syscall
        man 3 err | dprintf | end | gnu_get_libc_version | error | com_err
        man 3 gnu_get_libc_version | gnu_get_libc_release | undocumented
        man 3 endian | byteorder | ftw, nftw
        man __malloc_hook | mtrace | magic
        man getifaddrs
        
strftime: inotifywait find bash gawk nmap date logrotate lsof tcpdump
          man 3p tzset asctime strptime time.h
boybox  : uptime stat bootchartd ls ps 
strptime: sort.c date.c touch.c 
sscanf(proc) ifconfig netstat
             ftpget   date  expand  dmesg  ip 
             

               (异步|回调)
asynchronous(){
             | Blocking    | Non-blocking
--------------------------------------------------------
Synchronous  | write, read | write, read + poll / select
Asynchronous | -           | aio_write, aio_read

1. Process
2. Polling
3. Select(/poll) loops
4. Signals (interrupts)
5. Callback functions
6. Light-weight processes or threads
7. Completion queues/ports
8. Event flags
9. Channel I/O
10. Registered I/O

1. Blocking, synchronous:
device = IO.open() 
data = device.read() # thread will be blocked until there is no data in the device 
print(data)

2. Non-blocking, synchronous:
device = IO.open()
ready = False
while not ready:
    print("There is no data to read!")
    ready = IO.poll(device, IO.INPUT, 5) # returns control if 5 seconds have elapsed or there is data to read (INPUT)
data = device.read()
print(data)

3. Non-blocking, asynchronous:
ios = IO.IOService()
device = IO.open(ios)

def inputHandler(data, err):
    "Input data handler"
    if not err:
        print(data)

device.readSome(inputHandler)
ios.loop() # wait till all operations have been completed and call all appropriate handlers

4. Reactor pattern:
device = IO.open()
reactor = IO.Reactor()

def inputHandler(data):
    "Input data handler"
    print(data)
    reactor.stop()

reactor.addHandler(inputHandler, device, IO.INPUT)
reactor.run() # run reactor, which handles events and calls appropriate handlers
}
interface(){
1. 响应=api(请求) 
2. ret=api(请求) ret=api(响应)
3. ret=api(reg,privdata) reg(privdata)
4. ret=api(callback,privdata) callback(pridata)
}

状态机可归纳为4个要素，即现态、条件、动作、次态。"现态"和"条件"是因，"动作"和"次态"是果。详解如下：
1. 现态：是指当前所处的状态。
2. 条件：又称为"事件"。当一个条件被满足，将会触发一个动作，或者执行一次状态的迁移。
3. 动作：条件满足后执行的动作。动作执行完毕后，可以迁移到新的状态，也可以仍旧保持原状态。动作不是必需的，当条件满足后，也可以不执行任何动作，直接迁移到新状态。
4. 次态：条件满足后要迁往的新状态。"次态"是相对于"现态"而言的，"次态"一旦被激活，就转变成新的"现态"了。
state_machine(){
[ospf]
1. 端口状态变换
             点到点、点到多点网段和虚连接的端口状态机
当前状态    事件                   新状态                      动作
loopback    unlooped               Down                        无动作
down        InterfaceUp            Point-to-point              启动Hello Timer定时器，开始从端口上周期性发送Hello报文
任何状态    LoopInd                Loopback                    重置所有端口参数，关闭所有端口定时器
任何状态    InterfaceDown          Down                        重置所有端口参数，关闭所有端口定时器
1.1 状态的解释
Down：这是端口的初始状态，在该状态下，底层协议显示该端口不可用，所有定时器被关闭。
Loopback：此状态表示端口被环回。在该状态下的端口被通告为一个Stub网段。
Point-to-point（P-to-P）：在此状态下，端口是可用的，而且端口是连接到点到点、点到多点或者虚连接，此状态下的端口试图与邻居建立邻接关系，并以HelloInterval的间隔发送Hello报文。
DROther：该端口连接到一个广播型网段或者NBMA网段，而且该端口不是一个DR或者BDR。此状态下的端口与DR和BDR形成邻接关系并交换路由信息。
Waiting：在此状态下，路由器通过监听接收到的Hello报文检测网络中是否已经有DR和BDR。在此状态下的路由器不可以选举DR和BDR。
Backup：在此状态下，该路由器成为所连接网络上的BDR，并与网段中所有的其他路由器建立邻接关系。
DR：在此状态下，该路由器成为所连接网络上的DR，并与网段中所有的其他路由器建立邻接关系。
1.2 事件
InterfaceUp：
底层协议显示该端口处于可用状态。
LoopInd：
底层协议显示端口被环回。环回可以是物理环回或者逻辑环回。
UnloopInd：
底层协议显示端口环回被取消。
InterfaceDown：
底层协议显示该端口处于不可用状态。
WaitTimer：
Wait Timer被触发，显示选举DR和BDR之间需要的等待阶段到时。
Wait Timer是一个只被触发一次的定时器，被触发表示端口应退出Waiting状态，并开始选举DR和BDR。该定时器的时间长度RouterDeadInterval.
BackupSeen：
路由器已经检测到网络上是否存在BDR，有两种情况触发此事件，第一，路由器收到一个宣告自己为BDR的Hello报文；第二，路由器收到一个宣告自己为DR的Hello报文，但是BDR字段被设置为0.0.0.0，表示网络中没有BDR。
NeighborChange：
邻居发生变化，包括Router Priority被修改，DR或者BDR不再宣告自己为DR或者BDR，RouterDeadInterval间隔内没有收到DR或BDR的Hello报文。

            广播型网段和NBMA网段的端口状态机(不允许成为DR或者BDR)
当前状态    事件                   新状态                      动作
Loopback    UnloopInd              Down                        无动作
Down        InterfaceUp            DROther                     启动Hello Timer定时器，开始从端口上周期性发送Hello报文
任何状态    LoopInd                Loopback                    重置所有端口参数，关闭所有端口定时器
任何状态    InterfaceDown          Down                        重置所有端口参数，关闭所有端口定时器
            广播型网段和NBMA网段的端口状态机(可能成为DR或者BDR)
Loopback    UnloopInd              Down                        无动作
Down        InterfaceUp            Waiting                     启动Hello Timer定时器，开始从端口上周期性发送Hello报文
Waiting     BackupSeen|WaitTimer   可能为DR、Backup或DROther   计算所连接网段上的DR和BDR
DR Backup或DROther NeighborChange  可能为DR、Backup或DROther   计算所连接网段上的DR和BDR

1. 状态机由：当前状态，事件，新状态和动作组成。
2. 状态机可由：下层状态机，上层状态机组成。
   下层状态机正常初始之后，转而构建上层状态机。
   上层状态机异常之后，转而创建上层状态机或转而从底层状态机开始创建。
   下层状态机异常之后，转而重新初始化下层状态机。
3. 状态机可配：不同类型协议或者接口类型，状态机的状态会不一样。

[monit]


[moosefs]


[redis]
}

state_machine(){
    状态机实现过程中，状态可以是moosefs中连接状态中的mode(FREE,CONNECTING,DATA,KILL,CLOSE)或者registerstate(
UNREGISTERED,WAITING,INPROGRESS,REGISTERED); 使用不同的枚举值或者宏定义来表示一个变量当前处于的状态。 状态也可以
对应相同或者不同的数据结构，例如conncache中不同的数据结构，变量在 conncachehash 哈希表内表示连接有效，变量在 freehead
单向链表内表示连接空闲。例如libuv中相同的数据结构，变量在 threadpool 中 wq 双向链表内表示 uv_work_cb 未调用。
变量在 eventloop.wq 双向链表内表示 uv_work_cb 已调用。sheepdog  有相同情况。
    状态对应枚举值；   每个枚举值或宏定义 表示 变量或结构体 处于不同的状态，通过 状态值     对变量或结构体进行管理。
    状态对应数据结构； 每个结构体实例     表示 变量或结构体 处于不同的状态，通过 结构体实例 对变量或结构体进行管理。

    通常，枚举值容易阅读，不太容易控制, 即 switch 会使代码慢慢扩张和腐烂
    而使用数据结构实例时，比较容易控制, 但是阅读起来就比较麻烦了。
}


asynchronous(event loop){ 
三种异步执行模式
1. libevent libev libuv redis
注册读请求事件(私有数据+回调函数+[读请求标识]) <---------------------------|
回调函数处理(读数据 + 私有数据)                                            |
 | 读取请求数据: 将tcp流数据写入数据缓冲区，将数据缓冲区内数据分割成数据块/|\
 | 处理请求数据：处理已分割好的数据块 | 数据缓冲区内不足形成数据块 ------->| 注册读请求标识
 | 生成响应数据：                                                          |
 | 注册写请求标识 + 注册读请求标识                                        /|\
 | 发送响应数据： | 数据发送完毕：没有待发送数据 ------------------------> | 注册读请求标识
 | 注册写请求标识 + 注册读请求标识                                         |
\|/                                                                        |
 |--------------------------------------------------------------------------
 
[select|poll|epoll_wait] 
    redis事件驱动模型，首次调用poll之间，注册监听类型tcp socket。注册类型socket当接收到新连接请求的时候，
创建新客户端连接实例，并注册读请求标识(注册客户端的读请求标识，是在监听回调函数中完成的，在poll出参后调用)。
注册函数将私有数据+客户端fd+回调函数写入 event loop 关联的数据结构中(可以是链表、数组、扩展树、小堆等等)。
通过while(1)重新扫表已注册的fd和与之关联的读事件请求+写事件请求，将fd和读写请求标识组织成select|poll|epoll_wait
要求的传参格式。

注册回调 -> [select|poll|epoll_wait] -> 处理读请求和处理写请求 -> 注册回调
         /|\                                                         |
          | <---------------------------------------------------------

2. moosefs
注册 desc + serve 两个回调函数
 | 调用 desc 回调函数(用来注册fd 和 fd关联的读请求标识+fd关联的写请求标识) <-|
 | poll                                                                      |
 | 调用 serve 回调函数 (用来处理fd 和 fd关联的读请求函数+fd关联的写请求函数) |
\|/                                                                          |
 | --------------------------------------------------------------------------|
 
注册回调 -> 回调desc(fd[POLLIN+POLLOUT]) -> poll -> 回调serve(fd[read + write])
         /|\                                                         |
          | <---------------------------------------------------------

3. dnsmasq
            |
           \|/
 | <- poll_reset  恢复默认状态   <-----------------------------------------  |
 | poll_listen 设置fd和读写请求标识(POLLIN|POLLOUT)                          |
 | do_poll     调用poll                                                      |
 | poll_check  检查fd和读写请求标识(POLLIN|POLLOUT) + 执行处理函数           |
\|/                                                                          |
 | --------------------------------------------------------------------------|
 
moosefs poll函数入参通过调用注册函数组织; 在poll调用前，在while(1)循环头，通过调用注册函数组织poll入参。
redis   poll函数入参通过调用API函数组织 ; 在poll调用后，在回调函数调用中，通过调用API 函数组织poll入参。

异步实现就是：在需要异步执行的函数执行前，通过注册函数或者API函数组织入参+回调函数；
              在需要异步执行的函数执行后，调用注册函数或者调用API注册的回调函数；
}

定义和举例见：crosstool\cheatsheet\ops_doc-master\Service/CStyle.sh 中 initializer
情况1: 数组初始化
情况2：结构体初始化
情况3：索引为枚举类型的数组的初始化
情况4：元素是结构体对象的数组的初始化
initializer(){
[moosefs]
moosefs中RunTab和LateRunTab符合C90标准。moosefs中termsignal，reloadsignal，ignoresignal符合C90标准。
       中errtab符合C90标准。mfs_opts_stage2也符合C90标准, errtab[]={ERROR_STRINGS} 符合C90标准。 opstr[] validstr[]
       中vstring[] 数组性字符串
       中mfsnetdump.c 中cmdtab[] 字符串和宏对应关系
       中mfsclient 中 char* sugid_clear_mode_strings[] = {SUGID_CLEAR_MODE_STRINGS}; *sesflagposstrtab[]={SESFLAG_POS_STRINGS}
                                                                                char *sesflagnegstrtab[]={SESFLAG_NEG_STRINGS};
moosefs中mfs_meta_oper和mfs_oper符合C99标准，
主要应用是结构体数组 RunTab LateRunTab errtab mfs_opts_stage2 cmdtab[] # 回调函数+字符串 数值+字符串, 数组来源至宏
          字符串数组 opstr对应枚举值 errtab对应宏值                    # 字符串数组按顺序对应宏顺序或者字符串顺序
          大型结构体 mfs_meta_oper mfs_oper                            # 支持大量回调函数，只需要实现部分回调函数
          数值型数组 termsignal reloadsignal ignoresignal              # va_list 类型多值传递的数组形式
          数组类型字符串 id                                            # 利用C语言中，字符串的自动连接功能
          
[monit]
monit 中 tns.c 中 requestPing[] 数值数组 fail2ban.c ping[] 字符串数组 hex[] = "0123456789abcdef"; 字符串数组
      中 protocol.c 中 protocols[] 字符串和回调函数 
      Event_Table[] 对事件的状态描述failed successed changed changenot
      logPriority[] 数值+字符串
      actionnames[] *modenames[] *onrebootnames[] *checksumnames[] *operatornames[] *operatorshortnames[] 字符串和枚举值对应关系
      kNotation[] = {"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", NULL};
       conversion[] = {
        {1000, "ms"}, // millisecond
        {60,   "s"},  // second
        {60,   "m"},  // minute
        {24,   "h"},  // hour
        {365,  "d"},  // day
        {999,  "y"}   // year
    };
      struct option longopts[]
[toybox]
toybox 中 days[]={"sun""mon""tue""wed""thu""fri""sat"}; months[]={"jan""feb""mar""apr""may""jun""jul""aug""sep""oct""nov""dec"};
monit  中 days[] = "SunMonTueWedThuFriSat";             months[] = "JanFebMarAprMayJunJulAugSepOctNovDec"

#define SIGNIFY(x) {SIG##x, #x} 
#define MFS_OPT(t, p, v) { t, offsetof(struct mfsopts, p), v }
#define bprintf(...) { if (leng<size) leng+=snprintf(buff+leng,size-leng,__VA_ARGS__); }
#define debug(f, ...) { if (DEBUG) printf(f, __VA_ARGS__); }
宏定义
}

dlopen(){
misc/dynload/libcaculate
misc/examples/dlsym/dlsym.c:24:  void *handle = dlopen(lib, RTLD_LAZY);
misc/shlibs/dynload.c

# 使用dlopen调用链式的多个动态库
https://stackoverflow.com/questions/26619897/dynamic-linking-of-shared-libraries-with-dependencies

编译目标文件时一般需要加入-fPIC参数，效果是告诉编译器生成位置无关代码。
生成动态库时一般需要加入-shared参数，效果是告诉编译器生成共享库。
# Linux动态库版本命名规范

Linux环境下动态库发布——一式三份
Linux下第三方发布的动态库文件通常包括三个文件，而静态库文件只包含一个. 以libxml为例来说（为了清晰期间下面的内容有所省略）：
$ ls -l
lrwxrwxrwx 1 root root     16 Apr  4  2002 libxml.so -> libxml.so.1.8.14
lrwxrwxrwx 1 root root     16 Apr  4  2002 libxml.so.1 -> libxml.so.1.8.14
-rwxr-xr-x 1 root root 498438 Aug 13  2001 libxml.so.1.8.14
按照Wheeler的说明, 每个动态库一般包括real name、soname和linker name.
    real name: 动态库的real name是这三个文件中唯一一个不是软链接的文件，它是编译动态库时的-o参数指明的库文件名.
    soname: 是一个指向real name的软链接, 其名称一般只包括主版本号，主版本号发生改变一般意味着新版本库的接口
与之前版本库的接口不再兼容.
    linker name: 一般不包含任何版本号, 在被使用动态库的应用系统链接时最常被使用.

# Linux环境下动态库版本命名原则
简而言之, 版本号可以被看作形如libfoo.MAJOR.MINOR.PATCH.
    PATCH: 只有当修改后的软件既满足向前兼容又满足向后兼容时，才允许以只修改PATCH部分数字的形式发布新版本.
    MINOR: 只有当修改后的软件满足向后兼容时（并不要求必须满足向前兼容），才允许以只修改MINOR部分数字而不修改MAJOR部分数字的形式发布新版本.
    MAJOR: 当修改后的软件的API不再与之前版本的API兼容时，应该以修改MAJOR部分数字的形式发布新版本.

1. # Create the shared library with real name libdemo.so.1.0.1 and soname libdemo.so.1.
gcc -fPIC -g -c -Wall mod1.c mod2.c mod3.c
gcc -shared -Wl,-soname,libdemo.so.1 -o libdemo.so.1.0.1 mod1.o mod2.o mod3.o
2. # Create symbolic links for the soname and linker name:
$ ln -s libdemo.so.1.0.1 libdemo.so.1
$ ln -s libdemo.so.1 libdemo.so
$ ls -l libdemo.so* | cut -c 1-11,55- 
3. # Build executable using the linker name:
gcc -g -Wall -o ./prog prog.c -L. -ldemo
4. # Run the program as usual:
$ LD_LIBRARY_PATH=. ./prog 
Called mod1-x1 
Called mod2-x2

# 关于编译参数-soname的说明
$ g++ -shared -Wl,soname, libxxx.so.major ... -o libxxx.so.major.minor.patch
-Wl后面用逗号分割的内容都是传递给链接器的参数，而非编译器的参数；
soname用来指定库的简单共享名（Short for shared object name），一般就是库的名称加上主版本号。
可以使用命令行工具readelf查看动态库的soname：
readelf -d libhello.so.1.1
}

safe(){
POSIX的函数有三类异步安全的概念，每一类安全性对应一种特定的安全性上下文（safety contexts）：
MT-Safe：Thread-Safe functions，多线程安全。特点：可安全的用于多线程并发场景下，无需调用者单独加锁；
AS-Safe： Async-Signal-Safe functions，异步信号安全。特点：可安全用于信号处理句柄中。
AC-Safe：Async-Cancel-Safe functions，异步退出安全。特点：不是很清楚？不过貌似只有两个函数满足此要求。
总体上看，以上三类异步安全性的要求从上到下越来越严格。

}
signal(safe){
（1）是可重入函数； （2）不能被信号处理程序中断。
man 7 signal
}

pthread(safe){
线程安全函数采用黑名单机制（给出非线程安全函数名单），而可重入函数采用白名单机制（给出可重入函数名单）。
线程不安全函数黑名单完整版 man 7 pthreads
线程不安全函数： rand rand_r
strtok strtok_r asctime asctime_r ctime ctime_r gethostbyaddr gethostbyaddr_r 
gethostbyname gethostbyname_r localtime localtime_r
strerror strerror_r getpwname getpwname_r 

异步信号安全函数白名单：（1）是可重入函数； （2）不能被信号处理程序中断。
}
io(read & write 非阻塞){ 非阻塞IO可以实现阻塞IO，而阻塞IO不能实现非阻塞IO。如moosefs项目中的socket.c内tcptoread和tcptowrite函数
                         阻塞IO分为两种：无限期等待IO阻塞发送或读取；超时等待IO阻塞发送和读取。 moosefs实现的是超时等待类型。
非阻塞读或者写的三种状态
MSGST_OK    # 报文header和payload都得到
MSGST_CONT  # 报文header或payload没得全
  1. 对于二进制形式报文：header(固定长度) + data(可变长度) 
    如果当前读取处于header状态，则读取长度=固定长度才进行后续处理，否则MSGST_CONT
      如果可变长度的数据长度大于特定长度，则关闭此连接
    如果当前读取处于data  状态，则读取长度=固定长度指定长度才进行后续处理，否则MSGST_CONT
  2. 对于文本形式协议：json或者http之类，需要指定最大消息长度和结尾标识符；
    如果当前读取数据小于最大消息长度，且没有找到结尾标识符，则继续读取MSGST_CONT
MSGST_FAIL  # 报文header或payload不合法；或者read或write出现不可恢复的错误。

为什么非阻塞型套接字需要用户态的读写buffer？
非阻塞读或者写的三个变量
  预期读取长度(预期写入长度)
  已读取内容长度(已写入内容长度)
  已读取内容(未写入内容)

read: 读取成功                      | write: 写入成功                           # >0
            得到想要长度数据=length |              写入数据等于写入长度=length
          未得到想要长度数据<length |              写入数据不等于写入长度<length
      读取失败                      |        写入失败                           # =-1
           可以挽回类型             |             可以挽回类型                  # EAGAIN 或 EWOULDBLOCK
           不可挽回类型             |             不可挽回类型                  # 非以上两种类型
      对端关闭socket                |        对端关闭socket                     # =0

read： 数据包头
       数据包内容
       
有些程序read之后立刻对接收报文进行处理；有些程序read之后，缓存一下再对报文进行处理。
注意： 客户端 链接建立成功(connect建立成功)，是 write 可写
       服务器端和客户端 链接正常结束是 read  返回值0.
       
       
read函数
有多种情况可使读到的字节数少于要求读的字节数：
    读普通文件时，在读到要求字节数之前已到达了文件尾端。且下次调用read时，它将返回0
    当从终端设备读时，通常一次最多读一行
    当从网络读时，网络中的缓冲机构可能造成返回值小于所要求读的字节数
    当从管道或FIFO读时，如若管道包含的字节少于所需的数量，那么read将只返回实际可用的字节数
    当从某些面向记录的设备(如磁带)，一次最多返回一个记录
    当某一信号造成中断，而已经读了部分数据量时
有关错误处理
    EAGAIN 提示没有数据可读，可以重试，也许下次能成功
    EBADF,EISDIR 等属于程序错误，不应做错误处理（测试就能发现）
    EFAULT,EIO　等错误，无法处理，只能出错返回
    EINTR 信号中断，需要重试
    
write出错的常见原因是：磁盘已写满，或者超过了一个给定进程的文件长度限制
}
io(read & write 阻塞){
阻塞(同步)IO调用指的是：调用会一直阻塞，不会返回，直到发生下面三种情况之一。
1. 要么操作完成，
2. 要么操作被信号中断，
3. 要么经历相当长的时间，网络协议栈自己放弃。

read:                           write:
    读取成功                    写入成功                                        # >0
        得到想要长度数据=length     写入数据等于写入长度=length
    读取失败                    写入失败                                        # =-1
        可以挽回类型                可以挽回类型                                # EINTR
        不可挽回类型                不可挽回类型                                # 非以上两种类型
    对端关闭                    对端关闭                                        # =0
}
io(select poll epoll){
timeval                           timespec                             milliseconds   # 超时
select                            poll                                 epoll_wait
  =0 时表示超时，                   =0 时表示超时，                      =0 时表示超时，
  <0 表示有错误，                   <0 表示有错误，                      <0 表示有错误，
    EINTR                             EINTR                                EINTR
    其他错误 (ENOMEM|EINVAL|EBADF)    其他错误 (ENOMEM|EINVAL|EFAULT)      其他错误 (EBADF|EINVAL|EFAULT)
  >0 表示没有错误                   >0 表示没有错误                      >0 表示没有错误
}

io(send阻塞发送指定长度数据){
query 发送内容
remaining 发送数据长度
n_written已发送数据长度
#     cp = query;
#     remaining = strlen(query);
#     while (remaining) {
#       n_written = send(fd, cp, remaining, 0);
#       if (n_written <= 0) {
#         perror("send");
#         return 1;
#       }
#       remaining -= n_written;
#       cp += n_written;
#     }
}

socket(){
mfscommon/sockets.c
tcptoread tcptowrite tcptoaccept tcpstrtoconnect tcpnumtoconnect 在指定时间完全实现指定功能。
特别是read,write要求接收或者发送指定长度数据，长度不够，返回错误值-1.

tcpread tcpwrite 对read 和 write进行了封装，没有处理EINTR EAGAIN或EWOULDBLOCK 信号情况下的尽力

libmonit/src/system/net.c
Net_read Net_write 在指定时间尽力完成指定功能，不能满足指定长度时，返回已接收或已发送数据长度。

sockets.c 包括域名解析，绑定bind 连接connect 获取accept 以及地址解析
net.c 不包括上述功能。 --- bind connect getaddrinfo accept 都可能出现错误，所以，留给业务层
}

buffer(libevent){ 
总结：将对系统IO的收发数据读写操作与对缓冲区内数据的读写操作绑定，将读写缓冲区操作抽象成特定的接口，
使得对系统IO的读写操作转换成回调函数内对缓冲区数据的读写操作。


总结：bufferevent由一个底层传输系统(比如socket)，一个读缓冲区和一个写缓冲区组成。
普通的events在底层传输系统准备好读或写的时候就调用回调函数。
bufferevent 在已经写入或者读出数据之后才调用回调函数。
# bufferevent目前仅能工作在流式协议上，比如TCP。未来可能会支持数据报协议，比如UDP。

总结：非阻塞IO读取操作，存在可重试读取失败，部分读取成功和全部读取成功三种可继续读取情况。
部分读取成功决定：对已读取数据进行管理(预期读取长度，已读取内容长度和已读取内容)，继续读取时，预期读取长度减少
已读取内容长度增加，已读取内容要追加。对这些变量管理增加了非阻塞IO读取操作的复杂性。
      非阻塞IO写入操作：存在同样情况的复杂性
      bufferevent通过evbuffer_get_length(buf) evbuffer_remove(buf, &n, sizeof(n)) evbuffer_add(buf, &n, sizeof(n));
等操作实现了，获得读取缓冲区内数据长度，移除缓冲区部分数据和向缓冲区内追加数据等操作，这些操作都是在接收数据已读取和
发送数据可缓存的基础上的。使得接收数据不再关心"预期读取长度，已读取内容长度和已读取内容",只需要等到缓冲区内长度满足
预期长度，然后读取即可。即提供全局heap内数据缓存和管理。


总结：bufferevent和evbuffers
    每一个bufferevent都有一个输入缓冲区和一个输出缓冲区。它们的类型都是"struct evbuffer"。
如果bufferevent上有数据输出，则需要将数据写入到输出缓冲区中，将数据写入缓冲区中的操作在writecb或者connected事件中进行
如果bufferevent上有数据需要读取，则需要从输入缓冲区中进行抽取。将数据从缓冲区中读取的操作在readcb或者connectd事件中进行
}

io(单路阻塞->多路非阻塞->多路多线程->多路多进程){
1. 处理单路IO方式blocking阻塞方式即可。 --- 简单高效 moosefs/sockets.c
2. 处理多路IO的一种方式；libevent，redis和moosefs dnsmasq --- 从复杂高效，趋向简单高效 event.c ac.c main.c poll.c
3. 处理多路IO方式还有，多线程和多进程。 --- 复杂(线程间通信)低效；多用处理只有blocking阻塞方式
                                            moosefs/main.c bgjob.c
                                            
第一，某些平台上，创建新进程(甚至是线程)是十分昂贵的。当然在实际环境中，可以使用线程池，
      而不是每次都创建新线程。
第二，更重要的是，线程无法如你所愿的规模化使用。如果你的程序需要同时处理成千上万个链接的时候，
      处理成千上万个线程就不是那么高效的了。
      
dnsmasq -> moosefs -> redis -> libevent 越来越重量级，越来越强大；
从只关注fd事件；dnsmasq+moosefs (dnsmasq一次函数调用注册一个fd，moosefs一次函数回调注册多个fd；dnsmasq一次函数调用检查一个fd，moosefs一次回调函数回调检查多个fd)
到可以同时或者分开关注可读事件和可写事件；redis+libevent (redis只支持linux类型系统，libevent可支持windows系统) 支持多实例，而dnsmasq和moosefs不支持多实例。
最后，可以同时或者分开关注可读事件，可写事件，超时事件，信号事件和可读+超时事件，可写+超时事件。libevent (提供更多类型事件)
最最后，可以分开关注读完成、写完成事件，或者读完成+超时，写完成+超时事件。libevent  (提供读写缓冲区)

dnsmasq
moosefs: 将子进程结束的SIGCHLD|SIGCLD信号转换为管道消息发送给poll，然后由poll中完成waitpid() 子进程收尸处理
redis  : 将子进程创建的状态设置为全局变量，通过在周期函数中调用waitpid() 完成子进程收尸处理
libevent 没有支持fork类型的实例。
}

fork(进程管理){
1. 子进程管理 waitpid()

2. 非子进程管理 /var/run/xxx.pid

}

pthread(线程管理){
1. 动态线程池
moosefs中readdata.c和writedata.c bgjob.c

2. 静态线程池
libevent/libevent_threaded_example/libevent-thread/workqueue.c

3. 动态多线程
}

io(数据包和数据流){
1. 区分数据包和数据流；
2. 区分阻塞和非阻塞。
}

    系统编程最突出的特点在于要求系统程序员必须对其工作的硬件和操作系统有深入全面的了解。系统程序主要是与内核和系统库打交道
而应用程序还需要与更高层次的库进行交互。这些看把硬件和操作系统的抽象封装起来。这种抽象有以下几种目的：
1. 增强系统的可移植性
2. 便于实现不同系统版本之间的兼容
3. 构建更易于使用、功能更强大或二者兼而有之的高级工具箱。
Linux系统编程3大基石：系统调用、C库(libc-glibc)和C编译器(gcc是GNU版的C编译器cc)
标准的C++库和GNU C++编译器。

封装的目的：1. 数据通过接口操作，减少数据操作的复杂度。
            2. 接口封装数据的调用多牵涉到数据的生命周期管理。
            3. 接口封装数据，有时候伴随着单实例(全局变量)这样的约束。
            4. 封装内部拥有全局变量的模块，多是不可重入的；对要实现具体功能的模块而言，这又是不可避免的。
            
            有些封装是特定功能的属性配置集合，封装的目的多是简化调用或者屏蔽不同系统之间、相同系统不同版本的差异。
            
有时框架为了简单，提供了约束条件更多的限制。这些限制多通过配置进行设置。

程序设计：如何减少具有多个全局变量的(业务)模块之间的耦合性。
1. 模块自身不需要初始化，不含有全局变量。模块提供接口，实现内存资源或者系统机制的管理。
   如：*malloc(size_t size);*realloc(void *ptr, size_t size); *calloc(size_t nmemb, size_t size); free(void *ptr);
   如：hcreate, hdestroy, hsearch, hcreate_r, hdestroy_r, hsearch_r
   
2. 模块自身含有全局变量，全局变量通过线程机制提供多线程安全调用、或者系统接口调用受多线程约束。
   如*gethostbyname，*gethostbyname_r 
   如*strerror，  *strerror_r
   如int getopt(int argc, char * const argv[],const char *optstring);
   
3. 模块自身含有全局变量，全局变量受多线程的约束，用于数据处理的模块化设计而定。  性能选择... ...
   如：moosefs 的main.c [注册回调]
   如：dnsmasq的poll.c  [注册回调]
   如：redis提供的多路IO数据处理机制，和tcpcopy.c的main.c提供的多路IO数据处理机制。 [注册回调]
   如：sheepdog的work框架更大，包含的更多的文件。[多线程]
   如：toybox的init进程，用于管理其他进程状态。  [进程管理]
   
4. 业务模块，含有全局变量。全局变量受外部接口调用，更通过socket,磁盘IO接口,或者线程池机制实现数据处理。

协议阻塞：阻塞点理解.... ....
read、write、accept和connect。相同对应的有阻塞超时处理函数。
1、moosefs对上述函数提供超时等待机制。redis未提供超时等待机制。
2. moosefs和redis的read和write在数据发送时，都要将数据发送或接收完毕，发送部分或接收部分是不允许的。
   redis在阻塞情况下，未处理信号异常；moosefs在超时情况下，可能发送或接收部分数据。
3. redis和moosefs对阻塞处理原则不一：redis将block|unblock通过选项封装在函数里面；moosefs使用函数名对block|unblock进行区别调用。
   redis很多函数倾向于对底层函数层层封装；moosefs倾向于对底层函数独立封装。所有
   redis封装后即可被业务直接使用；moosefs封装后经过重新组合才能被业务使用。

1. 网络数据读写而言：
moosefs dnsmasq redis都认为指定长度的数据部分发送成功，就认为数据发送失败；
                           指定长度的数据部分接收成功，就认为数据接受失败；
也就是说：数据的有效性是以协议数据报文为单位，而不是以字节为单位。数据重新发送也是以报文为单位，而不是以字节为单位的。
则tcpwrite tcptowrite tcpread tcptoread anetRead anetWrite和tc_socket_snd tc_socket_rcv接口在数据收发上功能都是没任何问题的。

2. 本次磁盘数据读写而言：
busybox的xread xwrite函数在处理异常和返回值方面都是没有任何问题的。toybox的readall和writeall未处理异常，更重要的返回值不能正确
告知当前已写入或已读出数据量。moosefs在hdd_reed hdd_write中没有对读写异常进行处理。对磁盘而言更多考虑fread和fwrite这些函数吧！

3. 多路IO处理的时间机制方面：
moosefs相对而言效率和实时性都更低一些，tcpcopy相对而言性能会更低一些，dnsmasq超时事件处理还是比较准确的。
redis应该是效率和实时性都比较好的，但是不适合大量定时器处理。libevent在效率和实时性方面都会比redis好些。

4. IPv4 vs IPv6                 dnsmasq redis
   TCP  vs UDP vs icmp          moosefs dnsmasq
   Unix vs inet  vs netlink     moosefs redis dnsmasq
   客户端 VS 服务器端           moosefs redis dnsmasq tcpcopy

   pcap                        tcpcopy
   
5. 如果一个套接字又可读又可写，那么服务器将先读套接字，后写套接字。
   对读请求的处理会产生写请求的发送数据报文，所以，先处理读请求再处理写请求，会有更好的性能。
   5.1 redis
   当套接字变得可读时(客户端对套接字执行write操作、或者执行close操作)或者有新的可应答套接字出现时(客户端对服务器的监听
   套接字执行connect操作)，套接字产生AE_READABLE事件。
   当套接字变得可写时(客户端对套接字执行read操作)，套接字会产生AE_WRITABLE事件。
   5.2 moosefs
   按照读写处理分离原则，moosefs会在读数据处理流时，一起处理网络连接异常关闭的事件处理；moosefs处理完流，创建读数据报文缓存
   之后，会调用处理函数处理数据报文。
   moosefs会在读完成之后，进行数据报文的发送。
   moosefs会在发送完数据之后，对网络连接异常的进行后续内存空间释放。


6. 客户端：
   6.1 redis：客户端状态包括的属性可以分为两类
   一类是比较普通的属性，这些属性很少与特定的功能相关，无论客户端执行的是什么工作，它们都要用到这些属性。
   另外一类适合特定功能相关的属性，比如操作数据库时需要用到的db属性和dictid属性，执行事务时需要
   用到的mstate属性，以及执行WATCH命令时需要用到的watched_keys属性等等。
   
7. 多路IO框架差异
   dnsmasq和moosefs的多路IO框架是一种基于超时时间的轮询机制。
   1. poll每次阻塞调用完成以后，多路IO框架不知道哪些文件描述符fd需要执行；哪些文件描述fd不需要执行，多路IO框架会回调
   模块提供的回调函数，让模块判断自己管理的文件描述符fd是否可以发送数据包和接收数据包。
   2. 多路IO框架在注册关心读写事件类型的之前，文件描述符fd关心事件的注册由各个模块按照当前状态根据约定修改全局变量，
   实现读写事件类型的对多路IO框架的注册，然后由poll注册到内核中，阻塞监听文件描述符的读写状态。
   也就说：多路IO框架不确定哪些fd有事件哪些fd没有事件；多路IO框架也不缓存哪些fd需要监听读写事件，哪些fd不需要监听读写事件。
   
   redis和libevent的多路IO框架是一种基于事件驱动的触发机制。
   1. poll每次阻塞调用完成以后，多路IO框架知道哪些文件描述符fd需要执行；哪些文件描述符fd不需要执行，多路IO框架会根据事件
   回调模块提供的事件处理函数，事件的注册在事件处理函数中进行进行。
   2. 多路IO框架在注册关心读写事件类型的之前，文件描述符fd关心事件的注册已经在定时、周期性回调函数或者读写事件处理函数
   完成了注册，各个模块没有提供事件类型注册的回调函数。
   
   dnsmasq和moosefs提供的多路IO框架效率略低，比较适合客户端、服务器端的混合编程模式。
   redis和libevent提供的多路IO框架效率略高，比较适合纯服务器端的编程模式。
   
   sheepdog提供的编程框架比较大，将多路IO处理和线程池绑定在一起，还需进一步研究

redis: RTU程序打印部分按模块，根据配置级别进行打印的设计，比较死板，没有按照register的方式进行打印，
       当时按照固定数组方式进行打印，现在想想redis中命令的注册，然后按照dict方式构建的过程，感觉logger部分
       有进一步可以模块化的地方。

1. 为了提高效率，将链表遍历结构转化为数组查询，或者将无序的链表或者数组变成有序的链表或者数组
2. 为了提高利用率，根据需求动态扩展一个缓冲区，且为将来内存需求提供预留。

fcntl(moosefs|redis|dnsmasq|toybox){
文件的标志分为 file descriptor flag 与 file status flag 两类，分别用 F_GETFD/F_SETFD 和 F_GETFL/F_SETFL 来存取
file descriptor flag 只有一个：close-on-exec；file status flags 包含 O_NONBLOCK、 O_APPEND、O_DIRECT 等等。
因此files_struct要有fd_set close_on_exec 成员，用于存储 file descriptor flag，而file status flag 则是放在struct file 的 f_flags 成员中。

}

tcp_alloc(){
| struct           | size | slab cache name    |
| ---------------- | ---- | ------------------ |
| file             |  256 | "filp"             |
| dentry           |  192 | "dentry"           |
| socket_alloc     |  640 | "sock_inode_cache" |
| tcp_sock         | 1792 | "TCP"              |
| socket_wq        |   64 | "kmalloc-64"       |
| ---------------- | ---- | ------------------ |
| inet_bind_bucket |   64 | "tcp_bind_bucket"  |
| epitem           |  128 | "eventpoll_epi"    |
| tcp_request_sock |  256 | "request_sock_TCP" |
每个 TCP socket 占用的内存最少是 256 + 192 + 640 + 1792 + 64 = 2944 字节。
    创建 10000 个 TCP socket 会使用 31552 KB 内存（通过比较 /proc/meminfo 得出），即每个 TCP socket 
占用 3.155 KB，这个数字很接近上面考虑 SLAB overhead 之后的计算结果。
https://github.com/chenshuo/recipes/blob/master/tpc/bin/footprint.cc
}

udp(connect){
    如果一个udp socket，只作为client 向同一个server地址通讯，那么应该调用connect。
udp socket connect的作用是，提前告知内核对端的地址，从而可以在随后用send和recv而不是sendto和recvfrom，
从而少写一个参数。
    少写一个参数几乎没有什么意义。有意义的是，你调用connect之后，一个非server地址发给你的udp包会让
系统直接返回icmp并且不会导致recvfrom返回。如果你没调用connect，那么你只能用recvfrom收包，那么你收到
包之后首先得判断fromaddr，这很麻烦，用了connect之后就可以省掉这个步骤了。
}
OO(编程方向){
moosefs: 面向基本数据类型编程；
redis  ：面向字符串sds类型编程
dnsmasq：面向数据结构编程    # 把知识叠入数据(数据结构和数据结构之间的关系) ?
sheepdog: 面向数据结构编程   # 把知识叠入数据(数据结构和数据结构之间的关系) ?
ucos_arm: 面向对象编程
toybox和busybox: POSIX接口编程
}

moosefs(sessionid){
session ID的思想很简单，就是每一次对话都有一个编号（session ID）。如果对话中断，下次重连的时候，
只要客户端给出这个编号，且服务器有这个编号的记录，双方就可以重新使用已有的"对话密钥"，而不必重新生成一把。
int fs_connect(uint8_t oninit,struct connect_args_t *cargs) 
# 配置信息
  bindhostname       srcip
  masterhostname     masterip
  masterportname     masterport
  meta
  clearpassword
  info
  subfolder
  passworddigest     digest之后的密码值。md5方式生成digest
步骤1. 对密码进行digest处理
# md5pass[16]
方法1: 
md5_init(&ctx);
md5_update(&ctx,(uint8_t*)(mfsopts.password),strlen(mfsopts.password));
md5_final(md5pass,&ctx);
方法2：
通过字符串直接获得；string -> md5pass (char -> number)

步骤2. 对bindhostname masterhostname masterport 进行解析
fs_resolve() 解析bindhostname masterhostname masterportname

步骤3. tcp连接建立
tcpsocket();
tcpnodelay(fd)
tcpnumbind(fd,srcip,0)
tcpnumtoconnect(fd,masterip,masterport,CONNECT_TIMEOUT)

步骤4. 注册准备
CLTOMA_FUSE_REGISTER 长度 BLOB(64)   REGISTER_GETRANDOM
MATOCL_FUSE_REGISTER 长度 random(32) 
md5_init(&ctx);
md5_update(&ctx,regbuff,16);                 前16
md5_update(&ctx,cargs->passworddigest,16);   passworddigest 16
md5_update(&ctx,regbuff+16,16);              后16
md5_final(digest,&ctx);                      结束

步骤4. 注册
CLTOMA_FUSE_REGISTER 长度 BLOB(64) REGISTER_NEWMETASESSION|REGISTER_NEWSESSION VERSMAJ VERSMID VERSMIN ileng info digest[16]
MATOCL_FUSE_REGISTER 长度 masterversion sessionid rootuid rootgid mapalluid mapallgid mingoal maxgoal mintrashtime maxtrashtime
}
服务器结构一般分为三个模块：
  I/O处理单元（I/O模型、高效事件处理模式）
  逻辑单元（高效并发模式）
  存储单元（与网络编程无直接关系）
服务器模型：
  C/S模型
  P2P模型（分布式 节点既是服务端也是客户端 去中心化）
I/O模型：
  阻塞I/O、非阻塞I/O
  select、poll、epoll等I/O复用技术
  SIGIO信号 也可以报告I/O事件
  异步I/O（上面三种都是同步I/O） 异步I/O由内核来执行I/O
    
IO(应用总结){
服务器端：一个监听，多条连接。监听大多通过配置进行监听，连接通过监听套接字被动建立。
客户机端：没有监听，一条连接。连接可以通过配置和参数发起，也可以根据协议数据(hostname:port)发起连接。

moosefs: masterconn、matoclserventry、matocsserventry等等结构体具有很大相似性。构成被动网络连接链表，
         链表组成网络连接链，链表节点有协议处理与网络状态处理相关代码。可以关联session和密码相关代码。
         网络连接在xxxx_serve进行新建连接、关闭连接、接收数据和发送数据，在xxxx_desc中进行接收事件注册和发送事件注册
         接收数据和发送数据、接收事件注册和发送事件注册在两个回调函数中进行。
         接收事件注册和发送事件注册--受周期时间和网络连接状态驱动。
         
         使得代码没有类似redis网路连接处理中递归调用的aeCreateFileEvent(监听网络socket被动创建网络socket)
         也就是说：网络监听socket与监听socket被动创建socket使用不同函数进行构建。
         另一方面：网络监听socket与监听socket被动创建socket又调用相同的xxxx_serve和xxxx_desc处理接收和发送相关操作；
         造成后种情况的原因：接收事件注册和发送事件注册没有关联私有数据(回调函数)，使得后续数据处理不能在xxxx_serve和xxxx_desc中模块(独立)。

dnsmasq: netlink.c bpf.c dhcp.c dhcp6.c radv.c helper.c 等等文件直接通过dnsmasq.h间接通过poll.c 关联到一起。
         从功能上这些协议存在很大差异，从网络上看都是通过udp协议实现的，使得各个模块不存在多条连接管理的问题。
         
         接收数据和发送数据在poll_check之后确定，接收事件注册和发送事件注册在poll_listen中进行。

redis:   eventLoop将aeFileEvent、aeFiredEvent、aeTimeEvent、aeBeforeSleepProc结构体关联到一起。构成主被动网络连接表。
         链表组成网络连接数组，aeFileEvent节点有协议处理回调函数和接收事件状态、发送事件状态值、文件描述符
                               aeFiredEvent节点有接收事件状态、发送事件状态值、文件描述符
                               aeBeforeSleepProc节点处理器id，到达时间和处理回调函数。
         acceptTcpHandler|acceptUnixHandler 进行新建连接    -> # 由于是一次注册，后续不再注册，所以只需要一次调用即可
         readQueryFromClient 进行接收数据和接收数据事件注册 -> aeCreateFileEvent(sendReplyToClient)
         sendReplyToClient   进行发送数据和发送数据事件注册 -> # 由于是一次注册，后续不再注册，所以只需要一次调用即可
         接收数据和发送数据注册在readQueryFromClient函数中进行；发送数据和发送数据注册|删除在sendReplyToClient中进行；
         接收事件注册和发送事件注册--受周期时间和网络连接状态驱动。
         
         被动创建的客户端socket是监听socket通过"递归"注册回调aeCreateFileEvent的方式方式创建的；
         被动创建的客户端的数据发送是通过"递归"注册回调sendReplyToClient将数据发送出去的；
         网络监听socket与监听socket被动创建socket使用相同的注册函数 aeCreateFileEvent注册，
         使用不同回调函数(acceptTcpHandler|acceptUnixHandler、readQueryFromClient)进行处理；
         这种相同注册和不同回调是通过私有数据多样性绑定实现的。

libubox: wdt_timeout.cb = watchdog_timeout_cb;                     -> watchdog_timeout_cb(&wdt_timeout); 
         将函数watchdog_timeout_cb赋值给特定结构体wdt_timeout的cb，-> 又将wdt_timeout作为参数传递给回调函数。
         
         libubox将uloop_fd、uloop_timeout、uloop_process的内存申请放到了libubox模块外进行，同时对变量的初始化也没有
         封装成一些通用的函数，这就使得在数据结构在透明性和封装上存在很多问题。在内存申请上使得模块之间耦合性也很强。

sheepdog: 
}
  
poll(milliseconds：毫秒){ int timeout
struct pollfd   fds     //创建一个pollfd类型的数组
fds[0].fd               //向fds[0]中放入需要监视的fd
fds[0].events           //向fds[0]中放入需要监视的fd的触发事件
    POLLIN              //I/O有输入
    POLLPRI             //有紧急数据需要读取
    POLLOUT             //I/O可写
    POLLRDHUP           //流式套接字连接断开或套接字处于半关闭状态
    POLLERR             //错误条件(仅针对输出)
    POLLHUP             //挂起(仅针对输出)
    POLLNVAL            //无效的请求：fd没有被打开(仅针对输出)
}

select(microseconds：微秒){  struct timeval *timeout
fd_set      //创建fd_set对象，将来从中增减需要监视的fd
FD_ZERO()   //清空fd_set对象
FD_SET()    //将一个fd加入fd_set对象中  
select()    //监视fd_set对象中的文件描述符
pselect()   //先设定信号屏蔽，再监视
FD_ISSET()  //测试fd是否属于fd_set对象
FD_CLR()    //从fd_set对象中删除fd
}


epoll(milliseconds:毫秒){ int timeout
epoll_create()          //创建epoll对象
struct epoll_event      //准备事件结构体和事件结构体数组
    event.events
    event.data.fd ...
epoll_ctl()             //配置epoll对象
epoll_wait()            //监控epoll对象中的fd及其相应的event
}

timer(timeval:微秒处理相关){
# 统一为微秒处理函数
# int gettimeofday(struct timeval *tv, struct timezone *tz);
# int select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout);
void timeradd(struct timeval *a, struct timeval *b, struct timeval *res);
void timersub(struct timeval *a, struct timeval *b, struct timeval *res);
void timerclear(struct timeval *tvp);
int timerisset(struct timeval *tvp);
int timercmp(struct timeval *a, struct timeval *b, CMP);

# 超时处理
moosefs时间统一为微秒
redis时间统一为毫秒
tcpcopy时间统一为毫秒
dnsmasq超时定时为250微秒
}

timer(moosefs libevent libev){
moosefs: now使用unit32_t, usecnow使用uint64_t 即second *= 1000000
libevent: 使用struct timeval: 通过秒和微秒两个long型
libev   : 使用double类型，整数部分表示秒，小数部分表示秒下值
libuv
以上提供的时间都是系统时间，随着 settimeofday(&tv, NULL) 和 int stime(time_t *t);的调用改变，
进程中如果有用到这些时间值的需要特别注意，特别是用来进行超时处理或者周期性任务的。
sysinfo(&info) 获得的 uptime 是系统启动以来的秒累计值，使用该值用来进行超时处理或者周期性任务时，
比以上提供的函数更加有效。

Sunday, Monday, Tuesday, Wednesday, Thursday, Friday or Saturday

时间: second 秒  milliseconds 毫秒 microseconds 微秒 nanoseconds  纳秒
                                   timesval          timespec
1. nanoseconds 
yes no | man 2 -K timespec | sed  's/ /\n/g' | sed  '/ynq/d'
2. microseconds
yes no | man 2 -K timeval | sed  's/ /\n/g'  | sed  '/ynq/d'
3. milliseconds
yes no | man 2 -K milliseconds | sed  's/ /\n/g'   | sed  '/ynq/d'

real-time : time gettimeofday clock_gettime(CLOCK_REALTIME)
进程时间: times(2), getrusage(2), or clock(3)
monotonic time: sysinfo clock_gettime(CLOCK_MONOTONIC)
时间分解: localtime  gmtime  mktime
格式化时间: asctime ctime strftime strptime
硬件时间: hwclock rtc 
睡眠时间: nanosleep(2), clock_nanosleep(2), and sleep(3)
          alarm(2), getitimer(2), timerfd_create(2), and timer_create(2).
}

timer(adjtime){
adjtime用于修改系统时钟，该系统时钟由函数 gettimeofday 返回。
并且这种修改是通过每秒增加/减少需要调整的时钟的百分比来缓慢调节的。

int adjtime(const struct timeval *delta, struct timeval *olddelta);
delta       struct timeval *    调整时钟的值
olddelta    struct timeval *    旧时钟的值

结构体说明
struct timeval {
time_t tv_sec;         // 秒
suseconds_t tv_usec;   // 微妙 10^-6sec
}

原理说明
delta 参数可以是正数/负数，用来调快/调慢时钟。
这种调整是通过缓慢的每秒调节需要调节值的一定百分比进行调节的。
所以当前一个adjtime正在调节，此时再调用另外一个adjtime的话，前一个会 立刻停止调节，但是以及完成的调节就完成了。
如果 olddelta 不为空，此时将返回上一次调节剩余需要调节值。
}
timer(clock_gettime){ 用于获取&修改各种类型的时钟。 -lrt
#include <time.h>
int clock_getres(clockid_t clk_id, struct timespec *res);
int clock_gettime(clockid_t clk_id, struct timespec *tp);
int clock_settime(clockid_t clk_id, const struct timespec *tp);

参数      类型              说明
clk_id    clockid_t         时钟种类
res       struct timespec * 时钟的精度
tp        struct timespec * 设置或获取时钟的参数指针
struct timespec {
time_t tv_sec;    // 秒
long   tv_nsec;   // 纳妙 10^-9sec

CLOCK_REALTIME: 系统实时时间,随系统实时时间改变而改变,即从UTC1970-1-1 0:0:0开始计时,中间时刻如果系统时间被用户该成其他,则对应的时间相应改变
CLOCK_MONOTONIC:从系统启动这一刻起开始计时,不受系统时间被用户改变的影响
CLOCK_PROCESS_CPUTIME_ID:本进程到当前代码系统CPU花费的时间
CLOCK_THREAD_CPUTIME_ID:本线程到当前代码系统CPU花费的时间
}

clockid_t
其中clockid_tz设定支持的不同时钟类型，其中支持系统级别的时钟 (system-wide)，该时钟可以被系统的所有进程所使用；
或者支持一个进程级别 的时钟(per-process)，该时钟只有被一个进程所使用。

CLOCK_REALTIME
系统级别的实时时钟，也叫为墙壁时钟(wall-clock)。需要特殊的权限才能修改 该时钟。例如管理员修改系统时间，adjtime或者NTP服务。

CLOCK_REALTIME_COARSE
快速墙壁时钟，但是较少精度的准确性。

CLOCK_MONOTONIC
单调时钟，从开机开始算起。该时钟不能通过修改系统时间修改，但是可以通 adjtime(3)和NTP服务修改。

CLOCK_MONOTONIC_COARSE
快速单调时钟，但是具有较低的准确性。

CLOCK_MONOTONIC_RAW
类似CLOCK_MONOTONIC时钟，提供硬件级别的时钟，不能通过adjtime和NTP修改 该时钟。
CLOCK_BOOTTIME

类似于CLOCK_MONOTONIC时钟，而且包括系统暂停的时钟。

CLOCK_PROCESS_CPUTIME_ID
高精度的进程级别的时钟。

CLOCK_THREAD_CPUTIME_ID
高精度的线程级别的时钟。
}
nonblock(O_NONBLOCK vs. FIONBIO){
早些时候，这两个ioctl(...FIONBIO...) and fcntl(...O_NDELAY...)函数首先被标准化，但是不同的操作系统之间存在差异性
即使相同的操作系统不同版本之间也存在差异性。于是FIONBIO常用于socket，而O_NDELAY被用于tty。如果不想考虑差异性，
这两个选项都进行设置。同时非阻塞的read调用也存在差异性:EAGAIN和EWOULDBLOCK。

POSIX添加了O_NONBLOCK表示，在Linux操作系统内FIONBIO，O_NDELAY，O_NONBLOCK三个标识功能一致，且Linux将EAGAIN和EWOULDBLOCK
定义为值一样而名字不一样的两个值。
-------------------------------------------------------------------------------
有一个非常有迷惑性的做法是：
u_long has = 1;
ioctl(m_sock, FIONBIO , &has);
这个函数会非常无耻的返回你success，但是它实际上很可能什么也没做。

正确的做法应该是使用fcntl：
int flags = fcntl(m_sock, F_GETFL, 0);
fcntl(m_sock, F_SETFL, flags|O_NONBLOCK);

这真是一个隐蔽的问题，折腾了我两天。线程每每停留在send()调用那里，我始终没怀疑到：用ioctl设置FIONBIO成功之后，socket竟然还是阻塞的。
}
getaddrinfo(host dig nslookup ping fping 异步DNS请求){
(1)AI_PASSIVE当此标志置位时，表示调用者将在bind()函数调用中使用返回的地址结构。当此标志不置位时，
  表示将在connect()函数调用中使用。
1.1 当节点名位NULL，且此标志置位，则返回的地址将是通配地址。
1.2 如果节点名NULL，且此标志不置位，则返回的地址将是回环地址。
(2)AI_CANNONAME当此标志置位时，在函数所返回的第一个addrinfo结构中的ai_cannoname成员中，
   应该包含一个以空字符结尾的字符串，字符串的内容是节点名的正规名。
(3)AI_NUMERICHOST当此标志置位时，此标志表示调用中的节点名必须是一个数字地址字符串。
------------------------------------------------------------------------------- # 标识暗示分类
(1)通常服务器端在调用getaddrinfo之前，ai_flags设置AI_PASSIVE，用于bind；主机名nodename通常会设置为NULL，
   返回通配地址[::]。
(2)客户端调用getaddrinfo时，ai_flags一般不设置AI_PASSIVE，但是主机名nodename和服务名servname（更愿意称之为端口）
   则应该不为空。
(3)当然，即使不设置AI_PASSIVE，取出的地址也并非不可以被bind，很多程序中ai_flags直接设置为0，即3个标志位都
   不设置，这种情况下只要hostname和servname设置的没有问题就可以正确bind。
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
保留输入输出指向 /dev/null
lrwx------. 1 nobody nobody 64 Jul 10 13:21 0 -> /dev/null
lrwx------. 1 nobody nobody 64 Jul 10 13:21 1 -> /dev/null
lrwx------. 1 nobody nobody 64 Jul 10 13:21 2 -> /dev/null

openssl
[pid]:error:[error code]:[library name]:[function name]:[reason string]:[file name]:[line]:[optional text message]
moosefs(日志@协议){ -- 前后台分散输出
@日志流向
1. syslog a. 后台任务被触发执行
          系统资源的申请、释放(线程资源；socket资源)；关键对象的申请和释放
          协议或指令请求不在程序设计范围内(异常提示) switch:default crc校验失败 格式不正确 接收超时 内容不正确
          配置值或请求内容超过程序设计要求(异常提示) MAXLOGLINESIZE MAXLOGNUMBER
          外部触发进程执行特定异常处理单元(异常处理) 数据块丢失 数据处理过程中预料之外状态
          系统接口或库接口调用失败(fopen调用失败)    入参可能导致失败则打印入参；出参状态提示不同失败原因则分别打印错误
2. mfs_arg_syslog a. 启动过程中
          系统接口或库接口调用失败(fopen调用失败)    
          系统默认参数提示(默认配置)
          配置文件格式不正确或参数不正确(incorrect 或 maxgoal<mingoal)
3. mfs_arg_errlog a. 系统调用失败，有errno值
4. mfs_errlog_silent a. 系统调用失败，有errno值错误，后台执行
          可以通过重试忽略(ERRNO_ERROR)
          可以忽略(accept error)  tcpgetstatus close(sfd) fsync(sfd)
5. fprintf: 命令行处理|提示
          : 进程daemon之前打印
          : 管理命令工具
@日志级别     
1. LOG_NOTICE 提示作用，一般不会伴随-1这样的退出； 状态提示，自动修复
          系统默认参数提示(默认配置)   设置系统限制值setrlimit
          优化级别的配置选项设置失败
          计划申请的资源已经存在(创建目录目录已存在，创建文件文件已存在)
          进程正常退出(模块正常退出) | 进程正常启动(模块正常启动)
          系统调用错误是可以补救的；或者非预期内的执行阻塞
          read|write|accept 类型状态错误；或连接重建
2. LOG_WARNING 提示作用，常常伴随着-1这样的退出；  局部错误，不能修正
          参数不合法；
3. LOG_ERR 提示作用， 常常伴随着-1这样的退出； 模块级或系统级别错误，不能修复
          模块初始化失败
          系统初始化失败
          不可尝试性通道错误：pipe(read|write)
          
1. 内容组织：
  系统级别：直接说明，没有模块和关联对象作为开头；  error(read error|error reading) cannot
  模块级别：模块名：提示内容       invalid wrong incomplete incorrect
  模块关系：模块名 <-> 模块名      not found ; too long
  
@日志流向
1. syslog && stderr message                  mfs_syslog
2. syslog && stderr stdarg message           mfs_arg_syslog

3. syslog && stderr errno message            mfs_errlog
4. syslog && stderr errno stdarg message     mfs_arg_errlog

5. syslog errno message                      mfs_errlog_silent
6. syslog errno stdarg message               mfs_arg_errlog_silent

7. stderr errno message                      sprintf(stderr ... ) errno
8. stderr errno stdarg message               sprintf(stderr ... ) errno

9. syslog message                            syslog
10. stderr  message                          sprintf(stderr ... )

@1. 保持函数级别打印一致性
@2. 保持对象级别打印一致性
@3. 保持函数集级别打印一致性
@4. 保持文件集级别打印一致性
@5. 保持模块级别打印一致性
@6. 保持程序级别打印一致性

:    范围减小；或后者对前者进行说明
[+-] 增加或减少
() 进一步描述
/  实际值/期望值
|  或
-> 已完成
,  下一步

@协议 bgjobs.c
syslog(LOG_NOTICE,"workers: %"PRIu32"+",jp->workers_total);
syslog(LOG_NOTICE,"workers: %"PRIu32"-",jp->workers_total);
                   workers: 说明多少，+- 说明增减
syslog(LOG_NOTICE,"jobs: spawn worker (total: %"PRIu32")",jp->workers_total);
syslog(LOG_NOTICE,"jobs: close worker (total: %"PRIu32")",jp->workers_total);
                   模块名: 函数名     (总数量: 数量值)
syslog(LOG_NOTICE,"deleting jobqueue: %p",jp->jobqueue);
syslog(LOG_WARNING,"new jobqueue: %p",jp->jobqueue);
syslog(LOG_WARNING,"new pool of workers (%p:%"PRIu8")",(void*)jp,workers);

@协议 bio.c
syslog(LOG_NOTICE,"write %"PRIu32" -> %"PRId32" (error:%s)",leng,ret,strerr(errno));
syslog(LOG_NOTICE,"read %"PRIu32" -> %"PRId32" (error:%s)",leng,ret,strerr(errno));
                   操作：操作长度 -> 实际完成长度 (error:错误原因)
@ 协议 csserv.c
syslog(LOG_NOTICE,"ANTOAN_GET_VERSION - wrong size (%"PRIu32"/4|0)",length);
syslog(LOG_NOTICE,"ANTOCS_GET_CHUNK_BLOCKS - wrong size (%"PRIu32"/12)",length);
syslog(LOG_NOTICE,"ANTOCS_GET_CHUNK_CHECKSUM - wrong size (%"PRIu32"/12)",length);
syslog(LOG_NOTICE,"ANTOCS_GET_CHUNK_CHECKSUM_TAB - wrong size (%"PRIu32"/12)",length);
syslog(LOG_NOTICE,"CLTOCS_HDD_LIST - wrong size (%"PRIu32"/0)",length);
syslog(LOG_NOTICE,"CLTOAN_CHART - wrong size (%"PRIu32"/4|8)",length);
syslog(LOG_NOTICE,"CLTOAN_CHART_DATA - wrong size (%"PRIu32"/4|8)",length);
syslog(LOG_NOTICE,"CLTOAN_MONOTONIC_DATA - wrong size (%"PRIu32"/0)",length);
syslog(LOG_NOTICE,"CLTOAN_MODULE_INFO - wrong size (%"PRIu32"/0)",length);
                   处理命令             错误原因   (当前长度/期望长度)

@协议 chunk.c
syslog(LOG_WARNING,"serious structure inconsistency: (chunkid:%016"PRIX64")",c->chunkid);
syslog(LOG_WARNING,"serious structure inconsistency: (chunkid:%016"PRIX64")",c->chunkid);
syslog(LOG_WARNING,"serious structure inconsistency: (chunkid:%016"PRIX64")",ochunkid);
syslog(LOG_WARNING,"wrong all valid copies counter - (counter value: %u, should be: 0) - fixed",c->allvalidcopies);
syslog(LOG_WARNING,"wrong regular valid copies counter - (counter value: %u, should be: 0) - fixed",c->regularvalidcopies);

syslog(LOG_WARNING,"chunkserver has nonexistent chunk (%016"PRIX64"_%08"PRIX32"), id looks wrong - just ignore it",chunkid,version);
syslog(LOG_WARNING,"chunkserver has nonexistent chunk (%016"PRIX64"_%08"PRIX32"), so create it for future deletion",chunkid,version);
syslog(LOG_WARNING,"chunkserver has nonexistent chunk (%016"PRIX64"), id looks wrong - just ignore it",chunkid);
syslog(LOG_WARNING,"chunkserver has nonexistent chunk (%016"PRIX64"), so create it for future deletion",chunkid);
                  错误描述 (使用数字准确描述) ,后续处理
syslog(LOG_WARNING,"got unexpected delete status");
syslog(LOG_WARNING,"got replication status from server not set as busy !!!");
syslog(LOG_WARNING,"got replication status from one server, but another is set as busy !!!");
syslog(LOG_WARNING,"got replication status from server which had had that chunk before (chunk:%016"PRIX64"_%08"PRIX32")",chunkid,version);
                  错误描述
syslog(LOG_NOTICE,"DEL_LIMIT hard limit (%"PRIu32" per server) reached",MaxDelHardLimit);
syslog(LOG_NOTICE,"DEL_LIMIT temporary increased to: %"PRIu32" per server",TmpMaxDel);
syslog(LOG_NOTICE,"DEL_LIMIT back to soft limit (%"PRIu32" per server)",MaxDelSoftLimit);
syslog(LOG_NOTICE,"DEL_LIMIT decreased back to: %"PRIu32" per server",TmpMaxDel);
                   宏定义    错误描述           (使用数字准确描述)
syslog(LOG_WARNING,"chunk %016"PRIX64"_%08"PRIX32": wrong all valid copies counter - (counter value: %u, should be: %u) - fixed",c->chunkid,c->version,c->allvalidcopies,vc+tdc+bc+tdb);
syslog(LOG_WARNING,"chunk %016"PRIX64"_%08"PRIX32": wrong regular valid copies counter - (counter value: %u, should be: %u) - fixed",c->chunkid,c->version,c->regularvalidcopies,vc+bc);
syslog(LOG_WARNING,"chunk %016"PRIX64"_%08"PRIX32": chunk in middle of operation %s, but no chunk server is busy - finish operation",c->chunkid,c->version,opstr[c->operation]);
syslog(LOG_WARNING,"chunk %016"PRIX64"_%08"PRIX32": unexpected BUSY copies - fixing",c->chunkid,c->version);
syslog(LOG_WARNING,"chunk %016"PRIX64"_%08"PRIX32": unexpected BUSY copies - can't fix",c->chunkid,c->version);
syslog(LOG_WARNING,"chunk %016"PRIX64" has only invalid copies (%"PRIu32") - fixing it",c->chunkid,wvc+tdw);
syslog(LOG_NOTICE,"chunk %016"PRIX64"_%08"PRIX32" - wrong versioned copy on (%s - ver:%08"PRIX32")",c->chunkid,c->version,matocsserv_getstrip(cstab[s->csid].ptr),s->version);
syslog(LOG_NOTICE,"chunk %016"PRIX64"_%08"PRIX32" - valid copy on (%s - ver:%08"PRIX32")",c->chunkid,c->version,matocsserv_getstrip(cstab[s->csid].ptr),s->version);
syslog(LOG_WARNING,"chunk %016"PRIX64" has only invalid copies (%"PRIu32") - please repair it manually",c->chunkid,ivc);
syslog(LOG_WARNING,"chunk %016"PRIX64" has only copies with wrong versions (%"PRIu32") - please repair it manually",c->chunkid,wvc+tdw);
syslog(LOG_NOTICE,"chunk %016"PRIX64"_%08"PRIX32" - invalid copy on (%s - ver:%08"PRIX32")",c->chunkid,c->version,matocsserv_getstrip(cstab[s->csid].ptr),s->version);
syslog(LOG_NOTICE,"chunk %016"PRIX64"_%08"PRIX32" - copy with wrong version on (%s - ver:%08"PRIX32")",c->chunkid,c->version,matocsserv_getstrip(cstab[s->csid].ptr),s->version);
syslog(LOG_NOTICE,"chunk %016"PRIX64"_%08"PRIX32": there are no copies",c->chunkid,c->version);
                  chunk 描述信息                 [:-] 出错原因
}

# 处理: 参数类型不指定 和 参数个数不指定 问题. 实现方式 序列list
va_copy(迭代器){
va_list ap：定义一个指向个数可变的参数列表指针；
# 定义 ap
void va_start(va_list ap, last);：使参数列表指针ap指向函数参数列表中的第一个可选参数，
# 初始化 ap，依赖参数列表中 last 参数
  说明：last是位于第一个可选参数之前的固定参数，(或者说，最后一个固定参数； ... 之前的一个参数)，
  函数参数列表中参数在内存中的顺序与函数声明时的顺序是一致的。如果有xxx_va函数的声明是
  void va_test(char a, char b, char c, ...)，则它的固定参数依次是a,b,c，最后一个固定参数last为c，
  因此就是va_start(ap, c)。
  注意：last 不能是 函数类型 寄存器类型和数组类型。
type va_arg(va_list ap, type):  返回参数列表中指针ap所指的参数，返回类型为type，并使指针ap指向参数列表中下一个参数。
# 使用ap, 依赖 type 指定当前类型
void va_end(va_list ap):  清空参数列表，并置参数指针ap无效。
# 释放ap
  说明：指针ap被置无效后，可以通过调用va_start()、va_copy()恢复ap。
  每次调用va_start() / va_copy()后，必须得有相应的va_end()与之匹配。
  参数指针可以在参数列表中随意地来回移动，但必须在va_start() … va_end()之内。
void va_copy(va_list dest, va_list src):  dest，src的类型都是va_list，va_copy()用于复制参数列表指针，将dest初始化为src。
# 拷贝ap, 依赖src来自 va_start，va_copy

va_start va_arg va_copy va_end 依赖 va_list 类型；
va_arg va_copy va_end 依赖 va_start。
va_start 和 va_copy 依赖va_end给参数结尾

va_list aq = ap;              # 有些系统
va_list aq; *aq = *ap;        # 用些系统
va_list aq; va_copy(aq, ap)   # C99 才定义该函数 (统一系统之间差异)

1. 调用vxxprintf类型函数
1.1 直接调用vxxprintf类型函数
[redis] sdscatvprintf(sds s, const char *fmt, va_list ap) 格式化字符串 实现 sds sdscatprintf(sds s, const char *fmt, ...) 
    va_copy(cpy,ap);
    vsnprintf(buf, buflen, fmt, cpy);
    va_end(cpy); 
[redis] anetSetError(char *err, const char *fmt, ...) 错误提示输出
    va_start(ap, fmt);
    vsnprintf(err, ANET_ERR_LEN, fmt, ap);
    va_end(ap);
[redis] _serverPanic(const char *file, int line, const char *msg, ...) panic
    va_start(ap,msg);
    char fmtmsg[256];
    vsnprintf(fmtmsg,sizeof(fmtmsg),msg,ap);
    va_end(ap);
[moosefs] 实现 changelog 功能，即操作日志
    va_start(ap,format);
    leng = vsnprintf(printbuff,MAXLOGLINESIZE,format,ap);
    va_end(ap);
[moosefs] 实现 oplog 功能，即操作日志
    va_start(ap,format);
    leng += vsnprintf(buff+leng,LINELENG-leng,format,ap);
    va_end(ap); 
# 日志输出 moosefs(changelog和oplog)，错误提示(redis anetSetError)，panic(redis _serverPanic), debug(moosefs mfsdebug)
# 字符串连接 (redis sdscatvprintf)
[moosefs] static void mfsdebug(const char *format,...) 通过 format 指示: 打开文件，关闭文件和输出日志到文件
    va_start(ap,format);
    vfprintf(fd,format,ap);
    va_end(ap);
    
2.1 间接调用 vsnprintf(buf, buflen, fmt, cpy);
[redis] module.c  RM_Log(RedisModuleCtx *ctx, const char *levelstr, const char *fmt, ...) 错误输出
    va_start(ap, fmt);
    RM_LogRaw(ctx->module,levelstr,fmt,ap);
    va_end(ap);
[redis] module.c  RM_LogIOError(RedisModuleIO *io, const char *levelstr, const char *fmt, ...) 错误系统调用
    va_start(ap, fmt);
    RM_LogRaw(io->type->module,levelstr,fmt,ap);
    va_end(ap);
# 模块错误日志(RM_Log) 和模块 IO调用错误(RM_LogIOError)

2. 设定可变参数个数 # 可以通过数组达到同样效果
[redis] rewriteClientCommandVector(client *c, int argc, ...) 
    va_start(ap,argc);
    for (j = 0; j < argc; j++) {
        a = va_arg(ap, robj*);
    }
    va_end(ap);
    
3. 指定可变参数结尾 # 
[redis] *sendSynchronousCommand(int flags, int fd, ...) 
    va_start(ap,fd);
    while(1) {
        arg = va_arg(ap, char*);
        if (arg == NULL) break;
    }
    va_end(ap);
[syscall]
    int execl(const char *path, const char *arg, ...);
    int execlp(const char *file, const char *arg, ...);
    int execle(const char *path, const char *arg, ..., char * const envp[])

4. 重新定义fmt 参数格式化 方法
sdscatfmt(sds s, char const *fmt, ...)                                        # redis 的sds
const char *luaO_pushvfstring (lua_State *L, const char *fmt, va_list argp)   # lua   的LObject
sdscatfmt          是满足特定形式协议的格式化方式
luaO_pushvfstring  满足lua语言中zero-terminated string、an int as a character、an int、a lua_Integer、a lua_Number、a lua_Number、a pointer

6. 类似fmt定义方式，指定可变参数类型
5. 固定参数决定可选参数存在性和类型 
[moosefs]  mfsio.c # int mfs_open(const char *path,int oflag,...)
int open(const char *pathname, int flags);
int open(const char *pathname, int flags, mode_t mode);
    va_start(ap,oflag);
    mode = va_arg(ap,int);
    va_end(ap);

va_start 和 va_copy
T StringBuffer_append(T S, const char *s, ...)         # ap变量的初始化和释放
  va_list ap;
  va_start(ap, s);      # va_start
  _append(S, s, ap);
  va_end(ap);
T StringBuffer_vappend(T S, const char *s, va_list ap) # ap_copy变量的初始化和释放
  va_list ap_copy;
  va_copy(ap_copy, ap); # va_copy
  _append(S, s, ap);
  va_end(ap);
StringBuffer_T Util_printRule(StringBuffer_T buf, EventAction_T action, const char *rule, ...) 调用了StringBuffer_vappend
void Command_vSetEnv(T C, const char *name, const char *value, ...) 调用了StringBuffer_vappend

char *Str_vcat(const char *s, va_list ap) 
  va_list ap_copy;
  va_copy(ap_copy, ap);
  int size = vsnprintf(t, 0, s, ap_copy) + 1;
  va_end(ap_copy);
  t = ALLOC(size);
  va_copy(ap_copy, ap);
  vsnprintf(t, size, s, ap_copy);
  va_end(ap_copy);
char *Str_cat(const char *s, ...)           调用了Str_vcat
int Socket_print(T S, const char *m, ...)   调用了Str_vcat
void _send(T S, const char *data, ...) SMTP 调用了Str_vcat
void send_error(HttpRequest req, HttpResponse res, int code, const char *msg, ...)   调用了Str_vcat
void set_header(HttpResponse res, const char *name, const char *value, ...)          调用了Str_vcat
void Event_post(Service_T service, long id, State_Type state, EventAction_T action, char *s, ...) 调用了Str_vcat
_formatStatus(const char *name, Event_Type errorType, Output_Type type, HttpResponse res, Service_T s, boolean_t validValue, const char *value, ...) 

# 双层设计
void serverLog(int level, const char *fmt, ...); # 可变参数 处理 ap_list 和 ...
void serverLogRaw(int level, const char *msg);   # 固定参数 level 控制优先级和(时标,pid和进程名)内容。
serverLogRaw在 vsnprintf 之后调用
# 双层设计
void LogEmergency(const char *s, ...) # Emergency Alert Critical Error Warning Notice Info Debug 
void log_log(int priority, const char *s, va_list ap) # 固定参数 priority控制优先级。初始化时指定输出地
支持 LogEmergency(const char *s, ...) 和 vLogEmergency(const char *s, va_list ap) 两种调用方式。


get8bit get16bit get32bit get64bit  
put8bit put16bit put32bit put64bit
上述函数和va_arg之间存在类似性。

redis中adlist 和 dict 都有迭代器的实现
}
moosefs(断言@协议){ 指针 线程 errno值
@协议
# 断言格式   : 对前面输出进一步描述，缩小了搜索范围
#              assertion failed 或者 failed assertion 表明断言失败; 用来分割程序描述和自描述部分
syslog(LOG_ERR,"%s:%u - failed assertion '%s', error: %s",__FILE__,__LINE__,#e,_mfs_errorstring);
              # 文件名:行名 - failed assertion 提示信息，error:错误原因
syslog(LOG_ERR,"%s:%u - failed assertion '%s' : %s",__FILE__,__LINE__,#e,(msg))
              # 文件名:行名 - failed assertion 提示信息:错误描述
@断言集
assert： 
  passert：malloc           # passert(ptr)    #ptr            __FILE__ __LINE__  pointer assert       (malloc strdup)
  eassert：pipe(read|write) # eassert(e)      errno 值 + #e   __FILE__ __LINE__  extra errno assert   (pipe write && read)
  sassert: (条件判断)       # sassert(e)      #e              __FILE__ __LINE__  simple assert        (macro and status judge)
  massert: (条件判断)       # massert(e,msg)  #e + msg        __FILE__ __LINE__  message assert       (multi judge then it is difficult to understand)
  zassert：pthread          # zassert(e)      errno 值 + #e   __FILE__ __LINE__  zero errno message   (pthread_xxx)
在toybox和busybox中，通过在系统调用函数名前添加"x"来约定系统调用失败就abort。
}
redis(断言@协议){ client以及关联对象robj
@协议
格式1
=== ASSERTION FAILED ===
==> $file:$line '$estr' is not true
格式2
!!! Software Failure. Press left mouse button to continue
Guru Meditation: fmtmsg #$file:$line

@断言集 
绑定特定类型(client, robj)的退出策略，退出条件即退出描述
#define serverAssertWithInfo(_c,_o,_e) ((_e)?(void)0 : (_serverAssertWithInfo(_c,_o,#_e,__FILE__,__LINE__),_exit(1)))
退出条件即退出描述
#define serverAssert(_e) ((_e)?(void)0 : (_serverAssert(#_e,__FILE__,__LINE__),_exit(1)))
不提供退出条件，只提供退出描述
#define serverPanic(...) _serverPanic(__FILE__,__LINE__,__VA_ARGS__),_exit(1)
}
monit(断言@协议){ 只有moosefs提供了massert方式
@协议
"AssertException: " #e \" at %s:%d\naborting..\n 
断言和异常具有很强关联性

@断言集 
退出条件即退出描述
#define ASSERT(e) do { if (!(e)) { LogCritical("AssertException: " #e \
" at %s:%d\naborting..\n", __FILE__, __LINE__); abort(); } } while (0)
}
moosefs(日志特殊方式){
ERROR_STRINGS # 可以将该值赋值 const char* errtab[]={ERROR_STRINGS};          -- 顺序
#define ERROR_STRINGS \
	"OK", \
	"Operation not permitted"

EATTR_STRINGS # const char* eattrtab[EATTR_BITS]={EATTR_STRINGS}; -- 按位
#define EATTR_STRINGS \       
	"noowner", \
	"noattrcache", \
	"noentrycache", \
	"nodatacache"
EATTR_DESCRIPTIONS # const char* eattrdesc[EATTR_BITS]={EATTR_DESCRIPTIONS}; -- 按位
#define EATTR_DESCRIPTIONS \ 
	"every user (except root) sees object as his (her) own", \
	"prevent standard object attributes from being stored in kernel cache", \
	"prevent directory entries from being stored in kernel cache", \
	"prevent file data from being kept in kernel cache"
    
#include "commands.h"  # 文件中内容      -- 乱序
{ANTOAN_NOP,"ANTOAN_NOP"},
{ANTOAN_UNKNOWN_COMMAND,"ANTOAN_UNKNOWN_COMMAND"},

struct _mfscmd {       # 导入程序中
	uint32_t command;
	const char *commandstr;
} cmdtab[]={
#include "commands.h"
	{0,NULL}};

"-kMGTPE"[scale] # 计算后顺序
}

toybox(日志特殊方式){

#define SIGNIFY(x) {SIG##x, #x}
static struct signame signames[] = {
  SIGNIFY(ABRT), SIGNIFY(ALRM), SIGNIFY(BUS),
  SIGNIFY(FPE), SIGNIFY(HUP), SIGNIFY(ILL), SIGNIFY(INT), SIGNIFY(KILL),
  SIGNIFY(PIPE), SIGNIFY(QUIT), SIGNIFY(SEGV), SIGNIFY(TERM),
  SIGNIFY(USR1), SIGNIFY(USR2), SIGNIFY(SYS), SIGNIFY(TRAP),
  SIGNIFY(VTALRM), SIGNIFY(XCPU), SIGNIFY(XFSZ),

  // Start of non-terminal signals

  SIGNIFY(CHLD), SIGNIFY(CONT), SIGNIFY(STOP), SIGNIFY(TSTP),
  SIGNIFY(TTIN), SIGNIFY(TTOU), SIGNIFY(URG)
};

char *act_name = "sysinit\0wait\0once\0respawn\0askfirst\0ctrlaltdel\0"
                "shutdown\0restart\0";
for (tmp = act_name, i = 0; *tmp; i++, tmp += strlen(tmp) +1)     
}
lrwx------. 1 root root 64 Jul 10 13:31 0 -> /dev/pts/0
l-wx------. 1 root root 64 Jul 10 13:31 1 -> /root/redis-3.0-annotated-unstable/tests/tmp/server.12224.18/stdout
l-wx------. 1 root root 64 Jul 10 13:30 2 -> /root/redis-3.0-annotated-unstable/tests/tmp/server.12224.18/stderr
redis(日志){ -- 前后台集中输出
1. redisLogRaw(int level, const char *msg)   很少用；在一些先sprintf格式字符串的地方使用
2. redisLog(int level, const char *fmt, ...) 基本都用该函数

1. LOG_NOTICE 提示作用，一般不会伴随REDIS_ERR这样的退出；          状态提示，自动修复
      状态切换提示；
   REDIS_WARNING提示作用，常常伴随着REDIS_ERR|exit(1)这样的退出；  局部错误，不能修正
      配置更改；
      网络连接断链和重连； read|wrrite|accept系统调用错误
      系统调用错误；

1. 内容组织：
  比较随意：Fatal Unable Unexpected  Unknown Unrecoverable  
            Failed error Bad lost
            too long
            
assert
redisAssertWithInfo(_c,_o,_e) # 处理特定客户端失败；c为客户端内容，o要输出对象，e为断言
redisAssert(_e)               # 断言失败；输出断言失败内容
redisPanic(_e)                # 打印导致panic字符串
                   接收到不能处理的命令；
                   基本添加fd，添加定时任务失败；
                   系统配置存在问题
}
moosefs(层次相同的函数放在一个文件中；功能相同的函数放在一个文件中){
编写函数是为了把大一些的概念拆分为另一个抽象层上的一系列步骤。
    每个函数一个抽象层次
        函数分为不同的抽象层次
        函数中混杂不同抽象层次，往往让人迷惑
        
}
moosefs(规避标志参数){}
moosefs(禁止把布尔值传入函数){}
moosefs(参数名，最好和函数名有联系){}
moosefs(让相似的代码看上去相似-不重复){
conncache.c                                         conncache功能
freehead 单链表(空闲节点头)                         空闲节点+链表头
lruhead  lrutail 双向链表(老化节点头 老化节点尾)    老化节点+(链表头|链表尾)
    lrunext lruprev
conncachetab 连接缓存数组头                         conncache功能 + tab表
conncachehash 连接缓存哈希表头                      conncache功能 + hash表
    hashnext hashprev
    
CONN_CACHE_HASHSIZE   CONN_CACHE功能  HASHSIZE结构限定
CONN_CACHE_HASH       CONN_CACHE功能  HASH功能
                                                                 
matoclserv.c                                                     ma(master)tocl(client)serv(serve) 功能缩略
matoclserventry核心数据结构                                      matoclserventry 功能缩略+结构说明
out_packetstruct，in_packetstruct，matoclserventry重要数据结构   out(in)功能 + packet 功能 + struct结构说明
ListenHost ListenPort 全局变量 
CHUNKHASHSIZE CHUNKHASH MaxPacketSize 宏定义
}

1. MasterHost 来自配置文件
2. reconnect_hook 模块内static
3. IJ_GET_CHUNK_CHECKSUM 全大写 宏|枚举
4. masterconn_getmasterip 外部接口

moosefs(变量命名){
[pcqueue]
queue   q que {  head tail elements size maxsize freewaiting fullwaiting closed waitfree waitfull lock }
qentry  qe qen { id op data leng next }
r ret return
queue_new queue_delete queue_close queue_isempty queue_isfull queue_elements queue_sizeleft queue_put queue_tryput queue_get queue_tryget

[bgjob]
jobpool {rpipe,wpipe, fdpdescpos, workers_max, workers_himark, workers_lomark, workers_max_idle, workers_avail, workers_total
        workers_term_waiting worker_term_cond pipelock jobslock jobqueue statusqueue jobhash nextjobid}
        jp globalpool 
job     { jobid callback extra args jstate next } jptr  jhandle 
worker  { threadid jp } w 

exiting stats_maxjobscnt maxjobscnt last_maxjobscnt status{ job_send_status job_receive_status } qstatus lastnotify 
jhpos res(r ret) ptr(uint8_t*) pdesc ndesc pos jobscnt hlstatus load 
job_stats job_getload job_send_status job_receive_status job_worker job_spawn_worker job_close_worker, job_new
job_desc job_serve job_pool_check_jobs job_heavyload_test job_wantexit job_canexit job_term job_reload job_init

main_destruct_register   job_term
main_wantexit_register   job_wantexit
main_canexit_register    job_canexit
main_reload_register     job_reload
main_eachloop_register   job_heavyload_test
main_poll_register       job_desc,job_serve

DISABLED, ENABLED, INPROCESS
chunk_op_args { chunkid, copychunkid, version, newversion, copyversion, length }
              opargs
chunk_rw_args { sock, packet, length  }
              rwargs
chunk_rp_args { chunkid, version, xormasks, srccnt }
              rpargs
chunk_ij_args { chunkid, version, pointer }
              ijargs
              
[masterconn]
idlejob { jobid op valid chunkid version next prev buff }  idlejobs ijp ij
out_packetstruct { next startptr byteleft conncnt data } outputhead outputtail opptr opaptr outpacket opack
in_packetstruct { next type length data }  input_packet inputhead inputtail ipptr ipaptr ipack
masterconn { mode sock pdescpos lastread lastwrite input_hdr input_startptr input_bytesleft input_end 
         input_packet inputhead inputtail outputhead outputtail masterversion conncnt bindip masterip masterport 
         timeout masteraddrvalid registerstate new_register_mode hlstatus}
         masterconnsingleton eptr
reconnect_hook csidvalid manager_time_hook

fd rptr ret csidvalid csid 
masterconn_initcsid masterconn_getcsid masterconn_setcsid 
conncnt conntime reconnect_hook connection tcpnumconnect connected connecting ReconnectionDelay 
masterconn_initconnect masterconn_connecttest masterconn_disconnection_check masterconn_reconnect
masterconn_create masterconn_delete 
labelmask labelsstr masterconn_parselabels masterconn_sendlabels

masterconn_delete_packet masterconn_attach_packet masterconn_get_packet_data
masterconn_create_detached_packet masterconn_create_attached_packet 

usedspace,totalspace,chunkcount,tdusedspace,tdtotalspace,tdchunkcount

myport masterport hostport mport port MasterHost,MasterPort
}

codecomplete(){
1. 把限定词加到名字的最后
Total、Sum、Average、Max、Min、Record、String、Pointer
begin/end
first/last
locked/unlocked
min/max
next/previous
new/old
opened/closed
visible/invisible
source/target
source/destination
up/down

enum ReportType{ ReportType_Daily, ReportType_Monthly, ReportType_Quarterly, ReportType_Annual, ReportType_All };
Month Month_January Month_February ... Month_December
Planet Planet_Earth Planet_Mars Planet_Venus 
e_Color，e_Planet ， e_Month

done error found success ok ->  notFound、notdone 以及 notSuccessful 
                            ->  isFound   isDone       isSuccessful
                            
# 区分变量名和子程序名字 
本书所采用的命名规则要求变量名和对象名以小写字母开始，子程序名字以大写字母开始：variableName 对 RoutineName()。
# 区分类和对象 
方案1：通过大写字母开头区分类型和变量
Widget widget;
LongerWidget longerWidget;
方案2：通过全部大写区分类型和变量
WIDGET widget;
LONGERWIDGET longerWidget;
方案3：通过给类型加 "t_" 前缀区分类型和变量
t_Widget Widget;
t_LongerWidget LongerWidget;
方案4：通过给变量加 "a" 前缀区分类型和变量
Widget aWidget;
LongerWidget aLongerWidget;
方案5：通过对变量采用更明确的名字区分类型和变量
Widget employeeWidget;
LongerWidget fullEmployeeLongerWidget;

}
readablecode(){
send	deliver、dispatch、announce、distribute、route
find	search、extract、locate、recover
start	launch、create、begin、open
make	create、set up、build、generate、compose、add、new

min、max begin end 
is can shoud has 
}
moosefs(数据结构){
[threc]
1. 线程唯一标识符 # 一个线程只会关联一个 threc 实例
thid;
  2.  数据保护和等待-通知条件变量 # 线程间通信的方式，mutex用于保护数据，cond用于等待-通知，条件变量依赖执行过程中的状态值,
  mutex;
  cond;
  2.1 条件变量 关联的 状态值      # 数据处理过程中关键点，条件变量依赖这些关键点。
  sent;       // packet was sent
  status;     // receive status
  rcvd;       // packet was received
  waiting;    // thread is waiting for answer
3. 发送缓冲区 和 接收缓冲区 # 待处理的业务数据，内在不会变化的几个字段
obuff;
obuffsize;
odataleng;
ibuff;
ibuffsize;
idataleng;
  4. 接收命令标识值  # 协议中约定字段。
  rcvd_cmd;
  5. threc唯一标识id # 协议中约定字段。
  packetid;   // thread number
6. threc链表
struct _threc *next; # threc 数据管理方式

[masterconn]
1. socket 关联变量, mode字段标识连接状态。
mode; # FREE,CONNECTING,DATA,KILL,CLOSE, 1.FREE,CONNECTING 初始化过程，2.DATA数据交互过程，3.KILL,CLOSE 连接断链过程。
sock; # 数据接收发送
pdescpos; # sock在全局变量pdesc中的位置

2. 数据报文状态 
lastread,lastwrite; # TCP连接-心跳维护
timeout;
2.1 接收处理
2.1.1 临时缓存报文头key-length
input_hdr[8];
*input_startptr;
input_bytesleft;
input_end; # 由于 协议错误(长度不正确), 系统调用错误(连接断开，连接异常), POLLERR|POLLHUP 使得连接应当结束。
2.1.2 临时缓存报文内容 # 包括已解析的 key-length 和 length所指定的长度
in_packetstruct *input_packet;
2.1.3 待处理数据报文缓存 # 临时报文在 masterconn_read中生成，临时由 input_packet 指向，在 masterconn_gotpacket 中处理后释放
in_packetstruct *inputhead,**inputtail;
2.2 待发送处理数据报文缓存 # 在 masterconn_gotpacket 关联的处理函数中生成，在 masterconn_write 中释放
out_packetstruct *outputhead,**outputtail;

3. 连接状态
1.2 创建socket所依赖的参数，本地绑定ip，连接远端的ip和port
conncnt; # 重连次数
bindip;
masterip;
masterport;
masteraddrvalid; # 标识masterip, masterport, bindip 在 masterconn_initconnect()调用中是否需要重新被解析。
3.1 TCP连接层以上的处理过程和状态 # UNREGISTERED->INPROGRESS->REGISTERED 此后即可上报状态和处理请求
masterversion; # mfsmaster版本信息
registerstate; # UNREGISTERED,WAITING,INPROGRESS,REGISTERED, UNREGISTERED未注册，WAITING等待中，INPROGRESS上报chunk中，REGISTERED已注册
new_register_mode; # 重新注册模式
hlstatus; # heavyload 负载状态

}
moosefs(IO处理相关模块接口){
[sockets.c]
1. API极简且完备              # sockets.c将IO处理划分成：字符串与数字；udp和tcp,unix；客户端和服务器端三个角度进行API抽象
2. 语义清晰简单               # sockets.c将sockaddr_in结构，分成直接数字配置和getaddrinfo封装两种方式，实现客户端和服务器两种构造方法
3. 符合直觉                   # sockets.c将send recv和connect封装成streamtoread，streamtowrite，tcpstrtoconnect，tcpnumtoconnect，使得非阻塞IO超时读取；
                              # 成功返回0，失败返回-1；重试返回-1，且errno等于ETIMEDOUT。
                              # streamtoaccept阻塞在客户端可读；streamaccept不阻塞在客户端可读。成功返回0，失败返回-1；重试返回-1，且errno等于ETIMEDOUT。
4. 易于记忆                   # tcp|udp|unix表明连接类型，to表明是否会被阻塞，str表明字符串作为输入，num表明数字作为输入，stream表明流处理
5. 引导API使用者写出可读代码  # 用较少的单词，组合出准确, 合理的API集合。

紧凑性： 从层次上，很紧凑；从地址管理(数字型|字符串型，客户端|服务器)，socket管理(udp|tcp|unix)，到流处理->(tcp流和unix流)和数据包处理。
正交性： 超时阻塞处理是正交的，非阻塞处理是不正交的，与各个模块之间存在read和write交叉重叠的地方；
STOP原则：阻塞单点，非阻塞多点。
解决一个定义明确的问题：很好解决了地址和socket问题，同时实现非阻塞read和write阻塞化转换。
---------  接口设计思路 --------- moosefs vs redis
moosefs以简单数据类型为中心设计接口，当输入为字符串时，尽量向简单数据类型转换。
redis以字符串为中心设计接口，输出参数尽量向字符串类型转换。
# 感觉moosefs接口设计更好些。

moosefs和redis都会根据输入参数屏蔽一些errno错误值，相对于moosefs依赖外部对细节进行重新判断而言，
redis通过anetSetError函数将错误值格式化出来，通知给外部。即：倾向于字符串输出，而非数值输出。
---------------------------------------
1. 地址处理函数；  sockaddrnumfill|sockaddrfill|sockresolve|sockaddrpathfill   # fill和resolve两类函数
2. socket处理函数；socknonblock|sockgetstatus|tcpsetacceptfilter
3. 流处理函数：    streamtoread|streamtowrite|streamtoforward|streamtoaccept|streamaccept
4. TCP流处理函数： tcpsetacceptfilter|tcpsocket|tcpnonblock|tcpgetstatus|tcpresolve|tcpreuseaddr
                   |tcpnodelay|tcpaccfhttp|tcpaccfdata|tcpstrbind|tcpnumbind|tcpstrconnect|tcpnumconnect
                   |tcpstrtoconnect|tcpnumtoconnect|tcpstrlisten|tcpnumlisten|tcpgetpeer|tcpgetmyaddr|tcpclose
                   |tcptoread|tcptowrite|tcptoforward|tcptoaccept|tcpaccept
5. udp处理函数：   udpsocket|udpnonblock|udpgetstatus|udpresolve|udpnumlisten|udpstrlisten|udpwrite|udpread|udpclose
6. unix流处理函数：unixsocket|unixnonblock|unixgetstatus|unixconnect|unixtoconnect|unixlisten
                   |unixtoread|unixtowrite|unixtoforward|unixtoaccept|unixaccept

1. 地址处理函数分为数值输入和字符串输入两种形式；socket处理只有非阻塞和获取对端状态两个函数；这些都是socket的基础；
   地址处理函数__fill结尾完成sockaddr_in *sa或者sockaddr_un *sa地址的填充；该方法用于socket的连接。  # 客户端
   而sockresolve则返回IP地址和端口号；该方法用于socket的端口绑定和地址绑定。                         # 服务器端
2. 流处理包含了tcp流和unix两种处理函数的核心函数。
3. tcp流控制比较复杂，在socket处理上分别包含了超时封装和简单封装两种方式。
4. udp比较简单，这里没有提供udpconnect和udptoconnect这两个函数。connect函数可以使udp类型socket接收到被拒绝的发送报文。
5. unix封装类似tcp，只是比tcp封装简单了很多，没有涉及权限的内容。

总结：
1. 对tcp的简单封装被用于实现非阻塞形式交互；对tcp的超时封装被用于实现阻塞形式交互。
2. mfsmount[mastercomm.c]使用阻塞形式的tcp网络连接；mfsmaster[matoclserv.c]使用非阻塞形式的tcp网络连接。
   阻塞与非阻塞的设置影响的是主机本身的接收和发送数据包的策略，不影响tcp连接发送情况。
3. 函数的字符串输入具有明显的const表示，增加了程序的可显性。 # redis没做到这个细节 ? 接口设计

[sockets.c]
1. 单个socket，阻塞于poll超时等待，网络处理 moosefs(socket.c) 支持TCP、UDP、Unix Socket类型。
   从注释中有：tcpread和tcpwrite，从函数封装的意义上看，意义不大；
   比较典型的是：tcpstrbind、tcpnumbind 支持数值和字符串两种类型的处理方式
   比较典型的是：tcptoforward 支持转发
--------------------------------------- 接口封转导致了使用场景的减少。
[接收streamtowrite、发送streamtoread函数分析] # read可以发现对端关闭，而write对端关闭则是SIGPIPE
# streamtowrite和streamtoread适用于，TCP在指定时间内未发送|未接收成功，都断开连接的情况。
   streamtowrite:非阻塞读写设置
   发送是在屏蔽了异常之后的阻塞发送，发送有超时时间，没有异常中断次数限制（tcpcopy有）。
        发送前超时阻塞在poll系统调用,
        返回：未完全发送指定长度数据，则返回已发送数据长度。 # recvd > 0
        返回：异常ETIMEDOUT表示发送数据超时。                # recvd == -1 通过errno判断异常原因。
        # errno == EINTR|EAGAIN 被屏蔽掉；增加了ETIMEDOUT；保留了其他异常情况。
        返回：当前socket链接断链。                           # recvd == 0
   streamtoread:非阻塞读写设置
   接收是在屏蔽了异常之后的阻塞接收，接收有超时时间，没有异常中断次数限制（tcpcopy有）。
        接收前超时阻塞在poll系统调用,
         返回：未完全接收指定长度数据，则返回已接收数据长度。 # sent > 0 
         返回：异常ETIMEDOUT表示接收数据超时。                # sent == -1 通过errno判断异常原因。
         # errno == EINTR|EAGAIN 被屏蔽掉；增加了ETIMEDOUT；保留了其他异常情况。
         
streamtowrite和streamtoread函数的遗留问题是：如果数据部分发送成功，部分还未发送，返回异常为ETIMEDOUT，
返回值为-1，不知道已发送数据长度。 # 只能：将超时且数据部分发送作为网络连接自身的失败进行处理。
--------------------------------------- 地址处理函数输出和输入都要求主机字节序
sockresolve：    [tcpresolve|udpresolve] 这些函数返回的IP地址和端口号的字节序都为主机字节序。
sockaddrnumfill：[tcpnumconnect|tcpnumtoconnect|tcpnumlisten|udpwrite|udpnumlisten]
                                         这些函数要求输入的IP地址和端口号字节序都为主机字节序。
sockaddrfill：[tcpstrbind|tcpstrconnect|tcpstrtoconnect|tcpstrlisten|udpstrlisten]
              很多情况下使用str方式就可以了，之所有num方式，是为了查看当前地址正确性。
---------------------------------------
优点：        
streamtowrite和streamtoread既能让读写阻塞在有限的时间内，又能让文件描述符应用于多路IO处理系统。
阻塞超时            尝试发送        tcp协议阻塞超时    unix协议阻塞超时
streamtoread        streamread       tcptoread         unixtoread
streamtowrite       streamwrite      tcptowrite        unixtowrite
streamtoforward                      tcptoforward      unixtoforward
streamtoaccept      streamaccept     tcptoaccept       unixtoaccept
tcpstrtoconnect     tcpstrconnect                      unixtoconnect     
tcpnumtoconnect     tcpnumconnect                      unixtoconnect   
由于udp没有拥塞控制功能，所有，udp没有阻塞超时发送这类情况。 #或许tcpread和tcpwrite这两个函数就是为了与之进行对照而设计的。
  
---------------------------------------
接收tcpread、发送tcpwrite函数分析：
阻塞读写设置(逻辑上异常退出，能处理部分数据接收、发送情况)
tcpread :  tcpwrite: 
1. 这两个函数只能用于阻塞情况读写，对于非阻塞情况没有任何意义。
2. 由于读写没有处理信号中断接收|发送这种异常，可能造成tcp接收和发送缓冲拥塞而得不到处理；或者频繁的调用poll阻塞函数。
3.  遗留问题是：如果数据部分发送成功，部分还未发送，网络连接出现问题，返回值不是返回已发送数据长度，
                而是返回值为-1，不知道已发送数据长度。接收也存在此类情况。
---------------------------------------
[matoclserv.c]
2. 多个socket，阻塞于poll不超时等待，网络处理 moosefs(matoclserv.c) 支持TCP
   matoclserv_read  非阻塞尽力读
   matoclserv_parse 对接收数据处理
   matoclserv_write 非阻塞尽力写
---------------------------------------

[moosefs dnsmasq和redis tcpcopy libevent多路IO机制之间差异]
moosefs多路IO注册处理，是以连接为对象注册，注册的是一个文件描述符或多个文件描述符的状态，
dnsmasq注册的也是。此方法多以一个或多连接为模块进行管理，且注册描述符的状态字段和系统提供的字段相同，
一般不对select、poll、epoll系统接口进行封装，正常情况下，一个进程只使用一个框架、又与信号处理、线程管理、定时器混合在一起。
moosefs和dnsmasq注册是一元对象注册：文件描述符。

redis、tcpcopy和libevent多路IO注册处理，是以读写事件问对象注册的，注册的是文件描述符以及关联的读写事件、读写事件处理函数。
一般会对select、poll、epoll系统接口进行封装，这也使得会对读写事件的系统标识符进行重新定义。
正常情况下，一般情况下，一个多路IO注册处理与信号处理、线程管理、定时器管理等功能分离设计。正常情况下，可以一个线程一个框架。
redis、tcpcopy和libevent多路IO注册处理是二元对象注册：文件描述符、读写监听标识和读写处理函数。

--------------------------------------- hddspacemgr.c 文件总结
1. API应该极简且完备 2. 语义清晰简单 3. 符合直觉 4. 易于记忆 5. 引导API使用者写出可读代码  
# 理解了就容易调用，不理解就不知道如何是好； 没有实例理解有点困难，有了实例很容易理解。
紧凑性：正交性：STOP原则： # 都设计的的不错。
---------------------------------------
[hddspacemgr.c]
在hddspacemgr.c文件中的read和write函数调用中，没有对read和write函数被EINTR中断的规避。
   比较典型的是：按照64K读写数据的逻辑处理方法学习
1. hdd_stats|hdd_op_stats|hdd_errorcounter                  # 接口操作统计信息
2. hdd_get_damaged_chunk_count|hdd_get_damaged_chunk_data   # 数据块状态统计[损坏|丢失|新加]
   hdd_get_lost_chunk_count|hdd_get_lost_chunk_data
   hdd_get_new_chunk_count|hdd_get_new_chunk_data           # 磁盘状态统计
   hdd_diskinfo_size|hdd_diskinfo_data|hdd_diskinfo_monotonic_size|hdd_diskinfo_monotonic_data
   hdd_get_chunks_begin|hdd_get_chunks_end|hdd_get_chunks_next_list_count|hdd_get_chunks_next_list_data
3. hdd_spacechanged|hdd_get_space:                          # 磁盘大小
4. hdd_open... IO操作函数；hdd_get_blocks... chunk信息； hdd_chunkop... chunk操作： # 
5. hdd_late_init | hdd_init                                 # 初始化操作
6. hdd_test_show_chunks|hdd_test_show_openedchunks          # debug设计

---------------------------------------
[common/main.c]
   框架性比较大，提供的功能也多，容易进行模块化编程，
   由于框架包括了信号处理、进程管理、超时回调函数、单实例等机制，所有不容易分离。
   main_poll_register     # 数据驱动  (内核数据缓冲区内的数据状态变化引发用户态系统调用)
   main_eachloop_register # 数据和时间驱动  (内核数据缓冲区内的数据状态变化引发以及等待超时引发调用)
   main_time_register     # 时间驱动  (周期性的执行某些调用)
   main_info_register     # 信号驱动  (外部信号触发引起进程调用处理函数)
   main_chld_register     # 信号驱动  (外部信号触发引起进程调用处理函数)
   main_reload_register   # 信号驱动  (外部信号触发引起进程调用处理函数)
   main_wantexit_register、main_canexit_register、main_destruct_register main_exit # 进程退出次第调用方法
模块自身管理数据，多客户端需要管理外部的链表。链表通过文件描述符和poll建立映射关系。

main.c对进程提供了很好的管理，但是，关于进程如何初始化部分，没有提供很好的设计方案。
当前通过init.h文件实现；文件内的RunTab和LateRunTab也可以看作"把知识叠入数据以求逻辑质朴而健壮"的一个案例。
---------------------------------------
socket.c 和 main.c，hddspacemgr.c的接口声明方法存在差异，
---------------------------------------
[mfsmaster/bio.c]
整合了socket和file IO，从这更能感到socket和File IO之间的差别；
1、 File相比socket提供了更大的数据缓冲区；
2、 socket提供了超时时间，而File没有；
3、 socket的初始化要比File要复杂的多；因此socket没有提供IP地址和端口号相关参数，而是直接提供了fd；
4、 File有postion和size的概念，而socket没有。
总结：
1. 要依赖于抽象，不要依赖于具体。接口更多提供的是抽象-统一功能，尽量把接口的实现放到底层。
2. 函数应该把被修改的全局数据或对象的字段限制在3个以内，保证整个逻辑的清晰、易懂。
---------------------------------------
[mfschunkserver/bgjobs.c]
1. #define opargs ((chunk_op_args*)(jptr->args))   # 通过宏简化代码编写，提高可读性；
2. job_spawn_worker & job_close_worker & queue_get # 动态线程池
3. 回调函数：job_inval|job_chunkop|job_serv_read... # 减少了程序之间的耦合性。
   ? 异步数据处理-> 见job_pool_check_jobs
总结：
    位于各个模块之间的胶合层，为了减少耦合使用回调函数机制。
    感觉透明性不是很好，再看下个版本情况。
---------------------------------------
mfschunkserver masterconn.c masterconn_create_detached_packet
mfschunkserver masterconn.c masterconn_create_attached_packet
mfsmetalogger  masterconn.c masterconn_createpacket
mfsmaster      matoclserv.c matoclserv_createpacket
mfsmaster      matocsserv.c matocsserv_createpacket
mfsmaster      matomlserv.c matomlserv_createpacket
总结：
    这些函数具有一样的处理流程，为何没有统一成一种处理过程? 
1. 一方面是避免模块之间的依赖关系，增加了胶合层；
2. 另一方面估计为了优化考虑，不至于修改一处而动全身；
3. 或许更具业务不同，这些函数特点不一，最后优化策略也不一样吧。
----------------------------------------

moosefs [readdata.c] [writedata.c] [matoclserv.c] [matocsserv.c] [matomlserv.c] 
双层链表，readdata.c 和 writedata.c 是 inode和数据缓冲区
双层链表，matocsserv.c matocsserv.c matomlserv.c 是 connect和packet.
主从管理对象 pcqueue.c squeue.c workers.c
单实例模块 main.c crc.c charts.c cfg.c delayrun.c md5.c memusage.c random.c

moosefs [conncache.c] 
    conncache.c 中connentry被lru链表和hash链表管理，但是，仍只有一个被管理的对象，
尽管有 conncachetab 数组，conncachehash哈希表，lruhead老化表 和freehead 空闲表 三种访问或操作的数据管理方式
    
moosefs [mfschunkserver/hddspacemgr.c]
    主要用来实现对 chunk 对象的管理，而 chunk 对象有从属于 floder. 这使得 chunk 存在于 
f->chunktab[] hash表中，存在于 f *testhead,**testtail链表和全局hashtab[HASHSIZE] 链表中。
# 使用文件描述符作为索引或许更好。
    damagedchunks 损坏节点，lostchunks 丢失节点， newchunks 新扫描所得节点， newdopchunks 操作中节点
folderhead 文件夹实例， hashtab 所有节点集合， dophashtab 后台检查节点。
}

moosefs(sanitize){

# linux gcc with address sanitizer
CC=gcc CFLAGS='-O1 -g -fsanitize=address -fno-omit-frame-pointer' LDFLAGS='-O1 -g -fsanitize=address -fno-omit-frame-pointer'

# linux gcc with thread sanitizer
CC=gcc CFLAGS='-O1 -g -fsanitize=thread -fno-omit-frame-pointer' LDFLAGS='-O1 -g -fsanitize=thread -fno-omit-frame-pointer'
}
moosefs(poll异步回调){ 将输入和输出参数设计到不同的函数中，desc等同于event_add，而serve等用于cb回调函数。
增加参数: 额外数据+回调函数
管理数据: pollfd *管理对象(数组)，pollfd *对象。
输入pollfd *对象 和 输出pollfd *对象 之间通过数组偏移，来建立关联关系。 本质是以数组偏移为索引。

void main_poll_register (void (*desc)(struct pollfd *,uint32_t *),void (*serve)(struct pollfd *)) 
void (*desc)(struct pollfd *,     # 输入参数pollfd *对象
             uint32_t *)          # 额外数据
void (*serve)(struct pollfd *)    # 输出参数

int poll(struct pollfd *fds,      # 输入输出参数
         nfds_t nfds,             # 输入参数
         int timeout);            # 输入参数
}
moosefs(init.h 数据驱动程序){
init.h 文件观感：
matomlserv_init，matocsserv_init，matoclserv_init：每种协议和功能对应一个模块。
changelog_init，rnd_init，dcm_init，exports_init，topology_init：每个功能对应一个模块。
meta_init：[labelset_init,fs_strinit,chunk_strinit,xattr_init,
            posix_acl_init,flock_init,posix_lock_init,csdb_init，sessions_init,of_init]: 
将复杂的业务进一步分离，降低init.h文件在扩展上的复杂度。

RunTab      按照模块之间的依赖关系，依次初始化每个模块。
LateRunTab  用来处理模块之间相互依赖的情况；即模块A依赖模块B，模块B依赖模块A。
            此时，需要将A模块划分为A1和A2，将B模块划分为B1和B2，初始化设计成A1->B1(在RunTab定义)->B2->A2(在LateRunTab定义)

?   可否定义一个回调函数，返回RunTab和LateRunTab，然后由main.c完成对RunTab和LateRunTab函数内函数的回调；
以实现：一个程序根据配置加载不同的模块，一个程序根据配置执行不同的功能(mfsmaster,mfschunkserver,mfsmetalogger).
?    或许通过命令行参数也可以配置一个程序内部不同模块的执行。

?    从编译层次定义一个程序应该包含哪些模块，这个应该是更好的实现；关键是如何划分模块化命令行参数？
Make -DRTUD
Make -DHOSTD[-DOTDRD|-DSLOTD|-DSORD]... ...

网络的不稳定性处理：
1. 无线环境是不稳定的，为了保证数据的完整性，只能提供数据确认报文，才能保证数据完整可靠
2. 长连接在长时间没有数据包的情况下会处于假连接状态，对于这种连接，只能通过心跳以保证连接实时性。
}

moosefs(cfg.c){
1. API应该极简且完备 2. 语义清晰简单 3. 符合直觉 4. 易于记忆  5. 引导API使用者写出可读代码  # 这点不存在
紧凑性： 正交性： STOP原则： # 符合。
 
1. cfg_load，cfg_reload  # 构建
2. cfg_isdefined         # 调用
3. cfg_term              # 析构
--------- 调用函数的分类实现 ---------
cfg_getuint64 cfg_getuint32 cfg_getuint16 cfg_getuint8
cfg_getint64  cfg_getint32 cfg_getint16 cfg_getint8
cfg_getdouble cfg_getstr

strtol(cfg_getint32 cfg_getint16 cfg_getint8)
strtoul(cfg_getuint32 cfg_getuint16 cfg_getuint8)
strtoll(cfg_getint64)
strtoull(cfg_getuint64)
strtod(cfg_getdouble)
strdup(cfg_getstr)
---------------------------------------
#define _CONFIG_MAKE_PROTOTYPE(fname,type) 
type cfg_get##fname(const char *name,type def)
#define _CONFIG_GEN_FUNCTION(fname,type,convname,format)
type cfg_get##fname(const char *name,type def) 
模块的精华就在这两个宏定义，使用宏：将不同类型的输出需求抽象成统一的过程。有点C++多态的的感觉，却比多态清晰透明。
---------------------------------------

配置文件
1. 一套默认的配置参数，这些参数被固化到代码中。
2. 能够通过接口输出进程运行过程中，进程当前的配置。
3. 能够在进程运行中，通过处理SIGHUP信号，更新进程运行配置
---------------------------------------
4. 能够在进程运行中，通过接口修改进行当前的配置信息，
5. 能够检验配置文件内配置的合法性。
}

moosefs(bucktes.h){
1. API应该极简且完备 
2. 语义清晰简单 3. 符合直觉 4. 易于记忆  5. 引导API使用者写出可读代码  # 这些点不存在
紧凑性： 正交性： STOP原则： # 符合。
------------------------------------------------------------------------------- 清晰和可显性不佳
# 宏定义函数
CREATE_BUCKET_ALLOCATOR(freenode,freenode,5000)
CREATE_BUCKET_ALLOCATOR(quotanode,quotanode,500)
CREATE_BUCKET_ALLOCATOR(slist,slist,5000)

CREATE_BUCKET_ALLOCATOR(chunk,chunk,20000) # 构建
chunk_malloc();                            # 调用
chunk_getusage();                          # 调用
chunk_free                                 # 调用
chunk_free_all();                          # 析构

cfg.c和cfg.h中是宏定义处理过程。核心是将多个相同的处理过程通过宏的"##"功能，实现处理过程的内在统一。
buckets.h中是宏定义接口函数。核心是将多个相同的处理过程通过宏的"##"功能，达到抽象数据操作接口的实现。
# 使用相同的功能，达到不同的目的。

扩展见libevent中的tree。
}

moosefs(clocks.c){
double monotonic_seconds();      # 秒
uint64_t monotonic_useconds();   # 微秒
uint64_t monotonic_nseconds();   # 纳秒
const char* monotonic_method();  # 获取方法
uint32_t monotonic_speed();      # 系统时钟速度
---------------------------------------
man clock_gettime 中查询AVAILABILITY段落中的CLOCK_MONOTONIC... ... 
HAVE_GETTIMEOFDAY 这个是通过 autoconf和automake进行系统判别实现的。
}

moosefs(stats 以及cii){ 关注相同点提高重用能力；关注差异性提高设计能力。
moosefs模块和cii模块的相似点
1. 抽象数据类型 : 模块内部不暴露如何实现，模块对外返回void类型指针，外部使用void类型指针对模块内数据进行管理。
2. 抽象api接口设计 : api接口管理void类型指针数据的生命周期，同时api接口封装参数之间的关系；
3. 注重资源生命周期管理: 同时设计xxx_init函数和xxx_term函数。如果模块内数据结构不需要初始化，则可以没有xxx_init函数。
4. moosefs模块以C语言基本数据类型为模块参数集。基本使用结构体型参数。

moosefs模块和cii模块的不同点；
1. 功能差异性: moosefs围绕业务功能需求而设计，强调接口重用。
               cii围绕stack，环，链表，table和set，seq等抽象机制设计，强调机制重用。
2. 重用性差异: moosefs模块以业务功能设计api，规范接口隐藏实现，强调接口必要性。
               cii围绕stack,ring,link,table和set,seq机制设计接口，强调接口完备性和机制复用性。
3. 生命周期差异: moosefs模块生命周期是模块化级别；强调模块初始化-接口调用-模块注销。
                 cii生命周期管理是stack,ring,link,table和seq,set抽象对象级别的。强调stack实例创建-接口调用-stack实例删除
4. 对多线程而言: moosefs在模块内关注多线程影响；cii未提供多线程级别接口设计。
5. 正交性差异:  moosefs的conncache.c使用数组，空闲链表，lru链表和哈希表4种正交性策略实现快速遍历，重复利用，随机老化和快速查找
                cii提供了各种策略，每种策略实现一种管理结构。
}
moosefs(stats){ 用以管理各种操作的统计信息
stats.c (核心部分) masterconn.c negentrycache.c symlinkcache.c mfs_fuse.c 依赖stats.c文件提供的树形管理方法
void* stats_get_subnode(void *node,const char *name,uint8_t absolute,uint8_t printflag) 注册一个包含统计信息的节点
                           NULL和字符串        名称         非递归累加       输出标识
stats_counter_add(void *node,uint64_t delta) 增加delta
stats_counter_sub(void *node,uint64_t delta) 减少delta
stats_counter_inc(void *node) 增加1
stats_counter_dec(void *node) 减少1
stats_reset(statsnode *n)     重置n
stats_reset_all(void)         重置所有
stats_show_all(char **buff,uint32_t *leng)  输出所有
stats_term(void)              结束

树形结构
NULL(head) - master 统计mfsmount的接收、发送数据包量；mfsmount的接收、发送数据字节量和重连次数
            |-- packets_received
            |-- packets_sent
            |-- bytes_received
            |-- bytes_sent
            |-- reconnects
           |- negentry_cache 统计negentry缓存的插入个数，查找命中个数，查找不命中个数和使用量
            |-- inserts
            |-- removals
            |-- search_hits
            |-- search_misses
            |-- #entries
           |- symlink_cache 统计symlink缓存的插入个数，查找命中个数，查找不命中个数和使用量
            |-- inserts
            |-- search_hits
            |-- search_misses
            |-- #links
           |- fuse_ops 统计mfsmouont文件系统操作的次数
            |-- setxattr 
            |-- getxattr 
            |-- listxattr 
            |-- removexattr
            |-- flock 或者 getlk setlk
            |-- fsync flush write read release open create releasedir readdir opendir link rename 
            |-- readlink
               |---- master cached
            |-- lookup
               |---- cached
                    |------ readdir
                    |------ negative
               |---- master
                    |------ positive
                    |------ negative
                    |------ error
               |---- internal
            |-- access
            |-- statfs
            |-- readdir
              |---- with_attrs
              |---- without_attrs
masterconn.c (master.packets_received master.packets_sent master.bytes_received master.bytes_sent master.reconnects )
negentrycache.c (negentry_cache.inserts negentry_cache.removals negentry_cache.search_hits negentry_cache.search_misses negentry_cache.#entries)
symlinkcache.c (symlink_cache.inserts symlink_cache.search_hits symlink_cache.search_misses symlink_cache.#links)
mfs_fuse.c (fuse_ops)
setxattr getxattr listxattr removexattr
flock 或者 getlk setlk
fsync flush write read release open create releasedir readdir opendir link rename 
readlink (fuse_ops.readlink )master cached
symlink rmdir mkdir unlink mknod setattr getattr getattr-cached
lookup (fuse_ops.lookup)cached (fuse_ops.lookup.master)master internal positive negative error (fuse_ops.lookup.cached)readdir negative
access statfs readdir (fuse_ops.readdir)with_attrs without_attrs
}
moosefs(chunkloccache老化){ 用以缓存inode chunk pos对应位置的数据缓存；
func. 插入
1. 如果存在inode和pos相同的节点，则直接替换；
2. 如果不存在inode和pos相同的节点，
  2.1 如果存在空闲的节点，则用该节点进行数据缓存
  2.2 否则老化掉时间最老节点的数据缓存，缓存输入节点数据。
}

moosefs(symlinkcache老化){ 用以缓存inode对应位置的path路径名；
func. 插入
1. 如果存在inode相同的节点，则直接替换；
2. 如果不存在inode相同的节点，
  2.1 如果存在空闲的节点，则用该节点进行数据缓存
  2.2 否则老化掉时间最老节点的数据缓存，缓存输入节点数据。

func. 查找
1. 查到时，如果存在inode相同的节点
  1.1 如果缓存时间超过86400秒(一天时间)，则直接删除，并表示查询失败。
  1.2 如果缓存时间未超过86400秒(一天时间)，则返回inode对应的path，并表示查询成功。
2. 未查到时，返回查询失败。
}

moosefs(negentrycache老化){
func. 插入
1. 如果存在inode相同的节点，且节点的名称也长度相等，则更新时间；
2. 如果不存在inode和name都不相同的节点；
  2.1 如果存在空闲的节点，则用该节点进行数据缓存
  2.2 否则老化掉时间最老节点的数据缓存，缓存输入节点数据。

func. 查找(行超时时间老化)
1. 查找时，如果缓存时间超过设定缓存时间，或者，设置了清除缓存，则直接删除
2. 查到时，遍历当前节区后返回。

func. 删除(行超时时间老化)
1. 如果存在inode相同的节点，且节点的名称也长度相等，则删除；
2. 查找时，如果缓存时间超过设定缓存时间，或者，设置了清除缓存，则直接删除
}
moosefs(xattrcache老化+引用计数){
1. 支持引用计数，即 xattr_cache_set设置引用计数为1，xattr_cache_get增加引用计数，xattr_cache_rel减少引用计数，xattr_cache_del减少引用计数并判断是否需要删除
2. 支持老化，节点按照lru从尾部追加，从头部删除(从头遍历时，依次是递新的节点)，没有数量限制的老化，依赖时间超时进行老化。
   每次获取时，遍历链表，对链表进行一次老化处理。并增加引用计数，在使用完毕后调用xattr_cache_rel减少引用计数。

void* xattr_cache_get(uint32_t node,uint32_t uid,uint32_t gid,uint32_t nleng,const uint8_t *name,const uint8_t **value,uint32_t *vleng,int *status);
void xattr_cache_set(uint32_t node,uint32_t uid,uint32_t gid,uint32_t nleng,const uint8_t *name,const uint8_t *value,uint32_t vleng,int status);
void xattr_cache_del(uint32_t node,uint32_t nleng,const uint8_t *name);
void xattr_cache_rel(void *vv);
void xattr_cache_init(double timeout);
}
moosefs(sharedpointer+引用计数){ 该模块和cii的模块有很多相似性。当引用计数值等于0的时候，调用freefn删除pointer指向内容
void* shp_new(void *pointer,void (*freefn)(void*));  初始化
void* shp_get(void *vs);                             获取
void shp_inc(void *vs);                              增加引用计数
void shp_dec(void *vs);                              减少引用计数
}
模块化 = 紧凑型和正交性 + SPOT 原则 + 封装和最佳模块大小
正交性: 就是设计的维度与其他维度完全隔离，一个正交的设计/值域设计，其变化绝不会受其他正交维度影响，
        也不会影响其他正交维度。
1. 把 API 设计成正交的。这样 API 有独立变化的空间的。
2. 把问题域切分清楚。问题域之间完全不相互干涉（注意跨问题域问题）。
3. 把变量、字段、列设计成正交的。这样不同业务场景下，列之间的赋值不会相互覆盖。
http://man7.org/linux/man-pages/dir_section_7.html 有很多是系统编程模式阐述

STL 采用了一种不寻常的方法，即把数据(容器)与功能(算法)分离。尽管这种方法看上去与面向对象程序设计的 精神有所违背，
但为了支持 STL 中的通用程序设计，这是必要的。正交性指导原则就要求算法和容器是独立的，(几乎)任何算法都能用于
(几乎)任何容器。

moosefs(正交化编程){
1. 正交化来源于编程模式：
socket客户端模式 TCP
socket [bind | setsockopt | getsockopt] connect [getsockname | getpeername] read write [shutdown] close
socket服务器端模式
socket bind [setsockopt | getsockopt] listen accept close
                                               |--  [setsockopt | getsockopt] [getsockname | getpeername] read write [shutdown] close
socket客户端模式 UDP
socket [bind | setsockopt | getsockopt connect] (sendto|sendmsg) (recvfrom|recvmsg) close
socket bind [setsockopt | getsockopt] listen (sendto|sendmsg) (recvfrom|recvmsg) close

本地双向管道模式 (UDP|TCP)
socketpair sv[0] (read  recv recvfrom recvmsg) (write send sendto sendmsg) close
           sv[1] (read  recv recvfrom recvmsg) (write send sendto sendmsg) close
           
sockaddr_in的管理
初始化 htons htonl | getaddrinfo(hostname,service,addrinfo *hints,addrinfo **res)


功能同参数异: read  recv recvfrom recvmsg   接口参数不同，内核接口相同
              write send sendto   sendmsg   接口参数不同，内核接口相同
              select poll epoll             接口参数不同，内核接口不同

文件操作模式:
open(creat) [read|pread] [write|pwrite] [lseek] [fstat] close

线程互斥量模式
pthread_mutex_init pthread_mutex_lock pthread_mutex_unlock pthread_mutex_destroy

线程条件变量模式
pthread_cond_init  (pthread_cond_signal|pthread_cond_broadcast) pthread_cond_destroy
                   (pthread_cond_wait)
2. 将操作系统设计的模式进行相互正交：将一种系统模式叠加到另一种系统模式中；
2.1 叠加的多个模式资源管理是同步的    ：init(模式1+模式2) op(模式1+模式2) term(模式1+模式2)
2.2 一种模式的资源管理嵌在另一种模式中：init(模式1) op(模式1+init(模式2)) op(模式1+op(模式2)) op(模式1+term(模式2)) term(模式1)
2.3 资源申请是异步的资源释放是同步的  ：init(模式1) op(模式1+init(模式2)) op(模式1+op(模式2)) term(模式1+模式2)

3. 将cii中array,stack,queue,list,table操作正交到系统模式中：
将一个或多个array,stack,queue,list,table操作叠加到系统模式中，实现对系统资源的不同管理模式。
详见：conncache，pcqueue，csdb，chunkloccache，symlinkcache，negentrycache，xattrcache
}

moosefs(cond){
1. 与条件变量绑定的变量： 
rec->mutex 用于保证rec中字段正确性，
即 sent, status, rcvd, waiting与条件变量绑定；
流程: 分配rec， rec->sent=1, rec->waiting=1, rec->rcvd=1. rec->status 说明条件变量被触发时的接收状态。
sent表示已发送；                  send调用过  # 数据已发送，接收连接异常后，需要进行发送重试，-- 已发送数据标识
rcvd表示已接收；                  recv调用过  # 发送完毕之后，发生线程切换，使得待接收线程不需要条件阻塞等待
waiting 表示已阻塞   pthread_cond_wait调用过  # 线程进入条件阻塞状态
status 表示接收状态；         threc 处理成功  # 数据已发送，接收连接异常后，需要进行发送重试，-- 数据接收状态标识
即 packetid 客户端生成表示唯一 threc 的数据包id，标识发送报文和响应报文的对应关系。 # 使得发送线程与接收线程，客户端和服务器有了对应关系
即 obuff obuffsize odataleng 发送缓冲区以及缓冲区大小和长度。 # obuffsize标识发送缓冲区长度，实现接收缓冲区的重复利用
   ibuff ibuffsize idataleng 接收缓冲区以及缓冲区大小和长度。 # ibuffsize标识接收缓冲区长度，实现接收缓冲区的重复利用
    条件状态的设置，必然会引起条件状态的判断。设置状态和判断状态位于位于通知-等待两个不同的线程中。
fs_receive_thread() 阻塞在 tcptoread()的IO阻塞类型，使用IO阻塞线程执行。fs_sendandreceive() 阻塞在 pthread_cond_wait() 条件变量
接收过程tcptoread()和发送过程tcptowrite()之间的并发性，所以，增加了sent和rcvd两个变量，用以同步接收和发送状态。
    文件描述符fd的发送和接收可以保持独立；但是fd的发送之间和接收之间需要保证互斥。
fs_receive_thread()接收线程中，tcptoread()接收数据没有被加锁 -- 接收过程在单线程中进行，不存在多线程数据接收情况。
fs_sendandreceive()和fs_sendandreceive_any() 发送数据被加锁，-- 发送过程在多线程中进行，所以对tcptowrite进行了加锁。
fs_sendandreceive() 要求响应命令类型 与 请求命令类型相同。 用于实现命令类型被指定的 请求-发送。       具体到命令类型请求应答
fs_sendandreceive_any() 只要求请求packetid 与 响应packetid 相等。用于实现命令类型不确定的 请求-发送。 命令类型不定的转发功能

2. 与条件变量绑定的变量
elements: 队列内元素个数
size    : 队列内元素代表长度和值
maxsize : 队列内元素代表长度和值，最大值
closed  : 队列调用queue_close后标识
freewaiting freewait: 队列空，阻塞接收线程中
fullwaiting fullwait: 队列满，阻塞发送线程中
lock    : 保护锁

2.1 queue_put
pthread_mutex_lock(&(q->lock)
  leng>q->maxsize                          return -1;    EDEADLK                        异常退出 : 发送数据过大，无法送
  q->closed                                return -1;    EIO                            异常退出 : 当前处于closed状态，不再接收
  q->size+leng>q->maxsize && q->closed==0  pthread_cond_wait(&(q->waitfull),&(q->lock)) 阻塞等待 : 队列内数据满，
  q->elements++;               entry个数
  q->size += leng;             entry代表长度集合
  if (q->freewaiting>0) { (pthread_cond_signal(&(q->waitfree)); q->freewaiting--; }     通知执行 : 有空闲等待的线程
pthread_mutex_unlock(&(q->lock)
附加数据： id表示操作id， op表示操作, leng数据长度;

2.2 queue_get
pthread_mutex_lock(&(q->lock)
  while (q->elements==0 && q->closed==0) q->freewaiting++; pthread_cond_wait(&(q->waitfree),&(q->lock)) 阻塞等待 : 队列内没有元素，
  if (q->closed)                       return -1; 异常退出  : 当前处于closed状态，不再阻塞
  q->elements--;
  q->size -= qe->leng;
  if (q->fullwaiting>0)  pthread_cond_signal(&(q->waitfull))  q->fullwaiting--;  通知执行 : 有阻塞等待的线程
pthread_mutex_unlock(&(q->lock)

发送阻塞等待的条件是： leng+size > maxsize 发送空间已满
接收阻塞等待的条件是： element==0          没有接收元素
两者之间的关系是: 如果size>0; 则 element 肯定大于0.
异常情况是：队列当前处于closed状态，或者，发送长度大于队列能容纳元素长度。
2.3 queue_close
q->closed 作为发送条件；
q->freewaiting>0 触发 pthread_cond_broadcast(&(q->waitfree)) q->freewaiting = 0
q->fullwaiting>0 触发 pthread_cond_broadcast(&(q->waitfull)) q->fullwaiting = 0;
总结：在初始化和释放资源之间，每次成功调用，都会牵涉条件变量关联变量的状态设置和状态判断。
      在初始化和释放资源之间，每次失败调用，都会牵涉条件变量关联变量的状态判断，但是不会状态设置。
      queue_put函数中 状态设置和状态判断 会关联queue_get函数中 状态判断和状态设置。queue_get和queue_put相同。
      queue_closed函数中 状态设置和状态判断 会关联到queue_get queue_put函数中状态判断。
      条件变量的阻塞等待条件和通知执行条件是不同的，每次调用都会修改阻塞等待条件和通知执行条件。
对于queue_put函数，阻塞等待条件是 leng+size>maxsize, 通知执行条件是 freewaiting>0
对于queue_get函数，阻塞等待条件是 element=0,         通知执行条件是 fullwaiting>0

3. 与条件变量绑定的变量
uint32_t elements;                队列内元素个数
uint32_t maxelements;             队列内元素个数 最大值
uint32_t closed;                  队列调用squeue_close后标识
pthread_cond_t waitfree,waitfull; 队列空和队列满 条件变量
pthread_mutex_t lock;             保护锁
squeue_put
  q->elements>=q->maxelements && q->closed==0    发送阻塞等待
  q->closed                       EIO            发送失败
  pthread_cond_signal(&(q->waitfree))            通知执行 : 总是执行
squeue_get
  q->elements==0 && q->closed==0                 接收阻塞等待
  q->closed                       EIO            接受失败
  pthread_cond_signal(&(q->waitfull))            通知执行 : 总是执行
总结: 
pcqueue和squeue之间比对: 
a. 相同
1. 具有类似的接口集: new delete close isempty elements isfull sizeleft put tryput get tryput。都支持阻塞和非阻塞两种模式。
2. 具有无限制队列长度方式: squeue_new(uint32_t length) 设置length为0， queue_new(uint32_t size) 设置size为0
b. 不同
1. 具有不同限制队列长度方式: queue_put(... leng) 以入参长度累积作为限制条件；squeue_put(...data) 以入参data个数作为限制条件 
2. 阻塞-执行方法不一样: queue 根据 freewaiting 和 fullwaiting 计数作为通知 消费线程和生产线程执行条件，
                       squeue 没有 freewaiting 和 fullwaiting 这样条件，直接进行 消费线程和生产线程的通知。线程的阻塞具有相似的条件
3. 通过 pthread_cond_broadcast(&(q->waitfree)) 通知接收阻塞线程结束； 通过pthread_cond_broadcast(&(q->waitfull)) 通知发送阻塞线程结束。
   pcqueue 调用waitfree是有条件的，squeue调用waitfree是无条件的，pcqueue和squeue调用 waitfull都是无条件的。

xxx_put 三种状态: 1. 添加成功， 2，添加失败，3. 阻塞等待->[添加成功 | 添加失败] # queue_put moosefs所有调用均为判断返回值
对于 size (队列长度)不限制的队列，没有添加失败的情况。
xxx_get 三种状态: 1. 添加成功， 2，添加失败，3. 阻塞等待->[添加成功 | 添加失败] # queue_get 判断data值，如果为NULL，退出执行线程
queue_get调用后，data值为NULL，不会对队列内元素进行修改。
xxx_tryput 两种状态: 1. 添加成功， 2，添加失败，
xxx_tryget 两种状态: 11. 添加成功， 2，添加失败，
    xxx_put,xxx_get,xxx_tryput,xxx_tryget,xxx_isfull,xxx_isempty,xxx_iselements有效范围是: xxx_new和xxx_close之间，
调用xxx_close之后，上述put和get调用会出错但不异常；调用xxx_delete之后上述任何函数调用都会发生异常。

squeue_close() 通知被消息队列阻塞的线程处于执行状态，且阻止线程向消息队列中追加新的元素。
               squeue_close并不会被阻塞。但是又不能立刻释放消息队列自身的资源: 即立刻调用squeue_delete()
squeue_delete() 是在被阻塞线程都关闭的情况下被调用的，在squeue_close()和squeue_delete()之间必然阻塞等待相关线程执行结束的过程。
queue_elements() 被用来统计待处理和正处理数据总数。该总数被上报给mfsmaster和传递给jobs_canexit()
queue_isempty()  在job_send_status()中，如果消息队列空时，向pipe写入触发数据。
                 在job_receive_status()中，如果消息队列空时，读取pipe中的触发数据。
                 在job_pool_delete()中，在未处理数据情况下，释放数据占用的内存空间。
                 
4. 与条件变量绑定的变量  mfsmount/readdata.c writedata.c # 基本描述了线程池释放和消息队列释放的流程
通过调用消息队列 queue_close() 通知 接收线程尽快结束 --> 此时，接收线程发现接收到数据为NULL，则自动释放自己。
--> 此时，调用消息队列queue_close()的函数进入 等待线程池内线程释放结束 阻塞等待中。
接收线程结束过程中，特定线程发现自己为最后一个线程时，--> 通过 调用 pthread_cond_signal，通知等待queue_delete线程结束
--> 此时，调用消息队列 queue_close()的函数 结束阻塞等待状态，调用queue_delete删除消息队列。
# 一般 调用  queue_new queue_put() queue_close() queue_delete() 这几个函数的位于主流程中， 调用queue_get()的位于线程池中。
}
moosefs(bgjobs-动态线程池){
1. 受空闲线程数限制和最大线程数限制
bgjobs.c  job_spawn_worker(jobpool *jp) 未超过总量上限，获得消息后，如果没有空闲线程就创建新线程
          job_close_worker(worker *w)   空闲线程超过空闲上限，就调用该函数释放线程
          
workers_avail 可以获得线程数
workers_total 正在运行总线程数
          
2. 根据连接动态的创建 和 释放线程
mainserv.c mainserv_write_middle        根据数据转发创建线程；数据转发完毕就自动退出线程

3. 根据数据动态的创建 和 释放线程 (线程超过指定个数之后，动态注销线程)
readdata.c read_data_spawn_worker(void)       未超过总量上限，获得消息后，即创建一个额外的线程；数据传送完毕结束线程
           read_data_close_worker(worker *w)  
迭代: read_data_spawn_worker创建read_worker线程；read_worker调用read_data_spawn_worker创建新线程；
                                                 read_worker调用read_data_close_worker(w)关闭已有线程
           
writedata.c write_data_spawn_worker(void)       未超过总量上限，获得消息后，即创建一个额外的线程；数据传送完毕结束线程
            write_data_close_worker(worker *w) 
迭代: write_data_spawn_worker创建write_worker线程；write_worker调用write_data_spawn_worker创建新线程；
                                                   write_worker调用write_data_close_worker(w)关闭已有线程
}

# https://en.wikipedia.org/wiki/Monitor_(synchronization)#Condition_variables_2
# empty, full, or between empty and full
moosefs(pcqueue){ 尾部添加和头部删除队列 与 互斥量和条件变量 两者是正交的。     
                  数据结构为骨架，线程同步变量为血肉 =                     正交化编程
void* queue_new(uint32_t size)       创建
void queue_delete(void *que);        删除 先queue_close; 然后调用queue_delete
void queue_close(void *que);         关闭 调用pthread_cond_broadcast通知关闭，不再允许追加和isempty阻塞

int queue_isempty(void *que);        是否空
int queue_isfull(void *que);         是否满
uint32_t queue_elements(void *que);  已有元素
uint32_t queue_sizeleft(void *que);  剩余空间

# id 唯一性标识； op 对数据的操作； data数据内容； leng占据队列长度
void queue_put(void *que,uint32_t id,uint32_t op,uint8_t *data,uint32_t leng);       阻塞追加
添加数据前(1.队列满则阻塞等待；2. 队列关闭则返回EIO)                                 添加数据后(1. 队列处于空阻塞则signal通知)
int queue_tryput(void *que,uint32_t id,uint32_t op,uint8_t *data,uint32_t leng);     非阻塞追加
申请数据前(长度受限: 1. leng大于maxsize返回EDEADLK 2. size+leng大于maxsize返回EBUSY) 添加数据后(1. 队列处于空阻塞则signal通知)
void queue_get(void *que,uint32_t *id,uint32_t *op,uint8_t **data,uint32_t *leng);   阻塞获取
获取数据前(1. element等于0，则阻塞等待 2. 队列关闭则返回EIO)                         删除数据后(1. 队列处于满阻塞则signal)
int queue_tryget(void *que,uint32_t *id,uint32_t *op,uint8_t **data,uint32_t *leng); 非阻塞获取
申请数据前(1. element等于0，则返回EBUSY)                                             删除数据后(1. 队列处于满阻塞则signal)

fullwaiting 队列满而线程处于阻塞状态的线程个数
freewaiting 队列空而线程处于阻塞状态的线程个数 
waitfree    如果freewaiting大于0，则调用pthread_cond_signal(&(q->waitfree)) 唤醒处于队列空阻塞状态的线程
waitfull    如果fullwaiting大于0，则调用pthread_cond_signal(&(q->waitfull)) 唤醒处于队列满阻塞状态的线程
消息处理不能表示正在处理消息的线程个数。

1. 增加了一些互斥量和条件变量
2. 增加了接口状态互斥相关的变量

[head] ->qentry[next]->NULL (尾部添加，头部去除) 追加1步，删除1.5步
            /|\
             |-----------tail
}
moosefs(in_packetstruct out_packetstruct){ 接收数据包和发送数据包队列
[inputhead] -> ipptr[next] -> NULL (尾部添加，头部去除) 追加1步，删除1.5步
                      /|\
                       |--------------inputtail
[outputhead] -> opptr[next] -> NULL (尾部添加，头部去除) 追加1步，删除1.5步
                      /|\
                       |--------------outputtail                       
}
[lruhead] -> ce[lruprev]+[lrunext]->NULL (尾部添加，随机删除) 追加3步，删除约2步-删除末尾节点和删除非末尾节点，对lrutail的影响是不一样的。
   /|\             |         /|\
    |--------------|          |-----------lrutail

    
[conncachehash]->ce1[lruprev]+[lrunext]->ce2[lruprev]+[lrunext]->NULL (头部添加，随机删除) 追加3.5步，删除2.5步
      /|\              |          /|\           |                      追加：头部是否有节点；删除末尾节点和删除非末尾节点.
       |---------------|           |------------|
       
moosefs(conncache list *head **tail链表){
freehead 与 hash 共用一个hashnext链表；
1. freehead            用于缓存空闲对象块
2. conncachehash       用于快速查询
3. lrutail和lruhead    用于老化
4. conncachetab        顺序表用于保持心跳

lrutail 和 lruhead 组成一个尾部追加，指定节点位置移除的队列 (追加三步解决问题)  头尾lrutail, lruhead两个变量
1. lruprev=lrutail; *(lrutail) = ce; lrutail = &(ce->lrunext);
                                                    (删除两步解决问题)
2. ce->lrunext->lruprev = ce->lruprev 或 lrutail = ce->lruprev; *(ce->lruprev) = ce->lrunext;
   删除末尾节点和删除非末尾节点，对lrutail的影响是不一样的。

conncachehash[hash]        头部追加，随机移除的链表 (删除两步解决问题)  conncachehash[hash]一个变量
1. 或ce->hashnext->hashprev = ce->hashprev; *(ce->hashprev) = ce->hashnext;
   删除末尾节点和删除非末尾节点，对ce下个节点ce->hashnext->hashprev影响是不一样的。
                                                    (添加四步解决问题)
2. ce->hashnext = conncachehash[hash]; 2 或ce->hashnext->hashprev = &(ce->hashnext); 3. ce->hashprev = conncachehash+hash; 4. conncachehash[hash] = ce;                
   头节点指向元素和头节点指向NULL，对ce的影响不一样
}
moosefs(conncache.c : 老化策略){
1. 老化只是提供了一种策略，对于维持空闲网络连接的心跳可以有很多策略。模块的真实功能是维持空闲网络连接心跳。
2. 哈希表是实现快速查询的一种方法，实现查询的方法还可以有二叉树，红黑树，平衡树等等，选用算法核心要考虑：索引。
3. 对于插入的文件描述符进行心跳维持，由各种原因需要模块自身删除(ip:port <-> fd)缓冲块时，关闭文件描述；
                                     如果通过ip:port重复使用连接时，由外部维持心跳和关闭文件描述符。
4. 如何将多种数据结构组合在同一个对象中? 通过正交性策略组合成分属不同功能的管理方式。
void conncache_insert(uint32_t ip,uint16_t port,int fd);  # 插入
int conncache_get(uint32_t ip,uint16_t port);             # 获取
int conncache_init(uint32_t capacity);                    # 构建
1. 没有析构函数--释放申请内存信息，没有现成退出函数。因为作为mfsmount客户端的缘故? 
--------------------------------------- 哈希表规则
#define CONN_CACHE_HASHSIZE 256 
#define CONN_CACHE_HASH(ip,port) (hash32((ip)^((port)<<16))%(CONN_CACHE_HASHSIZE))

conncachetab      指向多个数据对象的内存；每个对象表示一个网络连接；               # 快速遍历
freehead          多个数据对象通过hash指针连接在一个freehead的空闲链表中；申请链表 # 快速获得空闲块
*lruhead,**lrutail 以时间为序的链表，用于连接的老化释放                            # 时间老化
conncachehash     一个hash链表，用于快速锁定对象；                                 # 快速获得有效块
conncachehash链表为内核中的hlist_head和hlist_node形式链表。相比list_head类型链表更省空间，更快操作速度。

--------------------------------------- 链表处理方法
######### 插入过程 ######### 关心后继节点和lrutail
# ce->lrunext = NULL;                   ce的lrunext
# ce->lruprev = lrutail;                ce的lruprev
# *(lrutail) = ce;                      ce前驱的lrunext
# lrutail = &(ce->lrunext);             lrutail
######### 移出过程 ######### 需要判断ce是否有后继节点
# if (ce->lrunext!=NULL) {              ce有后继节点则
#   ce->lrunext->lruprev = ce->lruprev; ce后继的lruprev指向ce的lruprev
# } else {                              ce没有后继节点则
#   lrutail = ce->lruprev;              lrutail指向ce前驱节点
# }                                     
# *(ce->lruprev) = ce->lrunext;         ce前驱的lrunext指向ce的lrunext
1. 相比于双向循环链表而言，插入的位置被设定为lurtail。
2. 相比于单向非循环链表而言，可以随意的删除链表中某个元素。
3. 定点插入元素，定点删除，随机删除元素。

######### 插入过程 #########  关注ce自身，ce的前驱和后续
#　ce->hashnext = conncachehash[hash];             ce的hashnext
#　if (ce->hashnext) {                             ce有后继节点则
#　    ce->hashnext->hashprev = &(ce->hashnext);   ce有后继节点hashprev指向ce的hashnext
#　}                                               
#　ce->hashprev = conncachehash+hash;              ce的hashprev为conncachehash+hash
#　conncachehash[hash] = ce;                       conncachehash[hash]为ce
######### 移出过程 ######### 
# if (ce->hashnext!=NULL) {                        ce有后继节点则
#     ce->hashnext->hashprev = ce->hashprev;       ce有后继节点的hashprev指向ce的hashprev
# }                                                
# *(ce->hashprev) = ce->hashnext;                  ce前驱的hashnext指向ce的hashnext
1. 相比于双向循环链表而言，插入的位置被设定为conncachehash[hash]。
2. 相比于单向非循环链表而言，可以随意的删除链表中某个元素。
3. 定点插入元素，随机删除元素。

conncache.c   # 数组，老化链表(双向)，哈希链表(双向)， 空闲内存管理
xattrcache.c  # 老化链表(双向)，哈希链表(双向)，引用计数
mfsmount(csdb.c) # 哈希链表(单向)与连接关联进行统计，会造成内存的慢性泄露，危险得很。
mfsmaster(csdb.c) # 哈希链表(单向)
mfsmaster(chunk.c) # 哈希链表(单向)
mfschunkserver(chunk.c) # 哈希链表，结构很多，
filesystem.c         # 略
-------------------------------------- 老化策略
conncache.c  总量一定，超过总量则直接老化掉    #  内部老化和外部老化相结合
xattrcache.c 设定时间，超过指定时间直接老化掉  #  只有内部老化
redis(object.c) 设定时间，超过指定时间直接老化 #  内部老化和外部老化相结合

-------------------------------------- 无垃圾，无混淆
SPOT原则就是提倡寻找一种数据结构，使得模型中的状态个真实世界系统的状态能够一一对应。
}

moosefs(csdb mfsmaster进一步){
mfsmount(csdb.c)  统计当前tcp连接个数，即tcp连接建立是调用csdb_readinc或者csdb_writeinc；tcp连接释放时调用csdb_readdec或者csdb_writedec
                  csorder_sort.c 根据优先级和chunkserver并发连接数，对当前连接进行排序。
mfsmaster(csdb.c) 保存mfsmaster和mfschunkserver之间的关联关系。存储了对应chunkserver的heavyload和maintenance.
}
moosefs(csdb_makestrip){
csdb_makestrip(char strip[16],uint32_t ip)
  snprintf(strip,16,"%"PRIu8".%"PRIu8".%"PRIu8".%"PRIu8,(uint8_t)(ip>>24),(uint8_t)(ip>>16),(uint8_t)(ip>>8),(uint8_t)ip);
  strip[15]=0;
}
moosefs(pthread_cond_signal){
1. masterconn.c 多个线程发送过等待一个线程接收响应。 1:n
pthread_cond_wait(多个线程)                      pthread_cond_signal(单个线程)
while (rec->rcvd==0) pthread_cond_wait           if (rec->waiting) pthread_cond_signal


2. bgjobs.c     一个线程等待多个线程结束自身运行。  n:1
pthread_cond_wait(单个线程)                      pthread_cond_signal(多个线程)
 while (jp->workers_total>0) pthread_cond_wait   if (jp->workers_term_waiting) pthread_cond_signal

 
3. pcqueue.c    多个线程put放置消息，多个线程get获取消息 m:n
pthread_cond_signal(多个线程)                    pthread_cond_wait(多个线程)
3.1 if (q->freewaiting>0) pthread_cond_signal;q->freewaiting--; 
    q->freewaiting++;     pthread_cond_wait
    
3.2 if (q->fullwaiting>0) pthread_cond_signal;q->fullwaiting--; 
    q->fullwaiting++;     pthread_cond_wait
    
4. readdata.c 与 bgjobs.c相同
5. delayrun.c 一个线程等待另一个线程结束自身运行
pthread_cond_signal(一个线程)                   pthread_cond_wait(一个线程)
if(waiting) pthread_cond_signal(&dcond)         waiting = 1;pthread_cond_wait;waiting = 0;

6. mainserv.c 转发
}

moosefs(pthread){
1. fs_receive_thread    一个接受线程面对不定的多个发送线程的同步；
1.1 fs_receive_thread   实现连接维护(connect|reconnect)；接收数据之后，signal通知处于waiting状态的线程
1.2 条件变量实例根据线程id进行缓存复用：线程发送数据之后就会阻塞在添加变量上，使得条件变量实例和线程id存在一一对应关系；
1.3 注意：网络连接断链之后，发送给mfsmaster的数据块将得不到mfsmaster的响应，因此，网络断链之后要signal通知已发送数据的线程；
1.4 响应命令的接收有fs_sendandreceive(接收指定命令)和fs_sendandreceive_any(接收任意命令两种)。

2. readdata.c          以线程池方式(将read_data对数据块的请求转化为read_data_new请求)从mfschunkserver读取数据
1. read_worker 通过消息队列从read_data函数获得数据请求；然后从指定mfschunkserver获取请求对应数据。
2. read_worker 尽量保证read_data发送过来的请求能被及时处理，所以，尽量保证线程池中有一个空闲线程；
3. read_worker 线程池又尽量保证线程池内线程个数不大于指定线程个数，所以大于指定线程个数就退出一个线程
4. read_worker 线程池使用全局变量标识线程池是否结束，即: 停止一个线程池也是可以回收所有线程资源的

3. bgjobs.c           以线程池方式(将write_data发送来的请求或者read_data发送来的请求)管理磁盘的chunk块
与readdata.c 略同
5. bgjobs.c    设定了线程池的WORKERS_MAX和WORKERS_MAX_IDLE个数，即允许线程池中有一定数量的空闲线程。
6. bgjobs.c    通过判断消息队列中未被处理的数据块个数和正在处理的数据块个数，判定当前数据块操作负载情况。

mainserv.c 待分析
}

moosefs(oplog.c){ 将日志写入循环buff中。
static inline void oplog_put(uint8_t *buff,uint32_t leng)                           # 将数据放入循环缓冲区
void oplog_printf(const struct fuse_ctx *ctx,const char *format,...)                # 格式化数据，调用oplog_put
void oplog_getdata(unsigned long fh,uint8_t **buff,uint32_t *leng,uint32_t maxleng) # 获取缓冲内数据
void oplog_releasedata(unsigned long fh)                                            # 清除缓冲区内数据
------------------------------------------------------------------------------- 操作日志
1. changelog：记录多长时间内的操作日志
2. ubox(logd): 记录多少条操作日志
3. oplog.c   : 记录多长的日志(循环缓冲区)

日志时间总是在900s内。
}

moosefs(openfiles.c){
mfsmaster(openfiles.c) # sessionid哈希链表(双向) inode哈希链表(双向)
                       # 快速查找 二分法查找(of_bisearch)
关于链表操作可以参看moosefs(conncache.c)
}

moosefs(labelsets.c){
Storage Classes: 一个文件的副本应该存储到那些存储数据服务器内。
1. 客户端mfsmount - labelparser.c             # 解析用户输入的特殊符号
2. 服务器mfsmaster - labelsets.c              # 收集存储数据服务器的特殊符号，进行分组和分级管理
3. 存储数据服务器 mfschunkserver - LABELS字段 # 上报自身标志，标识分组和分级特性
# labels 用来实现分组存储功能；
# creation keep archive 用来实现分级存储
---------------------------------------
LOOSE: 当存储服务器负载大或者存储空间满的情况下，能使用其他的；  # -m L Flag to mfsscadmin
STD  ：当存储服务器存储空间满的情况下，能使用其他的；(默认值)    # -m D Flag to mfsscadmin
STRICT: 不允许使用指定标签以外的存储服务器。                     # -m S Flag to mfsscadmin
LABELS：字母表字母个数26个(A-Z:最多有26个标识可以配置给chunkserver；每个chunkserver可以有多个标识，通过逗点分割)
MAXLABELSETS：可以配置规则最大个数256个
FIRSTLABELID：从1-9为moosefs的存储策略，这里作为默认策略，以便兼容moosefs v2.0版本[多副本，最多支持9副本]

---------------------------------------
mount -t moosefs mfsmaster.test.lan: /mnt/mfs # -o mfspreflabels=LABELEXPR 优先读写访问服务器
mfsmount -H mfsmaster.test.lan /mnt/mfs       # -o mfspreflabels=LABELEXPR 优先读写访问服务器

mfsscadmin  # Creating Storage Classes
mfssclass
mfsgetsclass,mfssetsclass,mfscopysclass,mfsxchgsclass,mfslistsclass.
---------------------------------------
asterisk：加星号于 [可悲存储到任意个存储服务器]
label schema：字母图表[Sum:包含labels中的任何一个字母都可以存储；Multiplication：包含所有labels中字母的才可以存储]


/etc/mfs/mfschunkserver.cfg

--------------------------------------- 分组存储
ts02, ts03 ：Master Servers
ts04..ts12 ：Chunkservers

ts04, ts05, ts06 and ts07     # label A
LABELS = A
ts08, ts09, ts10, ts11, ts12  # label B
LABELS = B

# 一下格式为mfsscadmin命令配置标签格式。
# A,B             {}   一份存在A标签存储服务器，另一份存储在B标签存储服务器
# A,*             {}   一份存在A标签存储服务器，另一份存储在A标签以外存储服务器
# *,*             {}   两份副本存储在两台不同的存储数据服务上
# AB,C+D          {}   一份存在AB标签存储服务器，另一份存储在C标签或D标签存储服务器
# A,B[X+Y],C[X+Y] {}   一份存在A标签存储服务器，另一份存储在BX标签或BY标签存储服务器；最后一份存储在
                     # CX标签或CY标签存储服务器
# A,A             {2A} 
# A,BC,BC,BC      {A,3BC}

mfsscadmin create 2A sclass1  # 双副本存储在A标识的服务器内
mfsscadmin create 2B sclass2  # 双副本存储在B标识的服务器内
mfsscadmin list
mfsscadmin list -l
mfssetsclass sclass1 dataX  # dataX子目录及其文件都按照sclass1规则进行存储
mfssetsclass sclass2 dataY  # dataY子目录及其文件都按照sclass2规则进行存储
--------------------------------------- 分级存储(Creation, keep, archive labels)
mfsscadmin [/MOUNTPOINT] create|make [-a adminonly] [-m creationmode]
[-C CREATIONLABELS] -K KEEPLABELS [-A ARCHLABELS -d ARCHDELAY] SCLASSNAME...
-C CREATIONLABELS               # Creation labels 数据块只有被创建之后才能被写入
-K KEEPLABELS                   # Keep labels     数据块应该被一直存储，直到create或archive条件发生变化
-A ARCHLABELS -d ARCHDELAY      # Archive labels  数据块被放到归档服务器；可以指定被转移为归档数据块时间

--------------------------------------- 负载：Normal；Internal rebalance；Overloaded
}
moosefs(mfscadmin|mfssclass){
mfsscadmin [/MOUNTPOINT] create|make [-a admin_only] [-m creation_mode] [-C CREATION_LABELS] -K KEEP_LABELS 
            [-A ARCH_LABELS -d ARCH_DELAY] SCLASS_NAME...
mfsscadmin [/MOUNTPOINT] create|make [-a admin_only] [-m creation_mode] LABELS SCLASS_NAME...
mfsscadmin [/MOUNTPOINT] change|modify  [-f]  [-a  admin_only]  [-m  creation_mode]  [-C  CREATION_LABELS]  
            [-K KEEP_LABELS] [-A ARCH_LABELS] [-d ARCH_DELAY] SCLASS_NAME...
mfsscadmin [/MOUNTPOINT] delete|remove SCLASS_NAME...
mfsscadmin [/MOUNTPOINT] copy|duplicate SRC_SCLASS_NAME DST_SCLASS_NAME...
mfsscadmin [/MOUNTPOINT] rename SRC_SCLASS_NAME DST_SCLASS_NAME
mfsscadmin [/MOUNTPOINT] list [-l]

LABELS
CREATION_LABELS
KEEP_LABELS
ARCH_LABELS
ARCH_DELAY
---------------------------------------
mfsgetsclass [-r] [-n|-h|-H|-k|-m|-g] OBJECT...
mfssetsclass [-r] [-n|-h|-H|-k|-m|-g] SCLASSNAME OBJECT...
mfscopysclass [-r] [-n|-h|-H|-k|-m|-g] SOURCEOBJECT OBJECT...
mfsxchgsclass [-r] [-n|-h|-H|-k|-m|-g] SRCSCLASSNAME DSTSCLASSNAME OBJECT...
mfslistsclass [-l] [MOUNTPOINT]

# Two server rooms (A and B)                       #
# SSD and HDD drives                               #
# Two server rooms (A and B) + SSD and HDD drives  #
# Creation, Keep and Archive modes                 #　很有意义哦。
}
moosefs(? labelparser.c){
# 有待进一步思考
}

moosefs(changelog.c @协议){
changelog_init()    # 初始化日志 (BackLogsNumber|ChangelogSecondsToRemember)
changelog_rotate()  # rename 方法将日志文件从changelog.0.mfs -> changelog.1.mfs
                    # changelog.1.mfs -> changelog.2.mfs
                    # changelog.2.mfs -> changelog.3.mfs 
                    # ...             -> ...
changelog_get_old_changes(...) # 获取过去多少条的日志信息
changelog_get_minversion(...)  # 最小版本信息
changelog_mr(...)  # 输出中具有版本信息
changelog_escape_name(...) #将不可打印和%以及其他字符格式化成%FF 十六进制格式
changelog_checkname(...) #检验日志名字的合法性；
-------------------------------------------------------------------------------
1. 将日志轮转和元数据的保存，进程的结束结合起来 # 不是单纯的时间和大小关联起来 
2. 在内存中保存多长时间的日志信息，可以通过文件或者socket方式得到这些日志信息。
3. 将不可以打印的信息格式化。

总结：
1. 作为独立模块而言，和matomlserv和metadata之间存在关联关系，最好是有回调函数的方式实现；耦合性比较高。
2. 文本形式存储，可读性比较好
3. 不会过多向外部披露自身的细节? 有待进一步优化... ... 

@协议 - 日志
changelog("%"PRIu32"|INCVERSION(%"PRIu64")",(uint32_t)main_time(),c->chunkid);
changelog("%"PRIu32"|CHUNKDEL(%"PRIu64",%"PRIu32")",main_time(),c->chunkid,c->version);
changelog("%"PRIu32"|NEXTCHUNKID(%"PRIu64")",main_time(),nextchunkid);
changelog("%"PRIu32"|CHUNKADD(%"PRIu64",%"PRIu32",%"PRIu32")",main_time(),c->chunkid,c->version,c->lockedto);
changelog("%"PRIu32"|CHUNKADD(%"PRIu64",%"PRIu32",%"PRIu32")",main_time(),c->chunkid,c->version,c->lockedto);
changelog("%"PRIu32"|CHUNKDEL(%"PRIu64",%"PRIu32")",main_time(),c->chunkid,c->version);
changelog("%"PRIu32"|CSDBOP(%u,%"PRIu32",%"PRIu16",%"PRIu16")",main_time(),CSDB_OP_NEWIPPORT,ip,port,csidptr->csid);
changelog("%"PRIu32 "|FREEINODES():%" PRIu32,ts,fi);
changelog("%"PRIu32"|SETPATH(%"PRIu32",%s)",(uint32_t)main_time(),inode,changelog_escape_name(pleng,path));
changelog("%"PRIu32"|UNDEL(%"PRIu32")",ts,inode);
changelog("%"PRIu32"|PURGE(%"PRIu32")",ts,inode);
           操作计数|操作方法(操作内容)
           
@协议 - 函数名称
changelog_get_old_changes
changelog_get_minversion
changelog_rotate
changelog_mr
changelog
changelog_init
changelog_reload
changelog_escape_name
changelog_findfirstversion
changelog_findlastversion
changelog_checkname

changelog: 文件名称；核心函数名；结构体类型名称修饰主体
changelog_[init|reload|mr|rotate] 操作名称
changelog_get_old_changes|minversion : 获取changelog结构体参数
}

moosefs(bio.c @协议){
bio_file_open(const char *fname,uint8_t direction,uint32_t buffersize);
bio_socket_open(int socket,uint8_t direction,uint32_t buffersize,uint32_t msecto);
bio_file_position(bio *b);
bio_file_size(bio *b);
bio_read(bio *b,void *dst,uint64_t len);
bio_write(bio *b,const void *src,uint64_t len);
bio_seek(bio *b,int64_t offset,int whence);
bio_skip(bio *b,uint64_t len);
bio_eof(bio *b);
bio_error(bio *b);
bio_descriptor(bio *b);
bio_close(bio *b);

bio: 文件名称；结构体类型名称；函数范围标识
bio_[file|socket]: 具体封装对象
bio_internal: 内部函数不对外提供
bio_[read|write|seek|skip|eof|error|close]: 抽象成相同操作
}

moosefs(misc @协议-数据结构){
crc.c
hashfn.h
md5.c
memusage.c
random.c

@协议
# 模块内部使用数据结构
typedef struct _quotanode {} quotanode
typedef struct _statsrecord {} statsrecord
typedef struct _chunk_op_args {} chunk_op_args
# 模块外部使用数据结构
struct _bio {}; typedef struct _bio bio; 
typedef struct deentry {} deentry;

record, entry, node, data, info, buf, cache, job, worker
hashbucket
}

pipe(moosefs,dnsmasq){
---------------------------------------moosefs.c
main.c # '\001'     '\002'        '\003'      '\004'      '\005'      '\006'
       # termhandle reloadhandle  chldhandle  infohandle  alarmhandle  main_exit
       # SIGTERM    SIGHUP        SIGCHLD     SIGINFO     SIGALRM
       #                          SIGCLD      SIGUSR1     SIGVTALRM
       #                                                  SIGPROF
# SIGINT                                            后台运行忽略
# SIGQUIT SIGPIPE  SIGTSTP SIGTTIN SIGTTOU SIGUSR2  程序运行忽略

mainserv.c # "*"
metadata.c # "x"
readdata.c # " "
writedata.c # " "
---------------------------------------dnsmasq.c
iov[0].iov_base = &ev;       # 
iov[0].iov_len = sizeof(ev); # 指定长度数据
iov[1].iov_base = msg;       # 
iov[1].iov_len = ev.msg_sz;  # 可变长度字符串
--------------------------------------- 

}
moosefs(把知识叠入数据以求逻辑质朴而健壮){
init.h 文件中的RunTab和LateRunTab。

1. 将复杂的逻辑处理转化为相对简单的数据处理。减少逻辑处理的复杂性 -- 通常为状态处理。
2. 将数据处理过程划分为不同的子过程，通过模块定义子过程，使用函数调用或者回调函数对子过程进行控制。 -- 数据化子过程
-------------------------------------------------------------------------------
将逻辑处理、系统调用和库函数调用过程中触发的各种问题和进程状态|线程状态(数据处理状态)、网络连接状态关联起来，
使得逻辑处理、系统调用和库函数调用过程中触发的各种问题，转变成几种状态处理问题。
1. 全局变量设定errno
2. 动态网络状态数据对象内保存状态
3. 将函数中系统调用和库函数调用异常转变成状态设定。

 # 将函数调用的异常返回值记录在特定变量中； 避免了函数调用过程中复杂的返回判断. 最终统一成一种处理方式
1. moosefs(matomlserv.c)中masterconn_read函数，将read函数的出错转变成err和hup两个值，
   然后eptr->input_end = 1; 
   
# 将协议处理的逻辑异常记录在特定变量中；    避免了函数调用过程中复杂的返回判断. 最终统一成一种处理方式
2. moosefs(matomlserv.c)中masterconn_write函数，将write函数的出错转变为eptr->mode = KILL；
                    matomlserv_get_version函数，将write函数的出错转变为eptr->mode = KILL；
                       matomlserv_register函数，将write函数的出错转变为eptr->mode = KILL；
                 matomlserv_download_start函数，将write函数的出错转变为eptr->mode = KILL；
               matomlserv_download_request函数，将write函数的出错转变为eptr->mode = KILL；
                   matomlserv_download_end函数，将write函数的出错转变为eptr->mode = KILL；
                          matomlserv_parse函数，将write函数的出错转变为eptr->mode = KILL；
                          matomlserv_serve函数，将write函数的出错转变为eptr->mode = KILL；
                 matomlserv_disconnect_all函数，将write函数的出错转变为eptr->mode = KILL；
最后将异常错误在matomlserv_disconnection_loop函数中进行统一的处理。

# 将函数调用的异常返回值存放到errno全局变量中
3. moosefs(filesystem.c)中fs_loadfree函数中int err = errno;和errno = err;处理，将错误存放在全局变量errno中
使得函数处理避免return返回值的复杂性。
}
moosefs(数据驱动程序与函数指针+时间驱动程序与函数指针+信号驱动程序转数据驱动程序+分析表){
数据驱动程序与函数指针(协议)
1. matomlserv.c 的matomlserventry数据结构的outputhead，驱动poll   #数据驱动程序
   matocsserv.c 的matocsserventry数据结构的outputhead，驱动poll   #数据驱动程序
   matoclserv.c 的matoclserventry数据结构的outputhead，驱动poll   #数据驱动程序
2. 线程池                                             #数据驱动程序
3. main_poll_register                                 #函数指针+数据驱动程序

时间驱动程序与函数指针(协议)
1. main_eachloop_register                       #时间驱动程序+函数指针
2. main_msectime_register，main_time_register   #时间驱动程序+函数指针
3. 独立线程，时间驱动。
hdd_tester_thread        portable_usleep                   # 时间驱动程序
hdd_folders_thread       sleep(1);                         # 时间驱动程序
hdd_rebalance_thread     sleep(1); 或 portable_usleep(en); # 时间驱动程序
hdd_delayed_thread       sleep(DELAYEDSTEP);               # 时间驱动程序

信号驱动程序转数据驱动程序(协议)
daemonignoresignal  SIG_IGN
alarmsignal         alarmhandle
ignoresignal        SIG_IGN
chldsignal          chldhandle
infosignal          infohandle
reloadsignal        reloadhandle
termsignal          termhandle

解析表：
init.h 文件中的RunTab表和LateRunTab表      # 模块初始化
strerr.c 文件中的errent errtab表           # 错误码列举
mfsnetdump.c 文件中_mfscmd中的"commands.h" # 命令码与字符串对应
}

moosefs_linyang(过程名称应该表明它们是做什么的，函数名称应该表明它们返回什么)
{
# destruct 过程， canexit 函数  register 比较中性，可以有返回值，也可以不存在返回值。
void main_destruct_register (void (*fun)(void));
void main_canexit_register (int (*fun)(void));

# 函数：
# 进程管理     #  init hook loop register unregister term destruct setup install uninstall exit keepalive load reload
# 任务管理     #  start stop pause continue run  
# 数据收发     #  read write send recv wait flust timeout flush 
# 数据管理     #  get find set put add del reset create delete each total max avail global
# 文件管理     #  mknod mkdir unlink rmdir rename link readdir
# 数据判断     #  isvalid isempty isfull iszero isequal greater less older newer isexist isopened 
               #  same true false test enable disable state status 
# 异或操作     #  nor or xor and
# 加减操作     #  inc dec add sub 
# 登录退出     #  login logout 
# 数据上报     #  report 
# 心跳         #  heartbeat
#              #  new delete malloc free zmalloc
# 过程：stat thread term worker 
     # function(func) callback 
     # handle
     # alert, crit, debug, emerg, err, error, info, notice, panic, warning, warn

# replicate duplicate copy repeat triplicate original
# 如果你replicate一件事物，你是重复一件已经做过的东西（可能多次）。强调过程，
# 如果你duplicate一件事物，你是重现一件已经做过的东西（一次）。    强调结果，   
# copy 是副印件                                  # copy通常是复制某样物品（大部分是纸张）
# duplicate 是原件两份 triplicate                # duplicate:各种复制都可以用
# duplicate,triplicate都是指与original一模一样的 # 
# repeat是重复某件事                             # 重做，并不强调重做过程完全相同。

# message packet queue list stack tree pool
# in out head tail data end last next prev right left parent children 
# xargs data extra
# manager
}

moosefs(注释){
1. 迭代过程中注释比较混乱，有些没有用的代码没有被删除掉，而是注释了。
2. readdata.c 中的一下注释很有意义，指的学习。
rreq:      |---------|
read: |--|
read: |-------|
read: |-------------------|
read:                  |--|
---------------------------------------
rreq: |---------|
read:    |---|
3. posixlock.c  这里的注释也很有意思
wl:   |-----|     |-----|
r:  |---|       |-------|
4. /* ---------------SOCK ADDR--------------- */
这些注释很有意思。
}

moosefs(heap){
void delay_heap_sort_down(void)  # 头部更新 
uint8_t delay_heap_sort_up(void) # 尾部添加 0:表示不影响firetime
void* delay_scheduler(void *arg) # 从堆栈删除元素
void delay_run (void (*fn)(void *),void *udata,uint64_t useconds) # 向堆中添加元素
void delay_term(void) # 释放heap
void delay_init(void) # 初始化heap
总结：缺少从heap删除元素的接口

void merger_heap_sort_down();    # 头部更新
void merger_heap_sort_up(void)   # 尾部添加 0:表示不影响firetime
int merger_start(uint32_t files,char **filenames,uint64_t maxhole,uint64_t minid,uint64_t maxid)  # 初始化heap
总结：缺少更多可以接口化的代码

最好的还是 libevent中的heap, 还有libuv中的堆
}

申请资源时就确定释放资源

1. 服务器资源初始化 RLIMIT_CORE RLIMIT_NOFILE getpwnam(setgid setuid) daemonize mlockall sigignore(SIGPIPE) save_pid(pid_file);
2. 初始化参数解析   settings settings_init() getopt getsubopt
3. 资源初始化       hash表的初始化, 统计信息的初始化, 工作线程的初始化, 连接的初始化
4. 网络监听的建立   server_sockets server_socket conn_new(连接的建立) dispatch_conn_new(连接分发)
5. 网络连接的建立   
6. 内存初始化
7. 线程交互
memcacahed(){

}

1. 宏实现功能控制
2. 日志管理 异常管理
3. 内存管理
4. 数据结构 链表(queue.h) 树(tree.h) 哈希表(ht-internal.h) binary tree(小堆树)
5. event_base 关键数据结构 event_config 配置event_base
6. 选择后端(1.可供选择的后端 2.如何选定后端 ) 后端数据存储结构体(1.IO复用结构体  )
7. 工作流程 event 的生命周期管理; event_base 的生命周期管理
8. evconnlistener
9. evbuffer
10. bufferevent
libevent(){
[event-config.h] 从命令选项到宏开关，从宏开关到功能启停
1. 定义宏和功能关系     event-config.h <- config.h(make-event-config.sed) <- config.h.in(autoheader)
2. 定义宏功能开闭       configure
3. 根据宏开关使用宏功能 util.h

[log.c] -- 模块日志的管理策略 以及 在初始化前配置
1. 通过头文件命名 log-internal.h 确定这些函数不能被外部使用
2. 通过设置回调函数， 确定内部日志可以输出的级别和流方向
log4pp、log4xx 重量级日志模块
3. 函数功能和命名
3.1 event_log   默认的输出到前端 demo作用
3.2 event_logv_ v(va_list 序列) _(内部函数)
3.3 event_msgx(无错误) 和 event_msg(系统接口错误errno) 
3.4 级别 exit err warn msg debug
3.5 event_sock_warn 模块级别错误
4. 错误处理
致命发生错误，默认行为是终止程序，用户也是可以用libevent定制自己的错误处理函数。

[mm-internal.h] -- 
1. --disable-malloc-replacement -> _EVENT_DISABLE_MM_REPLACEMENT 从命令选项到宏开关
2. 通过头文件命名 mm-internal.h 确定这些函数不能被外部使用
3. 内存管理定制要求 malloc_fn， realloc_fn， free_fn

vs monit的libmonit对内存管理进行封装，在模块内部使用 
Mem_alloc(malloc)    ALLOC
Mem_alloc(calloc)    CALLOC
Mem_free(free)       FREE
Mem_resize(reallooc) RESIZE
定义了新函数 NEW

1. 在运行时设置 malloc realloc和free函数，     libevent
2. 在链接时 链接到 不同的内存管理库(redis)     redis
3. 封装 malloc realloc和free，捕获内存管理异常 libmonit

[数据结构] 
1. 链表(queue.h)  见libevent(尾队列说明)
1.1 TAILQ 队列
hosts_entry(evdns.c dns解析) event_callback(event-internal.h event的回调函数) 
event_config_entry(event-internal.h 屏蔽的后台方法) evhttp_request(http-internal.h http请求)
evhttp_connection(event-internal.h 连接) 
1.2 LIST 链表
bufferevent_private(bufferevent-internal.h 在所有bufferevent类型之间共享的bufferevent结构的一部分)
evbuffer_cb_entry(evbuffer-internal.h evbuffer的回调函数链表)
event_once(event-internal.h 设置一次处理事件)
2. 树(tree.h)
2.1 SPLAY 延展树
2.2 RB    红黑树
3. 哈希表(ht-internal.h) event_io_map是一个哈希表，
event_signal_map是一个数组
非Windows系统中，event_io_map被定义成event_signal_map,此时slot将是文件描述符fd。
4. 小堆树(binary tree)

[event_base] event_base(配置和获取后端) -- libevent/libevent_API.sh
1. event_config 配置event_base
2. 创建、删除和run
 
[event] event(含义及操作集) -- libevent/libevent_API.sh
EVLIST_TIMEOUT  0x01 # event从属于定时器队列或者时间堆
EVLIST_INSERTED 0x02 # event从属于注册队列
EVLIST_SIGNAL   0x04 # 没有使用
EVLIST_ACTIVE   0x08 # event从属于活动队列
EVLIST_INTERNAL 0x10 # 该event是内部使用的。信号处理时有用到
EVLIST_INIT     0x80 # event已经被初始化了

[evconnlistener]  evconnlistener_cb(listener回调函数) -- libevent/libevent_API.sh
LEV_OPT_LEAVE_SOCKETS_BLOCKING
LEV_OPT_CLOSE_ON_FREE
LEV_OPT_CLOSE_ON_EXEC
LEV_OPT_REUSEABLE
LEV_OPT_THREADSAFE

[evbuffer] - evbuffer(基本操作) libevent/libevent_API.sh
[bufferevent] - bufferevent(基本概念) libevent/libevent_API.sh
}


链表：单指针链表：单向链表；单向循环链表 
      双指针链表：双向链表；双向循环链表
libevent(queue){ STAILQ和SIMPLEQ数据结构操作一致，只是STAILQ增加了_CONCAT操作。
+-----------------+-------+------+---------+--------+-------+---------+
|                 | SLIST | LIST | SIMPLEQ | STAILQ | TAILQ | CIRCLEQ |
+-----------------+-------+------+---------+--------+-------+---------+
|_EMPTY           |   +   |  +   |    +    |   +    |   +   |    +    |
|_FIRST           |   +   |  +   |    +    |   +    |   +   |    +    |
|_FOREACH         |   +   |  +   |    +    |   +    |   +   |    +    |
|_FOREACH_REVERSE |   -   |  -   |    -    |   -    |   +   |    +    |
|_INSERT_AFTER    |   +   |  +   |    +    |   +    |   +   |    +    |
|_INSERT_BEFORE   |   -   |  +   |    -    |   -    |   +   |    +    |
|_INSERT_HEAD     |   +   |  +   |    +    |   +    |   +   |    +    |
|_INSERT_TAIL     |   -   |  -   |    +    |   +    |   +   |    +    |
|_LAST            |   -   |  -   |    -    |   -    |   +   |    +    |
|_LOOP_NEXT       |   -   |  -   |    -    |   -    |   -   |    +    |
|_LOOP_PREV       |   -   |  -   |    -    |   -    |   -   |    +    |
|_NEXT            |   +   |  +   |    +    |   +    |   +   |    +    |
|_PREV            |   -   |  -   |    -    |   -    |   +   |    +    |
|_REMOVE          |   +   |  +   |    +    |   +    |   +   |    +    |
|_REMOVE_HEAD     |   +   |  -   |    +    |   +    |   -   |    -    |
|_CONCAT          |   -   |  -   |    -    |   +    |   +   |    -    |
+-----------------+-------+------+---------+--------+-------+---------+

# SLIST | LIST | SIMPLEQ | TAILQ 
1.   Insertion of a new entry at the head of the list.
2.   Insertion of a new entry after any element in the list.
3.   Removal of an entry from the head of the list.
4.   Forward traversal through the list.

#      Simple queues add the following functionality:
1.   Entries can be added at the end of a list.
However:
1.   All list insertions must specify the head of the list.
2.   Each head entry requires two pointers rather than one.
3.   Code size is about 15% greater and operations run about 20% slower than singly-linked lists.

# All doubly linked types of data structures (lists and tail queues) additionally allow:
1.   Insertion of a new entry before any element in the list.
2.   Removal of any entry in the list.
However:
1.   Each element requires two pointers rather than one.
2.   Code size and execution time of operations (except for removal) is about twice that of the singly-
    linked data-structures.
    
# Tail queues add the following functionality:
1.   Entries can be added at the end of a list.
2.   They may be traversed backwards, at a cost.
However:
1.   All list insertions and removals must specify the head of the list.
2.   Each head entry requires two pointers rather than one.
3.   Code size is about 15% greater and operations run about 20% slower than singly-linked lists.
}

1. type 为HT_HEAD和HT_ENTRY 与 外部关联的结构体; 如结构体 person
2. TAILQ_HEAD(name, type) 定义结构体，结构体自身 引用 外部结构体type。
   name是被定义的结构体，TAILQ_HEAD(name, type) 等于 name
3. TAILQ_ENTRY(type) 定义结构体，结构体自身包含在 type 结构体内，两者相互引用
4. type 为外部关联结构体 head头指针，elm|listelm|elm2 type类型变量，
   field 表示TAILQ_ENTRY(type)在type中的成员变量名

libevent/compat/sys/sample_restore_queue.c
libevent/compat/sys/sample_tail_queue.c
libevent/compat/sys/sample_queue.c
libevent(ds:TAILQ 尾队列){ 相当于moosefs中conncache中的lruhead和lrutail构成的队列。
person 为包含TAILQ_ENTRY(person) male;的结构体; 
1. TAILQ_HEAD和TAILQ_EMPTY用于定义struct类型，所以
TAILQ_HEAD(male_list, person) malequeue;   # 使用person 结构体 定义结构体(命名)male_list, 定义male_list类型变量 malequeue
TAILQ_ENTRY(person) male;                  # 通过person 结构体 定义结构体(匿名)，并定义变量male

# type 这里是 struct (结构体|类型) 的意思
TAILQ_HEAD(name, type)              定义新命名类型 name; TAILQ_HEAD(name, type) 就是类型; 等同于 name(结构体)
TAILQ_ENTRY(type)                   定义新匿名类型;      TAILQ_ENTRY(type)      也是类型;

2. TAILQ_HEAD_INITIALIZER定义方式初始化尾队列，TAILQ_INIT通过赋值语句初始化尾队列
TAILQ_HEAD_INITIALIZER(head)            初始化head  head是TAILQ_HEAD(name,type)定义或name定义的变量。
TAILQ_INIT(head)                        队列初始化  

3. TAILQ_EMPTY(head)                    判断队列是否为空

4. 头尾，前驱和后继
TAILQ_FIRST(head)                       返回队列的第一个对象
TAILQ_LAST(head, headname)              获取最后一个对象
TAILQ_NEXT(elm, field)                  用于获取下一个对象
TAILQ_PREV(elm, headname, field)        获取ele的前一个节点

5. 遍历
TAILQ_FOREACH(var, head, field)
TAILQ_FOREACH_SAFE(VARNAME, TAILQ_HEAD *head, FIELDNAME, TEMP_VARNAME);
TAILQ_FOREACH_REVERSE(var, head, headname, field)
TAILQ_FOREACH_REVERSE_SAFE(VARNAME, TAILQ_HEAD *head, HEADNAME, FIELDNAME, TEMP_VARNAME);

6. 头尾插入，随机插入
TAILQ_INSERT_HEAD(head, elm, field)     在队头head处插入元素elm
TAILQ_INSERT_TAIL(head, elm, field)     在队列head尾部插入elm
TAILQ_INSERT_AFTER(head, listelm, elm, field)   在队列head的listelm元素后插入elm
TAILQ_INSERT_BEFORE(listelm, elm, field)        在listelm元素前插入elm

7. 删除
TAILQ_REMOVE(head, elm, field)                  移除队列head的elm元素

8. 替换
TAILQ_REPLACE(head, elm, elm2, field)           使用elm2替换队列head的elm元素
TAILQ_CONCAT(TAILQ_HEAD *head1, TAILQ_HEAD *head2, FIELDNAME);
}

libevent/compat/sys/sample_simple_queue.c
libevent(ds:SIMPLEQ 简单队列){ 相当于moosefs中in_packetstruct out_packetstruct
1. SIMPLEQ_HEAD和SIMPLEQ_ENTRY用于定义struct类型，所以
SIMPLEQ_HEAD(male_list, person) malequeue;   # 使用persion定义新类型male_list,新类型变量为malequeue
SIMPLEQ_ENTRY(person) male;                    # 通过person类型定义新类型，新类型变量为male

SIMPLEQ_HEAD(name, type)                      # 队列表头：指向队列的第一个成员 和 指向队列最后一个成员的next地址
SIMPLEQ_ENTRY(type)                           # 定义指向下一个队列成员的结构

2. SIMPLEQ_HEAD_INITIALIZER定义方式初始化尾队列，SIMPLEQ_INIT通过赋值语句初始化尾队列
SIMPLEQ_HEAD_INITIALIZER(head)            初始化head
SIMPLEQ_INIT(head)                        队列初始化

3. SIMPLEQ_EMPTY(head)                       判断队列是否为空

4. 头尾，前驱和后继
SIMPLEQ_FIRST(head)                             返回队列的第一个对象
SIMPLEQ_NEXT(elm, field)                        用于获取下一个对象

5. 遍历
SIMPLEQ_FOREACH(var, head, field)
SIMPLEQ_FOREACH_SAFE(VARNAME, SIMPLEQ_HEAD *head, FIELDNAME, TEMP_VARNAME);

6. 头尾插入，随机插入
SIMPLEQ_INSERT_HEAD(head, elm, field)     在队头head处插入元素elm
SIMPLEQ_INSERT_TAIL(head, elm, field)     在队列head尾部插入elm
SIMPLEQ_INSERT_AFTER(head, listelm, elm, field)   在队列head的listelm元素后插入elm

7. 删除
SIMPLEQ_REMOVE_HEAD(head, elm, field)      从队列头head移除队列的首个成员elm

8. 连接
SIMPLEQ_CONCAT(SIMPLEQ_HEAD *head1, SIMPLEQ_HEAD *head2);
}

libevent/compat/sys/sample_list.c
libevent(ds:LIST 双向链表){ 相当于moosefs中conncache中的conncachetab
1. LIST_HEAD和LIST_ENTRY用于定义struct类型，所以
LIST_HEAD(male_list, person) malequeue;   # 使用persion定义新类型male_list,新类型变量为malequeue
LIST_ENTRY(person) male;                    # 通过person类型定义新类型，新类型变量为male

LIST_HEAD(HEADNAME, TYPE);                      # 一个双向链表的头部
LIST_ENTRY(TYPE);                           # 定义指向下一个队列成员的结构

2. LIST_HEAD_INITIALIZER定义方式初始化尾队列，LIST_INIT通过赋值语句初始化尾队列
LIST_HEAD_INITIALIZER(LIST_HEAD head);            初始化head
void LIST_INIT(LIST_HEAD *head);          链表初始化

3. LIST_EMPTY(head)                       判断链表是否为空

4. 头尾，前驱和后继
LIST_FIRST(head)                             返回链表的第一个对象
LIST_NEXT(elm, field)                        用于获取下一个对象

5. 遍历
LIST_FOREACH(var, head, field)
LIST_FOREACH_SAFE(VARNAME, LIST_HEAD *head, FIELDNAME, TEMP_VARNAME);

6. 头尾插入，随机插入
LIST_INSERT_HEAD(head, elm, field)              在链表head处插入元素elm
LIST_INSERT_AFTER(head, listelm, elm, field)    在链表head的listelm元素后插入elm
LIST_INSERT_BEFORE(head, listelm, elm, field)   在链表head的listelm元素后插入elm

7. 删除
SIMPLEQ_REMOVE_HEAD(head, elm, field)      从队列头head移除队列的首个成员elm
void LIST_REMOVE(struct TYPE *elm, FIELDNAME);

8. 替换
LIST_REPLACE(elm, elm2, field)             用elm2替换链表中的elm对象
void LIST_REPLACE(struct TYPE *elm, struct TYPE *elm2, FIELDNAME);
}

libevent/compat/sys/sample_slist.c
libevent(ds:SLIST 单向链表){ 相当于moosefs中main.c中的inhead，kahead
1. SLIST_HEAD和SLIST_ENTRY用于定义struct类型，所以
SLIST_HEAD(male_list, person) malequeue;   # 使用persion定义新类型male_list,新类型变量为malequeue
SLIST_ENTRY(person) male;                    # 通过person类型定义新类型，新类型变量为male

SLIST_HEAD(HEADNAME, TYPE);                      # 一个双向链表的头部
SLIST_ENTRY(TYPE);                           # 定义指向下一个队列成员的结构

2. SLIST_HEAD_INITIALIZER定义方式初始化尾队列，SLIST_INIT通过赋值语句初始化尾队列
SLIST_HEAD_INITIALIZER(SLIST_HEAD head)            初始化head
void SLIST_INIT(SLIST_HEAD *head);                        链表初始化

3. int SLIST_EMPTY(SLIST_HEAD *head);                       判断链表是否为空

4. 头尾，前驱和后继
struct TYPE *SLIST_FIRST(SLIST_HEAD *head);                             返回链表的第一个对象
struct TYPE *SLIST_NEXT(struct TYPE *listelm, FIELDNAME);                        用于获取下一个对象

5. 遍历
SLIST_FOREACH(VARNAME, SLIST_HEAD *head, FIELDNAME);
SLIST_FOREACH_SAFE(VARNAME, SLIST_HEAD *head, FIELDNAME, TEMP_VARNAME);

6. 头插入，随机插入
void SLIST_INSERT_AFTER(struct TYPE *listelm, struct TYPE *elm, FIELDNAME);
void SLIST_INSERT_HEAD(SLIST_HEAD *head, struct TYPE *elm, FIELDNAME);
void SLIST_REMOVE_AFTER(struct TYPE *elm, FIELDNAME);

6. 移除
void SLIST_REMOVE_HEAD(SLIST_HEAD *head, FIELDNAME);
void SLIST_REMOVE(SLIST_HEAD *head, struct TYPE *elm, TYPE, FIELDNAME);
}

libevent(ds:CIRCLEQ 简单队列){ 相当于moosefs中... ... libevent中也未提供实例
1. CIRCLEQ_HEAD和CIRCLEQ_ENTRY用于定义struct类型，所以
CIRCLEQ_HEAD(male_list, person) malequeue;   # 使用persion定义新类型male_list,新类型变量为malequeue
CIRCLEQ_ENTRY(person) male;                    # 通过person类型定义新类型，新类型变量为male

CIRCLEQ_HEAD(name, type)                      # 一个双向队列的头部
CIRCLEQ_ENTRY(type)                           # 定义指向下一个双向队列成员的结构

2. CIRCLEQ_HEAD_INITIALIZER定义方式初始化尾队列，CIRCLEQ_INIT通过赋值语句初始化尾队列
CIRCLEQ_HEAD_INITIALIZER(head)            初始化head
CIRCLEQ_INIT(head)                        链表初始化

3. CIRCLEQ_EMPTY(head)                       判断链表是否为空

4. 头尾，前驱和后继
CIRCLEQ_FIRST(head)                             返回链表的第一个对象
CIRCLEQ_LAST(head) 
CIRCLEQ_END(head)                               返回链表的尾部,指向NULL
CIRCLEQ_NEXT(elm, field)                        用于获取下一个对象
CIRCLEQ_PREV(elm, field)

5. 遍历
CIRCLEQ_FOREACH(var, head, field) 
CIRCLEQ_FOREACH_REVERSE(var, head, field)

6. 头插入，随机插入
CIRCLEQ_INSERT_AFTER(head, listelm, elm, field)
CIRCLEQ_INSERT_BEFORE(head, listelm, elm, field)
CIRCLEQ_INSERT_HEAD(head, elm, field)
CIRCLEQ_INSERT_TAIL(head, elm, field)

7. 删除
CIRCLEQ_REMOVE(head, elm, field)

8. 替换
CIRCLEQ_REPLACE(head, elm, elm2, field)
}

libevent(ds:STAILQ 单链尾队列){ 相当于moosefs中in_packetstruct out_packetstruct
1. STAILQ_HEAD和STAILQ_ENTRY用于定义struct类型，所以
STAILQ_HEAD(male_list, person) malequeue;   # 使用persion定义新类型male_list,新类型变量为malequeue
STAILQ_ENTRY(person) male;                    # 通过person类型定义新类型，新类型变量为male

STAILQ_HEAD(name, type)                      # 一个双向队列的头部
STAILQ_ENTRY(type)                           # 定义指向下一个双向队列成员的结构

2. STAILQ_HEAD_INITIALIZER定义方式初始化尾队列，STAILQ_INIT通过赋值语句初始化尾队列
STAILQ_HEAD_INITIALIZER(head)            初始化head
STAILQ_INIT(head)                        链表初始化

3. STAILQ_EMPTY(head)                       判断链表是否为空

4. 头尾，前驱和后继
STAILQ_FIRST(head)                             返回链表的第一个对象
STAILQ_NEXT(elm, field)                        用于获取下一个对象


5.遍历
STAILQ_FOREACH(var, head, field)                

6. 头插入，随机插入
STAILQ_INSERT_HEAD(head, elm, field)
STAILQ_INSERT_TAIL(head, elm, field) 
STAILQ_INSERT_AFTER(head, listelm, elm, field)

7. 删除
STAILQ_REMOVE_HEAD(head, field)
STAILQ_REMOVE(head, elm, type, field)

8. 连接
STAILQ_CONCAT(head1, head2) 
}

红黑树的操作方式与伸展树类似，tree.h有一个好处就是自己不会管理内存、非常适合在驱动程序中使用。

1. type 为SPLAY_HEAD和SPLAY_ENTRY 与 外部关联的结构体; 如结构体 event_map_entry
2. SPLAY_HEAD(name, type) 定义结构体，结构体自身 引用 外部结构体type。
   name是被定义的结构体，SPLAY_HEAD(name, type) 等于 name
3，SPLAY_ENTRY(type) 定义结构体，结构体自身包含在 type 结构体内，两者相互引用
4. SPLAY_PROTOTYPE(name, type, field, cmp)  name和type为结构体，field为SPLAY_ENTRY在type结构体中成员变量名称。
   cmp定义查找函数
5. SPLAY_GENERATE(name, type, field, cmp) 
   name和type为结构体，field为SPLAY_ENTRY在type结构体中成员变量名称。cmp定义查找函数
6. type 为外部关联结构体 head头指针，elm|listelm|elm2 type类型变量，
   field SPLAY_ENTRY(type)在type中的成员变量名; cmp定义查找函数
7. 宏连接 -> 重新定义函数名  或 变量名


libevent(splay tree){
splay tree的应用场景 splay tree 会把经常访问的数据移动到离树根更近，这在某些应用场景中非常有用，
比方在每100s中，应用程序会经常 访问某些数据，在其他的100s中会访问其他的数据，splay tree在这种场景中会很好的提高程序的性能。 
一个典型的场景是：例如网络包处理，这种树能起很大的作用，因为在相近的时间段中，网络包有同样IP的可能性很大。

伸展树 在维基中的定义： 伸展树（英语：Splay Tree）是一种二叉查找树，它能在O(log n)内完成插入、查找和删除操作
优点
    可靠的性能——它的平均效率不输于其他平衡树。
    存储所需的内存少——伸展树无需记录额外的什么值来维护树的信息，相对于其他平衡树，内存占用要小。
    支持可持久化——可以将其改造成可持久化伸展树。可持久化数据结构允许查询修改之前数据结构的信息，对于一般的数据结构，每次操作都有可能移除一些信息，而可持久化的数据结构允许在任何时间查询到之前某个版本的信息。可持久化这一特性在函数式编程当中非常有用。另外，可持久化伸展树每次一般操作的均摊复杂度是O(log n) 缺点
    伸展树最显著的缺点是它有可能会变成一条链。这种情况可能发生在以非降顺序访问n个元素之后。然而均摊的最坏情况是对数级的——O(log n)

1. SPLAY_HEAD(name, type)
生成一个伸展树类型：name为生成的类型名，type为节点元素类型，一般都是这样声明： 
SPLAY_HEAD(MY_TREE, my_node) root ; 
其展开代码如下: struct MY_TREE { struct my_node *sph_root; }root;

SPLAY_ENTRY(type) 向节点元素中添加管理数据，向数据结构中添加了spe_left和spe_right指针，一般这样使用： 
struct my_node{
    ...
    SPLAY_ENTRY(my_node) entry;
    ... 
};

2. 初始化伸展树
SPLAY_INITIALIZER(root) 
SPLAY_INIT(root) 

3. SPLAY_EMPTY(head)        判断一颗伸展树是否为空

4. SPLAY_PROTOTYPE(name, type, field, cmp)   # 生成声明
主要是声明伸展树内部的几个函数，可以不需要，因为我们可以用SPLAY_GENERATE自动给我们生成
其中name为伸展树定义的类型：MY_TREE
type为节点元素类型：my_node
filed为节点元素中管理成员：entry
cmp为传入的比较函数：int cmp(my_node* w1, my_node* w2) 比较两个节点的大小（必须确保一致性）

SPLAY_GENERATE(name, type, field, cmp)  # 生成定义
自动为我们生成伸展树所有的内部函数，参数类型与上面一样，不需要我们写什么代码

4.1 插入
SPLAY_INSERT(name, x, y)    # 向伸展树添加元素
name为伸展树定义的类型：MY_TREE
x为伸展树对象指针：&root
y为要添加的节点对象指针
宏返回元素冲突的对象指针，如果返回空，说明添加成功

4.2 删除
SPLAY_REMOVE(name, x, y)    # 从伸展树删除元素
y为要删除的节点对象指针
宏返回删除成功的节点指针，若为空，说明没找到该元素

4.3 查找
SPLAY_FIND(name, x, y)      # 伸展树查找
SPLAY_NEXT(name, x, y)

4.4 最小值
SPLAY_MIN(name, x)
从伸展树中取最小值对象

4.5 最大值
SPLAY_MAX(name, x)
从伸展树中取最大值对象

4.6 伸展树遍历
#define SPLAY_FOREACH(x, name, head)                                          \
  for ((x) = SPLAY_MIN(name, head);                                           \
       (x) != NULL;                                                           \
       (x) = SPLAY_NEXT(name, head, x))
}

libevent(redblack tree){
红黑树的特点 它是复杂的，但它的操作有着良好的最坏情况运行时间，并且在实践中是高效的: 
它可以在O(log n)时间内做查找，插入和删除，这里的n是树中元素的数目。
恢复红黑树的属性需要少量(O(log n))的颜色变更(实际是非常快速的)和不超过三次树旋转(对于插入操作是两次)。
虽然插入和删除很复杂，但操作时间仍可以保持为 O(log n) 次。

典型的用途是实现关联数组
红黑树与伸展树主要用途就是数据的 增删改查。

见 libevent/dstest/tree_api.c
}

1. type 为HT_HEAD和HT_ENTRY 与 外部关联的结构体; 如结构体 event_map_entry
2. HT_HEAD(name, type) 定义结构体，结构体自身 引用 外部结构体type。
   name是被定义的结构体，TAILQ_HEAD(name, type) 等于 name
3，HT_ENTRY(type) 定义结构体，结构体自身包含在 type 结构体内，两者相互引用
4. HT_PROTOTYPE(name, type, field, hashfn, eqfn) name和type为结构体，field为HT_ENTRY在type结构体中成员变量名称。
   hashfn定义hash函数，eqfn定义查找函数
5. HT_GENERATE(name, type, field, hashfn, eqfn, load, mallocfn, reallocfn, freefn)
   name和type为结构体，field为HT_ENTRY在type结构体中成员变量名称。hashfn定义hash函数，eqfn定义查找函数
   load 为hash表长度和hash表内元素 负载比值(但hth_n_entries>=hth_load_limit时，就会发生增长哈希表的长度)。
   mallocfn, reallocfn, freefn 内存申请，重申请，释放函数
6. type 为外部关联结构体 head头指针，elm|listelm|elm2 type类型变量，
   field HT_ENTRY(type)在type中的成员变量名; hashfn为哈希函数，eqfn为查找函数，load配置负载情况
7. 宏连接 -> 重新定义函数名  或 变量名
HT_INIT(name, head)                  name##_HT_INIT(head)               void
HT_CLEAR(name, head)                 name##_HT_CLEAR(head)              void
HT_FIND(name, head, elm)             name##_HT_FIND((head), (elm))      struct type *
HT_INSERT(name, head, elm)           name##_HT_INSERT((head), (elm))    void
HT_REPLACE(name, head, elm)          name##_HT_REPLACE((head), (elm))   struct type *
HT_REMOVE(name, head, elm)           name##_HT_REMOVE((head), (elm))    struct type *
HT_START(name, head)                 name##_HT_START(head)              struct type **
HT_NEXT(name, head, elm)             name##_HT_NEXT((head), (elm))      struct type **
HT_NEXT_RMV(name, head, elm)         name##_HT_NEXT_RMV((head), (elm))  struct type **
   
libevent(ht 哈希表){ 见 libevent\dstest\hashtable.c
1. HT_HEAD和HT_ENTRY用于定义struct类型，所以
HT_HEAD(name, type)   HT_HEAD(event_io_map, event_map_entry);  定义event_io_map类型
HT_ENTRY(type)        HT_ENTRY(event_map_entry) map_node;      定义HT_ENTRY(event_map_entry)类型

2. 初始化
HT_INITIALIZER()         # 初始化ht,赋值即可
HT_INIT(name, head)      # 初始化name类型的head指针

3. HT_EMPTY(head)        # 判断哈希表是否为空
   HT_SIZE(head)         # 获得哈希表大小
   
4. 头尾，后继
HT_START(name, head)
HT_NEXT(name, head, elm)
HT_NEXT_RMV(name, head, elm)

5. 遍历
HT_FOREACH(x, name, head) 

6. 查找，插入，替换，删除
HT_FIND(name, head, elm)
HT_INSERT(name, head, elm) 
HT_REPLACE(name, head, elm)
HT_REMOVE(name, head, elm)

7. 清除
HT_CLEAR(name, head)

8. 声明和定义
#define HT_PROTOTYPE(name, type, field, hashfn, eqfn)
#define HT_GENERATE(name, type, field, hashfn, eqfn, load, mallocfn,reallocfn, freefn) 
}

libuv 中的堆是树堆，libevent中的堆是数组堆
libevent(heap){
typedef struct min_heap{
    struct event** p; # 只需要将event换成自己设计的元素，即可重新使用堆操作。
    unsigned n, a;
} min_heap_t;


min_heap_ctor(&base->timeheap); 堆分配
ev = min_heap_top(&base->timeheap) 堆顶
min_heap_empty(&base->timeheap) 堆判空
min_heap_dtor(&base->timeheap)  堆释放
min_heap_size(&base->timeheap)  堆大小
min_heap_reserve(&base->timeheap, 1 + min_heap_size(&base->timeheap) 堆扩展
min_heap_erase(&base->timeheap, ev); 出堆
min_heap_push(&base->timeheap, ev);  入堆

}
libevent(IO处理相关模块接口){ 
evutil.c # 对不同平台下的网络实现的差异进行抽象；
int evutil_open_closeonexec_ 设置FD_CLOEXEC
int evutil_read_file_        读取文件所有内容
int evutil_socketpair        创建双向socket
int evutil_make_socket_nonblocking 非阻塞设置
int evutil_make_listen_socket_reuseable 设置listen类型socket地址重用
int evutil_make_listen_socket_reuseable_port 设置listen类型socket端口重用
int evutil_make_tcp_listen_socket_deferred   设置listen类型socket当客户端请求才出发accept
int evutil_make_socket_closeonexec(evutil_socket_t fd)  设置FD_CLOEXEC
int evutil_closesocket(evutil_socket_t sock)  关闭socket
void evutil_getaddrinfo_infer_protocols(struct evutil_addrinfo *hints) 在socktype和protocol之间相互推断
int evutil_getaddrinfo(const char *nodename, const char *servname,
    const struct evutil_addrinfo *hints_in, struct evutil_addrinfo **res)  getaddrinfo函数
# 更多工作用于windows和linux系统之间统一接口。
# 更多的用于socket创建和accept获取，nonblock设置。

1. 一站式监听socket,与libevent事件驱动绑定
struct evconnlistener *evconnlistener_new_bind(struct event_base *base, 
                                               evconnlistener_cb cb,
                                               void *ptr, 
                                               unsigned flags, 
                                               int backlog, 
                                               const struct sockaddr *sa,
                                               int socklen)
                                               
2. 三步实现连接socket,与libevent和bufferevent绑定
struct bufferevent *bufferevent_socket_new(struct event_base *base, 
                                              evutil_socket_t fd,
                                              int options)
void bufferevent_setcb(struct bufferevent *bufev,
                       bufferevent_data_cb readcb, 
                       bufferevent_data_cb writecb,
                       bufferevent_event_cb eventcb, 
                       void *cbarg)
int bufferevent_socket_connect(struct bufferevent *bev,
                               const struct sockaddr *sa, 
                               int socklen)
                               
3. 三步实现accept方式socket，与libevent和bufferevent绑定
struct bufferevent *bufferevent_socket_new(struct event_base *base, 
                                              evutil_socket_t fd,
                                              int options)
void bufferevent_setcb(struct bufferevent *bufev,
                       bufferevent_data_cb readcb, 
                       bufferevent_data_cb writecb,
                       bufferevent_event_cb eventcb, 
                       void *cbarg)
int bufferevent_enable(struct bufferevent *bufev, short event) 

}

libevent-book/examples_01/01_rot13_server_bufferevent.c  # bufferevent
libevent-bench/bench-server.c                            # 
libevent-book/examples_01/01_rot13_server_libevent.c     # 普通编程模式
libevent(bufferevent编程模式和普通编程模式差别){
总结：普通编程模式在读写前进行函数回调，在函数回调内进行数据读写(自行管理读取和写入数据)。
      bufferevent编程模式在读写后进行函数回调，在函数回调内进行数据读写(bufferevent自动管理读取和写入数据)。
bufferevent模式下，在回调函数内对请求数据进行有效性判断和处理请求，然后对请求进行响应。

总结：普通的events在底层传输系统准备好读或写的时候就调用回调函数。
      bufferevent 在已经写入或者读出数据之后才调用回调函数。

总结： 普通编程模式
1. 决定向一个链接中写入一些数据；
2. 将数据放入缓冲区中；
3. 告知select|poll|epoll期望进行写数据
4. 等待该链接变得可写；
5. 写入尽可能多的数据；
6. 记住写入的数据量，如果还有数据需要写入，则需要：再次告知select|poll|epoll期望进行写数据

struct event_pair {
    evutil_socket_t  fd;
    struct event  *read_event;
    struct event  *write_event;
};
# 检查event状态
      
1. 缓存管理方面
普通编程模式：没有提供缓存管理；
    a. 对于klv类型协议，缓存接收数据，状态在header定长和data不定长两种模式之间转换。
    b. 对于定长类型协议，缓存接收数据，状态只有header定长状态。
    c. 对于特定字符结尾协议(http). 在协议限定的长度内缓存数据，使用strstr查找结尾字符串和使用memove搬移缓存数据
    d. 对于特定模式协议(json和xml).在协议限定的长度内缓存数据，使用strstr查找结尾字符串和使用memove搬移缓存数据
bufferevent编程模式: 提供缓存管理
    a. 对于klv类型协议，状态在header定长和data不定长两种模式两种状态间，判定当前数据长度是否满足。
    b. 对于定长类型协议，状态只有header定长状态，数据长度只有一个。
    c. 对于特定字符结尾协议(http)：evbuffer_find和evbuffer_search，然后进行evbuffer_add_buffer或者evbuffer_remove_buffer
    d. 对于特定模式协议(json和xml): evbuffer_find和evbuffer_search，然后进行evbuffer_add_buffer或者evbuffer_remove_buffer
总结： 普通编程模式比较适合处理klv和定长类型协议，dns是实现klv协议的一个实例
       bufferevent编程模式可以更好的处理http和json，xml类型协议。http是实现特定字符结尾的一个实例
总结： 普通编程模式时，由于read和write关联到两个event，因此，在释放连接资源时，需要关注读和写event的关联性。
       bufferevent编程模式，由于readbuffer和writebuffer被统一在bufferevent之下，所以，不需要关注读写event的关联性。


2. 回调函数方面
普通编程模式：需要注册readcb和writecb两个回调函数，
2.1 a. 在readcb中接收数据-修改缓冲区对象状态-[处理缓冲区内数据]，
    b. [如果接收函数返回0或者-1(EAGAIN|EWOULDBLOCK外)，释放缓冲区+释放socket+释放event]
    c. 确定是否继续读event_add(注意arg参数)；event_del() # 持久性读
2.2 a. 在writecb中判断缓冲区对象状态-发送数据-修改缓冲区对象状态。
    b. [如果发送函数-1(EAGAIN|EWOULDBLOCK外)，释放缓冲区+释放socket+释放event]
    c. 确定是否继续写event_add(注意arg参数)；event_del() # 条件性写
    
bufferevent编程模式: 需要注册readcb和eventcb回调函数
2.3 a. 在readcb中接收数据，判断数据长度是否正确或者判断数据内容是否合法
    b. [如果数据长度错误或者数据内容不合法，释放bufferevent对象，顺带释放对应socket+event]
    c. 确定是否继续读bufferevent_enable(bev, EV_READ); bufferevent_disable(bev, EV_READ);# 持久性读
2.4 a. 在eventcb中监听 BEV_EVENT_EOF，BEV_EVENT_ERROR，BEV_EVENT_TIMEOUT。不能继续则调用bufferevent_free(bev);
2.5 a. 在readcb处理应答性发送evbuffer_add，在线程执行中执行主动发送evbuffer_add。
总结： 普通编程模式需要注册readcb和writecb两个回调函数，并在回调函数中实现缓冲区对象管理，连接对象管理和接收发送事件添加+删除。
       bufferevent编程模式需要注册readcb和eventcb。其中readcb处理数据接收和应答性发送，eventcb处理bufferevent对象管理
  普通编程模式和bufferevent编程模式回调函数内都不实现主动发送；readcb函数内都要进行协议处理。
  
总结：bufferevent的超时设置，
void bufferevent_set_timeouts(struct bufferevent *bufev, const struct timeval *timeout_read, const struct timeval *timeout_write);
bufferevent在eventcb中通过what判断BEV_EVENT_TIMEOUT，进一步判断是BEV_EVENT_READING还是BEV_EVENT_WRITING。
      普通编程模式的超时设置
      int event_add(struct event *ev, const struct timeval *tv); 
普通编程模式分别在readcb和writecb中通过EV_TIMEOUT，判断当前是读写请求还是超时事件。
}
libevent(evdns+异步回调){
struct evutil_addrinfo  *res,     # dns请求结果
struct evdns_getaddrinfo_request, # dns连接信息
struct evdns_base  *dns_base,     # dns配置信息

# 通过注册回调函数和执行回调函数实现异步回调；
struct evdns_getaddrinfo_request *evdns_getaddrinfo(struct evdns_base *dns_base,            # dns配置信息
                                                    const char *nodename,                   # 输入参数
                                                    const char *servname,                   # 输入参数
                                                    const struct evutil_addrinfo *hints_in, # 输入参数
                                                    evdns_getaddrinfo_cb cb,                # 回调函数
                                                    void *arg);                             # 额外数据
typedef void (*evdns_getaddrinfo_cb)(int result,                   # 函数返回值
                                     struct evutil_addrinfo *res,  # 输出参数
                                     void *arg);                   # 额外数据
增加参数: 额外数据+回调函数+函数返回值
管理数据: evdns_base配置数据，evdns_getaddrinfo_request连接信息。
int evutil_getaddrinfo(const char *nodename,                  # 输入参数
                       const char *servname,                  # 输入参数
                       const struct evutil_addrinfo *hints,   # 输入参数
                       struct evutil_addrinfo **res);         # 输出参数
                       

struct event *event_new(struct event_base *base,                     # event管理对象
                        evutil_socket_t fd,                          # 输入参数
                        short events,                                # 输入参数
                        void (*cb)(evutil_socket_t, short, void *),  # 回调函数
                        void *arg)                                   # 额外数据
                        
void (*cb)(evutil_socket_t,  # 输入参数
           short,            # 输入参数
           void *)           # 额外数据
增加参数: 额外数据+回调函数+函数返回值
管理数据: event_base event管理对象，event对象。
输入event对象和输出event对象通过额外参数建立关联关系。 本质是以地址为索引。

int poll(struct pollfd *fds,      # 输入输出参数
         nfds_t nfds,             # 输入参数
         int timeout);            # 输入参数
int select(int nfds,                  # 输入参数
           fd_set *readfds,           # 输入输出参数
           fd_set *writefds,          # 输入输出参数
           fd_set *exceptfds,         # 输入输出参数
           struct timeval *timeout);  # 输入输出参数
int epoll_wait(int epfd,                    # 输入参数
               struct epoll_event *events,  # 输出参数
               int maxevents,               # 输入参数
               int timeout);                # 输入参数
               
1. a. 注册函数关联对象：event
   b. 关联对象的管理对象: event_base
   c. 额外参数
2. 同步函数调用接口的输入输出参数
   同步函数调用接口的返回值
   同步函数调用环境参数
}

libevent(日志注册回调){
1. 无状态信息

# 注册函数回调和执行函数回调输入参数和输出参数相同
typedef void (*event_log_cb)(int severity,        # 输入参数
                             const char *msg);    # 输入参数
void event_set_log_callback(event_log_cb cb);

void event_log(int severity,      # 输入参数
               const char *msg)   # 输入参数

# 注册函数回调和执行函数回调输入参数和输出参数相同
typedef void (*event_fatal_cb)(int err);  # 输入参数
void event_set_fatal_callback(event_fatal_cb cb);
void event_exit(int errcode) # 输入参数
}

libevent(令牌桶算法){ rate-limit-algorithm
    限流的英文是 Rate limit，维基百科中的定义比较简单。我们编写的程序可以被外部调用，Web 应用通过浏览
器或者其他方式的 HTTP 方式访问，接口的访问频率可能会非常快，如果我们没有对接口访问频次做限制可能会导致服务器无
法承受过高的压力挂掉，这时候也可能会产生数据丢失。
    限流算法就可以帮助我们去控制每个接口或程序的函数被调用频率，它有点儿像保险丝，防止系统因为超过访问频率或并发
量而引起瘫痪。我们可能在调用某些第三方的接口的时候会看到类似这样的响应头
X-RateLimit-Limit: 60         //每秒60次请求
X-RateLimit-Remaining: 23     //当前还剩下多少次
X-RateLimit-Reset: 1540650789 //限制重置时间
上面的 HTTP Response 是通过响应头告诉调用方服务端的限流频次是怎样的，保证后端的接口访问上限。
策略就是拒绝超出的请求，或者让超出的请求排队等待。
1. 计数器法
可以在程序中设置一个变量 count，当过来一个请求我就将这个数 +1，同时记录请求时间。
当下一个请求来的时候判断 count 的计数值是否超过设定的频次，以及当前请求的时间和第一次请求时间是否在 1 分钟内。
    如果在 1 分钟内并且超过设定的频次则证明请求过多，后面的请求就拒绝掉。
    如果该请求与第一个请求的间隔时间大于 1 分钟，且 count 值还在限流范围内，就重置 count。
这种方法虽然简单，但也有个大问题就是没有很好的处理单位时间的边界。

2. 滑动窗口


常用的算法{
    1、计数器法【临界问题】
    2、滑动窗口
    3、漏桶算法
    4、令牌桶算法
}
}

libevent_libuv_libev(){
[libevent]
1. 基本libevent -- 支持所有类型流
struct event *event_new (struct event_base *base,
                         evutil_socket_t    fd,
                         short              what,
                         event_callback_fn  cb,
                         void              *arg);
int event_add(struct event *ev, const struct timeval *tv); 
void event_get_assigement(const struct event  *event,
                           struct event_base  **base_out,
                           evutil_short_t      *fd_out,
                           short               *events_out,
                           event_callback_fn   *callback_out,
                           void                *arg_out);
int event_del(struct event *ev); 
void event_free (struct event *event);
# read write 与 EV_TIMEOUT EV_READ EV_WRITE EV_SIGNAL EV_PERSIST EV_ET
应用自己处理read write等IO操作 和 流数据缓存
2. 流读写缓存libevent -- 仅支持stream类型流
struct bufferevent *bufferevent_socket_new(struct event_base *base,
                                           evutil_socket_t fd,
                                           enum bufferevent_options options);
int  bufferevent_socket_connect(struct bufferevent *bev,
                                struct sockaddr *address, int addrlen);
int bufferevent_socket_connect_hostname(struct  bufferevent *bev,
                                        struct evdns_base *dns_base,  
                                        int family, 
                                        const char *hostname,
                                        int port); 
struct evbuffer *bufferevent_get_input(struct bufferevent *bufev);
struct evbuffer *bufferevent_get_output(struct bufferevent *bufev);

int bufferevent_write(struct bufferevent *bufev, const void *data, size_t size);  # 返回0表示成功，返回-1表示发生了错误。
int bufferevent_write_buffer(struct bufferevent *bufev, struct evbuffer *buf);    # 返回0表示成功，返回-1表示发生了错误。
size_t bufferevent_read(struct bufferevent *bufev, void *data, size_t size);  # 该函数返回0实际移除的字节数，返回-1表示失败。
int bufferevent_read_buffer(struct bufferevent *bufev, struct evbuffer *buf); # 该函数返回0表示成功，返回-1表示失败。
libevent处理read write等IO操作 和 流数据缓存

3. 支持超时IO消息，支持优先级

[libuv]
1. stream类型(tcp pipe tty)
libuv处理read write等IO操作，流数据接收由应用自己处理，流数据发送由libuv处理
2. udp类型
libuv处理read write等IO操作，流数据接收由应用自己处理，流数据发送由libuv处理
3. poll类型
4. 不支持超时IO消息，不支持优先级 -> 需要通过ev_timer和ev_poll配合实现超时IO消息

[libev]
1. ev_io
应用自己处理read write等IO操作 和 流数据缓存
2. 不支持超时IO消息，不支持优先级  -> 需要通过ev_timer和ev_poll配合实现超时IO消息
}

libuv 中的堆是树堆，libevent中的堆是数组堆
libuv(heap-inl.h){
在这里实现了一个二叉最小堆。
二叉堆是一种特殊的堆，是完全二叉树或近似完全二叉树，二叉堆有两种：最大堆和最小堆。 
最大堆：父结点的键值总是大于或等于任何一个子节点的键值。
最小堆：父结点的键值总是小于或等于任何一个子节点的键值。

两个结构体：
struct heap_node {
  struct heap_node* left;
  struct heap_node* right;
  struct heap_node* parent;
};

struct heap {
    struct heap_node* min;
    unsigned int nelts;
};
    heap_node定义了子节点的结构，left right parent分别指向左、右和父节点； heap中heap->min是二叉堆的root节点，
heap->nelts是节点总数。

1. heap_init 以 struct heap* heap 为参数，初始化为：
heap->min = NULL;
heap->nelts = 0;

2. heap_min的实现很简单，以struct heap* heap 为参数，返回其min(root)节点：
3. heap_insert方法定义：
void heap_insert(
      struct heap* heap,
      struct heap_node* newnode,
      heap_compare_fn less_than)

heap为insert目标heap；newnode是待insert的新节点。 less_than的类型为heap_compare_fn，我们先看heap_compare_fn的类型定义：
typedef int (*heap_compare_fn)(
          const struct heap_node* a,
          const struct heap_node* b);

    heap_compare_fn是一个 参数为两个heap_node指针，返回值类型为int 的 函数指针。这里heap_compare_fn less_than 通常返回0或1，
在heap_insert内部通过less_than(newnode, newnode->parent)的值来判断是否需要和parent节点swap。具体heap_compare_fn less_than
可以通过不同场景来实现具体逻辑，这也是因为struct heap 和 struct heap_node并不会具体描述节点的值。
4. static void heap_node_swap(struct heap* heap,
                       struct heap_node* parent,
                       struct heap_node* child)
heap_node_swap实现 在heap中 交换parent父 child子 两个节点

heap_remove
heap_dequeue

# timer.c 文件中 
void* heap_node[3]; 
int uv_loop_init(uv_loop_t* loop) # 初始化
heap_init((struct heap*) &loop->timer_heap);

int uv_timer_start # 添加
heap_insert(timer_heap(handle->loop), (struct heap_node*) &handle->heap_node,  timer_less_than);  

void uv__run_timers 和 int uv__next_timeout # 最小值
heap_node = heap_min(timer_heap(loop)); -> handle = container_of(heap_node, uv_timer_t, heap_node);

int uv_timer_stop(uv_timer_t* handle) # 删除
heap_remove(timer_heap(handle->loop), (struct heap_node*) &handle->heap_node, timer_less_than);

}
libuv(queue){
queue.h中定义了一个双向链表 链表的类型定义如下：
/*包含两个指针元素（void*）的数组*/
typedef void *QUEUE[2];
整个双向列表的方法都是由宏实现.

struct handle_t { int val; QUEUE node; };
void handle_init(struct handle_t* handle_p, int val);

static QUEUE* q;
static QUEUE queue;
static QUEUE queue1;
static QUEUE queue2;

int main() {
	struct handle_t* handle_p;
	/*QUEUE_INIT(q) 初始化链表*/
	QUEUE_INIT(&queue);
	QUEUE_INIT(&queue1);
	QUEUE_INIT(&queue2);

	struct handle_t handle1;
	handle1.val = 1;
	handle_init(&handle1, 1);

	struct handle_t handle2;
	handle_init(&handle2, 2);

	struct handle_t handle3;
	handle_init(&handle3, 3);

	struct handle_t handle4;
	handle_init(&handle4, 4);

	struct handle_t handle5;
	handle_init(&handle5, 5);

	struct handle_t handle6;
	handle_init(&handle6, 6);

	//从尾部插入节点
	QUEUE_INSERT_TAIL(&queue, &handle1.node);
	QUEUE_INSERT_TAIL(&queue, &handle2.node);
	QUEUE_INSERT_TAIL(&queue, &handle3.node);
	//从头部插入节点
	QUEUE_INSERT_HEAD(&queue1, &handle4.node);
	QUEUE_INSERT_HEAD(&queue1, &handle5.node);
	QUEUE_INSERT_HEAD(&queue1, &handle6.node);

    QUEUE_ADD(h, n) 链接 h和n 两个链表
	QUEUE_ADD(&queue, &queue1);

    QUEUE_FOREACH(q, h)用于遍历队列 打印结果为：
        这里q初始值为QUEUE_HEAD(h) 通过QUEUE_NEXT(q) 遍历链表直到（q）== (h)停止
        通过QUEUE_DATA取到我们真正需要的数据结构，取到val值 具体实现会在后面分析，打印结果为

	QUEUE_FOREACH(q, &queue) {
    	handle_p = QUEUE_DATA(q, struct handle_t, node);
    	printf("%d\n", handle_p->val);
	};

    QUEUE_HEAD(h)的内部实现就是调用QUEUE_NEXT(h)

	q = QUEUE_HEAD(&queue);
    REMOVE q 的操作 其实就是链接 q的prev和q的next:
    QUEUE_PREV_NEXT(q) = QUEUE_NEXT(q);                                       \
     QUEUE_NEXT_PREV(q) = QUEUE_PREV(q);

    QUEUE_REMOVE(q);

    QUEUE_FOREACH(q, &queue) {
    handle_p = QUEUE_DATA(q, struct handle_t, node);
        printf("%d\n", handle_p->val);
    };
    printf("################\n");

    
    QUEUE_MOVE(h, n) 内部通过QUEUE_SPLIT实现，将链表h 移动到 n
    QUEUE_MOVE(&queue, &queue2); 等于下面QUEUE_SPLIT的写法
    QUEUE_SPLIT(&queue, QUEUE_HEAD(&queue), &queue2);
    

	//QUEUE_MOVE(&queue, &queue2);

    QUEUE_SPLIT(h, q, n) 以q将链表h分割为 h 和 n两部分
    QUEUE_SPLIT(&queue, &handle5.node, &queue2);

    QUEUE_FOREACH(q, &queue2) {
        handle_p = QUEUE_DATA(q, struct handle_t, node);
        printf("%d\n", handle_p->val);
    };
	printf("################\n");

    QUEUE_FOREACH(q, &queue) {
        handle_p = QUEUE_DATA(q, struct handle_t, node);
        printf("%d\n", handle_p->val);
    };
    printf("################\n");
}

void handle_init(struct handle_t* handle_p, int val) {
	handle_p->val = val;
	QUEUE_INIT(&handle_p->node);
}

1. libuv中queue操作方法描述与说明
QUEUE_DATA(ptr, type, field)
//获取queue所在的结构的实际数据值
//此用方法多用于libuv内部数据
//例如：
//已知uv_udp_send_t结构的req指针;
//已知其内部QUEUE q的地址，求req的地址，则可使用 
//uv_udp_send_t *req = QUEUE_DATA(q, uv_udp_send_t, queue)来获取 

QUEUE_FOREACH(q, h)
/*
使用q来遍历head queue, q会不停的变换值，如：
QUEUE_FOREACH(q, h)
{
    uv_*_t data= QUEUE_DATA(q, uv_*_t, queue);
}
*/

QUEUE_EMPTY(q)
//判断queue q是否为空，即只有一个节点

QUEUE_HEAD(q)
//初始化HEAD，跟INIT的功能一致，不过INIT的设置了PREV值
//QUEUE_EMPTY(QUEUE_HEAD(q)) 为True

QUEUE_INIT(q)
//初始化q的值，将q的next和prev均指向自己
//QUEUE_EMPTY(QUEUE_INIT(q)) 为True

QUEUE_ADD(h, n)
//在head的前面插入节点node，即在队列尾加入node

QUEUE_SPLIT(h, q, n)
//

QUEUE_MOVE(h, n)
//从head中移除n至end中所有结点，同时n为新的queue中的head

QUEUE_INSERT_HEAD(h, q)
//在head后面插入节点q

QUEUE_INSERT_TAIL(h, q)
//在head前面，也就是队尾插入节点q

QUEUE_REMOVE(q)
//删除节点q
}
arm_ucosii(数据驱动程序与面向对象+时间驱动程序与面向对象){
数据驱动程序与对象
OSMessageBase[ OSQueue ] OnHandleMessage #用于线程之间数据处理，有数据则触发处理，无数据则等待。
OSThreadEx[ OSMessageBase+OSThread ]     #线程和消息队列的组合，使得线程对象和消息队列对象抽象为同一个对象。
CILDevice CILService CThreadPool OSMessageBase #通过两个线程共同完成数据的接收和发送。

时间驱动程序
CFADIMonitor CFeedWatchdog	CFKDBTrigger OSDispatcher #

#对应用于协议解析，命令行处理，错误码对应
解析表(数据封包的时候常用解析表，而解包的时候，使用更底层的数据类型和协议buffer转换函数)
cil_fk.c  # plms_fmt_fn # 将内存数据类型转化为协议数据内容
          # plms_fmt_dt # 对命令选择码进行转换，然后将内存数据类型转化为协议数据内容
          # plms_fmt_tran 和 plms_fmt_appl # 将内存数据类型转化为协议数据内容， 将协议数据内容转化为内存数据类型 
cil_fa.c  # FA_Encode 和 FA_Decode FA_Output 又一个很大解析表，功能不太清楚
FKApp.c   # GetSystemError中的 s_szMsgs 错误输出字符串表
FKDebugger.c #中的 CMD_INNER和l_szThreads中，CMD_INNER为命令行解析表，l_szThreads任务功能表
MetaData.c  # MetaData结构体对应表
cil_dl645.cpp   # DL645_DATA s_DL645[]
pcol_edmi.cpp # MKX_MAP	ls_mapMKX
}

main(moosefs){
1. moosefs将模块初始化划分成两个步骤：initialize(void)和initialize_late(void) 。模块初始化，模块初始化后启动。
2. moosefs将模块结束处理划分为void main_destruct_register (void (*fun)(void)) 、main_canexit_register (int (*fun)(void)) 
   和main_wantexit_register (void (*fun)(void)) 几个步骤，顺序是wantexit、canexit，destruct。模块计划退出、模块可以退出、模块注销。

3. 进程初始化包括：命令行参数解析、配置文件数据解析、错误信息初始化、CRC校验表初始化，进程限制性配置、进程优先级、进行UID和GID更改
                   日志功能初始化、信号初始化和进程守护、前台运行初始化。
4. 进程模块结束后：进行注册框架功能释放，信号注销、配置文件注销和错误日志打印注销、日志输出注销、守护功能注销。
}

    [loop]
    在事件驱动编程中，程序会关注每一个事件，并且对每一个事件的发生做出反应。libuv会负责将来自操作系统的事件收集起来，
或者监视其他来源的事件。这样，用户就可以注册回调函数，回调函数会在事件发生的时候被调用。event-loop会一直保持运行状态。
libuv(loop){
    [update loop time]
    事件循环中的"现在时间(now)"被更新。事件循环会在一次循环迭代开始的时候缓存下当时的时间，用于减少与时间相关的系统调用次数。
    [loop alive?]
    如果事件循环仍是存活(alive)的，那么迭代就会开始，否则循环会立刻退出。如果一个循环内包含激活的可引用句柄，激活的请求或
正在关闭的句柄，那么则认为该循环是存活的。
    [run due timers]
    执行超时定时器(due timers)。所有在循环的"现在时间"之前超时的定时器都将在这个时候得到执行。
    [call pending callbacks]
    执行等待中回调(pending callbacks)。正常情况下，所有的 I/O 回调都会在轮询 I/O 后立刻被调用。但是有些情况下，回调可能会
被推迟至下一次循环迭代中再执行。任何上一次循环中被推迟的回调，都将在这个时候得到执行。
    [run idle handles]
    执行闲置句柄回调(idle handle callbacks)。尽管它有个不怎么好听的名字，但只要这些闲置句柄是激活的，那么在每次循环迭代中
它们都会执行。
    [run prepare handles]
    执行预备回调(prepare handle)。预备回调会在循环为 I/O 阻塞前被调用。
    开始计算轮询超时(poll timeout)。在为 I/O 阻塞前，事件循环会计算它即将会阻塞多长时间。以下为计算该超时的规则：
      如果循环带着 UV_RUN_NOWAIT 标识执行，那么超时将会是 0 。
      如果循环即将停止(uv_stop() 已在之前被调用)，那么超时将会是 0 。
      如果循环内没有激活的句柄和请求，那么超时将会是 0 。
      如果循环内有激活的闲置句柄，那么超时将会是 0 。
      如果有正在等待被关闭的句柄，那么超时将会是 0 。
      如果不符合以上所有，那么该超时将会是循环内所有定时器中最早的一个超时时间，如果没有任何一个激活的定时器，那么超时将会
是无限长(infinity)。
    [poll for io]
    事件循环为 I/O 阻塞。此时事件循环将会为 I/O 阻塞，持续时间为上一步中计算所得的超时时间。所有与 I/O 相关的句柄都将会监视
一个指定的文件描述符，等待一个其上的读或写操作来激活它们的回调。
    [run check handles]
    执行检查句柄回调(check handle callbacks)。在事件循环为 I/O 阻塞结束后，检查句柄的回调将会立刻执行。检查句柄本质上是
预备句柄的对应物(counterpart)。
    [call close callbacks]
    执行关闭回调(close callbacks)。如果一个句柄通过调用 uv_close() 被关闭，那么这将会调用关闭回调。
    
    [UV_RUN_NOWAIT | UV_RUN_ONCE]
    尽管在为 I/O 阻塞后可能并没有 I/O 回调被触发，但是仍有可能这时已经有一些定时器已经超时。若事件循环是以 UV_RUN_ONCE 标识执行，
那么在这时这些超时的定时器的回调将会在此时得到执行。
    迭代结束。如果循环以 UV_RUN_NOWAIT 或 UV_RUN_ONCE 标识执行，迭代便会结束，并且 uv_run() 将会返回。如果循环以 UV_RUN_DEFAUL
标识执行，那么如果若它还是存活的，它就会开始下一次迭代，否则结束。

    [async]
libuv 目前使用了一个全局的线程池，所有的循环都可以往其中加入任务。目前有三种操作会在这个线程池中执行：
    文件系统操作
    DNS 函数(getaddrinfo 和 getnameinfo)
    通过 uv_queue_work() 添加的用户代码
}
libuv(功能点){
libuv强制使用异步和事件驱动的编程风格。
libuv的核心工作是提供一个event-loop，还有基于I/O和其它事件通知的回调函数。
libuv还提供了一些核心工具，例如定时器，非阻塞的网络支持，异步文件系统访问，子进程等。
libuv会负责将来自操作系统的事件收集起来，或者监视其他来源的事件。
操作系统的事件：read|write|connect|close inotify signal等
其他来源的事件：timeout | idle | async | thread notify

libuv编程过程需要关注的对象： uv_loop_t 
                              uv_handle_t 
                                streams      uv_tcp_t uv_tty_t uv_pipe_t
                                udp          uv_udp_t
                                poll         uv_poll_t
                                prepare      uv_prepare_t
                                idle         uv_idle_t
                                async        uv_async_t
                                timer        uv_timer_t
                                process      uv_process_t
                                file system  uv_fs_event_t uv_fs_poll_t
                              uv_req_t       uv_getaddrinfo_t uv_shutdown_t uv_write_t uv_connect_t uv_udp_send_t uv_fs_t uv_work_t uv_connect_t
                              uv_buf_t       绑定在streams udp poll和file system等流或者数据实例上。
  UV_EAGAIN  内核态缓冲区内没数据可读
  UV_ENOBUFS 用户态没有足够内存作为缓冲区
  
  
1. 网络 (tcp              udp         dns interfaces)
         tcp-echo-server  udp-dhcp    dns interfaces
2. 进程 (attach子进程, detach子进程) 
         spawn         detach
   signal(uv_signal_init uv_kill uv_process_kill) signal
   pipe() 1. Parent-child IPC 2. Arbitrary process IPC 3. Sending file descriptors over pipes
             proc-streams        pipe-echo-server         multi-echo-server
3. 文件系统 
    同步读写变异步读写  
    uvcat uvtee
    inotify功能 uv_fs_event_init
    onchange
    stdin stdout stderr 与 uv_pipe_init 管道
    uvcat uvtee
4. 线程 互斥量，读写量，信号量，条件变量和屏障   -> uv_async_init
   线程接口封装      thread-create             https://computing.llnl.gov/tutorials/pthreads/
   线程池            queue-work queue-cancel
   mutex互斥锁       
   condition条件锁   
   semaphore信号量             https://en.wikipedia.org/wiki/Semaphore_(programming)
   barrier栅栏锁     locks     https://en.wikipedia.org/wiki/Barrier_(computer_science)
   read-write读写锁  locks     
   
5. 工具库
    uv_timer_init   ref-timer
    uv_ref uv_unref ref-timer detach
    uv_idle_init    idle-compute idle-basic
    uv_work_t req   queue-work queue-cancel
    uv_poll_init    uvwget
    uv_dlopen       plugin
    uv_tty_init     tty tty-gravity
    uv_async_t      progress

[编程思考]
    系统编程中最经常处理的一般是输入和输出，而不是一大堆的数据处理。
    向文件写入数据，从网络读取数据所花的时间，对比CPU的处理速度差得太多。
    解决方案 1. 多线程。 2. 异步，非阻塞风格。
    
    TCP是面向连接的，字节流协议，因此基于libuv的stream实现。
    用户数据报协议(User Datagram Protocol)提供无连接的，不可靠的网络通信。因此，libuv不会提供一个stream实现的形式，
而是提供了一个uv_udp_t句柄(接收端)，和一个uv_udp_send_t句柄(发送端)，还有相关的函数。

    说libuv是异步的，是因为程序可以在一头表达对某一事件感兴趣，并在另一头获取到数据(对于时间或是空间来说)。 
    -- 必然使用全局变量或堆上数据保存连接状态和接收、发送数据状态。
    说libuv是非阻塞是因为应用程序无需在请求数据后等待，可以自由地做其他的事。

     在UNIX中有一个共识，就是进程只做一件事，并把它做好。因此，进程通常通过创建子进程来完成不同的任务
一个多进程的，通过消息通信的模型，总比多线程的，共享内存的模型要容易理解得多。

    你必须以管理员的权限运行udp-dhcp，因为它的端口号低于1024
    ip地址为0.0.0.0，用来绑定所有的接口。255.255.255.255是一个广播地址，这也意味着数据报将往所有的子网接口中发送。
端口号为0代表着由操作系统随机分配一个端口。
    我们设置了一个用于接收socket绑定了全部网卡，端口号为68作为DHCP客户端，然后开始从中读取数据。它会接收所有来自
DHCP服务器的返回数据。我们设置了UV_UDP_REUSEADDR标记，用来和其他共享端口的 DHCP客户端和平共处。接着，我们设置了
一个类似的发送socket，然后使用uv_udp_send向DHCP服务器（在67端口）发送广播。
    设置广播发送是非常必要的，否则你会接收到EACCES错误。和此前一样，如果在读写中出错，返回码<0。
    因为UDP不会建立连接，因此回调函数会接收到关于发送者的额外的信息。
    当没有可读数据后，nread等于0。如果addr是null，它代表了没有可读数据（回调函数不会做任何处理）。如果不为null，
则说明了从addr中接收到一个空的数据报。如果flag为UV_UDP_PARTIAL，则代表了内存分配的空间不够存放接收到的数据了，
在这种情形下，操作系统会丢弃存不下的数据。
}

libuv(胶合层){ 给我一个支点，我可以撬起整个地球 -> 给我一点全局变量，我可以撬起一个模块。
1. 使用 void 类型的data指针 实现闭包
[uv_loop_t 私有数据和uv_handle_t 链表]
uv_loop_t.handle_queue[2] 一个uv_handle_t 链表 # 将管理对象抽象成一致对象
uv_loop_t.data            指向私有数据         # 多实例保存私有数据，也可以说是环境数据

[ uv_handle_t回指uv_loop_t，uv_handle_t 链表， uv_handle_t 私有数据 ]
uv_handle_t.loop = uv_loop   指向主loop            # 快速引用主loop的公有数据和函数
uv_handle_t.handle_queue[2]  一个uv_handle_t 链表  # 遍历
uv_handle_t.data = 私有数据 [peer_state_t]         # 业务处理数据内容

[ peer_state_t回指uv_tcp_t, peer_state_t 链表， peer_state_t 回指 g_list_head，业务数据 ]
typedef  struct peer_state_s {
  uint64_t number;
  uv_tcp_t* client;
  char sendbuf[SENDBUF_SIZE];
  int sendbuf_end;
  struct peer_state_s *next;
  struct peer_state_s *head;
} peer_state_t;
peer_state_t.client = [uv_handle_t] # 数据驱动调度实例
uv_handler_t.data   = peer_state_t  # 业务处理数据内容
uv_handler_t.next   = peer_state_s  # 遍历
peer_state_t.head   = g_list_head   # 快速引用主loop的公有数据和函数

2. 使用编译器特性实现闭包
libuv暗示隐形携带数据 到 socket()绑定参数时，指定struct sockaddr和指定长度。
typedef struct {
  uv_write_t req;
  uv_buf_t buf;
} write_req_t;

3. 指定 addr和addrlen长度
int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
}

https://en.wikipedia.org/wiki/Barrier_(computer_science) # 多线程协助完成某一特定任务。
stop   0      1<total      stop=total
pass   0      0            1
total  total  total        total
       初始   线程阻塞     线程执行
libuv(barrier){ 限制最多只能有
struct _uv_barrier {
  uv_mutex_t mutex;    # 线程之间数据保护
  uv_cond_t cond;      # 数据驱动型触发
  unsigned threshold;  # 阀值
  unsigned in;         # wait调用次数
  unsigned out;        # 
};
int uv_barrier_init(uv_barrier_t* barrier, unsigned int count); # 设置栅栏阀值并初始化
void uv_barrier_destroy(uv_barrier_t* barrier);                 # 销毁栅栏
void uv_barrier_wait(uv_barrier_t* barrier);                    # 当执行wait的次数等于count设定次数时，所有线程同步执行wait下面代码

# 主线程阻塞等待子线程退出；对子线程进行连接(uv_thread_join);
main-thread      child-thread       child-thread        ... ...
uv_barrier_init  uv_thread_create   uv_thread_create    ... ...
uv_barrier_wait  do_worker          do_worker
                 uv_barrier_wait    uv_barrier_wait
uv_thread_join(child-thread) 
uv_barrier_destroy
}

https://en.wikipedia.org/wiki/Monitor_(synchronization)#Mutual_exclusion
https://en.wikipedia.org/wiki/Lock_(computer_science)
libuv(mutex){ advisory劝告型 mandatory强制性  锁是二进制信号量
debug功能
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_ERRORCHECK)
递归加锁
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)

"test-and-set", "fetch-and-add" "compare-and-swap".
}
libuv(once){
pthread_once(guard, callback)
}

https://en.wikipedia.org/wiki/Semaphore_(programming)
libuv(semaphore){
信号量 # 运行线程不能超过指定个数
typedef struct uv_semaphore_s {
  uv_mutex_t mutex;
  uv_cond_t cond;
  unsigned int value;
} uv_semaphore_t; 
int uv_sem_init(uv_sem_t* sem, unsigned int value);
void uv_sem_destroy(uv_sem_t* sem);
void uv_sem_post(uv_sem_t* sem);
void uv_sem_wait(uv_sem_t* sem);
int uv_sem_trywait(uv_sem_t* sem);

对其的关键访问被保证是原子操作.如果一个程序中有多个线程试图改变一个信号量的值，系统将保证所有的操作都将依次进行。
而只有0和1两种取值的信号量叫做二进制信号量,在这里将重点介绍.而信号量一般常用于保护一段代码, 使其每次只被一个执行线程运行。
我们可以使用二进制信号量来完成这个工作。

int sem_init(sem_t *sem, int pshared, unsigned int value);  
描述:
    sem_init() 初始化 sem 的匿名信号量. value 参数指定信号量的初始值。
    如果是进程内的线程共享,信号量sem要放置在所有线程都可见的地址上(如全局变量，或者堆上动态分配的变量)。
    如果是进进程之间共享,信号量sem要放置在共享内存区域(shm_open(3)、mmap(2) 和 shmget(2))。
    (因为通过 fork(2) 创建的孩子继承其父亲的内存映射，因此它也可以见到这个信号量。)
    所有可以访问共享内存区域的进程都可以使用sem_post(3)、sem_wait(3) 等等操作信号量。
    初始化一个已经初始的信号量其结果未定义.
参数：
    sem: 信号量指针,要被赋值
    pshared：指明信号量是由进程内线程共享,还是由进程之间共享
             0:进程内的线程共享
             非零值: 进程之间共享
    value : 信号量的初始值
返回值:
    成功: 0
    失败: -1 ,并把 errno 设置为合适的值, errno值如下:
            EINVAL: value超过 SEM_VALUE_MAX。
            ENOSYS: pshared 非零,但系统还没有支持进程共享的信号量。

int sem_wait(sem_t * sem);   

描述:
    信号量减一操作.
    sem_wait函数也是一个原子操作,它的作用是从信号量的值减去一个"1",
    但它永远会先等待该信号量为一个非零值才开始做减法.也就是说，如果你对一个值为2的信号量调用sem_wait(),线程将会继续执行.
    这信号量的值将减到1。
    如果对一个值为0的信号量调用sem_wait()，这个函数就会阻塞等待直到有其它线程增加了这个值使它不再是0为止.
    如果有两个线程都在sem_wait()中等待同一个信号量变成非零值，那么当它被第三个线程增加 一个"1"时,
    等待线程中只有一个能够对信号量做减法并继续执行.另一个还将处于阻塞等待状态。
返回值:
    成功: 0
    失败: -1 ,并把 errno 设置为合适的值, errno值如下:
            EINTR: 这个调用被信号处理器中断
            EINVAL: sem 不是一个有效的信号量
            
            
int sem_post(sem_t * sem);
描述:
    sem_post函数的作用是给信号量的值加上一个"1"，它是一个"原子操作"
    即同时对同一个信号量做加"1"操作的两个线程是不会冲突的；
    而同时对同一个文件进行读、加和写操作的两个程序就有可能会引起冲突。
    信号量的值永远会正确地加一个"2"－－因为有两个线程试图改变它
返回值:
    成功: 0
    失败: -1 ,并把 errno 设置为合适的值, errno值如下:
            EINVAL: sem 不是一个有效的信号量
            EOVERFLOW: 信号量允许的最大值将要被超过
nt sem_destroy(sem_t *sem);  
描述:
这个函数也使用一个信号量指针做参数,归还自己申请的一切资源.在清理信号量的时候如果还有线程在等待它,用户就会收到一个错误.

返回值:
    成功: 0
    失败: -1
    
}
https://en.wikipedia.org/wiki/Monitor_(synchronization)#Condition_variables
libuv(condition){
int uv_cond_init(uv_cond_t* cond);
void uv_cond_destroy(uv_cond_t* cond);
void uv_cond_signal(uv_cond_t* cond);
void uv_cond_broadcast(uv_cond_t* cond);


/* Waits on a condition variable without a timeout.
 *
 * Note:
 * 1. callers should be prepared to deal with spurious wakeups.
 */
void uv_cond_wait(uv_cond_t* cond, uv_mutex_t* mutex);


/* Waits on a condition variable with a timeout in nano seconds.
 * Returns 0 for success or UV_ETIMEDOUT on timeout, It aborts when other
 * errors happen.
 *
 * Note:
 * 1. callers should be prepared to deal with spurious wakeups.
 * 2. the granularity of timeout on Windows is never less than one millisecond.
 * 3. uv_cond_timedwait takes a relative timeout, not an absolute time.
 */
int uv_cond_timedwait(uv_cond_t* cond, uv_mutex_t* mutex, uint64_t timeout);
}
toybox(把知识叠入数据以求逻辑质朴而健壮){

}
toybox(从busybox toybox ubox是一次一次重复，也为减少生成代码量){
[lib.c]
1. 单个文件描述符，不调用poll超时等待，不处理异常
readall  ：返回已读取数据的长度。
writeall ：返回完全写入数据长度，或者返回写入失败异常。

safe_poll 屏蔽了EINTR和ENOMEM异常
}

busybox(){
[read.c和full_write.c]
1. 单个文件描述符，不调用poll超时等待，处理异常
xread
xwrite

full_read  返回已读取数据的长度。读取数据错误返回错误码（未读到任何数据）。
full_write 返回已写入数据的长度。写入数据错误返回错误码（未写入任何数据）。

提供open_read_close函数。
}

busybox(? syslogd.c){
[来源]
logread命令：logger命令： # /dev/log
[发往地]
log_locally()...          # reopen  # 代码可读性有待提高，可读性。
try_to_resolve_remote()   # 可以往远程主机的514端口上发送UDP报文。
log_to_shmem              # 支持将日志信息写入共享内存缓冲区
[内核数据来源]
/proc/kmsg                # 内核数据
klogctl                   # dmesg函数
-------------------------------------------------------------------------------
输出到：网络(TCP/UDP);本地文件(文件自动轮转)；前端输出(-f跟踪输出)；共享内存(循环输出)；
输入源：kmsg(内核消息)；/dev/log(主机进程消息)；本地unix(新建业务功能)；

1. 业务程序向多个输出地进行输出，通过命令行或者配置文件可以指定向多个地方；
2. logread和tail之类通过管道从服务器进程或者文件获取数据的，结果总是输出到一个地方；通过命令行配置输出功能。
-------------------------------------------------------------------------------
syslogd -> busybox(syslogd) -> ubox(logd)
           /etc/syslogd.conf

klogd [Kernel logger]
-c n    Sets the default log level of console messages to n
-n      Run as a foreground process
}

dnsmasq(poll异步回调){
fd和event共同构成了pollfd *fds对象；
void poll_listen(int fd, short event)   # 输入参数
int poll_check(int fd, short event)     # 返回值作为输出参数

int poll(struct pollfd *fds,      # 输入输出参数
         nfds_t nfds,             # 输入参数
         int timeout);            # 输入参数

# 函数执行流程
poll_reset()
poll_listen(fd, event)
.
.
poll_listen(fd, event);
hits = do_poll(timeout);
if (poll_check(fd, event)
.
.
if (poll_check(fd, event)
.
.
event is OR of POLLIN, POLLOUT, POLLERR, etc
}

dnsmasq(IO处理相关模块接口){
[networking.c]
1. 将read和write统一在一个read和write函数中，同时未使用poll进行阻塞，而是睡眠阻塞读取
   处理EAGAIN、EWOULDBLOCK、EINTR和ENOMEM、ENOBUFS异常
   
read_write
    retry_send睡眠阻塞读取位置：该函数从实现上确实封装的到位。只是内部的nanosleep有点对性能有较大损耗。
    
#  define ERRNO_ERROR (errno!=EAGAIN && errno!=EWOULDBLOCK) # moosefs
errno == EAGAIN 有时 errno == EAGAIN || errno == EINTR      # tcpcopy
                                                            # redis 
moosefs实现的最简单；dnsmasq放弃了性能，且会丢包；tcpcopy和redis比较凌乱。

---------------------------------------
[poll.c]
2. poll.c
   poll框架比较小，提供机制较少，接口比较明确，容易分离，适合单线程应用。
封装了poll函数，设计了流程，提供了简单接口。
[1 -> 2 -> 3 -> 4 -> 1] 所有多路IO处理都是这个处理流程，只是hook点不一样
nfds_t fd_search(int fd)              # 对内 二分法查找
void poll_reset(void)                 # 对外 复位所有注册事件  1 
void poll_listen(int fd, short event) # 对外 注册事件          2
int do_poll(int timeout)              # 对外 监听注册事件      3 
int poll_check(int fd, short event)   # 对外 检验时间是否发生  4 
模块自身管理数据，多客户端需要管理外部的链表。链表通过文件描述符和poll建立映射关系。
---------------------------------------
[关于poll|select|epoll的一些感想]
1. Linux内核的进化以满足应用程序设计需求为目标，应用程序设计以可扩展性和高性能为核心。因此，接口设计的时候
   就出现了从select到poll，再从poll到epoll之间变迁；同时接口也从select到pselect，从poll到ppoll，从epoll_create
   到epoll_create1的更新，而这三个函数要实现的功能却是一致的：实现多路IO。从调用流程上基本上也是一致的。
   这就使得设计者如何在相同的基本流程中构建可扩展的架构，使得可以更易用和更容易扩展。
2. 从dnsmasq到moosefs，从redis到libevent。是在相同机制情况下，实现不同的接口设计。dnsmasq实现的最简单最透明，由
   由胶合层的主程序驱动整个poll调用的四步骤无限执行。而moosefs比较模块化，将整个poll调用第2步和第4步作为回调函数
   交给其他模块来实现。相比而言，redis的ac.c作为模块显得更层次化，厚实了一点，因为对poll的注册消息进行了重新定义。
   又添加了更多参数的回调函数。libevent也如此厚实，同时新增了buffer缓冲区模块，增加流处理的复杂性。
3. 正常情况下，接口实现越是厚实，需要的全局变量和状态变量就会越多，而全局变量和状态变量越多，回调函数限制条件也就越多。
   同时为了屏蔽底层的不一致性，也会重新定义接口和状态标识。
4. 模块的功能依赖于POSIX系统提供的接口功能，poll提供的功能;
   4.1 可读写标识的设置和输出
   4.2 无限阻塞超时，有限阻塞超时，非阻塞调用
   4.3 信号EINTR中断，有读写请求，无读写请求有超时请求。

--------------------------------------- fork两次的原因是防止启动程序是进程组领头进程
fork()    1
setsid()  2
fork()    3
[关于daemon的一些感想]
1. Linux内核定义了daemon如何实现的流程，具体如何实现落实到各个程序中可谓各不相同。
moosefs: 1. 有此代码实现的进程可以在前台运行，也可以在后台运行，因此，前台运行时不忽略SIGINT信号，且不调用daemon函数；
         2. 当调用daemon的时候，忽略SIGINT。daemon则：父进程先通过wait收尸子进程；然后等待孙进程告知正常启动再离开。
         3. 文件操作符为：关闭标准输入；由/dev/null覆盖标准输入，由/dev/null覆盖标准输出；错误输出重定向到父进程。
redis  ：创建子进程，父进程退出；子进程创建新会话；打开/dev/null，将标准输入，标准输出，错误输出都重定向到/dev/null
         redis也支持进程前台执行
tcpcopy: moosefs后台执行忽略SIGINT信号，而tcpcopy后台执行忽略SIGHUP；
         tcpcopy也支持进程前台执行
         创建子进程，父进程退出；子进程创建新会话；打开/dev/null，将标准输入，标准输出，错误输出都重定向到/dev/null
         tcpcopy向上层返回daemon失败的失败值，而redis不返回daemon失败后的失败值，全当成功。
dnsmasq：创建子进程，父进程通过管道等待子进程正常启动；如果有错怎提示错误，然后退出；
         打开/dev/null，将标准输入，标准输出，错误输出都重定向到/dev/null
----------------------------------------- 程序启动过程中致命错误
cannot fork into background: 
failed to create helper: 
setting capabilities failed: 
failed to change user-id to 
failed to change group-id to 
failed to open pidfile 
cannot open log 
failed to load Lua script: 
TFTP directory %s inaccessible: %s
cannot create timestamp file 
--------------------------------------- 服务器端流程
1. socket bind listen accept read write close [server]
                      read write close
[关于socket server的一些感想]
1. moosefs对网络部分的封装是简单透明的，没有提供接口级别服务器和客户端实现方法: 服务器和客户端实现依赖
   接口的整合。moosefs对阻塞超时很关注，因此，既提供了阻塞类型连接接口，也提供了非阻塞类型连接接口。而读写
   接口则只提供了阻塞超时类型接口。
   moosefs接口按照数据流(unix,tcp)和数据包进行了分类封装。同时将一些接口属性封装成不同名称的函数。
2. redis对网络部分的封装略微厚实一点，提供接口级别服务器和客户端实现方法: redis不关注阻塞超时条件，而是将
   基本的阻塞非阻塞设置，reuseaddr设置放到了接口内部实现。
   redis接口按照数据流(unix,tcp)进行封装组织。同时提供了keepalive参数设置功能。
3. tcpcopy只支持tcp类型socket建立，支持客户端网络连接。没有考虑连接超时问题，recv和snd靠超时重试进行异常处理
   基本不应对缓冲区满和缓冲区空的的情况。
--------------------------------------- 客户端流程
2. socket bind connect read write close
[关于socket client的一些感想]

阻塞   非阻塞
数据流 数据包

--------------------------------------- 进程管理
fork();&vfork()                               1
setsid();                                     2
execvp();                                     3
waitpid(-1, NULL, suspected_WNOHANG); & child 4

}
wdxtub(网络编程){
开启服务器（open_listenfd 函数，做好接收请求的准备）
---------------------------------------
getaddrinfo: 设置服务器的相关信息，具体可以参见 图1&2
socket: 创建 socket descriptor，也就是之后用来读写的 file descriptor
    int socket(int domain, int type, int protocol)
    例如 int clientfd = socket(AF_INET, SOCK_STREAM, 0);
    AF_INET 表示在使用 32 位 IPv4 地址
    SOCK_STREAM 表示这个 socket 将是 connection 的 endpoint
    前面这种写法是协议相关的，建议使用 getaddrinfo 生成的参数来进行配置，这样就是协议无关的了
bind: 请求 kernel 把 socket address 和 socket descriptor 绑定
    int bind(int sockfd, SA *addr, socklen_t addrlen);
    The process can read bytes that arrive on the connection whose endpoint is addr by reading from descriptor sockfd
    Similarly, writes to sockfd are transferred along connection whose endpoint is addr
    最好是用 getaddrinfo 生成的参数作为 addr 和 addrlen
listen: 默认来说，我们从 socket 函数中得到的 descriptor 默认是 active socket（也就是客户端的连接），调用 listen 函数告诉 kernel 这个 socket 是被服务器使用的
    int listen(int sockfd, int backlog);
    把 sockfd 从 active socket 转换成 listening socket，用来接收客户端的请求
    backlog 的数值表示 kernel 在接收多少个请求之后（队列缓存起来）开始拒绝请求
[*]accept: 调用 accept 函数，开始等待客户端请求
    int accept(int listenfd, SA *addr, int *addrlen);
    等待绑定到 listenfd 的连接接收到请求，然后把客户端的 socket address 写入到 addr，大小写入到 addrlen
    返回一个 connected descriptor 用来进行信息传输（类似 Unix I/O）
    具体的过程可以参考 图3
    
开启客户端（open_clientfd 函数，设定访问地址，尝试连接）
---------------------------------------
getaddrinfo: 设置客户端的相关信息，具体可以参见 图1&2
socket: 创建 socket descriptor，也就是之后用来读写的 file descriptor
connect: 客户端调用 connect 来建立和服务器的连接
    int connect(int clientfd, SA *addr, socklen_t addrlen);
    尝试与在 socker address addr 的服务器建立连接
    如果成功 clientfd 可以进行读写
    connection 由 socket 对描述 (x:y, addr.sin_addr:addr.sin_port)
    x 是客户端地址，y 是客户端临时端口，后面的两个是服务器的地址和端口
    最好是用 getaddrinfo 生成的参数作为 addr 和 addrlen

交换数据（主要是一个流程循环，客户端向服务器写入，就是发送请求；服务器向客户端写入，就是发送响应）
---------------------------------------
    [Client]rio_writen: 写入数据，相当于向服务器发送请求
    [Client]rio_readlineb: 读取数据，相当于从服务器接收响应
    [Server]rio_readlineb: 读取数据，相当于从客户端接收请求
    [Server]rio_writen: 写入数据，相当于向客户端发送响应

关闭客户端（主要是 close）
---------------------------------------
    [Client]close: 关闭连接

断开客户端（服务接收到客户端发来的 EOF 消息之后，断开已有的和客户端的连接）
---------------------------------------
    [Server]rio_readlineb: 收到客户端发来的关闭连接请求
    [Server]close: 关闭与客户端的连接
    
# http://www.cnblogs.com/maybe2030/p/4781555.html
# http://www.cnblogs.com/vamei/archive/2012/10/09/2715393.html
}

dnsmasq(数据驱动程序与函数指针+时间驱动程序与函数指针+分析表){
数据驱动程序
[poll.c]
    int poll_check(int fd, short event)
    
时间驱动程序
    int do_poll(int timeout)

信号驱动程序转化成数据驱动程序
static void sig_handler(int sig)

分析表
struct myoption opts[]    # 命令行解析
struct opttab_t opttab6[] # 命令对应处理函数
struct opttab_t opttab    # 命令对应处理函数

}

dnsmasq(把知识叠入数据以求逻辑质朴而健壮){

--------------------------------------- inotify.c
inotify_init1       # 初始化
inotify_add_watch   # 初始化 IN_CLOSE_WRITE | IN_MOVED_TO
poll_listen[poll]   # 监听 1
inotify_check[read] # 处理 2
inotify_event # 核心数据结构

[toybox]
inotify_init()       # 初始化
inotify_add_watch()  # 初始化 IN_CLOSE_WRITE | IN_MOVED_TO
poll(&fds, 1, -1);   # 监听 1
read                 # 处理 2
inotify_rm_watch     # 清除 3
--------------------------------------- dbus.c


--------------------------------------- netlink.c
socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE)                      # 初始化
bind(daemon->netlinkfd, (struct sockaddr *)&addr, sizeof(addr)   # 绑定
addr.nl_family = AF_NETLINK;                                     # 
addr.nl_pad = 0;                                                 # 
addr.nl_pid = 0; /* autobind */                                  # 
addr.nl_groups = RTMGRP_IPV4_ROUTE;                              # 
addr.nl_groups |= RTMGRP_IPV4_IFADDR;                            # 
addr.nl_groups |= RTMGRP_IPV6_ROUTE;                             # 
addr.nl_groups |= RTMGRP_IPV6_IFADDR;                            # 
addr.nl_groups |= RTMGRP_IPV6_IFADDR;                            # 
poll                                                             # 监听
recvmsg(daemon->netlinkfd, &msg, MSG_PEEK | MSG_TRUNC)           # 接收
close(fd)                                                        # 关闭
}

dnsmasq(option.c){
1. 如果redis的参数是一个格式化的坑，那么dnsmasq的参数就是一个非格式化的大坑。一个one_opt直接2000多行代码，汗! 
2. 如何将一个结构体关联到所有参数是个复杂的问题，option做到了，但很难重构。
struct {
  int opt;               # 解析选项 LOPT_AUTHSFS 数字类型
  unsigned int rept;     # OPT_BOGUSPRIV | OPT_LOG | OPT_DEBUG
  char * const flagdesc; # 格式描述
  char * const desc;     # 功能描述
  char * const arg;      # 默认值
}      usage                   
do_usage  # 用于帮助
one_opt   # 用于解析，
---------------------------------------
}

dnsmasq(log){
echo_stderr # 前台输出
log_fd      # 日志输出到指定服务器
log_to_file # 指定文件log_reopen
log_stderr  # 输出文件指定为"-"
}
redis(文件){
adlist.c 、 adlist.h    #双端链表数据结构的实现。
ae.c 、 ae.h 、 ae_epoll.c 、 ae_evport.c 、 ae_kqueue.c 、 ae_select.c   #  事件处理器，以及各个具体实现。
anet.c 、 anet.h   #  Redis 的异步网络框架，内容主要为对 socket 库的包装。
aof.c   #  AOF 功能的实现。
asciilogo.h   #  保存了 Redis 的 ASCII LOGO 。
bio.c 、 bio.h   #  Redis 的后台 I/O 程序，用于将 I/O 操作放到子线程里面执行， 减少 I/O 操作对主线程的阻塞。
bitops.c   #  二进制位操作命令的实现文件。
blocked.c   #  用于实现 BLPOP 命令和 WAIT 命令的阻塞效果。
cluster.c 、 cluster.h   #  Redis 的集群实现。
config.c 、 config.h   #  Redis 的配置管理实现，负责读取并分析配置文件， 然后根据这些配置修改 Redis 服务器的各个选项。
crc16.c 、 crc64.c 、 crc64.h   #  计算 CRC 校验和。
db.c   #  数据库实现。
debug.c   #  调试实现。
dict.c 、 dict.h   #  字典数据结构的实现。
endianconv.c 、 endianconv.h   #  二进制的大端、小端转换函数。
fmacros.h   #  一些移植性方面的宏。
help.h   #  utils/generate-command-help.rb 程序自动生成的命令帮助信息。
hyperloglog.c   #  HyperLogLog 数据结构的实现。
intset.c 、 intset.h   #  整数集合数据结构的实现，用于优化 SET 类型。
lzf_c.c 、 lzf_d.c 、 lzf.h 、 lzfP.h   #  Redis 对字符串和 RDB 文件进行压缩时使用的 LZF 压缩算法的实现。
Makefile 、 Makefile.dep   #  构建文件。
memtest.c   #  内存测试。
mkreleasehdr.sh   #  用于生成释出信息的脚本。
multi.c   #  Redis 的事务实现。
networking.c   #  Redis 的客户端网络操作库， 用于实现命令请求接收、发送命令回复等工作， 文件中的函数大多为 write 、 read 、 close 等函数的包装， 以及各种协议的分析和构建函数。
notify.c   #  Redis 的数据库通知实现。
object.c   #  Redis 的对象系统实现。
pqsort.c 、 pqsort.h   #  快速排序（QuickSort）算法的实现。
pubsub.c   #  发布与订阅功能的实现。
rand.c 、 rand.h   #  伪随机数生成器。
rdb.c 、 rdb.h   #  RDB 持久化功能的实现。
redisassert.h   #  Redis 自建的断言系统。
redis-benchmark.c   #  Redis 的性能测试程序。
redis.c   #  负责服务器的启动、维护和关闭等事项。
redis-check-aof.c 、 redis-check-dump.c   #  RDB 文件和 AOF 文件的合法性检查程序。
redis-cli.c   #  Redis 客户端的实现。
redis.h   #  Redis 的主要头文件，记录了 Redis 中的大部分数据结构， 包括服务器状态和客户端状态。
redis-trib.rb   #  Redis 集群的管理程序。
release.c 、 release.h   #  记录和生成 Redis 的释出版本信息。
replication.c   #  复制功能的实现。
rio.c 、 rio.h   #  Redis 对文件 I/O 函数的包装， 在普通 I/O 函数的基础上增加了显式缓存、以及计算校验和等功能。
scripting.c   #  脚本功能的实现。
sds.c 、 sds.h   #  SDS 数据结构的实现，SDS 为 Redis 的默认字符串表示。
sentinel.c   #  Redis Sentinel 的实现。
setproctitle.c   #  进程环境设置函数。
sha1.c 、 sha1.h   #  SHA1 校验和计算函数。
slowlog.c 、 slowlog.h   #  慢查询功能的实现。
solarisfixes.h   #  针对 Solaris 系统的补丁。
sort.c   #  SORT 命令的实现。
syncio.c   #  同步 I/O 操作。
testhelp.h   #  测试辅助宏。
t_hash.c 、 t_list.c 、 t_set.c 、 t_string.c 、 t_zset.c   #  定义了 Redis 的各种数据类型，以及这些数据类型的命令。
util.c 、 util.h   #  各种辅助函数。
valgrind.sup   #  valgrind 的suppression文件。
version.h   #  记录了 Redis 的版本号。
ziplist.c 、 ziplist.h   #  ZIPLIST 数据结构的实现，用于优化 LIST 类型。
zipmap.c 、 zipmap.h   #  ZIPMAP 数据结构的实现，在 Redis 2.6 以前用与优化 HASH 类型， Redis 2.6 开始已经废弃。
zmalloc.c 、 zmalloc.h   #  内存管理程序。
}
从redis2.0 到redis3.0 你的路上
http://www.wzxue.com/redis%E6%A0%B8%E5%BF%83%E8%A7%A3%E8%AF%BB/               # 
http://redisbook.com/preview/sds/different_between_sds_and_c_string.html#id4  # 
redis(IO处理相关模块接口){
[anet.c]
1. 单个socket的处理，更注重IPv4和IPv6的统一封装，阻塞connnect和非阻塞connect的封装，
   对read和write函数未进行阻塞非阻塞设定，只能根据外部环境说明。
地址解析层次：anetGenericResolve|anetResolve|anetResolveIP ： # 完成域名字符串到IP字符串之间的转换。
流选项处理  ：anetSetReuseAddr|anetTcpKeepAlive|anetSetSendBuffer|anetEnableTcpNoDelay
              anetDisableTcpNoDelay|anetKeepAlive|anetNonBlock|anetSetError # 除了是否阻塞，都是tcp处理选项
流读写处理  : anetRead|anetWrite # 没有真实使用，最好别使用。
TCP流处理   ：anetTcpConnect|anetTcpNonBlockConnect|anetTcpNonBlockBindConnect|anetTcpServer|anetTcp6Server
              anetTcpAccept|anetPeerToString|anetSockName # 客户机和服务器端，阻塞和非阻塞处理
Unix流处理  ：anetUnixConnect|anetUnixNonBlockConnect|anetUnixServer|anetUnixAccept # 客户机和服务器端

anetGenericAccept(anetTcpAccept,anetUnixAccept) # 阻塞式等待客户端连接接入

anetSetError：该函数贯穿始终实现了网络模块的透明性：便于调试。 
              该函数内的全局变量使得函数自身透明性存在问题。 # ? vasprintf函数或许更好点。
内部没有对自身封装的地址解析处理函数进行调用，都是自身调用getaddrinfo。 # ? 多处调用getaddrinfo不符合单点原则

不清楚，为何redis中的inet_ntop函数调用不对返回值进行判断。   # ? 接口调用
--------------------------------------- 从sock到本地socket地址和端口，远端socket地址和端口
anetPeerToString和anetSockName返回的地址是字符串，而port是一个int类型；
tcpgetpeer和tcpgetmyaddr返回的是一个int值，而port是unit16_t的类型；
相比而言moosefs实现的更好一点，从模块设计上没有考虑ipv6的情况下这已经很好了。地址返回uint32_t型，port返回uint16_t类型。
1. 而redis地址返回字符串长度：需要考虑，port返回类型为int类型，接口设计缺少严谨。               # ? 接口设计
2. redis内部处理对输入的判断在异常处理部分没有正确处理。且redis 2.0的接口ip地址字符串长度参数。 # ? 内部实现
3. redis 3.0 相较于redis2.0而言，支持了ipv6协议。
--------------------------------------- 

anet.c中的socket创建、连接管理，数据收发代码更适合作为客户端代码的参考代码。   
anet.c中的socket功能调整代码（非阻塞设定、连接keepalive时间设定，Nagle算法开启关闭）在客户端和服务器都可以使用。   

阻塞读写设置(逻辑上异常退出，不能处理部分数据接收、发送情况) # 这两个函数最好别使用。
    anetRead : 接收是在未屏蔽异常之后的阻塞读取，使得读取时间被阻塞时间不确定。异常退出，返回错误值-1。
    anetWrite: 发送是在未屏蔽异常之后的阻塞写入，使得发送时间被阻塞时间不确定。异常退出，返回错误值-1。

anetRead和anetWrite -> tcpread和tcpwrite 在处理上完全一致。与tcptoread和tcpwrite处理机制差异是不支持超时。
---------------------------------------
2. [syncio.c]
ssize_t syncRead(int fd, char *ptr, ssize_t size, long long timeout)      等同于tcptoread
ssize_t syncWrite(int fd, char *ptr, ssize_t size, long long timeout)     等同于toptowrite
ssize_t syncReadLine(int fd, char *ptr, ssize_t size, long long timeout)  以换行为结束的数据长度
syncRead和syncWrite中没有对ENTR信号进行考虑。
[networking.c]
3. networking.c代码更多是业务实例。不同的业务应该有多个networking.c的实例代码。
processEventsWhileBlocked:让服务器在被阻塞的情况下，仍处理某些事件。poll在非阻塞的情况下运行。即：
当等待超时时间等于0的情况，设置超时时间等于0，而不是无限期阻塞等待。

networking.c不是一个模块，更像是一个厚厚的胶合层。结果使得读者很难搞懂networking.c文件真实功能。
}
redis(事件驱动){
通过ac.c+[ae_evport.c|ae_epoll.c|ae_kqueue.c|ae_select.c]:即可以实现简单的epoll或者select多路IO阻塞模型。
相比而言，比moosefs更简单。
1. [ae.c]
ae.c依赖于ae_evport.c、ae_epoll.c、ae_kqueue.c或ae_select.c
   主要对poll、select以及epoll的封装，在这些函数的基础上提供了
   文件事件处理机制：在aeCreateFileEvent中的注册函数中调用aeCreateFileEvent函数，继续进行监听注册。
   aeCreateFileEvent:接收一个套接字描述符、一个事件类型以及一个事件处理器作为参数，将给定套接字的给定事件加入到IO多路复用程序
                     的监听范围之内，并对事件和事件处理函数进行关联。
   aeDeleteFileEvent：接收一个套接字描述符、一个事件类型作为参数，让多路IO复用程序取消对给定套接字的给定事件的监听，并取消事件
                      和事件处理器之间的关联。
   aeGetFileEvents：  接收一个套接字描述符，返回该套接字正在被监听的事件类型：
                      AE_NONE                     未注册事件
                      AE_READABLE                 注册读事件
                      AE_WRITABLE                 注册写事件
                      AE_READABLE | AE_WRITABLE   注册读写事件
   aeApiPoll：      函数接收一个timeval结构为参数，并在指定的时间内，阻塞并等待所有被aeCreateFileEvent函数设置为监听状态的套接字
                    产生文件事件，当有至少一个事件产生，或者等待超时后，函数返回。
   aeProcessEvents: 文件事件分派器，它先调用aeApiPoll函数来等待事件产生，然后遍历所有已产生的事件，并调用响应的事件处理器来处理这些事件。
   
   超时时间处理机制：在aeCreateTimeEvent中的注册函数中调用aeCreateTimeEvent函数，继续进行超时事件处理。
   aeCreateTimeEvent：接收一个毫秒数和一个时间事件处理器proc作为参数，将一个新的时间事件添加到服务器，这个新的时间事件将在当前时间到达
                      后执行proc。
   aeDeleteTimeEvent：接收一个时间ID作为参数，然后从服务器中删除该ID所对应的时间事件。
   aeSearchNearestTimer：返回达到时间距离当前时间最接近的哪个时间事件。
   processTimeEvents：  时间事件处理器
aeWait：超时阻塞监听文件描述符的状态。如果有事件则返回事件mask值；如果没有事件返回：超时值0或者异常中断值-1，
该函数没有处理异常，似乎有点遗憾。

2. [流程详解]
step1： 初始化事件处理器结构体
struct redisServer server; // 全局变量
server.el = aeCreateEventLoop(server.maxclients+REDIS_EVENTLOOP_FDSET_INCR); // 初始化事件处理器结构体

step2: 注册事件处理函数
aeCreateFileEvent(server.el, server.ipfd[j], AE_READABLE,acceptTcpHandler,NULL)  // TCP
aeCreateFileEvent(server.el,server.sofd,AE_READABLE, acceptUnixHandler,NULL)     // Unix

aeEventLoop.events; // 已注册的文件事件, events是aeFileEvent类型
  aeFileEvent {int mask; aeFileProc *rfileProc; aeFileProc *wfileProc; void *clientData;  # 外部结构
  typedef void aeFileProc(struct aeEventLoop *eventLoop, int fd, void *clientData, int mask); // aeFileProc函数指针
  
step3: 事件触发，执行回调函数
aeMain(aeEventLoop *eventLoop)
  aeProcessEvents(eventLoop, AE_ALL_EVENTS);
    执行回调函数acceptTcpHandle
    
step4: 回复请求
createClient函数
  aeCreateFileEvent(server.el,fd,AE_READABLE, readQueryFromClient, c)         // 注册读请求标识
    readQueryFromClient(aeEventLoop *el, int fd, void *privdata, int mask)    // 接收请求
    processInputBuffer(redisClient *c)                                        // 处理请求
    void addReply(redisClient *c, robj *obj)                                  // 回复请求
    int prepareClientToWrite(redisClient *c)                                  // 注册读写请求标识
    void sendReplyToClient(aeEventLoop *el, int fd, void *privdata, int mask) // 写发送
}

redis(数据驱动程序与函数指针+时间驱动程序与函数指针+分析表){
数据驱动程序+函数指针
reids.c       数据驱动程序与函数指针
aeCreateFileEvent(server.el, server.ipfd[j], AE_READABLE,acceptTcpHandler,NULL)#acceptTcpHandler
aeCreateFileEvent(server.el,server.sofd,AE_READABLE,acceptUnixHandler,NULL)    #acceptUnixHandler
networking.c  数据驱动程序与函数指针                                           #
aeCreateFileEvent(server.el,fd,AE_READABLE,readQueryFromClient, c)             #readQueryFromClient
aeCreateFileEvent(server.el, c->fd, AE_WRITABLE,sendReplyToClient, c)          #sendReplyToClient

时间驱动程序+函数指针                                  
redis.c                                                 #
eventLoop->beforesleep                                  #beforesleep
aeCreateTimeEvent(server.el, 1, serverCron, NULL, NULL) #serverCron

分析表
redis.c redisCommandTable命令操作表；
redis.c setDictType
        zsetDictType
        dbDictType
        shaScriptObjectDictType
        keyptrDictType
        commandTableDictType
        hashDictType
        keylistDictType
        clusterNodesDictType
        clusterNodesBlackListDictType
        migrateCacheDictType
        replScriptCacheDictType
然后通过dictCreate创建dict，在对该字典进行管理。 
typedef void redisCommandProc(redisClient *c);                                                # 回调函数
typedef int *redisGetKeysProc(struct redisCommand *cmd, robj **argv, int argc, int *numkeys); # 回调函数
}

redis(把知识叠入数据以求逻辑质朴而健壮){

}

https://github.com/antirez/sds
redis(sds.c v1){
1. 分析redis的第一步是分析sds，sds将redis变成了一个字符串的世界，在这个世界里面，请面向字符串编程。
2. C语言的字符串表示，以'\0'结尾的字符buffer，有太多的问题，如缓冲区溢出，未知长度等等。
--------------------------------------- C字符串 vs. sds 
1. 常数复杂度获取字符串长度:    和 C 字符串不同， 因为 SDS 在 len 属性中记录了 SDS 本身的长度， 
   所以获取一个 SDS 长度的复杂度仅为 O(1)。 # sdslen sdsavail sdsnewlen sdsnew
2. 杜绝缓冲区溢出：   当 SDS API 需要对 SDS 进行修改时， API 会先检查 SDS 的空间是否满足修改所需的要求， 
   如果不满足的话， API 会自动将 SDS 的空间扩展至执行修改所需的大小， 然后才执行实际的修改操作， 所以使用 
   SDS 既不需要手动修改 SDS 的空间大小， 也不会出现前面所说的缓冲区溢出问题。 # sdscat
3. 减少修改字符串时带来的内存重分配次数：  # 
   3.1 空间预分配： 
        如果对 SDS 进行修改之后， SDS 的长度（也即是 len 属性的值）将小于 1 MB ， 那么程序分配和 len 属性
   同样大小的未使用空间， 这时 SDS len 属性的值将和 free 属性的值相同。
        如果对 SDS 进行修改之后， SDS 的长度将大于等于 1 MB ， 那么程序会分配 1 MB 的未使用空间。 
   3.2 惰性空间释放：                      # sdstrim(s, "XY")
        惰性空间释放用于优化 SDS 的字符串缩短操作： 当 SDS 的 API 需要缩短 SDS 保存的字符串时， 程序并不立即
   使用内存重分配来回收缩短后多出来的字节， 而是使用 free 属性将这些字节的数量记录起来， 并等待将来使用。
4. 二进制安全： C 字符串中的字符必须符合某种编码（比如 ASCII）， 并且除了字符串的末尾之外， 字符串里面不能包含
  空字符， 否则最先被程序读入的空字符将被误认为是字符串结尾 —— 这些限制使得 C 字符串只能保存文本数据， 而不能
  保存像图片、音频、视频、压缩文件这样的二进制数据。 # strcasecmp strcat
5.兼容部分 C 字符串函数

======================= ============================================================================= =================
函数                    作用                                                                            算法复杂度
======================= ============================================================================= =================
"sdsnewlen"           创建一个指定长度的 "sds" ，接受一个 C 字符串作为初始化值                      'O(N)'
"sdsempty"            创建一个只包含空白字符串   的 "sds"                                      'O(1)'
"sdsnew"              根据给定 C 字符串，创建一个相应的 "sds"                                       'O(N)'
"sdsdup"              复制给定 "sds"                                                                'O(N)'
"sdsfree"             释放给定 "sds"                                                                'O(N)'
"sdsupdatelen"        更新给定 "sds" 所对应 "sdshdr" 结构的 "free" 和 "len"                   'O(N)'
"sdsclear"            清除给定 "sds" 的内容，将它初始化为 """"                                    'O(1)'
"sdsMakeRoomFor"      对 "sds" 所对应 "sdshdr" 结构的 "buf" 进行扩展                            'O(N)'
"sdsRemoveFreeSpace"  在不改动 "buf" 的情况下，将 "buf" 内多余的空间释放出去                      'O(N)'
"sdsAllocSize"        计算给定 "sds" 的 "buf" 所占用的内存总数                                    'O(1)'
"sdsIncrLen"          对 "sds" 的 "buf" 的右端进行扩展（expand）或修剪（trim）                    'O(1)'
"sdsgrowzero"         将给定 "sds" 的 "buf" 扩展至指定长度，无内容的部分用 "\0" 来填充          'O(N)'
"sdscatlen"           按给定长度对 "sds" 进行扩展，并将一个 C 字符串追加到 "sds" 的末尾           'O(N)'
"sdscat"              将一个 C 字符串追加到 "sds" 末尾                                              'O(N)'
"sdscatsds"           将一个 "sds" 追加到另一个 "sds" 末尾                                        'O(N)'
"sdscpylen"           将一个 C 字符串的部分内容复制到另一个 "sds" 中，需要时对 "sds" 进行扩展     'O(N)'
"sdscpy"              将一个 C 字符串复制到 "sds"                                                   'O(N)'
======================= ============================================================================= =================
}
redis(sds.c v2){  1. sds与null结尾字符串 2. sds与buf+len方式 3. sds与sds自身 4. sds与zero(null) 5. sds和其他类型
1. Redis, Disque, Hiredis, and the stand alone SDS versions  # 项目使用
2. version 2 不再二进制兼容version 1，但是 99% 的接口在两个版本之间兼容
3. 某些情况下 version 2性能会下降，因为header size的长度可变
+--------+-------------------------------+-----------+
| Header | Binary safe C alike string... | Null term |
+--------+-------------------------------+-----------+
         |
         |-> Pointer returned to the user.
# 返回C字符串指针前 有Header元数据，后追加 null作为结尾。
4. 可以以C字符串方式引用，不可以以C字符串方式修改

# 相比于 {uint64_t len, char *str} 方式的优点和缺点 Advantages & disadvantages 
[disadvantages]
1. 很多函数返回一个新字符串作为返回值，这是由于，有时候sds新字符串需要更多的空间。
  s = sdscat(s,"Some more data");  # sdscat 返回结果必须赋值给s，因为参数s会在重新分配空间时，地址发生变化
2. 如果sds被程序的多个地方引用，当修改sds的时候，必须修改所有的引用位置。
   如果sds被程序的多个地方共享，最好将sds封装在一个引用计数对象中
[advantages]
1. printf("%s\n", sds_string);    可以将sds直接传递给C格式化函数，
2. printf("%c %c\n", s[0], s[1]); 可以直接访问字符串对应位置的字符
3. 其他方式的二进制标识：{ size_t len; char *str } 会使内存分散，降低CPU内存命中率，单一内容分配提高了缓存命中率

[SDS basics]
1. sds是指向char *的字符串。即sds是 typedef char *sds; 别名；
   使用sds用以表示代码中该字符串为sds类型
sds mystring = sdsnew("Hello World!"); 
printf("%s\n", mystring); 
sdsfree(mystring);

[Creating SDS strings]
sds sdsnewlen(const void *init, size_t initlen); # 构造 根据指定长度构造，可以使用二进制数据创建一个字符串。
sds sdsnew(const char *init);  # 构造 根据字符串长度构造
sdsempty(void)        # 构造 空字符串sds构造     申请一个值为空的 SDS
sdsdup(const sds s)   # 构造 根据sds构造         复制 SDS
1. sdsnewlen
char buf[3];
sds mystring;

buf[0] = 'A';
buf[1] = 'B';
buf[2] = 'C';
mystring = sdsnewlen(buf,3);
printf("%s of len %d\n", mystring, (int) sdslen(mystring));
# output> ABC of len 3
2. sdsempty
sds mystring = sdsempty();
printf("%d\n", (int) sdslen(mystring));
# output> 0
3. sdsdup
sds s1, s2;
s1 = sdsnew("Hello");
s2 = sdsdup(s1);
printf("%s %s\n", s1, s2);
# output> Hello Hello

[Obtaining the string length]
size_t sdslen(const sds s)  # 获取长度时间为常量，可以获取二进制数据的长度
sds s = sdsnewlen("A\0\0B",4);
printf("%d\n", (int) sdslen(s));
# output> 4

[Destroying strings]
void sdsfree(sds s); # sdsfree传入参数为NULL可以接收
if (string) sdsfree(string); /* Not needed. */
sdsfree(string); /* Same effect but simpler. */

[Concatenating strings]
sds sdscatlen(sds s, const void *t, size_t len); # 连接 定长连接    二进制安全
sds sdscat(sds s, const char *t);                # 连接 字符串连接  字符串null结尾
sds sdscatsds(sds s, const sds t);               # 连接 sds连接     二进制安全
1. sdscat
sds s = sdsempty(); 
s = sdscat(s, "Hello "); 
s = sdscat(s, "World!"); 
printf("%s\n", s); 
# output> Hello World!
2. sdscatsds
sds s1 = sdsnew("aaa");
sds s2 = sdsnew("bbb");
s1 = sdscatsds(s1,s2);
sdsfree(s2);
printf("%s\n", s1);
#output> aaabbb

sds sdsgrowzero(sds s, size_t len); # 大小 扩展sds空间大小 
sds s = sdsnew("Hello");
s = sdsgrowzero(s,6);
s[5] = '!'; /* We are sure this is safe because of sdsgrowzero() */
printf("%s\n", s);
# output> Hello!

[Formatting strings]
sds sdscatprintf(sds s, const char *fmt, ...); # 构造 格式化构造    使用参数列表把格式化字符串拼接到 s 后面
1. sdscatprintf
sds s;
int a = 10, b = 20;
s = sdsnew("The sum is: ");
s = sdscatprintf(s,"%d+%d = %d",a,b,a+b);
2. sdscatprintf
char *name = "Anna";
int loc = 2500;
sds s;
s = sdscatprintf(sdsempty(), "%s wrote %d lines of LISP\n", name, loc);
3.sdscatprintf
int some_integer = 100;
sds num = sdscatprintf(sdsempty(),"%d\n", some_integer);

[Fast number to string operations]
sds sdsfromlonglong(long long value);                  # 构造 格式化构造    创建 SDS 值为 value 的字符串表示
1. sdsfromlonglong
sds s = sdsfromlonglong(10000); 
printf("%d\n", (int) sdslen(s)); 
# output> 5

[Trimming strings and getting ranges]
void sdsrange(sds s, int start, int end) # 截取 定长截取  常用以实现协议处理
void sdstrim(sds s, const char *cset);   # 截取 匹配截取
1. sdstrim
sds s = sdsnew("         my string\n\n  "); 
sdstrim(s," \n"); 
printf("-%s-\n",s); 
# output> -my string-
2. sdsrange
sds s = sdsnew("Hello World!"); 
sdsrange(s,1,4); 
printf("-%s-\n"); 
# output> -ello-
3. sdsrange
sds s = sdsnew("Hello World!");
sdsrange(s,6,-1);
printf("-%s-\n");
sdsrange(s,0,-2);
printf("-%s-\n");
# output> -World!-
# output> -World-

[String copying]
sds sdscpylen(sds s, const char *t, size_t len); # 构造 定长复制构造
sds sdscpy(sds s, const char *t);                # 构造 字符串复制构造
s = sdsnew("Hello World!");
s = sdscpylen(s,"Hello Superman!",15);

[Quoting strings] for JSON and CSV
sds sdscatrepr(sds s, const char *p, size_t len)  # sds原样；相当于与echo -e # sds原样；相当于与echo -e
1. sdscatrepr
sds s1 = sdsnew("abcd");
sds s2 = sdsempty();
s[1] = 1;
s[2] = 2;
s[3] = '\n';
s2 = sdscatrepr(s2,s1,sdslen(s1));
printf("%s\n", s2);
# output> "a\x01\x02\n"

[Tokenization]
sds *sdssplitlen(const char *s, int len, const char *sep, int seplen, int *count); # 构造 字符串分割构造多个sds
void sdsfreesplitres(sds *tokens, int count);                                      # 析构 释放多个sds
1. sdssplitlen, sdsfreesplitres
sds *tokens;
int count, j;

sds line = sdsnew("Hello World!");
tokens = sdssplitlen(line,sdslen(line)," ",1,&count);

for (j = 0; j < count; j++)
    printf("%s\n", tokens[j]);
sdsfreesplitres(tokens,count);

# output> Hello
# output> World!

[Command line oriented tokenization]
sds *sdssplitargs(const char *line, int *argc)                                     # 构造 字符串分割构造多个sds

[String joining]
sds sdsjoin(char **argv, int argc, char *sep); # 连接构造
sds sdsjoinsds(sds *argv, int argc, const char *sep, size_t seplen);
1. sdsjoin
char *tokens[3] = {"foo","bar","zap"};
sds s = sdsjoin(tokens,3,"|",1);
printf("%s\n", s);
# output> foo|bar|zap

sds sdscatvprintf(sds s, const char *fmt, va_list ap); # 构造 格式化构造
sds sdscatfmt(sds s, char const *fmt, ...);            # 构造 格式化构造    自定义的格式化字符串并拼接到 s 后边

lower [Shrinking strings]
sds sdsRemoveFreeSpace(sds s)                  # 删除 SDS 中 buf 包含的多余空间
size_t sdsAllocSize(sds s)          # 大小 全部使用空间大小      

void sdsupdatelen(sds s);           # 大小 根据字符串更新长度     使用 strlen(s) 更新 s 所对应的 SDS.len

<Sharing SDS strings>
struct mySharedString {
    int refcount;
    sds string;
}
<Interactions with heap checkers>
sds_malloc(), sds_realloc() and sds_free().

<Zero copy append from syscalls>
sdsIncrLen() and sdsMakeRoomFor()
oldlen = sdslen(s);
s = sdsMakeRoomFor(s, BUFFER_SIZE);
nread = read(fd, s+oldlen, BUFFER_SIZE);
... check for nread <= 0 and handle it ...
sdsIncrLen(s, nread);

-------------------------------------------------------------------------------
1. sds 模块是面向sds的编程，作为基础部分--不反应业务功能，为其他模块提供简单接口；因此，在头文件中声明了sds结构体
   基础部分不反应具体业务功能，可对于性能和扩展性有很大影响。
2. sds 实现了很多字符串相关的功能。从string模块到stdarg模块,ctype模块，<stdio.h>模块。
}

redis(adlist){ redis/reuse-redis-module/adlist
Redis 实现的是一个典型的双端链表， 这个链表具有以下特性：
    带有表头和表尾指针，可以在 O(1) 复杂度内取得表头或者表尾节点
    带有节点数量变量，可以在 O(1) 复杂度内取得链表的节点数量
    可以通过指定 dup 、 free 和 match 函数，适应多种类型的值（或结构）
    带有一个链表迭代器，通过这个迭代器，可以从表头向表尾或者从表尾向表头进行迭代。
[API 及 生命周期]
|--list *listCreate(void)     创建空list
|--list *listDup(list *orig)  拷贝list
|  |--list *listAddNodeHead(list *list, void *value)
|  |  # 添加生成返回list，否则返回NULL
|  |  list *listAddNodeTail(list *list, void *value) 
|  |  # 添加生成返回list，否则返回NULL
|  |--void listDelNode(list *list, listNode *node)
|  |  # 删除listEntry及关联的val
|--void listRelease(list *list) 释放list及关联listNode

[list]
typedef struct dictType {
listNode *head;                       
listNode *tail;                       
void *(*dup)(void *ptr);             listSetDupMethod    listGetDupMethod    # listDup用来生成adlist的副本
void (*free)(void *ptr);             listSetFreeMethod   listGetFreeMethod   # listDelNode listRelease用来释放listAddNode(Tail|Head)的实例
int (*match)(void *ptr, void *key);  listSetMatchMethod  listGetMatchMethod  # listSearchKey用来获取adlist是否存在指定元素
unsigned long len;                   
}

[listEntry]


以下是用于操作双端链表的 API ，它们的作用以及算法复杂度：
====================  ========================================================  =========================
函数                    作用                                                        算法复杂度
====================  ========================================================  =========================
"listCreate"          创建新链表                                              'O(1)'
"listRelease"         释放链表，以及该链表所包含的节点                        'O(N)'
"listDup"             创建给定链表的副本                                      'O(N)'
"listRotate"          取出链表的表尾节点，并插入到表头                        'O(1)'
"listAddNodeHead"     将包含给定值的节点添加到链表的表头                      'O(1)'
"listAddNodeTail"     将包含给定值的节点添加到链表的表尾                      'O(1)'
"listInsertNode"      将包含给定值的节点添加到某个节点的之前或之后            'O(1)'
"listDelNode"         删除给定节点                                            'O(1)'
"listSearchKey"       在链表中查找和给定 key 匹配的节点                       'O(N)'
"listIndex"           给据给定索引，返回列表中相应的节点                      'O(N)'
"listLength"          返回给定链表的节点数量                                  'O(1)'
"listFirst"           返回链表的表头节点                                      'O(1)'
"listLast"            返回链表的表尾节点                                      'O(1)'
"listPrevNode"        返回给定节点的前一个节点                                'O(1)'
"listNextNode"        返回给定节点的后一个节点                                'O(1)'
"listNodeValue"       返回给定节点的值                                        'O(1)'
====================  ========================================================  =========================

以下是迭代器的操作 API ，API 的作用以及算法复杂度：

=========================  =========================== =====================
函数                        作用                        算法复杂度
=========================  =========================== =====================
"listGetIterator"         创建一个列表迭代器          'O(1)'
"listReleaseIterator"     释放迭代器                  'O(1)'
"listRewind"              将迭代器的指针指向表头      'O(1)'
"listRewindTail"          将迭代器的指针指向表尾      'O(1)'
"listNext"                取出迭代器当前指向的节点    'O(1)'
=========================  =========================== =====================

小结
------
- Redis 实现了自己的双端链表结构。
- 双端链表主要有两个作用：
  - 作为 Redis 列表类型的底层实现之一；
  - 作为通用数据结构，被其他功能模块所使用；
- 双端链表及其节点的性能特性如下：
  - 节点带有前驱和后继指针，访问前驱节点和后继节点的复杂度为 :math:`O(1)` ，并且对链表的迭代可以在从表头到表尾和从表尾到表头两个方向进行；
  - 链表带有指向表头和表尾的指针，因此对表头和表尾进行处理的复杂度为 :math:`O(1)` ；
  - 链表带有记录节点数量的属性，所以可以在 :math:`O(1)` 复杂度内返回链表的节点数量（长度）；
}
redis(dict){
Redis 的字典实现具有以下特色：
    可以通过设置不同的类型特定函数，让字典的键和值包含不同的类型，并为键使用不同的哈希算法。
    字典可以自动进行扩展或收缩，并且由此而带来的 rehash 是渐进式地进行的。

[API 及 生命周期]
|--dict *dictCreate(dictType *type,void *privDataPtr)
| |-- API insert/del/replace/find/get-random-element
| |       int dictAdd(dict *d, void *key, void *val)        # insert
| |   # 存在相同的key，则返回DICT_ERR
| |       int dictDelete(dict *ht, const void *key)         # del
| |   # 删除成功 DICT_OK  删除失败 DICT_ERR
| |       int dictReplace(dict *d, void *key, void *val)    # replace
| |   # 1: 添加 0: 替换
| |       dictEntry *dictFind(dict *d, const void *key)     # find 
| |   # 非NULL的值，返回指针指向已存在的值。 NULL当前不存在
| |       dictEntry *dictAddOrFind(dict *d, void *key)      # add or find
| |-- # 非NULL的值，返回指针指向已存在的值或已添加的值
|--void dictRelease(dict *d)

[内存管理]
1. dict,dictht和dictEntry是dict模块自管理对象；通过接口调用进行生命周期管理。
dict和dictht生命周期   接口  >= dictEntry 生命周期                           接口
dictCreate+dictRelease 接口     dictAdd+dictReplace+dictAddOrFind+dictDelete 接口
2. dictType 是给dict注册的 外部管理对象方案；  通过注册函数 由dict接口调用间接 进行生命周期管理。
# 注册函数用于确定key和val如何分配，释放。即进行内存拷贝还是进行地址引用。或者值应用。

[rehash]
static int dict_can_resize = 1;                  # 是否支持resize
void dictEnableResize(void)     dict_can_resize = 1;
void dictDisableResize(void)    dict_can_resize = 0;
static unsigned int dict_force_resize_ratio = 5; # used/size > dict_force_resize_ratio 时才进行rehash
1. dict是否按used>size条件进行rehash是全局的，当dict_can_resize = 1时，used>size时就进行rehash
2. dict是否按used/size条件进行rehash是全局的，当used/size > dict_force_resize_ratio 时就进行rehash

3. dict的rehash是渐进的，在每次添加或设置时，渐进的将ht[0].buckets 迁移到 ht[1].buckets
4. dict的rehash时，hash表大小按照d->ht[0].used*2进行扩展。

# 特定于类型的一簇处理函数
typedef struct dictType {
  unsigned int (*hashFunction)(const void *key);     # 计算键的哈希值函数   dictHashKey(ht, key)
  void *(*keyDup)(void *privdata, const void *key);  # 复制键的函数    函数存在进行拷贝，否则进行地址引用  dictSetKey(d, entry, _key_)
  void *(*valDup)(void *privdata, const void *obj);  # 复制值的函数    函数存在进行拷贝，否则进行地址引用  dictSetVal(d, entry, _val_)
  int (*keyCompare)(void *privdata, const void *key1, const void *key2); # 对比两个键的函数                dictCompareKeys(d, key1, key2)
  void (*keyDestructor)(void *privdata, void *key);  # 键的释构函数                                        dictFreeKey(d, entry)
  void (*valDestructor)(void *privdata, void *obj);  # 值的释构函数                                        dictFreeVal(d, entry) 
} dictType;
# privdata为私有数据，用来对key或者obj进行优化。不是 必须的 

Redis 是一个键值对数据库， 数据库中的键值对由字典保存： 每个数据库都有一个对应的字典， 这个字典被称之为键空间。
DBSIZE 、FLUSHDB、 RANDOMKEY
Redis 的 Hash 类型键使用以下两种数据结构作为底层实现:
    字典；
    跳表
HSET、HGETALL book

[实现方法]
实现字典的方法有很多种：
    最简单的就是使用链表或数组，但是这种方式只适用于元素个数不多的情况下；
    要兼顾高效和简单性，可以使用哈希表；
    如果追求更为稳定的性能特征，并希望高效地实现排序操作的话，则可使用更为复杂的平衡树；
# Redis 选择了高效、实现简单的哈希表，作为字典的底层实现。

[redis字典实现]
    typedef struct dict {
        // 特定于类型的处理函数
        dictType *type;
        // 类型处理函数的私有数据
        void *privdata;
        // 哈希表（2 个）
        dictht ht[2];
        // 记录 rehash 进度的标志，值为 -1 表示 rehash 未进行
        int rehashidx;
        // 当前正在运作的安全迭代器数量
        int iterators;
    } dict;
以下是用于处理 dict 类型的 API ， 它们的作用及相应的算法复杂度：
+------------------------------------+------------------------------+--------------+
| 操作                               | 函数                         | 算法复杂度   |
+====================================+==============================+==============+
| 创建一个新字典                     |    ``dictCreate``            | 'O(1)'       |
| 添加新键值对到字典                 |     ``dictAdd``              | 'O(1)'       |
| 添加或更新给定键的值               |   ``dictReplace``            | 'O(1)'       |
| 在字典中查找给定键所在的节点       |   ``dictFind``               | 'O(1)'       |
| 在字典中查找给定键的值             |   ``dictFetchValue``         | 'O(1)'       |
| 从字典中随机返回一个节点           |   ``dictGetRandomKey``       | 'O(1)'       |
| 根据给定键，删除字典中的键值对     |    ``dictDelete``            | 'O(1)'       |
| 清空并释放字典                     |   ``dictRelease``            | 'O(N)'       |
| 清空并重置（但不释放）字典         |   ``dictEmpty``              | 'O(N)'       |
| 缩小字典                           |    ``dictResize``            | 'O(N)'       |
| 扩大字典                           |    ``dictExpand``            | 'O(N)'       |
| 对字典进行给定步数的 rehash        |      ``dictRehash``          | 'O(N)'       |
| 在给定毫秒内，对字典进行rehash     |   ``dictRehashMilliseconds`` | 'O(N)'       |
+------------------------------------+------------------------------+--------------+
注意 dict 类型使用了两个指针，分别指向两个哈希表。
其中， 0 号哈希表（ht[0]）是字典主要使用的哈希表， 而 1 号哈希表（ht[1]）则只有在程序对 0 号哈希表进行 rehash 时才使用。

# 哈希表
typedef struct dictht {
    // 哈希表节点指针数组（俗称桶，bucket）
    dictEntry **table;
    // 指针数组的大小
    unsigned long size;
    // 指针数组的长度掩码，用于计算索引值
    unsigned long sizemask;
    // 哈希表现有的节点数量
    unsigned long used;
} dictht;

# 哈希表节点
typedef struct dictEntry {
    // 键
    void *key;
    // 值
    union {
        void *val;
        uint64_t u64;
        int64_t s64;
    } v;
    // 链往后继节点
    struct dictEntry *next;
} dictEntry;


# 字典迭代器
typedef struct dictIterator {
    dict *d;                // 正在迭代的字典
    int table,              // 正在迭代的哈希表的号码（0 或者 1）
        index,              // 正在迭代的哈希表数组的索引
        safe;               // 是否安全？
    dictEntry *entry,       // 当前哈希节点
              *nextEntry;   // 当前哈希节点的后继节点

} dictIterator;

以下函数是这个迭代器的 API ，API 的作用及相关算法复杂度：
========================= ============================================================== ====================
  函数                      作用                                                            算法复杂度
========================= ============================================================== ====================
``dictGetIterator``         创建一个不安全迭代器。                                         '(1)'
``dictGetSafeIterator``     创建一个安全迭代器。                                           '(1)'
``dictNext``                返回迭代器指向的当前节点，如果迭代完毕，返回 ``NULL`` 。       '(1)'
``dictReleaseIterator``     释放迭代器。                                                   '(1)'
========================= ============================================================== ====================

小结
-----------
- 字典是由键值对构成的抽象数据结构。
- Redis 中的数据库和哈希键都基于字典来实现。
- Redis 字典的底层实现为哈希表，每个字典使用两个哈希表，一般情况下只使用 0 号哈希表，只有在 rehash 进行时，才会同时使用 0 号和 1 号哈希表。
- 哈希表使用链地址法来解决键冲突的问题。
- Rehash 可以用于扩展或收缩哈希表。
- 对哈希表的 rehash 是分多次、渐进式地进行的。
}

redis(intset){
整数集合提供了这样一个抽象：
    集合可以保存 int_16 、 int_32t 和 int_64 三种不同长度的整数。
    对集合保存值所使用的字长是由程序自动调整的，这个过程被称为"升级"。
    所有整数在集合中都是独一无二的，各个整数以从小到达的顺序在集合中排序，所以程序在集合中查找元素的复杂度为 O(\log N) 。

}
redis(config.c){
void loadServerConfig(char *filename, char *options);                                              # 加载配置
void appendServerSaveParams(time_t seconds, int changes);                                          # redis数据保存时间
void resetServerSaveParams();                                                                      # redis数据保存时间复位
void rewriteConfigRewriteLine(struct rewriteConfigState *state, char *option, sds line, int force);# 
int rewriteConfig(char *path);                                                                     # 重新保存配置
void configCommand(redisClient *c)                                                                 # 客户端命令配置
--------------------------------------- 参数说明
timeout tcp-keepalive port tcp-backlog unixsocket unixsocketperm dir loglevel logfile                       # 参数等于2
syslog-enabled syslog-ident  syslog-facility  databases include maxclients maxmemory  maxmemory-policy      # 参数等于2
maxmemory-samples repl-ping-slave-period repl-timeout repl-disable-tcp-nodelay repl-backlog-size            # 参数等于2
repl-backlog-ttl masterauth slave-serve-stale-data slave-read-only rdbcompression rdbchecksum               # 参数等于2
activerehashing daemonize hz appendonly appendfilename no-appendfsync-on-rewrite appendfsync                # 参数等于2
auto-aof-rewrite-percentage auto-aof-rewrite-min-size aof-rewrite-incremental-fsync requirepass             # 参数等于2
pidfile dbfilename cluster-enabled  cluster-config-file cluster-node-timeout cluster-migration-barrier      # 参数等于2
lua-time-limit slowlog-max-len slave-priority min-slaves-to-write min-slaves-max-lag notify-keyspace-events # 参数等于2
hash-max-ziplist-entries  hash-max-ziplist-value  # 参数等于2
list-max-ziplist-entries  list-max-ziplist-value  # 参数等于2
zset-max-intset-entries   set-max-intset-value    # 参数等于2
set-max-intset-entries    hll-sparse-max-bytes    # 参数等于2
sentinel # 参数等于1
bind    # 参数大于等于2
save(seconds,changes) slaveof(masterhost,masterport) rename-command()   # 参数等于3
client-output-buffer-limit # 参数等于5

--------------------------------------- 错误说明
loadServerConfigFromString(char *config)  # 函数中的错误提示很值得好好学
[invalid]
"Invalid timeout value";
"Invalid tcp-keepalive value"; 
"Invalid port"; 
"Invalid backlog value"; 
"Invalid socket file permissions"; 
"Invalid save parameters"; 
"Invalid log level. Must be one of debug, notice, warning";
"Invalid log facility. Must be one of USER or between LOCAL0-LOCAL7";
"Invalid number of databases"; 
"Invalid max clients limit"; 
"Invalid maxmemory policy";
"Invalid negative percentage for AOF auto rewrite";
"Invalid value for min-slaves-to-write."; 
"Invalid value for min-slaves-max-lag."; 
"Invalid event class character. Use 'g$lshzxeA'.";
[argument]
"argument must be 'yes' or 'no'"; 
"argument must be 'no', 'always' or 'everysec'";
[misc]
"Unbalanced quotes in configuration line";
"Too many bind addresses specified";
"maxmemory-samples must be 1 or greater";
"repl-ping-slave-period must be 1 or greater";
"repl-timeout must be 1 or greater";
"repl-backlog-size must be 1 or greater.";
"repl-backlog-ttl can't be negative ";
"appendfilename can't be a path, just a filename";
"Password is longer than REDIS_AUTHPASS_MAX_LEN";
"dbfilename can't be a path, just a filename";
"No such command in rename-command";
"Target command name already exists"; 
"cluster node timeout must be 1 or greater"; 
"cluster migration barrier must be positive";
"Unrecognized client limit class";
"Negative number of seconds in soft limit is invalid";
"sentinel directive while not in sentinel mode";
"Bad directive or wrong number of arguments";
"slaveof directive not allowed in cluster mode";

--------------------------------------- configGetCommand 获取配置功能
config_get_string_field
config_get_bool_field
config_get_numerical_field

---------------------------------------
1. moosefs(cfg)与redis(config)相比，cfg与业务无关，业务是现在各个分散的模块中；config是业务紧密相关的。
   redis进行很多很多的配置处理，包括配置转化，有效性和默认配置等。
   config模块没有太多的全局变量，比较欣慰。
2. config支持一个key多个value的情况，cfg不支持
3. config支持""和\数字，cfg不支持
}

redis(goto){
aeEventLoop *aeCreateEventLoop(int setsize) # 分配aeEventLoop
static int anetTcpGenericConnect(char *err, char *addr, int port,
                                 char *source_addr, int flags) # 分配系统描述符
int _anetTcpServer(char *err, int port, char *bindaddr, int af, int backlog) # 分配系统描述符
void loadServerConfigFromString(char *config)  # 模拟switch的break
int redisContextConnectTcp(redisContext *c, const char *addr, int port, struct timeval *timeout) # 分配系统描述符
1. 关联到多个资源的分配和释放的时候，使用goto可以使代码更加紧凑
2. 像loadServerConfigFromString这个函数，如果switch分支太多，或者由于switch不支持类型用if else if代替时，goto可以使代码更加紧凑
}

redis(hiredis){
int redisBufferWrite(redisContext *c, int *done) # 向输出缓冲区写入数据
# write
如果(已写入后|未写入前)输出缓冲区为空 返回REDIS_OK 且done等于1；
如果已写入后输出缓冲区不为空 返回REDIS_OK 且done等于0
如果调用write函数写入失败 返回REDIS_ERR， 且将错误保存到c->err和c->errstr

void redisAsyncHandleWrite(redisAsyncContext *ac)
# getsockopt write register unregister
如果TCP链接未建立成功，则直接退出。 # getsockopt
如果发送缓冲区内数据发送完毕，则删除写请求。
如果发送缓冲区内数据未发送完毕，则添加写请求。
总是注册读取缓冲区回调函数。
如果发送数据失败，则调用Disconnect回调函数。


int redisBufferRead(redisContext *c)
# read
如果调用read=-1 && errno != EAGAIN 则返回 REDIS_ERR, 且将错误保存到c->err和c->errstr
如果调用read=-1 && errno = EAGAIN 则返回 REDIS_OK，
如果调用read=0 则返回 REDIS_ERR, 且将错误保存到c->err和c->errstr
如果调用read>0 则返回 REDIS_OK, 且将数据 拷贝到redisReader结构体的缓冲区中

void redisAsyncHandleRead(redisAsyncContext *ac) 
# getsockopt read register 
如果TCP链接未建立成功，则直接退出。 # getsockopt
总是注册读取缓冲区回调函数。
如果链接没有问题，则调用回调函数redisProcessCallbacks(ac);处理输入缓冲内数据
如果发送数据失败，则调用Disconnect回调函数。

void redisProcessCallbacks(redisAsyncContext *ac) 
# 

 '-+:' void *createIntegerObject(const redisReadTask *task, long long value)      # 创建integer实例
 '' void *createNilObject(const redisReadTask *task)                           # 创建nil实例
 '$' void *createStringObject(const redisReadTask *task, char *str, size_t len) # 创建string实例
 '*' void *createArrayObject(const redisReadTask *task, int elements)           # 创建array实例
 '-' void freeReplyObject(void *reply)
}

redis(函数设计){
long _dictKeyIndex(dict *d, const void *key, uint64_t hash, dictEntry **existing)
返回值： 正整数表示hash表中数组的有效位置，
         -1表示当前元素存在于hash表中，此时查看**existing
           existing =  NULL表示 正处于expand过程中
           existing != NULL表示 该键已经存在于hash表中

dictIsRehashing(d) ((d)->rehashidx != -1)
返回值：0: hash表不再rehash中
        1: hash表正在rehash中
        
        
}
redis(net接口设计){ 
对POSIX API的封装，即将POSIX中的retrun + errno 转换成 return + redisContext.err + redisContext.errstr且从底层向上层报告。
其最底层使用 errstr[] 数组形式，而与应用关联的胶合层使用指针。
# 尽可能薄，不应该隐藏各层的裂痕和不平整
# 强烈倾向于把程序分解为由胶合层连接的库集合共享库
# 薄胶合层原则：硬件和程序顶层对象之间的抽象层越少越好
# 良好的设计应该是良好的模块+薄胶合层。
    [redisContext客户端底层封装] stream(tcp|unix) 类型客户端实现方式
int redisContextConnectTcp(redisContext *c, const char *addr, int port, struct timeval *timeout) 
# 阻塞类型  非阻塞类型
# 等待超时  非等待超时
# 错误递归上报 -> connect(redisContext) -> redisAsyncConnect(redisAsyncContext) -> 业务代码处理错误信息
# getaddrinfo[ret] + socket[ret] + fcntl(blocking?)[ret] + poll(timeout)[ret+errno] + connect[ret+errno] + freeaddrinfo
关注：需要完成的功能 -> 系统调用错误返回(ret+errno)

int redisContextConnectUnix(redisContext *c, const char *path, struct timeval *timeout) 
# 阻塞类型  非阻塞类型
# 等待超时  非等待超时
# 错误递归上报 -> connect(redisContext) -> redisAsyncConnect(redisAsyncContext) -> 业务代码处理错误信息
# socket[ret] + + fcntl(blocking?)[ret] + poll(timeout)[ret+errno] + connect[ret+errno] 
关注：需要完成的功能 -> 系统调用错误返回(ret+errno)

#      int redisSetTimeout(redisContext *c, struct timeval tv) 
int redisContextSetTimeout(redisContext *c, struct timeval tv)

int redisCheckSocketError(redisContext *c, int fd) 
int redisContextWaitReady(redisContext *c, int fd, const struct timeval *timeout) 
int redisSetTcpNoDelay(redisContext *c, int fd)
int redisSetBlocking(redisContext *c, int fd, int blocking) 
int redisCreateSocket(redisContext *c, int type) 
int redisSetReuseAddr(redisContext *c, int fd)
}

redis(模块化){ 对象生命周期管理问题? 私有数据问题? 结构体实现文件内定义 或 结构体头文件内定义 ?
模块必然关联到内存的生命周期管理 (内存的分配和释放 或 文件描述符的分配和释放 或 进程线程信号量共享内存等资源的分配和释放)
[ 单独对象生命周期管理 ]
1. sds     单一对象生命周期管理      分配: sdsnew sdsnewlen sdsempty sdsdup 释放 sdsfree

[ 外部和内部回调函数共同完成对象生命周期管理 ] 管理对象+被管理对象
2. adlist  外部对象生命周期 关联(管理)|不关联(检索) 到内部子对象生命周期管理。
           adlist对象管理 分配 listCreate|listDup 释放 listRelease
           listNode对象管理: 分配 val=malloc(), listAddNode(Head|Tail)  释放 listDelNode list->free(val) # list将val对象管理起来
           listNode对象管理: 分配 val=malloc(), listAddNode(Head|Tail)  释放 listDelNode(val脱离adlist)  # list提供检索val对象方式
# listSetDupMethod、listSetFreeMethod和listSetMatchMethod 在redis中都有使用。

3. dict    外部对象生命周期 关联(管理)|不关联(检索) 到内部子对象生命周期管理。
           dict对象管理 分配 dictCreate 释放 dictRelease
           dictEntry对象管理: 分配 keyDup=valDup=!NULL  dictAdd|dictAddOrFind|dictReplace 释放 dictDelete # dict释放key val dictEntry
                                                                                          释放 dictUnlink # 只是从hash表中移除dictEntry 后续依赖dictFreeUnlinkedEntry进行释放
                              分配 keyDup=valDup==NULL  dictAdd|dictAddOrFind|dictReplace 释放 dictDelete # dict释放dictEntry
                                                                                          释放 dictUnlink # 只是从hash表中移除dictEntry 后续依赖dictFreeUnlinkedEntry进行释放
# 整个redis工程中keyDup和valDup回调函数都为NULL，也即不存在 dict内部复制的情况。
[dbDictType]              [keyptrDictType]     [keylistDictType]         [setDictType]             
dictSdsHash,              dictSdsHash,         dictObjHash,              dictEncObjHash,            必须
NULL,                     NULL,                NULL,                     NULL,                      可选; 引用
NULL,                     NULL,                NULL,                     NULL,                      可选; 引用
dictSdsKeyCompare,        dictSdsKeyCompare,   dictObjKeyCompare,        dictEncObjKeyCompare,      必须
dictSdsDestructor,        NULL,                dictRedisObjectDestructor,dictRedisObjectDestructor  可选; 由dict进行内存释放?
dictRedisObjectDestructor NULL                 dictListDestructor        NULL                       可选; 由dict进行内存释放?

[ 外部接口完整实现对象声明周期管理 ] # 外部接口通过注册函数对(事件驱动)处理部数据
aeFileEvent通过clientData在回调函数中进行数据关联 
aeTimeEvent通过clientData在回调函数中进行数据关联 
4. ae.c    外部对象生命周期 不关联 到内部子对象生命周期管理。管理对象 分配: aeCreateEventLoop 释放 aeDeleteEventLoop
           被管理对象 aeFileEvent   分配: aeCreateFileEvent  释放 aeDeleteFileEvent  获取 aeGetFileEvents
           被管理对象 aeTimeEvent   分配: aeCreateTimeEvent  释放 aeDeleteTimeEvent  获取 aeGetTime

   ae.c(ae_epoll.c) aeApiState{int epfd;struct epoll_event *events;}     # 内部结构
       (ae_select.c) aeApiState{fd_set rfds, wfds;fd_set _rfds, _wfds;}  # 内部结构
核心结构 aeEventLoop                                                     # 外部结构
内部结构为抽象的被管理实例，并将被管理实例关联到核心结构上，影响内部流程对核心结构的处理。
内部结构生命周期管理由公有API接口管理，内部结构的状态既受公有API接口改变，又受系统API接口改变。
aeFileEvent {int mask; aeFileProc *rfileProc; aeFileProc *wfileProc; void *clientData;  # 外部结构
aeTimeEvent { long long id; long when_sec; long when_ms; aeTimeProc *timeProc; 
              aeEventFinalizerProc *finalizerProc; void *clientData;struct aeTimeEvent *next;} # 外部结构
aeFiredEvent {int fd; int mask;} # 外部结构
外部结构 与 外部结构之间通过接口建立关联关系，即使是外部结构也不要直接引用外部结构内部字段。
# 结构体既被定义在头文件中，也被定义在实现文件中

[ 外部接口完整实现对象生命周期管理 ] # 外部接口通过注册函数对(事件驱动)处理部数据
5. async.c 外部对象生命周期 不关联 到外部子对象生命周期管理。
           管理对象 分配: redisAsyncConnect redisAsyncConnectUnix 释放 redisAsyncFree
           被管理对象：redisReply 分配: createReplyObject    释放 freeReplyObject
                                        createStringObject
                                        createArrayObject
                                        createIntegerObject
                                        createNilObject
async.c 通过ev{data, addRead, delRead, addWrite, delWrite, cleanup} 将回调接口绑定到event loop上(libevent,libev,libuv)等
async.c 通过onDisconnect和onConnect，用来进行连接管理。
从设计结果上，和libevent的bufferevent有相似之处，和libuv的uv_tcp_init, uv_tcp_start也有相似之处。
libevent     redis                      libuv       # 库
bufferevent  redisAsyncConnect          uv_tcp_t    # 对象
readcb       addRead, delRead,          uv_read_start|uv_read_stop
writecb      addWrite, delWrite,        uv_write
eventcb      onConnect, onDisconnect    uv_connect_cb

核心结构 redisAsyncContext 
redisCallback { struct redisCallback *next; redisCallbackFn *fn; void *privdata;}
redisCallbackList {redisCallback *head, *tail;}
即使以上结构体在头文件中暴露出来，也不是让使用者直接访问其内部字段
# 结构体只在头文件中定义

3. hiredis.c net.c
核心结构 redisContext redisReader redisReplyObjectFunctions redisReply 
4. ae.h redisAeEvents{ redisAsyncContext *context; aeEventLoop *loop; int fd; int reading, writing;}
核心结构 redisAeEvents
   libevent redisLibeventEvents { redisAsyncContext *context;  struct event rev, wev;}
核心结构 redisLibeventEvents
   libev redisLibevEvents { redisAsyncContext *context; struct ev_loop *loop; int reading, writing ev_io rev, wev;}
核心结构 redisLibevEvents
redisAeEvents,redisLibeventEvents,redisLibevEvents 为封装层，提供接口之间参数的修改，没有提供外部结构。
# 结构体只在内部定义
moosefs 极力做到 "结构体只在内部定义" 的状态。

    1. 紧凑性是对一个软件模块大小的很好的评判标准。
一个良好软件模块应该是紧凑的，这样人们便易于理解。达到紧凑性需要对这个模块面向的场景、要解决的问题抽取出良好的抽象和问题定义，
这个抽象概念越明确，问题定义越精准，越有可能导致紧凑的设计。
    2. 正交性是评价模块和模块关系方面设计质量的标准之一。
需要明确场景，对模块进行精准的定义和划分，保证每个模块做且只做好一件事情，设计就趋向正交。
    3. 要对设计中的重复异常敏感，发现重复的代码、数据、资源等都考虑重构，方能趋于SPOT。
}
redis(hiredis){
Hiredis 自带的异步API可以和任何一个事件库配合使用.在EXAMPLES中展示了Hiredis 配合libev和libevent的例子.
Hiredis 带有多个API。 有同步API，异步API和答复解析API。
Hiredis仅支持二进制安全(**binary-safe**)的Redis协议。
除了支持发送命令和接收回复之外，它还附带了一个与I / O层分离的回复解析器。为了方便复用，其设计成为一个流解析器，例如可以在更高级别的语言
    
    [redisAsyncContext] 一个异步链接到redis的上下文
    redisContext c;  # redis通用上下文
    int err;         # 错误值
    char *errstr;    # 错误字符
    void *data;      # 私有数据
    redisDisconnectCallback *onDisconnect; # 断链回调函数
    redisConnectCallback *onConnect;       # 链接回调函数
    redisCallbackList replies;             # 注册的回调处理函数
    struct {                               # 订阅
        redisCallbackList invalid;
        struct dict *channels;
        struct dict *patterns;
    } sub;
    struct {                               # 事件驱动库私有数据和回调函数
        void *data;                        # 
        void (*addRead)(void *privdata);
        void (*delRead)(void *privdata);
        void (*addWrite)(void *privdata);
        void (*delWrite)(void *privdata);
        void (*cleanup)(void *privdata);
    } ev;
redisAsyncContext *redisAsyncConnect(const char *ip, int port)
redisAsyncContext *redisAsyncConnectUnix(const char *path)

int redisAsyncSetConnectCallback(redisAsyncContext *ac, redisConnectCallback *fn) 
int redisAsyncSetDisconnectCallback(redisAsyncContext *ac, redisDisconnectCallback *fn)

    [redisContext] **注意:一个redisContext结构是线程非安全的。**
    int err;            # 错误值
    char errstr[128];   # 错误字符
    int fd;             # 文件描述符
    int flags;          # 标识符
      REDIS_BLOCK
      REDIS_CONNECTED
      REDIS_DISCONNECTING
      REDIS_FREEING
      REDIS_IN_CALLBACK
      REDIS_SUBSCRIBED
      REDIS_MONITORING
    char *obuf;         # 输出缓冲区
    redisReader *reader;  # 协议读取
redisContext *redisContextInit(void) 
redisContext *redisConnect(const char *ip, int port);
redisContext *redisConnectWithTimeout(const char *ip, int port, struct timeval tv) 
redisContext *redisConnectNonBlock(const char *ip, int port)
redisContext *redisConnectUnix(const char *path) 
redisContext *redisConnectUnixWithTimeout(const char *path, struct timeval tv)
redisContext *redisConnectUnixNonBlock(const char *path)
    "redisConnect"用于创建所谓的"redisContext"结构。"redisContext"是"Hiredis"持有连接状态的地方。
当连接处于错误状态时，"redisContext"结构的整数"err"字段不为零。"errstr"字段将包含一个描述错误的字符串。
尝试使用"redisConnect"连接到"Redis"后，应检查"err"字段以查看建立连接是否成功：

void *redisCommand(redisContext *c, const char *format, ...);
    首先介绍的是"redisCommand"。 这个函数的格式类似于"printf"。 最简单的形式是这样使用的：
    reply = redisCommand(context, "SET foo bar");
当您需要在命令中传递二进制安全字符串时，可以使用"％b"说明符。 与指向字符串的指针一起，它需要字符串的"size_t"长度参数
    reply = redisCommand(context, "SET foo %b", value, (size_t) valuelen);
    在内部，"Hiredis"将命令拆分为不同的参数，并将其转换为与"Redis"进行通信的协议。 一个或多个空格分隔参数，因此您可以
在参数的任何位置使用说明符

    当命令成功执行时，"redisCommand"的返回值保留一个回复。 发生错误时，返回值为"NULL"，上下文中的err字段将被设置。 
一旦错误返回，上下文不能被重用，你应该建立一个新的连接。
    "redisCommand"的标准回复类型是"redisReply"。 应该使用"redisReply"中的类型字段来测试收到的答复类型：
    REDIS_REPLY_STATUS 状态字符串可以使用"reply-> str"来访问。 这个字符串的长度可以使用"reply-> len"来访问。
    REDIS_REPLY_ERROR   回复了一个错误。 错误字符串可以被访问"REDIS_REPLY_STATUS"来获得。
    REDIS_REPLY_INTEGER 一个整数来回答。 可以使用"long long"类型的"reply-> integer"字段来访问整数值
    REDIS_REPLY_NIL     回答了一个无效的**nil**对象。 其表示没有数据可以访问。
    REDIS_REPLY_STRING 批量数据(字符串)回复。 答复的值可以使用"reply-> str"来访问。这个字符串的长度可以使用"reply-> len"来访问
    REDIS_REPLY_ARRAY 多批量数据回复。 多批量数据回复中的元素数量存储在"reply->elements"。 多批量回复中的每个元素也是一个
    "redisReply"对象，可以通过"reply->element [.. index ..]"进行访问。
    reply = redisCommand(context, "SET key:%s %s", myid, value);
void freeReplyObject(void *reply);

void redisFree(redisContext *c); # 要断开和释放上下文，立即关闭套接字，然后释放创建上下文的分配。

    [redisReader]
    int err;            # 错误值
    char errstr[128];   # 错误字符
    char *buf;          # 读缓冲区
    size_t pos;         # 读缓冲区游标
    size_t len;         # 读缓冲区长度
    size_t maxbuf;      # 读缓冲区最大长度
    redisReadTask rstack[9];        # 读任务数组
    int ridx;                       # 当前读任务位移
    void *reply;                    # 临时响应指针
    redisReplyObjectFunctions *fn;  # 响应回调函数
    void *privdata;                 # 私有数据
    
redisReader *redisReaderCreate(void);
void redisReaderFree(redisReader *reader);
int redisReaderFeed(redisReader *reader, const char *buf, size_t len);
int redisReaderGetReply(redisReader *reader, void **reply);
在创建正常的Redis上下文时，hiredis在内部使用相同的一组函数，上面的API只是将其公开给用户以供直接使用。

    [redisReadTask]
    int type;
    int elements;
    int idx;
    void *obj;
    struct redisReadTask *parent;
    void *privdata; 
    
    [redisAeEvents] Ae
    redisAsyncContext *context;
    aeEventLoop *loop;
    int fd;
    int reading, writing;
    
    [redisLibeventEvents]
    redisAsyncContext *context;
    struct event rev, wev;
    
    [redisLibevEvents]
    redisAsyncContext *context;
    struct ev_loop *loop;
    int reading, writing;
    ev_io rev, wev;
}
redis(sync){
    [Synchronous API]
    redisContext *redisConnect(const char *ip, int port);
    void *redisCommand(redisContext *c, const char *format, ...);
    void freeReplyObject(void *reply);
    
    # [Connecting]
    redisContext *c = redisConnect("127.0.0.1", 6379);
    if (c == NULL || c->err) {
        if (c) {
            printf("Error: %s\n", c->errstr);
            // handle error
        } else {
            printf("Can't allocate redis context\n");
        }
    }

    # [Sending commands]
    reply = redisCommand(context, "SET foo bar");
    reply = redisCommand(context, "SET foo %s", value);
    reply = redisCommand(context, "SET foo %b", value, (size_t) valuelen);
    reply = redisCommand(context, "SET key:%s %s", myid, value);
    
    # [Connecting]
    REDIS_REPLY_STATUS    reply->str     reply->len
    REDIS_REPLY_ERROR     reply->str     reply->len
    REDIS_REPLY_INTEGER   reply->integer
    REDIS_REPLY_NIL
    REDIS_REPLY_STRING    reply->str     reply->len
    REDIS_REPLY_ARRAY     reply->elements           reply->element[..index..]
    -> redisReply
    freeReplyObject() 不必释放array类型底层redisReply实例
    
    # [Cleaning up]
    void redisFree(redisContext *c);
    
    # [Sending commands]
    void *redisCommandArgv(redisContext *c, int argc, const char **argv, const size_t *argvlen);
    
    [Pipelining]
    redisReply *reply;
    redisAppendCommand(context,"SET foo bar");
    redisAppendCommand(context,"GET foo");
    redisGetReply(context,&reply); // reply for SET
    freeReplyObject(reply);
    redisGetReply(context,&reply); // reply for GET
    freeReplyObject(reply);

    [subscriber]
    reply = redisCommand(context,"SUBSCRIBE foo");
    freeReplyObject(reply);
    while(redisGetReply(context,&reply) == REDIS_OK) {
        // consume message
        freeReplyObject(reply);
    }
    
    [error]
    REDIS_ERR_IO
    REDIS_ERR_EOF
    REDIS_ERR_PROTOCOL
    REDIS_ERR_OTHER
}
redis(async){
    [redisAsyncConnect]
    redisAsyncConnect 这个函数可以用来建立与Redis的非阻塞连接. 这个函数会返回一个新创建的redisAsyncContext 结构体.
创建后需要检查redisAsyncContext 结构体中的 err字段, 查看创建连接是否发生错误.因为创建的连接是非阻塞的, 就算立刻连上
了Redis,内核也无法立刻返回.
    redisAsyncContext *c = redisAsyncConnect("127.0.0.1", 6379); 
    if (c->err){ printf("Error: %s\n", c->errstr); 
    // handle error 
    }
    
    [disconnect]
    异步context可以保存断开连接的回调函数，函数原型如下
    void(const redisAsyncContext *c, int status);
    如果是用户主动断开连接，则status会被设置成REDIS_OK
    如果发生错误，status会被设置成REDIS_ERR
    发生错误时, 可以通过redisAsyncContext中的err来查看具体的原因.
    每一个Contaxt只能设置一次断开连接回调， 除了第一次设置的，后面的status都会被设置成REDIS_ERR, 函数原型如下：
    int redisAsyncSetDisconnectCallback(redisAsyncContext *ac, redisDisconnectCallback *fn);
    
    [Sending commands and their callbacks]
    void(redisAsyncContext *c, void *reply, void *privdata);
    int redisAsyncCommand( redisAsyncContext *ac, redisCallbackFn *fn, void *privdata, const char *format, ...); 
    int redisAsyncCommandArgv( redisAsyncContext *ac, redisCallbackFn *fn, void *privdata, int argc, const char **argv, const size_t *argvlen);
    
    [Disconnecting]
    void redisAsyncDisconnect(redisAsyncContext *ac);
    
    [Event library data and hooks]
    {                                     libevent               libev               ae               ivykis              libuv
        void *data;                       e(redisLibeventEvents) e(redisLibevEvents) e(redisAeEvents) e(redisIvykisEvents) e(redisLibuvEvents)
        void (*addRead)(void *privdata);  redisLibeventAddRead   redisLibevAddRead   redisAeAddRead   redisIvykisAddRead   redisLibuvAddRead
        void (*delRead)(void *privdata);  redisLibeventDelRead   redisLibevDelRead   redisAeDelRead   redisIvykisDelRead   redisLibuvDelRead
        void (*addWrite)(void *privdata); redisLibeventAddWrite  redisLibevAddWrite  redisAeAddWrite  redisIvykisAddWrite  redisLibuvAddWrite
        void (*delWrite)(void *privdata); redisLibeventDelWrite  redisLibevDelWrite  redisAeDelWrite  redisIvykisDelWrite  redisLibuvDelWrite
        void (*cleanup)(void *privdata);  redisLibeventCleanup   redisLibevCleanup   redisAeCleanup   redisIvykisCleanup   redisLibuvCleanup
    } ev;                                                                                                                          
    事件驱动程序和async.c之间适配层。
    e(redisLibeventEvents|redisLibevEvents|redisAeEvents) 绑定了 redisAsyncContext实例和 对应Event library实例之间关系。
    
    1. hiredis可以绑定libevent libev ae libuv ivykis等等。async实例很有linux文件系统实例要求方式。
    提供了回调函数集合以及相关的私有数据，私有数据用以实现event loop实例和redisAsyncContext实例之间关联。
    原则上这些接口都是必须实现的。
    2. async实例还提供了connectCallback 和 disconnectCallback回调函数，该回调函数指明redisAsyncContext实例参数和状态参数
    
    [Reply parsing API]
    redisReader *redisReaderCreate(void);
    void redisReaderFree(redisReader *reader);
    int redisReaderFeed(redisReader *reader, const char *buf, size_t len);
    int redisReaderGetReply(redisReader *reader, void **reply);
}

redis(libevent){

}
redis(libev){

}

monit(color){

#define COLOR_RESET        "\033[0m"
#define COLOR_BOLD         "\033[1m"

#define COLOR_BLACK        "\033[0;30m"
#define COLOR_RED          "\033[0;31m"
#define COLOR_GREEN        "\033[0;32m"
#define COLOR_YELLOW       "\033[0;33m"
#define COLOR_BLUE         "\033[0;34m"
#define COLOR_MAGENTA      "\033[0;35m"
#define COLOR_CYAN         "\033[0;36m"
#define COLOR_WHITE        "\033[0;37m"
#define COLOR_DEFAULT      "\033[0;39m"

#define COLOR_BOLDBLACK    "\033[1;30m"
#define COLOR_BOLDRED      "\033[1;31m"
#define COLOR_BOLDGREEN    "\033[1;32m"
#define COLOR_BOLDYELLOW   "\033[1;33m"
#define COLOR_BOLDBLUE     "\033[1;34m"
#define COLOR_BOLDMAGENTA  "\033[1;35m"
#define COLOR_BOLDCYAN     "\033[1;36m"
#define COLOR_BOLDWHITE    "\033[1;37m"

#define COLOR_DARKGRAY     "\033[0;90m"
#define COLOR_LIGHTRED     "\033[0;91m"
#define COLOR_LIGHTGREEN   "\033[0;92m"
#define COLOR_LIGHTYELLOW  "\033[0;93m"
#define COLOR_LIGHTBLUE    "\033[0;94m"
#define COLOR_LIGHTMAGENTA "\033[0;95m"
#define COLOR_LIGHTCYAN    "\033[0;96m"
#define COLOR_LIGHTWHITE   "\033[0;97m"


#define Color_black(format, ...)        COLOR_BLACK format COLOR_RESET, ##__VA_ARGS__
#define Color_red(format, ...)          COLOR_RED format COLOR_RESET, ##__VA_ARGS__
#define Color_green(format, ...)        COLOR_GREEN format COLOR_RESET, ##__VA_ARGS__
#define Color_yellow(format, ...)       COLOR_YELLOW format COLOR_RESET, ##__VA_ARGS__
#define Color_blue(format, ...)         COLOR_BLUE format COLOR_RESET, ##__VA_ARGS__
#define Color_magenta(format, ...)      COLOR_MAGENTA format COLOR_RESET, ##__VA_ARGS__
#define Color_cyan(format, ...)         COLOR_CYAN format COLOR_RESET, ##__VA_ARGS__
#define Color_white(format, ...)        COLOR_WHITE format COLOR_RESET, ##__VA_ARGS__
#define Color_boldBlack(format, ...)    COLOR_BOLDBLACK format COLOR_RESET, ##__VA_ARGS__
#define Color_boldRed(format, ...)      COLOR_BOLDRED format COLOR_RESET, ##__VA_ARGS__
#define Color_boldGreen(format, ...)    COLOR_BOLDGREEN format COLOR_RESET, ##__VA_ARGS__
#define Color_boldYellow(format, ...)   COLOR_BOLDYELLOW format COLOR_RESET, ##__VA_ARGS__
#define Color_boldBlue(format, ...)     COLOR_BOLDBLUE format COLOR_RESET, ##__VA_ARGS__
#define Color_boldMagenta(format, ...)  COLOR_BOLDMAGENTA format COLOR_RESET, ##__VA_ARGS__
#define Color_boldCyan(format, ...)     COLOR_BOLDCYAN format COLOR_RESET, ##__VA_ARGS__
#define Color_boldWhite(format, ...)    COLOR_BOLDWHITE format COLOR_RESET, ##__VA_ARGS__
#define Color_darkGray(format, ...)     COLOR_DARKGRAY format COLOR_RESET, ##__VA_ARGS__
#define Color_lightRed(format, ...)     COLOR_LIGHTRED format COLOR_RESET, ##__VA_ARGS__
#define Color_lightGreen(format, ...)   COLOR_LIGHTGREEN format COLOR_RESET, ##__VA_ARGS__
#define Color_lightYellow(format, ...)  COLOR_LIGHTYELLOW format COLOR_RESET, ##__VA_ARGS__
#define Color_lightBlue(format, ...)    COLOR_LIGHTBLUE format COLOR_RESET, ##__VA_ARGS__
#define Color_lightMagenta(format, ...) COLOR_LIGHTMAGENTA format COLOR_RESET, ##__VA_ARGS__
#define Color_lightCyan(format, ...)    COLOR_LIGHTCYAN format COLOR_RESET, ##__VA_ARGS__
#define Color_lightWhite(format, ...)   COLOR_LIGHTWHITE format COLOR_RESET, ##__VA_ARGS__

printf(Color_black("Color_black\n"));
}

monit(NEW){ NEW
封装的内存管理
#低版本
#define NEW(p) ((p)= xcalloc(1, (long)sizeof *(p)))
#define FREE(p) ((void)(free(p), (p)= 0))

# 高版本
#define ALLOC(n) Mem_alloc((n), __func__, __FILE__, __LINE__)
#define CALLOC(c, n) Mem_calloc((c), (n), __func__, __FILE__, __LINE__)
#define NEW(p) ((p) = CALLOC(1, (long)sizeof *(p)))
#define FREE(p) ((void)(Mem_free((p), __func__, __FILE__, __LINE__), (p) = 0))
}

monit(debug){ debug && assert
void LogEmergency(const char *s, ...)   # 忽略
void LogAlert(const char *s, ...)       # 忽略
void LogCritical(const char *s, ...)    # LogCritical("AssertException: " #e " at %s:%d\naborting..\n", __FILE__, __LINE__); abort(); 
void LogError(const char *s, ...)       # 有调用
以上函数都会打印backtrace, 
LogAlert和LogEmergency在代码中未使用，
LogError输出要输出的信息和backtrace,                               # 系统调用未达到 目的
LogCritical用于ASSERT，在输出错误信息和backtrace之后，调用abort    # 函数输入未达到 目的

yyerror2            yyerror2           # 参数错误
yywarning2          LogWarning         # 参数告警

void LogWarning(const char *s, ...)  # 配文件解析
void LogNotice(const char *s, ...)   # 忽略
void LogInfo(const char *s, ...)     # 触发性打印
void LogDebug(const char *s, ...)    # 周期性调用
LogDebug被重命名为DEBUG，

#define ASSERT(e) do { if(!(e)) { LogCritical("AssertException: " #e \
        " at %s:%d\naborting..\n", __FILE__, __LINE__); abort(); } } while(0)
        
#define DEBUG LogDebug                # 高版本
#define DEBUG if(Run.debug) LogDebug  # 低版本
}

redis(debug){
void redisLog(int level, const char *fmt, ...) 
REDIS_DEBUG         普通打印
REDIS_VERBOSE       触发性打印(连接断链，协议错误)  存在错误
REDIS_NOTICE        触发性打印(请求应答，周期任务)  存在触发
REDIS_WARNING       错误退出， 用于 assert panic 和 signal(SIGSEGV|SIGBUS|SIGFPE|SIGILL) signal(SIGALRM)

#define redisAssertWithInfo(_c,_o,_e) ((_e)?(void)0 : (_redisAssertWithInfo(_c,_o,#_e,__FILE__,__LINE__),_exit(1)))
#define redisAssert(_e) ((_e)?(void)0 : (_redisAssert(#_e,__FILE__,__LINE__),_exit(1)))
#define redisPanic(_e) _redisPanic(#_e,__FILE__,__LINE__),_exit(1)
}
moosefs(debug){
moosefs(日志@协议)
在strerr.h 中通过 宏 重新定义 错误宏值和宏值描述 之间对应关系。
moosefs(断言@协议)
}

monit(rescurive){ rescurive 链表
static void _gc_service_list(Service_T *s) {
        ASSERT(s&&*s);
        if ((*s)->next)
                _gc_service_list(&(*s)->next);
        _gc_service(&(*s));
}
# s为二级指针，在_gc_service_list递归调用自身时，顺带调用_gc_service以释放Service_T关联的对象内存。

低版本的
static void put_monit_environment(Environment_T e);
static void free_monit_environment(Environment_T *e);
static void push_monit_environment(const char *env, Environment_T *list);
static void set_monit_environment(Service_T s, Command_T C, Event_T event, Environment_T *e);
更能说明这点；
push_monit_environment添加Environment_T项，list为二级指针。set_monit_environment的e也是二级指针。
free_monit_environment用于释放
put_monit_environment 用以访问
}

monit(cii){
monit 和 cii 会将一些结构体定义为T；T在头文件中开头定义为结构体，且在 头文件尾部使用 "#undef T"取消定义；
T在此表示 提供特定功能的上下文管理对象，且上下文结构体 对模块外部是私有，对模块内部是公开的。
}

monit(string){
void Util_handleEscapes(char *buf) # 将字符串中的"\n"转变成C语言中的'\n'(即\012)
int Util_handle0Escapes(char *buf) # 将字符串中的"\0xFF" 转变成C语言中的 值

crosstool/cheatsheet/ops_doc-master/cii/cii15_str.txt

char* changelog_escape_name(uint32_t nleng,const uint8_t *name)  # 将name中不能打印的ASCII字母和大于127的值，转变成"%FF"的字符串

}

monit(str_vcat){ 格式化
char *Str_vcat(const char *s, va_list ap) 
    va_list ap_copy;
    va_copy(ap_copy, ap);
    int size = vsnprintf(t, 0, s, ap_copy) + 1;
    va_end(ap_copy);
    t = ALLOC(size);
    va_copy(ap_copy, ap);
    vsnprintf(t, size, s, ap_copy);
    va_end(ap_copy);
}

命名
open_log                模块内函数名
logPriorityDescription  模块内函数名
log_close log_init      模块外函数名
LogEmergency            模块外函数名
vLogEmergency           模块外函数名



monit(awk){
1. 差异性
lua,python等脚本语言支持C语言扩展，awk不支持C语言扩展。
monit通过p.y和l.l实现对配置文件的解析，而awk通过"模式-动作"编程方式，实现对配置文件或其他文件解析；
awk和sed都是"模式-动作"方式的文本处理工具。每行数据可以对应多条"模式-动作"，即: 一行数据可以被处理多次。
sed 通过模式匹配进行定位，使用特定的函数和模式替换对输入进行处理；
awk通过模式匹配和条件判断语句匹配进行定位，通过特定函数和位置变量赋值对输入数据进行处理。
sed通过保存空间保存临时数据，保存空间相当于一个变量
awk通过位置变量、自定义变量、环境变量和关联数组保存临时数据，所以awk处理数据更加强大。

2. 共同性
awk,sed,monit和lua,python都强调模式匹配的重要性，
lua和python模式匹配用在数据处理上。 -- 强调语言功能特性，
awk和sed将模式匹配用在处理文本上，  -- 强调数据处理能力，
monit将模式匹配用在解析配置文件上， -- 强调配置文件灵活性，
3. 基于flex和bison形式的模式匹配
flex是基于流的模式-执行单元组；
awk 是基于行|字段的模式-执行单元组；
sed 是基于行的模式-执行单元组；
bison 是基于token关系的模式-执行单元组
find+xargs 也可以某种意义的模式-执行单元组
4. glob regex 
man 7 regex  {grep}
man 3 regex  
man 7 glob   {sh, ls, stat, exec}
man 3 glob
}
libubox(){
void *__calloc_a(size_t len, ...)
}

keeplive(http://www.tldp.org/HOWTO/html_single/TCP-Keepalive-HOWTO/){
int keepAlive = 1; // 开启keepalive属性
int keepIdle = 60; // 如该连接在60秒内没有任何数据往来,则进行探测 
int keepInterval = 5; // 探测时发包的时间间隔为5 秒
int keepCount = 3; // 探测尝试的次数.如果第1次探测包就收到响应了,则后2次的不再发.

SO_KEEPALIVE
TCP_KEEPIDLE      # overrides tcp_keepalive_time
TCP_KEEPINTVL     # overrides tcp_keepalive_intvl
TCP_KEEPCNT       # overrides tcp_keepalive_probes

/proc/sys/net/ipv4/tcp_keepalive_time 开始首次KeepAlive探测前的TCP空闭时间 #   > net.ipv4.tcp_keepalive_time 
/proc/sys/net/ipv4/tcp_keepalive_intvl 两次KeepAlive探测间的时间间隔       #   > net.ipv4.tcp_keepalive_intvl 
/proc/sys/net/ipv4/tcp_keepalive_probes 判定断开前的KeepAlive探测次数      #   > net.ipv4.tcp_keepalive_probes

1. 检查对端是否存活
    _____                                                     _____
   |     |                                                   |     |
   |  A  |                                                   |  B  |
   |_____|                                                   |_____|
      ^                                                         ^
      |--->--->--->-------------- SYN -------------->--->--->---|
      |---<---<---<------------ SYN/ACK ------------<---<---<---|
      |--->--->--->-------------- ACK -------------->--->--->---|
      |                                                         |
      |                                       system crash ---> X
      |
      |                                     system restart ---> ^
      |                                                         |
      |--->--->--->-------------- PSH -------------->--->--->---|
      |---<---<---<-------------- RST --------------<---<---<---|
      |                                                         |
2. 防止由于网络引起的断链
    _____           _____                                     _____
   |     |         |     |                                   |     |
   |  A  |         | NAT |                                   |  B  |
   |_____|         |_____|                                   |_____|
      ^               ^                                         ^
      |--->--->--->---|----------- SYN ------------->--->--->---|
      |---<---<---<---|--------- SYN/ACK -----------<---<---<---|
      |--->--->--->---|----------- ACK ------------->--->--->---|
      |               |                                         |
      |               | <--- connection deleted from table      |
      |               |                                         |
      |--->- PSH ->---| <--- invalid connection                 |
      |               |                                         |

 $ test
  SO_KEEPALIVE is OFF

  $ LD_PRELOAD=libkeepalive.so \
  > KEEPCNT=20 \
  > KEEPIDLE=180 \
  > KEEPINTVL=60 \
  > test
  SO_KEEPALIVE is ON
  TCP_KEEPCNT   = 20
  TCP_KEEPIDLE  = 180
  TCP_KEEPINTVL = 60   
}

reuseaddr(SO_REUSEADDR){
Q:编写 TCP/SOCK_STREAM 服务程序时，SO_REUSEADDR到底什么意思？
A:这个套接字选项通知内核，如果端口忙，但TCP状态位于 TIME_WAIT ，可以重用端口。
  如果端口忙，而TCP状态位于其他状态，重用端口时依旧得到一个错误信息，指明"地址已经使用中"。
  如果你的服务程序停止后想立即重启，而新套接字依旧使用同一端口，此时SO_REUSEADDR 选项非常有用。

SO_REUSEADDR提供如下四个功能：
    SO_REUSEADDR允许启动一个监听服务器并捆绑其众所周知端口，即使以前建立的将此端口用做他们的本地端口的连接仍存在。这通常是重启监听服务器时出现，若不设置此选项，则bind时将出错。
    SO_REUSEADDR允许在同一端口上启动同一服务器的多个实例，只要每个实例捆绑一个不同的本地IP地址即可。对于TCP，我们根本不可能启动捆绑
                相同IP地址和相同端口号的多个服务器。UDP?IGMP?协议
    SO_REUSEADDR允许单个进程捆绑同一端口到多个套接口上，只要每个捆绑指定不同的本地IP地址即可。这一般不用于TCP服务器。
    SO_REUSEADDR允许完全重复的捆绑：当一个IP地址和端口绑定到某个套接口上时，还允许此IP地址和端口捆绑到另一个套接口上。一般来说，
                这个特性仅在支持多播的系统上才有，而且只对UDP套接口而言（TCP不支持多播）。

SO_REUSEPORT选项有如下语义：
    此选项允许完全重复捆绑，但仅在想捆绑相同IP地址和端口的套接口都指定了此套接口选项才行。
    如果被捆绑的IP地址是一个多播地址，则SO_REUSEADDR和SO_REUSEPORT等效。

}
TCP_NODELAY(黏包问题;"粘包"可发生在发送端也可发生在接收端.)
{
tcpip协议使用"流式"（套接字）进行数据的传输，就是说它保证数据的可达以及数据抵达的顺序，但并不保证数据是否在你接收的时候
就到达，特别是为了提高效率，充分利用带宽，底层会使用缓存技术，具体的说就是使用Nagle算法将小的数据包放到一起发送，但是
这样也带来一个使用上的问题——黏包，黏包就是说一次将多个数据包发送出去，导致接收方不能进行正常的解析，

int enable=1; 
setsockopt(sockfd,IPROTO_TCP,TCP_NODELAY,(void*)&enable,sizeof(enable))

接收方的黏包问题可以使用recv(sockfd,buf,sizeof(buf),MSG_WAITALL)来解决，MSG_WAITALL可以强制接收方收到sizeof(buf)那么多的
数据才返回，而buf的大小可以是收发双方约定好的大小。

1:如果利用tcp每次发送数据，就与对方建立连接，然后双方发送完一段数据后，就关闭连接，这样就不会出现粘包问题
 （因为只有一种包结构,类似于http协议）。关闭连接主要要双方都发送close连接（参考tcp关闭协议）。如：A需要发送
  一段字符串给B，那么A与B建立连接，然后发送双方都默认好的协议字符如"hello give me sth abour yourself"，
  然后B收到报文后，就将缓冲区数据接收,然后关闭连接，这样粘包问题不用考虑到，因为大家都知道是发送一段字符。
2：如果发送数据无结构，如文件传输，这样发送方只管发送，接收方只管接收存储就ok，也不用考虑粘包

三 .粘包出现原因：在流传输中出现，UDP不会出现粘包，因为它有消息边界(参考Windows 网络编程)
1 发送端需要等缓冲区满才发送出去，造成粘包
2 接收方不及时接收缓冲区的包，造成多个包接收
}

AF_LOCAL(代码流程){
1. socket()
//创建网络端点，返回socket文件描述符，失败返回-1设errno
int socket(int domain, int type, int protocol);
domain:AF_INET, AF_LOCAL
type: SOCK_STREAM  可靠的、全双工、面相连接的字节流
      SOCK_DGRAM   不可靠，尽力而为的数据报服务
      SOCK_RAW     允许对IP层的某些数据报进行访问
protocol: SOCK_STREAM:0， SOCK_DGRAM:0 SOCK_RAW:需要指定

2. 准备通信地址:
struct sockaddr{    //主要用于函数的形参类型, 很少定义结构体变量使用, 叫做通用的通信地址类型//$man bind
    sa_family_t     sa_family;
    char            sa_data[14];
}
struct sockaddr_un{ //准备本地通信的通信地址   //$man un.h
    sa_family_t     sun_family;//协议族,就是socket()的domain的AF_LOCAL
    char            sun_path[];//文件的路径
}

3. bind()
//把通信地址和socket文件描述符绑定，用在服务器端，成功返回0,失败返回-1设errno
int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

sockfd: socket文件的fd(returned by socket())
addr: 需要强制类型转换成socketaddr_un或soketaddr_in, 参见上
addrlen: 通信地址的大小, 使用sizeof();

4. connect():
//初始化一个socket的连接，用在客户端，成功返回0,失败返回-1设errno
int connect(int sockfd, const struct sockaddr *addr,socklen_t addrlen);
sockfd: socket文件的fd(returned by socket())
addr: 需要强制类型转换成socketaddr_un或soketaddr_in, 参见上
addrlen: 通信地址的大小, 使用sizeof();
}

SO_BROADCAST()
{
1. 广播
广播即向当前网段的所有主机进行广播。广播的信息是在接受方的传输层才决定是否被处理，广播主机的使用当前网段的最大ip地址作为广播地址，即，xxx.xxx.xxx.255，而255.255.255.255在所有网段都是广播地址。 只有使用udp套接字才能广播，而默认设置的socket是不允许发送广播的，需要setsockopt()进行设置
模型

sockfd=soket();
...
int on = 1;
setsockopt(sockfd,SOL_SOCKKET,SO_BROADCAST,&on,sizeof(on));
...
sendto();


2. 组播
广播在接收主机的传输层才会决定是否处理，如果很多主机都是不处理，这种广播风暴无疑会大大的占用带宽并增加主机负载。组播就可以解决既希望实现"一发多收"又不希望引起"广播风暴"的一种机制。组播就是只发消息给组内的主机，而不是网段内所有的主机。
模型

//netinet/in.h
struct ip_mreq{
    struct in_addr imr_multiaddr;
    struct in_addr imr_interface;
};

// 加入多播组
struct ip_mreq mreq;
bzero(&mreq,sizeof(mreq));
mreq.imr_multiaddr.s_addr=inet_addr("224.1.2.2");
mreq.imr_interface.s_addr=htonl(INADDR_ANY);    
setsockopt(sockfd,IPPROTO_IP,IP_ADD_MEMBERSHIP,&mreq,sizeof(mreq));

}

sockaddr_storage(redis dnsmasq：IPv4和IPv6混合编程){
1. 不像struct sockaddr，新的struct sockaddr_storage足以容纳系统所支持的任何套接字地址结构，sockaddr_storage结构
   在<netinet/in.h>头文件中定义。
   
struct sockaddr_storage
  {
    __SOCKADDR_COMMON (ss_);
    __ss_aligntype __ss_align;
    char __ss_padding[_SS_PADSIZE];
  }; 
#define	__SOCKADDR_COMMON(sa_prefix)	\
  unsigned char sa_prefix##len;		\
  sa_family_t sa_prefix##family
  
sockaddr_storage和sockaddr的主要差别
(1) sockaddr_storage通用套接字地址结构满足对齐要求。
(2) sockaddr_storage通用套接字地址结构足够大，能够容纳系统支持的任何套接字地址结构。

man sys_socket.h  #说明
man getaddrinfo   #例子

getpeername
getsockname
accept


len长度大小在<netinet/in.h>头文件中有如下定义：
#define INET_ADDRSTRLEN 16 /* for IPv4 dotted-decimal */
#define INET6_ADDRSTRLEN 46  /* for IPv6 dotted-decimal */
}

INET_ADDRSTRLEN(netinet/in.h:字符串表示地址时，字符串最大长度){
int inet_pton(int family, const char *strptr, void *addrptr);
const char *inet_ntop(int family, const void *addrptr, char *strptr, size_t len);

}
INET6_ADDRSTRLEN(netinet/in.h:字符串表示地址时，字符串最大长度){
int inet_pton(int family, const char *strptr, void *addrptr);
const char *inet_ntop(int family, const void *addrptr, char *strptr, size_t len);
}


sendmsg(不能用sendmsg提升原始套接字发送性能){
使用原始套接字发送IP报文，通过setsocketopt中的IP_HDRINCL(Header Include)选项来设置socket，由应用而不是协议栈自动填充IP header。
原来是通过sendto发送，在实际测试中发现每次sendto调用需要10微秒做左右。就像stackoverflow的这篇文章一样，希望通过sendmsg提高发送速度。

struct msghdr {
    void         *msg_name;       /* optional address */
    socklen_t     msg_namelen;    /* size of address */
    struct iovec *msg_iov;        /* scatter/gather array */
    size_t        msg_iovlen;     /* # elements in msg_iov */
    void         *msg_control;    /* ancillary data, see below */
    size_t        msg_controllen; /* ancillary data buffer len */
    int           msg_flags;      /* flags (unused) */
};

我们将多个已构造的IP包，填充到msg_iov数组内，再调用sendmsg，结果出错，返回EMSGSIZE，即message too long。
查阅资料后发现，对于不需要协议栈填充IP头的原始套接字，msg_iov数据总长度超过MTU时，sendmsg不能一次发送。
如果没有设置IP_HDRINCL来由我们自己定义IP头部，那么sendmsg会进行IP分片。
综上，sendmsg无法提升原始套接字发送IP包的速度。
参考：
http://blog.csdn.net/liuxingen/article/details/45622517
http://sock-raw.org/papers/sock_raw

}


rio(磁盘IO){

 RIO 是一个可以面向流、可用于对多种不同的输入（目前是文件和内存字节）进行编程的抽象。
 比如说，RIO 可以同时对内存或文件中的 RDB 格式进行读写。
 一个 RIO 对象提供以下方法：
read: read from stream. 从流中读取
write: write to stream.  写入到流中
tell: get the current offset. 获取当前的偏移量

这里调用fread和fwrite以及相关的ftello。
fflush(r->io.file.fp);                                                 将数据从用户态同步到内核态
aof_fsync(fileno(r->io.file.fp)); aof_fsync可以为fdatasync或者fsync    将数据从内核态同步到磁盘
 
}

tcpcopy(把知识叠入数据以求逻辑质朴而健壮){

}

tcpcopy(IO处理相关模块接口)
{
(tc_event.c tc_event.h) + [tc_epoll_module.[c|h] 或 tc_select_module.[c|h]] 实现多路IO

1. [tc_socket.c ]
阻塞读写设置(逻辑上异常退出，不能处理部分数据接收、发送情况)
tc_socket_snd
   发送是在屏蔽了异常之后的阻塞发送，发送没有超时时间，有异常中断次数限制。
        发送阻塞在send系统调用；
        未发送指定长度返回失败，而不是发送数据长度。
tc_socket_rcv
   接收是在屏蔽了异常之后的阻塞接收，接收没有超时时间，有异常中断次数限制。
        接收阻塞在recv系统调用；
        未接受指定长度返回失败，而不是接收数据长度。

2. tc_epoll_module.c/tc_epoll_module.h
   tc_select_module.c/tc_select_module.h
   实现底层epoll和select系统接口的封装。提供了对tc_event_t抽象数据结构的管理。
   
   tc_event.c/tc_event.h 将以上两种相似机制抽象出统一的接口。同时，也调用了
   tc_event_timer.c/tc_event_timer.h 提供的基于红黑树的时间超时注册处理函数。
   tc_time.c/tc_time.h 提供的时间更新接口。
        
多路IO的实现比较模块化，时间管理是一个模块、定时器管理是一个模块，多路IO处理是一个模块，多路IO系统调用的实现又是一个模块。

redis和tcpcopy:注册回调机制
   本系统的多路IO接口，每次文件描述事件注册，要么是读事件注册，要么是写事件注册，不能同时注册读写事件。
   redis的多路IO接口，每次文件描述符事件注册，可以同时注册读事件和写事件，此时读事件和写事件使用相同读写事件处理函数。
   
   本系统需要在注册前申请tc_event_t对象，建立文件描述符和读事件处理函数、写事件处理函数。
   redis的多路IO接口，建立文件描述符和读事件处理函数、写事件处理函数的管理是在注册的时候已经建立的。
   
   本系统不支持TCP连接多实例方式注册，因为没有提供对私有数据的管理，这使得系统只能处理单实例的。
   redis的多路IO接口，提供了私有数据的注册，这使得在处理多实例的时候，更加方便，更加简单。
   
   本系统的多路IO框架更加模块化，时间管理模块、定时器管理模块和多路IO处理模块在tc_event_proc_cycle函数中进行了耦合处理。
   redis的多路IO接口将定时器管理、多路IO处理模块和每次处理模块统一在aeProcessEvents函数中进行耦合，不过模块化不强。
   
redis、tcpcopy、moosefs、dnsmasq:超时处理机制
1. redis、tcpcopy、moosefs超时时间片单位为毫秒，dnsmasq超时时间片单位为秒；
2. redis、tcpcopy、moosefs都提供了超时注册处理函数，dnsmasq没有提供超时注册处理函数。
3. redis和moosefs提供了poll调用次数相关的注册处理函数，redis在阻塞前被调用，只能注册一个回调函数；moosefs在阻塞后被调用，可以注册多个回调函数。
4. moosefs提供注册处理时间片相对偏移量。redis和tcpcopy没有提供。
5. redis和tcpcopy提供了私有数据，这样可以使处理函数处理多实例对象。而moosefs未提供私有数据，不能用于处理多实例。
6. tcpcopy有毫秒超时判断，在同一毫秒内超时处理函数不会被执行。redis、moosefs和dnsmasq没有。
7. tcpcopy基于红黑树处理超时函数，redis事件处理使用链表形式，大量注册有些问题。
8. moosefs是10毫秒定时超时；redis根据超时时间计算出超时；dnsmasq根据dns转发请求和相应超时设定超时；tcpcopy是最长500毫秒的超时任务。
   moosefs、redis注册的是周期性超时定时器，tcpcopy、libevent注册的是一次性超时定时器，有点类似内核的定时器。
}


tcp_burn(IO处理相关模块接口){

}

intercept(IO处理相关模块接口){

}

cmake(把知识叠入数据以求逻辑质朴而健壮){
------------------------------------------------------------------------------- 数据
1. 关于数据
1.1 cmake自定义变量的方式 
SET(HELLO_SRC main.c)，
1.2 cmake常用变量
CMAKE_BINARY_DIR  PROJECT_BINARY_DIR  <projectname>_BINARY_DIR   CMAKE_CURRENT_BINARY_DIR
CMAKE_SOURCE_DIR  PROJECT_SOURCE_DIR  <projectname>_SOURCE_DIR   CMAKE_CURRENT_SOURCE_DIR
CMAKE_CURRENT_SOURCE_DIR    CMAKE_CURRRENT_BINARY_DIR
PROJECT_NAME
EXECUTABLE_OUTPUT_PATH      LIBRARY_OUTPUT_PATH
CMAKE_INCLUDE_CURRENT_DIR   CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE
1.3 cmake环境变量
CMAKE_INCLUDE_PATH  CMAKE_LIBRARY_PATH
设置编译环境变量
LDFLAGS= XXX  #设置link标志
CXXFLAGS= XXX #初始化CMAKE_CXX_FLAGS
CFLAGS= XXX   #初始化CMAKE_C_FLAGS

--------------------------------------- 作用域
数据：       # 作用域
1. 系统环境变量 # 进程执行时环境变量；CPU，操作系统，操作系统对进程启动和执行过程中的限制。
CMAKE_MAJOR_VERSION、CMAKE_MINOR_VERSION、CMAKE_PATCH_VERSION、CMAKE_SYSTEM、CAMKE_SYSTEM_NAME、UNIX、WIN32
2. 进程环境变量 # 进程业务处理过程中用到的环境变量，控制命令的选择，命令选项的选择和处理过程的选择。
CMAKE_INCLUDE_PATH、CMAKE_LIBRARY_PATH、LDFLAGS、CXXFLAGS、CFLAGS
3. 全局变量     # 进程中被各个模块共享，用来表示整体上的输入和输出
CMAKE_BINARY_DIR  PROJECT_BINARY_DIR  <projectname>_BINARY_DIR   CMAKE_CURRENT_BINARY_DIR
CMAKE_SOURCE_DIR  PROJECT_SOURCE_DIR  <projectname>_SOURCE_DIR   CMAKE_CURRENT_SOURCE_DIR
CMAKE_CURRENT_SOURCE_DIR    CMAKE_CURRRENT_BINARY_DIR
4. 静态全局变量 # 用于模块相关的各个属性；模块状态，模块名称、大小等等
5. 静态局部变量 # 用于状态函数相关的属性：接口数据处理状态记录或接口数据处理缓存
6. 局部变量     # 用于记录接口内系统函数和库函数状态记录、数据记录
SET(HELLO_SRC main.c)
CMAKE_CURRENT_LIST_FILE
CMAKE_CURRENT_LIST_LINE
--------------------------------------- 生成方式
1. 通过函数调用生成，特别是可以通过宏调用生成；
PROJECT(netifd C)  
2. 通过自己声明初始化生成。
SET(HELLO_SRC main.c)

------------------------------------------------------------------------------- 接口
PROJECT(netifd C)                                                      # 通过接口产生数据-隐形
ADD_DEFINITIONS(-Os -Wall -Werror --std=gnu99 -Wmissing-declarations)  # 通过接口修改数据-编译过程
SET(LIBS ubox ubus uci json-c blobmsg_json)                            # 通过接口产生数据-显性
ADD_EXECUTABLE(netifd ${SOURCES})                                      # 通过接口增加处理过程
TARGET_LINK_LIBRARIES(netifd ${LIBS})                                  # 通过接口修改数据-连接过程
1. 接口调用生成数据
PROJECT(netifd C) 
2. 接口调用定义过程
ADD_EXECUTABLE(netifd ${SOURCES}) 
3. 接口调用设置数据
TARGET_LINK_LIBRARIES(netifd ${LIBS})   
ADD_DEFINITIONS(-Os -Wall -Werror --std=gnu99 -Wmissing-declarations) 


}

tc_socket()
{

#define tc_socket_close(fd) close(fd)


int tc_pcap_socket_in_init(pcap_t **pd, char *device, 
        int snap_len, int buf_size, char *pcap_filter);

int tc_raw_socket_in_init(int type);

int tc_raw_socket_out_init(void);
int tc_raw_socket_snd(int fd, void *buf, size_t len, uint32_t ip);


int tc_pcap_snd_init(char *if_name, int mtu);
int tc_pcap_snd(unsigned char *frame, size_t len);
int tc_pcap_over(void);

int tc_socket_init(void);
int tc_socket_set_nonblocking(int fd);
int tc_socket_set_nodelay(int fd);
int tc_socket_connect(int fd, uint32_t ip, uint16_t port);
int tc_socket_rcv(int fd, char *buffer, ssize_t len);

int tc_socket_cmb_rcv(int fd, int *num, char *buffer);
int tc_socket_snd(int fd, char *buffer, int len);

}

sheepdog(rbtree){
[lock_entry] 侵入式
struct lock_entry {
    struct rb_node rb;
    int fd;
    uint64_t lock_id;
    uint64_t ref;
    struct sd_mutex *mutex;
};
struct rb_root lock_tree_root = RB_ROOT;
rb_insert(&lock_tree_root, lock_entry, rb, lock_cmp);  # 插入
rb_search(&lock_tree_root, lock_entry, rb, lock_cmp);  # 查找
rb_erase(&lock_entry->rb, &lock_tree_root);            # 删除

[sd_node]  侵入式
struct sd_node {
    struct rb_node  rb;
    struct node_id  nid;
    uint16_t	nr_vnodes;
    uint32_t	zone;
    uint64_t        space;
    #define SD_MAX_NODES 830
    #define SD_NODE_SIZE (80 + sizeof(struct disk_info) * DISK_MAX)
    struct disk_info disks[DISK_MAX];
};
struct rb_root sd_vroot = RB_ROOT;
rb_for_each_entry(n, nroot, rb) sd_node *n;  # 遍历
next = rb_entry(rb_next(&next->rb), struct sd_vnode, rb); # 下一个
next = rb_entry(rb_first(root), struct sd_vnode, rb);     # 下一个

[event_info]  侵入式
struct event_info {
    event_handler_t handler;
    int fd;
    void *data;
    struct rb_node rb;
    int prio;
};
rb_insert(&events_tree, ei, rb, event_cmp);     # 插入
rb_search(&events_tree, &key, rb, event_cmp);   # 查找
rb_erase(&ei->rb, &events_tree);                # 删除

[oid_entry]  侵入式
struct oid_entry {
    struct rb_node rb;
    struct sd_node *node; 
    uint64_t *oids;       
    int end;              
    int last;             
};
struct rb_root oid_tree = RB_ROOT;
rb_insert(&oid_tree, entry, rb, oid_entry_cmp);         # 插入
entry = rb_search(&oid_tree, &key, rb, oid_entry_cmp);  # 查找
rb_for_each_entry(entry, &oid_tree, rb)                 # 遍历
rb_destroy(&oid_tree, struct oid_entry, rb);            # 清除

INIT_RB_ROOT(struct rb_root *root) 初始化非静态声明的rb_root结构
rb_entry(ptr, type, member)        从rb_node指针到结构体指针
RB_EMPTY_ROOT(root)                只有root节点
rb_init_node(struct rb_node *rb)   初始化node节点
void rb_erase(struct rb_node *, struct rb_root *); 删除rb_node

# 用在for或者while循环中
struct rb_node *rb_next(const struct rb_node *);  # next
struct rb_node *rb_prev(const struct rb_node *);  # prev
struct rb_node *rb_first(const struct rb_root *); # first
struct rb_node *rb_last(const struct rb_root *);  # last

# Search for a value in the rbtree.  This returns NULL when the key is not found in the rbtree.
#define rb_search(root, key, member, compar)

# Insert a new node into the rbtree.  This returns NULL on success, or the existing node on error.
#define rb_insert(root, new, member, compar)

# Search for a value in the rbtree.  When the key is not found in the rbtree,this returns the next greater node. Note, 
#  if key > greatest node, we'll return first node.
#  For an empty tree, we return NULL.
#define rb_nsearch(root, key, member, compar) 

# Iterate over a rbtree safe against removal of rbnode 
#define rb_for_each(pos, root)

# Iterate over a rbtree of given type safe against removal of rbnode 
#define rb_for_each_entry(pos, root, member)

#  Destroy the tree and free the memory 
#define rb_destroy(root, type, member)

# Copy the tree 'root' as 'outroot'
#define rb_copy(root, type, member, outroot, compar)
}

sheepdog(eventloop){
int init_event(int nr); # 调用epoll_create()
int register_event_prio(int fd, event_handler_t h, void *data, int prio); # 调度优先级prio 注册
int register_event(int fd, event_handler_t h, void *data)                 # 普通优先级prio 注册
void unregister_event(int fd);                                            # 注销
int modify_event(int fd, unsigned int events);                            # 修改监听event
void event_loop(int timeout);                                             # 不支持优先级
void event_loop_prio(int timeout);                                        # 支持优先级
void event_force_refresh(void)                                            # 停止后续执行

typedef void (*event_handler_t)(int fd, int events, void *data);          # 回调函数
struct timer {                                                            # 回调函数
	void (*callback)(void *);
	void *data;
};

这里有signalfd，eventfd和 timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK); 的使用。
}

net(网络IO)
{
int set_snd_timeout(int fd):
int set_rcv_timeout(int fd):

static int do_write(int sockfd, struct msghdr *msg, int len,  bool (*need_retry)(uint32_t), uint32_t epoch, uint32_t max_count)
            
int do_read(int sockfd, void *buf, int len, bool (*need_retry)(uint32_t epoch), uint32_t epoch, uint32_t max_count) 
}

setsockopt()
{
    SO_BROADCAST允许发送广播数据int
　　SO_DEBUG允许调试int
　　SO_DONTROUTE不查找路由int
　　SO_ERROR获得套接字错误int
　　SO_KEEPALIVE保持连接int
　　SO_LINGER 延迟关闭连接struct linger
　　SO_OOBINLINE带外数据放入正常数据流int
　　SO_RCVBUF 接收缓冲区大小int
　　SO_SNDBUF 发送缓冲区大小int
　　SO_RCVLOWAT 接收缓冲区下限int
　　SO_SNDLOWAT 发送缓冲区下限int
　　SO_RCVTIMEO 接收超时struct timeval
　　SO_SNDTIMEO 发送超时struct timeval
　　SO_REUSERADDR 允许重用本地地址和端口int
　　SO_TYPE 获得套接字类型int
　　SO_BSDCOMPAT与BSD系统兼容 int

    如果你没有特殊的理由，我建议你不要自己设置 rcvbuf/sndbuf，因为 Linux 内核本来会自动调整 buffer 大小，
但是你设置之后就变成了固定大小

　　IP_HDRINCL在数据包中包含IP首部int
　　IP_OPTINOSIP首部选项int
　　IP_TOS服务类型
　　IP_TTL生存时间int

    TCP_MAXSEGTCP最大数据段的大小 int
　　TCP_NODELAY 不使用Nagle算法 int
}

openssl(){
         [client]                                            [server]
/*SSL初始化*/                                               /*SSL初始化*/
SSL_library_init();                                         SSL_library_init();
OpenSSL_add_all_algorithms();                               OpenSSL_add_all_algorithms();
SSL_load_error_strings();                                   SSL_load_error_strings();
ctx = SSL_CTX_new(SSLv3_client_method());                   ctx = SSL_CTX_new(SSLv3_client_method());
                                                            /*加载公钥证书*/
                                                            SSL_CTX_use_certificate_file(ctx, SERVER_CERT, SSL_FILETYPE_PEM)
                                                            /*设置私钥*/
                                                            SSL_CTX_use_PrivateKey_file(ctx, SERVER_KEY, SSL_FILETYPE_PEM)
                                                            /*验证私有和证书匹配*/
                                                            SSL_CTX_check_private_key(ctx)
                                                            
sockfd = socket(AF_INET, SOCK_STREAM, 0)                    sockfd = socket(PF_INET, SOCK_STREAM, 0))
                                                            setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse)
                                                            bind(sockfd, (struct sockaddr *) &my_addr, sizeof(struct sockaddr))
                                                            listen(sockfd, lisnum)
connect(sockfd, (struct sockaddr *) &dest, sizeof(dest))    accept(sockfd, (struct sockaddr *) &their_addr, &len)
                                                            
ssl = SSL_new(ctx);                                         ssl = SSL_new(ctx);
SSL_set_fd(ssl, sockfd);                                    SSL_set_fd(ssl, sockfd);
SSL_connect(ssl)                                            SSL_accept(ssl) 

len = SSL_read(ssl, buffer, MAXBUF);                        len = SSL_read(ssl, buffer, MAXBUF);
len = SSL_write(ssl, buffer, strlen(buffer));               len = SSL_write(ssl, buffer, strlen(buffer));

SSL_shutdown(ssl);                                          SSL_shutdown(ssl);
SSL_free(ssl);                                              SSL_free(ssl);
close(sockfd);                                              close(new_fd);
SSL_CTX_free(ctx);

1. openssl和moosefs的实现有相似的地方。
1.1 都被协议分层：在没有应用层协议的情况下，openssl被划分成tcp层和tls层。moosefs被划分成tcp层和协议层。
下层协议提供建立连接，连接中，重新建立连接，连接资源释放的API接口；
上层协议调用下层协议的读写API接口，实现上层协议的建立连接，连接中，重新建立连接，连接资源释放的API接口。
下层协议状态机由系统API通过返回值和errno值驱动，实现建立连接->连接中->[建立完成的过程]，建立完成之后，
上层协议状态机，通过系统read|write接口数据值驱动，实现建立连接->连接中->[建立完成的过程]，以达到协议内容级别的读写调用。

1.2 上下层之间接口正交
下层接口是正交的，
}
