#ifndef TOKENIZER_H
#define TOKENIZER_H

#include "utils.h"

BEGIN_DECLS

typedef struct  {
    char*       s;
    const char* delimiters;
    char*       current;
    char*       next;
    unsigned         is_ignore_empties;
} tokenizer_t;

enum { TOKENIZER_EMPTIES_OK, TOKENIZER_NO_EMPTIES };

tokenizer_t tokenizer       (char* s, const char* delimiters, unsigned empties );
char* tokenize        (tokenizer_t* tokenizer );

END_DECLS

#endif 