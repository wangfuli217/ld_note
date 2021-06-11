/***
 * 测试longjmp恢复寄存器环境后, 对
 * ---- 自动变量、全局变量、寄存器变量、静态变量、易失变量
 * 的影响
 * -------------------------------------------------------
 * 最终只有寄存器变量恢复了, 因为底层汇编直接恢复寄存器.
 * 这也是为什么stackless coroutine无法实现协程间的深层嵌套调用(比如递归)
 */
#include <setjmp.h>

static void f1(int, int, int, int);
static void f2(void);

static jmp_buf jmp;
int globval;

int main(void) {
    int autoval;
    register int regival;
    volatile int volaval;
    static int statval;

    globval = 1; autoval = 2; regival = 3; volaval = 4; statval = 5;

    if (setjmp(jmp) != 0) {
        printf("\nafter longjmp:\n");
        printf("globval = %d; ", globval);
        printf("autoval = %d; ", autoval);
        printf("regival = %d; ", regival);
        printf("volaval = %d; ", volaval);
        printf("statval = %d; ", statval);
        return 0;
    }
    // change variable after setjmp, but before longjmp
    globval = 95; autoval = 96; regival = 97; volaval = 98; statval = 99;

    f1(autoval, regival, volaval, statval);

    return 0;
}

static void f1(int autoval, int regival, int volaval, int statval) {
    printf("in f1():\n");
    printf("globval = %d; ", globval);
    printf("autoval = %d; ", autoval);
    printf("regival = %d; ", regival);
    printf("volaval = %d; ", volaval);
    printf("statval = %d; ", statval);
    f2();
}

static void f2(void) {
    longjmp(jmp, 1);
}