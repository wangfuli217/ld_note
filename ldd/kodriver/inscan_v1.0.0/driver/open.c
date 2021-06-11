/*
 * can_open - can4linux CAN driver module
 *
 * can4linux -- LINUX CAN device driver source
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 *
 * 
 * Copyright (c) 2001 port GmbH Halle/Saale
 * (c) 2001 Heinz-Jürgen Oertel (oe@port.de)
 *          Claus Schroeter (clausi@chemie.fu-berlin.de)
 *------------------------------------------------------------------
 * $Header: /z2/cvsroot/products/0530/software/can4linux/src/open.c,v 1.8 2009/06/03 14:27:56 oe Exp $
 *
 *--------------------------------------------------------------------------
 *
 *
 *
 *
 *--------------------------------------------------------------------------
 */


/**
* \file open.c
* \author Heinz-Jürgen Oertel, port GmbH
* $Revision: 1.8 $
* $Date: 2009/06/03 14:27:56 $
*
*
*/


/* header of standard C - libraries */

/* header of common types */

/* shared common header */

/* header of project specific types */

/* project headers */
#include "defs.h"

/* local header */

/* constant definitions
---------------------------------------------------------------------------*/

/* local defined data types
---------------------------------------------------------------------------*/
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39) 
DEFINE_SPINLOCK(waitflag_lock ); 
#else
static spinlock_t waitflag_lock = SPIN_LOCK_UNLOCKED;
#endif

/* list of external used functions, if not in headers
---------------------------------------------------------------------------*/

/* list of global defined functions
---------------------------------------------------------------------------*/

/* list of local defined functions
---------------------------------------------------------------------------*/

/* external variables
---------------------------------------------------------------------------*/

/* global variables
---------------------------------------------------------------------------*/
/* device minor already opened */
/* For Can_isopen[minor] we use an atomic variable !!  page 85 Quade */
atomic_t Can_isopen[MAX_CHANNELS];

/* local defined variables
---------------------------------------------------------------------------*/
/* static char _rcsid[] = "$Id: open.c,v 1.8 2009/06/03 14:27:56 oe Exp $"; */


/***************************************************************************/
/**
*
* \brief int open(const char *pathname, int flags);
* opens the CAN device for following operations
* \param pathname device pathname, usual /dev/can?
* \param flags is one of \c O_RDONLY, \c O_WRONLY or \c O_RDWR which request
*       opening  the  file  read-only,  write-only  or read/write,
*       respectively.
*
*
* The open call is used to "open" the device.
* Doing a first initialization according the to values in the /proc/sys/Can
* file system.
* Additional an ISR function is assigned to the IRQ.
*
* The CLK OUT pin is configured for creating the same frequency
* like the chips input frequency fclk (XTAL). 
*
* If Vendor Option \a VendOpt is set to 's' the driver performs
* an hardware reset befor initializing the chip.
*
* If compiled with CAN_MAX_OPEN > 1, open() can be called more than once.
*
* \returns
* open return the new file descriptor,
* or -1 if an error occurred (in which case, errno is set appropriately).
*
* \par ERRORS
* the following errors can occur
* \arg \c ENXIO  the file is a device special file
* and no corresponding device exists.
* \arg \c EINVAL illegal \b minor device number
* \arg \c EINVAL wrong IO-model format in /proc/sys/Can/IOmodel
* \arg \c EBUSY  IRQ for hardware is not available
* \arg \c EBUSY  I/O region for hardware is not available

*/
int CAN_VendorInit(int minor)
{
   if (IOModel[minor] == 'm')
   {
	return CAN_VendorInit_isa (minor);
   }
   else
   {
	return CAN_VendorInit_pci (minor);
   }
}
int can_open( __LDDK_OPEN_PARAM ) /*struct inode *inode, struct file *file */
{
int retval = 0;
struct _instance_data *iptr;		/* pointer to privtae data */
unsigned int minor = iminor(inode);

    DBGin();

	if( minor >= MAX_CHANNELS )
	{
	    printk(KERN_ERR "CAN: Illegal minor number %d\n", minor);
	    DBGout();
	    return -EINVAL;
	}
	/* Base address only makes sensen in tradional parallel buses
	 * would should we put in here for SPI ?
	 */
	if( Base[minor] == 0x00) {
	    /* No device available */
	    printk(KERN_ERR "CAN[%d]: no device available\n", minor);
	    DBGout();
	    return -ENXIO;
	}

	if( CAN_MAX_OPEN == atomic_read(&Can_isopen[minor])) {
	    /* number of allowed open processes exceeded */
	    printk(KERN_ERR "CAN[%d]: max number of open() calls reached\n",
	    		minor);
	    DBGout();
	    return -ENXIO;
	}

	/* do things that have do be done the first time open() is called */
	if(0 == atomic_read(&Can_isopen[minor])) {
	    /* first time called, initialize hardware and global data */

	    /* the following does all the board specific things
	       also memory remapping if necessary
	       and the CAN ISR is assigned */
	    if( (retval = CAN_VendorInit(minor)) < 0 ){
		DBGout();
		return retval;
	    }
	    /* Access macros based in can_base[] should work now */
	    /* CAN_ShowStat(minor); */

	    /* tx fifo needs only to be inizialized the first time
	     * CAN is opened */
	    Can_TxFifoInit(minor);
	}

	/* per open() call */
	iptr = (struct _instance_data *)
	        kmalloc(sizeof(struct _instance_data), GFP_KERNEL);
	if( iptr == 0) {
	    printk(KERN_ERR "not enough kernel memory\n");
	    return -ENOMEM;
	}

	{
	/* look for free queue , rx_fifo
	 * if two or more processes open at the same time
	 * we can have a race condition.
	 * Therefore this code is secured by a spin lock
	 */
	int i;
	    spin_lock(&waitflag_lock);
	    for(i = 0; i < CAN_MAX_OPEN; i++) {
		if(CanWaitFlag[minor][i] == 0) break;
	    }
	    spin_unlock(&waitflag_lock);

	    /* iptr->rx_index     = atomic_read(&Can_isopen[minor]); */
	    iptr->rx_index     = i;
	}

	selfreception[minor][iptr->rx_index] = 0;
	file->private_data = (void *)iptr;


	/* initialize and mark used rx buffer in flags field */
	Can_RxFifoInit(minor, iptr->rx_index);

#if CAN_USE_FILTER
	Can_FilterInit(minor, iptr->rx_index);
#endif

	/* Last step
	 * if first time CAN is opened, reset the CAN controller
	 * and start it
	 */
	if(0 == atomic_read(&Can_isopen[minor])) {
	    if( CAN_ChipReset(minor) < 0 ) {
		retval = -EINVAL;
		goto leave_and_free;
	    }
	    CAN_StartChip(minor); /* enables interrupts */
#if XDEBUG
	    CAN_ShowStat(minor);
	    CAN_register_dump(minor);
	    {
		int i;
		for(i = 16; i < 20; i++) {
			CAN_object_dump(minor, i);
		}
	     }
#endif
	}

	/* flag device in use */
	/* ++Can_isopen[minor]; */
	atomic_inc(&Can_isopen[minor]);
    DBGout();
    return 0;

leave_and_free:
    kfree(file->private_data);
    DBGout();
    return retval;
    DBGout();

}
