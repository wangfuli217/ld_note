/* can_sja1000funcs
*
* can4linux -- LINUX CAN device driver source
* 
* This file is subject to the terms and conditions of the GNU General Public
* License.  See the file "COPYING" in the main directory of this archive
* for more details.
*
* 
* Copyright (c) 2002-2010 port GmbH Halle/Saale
* (c) 2001 Heinz-Juergen Oertel (oe@port.de)
*------------------------------------------------------------------
* $Header: /z2/cvsroot/products/0530/software/can4linux/src/sja1000funcs.c,v 1.14 2009/05/17 16:11:26 oe Exp $
*
*--------------------------------------------------------------------------
*
*
* modification history
* --------------------
* $Log: sja1000funcs.c,v $
* Revision 1.14  2009/05/17 16:11:26  oe
* - CONFIG_TIME_MEASURE calls functions from hardware dependant files
* - added new Target CPC_PCI2 for _new_ CPC-PCI 4 channel
* - used TxErr und RxERR counters
*
* Revision 1.13  2008/11/23 12:05:30  oe
* - Update and released for 3.5.3
*
* Revision 1.12  2008/02/24 17:55:55  oe
* - changed IRQ falgs from SA_* to  IRQF_SHARED
*
* Revision 1.11  2008/02/24 15:25:06  oe
* - renamed MAX_OPEN to CAN_MAX_OPEN
* - error in rx_int frame copy loop, intoduced length variable
*
* Revision 1.10  2007/08/03 11:23:46  hae
* removed test code
* removed for-loop copying the last_tx_obj in the rxfifos of other processes causing erroneous behaviour
*
* Revision 1.9  2007/07/30 06:41:22  hae
* prohibit setting a new bitttime if the channel was already opened by another process, setting the same bitrate as the first process is permitted
*
* Revision 1.8  2007/07/30 06:20:41  hae
* extend selfrecetion flag from 'per channel (minor)' to 'pre process'
*
* Revision 1.7  2007/07/19 13:40:37  oe
* - removed printk()
*
* Revision 1.6  2007/07/17 10:14:59  oe
* - changed array initialization of: selfreception, use_timestamp
*
* Revision 1.5  2007/07/16 13:31:34  oe
* - write CAN errors into all open rx fifos
*
* Revision 1.4  2007/07/16 07:34:07  oe
* - the driver allows open() from different processes
*   the number of allowed calls is defined in CAN_MAX_OPEN (defs.h)
*
* Revision 1.3  2007/02/07 15:25:38  oe
* 64 bit
*
* Revision 1.2  2006/06/21 13:18:32  oe
* - Update support fpr EMS CPC-104
* - mixed configuration CPC-104 and PCM3680
*
* Revision 1.1  2006/04/21 16:26:53  oe
* - new version with new file structure for all architectures
*
* Revision 1.14  2006/01/09 10:07:28  oe
* - added int CAN_SetBTR
*
* Revision 1.13  2005/08/29 08:51:27  oe
* - added support for SJA1000 ListenOnlyMode, thanks to Steven Scholz
*   <steven.scholz@imc-berlin.de>
* - added support for frame self reception mode
*
* Revision 1.12  2005/07/22 12:01:47  oe
* applied patch by Steven Scholz
* - new ioctl( , CONF_LISTEN_ONLY_MODE, )
* - replaced verify_area() by !access_ok()
*
* Revision 1.11  2005/04/01 16:05:50  oe
* - replaced cli() ...
*
* Revision 1.10  2005/02/09 16:17:05  oe
* - corrected __iomem annotation
*
* Revision 1.9  2005/02/07 11:44:10  oe
* - casting io-mem data types __iomem
*
* Revision 1.8  2005/02/07 11:17:09  oe
* - IRQ Acknowledge for (CCPC104) added
*
* Revision 1.7  2004/12/14 09:36:36  oe
* - Release for kernel 2.6 with support for 82527 included
*
* Revision 1.6  2004/05/14 10:02:54  oe
* - started supporting CPC-Card
* - version number in can4linux.h available
* - only one structure type for Config_par_t Command_par_t
* - new ioctl command CMD_CLEARBUFFERS
*
* Revision 1.5  2004/02/13 14:19:50  oe
* *** empty log message ***
*
* Revision 1.4  2003/12/29 15:20:15  oe
* - support for indexed-i/o
*
* Revision 1.3  2003/08/27 17:49:27  oe
* - New CanStatusPar structure
*
* Revision 1.2  2003/08/27 13:06:27  oe
* - Version 3.0
*
* Revision 1.1  2003/07/05 14:28:55  oe
* - all changes for the new 3.0: try to eliminate hw depedencies at run-time.
*   configure for HW at compile time
*
* Revision 1.8  2002/10/25 10:39:00  oe
* - vendor specific handling for Involuser board added by "R.R.Robotica" <rrrobot@tin.it>
*
* Revision 1.7  2002/10/11 16:58:06  oe
* - IOModel, Outc, VendOpt are now set at compile time
* - deleted one misleading printk()
*
* Revision 1.6  2002/08/20 05:57:22  oe
* - new write() handling, now not ovrwriting buffer content if buffer fill
* - ioctl() get status returns buffer information
*
* Revision 1.5  2002/08/08 17:55:32  oe
* - added vendor specific code for stzp 's' IXXAT board iPC03
* - received message with id=0xffffffff == error
*
* Revision 1.4  2001/09/14 14:58:09  oe
* first free release
*
*
*/
#include "defs.h"
#include "linux/delay.h"
#include "sja1000.h"
#include <linux/sched.h>


/* int	CAN_Open = 0; */

/* timing values */
u8 CanTiming[10][2]={
	{CAN_TIM0_10K,  CAN_TIM1_10K},
	{CAN_TIM0_20K,  CAN_TIM1_20K},
	{CAN_TIM0_50K,  CAN_TIM1_50K},
	{CAN_TIM0_100K, CAN_TIM1_100K},
	{CAN_TIM0_125K, CAN_TIM1_125K},
	{CAN_TIM0_250K, CAN_TIM1_250K},
	{CAN_TIM0_500K, CAN_TIM1_500K},
	{CAN_TIM0_800K, CAN_TIM1_800K},
	{CAN_TIM0_1000K,CAN_TIM1_1000K}};


#if defined(CAN_INDEXED_PORT_IO) || defined(CAN_INDEXED_MEM_IO)
canregs_t* regbase = 0;
#endif

canregs_t sja1000reg;

/* Board reset
   means the following procedure:
  set Reset Request
  wait for Rest request is changing - used to see if board is available
  initialize board (with valuse from /proc/sys/Can)
    set output control register
    set timings
    set acceptance mask
*/


#ifdef DEBUG
int CAN_ShowStat (int board)
{
    if (dbgMask && (dbgMask & DBG_DATA)) {
    printk(" MODE 0x%x,", CANin(board, canmode));
    printk(" STAT 0x%x,", CANin(board, canstat));
    printk(" IRQE 0x%x,", CANin(board, canirq_enable));
    printk(" INT 0x%x\n", CANin(board, canirq));
    }
    return 0;
}
#endif

/* can_GetStat - read back as many status information as possible 
*
* Because the CAN protocol itself describes different kind of information
* already, and the driver has some generic information
* (e.g about it's buffers)
* we can define a more or less hardware independent format.
*
*
* exception:
* ERROR WARNING LIMIT REGISTER (EWLR)
* The SJA1000 defines a EWLR, reaching this Error Warning Level
* an Error Warning interrupt can be generated.
* The default value (after hardware reset) is 96. In reset
* mode this register appears to the CPU as a read/write
* memory. In operating mode it is read only.
* Note, that a content change of the EWLR is only possible,
* if the reset mode was entered previously. An error status
* change (see status register; Table 14) and an error
* warning interrupt forced by the new register content will not
* occur until the reset mode is cancelled again.
*/

int can_GetStat(
	struct inode *inode,
	struct file *file,
	CanStatusPar_t *stat
	)
{
unsigned int minor = iminor(inode);	
msg_fifo_t *Fifo;
unsigned long flags;
int rx_fifo = ((struct _instance_data *)(file->private_data))->rx_index;


    stat->type = CAN_TYPE_SJA1000;

    stat->baud = Baud[minor];
    /* printk(" STAT ST %d\n", CANin(minor, canstat)); */
    stat->status = CANin(minor, canstat);
    /* printk(" STAT EWL %d\n", CANin(minor, errorwarninglimit)); */
    stat->error_warning_limit = CANin(minor, errorwarninglimit);
    stat->rx_errors = CANin(minor, rxerror);
    stat->tx_errors = CANin(minor, txerror);
    stat->error_code= CANin(minor, errorcode);

    /* Disable CAN (All !!) Interrupts */
    /* !!!!!!!!!!!!!!!!!!!!! */
    /* save_flags(flags); cli(); */
    local_irq_save(flags);

    Fifo = &Rx_Buf[minor][rx_fifo];
    stat->rx_buffer_size = MAX_BUFSIZE;	/**< size of rx buffer  */
    /* number of messages */
    stat->rx_buffer_used =
    	(Fifo->head < Fifo->tail)
    	? (MAX_BUFSIZE - Fifo->tail + Fifo->head) : (Fifo->head - Fifo->tail);
    Fifo = &Tx_Buf[minor];
    stat->tx_buffer_size = MAX_BUFSIZE;	/* size of tx buffer  */
    /* number of messages */
    stat->tx_buffer_used = 
    	(Fifo->head < Fifo->tail)
    	? (MAX_BUFSIZE - Fifo->tail + Fifo->head) : (Fifo->head - Fifo->tail);
    /* Enable CAN Interrupts */
    /* !!!!!!!!!!!!!!!!!!!!! */
    /* restore_flags(flags); */
    local_irq_restore(flags);
    return 0;
}

int CAN_ChipReset (int minor)
{
u8 status;
/* int i; */

    DBGin();
    DBGprint(DBG_DATA,(" INT 0x%x", CANin(minor, canirq)));

    CANout(minor, canmode, CAN_RESET_REQUEST);



    /* for(i = 0; i < 100; i++) SLOW_DOWN_IO; */
    udelay(10);

    status = CANin(minor, canstat);

    DBGprint(DBG_DATA,("status=0x%x mode=0x%x", status,
	    CANin(minor, canmode) ));
#if 0
    if( ! (CANin(minor, canmode) & CAN_RESET_REQUEST ) ){
	    printk("ERROR: no board present!\n");
	    /* MOD_DEC_USE_COUNT; */
#if defined(PCM3680) || defined(CPC104) || defined(CPC_PCM_104)
	    CAN_Release(minor);
#endif
	    DBGout();return -1;
    }
#endif

    DBGprint(DBG_DATA, ("[%d] CAN_mode 0x%x", minor, CANin(minor, canmode)));
    /* select mode: Basic or PeliCAN */
    CANout(minor, canclk, CAN_MODE_PELICAN + CAN_MODE_CLK);
    CANout(minor, canmode, CAN_RESET_REQUEST + CAN_MODE_DEF);
    
    /* Board specific output control */
    if (Outc[minor] == 0) {
	Outc[minor] = CAN_OUTC_VAL; 
    }
    CANout(minor, canoutc, Outc[minor]);

    CAN_SetTiming(minor, Baud[minor]    );
    CAN_SetMask  (minor, AccCode[minor], AccMask[minor] );
    DBGprint(DBG_DATA, ("[%d] CAN_mode 0x%x", minor, CANin(minor, canmode)));

    /* can_dump(minor); */
    DBGout();
    return 0;
}


/*
 * Configures bit timing registers directly. Chip must be in bus off state.
 */
int CAN_SetBTR (int minor, int btr0, int btr1)
{
    DBGin();
    DBGprint(DBG_DATA, ("[%d] btr0=%d, btr1=%d", minor, btr0, btr1));

    /* select mode: Basic or PeliCAN */
    CANout(minor, canclk, CAN_MODE_PELICAN + CAN_MODE_CLK);
    CANout(minor, cantim0, (u8) (btr0 & 0xff));
    CANout(minor, cantim1, (u8) (btr1 & 0xff));
    DBGprint(DBG_DATA,("tim0=0x%x tim1=0x%x", CANin(minor, cantim0), CANin(minor, cantim1)) );
    DBGout();
    return 0;
}


/*
 * Configures bit timing. Chip must be in bus off state.
 */
int CAN_SetTiming (int minor, int baud)
{
int i = 5;
int custom=0;
int isopen;

    DBGin();

    isopen = atomic_read(&Can_isopen[minor]);
    if ((isopen > 1) && (Baud[minor] != baud)) {
	DBGprint(DBG_DATA, ("isopen = %d", isopen));
	DBGprint(DBG_DATA, ("refused baud[%d]=%d already set to %d",
					minor, baud, Baud[minor]));
	return -1;
    }

    DBGprint(DBG_DATA, ("baud[%d]=%d", minor, baud));
    switch(baud)
    {
	case   10: i = 0; break;
	case   20: i = 1; break;
	case   50: i = 2; break;
	case  100: i = 3; break;
	case  125: i = 4; break;
	case  250: i = 5; break;
	case  500: i = 6; break;
	case  800: i = 7; break;
	case 1000: i = 8; break;
	default  : 
		custom=1;
    }
    /* select mode: Basic or PeliCAN */
    CANout(minor, canclk, CAN_MODE_PELICAN + CAN_MODE_CLK);
    if( custom ) {
       CANout(minor, cantim0, (u8) (baud >> 8) & 0xff);
       CANout(minor, cantim1, (u8) (baud & 0xff ));
    } else {
       CANout(minor,cantim0, (u8) CanTiming[i][0]);
       CANout(minor,cantim1, (u8) CanTiming[i][1]);
    }
    DBGprint(DBG_DATA,("tim0=0x%x tim1=0x%x",
    		CANin(minor, cantim0), CANin(minor, cantim1)) );

    DBGout();
    return 0;
}


int CAN_StartChip (int minor)
{
/* int i; */
    RxErr[minor] = TxErr[minor] = 0L;
    DBGin();
    DBGprint(DBG_DATA, ("[%d] CAN_mode 0x%x", minor, CANin(minor, canmode)));
/*
    CANout( minor,cancmd, (CAN_RELEASE_RECEIVE_BUFFER 
			  | CAN_CLEAR_OVERRUN_STATUS) ); 
*/
    /* for(i=0;i<100;i++) SLOW_DOWN_IO; */
    udelay(10);
    /* clear interrupts, value not used */
    (void)CANin(minor, canirq);

    /* Interrupts on Rx, TX, any Status change and data overrun */
    CANset(minor, canirq_enable, (
		  CAN_OVERRUN_INT_ENABLE
		+ CAN_ERROR_INT_ENABLE
		+ CAN_TRANSMIT_INT_ENABLE
		+ CAN_RECEIVE_INT_ENABLE ));

    CANreset( minor, canmode, CAN_RESET_REQUEST );
    DBGprint(DBG_DATA,("start mode=0x%x", CANin(minor, canmode)));

    DBGout();
    return 0;
}


int CAN_StopChip (int minor)
{
    DBGin();
    CANset(minor, canmode, CAN_RESET_REQUEST );
    DBGout();
    return 0;
}

/* set value of the output control register */
int CAN_SetOMode (int minor, int arg)
{

    DBGin();
	DBGprint(DBG_DATA,("[%d] outc=0x%x", minor, arg));
	CANout(minor, canoutc, arg);

    DBGout();
    return 0;
}

/*
Listen-Only Mode
In listen-only mode, the CAN module is able to receive messages
without giving an acknowledgment.
Since the module does not influence the CAN bus in this mode
the host device is capable of functioning like a monitor
or for automatic bit-rate detection.

 must be done after CMD_START (CAN_StopChip)
 and before CMD_START (CAN_StartChip)
*/
int CAN_SetListenOnlyMode (int minor,
	int arg)	/* true - set Listen Only, false - reset */
{
    DBGin();
    if (arg) {
	CANset(minor, canmode, CAN_LISTEN_ONLY_MODE);
    } else {
	CANreset(minor, canmode, CAN_LISTEN_ONLY_MODE );
    }

    DBGout();
    return 0;
}

int CAN_SetMask (int minor, unsigned int code, unsigned int mask)
{
#ifdef CPC_PCI
# define R_OFF 4 /* offset 4 for the EMS CPC-PCI card */
#else
# define R_OFF 1
#endif

    DBGin();
    DBGprint(DBG_DATA,("[%d] acc=0x%x mask=0x%x",  minor, code, mask));
    CANout(minor, frameinfo,
			(unsigned char)((unsigned int)(code >> 24) & 0xff));	
    CANout(minor, frame.extframe.canid1,
			(unsigned char)((unsigned int)(code >> 16) & 0xff));	
    CANout(minor, frame.extframe.canid2,
			(unsigned char)((unsigned int)(code >>  8) & 0xff));	
    CANout(minor, frame.extframe.canid3,
    			(unsigned char)((unsigned int)(code >>  0 ) & 0xff));	

    CANout(minor, frame.extframe.canid4,
			(unsigned char)((unsigned int)(mask >> 24) & 0xff));
    CANout(minor, frame.extframe.canxdata[0 * R_OFF],
			(unsigned char)((unsigned int)(mask >> 16) & 0xff));
    CANout(minor, frame.extframe.canxdata[1 * R_OFF],
			(unsigned char)((unsigned int)(mask >>  8) & 0xff));
    CANout(minor, frame.extframe.canxdata[2 * R_OFF],
			(unsigned char)((unsigned int)(mask >>  0) & 0xff));

    /* put values back in global variables for sysctl */
    AccCode[minor] = code;
    AccMask[minor] = mask;
    DBGout();
    return 0;
}




/* 
Single CAN frames or the very first Message are copied into the CAN controller
using this function. After that an transmission request is set in the
CAN controllers command register.
After a succesful transmission, an interrupt will be generated,
which will be handled in the CAN ISR CAN_Interrupt()
*/
int CAN_SendMessage (int minor, canmsg_t *tx)
{
int i = 0;
int ext;			/* message format to send */
u8 tx2reg, stat;

    DBGin();

    while ( ! ((stat=CANin(minor, canstat)) & CAN_TRANSMIT_BUFFER_ACCESS)) {
	    #if LINUX_VERSION_CODE >= 131587
	    # if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
	    cond_resched();
	    # else
	    if( current->need_resched ) schedule();
	    # endif
	    #else
	    if( need_resched ) schedule();
	    #endif
    }

    DBGprint(DBG_DATA,(
    		"CAN[%d]: tx.flags=%d tx.id=0x%lx tx.length=%d stat=0x%x",
		minor, tx->flags, tx->id, tx->length, stat));

    tx->length %= 9;			/* limit CAN message length to 8 */
    ext = (tx->flags & MSG_EXT);	/* read message format */

    /* fill the frame info and identifier fields */
    tx2reg = tx->length;
    if( tx->flags & MSG_RTR) {
	    tx2reg |= CAN_RTR;
    }

    if(ext) {
    DBGprint(DBG_DATA, ("---> send ext message"));
	CANout(minor, frameinfo, CAN_EFF + tx2reg);
	CANout(minor, frame.extframe.canid1, (u8)(tx->id >> 21));
	CANout(minor, frame.extframe.canid2, (u8)(tx->id >> 13));
	CANout(minor, frame.extframe.canid3, (u8)(tx->id >> 5));
	CANout(minor, frame.extframe.canid4, (u8)(tx->id << 3) & 0xff);

    } else {
	DBGprint(DBG_DATA, ("---> send std message"));
	CANout(minor, frameinfo, CAN_SFF + tx2reg);
	CANout(minor, frame.stdframe.canid1, (u8)((tx->id) >> 3) );
	CANout(minor, frame.stdframe.canid2, (u8)(tx->id << 5 ) & 0xe0);
    }

    /* - fill data ---------------------------------------------------- */
    if(ext) {
	for( i=0; i < tx->length ; i++) {
	    CANout( minor, frame.extframe.canxdata[R_OFF * i], tx->data[i]);
	    	/* SLOW_DOWN_IO; SLOW_DOWN_IO; */
	}
    } else {
	for( i=0; i < tx->length ; i++) {
	    CANout( minor, frame.stdframe.candata[R_OFF * i], tx->data[i]);
	    	/* SLOW_DOWN_IO; SLOW_DOWN_IO; */
	}
    }
    /* - /end --------------------------------------------------------- */
    CANout(minor, cancmd, CAN_TRANSMISSION_REQUEST );

    /* 
     * Save last message that was sent.
     * Since can4linux 3.5 multiple processes can access
     * one CAN interface. On a CAN interrupt this message is copied into 
     * the receive queue of each process that opened this same CAN interface.
     */
    memcpy(
	(void *)&last_Tx_object[minor],
	(void *)tx,
	sizeof(canmsg_t));

  DBGout();return i;
}



/*
 * The plain SJA1000 interrupt
 *
 *				RX ISR           TX ISR
 *                              8/0 byte
 *                               _____            _   ___
 *                         _____|     |____   ___| |_|   |__
 *---------------------------------------------------------------------------
 * 1) CPUPentium 75 - 200
 *  75 MHz, 149.91 bogomips
 *  AT-CAN-MINI                 42/27µs            50 µs
 *  CPC-PCI		        35/26µs		   
 * ---------------------------------------------------------------------------
 * 2) AMD Athlon(tm) Processor 1M
 *    2011.95 bogomips
 *  AT-CAN-MINI  std            24/12µs            ?? µs
 *               ext id           /14µs
 *
 * 
 * 1) 1Byte = (42-27)/8 = 1.87 µs
 * 2) 1Byte = (24-12)/8 = 1.5  µs
 *
 *
 *
 * RX Int with to Receive channels:
 * 1)                _____   ___
 *             _____|     |_|   |__
 *                   30    5  20  µs
 *   first ISR normal length,
 *   time between the two ISR -- short
 *   sec. ISR shorter than first, why? it's the same message
 */

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,18) 
irqreturn_t CAN_Interrupt( int irq, void *dev_id)
#else
irqreturn_t CAN_Interrupt( int irq, void *dev_id, struct pt_regs *notused)
#endif
{
int minor;
int i = 0;
int rx_fifo;
struct timeval  timestamp;
unsigned long flags;
int ext;			/* flag for extended message format */
int irqsrc, dummy;
msg_fifo_t   *RxFifo; 
msg_fifo_t   *TxFifo;
#if CAN_USE_FILTER
msg_filter_t *RxPass;
unsigned int id;
#endif 
#if 1
int first = 0;
#endif 

#if CONFIG_TIME_MEASURE
    /* outb(0xff, 0x378);   */
    /* set port to high */
    set_measure_pin();
#endif


    minor = *(int *)dev_id;
//    printk("CAN - ISR ; minor = %d\n", *(int *)dev_id); 


    RxFifo = &Rx_Buf[minor][0]; 
    TxFifo = &Tx_Buf[minor];
#if CAN_USE_FILTER
    RxPass = &Rx_Filter[minor];
#endif 

    /* Disable PITA Interrupt */
    /* writel(0x00000000, Can_pitapci_control[minor] + 0x0); */

    irqsrc = CANin(minor, canirq);
    if(irqsrc == 0) {
//	printk("it's not for me, bye\n");
         /* first call to ISR, it's not for me ! */
#if CONFIG_TIME_MEASURE
	reset_measure_pin();
#endif
#if LINUX_VERSION_CODE >= 0x020500 
	return IRQ_RETVAL(IRQ_NONE);
#else
	goto IRQdone_doneNothing;
#endif
    }
#if defined(CCPC104)
	pc104_irqack();
#endif

    do {
    /* loop as long as the CAN controller shows interrupts */
    DBGprint(DBG_DATA, (" => got IRQ[%d]: 0x%0x", minor, irqsrc));
    /* can_dump(minor); */

    /* fill timestamp as first action. 
     * Getting a precises time takes a lot of time
     * (additional 7 µs of ISR time )
     * if a time stamp is not needed, it can be switched of
     * by ioctl() */
    if (use_timestamp[minor]) {
	do_gettimeofday(&timestamp);
    } else {
	timestamp.tv_sec  = 0;
	timestamp.tv_usec = 0;
    }

    for(rx_fifo = 0; rx_fifo < CAN_MAX_OPEN; rx_fifo++) {
	RxFifo = &Rx_Buf[minor][rx_fifo];

	RxFifo->data[RxFifo->head].timestamp = timestamp;

	/* preset flags */
	(RxFifo->data[RxFifo->head]).flags =
        		(RxFifo->status & BUF_OVERRUN ? MSG_BOVR : 0);
    }

#if 1
    /* how often do we loop through the ISR ? */
    /* if(first) printk("n = %d\n", first); */
    first++;
    if (first > 10) return IRQ_RETVAL(IRQ_HANDLED);
#endif


    /*========== receive interrupt */
    if( irqsrc & CAN_RECEIVE_INT ) {
    	int length;

        /* printk(" CAN RX %d\n", minor); */
	dummy  = CANin(minor, frameinfo );

/* ---------- fill frame data -------------------------------- */
    /* handle all subscribed rx fifos */

    for(rx_fifo = 0; rx_fifo < CAN_MAX_OPEN; rx_fifo++) {
	/* for every rx fifo */

	/* printk(KERN_INFO " used fifos [%d][%d] = %d\n", minor, rx_fifo, */
	    /* CanWaitFlag[minor][rx_fifo]); */

	if (CanWaitFlag[minor][rx_fifo] == 1) {
	    /* this FIFO is in use */
	    RxFifo = &Rx_Buf[minor][rx_fifo]; /* prepare buffer to be used */
/* printk(KERN_INFO "> filling buffer [%d][%d]\n", minor, rx_fifo);  */

	    if( dummy & CAN_RTR ) {
		(RxFifo->data[RxFifo->head]).flags |= MSG_RTR;
	    }

	    if( dummy & CAN_EFF ) {
		(RxFifo->data[RxFifo->head]).flags |= MSG_EXT;
	    }
	    ext = (dummy & CAN_EFF);
	    if(ext) {
	        (RxFifo->data[RxFifo->head]).id =
	          ((unsigned int)(CANin(minor, frame.extframe.canid1)) << 21)
		+ ((unsigned int)(CANin(minor, frame.extframe.canid2)) << 13)
		+ ((unsigned int)(CANin(minor, frame.extframe.canid3)) << 5)
		+ ((unsigned int)(CANin(minor, frame.extframe.canid4)) >> 3);
	    } else {
	        (RxFifo->data[RxFifo->head]).id =
        	(
        	  ((unsigned int)(CANin(minor, frame.stdframe.canid1 )) << 3) 
        	+ ((unsigned int)(CANin(minor, frame.stdframe.canid2 )) >> 5)
		) & CAN_SFF_MASK
        	;
	}
	    /* get message length as received in the frame */
	    length = dummy  & 0x0f;			/* strip length code */ 
	    (RxFifo->data[RxFifo->head]).length = length;

	    length %= 9;	/* limit count to 8 bytes for number of data */
	    for( i = 0; i < length; i++) {
		/* SLOW_DOWN_IO;SLOW_DOWN_IO; */
		if(ext) {
		    (RxFifo->data[RxFifo->head]).data[i] =
			    CANin(minor, frame.extframe.canxdata[R_OFF * i]);
		} else {
		    (RxFifo->data[RxFifo->head]).data[i] =
			    CANin(minor, frame.stdframe.candata[R_OFF * i]);
		}
	    }

	    /* mark just written entry as OK and full */
	    RxFifo->status = BUF_OK;
	    /* Handle buffer wrap-around */
	    ++(RxFifo->head);
	    RxFifo->head %= MAX_BUFSIZE;
	    if(RxFifo->head == RxFifo->tail) {
		    printk("CAN[%d][%d] RX: FIFO overrun\n", minor, rx_fifo);
		    RxFifo->status = BUF_OVERRUN;
	    } 

	    /*---------- kick the select() call  -*/
	    /* This function will wake up all processes
	       that are waiting on this event queue,
	       that are in interruptible sleep
	    */
	/* printk(KERN_INFO " should wake [%d][%d]\n", minor, rx_fifo); */
	    wake_up_interruptible(&CanWait[minor][rx_fifo]); 

	}
    }
/* ---------- / fill frame data -------------------------------- */

        /* release the CAN controller now */
        CANout(minor, cancmd, CAN_RELEASE_RECEIVE_BUFFER );
        if(CANin(minor, canstat) & CAN_DATA_OVERRUN ) {
		 printk("CAN[%d] Rx: Overrun Status \n", minor);
		 CANout(minor, cancmd, CAN_CLEAR_OVERRUN_STATUS );
	}

   }

    /*========== transmit interrupt */
    if( irqsrc & CAN_TRANSMIT_INT ) {
	/* CAN frame successfully sent */
	u8 tx2reg;
	unsigned int id;

	/* use time stamp sampled with last INT */
	last_Tx_object[minor].timestamp = timestamp;

	/* depending on the number of open processes
	 * the TX data has to be copied in different
	 * rx fifos
	 */
	for(rx_fifo = 0; rx_fifo < CAN_MAX_OPEN; rx_fifo++) {
	    /* for every rx fifo */
	    if (CanWaitFlag[minor][rx_fifo] == 1) {
		/* this FIFO is in use */
		/* printk(KERN_INFO "self copy to [%d][%d]\n", minor, rx_fifo); */
		    
		/*
		 * Don't copy the message in the receive queue
		 * of the process that sent the message unless
		 * this process requested selfreception.
		 */
		if ((last_Tx_object[minor].cob == rx_fifo) && 
		    (selfreception[minor][rx_fifo] == 0))
		{
		    /* printk("CAN[%d][%d] Don't copy message in my queue\n", minor, rx_fifo); */
		    continue;
		}

#ifdef VERBOSE
		printk(
		"CAN[%d][%d] Copy message from %d in queue id 0x%lx 0x%x\n",
		        minor, rx_fifo,
			last_Tx_object[minor].cob,
			last_Tx_object[minor].id,
			last_Tx_object[minor].data[0]);
#endif
		/* prepare buffer to be used */
		RxFifo = &Rx_Buf[minor][rx_fifo];


		memcpy(  
		    (void *)&RxFifo->data[RxFifo->head],
		    (void *)&last_Tx_object[minor],
		    sizeof(canmsg_t));
		
		/* Mark message as 'self sent/received' */
		RxFifo->data[RxFifo->head].flags |= MSG_SELF;

		/* increment write index */
		RxFifo->status = BUF_OK;
		++(RxFifo->head);
		RxFifo->head %= MAX_BUFSIZE;

		if(RxFifo->head == RxFifo->tail) {
		    printk("CAN[%d][%d] RX: FIFO overrun\n", minor, rx_fifo);
		    RxFifo->status = BUF_OVERRUN;
		} 
		/*---------- kick the select() call  -*/
		/* This function will wake up all processes
		   that are waiting on this event queue,
		   that are in interruptible sleep
		*/
		wake_up_interruptible(&CanWait[minor][rx_fifo]); 
	    } /* this FIFO is in use */
	} /* end for loop filling all rx-fifos */


	if( TxFifo->free[TxFifo->tail] == BUF_EMPTY ) {
	    /* TX FIFO empty, nothing more to sent */
	    /* printk("TXE\n"); */
	    TxFifo->status = BUF_EMPTY;
            TxFifo->active = 0;
	    /* This function will wake up all processes
	       that are waiting on this event queue,
	       that are in interruptible sleep
	    */
	    wake_up_interruptible(&CanOutWait[minor]); 
            goto Tx_done;
	}

        /* enter critical section */
	local_irq_save(flags);

	/* The TX message FIFO contains other CAN frames to be sent
	 * The next frame in the FIFO is copied into the last_Tx_object
	 * and directly into the hardware of the CAN controller
	 */
	memcpy(
		(void *)&last_Tx_object[minor],
		(void *)&TxFifo->data[TxFifo->tail],
		sizeof(canmsg_t));

	tx2reg = (TxFifo->data[TxFifo->tail]).length;
	if( (TxFifo->data[TxFifo->tail]).flags & MSG_RTR) {
		tx2reg |= CAN_RTR;
	}
        ext = (TxFifo->data[TxFifo->tail]).flags & MSG_EXT;
        id = (TxFifo->data[TxFifo->tail]).id;
        if(ext) {
	    DBGprint(DBG_DATA, ("---> send ext message"));
	    CANout(minor, frameinfo, CAN_EFF + tx2reg);
	    CANout(minor, frame.extframe.canid1, (u8)(id >> 21));
	    CANout(minor, frame.extframe.canid2, (u8)(id >> 13));
	    CANout(minor, frame.extframe.canid3, (u8)(id >> 5));
	    CANout(minor, frame.extframe.canid4, (u8)(id << 3) & 0xff);
        } else {
	    DBGprint(DBG_DATA, ("---> send std message"));
	    CANout(minor, frameinfo, CAN_SFF + tx2reg);
	    CANout(minor, frame.stdframe.canid1, (u8)((id) >> 3) );
	    CANout(minor, frame.stdframe.canid2, (u8)(id << 5 ) & 0xe0);
        }


	tx2reg &= 0x0f;		/* restore length only */
	if(ext) {
	    for( i=0; i < tx2reg ; i++) {
		CANout(minor, frame.extframe.canxdata[R_OFF * i],
		    (TxFifo->data[TxFifo->tail]).data[i]);
	    }
        } else {
	    for( i=0; i < tx2reg ; i++) {
		CANout(minor, frame.stdframe.candata[R_OFF * i],
		    (TxFifo->data[TxFifo->tail]).data[i]);
	    }
        }

        CANout(minor, cancmd, CAN_TRANSMISSION_REQUEST );

	TxFifo->free[TxFifo->tail] = BUF_EMPTY; /* now this entry is EMPTY */
	++(TxFifo->tail);
	TxFifo->tail %= MAX_BUFSIZE;

        /* leave critical section */
	local_irq_restore(flags);
   }
Tx_done:
   /*========== error status */
   if( irqsrc & CAN_ERROR_INT ) {
   unsigned int status;
   unsigned int flags = 0;

	/* printk("CAN[%d]: error interrupt!\n", minor); */
        TxErr[minor]++;

        /* insert error */
        status = CANin(minor,canstat);
        if(status & CAN_BUS_STATUS ) {
	    flags |= MSG_BUSOFF;
	    TxErr[minor]++;
	    (RxFifo->data[RxFifo->head]).flags |= MSG_BUSOFF; 
	    /* printk(" MSG_BUSOF\n"); */
        }
        if(status & CAN_ERROR_STATUS) {
	    flags |= MSG_PASSIVE;
	    TxErr[minor]++;
	    (RxFifo->data[RxFifo->head]).flags |= MSG_PASSIVE; 
	    /* printk(" MSG_PASSIVE\n"); */
        }

	for(rx_fifo = 0; rx_fifo < CAN_MAX_OPEN; rx_fifo++) {
	    /* for every rx fifo */
	    if (CanWaitFlag[minor][rx_fifo] == 1) {
		/* this FIFO is in use */
		RxFifo = &Rx_Buf[minor][rx_fifo]; /* prepare buffer to be used */
		(RxFifo->data[RxFifo->head]).flags += flags; 
		(RxFifo->data[RxFifo->head]).id = CANDRIVERERROR;
        	(RxFifo->data[RxFifo->head]).length = 0;
		RxFifo->status = BUF_OK;

		/* handle fifo wrap around */
		++(RxFifo->head);
		RxFifo->head %= MAX_BUFSIZE;
		if(RxFifo->head == RxFifo->tail) {
		    printk("CAN[%d][%d] RX: FIFO overrun\n", minor, rx_fifo);
		    RxFifo->status = BUF_OVERRUN;
		} 
		/* tell someone that there is a new error message */
		wake_up_interruptible(&CanWait[minor][rx_fifo]); 
	    }
	}
   }
   if( irqsrc & CAN_OVERRUN_INT ) {
   int status;
	printk("CAN[%d]: controller overrun!\n", minor);
        Overrun[minor]++;

        /* insert error */
        status = CANin(minor,canstat);
        RxErr[minor]++;

	for(rx_fifo = 0; rx_fifo < CAN_MAX_OPEN; rx_fifo++) {
	    /* for every rx fifo */
	    if (CanWaitFlag[minor][rx_fifo] == 1) {
		/* this FIFO is in use */
		if(status & CAN_DATA_OVERRUN)
		    (RxFifo->data[RxFifo->head]).flags += MSG_OVR; 

		(RxFifo->data[RxFifo->head]).id = 0xFFFFFFFF;
		(RxFifo->data[RxFifo->head]).length = 0;
		RxFifo->status = BUF_OK;
		++(RxFifo->head);
		RxFifo->head %= MAX_BUFSIZE;
		if(RxFifo->head == RxFifo->tail) {
		    printk("CAN[%d][%d] RX: FIFO overrun\n", minor, rx_fifo);
		    RxFifo->status = BUF_OVERRUN;
		} 
		/* tell someone that there is a new error message */
		wake_up_interruptible(&CanWait[minor][rx_fifo]); 
	    }
	}

        CANout(minor, cancmd, CAN_CLEAR_OVERRUN_STATUS );
   } 
   } while( (irqsrc = CANin(minor, canirq)) != 0);

/* IRQdone: */
    DBGprint(DBG_DATA, (" => leave IRQ[%d]", minor));

    /* 
      EMS macht es anders.
      Tritt ein Interrupt auf, werden alle möglichen
      CAN controller abgerappelt
      und erst zum Schluss board_clear_interrupts() aufgerufen
     */
    board_clear_interrupts(minor);

#if LINUX_VERSION_CODE < 0x020500 
IRQdone_doneNothing:
#endif

#if CONFIG_TIME_MEASURE
    /* outb(0x00, 0x378);   */
    reset_measure_pin();
#endif

    return IRQ_RETVAL(IRQ_HANDLED);
}


