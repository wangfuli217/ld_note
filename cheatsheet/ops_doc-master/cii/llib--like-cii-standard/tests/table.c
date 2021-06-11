#include "table.h"
#include "test.h"
#include "str.h"
#include "atom.h"
#include "mem.h"

struct Test { int i; char* s;};

char* TestToStr(struct Test* t) {
   return Str_asprintf("%i%s", t->i, t->s); 
}

unsigned test_table() {

    Table_T tbl = Table_new(10, NULL, NULL);
    struct Test t1 = { 10, "Luca"};
    char* s1 = TestToStr(&t1);
    const char* a1 = Atom_string(s1);
    char * result;

    Table_put(tbl, a1, "Luca");
    result = (char*) Table_get(tbl, a1);
    test_assert(strcmp(result, "Luca") == 0);

    Table_free(&tbl);
    FREE(s1);
    Atom_freeAll();
    return TEST_SUCCESS;
}