udp_sendmsg函数调用udp_push_pending_frams把数据封装成UDP包，
调用ip_route_output_flow函数来查询路由信息，为数据包确定出口信息。
最后：udp_send用ip_push_pending_frames把数据包交给IP层协议模块。


ip_local_deliver_finsh函数调用udp_rcv把数据包交给UDP协议模块。去掉UDP协议信息后，
udp_rcv调用udp_queue_rcv_skb和sock_queue_rcv_skb把数据包插到套接字队列中。
最后：udp_recvmsg从该队列中取出数据包，并通知应用程序的接收函数读取数据。

ip_append_data(对数据包进行分片)
{
如果说ip_append_data()只是UDP套接字和RAW套接字的输出接口，也不完全正确，           
因为在TCP中用于发送ACK和RST包的函数ip_send_reply()最终也调用了该函数。             
ip_append_data()是一个比较复杂的函数，主要是将接收到的大数据包分成                 
多个小于或等于MTU的SKB，为网络层要实现的IP分片做准备。例如，假设待发送             
的数据包大小为4000B，先前输出队列非空，且最后一个SKB还未填满，剩余500B。           
这时传输层调用ip_append_data(),则首先会将有剩余空间的SKB填满。当网络设备           
支持聚合分散I/O时，便会将数据写到frags指向的页面中，如果相关的页面已经填满，       
则会再分配一个新的页面。接着，进入下次循环，每次循环都分配一个SKB，                
通过getfrag将数据从传输层复制数据，并将其添加到输出队列的末尾，直至                
复制完所有待输出的数据。                                                           
ip_append_data()在多处被调用，包括UDP、TCP、RAW套接字以及ICMP。因此在复制数据      
时，有时复制传输层负载部分，传输层首部会后续添加(UDP),有时则需要复制包括           
传输层首部的的全部数据(ICMP).参数说明如下：
                                        
@sk：输出数据的传输控制块。该传输控制块还提供一些其他信息，如IP选项等。            
@getfrag：用于复制数据到SKB中。不同的传输层，由于特性不同，因此对应复制的          
          方法也不一样。该接口的参数说明如下：                                     
          1.from：标识待复制数据存储的位置                                         
          2.to：标识数据待复制到的目的地                                           
          3.offset：待复制数据在数据存储位置的偏移，数据从此位置开始复制           
          4.len：待复制数据的长度。                                                
          5.odd：从上一个SKB中剩余下来并复制到此SKB中的数据长度。如果为奇数，      
                 则后续数据的校验和计算时的16位数据的高8位和低8位的值是颠倒的，    
                 因此需要将后续数据的校验和高低8位对调。                           
         6.skb：复制数据的SKB，计算得到的数据部分的校验和暂存到SKB中，为计算       
                完成的传输层校验和做准备。                                         
         UDP和RAW为ip_generic_getfrag()，TCP为ip_reply_glue_bits()，ICMP为         
         icmp_glue_bits(),复制轻量级UDP的数据时为udplite_getfrag().                
@from：输出数据所在的数据块地址，它指向用户空间或内核空间，该参数为传递给          
       getfrag()接口                                                               
@length:输出数据的长度                                                             
@transhdrlen：传输层首部长度                                                       
@ipc：传递到IP层的临时信息块                                                       
@rt：输出该数据的路由缓存项，在调用此函数之前由传输控制块已经缓存路由缓存          
     项或者已经通过ip_route_output_flow()查找到了输出数据的路由缓存项              
@flags：输出数据的一些标志，如MSG_MORE等。     



函数ip_append_data的主要任务是创建套接字缓冲区，为IP层数据分片做好准备。该函数根据路由查询得到的接口MTU，把超过MTU
长度的数据分片保存在多个套接字缓冲区中，并插入套接字的sk_write_queue中。对于较大的数据包，该函数可能循环执行多次。                                    

}

ip_cmsg_send(msghdr->control控制数据处理)
{
UDP套接字和RAW套接字在通过sendmsg系统调用  
输出数据时，会检测消息头中是否存在控制     
信息，如果存在，则调用ip_cmsg_send()将控制 
信息获取到一个IP控制信息块中。             
@msg:输出数据的消息头，包括控制信息等      
@ipc: 用来保存控制信息的临时消息块。       

}

ip_ufo_append_data()
{
实现复制数据到输出队列末尾那个SKB的聚合分散I/O页面中
}

udp_push_pending_frames(udp数据传输)
{
函数udp_push_pending_frames被udp_sendmsg调用，用于数据传输，该函数为数据包添加UDP头部，
然后调用ip_push_pending_frames发送数据包。
}

ip_push_pending_frames(ip数据传输)
{
将输出队列上的多个分片合成一个完整的IP数据包，并通过ip_output()输出  


}

udp_queue_rcv_skb(把收到的套接字缓冲区skb插入套接字sk的接收队列中)
{}
sock_queue_rcv_skb(把收到的套接字缓冲区skb插入套接字sk->sk_receive_queue的尾部){}

ip_cmsg_recv()
{

用户获取报文控制信息，在UDP套接字和RAW套接字的recvmsg例程中，当设置了IP_PKTINFO
等报文控制信息相关的套接字选项后，无论是接收错误洗洗还是正常的数据，都会被
调用。在获取每一种报文控制信息前，会将报文控制信息标志向右移位，然后根据
标志检测是否需要获取对应的报文控制信息。参数说明如下:
@msg: 用来读取数据信息头
@skb:用来接收错误信息或正常数据的报文

}