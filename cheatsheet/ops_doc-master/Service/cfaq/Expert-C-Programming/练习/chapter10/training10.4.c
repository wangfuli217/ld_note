#include <stdio.h>

my_function_1(int fruit[2][3][5]){printf("%d\n",fruit[0][0][0]);}
my_function_2(int fruit[][3][5]){printf("%d\n",fruit[0][0][0]);}
my_function_3(int (*fruit)[3][5]){printf("%d\n",fruit[0][0][0]);}

int main()
{
    int apricot[2][3][5]={{{1,2,3,4,5}}};
    int (*p)[3][5] = apricot;
    int (*q)[2][3][5] = &apricot;

    my_function_1(apricot);
    my_function_2(apricot);
    my_function_3(apricot);

    my_function_1(p);
    my_function_2(p);
    my_function_3(p);

    my_function_1(*q);
    my_function_2(*q);
    my_function_3(*q);
}
