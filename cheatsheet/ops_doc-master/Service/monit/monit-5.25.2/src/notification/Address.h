/*
 * Copyright (C) Tildeslash Ltd. All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * In addition, as a special exception, the copyright holders give
 * permission to link the code of portions of this program with the
 * OpenSSL library under certain conditions as described in each
 * individual source file, and distribute linked combinations
 * including the two.
 *
 * You must obey the GNU Affero General Public License in all respects
 * for all of the code used other than OpenSSL.
 */


#ifndef MONIT_ADDRESS_H
#define MONIT_ADDRESS_H


#define T Address_T
typedef struct T {
        char *name;
        char *address;
} *T;


/**
 * Create a new Address object
 * @return Address object
 */
T Address_new(void);


/**
 * Destroy the Address object
 * @param A A reference to the Address object
 * @exception AssertException if reference is NULL
 */
void Address_free(T *A);


/**
 * Copy address object.
 * @param A An Address object to copy
 * @return An Address object copy
 * @exception AssertException if reference is NULL
 */
T Address_copy(T A);


#undef T
#endif

