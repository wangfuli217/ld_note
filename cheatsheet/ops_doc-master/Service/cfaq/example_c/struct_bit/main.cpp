#include <stdio.h>
#include <stdlib.h>

struct bit {
	char i1:1;
	char i2:1;
	char i3:1;
	char i4:1;
	char i5:1;
	char i6:1;
	char i7:1;
	char i8:1;
};


int main()
{
    char x=1;
    struct bit *pb=(struct bit*)&x;  
    pb->i5=1;
	
	printf("%d\n",x);
    system("pause");
    
	return 0;
}