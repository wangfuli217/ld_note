
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

#include "common/string.h"

#include "cunit/cunit.h"

static char output[16];
static char *output_start;
static size_t output_len;
static struct strarray string_array;


static void
clear_elements(void) {
  memset(output, 0, sizeof(output));

  output_start = &output[1];

  output_len = sizeof(output) - 2;

  /* set guards for over- or underflow */
  output[0] = -1;
  output[sizeof(output)-1] = -1;

  /* initialize string array */
  strarray_free(&string_array);
  strarray_init(&string_array);
}

static void
test_strscpy_1(void) {
  START_TEST();

  strcpy (output_start, "1234");
  strscpy (output_start, "123456", output_len);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "123456") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscpy_2(void) {
  START_TEST();

  strcpy (output_start, "1234");
  strscpy (output_start, "1234567890abcdef", output_len);

  CHECK_TRUE(output[0] == (char)(char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)(char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234567890abc") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscpy_3(void) {
  START_TEST();

  strcpy (output_start, "1234");
  strscpy (output_start, NULL, output_len);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscpy_4(void) {
  START_TEST();

  strcpy (output_start, "1234");
  strscpy (NULL, "123456", output_len);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscpy_5(void) {
  START_TEST();

  strcpy (output_start, "1234");
  strscpy (output_start, "123456", 0);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscpy_6(void) {
  START_TEST();

  strcpy (output_start, "123456");
  strscpy (output_start, "1234", output_len);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscat_1(void) {
  START_TEST();

  strcpy (output_start, "1234");
  strscat (output_start, "123456", output_len);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234123456") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscat_2(void) {
  START_TEST();

  strcpy (output_start, "1234");
  strscat (output_start, "1234567890abcdef", output_len);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234123456789") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscat_3(void) {
  START_TEST();

  strcpy (output_start, "1234");
  strscat (output_start, NULL, output_len);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscat_4(void) {
  START_TEST();

  strcpy (output_start, "1234");
  strscat (NULL, "123456", output_len);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscat_5(void) {
  START_TEST();

  strcpy (output_start, "1234");
  strscat (output_start, "123456", 0);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strscat_6(void) {
  START_TEST();

  strcpy (output_start, "123456");
  strscat (output_start, "1234", output_len);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(output_start, "1234561234") == 0, "bad result: %s", output_start);
  END_TEST();
}

static void
test_strtrim_1(void) {
  char *ptr;

  START_TEST();

  ptr = output_start;
  strcpy(output_start, "\t abcde fg\t ");

  ptr = str_trim(ptr);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(ptr, "abcde fg") == 0, "bad result: %s", ptr);
  CHECK_TRUE(ptr == &output_start[2], "bad start pointer");
  END_TEST();
}

static void
test_strtrim_2(void) {
  char *ptr;

  START_TEST();

  ptr = output_start;
  strcpy(output_start, "abcde fg\t ");

  ptr = str_trim(ptr);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(ptr, "abcde fg") == 0, "bad result: %s", ptr);
  CHECK_TRUE(ptr == &output_start[0], "bad start pointer");
  END_TEST();
}

static void
test_strtrim_3(void) {
  char *ptr;

  START_TEST();

  ptr = output_start;
  strcpy(output_start, " \tabcde fg");

  ptr = str_trim(ptr);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(ptr, "abcde fg") == 0, "bad result: %s", ptr);
  CHECK_TRUE(ptr == &output_start[2], "bad start pointer");
  END_TEST();
}

static void
test_strtrim_4(void) {
  char *ptr;

  START_TEST();

  ptr = output_start;
  strcpy(output_start, " \t  \t");

  ptr = str_trim(ptr);

  CHECK_TRUE(output[0] == (char)-1, "output underflow guard overwritten");
  CHECK_TRUE(output[sizeof(output)-1] == (char)-1, "output overflow guard overwritten");

  CHECK_TRUE(strcmp(ptr, "") == 0, "bad result: %s", ptr);
  CHECK_TRUE(ptr == &output_start[5], "bad start pointer");
  END_TEST();
}

static void
test_strarray_1(void) {
  START_TEST();

  CHECK_TRUE(strarray_get_count(&string_array) == 0,
      "empty array has %"PRINTF_SIZE_T_SPECIFIER" elements!",
      strarray_get_count(&string_array));

  CHECK_TRUE(strarray_append(&string_array, "string1") == 0,
      "Could not append first element");
  CHECK_TRUE(strarray_get_count(&string_array) == 1,
      "one element array has %"PRINTF_SIZE_T_SPECIFIER" elements!",
      strarray_get_count(&string_array));

  CHECK_TRUE(strarray_append(&string_array, "string2") == 0,
      "Could not append second element");
  CHECK_TRUE(strarray_get_count(&string_array) == 2,
      "two element array has %"PRINTF_SIZE_T_SPECIFIER" elements!",
      strarray_get_count(&string_array));

  CHECK_TRUE(strarray_append(&string_array, "3") == 0,
      "Could not append third element");
  CHECK_TRUE(strarray_get_count(&string_array) == 3,
      "three element array has %"PRINTF_SIZE_T_SPECIFIER" elements!",
      strarray_get_count(&string_array));

  END_TEST();
}

static void
test_strarray_2(void) {
  char *ptr;
  int count;

  START_TEST();

  strarray_append(&string_array, "string1");
  strarray_append(&string_array, "string2");
  strarray_append(&string_array, "3");

  count = 0;
  strarray_for_each_element(&string_array, ptr) {
    count++;
    switch(count) {
      case 1:
        CHECK_TRUE(strcmp(ptr, "string1") == 0, "1st string is '%s'", ptr);
        break;
      case 2:
        CHECK_TRUE(strcmp(ptr, "string2") == 0, "2nd string is '%s'", ptr);
        break;
      case 3:
        CHECK_TRUE(strcmp(ptr, "3") == 0, "3rd string is '%s'", ptr);
        break;
      default:
        CHECK_TRUE(false, "Loop count was %d", count);
        break;
    }
  }

  for (count = 0; count < 3; count ++) {
    ptr = strarray_get(&string_array, count);

    switch(count+1) {
      case 1:
        CHECK_TRUE(strcmp(ptr, "string1") == 0, "1st string is '%s'", ptr);
        break;
      case 2:
        CHECK_TRUE(strcmp(ptr, "string2") == 0, "2nd string is '%s'", ptr);
        break;
      case 3:
        CHECK_TRUE(strcmp(ptr, "3") == 0, "3rd string is '%s'", ptr);
        break;
      default:
        CHECK_TRUE(false, "Loop count was %d", count);
        break;
    }
  }
  END_TEST();
}

static void
test_strarray_3(void) {
  char *ptr;

  START_TEST();

  strarray_append(&string_array, "string1");
  strarray_append(&string_array, "string2");
  strarray_append(&string_array, "3");

  ptr = strarray_get_first(&string_array);
  CHECK_TRUE(strcmp(ptr, "string1") == 0, "first string was %s", ptr);

  END_TEST();
}


static void
test_strarray_4(void) {
  char *ptr;
  int count;

  START_TEST();

  strarray_append(&string_array, "string1");
  strarray_append(&string_array, "string2");
  strarray_append(&string_array, "3");

  /* remove first */
  ptr = strarray_get(&string_array, 0);
  strarray_remove(&string_array, ptr);

  CHECK_TRUE(strarray_get_count(&string_array) == 2,
      "After removal array had %"PRINTF_SIZE_T_SPECIFIER" elements",
      strarray_get_count(&string_array));

  count = 0;
  strarray_for_each_element(&string_array, ptr) {
    count++;
    switch(count) {
      case 1:
        CHECK_TRUE(strcmp(ptr, "string2") == 0, "1st string is '%s'", ptr);
        break;
      case 2:
        CHECK_TRUE(strcmp(ptr, "3") == 0, "2nd string is '%s'", ptr);
        break;
      default:
        CHECK_TRUE(false, "Loop count was %d", count);
        break;
    }
  }

  END_TEST();
}

static void
test_strarray_5(void) {
  char *ptr;
  int count;

  START_TEST();

  strarray_append(&string_array, "string1");
  strarray_append(&string_array, "string2");
  strarray_append(&string_array, "3");

  /* remove second */
  ptr = strarray_get(&string_array, 1);
  strarray_remove(&string_array, ptr);

  CHECK_TRUE(strarray_get_count(&string_array) == 2,
      "After removal array had %"PRINTF_SIZE_T_SPECIFIER" elements",
      strarray_get_count(&string_array));

  count = 0;
  strarray_for_each_element(&string_array, ptr) {
    count++;
    switch(count) {
      case 1:
        CHECK_TRUE(strcmp(ptr, "string1") == 0, "1st string is '%s'", ptr);
        break;
      case 2:
        CHECK_TRUE(strcmp(ptr, "3") == 0, "2nd string is '%s'", ptr);
        break;
      default:
        CHECK_TRUE(false, "Loop count was %d", count);
        break;
    }
  }

  END_TEST();
}

static void
test_strarray_6(void) {
  char *ptr;
  int count;

  START_TEST();

  strarray_append(&string_array, "string1");
  strarray_append(&string_array, "string2");
  strarray_append(&string_array, "3");

  /* remove third */
  ptr = strarray_get(&string_array, 2);
  strarray_remove(&string_array, ptr);

  CHECK_TRUE(strarray_get_count(&string_array) == 2,
      "After removal array had %"PRINTF_SIZE_T_SPECIFIER" elements",
      strarray_get_count(&string_array));

  count = 0;
  strarray_for_each_element(&string_array, ptr) {
    count++;
    switch(count) {
      case 1:
        CHECK_TRUE(strcmp(ptr, "string1") == 0, "1st string is '%s'", ptr);
        break;
      case 2:
        CHECK_TRUE(strcmp(ptr, "string2") == 0, "2nd string is '%s'", ptr);
        break;
      default:
        CHECK_TRUE(false, "Loop count was %d", count);
        break;
    }
  }

  END_TEST();
}

static void
test_strarray_7(void) {
  char *ptr;

  START_TEST();

  strarray_append(&string_array, "string1");
  strarray_append(&string_array, "string2");
  strarray_append(&string_array, "3");

  /* remove first */
  ptr = strarray_get_first(&string_array);
  strarray_remove(&string_array, ptr);
  CHECK_TRUE(strarray_get_count(&string_array) == 2,
      "After 1st removal array had %"PRINTF_SIZE_T_SPECIFIER" elements",
      strarray_get_count(&string_array));

  /* remove second */
  ptr = strarray_get_first(&string_array);
  strarray_remove(&string_array, ptr);
  CHECK_TRUE(strarray_get_count(&string_array) == 1,
      "After 2nd removal array had %"PRINTF_SIZE_T_SPECIFIER" elements",
      strarray_get_count(&string_array));

  /* remove third */
  ptr = strarray_get_first(&string_array);
  strarray_remove(&string_array, ptr);
  CHECK_TRUE(strarray_get_count(&string_array) == 0,
      "After 3rd removal array had %"PRINTF_SIZE_T_SPECIFIER" elements",
      strarray_get_count(&string_array));

  /* check result */
  CHECK_TRUE(string_array.value == NULL, "value should be NULL");
  CHECK_TRUE(string_array.length == 0, "length should be 0");
  END_TEST();
}

static void
test_strarray_8(void) {
  char *ptr;
  int count;

  START_TEST();

  strarray_prepend(&string_array, "string1");
  strarray_prepend(&string_array, "string2");
  strarray_prepend(&string_array, "3");

  count = 0;
  strarray_for_each_element(&string_array, ptr) {
    count++;
    switch(count) {
      case 1:
        CHECK_TRUE(strcmp(ptr, "3") == 0, "1st string is '%s'", ptr);
        break;
      case 2:
        CHECK_TRUE(strcmp(ptr, "string2") == 0, "2nd string is '%s'", ptr);
        break;
      case 3:
        CHECK_TRUE(strcmp(ptr, "string1") == 0, "3rd string is '%s'", ptr);
        break;
      default:
        CHECK_TRUE(false, "Loop count was %d", count);
        break;
    }
  }

  END_TEST();
}


static void
test_str_hasnextword_1(void) {
  const char *TEST = "a b c";
  const char *ptr;

  START_TEST();

  ptr = str_hasnextword(TEST, "a");
  CHECK_TRUE(ptr, "First word should be 'a'");

  if (ptr) {
    ptr = str_hasnextword(ptr, "b");
    CHECK_TRUE(ptr, "Second word should be 'b'");
  }

  if (ptr) {
    ptr = str_hasnextword(ptr, "c");
    CHECK_TRUE(ptr, "Second word should be 'c'");
  }

  if (ptr) {
    ptr = str_hasnextword(ptr, "d");
    CHECK_TRUE(ptr == NULL, "Fourth word should be NULL");
  }

  ptr = str_hasnextword(TEST, "a");
  CHECK_TRUE(ptr, "First word should be 'a'");

  if (ptr) {
    ptr = str_hasnextword(ptr, "c");
    CHECK_TRUE(ptr == NULL, "Second word should not be 'c'");
  }

  END_TEST();
}


static void
test_str_hasnextword_2(void) {
  const char *TEST = " a \t b \t c \t";
  const char *ptr;

  START_TEST();

  ptr = str_hasnextword(TEST, "a");
  CHECK_TRUE(ptr, "First word should be 'a'");

  if (ptr) {
    ptr = str_hasnextword(ptr, "b");
    CHECK_TRUE(ptr, "Second word should be 'b'");
  }

  if (ptr) {
    ptr = str_hasnextword(ptr, "c");
    CHECK_TRUE(ptr, "Second word should be 'c'");
  }

  if (ptr) {
    ptr = str_hasnextword(ptr, "d");
    CHECK_TRUE(ptr == NULL, "Fourth word should be NULL");
  }

  ptr = str_hasnextword(TEST, "a");
  CHECK_TRUE(ptr, "First word should be 'a'");

  if (ptr) {
    ptr = str_hasnextword(ptr, "c");
    CHECK_TRUE(ptr == NULL, "Second word should not be 'c'");
  }

  END_TEST();
}

static void
test_str_hasnextword_3(void) {
  const char *TEST1 = "";
  const char *TEST2 = " \t";

  START_TEST();

  CHECK_TRUE(str_hasnextword(TEST1, "a") == NULL, "First word should be NULL");
  CHECK_TRUE(str_hasnextword(TEST2, "a") == NULL, "First word should be NULL");

  END_TEST();
}

int
main(int argc __attribute__ ((unused)), char **argv __attribute__ ((unused))) {
  strarray_init(&string_array);

  BEGIN_TESTING(clear_elements);

  test_strscpy_1();
  test_strscpy_2();
  test_strscpy_3();
  test_strscpy_4();
  test_strscpy_5();
  test_strscpy_6();

  test_strscat_1();
  test_strscat_2();
  test_strscat_3();
  test_strscat_4();
  test_strscat_5();
  test_strscat_6();

  test_strtrim_1();
  test_strtrim_2();
  test_strtrim_3();
  test_strtrim_4();

  test_strarray_1();
  test_strarray_2();
  test_strarray_3();
  test_strarray_4();
  test_strarray_5();
  test_strarray_6();
  test_strarray_7();
  test_strarray_8();

  test_str_hasnextword_1();
  test_str_hasnextword_2();
  test_str_hasnextword_3();

  strarray_free(&string_array);

  return FINISH_TESTING();
}
