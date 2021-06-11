/*
 * Module: semaphore.h
 *
 * Purpose:
 *	Semaphores aren't actually part of the PThreads standard.
 *	They are defined by the POSIX Standard:
 *
 *		POSIX 1003.1b-1993	(POSIX.1b)
 *
 * --------------------------------------------------------------------------
 *
 *      Pthreads-win32 - POSIX Threads Library for Win32
 *      Copyright(C) 1998 John E. Bossom
 *      Copyright(C) 1999,2012 Pthreads-win32 contributors
 *
 *      Homepage1: http://sourceware.org/pthreads-win32/
 *      Homepage2: http://sourceforge.net/projects/pthreads4w/
 *
 *      The current list of contributors is contained
 *      in the file CONTRIBUTORS included with the source
 *      code distribution. The list can also be seen at the
 *      following World Wide Web location:
 *      http://sources.redhat.com/pthreads-win32/contributors.html
 * 
 *      This library is free software; you can redistribute it and/or
 *      modify it under the terms of the GNU Lesser General Public
 *      License as published by the Free Software Foundation; either
 *      version 2 of the License, or (at your option) any later version.
 * 
 *      This library is distributed in the hope that it will be useful,
 *      but WITHOUT ANY WARRANTY; without even the implied warranty of
 *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *      Lesser General Public License for more details.
 * 
 *      You should have received a copy of the GNU Lesser General Public
 *      License along with this library in the file COPYING.LIB;
 *      if not, write to the Free Software Foundation, Inc.,
 *      59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */
#if !defined(_H_SEMAPHORE) && defined(_MSC_VER)
#define _H_SEMAPHORE

#include <errno.h>

typedef unsigned int mode_t;

typedef struct sem_t_ * sem_t;

extern int __cdecl sem_init (sem_t * sem, int pshared, unsigned int value);

extern int __cdecl sem_destroy (sem_t * sem);

extern int __cdecl sem_trywait (sem_t * sem);

extern int __cdecl sem_wait (sem_t * sem);

extern int __cdecl sem_timedwait (sem_t * sem, const struct timespec * abstime);

extern int __cdecl sem_post (sem_t * sem);

extern int __cdecl sem_post_multiple (sem_t * sem, int count);

extern int __cdecl sem_open (const char * name, int oflag, mode_t mode, unsigned int value);

extern int __cdecl sem_close (sem_t * sem);

extern int __cdecl sem_unlink (const char * name);

extern int __cdecl sem_getvalue (sem_t * sem, int * sval);

#endif				/* !_H_SEMAPHORE */