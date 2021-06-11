#include <stdarg.h>  // VA_LIST 
#include <stddef.h>  // size_t
#include <setjmp.h>  // jmp_buf
#include <cmocka.h>

#include <stdlib.h>  //malloc
#include <errno.h>
#include <stdio.h>
#include <string.h>  //strcpy

  
  static void int_test_success(void **state)      
 {     
   /* 申请两块内存 */	  
	  char *b=malloc(27);               //27字节大小
	  if(b==NULL)
	  {
		 printf("apply first memory failed\n"); 
	  }
	  
	  char *p=malloc(27);
	  if(p==NULL)
	  {
		 printf("apply second memory failed\n"); 
	  }
	 	 	
	/* 定义两个字符串，把两个字符串分别放入申请的两块内存中 */
	char *str1={"abcdefghijklmnopqrstuvwxyz"};
	char *str2={"abcdefghijklmnopqrstuvwxyz"};	
	
	strcpy(b,str1);
	strcpy(p,str2);
	
    assert_memory_equal(b,p,27);   //比较结果是内容相同
	   
  }

  
  int main(void) 
 {	  
      const struct CMUnitTest tests[] = {
	     	  
        cmocka_unit_test(int_test_success), 	  
	  
 };      
	  //free(b);
      //free(p);
	 return cmocka_run_group_tests(tests, NULL, NULL); 
	  
 }


