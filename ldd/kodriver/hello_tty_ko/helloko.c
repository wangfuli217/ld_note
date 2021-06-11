/*
 * =====================================================================================
 *
 *       Filename:  helloko.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年11月29日 21时52分10秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:   (), 
 *        Company:  
 *
 * =====================================================================================
 */
#include "linux/init.h"
#include "linux/kernel.h"
#include "linux/module.h"

#include <linux/module.h>
#include <linux/tty.h>
#include <linux/ioport.h>
#include <linux/init.h>
#include <linux/console.h>
#include <linux/sysrq.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/pci.h>
#include <linux/sched.h>
#include <linux/string.h>
#include <linux/kernel.h>
#include <linux/slab.h>

#include <linux/tty.h>
#include <linux/tty_flip.h>
#include <linux/serial_reg.h>
#include <linux/serial.h>
#include <linux/serial_core.h>


#include <asm/io.h>
#include <asm/irq.h>
#include <asm/irq.h>
#include <asm/bitops.h>
#include <asm/byteorder.h>
#include <asm/serial.h>
#include <asm/io.h>
#include <asm/uaccess.h>

#include "linux/version.h"

#define DEBUG
#define SF	printk("%s+++++\n",__func__)
MODULE_LICENSE("GPL");

struct uart_adv_port {
	struct uart_port	port;
	struct timer_list	timer;		    /* "no irq" timer */
	struct list_head	list;		    /* ports on this IRQ */
	unsigned short		capabilities;	/* port capabilities */
	unsigned short		bugs;		    /* port bugs */
	unsigned int		tx_loadsz;	    /* transmit fifo load size */
	unsigned char		acr;
	unsigned char		ier;
	unsigned char		lcr;
	unsigned char		mcr;
	unsigned char		mcr_mask;	    /* mask of user bits */
	unsigned char		mcr_force;	    /* mask of forced bits */

	unsigned char		lsr_saved_flags;
	unsigned char		msr_saved_flags;

	unsigned short 		deviceid;

	/*
	 * We provide a per-port pm hook.
	 */
	void			    (*pm)(struct uart_port *port,
                            unsigned int state, unsigned int old);

	int 			    index;		    /* serial index in card, start at 0 */
	int			        serialMode;	    /* RS232 or RS422 or RS485 */
};

#define NR_PORTS	                256

static struct uart_adv_port serialadv_ports[NR_PORTS];


static void showUart(struct uart_port *port)
{
	struct circ_buf *xmit = &port->state->xmit;
	printk("%s:fifosize=%d\n",__func__,port->fifosize);
	printk("%s:xmit->head=%d,tail=%d\n",__func__,xmit->head,xmit->tail);

}

static unsigned int serialadv_tx_empty(struct uart_port *port)
{
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//	unsigned long flags;
//	unsigned int lsr;
//
//	spin_lock_irqsave(&up->port.lock, flags);
//	lsr = serial_in(up, UART_LSR);
//	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
//	spin_unlock_irqrestore(&up->port.lock, flags);
//
//	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
	SF;
	return TIOCSER_TEMT;
}


static unsigned int serialadv_get_mctrl(struct uart_port *port)
{
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//	unsigned int status;
	unsigned int ret;
//
//	status = check_modem_status(up);
//
	ret = 0;
//	if (status & UART_MSR_DCD)
		ret |= TIOCM_CAR;
//	if (status & UART_MSR_RI)
		ret |= TIOCM_RNG;
//	if (status & UART_MSR_DSR)
		ret |= TIOCM_DSR;
//	if (status & UART_MSR_CTS)
		ret |= TIOCM_CTS;
	SF;
	return ret;
}

static void serialadv_set_mctrl(struct uart_port *port, unsigned int mctrl)
{
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//	unsigned char mcr = 0;
//
//	if (mctrl & TIOCM_RTS)
//		mcr |= UART_MCR_RTS;
//	if (mctrl & TIOCM_DTR)
//		mcr |= UART_MCR_DTR;
//	if (mctrl & TIOCM_OUT1)
//		mcr |= UART_MCR_OUT1;
//	if (mctrl & TIOCM_OUT2)
//		mcr |= UART_MCR_OUT2;
//	if (mctrl & TIOCM_LOOP)
//		mcr |= UART_MCR_LOOP;
//
//	mcr = (mcr & up->mcr_mask) | up->mcr_force | up->mcr;
//	serial_out(up, UART_MCR, mcr);
	SF;
}

static void serialadv_stop_tx(struct uart_port *port)
{
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//
//	if (up->ier & UART_IER_THRI)
//    {
//		up->ier &= ~UART_IER_THRI;
//		serial_out(up, UART_IER, up->ier);
//	}


	SF;
}

static void serialadv_start_tx(struct uart_port *port)
{

//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//	if (!(up->ier & UART_IER_THRI))
//    {
//		up->ier |= UART_IER_THRI;
//		serial_out(up, UART_IER, up->ier);
//	}
//	uart_write_wakeup(port);

//	struct uart_adv_port *up = (struct uart_adv_port *)data;
//		struct tty_struct *tty = port->state->port.tty;
////		struct uart_port *port = &up->port;
//		struct circ_buf *xmit = &port->state->xmit;
//		char ch;
//		int count = 0;
//		int ret = 0;
//
//		while(xmit->tail != xmit->head)
//		{
//			ch = xmit->buf[xmit->tail];
//			count = uart_circ_chars_pending(xmit);
//	//		count = 1;
//			printk("%s:0x%02x=%c\n",__func__,ch,ch);
//			spin_lock(&port->lock);
//	//		if (!uart_handle_sysrq_char(port, ch))
//			{
//	//			uart_insert_char(port,0, UART_LSR_OE, 'a', TTY_NORMAL);
//	//			ret = tty_insert_flip_char(tty,ch,TTY_NORMAL);
//				ret = tty_insert_flip_string(tty, &xmit->buf[xmit->tail], count);
//				port->icount.rx+= count;
//			}
//			xmit->tail += count;
//			xmit->tail &= (UART_XMIT_SIZE-1);
//			port->icount.tx += count;
//
//			spin_unlock(&port->lock);
//		}
	SF;
	showUart(port);


}

static void serialadv_stop_rx(struct uart_port *port)
{
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//
//	up->ier &= ~UART_IER_RLSI;
	port->read_status_mask &= ~UART_LSR_DR;
//	serial_out(up, UART_IER, up->ier);
	SF;
}


static void serialadv_enable_ms(struct uart_port *port)
{
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//
//	up->ier |= UART_IER_MSI;
//	serial_out(up, UART_IER, up->ier);
	SF;
}
static void serialadv_break_ctl(struct uart_port *port, int break_state)
{
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//	unsigned long flags;
//
//	spin_lock_irqsave(&up->port.lock, flags);
//	if (break_state == -1)
//		up->lcr |= UART_LCR_SBC;
//	else
//		up->lcr &= ~UART_LCR_SBC;
//	serial_out(up, UART_LCR, up->lcr);
//	spin_unlock_irqrestore(&up->port.lock, flags);
	SF;
}


static int serialadv_startup(struct uart_port *port)
{
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//	unsigned long flags;
//    int retval;
//
//	up->capabilities = uart_config[up->port.type].flags;
//
//	serial_out(up, XR_17V35X_EXTENDED_EFR, UART_EFR_ECB);
//	serial_out(up, UART_IER, 0);
//
//	/* Set the RX/TX trigger levels */
//	/* These are some default values, the OEMs can change these values
//		* according to their best case scenarios */
//
//	serial_out(up, XR_17V35X_EXTENDED_RXTRG, 192);
//	serial_out(up, XR_17V35X_EXTENDED_TXTRG, 64);
//
//
//	/* Hysteresis level of 8 */
//	serial_out(up, XR_17V35X_EXTENDED_FCTR, XR_17V35X_FCTR_TRGD | XR_17V35X_FCTR_RTS_8DELAY);
//
//	serial_out(up, UART_LCR, 0);
//
//	/* Wake up and initialize UART */
//	serial_out(up, XR_17V35X_EXTENDED_EFR, UART_EFR_ECB | 0x10/*Enable Shaded bits access*/);
//	serial_out(up,XR_17V35X_UART_MSR, 0);
//	serial_out(up, UART_IER, 0);
//	serial_out(up, UART_LCR, 0);
//
//	/*
//	 * Clear the FIFO buffers and disable them.
//	 * (they will be reeanbled in set_termios())
//	 */
//	serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO |
//			UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
//	serial_out(up, UART_FCR, 0);
//
//	/*
//	 * Clear the interrupt registers.
//	 */
//	(void) serial_in(up, UART_LSR);
//	(void) serial_in(up, UART_RX);
//	(void) serial_in(up, UART_IIR);
//	(void) serial_in(up, UART_MSR);
//
//    if(port->irq) {
//	    retval = serial_link_irq_chain(up);
//	    if(retval)
//		    return retval;
//    }
//
//	/*
//	 * Now, initialize the UART
//	 */
//	serial_out(up, UART_LCR, UART_LCR_WLEN8);
//
//	spin_lock_irqsave(&up->port.lock, flags);
//
//	/*
//	* Most PC uarts need OUT2 raised to enable interrupts.
//	*/
//	if (is_real_interrupt(up->port.irq))
//		up->port.mctrl |= TIOCM_OUT2;
//	//to enable intenal loop, uncomment the line below
//	//up->port.mctrl |= TIOCM_LOOP;
//
//	serialadv_set_mctrl(&up->port, up->port.mctrl);
//	spin_unlock_irqrestore(&up->port.lock, flags);
//
//	/*
//	 * Finally, enable interrupts.  Note: Modem status interrupts
//	 * are set via set_termios(), which will be occurring imminently
//	 * anyway, so we don't enable them here.
//	 */
//	up->ier = UART_IER_RLSI | UART_IER_RDI;
//	serial_out(up, UART_IER, up->ier);
//
//	/*
//	 * And clear the interrupt registers again for luck.
//	 */
//	(void) serial_in(up, UART_LSR);
//	(void) serial_in(up, UART_RX);
//	(void) serial_in(up, UART_IIR);
//	(void) serial_in(up, UART_MSR);
	struct uart_adv_port *uart = &serialadv_ports[0];
	add_timer(&uart->timer);
	SF;
	return 0;
}

static void serialadv_shutdown(struct uart_port *port)
{
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
	unsigned long flags;
	struct uart_adv_port *uart = &serialadv_ports[0];
	 del_timer(&uart->timer);
//
//	/*
//	 * Disable interrupts from this port
//	 */
//	up->ier = 0;
//	serial_out(up, UART_IER, 0);
//
	spin_lock_irqsave(&port->lock, flags);
//
	port->mctrl &= ~TIOCM_OUT2;
//
//	serialadv_set_mctrl(&up->port, up->port.mctrl);
	spin_unlock_irqrestore(&port->lock, flags);
//
//	/*
//	 * Disable break condition and FIFOs
//	 */
//	serial_out(up, UART_LCR, serial_in(up, UART_LCR) & ~UART_LCR_SBC);
//	serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO |
//				  UART_FCR_CLEAR_RCVR |
//				  UART_FCR_CLEAR_XMIT);
//	serial_out(up, UART_FCR, 0);
//
//	/*
//	 * Read data port to reset things, and then unlink from
//	 * the IRQ chain.
//	 */
//	(void) serial_in(up, UART_RX);
//
//    if (port->irq)
//	    serial_unlink_irq_chain(up);
//
//    /*
//     *  we reset serial, for bug 1616
//     */
//    serial_out(up, XR_17V35X_RESET, 1<<(up->index));
	SF;
}
static struct ktermios g_termios;
static void
serialadv_set_termios(struct uart_port *port, struct ktermios *termios,
		       struct ktermios *old)
//#endif
{

//	struct uart_adv_port *up = (struct uart_adv_port *)port;
	unsigned char   cval = 0;
	unsigned long   flags = 0;
//	unsigned int    baud = 0, quot = 0, quot_fraction = 0;
//
//	unsigned int    devide1 = 0;
//	unsigned char   oldEFR = 0;
//	unsigned char   oldMCR = 0;
//	unsigned char   valof4xreg = 0, valof8xreg= 0;
//
	memcpy(&g_termios,termios,sizeof(g_termios));
	switch (termios->c_cflag & CSIZE) {
	case CS5:
		cval = 0x00;
		break;
	case CS6:
		cval = 0x01;
		break;
	case CS7:
		cval = 0x02;
		break;
	default:
	case CS8:
		cval = 0x03;
		break;
	}

	if (termios->c_cflag & CSTOPB)
		cval |= 0x04;
	if (termios->c_cflag & PARENB)
		cval |= UART_LCR_PARITY;
	if (!(termios->c_cflag & PARODD))
		cval |= UART_LCR_EPAR;
#ifdef CMSPAR
	if (termios->c_cflag & CMSPAR)
		cval |= UART_LCR_SPAR;
#endif
//	/*
//	 * Ask the core to calculate the divisor for us.
//     * Add limited max baud rate as 921600.
//	 */
//	baud = uart_get_baud_rate(port, termios, old, 0, 921600);
//
//
//	serialadv_get_divisor(port, baud, &quot, &quot_fraction, &devide1);
//    DEBUG_INTR(KERN_INFO"serialadv_get_divisor::baud =%d, quot=0x%x, quot_fraction=0x%x, devide1=%d\n", baud, quot, quot_fraction, devide1);
//
//	/*
//	 * Ok, we're now changing the port state.  Do it with
//	 * interrupts disabled.
//	 */
	spin_lock_irqsave(&port->lock, flags);
//
//	/*
//	 * Update the per-port timeout.
//	 */
	uart_update_timeout(port, termios->c_cflag, 9600);
//
	port->read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_PE | UART_LSR_DR;
	if (termios->c_iflag & INPCK)
		port->read_status_mask |= UART_LSR_FE | UART_LSR_PE;
	if (termios->c_iflag & (BRKINT | PARMRK))
		port->read_status_mask |= UART_LSR_BI;
//
//	/*
//	 * Characteres to ignore
//	 */
	port->ignore_status_mask = 0;
	if (termios->c_iflag & IGNPAR)
		port->ignore_status_mask |= UART_LSR_PE | UART_LSR_FE;
	if (termios->c_iflag & IGNBRK) {
		port->ignore_status_mask |= UART_LSR_BI;
		/*
		 * If we're ignoring parity and break indicators,
		 * ignore overruns too (for real raw support).
		 */
		if (termios->c_iflag & IGNPAR)
			port->ignore_status_mask |= UART_LSR_OE;
	}

	/*
	 * ignore all characters if CREAD is not set
	 */
	if ((termios->c_cflag & CREAD) == 0)
		port->ignore_status_mask |= UART_LSR_DR;

//	/*
//	 * CTS flow control flag and modem status interrupts
//	 */
//	up->ier &= ~UART_IER_MSI;
//	if (UART_ENABLE_MS(&up->port, termios->c_cflag))
//		up->ier |= UART_IER_MSI;
//
//	serial_out(up, UART_IER, up->ier);
//	//serial_out(up, XR_17V35X_EXTENDED_EFR, termios->c_cflag & CRTSCTS ? UART_EFR_CTS :0);
//
//	SerialSetDtrDsr(port, 0);
//	SerialSetCtsRts(port, 0);
//	//using DTR/DSR hardware control flow
//	if(termios->c_cflag & CDTRDSR)
//	{
//		SerialSetDtrDsr(port, 1);
//	}
//	else if (termios->c_cflag & CRTSCTS)
//	{
//		SerialSetCtsRts(port, 1);
//	}
//
//
//    if(((termios->c_iflag) & IXOFF)||((termios->c_iflag) & IXON))
//	{
//		SerialSetXonXoff(port, 1);
//	}
//	else
//	{
//		SerialSetXonXoff(port, 0);
//	}
//
//	// set baud rate
//	// set sample 16
//	valof8xreg = serial_in(up, XR_17V35X_8XMODE);
//	valof4xreg = serial_in(up, XR_17V35X_4XMODE);
//	valof4xreg &= ~(1 << up->index);
//	valof8xreg &= ~(1 << up->index);
//	serial_out(up, XR_17V35X_8XMODE, valof8xreg);
//	serial_out(up, XR_17V35X_4XMODE, valof4xreg);
//
//    oldEFR = serial_in(up, XR_17V35X_EXTENDED_EFR);
//    serial_out(up, XR_17V35X_EXTENDED_EFR, oldEFR|0x10);
//	if(devide1)  	//Prescaler Divide by 1
//	{
//        oldMCR = serial_in(up, UART_MCR);
//        oldMCR &= ~UART_MCR_CLKSEL; // using Prescaler Divide by 1
//        up->port.mctrl &= ~UART_MCR_CLKSEL;
//        serial_out (up, UART_MCR, oldMCR);
//	}
//	else  		//Prescaler Divide by 4
//	{
//        oldMCR = serial_in(up, UART_MCR);
//        oldMCR |= UART_MCR_CLKSEL;  // using Prescaler Divide by 4
//        up->port.mctrl |= UART_MCR_CLKSEL;
//        serial_out (up, UART_MCR, oldMCR);
//	}
//	serial_out(up, XR_17V35X_EXTENDED_EFR, oldEFR);
//
//	serial_out(up, UART_LCR, cval | UART_LCR_DLAB);/* set DLAB */
//	serial_out(up, UART_DLL, (unsigned char)(quot & 0xff));		/* LS of divisor */
//	serial_out(up, UART_DLM, (unsigned char)(quot >> 8));		/* MS of divisor */
//	/* if RS485,we set DLD[7] */
//	quot_fraction = up->serialMode == SERIAL_MODE_RS485ORRS422S ? ((quot_fraction&0x0f)|0x80) : (quot_fraction&0x0f);
//
//	serial_out(up, XR_17V35X_UART_DLD, (unsigned char)quot_fraction);
//
//	serial_out(up, UART_LCR, cval);		/* reset DLAB */
//	up->lcr = cval;					    /* Save LCR */
//
//	// set RS485
//	up->serialMode == SERIAL_MODE_RS485ORRS422S ? serialadv_setRS485(&up->port, 1, 0) : serialadv_setRS485(&up->port, 0, 0);
//
//	serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO);/* set fcr */
//
//	serialadv_set_mctrl(&up->port, up->port.mctrl);
	spin_unlock_irqrestore(&port->lock, flags);
	SF;
}


static int
serialadv_ioctl(struct uart_port *port, unsigned int cmd, unsigned long arg)
{

//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//	struct tty_struct *real_tty = up->port.state->port.tty;
	int ret = -ENOIOCTLCMD;
	return ret;
//	struct advioctl_rw_reg ioctlrwarg;
//	int iArg = 0;

	printk("%s:cmd=0x%x\n",__func__,cmd);
	switch (cmd)
	{
	case TCGETS:
//			copy_termios(real_tty, &g_termios);
			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, &g_termios))
				ret = -EFAULT;
			return ret;
	}
//		case ADV_READ_REG:
//			if (copy_from_user(&ioctlrwarg, (void *)arg, sizeof(ioctlrwarg)))
//				return -EFAULT;
//			ioctlrwarg.regvalue = serial_in(up, ioctlrwarg.reg);
//			if (copy_to_user((void *)arg, &ioctlrwarg, sizeof(ioctlrwarg)))
//				return -EFAULT;
//			DEBUG_INTR(KERN_INFO "serialadv_ioctl read reg[0x%02x]=0x%02x \n",ioctlrwarg.reg,ioctlrwarg.regvalue);
//			ret = 0;
//			break;
//
//		case ADV_WRITE_REG:
//			if (copy_from_user(&ioctlrwarg, (void *)arg, sizeof(ioctlrwarg)))
//				return -EFAULT;
//			serial_out(up, ioctlrwarg.reg, ioctlrwarg.regvalue);
//			DEBUG_INTR(KERN_INFO "serialadv_ioctl write reg[0x%02x]=0x%02x \n",ioctlrwarg.reg,ioctlrwarg.regvalue);
//			ret = 0;
//			break;
//
//		// serial have RS232/RS422/RS485 mode, get it
//		case ADV_GET_SERIAL_MODE:
//			DEBUG_INTR(KERN_INFO"enter ADV_GET_SERIAL_MODE\n");
//			if ( copy_to_user((void *)arg, &up->serialMode, sizeof(int)) )
//				return -EFAULT;
//			ret = 0;
//			break;
//
//		case ADV_SET_TURN_AROUND_DELAY:
//			DEBUG_INTR(KERN_INFO"enter ADV_SET_TURN_AROUND_DELAY\n");
//            iArg = (int) arg;
//
//			DEBUG_INTR(KERN_INFO"iArg = %d\n", iArg);
//			if( (up->serialMode!=SERIAL_MODE_RS485ORRS422S) || iArg<0 || iArg>15)
//				return -EFAULT;
//
//			serialadv_setRS485(&up->port, 1, iArg);
//			ret = 0;
//			break;
//	}

//	SF;
	return ret;
}


static void
serialadv_pm(struct uart_port *port, unsigned int state,
	      unsigned int oldstate)
{
	printk("%s:state=%d,oldstate=%d\n",__func__,state,oldstate);
	showUart(port);
//	if (up->pm)
//			up->pm(port, state, oldstate);
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//	unsigned char oldEFR = 0;
//	oldEFR = serial_in(up, XR_17V35X_EXTENDED_EFR);
//	if (state) {
//		/* sleep */
//		serial_out(up, XR_17V35X_EXTENDED_EFR, oldEFR | 0x10);
//		serial_out(up, UART_IER, UART_IERX_SLEEP);
//		serial_out(up, XR_17V35X_EXTENDED_EFR, oldEFR &(~0x10));
//	} else {
//		/* wake */
//		serial_out(up, XR_17V35X_EXTENDED_EFR, oldEFR | 0x10);
//		serial_out(up, UART_IER, 0);
//		serial_out(up, XR_17V35X_EXTENDED_EFR, oldEFR &(~0x10));
//	}
//
//	if (up->pm)
//		up->pm(port, state, oldstate);
	SF;
}

static void serialadv_release_port(struct uart_port *port)
{
	SF;
}

static int serialadv_request_port(struct uart_port *port)
{
	SF;
	return 0;
}

static void serialadv_config_port(struct uart_port *port, int flags)
{
//	struct uart_adv_port *up = (struct uart_adv_port *)port;
//
//	if (flags & UART_CONFIG_TYPE)
//	{
//		up->port.type = XRPCIe_TYPE;
//		up->port.fifosize = uart_config[up->port.type].dfl_xmit_fifo_size;
//		up->capabilities = uart_config[up->port.type].flags;
//	}
	SF;
}

static const char *
serialadv_type(struct uart_port *port)
{
//	int type = port->type;
//
//	if (type >= ARRAY_SIZE(uart_config))
//		type = 0;
//	return uart_config[type].name;
	SF;
	return NULL;
}



static struct uart_ops serialadv_pops = {
	.tx_empty	    = serialadv_tx_empty,
	.set_mctrl	    = serialadv_set_mctrl,
	.get_mctrl	    = serialadv_get_mctrl,
	.stop_tx	    = serialadv_stop_tx,
	.start_tx	    = serialadv_start_tx,
	.stop_rx	    = serialadv_stop_rx,
	.enable_ms	    = serialadv_enable_ms,
	.break_ctl	    = serialadv_break_ctl,
	.startup	    = serialadv_startup,
	.shutdown	    = serialadv_shutdown,
	.set_termios	= serialadv_set_termios,
//	.pm		        = serialadv_pm,
	.type		    = serialadv_type,
	.release_port	= serialadv_release_port,
	.request_port	= serialadv_request_port,
	.config_port	= serialadv_config_port,
	.ioctl		    = serialadv_ioctl,
//	.throttle	= adv_uart_throttle,
//	.unthrottle	= adv_uart_unthrottle,
};



#define XR_MAJOR                    38
#define XR_MINOR                    0



#define SERIALADV_CONSOLE	NULL

static struct uart_driver adv_uart_driver = {
	.owner			= THIS_MODULE,
	.driver_name	= "ADVserial",
	.dev_name		= "ttyAP",
	.major			= XR_MAJOR,
	.minor			= XR_MINOR,
	.nr			    = NR_PORTS,
//	.cons			= SERIALADV_CONSOLE,
};

static void tiny_tx_chars(struct uart_port *port)
{
	struct circ_buf *xmit = &port->state->xmit;
	int count;

	if (port->x_char) {
		pr_debug("wrote %2x", port->x_char);
		port->icount.tx++;
		port->x_char = 0;
		return;
	}
	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
		serialadv_stop_tx(port);
		return;
	}

	count = port->fifosize >> 1;
	do {
		pr_debug("wrote %2x", xmit->buf[xmit->tail]);
		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
		port->icount.tx++;
		if (uart_circ_empty(xmit))
			break;
	} while (--count > 0);

	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
		uart_write_wakeup(port);

	if (uart_circ_empty(xmit))
		serialadv_stop_tx(port);
}

/*
 * This function is used to handle ports that do not have an
 * interrupt.  This doesn't work very well for 16450's, but gives
 * barely passable results for a 16550A.  (Although at the expense
 * of much CPU overhead).
 */
static void serialadv_timeout(unsigned long data)
{
	struct uart_adv_port *up = (struct uart_adv_port *)data;
	struct tty_struct *tty = up->port.state->port.tty;
	struct uart_port *port = &up->port;
	struct circ_buf *xmit = &port->state->xmit;
	char ch;
	int count = 0;
	int send = 0;
	int ret = 0;

//	tty_insert_flip_char(tty, 'a', 0);
//	tty_flip_buffer_push(tty);
//	showUart(port);
	while(xmit->tail != xmit->head)
	{
		ch = xmit->buf[xmit->tail];
		count = uart_circ_chars_pending(xmit);
//		count = 1;
		printk("%s:0x%02x=%c\n",__func__,ch,ch);
		spin_lock(&port->lock);
//		if (!uart_handle_sysrq_char(port, ch))
		{
//			uart_insert_char(port,0, UART_LSR_OE, 'a', TTY_NORMAL);
//			ret = tty_insert_flip_char(tty,ch,TTY_NORMAL);
			ret = tty_insert_flip_string(tty, &xmit->buf[xmit->tail], count);
			port->icount.rx+= count;
		}
		xmit->tail += count;
		xmit->tail &= (UART_XMIT_SIZE-1);
		port->icount.tx += count;

		send++;
		spin_unlock(&port->lock);
	}
	if(send)
	{
		printk("%s:ret=%d\n",__func__,ret);
		tty_flip_buffer_push(tty);
	}
//	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
//			uart_write_wakeup(&up->port);
//
	mod_timer(&up->timer, jiffies + 1*HZ);
//	tiny_tx_chars(port);
}

static void add_port(int index)
{
	int ret = 0;
//	struct uart_port serial_port;
	struct uart_adv_port *uart = &serialadv_ports[index];
	if (uart) {
//			uart->port.iobase   = 0;
//			uart->port.membase  = 0;
//			uart->port.irq      = 0;
//			uart->port.uartclk  = 0;
			uart->port.fifosize = 256;
//			uart->port.regshift = 0;
//			uart->port.iotype   = UPIO_MEM;
//			uart->port.flags    =  UPF_SKIP_TEST | UPF_BOOT_AUTOCONF | UPF_SHARE_IRQ;
//			uart->port.mapbase  = 0;
			uart->port.type		= PORT_16850;
//			if (port->dev)
//				uart->port.dev = port->dev;


//			uart->deviceid = deviceid;
//			uart->port.line = 0;
//			uart->index = index;
			spin_lock_init(&uart->port.lock);

			init_timer(&uart->timer);
			uart->timer.function = serialadv_timeout;
			uart->timer.expires = jiffies + (1 * HZ);
			uart->timer.data = (unsigned long) uart;


			/*
			 * ALPHA_KLUDGE_MCR needs to be killed.
			 */
//			uart->mcr_mask = ~(0x0); //~ALPHA_KLUDGE_MCR;
//			uart->mcr_force = 0; // ALPHA_KLUDGE_MCR;

			uart->port.ops = &serialadv_pops;

			/*
			 * get serial mode
			 */
//			serial_get_mode(uart);

			ret = uart_add_one_port(&adv_uart_driver, &uart->port);
		}

}

static void del_port(int index)
{
	struct uart_adv_port *uart = &serialadv_ports[index];
	 del_timer(&uart->timer);
	 showUart(&uart->port);
	uart_remove_one_port(&adv_uart_driver, &uart->port);
}

static int __init hello_init(void) {


        int ret;

        printk(KERN_ALERT "Hello world!\n");
        memset(serialadv_ports,0,sizeof(serialadv_ports));

		ret = uart_register_driver(&adv_uart_driver);
		if (ret)
			return ret;

		add_port(0);
        return 0;
}

static void __exit hello_exit(void) {
        printk(KERN_ALERT "Goodbye!\n");

        del_port(0);
        uart_unregister_driver(&adv_uart_driver);
}

module_init(hello_init);
module_exit(hello_exit);
MODULE_AUTHOR("blaider");
MODULE_DESCRIPTION("hello");
