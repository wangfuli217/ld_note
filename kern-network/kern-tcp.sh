UGR 指示数据包的紧急指针有效
ACK 表示已经正确接受了确认好之前的字节
PSH 表示接收方应马上将数据上传至应用层
RST 用于复位主机崩溃等原因导致的错误链接，拒绝非法的数据或连接请求
SYN 用于连接同步，请求或请求确认连接的建立
FIN 释放已建立的连接

tcp_sendmsg函数分三种情况调用tcp_push tcp_one_push和__tcp_push_pending_frames.这些函数
再调用tcp_transmit_skb来完成TCP协议处理，封装TCP包。最后，tcp_transmit_skb调用ip_queue_xmit
把TCP包交给IP层协议模块。

从IP包取出数据后，IP协议模块的ip_local_deliver_finish函数调用tcp_v4_rcv把数据包递交到TCP协议模块。
完成TCP协议处理后，tcp_v4_rcv调用tco_v4_do_rcv来处理收到的数据，根据接收情形，tcp_v4_do_rcv分别调用
tcp_rcv_established和tcp_rcv_state_process来进一步处理。
其中tcp_rcv_established直接把接收到的数据包插入套接字接收队列中，
而tcp_rcv_state_process根据当前状态按照TCP协议状态机来工作，并把数据插入套接字队列，最后
tcp_recvmsg从队列中取出数据包，并通知应用程序的接收函数从内核读取数据。

tcphdr() {
      /* 源端口号*/
	__be16	source;
      /* 目的端口号*/
	__be16	dest;
      /*
       * 序列号，它指定了TCP分组在数据流
       * 中的位置，在数据丢失需要重新传输
       * 时很重要
       */
	__be32	seq;
      /* 序列号，在确认收到TCP分组时使用 */
	__be32	ack_seq;
#if defined(__LITTLE_ENDIAN_BITFIELD)
      /* 
       * 控制标志，用于检查、建立和结束连接
       * TCP首部中保留的6位应该是指res1、ece和cwr
       * 三个成员
       */
	__u16	res1:4,
		doff:4,  /* 
		             * 数据偏移量(架构上的描述)并指定了TCP首部结构
		             * 的长度,4字节为单位
		             */
		fin:1, 
		syn:1,  /* 同步*/
		rst:1,   /* 重置*/
		psh:1, /* 用来通知对方尽快接收的标志位*/
		ack:1, /* 确认*/
		urg:1, /* 紧急*/
		/*
		 * TCP对ECN的支持使用TCP中预先定义的保留位。ECE和CWR。
		 */
		/*
		 * ECE，ECE响应标志被用来在TCP三次握手时标明一个TCP
		 * 端是支持ECN功能的，并且表明接收到的TCP段的IP首部
		 * 的ECN被设置为11.
		 */
		ece:1,
		/*
		 * CWR: 拥塞窗口减小标志由发送主机设置，用来表明它
		 * 接收到了设置ECE标志的TCP段。
		 */
		cwr:1;
#elif defined(__BIG_ENDIAN_BITFIELD)
	__u16	doff:4,
		res1:4,
		cwr:1,
		ece:1,
		urg:1,
		ack:1,
		psh:1,
		rst:1,
		syn:1,
		fin:1;
#else
#error	"Adjust your <asm/byteorder.h> defines"
#endif	
       /* 
        * 告诉连接的另一方，在接收方的缓冲区满
        * 之前，可以发送多少字节。这用于快速的
        * 发送方与低速接收方通信时防止数据的积
        * 压
        */
	__be16	window;
      /* 分组的校验和*/
	__sum16	check;
      /* 
       * 紧急指针,其实是一个偏移量.当urg位
       * 被设置，表示包含紧急数据，
       * 该偏移量必须与TCP首部中的序号
       * 字段相加，以便得出紧急数据的
       * 最后一个字节的序号
       */
	__be16	urg_ptr;
};

tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
{
在套接字层检测完必要条件，如套接字的状态等之后，传输接口层中还需对传输控制块进行更详细的校验，如地址族的
类型，是否获取到有效的路由入口。通过检测后设置传输控制块各字段值，如初始化时间戳，保存目的地址和目的端口
等，最后构造并发送SYN段。

}


tcp_connect(struct sock *sk)
{tcp_connect()用来构造并发送一个SYN段。}