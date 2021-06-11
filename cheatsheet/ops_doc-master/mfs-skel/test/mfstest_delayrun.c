/*
 * Copyright (C) 2019 Jakub Kruszona-Zawadzki, Core Technology Sp. z o.o.
 * 
 * This file is part of MooseFS.
 * 
 * MooseFS is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 2 (only).
 * 
 * MooseFS is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with MooseFS; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02111-1301, USA
 * or visit http://www.gnu.org/licenses/gpl-2.0.html
 */

#include <sys/types.h>
#include <sys/select.h>
#include <sys/time.h>
#include <stdlib.h>
#include <stdio.h>

#include "delayrun.h"
#include "portable.h"
#include "clocks.h"
#include "strerr.h"

uint32_t global_variable;

void set_variable(void *arg) {
	uint32_t *a = (uint32_t*)(arg);
#ifndef DEBUG
     printf("%.6lf ; set %"PRIu32"\n",monotonic_seconds(),*a);
#endif
	global_variable = *a;
}

int main(void) {
	uint32_t values[7] = {0,1,2,3,4,5,6};
	//mfstest_init();

	//mfstest_start(delay_run);

	delay_init();
#if 0
	global_variable = 0xFFFFFFFF;
	delay_run(set_variable,values,10000);
	portable_usleep(20000);
	mfstest_assert_uint32_eq(global_variable,0);
	delay_run(set_variable,values+2,30000);
	delay_run(set_variable,values+3,50000);
	delay_run(set_variable,values+1,10000);
	mfstest_assert_uint32_eq(global_variable,0);
	portable_usleep(20000);
	mfstest_assert_uint32_eq(global_variable,1);
	portable_usleep(20000);
	mfstest_assert_uint32_eq(global_variable,2);
	portable_usleep(20000);
	mfstest_assert_uint32_eq(global_variable,3);
	delay_run(set_variable,values+6,60000);
	portable_usleep(10000);
	delay_run(set_variable,values+4,10000);
	portable_usleep(20000);
	mfstest_assert_uint32_eq(global_variable,4);
	delay_run(set_variable,values+5,10000);
	portable_usleep(20000);
	mfstest_assert_uint32_eq(global_variable,5);
	portable_usleep(20000);
	mfstest_assert_uint32_eq(global_variable,6);
#endif
	delay_run(set_variable,values,10000);
	delay_run(set_variable,values,20000);
	delay_run(set_variable,values,30000);
	delay_run(set_variable,values,40000);
	delay_run(set_variable,values,50000);
	delay_run(set_variable,values,60000);
	delay_run(set_variable,values,70000);
	delay_run(set_variable,values,80000);
	delay_run(set_variable,values,90000);
	delay_run(set_variable,values,100000);
	delay_run(set_variable,values,40000);
	delay_run(set_variable,values,50000);
	delay_run(set_variable,values,60000);
	delay_run(set_variable,values,70000);
	delay_run(set_variable,values,80000);
	portable_usleep(2000000);
	delay_term();

	//mfstest_end();
	//mfstest_return();
}
