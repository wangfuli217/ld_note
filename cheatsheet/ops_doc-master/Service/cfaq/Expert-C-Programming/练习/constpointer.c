void foo(const char **p) { }
int main(int argc,char **argv){
    foo(argv);
    return 0;
}

#if 0
#include <stdio.h>

void foo(const char **p){
    printf("%s\n", *p);
}

int main(void){
    char *s[] = {
        "abc","def"
    };
    foo(s);
    return 0;
}
// 这段代码是会发出编译警告的: warning: passing argument 1 of foo from incompatible pointer type
#endif