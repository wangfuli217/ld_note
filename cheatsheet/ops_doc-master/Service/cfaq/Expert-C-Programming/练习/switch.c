#include <stdio.h>

#if 0
// case后面必须为常量值或常量表达式
int main(void){
    int i=0,j=0;
    const int a = 2;
    switch(i){
        case 1: j=1;
        case a: j=2;
        case 3: j=3;
        default: j=4;
    }
    return 0;
}
#endif

#if 0
// 可以在switch的左花括号之后声明一些变量，但变量不会被初始化。
int main(void){
    int i=0,j=0;
    switch(i){
        int a = 2;
        case 1: j=1;
        case 2: j=2;
        case 3: j=3;
        default: j=4;
        printf("%d\n",a);
    }
    printf("%d\n",j);
    return 0;
}
#endif

#if 0
// switch内部任何语句都可以加上标签。
int main(void){
    int i = 2;
    switch(i){
        case 5+3: do_again:
        case 2: printf("loop\n");goto do_again;
        default: i++;
        case 3: ;
    }
    return 0;
}
#endif

#if 0
// 对case可能出现的值太过于放纵了。
int main(void){
    int i = 2;
    switch(i){
        case 5+3: ;
        case 2: printf("loop\n");
        defau1t: i++;
        case 3: ;
    }
    printf("%d\n",i);
    return 0;
}
#endif

#if 0
// 最大的缺点——fall through
int main(void){
    switch(2){
        case 1: printf("case 1\n");
        case 2: printf("case 2\n");
        case 3: printf("case 3\n");
        case 4: printf("case 4\n");
        default: printf("default\n");
    }
    return 0;
}
#endif

#if 0
int main(void){
    int i = 2,a = 0,b = 1;
    switch(i){
        case 1: 
            printf("case 1\n");
            break;
        case 2: 
            if(a == 0){
                printf("step 1\n");
                if(b ==1)
                    break;
                printf("step 2\n");
            }//代码意图是跳到这里
            printf("step 3\n");
            b++;
            break;
        default: printf("default\n");
    }//事实是跳到这里
    printf("b = %d\n",b);
    return 0;
}
#endif