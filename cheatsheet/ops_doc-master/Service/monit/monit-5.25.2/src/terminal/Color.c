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


#include "config.h"

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include "monit.h"

// libmonit
#include "util/Str.h"


/**
 * Implementation of the Terminal color interface
 *
 * @author http://www.tildeslash.com/
 * @see http://www.mmonit.com/
 * @file
 */


/* -------------------------------------------------------- Public Methods */


boolean_t Color_support() {
        if (! (Run.flags & Run_Batch) && isatty(STDOUT_FILENO)) {
                if (getenv("COLORTERM")) {
                        return true;
                } else {
                        char *term = getenv("TERM");
                        if (term && (Str_startsWith(term, "screen") || Str_startsWith(term, "xterm") || Str_startsWith(term, "vt100") || Str_startsWith(term, "ansi") || Str_startsWith(term, "linux") || Str_startsWith(term, "rxvt") || Str_sub(term, "color")))
                                return true;
                }
        }
        return false;
}


int Color_length(char *s) {
        if (STR_DEF(s)) {
                int length = 0;
                boolean_t ansi = false;
                for (int i = 0; s[i]; i++) {
                        if (s[i] == '\033' && s[i + 1] == '[') {
                                // Escape sequence start
                                ansi = true;
                                length += 2;
                                i++;
                        } else if (ansi) {
                                length++;
                                // Escape sequence stop
                                if (s[i] >= 64 && s[i] <= 126)
                                        ansi = false;
                        }
                }
                return length;
        }
        return 0;
}


char *Color_strip(char *s) {
        if (STR_DEF(s)) {
                int x, y;
                boolean_t ansi = false;
                for (x = 0, y = 0; s[y]; y++) {
                        if (s[y] == '\033' && s[y + 1] == '[') {
                                // Escape sequence start
                                ansi = true;
                                y++; // ++ to skip 'ESC['
                        } else if (ansi) {
                                // Escape sequence stop
                                if (s[y] >= 64 && s[y] <= 126)
                                        ansi = false;
                        } else {
                                s[x++] = s[y];
                        }
                }
                s[x] = 0;
        }
        return s;
}

