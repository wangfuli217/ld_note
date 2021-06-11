#include "atom.h"
#include "test.h"

unsigned test_atom() {

    const char* s1 = Atom_int(10);
    const char* s2 = Atom_int(10);
    const char* s3 = Atom_int(11);

    const char* s4 = Atom_string("Luca");
    const char* s5 = Atom_string("Luca");
    const char* s6 = Atom_string("luca");

    
    test_assert(s1 == s2);
    test_assert(s1 != s3);

    test_assert(s4 == s5);
    test_assert(s4 != s6);

    Atom_freeAll();

    return TEST_SUCCESS;
}