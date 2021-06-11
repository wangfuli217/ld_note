
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

#include "common/common_types.h"
#include "common/netaddr.h"
#include "common/netaddr_acl.h"
#include "common/string.h"

static bool _is_in_array(const struct netaddr *, size_t, const struct netaddr *);

/**
 * Initialize an ACL object. It will contain no addresses on both
 * accept and reject list and will be "accept first", "reject default".
 * @param acl pointer to ACL
 */
void
netaddr_acl_add(struct netaddr_acl *acl) {
  memset(acl, 0, sizeof(*acl));
}

/**
 * Cleanup an ACL object and free its resources.
 * @param acl pointer to ACL
 */
void
netaddr_acl_remove(struct netaddr_acl *acl) {
  free(acl->accept);
  free(acl->reject);

  memset(acl, 0, sizeof(*acl));
}

/**
 * Initialize an ACL with a list of string parameters.
 * @param acl pointer to uninitialized ACL
 * @param value pointer to string-array of text arguments for the ACL
 * @return -1 if an error happened, 0 otherwise
 */
int
netaddr_acl_from_strarray(struct netaddr_acl *acl,
    const struct const_strarray *value) {
  size_t accept_count, reject_count;
  const char *ptr, *addr;

  accept_count = 0;
  reject_count = 0;

  /* clear acl struct */
  memset(acl, 0, sizeof(*acl));

  /* count number of address entries */
  strarray_for_each_element(value, ptr) {
    if (netaddr_acl_handle_keywords(acl, ptr) == 0) {
      continue;
    }

    if (ptr[0] == '-') {
      reject_count++;
    }
    else {
      accept_count++;
    }
  }

  /* allocate memory */
  if (accept_count > 0) {
    acl->accept = calloc(accept_count, sizeof(struct netaddr));
    if (acl->accept == NULL) {
      goto from_entry_error;
    }
  }
  if (reject_count > 0) {
    acl->reject = calloc(reject_count, sizeof(struct netaddr));
    if (acl->reject == NULL) {
      goto from_entry_error;
    }
  }

  /* read netaddr strings into buffers */
  strarray_for_each_element(value, ptr) {
    if (netaddr_acl_handle_keywords(acl, ptr) == 0) {
      continue;
    }

    if (*ptr == '-' || *ptr == '+') {
      addr = &ptr[1];
    }
    else {
      addr = ptr;
    }

    if (*ptr == '-') {
      if (netaddr_from_string(&acl->reject[acl->reject_count], addr)) {
        goto from_entry_error;
      }
      acl->reject_count++;
    }
    else {
      if (netaddr_from_string(&acl->accept[acl->accept_count], addr)) {
         goto from_entry_error;
      }
      acl->accept_count++;
    }
  }
  return 0;

from_entry_error:
  netaddr_acl_remove(acl);
  return -1;
}

/**
 * Copy one ACL to another one.
 * @param to pointer to destination ACL
 * @param from pointer to source ACL
 * @return -1 if an error happened, 0 otherwise
 */
int
netaddr_acl_copy(struct netaddr_acl *to, const struct netaddr_acl *from) {
  netaddr_acl_remove(to);
  memcpy(to, from, sizeof(*to));

  if (to->accept_count) {
    to->accept = calloc(to->accept_count, sizeof(struct netaddr));
    if (to->accept == NULL) {
      return -1;
    }
    memcpy(to->accept, from->accept, to->accept_count * sizeof(struct netaddr));
  }

  if (to->reject_count) {
    to->reject = calloc(to->reject_count, sizeof(struct netaddr));
    if (to->reject == NULL) {
      return -1;
    }
    memcpy(to->reject, from->reject, to->reject_count * sizeof(struct netaddr));
  }
  return 0;
}

/**
 * Check if an address is accepted by an ACL
 * @param acl pointer to ACL
 * @param addr pointer to address
 * @return true if accepted, false otherwise
 */
bool
netaddr_acl_check_accept(const struct netaddr_acl *acl, const struct netaddr *addr) {
  if (acl->reject_first) {
    if (_is_in_array(acl->reject, acl->reject_count, addr)) {
      return false;
    }
  }

  if (_is_in_array(acl->accept, acl->accept_count, addr)) {
    return true;
  }

  if (!acl->reject_first) {
    if (_is_in_array(acl->reject, acl->reject_count, addr)) {
      return false;
    }
  }

  return acl->accept_default;
}

/**
 * Handle the four control text blocks for ACL initialization.
 * @param acl pointer to ACL
 * @param cmd pointer to control word
 * @return -1 if not a control word, 0 if control world was applied
 */
int
netaddr_acl_handle_keywords(struct netaddr_acl *acl, const char *cmd) {
  if (strcasecmp(cmd, ACL_DEFAULT_ACCEPT) == 0) {
    acl->accept_default = true;
  }
  else if (strcasecmp(cmd, ACL_DEFAULT_REJECT) == 0) {
    acl->accept_default = false;
  }
  else if (strcasecmp(cmd, ACL_FIRST_ACCEPT) == 0) {
    acl->reject_first = false;
  }
  else if (strcasecmp(cmd, ACL_FIRST_REJECT) == 0) {
    acl->reject_first = true;
  }
  else {
    /* no control command, must be an address */
    return -1;
  }

  /* was one of the four valid control commands */
  return 0;
}

/**
 * @param array pointer to array of addresses and networks
 * @param length length of array
 * @param addr pointer of address to be checked
 * @return true if address is inside list of addresses and networks
 */
static bool
_is_in_array(const struct netaddr *array, size_t length, const struct netaddr *addr) {
  size_t i;

  for (i=0; i<length; i++) {
    if (netaddr_is_in_subnet(&array[i], addr)) {
      return true;
    }
  }
  return false;
}
