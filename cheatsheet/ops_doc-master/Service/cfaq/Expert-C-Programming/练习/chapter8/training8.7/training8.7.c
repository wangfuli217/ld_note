#include "def.c"//training8.7.c在atom中无法编译成功，会报错。

int olddef(float d,char i);

main()
{
    float d = 10.0;
    char j = 3;
    olddef(d,j);
    newdef(d,j);
}
