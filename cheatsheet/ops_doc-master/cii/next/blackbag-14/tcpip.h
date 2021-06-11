#ifndef TCPIP_INCLUDE
#define TCPIP_INCLUDE

struct ip_h {
         u_int   ip_v:4,                 /* version */
                 ip_hl:4;                /* header length */
       
	u_char  ip_tos;                 /* type of service */
	u_short ip_len;                 /* total length */
	u_short ip_id;                  /* identification */
	u_short ip_off;                 /* fragment offset field */
	u_char  ip_ttl;                 /* time to live */
	u_char  ip_p;                   /* protocol */
	u_short ip_sum;                 /* checksum */
	u_int   ip_src;
	u_int   ip_dst;
};

struct tcp_h {
	u_short th_sport;
	u_short th_dport;
	u_int   th_seq;
	u_int   th_ack;
	u_int   th_off:4,
	        th_x2:4;
	u_char  th_flags;
	u_short th_win;
	u_short th_sum;
	u_short th_urp;        
};

struct udp_h {
	u_short uh_sport;
	u_short uh_dport;
	u_short uh_ulen;
	u_short uh_sum;
};

struct icmp_h { 
	u_char icmp_type;
	u_char icmp_code;
	u_short icmp_sum;
};

#ifdef _IP_VHL
#define	IP_MAKE_VHL(v, hl)	((v) << 4 | (hl))
#define	IP_VHL_HL(vhl)		((vhl) & 0x0f)
#define	IP_VHL_V(vhl)		((vhl) >> 4)
#define	IP_VHL_BORING		0x45
#endif

#define	IP_MAXPACKET	65535		/* maximum packet size */

/*
 * Definitions for IP type of service (ip_tos)
 */
#define	IPTOS_LOWDELAY		0x10
#define	IPTOS_THROUGHPUT	0x08
#define	IPTOS_RELIABILITY	0x04
#define	IPTOS_MINCOST		0x02
/* ECN bits proposed by Sally Floyd */
#define	IPTOS_CE		0x01	/* congestion experienced */
#define	IPTOS_ECT		0x02	/* ECN-capable transport */


/*
 * Definitions for IP precedence (also in ip_tos) (hopefully unused)
 */
#define	IPTOS_PREC_NETCONTROL		0xe0
#define	IPTOS_PREC_INTERNETCONTROL	0xc0
#define	IPTOS_PREC_CRITIC_ECP		0xa0
#define	IPTOS_PREC_FLASHOVERRIDE	0x80
#define	IPTOS_PREC_FLASH		0x60
#define	IPTOS_PREC_IMMEDIATE		0x40
#define	IPTOS_PREC_PRIORITY		0x20
#define	IPTOS_PREC_ROUTINE		0x00

/*
 * Definitions for options.
 */
#define	IPOPT_COPIED(o)		((o)&0x80)
#define	IPOPT_CLASS(o)		((o)&0x60)
#define	IPOPT_NUMBER(o)		((o)&0x1f)

#define	IPOPT_CONTROL		0x00
#define	IPOPT_RESERVED1		0x20
#define	IPOPT_DEBMEAS		0x40
#define	IPOPT_RESERVED2		0x60

#define	IPOPT_EOL		0		/* end of option list */
#define	IPOPT_NOP		1		/* no operation */

#define	IPOPT_RR		7		/* record packet route */
#define	IPOPT_TS		68		/* timestamp */
#define	IPOPT_SECURITY		130		/* provide s,c,h,tcc */
#define	IPOPT_LSRR		131		/* loose source route */
#define	IPOPT_SATID		136		/* satnet id */
#define	IPOPT_SSRR		137		/* strict source route */
#define	IPOPT_RA		148		/* router alert */

/*
 * Offsets to fields in options other than EOL and NOP.
 */
#define	IPOPT_OPTVAL		0		/* option ID */
#define	IPOPT_OLEN		1		/* option length */
#define IPOPT_OFFSET		2		/* offset within option */
#define	IPOPT_MINOFF		4		/* min value of above */

/*
 * Time stamp option structure.
 */
struct	ip_timestamp {
	u_char	ipt_code;		/* IPOPT_TS */
	u_char	ipt_len;		/* size of structure (variable) */
	u_char	ipt_ptr;		/* index of current entry */
#if BYTE_ORDER == LITTLE_ENDIAN
	u_int	ipt_flg:4,		/* flags, see below */
		ipt_oflw:4;		/* overflow counter */
#endif
#if BYTE_ORDER == BIG_ENDIAN
	u_int	ipt_oflw:4,		/* overflow counter */
		ipt_flg:4;		/* flags, see below */
#endif
	union ipt_timestamp {
		u_int32_t	ipt_time[1];
		struct	ipt_ta {
			struct in_addr ipt_addr;
			u_int32_t ipt_time;
		} ipt_ta[1];
	} ipt_timestamp;
};

/* flag bits for ipt_flg */
#define	IPOPT_TS_TSONLY		0		/* timestamps only */
#define	IPOPT_TS_TSANDADDR	1		/* timestamps and addresses */
#define	IPOPT_TS_PRESPEC	3		/* specified modules only */

/* bits for security (not byte swapped) */
#define	IPOPT_SECUR_UNCLASS	0x0000
#define	IPOPT_SECUR_CONFID	0xf135
#define	IPOPT_SECUR_EFTO	0x789a
#define	IPOPT_SECUR_MMMM	0xbc4d
#define	IPOPT_SECUR_RESTR	0xaf13
#define	IPOPT_SECUR_SECRET	0xd788
#define	IPOPT_SECUR_TOPSECRET	0x6bc5

/*
 * Internet implementation parameters.
 */
#define	MAXTTL		255		/* maximum time to live (seconds) */
#define	IPDEFTTL	64		/* default ttl, from RFC 1340 */
#define	IPFRAGTTL	60		/* time to live for frags, slowhz */
#define	IPTTLDEC	1		/* subtracted when forwarding */

#define	IP_MSS		576		/* default maximum segment size */

/*
 * Protocols (RFC 1700)
 */
#ifndef __linux__ 
#ifndef __OpenBSD__
#define	IPPROTO_IP		0		/* dummy for IP */
#define	IPPROTO_HOPOPTS	0		/* IP6 hop-by-hop options */
#define	IPPROTO_ICMP		1		/* control message protocol */
#define	IPPROTO_IGMP		2		/* group mgmt protocol */
#define	IPPROTO_GGP		3		/* gateway^2 (deprecated) */
#define IPPROTO_IPV4		4 		/* IPv4 encapsulation */
#define IPPROTO_IPIP		IPPROTO_IPV4	/* for compatibility */
#define	IPPROTO_TCP		6		/* tcp */
#define	IPPROTO_ST		7		/* Stream protocol II */
#define	IPPROTO_EGP		8		/* exterior gateway protocol */
#define	IPPROTO_PIGP		9		/* private interior gateway */
#define	IPPROTO_RCCMON		10		/* BBN RCC Monitoring */
#define	IPPROTO_NVPII		11		/* network voice protocol*/
#define	IPPROTO_PUP		12		/* pup */
#define	IPPROTO_ARGUS		13		/* Argus */
#define	IPPROTO_EMCON		14		/* EMCON */
#define	IPPROTO_XNET		15		/* Cross Net Debugger */
#define	IPPROTO_CHAOS		16		/* Chaos*/
#define	IPPROTO_UDP		17		/* user datagram protocol */
#define	IPPROTO_MUX		18		/* Multiplexing */
#define	IPPROTO_MEAS		19		/* DCN Measurement Subsystems */
#define	IPPROTO_HMP		20		/* Host Monitoring */
#define	IPPROTO_PRM		21		/* Packet Radio Measurement */
#define	IPPROTO_IDP		22		/* xns idp */
#define	IPPROTO_TRUNK1		23		/* Trunk-1 */
#define	IPPROTO_TRUNK2		24		/* Trunk-2 */
#define	IPPROTO_LEAF1		25		/* Leaf-1 */
#define	IPPROTO_LEAF2		26		/* Leaf-2 */
#define	IPPROTO_RDP		27		/* Reliable Data */
#define	IPPROTO_IRTP		28		/* Reliable Transaction */
#define	IPPROTO_TP		29 		/* tp-4 w/ class negotiation */
#define	IPPROTO_BLT		30		/* Bulk Data Transfer */
#define	IPPROTO_NSP		31		/* Network Services */
#define	IPPROTO_INP		32		/* Merit Internodal */
#define	IPPROTO_SEP		33		/* Sequential Exchange */
#define	IPPROTO_3PC		34		/* Third Party Connect */
#define	IPPROTO_IDPR		35		/* InterDomain Policy Routing */
#define	IPPROTO_XTP		36		/* XTP */
#define	IPPROTO_DDP		37		/* Datagram Delivery */
#define	IPPROTO_CMTP		38		/* Control Message Transport */
#define	IPPROTO_TPXX		39		/* TP++ Transport */
#define	IPPROTO_IL		40		/* IL transport protocol */
#define 	IPPROTO_IPV6		41		/* IP6 header */
#define	IPPROTO_SDRP		42		/* Source Demand Routing */
#define 	IPPROTO_ROUTING	43		/* IP6 routing header */
#define 	IPPROTO_FRAGMENT	44		/* IP6 fragmentation header */
#define	IPPROTO_IDRP		45		/* InterDomain Routing*/
#define 	IPPROTO_RSVP		46 		/* resource reservation */
#define	IPPROTO_GRE		47		/* General Routing Encap. */
#define	IPPROTO_MHRP		48		/* Mobile Host Routing */
#define	IPPROTO_BHA		49		/* BHA */
#define	IPPROTO_ESP		50		/* IP6 Encap Sec. Payload */
#define	IPPROTO_AH		51		/* IP6 Auth Header */
#define	IPPROTO_INLSP		52		/* Integ. Net Layer Security */
#define	IPPROTO_SWIPE		53		/* IP with encryption */
#define	IPPROTO_NHRP		54		/* Next Hop Resolution */
/* 55-57: Unassigned */
#define 	IPPROTO_ICMPV6	58		/* ICMP6 */
#define 	IPPROTO_NONE		59		/* IP6 no next header */
#define 	IPPROTO_DSTOPTS	60		/* IP6 destination option */
#define	IPPROTO_AHIP		61		/* any host internal protocol */
#define	IPPROTO_CFTP		62		/* CFTP */
#define	IPPROTO_HELLO		63		/* "hello" routing protocol */
#define	IPPROTO_SATEXPAK	64		/* SATNET/Backroom EXPAK */
#define	IPPROTO_KRYPTOLAN	65		/* Kryptolan */
#define	IPPROTO_RVD		66		/* Remote Virtual Disk */
#define	IPPROTO_IPPC		67		/* Pluribus Packet Core */
#define	IPPROTO_ADFS		68		/* Any distributed FS */
#define	IPPROTO_SATMON		69		/* Satnet Monitoring */
#define	IPPROTO_VISA		70		/* VISA Protocol */
#define	IPPROTO_IPCV		71		/* Packet Core Utility */
#define	IPPROTO_CPNX		72		/* Comp. Prot. Net. Executive */
#define	IPPROTO_CPHB		73		/* Comp. Prot. HeartBeat */
#define	IPPROTO_WSN		74		/* Wang Span Network */
#define	IPPROTO_PVP		75		/* Packet Video Protocol */
#define	IPPROTO_BRSATMON	76		/* BackRoom SATNET Monitoring */
#define	IPPROTO_ND		77		/* Sun net disk proto (temp.) */
#define	IPPROTO_WBMON		78		/* WIDEBAND Monitoring */
#define	IPPROTO_WBEXPAK		79		/* WIDEBAND EXPAK */
#define	IPPROTO_EON		80		/* ISO cnlp */
#define	IPPROTO_VMTP		81		/* VMTP */
#define	IPPROTO_SVMTP		82		/* Secure VMTP */
#define	IPPROTO_VINES		83		/* Banyon VINES */
#define	IPPROTO_TTP		84		/* TTP */
#define	IPPROTO_IGP		85		/* NSFNET-IGP */
#define	IPPROTO_DGP		86		/* dissimilar gateway prot. */
#define	IPPROTO_TCF		87		/* TCF */
#define	IPPROTO_IGRP		88		/* Cisco/GXS IGRP */
#define	IPPROTO_OSPFIGP		89		/* OSPFIGP */
#define	IPPROTO_SRPC		90		/* Strite RPC protocol */
#define	IPPROTO_LARP		91		/* Locus Address Resoloution */
#define	IPPROTO_MTP		92		/* Multicast Transport */
#define	IPPROTO_AX25		93		/* AX.25 Frames */
#define	IPPROTO_IPEIP		94		/* IP encapsulated in IP */
#define	IPPROTO_MICP		95		/* Mobile Int.ing control */
#define	IPPROTO_SCCSP		96		/* Semaphore Comm. security */
#define	IPPROTO_ETHERIP		97		/* Ethernet IP encapsulation */
#define	IPPROTO_ENCAP		98		/* encapsulation header */
#define	IPPROTO_APES		99		/* any private encr. scheme */
#define	IPPROTO_GMTP		100		/* GMTP*/
#define	IPPROTO_IPCOMP	108		/* payload compression (IPComp) */
/* 101-254: Partly Unassigned */
#define	IPPROTO_PIM		103		/* Protocol Independent Mcast */
#define	IPPROTO_PGM		113		/* PGM */
/* 255: Reserved */
/* BSD Private, local use, namespace incursion */
#define	IPPROTO_DIVERT		254		/* divert pseudo-protocol */
#define	IPPROTO_RAW		255		/* raw IP packet */
#define	IPPROTO_MAX		256

#define	INADDR_ANY		(u_int32_t)0x00000000
#define	INADDR_LOOPBACK		(u_int32_t)0x7f000001
#define	INADDR_BROADCAST	(u_int32_t)0xffffffff	/* must be masked */
#define	INADDR_NONE		0xffffffff		/* -1 return */
#define	IN_LOOPBACKNET		127			/* official! */
#endif
#endif

#define	TH_FIN	0x01
#define	TH_SYN	0x02
#define	TH_RST	0x04
#define	TH_PUSH	0x08
#define	TH_ACK	0x10
#define	TH_URG	0x20
#define	TH_ECE	0x40
#define	TH_CWR	0x80
#define	TH_FLAGS	(TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG|TH_ECE|TH_CWR)

#define	TCPOPT_EOL		0
#define	TCPOPT_NOP		1
#define	TCPOPT_MAXSEG		2
#define    TCPOLEN_MAXSEG		4
#define TCPOPT_WINDOW		3
#define    TCPOLEN_WINDOW		3
#define TCPOPT_SACK_PERMITTED	4		/* Experimental */
#define    TCPOLEN_SACK_PERMITTED	2
#define TCPOPT_SACK		5		/* Experimental */
#define TCPOPT_TIMESTAMP	8
#define    TCPOLEN_TIMESTAMP		10
#define    TCPOLEN_TSTAMP_APPA		(TCPOLEN_TIMESTAMP+2) /* appendix A */
#define    TCPOPT_TSTAMP_HDR		\
    (TCPOPT_NOP<<24|TCPOPT_NOP<<16|TCPOPT_TIMESTAMP<<8|TCPOLEN_TIMESTAMP)

#define	TCPOPT_CC		11		/* CC options: RFC-1644 */
#define TCPOPT_CCNEW		12
#define TCPOPT_CCECHO		13
#define	   TCPOLEN_CC			6
#define	   TCPOLEN_CC_APPA		(TCPOLEN_CC+2)
#define	   TCPOPT_CC_HDR(ccopt)		\
    (TCPOPT_NOP<<24|TCPOPT_NOP<<16|(ccopt)<<8|TCPOLEN_CC)

#define ICMP_ECHOREPLY          0               /* echo reply */
#define ICMP_UNREACH            3               /* dest unreachable, codes: */
#define         ICMP_UNREACH_NET        0               /* bad net */
#define         ICMP_UNREACH_HOST       1               /* bad host */
#define         ICMP_UNREACH_PROTOCOL   2               /* bad protocol */
#define         ICMP_UNREACH_PORT       3               /* bad port */
#define         ICMP_UNREACH_NEEDFRAG   4               /* IP_DF caused drop */
#define         ICMP_UNREACH_SRCFAIL    5               /* src route failed */
#define         ICMP_UNREACH_NET_UNKNOWN 6              /* unknown net */
#define         ICMP_UNREACH_HOST_UNKNOWN 7             /* unknown host */
#define         ICMP_UNREACH_ISOLATED   8               /* src host isolated */
#define         ICMP_UNREACH_NET_PROHIB 9               /* prohibited access */
#define         ICMP_UNREACH_HOST_PROHIB 10             /* ditto */
#define         ICMP_UNREACH_TOSNET     11              /* bad tos for net */
#define         ICMP_UNREACH_TOSHOST    12              /* bad tos for host */
#define         ICMP_UNREACH_FILTER_PROHIB 13           /* admin prohib */
#define         ICMP_UNREACH_HOST_PRECEDENCE 14         /* host prec vio. */
#define         ICMP_UNREACH_PRECEDENCE_CUTOFF 15       /* prec cutoff */
#define ICMP_SOURCEQUENCH       4               /* packet lost, slow down */
#define ICMP_REDIRECT           5               /* shorter route, codes: */
#define         ICMP_REDIRECT_NET       0               /* for network */
#define         ICMP_REDIRECT_HOST      1               /* for host */
#define         ICMP_REDIRECT_TOSNET    2               /* for tos and net */
#define         ICMP_REDIRECT_TOSHOST   3               /* for tos and host */
#define ICMP_ECHO               8               /* echo service */
#define ICMP_ROUTERADVERT       9               /* router advertisement */
#define ICMP_ROUTERSOLICIT      10              /* router solicitation */
#define ICMP_TIMXCEED           11              /* time exceeded, code: */     
#define         ICMP_TIMXCEED_INTRANS   0               /* ttl==0 in transit */
#define         ICMP_TIMXCEED_REASS     1               /* ttl==0 in reass */
#define ICMP_PARAMPROB          12              /* ip header bad */
#define         ICMP_PARAMPROB_ERRATPTR 0               /* error at param ptr */#define         ICMP_PARAMPROB_OPTABSENT 1              /* req. opt. absent */
#define         ICMP_PARAMPROB_LENGTH 2                 /* bad length */    
#define ICMP_TSTAMP             13              /* timestamp request */  
#define ICMP_TSTAMPREPLY        14              /* timestamp reply */       
#define ICMP_IREQ               15              /* information request */  
#define ICMP_IREQREPLY          16              /* information reply */  
#define ICMP_MASKREQ            17              /* address mask request */
#define ICMP_MASKREPLY          18              /* address mask reply */     

#endif
