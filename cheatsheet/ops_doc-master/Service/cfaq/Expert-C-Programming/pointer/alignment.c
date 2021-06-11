#include <stdio.h>
 
typedef struct {
    int     int1;
    double  double1;
    char    char1;
    double  double2;
} Hoge;

int main(void)
{
    Hoge        hoge;
 
    printf("hoge size..%d\n", sizeof(Hoge));
 
    printf("hoge   ..%p\n", &hoge);
    printf("int1   ..%p\n", &hoge.int1);
    printf("double1..%p\n", &hoge.double1);
    printf("char1  ..%p\n", &hoge.char1);
    printf("double2..%p\n", &hoge.double2);
 
    return 0;
}
