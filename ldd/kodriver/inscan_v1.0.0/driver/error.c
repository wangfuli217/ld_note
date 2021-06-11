/* Can_error
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
 * $Header: /z2/cvsroot/products/0530/software/can4linux/src/error.c,v 1.1 2006/04/21 16:26:50 oe Exp $
 *
 *--------------------------------------------------------------------------
 *
 *
 *
 *
 *
 */
#include "defs.h"

int Can_errno = 0;


int Error(int err)
{
    Can_errno = err;
    return 0;
}
