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


#include "Config.h"

#include <stdint.h>

#include "Statistics.h"


/**
 * Statistics
 *
 * @author http://www.tildeslash.com/
 * @see http://www.mmonit.com/
 * @file
 */


/* ------------------------------------------------------------- Definitions */


#define T Statistics_T


/* ---------------------------------------------------------------- Public */


void Statistics_update(T S, uint64_t time, uint64_t value) {
       uint64_t _value = value;
#ifndef __LP64__
        if (value < S->raw)
                _value = S->current.value + ULONG_MAX + 1ULL - S->raw + value; // Counter wrapped
        else
                _value = S->current.value + value - S->raw; 
        S->raw = value;
#endif
        S->last.time = S->current.time;
        S->last.value = S->current.value;
        S->current.time = time;
        S->current.value = _value;
        S->initialized = true;
}


void Statistics_reset(T S) {
#ifndef __LP64__
        S->raw = 0ULL;
#endif
        S->last.time = S->current.time = S->last.value = S->current.value = 0ULL;
        S->initialized = false;
}


boolean_t Statistics_initialized(T S) {
        return S->initialized;
}


uint64_t Statistics_raw(T S) {
        return S->current.value;
}


uint64_t Statistics_delta(T S) {
        if (S->last.value > 0 && S->current.value > S->last.value)
                return S->current.value - S->last.value;
        return 0ULL;
}


double Statistics_deltaNormalize(T S) {
        if (S->last.time > 0 && S->current.time > S->last.time)
                if (S->last.value > 0 && S->current.value > S->last.value)
                        return ((double)(S->current.value - S->last.value) * 1000. / (double)(S->current.time - S->last.time));
        return 0.;
}

