#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>
#include <errno.h>

static int setup(void **state) 
 {  
    int *answer = malloc(sizeof(int));
	if (answer == NULL) 
    {   return -1; }
    *answer = 42;
    *state = answer;    
    return 0;
  }
 
 static int teardown(void **state)  
 {    free(*state);      //释放state，相当于释放answer指针

      return 0;
  }


  static void int_test_success(void **state)
 {     int *answer = *state;
       
	   //assert_true(*answer==42);
	   //assert_false(*answer==45); 
	   //assert_int_equal(*answer,42);
	   //assert_int_not_equal(*answer,43);
	   
	   //assert_null(answer);
	   //assert_non_null(answer);   
	   //assert_ptr_equal(answer, *state);
	   //assert_ptr_not_equal(answer, *state);
	   
	    //int a=-2;
	    //assert_return_code(a, NULL);
		//assert_return_code(a, errno);
		//assert_return_code(a, 38); 

         char *str1="zhanggangbi";
         char *str2="renweiwei";
		// assert_string_equal(str1,str2); 
        // assert_string_equal(str1,"renweiwei");  		 
	    // assert_string_equal("zhanggangbi",str2); 
		
		 int a=20;                       
		//assert_in_range(a,100.79,500.8); // 比较的值都是正整数，范围是0-max，小数会转化成整数比较。
		//assert_not_in_range(a,10,800);
		
		const long unsigned b[]={1,2,3,4,5,6};   //数组的类型由系统的配置决定，我的系统必须是const long unsigned
		//assert_in_set(5,b,6);
		assert_not_in_set(8,b,6);
				
  }
  
  int main(void) 
 {	  
      const struct CMUnitTest tests[] = {
	     	  
	  cmocka_unit_test_setup_teardown(int_test_success, NULL, NULL),
	  //cmocka_unit_test_setup_teardown(int_test_success, setup, teardown),
 };      
	 
	 return cmocka_run_group_tests(tests, NULL, NULL); 
	  
 }


