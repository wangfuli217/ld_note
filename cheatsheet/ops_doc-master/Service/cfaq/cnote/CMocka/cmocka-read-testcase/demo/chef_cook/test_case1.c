/*
  这里一个完整的例子,包含了两个case,case运行的结果是不通过。
  
  这并不是case本身的问题，而是刻意制造出不满足的条件。
*/
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int chef_cook(const char *order, char **dish_out)
{
	
    if (order == NULL || dish_out == NULL) 
		 
	   return EINVAL;

    return -ENOSYS;
}

const char *chef_strerror(int error)
{
    switch (error) {
    case 0:
        return "Success";
    case -1:
        return "Unknown dish";
    case -2:
        return "Not enough ingredients for the dish";
    }

    return "Unknown error!";
}

int __wrap_chef_cook(const char *order, char **dish_out)
{
    bool has_ingredients;
    bool knows_dish;
    char *dish;

    check_expected_ptr(order);

    knows_dish = mock_type(bool);
    if (knows_dish == false) 
	{
        return -1;
    }

    has_ingredients = mock_type(bool);	
    if (has_ingredients == false)
	{
        return -2;
    }

    dish = mock_ptr_type(char *);
	printf("%s\n",dish);
    
	*dish_out = strdup(dish);         //strdup()字符串拷贝库函数，一般和 free()函数成对出现
    if (*dish_out == NULL) 
		
	   return ENOMEM;

    return mock_type(int);
}

static int waiter_process(const char *order, char **dish)
{
    int rv;

    rv = chef_cook(order, dish);
    if (rv != 0) 
	{
        printf("chef_cook return value is %d\n",rv);     //-38
		fprintf(stderr, "Chef couldn't cook %s: %s\n",
                order, chef_strerror(rv));
        return -1;
    }

    if (strcmp(order, *dish) != 0)                     /* 检查我们是否收到了想要的菜 */
	{
        free(*dish);
        *dish = NULL;
        return -2;
    }

    return 0;
}

static void test_order_hotdog(void **state)
{
    int rv;
    char *dish;                                        //定义一个指针，没有赋初值，随意指向一个地址，导致dish不为空。
	if (dish!=NULL)
	{
	   printf("dish is not NULL\n");
       printf("%s\n",dish);	   
	}
	
    (void) state;   /* unused */
	
    expect_string(__wrap_chef_cook, order, "hotdog");  //期待厨师可以接收到"hotdog"命令
	
    will_return(__wrap_chef_cook, true);               //knows_dish的值为true
    will_return(__wrap_chef_cook, true);               //has_ingredients的值是true		
    will_return(__wrap_chef_cook, cast_ptr_to_largest_integral_type("hotdog"));  //指定dish的返回值是字符串“hotdog”
    will_return(__wrap_chef_cook, 0);                  // return 0；


    rv = waiter_process("hotdog", &dish);             //这里dish没有值
		  
	printf("return value is %d\n",rv);                //返回值-1
    assert_int_equal(rv, 0);                          // 断言waiter_process()执行成功，返回0，即做好了hotdog.
	
    /* And actually receive one */
    assert_string_equal(dish, "hotdog");
	
    if (dish != NULL)
	{
        free(dish);
    }
}

static void test_bad_dish(void **state)
{
    int rv;
    char *dish;

    (void) state; /* unused */

    expect_string(__wrap_chef_cook, order, "hotdog");
  
    will_return(__wrap_chef_cook, true);
    will_return(__wrap_chef_cook, true);
    will_return(__wrap_chef_cook, cast_ptr_to_largest_integral_type("burger"));
    will_return(__wrap_chef_cook, 0);

    rv = waiter_process("hotdog", &dish);

    /* According to the documentation the waiter should return -2 now */
    assert_int_equal(rv, -2);
    /* And do not give the bad dish to the customer */
    assert_null(dish);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_order_hotdog),
        cmocka_unit_test(test_bad_dish),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
