
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

#include <signal.h>
#include <stdio.h>
#include <string.h>

#include "common/isonumber.h"
#include "common/string.h"

#include "cunit/cunit.h"

static void
clear_elements(void) {
}

static void
test_str_to_isonumber_u64(void) {
  static const char *results[2][3][5] = {
    {
      { "999", "1.023 k", "999.999 k", "1.023 M",  "1.048 M" },
      { "1 k", "1.024 k", "1 M", "1.024 M", "1.048 M" },
      { "1.001 k", "1.025 k", "1 M", "1.024 M", "1.048 M" }
    },
    {
      { "999", "1023", "976.561 k", "999.999 k", "1023.999 k" },
      { "1000", "1 k",  "976.562 k", "1000 k", "1 M" },
      { "1001", "1 k", "976.563 k", "1000 k", "1 M" }
    }
  };
  static uint64_t tests[] = { 1000, 1024, 1000*1000, 1000*1024, 1024*1024 };
  struct isonumber_str buf;
  uint64_t diff;
  int binary;
  size_t i;

  const char *tmp;
  bool correct;

  START_TEST();

  for (binary=0; binary < 2; binary++) {
    for (diff=0; diff < 3; diff++) {
      for (i=0; i<ARRAYSIZE(tests); i++) {
    	tmp = isonumber_from_u64(&buf, tests[i]+diff-1, NULL, 0, binary==1, false);
    	correct = tmp != NULL && strcmp(tmp, results[binary][diff][i]) == 0;

    	CHECK_TRUE(tmp != NULL, "str_to_isonumber_u64(%"PRIu64", %s) is not null",
        		tests[i]+diff-1, binary == 1 ? "binary" : "normal");
    	CHECK_TRUE(correct, "str_to_isonumber_u64(%"PRIu64", %s) = %s should be %s",
        		tests[i]+diff-1, binary == 1 ? "binary" : "normal",
        		tmp, results[binary][diff][i]);
      }
	}
  }

  END_TEST();
}

static void
test_str_to_isonumber_s64(void) {
  static const char *results[2][3][5] = {
    {
      { "-999", "-1.023 k", "-999.999 k", "-1.023 M",  "-1.048 M" },
      { "-1 k", "-1.024 k", "-1 M", "-1.024 M", "-1.048 M" },
      { "-1.001 k", "-1.025 k", "-1 M", "-1.024 M", "-1.048 M" }
    },
    {
      { "-999", "-1023", "-976.561 k", "-999.999 k", "-1023.999 k" },
      { "-1000", "-1 k",  "-976.562 k", "-1000 k", "-1 M" },
      { "-1001", "-1 k", "-976.563 k", "-1000 k", "-1 M" }
    }
  };
  static int64_t tests[] = { -1000, -1024, -1000*1000, -1000*1024, -1024*1024 };
  struct isonumber_str buf;
  uint64_t diff;
  int binary;
  size_t i;

  const char *tmp;
  bool correct;

  START_TEST();

  for (binary=0; binary < 2; binary++) {
    for (diff=0; diff < 3; diff++) {
      for (i=0; i<ARRAYSIZE(tests); i++) {
    	tmp = isonumber_from_s64(&buf, tests[i]-diff+1, NULL, 0, binary==1, false);
    	correct = tmp != NULL && strcmp(tmp, results[binary][diff][i]) == 0;

    	CHECK_TRUE(tmp != NULL, "str_to_isonumber_s64(%"PRId64", %s) is not null",
        		tests[i]-diff+1, binary == 1 ? "binary" : "normal");
    	CHECK_TRUE(correct, "str_to_isonumber_s64(%"PRId64", %s) = %s should be %s",
        		tests[i]-diff+1, binary == 1 ? "binary" : "normal",
        		tmp, results[binary][diff][i]);
      }
	}
  }

  END_TEST();
}

static void
test_str_to_isonumber_s64_2(void) {
  struct isonumber_str buf;
  START_TEST();

  CHECK_TRUE(
      isonumber_from_s64(&buf,
          5185050545986994176ll, "bit/s", 0, true, false) != NULL, "test");
  END_TEST();
}

int
main(int argc __attribute__ ((unused)), char **argv __attribute__ ((unused))) {
  BEGIN_TESTING(clear_elements);

  test_str_to_isonumber_u64();
  test_str_to_isonumber_s64();
  test_str_to_isonumber_s64_2();

  return FINISH_TESTING();
}
