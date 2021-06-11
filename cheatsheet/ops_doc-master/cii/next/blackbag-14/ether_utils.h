#ifndef _ETHER_UTILS_H
#define _ETHER_UTILS_H

#ifdef __linux__
#define ETHERTYPE_VLAN 0x8100
#define ETHERTYPE_LOOPBACK 0x9000
#endif

int pcap_ether_dloff(pcap_t *pd);
int ether_dloff(int dlink);
u_char *link_to_ip(int dlt, u_char *pkt, size_t len);

#endif
