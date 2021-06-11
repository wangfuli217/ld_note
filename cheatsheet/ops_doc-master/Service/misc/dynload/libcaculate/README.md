 在linux上man dlopen可以看到使用说明，函数声明如下：
 #include <dlfcn.h>
void *dlopen(const char *filename, int flag);
char *dlerror(void);
void *dlsym(void *handle, const char *symbol);
int dlclose(void *handle);
 
    dlopen以指定模式打开指定的动态连接库文件，并返回一个句柄给调用进程，dlerror返回出现的错误
dlsym通过句柄和连接符名称获取函数名或者变量名，dlclose来卸载打开的库。 dlopen打开模式如下：
    RTLD_LAZY 暂缓决定，等有需要时再解出符号 
    RTLD_NOW 立即决定，返回前解除所有未决定的符号。

两种打开方式RTLD_LAZY和RTLD_NOW：前者在打开共享库的时候，
会检查库里面所有的函数是否已经实现；后者只在dlsym的时候，检查使用的函数是否实现

*(void **) (&cac_func) = dlsym(handle, "add");
void * cac_func = dlsym(handle, "add");


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
    funcp = (void (*)(void)) dlsym(libHandle, argv[2]);
#pragma GCC diagnostic pop

    /* In the book, instead of the preceding line, the code uses a
       rather clumsy looking cast of the form:

           *(void **) (&funcp) = dlsym(libHandle, argv[2]);

       This was done because the ISO C standard does not require compilers
       to allow casting of pointers to functions back and forth to 'void *'.
       (See TLPI pages 863-864.) SUSv3 TC1 and SUSv4 accepted the ISO C
       requirement and proposed the clumsy cast as the workaround. However,
       the 2013 Technical Corrigendum to SUSv4 requires implementations
       to support casts of the more natural form (now) used in the code
       above. However, various current compilers (e.g., gcc with the
       '-pedantic' flag) may still complain about such casts. Therefore,
       we use a gcc pragma to disable the warning.

       Note that this pragma is available only since gcc 4.6, released in
       2010. If you are using an older compiler, the pragma will generate
       an error. In that case, simply edit this program to remove the
       lines above that begin with '#pragma".

       See also the erratum note for page 864 at
       http://www.man7.org/tlpi/errata/. */
