/*
 * can4linux project
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 *
*/
#ifndef __DEBUG_INCLUDED

#if defined(DEBUG)
#define DRIVER_NAME "Can"

#define DBG_ALL      (1 << 0)
#define DBG_ENTRY   ((1 << 1) | DBG_ALL)
#define DBG_EXIT    ((1 << 2) | DBG_ALL)
#define DBG_BRANCH  ((1 << 3) | DBG_ALL)
#define DBG_DATA    ((1 << 4) | DBG_ALL)
#define DBG_INTR    ((1 << 5) | DBG_ALL)
#define DBG_REG     ((1 << 6) | DBG_ALL)
#define DBG_SPEC    ((1 << 7) | DBG_ALL)
#define DBG_1PPL     (1 << 8)		/* one DBG print statement/line */

extern unsigned int dbgMask;


/* class of debug statements allowed		*/

extern int   fidx;     
extern char *fstk[];
extern char *ffmt[];

#define DBGprint(ms,ar)	{ if (dbgMask && (dbgMask & ms)) \
	{ printk(KERN_INFO "Can: - :"); printk ar; printk("\n"); } }
#define DBGin()		{ if (dbgMask && (dbgMask & DBG_ENTRY)) \
	{ printk(KERN_INFO "Can[%d]: - : in  %s()\n", minor, __func__); } }
#define DBGout()	{ if (dbgMask && (dbgMask & DBG_EXIT)) \
	{ printk(KERN_INFO "Can[%d]: - : out %s()\n", minor, __func__); } }

#define DEBUG_TTY(n, args...) if(dbgMask >= (n)) print_tty(args);

#else					
#define DBGprint(ms,ar)	{ }
#define DBGin()	{ }
#define DBGout()	{ }
#define DEBUG_TTY(n, args...)
extern unsigned int dbgMask;

#endif					

#define err(format, arg...) do { \
	printk(KERN_INFO "Can: - : " format "\n" , ## arg); } while (0)


#define __DEBUG_INCLUDED
#endif



