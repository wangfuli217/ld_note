/*
 * can_core - can4linux CAN driver module
   set tagprg="global -t $1"
 *
 * can4linux -- LINUX CAN device driver source
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 * 
 * Copyright (c) 2001-2010 port GmbH Halle/Saale
 * (c) 2001 Heinz-J�rgen Oertel (oe@port.de)
 *          Claus Schroeter (clausi@chemie.fu-berlin.de)
 *------------------------------------------------------------------
 * $Header: /z2/cvsroot/products/0530/software/can4linux/src/core.c,v 1.14 2009/06/03 14:25:31 oe Exp $
 *
 *--------------------------------------------------------------------------
 *
 *
 *
 *
 *--------------------------------------------------------------------------
 */


/****************************************************************************/
/**
* \mainpage  can4linux - CAN network device driver
*
The LINUX CAN driver
can be used to control the CAN bus (http://www.can-cia.org)
connected to a PC running LINUX or embedded LINUX systems using uClinux.
Different interface boards and target micro controlllers are supported
(see TARGET=VARIABLE in Makefile).
The most popular interfaces are the
AT-CAN-MINI http://www.port.de/pages/products/can/canopen/hardware/at_canmini.php?lang=en
and
CPC-PCI  http://www.port.de/0665
or PCI-express

This project was done in cooperation with the  LINUX LLP Project
to control laboratory or automation devices via CAN.
It started already in 1995 and is now considered as mature.

The former and older can4linux version 1.x
did support many different interface boards.
It was possible to use different kinds of boards at the same time.
Up to four boards could be placed in one computer.
With this feature it was possible to use /dev/can0 and
/dev/can2 for two boards AT-CAN-MINI with SJA1000
and /dev/can1 and /dev/can3 with two CPC-XT equipped with Intel 82527.

\b Attention: This can4linux version isn't supported anymore \b !

Instead the \b new version has to be compiled for the target hardware.
It was unlikely in the past that a PC or embedded device
was equipped with different CAN controllers.

In all these configurations
the programmer sees the same driver interface with
open(), close(), read(), write() and ioctl() calls
( can_open(), can_close(), can_read(), can_write(), can_ioctl() ).

The driver itself is highly configurable
using the /proc interface of the LINUX kernel. 

The following listing shows a typical configuration with three boards: 

\code
$ grep . /proc/sys/Can/\*
/proc/sys/Can/AccCode:  -1       -1      -1      -1
/proc/sys/Can/AccMask:  -1       -1      -1      -1
/proc/sys/Can/Base:     800      672     832     896
/proc/sys/Can/Baud:     125      125     125     250
/proc/sys/Can/Chipset:  SJA1000
/proc/sys/Can/IOModel:  pppp
/proc/sys/Can/IRQ:      5     7       3       5
/proc/sys/Can/Outc:     250   250     250     0
/proc/sys/Can/Overrun:  0     0       0       0
/proc/sys/Can/RxErr:    0     0       0       0
/proc/sys/Can/Timeout:  100   100     100     100
/proc/sys/Can/TxErr:    0     0       0       0
/proc/sys/Can/dbgMask:  0
/proc/sys/Can/version:  3.0_ATCANMINI_PELICAN
\endcode


This above mentioned full flexibility
is not needed in embedded applications.
For this applications, a stripped-down version exists.
It uses the same programming interface
but does the most configurations at compile time.
That means especially that only one CAN controller support with
a special register access method is compiled into the driver.
Actually the only CAN controller supported by this version
is the Philips SJA 1000 in both the compatibility mode 
\b BasicCAN and the Philips \b PeliCAN mode (compile time selectable).

The version of can4linux currently available at the uClinux CVS tree
is also supporting the Motorola FlexCAN module as ist is implemented
on Motorolas ColdFire 5282 CPU and the Analog Devices BlackFin DSP with CAN.

Since version 3.4.6 can4linux 
assumes that your distribution uses \b udev to have the device
`/dev/can[0-9]' automatically created.
It is usually necessary to change the device access rights set by \b udev .
With the Fedora Core >= 4 or SuSE/novell you can do: 

\code
echo 'KERNEL=="[Cc]an*", NAME="%k", MODE="0666"' \
     > /etc/udev/rules.d/91-Can.rules
\endcode

Alternatively create the device inodes in
/lib/udev/devices .
At system start-up,
the contents of that directory is copied to the /dev directory
with the same ownership and permissions as the files in /lib/udev/devices. 


The driver creates class Can,
with information in /sys/class/Can/


See also udev (7)

The following sections are describing the \e sysctl entries.

\par AccCode/AccMask
contents of the message acceptance mask and acceptance code registers
of 82x200/SJA1000 compatible CAN controllers (see can_ioctl()).

\par Base
CAN controllers base address for each board.
Depending of the \e IOModel entry that can be a memory or I/O address.
(read-only for PCI boards)
\par Baud
used bit rate for this board in Kbit/s
\par Chipset
name of the supported CAN chip used with this boards
Read only for this version.
\par IOModel
one letter for each port. Readonly.
Read the CAN register access model.
The following models are currently supported:
\li m - memory access, the registers are directly mapped into memory
\li f - fast register access, special mode for the 82527
     uses memory locations for register addresses 
     (ELIMA)
\li p - port I/O,  80x86 specific I/O address range
     (AT-CAN-MINI)
\li b - special mode for the B&R CAN card,
     two special I/O addresses for register addressing and access
Since version 2.4 set at compile time.
\par IRQ
used IRQ numbers, one value for each board.
(read-only for PCI boards)
\par Outc
value of the output control register of the CAN controller
Since version 2.4 set at compile time.
A board specific value is used when the module the first time is loaded.
This board specific value can be reloded by writing the value 0
to \e Outc .
\par
With the most boards using a Philips SJA1000,
by changing the value of the \e Outc it is possible
to inhibit generating the CAN Acknowledge.
Using this feature, it is possible to implement a 
\b listen \b only
mode.
Please refer the CAN controller documenattion for more details.
\par
Another way is implementing access to the \b mode register with an
\e ioctl () call in later \e can4linux versions.

\par Overrun
counter for overrun conditions in the CAN controller
\par RxErr
counter for CAN controller rx error conditions
\par Timeout
time out value for waiting for a successful transmission

\par TxErr
counter for CAN controller tx error conditions

\par dbgMask
if compiled with debugging support, writing a value greater then 0 
enables debugging to \b syslogd .
The value is bit coded.
\code
Bit 0 print all debug messages
Bit 1 print function entry message
Bit 2 print function exit message
Bit 3 print if a function branches intwo differnt branches
Bit 4 print debug data statements
\endcode


\par version
read only entry containing the drivers version number


Please see also at can_ioctl() for some additional descriptions.

For initially writing these sysctl entries after loading the driver
(or at any time) a shell script utility does exist.
It uses a board configuration file that is written over \e /proc/sys/Can .
\code
utils/cansetup port.conf
\endcode
or, like used in the Makefile:
\code
CONFIG := $(shell uname -n)

# load host specific CAN configuration
load:
	@echo "Loading etc/$(CONFIG).conf CAN configuration"
	utils/cansetup etc/$(CONFIG).conf
	echo 0 >/proc/sys/Can/dbgMask
\endcode
Example *.conf files are located in the \e etc/ directory.

\note
This documentation was created using the wonderful tool
\b Doxygen http://www.doxygen.org/index.html .
Die Dokumentation wurde unter Verwendung von
\b Doxygen http://www.doxygen.org/index.html
erstellt

*/

#include <linux/init.h>
#include <linux/fs.h>			/* register_chrdev() */
#include <linux/pci.h>

#include "defs.h"
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0) 
# include <linux/device.h>
#endif

#ifndef DOXYGEN_SHOULD_SKIP_THIS

MODULE_AUTHOR("H.-J.Oertel <oe@port.de>");
MODULE_DESCRIPTION("CAN fieldbus driver");

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,4,7) 
MODULE_LICENSE("GPL");
#endif
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0) 
MODULE_VERSION("svn 53");
#endif


#define CANREGDEVNAME "inscan"

static char *INVOLUSER_CAN_VER = "1.0.0";
static char *INVOLUSER_CAN_REV = "2017-12-04";

int IRQ_requested[MAX_CHANNELS]             = { 0 };
int Can_minors[MAX_CHANNELS]                = { 0 }; /* used as IRQ dev_id */
int addlen[ MAX_CHANNELS]              ={0};
int slot[MAX_CHANNELS]    = { 0 }; /* used as IRQ dev_id */
void *  Reg[MAX_CHANNELS][32];
int Can_major = 0; 
int numdevs = 0;

#endif /* DOXYGEN_SHOULD_SKIP_THIS */

/*
There's a C99 way of assigning to elements of a structure,
and this is definitely preferred over using the GNU extension.
gcc 2.95, supports the new C99 syntax.
The meaning is clear, and you should be aware
that any member of the structure which you don't explicitly assign
will be initialized to NULL by gcc.
*/

static struct file_operations can_fops = { 
    .owner	=	THIS_MODULE,
    .open	=	can_open,
    .release	=	can_close,
    .read	=	can_read,
    .write	=	can_write,
    .poll	=	can_select,
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36) 
    .unlocked_ioctl =	can_ioctl,
#else
    .ioctl	=	can_ioctl,
#endif
    .fasync	=	can_fasync,
};

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0) 
static struct class *can_class;
#endif


#ifndef DOXYGEN_SHOULD_SKIP_THIS


#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0) 
static int __init can_init(void)
#else
static int init_module(void)
#endif
{
int i, j, err = 0;

    /* do you want do see debug message already while loading the driver ?
     * Then enable this line and set the mask != 0
     */
    /* dbgMask = 7; */

    //DBGin();
    printk("\n=====================================================\n");
    printk("CAN Communication Driver.\nVersion: %s (%s)\n", 
		INVOLUSER_CAN_VER, INVOLUSER_CAN_REV);
    printk("INVOLUSER Co,Ltd.\n");
    printk("=====================================================\n");

    /* try udev support */
    if( (Can_major = register_chrdev(0, CANREGDEVNAME, &can_fops)) < 0) {
	printk(KERN_ERR "-> can't get Major %d\n", Can_major);
	return(-EIO);
    }

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0) 
    /* udev support */
    can_class = class_create(THIS_MODULE, CANREGDEVNAME);
    if( IS_ERR(can_class)) {
	printk("No udev support.\n");
	err = PTR_ERR(can_class);
	goto out_devfs;
    }

    /*
    The kernel API for device_create() in 2.6.26 and previous versions was:

    extern struct device *device_create(
    		struct class *cls, struct device *parent,
		dev_t devt, const char *fmt, ...)
		__attribute__((format(printf, 4, 5)));

    and starting in 2.6.27 it changed to:


    struct device *device_create(
    		struct class *cls, struct device *parent,
		dev_t devt, void *drvdata,
		const char *fmt, ...)

    */
    for (i = 0; i < MAX_CHANNELS; i++) {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18) 
	class_device_create(can_class, NULL, MKDEV(Can_major, i),NULL,
		"can%d", i);
#elif LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27) 
	device_create(can_class, NULL, MKDEV(Can_major, i),
		"can%d", i);
#else
	device_create(can_class, NULL, MKDEV(Can_major, i),
		NULL, "can%d", i);
#endif
    }

   
#endif

    printk( KERN_INFO __CAN_TYPE__ "CAN Driver" " (c) "
    					__DATE__ " " __TIME__ "\n");

    //printk(KERN_INFO " INVOLUSER CAN port\n");    
    //printk(KERN_INFO " MAX_CHANNELS %d\n", MAX_CHANNELS);
    //printk(KERN_INFO " CAN_MAX_OPEN %d\n", CAN_MAX_OPEN);

    /*
    initialize the variables layed down in /proc/sys/Can
    ====================================================
    */
    for (i = 0; i < MAX_CHANNELS; i++) {
        atomic_set(&Can_isopen[i], 0);
	for(j=0; j < CAN_MAX_OPEN; j++) {
	    selfreception[i][j] = 1;
	}
	IOModel[i] = 'm';
	use_timestamp[i] = 1;
	//IOModel[i]       = IO_MODEL;
	Baud[i]          = 125;
	AccCode[i]       = AccMask[i] =  STD_MASK;
	Timeout[i]       = 100;
	Outc[i]          = CAN_OUTC_VAL;
	IRQ_requested[i] = 0;
	Can_minors[i]    = i;		/* used as IRQ dev_id */
	slot[i] = -1;
	spin_lock_init(&write_splock[i]);

    } /* end of for loop initializing all CAN channels */



    /* after initializing channel based parameters
     * finish some entries 
     * and do drivers specific initialization
     */
    IOModel[i] = '\0';

    /* make some syctl entries read only
     * IRQ number
     * Base address
     * and access mode
     * are fixed and provided by the PCI BIOS
     */
    can_sysctl_table[CAN_SYSCTL_IRQ  - 1].mode = 0666;
    can_sysctl_table[CAN_SYSCTL_BASE - 1].mode = 0666;



    sja1000reg.canmode                   = 0;		// 0 
    sja1000reg.cancmd                    = 1;
    sja1000reg.canstat                   = 2;
    sja1000reg.canirq                    = 3;
    sja1000reg.canirq_enable             = 4;
    sja1000reg.reserved1                 = 5;		// 5 
    sja1000reg.cantim0                   = 6;
    sja1000reg.cantim1                   = 7;
    sja1000reg.canoutc                   = 8;
    sja1000reg.cantest                   = 9;
    sja1000reg.reserved2                 = 10;		// 10 
    sja1000reg.arbitrationlost           = 11;	   
    sja1000reg.errorcode                 = 12;	
    sja1000reg.errorwarninglimit         = 13;
    sja1000reg.rxerror                   = 14;
    sja1000reg.txerror                   = 15;		// 15 
    sja1000reg.frameinfo                 = 16;
    sja1000reg.frame.extframe.canid1     = 17;
    sja1000reg.frame.extframe.canid2     = 18;
    sja1000reg.frame.extframe.canid3     = 19;
    sja1000reg.frame.extframe.canid4     = 20;
    sja1000reg.frame.extframe.canxdata[0] = 21;
    sja1000reg.frame.extframe.canxdata[1] = 22;
    sja1000reg.frame.extframe.canxdata[2] = 23;
    sja1000reg.frame.extframe.canxdata[3] = 24;
    sja1000reg.frame.extframe.canxdata[4] = 25;
    sja1000reg.frame.extframe.canxdata[5] = 26;
    sja1000reg.frame.extframe.canxdata[6] = 27;
    sja1000reg.frame.extframe.canxdata[7] = 28;
    sja1000reg.frame.stdframe.canid1     = 17;
    sja1000reg.frame.stdframe.canid2     = 18;
    sja1000reg.frame.stdframe.candata[0] = 19;
    sja1000reg.frame.stdframe.candata[1] = 20;
    sja1000reg.frame.stdframe.candata[2] = 21;
    sja1000reg.frame.stdframe.candata[3] = 22;
    sja1000reg.frame.stdframe.candata[4] = 23;
    sja1000reg.frame.stdframe.candata[5] = 24;
    sja1000reg.frame.stdframe.candata[6] = 25;
    sja1000reg.frame.stdframe.candata[7] = 26;
    sja1000reg.reserved3                 = 29;
    sja1000reg.canrxbufferadr            = 30;		// 30 
    sja1000reg.canclk                    = 31; 	

    /* printk(KERN_INFO "CAN pci test loaded\n"); */
    /* dbgMask = 0; */
    if(init_ins_pci()) {
        err("no valid PCI CAN found");
	err = -EIO;
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0) 
	goto out_class;
#else
	goto out_devfs;
#endif
    }
   
    //err("pci scan success");

        

#if LDDK_USE_PROCINFO
    register_procinfo();
#endif

#if LDDK_USE_SYSCTL
    register_systables();
#endif

    //DBGout();
    return 0;

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0) 
out_class:
    class_destroy(can_class);
#endif
out_devfs:
    unregister_chrdev(Can_major, CANREGDEVNAME);
    //DBGout();
    return err;
}


#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0) 
static void __exit can_exit(void)
#else
static void cleanup_module(void)
#endif
{
#if defined(KVASER_PCICAN)
int i;
void *ptr;
#endif

    
    //DBGin();

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0) 
  if (MOD_IN_USE) {
    printk(KERN_WARNING "Can : device busy, remove delayed\n");
  }
#endif


    exit_ins_pci();

    unregister_chrdev(Can_major, CANREGDEVNAME);
    printk(KERN_INFO CANREGDEVNAME ": successfully removed\n");

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0) 
    if( !IS_ERR(can_class)) {
	int i;
	for (i = 0; i < MAX_CHANNELS; i++) {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18) 
	    class_device_destroy (can_class, MKDEV(Can_major, i));
#else
	    device_destroy(can_class, MKDEV(Can_major, i));
#endif
	}
	class_destroy(can_class);
    }
#endif
#if LDDK_USE_PROCINFO
    unregister_procinfo();
#endif

#if LDDK_USE_SYSCTL
    unregister_systables();
#endif
    //DBGout();
}

#endif /* DOXYGEN_SHOULD_SKIP_THIS */

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0) 
module_init(can_init);
module_exit(can_exit);
/* EXPORT_NO_SYMBOLS; */
#endif

