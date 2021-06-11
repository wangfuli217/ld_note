/*
 * defs.h  - can4linux CAN driver module, common definitions
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 *
 * Copyright (c) 2001-2008 port GmbH Halle/Saale
 *------------------------------------------------------------------
 * $Header: /z2/cvsroot/products/0530/software/can4linux/src/defs.h,v 1.16 2009/06/18 09:15:56 oe Exp $
 *
 *--------------------------------------------------------------------------
 *
 *
 *
 *--------------------------------------------------------------------------
 */


/**
* \file defs.h
* \author Name, port GmbH
* $Revision: 1.16 $
* $Date: 2009/06/18 09:15:56 $
*
* Module Description 
* see Doxygen Doc for all possibilites
*
*
*
*/


#ifdef __KERNEL__
#include <linux/version.h>
#include <linux/init.h>
#include <linux/module.h>


/* needed for 2.4 */
#ifndef NOMODULE
# define __NO_VERSION__
# ifndef MODULE
#  define MODULE
# endif
#endif

#ifdef __KERNEL__
#ifndef KERNEL_VERSION
#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
#endif


#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
# include <linux/config.h>
#endif

#include <linux/kernel.h>
#include <linux/tty.h>
#include <linux/errno.h>
#include <linux/major.h>


#if LINUX_VERSION_CODE > KERNEL_VERSION(2,4,6)
# include <linux/slab.h>
#else
# include <linux/malloc.h>
#endif

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,1,0)
#include <linux/poll.h>
#endif

#include <asm/io.h>
#include <asm/segment.h>
#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0)
#include <asm/switch_to.h>
#else
#include <asm/system.h>
#endif
#include <asm/irq.h>
#include <asm/dma.h>

#include <linux/mm.h>
#include <linux/signal.h>
#include <linux/timer.h>

#include <asm/uaccess.h>

#define __lddk_copy_from_user(a,b,c) _cnt = copy_from_user(a,b,c)
#define __lddk_copy_to_user(a,b,c) _cnt =copy_to_user(a,b,c)


#include <linux/ioport.h>

#if !defined(__iomem)
# define __iomem
#endif
#endif

/* Unsigned value which later should be converted to an integer */
#if defined(__x86_64__)

#  if defined(CAN_PORT_IO)
typedef unsigned int upointer_t;
/* typedef unsigned int upointer_t; */
#  else
typedef unsigned long upointer_t;
#  endif

#else  /* 32 bit system */

#  if defined(CAN_PORT_IO)
typedef unsigned int upointer_t;
/* typedef unsigned int upointer_t; */
#  else
typedef unsigned long upointer_t;
#  endif
#endif /* defined(__x86_64__) */


#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0) 
# include <linux/interrupt.h> 

#else
 /* For 2.4.x compatibility, 2.4.x can use */
typedef void irqreturn_t;
#define IRQ_NONE
#define IRQ_HANDLED
#define IRQ_RETVAL(x)

/* not available in k2.4.x */
static inline unsigned iminor(struct inode *inode)
{
	return MINOR(inode->i_rdev);
}
#endif





#if CAN4LINUX_PCI
# define _BUS_TYPE "PCI-"
/* 
Since 2008 we hav two versions of the CPC PCI
The old one, using the SIemens PITA chip with up to two CAN controllers
The new one using A PLX PCI Bridge with up to 4 CAN controllers
the only one supported: EMS CPC-PCI */

/* Old */
# define PCI_VENDOR_CAN_EMS	0x110a
# define PCI_DEVICE_CAN 	0x2104
/* PSB4610 PITA-2 bridge control registers */
#define PITA2_ICR           0x00	    /* Interrupt Control Register */
#define PITA2_ICR_INT0      0x00000002	/* [RC] INT0 Active/Clear */
#define PITA2_ICR_INT0_EN   0x00020000	/* [RW] Enable INT0 */

#define PITA2_MISC          0x1c	    /* Miscellaneous Register */
#define PITA2_MISC_CONFIG   0x04000000	/* Multiplexed parallel interface */

/* New */
/* #define PCI_VENDOR_ID_PLX  : in pci_ids.h */
#ifndef PCI_DEVICE_ID_PLX_9030
#define PCI_DEVICE_ID_PLX_9030 0x9030
#endif
/* PLX 9030 PCI-to-IO Bridge control registers */
#define PLX9030_ICR             0x4c  /* Interrupt Control Register */
#define PLX9030_ICR_CLEAR_IRQ0  0x400
#define PLX9030_ICR_ENABLE_IRQ0 0x41



/* and CANPCI manufactured by Contemporary Controls Inc. */
# define PCI_VENDOR_CAN_CC	0x1571
# define PCI_DEVICE_CC_MASK 	0xC001
# define PCI_DEVICE_CC_CANopen 	0xC001
# define PCI_DEVICE_CC_CANDnet 	0xC002

/* and PCICAN manufactured by Kvaser */
# define PCI_VENDOR_CAN_KVASER	0x10e8
# define PCI_DEVICE_CAN_KVASER	0x8406


#elif CAN4LINUX_PCCARD
# define _BUS_TYPE "PC-Card-"
#elif  SSV_MCP2515
# define _BUS_TYPE "SPI-"
#else
# define _BUS_TYPE "ISA-"
#endif

#if    defined(ATCANMINI_PELICAN) \
    || defined(CCPC104)		\
    || defined(CPC_PCI)		\
    || defined(CPC_PCI2)	\
    || defined(JANZ_PCIL)	\
    || defined(CC_CANPCI)	\
    || defined(IXXAT_PCI03)	\
    || defined(PCM3680)		\
    || defined(PCM9890)		\
    || defined(CPC104)		\
    || defined(CPC104_200)	\
    || defined(CPC_PCM_104)	\
    || defined(CPC_CARD)	\
    || defined(KVASER_PCICAN)	\
    || defined(VCMA9)		\
    || defined(MMC_SJA1000)	\
    || defined(MULTILOG_SJA1000)\
    || defined(CTI_CANPRO)	\
    || defined(ECAN1000) \
    || defined(INVOLUSER)
/* ---------------------------------------------------------------------- */

#  define __CAN_TYPE__ "Involuser CAN Port "

#elif defined(MCF5282)
#   define __CAN_TYPE__ _BUS_TYPE "FlexCAN "
/* ---------------------------------------------------------------------- */
#elif defined(IMX35) || defined(IMX25)
#   define __CAN_TYPE__ _BUS_TYPE "FlexCAN "
/* ---------------------------------------------------------------------- */
#elif defined(UNCTWINCAN)
#   define __CAN_TYPE__ _BUS_TYPE "TwinCAN "
/* ---------------------------------------------------------------------- */
#elif defined(AD_BLACKFIN)
#   define __CAN_TYPE__ _BUS_TYPE "BlackFin-CAN "
/* ---------------------------------------------------------------------- */
#elif defined(ATMEL_SAM9)
#   define __CAN_TYPE__ _BUS_TYPE "Atmel-CAN "
/* ---------------------------------------------------------------------- */
#elif defined(SSV_MCP2515)
#   define __CAN_TYPE__ _BUS_TYPE "Microchip MCP2515 "
/* ---------------------------------------------------------------------- */
#else
/* ---------------------------------------------------------------------- */
#endif

/* Length of the "version" string entry in /proc/.../version */
#define PROC_VER_LENGTH 80
/* Length of the "Chipset" string entry in /proc/.../version */
#define PROC_CHIPSET_LENGTH 30

/* kernels higher 2.3.x have a new kernel interface.
*  Since can4linux V3.x only kernel interfaces 2.4 an higher are supported.
*  This simplfies alot of things
* ******************/
#define __LDDK_WRITE_TYPE	ssize_t
#define __LDDK_CLOSE_TYPE	int
#define __LDDK_READ_TYPE	ssize_t
#define __LDDK_OPEN_TYPE	int
#define __LDDK_IOCTL_TYPE	int
#define __LDDK_SELECT_TYPE	unsigned int
#define __LDDK_FASYNC_TYPE	int

#define __LDDK_SEEK_PARAM 	struct file *file, loff_t off, size_t count
#define __LDDK_READ_PARAM 	struct file *file, char *buffer, size_t count, \
					loff_t *loff
#define __LDDK_WRITE_PARAM 	struct file *file, const char *buffer, \
					size_t count, loff_t *loff
#define __LDDK_READDIR_PARAM 	struct file *file, void *dirent, filldir_t count
#define __LDDK_SELECT_PARAM 	struct file *file, \
					struct poll_table_struct *wait
#define __LDDK_IOCTL_PARAM 	struct inode *inode, struct file *file, \
					unsigned int cmd, unsigned long arg
#define __LDDK_MMAP_PARAM 	struct file *file, struct vm_area_struct * vma
#define __LDDK_OPEN_PARAM 	struct inode *inode, struct file *file 
#define __LDDK_FLUSH_PARAM	struct file *file 
#define __LDDK_CLOSE_PARAM 	struct inode *inode, struct file *file 
#define __LDDK_FSYNC_PARAM 	struct file *file, struct dentry *dentry, \
					int datasync
#define __LDDK_FASYNC_PARAM 	int fd, struct file *file, int count 
#define __LDDK_CCHECK_PARAM 	kdev_t dev
#define __LDDK_REVAL_PARAM 	kdev_t dev

#define __LDDK_MINOR MINOR(file->f_dentry->d_inode->i_rdev)
#define __LDDK_INO_MINOR MINOR(inode->i_rdev)


#ifndef SLOW_DOWN_IO
# define SLOW_DOWN_IO __SLOW_DOWN_IO
#endif





/************************************************************************/
#include "debug.h"
/************************************************************************/
#ifdef __KERNEL__

extern __LDDK_READ_TYPE   can_read   (__LDDK_READ_PARAM);
extern __LDDK_WRITE_TYPE can_write (__LDDK_WRITE_PARAM);
extern __LDDK_SELECT_TYPE can_select (__LDDK_SELECT_PARAM);
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36) 
long can_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
#else
extern __LDDK_IOCTL_TYPE  can_ioctl  (__LDDK_IOCTL_PARAM);
#endif
extern __LDDK_OPEN_TYPE   can_open   (__LDDK_OPEN_PARAM);
extern __LDDK_CLOSE_TYPE can_close (__LDDK_CLOSE_PARAM);
extern __LDDK_FASYNC_TYPE can_fasync (__LDDK_FASYNC_PARAM);

#endif 

/* number of supported CAN channels */
#ifndef MAX_CHANNELS
# define MAX_CHANNELS 16
#endif
#include "inscan.h"
extern void (*advCanout[MAX_CHANNELS])(void * adr,unsigned char v);
extern unsigned (*advCanin[ MAX_CHANNELS])(void * adr);
extern void (*advCanset[ MAX_CHANNELS])(void * adr,int m);
extern void (*advCanreset[ MAX_CHANNELS])(void * adr,int m);
extern unsigned (*advCantest[ MAX_CHANNELS])(void * adr, unsigned m);
extern void *  Reg[MAX_CHANNELS][32];


/*---------- Default Outc and other value for some known boards
 * this depends on the transceiver configuration
 * some embedded CAN controllers even don't have this configuration option
 * 
 * the AT-CAN-MINI board uses optocoupler configuration as denoted
 * in the Philips application notes, so the OUTC value is 0xfa
 *
 * CAN_OUTC_VAL  - is a register value, mostly used for SJA1000
 * IO_Modeli     'p'  port IO
 *               'm'  memory IO
 *               's'  spi bus connected
 *               'i'  indexed meory or indexed port access
 */


# define CAN_OUTC_VAL           0xfa
# define IO_MODEL		'p'
# define STD_MASK		0xFFFFFFFF 
# include "sja1000.h"



/************************************************************************/
#include "can4linux.h"
/************************************************************************/
 /* extern volatile int irq2minormap[]; */
 /* extern volatile int irq2pidmap[]; */
#if defined (CPC_PCI2)
extern void __iomem *Can_pitapci_control[];
#else
extern upointer_t Can_pitapci_control[];
#endif

extern void __iomem *Can_ob_control[];

/* extern void __iomem *Can_pitapci_control[]; */
extern struct	pci_dev *Can_pcidev[];



/* number of processes allowed to open a CAN channel */
#ifndef CAN_MAX_OPEN
# define CAN_MAX_OPEN 1
#endif


#ifndef MAX_BUFSIZE
# define MAX_BUFSIZE 256
/* #define MAX_BUFSIZE 1000 */
/* #define MAX_BUFSIZE 4 */
#endif

/* highest supported interrupt number */
#define MAX_IRQNUMBER	32767 /* SHRT_MAX */
/* max number of bytes used for the device name in the inode 'can%d' */
#define MAXDEVNAMELENGTH 10

#define BUF_EMPTY    0
#define BUF_OK       1
#define BUF_FULL     BUF_OK
#define BUF_OVERRUN  2
#define BUF_UNDERRUN 3


typedef struct {
	int head;
        int tail;
        int status;
	int active;
	char free[MAX_BUFSIZE];
        canmsg_t data[MAX_BUFSIZE];
 } msg_fifo_t;


struct _instance_data {
	int rx_index;
	wait_queue_head_t CanRxWait;
    };


#ifdef CAN_USE_FILTER
 #define MAX_ID_LENGTH 11
 #define MAX_ID_NUMBER (1<<11)

 typedef struct {
	unsigned    use;
	unsigned    signo[3];
	struct {
		unsigned    enable    : 1;
		unsigned    timestamp : 1;
		unsigned    signal    : 2;
		canmsg_t    *rtr_response;
	} filter[MAX_ID_NUMBER];
 } msg_filter_t;



 extern msg_filter_t Rx_Filter[];
#endif

extern msg_fifo_t Tx_Buf[MAX_CHANNELS];
extern msg_fifo_t Rx_Buf[MAX_CHANNELS][CAN_MAX_OPEN];
extern canmsg_t last_Tx_object[MAX_CHANNELS];    /* used for selfreception of messages */


extern atomic_t Can_isopen[MAX_CHANNELS];   /* device minor already opened */


#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,18) 
extern int Can_RequestIrq(int minor, int irq, 
	irqreturn_t (*handler)(int, void *));
#else
extern int Can_RequestIrq(int minor, int irq, 
	irqreturn_t (*handler)(int, void *, struct pt_regs *));
#endif


extern wait_queue_head_t CanWait[MAX_CHANNELS][CAN_MAX_OPEN];
extern wait_queue_head_t CanOutWait[MAX_CHANNELS];
extern int CanWaitFlag[MAX_CHANNELS][CAN_MAX_OPEN];

extern spinlock_t write_splock[MAX_CHANNELS];



#if defined (CAN_PORT_IO)
/* can_base holds a pointer, in order to use the acess macros
   for adress calculation with the given CAN register structure.
   before acessing the registers, the pointer is csted to int */
extern unsigned char *can_base[];
#else
/* Memory access to CAN */
extern void __iomem *can_base[];
#endif /* defined (CAN_PORT_IO) */



extern unsigned int   can_range[];
#endif		/*  __KERNEL__ */

extern int IRQ_requested[];
extern int Can_minors[];			/* used as IRQ dev_id */
extern int selfreception[MAX_CHANNELS][CAN_MAX_OPEN];			/* flag  1 = On */
extern int use_timestamp[MAX_CHANNELS];			/* flag  1 = On */
extern int wakeup[];				/* flag  1 = On */
extern int listenmode;				/* true for listen only */

/************************************************************************/
#define LDDK_USE_SYSCTL 1
#ifdef __KERNEL__
#include <linux/sysctl.h>

extern ctl_table can_sysctl_table[];


/* ------ /proc/sys/dev/Can accessible global variables */

extern char version[];
extern char Chipset[];
extern char IOModel[];
extern  int IRQ[];
extern  upointer_t Base[];
extern  int Baud[];
extern  unsigned int Clock;

extern canregs_t sja1000reg;

#if defined(IMX35) || defined(IMX25) 
extern  unsigned int AccCode[FLEXCAN_MAX_FILTER][MAX_CHANNELS];
extern  unsigned int AccMask[FLEXCAN_MAX_FILTER][MAX_CHANNELS];
#else
extern  unsigned int AccCode[];
extern  unsigned int AccMask[];
#endif

extern  int Timeout[];
extern  int Outc[];
extern  int TxErr[];
extern  int RxErr[];
extern  int Overrun[];
extern unsigned int dbgMask;
extern  int Cnt1[];
extern  int Cnt2[];
 
enum {
	CAN_SYSCTL_VERSION  = 1,
	CAN_SYSCTL_CHIPSET  = 2,
	CAN_SYSCTL_IOMODEL  = 3,
	CAN_SYSCTL_IRQ      = 4,
	CAN_SYSCTL_BASE     = 5,
	CAN_SYSCTL_BAUD     = 6,
	CAN_SYSCTL_ACCCODE  = 7,
	CAN_SYSCTL_ACCMASK  = 8,
	CAN_SYSCTL_TIMEOUT  = 9,
	CAN_SYSCTL_OUTC     = 10,
	CAN_SYSCTL_TXERR    = 11,
	CAN_SYSCTL_RXERR    = 12,
	CAN_SYSCTL_OVERRUN  = 13,
	CAN_SYSCTL_DBGMASK  = 14,
	CAN_SYSCTL_CNT1     = 15,
	CAN_SYSCTL_CNT2     = 16,
	CAN_SYSCTL_CLOCK
};
 
#endif
/************************************************************************/



#ifndef CAN_MAJOR
#define CAN_MAJOR 91
#endif

extern int Can_errno;

#ifdef USE_LDDK_RETURN
#define LDDK_RETURN(arg) DBGout();return(arg)
#else
#define LDDK_RETURN(arg) return(arg)
#endif


/************************************************************************/
/* function prototypes */
/************************************************************************/
extern int CAN_ChipReset(int);
extern int CAN_SetTiming(int, int);
extern int CAN_StartChip(int);
extern int CAN_StopChip(int);
#if defined(IMX35) || defined(IMX25)
extern int CAN_SetMask(int, int, unsigned int, unsigned int);
#else
extern int CAN_SetMask(int, unsigned int, unsigned int);
#endif
extern int CAN_SetOMode(int,int);
extern int CAN_SetListenOnlyMode(int, int);
extern int CAN_SendMessage(int minor, canmsg_t *tx);
extern int CAN_SetBTR(int, int, int);

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,18) 
extern irqreturn_t CAN_Interrupt( int irq, void *dev_id);
#else
extern irqreturn_t CAN_Interrupt( int irq, void *dev_id, struct pt_regs *);
#endif

extern int CAN_VendorInit(int);
extern int CAN_Release(int);

extern void register_systables(void);
extern void unregister_systables(void);


/* util.c */
extern int Can_RxFifoInit(int minor, int fifo);
extern int Can_TxFifoInit(int minor);
extern int Can_FilterCleanup(int minor);
extern int Can_FilterInit(int minor);
extern int Can_FilterMessage(int minor, unsigned message, unsigned enable);
extern int Can_FilterOnOff(int minor, unsigned on);
extern int Can_FilterSigNo(int minor, unsigned signo, unsigned signal);
extern int Can_FilterSignal(int minor, unsigned id, unsigned signal);
extern int Can_FilterTimestamp(int minor, unsigned message, unsigned stamp);
extern int Can_FreeIrq(int minor, int irq );
extern int Can_WaitInit(int minor);
extern void Can_StartTimer(unsigned long v);
extern void Can_StopTimer(void);
extern void Can_TimerInterrupt(unsigned long unused);
extern void can_dump(int minor);
extern void CAN_register_dump(int minor);
extern void CAN_object_dump(int minor, int object);
extern void print_tty(const char *fmt, ...);
extern int controller_available(upointer_t address, int offset);



/* PCI support */
extern int pcimod_scan(void);

/* debug support */
extern void init_measure(void);
extern void set_measure_pin(void);
extern void reset_measure_pin(void);

#ifndef pci_pretty_name
#define pci_pretty_name(dev) ""
#endif


/* ----------------------------------------
 *
 * TARGET specific function declarations
 *
 * ---------------------------------------
 */

/* can_82c200funcs.c */
extern int CAN_ShowStat (int board);





/*________________________E_O_F_____________________________________________*/
