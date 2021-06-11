/* can_sysctl
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
 * $Header: /z2/cvsroot/products/0530/software/can4linux/src/sysctl.c,v 1.8 2009/05/17 16:12:02 oe Exp $
 *
 *--------------------------------------------------------------------------
 *
 *
 *
 *
 */
/*
 * This Template implements the SYSCTL basics, and handler/strategy routines
 * Users may implement own routines and hook them up with the 'handler'		
 * and 'strategy' methods of sysctl.
 * 
 *
 */
#include "defs.h"
#include <linux/mm.h>
#include <linux/sysctl.h>
#include <linux/ctype.h>


static struct ctl_table_header *Can_systable = NULL;

/* ----- Prototypes */

/* ----- global variables accessible through /proc/sys/Can */

char version[] = VERSION;
char IOModel[MAX_CHANNELS] = { 0 };
char Chipset[] = "SJA1000";

int IRQ[MAX_CHANNELS]; /*              = { 0x0 }; */
/* dont assume a standard address, always configure,
 * address                         = = 0 means no board available */
upointer_t  Base[MAX_CHANNELS]    = { 0x0 };
/* void __iomem  *Base[MAX_CHANNELS]    = { 0x0 }; */
int Baud[MAX_CHANNELS]             = { 0x0 };

#if defined(IMX35)   || defined(IMX25)
/* eight filters per CAN controller in FIFO mode */
unsigned int AccCode[FLEXCAN_MAX_FILTER][MAX_CHANNELS] = {{0x0}};
unsigned int AccMask[FLEXCAN_MAX_FILTER][MAX_CHANNELS] = {{0x0}};
#else 
/* only one filter can be used */
unsigned int AccCode[MAX_CHANNELS] = { 0x0 };
unsigned int AccMask[MAX_CHANNELS] = { 0x0 };
#endif

unsigned int Clock =  0x0;	/* Clock frequency driving the CAN */

int Timeout[MAX_CHANNELS] 	   = { 0x0 };
/* predefined value of the output control register,
* depends of TARGET set by Makefile */
int Outc[MAX_CHANNELS]	  = { 0x0 };
int TxErr[MAX_CHANNELS]   = { 0x0 };
int RxErr[MAX_CHANNELS]   = { 0x0 };
int Overrun[MAX_CHANNELS] = { 0x0 };
int Options[MAX_CHANNELS] = { 0x0 };

#ifdef DEBUG_COUNTER
int Cnt1[MAX_CHANNELS]    = { 0x0 };
int Cnt2[MAX_CHANNELS]    = { 0x0 };
#endif /* DEBUG_COUNTER */

/* ----- the sysctl table */


/* The ctl_table format has changed in 2.6.33:
Author: Marc Dionne <marc.c.dionne@gmail.com>
Date:   Wed Dec 9 19:06:18 2009 -0500

    Linux: deal with ctl_name removal
    
    The binary sysctl interface will be removed in kernel 2.6.33 and
    ctl_name will be dropped from the ctl_table structure.
    Make the code that uses ctl_name conditional on a configure test.

*/

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
/* sysctl without a binary number */
/* #define CTL_UNNUMBERED	CTL_NONE */
#define CTL_UNNUMBERED	1
#endif

ctl_table can_sysctl_table[] = {
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "version",
         .data = &version,
         .maxlen = PROC_VER_LENGTH,
         .mode = 0444,
         .proc_handler = &proc_dostring,
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .strategy = &sysctl_string,
#endif
        },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "Chipset",
         .data = &Chipset,
         .maxlen = PROC_CHIPSET_LENGTH,
         .mode = 0444,
         .proc_handler = &proc_dostring,
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .strategy = &sysctl_string,
#endif
        },
	{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "IOModel",
         .data = &IOModel,
         .maxlen = MAX_CHANNELS + 1,   /* +1 for '\0' */
         .mode = 0444,
         .proc_handler = &proc_dostring,
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .strategy = &sysctl_string,
#endif
        },
	{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "IRQ",
         .data = IRQ,
         .maxlen = MAX_CHANNELS * sizeof(int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "Base",
         .data = Base,
         .maxlen = MAX_CHANNELS * sizeof(int),
         /* .maxlen = MAX_CHANNELS * sizeof(void __iomem *), */
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "Baud",
         .data = Baud,
         .maxlen = MAX_CHANNELS * sizeof(int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
#if defined(IMX35) || defined(IMX25)
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccCode0",
         .data = &AccCode[0],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccMask0",
         .data = &AccMask[0],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccCode1",
         .data = &AccCode[1],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccMask1",
         .data = &AccMask[1],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccCode2",
         .data = &AccCode[2],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccMask2",
         .data = &AccMask[2],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccCode3",
         .data = &AccCode[3],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccMask3",
         .data = &AccMask[3],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccCode4",
         .data = &AccCode[4],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccMask4",
         .data = &AccMask[4],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccCode5",
         .data = &AccCode[5],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccMask5",
         .data = &AccMask[5],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccCode6",
         .data = &AccCode[6],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccMask6",
         .data = &AccMask[6],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccCode7",
         .data = &AccCode[7],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccMask7",
         .data = &AccMask[7],
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
#else
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccCode",
         .data = AccCode,
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "AccMask",
         .data = AccMask,
         .maxlen = MAX_CHANNELS * sizeof(unsigned int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
#endif
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "Timeout",
         .data = Timeout,
         .maxlen = MAX_CHANNELS * sizeof(int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
         {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "Outc",
         .data = Outc,
         .maxlen = MAX_CHANNELS * sizeof(int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },
 	{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "TxErr",
         .data = TxErr,
         .maxlen = MAX_CHANNELS * sizeof(int),
         .mode = 0444,
         .proc_handler = &proc_dointvec,
         },
	{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "RxErr",
         .data = RxErr,
         .maxlen = MAX_CHANNELS * sizeof(int),
         .mode = 0444,
         .proc_handler = &proc_dointvec,
         },
	{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "Overrun",
         .data = Overrun,
         .maxlen = MAX_CHANNELS * sizeof(int),
         .mode = 0444,
         .proc_handler = &proc_dointvec,
         },
	{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "dbgMask",
         .data = &dbgMask,
         .maxlen = 1 * sizeof(int),
         .mode = 0644,
         .proc_handler = &proc_dointvec,
         },


	{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "CAN clock",
         .data = &Clock,
         .maxlen = 1 * sizeof(unsigned int),
         .mode = 0444,
         .proc_handler = &proc_dointvec,
         },








#ifdef DEBUG_COUNTER
/* ---------------------------------------------------------------------- */
 	{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "cnt1",
         .data = Cnt1,
         .maxlen = MAX_CHANNELS * sizeof(int),
         .mode = 0444,
         .proc_handler = &proc_dointvec,
         },
	{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "cnt2",
         .data = Cnt2,
         .maxlen = MAX_CHANNELS * sizeof(int),
         .mode = 0444,
         .proc_handler = &proc_dointvec,
         },
/* ---------------------------------------------------------------------- */
#endif /* DEBUG_COUNTER */

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
	{.ctl_name = 0}
#else
	{.procname = 0}
#endif
};
 

static ctl_table can_root[] = {
        {
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_UNNUMBERED,
#endif
         .procname = "Can",
         .maxlen   = 0,
         .mode     = 0555,
         .child    = can_sysctl_table,
         },
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
	{.ctl_name = 0}
#else
	{.procname = 0}
#endif
};


static ctl_table dev_root[] = {
	{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
         .ctl_name = CTL_DEV,
#endif
	 .procname = "dev",
	 .maxlen = 0,
	 .mode = 0555,
	 .child = can_root,
	 },
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
	{.ctl_name = 0}
#else
	{.procname = 0}
#endif
};


/* ----- register and unregister entrys */

void register_systables(void)
{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)
    Can_systable = register_sysctl_table(dev_root, 0);
#else
    Can_systable = register_sysctl_table(dev_root);
#endif
}

void unregister_systables(void)
{
    unregister_sysctl_table(Can_systable);
}
