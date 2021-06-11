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

#include <stdio.h>
#include <strings.h>
#include <string.h>
#include <stdarg.h>
#include <sys/stat.h>
#include <errno.h>
#include <sys/types.h>
#include <signal.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <regex.h>
#include <limits.h>
#include <math.h>


#include "NumberFormatException.h"
#include "system/System.h"
#include "Str.h"


/**
 * Implementation of the Str interface
 *
 * @author http://www.tildeslash.com/
 * @see http://www.mmonit.com/
 * @file
 */


/* ----------------------------------------------------------- Definitions */


static double epsilon = 1e-6;

static boolean_t _isInt(double x) {
        return fabs(x - round(x)) < epsilon;
}


/* -------------------------------------------------------- Public Methods */


char *Str_chomp(char *s) {
        if (STR_DEF(s)) {
                for (char *p = s; *p; p++)
                        if (*p == '\r' || *p == '\n') {
                                *p = 0; break;
                        }
        }
        return s;
}


char *Str_trim(char *s) {
        return (Str_ltrim(Str_rtrim(s)));
}


char *Str_ltrim(char *s) {
        if (STR_DEF(s) && isspace(*s)) {
                int i, j;
                for (j = 0; s[j]; j++) ;
                for (i = 0; isspace(s[i]); i++) ;
                memmove(s, s + i, j - i);
                s[j - i] = 0;
        }
        return s;
}


char *Str_rtrim(char *s) {
        if (STR_DEF(s))
                for (size_t j = strlen(s) - 1; isspace(s[j]); j--) s[j] = 0;
        return s;
}


char *Str_unquote(char *s) {
        if (STR_DEF(s)) {
                char *t = s;
                // Left unquote
                while (*t == 34 || *t == 39 || isspace(*t)) t++;
                if (t != s) {
                        char *u = s;
                        for (; *t; t++, u++)
                                *u = *t;
                        t = u;
                } else
                        while (*t) t++;
                // Right unquote
                do
                        *(t--) = 0;
                while (t > s && (*t == 34 || *t == 39 || isspace(*t)));
        }
        return s;
}


char *Str_toLower(char *s) {
        if (s)
                for (int i = 0; s[i]; i++)
                        s[i] = tolower(s[i]);
        return s;
}


char *Str_toUpper(char *s) {
        if (s)
                for (int i = 0; s[i]; i++)
                        s[i] = toupper(s[i]);
        return s;
}


int Str_parseInt(const char *s) {
        int i;
        char *e;
        if (STR_UNDEF(s))
                THROW(NumberFormatException, "For input string null");
        errno = 0;
        i = (int)strtol(s, &e, 10);
        if (errno || (e == s))
                THROW(NumberFormatException, "For input string %s -- %s", s, System_getError(errno));
        return i;
}


long long int Str_parseLLong(const char *s) {
        char *e;
        long long l;
        if (STR_UNDEF(s))
                THROW(NumberFormatException, "For input string null");
        errno = 0;
        l = strtoll(s, &e, 10);
        if (errno || (e == s))
                THROW(NumberFormatException, "For input string %s -- %s", s, System_getError(errno));
        return l;
}


double Str_parseDouble(const char *s) {
        char *e;
        double d;
        if (STR_UNDEF(s))
                THROW(NumberFormatException, "For input string null");
        errno = 0;
        d = strtod(s, &e);
        if (errno || (e == s))
                THROW(NumberFormatException, "For input string %s -- %s", s, System_getError(errno));
        return d;
}


char *Str_replaceChar(char *s, char o, char n) {
        if (s) {
                for (char *t = s; *t; t++)
                        if (*t == o)
                                *t = n;
        }
        return s;
}


int Str_startsWith(const char *a, const char *b) {
	if (a && b) {
	        do
	                if (toupper(*a++) != toupper(*b++)) return false;
                while (*b);
                return true;
        }
        return false;
}


int Str_endsWith(const char *a, const char *b) {
        if (a && b) {
                size_t i = 0, j = 0;
                for (i = strlen(a), j = strlen(b); (i && j); i--, j--)
                        if (toupper(a[i]) != toupper(b[j])) return false;
                return (i >= j);
        }
        return false;
}


char *Str_sub(const char *a, const char *b) {
        if (a && STR_DEF(b)) {
                const char *p, *q;
                while (*a) {
                        if (toupper(*a) == toupper(*b)) {
                                p = a;
                                q = b;
                                do
                                        if (! *q)
                                                return (char*)a;
                                while (toupper(*p++) == toupper(*q++));
                        }
                        a++;
                }
        }
        return NULL;
}


int Str_has(const char *charset, const char *s) {
        if (charset && s) {
                for (int x = 0; s[x]; x++) {
                        for (int y = 0; charset[y]; y++) {
                                if (s[x] == charset[y])
                                        return true;
                        }
                }
        }
        return false;
}


char *Str_unescape(const char *charset, char *s) {
        if (charset && STR_DEF(s)) {
                int x, y;
                for (x = 0, y = 0; s[y]; x++, y++) {
                        if ((s[x] = s[y]) == '\\')
                                for (int i = 0; charset[i]; i++) {
                                        if (charset[i] == s[y + 1]) {
                                                s[x] = charset[i];
                                                y++;
                                                break;
                                        }
                                }
                }
                s[x] = 0;
        }
        return s;
}


int Str_isEqual(const char *a, const char *b) {
        if (a && b) {
                while (*a && *b)
                        if (toupper(*a++) != toupper(*b++)) return false;
                return (*a == *b);
        }
        return false;
}


int Str_isByteEqual(const char *a, const char *b) {
        if (a && b) {
                while (*a && *b)
                        if (*a++ != *b++) return false;
                return (*a == *b);
        }
        return false;
}


char *Str_copy(char *dest, const char *src, int n) {
	if (src && dest && (n > 0)) {
        	char *t = dest;
	        while (*src && n--)
        		*t++ = *src++;
        	*t = 0;
	} else if (dest)
	        *dest = 0;
        return dest;
}


// We don't use strdup so we can report MemoryException on OOM
char *Str_dup(const char *s) {
        char *t = NULL;
        if (s) {
                size_t n = strlen(s) + 1;
                t = ALLOC(n);
                memcpy(t, s, n);
        }
        return t;
}


char *Str_ndup(const char *s, long n) {
        char *t = NULL;
        assert(n >= 0);
        if (s) {
                size_t l = strlen(s);
                n = l < n ? l : n; // Use the actual length of s if shorter than n
                t = ALLOC(n + 1);
                memcpy(t, s, n);
                t[n] = 0;
        }
        return t;
}


char *_Str_join(char *dest, int n, ...) {
        char *p, *q;
        va_list ap;
        assert(dest);
        va_start(ap, n);
        for (q = dest, p = va_arg(ap, char *); (p && (n > 0)); p = va_arg(ap, char *))
                while (*p && n--) *q++ = *p++;
        va_end(ap);
        *q = 0;
        return dest;
}


char *Str_cat(const char *s, ...) {
        char *t = NULL;
        if (s) {
                va_list ap;
                va_start(ap, s);
                t = Str_vcat(s, ap);
                va_end(ap);
        }
        return t;
}


char *Str_vcat(const char *s, va_list ap) {
        char *t = NULL;
        if (s) {
                va_list ap_copy;
                va_copy(ap_copy, ap);
                int size = vsnprintf(t, 0, s, ap_copy) + 1;
                va_end(ap_copy);
                t = ALLOC(size);
                va_copy(ap_copy, ap);
                vsnprintf(t, size, s, ap_copy);
                va_end(ap_copy);
        }
        return t;
}


char *Str_trunc(char *s, int n) {
        assert(n >= 0);
        if (s) {
                size_t sl = strlen(s);
                if (sl > n) {
                        if (n - 3 >= 0)
                                for (int e = n - 3; e < n; e++)
                                        s[e] = '.';
                        s[n] = 0;
                }
        }
        return s;
}


char *Str_curtail(char *s, char *t) {
        if (s) {
                char *x = Str_sub(s, t);
                if (x) *x = 0;
        }
        return s;
}


int Str_lim(const char *s, int limit) {
        assert(limit>=0);
        if (s)
                for (; (*s && limit--); s++) ;
        return (limit < 0);
}


int Str_match(const char *pattern, const char *subject) {
        assert(pattern);
        if (STR_DEF(subject)) {
                regex_t regex = {0};
                int error = regcomp(&regex, pattern, REG_NOSUB|REG_EXTENDED);
                if (error) {
                        char e[STRLEN];
                        regerror(error, &regex, e, STRLEN);
                        regfree(&regex);
                        THROW(AssertException, "regular expression error -- %s", e);
                } else {
                        error = regexec(&regex, subject, 0, NULL, 0);
                        regfree(&regex);
                        return (error == 0);
                }
        }
        return false;
}


unsigned int Str_hash(const void *x) {
        const char *s = x;
        unsigned long h = 0, g;
        assert(x);
        while (*s) {
                h = (h << 4) + *s++;
                if ((g = h & 0xF0000000))
                        h ^= g >> 24;
                h &= ~g;
        }
        return (int)h;
}


int Str_cmp(const void *x, const void *y) {
        return strcmp((const char *)x, (const char *)y);
}


int Str_compareConstantTime(const void *x, const void *y) {
        // Copy input to zero initialized buffers of fixed size, to prevent string length timing attack (handle NULL input as well). If some string exceeds hardcoded buffer size, error is returned.
        char _x[MAX_CONSTANT_TIME_STRING_LENGTH + 1] = {};
        char _y[MAX_CONSTANT_TIME_STRING_LENGTH + 1] = {};
        if (snprintf(_x, sizeof(_x), "%s", x ? (const char *)x : "") > MAX_CONSTANT_TIME_STRING_LENGTH || snprintf(_y, sizeof(_y), "%s", y ? (const char *)y : "") > MAX_CONSTANT_TIME_STRING_LENGTH)
                return 1;
        int rv = 0;
        for (size_t i = 0; i < sizeof(_x); i++)
                rv |= _x[i] ^ _y[i];
        return rv;
}


char *Str_bytes2str(double bytes, char s[10]) {
        assert(s);
        static const char *kNotation[] = {"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", NULL};
        *s = 0;
        char *sign = (bytes < 0) ? "-" : "";
        bytes = fabs(bytes);
        assert(bytes < 1e+24);
        for (int i = 0; kNotation[i]; i++) {
                if (bytes >= 1024) {
                        bytes /= 1024;
                } else {
                        snprintf(s, 10, _isInt(bytes) ? "%s%.0lf %s" : "%s%.1lf %s", sign, bytes, kNotation[i]);
                        break;
                }
        }
        return s;
}


char *Str_time2str(double milli, char s[11]) {
        assert(s);
        struct conversion {
                double base;
                char *suffix;
        } conversion[] = {
                {1000, "ms"}, // millisecond
                {60,   "s"},  // second
                {60,   "m"},  // minute
                {24,   "h"},  // hour
                {365,  "d"},  // day
                {999,  "y"}   // year
        };
        *s = 0;
        char *sign = (milli < 0) ? "-" : "";
        milli = fabs(milli);
        assert(milli < 3.14e+12); // -99.569 y
        for (int i = 0; i < (sizeof(conversion) / sizeof(conversion[0])); i++) {
                if (milli >= conversion[i].base) {
                        milli /= conversion[i].base;
                } else {
                        snprintf(s, 11, _isInt(milli) ? "%s%.0lf %s" : "%s%.3lf %s", sign, milli, conversion[i].suffix);
                        break;
                }
        }
        return s;
}



