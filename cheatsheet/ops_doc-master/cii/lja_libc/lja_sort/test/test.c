#include  <CUnit/CUnit.h>
#include  <CUnit/Basic.h>
#include  <stdlib.h>

#include  "lja_qsort.h"

int cmp_int(void *a, void *b)
{
	int *pa = (int*)a;
	int *pb = (int*)b;

	if(*pa > *pb)  return 1;
	if(*pa == *pb) return 0;
	if(*pa < *pb)  return -1;
}

void swap_int(void *a, void *b)
{
	if (a == b) return;

	int *pa = (int*)a;
	int *pb = (int*)b;

	*pa = *pa + *pb;
	*pb = *pa - *pb;
	*pa = *pa - *pb;
}

/**
 * @brief lja_qsort_arry的测试用例
 */
static void lja_qsort_arry_test(void)
{
	{
		int arry[] = {5,4,3,2,1,0};
		int expt[] = {0,1,2,3,4,5};
		int size = sizeof(arry)/sizeof(arry[0]);
		lja_qsort_arry(arry, sizeof(arry[0]), 0, size-1, cmp_int, swap_int);

		int i;
		for(i=0; i<size; i++){
			if(arry[i] != expt[i]) break;
		}
		CU_ASSERT(i == size);
	}

	{
		int arry[] = {0,1,2,3,4,5,6,7,8,9,10};
		int expt[] = {0,1,2,3,4,5,6,7,8,9,10};
		int size = sizeof(arry)/sizeof(arry[0]);
		lja_qsort_arry(arry, sizeof(arry[0]), 0, size-1, cmp_int, swap_int);

		int i;
		for(i=0; i<size; i++){
			if(arry[i] != expt[i]) break;
		}
		CU_ASSERT(i == size);
	}

	{
		int arry[] = {7,7,4,5,3,2,9,5,3,6,7,2,3,5,7};
		int expt[] = {2,2,3,3,3,4,5,5,5,6,7,7,7,7,9};
		int size = sizeof(arry)/sizeof(arry[0]);
		lja_qsort_arry(arry, sizeof(arry[0]), 0, size-1, cmp_int, swap_int);

		int i;
		for(i=0; i<size; i++){
			if(arry[i] != expt[i]) break;
		}
		CU_ASSERT(i == size);
	}

	{
		int arry[] = {7};
		int expt[] = {7};
		int size = sizeof(arry)/sizeof(arry[0]);
		lja_qsort_arry(arry, sizeof(arry[0]), 0, size-1, cmp_int, swap_int);

		int i;
		for(i=0; i<size; i++){
			if(arry[i] != expt[i]) break;
		}
		CU_ASSERT(i == size);
	}

	{
		int arry[] = {7,8};
		int expt[] = {7,8};
		int size = sizeof(arry)/sizeof(arry[0]);
		lja_qsort_arry(arry, sizeof(arry[0]), 0, size-1, cmp_int, swap_int);

		int i;
		for(i=0; i<size; i++){
			if(arry[i] != expt[i]) break;
		}
		CU_ASSERT(i == size);
	}
}

/**
 * @brief lja_qsort_h的TestInfo
 */
static CU_TestInfo lja_qsort_h[] = {
	{"lja_qsort_arry_test",lja_qsort_arry_test},
	CU_TEST_INFO_NULL,
};

/**
 * @brief suites模块的SuitInfo
 */
static CU_SuiteInfo suites[] = {
	{"lja_qsort_h",NULL,NULL,lja_qsort_h},
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
