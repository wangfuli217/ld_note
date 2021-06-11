#include  <CUnit/CUnit.h>
#include  <CUnit/Basic.h>
#include  <stdlib.h>
#include  "lja_bit.h"

#define LJA_BIT_SIZE 100
lja_Bit *g_lja_bit;

int lja_bit_test_init()
{
	g_lja_bit = lja_bit_new(LJA_BIT_SIZE);
	return 0;
}

int lja_bit_test_clean()
{
	lja_bit_free(g_lja_bit);
	return 0;
}

/**
 * @brief lja_bit_set_test的测试用例
 */
static void lja_bit_set_test(void)
{
	{
		lja_bit_set(g_lja_bit, 1);
		CU_ASSERT(1 == lja_bit_get(g_lja_bit,1));

		lja_bit_reset(g_lja_bit, 1);
		CU_ASSERT(0 == lja_bit_get(g_lja_bit,1));
	}

	{
		lja_bit_set(g_lja_bit, LJA_BIT_SIZE/2);
		CU_ASSERT(1 == lja_bit_get(g_lja_bit,LJA_BIT_SIZE/2));

		lja_bit_reset(g_lja_bit, LJA_BIT_SIZE/2);
		CU_ASSERT(0 == lja_bit_get(g_lja_bit,LJA_BIT_SIZE/2));
	}

	{
		lja_bit_set(g_lja_bit, LJA_BIT_SIZE);
		CU_ASSERT(1 == lja_bit_get(g_lja_bit,LJA_BIT_SIZE));

		lja_bit_reset(g_lja_bit, LJA_BIT_SIZE);
		CU_ASSERT(0 == lja_bit_get(g_lja_bit,LJA_BIT_SIZE));
	}

	{
		lja_bit_set(g_lja_bit, 1);
		CU_ASSERT(1 == lja_bit_get(g_lja_bit,1));

		lja_bit_set(g_lja_bit, LJA_BIT_SIZE/2);
		CU_ASSERT(1 == lja_bit_get(g_lja_bit,LJA_BIT_SIZE/2));

		lja_bit_set(g_lja_bit, LJA_BIT_SIZE);
		CU_ASSERT(1 == lja_bit_get(g_lja_bit,LJA_BIT_SIZE));

		lja_bit_clean(g_lja_bit);

		CU_ASSERT(0 == lja_bit_get(g_lja_bit,1));
		CU_ASSERT(0 == lja_bit_get(g_lja_bit,LJA_BIT_SIZE/2));
		CU_ASSERT(0 == lja_bit_get(g_lja_bit,LJA_BIT_SIZE));

	}
}

/**
 * @brief lja_bit_set_test的TestInfo
 */
static CU_TestInfo lja_bit_h[] = {
	{"lja_bit_set_test",lja_bit_set_test},
	CU_TEST_INFO_NULL,
};

/**
 * @brief suites模块的SuitInfo
 */
static CU_SuiteInfo suites[] = {
	{"lja_bit_h",lja_bit_test_init,lja_bit_test_clean,lja_bit_h},
	CU_SUITE_INFO_NULL,
};

int main(int argc, char *argv[])
{
	if(CU_initialize_registry() != CUE_SUCCESS) 
	{
		fprintf(stderr,"Failed CU_initialize %s:%d\n",__FILE__,__LINE__);
		exit(-1);
	}
	if(CU_is_test_running())
	{
		fprintf(stderr,"Failed CU_is_test_running %s:%d\n",__FILE__,__LINE__);
		exit(-1);
	}
	if(CU_register_suites(suites) != CUE_SUCCESS)
	{
		fprintf(stderr,"Failed CU_register_suites suites %s:%d\n",__FILE__,__LINE__);
		exit(-1);
	}

	CU_basic_set_mode(CU_BRM_NORMAL);
	CU_set_error_action(CUEA_IGNORE);
	CU_basic_run_tests();
	CU_cleanup_registry();

	return 0;
}
