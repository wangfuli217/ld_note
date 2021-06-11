
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

#include "common/list.h"
#include "cunit/cunit.h"

struct list_element {
  int value;
  struct list_entity node;
};

#define COUNT 6

struct list_entity head;
struct list_element elements1[COUNT], elements2[COUNT];
int values[COUNT] = { 1,2,3,4,5,6 };

static void clear_elements(void) {
  int i;

  memset(&head, 0, sizeof(head));
  memset(values, 0, sizeof(values));
  memset(elements1, 0, sizeof(elements1));
  memset(elements2, 0, sizeof(elements2));

  for (i=0; i<COUNT; i++) {
    elements1[i].value = i;
    elements2[i].value = -i;
  }
}

static void add_elements(struct list_element *elements, bool add_head) {
  int i;
  for (i=0; i<COUNT; i++) {
    list_init_node(&elements[i].node);

    if (add_head) {
      list_add_head(&head, &elements[i].node);
    }
    else {
      list_add_tail(&head, &elements[i].node);
    }
  }
}
static void test_add_tail(void) {
  int i;

  START_TEST();
  list_init_head(&head);
  add_elements(elements1, false);

  CHECK_TRUE(head.next == &elements1[0].node, "head->next");
  CHECK_TRUE(head.prev == &elements1[COUNT-1].node, "head->prev");
  CHECK_TRUE(elements1[0].node.prev == &head, "elements1[0]->prev");
  CHECK_TRUE(elements1[COUNT-1].node.next == &head, "elements1[%d]->next", COUNT-1);

  for (i=0; i<COUNT-1; i++) {
    CHECK_TRUE(elements1[i].node.next == &elements1[i+1].node, "elements1[%d]->next", i);
  }
  for (i=1; i<COUNT; i++) {
    CHECK_TRUE(elements1[i].node.prev == &elements1[i-1].node, "elements1[%d]->prev", i);
  }
  END_TEST();
}

static void test_add_head(void) {
  int i;

  START_TEST();
  list_init_head(&head);
  add_elements(elements1, true);

  CHECK_TRUE(head.next == &elements1[COUNT-1].node, "head->next");
  CHECK_TRUE(head.prev == &elements1[0].node, "head->prev");
  CHECK_TRUE(elements1[COUNT-1].node.prev == &head, "elements1[%d]->prev", COUNT-1);
  CHECK_TRUE(elements1[0].node.next == &head, "elements1[0]->next");

  for (i=0; i<COUNT-1; i++) {
    CHECK_TRUE(elements1[i].node.prev == &elements1[i+1].node, "elements1[%d]->prev", i);
  }
  for (i=1; i<COUNT; i++) {
    CHECK_TRUE(elements1[i].node.next == &elements1[i-1].node, "elements1[%d]->next", i);
  }
  END_TEST();
}

static void test_add_before(void) {
  START_TEST();
  list_init_head(&head);
  add_elements(elements1, false);

  list_add_before(&elements1[3].node, &elements2[0].node);

  CHECK_TRUE(elements1[2].node.next == &elements2[0].node, "elements1[2]->next");
  CHECK_TRUE(elements1[3].node.prev == &elements2[0].node, "elements1[3]->prev");
  CHECK_TRUE(elements2[0].node.next == &elements1[3].node, "elements2[0]->next");
  CHECK_TRUE(elements2[0].node.prev == &elements1[2].node, "elements2[0]->prev");
  END_TEST();
}

static void test_add_after(void) {
  START_TEST();
  list_init_head(&head);
  add_elements(elements1, false);

  list_add_after(&elements1[2].node, &elements2[0].node);

  CHECK_TRUE(elements1[2].node.next == &elements2[0].node, "elements1[2]->next");
  CHECK_TRUE(elements1[3].node.prev == &elements2[0].node, "elements1[3]->prev");
  CHECK_TRUE(elements2[0].node.next == &elements1[3].node, "elements2[0]->next");
  CHECK_TRUE(elements2[0].node.prev == &elements1[2].node, "elements2[0]->prev");
  END_TEST();
}

static void test_remove(void) {
  START_TEST();
  list_init_head(&head);
  add_elements(elements1, false);

  list_remove(&elements1[2].node);

  CHECK_TRUE(elements1[1].node.next == &elements1[3].node, "elements1[1]->next");
  CHECK_TRUE(elements1[3].node.prev == &elements1[1].node, "elements1[3]->prev");
  CHECK_TRUE(elements1[2].node.next == NULL, "elements1[2]->next");
  CHECK_TRUE(elements1[2].node.prev == NULL, "elements1[2]->prev");
  END_TEST();
}

static void test_conditions(void) {
  START_TEST();
  list_init_head(&head);

  CHECK_TRUE(list_is_empty(&head), "list_is_empty (1)");
  CHECK_TRUE(!list_is_node_added(&elements1[0].node), "list_node_added (1)");

  add_elements(elements1, false);

  CHECK_TRUE(!list_is_empty(&head), "list_is_empty (1)");
  CHECK_TRUE(list_is_node_added(&elements1[0].node), "list_node_added (1)");

  CHECK_TRUE(list_is_first(&head, &elements1[0].node), "list_is_first (1)");
  CHECK_TRUE(list_is_last(&head, &elements1[COUNT-1].node), "list_is_last (1)");
  CHECK_TRUE(!list_is_first(&head, &elements1[1].node), "list_is_first (2)");
  CHECK_TRUE(!list_is_last(&head, &elements1[1].node), "list_is_last (2)");
  END_TEST();
}

static void test_merge(void) {
  struct list_entity head2;
  int i;
  struct list_element *e;

  START_TEST();
  list_init_head(&head);
  list_init_head(&head2);

  CHECK_TRUE(list_is_empty(&head), "list_is_empty (1)");
  CHECK_TRUE(!list_is_node_added(&elements1[0].node), "list_node_added (1)");
  CHECK_TRUE(!list_is_node_added(&elements2[0].node), "list_node_added (1)");

  add_elements(elements1, false);

  for (i=0; i<COUNT; i++) {
    list_init_node(&elements2[i].node);
    list_add_tail(&head2, &elements2[i].node);
  }

  i = 0;
  list_for_each_element(&head, e, node) {
    CHECK_TRUE(e == &elements1[i], "for_each iteration %d failed", i);
    i++;
  }
  i = 0;
  list_for_each_element(&head2, e, node) {
    CHECK_TRUE(e == &elements2[i], "for_each iteration %d failed", i);
    i++;
  }

  list_merge(&head, &head2);
  CHECK_TRUE(list_is_empty(&head2), "list_is_empty (1)");

  i = 0;
  list_for_each_element(&head2, e, node) {
    if (i < COUNT) {
      CHECK_TRUE(e == &elements1[i], "for_each iteration %d failed", i);
    }
    else {
      CHECK_TRUE(e == &elements2[i-COUNT], "for_each iteration %d failed", i);
    }
    i++;
  }

  END_TEST();
}
static void test_element_macros(void) {
  struct list_element *e;

  START_TEST();
  list_init_head(&head);
  add_elements(elements1, false);

  CHECK_TRUE(list_first_element(&head, e, node) == &elements1[0], "list_first_element");
  CHECK_TRUE(list_last_element(&head, e, node) == &elements1[COUNT-1], "list_first_element");

  CHECK_TRUE(list_next_element(&elements1[0], node) == &elements1[1], "list_next_element(elements1[0])");
  CHECK_TRUE(list_prev_element(&elements1[1], node) == &elements1[0], "list_prev_element(elements1[1])");
  END_TEST();
}

static void test_for_each_macros(void) {
  struct list_element *e;
  int i;

  START_TEST();
  list_init_head(&head);
  add_elements(elements1, false);

  i = 0;
  list_for_each_element(&head, e, node) {
    CHECK_TRUE(e == &elements1[i], "for_each iteration %d failed", i);
    i++;
  }
  CHECK_TRUE(i == COUNT, "for_each only had %d of %d iterations", i, COUNT);

  i = 1;
  list_for_element_range(&elements1[1], &elements1[4], e, node) {
    CHECK_TRUE(e == &elements1[i], "for_element_range iteration %d failed", i);
    i++;
  }
  CHECK_TRUE(i == 5, "for_element_range only had %d of %d iterations", i-1, 4);

  i = 1;
  list_for_element_to_last(&head, &elements1[1], e, node) {
    CHECK_TRUE(e == &elements1[i], "element_to_last iteration %d failed", i);
    i++;
  }
  CHECK_TRUE(i == COUNT, "element_to_last only had %d of %d iterations", i-1, 5);

  i = 0;
  list_for_first_to_element(&head, &elements1[4], e, node) {
    CHECK_TRUE(e == &elements1[i], "first_to_element iteration %d failed", i);
    i++;
  }
  CHECK_TRUE(i == 5, "first_to_element only had %d of %d iterations", i-1, 5);

  END_TEST();
}

static void test_for_each_reverse_macros(void) {
  struct list_element *e;
  int i,j;

  START_TEST();
  list_init_head(&head);
  add_elements(elements1, false);

  i = 0;
  j = COUNT - 1;
  list_for_each_element_reverse(&head, e, node) {
    CHECK_TRUE(e == &elements1[j], "for_each iteration %d failed", i);
    i++;
    j--;
  }
  CHECK_TRUE(i == COUNT, "for_each only had %d of %d iterations", i, COUNT);

  i = 1;
  j = 4;
  list_for_element_range_reverse(&elements1[1], &elements1[4], e, node) {
    CHECK_TRUE(e == &elements1[j], "for_element_range iteration %d failed", i);
    i++;
    j--;
  }
  CHECK_TRUE(i == 5, "for_element_range only had %d of %d iterations", i-1, 4);

  i = 1;
  j = COUNT - 1;
  list_for_element_to_last_reverse(&head, &elements1[1], e, node) {
    CHECK_TRUE(e == &elements1[j], "element_to_last iteration %d failed", i);
    i++;
    j--;
  }
  CHECK_TRUE(i == COUNT, "element_to_last only had %d of %d iterations", i-1, 5);

  i = 0;
  j = 4;
  list_for_first_to_element_reverse(&head, &elements1[4], e, node) {
    CHECK_TRUE(e == &elements1[j], "first_to_element iteration %d failed", i);
    i++;
    j--;
  }
  CHECK_TRUE(i == 5, "first_to_element only had %d of %d iterations", i-1, 5);

  END_TEST();
}

static void test_for_each_save_macro(void) {
  struct list_element *e, *ptr;
  int i;

  START_TEST();
  list_init_head(&head);
  add_elements(elements1, false);

  i = 0;

  list_for_each_element_safe(&head, e, node, ptr) {
    CHECK_TRUE(e == &elements1[i], "for_each_save iteration %d failed", i);
    list_remove(&e->node);
    i++;
  }
  CHECK_TRUE(i == COUNT, "for_each_save only had %d of %d iterations", i, COUNT);
  CHECK_TRUE(list_is_empty(&head), "for_each_save list not empty after loop with remove");
  END_TEST();
}

static void test_for_each_reverse_save_macro(void) {
  struct list_element *e, *ptr;
  int i,j;

  START_TEST();
  list_init_head(&head);
  add_elements(elements1, false);

  i = 0;
  j = COUNT - 1;
  list_for_each_element_reverse_safe(&head, e, node, ptr) {
    CHECK_TRUE(e == &elements1[j], "for_each_save iteration %d failed", i);
    list_remove(&e->node);
    i++;
    j--;
  }
  CHECK_TRUE(i == COUNT, "for_each_save only had %d of %d iterations", i, COUNT);
  CHECK_TRUE(list_is_empty(&head), "for_each_save list not empty after loop with remove");
  END_TEST();
}

int main(int argc __attribute__ ((unused)), char **argv __attribute__ ((unused))) {
  BEGIN_TESTING(clear_elements);

  test_add_tail();
  test_add_head();
  test_add_before();
  test_add_after();
  test_remove();
  test_conditions();
  test_merge();
  test_element_macros();
  test_for_each_macros();
  test_for_each_reverse_macros();
  test_for_each_save_macro();
  test_for_each_reverse_save_macro();

  return FINISH_TESTING();
}
