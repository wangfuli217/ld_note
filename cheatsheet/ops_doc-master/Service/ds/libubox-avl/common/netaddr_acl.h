
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

#ifndef NETADDR_ACL_H_
#define NETADDR_ACL_H_

#include "common/common_types.h"
#include "common/netaddr.h"
#include "common/string.h"

/*
 * Text commands within ACL lists.
 *
 * Used preprocessor instead of variables to allow building
 * larger strings, e.g. "-127.0.0.1 " ACL_FIRST_ACCEPT
 */

/*! text name for checking the reject list of an ACL first */
#define ACL_FIRST_REJECT "first_reject"

/*! text name for checking the accept list of an ACL first */
#define ACL_FIRST_ACCEPT "first_accept"

/*! text name for accepting an address if no list matches */
#define ACL_DEFAULT_ACCEPT "default_accept"

/*! text name for rejecting an address if no list matches */
#define ACL_DEFAULT_REJECT "default_reject"

/**
 * represents an netaddr access control list with white/blacklist
 */
struct netaddr_acl {
  /*! array of prefixes that will be accepted by the ACL */
  struct netaddr *accept;

  /*! number of accepted prefixes */
  size_t accept_count;

  /*! array of prefixes that will be rejected by the ACL */
  struct netaddr *reject;

  /*! number of rejected prefixes */
  size_t reject_count;

  /**
   * true if the reject array will be parsed first,
   * false if the accept array will be parsed first.
   */
  bool reject_first;

  /*! result of the check if neither of the arrays have a match */
  bool accept_default;
};

EXPORT void netaddr_acl_add(struct netaddr_acl *);
EXPORT int netaddr_acl_from_strarray(struct netaddr_acl *, const struct const_strarray *value);
EXPORT void netaddr_acl_remove(struct netaddr_acl *);
EXPORT int netaddr_acl_copy(struct netaddr_acl *to, const struct netaddr_acl *from);

EXPORT bool netaddr_acl_check_accept(const struct netaddr_acl *, const struct netaddr *);
EXPORT int netaddr_acl_handle_keywords(struct netaddr_acl *acl, const char *cmd);

#endif /* NETADDR_ACL_H_ */
