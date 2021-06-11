/*
 * =====================================================================================
 *
 *       Filename:  arrayptr.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 03:53:34 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */
// &x 返回数组指针，*p 获取和x相同的指针，也就是指向第一个元素的指针，然后可以用下标或指针运算存储元素。
void test1(void){
    int x[] = { 1, 2, 3 };
    int(*p)[] = &x;
    for (int i = 0; i < 3; i++)
    {
        printf("x[%d] = %d\n", i, (*p)[i]);
        printf("x[%d] = %d\n", i, *(*p + i));
    }
}
//指针数组 x 是三个指向?标对象(数组)的指针，*(x + 1)  获取目标对象，也就是 x[1]
void test2(void){
    int* x[3] = {};
    x[0] = (int[]){ 1 };
    x[1] = (int[]){ 2, 22 };
    x[2] = (int[]){ 3, 33, 33 };
    int* x1 = *(x + 1);
    for (int i = 0; i < 2; i++)
    {
        printf("%d\n", x1[i]);
        printf("%d\n", *(*(x + 1) + i));
    }
}

int main(int argc, char *argv[]){
    test1();
    test2();
    return 0;
}

