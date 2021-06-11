#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>
#include <errno.h>

  
  static void int_test_success(void **state)      //test_case只有一个参数传递。
 { 

    //一次malloc的内存虚拟地址是连续的，物理地址不连续，连续多次malloc的内存之间不一定连续;
	
	//即连续申请了两次内存，这两块内存大小可以相等，但不“相同”，因为虚拟地址、物理地址都不同。

 
	int *b=malloc(sizeof(int));
	int *p=malloc(sizeof(int));
	*b=42;    //内容是42
	//*p=42;  //内容是42
	const unsigned char *m =(unsigned char *)b;
	const unsigned char *n =(unsigned char *)p;
	
	assert_memory_not_equal(m,n,4);	  
    //assert_memory_equal(m,n,4);		 //内容相等

    free(b);
    free(p);	
  }

  
  int main(void) 
 {	  
      const struct CMUnitTest tests[] = {
	     	  
        cmocka_unit_test(int_test_success), 	  
	  
 };      
	 
	 return cmocka_run_group_tests(tests, NULL, NULL); 
	  
 }


