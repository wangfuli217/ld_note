/*
 *  Boa, an http server
 *  Copyright (C) 1995 Paul Phillips <paulp@go2net.com>
 *  Copyright (C) 2001 Jon Nelson <jnelson@boa.org>
 *  Copyright (C) 2001 Larry Doolittle <ldoolitt@boa.org>

 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 1, or (at your option)
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */



#include "config.h"


#define NEEDS_ESCAPE_BITS 128

#ifndef NEEDS_ESCAPE_SHIFT
#define NEEDS_ESCAPE_SHIFT 5     
#endif

#define NEEDS_ESCAPE_WORD_LENGTH (1<<NEEDS_ESCAPE_SHIFT)

#define NEEDS_ESCAPE_INDEX(c) ((c)>>NEEDS_ESCAPE_SHIFT)


#define NEEDS_ESCAPE_MASK(c)  (1<<((c)&(NEEDS_ESCAPE_WORD_LENGTH - 1)))

/* Newer compilers could use an inline function.
 * This macro works great, as long as you pass unsigned int or unsigned char.
 */
#define needs_escape(c) ((c)>=NEEDS_ESCAPE_BITS || _needs_escape[NEEDS_ESCAPE_INDEX(c)]&NEEDS_ESCAPE_MASK(c))

extern unsigned long _needs_escape[(NEEDS_ESCAPE_BITS+NEEDS_ESCAPE_WORD_LENGTH-1)/NEEDS_ESCAPE_WORD_LENGTH];
void build_needs_escape(void);
