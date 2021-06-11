/* Copyright 2012-2018 Dustin M. DeWeese

   This file is part of the Startle example program.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "startle/types.h"
#include "startle/macros.h"
#include "startle/support.h"
#include "startle/log.h"
#include "startle/error.h"
#include "startle/test.h"
#include "startle/map.h"
#include "commands.h"

int main(int argc, char **argv) {
  seg_t command_name = {NULL, 0};
  seg_t command_argv[4];
  unsigned int command_argc = 0;
  error_t error;
  if(catch_error(&error)) {
    log_print_all();
    return -error.type;
  } else {
    COUNTUP(i, argc) {
      char *arg = argv[i];
      int len = strlen(arg);
      if(len == 0) continue;
      if(arg[0] == '-') {
        // run previous command
        if(command_name.s) {
          run_command(command_name, command_argc, command_argv);
        }
        command_argc = 0;
        command_name = (seg_t) {.s = arg + 1,
                                .n = len - 1};
      } else if(command_argc < LENGTH(command_argv)) {
        command_argv[command_argc++] = (seg_t) { .s = arg, .n = len };
      }
    }
    // run previous command
    if(command_name.s) {
      run_command(command_name, command_argc, command_argv);
    }
    return 0;
  }
}

COMMAND(test, "run tests matching the argument") {
  run_test(argc > 0 ? argv[0] : (seg_t){"", 0});
}

COMMAND(log, "print the log") {
  log_print_all();
}

/* How to use this:
 * 1. Find an interesting tag (last four characters) in the log
 * 2. Load the program in a debugger
 * 3. Set a breakpoint on the function 'breakpoint'
 * 4. Run again passing the log tag with this flag
 * 5. Finish the 'breakpoint' function
 * 6. Now you are at the log message
 *
 * With LLDB:
 * $ lldb example
 * (lldb) b breakpoint
 * (lldb) process launch -- -watch mhdc -fib 5
 * (lldb) finish
 */
COMMAND(watch, "watch for a log tag") {
  if(argc > 0) {
    seg_t tag = argv[0];
    if(tag.n == sizeof(tag_t) &&
       tag.s[0] >= 'a' &&
       tag.s[0] <= 'z') {
      set_log_watch(tag.s, false);
    } else {
      printf("invalid log tag\n");
    }
  }
}

// Naive recursive calculation of the nth Fibonacci number
int fib(int n) {
  CONTEXT("Calculating fib(%d)", n);
  assert_error(n >= 0, "must be a positive number");
  if(n < 2) {
    LOG("fib(%d) is obviously 1", n);
    return 1;
  } else {
    assert_counter(10000000);
    int a = fib(n - 1);
    int b = fib(n - 2);
    int r = a + b;
    assert_error(r >= 0, "overflow");
    LOG("%d + %d = %d", a, b, r);
    return r;
  }
}

COMMAND(fib, "calculate the Nth Fibonacci number") {
  if(argc > 0) {
    int x = atoi(argv[0].s);
    int r = fib(x);
    printf("fib(%d) = %d\n", x, r);
  }
}

// Memoized recursive calculation of the nth Fibonacci number
MAP(fib_result_map, 50);
int fib_map(int n) {
  CONTEXT("Calculating fib_map(%d)", n);
  assert_error(n >= 0, "must be a positive number");
  if(n < 2) {
    LOG("fib(%d) is obviously 1", n);
    return 1;
  } else {
    assert_counter(10000000);
    pair_t *x = map_find(fib_result_map, n);
    if(x) {
      int r = x->second;
      LOG("found fib(%d) = %d", n, r);
      return r;
    } else {
      int a = fib_map(n - 1);
      int b = fib_map(n - 2);
      int r = a + b;
      assert_error(r >= 0, "overflow");
      LOG_UNLESS(map_insert(fib_result_map, (pair_t) {n, r}),
                 NOTE("insertion failed"));
      LOG("insert fib(%d) = %d + %d = %d", n, a, b, r);
      return r;
    }
  }
}

COMMAND(fib_map, "calculate the Nth Fibonacci number, with memoization") {
  if(argc > 0) {
    int x = atoi(argv[0].s);
    int r = fib_map(x);
    printf("fib_map(%d) = %d\n", x, r);
  }
}
