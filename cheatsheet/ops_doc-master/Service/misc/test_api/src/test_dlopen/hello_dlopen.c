#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
typedef void (*callfun_t)();
int main(int argc, char **argv)
{
    void *handle;
    void (*callfun)();
    char *error;
    handle = dlopen("./hello.so",RTLD_LAZY);  //如果hello.so不是在LD_LIBRARY_PATH所申明
                                                      //的路径中必须使用全路径名
    if(!handle)
    {
        printf("%s \n",dlerror());
        exit(1);
    }
    dlerror();
    callfun=(callfun_t)dlsym(handle,"hello");
    if((error=dlerror())!=NULL)
    {
        printf("%s \n",error);
        exit(1);
    }
    callfun();
    dlclose(handle);
    return 0;
}
