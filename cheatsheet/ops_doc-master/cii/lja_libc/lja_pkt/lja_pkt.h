/**
 * @file lja_pkt.h
 * @brief 解析网络数据包。只依赖C标准库。
 * @author LJA
 * @version 0.0.1
 * @date 2012-11-13
 */
#ifndef LJA_PKT_H
#define LJA_PKT_H
#include  "lja_type.h"

/**
 * @brief 网络层协议类型
 */
typedef enum{
	NET_INVALID,
	IPV4 ,  //!IPV4    0x0800
	ARP  ,  //!ARP     0x0806
	RARP ,  //!RARP    0x8035
	IPV6 ,  //!IPV6    0x86DD
	MPLS ,  //!MPLS    0x8847
	PPPOED, //!PPPoE   0x8863 - Discovery
	PPPOES, //!PPPoE   0x8864 - Session
	p8021Q,  //!802.1Q  0x8100
	NET_MAX
}net_procol;

/**
 * @brief 传输层协议类型
 */
typedef enum{
	TRAN_INVALID,
	TCP ,  //!TCP  0x06
	UDP ,  //!UDP  0x11
	TRAN_MAX
}tran_procol;

/**
 * @brief 应用层协议类型
 */
typedef enum{
	APP_INVALID,
	HTTP ,        //!HTTP
	APP_UNKNOWN,  //!未知的应用层协议
	APP_MAX
}app_procol;

/**
 * @brief 数据链路层头
 */
typedef struct{
	u_char   dmac[6];  //!目的MAC
	u_char   smac[6];  //!源 MAC
	u_int16  type;     //!对于以太网是网络层类型,对于IEE802.2/IEE802.3是长度
}data_link_hdr;

/**
 * @brief IEEE802.2和802.3添加的内容
 */
typedef struct{
	u_char dsap;   //!目的服务访问点(Destination Service Access Point)
	u_char ssap;   //!源服务访问点(Source Service Access Point)
	u_char ctrl;   //!ctrl
	u_char org[3]; //!org code
	u_int16 type;  //!网络层类型
}ieee_8022_8023_hdr;

/**
 * @brief IPv4报文头
 */
typedef struct{
#if LJA_BIG_ENDIAN
	u_int8 ver:4; //!版本号
	u_int8 ihl:4; //!头部长度，计数单位为4byte，不得低于20byte
#elif LJA_LITTLE_ENDIAN
	u_int8 ihl:4;    //!IP头部长度，计数单位为4byte，不得低于20byte
	u_int8 ver:4;    //!版本号
#endif

	u_int8  tos;      //!服务类型（type of service)
	u_int16 tot_len;  //!IP报文长度,计数单位为1byte
	u_int16 id;       //!IP报文id(identification)
	u_int16 frag_off; //!分片的偏移，以4byte为单位标志位，前三位是标志位[保留] [是否分片] [是否最后一个分片]
	u_int8  ttl;      //!ttl
	u_int8  procol;   //!传输层协议
	u_int16 check;    //!ip头部校验和
	u_int32 saddr;    //!源地址
	u_int32 daddr;    //!目的地址
	u_char option[0]; //!Options
}ipv4_hdr;

/**
 * @brief TCP报头
 */
typedef struct{
	u_int16 source;   //!源端口
	u_int16 dest;     //!目的端口
	u_int32 seq;      //!TCP报文中第一个序列号
	u_int32 ack_seq;  //!确认序列号,ack_seq之前的数据已经被接收
#if LJA_BIG_ENDIAN
	u_int16 doff:4;   //!TCP报头长度，计数单位是4byte，也是TCP数据部分相对报头开始出的偏移
	u_int16 res1:4;   //!保留标志位
	u_int16 cwr:1;    //!通知接收端已经收到了设置ECE标志的ACK
	u_int16 ece:1;    //!
	u_int16 urg:1;    //!是否有紧急指针
	u_int16 ack:1;    //!是否确认序列号
	u_int16 psh:1;    //!是否直接推送到应用程序
	u_int16 rst:1;    //!是否重建连接
	u_int16 syn:1;    //!建立连接
	u_int16 fin:1;    //!终止连接
#elif LJA_LITTLE_ENDIAN
	u_int16 res1:4;   //!保留标志位
	u_int16 doff:4;   //!TCP报头长度，计数单位是4byte，也是TCP数据部分相对报头开始出的偏移
	u_int16 fin:1;    //!终止连接
	u_int16 syn:1;    //!建立连接
	u_int16 rst:1;    //!是否重建连接
	u_int16 psh:1;    //!是否直接推送到应用程序
	u_int16 ack:1;    //!是否确认序列号
	u_int16 urg:1;    //!是否有紧急指针
	u_int16 ece:1;    //!
	u_int16 cwr:1;    //!通知接收端已经收到了设置ECE标志的ACK
#endif
	u_int16 window;   //!发送方的窗口大小,8bit为单位
	u_int16 check;    //!校验码
	u_int16 urg_ptr;  //!紧急指针,紧临着紧急数据的第一个非紧急数据相对于序列号的正偏移
	u_char option[0]; //!options
}tcp_hdr;

/**
 * @brief UDP报头
 */
typedef struct{
	u_int16 source;   //!源端口
	u_int16 dest;     //!目的端口
	u_int16 len;      //!整个upd报文的长度
	u_int16 check;    //!校验码
}udp_hdr;

/**
 * @brief 从数据链路层解析出的网络层信息 
 */
typedef struct{
	u_char *data;     //!网络层开始的数据 
	net_procol type;  //!网络层协议类型
	u_int16 size;     //!网络层数据大小
}net_info;

/**
 * @brief 从网络层解析出的传输层信息
 */
typedef struct{
	u_char *data;       //!传输层开始的数据 
	tran_procol type;   //!传输层协议类型
	u_int16 size;       //!传输层数据大小
}tran_info;

/**
 * @brief 从传输层解析出的应用层信息
 */
typedef struct{
	u_char *data;       //!应用层开始的数据
	tran_procol type;   //!应用层协议类型
	u_int16 size;       //!应用层数据大小
}app_info;
/**
 * @brief 打印mac地址。(实际就是打印mac处的6个字节)
 *
 * @param mac
 */
void display_mac(u_char *mac);

/**
 * @brief 打印ipv4报头信息
 *
 * @param hdr ipv4_hdr*
 */
void display_ipv4_hdr(ipv4_hdr *hdr);

/**
 * @brief 打印点分形式的ipv4地址
 *
 * @param addr ipv4地址指针
 */
void display_ipv4_addr(u_int32 *addr);

/**
 * @brief 打印tcp报头信息
 *
 * @param hdr tcp_hdr*
 */
void display_tcp_hdr(tcp_hdr *hdr);

/**
 * @brief 打印udp报头信息
 *
 * @param hdr udp_hdr*
 */
void display_udp_hdr(udp_hdr *hdr);

/**
 * @brief 解析链路层数据包。
 *
 * @param size  链路层数据包大小
 * @param data  链路层数据包的开始位置
 * @param info  从链路层数据包中解析出的网络层信息
 *
 */
void parse_data_linker(u_int16 size, u_char *data, net_info *info/**<[out] 解析出报文的网络层信息*/);

/**
 * @brief 解析网络层报文
 *
 * @param netinfo  传入的网络层信息
 * @param traninfo 传出的传输层信息
 */
void parse_net(net_info *netinfo/**<[in]网络层报文信息*/, tran_info *taninfo/**<[out] 解析出的传输层报文信息*/);

/**
 * @brief 解析链路层的IEEE802.2/802.3
 *
 * @param size  IEEE802.2/802.3中的长度字段指定的长度
 * @param data  IEEE802.2/802.3数据包开始位置(长度字段以后)
 * @param info  从链路层数据包中解析出的网络层信息
 */
void parse_ieee_8022_8023(u_int16 size, u_char *data, net_info *info/**<[out] 解析出报文的网络层信息*/);

/**
 * @brief 解析网络层ipv4数据
 *
 * @param size 网络层ipv4数据包的大小
 * @param data 网络层ipv4数据包的开始位置
 * @param info 从网络层ipv4数据包中解析出的传输层信息
 */
void parse_ipv4(u_int16 size, u_char *data, tran_info *info/**<[out] 解析出报文的传输层信息*/);

/**
 * @brief 解析传输层数据
 *
 * @param traninfo 传入的传输层信息
 * @param appinfo  传出的应用层信息
 */
void parse_tran(tran_info *traninfo/**<[in] 传输层报文信息*/, app_info *appinfo/**<[out] 解析出的应用层报文信息*/);

/**
 * @brief 解析传输层tcp数据
 *
 * @param size 传输层tcp数据包的大小 
 * @param data 传输层tcp数据包的开始位置
 * @param info 从传输层tcp数据包中解析出的应用层信息
 */
void parse_tcp(u_int16 size, u_char *data, app_info *info);

/**
 * @brief 解析传输层udp数据
 *
 * @param size 传输层udp数据包的大小 
 * @param data 传输层udp数据包的开始位置
 * @param info 从传输层udp数据包中解析出的应用层信息
 */
void parse_udp(u_int16 size, u_char *data, app_info *info);
#endif
