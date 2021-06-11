#include <CUnit/Basic.h>
#include "atom.h"

static const char msg[] = "This is an atom";
static const char *atom;

int atom_setup(void)
{
   return 0;
}

int atom_teardown(void)
{
   Atom_reset();
   return 0;
}

void count(const char *str, int len, void *aux)
{
   ++(*(int *)(aux));
}

int Atom_count(void)
{
   int total = 0;
   Atom_map(count, &total);
   return total;
}

void test_Atom_string(void)
{
   const char *str;
   atom = Atom_string(msg);
   str = Atom_string(msg);
   CU_ASSERT_EQUAL(str, atom);
   CU_ASSERT_STRING_EQUAL(str, msg);
}

void test_Atom_int(void)
{
   const char *str;
   int i = -123456;
   str = Atom_int(i);
   CU_ASSERT_STRING_EQUAL(str, "-123456");
}

void test_Atom_length(void)
{
   atom = Atom_string(msg);
   CU_ASSERT_EQUAL(Atom_length(atom), strlen(msg));
   
   atom = Atom_new(msg, strlen(msg) + 1);
   CU_ASSERT_NOT_EQUAL(Atom_length(atom), strlen(msg));
}

void test_Atom_map(void)
{
   Atom_reset();
   atom = Atom_string(msg);
   CU_ASSERT_EQUAL(Atom_count(), 1);
   
   Atom_reset();
   int i;
   for (i = 0; i < 10; i++)
      Atom_int(i);
   CU_ASSERT_EQUAL(Atom_count(), 10);
}

void test_Atom_reset(void)
{
   Atom_reset();
   CU_ASSERT_EQUAL(Atom_count(), 0);
}

void test_Atom_free(void)
{
   Atom_reset();
   atom = Atom_string(msg);
   Atom_free(atom);
   CU_ASSERT_EQUAL(Atom_count(), 0);
   
   int i;
   for (i = 0; i < 10000; i++)
      Atom_int(i);
   for (i = 0; i < 5000; i += 2) {
      atom = Atom_int(i);
      Atom_free(atom);
   }
   CU_ASSERT_EQUAL(Atom_count(), 7500);
}

void test_Atom_aload(void)
{
   const char *astr[] = {"1", "2", "3", "4", NULL};
   Atom_reset();
   Atom_aload(astr);
   CU_ASSERT_EQUAL(Atom_count(), 4);
}

void test_Atom_vload(void)
{
   Atom_reset();
   Atom_vload("1", "2", "3", "4", NULL);
   CU_ASSERT_EQUAL(Atom_count(), 4);
   
   Atom_reset();
   Atom_vload(NULL);
   CU_ASSERT_EQUAL(Atom_count(), 0);
}