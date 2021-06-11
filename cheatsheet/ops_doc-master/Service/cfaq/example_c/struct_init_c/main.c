#include <stdlib.h>
#include <stdio.h>

struct test
{
    int a;
    int b;
};

struct test_2 {
	char name[10];
	int age;
};

struct test_3 {
	struct test prop;
	struct test_2 info;
};

//static void 
//__show_struct(struct test ss, const struct test& sss)
//{
//	
//}

int main()
{
    struct test t1 = {0, 0}; 
    struct test t2 = { 
        .a=2, 
        .b=3
    };  
    struct test t3 = { 
        a:12345,
        b:567890
    };  
    
	struct test t4 = {0};
	
	struct test_2 t5 = {"chenbo", 0};
	struct test_2 t6 = {.name="chenbo", .age=0};
	struct test_2 t7 = {name:"chenbo", age:0};
	struct test_2 t8 = {age:0};
	
	struct test_3 t9 = {{10, 20}, {"chenbo", 30}};
	struct test_3 t10 = {prop: {a: 10, b: 20}, info: {"chenbo", 30}};
	
    printf("t1.a = %d, t1.b = %d\n", t1.a, t1.b);
    printf("t2.a = %d, t2.b = %d\n", t2.a, t2.b);
    printf("t3.a = %d, t3.b = %d\n", t3.a, t3.b);
    
//	__show_struct({0,0}, {1,1});
	
	return 0;
}
