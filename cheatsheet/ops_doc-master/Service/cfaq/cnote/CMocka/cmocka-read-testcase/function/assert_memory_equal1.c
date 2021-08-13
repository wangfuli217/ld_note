#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>  //malloc
#include <errno.h>
#include <stdio.h>

  
  static void int_test_success(void **state)      //test_case只有一个参数传递。
 { 
    
	// 连续申请了两次内存，这两块内存大小可以相等，但不“相同”，因为虚拟地址、物理地址都不同	
	  char *b=malloc(sizeof(int));
	  if(b==NULL)
	  {
		 printf("first no memory\n"); 
	  }
	  
	  char *p=malloc(sizeof(int));
	  if(p==NULL)
	  {
		 printf("second no memory\n"); 
	  }
	  
	  printf("%d\n",sizeof(b));        //64位环境下，指针大小为8
      printf("%d\n",sizeof(*b));       //大小为1；
	 
	 	
	//定义两个字符串，把这两个字符串分别放入申请的内存中。
	char *str1={"abc"};
	char *str2={"abc"};	
	
	*b= *str1;
	printf("%c\n",*b);  //这里只有一个‘a’
	
	*p= *str2;
	printf("%c\n",*p);  //这里只有一个‘a’
	
    assert_memory_equal(b,p,0);   //比较结果是内容相同
	
    free(b);
    free(p);	
  }

 
  int main(void) 
 {	  
      const struct CMUnitTest tests[] = {
	     	  
	  //cmocka_unit_test_setup_teardown(int_test_success, setup, teardown),
      //cmocka_unit_test_setup_teardown(int_test_success, setup1, teardown1), 
        cmocka_unit_test(int_test_success), 	  
	  
 };      
	 
	 return cmocka_run_group_tests(tests, NULL, NULL); 
	  
 }


