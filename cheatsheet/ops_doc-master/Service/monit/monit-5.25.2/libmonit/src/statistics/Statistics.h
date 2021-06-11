/*
 * Copyright (C) Tildeslash Ltd. All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
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


#ifndef STATISTICS_INCLUDED
#define STATISTICS_INCLUDED


/**
 * Statistics
 *
 * @author http://www.tildeslash.com/
 * @see http://www.mmonit.com/
 * @file
 */


#define T Statistics_T


typedef struct T {
        boolean_t initialized;
#ifndef __LP64__
        uint64_t raw;
#endif
        struct {
                uint64_t time;
                uint64_t value;
        } last;
        struct {
                uint64_t time;
                uint64_t value;
        } current;
} *T;


/**
 * Save the counter value and update Statistics object. The update method
 * handles 32-bit counter wraps.
 * @param S A Statistics object
 * @param timestamp A value timestamp [ms]
 * @param value A raw value to which the object should be set
 */
void Statistics_update(T S, uint64_t time, uint64_t value);


/**
 * Reset Statistics object
 * @param S A Statistics object
 */
void Statistics_reset(T S);


/**
 * Return true if the counter was initialized, otherwise false
 * @param S A Statistics object
 * @return true if the counter was initialized, otherwise false
 */
boolean_t Statistics_initialized(T S);


/**
 * Return the last raw value
 * @param S A Statistics object
 * @return last raw value
 */
uint64_t Statistics_raw(T S);


/**
 * Return the delta between last two updates
 * @param S A Statistics object
 * @return delta
 */
uint64_t Statistics_delta(T S);


/**
 * Return the delta of value between last two updates normalized to per-second rate
 * @param S A Statistics object
 * @return normalized delta [value per second]
 */
double Statistics_deltaNormalize(T S);


#undef T
#endif
