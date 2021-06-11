#include <stdlib.h>
#include <stdio.h>
#include <string>

using std::string;

struct test
{
    int a;
    int b;
};

struct test_2 {
	char name[10];
	int age;
};

typedef struct test_3_s test_3_t;
struct test_3_s {
	test 	x;
	string 	name;
	int 	age;
};

static void
__show_struct(struct test ss)
{
	printf("a: %d b: %d\n", ss.a, ss.b);
}

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
    
	string name = "chenbo";
	struct test_2 t5 = { "chenbo", 0};
	struct test_2 t8 = {name.c_str(), 0};
	
	
	test_3_t t6 = {x:{1, 2}, name: "", age: 0};
	test_3_t t7 = {{1, 2}, "", (int)time(NULL)}; // 字段不能遗漏，否则报错。sorry, unimplemented: non-trivial designated initializers not supported

	
	printf("t1.a = %d, t1.b = %d\n", t1.a, t1.b);
    printf("t2.a = %d, t2.b = %d\n", t2.a, t2.b);
    printf("t3.a = %d, t3.b = %d\n", t3.a, t3.b);
	
	__show_struct({0,0});
    return 0;
}
