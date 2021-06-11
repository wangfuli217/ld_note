
/*
 * The olsr.org Optimized Link-State Routing daemon version 2 (olsrd2)
 * Copyright (c) 2004-2015, the olsr.org team - see HISTORY file
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in
 *   the documentation and/or other materials provided with the
 *   distribution.
 * * Neither the name of olsr.org, olsrd nor the names of its
 *   contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Visit http://www.olsr.org for more information.
 *
 * If you find this software useful feel free to make a donation
 * to the project. For more information see the website or contact
 * the copyright holders.
 *
 */

/**
 * @file
 */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "common/isonumber.h"
#include "common/string.h"

static const char *_isonumber_u64_to_string(char *out,
    size_t out_len, uint64_t number, const char *unit, size_t fraction,
    bool binary, bool raw);

/**
 * Converts an unsigned 64 bit integer into a human readable number
 * in string representation.
 *
 * '120000' will become '120 k' for example.
 *
 * @param out pointer to output buffer
 * @param number number to convert.
 * @param unit unit to be appended at the end, can be NULL
 * @param fraction number of fractional digits
 * @param binary true if conversion should use 1024 as factor,
 *   false for default 1000 conversion factor
 * @param raw true if the whole text conversion should be bypassed
 *   and only the raw number shall be written, false otherwise
 * @return pointer to converted string
 */
const char *
isonumber_from_u64(struct isonumber_str *out,
    uint64_t number, const char *unit, int fraction,
    bool binary, bool raw) {
  return _isonumber_u64_to_string(
      out->buf, sizeof(*out), number, unit, fraction, binary, raw);
}

/**
 * Converts a signed 64 bit integer into a human readable number
 * in string representation.
 *
 * '-120000' will become '-120 k' for example.
 *
 * @param out pointer to output buffer
 * @param number number to convert.
 * @param unit unit to be appended at the end, can be NULL
 * @param fraction number of fractional digits of fractional digits
 * @param binary true if conversion should use 1024 as factor,
 *   false for default 1000 conversion factor
 * @param raw true if the whole text conversion should be bypassed
 *   and only the raw number shall be written, false otherwise
 * @return pointer to converted string
 */
const char *
isonumber_from_s64(struct isonumber_str *out,
    int64_t number, const char *unit, int fraction,
    bool binary, bool raw) {
  char *outbuf = out->buf;
  uint64_t num;
  size_t len;

  len = sizeof(*out);
  if (number == INT64_MIN) {
    *outbuf++ = '-';
    len--;
    num = 1ull<<63;
  }
  else if (number < 0) {
    *outbuf++ = '-';
    len--;
    num = (uint64_t)(-number);
  }
  else {
    num = (uint64_t)number;
  }

  if (_isonumber_u64_to_string(
      outbuf, len, num, unit, fraction, binary, raw)) {
  return out->buf;
  }
  return NULL;
}

/**
 * Converts a string representation of a (fractional) number with iso-prefix
 * to a signed 64bit integer.
 * @param dst pointer to destination variable
 * @param iso pointer to string source
 * @param fractions number of fractional digits, might be zero
 * @param binary true if prefixes should use factor 1024, false if they should
 *   use a factor of 1000
 * @return -1 if an error happened, 0 otherwise
 */
int
isonumber_to_s64(int64_t *dst, const char *iso, int fractions, bool binary) {
  const char *ptr;
  int result;
  uint64_t u64;

  ptr = iso;
  if (*iso == '-') {
    ptr++;
  }

  result = isonumber_to_u64(&u64, ptr, fractions, binary);
  if (!result) {
    if (*iso == '-') {
      *dst = -((int64_t)u64);
    }
    else {
      *dst = (int64_t)u64;
    }
  }
  return result;
}

/**
 * Converts a string representation of a (fractional) number with iso-prefix
 * to an unsigned 64bit integer.
 * @param dst pointer to destination variable
 * @param iso pointer to string source
 * @param fraction number of fractional digits, might be zero
 * @param binary true if prefixes should use factor 1024, false if they should
 *   use a factor of 1000
 * @return -1 if an error happened, 0 otherwise
 */
int
isonumber_to_u64(uint64_t *dst, const char *iso, int fraction, bool binary) {
  uint64_t num;
  uint64_t factor;
  uint64_t multiplicator;
  int frac;
  char *next = NULL;

  errno = 0;
  num = strtoull(iso, &next, 10);
  if (errno) {
    return -1;
  }

  if (*next == 0) {
    *dst = num;
    return 0;
  }

  /* Handle fractional part */
  frac = 0;
  if (*next == '.') {
    next++;
    while (*next >='0' && *next <='9' && frac < fraction) {
      num *= 10;
      num += (*next - '0');
      frac++;
      next++;
    }
  }
  while (frac++ < fraction) {
    num *= 10;
  }

  /* handle spaces */
  while (*next == ' ') {
    next++;
  }

  factor = 1;
  if (*next) {
    /* handle iso-prefix */
    if (next[1] != 0) {
      return -1;
    }

    multiplicator = binary ? 1024 : 1000;

    switch (next[0]) {
      case 'E':
        factor *= multiplicator;
        /* no break */
      case 'P':
        factor *= multiplicator;
        /* no break */
      case 'T':
        factor *= multiplicator;
        /* no break */
      case 'G':
        factor *= multiplicator;
        /* no break */
      case 'M':
        factor *= multiplicator;
        /* no break */
      case 'k':
        factor *= multiplicator;
        /* no break */
      case ' ':
        break;
      default:
        return -1;
    }
  }

  if (num > UINT64_MAX / factor) {
    /* this would be an integer overflow */
    return -1;
  }

  *dst = num * factor;
  return 0;
}

/**
 * Helper function to convert an unsigned 64bit integer
 * into a string representation with fractional digits,
 * an optional unit and iso-prefixes
 * @param out pointer to output buffer
 * @param out_len length of output buffer
 * @param number number to convert
 * @param unit unit that should be appended on result
 * @param fraction number of fractional digits
 * @param binary true if prefixes should use factor 1024, false if they should
 *   use a factor of 1000
 * @param raw true to suppress iso prefixes and unit, false otherwise
 * @return pointer to output buffer, NULL if an error happened
 */
static const char *
_isonumber_u64_to_string(char *out, size_t out_len,
    uint64_t number, const char *unit, size_t fraction,
    bool binary, bool raw) {
  static const char symbol_large[] = " kMGTPE";
  static const char symbol_small[] = " munpfa";
  uint64_t step, multiplier, print, n;
  const char *unit_modifier;
  size_t idx, len;
  int result;

  step = binary ? 1024 : 1000;
  multiplier = 1;

  while (fraction > 0) {
    multiplier *= 10;
    fraction--;
  }

  if (number >= multiplier) {
    unit_modifier = symbol_large;
    while (!raw && *unit_modifier != 0 && number / step >= multiplier) {
      multiplier *= step;
      unit_modifier++;
    }
  }
  else {
    unit_modifier = symbol_small;
    while (!raw && *unit_modifier != 0 && number < multiplier
        && multiplier >= step) {
      multiplier /= step;
      unit_modifier++;
    }
  }

  /* print whole */
  if ((result = snprintf(out, out_len, "%"PRIu64, number / multiplier)) < 0) {
    return NULL;
  }

  idx = result;
  len = result;

  out[len++] = '.';
  n = number;

  if (*unit_modifier != ' ') {
    fraction = 3;
  }

  while (true) {
    n = n % multiplier;
    if (n == 0 || fraction == 0) {
      break;
    }
    fraction--;
    n *= 10;

    print = n / multiplier;

    if (print >= 10) {
      return NULL;
    }

    out[len++] = (char)'0' + (char)(print);
    if (print) {
      idx = len;
    }
  }

  if (!raw) {
    out[idx++] = ' ';
    out[idx++] = *unit_modifier;
  }
  out[idx++] = 0;

  if (!raw && unit != NULL) {
    strscat(out, unit, out_len);
  }

  return str_trim(out);
}
