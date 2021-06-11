/**
 * @file ljapkt.c
 * @brief 解析网络数据包。只依赖C标准库。
 * @author LJA
 * @version 0.0.1
 * @date 2012-11-13
 */

#include  "lja_pkt.h"
#include  <assert.h>
#include  <stdio.h>
#include  <arpa/inet.h>
/**
 * @brief 打印mac地址。(实际就是打印mac处的6个字节)
 *
 * @param mac
 */
void display_mac(u_char *mac)
{
	assert(mac != NULL);

	u_int8 i;

	printf("%.2x",mac[0]);
	for(i = 1; i< 6; i++)
	{
		printf(":");
		printf("%.2x",mac[i]);
	}
	
	return ;
}

/**
 * @brief 解析链路层数据包。
 *
 * @param size  数据包大小
 * @param data  数据包开始位置
 * @param info  从数据包的链路层中解析出的网络层信息
 *
 * 测试用例: 
 *   以太网协议封装的IPV4 ARP RARP IPV6 MPLS PPPOE(discovery and Session) 802.1Q 
 *   ieee802.2/802.3封装的IPV4 ARP RARP IPV6 MPLS PPPOE(discovery and Session) 802.1Q 
 *
 */
void parse_data_linker(u_int16 size, u_char *data, net_info *info/**<[out] 解析出报文的网络层信息*/)
{
	assert(size >= 0);
	assert(data != NULL);
	assert(info != NULL);

	data_link_hdr *hdr = (data_link_hdr*)data;
	u_char* ret = NULL;

	info->data = NULL;
	info->type = NET_INVALID;
	info->size = 0;

	display_mac(hdr->dmac);
	printf(" <- ");
	printf("Src MAC: ");
	display_mac(hdr->smac);
	switch (htons(hdr->type))
	{
		case 0x0800 :  //IPv4
			printf("\n[IPv4]\t");
			info->data = data+14;
			info->type = IPV4;
			info->size = size - 18;  //6+6+2+4(dmac+smac+type+CRC)
			break;
		case 0x0806 :  //ARP
			printf("\n[ARP]\t");
			info->data = data+14;
			info->type = ARP;
			info->size = size - 18;  //6+6+2+4(dmac+smac+type+CRC)
			break;
		case 0x8035 :  //RAPP
			printf("\n[RARP]\t");
			info->data = data+14;
			info->type = RARP;
			info->size = size - 18;  //6+6+2+4(dmac+smac+type+CRC)
			break;
		case 0x86DD :  //IPv6
			printf("\n[IPv6]\t");
			info->data = data+14;
			info->type = IPV6;
			info->size = size - 18;  //6+6+2+4(dmac+smac+type+CRC)
			break;
		case 0x8847 :  //MPLS Label
			printf("\n[MPLS]\t");
			info->data = data+14;
			info->type = MPLS;
			info->size = size - 18;  //6+6+2+4(dmac+smac+type+CRC)
			break;
		case 0x8863 :  //PPPoe - Discovery
			printf("\n[PPPoe]\t");
			info->data = data+14;
			info->type = PPPOED;
			info->size = size - 18;  //6+6+2+4(dmac+smac+type+CRC)
			break;
		case 0x8864 :  //PPPoe - Session
			printf("\n[PPPoe]\t");
			info->data = data+14;
			info->type = PPPOES;
			info->size = size - 18;  //6+6+2+4(dmac+smac+type+CRC)
			break;
		case 0x8100 :  //802.1Q tag
			printf("\n[802.1Q]\t");
			info->data = data+14;
			info->type = p8021Q;
			info->size = size - 18;  //6+6+2+4(dmac+smac+type+CRC)
			break;
		default :      //IEEE802.2/802.3 rfc1084
			//TODO
			printf("\n[IEEE802.2/802.3]\t");
			parse_ieee_8022_8023(hdr->type,data+14,info);
			break;
	}
	return ;
}

/**
 * @brief 解析链路层的IEEE802.2/802.3
 *
 * @param size  IEEE802.2/802.3中的长度字段指定的长度
 * @param data  IEEE802.2/802.3数据包开始位置(长度字段以后)
 * @param info  从数据包的链路层中解析出的网络层信息
 *
 * 测试用例: 
 *   ieee802.2/802.3封装的IPV4 ARP RARP IPV6 MPLS PPPOE(discovery and Session) 802.1Q 
 */
void parse_ieee_8022_8023(u_int16 size, u_char *data, net_info *info/**<[out] 解析出报文的网络层信息*/)
{
	assert(size != 0);
	assert(data != NULL);
	assert(info != NULL);

	info->data = NULL;
	info->type = NET_INVALID;
	info->size = 0;

	ieee_8022_8023_hdr *hdr=(ieee_8022_8023_hdr *)data;
	switch (htons(hdr->type)){
		case 0x0800 :  //IPv4
			printf("[IPv4]");
			info->data = data+8;
			info->type = IPV4;
			info->size = size-8;  //ieee_8022_8033_hdr'size
			break;
		case 0x0806 :  //ARP
			printf("[ARP]");
			info->data = data+8;
			info->type = ARP;
			info->size = size-8;  //ieee_8022_8033_hdr'size
			break;
		case 0x8035 :  //RAPP
			printf("[RARP]");
			info->data = data+8;
			info->type = RARP;
			info->size = size-8;  //ieee_8022_8033_hdr'size
			break;
		case 0x86DD :  //IPv6
			printf("[IPv6]");
			info->data = data+8;
			info->type = IPV6;
			info->size = size-8;  //ieee_8022_8033_hdr'size
			break;
		case 0x8847 :  //MPLS Label
			printf("[MPLS]");
			info->data = data+8;
			info->type = MPLS;
			info->size = size-8;  //ieee_8022_8033_hdr'size
			break;
		case 0x8863 :  //PPPoe - Discovery
			printf("[PPPoe]");
			info->data = data+8;
			info->type = PPPOED;
			info->size = size-8;  //ieee_8022_8033_hdr'size
			break;
		case 0x8864 :  //PPPoe - Session
			printf("[PPPoe]");
			info->data = data+8;
			info->type = PPPOES;
			info->size = size-8;  //ieee_8022_8033_hdr'size
			break;
		case 0x8100 :  //802.1Q tag
			printf("[802.1Q]");
			info->data = data+8;
			info->type = p8021Q;
			info->size = size-8;  //ieee_8022_8033_hdr'size
			break;
		default :      //IEEE802.2/802.3 rfc1084
			printf("[Unknow]");
	}
	return ;
}

/**
 * @brief 解析网络层ipv4数据
 *
 * @param size 网络层ipv4数据包的大小
 * @param data 网络层ipv4数据包的开始位置
 * @param info 从网络层ipv4数据包中解析出的传输层信息
 */
void parse_ipv4(u_int16 size, u_char *data, tran_info *info/**<[out] 解析出报文的传输层信息*/)
{
	assert(size != 0);
	assert(data != NULL);
	assert(info != NULL);

	ipv4_hdr *hdr=(ipv4_hdr *)data;
	display_ipv4_hdr(hdr);

	info->data = NULL;
	info->size = 0;
	info->type = TRAN_INVALID;

	info->data = data + (hdr->ihl)*4;
	info->size = hdr->tot_len - (hdr->ihl)*4; //减去头部的大小

	//TODO 总过有141种（0-140）,以后根据需要逐渐添加吧 
	switch (hdr->procol)
	{
		case 0x06 :    //TCP
			info->type = TCP;
			printf("\n[TCP]\t");
			break;
		case 0x11 :    //UDP
			info->type = UDP;
			printf("\n[UDP]\t");
			break;
		default :
			printf("\n[UNKNOWN]\t");
			info->type = TRAN_INVALID;
			break;
	}
	
	return ;
}

/**
 * @brief 打印ipv4报头信息
 *
 * @param hdr ipv4_hdr*
 */
void display_ipv4_hdr(ipv4_hdr *hdr)
{
	assert(hdr != NULL);

	u_int8 option_len = hdr->ihl - 5;
	u_int16 tmp = htons(hdr->frag_off);

	printf("ver %d",hdr->ver);
	printf(" hdl %d",hdr->ihl);
	printf(" tos 0x%x",hdr->tos);
	printf(" totlen %d",htons(hdr->tot_len));
	printf(" id %d",htons(hdr->id));
	printf(" flag 0x%x",tmp>>13);
	printf(" fragoff %d*4",tmp&0x1fff);
	printf(" ttl %d",hdr->ttl);
	printf(" procol 0x%x",hdr->procol);
	printf(" check 0x%x",hdr->check);
	printf(" saddr ");
	display_ipv4_addr(&(hdr->saddr));
	printf(" daddr ");
	display_ipv4_addr(&(hdr->daddr));
	
	printf(" option ");
	u_int16 i=0;
	for(i; i<option_len*4; i++)
	{
		printf("%x",hdr->option[i]);
	}
	
	return ;
}

/**
 * @brief 打印点分形式的ipv4地址
 *
 * @param addr ipv4地址指针
 */
void display_ipv4_addr(u_int32 *addr)
{
	assert(addr != NULL);
	u_int8 *p = (u_int8*)addr;

	u_int8 i = 0;

	for(i; i<3; i++)
	{
		printf("%d",p[i]);
		printf(":");
	}
	printf("%d",p[i]);
	
	return ;
}

/**
 * @brief 打印tcp报头信息
 *
 * @param hdr tcp_hdr*
 */
void display_tcp_hdr(tcp_hdr *hdr)
{
	assert(hdr != NULL);

	printf("source %u",hdr->source);
	printf(" dest %u",hdr->dest);
	printf(" seq %u",hdr->seq);
	printf(" ackseq %u",hdr->ack_seq);
	printf(" doff %u",hdr->doff);
	printf(" cwr %u",hdr->cwr);
	printf(" ece %u",hdr->cwr);
	printf(" urg %u",hdr->cwr);
	printf(" ack %u",hdr->cwr);
	printf(" psh %u",hdr->cwr);
	printf(" rst %u",hdr->cwr);
	printf(" syn %u",hdr->cwr);
	printf(" fin %u",hdr->cwr);
	printf(" window %u",hdr->window);
	printf(" check %u",hdr->check);
	printf(" urgptr %u",hdr->urg_ptr);
	printf(" option ");
	u_char i=20;
	for(i;i<hdr->doff*4;i++){
		printf("%x",hdr->option[i]);
	}
}

/**
 * @brief 打印udp报头信息
 *
 * @param hdr udp_hdr*
 */
void display_udp_hdr(udp_hdr *hdr)
{
	assert(hdr != NULL);
	printf("source %u",hdr->source);
	printf(" dest %u",hdr->dest);
	printf(" len %u",hdr->len);
	printf(" check %u",hdr->check);
}

/**
 * @brief 解析网络层报文
 *
 * @param netinfo  传入的网络层信息
 * @param traninfo 传出的传输层信息
 */
void parse_net(net_info *netinfo/**<[in]网络层报文信息*/, tran_info *traninfo/**<[out] 解析出的传输层报文信息*/)
{
	assert(netinfo != NULL);
	assert(traninfo != NULL);

	traninfo->data = NULL;
	traninfo->type = TRAN_INVALID;
	traninfo->size = 0;

	switch (netinfo->type)
	{
		case NET_INVALID: //TODO
			break;
		case IPV4 :  //!IPV4    0x0800
			parse_ipv4(netinfo->size,netinfo->data,traninfo);
			break;
		case ARP  :  //!ARP     0x0806
			break;
		case RARP :  //!RARP    0x8035
			break;
		case IPV6 :  //!IPV6    0x86DD
			break;
		case MPLS :  //!MPLS    0x8847
			break;
		case PPPOED: //!PPPoE   0x8863 - Discovery
			break;
		case PPPOES: //!PPPoE   0x8864 - Session
			break;
		case p8021Q:  //!802.1Q  0x8100
			break;
		case NET_MAX: //TODO
			break;
		default :
			break;
	}
	return ;
}

/**
 * @brief 解析传输层数据
 *
 * @param traninfo 传入的传输层信息
 * @param appinfo  传出的应用层信息
 */
void parse_tran(tran_info *traninfo/**<[in] 传输层报文信息*/, app_info *appinfo/**<[out] 解析出的应用层报文信息*/)
{
	assert(traninfo != NULL);
	assert(appinfo != NULL);

	appinfo->data = NULL;
	appinfo->type = APP_INVALID;
	appinfo->size = 0;

	switch (traninfo->type)
	{
		case TCP :
			parse_tcp(traninfo->size, traninfo->data,appinfo);
			break;
		case UDP :
			parse_udp(traninfo->size, traninfo->data,appinfo);
			break;
		default :
			break;
	}

	return ;
}

/**
 * @brief 解析传输层tcp数据
 *
 * @param size 传输层tcp数据包的大小 
 * @param data 传输层tcp数据包的开始位置
 * @param info 从传输层tcp数据包中解析出的应用层信息
 */
void parse_tcp(u_int16 size, u_char *data, app_info *info)
{
	assert(size != 0);
	assert(data != NULL);
	assert(info != NULL);

	tcp_hdr *hdr = (tcp_hdr*)data;
	display_tcp_hdr(hdr);

	info->data = NULL;
	info->type = APP_INVALID;
	info->size = 0;

	info->data = data + hdr->doff*4;
	info->size = size - hdr->doff*4;

	/*
		TODO: 获取应用层的协议类型
		方案1: 跟据端口判断
		方案2: 扫描报文内容
		方案3: 建立状态机
	*/
	
	return ;
}

/**
 * @brief 解析传输层udp数据
 *
 * @param size 传输层udp数据包的大小 
 * @param data 传输层udp数据包的开始位置
 * @param info 从传输层udp数据包中解析出的应用层信息
 */
void parse_udp(u_int16 size, u_char *data, app_info *info)
{
	assert(size != 0);
	assert(data != NULL);
	assert(info != NULL);

	udp_hdr *hdr=(udp_hdr*)data;
	display_udp_hdr(hdr);

	info->data = NULL;
	info->type = APP_INVALID;
	info->size = 0;

	info->data = data + 8;
	info->size = hdr->len;

	/*
		TODO: 获取应用层的协议类型
		方案1: 跟据端口判断
		方案2: 扫描报文内容
		方案3: 建立状态机
	*/

	return ;
}

