/*
 * can4linux -- LINUX CAN device driver source
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 *
 * 
 * derived from the the LDDK can4linux version
 *     (c) 1996,1997 Claus Schroeter (clausi@chemie.fu-berlin.de)
 *
 *------------------------------------------------------------------
 * $Header: /z2/cvsroot/products/0530/software/can4linux/src/util.c,v 1.11 2009/06/03 14:33:43 oe Exp $
 *
 *--------------------------------------------------------------------------
 *
 *
 *
 */


#include <linux/sched.h> 
#include <linux/proc_fs.h>
#include <linux/pci.h>
#include <linux/spinlock.h>
#include "defs.h"

/*
 * Refuse to compile under versions older than 1.99.4
 */

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
#  error "This module needs Linux 2.4 or newer"
#endif

/* each CAN channel has one wait_queue for read and one for write */
wait_queue_head_t CanWait[MAX_CHANNELS][CAN_MAX_OPEN];
wait_queue_head_t CanOutWait[MAX_CHANNELS];

spinlock_t write_splock[MAX_CHANNELS];

/* Flag for the ISR, which read queue is in use */
int CanWaitFlag[MAX_CHANNELS][CAN_MAX_OPEN] = {{0}};

/* for each CAN channel allocate a TX and RX FIFO */
msg_fifo_t   Tx_Buf[MAX_CHANNELS] = {{0}};
msg_fifo_t   Rx_Buf[MAX_CHANNELS][CAN_MAX_OPEN] = {{{0}}};

#ifdef CAN_USE_FILTER
    msg_filter_t Rx_Filter[MAX_CHANNELS] = {{0}}; 
#endif
/* used to store always the last frame sent on this channel */
canmsg_t     last_Tx_object[MAX_CHANNELS];

#if defined (CAN_PORT_IO)
/* can_base holds a pointer, in order to use the acess macros
   for adress calculation with the given CAN register structure.
   before acessing the registers, the pointer is casted to int */
unsigned char *can_base[MAX_CHANNELS] = {0};
#else
/* Memory access to CAN */
void __iomem *can_base[MAX_CHANNELS] = {0};	/* ioremapped adresses */
#endif /* defined (CAN_PORT_IO) */

unsigned int can_range[MAX_CHANNELS] = {0};	/* width of the address range */

/* flag indicating that selfreception of frames is allowed */
int selfreception[MAX_CHANNELS][CAN_MAX_OPEN] = {{0}};
int use_timestamp[MAX_CHANNELS] = {0};	/* flag indicating that timestamp 
				       value should assigned to rx messages */
int wakeup[MAX_CHANNELS] = {0};		/* flag indicating that sleeping
				    processes are waken up in case of events */


/*
initialize RX Fifo
*/
int Can_RxFifoInit(int minor, int fifo)
{
    DBGin();
    /* printk("Can_RxFifoInit minor %d, fifo %d\n", minor, fifo); */

	Rx_Buf[minor][fifo].head   = 0;
	Rx_Buf[minor][fifo].tail   = 0;
	Rx_Buf[minor][fifo].status = 0;
	Rx_Buf[minor][fifo].active = 0;

	init_waitqueue_head(&CanWait[minor][fifo]);
	CanWaitFlag[minor][fifo] = 1;

    DBGout();
    return 0;
}
/*
initialize  TX Fifo
*/
int Can_TxFifoInit(int minor)
{
int i;

    DBGin();

        Tx_Buf[minor].head   = 0;
        Tx_Buf[minor].tail   = 0;
        Tx_Buf[minor].status = 0;
        Tx_Buf[minor].active = 0;
        for(i = 0; i < MAX_BUFSIZE; i++) {
	   Tx_Buf[minor].free[i]  = BUF_EMPTY;
        }
	init_waitqueue_head(&CanOutWait[minor]);

    DBGout();
    return 0;
}

#ifdef CAN_USE_FILTER
int Can_FilterInit(int minor)
{
int i;

    DBGin();
       Rx_Filter[minor].use      = 0;
       Rx_Filter[minor].signo[0] = 0;
       Rx_Filter[minor].signo[1] = 0;
       Rx_Filter[minor].signo[2] = 0;

       for(i=0;i<MAX_ID_NUMBER;i++)	
	  Rx_Filter[minor].filter[i].rtr_response = NULL;

    DBGout();
    return 0;
}

int Can_FilterCleanup(int minor)
{
int i;

    DBGin();
    for(i=0;i<MAX_ID_NUMBER;i++) {
	    if( Rx_Filter[minor].filter[i].rtr_response != NULL )	
	       kfree( Rx_Filter[minor].filter[i].rtr_response);
	    Rx_Filter[minor].filter[i].rtr_response = NULL;
    }
    DBGout();
    return 0;
}


int Can_FilterOnOff(int minor, unsigned on) {
    DBGin();
       Rx_Filter[minor].use = (on!=0);
    DBGout();
    return 0;
}

int Can_FilterMessage(int minor, unsigned message, unsigned enable) {
    DBGin();
       Rx_Filter[minor].filter[message].enable = (enable!=0);
    DBGout();
    return 0;
}

int Can_FilterTimestamp(int minor, unsigned message, unsigned stamp) {
    DBGin();
       Rx_Filter[minor].filter[message].timestamp = (stamp!=0);
    DBGout();
    return 0;
}

int Can_FilterSignal(int minor, unsigned id, unsigned signal) {
    DBGin();
       if( signal <= 3 )
       Rx_Filter[minor].filter[id].signal = signal;
    DBGout();
    return 0;
}

int Can_FilterSigNo(int minor, unsigned signo, unsigned signal ) {
    DBGin();
       if( signal < 3 )
       Rx_Filter[minor].signo[signal] = signo;
    DBGout();
    return 0;
}
#endif

#ifdef CAN_RTR_CONFIG
int Can_ConfigRTR( int minor, unsigned message, canmsg_t *Tx )
{
canmsg_t *tmp;

    DBGin();
    if( (tmp = kmalloc ( sizeof(canmsg_t), GFP_ATOMIC )) == NULL ){
	    DBGprint(DBG_BRANCH,("memory problem"));
	    DBGout(); return -1;
    }
    Rx_Filter[minor].filter[message].rtr_response = tmp;
    memcpy( Rx_Filter[minor].filter[message].rtr_response , Tx, sizeof(canmsg_t));	
    DBGout(); return 1;
    return 0;
}

int Can_UnConfigRTR( int minor, unsigned message )
{
canmsg_t *tmp;

    DBGin();
    if( Rx_Filter[minor].filter[message].rtr_response != NULL ) {
	    kfree(Rx_Filter[minor].filter[message].rtr_response);
	    Rx_Filter[minor].filter[message].rtr_response = NULL;
    }	
    DBGout(); return 1;
    return 0;
}
#endif


#ifdef DEBUG

/* dump_CAN or CAN_dump() which is better ?? */
#if CAN4LINUX_PCI
#else
#endif
#include <asm/io.h>

#if 1
/* simply dump a memory area bytewise for n*16 addresses */
/*
 * adress - start address 
 * n      - number of 16 byte rows, 
 * offset - print every n-th byte
 */
void dump_CAN(unsigned long adress, int n, int offset)
{
int i, j;
    printk("     CAN at Adress 0x%lx\n", adress);
    for(i = 0; i < n; i++) {
	printk("     ");
	for(j = 0; j < 16; j++) {
	    /* printk("%02x ", *ptr++); */
	    printk("%02x ", readb((void __iomem *)adress));
	    adress += offset;
	}
	printk("\n");
    }
}
#endif

#ifdef CPC_PCI 
# define REG_OFFSET 4
#else
# define REG_OFFSET 1
#endif
/**
*   Dump the CAN controllers register contents,
*   identified by the device minor number to stdout
*
*   Base[minor] should contain the virtual adress
*/
void can_dump(int minor)
{
int i, j;
int index = 0;

	for(i = 0; i < 2; i++) {
	    printk("0x%04x: ", (unsigned int)Base[minor] + (i * 16));
	    for(j = 0; j < 16; j++) {
		printk("%02x ",
#ifdef  CAN_PORT_IO
		inb((int) (Base[minor] + index)) );
#else
		readb((void __iomem *) (can_base[minor] + index)) );
#endif
		/* slow_down_io(); */
		index += REG_OFFSET;
	    }
	    printk("\n");
	}
}
#endif

void canout_mem(void * adr,unsigned char v)	
{            
	writeb(v, (void __iomem *)adr );
} 

unsigned canin_mem(void * adr)	
{
	return (readb((void __iomem *)adr ));
}

unsigned cantest_mem(void * adr, unsigned m)	
{
	return (readb ((void __iomem *)adr ) & (m) );
}

void canreset_mem(void * adr,int m)
{                       
	writeb((readb((void __iomem *)adr)) & ~(m), (void __iomem *)adr );
}

void canset_mem(void * adr,int m)	
{                       
	writeb((readb((void __iomem *)adr)) | (m) , (void __iomem *)adr ); 
}


void canout_io(void * adr,unsigned char v)	
{            
	outb(v, (int)adr );
} 

unsigned canin_io(void * adr)	
{
	return (inb ((int)adr)) ;
}

unsigned cantest_io(void * adr, unsigned m)	
{
	return (inb((int)adr) & m ); 
}

void canreset_io(void * adr,int m)
{                       
	outb((inb((int)adr)) & ~m,(int)adr);
}

void canset_io(void * adr,int m)	
{                       
	outb((inb((int)adr)) | m ,(int)adr );
}


void (*advCanout[MAX_CHANNELS])(void * adr,unsigned char  v);
unsigned (*advCanin[ MAX_CHANNELS])(void * adr);
void (*advCanset[ MAX_CHANNELS])(void * adr,int m);
void (*advCanreset[ MAX_CHANNELS])(void * adr,int m);
unsigned (*advCantest[ MAX_CHANNELS])(void * adr, unsigned m);



/*----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
