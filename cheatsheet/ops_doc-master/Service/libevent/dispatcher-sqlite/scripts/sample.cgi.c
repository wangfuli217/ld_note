#include <stdio.h>
#include <stdlib.h>
#include "../debug.h"
#include "../dao.h"
#include "cgic.h"

int cgiMain() {
  char username[] = "hello,world";
  friend_list **list = NULL;
  cgiHeaderContentType("text/html;charset=UTF-8");
  fprintf(stdout, "%s", "<h1>abcde</h1>");
  fprintf(stdout, "%s\n", cgiQueryString);
  dao_init();
  int i, sz = 0;
  dao_get_friends(username, &list, &sz);
  if (sz > 0) {
    fprintf(stdout, "Total: %d<br/>\n", sz);
    for (i = 0; i < sz; i++) {
      fprintf(stdout, "&nbsp;&nbsp;name=%s, ip=%s\n",
        list[i]->username_a, list[i]->ipaddr
      );
    }
  }
  dao_free_friends_result(list, sz);
  list = NULL;
  dao_deinit();
  return 0;
}
