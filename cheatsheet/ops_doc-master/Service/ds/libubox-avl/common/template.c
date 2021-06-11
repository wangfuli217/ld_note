
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

#include <stdio.h>
#include <stdlib.h>

#include "common/common_types.h"
#include "common/autobuf.h"
#include "common/string.h"
#include "common/template.h"

static struct abuf_template_data_entry *_find_template(
    struct abuf_template_data *set, size_t set_count, const char *txt, size_t txtLength);

/**
 * Initialize an index table for a template engine.
 * Each usage of a key in the format has to be %key%.
 * The existing keys (start, end, key-number) will be recorded
 * in the integer array the user provided, so the template
 * engine can replace them with the values later.
 *
 * @param storage pointer to template storage
 * @param data array of key/value pairs for the template engine
 * @param data_count number of keys
 * @param format format string of the template
 */
void
abuf_template_init_ext(struct abuf_template_storage *storage,
    struct abuf_template_data *data, size_t data_count, const char *format) {
  /* helper string for 'just one tab between keys' */
  static const char default_format[] = "\t";

  struct abuf_template_data_entry *d;
  bool no_open_format = true;
  bool escape = false;
  size_t start = 0;
  size_t pos = 0;
  size_t i,j;

  memset(storage, 0, sizeof(*storage));

  if (!format) {
    /* generate default format, just tab between each value */
    storage->format = default_format;

    storage->count = 0;

    for (j = 0; j < data_count; j++) {
      for (i = 0; i < data[j].count; i++) {
        storage->indices[storage->count].start = 1;
        storage->indices[storage->count].end = 0;
        storage->indices[storage->count].data = &data[j].data[i];
        storage->count++;
      }
    }

    if (storage->count) {
      storage->indices[0].start = 0;
      storage->indices[storage->count-1].end = 1;
    }
    return;
  }

  storage->format = format;
  while (format[pos]) {
    if (!escape && format[pos] == '%') {
      if (no_open_format) {
        start = pos++;
        no_open_format = false;
        continue;
      }
      if (pos - start > 1) {
        d = _find_template(data, data_count, &format[start+1], pos-start-1);
        if (d) {
          storage->indices[storage->count].start = start;
          storage->indices[storage->count].end = pos+1;
          storage->indices[storage->count].data = d;

          storage->count++;
        }
      }
      no_open_format = true;
    }
    else if (format[pos] == '\\') {
      /* handle "\\" and "\%" in text */
      escape = !escape;
    }
    else {
      escape = false;
    }

    pos++;
  }
}

/**
 * Append the result of a template engine into an autobuffer.
 * Each usage of a key will be replaced with the corresponding
 * value.
 * @param out pointer to autobuf object
 * @param storage pointer to template storage object, which will be filled by
 *   this function
 * @param keys true if the engine should leave the keys in there,
 *   false to insert the values.
 */
void
abuf_add_template(struct autobuf *out,
    struct abuf_template_storage *storage, bool keys) {
  struct abuf_template_storage_entry *entry;
  size_t i, last = 0;
  const char *value;

  for (i=0; i<storage->count; i++) {
    entry = &storage->indices[i];

    /* copy prefix text */
    if (last < entry->start) {
      abuf_memcpy(out, &storage->format[last], entry->start - last);
    }

    if (keys) {
      value = entry->data->key;
    }
    else {
      value = entry->data->value;
    }
    if (value) {
      abuf_puts(out, value);
    }
    last = entry->end;
  }

  if (last < strlen(storage->format)) {
    abuf_puts(out, &storage->format[last]);
  }
}

/**
 * Find the template data corresponding to a key
 * @param set pointer to template data array
 * @param set_count number of template data entries in array
 * @param txt pointer to text to search in
 * @param txtLength length of text to search in
 * @return pointer to corresponding template data, NULL if not found
 */
static struct abuf_template_data_entry *
_find_template(struct abuf_template_data *set, size_t set_count, const char *txt, size_t txtLength) {
  size_t i, j;

  for (j=0; j<set_count; j++) {
    for (i=0; i<set[j].count; i++) {
      const char *key;

      key = set[j].data[i].key;
      if (strncmp(key, txt, txtLength) == 0 && key[txtLength] == 0) {
        return &set[j].data[i];
      }
    }
  }
  return NULL;
}
