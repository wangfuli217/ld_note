
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

#ifndef TEMPLATE_H_
#define TEMPLATE_H_

#include "common/common_types.h"
#include "common/autobuf.h"

/*! text name for json boolean true value */
#define TEMPLATE_JSON_TRUE            "true"

/*! text name for json boolean false value */
#define TEMPLATE_JSON_FALSE           "false"

enum {
  /*! length of text buffer for json boolean */
  TEMPLATE_JSON_BOOL_LENGTH = 6,

  /*! maximum number of template keys per template */
  TEMPLATE_MAX_KEYS         = 32
};

/**
 * Defines a single Template key/value data entry
 */
struct abuf_template_data_entry {
  /*! key of the data entry */
  const char *key;

  /*! value of the data entry */
  const char *value;

  /*! true if the data is a string, false if it is a number */
  bool string;
};

/**
 * Represents an array of data entries that can be used to
 * build a complete template
 */
struct abuf_template_data {
  /*! pointer to array of data entries */
  struct abuf_template_data_entry *data;

  /*! number of data entries in array */
  size_t count;
};

/**
 * Stores which byte range has to be replaced by a certain data entry
 */
struct abuf_template_storage_entry {
  /*! pointer to data entry */
  struct abuf_template_data_entry *data;

  /*! first byte to be replaced with data entry value */
  size_t start;

  /*! first byte after the replaced format string */
  size_t end;
};

/**
 * Preprocessed template format string
 */
struct abuf_template_storage {
  /*! number of templates used in format string */
  size_t count;

  /*! format string for template */
  const char *format;

  /*! mapping of used templates to byte positions in format string */
  struct abuf_template_storage_entry indices[TEMPLATE_MAX_KEYS];
};

EXPORT void abuf_template_init_ext (struct abuf_template_storage *storage,
    struct abuf_template_data *data, size_t data_count, const char *format);
EXPORT void abuf_add_template(struct autobuf *out,
    struct abuf_template_storage *storage, bool keys);

/**
 * Helper function to initialize a template with
 * a single abuf_template_data_entry array
 * @param storage
 * @param entry
 * @param entry_count
 * @param format
 */
static INLINE void
abuf_template_init(struct abuf_template_storage *storage,
    struct abuf_template_data_entry *entry, size_t entry_count, const char *format) {
  struct abuf_template_data data = { entry, entry_count };
  abuf_template_init_ext(storage, &data, 1, format);
}

#endif /* TEMPLATE_H_ */
