
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

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "common/netaddr.h"
#include "cunit/cunit.h"

struct netaddr_string_tests {
  const char *str;
  struct netaddr bin;
};

/* test cases that are symmetric for netaddr_to_string and netaddr_from_string */
struct netaddr_string_tests string_tests[] = {
  /* ipv4 */
  { "10.0.0.1",                { {10,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0 }, AF_INET, 32 } },
  { "0.0.0.0",                 { {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }, AF_INET, 32 } },
  { "255.255.255.255",         { {255,255,255,255, 0,0,0,0, 0,0,0,0, 0,0,0,0 }, AF_INET, 32 } },

  { "10.0.0.0/8",              { {10,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }, AF_INET, 8 } },
  { "10.0.0.0/0",              { {10,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }, AF_INET, 0 } },

  /* ipv6 */
  { "1111:2222:3333:4444:5555:6666:7777:8888",
      { {0x11,0x11,0x22,0x22, 0x33,0x33,0x44,0x44, 0x55,0x55,0x66,0x66, 0x77,0x77,0x88,0x88 }, AF_INET6, 128 } },
  { "1:2:3:4:5:6:7:8",         { {0,1,0,2, 0,3,0,4, 0,5,0,6, 0,7,0,8 }, AF_INET6, 128 } },
  { "::",                      { {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }, AF_INET6, 128 } },
  { "aabb::ddee",              { {0xaa,0xbb,0,0, 0,0,0,0, 0,0,0,0, 0,0,0xdd,0xee }, AF_INET6, 128 } },
  { "::ffff:10.0.0.1",         { {0,0,0,0, 0,0,0,0, 0,0,0xff,0xff, 10,0,0,1 }, AF_INET6, 128 } },
  { "2000:0:0:1::/64",         { {0x20,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0 }, AF_INET6, 64 } },

  /* mac48 */
  { "10:00:00:00:00:0a",       { {0x10,0,0,0, 0,0x0a,0,0, 0,0,0,0, 0,0,0,0 }, AF_MAC48, 48 } },
  { "10:00:00:00:00:ff",       { {0x10,0,0,0, 0,0xff,0,0, 0,0,0,0, 0,0,0,0}, AF_MAC48, 48 } },

  /* eui-64 */
  { "10-00-00-00-00-0a-0a-0b", { {0x10,0,0,0, 0,0x0a,0x0a,0x0b, 0,0,0,0, 0,0,0,0}, AF_EUI64, 64 } },
};

/* special test cases for netaddr_from_string */
struct netaddr_string_tests good_netaddr_from_string[] = {
  /* ipv4 */
  { "10.0.0.0/32",              { {10,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }, AF_INET, 32 } },

  /* ipv6 */
  { "aaaa::10.0.0.1",       { {0xaa,0xaa,0,0, 0,0,0,0, 0,0,0,0, 10,0,0,1 }, AF_INET6, 128 } },
  { "::ffff:a00:1",         { {0,0,0,0, 0,0,0,0, 0,0,0xff,0xff, 10,0,0,1 }, AF_INET6, 128 } },
  { "::ffff:0001:0002",     { {0,0,0,0, 0,0,0,0, 0,0,0xff,0xff, 0,1,0,2 }, AF_INET6, 128 } },
  { "64:ff9b::192.168.1.1", { {0,0x64,0xff,0x9b, 0,0,0,0, 0,0,0,0, 192,168,1,1 }, AF_INET6, 128 } },

  /* mac48 */
  { "10:0:0:0:0:a",         { {0x10,0, 0,0,0,0x0a,0,0, 0,0,0,0, 0,0,0,0 }, AF_MAC48, 48 } },
  { "10-0-0-0-0-a",         { {0x10,0, 0,0,0,0x0a,0,0, 0,0,0,0, 0,0,0,0 }, AF_MAC48, 48 } },
  { "10-0-0-0-0-A",         { {0x10,0, 0,0,0,0x0a,0,0, 0,0,0,0, 0,0,0,0 }, AF_MAC48, 48 } },
  { "10-0-0-0-0-Ab",        { {0x10,0, 0,0,0,0x0ab,0,0, 0,0,0,0, 0,0,0,0 }, AF_MAC48, 48 } },

  /* eui-64 */
  { "10-0-0-0-0-a-a-b",     { {0x10,0,0,0, 0,0x0a,0x0a,0x0b, 0,0,0,0, 0,0,0,0}, AF_EUI64, 64 } },
};

/* strings that will create an error in netaddr_from_string */
const char *bad_netaddr_from_string[] = {
  "0.0.0.",
  "0.0.0.0a",
  "10.0.0.0//8",
  "10.0.0.0/33",
  "10.0.0.0/",
  "10.0.0.0/255.0.0.255",
  "10.0.0.0/8/10",
  "::ffff:192.168.0.1/255.0.0.0",
  "10-0-0-0-0-+a",
  "10-0:0-0-0-0",
  "10-0:0-0-0-",
  "10-0-0-0--0",
  "10-0-0-0-0-0-0-0-0-0-0",
};

/* in subnet tests */
const struct netaddr in_subnet_subnets[]= {
    { { 10,0,0,0 }, AF_INET, 7 },
    { { 10,0,0,0 }, AF_INET, 8 },
    { { 10,0,0,0 }, AF_INET, 31 },
    { { 10,0,0,0 }, AF_INET, 32 },
    { {  0,0,0,0 }, AF_INET, 0 },
};


const struct netaddr in_subnet_addrs[] = {
    { { 10,0,0,0 }, AF_INET, 32 },
    { { 10,0,0,1 }, AF_INET, 32 },
    { { 10,1,0,0 }, AF_INET, 32 },
    { { 11,0,0,0 }, AF_INET, 32 },
    { { 12,0,0,0 }, AF_INET, 32 },
    { { 0xfc,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1 }, AF_INET6, 128 },
};

const bool in_subnet_results[6][5] = {
    /* address 10.0.0.0 in 10.0.0.0/7, 10.0.0.0/8, 10.0.0.0/31, 10.0.0.0/32, 0.0.0.0/0 */
    { true, true, true, true, true },
    /* address 10.0.0.1 in 10.0.0.0/7, 10.0.0.0/8, 10.0.0.0/31, 10.0.0.0/32, 0.0.0.0/0 */
    { true, true, true, false, true },
    /* address 10.1.0.1 in 10.0.0.0/7, 10.0.0.0/8, 10.0.0.0/31, 10.0.0.0/32, 0.0.0.0/0 */
    { true, true, false, false, true },
    /* address 11.0.0.0 in 10.0.0.0/7, 10.0.0.0/8, 10.0.0.0/31, 10.0.0.0/32, 0.0.0.0/0 */
    { true, false, false, false, true },
    /* address 12.0.0.0 in 10.0.0.0/7, 10.0.0.0/8, 10.0.0.0/31, 10.0.0.0/32, 0.0.0.0/0 */
    { false, false, false, false, true },
    /* address fc00::1 in 10.0.0.0/7, 10.0.0.0/8, 10.0.0.0/31, 10.0.0.0/32, 0.0.0.0/0 */
    { false, false, false, false, false },
};

/* create host tests */
struct create_host_test {
  const char *netmask;
  const char *result;
  int buf_len;
};

static struct create_host_test _create_host_test[] = {
    { "0.0.0.0/0", "0.0.0.0", 0 },
    { "0.0.0.0/0", "0.0.0.255", 1 },
    { "0.0.0.0/0", "0.0.255.255", 2 },
    { "0.0.0.0/0", "0.255.255.255", 3 },
    { "0.0.0.0/0", "255.255.255.255", 4 },
    { "0.0.0.0/0", "255.255.255.255", 17 },

    { "128.0.0.0/1", "128.0.0.0", 0 },
    { "128.0.0.0/1", "128.0.0.255", 1 },
    { "128.0.0.0/1", "128.0.255.255", 2 },
    { "128.0.0.0/1", "128.255.255.255", 3 },
    { "128.0.0.0/1", "255.255.255.255", 4 },
    { "128.0.0.0/1", "255.255.255.255", 17 },

    { "128.0.0.0/2", "128.0.0.0", 0 },
    { "128.0.0.0/2", "128.0.0.255", 1 },
    { "128.0.0.0/2", "128.0.255.255", 2 },
    { "128.0.0.0/2", "128.255.255.255", 3 },
    { "128.0.0.0/2", "191.255.255.255", 4 },
    { "128.0.0.0/2", "191.255.255.255", 17 },

    { "128.0.0.0/15", "128.0.0.0", 0 },
    { "128.0.0.0/15", "128.0.0.255", 1 },
    { "128.0.0.0/15", "128.0.255.255", 2 },
    { "128.0.0.0/15", "128.1.255.255", 3 },
    { "128.0.0.0/15", "128.1.255.255", 4 },
    { "128.0.0.0/15", "128.1.255.255", 17 },

    { "128.0.0.0/16", "128.0.0.0", 0 },
    { "128.0.0.0/16", "128.0.0.255", 1 },
    { "128.0.0.0/16", "128.0.255.255", 2 },
    { "128.0.0.0/16", "128.0.255.255", 3 },
    { "128.0.0.0/16", "128.0.255.255", 4 },
    { "128.0.0.0/16", "128.0.255.255", 17 },

    { "128.0.0.0/17", "128.0.0.0", 0 },
    { "128.0.0.0/17", "128.0.0.255", 1 },
    { "128.0.0.0/17", "128.0.127.255", 2 },
    { "128.0.0.0/17", "128.0.127.255", 3 },
    { "128.0.0.0/17", "128.0.127.255", 4 },
    { "128.0.0.0/17", "128.0.127.255", 17 },

    { "128.0.0.0/31", "128.0.0.0", 0 },
    { "128.0.0.0/31", "128.0.0.1", 1 },
    { "128.0.0.0/31", "128.0.0.1", 2 },
    { "128.0.0.0/31", "128.0.0.1", 3 },
    { "128.0.0.0/31", "128.0.0.1", 4 },
    { "128.0.0.0/31", "128.0.0.1", 17 },

    { "128.0.0.0/32", "128.0.0.0", 0 },
    { "128.0.0.0/32", "128.0.0.0", 1 },
    { "128.0.0.0/32", "128.0.0.0", 2 },
    { "128.0.0.0/32", "128.0.0.0", 3 },
    { "128.0.0.0/32", "128.0.0.0", 4 },
    { "128.0.0.0/32", "128.0.0.0", 17 },

    { "255.255.255.255/17", "255.255.255.255",  0 },
    { "255.255.255.255/17", "255.255.255.0", -1 },
    { "255.255.255.255/17", "255.255.128.0", -2 },
    { "255.255.255.255/17", "255.255.128.0", -3 },
    { "255.255.255.255/17", "255.255.128.0", -4 },
    { "255.255.255.255/17", "255.255.128.0", -17 },

    { "255.255.255.255/15", "255.255.255.255",  0 },
    { "255.255.255.255/15", "255.255.255.0", -1 },
    { "255.255.255.255/15", "255.255.0.0", -2 },
    { "255.255.255.255/15", "255.254.0.0", -3 },
    { "255.255.255.255/15", "255.254.0.0", -4 },
    { "255.255.255.255/15", "255.254.0.0", -17 },

};

static void
test_netaddr_to_string(void) {
  size_t i;
  const char *ptr;
  struct netaddr_str strbuf;

  START_TEST();

  /* test successful netaddr to string conversions first */
  for (i=0; i<sizeof(string_tests) / sizeof(*string_tests); i++) {
    ptr = netaddr_to_string(&strbuf, &string_tests[i].bin);
    CHECK_TRUE(ptr == strbuf.buf, "netaddr_to_string %s return error condition",
        string_tests[i].str);

    if(ptr != NULL) {
      CHECK_TRUE(strcmp(string_tests[i].str, ptr) == 0,
          "netaddr_to_string %s != %s return value", string_tests[i].str, ptr);
    }
  }

  END_TEST();
}

static void
test_netaddr_from_string(void) {
  size_t i;
  int ret;
  struct netaddr netaddr_buf;

  START_TEST();

  /* test successful string to netaddr conversions first */
  for (i=0; i<sizeof(string_tests) / sizeof(*string_tests); i++) {
    ret = netaddr_from_string(&netaddr_buf, string_tests[i].str);
    CHECK_TRUE(ret == 0, "netaddr_from_string (%s) returns %d", string_tests[i].str, ret);

    if (ret == 0) {
      CHECK_TRUE(memcmp(&netaddr_buf, &string_tests[i].bin, sizeof(netaddr_buf)) == 0,
          "netaddr_from_string (%s) value", string_tests[i].str);
    }
  }

  /* test special cases of string to netaddr conversions next */
  for (i=0; i<sizeof(good_netaddr_from_string) / sizeof(*good_netaddr_from_string); i++) {
    ret = netaddr_from_string(&netaddr_buf, good_netaddr_from_string[i].str);
    CHECK_TRUE(ret == 0, "netaddr_from_string (%s) returns %d", good_netaddr_from_string[i].str, ret);

    if (ret == 0) {
      CHECK_TRUE(memcmp(&netaddr_buf, &good_netaddr_from_string[i].bin, sizeof(netaddr_buf)) == 0,
          "netaddr_from_string (%s) value", good_netaddr_from_string[i].str);
    }
  }

  /* test error cases of string to netaddr conversions next */
  for (i=0; i<sizeof(bad_netaddr_from_string)/sizeof(*bad_netaddr_from_string); i++) {
    CHECK_TRUE (0 != netaddr_from_string(&netaddr_buf, bad_netaddr_from_string[i]),
        "netaddr_from_string %s returns %d", bad_netaddr_from_string[i], ret);
  }

  END_TEST();
}

static void
test_netaddr_create_host(void) {
  struct netaddr netmask, host, result;
  struct netaddr_str buf1, buf2, buf3;
  char buffer1[17], buffer2[17];
  size_t i;

  memset(buffer1, 255, sizeof(buffer1));
  memset(buffer2, 0, sizeof(buffer2));

  START_TEST();

  for (i=0; i<ARRAYSIZE(_create_host_test); i++) {
    CHECK_TRUE(netaddr_from_string(&netmask, _create_host_test[i].netmask) == 0,
        "error in parsing netmask %"PRINTF_SIZE_T_SPECIFIER" %s", i, _create_host_test[i].netmask);
    CHECK_TRUE(netaddr_from_string(&result, _create_host_test[i].result) == 0,
        "error in parsing result %"PRINTF_SIZE_T_SPECIFIER" %s", i, _create_host_test[i].result);

    if (_create_host_test[i].buf_len >= 0) {
      CHECK_TRUE(netaddr_create_host_bin(&host, &netmask, buffer1, _create_host_test[i].buf_len) == 0,
          "error in creating host %"PRINTF_SIZE_T_SPECIFIER" %s with length %d",
          i, netaddr_to_string(&buf1,  &netmask), _create_host_test[i].buf_len);
    }
    else {
      CHECK_TRUE(netaddr_create_host_bin(&host, &netmask, buffer2, -_create_host_test[i].buf_len) == 0,
          "error in creating host %"PRINTF_SIZE_T_SPECIFIER" %s with length %d",
          i, netaddr_to_string(&buf1,  &netmask), _create_host_test[i].buf_len);
    }

    CHECK_TRUE(netaddr_cmp(&host, &result) == 0,
        "Error, host %"PRINTF_SIZE_T_SPECIFIER" %s != result %s (netmask %s, len=%d)",
        i, netaddr_to_string(&buf1, &host), netaddr_to_string(&buf2, &result),
        netaddr_to_string(&buf3, &netmask), _create_host_test[i].buf_len);
  }

  END_TEST();
}

static void
test_netaddr_is_in_subnet(void) {
  struct netaddr_str str1, str2;
  size_t a, s;
  START_TEST();

  for (s = 0; s < sizeof(in_subnet_subnets) / sizeof(*in_subnet_subnets); s++) {
    for (a = 0; a < sizeof(in_subnet_addrs) / sizeof(*in_subnet_addrs); a++) {
      CHECK_TRUE(
          in_subnet_results[a][s] == netaddr_binary_is_in_subnet(&in_subnet_subnets[s], &in_subnet_addrs[a],
              netaddr_get_maxprefix(&in_subnet_addrs[a])/8, in_subnet_addrs[a]._type),
          "%s should %sbe in %s",
          netaddr_to_string(&str1, &in_subnet_addrs[a]),
          in_subnet_results[a][s] ? "" : "not ",
          netaddr_to_string(&str2, &in_subnet_subnets[s]));

      CHECK_TRUE(
          in_subnet_results[a][s] == netaddr_is_in_subnet(&in_subnet_subnets[s], &in_subnet_addrs[a]),
          "%s should %sbe in %s",
          netaddr_to_string(&str1, &in_subnet_addrs[a]),
          in_subnet_results[a][s] ? "" : "not ",
          netaddr_to_string(&str2, &in_subnet_subnets[s]));
    }
  }

  END_TEST();
}

int main(int argc __attribute__ ((unused)), char **argv __attribute__ ((unused))) {
  BEGIN_TESTING(NULL);

  test_netaddr_to_string();
  test_netaddr_from_string();

  test_netaddr_is_in_subnet();

  test_netaddr_create_host();

  return FINISH_TESTING();
}
