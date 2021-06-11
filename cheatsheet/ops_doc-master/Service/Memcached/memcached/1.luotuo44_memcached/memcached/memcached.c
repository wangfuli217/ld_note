#include "memcached.h"
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <signal.h>
#include <sys/param.h>
#include <sys/resource.h>
#include <sys/uio.h>
#include <ctype.h>
#include <stdarg.h>

/* some POSIX systems need the following definition
 *  * to get mlockall flags out of sys/mman.h.  */
#ifndef _P1003_1B_VISIBLE
#define _P1003_1B_VISIBLE
#endif
/* need this to get IOV_MAX on some platforms. */
#ifndef __need_IOV_MAX
#define __need_IOV_MAX
#endif
#include <pwd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <limits.h>
#include <sysexits.h>
#include <stddef.h>

/* FreeBSD 4.x doesn't have IOV_MAX exposed. */
#ifndef IOV_MAX
#if defined(__FreeBSD__) || defined(__APPLE__)
# define IOV_MAX 1024
#endif
#endif

/* defaults */
static void settings_init(void);

struct slab_rebalance slab_rebal;
volatile int slab_rebalance_signal;

/** file scope variables **/
static conn *listen_conn = NULL;

static void settings_init(void) {  
    //开启CAS业务，如果开启了那么在item里面就会多一个用于CAS的字段。可以在启动memcached的时候通过-C选项禁用  
    settings.use_cas = true;  
      
    settings.access = 0700; //unix socket的权限位信息  
    settings.port = 11211;//memcached监听的tcp端口  
    settings.udpport = 11211;//memcached监听的udp端口  
    //memcached绑定的ip地址。如果该值为NULL，那么就是INADDR_ANY。否则该值指向一个ip字符串  
    settings.inter = NULL;  
      
    settings.maxbytes = 64 * 1024 * 1024; //memcached能够使用的最大内存  
    settings.maxconns = 1024; //最多允许多少个客户端同时在线。不同于settings.backlog  
     
    settings.verbose = 0;//运行信息的输出级别.该值越大输出的信息就越详细  
    settings.oldest_live = 0; //flush_all命令的时间界限。插入时间小于这个时间的item删除。  
    settings.evict_to_free = 1;  //标记memcached是否允许LRU淘汰机制。默认是可以的。可以通过-M选项禁止    
    settings.socketpath = NULL;//unix socket监听的socket路径.默认不使用unix socket   
    settings.factor = 1.25; //item的扩容因子  
    settings.chunk_size = 48; //最小的一个item能存储多少字节的数据(set、add命令中的数据)  
    settings.num_threads = 4; //worker线程的个数  
     //多少个worker线程为一个udp socket服务 number of worker threads serving each udp socket  
    settings.num_threads_per_udp = 0;  
      
    settings.prefix_delimiter = ':'; //分隔符  
    settings.detail_enabled = 0;//是否自动收集状态信息  
  
    //worker线程连续为某个客户端执行命令的最大命令数。这主要是为了防止一个客户端霸占整个worker线程  
    //，而该worker线程的其他客户端的命令无法得到处理  
    settings.reqs_per_event = 20;  
      
    settings.backlog = 1024;//listen函数的第二个参数，不同于settings.maxconns  
    //用户命令的协议，有文件和二进制两种。negotiating_prot是协商，自动根据命令内容判断  
    settings.binding_protocol = negotiating_prot;  
    settings.item_size_max = 1024 * 1024;//slab内存页的大小。单位是字节  
    settings.maxconns_fast = false;//如果连接数超过了最大同时在线数(由-c选项指定)，是否立即关闭新连接上的客户端。  
  
    //用于指明memcached是否启动了LRU爬虫线程。默认值为false，不启动LRU爬虫线程。  
    //可以在启动memcached时通过-o lru_crawler将变量的值赋值为true，启动LRU爬虫线程  
    settings.lru_crawler = false;  
    settings.lru_crawler_sleep = 100;//LRU爬虫线程工作时的休眠间隔。单位为微秒   
    settings.lru_crawler_tocrawl = 0; //LRU爬虫检查每条LRU队列中的多少个item,如果想让LRU爬虫工作必须修改这个值  
  
    //哈希表的长度是2^n。这个值就是n的初始值。可以在启动memcached的时候通过-o hashpower_init  
    //设置。设置的值要在[12, 64]之间。如果不设置，该值为0。哈希表的幂将取默认值16  
    settings.hashpower_init = 0;  /* Starting hash power level */  
  
    settings.slab_reassign = false;//是否开启调节不同类型item所占的内存数。可以通过 -o slab_reassign选项开启  
    settings.slab_automove = 0;//自动检测是否需要进行不同类型item的内存调整，依赖于settings.slab_reassign的开启  
  
    settings.shutdown_command = false;//是否支持客户端的关闭命令，该命令会关闭memcached进程  
  
    //用于修复item的引用数。如果一个worker线程引用了某个item，还没来得及解除引用这个线程就挂了  
    //那么这个item就永远被这个已死的线程所引用而不能释放。memcached用这个值来检测是否出现这种  
    //情况。因为这种情况很少发生，所以该变量的默认值为0(即不进行检测)。  
    //在启动memcached时，通过-o tail_repair_time xxx设置。设置的值要大于10(单位为秒)  
    //TAIL_REPAIR_TIME_DEFAULT 等于 0。  
    settings.tail_repair_time = TAIL_REPAIR_TIME_DEFAULT;   
    settings.flush_enabled = true;//是否运行客户端使用flush_all命令  
}//end  settings_init()

static int add_msghdr(conn *c)
{
    struct msghdr *msg;

    assert(c != NULL);

    if (c->msgsize == c->msgused) {//已经用完了 
        msg = realloc(c->msglist, c->msgsize * 2 * sizeof(struct msghdr));
        if (! msg) {
            STATS_LOCK();
            stats.malloc_fails++;
            STATS_UNLOCK();
            return -1;
        }
        c->msglist = msg;
        c->msgsize *= 2;
    }

    msg = c->msglist + c->msgused;//msg指向空闲的节点

    /* this wipes msg_iovlen, msg_control, msg_controllen, and
       msg_flags, the last 3 of which aren't defined on solaris: */
    memset(msg, 0, sizeof(struct msghdr));

    msg->msg_iov = &c->iov[c->iovused];//指向空闲的iovec

    if (IS_UDP(c->transport) && c->request_addr_size > 0) {
        msg->msg_name = &c->request_addr;
        msg->msg_namelen = c->request_addr_size;
    }

    c->msgbytes = 0;
    c->msgused++;

    if (IS_UDP(c->transport)) {
        /* Leave room for the UDP header, which we'll fill in later. */
        return add_iov(c, NULL, UDP_HEADER_SIZE);
    }

    return 0;
}


//在《命令行参数详解》中有提到，
//可以在启动memcached的时候通过命令行参数-c num指定memcached允许的最大同时在线客户端数量。
//即使没有使用该参数，memcached也会采用默认值的，具体的默认值可以参数《关键配置的默认值》。
//也就是说在启动memcached之后就可以确定最多允许多少个客户端同时在线。
//有了这个数值就不用一有新连接就malloc一个conn结构体(这样会很容易造成内存碎片)。
//有了这个数值那么可以在一开始(conn_init函数)，就申请动态申请一个数组。有新连接就从这个数组中分配一个元素即可
/*
 * Initializes the connections array. We don't actually allocate connection
 * structures until they're needed, so as to avoid wasting memory when the
 * maximum connection count is much higher than the actual number of
 * connections.
 *
 * This does end up wasting a few pointers' worth of memory for FDs that are
 * used for things other than connections, but that's worth it in exchange for
 * being able to directly index the conns array by FD.
 */
static void conn_init(void) {
    /* We're unlikely to see an FD much higher than maxconns. */
    //已经dup返回当前未使用的最小正整数，所以next_fd等于此刻已经消耗了的fd个数  
    int next_fd = dup(1);//获取当前已经使用的fd的个数
    //预留一些文件描述符。也就是多申请一些conn结构体。以免有别的需要把文件描述符  
    //给占了。导致socket fd的值大于这个数组长度
    int headroom = 10; //预留一些文件描述符 /* account for extra unexpected open FDs */
    struct rlimit rl;

    //settings.maxconns的默认值是1024.  
    max_fds = settings.maxconns + headroom + next_fd;

    /* But if possible, get the actual highest FD we can possibly ever see. */
    if (getrlimit(RLIMIT_NOFILE, &rl) == 0) {
        max_fds = rl.rlim_max;
    } else {
        fprintf(stderr, "Failed to query maximum file descriptor; "
                        "falling back to maxconns\n");
    }

    close(next_fd);//next_fd只是用来计数的，并没有其他用途

    //注意，申请的conn结构体数量是比settings.maxconns这个客户端同时在线数  
    //还要大的。因为memcached是直接用socket fd的值作为数组下标的。也正是  
    //这个原因，前面需要使用headroom预留一些空间给突发情况 
    if ((conns = calloc(max_fds, sizeof(conn *))) == NULL) {
        fprintf(stderr, "Failed to allocate connection structures\n");
        /* This is unrecoverable so bail out early. */
        exit(1);
    }
}//end conn_init()



//连接管理者conn：
//现在我们来关注一下conn_new函数。
//因为在这里函数里面会创建一个用于监听socket fd的event，并调用event_add加入到主线程的event_base中。
//从conn_new的函数名来看，是new一个conn。确实如何。
//事实上memcached为每一个socket fd(也就是一个连接)都创建一个conn结构体，
//用于管理这个socket fd(连接)。因为一个连接会有很多数据和状态信息，所以需要一个结构体来负责管理。
//所以阅读conn_new函数之前，还需要先阅读一下conn_init函数，了解conn结构体的一些初试化。

//conn_init()中，calloc申请的是conn*指针数组而不是conn结构体数组。
//主要是因为conn结构体是比较大的一个结构体(成员变量很多)。
//不一定会存在settings.maxconns个同时在线的客户端。所以可以等到需要conn结构体的时候再去动态申请。
//需要时去动态申请，这样会有内存碎片啊！非也！！因为可以循环使用的。
//如果没有这个conn*指针数组，那么当这个连接断开后就要free这个conn结构体所占的内存(不然就内存泄漏了)。
//有了这个数组那么就可以不free，由数组管理这个内存。下面的conn_new函数展示了这一点。

//为sfd分配一个conn结构体，并且为这个sfd建立一个event，然后让base监听这个event  
conn *conn_new(const int sfd, enum conn_states init_state,
                const int event_flags,
                const int read_buffer_size, enum network_transport transport,
                struct event_base *base) {
    conn *c;

    assert(sfd >= 0 && sfd < max_fds);
    c = conns[sfd];//直接使用下

    if (NULL == c) {//之前没有哪个连接用过这个sfd值，需要申请一个conn结构体
        if (!(c = (conn *)calloc(1, sizeof(conn)))) {
            STATS_LOCK();
            stats.malloc_fails++;
            STATS_UNLOCK();
            fprintf(stderr, "Failed to allocate connection object\n");
            return NULL;
        }
        MEMCACHED_CONN_CREATE(c);

        c->rbuf = c->wbuf = 0;
        c->ilist = 0;
        c->suffixlist = 0;
        c->iov = 0;
        c->msglist = 0;
        c->hdrbuf = 0;

        c->rsize = read_buffer_size;
        c->wsize = DATA_BUFFER_SIZE;
        c->isize = ITEM_LIST_INITIAL;
        c->suffixsize = SUFFIX_LIST_INITIAL;
        c->iovsize = IOV_LIST_INITIAL;
        c->msgsize = MSG_LIST_INITIAL;
        c->hdrsize = 0;

        c->rbuf = (char *)malloc((size_t)c->rsize);
        c->wbuf = (char *)malloc((size_t)c->wsize);
        c->ilist = (item **)malloc(sizeof(item *) * c->isize);
        c->suffixlist = (char **)malloc(sizeof(char *) * c->suffixsize);
        c->iov = (struct iovec *)malloc(sizeof(struct iovec) * c->iovsize);
        c->msglist = (struct msghdr *)malloc(sizeof(struct msghdr) * c->msgsize);

        if (c->rbuf == 0 || c->wbuf == 0 || c->ilist == 0 || c->iov == 0 ||
                c->msglist == 0 || c->suffixlist == 0) {
            conn_free(c);
            STATS_LOCK();
            stats.malloc_fails++;
            STATS_UNLOCK();
            fprintf(stderr, "Failed to allocate buffers for connection\n");
            return NULL;
        }

        STATS_LOCK();
        stats.conn_structs++;
        STATS_UNLOCK();

        c->sfd = sfd;
        conns[sfd] = c;////将这个结构体交由conns数组管理
    }

    c->transport = transport;
    c->protocol = settings.binding_protocol;

    /* unix socket mode doesn't need this, so zeroed out.  but why
     * is this done for every command?  presumably for UDP
     * mode.  */
    if (!settings.socketpath) {
        c->request_addr_size = sizeof(c->request_addr);
    } else {
        c->request_addr_size = 0;
    }

    if (transport == tcp_transport && init_state == conn_new_cmd) {
        if (getpeername(sfd, (struct sockaddr *) &c->request_addr,
                        &c->request_addr_size)) {
            perror("getpeername");
            memset(&c->request_addr, 0, sizeof(c->request_addr));
        }
    }

    if (settings.verbose > 1) {
        if (init_state == conn_listening) {
            fprintf(stderr, "<%d server listening (%s)\n", sfd,
                prot_text(c->protocol));
        } else if (IS_UDP(transport)) {
            fprintf(stderr, "<%d server listening (udp)\n", sfd);
        } else if (c->protocol == negotiating_prot) {
            fprintf(stderr, "<%d new auto-negotiating client connection\n",
                    sfd);
        } else if (c->protocol == ascii_prot) {
            fprintf(stderr, "<%d new ascii client connection.\n", sfd);
        } else if (c->protocol == binary_prot) {
            fprintf(stderr, "<%d new binary client connection.\n", sfd);
        } else {
            fprintf(stderr, "<%d new unknown (%d) client connection\n",
                sfd, c->protocol);
            assert(false);
        }
    }

	//初始化另外一些成员变量
    c->state = init_state;//值为conn_listening
    c->rlbytes = 0;
    c->cmd = -1;
    c->rbytes = c->wbytes = 0;
    c->wcurr = c->wbuf;
    c->rcurr = c->rbuf;
    c->ritem = 0;
    c->icurr = c->ilist;
    c->suffixcurr = c->suffixlist;
    c->ileft = 0;
    c->suffixleft = 0;
    c->iovused = 0;
    c->msgcurr = 0;
    c->msgused = 0;
    c->authenticated = false;

    c->write_and_go = init_state;
    c->write_and_free = 0;
    c->item = 0;

    c->noreply = false;
	//主线程的基础实施也已经搭好了。
	//注意，主线程对于socket fd 可读事件的回调函数是event_handler，回调参数是conn这个结构体指针。
    //等同于event_assign，会自动关联current_base。event的回调函数是event_handler  
    event_set(&c->event, sfd, event_flags, event_handler, (void *)c);
    event_base_set(base, &c->event);
    c->ev_flags = event_flags;

    if (event_add(&c->event, 0) == -1) {
        perror("event_add");
        return NULL;
    }

    STATS_LOCK();
    stats.curr_conns++;
    stats.total_conns++;
    STATS_UNLOCK();

    MEMCACHED_CONN_ALLOCATE(c->sfd);

    return c;
}//end conn_new()

static void conn_release_items(conn *c) {
    assert(c != NULL);

    if (c->item) {
        item_remove(c->item);
        c->item = 0;
    }

    while (c->ileft > 0) {
        item *it = *(c->icurr);
        assert((it->it_flags & ITEM_SLABBED) == 0);
        item_remove(it);
        c->icurr++;
        c->ileft--;
    }

    if (c->suffixleft != 0) {
        for (; c->suffixleft > 0; c->suffixleft--, c->suffixcurr++) {
            cache_free(c->thread->suffix_cache, *(c->suffixcurr));
        }
    }

    c->icurr = c->ilist;
    c->suffixcurr = c->suffixlist;
}//end conn_release_items()

static void conn_close(conn *c) {
    assert(c != NULL);

    /* delete the event, the socket and the conn */
    event_del(&c->event);

    if (settings.verbose > 1)
        fprintf(stderr, "<%d connection closed.\n", c->sfd);

    conn_cleanup(c);

    MEMCACHED_CONN_RELEASE(c->sfd);
    conn_set_state(c, conn_closed);
    close(c->sfd);

    pthread_mutex_lock(&conn_lock);
    allow_new_conns = true;
    pthread_mutex_unlock(&conn_lock);

    STATS_LOCK();
    stats.curr_conns--;
    STATS_UNLOCK();

    return;
}//end conn_close()


//收缩到初始大小  
static void conn_shrink(conn *c) {  
    assert(c != NULL);  
  
    if (IS_UDP(c->transport))  
        return;  
  
    //c->rbytes指明了当前读缓冲区有效数据的长度。当其小于DATA_BUFFER_SIZE  
    //才进行读缓冲区收缩，所以不会导致客户端命令数据的丢失。  
    if (c->rsize > READ_BUFFER_HIGHWAT && c->rbytes < DATA_BUFFER_SIZE) {  
        char *newbuf;  
  
        if (c->rcurr != c->rbuf)  
            memmove(c->rbuf, c->rcurr, (size_t)c->rbytes);  
  
        newbuf = (char *)realloc((void *)c->rbuf, DATA_BUFFER_SIZE);  
  
        if (newbuf) {  
            c->rbuf = newbuf;  
            c->rsize = DATA_BUFFER_SIZE;  
        }  
        /* TODO check other branch... */  
        c->rcurr = c->rbuf;  
    }  
  
    if (c->isize > ITEM_LIST_HIGHWAT) {  
        item **newbuf = (item**) realloc((void *)c->ilist, ITEM_LIST_INITIAL * sizeof(c->ilist[0]));  
        if (newbuf) {  
            c->ilist = newbuf;  
            c->isize = ITEM_LIST_INITIAL;  
        }  
    /* TODO check error condition? */  
    }  
  
    if (c->msgsize > MSG_LIST_HIGHWAT) {  
        struct msghdr *newbuf = (struct msghdr *) realloc((void *)c->msglist, MSG_LIST_INITIAL * sizeof(c->msglist[0]));  
        if (newbuf) {  
            c->msglist = newbuf;  
            c->msgsize = MSG_LIST_INITIAL;  
        }  
    /* TODO check error condition? */  
    }  
  
    if (c->iovsize > IOV_LIST_HIGHWAT) {  
        struct iovec *newbuf = (struct iovec *) realloc((void *)c->iov, IOV_LIST_INITIAL * sizeof(c->iov[0]));  
        if (newbuf) {  
            c->iov = newbuf;  
            c->iovsize = IOV_LIST_INITIAL;  
        }  
    /* TODO check return value */  
    }  
}  


/*
 * Sets a connection's current state in the state machine. Any special
 * processing that needs to happen on certain state transitions can
 * happen here.
 */
static void conn_set_state(conn *c, enum conn_states state) {
    assert(c != NULL);
    assert(state >= conn_listening && state < conn_max_state);

    if (state != c->state) {
        if (settings.verbose > 2) {
            fprintf(stderr, "%d: going from %s to %s\n",
                    c->sfd, state_text(c->state),
                    state_text(state));
        }

        if (state == conn_write || state == conn_mwrite) {
            MEMCACHED_PROCESS_COMMAND_END(c->sfd, c->wbuf, c->wbytes);
        }
        c->state = state;
    }
}//end conn_set_state()

/*
 * Ensures that there is room for another struct iovec in a connection's
 * iov list.
 *
 * Returns 0 on success, -1 on out-of-memory.
 */
static int ensure_iov_space(conn *c) {
    assert(c != NULL);

    //已经使用完了之前申请的  
    if (c->iovused >= c->iovsize) {
        int i, iovnum;
        struct iovec *new_iov = (struct iovec *)realloc(c->iov,
                                (c->iovsize * 2) * sizeof(struct iovec));
        if (! new_iov) {
            STATS_LOCK();
            stats.malloc_fails++;
            STATS_UNLOCK();
            return -1;
        }
        c->iov = new_iov;
        c->iovsize *= 2;

        /* Point all the msghdr structures at the new list. */
        //因为iovec数组已经重新分配在别的空间了，而msglist数组元素指向这个iovec  
        //数组，所以需要修改msglist数组元素的值
        for (i = 0, iovnum = 0; i < c->msgused; i++) {
            c->msglist[i].msg_iov = &c->iov[iovnum];
            iovnum += c->msglist[i].msg_iovlen;
        }
    }

    return 0;
}//end ensure_iov_space()



/*
 * Adds data to the list of pending data that will be written out to a
 * connection.
 *
 * Returns 0 on success, -1 on out-of-memory.
 */
//memcached使用iovec结构体的成员变量指向item的数据，实际上除了item数据，
//所有回应客户端的数据(包括错误信息)都是通过iovec结构体指向的。memcached通过add_iov函数把要回应的字符串加入到iovec中。
static int add_iov(conn *c, const void *buf, int len) {
    struct msghdr *m;
    int leftover;
    bool limit_to_mtu;

    assert(c != NULL);

    //在process_command函数中，一开始会调用add_msghdr函数，而add_msghdr会把  
    //msgused++，所以msgused会等于1,即使在conn_new函数中它被赋值为0  
    do {
        m = &c->msglist[c->msgused - 1];

        /*
         * Limit UDP packets, and the first payloads of TCP replies, to
         * UDP_MAX_PAYLOAD_SIZE bytes.
         */
        limit_to_mtu = IS_UDP(c->transport) || (1 == c->msgused);

        /* We may need to start a new msghdr if this one is full. */
        if (m->msg_iovlen == IOV_MAX || //一个msghdr最多只能有IOV_MAX个iovec结构体
            (limit_to_mtu && c->msgbytes >= UDP_MAX_PAYLOAD_SIZE)) {
            add_msghdr(c);
            m = &c->msglist[c->msgused - 1];
        }

        //保证iovec数组是足够用的。调用add_iov函数一次会消耗一个iovec结构体  
        //所以可以在插入数据之前保证iovec数组是足够用的  
        if (ensure_iov_space(c) != 0)
            return -1;

        /* If the fragment is too big to fit in the datagram, split it up */
        if (limit_to_mtu && len + c->msgbytes > UDP_MAX_PAYLOAD_SIZE) {
            leftover = len + c->msgbytes - UDP_MAX_PAYLOAD_SIZE;
            len -= leftover;
        } else {
            leftover = 0;
        }

        //用一个iovec结构体指向要回应的数据  
        m = &c->msglist[c->msgused - 1];
        m->msg_iov[m->msg_iovlen].iov_base = (void *)buf;
        m->msg_iov[m->msg_iovlen].iov_len = len;

        c->msgbytes += len;
        c->iovused++;
        m->msg_iovlen++;

        buf = ((char *)buf) + len;
        len = leftover;
    } while (leftover > 0);

    return 0;
}//end add_iov()


//回应命令：
//在complete_nread_ascii函数中，无论是存储成功还是失败都会调用out_string函数回应客户端。
static void out_string(conn *c, const char *str) {  
    size_t len;  
  
    assert(c != NULL);  
  
    if (c->noreply) {//不需要回复信息给客户端  
        if (settings.verbose > 1)  
            fprintf(stderr, ">%d NOREPLY %s\n", c->sfd, str);  
        c->noreply = false; //重置  
        conn_set_state(c, conn_new_cmd);  
        return;  
    }  
  
  
    /* Nuke a partial output... */  
    c->msgcurr = 0;  
    c->msgused = 0;  
    c->iovused = 0;  
    add_msghdr(c);  
  
    len = strlen(str);  
    if ((len + 2) > c->wsize) {///2是后面的\r\n  
        /* ought to be always enough. just fail for simplicity */  
        str = "SERVER_ERROR output line too long";  
        len = strlen(str);  
    }  
  
    memcpy(c->wbuf, str, len);  
    memcpy(c->wbuf + len, "\r\n", 2);  
    c->wbytes = len + 2;  
    c->wcurr = c->wbuf;  
  
    conn_set_state(c, conn_write);//写状态  
    c->write_and_go = conn_new_cmd;//写完后的下一个状态  
    return;  
}  


static void complete_nread_ascii(conn *c) {
    assert(c != NULL);

    //此时这个item不在LRU队列，也不在哈希表中  
    //并且引用数等于1(就是本worker线程在引用它)  
    item *it = c->item;
    int comm = c->cmd;
    enum store_item_type ret;

    //保证最后的两个字符是"\r\n"，否则就是错误数据  
    pthread_mutex_lock(&c->thread->stats.mutex);
    c->thread->stats.slab_stats[it->slabs_clsid].set_cmds++;
    pthread_mutex_unlock(&c->thread->stats.mutex);

    if (strncmp(ITEM_data(it) + it->nbytes - 2, "\r\n", 2) != 0) {
        out_string(c, "CLIENT_ERROR bad data chunk");
    } else {
      ret = store_item(it, comm, c);//将这个item存放到LRU对和哈希表中

#ifdef ENABLE_DTRACE
      uint64_t cas = ITEM_get_cas(it);
      switch (c->cmd) {
      case NREAD_ADD:
          MEMCACHED_COMMAND_ADD(c->sfd, ITEM_key(it), it->nkey,
                                (ret == 1) ? it->nbytes : -1, cas);
          break;
      case NREAD_REPLACE:
          MEMCACHED_COMMAND_REPLACE(c->sfd, ITEM_key(it), it->nkey,
                                    (ret == 1) ? it->nbytes : -1, cas);
          break;
      case NREAD_APPEND:
          MEMCACHED_COMMAND_APPEND(c->sfd, ITEM_key(it), it->nkey,
                                   (ret == 1) ? it->nbytes : -1, cas);
          break;
      case NREAD_PREPEND:
          MEMCACHED_COMMAND_PREPEND(c->sfd, ITEM_key(it), it->nkey,
                                    (ret == 1) ? it->nbytes : -1, cas);
          break;
      case NREAD_SET:
          MEMCACHED_COMMAND_SET(c->sfd, ITEM_key(it), it->nkey,
                                (ret == 1) ? it->nbytes : -1, cas);
          break;
      case NREAD_CAS:
          MEMCACHED_COMMAND_CAS(c->sfd, ITEM_key(it), it->nkey, it->nbytes,
                                cas);
          break;
      }
#endif

      switch (ret) {
      case STORED:
          out_string(c, "STORED");
          break;
      case EXISTS:
          out_string(c, "EXISTS");
          break;
      case NOT_FOUND:
          out_string(c, "NOT_FOUND");
          break;
      case NOT_STORED:
          out_string(c, "NOT_STORED");
          break;
      default:
          out_string(c, "SERVER_ERROR Unhandled storage type.");
      }

    }

    item_remove(c->item);       /* release the c->item reference */
    c->item = 0;
}//end complete_nread_ascii()


//存储item：
//填充数据还是比较简单的。
//填充数据后这个item就是完整的了，此时需要把item插入到LRU队列和哈希表中。
//Memcached是调用complete_nread函数完成这操作。
//complete_nread内部会间接调用函数do_store_item，
//后者会先调用do_item_get函数查询当前memcached服务器是否已经存在相同键值的item，然后根据不同的命令(add、replace、set)进行不同的处理。
static void complete_nread(conn *c) {  
    assert(c != NULL);  
    assert(c->protocol == ascii_prot  
			           || c->protocol == binary_prot);  
  
    if (c->protocol == ascii_prot) {//文本协议  
	        complete_nread_ascii(c);  //看这个
	    } else if (c->protocol == binary_prot) {//二进制协议  
		        complete_nread_binary(c);  
		    }  
}  


static void reset_cmd_handler(conn *c) {
    c->cmd = -1;
    c->substate = bin_no_state;
    if(c->item != NULL) {//conn_new_cmd状态下，item为NULL
        item_remove(c->item);
        c->item = NULL;
    }
	//当然我们假设nreqs大于0，然后看一下reset_cmd_handler函数。
	//该函数会判断conn的读缓冲区是否还有数据。此外，该函数还有一个重要的作用：调节conn缓冲区的大小。
	//前一篇博文已经说到，memcached会尽可能把客户端socket里面的数据读入conn的读缓冲区，这种特性会撑大conn的读缓冲区。
	//除了读缓冲区，用于回写数据的iovec和msghdr数组也会被撑大，这也要收缩。
	//因为是在处理完一条命令后才进行的收缩，所以收缩不会导致数据的丢失。

	//收缩到初始大小 
	conn_shrink(c);
	//为了简单，这里假设没有数据  
	if (c->rbytes > 0) {//读缓冲区里面有数据   
		conn_set_state(c, conn_parse_cmd);//解析读到的数据  
	} else {   
		conn_set_state(c, conn_waiting);//否则等待数据的到来  
	}  
}

//主调函数store_item会加item_lock(hv)锁  
//set、add、replace命令最终都会调用本函数进行存储的  
//comm参数保存了具体是哪个命令  
enum store_item_type do_store_item(item *it, int comm, conn *c, const uint32_t hv) {  
    char *key = ITEM_key(it);  
    item *old_it = do_item_get(key, it->nkey, hv);//查询旧值  
    enum store_item_type stored = NOT_STORED;  
  
    item *new_it = NULL;  
    int flags;  
  
    if (old_it != NULL && comm == NREAD_ADD) {  
        /* add only adds a nonexistent item, but promote to head of LRU */  
        //因为已经有相同键值的旧item了，所以add命令使用失败。但  
        //还是会刷新旧item的访问时间以及LRU队列中的位置  
        do_item_update(old_it);  
    } else if (!old_it && (comm == NREAD_REPLACE  
        || comm == NREAD_APPEND || comm == NREAD_PREPEND))  
    {  
        /* replace only replaces an existing value; don't store */  
    } else if (comm == NREAD_CAS) {  
        /* validate cas operation */  
        if(old_it == NULL) {  
            // LRU expired  
            stored = NOT_FOUND;  
            pthread_mutex_lock(&c->thread->stats.mutex);  
            c->thread->stats.cas_misses++;  
            pthread_mutex_unlock(&c->thread->stats.mutex);  
        }  
        else if (ITEM_get_cas(it) == ITEM_get_cas(old_it)) {  
            // cas validates  
            // it and old_it may belong to different classes.  
            // I'm updating the stats for the one that's getting pushed out  
            pthread_mutex_lock(&c->thread->stats.mutex);  
            c->thread->stats.slab_stats[old_it->slabs_clsid].cas_hits++;  
            pthread_mutex_unlock(&c->thread->stats.mutex);  
  
            item_replace(old_it, it, hv);  
            stored = STORED;  
        } else {  
            pthread_mutex_lock(&c->thread->stats.mutex);  
            c->thread->stats.slab_stats[old_it->slabs_clsid].cas_badval++;  
            pthread_mutex_unlock(&c->thread->stats.mutex);  
  
            if(settings.verbose > 1) {  
                fprintf(stderr, "CAS:  failure: expected %llu, got %llu\n",  
                        (unsigned long long)ITEM_get_cas(old_it),  
                        (unsigned long long)ITEM_get_cas(it));  
            }  
            stored = EXISTS;  
        }  
    } else {  
        /* 
         * Append - combine new and old record into single one. Here it's 
         * atomic and thread-safe. 
         */  
        if (comm == NREAD_APPEND || comm == NREAD_PREPEND) {  
            /* 
             * Validate CAS 
             */  
            if (ITEM_get_cas(it) != 0) {  
                // CAS much be equal  
                if (ITEM_get_cas(it) != ITEM_get_cas(old_it)) {  
                    stored = EXISTS;  
                }  
            }  
  
            if (stored == NOT_STORED) {  
                /* we have it and old_it here - alloc memory to hold both */  
                /* flags was already lost - so recover them from ITEM_suffix(it) */  
  
                flags = (int) strtol(ITEM_suffix(old_it), (char **) NULL, 10);  
  
                //因为是追加数据，先前分配的item可能不够大，所以要重新申请item  
                new_it = do_item_alloc(key, it->nkey, flags, old_it->exptime, it->nbytes + old_it->nbytes - 2 /* CRLF */, hv);  
  
                if (new_it == NULL) {  
                    /* SERVER_ERROR out of memory */  
                    if (old_it != NULL)  
                        do_item_remove(old_it);  
  
                    return NOT_STORED;  
                }  
  
                /* copy data from it and old_it to new_it */  
  
                if (comm == NREAD_APPEND) {  
                    memcpy(ITEM_data(new_it), ITEM_data(old_it), old_it->nbytes);  
                    memcpy(ITEM_data(new_it) + old_it->nbytes - 2 /* CRLF */, ITEM_data(it), it->nbytes);  
                } else {  
                    /* NREAD_PREPEND */  
                    memcpy(ITEM_data(new_it), ITEM_data(it), it->nbytes);  
                    memcpy(ITEM_data(new_it) + it->nbytes - 2 /* CRLF */, ITEM_data(old_it), old_it->nbytes);  
                }  
  
                it = new_it;  
            }  
        }  
  
        //add、set、replace命令还没处理,但之前已经处理了不合理的情况  
        //即add命令已经确保了目前哈希表还没存储对应键值的item，replace命令  
        //已经保证哈希表已经存储了对应键值的item  
        if (stored == NOT_STORED) {  
            if (old_it != NULL)//replace和set命令会进入这里  
                item_replace(old_it, it, hv);//删除旧item，插入新item  
            else//add和set命令会进入这里       
				//对于一个没有存在的key，使用set命令会来到这里  
                do_item_link(it, hv);//插入hashtable和LRU
  
            c->cas = ITEM_get_cas(it);  
  
            stored = STORED;  
        }  
    }  
  
    if (old_it != NULL)  
        do_item_remove(old_it);         /* release our reference */  
    if (new_it != NULL)  
        do_item_remove(new_it);  
  
    if (stored == STORED) {  
        c->cas = ITEM_get_cas(it);  
    }  
  
    return stored;  
}// end do_store_item()  

typedef struct token_s {
	char *value;
	size_t length;
} token_t;

#define COMMAND_TOKEN 0
#define SUBCOMMAND_TOKEN 1
#define KEY_TOKEN 1

#define MAX_TOKENS 8

//符号化命令内容：
//为了能执行命令，必须能识别出客户端发送的具体是什么命令以及有什么参数。
//为了做到这一步，就得先命令字符串(try_read_command函数中已经把命令数据当作一个C语言的字符串了)里面的每一个词分割出来。
//比如将字符串"set tt 3 0 10"分割为”set”、”tt”、”3”、”0”和”10”这个5个词，在memcached里面用一个专门的名称token表示这些词。
//Memcached在判别具体的命令前，要做的一步就是将命令内容进行符号化。
//在process_command函数中，memcached会调用tokenize_command函数把命令字符串符号化。
//process_command函数还定义了一个局部数组tokens用于指明命令字符串里面每一个token。下面是tokenize_command函数的具体实现。

//将一条命令分割成一个个的token，并用tokens数组一一对应的指向  
//比如命令"set tt 3 0 10"，将被分割成"set"、"tt"、"3"、"0"、"10"  
//并用tokens数组的5个元素对应指向。token_t类型的value成员指向对应token  
//在command里面的位置，length则指明该token的长度  
//返回token的数目，最后一个token是无意义的  

//经过命令符号化后，使用起来就会很简单的了。
//比如根据tokens[0]的内容可以判断这个命令是什么命令，如果是set命令(tokens[0]的内容等于”set”)，自然tokens[1]就是键值了。
//接下来的tokens[2]、tokens[3]、tokens[4]就是键值的三个参数了。
static size_t tokenize_command(char *command, token_t *tokens, const size_t max_tokens) {  
    char *s, *e;  
    size_t ntokens = 0;  
    size_t len = strlen(command);  
    unsigned int i = 0;  
  
    assert(command != NULL && tokens != NULL && max_tokens > 1);  
  
    s = e = command;  
    for (i = 0; i < len; i++) {  
        if (*e == ' ') {//如果有连续多个空格符，那么需要跳过  
            if (s != e) {//s此时指向非空格符,并且是某个token的第一个字符  
                tokens[ntokens].value = s;//指向token的开始位置  
                tokens[ntokens].length = e - s;//这个token的长度  
                ntokens++;  
                *e = '\0';//赋值为'\0'，这样这个token就是s开始的一个字符串  
                if (ntokens == max_tokens - 1) {  
                    //这条命令至少有max_tokens-2个token  
                    e++;  
                    s = e; /* so we don't add an extra token */  
                    break;  
                }  
            }  
            s = e + 1;//最后s会指向第一个非空格符  
        }  
        e++;  
    }  
  
    //当这条命令是以空格符结尾的，那么上面那个循环结束后，s等于e。  
    //否则s 不等于 e。此时s指向最后一个token的开始位置，e则指向token  
    //最后一个字符的下一个字符(the first element past the end)  
    if (s != e) {//处理最后一个token  
        tokens[ntokens].value = s;  
        tokens[ntokens].length = e - s;  
        ntokens++;  
    }  
  
    /* 
     * If we scanned the whole string, the terminal value pointer is null, 
     * otherwise it is the first unprocessed character. 
     */  
    //最多只处理max_tokens-1(等于7)个token，剩下的不处理  
    tokens[ntokens].value =  *e == '\0' ? NULL : e;  
    tokens[ntokens].length = 0;  
    ntokens++;  
  
    return ntokens;  
}  

//执行命令：
//回应信息的存储：
//process_get_command函数在处理get命令时，并不是直接拷贝一份item的数据(考虑一下效率和内存)，
//所以memcached是直接使用item本身的数据，用iovec结构体的成员变量指向item里面的数据。
//这样能省去拷贝数据内存，也能提高效率。但memcached里面的item可能随时被删除(归还给slab内存分配器)，
//可以通过占用这个item，防止item被删除。
//在《item引用计数》中说到，只要增加item的引用计数就能防止这个item被删除。
//于是在process_get_command函数中会占有item，并用一个item指针数组记录其占用了哪些item(这个数组在conn结构体中)。
//当memcached将item的数据返回给客户端后，就会释放对item的占用。
//        前面说到memcached使用iovec结构体的成员变量指向item的数据，但memcached并不是使用writev函数向客户端写数据的，而是使用sendmsg函数。
//sendmsg函数使用msghdr结构体指针作为参数。
//因为sendmsg函数中msghdr结构体中的iovec数组长度是有限制的，所以conn结构体中有一个msghdr数组。
//数组中每一个msghdr结构体带有IOV_MAX个iovec结构体。通过动态申请msghdr数组，可以使得有很多个iovec结构体,不再受IOV_MAX的限制。
//当然前面说到的iovec结构体个数也是要有足够多，所以conn结构体里面还是有一个iovec指针用来动态申请iovec结构体。
//现在来看一下conn结构体对应的成员。

/* ntokens is overwritten here... shrug.. */
static inline void process_get_command(conn *c, token_t *tokens, size_t ntokens, bool return_cas) {
	char *key;
	size_t nkey;
	int i = 0;
	item *it;
	token_t *key_token = &tokens[KEY_TOKEN];
	char *suffix;
	assert(c != NULL);

	do {
		//因为一个get命令可以同时获取多条记录的内容  
		//比如get key1 key2 key3 
		while(key_token->length != 0) {

			key = key_token->value;
			nkey = key_token->length;

			if(nkey > KEY_MAX_LENGTH) {
				out_string(c, "CLIENT_ERROR bad command line format");
				while (i-- > 0) {
					item_remove(*(c->ilist + i));
				}
				return;
			}

			it = item_get(key, nkey);
			if (settings.detail_enabled) {
				stats_prefix_record_get(key, nkey, NULL != it);
			}
			if (it) {
				if (i >= c->isize) {
					item **new_list = realloc(c->ilist, sizeof(item *) * c->isize * 2);
					if (new_list) {
						c->isize *= 2;
						c->ilist = new_list;
					} else {
						STATS_LOCK();
						stats.malloc_fails++;
						STATS_UNLOCK();
						item_remove(it);
						break;
					}
				}

				/*
				 * Construct the response. Each hit adds three elements to the
				 * outgoing data list:
				 *   "VALUE "
				 *   key
				 *   " " + flags + " " + data length + "\r\n" + data (with \r\n)
				 */

				if (return_cas)
				{
					MEMCACHED_COMMAND_GET(c->sfd, ITEM_key(it), it->nkey,
							it->nbytes, ITEM_get_cas(it));
					/* Goofy mid-flight realloc. */
					if (i >= c->suffixsize) {
						char **new_suffix_list = realloc(c->suffixlist,
								sizeof(char *) * c->suffixsize * 2);
						if (new_suffix_list) {
							c->suffixsize *= 2;
							c->suffixlist  = new_suffix_list;
						} else {
							STATS_LOCK();
							stats.malloc_fails++;
							STATS_UNLOCK();
							item_remove(it);
							break;
						}
					}

					suffix = cache_alloc(c->thread->suffix_cache);
					if (suffix == NULL) {
						STATS_LOCK();
						stats.malloc_fails++;
						STATS_UNLOCK();
						out_of_memory(c, "SERVER_ERROR out of memory making CAS suffix");
						item_remove(it);
						while (i-- > 0) {
							item_remove(*(c->ilist + i));
						}
						return;
					}
					*(c->suffixlist + i) = suffix;
					int suffix_len = snprintf(suffix, SUFFIX_SIZE,
							" %llu\r\n",
							(unsigned long long)ITEM_get_cas(it));
					if (add_iov(c, "VALUE ", 6) != 0 ||
							add_iov(c, ITEM_key(it), it->nkey) != 0 ||
							add_iov(c, ITEM_suffix(it), it->nsuffix - 2) != 0 ||
							add_iov(c, suffix, suffix_len) != 0 ||
							add_iov(c, ITEM_data(it), it->nbytes) != 0)
					{
						item_remove(it);
						break;
					}
				}
				else
				{
					MEMCACHED_COMMAND_GET(c->sfd, ITEM_key(it), it->nkey,
							it->nbytes, ITEM_get_cas(it));
					//填充要返回的信息  
					if (add_iov(c, "VALUE ", 6) != 0 ||
							add_iov(c, ITEM_key(it), it->nkey) != 0 ||
							add_iov(c, ITEM_suffix(it), it->nsuffix + it->nbytes) != 0)
					{
						item_remove(it);
						break;
					}
				}


				if (settings.verbose > 1) {
					int ii;
					fprintf(stderr, ">%d sending key ", c->sfd);
					for (ii = 0; ii < it->nkey; ++ii) {
						fprintf(stderr, "%c", key[ii]);
					}
					fprintf(stderr, "\n");
				}

				/* item_get() has incremented it->refcount for us */
				pthread_mutex_lock(&c->thread->stats.mutex);
				c->thread->stats.slab_stats[it->slabs_clsid].get_hits++;
				c->thread->stats.get_cmds++;
				pthread_mutex_unlock(&c->thread->stats.mutex);
				item_update(it);//刷新这个item的访问时间以及在LRU队列中的位置  
				//并不会马上放弃对这个item的占用。因为在add_iov函数中，memcached并不为  
				//复制一份item，而是直接使用item结构体本身的数据。故不能马上解除对  
				//item的引用，不然其他worker线程就有机会把这个item释放,导致野指针 
				*(c->ilist + i) = it;
				i++;

			} else {
				pthread_mutex_lock(&c->thread->stats.mutex);
				c->thread->stats.get_misses++;
				c->thread->stats.get_cmds++;
				pthread_mutex_unlock(&c->thread->stats.mutex);
				MEMCACHED_COMMAND_GET(c->sfd, key, nkey, -1, 0);
			}

			key_token++;
		}

		//因为调用一次tokenize_command最多只可以解析MAX_TOKENS-1个token，但  
		//get命令的键值key个数可以有很多个，所以此时就会出现后面的键值  
		//不在第一次tokenize的tokens数组中，此时需要多次调用tokenize_command  
		//函数，把所有的键值都tokenize出来。注意，此时还是在get命令中。  
		//当然在看这里的代码时直接忽略这种情况，我们只考虑"get tk"命令  
		/*
		 * If the command string hasn't been fully processed, get the next set
		 * of tokens.
		 */
		if(key_token->value != NULL) {
			ntokens = tokenize_command(key_token->value, tokens, MAX_TOKENS);
			key_token = tokens;
		}

	} while(key_token->value != NULL);

	c->icurr = c->ilist;
	c->ileft = i;
	if (return_cas) {
		c->suffixcurr = c->suffixlist;
		c->suffixleft = i;
	}

	if (settings.verbose > 1)
		fprintf(stderr, ">%d END\n", c->sfd);

	/*
	   If the loop was terminated because of out-of-memory, it is not
	   reliable to add END\r\n to the buffer, because it might not end
	   in \r\n. So we send SERVER_ERROR instead.
	   */
	if (key_token->value != NULL || add_iov(c, "END\r\n", 5) != 0
			|| (IS_UDP(c->transport) && build_udp_headers(c) != 0)) {
		out_of_memory(c, "SERVER_ERROR out of memory writing get response");
	}
	else {
		conn_set_state(c, conn_mwrite);
		c->msgcurr = 0;
	}
}//end process_get_command()




//现在已经知道是set命令，并且键值和对应的参数都已经提取出来了。
//接下来可以真正处理set命令了。set命令是：键值已存在则更新，不存在则添加。但在这里不管那么多，直接调用item_alloc申请一个item。
//其实process_update_command函数处理的命令不仅仅是set，还包括replace、add、append等等，这些命令也是直接申请一个新的item。
//
//item_alloc函数会直接调用do_item_alloc函数申请一个item。
//前面的很多博文一直在部分介绍do_item_alloc函数，但都没有给出过完整版。
//现在就给出神秘函数的全部代码。对于这个函数一些讨论参数前面的一些博文吧

//process_update_command函数申请分配一个item后，并没有直接直接把这个item插入到LRU队列和哈希表中，
//而仅仅是用conn结构体的item成员指向这个申请得到的item，并且用ritem成员指向item结构体的数据域(这为了方便写入数据)。
//最后conn的状态修改为conn_nread，就这样process_update_command函数曳然而止了。
static void process_update_command(conn *c, token_t *tokens, const size_t ntokens, int comm, bool handle_cas) {
    char *key;//键值  
    size_t nkey;//键值长度  
    unsigned int flags;//item的flags  
    time_t exptime;//item的超时  
    int vlen;//item数据域的长度  
    uint64_t req_cas_id=0;  
    item *it;  

    assert(c != NULL);

    //服务器不需要回复信息给客户端，这可以减少网络IO进而提高速度  
    //这种设置是一次性的，不影响下一条命令  
    set_noreply_maybe(c, tokens, ntokens);//处理用户命令里面的noreply  
  
    //键值的长度太长了。KEY_MAX_LENGTH为250  
    if (tokens[KEY_TOKEN].length > KEY_MAX_LENGTH) {  
        out_string(c, "CLIENT_ERROR bad command line format");  
        return;  
    }  

    key = tokens[KEY_TOKEN].value;
    nkey = tokens[KEY_TOKEN].length;

    //将字符串转成unsigned long,获取flags、exptime_int、vlen。  
    //它们的字符串形式必须是纯数字，否则转换失败,返回false  
    if (! (safe_strtoul(tokens[2].value, (uint32_t *)&flags)
           && safe_strtol(tokens[3].value, &exptime_int)
           && safe_strtol(tokens[4].value, (int32_t *)&vlen))) {
        out_string(c, "CLIENT_ERROR bad command line format");
        return;
    }

    /* Ubuntu 8.04 breaks when I pass exptime to safe_strtol */
    exptime = exptime_int;

    /* Negative exptimes can underflow and end up immortal. realtime() will
       immediately expire values that are greater than REALTIME_MAXDELTA, but less
       than process_started, so lets aim for that. */
    if (exptime < 0){
        exptime = REALTIME_MAXDELTA + 1;//REALTIME_MAXDELTA等于30天
	}

    // does cas value exist?
    if (handle_cas) {
        if (!safe_strtoull(tokens[5].value, &req_cas_id)) {
            out_string(c, "CLIENT_ERROR bad command line format");
            return;
        }
    }

    //在存储item数据的时候，都会自动在数据的最后加上"\r\n"  
    vlen += 2;
    if (vlen < 0 || vlen - 2 < 0) {
        out_string(c, "CLIENT_ERROR bad command line format");
        return;
    }

    if (settings.detail_enabled) {
        stats_prefix_record_set(key, nkey);
    }

    //根据所需的大小分配对应的item,并给这个item赋值。  
    //除了time和refcount成员外，其他的都赋值了。并把键值、flag这些值都拷贝  
    //到item后面的buff里面了，至于data，因为现在都还没拿到所以还没赋值  
    //realtime(exptime)是直接赋值给item的exptime成员 
    it = item_alloc(key, nkey, flags, realtime(exptime), vlen);

    if (it == 0) {
        if (! item_size_ok(nkey, flags, vlen))
            out_string(c, "SERVER_ERROR object too large for cache");
        else
            out_of_memory(c, "SERVER_ERROR out of memory storing object");
        /* swallow the data line */
        c->write_and_go = conn_swallow;
        c->sbytes = vlen;

        /* Avoid stale data persisting in cache because we failed alloc.
         * Unacceptable for SET. Anywhere else too? */
        if (comm == NREAD_SET) {
            it = item_get(key, nkey);
            if (it) {
                item_unlink(it);
                item_remove(it);
            }
        }

        return;
    }
    ITEM_set_cas(it, req_cas_id);

    //本函数并不会把item插入到哈希表和LRU队列，这个插入工作由  
    //complete_nread_ascii函数完成。 
    c->item = it;
    c->ritem = ITEM_data(it);//数据直通车  
    c->rlbytes = it->nbytes;//等于vlen(要比用户输入的长度大2，因为要加上\r\n)
    c->cmd = comm;
    conn_set_state(c, conn_nread);
}//end  process_update_command()



//command指向这条命令(该命令以字符串的形式表示)  
//在process_command函数中，memcached会增加msglist数组的大小。
static void process_command(conn *c, char *command) {

	token_t tokens[MAX_TOKENS];
	size_t ntokens;
	int comm;

	assert(c != NULL);

	MEMCACHED_PROCESS_COMMAND_START(c->sfd, c->rcurr, c->rbytes);

	if (settings.verbose > 1)
		fprintf(stderr, "<%d %s\n", c->sfd, command);

	/*
	 * for commands set/add/replace, we build an item and read the data
	 * directly into it, then continue in nread_complete().
	 */

	c->msgcurr = 0;
	c->msgused = 0;
	c->iovused = 0;
	if (add_msghdr(c) != 0) {
		out_of_memory(c, "SERVER_ERROR out of memory preparing response");
		return;
	}

	//将一条命令分割成一个个的token，并用tokens数组一一对应的指向  
	//比如命令"set tt 3 0 10"，将被分割成"set"、"tt"、"3"、"0"、"10"  
	//并用tokens数组的5个元素对应指向。token_t类型的value成员指向对应token  
	//在command字符串中的位置，length则指明该token的长度。  
	//该函数返回token的数量，数量是用户敲入的命令token数 + 1.  
	//上面的set命令例子，tokenize_command会返回6。  最后一个token是无意义的  
	ntokens = tokenize_command(command, tokens, MAX_TOKENS);//将命令记号化  

	//对于命令"get tk"，那么tokens[0].value 等于指向"get"的开始位置  
	//tokens[1].value 则指向"tk"的开始位置  
	if (ntokens >= 3 &&
			((strcmp(tokens[COMMAND_TOKEN].value, "get") == 0) ||
			 (strcmp(tokens[COMMAND_TOKEN].value, "bget") == 0))) {

		process_get_command(c, tokens, ntokens, false);

	} else if ((ntokens == 6 || ntokens == 7) &&
			((strcmp(tokens[COMMAND_TOKEN].value, "add") == 0 && (comm = NREAD_ADD)) ||
			 (strcmp(tokens[COMMAND_TOKEN].value, "set") == 0 && (comm = NREAD_SET)) ||
			 (strcmp(tokens[COMMAND_TOKEN].value, "replace") == 0 && (comm = NREAD_REPLACE)) ||
			 (strcmp(tokens[COMMAND_TOKEN].value, "prepend") == 0 && (comm = NREAD_PREPEND)) ||
			 (strcmp(tokens[COMMAND_TOKEN].value, "append") == 0 && (comm = NREAD_APPEND)) )) {

		process_update_command(c, tokens, ntokens, comm, false);

	} else if ((ntokens == 7 || ntokens == 8) && (strcmp(tokens[COMMAND_TOKEN].value, "cas") == 0 && (comm = NREAD_CAS))) {

		process_update_command(c, tokens, ntokens, comm, true);

	} else if ((ntokens == 4 || ntokens == 5) && (strcmp(tokens[COMMAND_TOKEN].value, "incr") == 0)) {

		process_arithmetic_command(c, tokens, ntokens, 1);

	} else if (ntokens >= 3 && (strcmp(tokens[COMMAND_TOKEN].value, "gets") == 0)) {

		process_get_command(c, tokens, ntokens, true);

	} else if ((ntokens == 4 || ntokens == 5) && (strcmp(tokens[COMMAND_TOKEN].value, "decr") == 0)) {

		process_arithmetic_command(c, tokens, ntokens, 0);

	} else if (ntokens >= 3 && ntokens <= 5 && (strcmp(tokens[COMMAND_TOKEN].value, "delete") == 0)) {

		process_delete_command(c, tokens, ntokens);

	} else if ((ntokens == 4 || ntokens == 5) && (strcmp(tokens[COMMAND_TOKEN].value, "touch") == 0)) {

		process_touch_command(c, tokens, ntokens);

	} else if (ntokens >= 2 && (strcmp(tokens[COMMAND_TOKEN].value, "stats") == 0)) {

		process_stat(c, tokens, ntokens);

	} else if (ntokens >= 2 && ntokens <= 4 && (strcmp(tokens[COMMAND_TOKEN].value, "flush_all") == 0)) {
		time_t exptime = 0;

		set_noreply_maybe(c, tokens, ntokens);

		pthread_mutex_lock(&c->thread->stats.mutex);
		c->thread->stats.flush_cmds++;
		pthread_mutex_unlock(&c->thread->stats.mutex);

		if (!settings.flush_enabled) {
			// flush_all is not allowed but we log it on stats
			out_string(c, "CLIENT_ERROR flush_all not allowed");
			return;
		}

		if(ntokens == (c->noreply ? 3 : 2)) {
			settings.oldest_live = current_time - 1;
			item_flush_expired();
			out_string(c, "OK");
			return;
		}

		exptime = strtol(tokens[1].value, NULL, 10);
		if(errno == ERANGE) {
			out_string(c, "CLIENT_ERROR bad command line format");
			return;
		}

		/*
		   If exptime is zero realtime() would return zero too, and
		   realtime(exptime) - 1 would overflow to the max unsigned
		   value.  So we process exptime == 0 the same way we do when
		   no delay is given at all.
		   */
		if (exptime > 0)
			settings.oldest_live = realtime(exptime) - 1;
		else /* exptime == 0 */
			settings.oldest_live = current_time - 1;
		item_flush_expired();
		out_string(c, "OK");
		return;

	} else if (ntokens == 2 && (strcmp(tokens[COMMAND_TOKEN].value, "version") == 0)) {

		out_string(c, "VERSION " VERSION);

	} else if (ntokens == 2 && (strcmp(tokens[COMMAND_TOKEN].value, "quit") == 0)) {

		conn_set_state(c, conn_closing);

	} else if (ntokens == 2 && (strcmp(tokens[COMMAND_TOKEN].value, "shutdown") == 0)) {

		if (settings.shutdown_command) {
			conn_set_state(c, conn_closing);
			raise(SIGINT);
		} else {
			out_string(c, "ERROR: shutdown not enabled");
		}

	} else if (ntokens > 1 && strcmp(tokens[COMMAND_TOKEN].value, "slabs") == 0) {
		if (ntokens == 5 && strcmp(tokens[COMMAND_TOKEN + 1].value, "reassign") == 0) {
			int src, dst, rv;

			if (settings.slab_reassign == false) {
				out_string(c, "CLIENT_ERROR slb reassignment disabled");
				return;
			}

			src = strtol(tokens[2].value, NULL, 10);
			dst = strtol(tokens[3].value, NULL, 10);

			if (errno == ERANGE) {
				out_string(c, "CLIENT_ERROR bad command line format");
				return;
			}

			rv = slabs_reassign(src, dst);
			switch (rv) {
				case REASSIGN_OK:
					out_string(c, "OK");
					break;
				case REASSIGN_RUNNING:
					out_string(c, "BUSY currently processing reassign request");
					break;
				case REASSIGN_BADCLASS:
					out_string(c, "BADCLASS invalid src or dst class id");
					break;
				case REASSIGN_NOSPARE:
					out_string(c, "NOSPARE source class has no spare pages");
					break;
				case REASSIGN_SRC_DST_SAME:
					out_string(c, "SAME src and dst class are identical");
					break;
			}
			return;
		} else if (ntokens == 4 &&
				(strcmp(tokens[COMMAND_TOKEN + 1].value, "automove") == 0)) {
			process_slabs_automove_command(c, tokens, ntokens);
		} else {
			out_string(c, "ERROR");
		}
	} else if (ntokens > 1 && strcmp(tokens[COMMAND_TOKEN].value, "lru_crawler") == 0) {
		if (ntokens == 4 && strcmp(tokens[COMMAND_TOKEN + 1].value, "crawl") == 0) {
			int rv;
			if (settings.lru_crawler == false) {
				out_string(c, "CLIENT_ERROR lru crawler disabled");
				return;
			}

			rv = lru_crawler_crawl(tokens[2].value);
			switch(rv) {
				case CRAWLER_OK:
					out_string(c, "OK");
					break;
				case CRAWLER_RUNNING:
					out_string(c, "BUSY currently processing crawler request");
					break;
				case CRAWLER_BADCLASS:
					out_string(c, "BADCLASS invalid class id");
					break;
			}
			return;
		} else if (ntokens == 4 && strcmp(tokens[COMMAND_TOKEN + 1].value, "tocrawl") == 0) {
			uint32_t tocrawl;
			if (!safe_strtoul(tokens[2].value, &tocrawl)) {
				out_string(c, "CLIENT_ERROR bad command line format");
				return;
			}
			settings.lru_crawler_tocrawl = tocrawl;
			out_string(c, "OK");
			return;
		} else if (ntokens == 4 && strcmp(tokens[COMMAND_TOKEN + 1].value, "sleep") == 0) {
			uint32_t tosleep;
			if (!safe_strtoul(tokens[2].value, &tosleep)) {
				out_string(c, "CLIENT_ERROR bad command line format");
				return;
			}
			if (tosleep > 1000000) {
				out_string(c, "CLIENT_ERROR sleep must be one second or less");
				return;
			}
			settings.lru_crawler_sleep = tosleep;
			out_string(c, "OK");
			return;
		} else if (ntokens == 3) {
			if ((strcmp(tokens[COMMAND_TOKEN + 1].value, "enable") == 0)) {
				if (start_item_crawler_thread() == 0) {
					out_string(c, "OK");
				} else {
					out_string(c, "ERROR failed to start lru crawler thread");
				}
			} else if ((strcmp(tokens[COMMAND_TOKEN + 1].value, "disable") == 0)) {
				if (stop_item_crawler_thread() == 0) {
					out_string(c, "OK");
				} else {
					out_string(c, "ERROR failed to stop lru crawler thread");
				}
			} else {
				out_string(c, "ERROR");
			}
			return;
		} else {
			out_string(c, "ERROR");
		}
	} else if ((ntokens == 3 || ntokens == 4) && (strcmp(tokens[COMMAND_TOKEN].value, "verbosity") == 0)) {
		process_verbosity_command(c, tokens, ntokens);
	} else {
		out_string(c, "ERROR");
	}
	return;
}//end process_command()




//try_read_command函数，以\n或者\n\r为作为一条数据的结尾。
//并且会把数据的结尾赋值为’\0’，这样conn的rcurr指针就相当于指向一个以’\0’结尾的字符串。
//接着就会调用process_command函数处理这个字符串，在处理之前还要解析出这个字符串具体是什么命令。

//判断命令的完整性：
//在具体解析客户端命令的内容之前，还需要做一个工作：判断是否接收到完整的一条命令。
//Memcached判断的方法也简单：如果接收的数据中包含换行符就说明接收到完整的一条命令，
//否则就不完整，需要重新读取客户端socket(把conn状态设置为conn_waiting)。
//由于不同的平台对于行尾有不同的处理，有的为”\r\n”，有的为”\n”。memcached必须处理这种情况。
//Memcached的解决方案是：不管它！直接把命令最后一个字符的后一个字符(the character past the end of the command)改为’\0’，这样命令数据就变成一个C语言的字符串了。
//更巧妙的是，memcached还用一个临时变量指向’\n’字符的下一个字符。这样，无论行尾是”\r\n”还是”\n”都不重要了。

static int try_read_command(conn *c) {
	assert(c != NULL);
	assert(c->rcurr <= (c->rbuf + c->rsize));
	assert(c->rbytes > 0);

    //memcached支持文本和二进制两种协议。对于TCP这样的有连接协议,memcached为该  
    //fd分配conn的时候，并不指明其是用哪种协议的。此时用negotiating_prot代表待  
    //协商的意思(negotiate是谈判、协商)。而是在客户端第一次发送数据给  
    //memcached的时候用第一个字节来指明.之后的通信都是使用指明的这种协议。  
    //对于UDP这样的无连接协议，指明每次都指明使用哪种协议了  
	if (c->protocol == negotiating_prot || c->transport == udp_transport)  {
        //对于TCP只会进入该判断体里面一次，而UDP就要次次都进入了  
        //PROTOCOL_BINARY_REQ为0x80，即128。对于ascii的文本来说，是不会取这个值的  
		if ((unsigned char)c->rbuf[0] == (unsigned char)PROTOCOL_BINARY_REQ) {
			c->protocol = binary_prot;
		} else {
			c->protocol = ascii_prot;
		}

		if (settings.verbose > 1) {
			fprintf(stderr, "%d: Client using the %s protocol\n", c->sfd,
					prot_text(c->protocol));
		}
	}

	if (c->protocol == binary_prot) {//二进制不看
		/* Do we have the complete packet header? */
		if (c->rbytes < sizeof(c->binary_header)) {
			/* need more data! */
			return 0;
		} else {
#ifdef NEED_ALIGN
			if (((long)(c->rcurr)) % 8 != 0) {
				/* must realign input buffer */
				memmove(c->rbuf, c->rcurr, c->rbytes);
				c->rcurr = c->rbuf;
				if (settings.verbose > 1) {
					fprintf(stderr, "%d: Realign input buffer\n", c->sfd);
				}
			}
#endif
			protocol_binary_request_header* req;
			req = (protocol_binary_request_header*)c->rcurr;

			if (settings.verbose > 1) {
				/* Dump the packet before we convert it to host order */
				int ii;
				fprintf(stderr, "<%d Read binary protocol data:", c->sfd);
				for (ii = 0; ii < sizeof(req->bytes); ++ii) {
					if (ii % 4 == 0) {
						fprintf(stderr, "\n<%d   ", c->sfd);
					}
					fprintf(stderr, " 0x%02x", req->bytes[ii]);
				}
				fprintf(stderr, "\n");
			}

			c->binary_header = *req;
			c->binary_header.request.keylen = ntohs(req->request.keylen);
			c->binary_header.request.bodylen = ntohl(req->request.bodylen);
			c->binary_header.request.cas = ntohll(req->request.cas);

			if (c->binary_header.request.magic != PROTOCOL_BINARY_REQ) {
				if (settings.verbose) {
					fprintf(stderr, "Invalid magic:  %x\n",
							c->binary_header.request.magic);
				}
				conn_set_state(c, conn_closing);
				return -1;
			}

			c->msgcurr = 0;
			c->msgused = 0;
			c->iovused = 0;
			if (add_msghdr(c) != 0) {
				out_of_memory(c,
						"SERVER_ERROR Out of memory allocating headers");
				return 0;
			}

			c->cmd = c->binary_header.request.opcode;
			c->keylen = c->binary_header.request.keylen;
			c->opaque = c->binary_header.request.opaque;
			/* clear the returned cas value */
			c->cas = 0;

			dispatch_bin_command(c);

			c->rbytes -= sizeof(c->binary_header);
			c->rcurr += sizeof(c->binary_header);
		}
	} else {//文本协议
		char *el, *cont;

        if (c->rbytes == 0)//读缓冲区里面没有数据,被耍啦  
            return 0;//返回0表示需要继续读取socket的数据才能解析命令  

		el = memchr(c->rcurr, '\n', c->rbytes);
		if (!el) {//没有读取到一条完整的命令 //为了简单，不考虑这种情况。
			if (c->rbytes > 1024) {//接收了1024个字符都没有回车符，值得怀疑
				/*
				 * We didn't have a '\n' in the first k. This _has_ to be a
				 * large multiget, if not we should just nuke the connection.
				 */
				char *ptr = c->rcurr;
				while (*ptr == ' ') { /* ignore leading whitespaces */
					++ptr;
				}

				if (ptr - c->rcurr > 100 || //太多的空格符
						(strncmp(ptr, "get ", 4) && strncmp(ptr, "gets ", 5))) {//是get或者gets命令，但一次获取太多信息了
					conn_set_state(c, conn_closing);//必须干掉这种扯蛋的conn客户端
					return 1;
				}
			}

			return 0;//返回0表示需要继续读取socket的数据才能解析命令
		}

        //来到这里，说明已经读取到至少一条完整的命令  

		//用cont指向下一行的开始，无论行尾是\n还是\r\n  
		cont = el + 1;
		//不同的平台对于行尾有不同的处理,有的为\r\n有的则是\n。所以memcached  
		//还要判断一下\n前面的一个字符是否为\r 
		if ((el - c->rcurr) > 1 && *(el - 1) == '\r') {
			el--;
		}
		//'\0',C语言字符串结尾符号。结合c->rcurr这个开始位置，就可以确定  
		//这个命令(现在被看作一个字符串)的开始和结束位置。rcurr指向了一个字符串  
		//注意，下一条命令的开始位置由前面的cont指明了 
		*el = '\0';

		assert(cont <= (c->rcurr + c->rbytes));

		c->last_cmd_time = current_time;
		process_command(c, c->rcurr);//命令字符串由c->rcurr指向

        //cont指明下一条命令的开始位置  
        //更新curr指针和剩余字节数  
		c->rbytes -= (cont - c->rcurr);
		c->rcurr = cont;

		assert(c->rcurr <= (c->rbuf + c->rsize));
	}

	return 1;//返回1表示正在处理读取的一条命令
}//end try_read_command()

//尽可能把socket的所有数据都读进c指向的一个缓冲区里面  
//当然为了防止有恶意的客户端，memcached也是有限度的：只撑大读缓冲区4次。这对于正常的客户端命令来说已经是足够的了。
static enum try_read_result try_read_network(conn *c) {  
    enum try_read_result gotdata = READ_NO_DATA_RECEIVED;  
    int res;  
    int num_allocs = 0;  
    assert(c != NULL);  
  
    if (c->rcurr != c->rbuf) {  
        //rcurr 和 rbuf之间是一条已经解析了的命令。现在可以丢弃了  
        if (c->rbytes != 0) /* otherwise there's nothing to copy */  
            memmove(c->rbuf, c->rcurr, c->rbytes);  
        c->rcurr = c->rbuf;  
    }  
  
    while (1) {  
        //因为本函数会尽可能把socket数据都读取到rbuf指向的缓冲区里面，  
        //所以可能出现当前缓冲区不够大的情况(即rbytes>=rsize)  
        if (c->rbytes >= c->rsize) {  
            //可能有坏蛋发无穷无尽的数据过来，而本函数又是尽可能把所有数据都  
            //读进缓冲区。为了防止坏蛋耗光服务器的内存，所以就只分配4次内存  
            if (num_allocs == 4) {  
                return gotdata;  
            }  
            ++num_allocs;  
            char *new_rbuf = realloc(c->rbuf, c->rsize * 2);  
            if (!new_rbuf) {  
                //虽然分配内存失败，但realloc保证c->rbuf还是合法可用的指针  
                c->rbytes = 0; /* ignore what we read */  
  
                out_of_memory(c, "SERVER_ERROR out of memory reading request");  
                c->write_and_go = conn_closing;//关闭这个conn  
                return READ_MEMORY_ERROR;  
            }  
            c->rcurr = c->rbuf = new_rbuf;  
            c->rsize *= 2;  
        }  
  
        int avail = c->rsize - c->rbytes;  
        res = read(c->sfd, c->rbuf + c->rbytes, avail);  
        if (res > 0) {  
            pthread_mutex_lock(&c->thread->stats.mutex);  
            c->thread->stats.bytes_read += res;//记录该线程读取了多少字节  
            pthread_mutex_unlock(&c->thread->stats.mutex);  
            gotdata = READ_DATA_RECEIVED;  
            c->rbytes += res;  
            if (res == avail) {//可能还有数据没有读出来  
                continue;  
            } else {  
                break;//socket暂时还没数据了(即已经读取完)  
            }  
        }  
        if (res == 0) {  
            return READ_ERROR;  
        }  
        if (res == -1) {  
            if (errno == EAGAIN || errno == EWOULDBLOCK) {  
                break;  
            }  
            return READ_ERROR;  
        }  
    }  
    return gotdata;  
}//end try_read_network()

//即使transmit函数一次把所有的数据都写到了客户端，还是会调用transmit函数两次才能返回TRANSMIT_COMPLETE。
//第一次是TRANSMIT_INCOMPLETE,第二次才是TRANSMIT_COMPLETE.
//当memcached把所有的数据都写回客户端后，就会调用conn_release_items函数释放对item的占用。
static enum transmit_result transmit(conn *c) {
	assert(c != NULL);

	if (c->msgcurr < c->msgused &&
			c->msglist[c->msgcurr].msg_iovlen == 0) {//msgcurr指向的msghdr已经发送完毕
		/* Finished writing the current msg; advance to the next. */
		c->msgcurr++;
	}
	if (c->msgcurr < c->msgused) {//还有数据需要发送
		ssize_t res;
		struct msghdr *m = &c->msglist[c->msgcurr];

		res = sendmsg(c->sfd, m, 0);
		if (res > 0) {//成功
			//通过sendmsg返回值确定已经写了多少个iovec数组。循环减去每一个iovec数组的每一个  
			//元素的数据长度即可  
			pthread_mutex_lock(&c->thread->stats.mutex);
			c->thread->stats.bytes_written += res;
			pthread_mutex_unlock(&c->thread->stats.mutex);

			/* We've written some of the data. Remove the completed
			   iovec entries from the list of pending writes. */
			while (m->msg_iovlen > 0 && res >= m->msg_iov->iov_len) {
				res -= m->msg_iov->iov_len;
				m->msg_iovlen--;
				m->msg_iov++;
			}

			//只写了iovec结构体的部分数据  
			/* Might have written just part of the last iovec entry;
			   adjust it so the next write will do the rest. */
			if (res > 0) {
				m->msg_iov->iov_base = (caddr_t)m->msg_iov->iov_base + res;
				m->msg_iov->iov_len -= res;
			}
			return TRANSMIT_INCOMPLETE;
		}
		if (res == -1 && (errno == EAGAIN || errno == EWOULDBLOCK)) {
			if (!update_event(c, EV_WRITE | EV_PERSIST)) {
				if (settings.verbose > 0)
					fprintf(stderr, "Couldn't update event\n");
				conn_set_state(c, conn_closing);
				return TRANSMIT_HARD_ERROR;
			}
			return TRANSMIT_SOFT_ERROR;
		}
		/* if res == 0 or res == -1 and error is not EAGAIN or EWOULDBLOCK,
		   we have a real error, on which we close the connection */
		if (settings.verbose > 0)
			perror("Failed to write, and not due to blocking");

		if (IS_UDP(c->transport))
			conn_set_state(c, conn_read);
		else
			conn_set_state(c, conn_closing);
		return TRANSMIT_HARD_ERROR;
	} else {//所有的数据都已经发送完毕
		return TRANSMIT_COMPLETE;
	}
}//end  transmit()



//drive_machine被调用会进行状态判断，并进行一些处理。但也可能发生状态的转换  
//此时就需要一个循环，当进行状态转换时，也能处理  

//drive_machine这个方法中，都是通过c->state来判断需要处理的逻辑。
//conn_listening：监听状态
//conn_waiting：等待状态
//conn_read：读取状态
//conn_parse_cmd：命令行解析
//conn_mwrite：向客户端写数据
//conn_new_cmd：解析新的命令
static void drive_machine(conn *c) {
	bool stop = false;
	int sfd;
	socklen_t addrlen;
	struct sockaddr_storage addr;
	int nreqs = settings.reqs_per_event;//20
	int res;
	const char *str;
#ifdef HAVE_ACCEPT4
	static int  use_accept4 = 1;
#else
	static int  use_accept4 = 0;
#endif

	assert(c != NULL);

	while (!stop) {

		switch(c->state) {
			case conn_listening:
				addrlen = sizeof(addr);
#ifdef HAVE_ACCEPT4
				if (use_accept4) {
					sfd = accept4(c->sfd, (struct sockaddr *)&addr, &addrlen, SOCK_NONBLOCK);
				} else {
					sfd = accept(c->sfd, (struct sockaddr *)&addr, &addrlen);
				}
#else
				sfd = accept(c->sfd, (struct sockaddr *)&addr, &addrlen);
#endif
				if (sfd == -1) {
					if (use_accept4 && errno == ENOSYS) {
						use_accept4 = 0;
						continue;
					}
					perror(use_accept4 ? "accept4()" : "accept()");
					if (errno == EAGAIN || errno == EWOULDBLOCK) {
						/* these are transient, so don't log anything */
						stop = true;
					} else if (errno == EMFILE) {
						if (settings.verbose > 0)
							fprintf(stderr, "Too many open connections\n");
						accept_new_conns(false);
						stop = true;
					} else {
						perror("accept()");
						stop = true;
					}
					break;
				}
				if (!use_accept4) {
					if (fcntl(sfd, F_SETFL, fcntl(sfd, F_GETFL) | O_NONBLOCK) < 0) {
						perror("setting O_NONBLOCK");
						close(sfd);
						break;
					}
				}

				if (settings.maxconns_fast &&
						stats.curr_conns + stats.reserved_fds >= settings.maxconns - 1) {
					str = "ERROR Too many open connections\r\n";
					res = write(sfd, str, strlen(str));
					close(sfd);
					STATS_LOCK();
					stats.rejected_conns++;
					STATS_UNLOCK();
				} else {
					//选定一个worker线程，new一个CQ_ITEM，把这个CQ_ITEM仍给这个线程.  
					dispatch_conn_new(sfd, conn_new_cmd, EV_READ | EV_PERSIST,
							DATA_BUFFER_SIZE, tcp_transport);
				}

				stop = true;
				break;

			case conn_waiting://等待socket变成可读的  
				if (!update_event(c, EV_READ | EV_PERSIST)) {//更新监听事件失败
					if (settings.verbose > 0)
						fprintf(stderr, "Couldn't update event\n");
					conn_set_state(c, conn_closing);
					break;
				}

				conn_set_state(c, conn_read);
				stop = true;
				break;

			case conn_read:
				res = IS_UDP(c->transport) ? try_read_udp(c) : try_read_network(c);

				switch (res) {  
					case READ_NO_DATA_RECEIVED://没有读取到数据  
						conn_set_state(c, conn_waiting);//等待  
						break;  
					case READ_DATA_RECEIVED://读取到了数据，接着就去解析数据  
						conn_set_state(c, conn_parse_cmd);  
						break;  
					case READ_ERROR://read函数的返回值等于0或者-1时，会返回这个值  
						conn_set_state(c, conn_closing);//直接关闭这个客户端  
						break;  
					case READ_MEMORY_ERROR: /* Failed to allocate more memory */  
						/* State already set by try_read_network */  
						break;  
				}  

				break;

			case conn_parse_cmd :
				//解析命令：
				//前面已经展示了，worker线程怎么读取数据(命令)，
				//并且在读取完毕后会把conn的状态设置为conn_parse_cmd。
				//为了简单起见，我们假设经过一次读取就已经成功读取了一条完整的get命令。

				//返回1表示正在处理读取的一条命令  
				//返回0表示需要继续读取socket的数据才能解析命令  
				//如果读取到了一条完整的命令，那么函数内部会去解析，  
				//并进行调用process_command函数进行一些处理.  
				//像set、add、replace、get这些命令，会在处理的时候调用
				if (try_read_command(c) == 0) {
					/* wee need more data! */
					conn_set_state(c, conn_witing);
				}

				break;

			case conn_new_cmd:
				/* Only process nreqs at a time to avoid starving other
				   connections */

				--nreqs;
				if (nreqs >= 0) {//简单起见，不考虑nreqs小于0的情况  
					//如果该conn的读缓冲区没有数据，那么将状态改成conn_waiting  
					//如果该conn的读缓冲区有数据， 那么将状态改成conn_pase_cmd  
					reset_cmd_handler(c);
				} else {
					pthread_mutex_lock(&c->thread->stats.mutex);
					c->thread->stats.conn_yields++;
					pthread_mutex_unlock(&c->thread->stats.mutex);
					if (c->rbytes > 0) {
						//如果某个客户端的命令数过多，会被memcached强制退出drive_mahcine。
						//如果该客户端的socket里面还有数据并且是libevent是水平触发的，那么libevent会自动触发事件，能再次进入drive_mahcine函数。
						//但如果该客户端的命令都读进conn结构体的读缓冲区，那么就必须等到客户端再次发送命令，libevent才会触发。
						//但客户端一直不再发送命令了呢？
						//为了解决这个问题，memcached采用了一种很巧妙的处理方法：为这个客户端socket设置可写事件。
						//除非客户端socket的写缓冲区已满，否则libevent都会为这个客户端触发事件。
						//事件一触发，那么worker线程就会进入drive_machine函数处理这个客户端的命令。
						/* We have already read in data into the input buffer,
						   so libevent will most likely not signal read events
						   on the socket (unless more data is available. As a
						   hack we should just put in a request to write data,
						   because that should be possible ;-)
						   */
						if (!update_event(c, EV_WRITE | EV_PERSIST)) {
							if (settings.verbose > 0)
								fprintf(stderr, "Couldn't update event\n");
							conn_set_state(c, conn_closing);
							break;
						}
					}
					stop = true;
				}
				break;

			case conn_nread:

				//填充item数据域：
				//process_update_command() 没有把item的数据写入到item结构体中。
				//现在要退出到有限自动机drive_machine函数中，查看memcached是怎么处理conn_nread状态的。
				//虽然process_update_command留下了手尾，但它也用conn的成员变量记录了一些重要值，
				//比如rlbytes表示需要用多少字节填充item；rbytes表示读缓冲区还有多少字节可以使用；ritem指向数据填充地点


				//对于set、add、replace这样的命令会将state设置成conn_nread  
				//因为在conn_read，它只读取了一行的数据，就去解析。但数据是  
				//在第二行输入的(客户端输入进行操作的时候)，此时，rlbytes  
				//等于data的长度。本case里面会从conn的读缓冲区、socket读缓冲区  
				//读取数据到item里面。  

				//rlbytes标识还有多少字节需要读取到item里面。只要没有读取足够的  
				//数据，conn的状态都是保持为conn_nread。即使读取到足够的数据  
				//状态还是不变，但此时rlbytes等于0。此刻会进入下面的这个if里面
				if (c->rlbytes == 0) {
					//处理完成后会调用out_string函数。如果用户明确要求不需要回复  
					//那么conn的状态变成conn_new_cmd。如果需要回复，那么状态改为  
					//conn_write，并且write_and_go成员赋值为conn_new_cmd  
					complete_nread(c);//完成对一个item的操作
					break;
				}

				/* Check if rbytes < 0, to prevent crash */
				if (c->rlbytes < 0) {
					if (settings.verbose) {
						fprintf(stderr, "Invalid rlbytes to read: len %d\n", c->rlbytes);
					}
					conn_set_state(c, conn_closing);
					break;
				}

				/* first check if we have leftovers in the conn_read buffer */
				if (c->rbytes > 0) {//conn读缓冲区里面还有数据,那么把数据直接赋值到item里面
					//rlbytes是需要读取的字节数, rbytes是读缓冲区拥有的字节数  
					int tocopy = c->rbytes > c->rlbytes ? c->rlbytes : c->rbytes;
					if (c->ritem != c->rcurr) {
						memmove(c->ritem, c->rcurr, tocopy);
					}
					c->ritem += tocopy;
					c->rlbytes -= tocopy;
					c->rcurr += tocopy;
					c->rbytes -= tocopy;
					if (c->rlbytes == 0) {//conn读缓冲区的数据能满足item的所需数据,无需从socket中读取
						break;
					}
				}

				//下面的代码中，只要不发生socket错误，那么无论是否读取到足够的数据  
				//都不会改变conn的状态，也就是说，下一次进入状态机还是为conn_nread状态  
				/*  now try reading from the socket */
				res = read(c->sfd, c->ritem, c->rlbytes);//直接从socket中读取数据
				if (res > 0) {
					pthread_mutex_lock(&c->thread->stats.mutex);
					c->thread->stats.bytes_read += res;
					pthread_mutex_unlock(&c->thread->stats.mutex);
					if (c->rcurr == c->ritem) {
						c->rcurr += res;
					}
					c->ritem += res;
					c->rlbytes -= res;
					break;
				}
				if (res == 0) { /* end of stream */
					conn_set_state(c, conn_closing);
					break;
				}
				if (res == -1 && (errno == EAGAIN || errno == EWOULDBLOCK)) {
					if (!update_event(c, EV_READ | EV_PERSIST)) {
						if (settings.verbose > 0)
							fprintf(stderr, "Couldn't update event\n");
						conn_set_state(c, conn_closing);
						break;
					}
					stop = true;//此时就不要再读了，停止状态机，等待libevent通知有数据可读
					break;
				}
				/* otherwise we have a real error, on which we close the connection */
				if (settings.verbose > 0) {
					fprintf(stderr, "Failed to read, and not due to blocking:\n"
							"errno: %d %s \n"
							"rcurr=%lx ritem=%lx rbuf=%lx rlbytes=%d rsize=%d\n",
							errno, strerror(errno),
							(long)c->rcurr, (long)c->ritem, (long)c->rbuf,
							(int)c->rlbytes, (int)c->rsize);
				}
				conn_set_state(c, conn_closing);
				break;

			case conn_swallow:
				/* we are reading sbytes and throwing them away */
				if (c->sbytes == 0) {
					conn_set_state(c, conn_new_cmd);
					break;
				}

				/* first check if we have leftovers in the conn_read buffer */
				if (c->rbytes > 0) {
					int tocopy = c->rbytes > c->sbytes ? c->sbytes : c->rbytes;
					c->sbytes -= tocopy;
					c->rcurr += tocopy;
					c->rbytes -= tocopy;
					break;
				}

				/*  now try reading from the socket */
				res = read(c->sfd, c->rbuf, c->rsize > c->sbytes ? c->sbytes : c->rsize);
				if (res > 0) {
					pthread_mutex_lock(&c->thread->stats.mutex);
					c->thread->stats.bytes_read += res;
					pthread_mutex_unlock(&c->thread->stats.mutex);
					c->sbytes -= res;
					break;
				}
				if (res == 0) { /* end of stream */
					conn_set_state(c, conn_closing);
					break;
				}
				if (res == -1 && (errno == EAGAIN || errno == EWOULDBLOCK)) {
					if (!update_event(c, EV_READ | EV_PERSIST)) {
						if (settings.verbose > 0)
							fprintf(stderr, "Couldn't update event\n");
						conn_set_state(c, conn_closing);
						break;
					}
					stop = true;
					break;
				}
				/* otherwise we have a real error, on which we close the connection */
				if (settings.verbose > 0)
					fprintf(stderr, "Failed to read, and not due to blocking\n");
				conn_set_state(c, conn_closing);
				break;

			case conn_write:
				/*
				 * We want to write out a simple response. If we haven't already,
				 * assemble it into a msgbuf list (this will be a single-entry
				 * list for TCP or a two-en:try list for UDP).
				 */
				if (c->iovused == 0 || (IS_UDP(c->transport) && c->iovused == 1)) {
					if (add_iov(c, c->wcurr, c->wbytes) != 0) {
						if (settings.verbose > 0)
							fprintf(stderr, "Couldn't build response\n");
						conn_set_state(c, conn_closing);
						break;
					}
				}

				/* fall through... */

				//回应命令:
				//前面的process_get_command函数已经把要写的数据都通过iovec结构体指明了，
				//并且把conn的状态设置为conn_mwrite。现在来看一下memcached具体是怎么写数据的。
			case conn_mwrite:
				if (IS_UDP(c->transport) && c->msgcurr == 0 && build_udp_headers(c) != 0) {
					if (settings.verbose > 0)
						fprintf(stderr, "Failed to build UDP headers\n");
					conn_set_state(c, conn_closing);
					break;
				}
				switch (transmit(c)) {//发送数据给c->sfd指明的客户端
					case TRANSMIT_COMPLETE://发送数据完毕
						if (c->state == conn_mwrite) {
							conn_release_items(c);//释放对item的占用
							/* XXX:  I don't know why this wasn't the general case */
							if(c->protocol == binary_prot) {
								conn_set_state(c, c->write_and_go);
							} else {//我们只考虑文本协议 
								conn_set_state(c, conn_new_cmd);//又回到了一开始的conn_new_cmd状态
							}
						} else if (c->state == conn_write) {
							if (c->write_and_fwree) {
								free(c->write_and_free);
								c->write_and_free = 0;
							}
							conn_set_state(c, c->write_and_go);
						} else {
							if (settings.verbose > 0)
								fprintf(stderr, "Unexpected state %d\n", c->state);
							conn_set_state(c, conn_closing);
						}
						break;

					case TRANSMIT_INCOMPLETE://还没发送完毕  
					case TRANSMIT_HARD_ERROR:
						break;                   /* Continue in state machine. */

					case TRANSMIT_SOFT_ERROR:
						stop = true;
						break;
				}
				break;

			case conn_closing:
				if (IS_UDP(c->transport))

					conn_cleanup(c);
				else
					conn_close(c);
				stop = true;
				break;

			case conn_closed:
				/* This only happens if dormando is an idiot. */
				abort();
				break;

			case conn_max_state:
				assert(false);
				break;
		}
	}

	return;
}//end drive_machine()


//牛刀小试：
//主线程和worker线程的基础设施都已经搭建好了，现在来尝试一下accept一个客户端。
//在跑一遍整个流程之前，先回忆一下回调函数。
//worker线程对于管道可读事件的回调函数是ethread_libevent_process函数。
//主线程对于socket fd可读事件的回调函数是event_handler函数。
//conn结构体成员state的值为conn_listening。现在走起！！直奔event_handler函数。
void event_handler(const int fd, const short which, void *arg) {
	conn *c;

	c = (conn *)arg;
	assert(c != NULL);

	c->which = which;

	/* sanity */
	if (fd != c->sfd) {
		if (settings.verbose > 0)
			fprintf(stderr, "Catastrophic: event fd doesn't match conn fd!\n");
		conn_close(c);
		return;
	}

	drive_machine(c);//有限状态机

	/* wait for next event */
	return;
}//end event_handler()

static int new_socket(struct addrinfo *ai) {
	int sfd;
	int flags;

	if ((sfd = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol)) == -1) {
		return -1;
	}

	if ((flags = fcntl(sfd, F_GETFL, 0)) < 0 ||
			fcntl(sfd, F_SETFL, flags | O_NONBLOCK) < 0) {
		perror("setting O_NONBLOCK");
		close(sfd);
		return -1;
	}
	return sfd;
}// end new_socket()

/**
 * Create a socket and bind it to a specific port number
 * @param interface the interface to bind to
 * @param port the port number to bind to
 * @param transport the transport protocol (TCP / UDP)
 * @param portnumber_file A filepointer to write the port numbers to
 *        when they are successfully added to the list of ports we
 *        listen on.
 */
static int server_socket(const char *interface,
		int port,
		enum network_transport transport,
		FILE *portnumber_file) {
	int sfd;
	struct linger ling = {0, 0};
	struct addrinfo *ai;
	struct addrinfo *next;
	struct addrinfo hints = { .ai_flags = AI_PASSIVE,
		.ai_family = AF_UNSPEC };
	char port_buf[NI_MAXSERV];
	int error;
	int success = 0;
	int flags =1;

	hints.ai_socktype = IS_UDP(transport) ? SOCK_DGRAM : SOCK_STREAM;

	if (port == -1) {
		port = 0;
	}
	snprintf(port_buf, sizeof(port_buf), "%d", port);
	error= getaddrinfo(interface, port_buf, &hints, &ai);
	if (error != 0) {
		if (error != EAI_SYSTEM)
			fprintf(stderr, "getaddrinfo(): %s\n", gai_strerror(error));
		else
			perror("getaddrinfo()");
		return 1;
	}

	//如果interface是一个hostname的话，那么可能就有多个ip  
	for (next= ai; next; next= next->ai_next) {
		conn *listen_conn_add;

		//创建一个套接字，然后设置为非阻塞的  
		if ((sfd = new_socket(next)) == -1) {
			/* getaddrinfo can return "junk" addresses,
			 * we make sure at least one works before erroring.
			 */
			if (errno == EMFILE) {
				/* ...unless we're out of fds */
				perror("server_socket");
				exit(EX_OSERR);
			}
			continue;
		}

#ifdef IPV6_V6ONLY
		if (next->ai_family == AF_INET6) {
			error = setsockopt(sfd, IPPROTO_IPV6, IPV6_V6ONLY, (char *) &flags, sizeof(flags));
			if (error != 0) {
				perror("setsockopt");
				close(sfd);
				continue;
			}
		}
#endif

		setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, (void *)&flags, sizeof(flags));
		if (IS_UDP(transport)) {
			maximize_sndbuf(sfd);
		} else {
			error = setsockopt(sfd, SOL_SOCKET, SO_KEEPALIVE, (void *)&flags, sizeof(flags));
			if (error != 0)
				perror("setsockopt");

			error = setsockopt(sfd, SOL_SOCKET, SO_LINGER, (void *)&ling, sizeof(ling));
			if (error != 0)
				perror("setsockopt");

			error = setsockopt(sfd, IPPROTO_TCP, TCP_NODELAY, (void *)&flags, sizeof(flags));
			if (error != 0)
				perror("setsockopt");
		}

		if (bind(sfd, next->ai_addr, next->ai_addrlen) == -1) {
			if (errno != EADDRINUSE) {
				perror("bind()");
				close(sfd);
				freeaddrinfo(ai);
				return 1;
			}
			close(sfd);
			continue;
		} else {
			success++;
			if (!IS_UDP(transport) && listen(sfd, settings.backlog) == -1) {
				perror("listen()");
				close(sfd);
				freeaddrinfo(ai);
				return 1;
			}
			if (portnumber_file != NULL &&
					(next->ai_addr->sa_family == AF_INET ||
					 next->ai_addr->sa_family == AF_INET6)) {
				union {
					struct sockaddr_in in;
					struct sockaddr_in6 in6;
				} my_sockaddr;
				socklen_t len = sizeof(my_sockaddr);
				if (getsockname(sfd, (struct sockaddr*)&my_sockaddr, &len)==0) {
					if (next->ai_addr->sa_family == AF_INET) {
						fprintf(portnumber_file, "%s INET: %u\n",
								IS_UDP(transport) ? "UDP" : "TCP",
								ntohs(my_sockaddr.in.sin_port));
					} else {
						fprintf(portnumber_file, "%s INET6: %u\n",
								IS_UDP(transport) ? "UDP" : "TCP",
								ntohs(my_sockaddr.in6.sin6_port));
					}
				}
			}
		}

		if (IS_UDP(transport)) {
			int c;

			for (c = 0; c < settings.num_threads_per_udp; c++) {
				/* Allocate one UDP file descriptor per worker thread;
				 * this allows "stats conns" to separately list multiple
				 * parallel UDP requests in progress.
				 *
				 * The dispatch code round-robins new connection requests
				 * among threads, so this is guaranteed to assign one
				 * FD to each thread.
				 */
				int per_thread_fd = c ? dup(sfd) : sfd;
				dispatch_conn_new(per_thread_fd, conn_read,
						EV_READ | EV_PERSIST,
						UDP_READ_BUFFER_SIZE, transport);
			}
		} else {
			if (!(listen_conn_add = conn_new(sfd, conn_listening,
							EV_READ | EV_PERSIST, 1,
							transport, main_base))) {
				fprintf(stderr, "failed to create listening connection\n");
				exit(EXIT_FAILURE);
			}

			//将要监听的多个conn放到一个监听队列里面  
			listen_conn_add->next = listen_conn;
			listen_conn = listen_conn_add;
		}
	}

	freeaddrinfo(ai);

	/* Return zero iff we detected no errors in starting up connections */
	return success == 0;
}//end  server_socket()


//代码的流程还是蛮清晰的。就是根据用户的IP和端口号建立一个socket，bind、listen监听客户端的到来。
//因为主线程申请的socketfd已经设置为非阻塞的，所以listen函数会立刻返回。
//在main函数中，主线程最终将调用event_base_loop函数进入事件监听循环，处理客户端的连接请求。
static int server_sockets(int port, enum network_transport transport,
		FILE *portnumber_file) {
	if (settings.inter == NULL) {
		return server_socket(settings.inter, port, transport, portnumber_file);
	} else {
		//settings.inter里面可能有多个IP地址.如果有多个那么将用逗号分隔  
		// tokenize them and bind to each one of them..
		char *b;
		int ret = 0;

		//复制一个字符串，避免下面的strtok_r函数修改(污染)全局变量settings.inter  
		char *list = strdup(settings.inter);

		if (list == NULL) {
			fprintf(stderr, "Failed to allocate memory for parsing server interface string\n");
			return 1;
		}

		//这个循环主要是处理多个IP的情况  
		for (char *p = strtok_r(list, ";,", &b);
				p != NULL;//分割出一个个的ip,使用分号;作为分隔符
				p = strtok_r(NULL, ";,", &b)) {
			int the_port = port;
			char *s = strchr(p, ':');//启动的可能使用-l ip:port 参数形式  
			//ip后面接着端口号，即指定ip的同时也指定了该ip的端口号  
			//此时采用ip后面的端口号，而不是采用-p指定的端口号
			if (s != NULL) {
				*s = '\0';//截断后面的端口号，使得p指向的字符串只是一个ip
				++s;
				if (!safe_strtol(s, &the_port)) {//截断后面的端口号，使得p指向的字符串只是一个ip
					fprintf(stderr, "Invalid port number: \"%s\"", s);
					return 1;
				}
			}
			if (strcmp(p, "*") == 0) {
				p = NULL;
			}
			//处理其中一个IP。有p指定ip(或者hostname)  
			ret |= server_socket(p, the_port, transport, portnumber_file);
		}
		free(list);
		return ret;
	}
}//end  server_sockets()



/* libevent uses a monotonic clock when available for event scheduling. Aside
 * from jitter, simply ticking our internal timer here is accurate enough.
 * Note that users who are setting explicit dates for expiration times *must*
 * ensure their clocks are correct before starting memcached. */
static void clock_handler(const int fd, const short which, void *arg) {
	struct timeval t = {.tv_sec = 1, .tv_usec = 0};
	static bool initialized = false;
#if defined(HAVE_CLOCK_GETTIME) && defined(CLOCK_MONOTONIC)
	static bool monotonic = false;
	static time_t monotonic_start;
#endif

	if (initialized) {
		/* only delete the event if it's actually there. */
		evtimer_del(&clockevent);
	} else {
		initialized = true;
		/* process_started is initialized to time() - 2. We initialize to 1 so
		 * flush_all won't underflow during tests. */
#if defined(HAVE_CLOCK_GETTIME) && defined(CLOCK_MONOTONIC)
		struct timespec ts;
		if (clock_gettime(CLOCK_MONOTONIC, &ts) == 0) {
			monotonic = true;
			monotonic_start = ts.tv_sec - ITEM_UPDATE_INTERVAL - 2;
		}
#endif
	}

	evtimer_set(&clockevent, clock_handler, 0);
	event_base_set(main_base, &clockevent);
	evtimer_add(&clockevent, &t);

#if defined(HAVE_CLOCK_GETTIME) && defined(CLOCK_MONOTONIC)
	if (monotonic) {
		struct timespec ts;
		if (clock_gettime(CLOCK_MONOTONIC, &ts) == -1)
			return;
		current_time = (rel_time_t) (ts.tv_sec - monotonic_start);
		return;
	}
#endif
	{
		struct timeval tv;
		gettimeofday(&tv, NULL);
		current_time = (rel_time_t) (tv.tv_sec - process_started);
	}
}//end  clock_handler

int main (int argc, char **argv) {
	int c;
	bool lock_memory = false;
	bool do_daemonize = false;
	bool preallocate = false;
	int maxcore = 0;
	char *username = NULL;
	char *pid_file = NULL;
	struct passwd *pw;
	struct rlimit rlim;
	char *buf;
	char unit = '\0';
	int size_max = 0;
	int retval = EXIT_SUCCESS;
	/* listening sockets */
	static int *l_socket = NULL;

	/* udp socket */
	static int *u_socket = NULL;
	bool protocol_specified = false;
	bool tcp_specified = false;
	bool udp_specified = false;
	enum hashfunc_type hash_type = JENKINS_HASH;
	uint32_t tocrawl;

	char *subopts;
	char *subopts_value;
	enum {
		MAXCONNS_FAST = 0,
		HASHPOWER_INIT,
		SLAB_REASSIGN,
		SLAB_AUTOMOVE,
		TAIL_REPAIR_TIME,
		HASH_ALGORITHM,
		LRU_CRAWLER,
		LRU_CRAWLER_SLEEP,
		LRU_CRAWLER_TOCRAWL
	};
	char *const subopts_tokens[] = {
		[MAXCONNS_FAST] = "maxconns_fast",
		[HASHPOWER_INIT] = "hashpower",
		[SLAB_REASSIGN] = "slab_reassign",
		[SLAB_AUTOMOVE] = "slab_automove",
		[TAIL_REPAIR_TIME] = "tail_repair_time",
		[HASH_ALGORITHM] = "hash_algorithm",
		[LRU_CRAWLER] = "lru_crawler",
		[LRU_CRAWLER_SLEEP] = "lru_crawler_sleep",
		[LRU_CRAWLER_TOCRAWL] = "lru_crawler_tocrawl",
		NULL
	};

	if (!sanitycheck()) {
		return EX_OSERR;
	}

	/* handle SIGINT */
	signal(SIGINT, sig_handler);

	//对memcached的关键设置取默认值  
	/* init settings */
	settings_init();

	/* set stderr non-buffering (for running under, say, daemontools) */
	setbuf(stderr, NULL);

	/* process arguments */
	while (-1 != (c = getopt(argc, argv,
					"a:"  /* access mask for unix socket */
					"A"  /* enable admin shutdown commannd */
					"p:"  /* TCP port number to listen on */
					"s:"  /* unix socket path to listen on */
					"U:"  /* UDP port number to listen on */
					"m:"  /* max memory to use for items in megabytes */
					"M"   /* return error on memory exhausted */
					"c:"  /* max simultaneous connections */
					"k"   /* lock down all paged memory */
					"hi"  /* help, licence info */
					"r"   /* maximize core file limit */
					"v"   /* verbose */
					"d"   /* daemon mode */
					"l:"  /* interface to listen on */
					"u:"  /* user identity to run as */
					"P:"  /* save PID in file */
					"f:"  /* factor? */
					"n:"  /* minimum space allocated for key+value+flags */
					"t:"  /* threads */
					"D:"  /* prefix delimiter? */
					"L"   /* Large memory pages */
					"R:"  /* max requests per event */
					"C"   /* Disable use of CAS */
					"b:"  /* backlog queue limit */
					"B:"  /* Binding protocol */
					"I:"  /* Max item size */
					"S"   /* Sasl ON */
					"F"   /* Disable flush_all */
					"o:"  /* Extended generic options */
					))) {
						switch (c) {
							case 'A':
								/* enables "shutdown" command */
								settings.shutdown_command = true;
								break;

							case 'a':
								/* access for unix domain socket, as octal mask (like chmod)*/
								settings.access= strtol(optarg,NULL,8);
								break;

							case 'U':
								settings.udpport = atoi(optarg);
								udp_specified = true;
								break;
							case 'p':
								settings.port = atoi(optarg);
								tcp_specified = true;
								break;
							case 's':
								settings.socketpath = optarg;
								break;
							case 'm':
								settings.maxbytes = ((size_t)atoi(optarg)) * 1024 * 1024;
								break;
							case 'M':
								settings.evict_to_free = 0;
								break;
							case 'c':
								settings.maxconns = atoi(optarg);
								break;
							case 'h':
								usage();
								exit(EXIT_SUCCESS);
							case 'i':
								usage_license();
								exit(EXIT_SUCCESS);
							case 'k':
								lock_memory = true;
								break;
							case 'v':
								settings.verbose++;
								break;
							case 'l':
								if (settings.inter != NULL) {
									size_t len = strlen(settings.inter) + strlen(optarg) + 2;
									char *p = malloc(len);
									if (p == NULL) {
										fprintf(stderr, "Failed to allocate memory\n");
										return 1;
									}
									snprintf(p, len, "%s,%s", settings.inter, optarg);
									free(settings.inter);
									settings.inter = p;
								} else {
									settings.inter= strdup(optarg);
								}
								break;
							case 'd':
								do_daemonize = true;
								break;
							case 'r':
								maxcore = 1;
								break;
							case 'R':
								settings.reqs_per_event = atoi(optarg);
								if (settings.reqs_per_event == 0) {
									fprintf(stderr, "Number of requests per event must be greater than 0\n");
									return 1;
								}
								break;
							case 'u':
								username = optarg;
								break;
							case 'P':
								pid_file = optarg;
								break;
							case 'f':
								settings.factor = atof(optarg);
								if (settings.factor <= 1.0) {
									fprintf(stderr, "Factor must be greater than 1\n");
									return 1;
								}
								break;
							case 'n':
								settings.chunk_size = atoi(optarg);
								if (settings.chunk_size == 0) {
									fprintf(stderr, "Chunk size must be greater than 0\n");
									return 1;
								}
								break;
							case 't':
								settings.num_threads = atoi(optarg);
								if (settings.num_threads <= 0) {
									fprintf(stderr, "Number of threads must be greater than 0\n");
									return 1;
								}
								/* There're other problems when you get above 64 threads.
								 * In the future we should portably detect # of cores for the
								 * default.
								 */
								if (settings.num_threads > 64) {
									fprintf(stderr, "WARNING: Setting a high number of worker"
											"threads is not recommended.\n"
											" Set this value to the number of cores in"
											" your machine or less.\n");
								}
								break;
							case 'D':
								if (! optarg || ! optarg[0]) {
									fprintf(stderr, "No delimiter specified\n");
									return 1;
								}
								settings.prefix_delimiter = optarg[0];
								settings.detail_enabled = 1;
								break;
							case 'L' :
								if (enable_large_pages() == 0) {
									preallocate = true;
								} else {
									fprintf(stderr, "Cannot enable large pages on this system\n"
											"(There is no Linux support as of this version)\n");
									return 1;
								}
								break;
							case 'C' :
								settings.use_cas = false;
								break;
							case 'b' :
								settings.backlog = atoi(optarg);
								break;
							case 'B':
								protocol_specified = true;
								if (strcmp(optarg, "auto") == 0) {
									settings.binding_protocol = negotiating_prot;
								} else if (strcmp(optarg, "binary") == 0) {
									settings.binding_protocol = binary_prot;
								} else if (strcmp(optarg, "ascii") == 0) {
									settings.binding_protocol = ascii_prot;
								} else {
									fprintf(stderr, "Invalid value for binding protocol: %s\n"
											" -- should be one of auto, binary, or ascii\n", optarg);
									exit(EX_USAGE);
								}
								break;
							case 'I':
								buf = strdup(optarg);
								unit = buf[strlen(buf)-1];
								if (unit == 'k' || unit == 'm' ||
										unit == 'K' || unit == 'M') {
									buf[strlen(buf)-1] = '\0';
									size_max = atoi(buf);
									if (unit == 'k' || unit == 'K')
										size_max *= 1024;
									if (unit == 'm' || unit == 'M')
										size_max *= 1024 * 1024;
									settings.item_size_max = size_max;
								} else {
									settings.item_size_max = atoi(buf);
								}
								if (settings.item_size_max < 1024) {
									fprintf(stderr, "Item max size cannot be less than 1024 bytes.\n");
									return 1;
								}
								if (settings.item_size_max > 1024 * 1024 * 128) {
									fprintf(stderr, "Cannot set item size limit higher than 128 mb.\n");
									return 1;
								}
								if (settings.item_size_max > 1024 * 1024) {
									fprintf(stderr, "WARNING: Setting item max size above 1MB is not"
											" recommended!\n"
											" Raising this limit increases the minimum memory requirements\n"
											" and will decrease your memory efficiency.\n"
										   );
								}
								free(buf);
								break;
							case 'S': /* set Sasl authentication to true. Default is false */
#ifndef ENABLE_SASL
								fprintf(stderr, "This server is not built with SASL support.\n");
								exit(EX_USAGE);
#endif
								settings.sasl = true;
								break;
							case 'F' :
								settings.flush_enabled = false;
								break;
							case 'o': /* It's sub-opts time! */
								subopts = optarg;

								while (*subopts != '\0') {

									switch (getsubopt(&subopts, subopts_tokens, &subopts_value)) {
										case MAXCONNS_FAST:
											settings.maxconns_fast = true;
											break;
										case HASHPOWER_INIT:
											if (subopts_value == NULL) {
												fprintf(stderr, "Missing numeric argument for hashpower\n");
												return 1;
											}
											settings.hashpower_init = atoi(subopts_value);
											if (settings.hashpower_init < 12) {
												fprintf(stderr, "Initial hashtable multiplier of %d is too low\n",
														settings.hashpower_init);
												return 1;
											} else if (settings.hashpower_init > 64) {
												fprintf(stderr, "Initial hashtable multiplier of %d is too high\n"
														"Choose a value based on \"STAT hash_power_level\" from a running instance\n",
														settings.hashpower_init);
												return 1;
											}
											break;
										case SLAB_REASSIGN:
											settings.slab_reassign = true;
											break;
										case SLAB_AUTOMOVE:
											if (subopts_value == NULL) {
												settings.slab_automove = 1;
												break;
											}
											settings.slab_automove = atoi(subopts_value);
											if (settings.slab_automove < 0 || settings.slab_automove > 2) {
												fprintf(stderr, "slab_automove must be between 0 and 2\n");
												return 1;
											}
											break;
										case TAIL_REPAIR_TIME:
											if (subopts_value == NULL) {
												fprintf(stderr, "Missing numeric argument for tail_repair_time\n");
												return 1;
											}
											settings.tail_repair_time = atoi(subopts_value);
											if (settings.tail_repair_time < 10) {
												fprintf(stderr, "Cannot set tail_repair_time to less than 10 seconds\n");
												return 1;
											}
											break;
										case HASH_ALGORITHM:
											if (subopts_value == NULL) {
												fprintf(stderr, "Missing hash_algorithm argument\n");
												return 1;
											};
											if (strcmp(subopts_value, "jenkins") == 0) {
												hash_type = JENKINS_HASH;
											} else if (strcmp(subopts_value, "murmur3") == 0) {
												hash_type = MURMUR3_HASH;
											} else {
												fprintf(stderr, "Unknown hash_algorithm option (jenkins, murmur3)\n");
												return 1;
											}
											break;
										case LRU_CRAWLER:
											if (start_item_crawler_thread() != 0) {
												fprintf(stderr, "Failed to enable LRU crawler thread\n");
												return 1;
											}
											break;
										case LRU_CRAWLER_SLEEP:
											settings.lru_crawler_sleep = atoi(subopts_value);
											if (settings.lru_crawler_sleep > 1000000 || settings.lru_crawler_sleep < 0) {
												fprintf(stderr, "LRU crawler sleep must be between 0 and 1 second\n");
												return 1;
											}
											break;
										case LRU_CRAWLER_TOCRAWL:
											if (!safe_strtoul(subopts_value, &tocrawl)) {
												fprintf(stderr, "lru_crawler_tocrawl takes a numeric 32bit value\n");
												return 1;
											}
											settings.lru_crawler_tocrawl = tocrawl;
											break;
										default:
											printf("Illegal suboption \"%s\"\n", subopts_value);
											return 1;
									}

								}
								break;
							default:
								fprintf(stderr, "Illegal argument \"%c\"\n", c);
								return 1;
						}
					}

	if (hash_init(hash_type) != 0) {
		fprintf(stderr, "Failed to initialize hash_algorithm!\n");
		exit(EX_USAGE);
	}

	/*
	 * Use one workerthread to serve each UDP port if the user specified
	 * multiple ports
	 */
	if (settings.inter != NULL && strchr(settings.inter, ',')) {
		settings.num_threads_per_udp = 1;
	} else {
		settings.num_threads_per_udp = settings.num_threads;
	}

	if (settings.sasl) {
		if (!protocol_specified) {
			settings.binding_protocol = binary_prot;
		} else {
			if (settings.binding_protocol != binary_prot) {
				fprintf(stderr, "ERROR: You cannot allow the ASCII protocol while using SASL.\n");
				exit(EX_USAGE);
			}
		}
	}

	if (tcp_specified && !udp_specified) {
		settings.udpport = settings.port;
	} else if (udp_specified && !tcp_specified) {
		settings.port = settings.udpport;
	}

	if (maxcore != 0) {
		struct rlimit rlim_new;
		/*
		 * First try raising to infinity; if that fails, try bringing
		 * the soft limit to the hard.
		 */
		if (getrlimit(RLIMIT_CORE, &rlim) == 0) {
			rlim_new.rlim_cur = rlim_new.rlim_max = RLIM_INFINITY;
			if (setrlimit(RLIMIT_CORE, &rlim_new)!= 0) {
				/* failed. try raising just to the old max */
				rlim_new.rlim_cur = rlim_new.rlim_max = rlim.rlim_max;
				(void)setrlimit(RLIMIT_CORE, &rlim_new);
			}
		}
		/*
		 * getrlimit again to see what we ended up with. Only fail if
		 * the soft limit ends up 0, because then no core files will be
		 * created at all.
		 */

		if ((getrlimit(RLIMIT_CORE, &rlim) != 0) || rlim.rlim_cur == 0) {
			fprintf(stderr, "failed to ensure corefile creation\n");
			exit(EX_OSERR);
		}
	}

	/*
	 * If needed, increase rlimits to allow as many connections
	 * as needed.
	 */

	if (getrlimit(RLIMIT_NOFILE, &rlim) != 0) {
		fprintf(stderr, "failed to getrlimit number of files\n");
		exit(EX_OSERR);
	} else {
		rlim.rlim_cur = settings.maxconns;
		rlim.rlim_max = settings.maxconns;
		if (setrlimit(RLIMIT_NOFILE, &rlim) != 0) {
			fprintf(stderr, "failed to set rlimit for open files. Try starting as root or requesting smaller maxconns value.\n");
			exit(EX_OSERR);
		}
	}

	/* lose root privileges if we have them */
	if (getuid() == 0 || geteuid() == 0) {
		if (username == 0 || *username == '\0') {
			fprintf(stderr, "can't run as root without the -u switch\n");
			exit(EX_USAGE);
		}
		if ((pw = getpwnam(username)) == 0) {
			fprintf(stderr, "can't find the user %s to switch to\n", username);
			exit(EX_NOUSER);
		}
		if (setgid(pw->pw_gid) < 0 || setuid(pw->pw_uid) < 0) {
			fprintf(stderr, "failed to assume identity of user %s\n", username);
			exit(EX_OSERR);
		}
	}

	/* Initialize Sasl if -S was specified */
	if (settings.sasl) {
		init_sasl();
	}

	/* daemonize if requested */
	/* if we want to ensure our ability to dump core, don't chdir to / */
	if (do_daemonize) {
		if (sigignore(SIGHUP) == -1) {
			perror("Failed to ignore SIGHUP");
		}
		if (daemonize(maxcore, settings.verbose) == -1) {
			fprintf(stderr, "failed to daemon() in order to daemonize\n");
			exit(EXIT_FAILURE);
		}
	}

	/* lock paged memory if needed */
	if (lock_memory) {
#ifdef HAVE_MLOCKALL
		int res = mlockall(MCL_CURRENT | MCL_FUTURE);
		if (res != 0) {
			fprintf(stderr, "warning: -k invalid, mlockall() failed: %s\n",
					strerror(errno));
		}
#else
		fprintf(stderr, "warning: -k invalid, mlockall() not supported on this platform.  proceeding without.\n");
#endif
	}

	//main_base是一个struct event_base类型的全局变量  
	/* initialize main thread libevent instance */
	main_base = event_init();

	/* initialize other stuff */
	stats_init();
	assoc_init(settings.hashpower_init);
	conn_init();
	slabs_init(settings.maxbytes, settings.factor, preallocate);

	/*
	 * ignore SIGPIPE signals; we can use errno == EPIPE if we
	 * need that information
	 */
	if (sigignore(SIGPIPE) == -1) {
		perror("failed to ignore SIGPIPE; sigaction");
		exit(EX_OSERR);
	}

	//创建settings.num_threads个worker线程，并且为每个worker线程创建一个CQ队列  
	//并为这些worker申请各自的event_base，worker线程然后进入事件循环中     
	/* start up worker threads if MT mode */
	thread_init(settings.num_threads, main_base);

	if (start_assoc_maintenance_thread() == -1) {
		exit(EXIT_FAILURE);
	}

	if (settings.slab_reassign &&
			start_slab_maintenance_thread() == -1) {
		exit(EXIT_FAILURE);
	}

	/* Run regardless of initializing it later */
	init_lru_crawler();

	/* initialise clock event */
	clock_handler(0, 0, 0);

	/* create unix mode sockets after dropping privileges */
	if (settings.socketpath != NULL) {
		errno = 0;
		if (server_socket_unix(settings.socketpath,settings.access)) {
			vperror("failed to listen on UNIX socket: %s", settings.socketpath);
			exit(EX_OSERR);
		}
	}

	//在main函数中，主线程创建了属于自己的event_base，存放在全局变量main_base中。
	//在main函数的最后，主线程调用event_base_loop进入事件循环中。
	//中间的server_sockets函数是创建一个监听客户端的socket，并将创建一个event监听该socket的可读事件。
	//下面就看一下这个函数。为了简单起见下面的代码都忽略错误处理。
	/* create the listening socket, bind it, and init */
	if (settings.socketpath == NULL) {
		const char *portnumber_filename = getenv("MEMCACHED_PORT_FILENAME");
		char temp_portnumber_filename[PATH_MAX];
		FILE *portnumber_file = NULL;

		if (portnumber_filename != NULL) {
			snprintf(temp_portnumber_filename,
					sizeof(temp_portnumber_filename),
					"%s.lck", portnumber_filename);

			portnumber_file = fopen(temp_portnumber_filename, "a");
			if (portnumber_file == NULL) {
				fprintf(stderr, "Failed to open \"%s\": %s\n",
						temp_portnumber_filename, strerror(errno));
			}
		}

		//创建监听客户端的socket  
		errno = 0;
		if (settings.port && server_sockets(settings.port, tcp_transport,
					portnumber_file)) {
			vperror("failed to listen on TCP port %d", settings.port);
			exit(EX_OSERR);
		}

		/*
		 * initialization order: first create the listening sockets
		 * (may need root on low ports), then drop root if needed,
		 * then daemonise if needed, then init libevent (in some cases
		 * descriptors created by libevent wouldn't survive forking).
		 */

		/* create the UDP listening socket and bind it */
		errno = 0;
		if (settings.udpport && server_sockets(settings.udpport, udp_transport,
					portnumber_file)) {
			vperror("failed to listen on UDP port %d", settings.udpport);
			exit(EX_OSERR);
		}

		if (portnumber_file) {
			fclose(portnumber_file);
			rename(temp_portnumber_filename, portnumber_filename);
		}
	}

	/* Give the sockets a moment to open. I know this is dumb, but the error
	 * is only an advisory.
	 */
	usleep(1000);
	if (stats.curr_conns + stats.reserved_fds >= settings.maxconns - 1) {
		fprintf(stderr, "Maxconns setting is too low, use -c to increase.\n");
		exit(EXIT_FAILURE);
	}

	if (pid_file != NULL) {
		save_pid(pid_file);
	}

	/* Drop privileges no longer needed */
	drop_privileges();

	/* enter the event loop */
	if (event_base_loop(main_base, 0) != 0) {
		retval = EXIT_FAILURE;
	}

	stop_assoc_maintenance_thread();

	/* remove the PID file if we're a daemon */
	if (do_daemonize)
		remove_pidfile(pid_file);
	/* Clean up strdup() call for bind() address */
	if (settings.inter)
		free(settings.inter);
	if (l_socket)
		free(l_socket);
	if (u_socket)
		free(u_socket);

	return retval;
}
