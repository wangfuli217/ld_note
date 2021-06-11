/* can_select
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
 * $Header: /z2/cvsroot/products/0530/software/can4linux/src/select.c,v 1.2 2007/07/16 07:34:06 oe Exp $
 *
 *--------------------------------------------------------------------------
 *
 *
 *
 *
 */
#include "defs.h"

__LDDK_SELECT_TYPE can_select( __LDDK_SELECT_PARAM )
{

unsigned int minor = __LDDK_MINOR;
int rx_fifoindex =
		((struct _instance_data *)(file->private_data))->rx_index;
msg_fifo_t *RxFifo = &Rx_Buf[minor][rx_fifoindex];
msg_fifo_t *TxFifo = &Tx_Buf[minor];
unsigned int mask = 0;

    /* DBGin("can_select"); */
	    /* DBGprint(DBG_DATA,("minor = %d", minor)); */
#ifdef DEBUG
    /* CAN_ShowStat(minor); */
#endif

    /* DBGprint(DBG_BRANCH,("POLL: fifo empty,poll waiting...\n")); */

    /* every event queue that could wake up the process
     * and change the status of the poll operation
     * can be added to the poll_table structure by
     * calling the function poll_wait:  
     */
    /*     _select para, wait queue, _select para */
    poll_wait(file, &CanWait[minor][rx_fifoindex], wait);
    poll_wait(file, &CanOutWait[minor] , wait);

    /* DBGprint(DBG_BRANCH,("POLL: wait returned \n")); */
    if( RxFifo->head != RxFifo->tail ) {
	/* fifo has some telegrams */
	/* Return a bit mask
	 * describing operations that could be immediately performed
	 * without blocking.
	 */
	/*
	 * POLLIN This bit must be set
	 *        if the device can be read without blocking. 
	 * POLLRDNORM This bit must be set
	 * if "normal'' data is available for reading.
	 * A readable device returns (POLLIN | POLLRDNORM)
	 *
	 *
	 *
	 */
	mask |= POLLIN | POLLRDNORM;	/* readable */
    }
    if( TxFifo->head == TxFifo->tail ) {
	/* fifo is empty */
	/* Return a bit mask
	 * describing operations that could be immediately performed
	 * without blocking.
	 */
	/*
	 * POLLOUT This bit must be set
	 *        if the device can be written without blocking. 
	 * POLLWRNORM This bit must be set
	 */
	mask |= POLLOUT | POLLWRNORM;	/* writeable */
    }
    /* DBGout(); */
    return mask;
}
