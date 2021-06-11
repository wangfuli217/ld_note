#include <stdio.h>
#pragma GCC poison puts
 

static void
__scope_poison()
{
#pragma GCC bless begin puts
    puts('a');
#pragma GCC bless end puts
}
 
 
int main(){
	puts("hello");
	__scope_poison();
}