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

#include "startle/types.h"
#include "startle/macros.h"
#include "startle/support.h"
#include "startle/log.h"
#include "startle/error.h"
#include "startle/test.h"
#include "startle/map.h"
#include "commands.h"

// declare commands
#define COMMAND_ITEM(name, desc)                \
  void command_##name(int arc, seg_t *argv);
#include "command_list.h"
#undef COMMAND_ITEM

// command function table
#define COMMAND_ITEM(name, desc)                         \
  {                                                      \
    .first = (uintptr_t)#name,                           \
    .second = (uintptr_t)&command_##name                 \
  },
static pair_t commands[] = {
#include "command_list.h"
};
#undef COMMAND_ITEM

// command description table
#define COMMAND_ITEM(name, desc)                         \
  {                                                      \
    .first = (uintptr_t)#name,                           \
    .second = (uintptr_t)desc                            \
  },
static pair_t command_descriptions[] = {
#include "command_list.h"
};
#undef COMMAND_ITEM

#if INTERFACE
#define COMMAND(name, desc) void command_##name(UNUSED int argc, UNUSED seg_t *argv)
#endif

bool run_command(seg_t name, int argc, seg_t *argv) {
  FOREACH(i, commands) {
    pair_t *entry = &commands[i];
    char *entry_name = (char *)entry->first;
    void (*entry_func)(int, seg_t *) = (void (*)(int, seg_t *))entry->second;
    int entry_name_size = strlen(entry_name);
    if((int)name.n <= entry_name_size &&
       strncmp(name.s, entry_name, name.n) == 0) {
      entry_func(argc, argv);
      return true;
    }
  }
  return false;
}

COMMAND(help, "list available commands") {
  printf("'----> FLAG | DESCRIPTION\n");
  FOREACH(i, command_descriptions) {
    pair_t *entry = &command_descriptions[i];
    char *entry_name = (char *)entry->first;
    char *entry_desc = (char *)entry->second;
    int entry_name_size = strlen(entry_name);
    printf("  %*c%s | %s\n", max(0, 9 - entry_name_size), '-', entry_name, entry_desc);
  }
  printf("            V\n");
}
