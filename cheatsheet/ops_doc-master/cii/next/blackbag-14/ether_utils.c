#include "firebert.h" 
#include <pcap.h>

#ifdef __OpenBSD__
#include <queue.h>
#include <net/if.h>
#include <net/if_arp.h>
#include <netinet/if_ether.h>
#else
#include <net/ethernet.h>
#endif

#include "ether_utils.h"

#define ETHERTYPE_ISL		ETHERMTU - 1
#define HEADER_LEN_ISL		26
#define HEADER_LEN_8021Q	4

/* ------------------------------------------------------------ */

static int
_dloff(int i) 
{
  switch (i) {
  case DLT_EN10MB:
    i = 14;
    break;
  case DLT_IEEE802:
    i = 22;
    break;
  case DLT_FDDI:
    i = 21;
    break;
  case DLT_LOOP:
  case DLT_NULL:
    i = 4;
    break;
  case ETHERTYPE_ISL:
	i=26;
	break;
  case DLT_RAW:
	i=0;
	break;
  default:
    i = -1;
    break;
  }
  return (i);
}

/* ------------------------------------------------------------ */
                        
int             
pcap_ether_dloff(pcap_t *pd) 
{
  return (_dloff(pcap_datalink(pd)));
}

/* ------------------------------------------------------------ */

int
ether_dloff(int dlink)
{
  return (_dloff(dlink));
}
/* ----------------------------------------------------------- */

u_char *link_to_ip(int dlink, u_char *packet, size_t len)
{
	// XXX verify that we can trust DLT
	// consider: VLAN tags mixed with regular traffic
	u_char *ip = NULL;
	switch(dlink) {
	case DLT_EN10MB:
		{
			const struct ether_header *ep = (const struct ether_header*) packet;
			const u_char *hd = (u_char*)packet;
			int proto = ntohs(ep->ether_type);
			/*
			 * deal with (gag) 802.3
			 */
			if (proto <= ETHERMTU) {
				/* Can only tell if it's an ISL frame if dest addr is
				   01-00-0C-00-00.  ISL header is placed before ethernet
				   header. :( */
				if ((hd[0] == 0x1) && (hd[1] == 0x0) && (hd[2] == 0xC)
				    && (hd[3] == 0x0) && (hd[4] == 0x0)) {
					proto = ETHERTYPE_ISL;
				} else
				        proto = ntohs((&ep->ether_type)[1]);
			} else
				proto = DLT_EN10MB;

			ip = packet + _dloff(proto);

			if(proto == ETHERTYPE_VLAN)
				ip += 8; // XXX don't hardcode.  make sure this is true with vlans
			break;
		}
	case DLT_LOOP:
		ip = packet + _dloff(ETHERTYPE_LOOPBACK);
		break;
	case DLT_RAW:
		ip = packet + _dloff(DLT_RAW);
	}	

	return(ip);		      
}

