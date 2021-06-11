/* Can_debug
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
 * $Header: /z2/cvsroot/products/0530/software/can4linux/src/debug.c,v 1.2 2008/11/23 12:05:29 oe Exp $
 *
 *--------------------------------------------------------------------------
 *
 *
 *
 *
 *
 */
#include "defs.h"


/* default debugging level */

#if defined (DEBUG)
unsigned int   dbgMask  = 0;
#else
unsigned int   dbgMask  = 0;
#endif
