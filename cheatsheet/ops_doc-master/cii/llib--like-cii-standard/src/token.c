#include <stdlib.h>
#include <string.h>

#include "token.h"
#include "str.h"
#include "assert.h"

tokenizer_t tokenizer(char* s, const char* delimiters, unsigned empties) {
    tokenizer_t result ;
    assert(s);
    assert(delimiters);
    assert(empties == TOKENIZER_EMPTIES_OK || empties == TOKENIZER_NO_EMPTIES);
    assert(*delimiters != '\0');

    result.s                 = s;
    result.delimiters        = delimiters;
    result.current           = NULL;
    result.next              = result.s;
    result.is_ignore_empties = (empties != TOKENIZER_EMPTIES_OK);

    return result;
}

char* tokenize(tokenizer_t* tkn) {
    assert(tkn);
    assert(tkn->s);

    if (!tkn->next)   return NULL;

    tkn->current  = tkn->next;
    tkn->next     = strpbrk(tkn->current, tkn->delimiters );

    if (tkn->next) {
        *tkn->next = '\0';
        tkn->next += 1;

        if (tkn->is_ignore_empties) {
            tkn->next += strspn(tkn->next, tkn->delimiters);
            if (!(*tkn->current))
                return tokenize( tkn );
        }
    }
    else if (tkn->is_ignore_empties && !(*tkn->current))
        return NULL;

    return tkn->current;
}



