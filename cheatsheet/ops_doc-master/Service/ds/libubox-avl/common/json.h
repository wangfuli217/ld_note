
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

#ifndef JSON_H_
#define JSON_H_

#include "common/common_types.h"
#include "common/autobuf.h"
#include "common/template.h"

/**
 * contains the session variables for JSON generation
 */
struct json_session {
  /*! pointer to output buffer */
  struct autobuf *out;

  /*! true if we just started a new object/array */
  bool empty;
};

EXPORT void json_init_session(struct json_session *,
    struct autobuf *out);
EXPORT void json_start_array(struct json_session *,
    const char *name);
EXPORT void json_end_array(struct json_session *);
EXPORT void json_start_object(struct json_session *,
    const char *name);
EXPORT void json_end_object(struct json_session *);
EXPORT void json_print_templates(struct json_session *,
    struct abuf_template_data *data, size_t count);
EXPORT void json_print(struct json_session *session,
    const char *key, bool string, const char *value);

/**
 * Returns the JSON text representation of a boolean
 * @param value boolean value
 * @return "true" or "false
 */
static INLINE const char *
json_getbool(bool value) {
  return value ? "true" : "false";
}

#endif /* JSON_H_ */
