/**
 * @file ljapcap.c
 * @brief 对pcap的实用封装。依赖pcap-1.3.0
 * @author LJA
 * @version 0.0.1
 * @date 2012-11-12
 */

#include  "lja_pcap.h"
#include  <arpa/inet.h>
/**
 * @brief 打印设备列表
 *
 * @param devs pcap_if_t
 * @return 设备的数目
 */
int display_devs(pcap_if_t *devs)
{
	assert(devs != NULL);
	pcap_if_t *d;
	
	int i=0;
	for( d=devs ; d != NULL ; d=d->next )
	{
		printf("%d. %s",++i, d->name);
		if(NULL != d->description){
			printf(" (%s)\n", d->description);
		}else{
			printf(" (No description)\n");
		}
	}
	return i;
}

/**
 * @brief 打印一个设备信息
 *
 * @param dev 
 *
 */
void  display_dev(pcap_if_t *dev)
{
	assert(dev != NULL);

	printf("%s",dev->name);
	if(NULL != dev->description){
		printf(" (%s)\n", dev->description);
	}else{
		printf(" (No description)\n");
	}
	return ;
}

/**
 * @brief 打印pcap报文头
 *
 * @param hdr
 */
void display_pcap_pkthdr(struct pcap_pkthdr *hdr)
{
	assert(hdr != NULL);
	printf("%ld.%ld: %u of %u",hdr->ts.tv_sec,hdr->ts.tv_usec,hdr->caplen,hdr->len);
	return ;
}

/**
 * @brief 打印pcap捕获的数据包的内容
 *
 * @param hdr 捕获的包的pcap头
 * @param data 捕获的报文数据
 */
void display_pcap_data(struct pcap_pkthdr *hdr, const u_char *data)
{
	assert(hdr != NULL);
	assert(data != NULL);
	int i;
	for (i= 0; i < hdr->caplen; i++)
	{
		printf("%.2x",data[i]);
	}
	return ;
}

