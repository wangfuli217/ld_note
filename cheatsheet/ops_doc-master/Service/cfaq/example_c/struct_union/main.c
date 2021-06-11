#include <stdio.h>

typedef struct a_s a_t;
struct a_s {
    int id;
    union {
        int key;
        long long sid;
    };
    struct {
        int age;
    };
};


int main(int argc, char **argv)
{
	a_t t;
    
    t.id = 1;
    t.key = 2;
    t.age = 3;
    (void)t;
    
    printf("hello world\n");
	return 0;
}
