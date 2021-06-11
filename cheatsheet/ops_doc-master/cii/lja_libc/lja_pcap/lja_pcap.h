/**
 * @file lja_pcap.h
 * @brief 对pcap的实用封装。依赖pcap-1.3.0
 * @author LJA
 * @version 0.0.1
 * @date 2012-11-12
 */

#ifndef LJA_PCAP_H
#define LJA_PCAP_H

#include  <assert.h>
#include  <pcap/pcap.h>

/**
 * @brief 打印设备列表
 *
 * @param devs pcap_if_t
 * @return 设备的数目
 */
int display_devs(pcap_if_t *devs);

/**
 * @brief 打印一个设备信息
 *
 * @param dev 
 *
 */
void displcay_dev(pcap_if_t *dev);

/**
 * @brief 打印pcap报文头
 *
 * @param hdr
 */
void display_pcap_pkthdr(struct pcap_pkthdr *hdr);

/**
 * @brief 打印pcap捕获的数据包的内容
 *
 * @param hdr 捕获的包的pcap头
 * @param data 捕获的报文数据
 */
void display_pcap_data(struct pcap_pkthdr *hdr, const u_char *data);

#endif

