#include <stdio.h>

int main(void){
    
    printf("hello \
    world \
    \n");
    
    printf("hello "
    "world"
    " \n");
    
    return 0;
}

#if 0
// 可见行末加'\'的做法，把下一行的缩进也包含到字符串里了
int main(void){
    
    printf("hello \
world \
\n");
    
    printf("hello "
    "world"
    " \n");
    
    return 0;
}
#endif

#if 0
// 自动合并是在编译时自动合并，除了最后一个字符串外，其余每个字符串末尾的'\0'字符会被自动删除。
// 如果不小心漏掉了一个逗号，编译器将不会发出错误信息，而是悄无声息的把两个字符串合并在一起。
int main(void){
    char *word[] = {
        "pen",
        "class",
        "note" //这里漏掉逗号
        "book",
    };      
    printf("%s",word[2]);
    return 0;
}
#endif

#if 0
// 如果在程序中访问或修改word[3]，就是数组越界，访问或修改了其他的内容。
int main(void){
    char *word[] = {
        "pen",
        "class",
        "note" //这里漏掉逗号
        "book",
    };      
    printf("%s",word[3]);
    return 0;
}
#endif