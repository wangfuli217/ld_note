#include <stdio.h>
#include <string.h>

char * string_copy(char * source_str){
// buffer是一个自动分配内存的数组，是该函数的局部变量。当控制流离开声明局部变量的范围时，自动变量便自动失效。
    char buffer[120];
    strncpy(buffer, source_str, 119);
    return buffer;
}

int main(void){
    char *destination_str;
    char source_str[] = "hello world";
    destination_str = string_copy(source_str);
    printf("%s\n",destination_str);
    return 0;
}

// warning: function returns address of local variable [-Wreturn-local-addr]
#if 0
1.函数可以返回一个常量，或指向常量的指针。
int func(){
  return 0;
}
这是最简单的解决方案，但是如果是其他需要返回变化的内容时，这就无能为力了。
#endif


#if 0
2. 使用全局声明的变量。
char my_global_array[120];
char *fun(){
  ...
  my_global_array[i] = ...;
  ...
  return my_global_array;
}
这适用于自己创建字符串的情况，也很简单易用。
全局声明的缺点在于任何人都有可能在任何时候修改这个全局数组，而且该函数的下一次调用也会覆盖该数组的内容。
#endif


#if 0
3. 使用静态数组。
char * func(){
  static char buffer[120];
  ...
  return buffer;
}
这就可以防止任何人修改这个数组。
该函数的下一次调用将覆盖这个数组的内容，所以调用者必须在此之前使用或备份数组的内容。
#endif

#if 0
4. 显式分配一些内存，保存返回值。
char * func(){
  char *s = (char *)malloc(120 * sizeof(char));
  ...
  return s;
}
缺点在于程序员必须承担内存管理的责任。
#endif

#if 0
// 5.最好的解决方案就是要求调用者分配内存来保存函数的返回值。
// 为了提高安全性，调用者应该同时指定缓冲区的大小。

void string_copy(char * destination_str,char * source_str,int size){
    strncpy(destination_str, source_str, size);
}

int main(void){
    char source_str[] = "hello world";
    int str_size = 120;
    char *destination_str = (char *)malloc(str_size * sizeof(char));
    string_copy(destination_str,source_str,str_size);
    printf("%s\n",destination_str);
    free(destination_str);
    return 0;
}
// 如果可以在同一代码块中同时进行”malloc”和”free”操作，内存管理是最为轻松的。
#endif