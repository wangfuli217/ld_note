extern int atom_setup(void);
extern int atom_teardown(void);
extern void test_Atom_string(void);
extern void test_Atom_length(void);
extern void test_Atom_int(void);
extern void test_Atom_map(void);
extern void test_Atom_reset(void);
extern void test_Atom_free(void);
extern void test_Atom_aload(void);
extern void test_Atom_vload(void);

CU_TestInfo test_atom_info[] = {
  { "Atom_string", test_Atom_string },
  { "Atom_length", test_Atom_length },
  { "Atom_int", test_Atom_int },
  { "Atom_reset", test_Atom_reset },
  { "Atom_free", test_Atom_free },
  { "Atom_aload", test_Atom_aload },
  { "Atom_vload", test_Atom_vload },
  CU_TEST_INFO_NULL,
};