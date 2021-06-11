#ifndef PARAM_H
#define PARAM_H

#include <stdlib.h>
#include <string.h>

#include "list.h"

typedef struct {
    char *value;
    list_t params;
} Param;

#define param_entry(pos) list_entry(pos, Param, params)
#define param_value(pos) (param_entry(pos)->value)

static void param_add(list_t *head, const char *token) {
    Param *new_para = malloc(sizeof(Param));
    size_t len = strlen(token) + 1;
    new_para->value = malloc(sizeof(char) * len);
    bzero(new_para->value, sizeof(char) * len);
    strcpy(new_para->value, token);
    list_insert(&new_para->params, head);
}

static void param_free(list_t *head) {
    list_t *pos, *p;
    list_for_each_safe(pos, p, head) {
        free(param_value(pos));
        free(param_entry(pos));
    }
}

#endif
