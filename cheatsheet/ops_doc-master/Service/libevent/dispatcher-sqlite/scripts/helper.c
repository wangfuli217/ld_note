#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include "../debug.h"

static uint8_t hexchar2binchar(char c) {
  if (c >= '0' && c <= '9') {
    return c - '0';
  } else if (c >= 'a' && c <= 'z') {
    return c - 'a' + 10;
  } else if (c >= 'A' && c <= 'Z') {
    return c - 'A' + 10;
  }
  return 0xff;
}

int urlunescape(char **new, const char *src, int len) {
  int pos = 0, src_pos = 0;
  char c, *p = NULL;

  p = (char*)malloc(len + 1);
  if (NULL  == p) {
    return -1;
  }

  while (src_pos < len) {
    switch (src[src_pos]) {
    case '%':
      c = hexchar2binchar(src[src_pos + 1]);
      c <<= 4;
      c |= hexchar2binchar(src[src_pos + 2]);
      p[pos] = c;
      src_pos += 3;
      break;

    case '+':
      p[pos] = '\x20';
      src_pos++;

    default:
      p[pos] = src[src_pos];
      src_pos++;
      break;
    }
    pos++;
  }

   p[pos] = '\0';
  *new = p;

  return 0;
}

void cgiGet(char *qs, const char *name, char *value) {
  char *s = NULL, *e = NULL;
  char *a = NULL, *v = NULL;
  char *p = qs + strlen(qs);
  int aL,vL;

  s = qs;
  while ((e = strchr(s, '='))) {
    aL = e - s;
    urlunescape(&a, s, aL);
    
    s = e + 1;
    while (e < p) {
      if (*e == '&') {
        break;
      }
      e++;
    }
    vL = e - s;
    urlunescape(&v, s, vL);
    s = e + 1;
    if (strcmp(name, a) == 0) {
      strcpy(value, v);
      free(v);
      break;
    } else {
      free(a);
      free(v);
    }
  }
}

long getLong(const char* arg, int flags, const char* name) {
  long res;
  int base;
  char *endptr;

  if (arg == NULL *arg == '\0') {
    ph_log_err("%s,null or empty string:%s", name, arg);
  }
  base = (flags & GN_ANY_BASE) ? 0 : (flags & GN_ANY_BASE_8) ? 8:
         (flags & GN_ANY_BASE_16) ? 16: 10;
  errno = 0;
  res = strtol(arg, &endptr, base);
  if (errno != 0) {
    ph_log_err("%s,strtol() failed:%s", name, arg);
  }
  if ((flags & GN_NONNEG) && res < 0) {
    ph_log_err("%s,negative value not allowed", name, arg);
  }
  if ((flags & GN_GT_0) && res < 0) {
    ph_log_err("%s,value must be > 0", name, arg);
  }
  return res;
}

int getInt(const char* arg, int flags, const char* name) {
  return (int)getLong(arg, flags, name);
}
