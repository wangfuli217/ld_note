#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>
#include <string.h>

void* memcpy_t1(void* dest, void* source, size_t count)  
{  
	void* ret = dest;
	
	char* from = (char*)source;
	char* to = (char*)dest;
	
	if (to <= from || to >= (from + count))  
	{  
		//Non-Overlapping Buffers  
		//copy from lower addresses to higher addresses  
		while (count --)  
			*to++ = *from++;  
	}  
	else  
	{  
		//Overlapping Buffers  
		//copy from higher addresses to lower addresses  
		to += count - 1;  
		from += count - 1;  
		while (count--)  
			*to-- = *from--;  
	}  
	return ret;  
}  

void memcpy_t2(void* dest, const void* src, size_t n)  
{  
    assert((((uintptr_t) dest | (uintptr_t) src | n) & 0x03) == 0);  
    uint32_t* d = (uint32_t*) dest;  
    const uint32_t* s = (const uint32_t*)src;  
    n /= sizeof(uint32_t);  
	
	if (d < s) {  
        /* copy forward */  
        while (n--) {  
            *d++ = *s++;  
        }  
    } 
	else 
	{  
        /* copy backward */  
        d += n;  
        s += n;  
        while (n--) {  
            *--d = *--s;  
        }  
    }  
} 

//采用流水线的优化方式优化memcpy的执行
void duff_memcpy( char* to, char* from, int count ) {
    size_t n = (count+7)/8;
    switch( count%8 ) {
    case 0: do{ *to++ = *from++;
    case 7:     *to++ = *from++;
    case 6:     *to++ = *from++;
    case 5:     *to++ = *from++;
    case 4:     *to++ = *from++;
    case 3:     *to++ = *from++;
    case 2:     *to++ = *from++;
    case 1:     *to++ = *from++;
            }while(--n>0);
    }
}




//8路执行
void memcpy_t3(char *to , char *from , int count){
#define DEF(x) char*to##x=to+x;char*from##x=from+x 
#define EXEC(x) *to##x=*from##x;to##x+=8;from##x+=8;
    DEF(0) ;DEF(1) ;DEF(2) ;DEF(3) ;DEF(4) ;DEF(5) ;DEF(6) ;DEF(7) ;
    size_t n = (count+7)/8;
    switch( count%8 ) {
    case 0: do{ EXEC(7) ;
    case 7:     EXEC(6) ;
    case 6:     EXEC(5) ;
    case 5:     EXEC(4) ;
    case 4:     EXEC(3) ;
    case 3:     EXEC(2) ;
    case 2:     EXEC(1) ;
    case 1:     EXEC(0) ;
            }while(--n>0);
    }    
#undef DEF
#undef EXEC
}

// 2路执行
void memcpy_t4(char *to , char *from , int count){
    char *to0 = to ;
    char *from0 = from ;
    char *to1 = to + 1 ;
    char *from1 = from + 1 ;
    int n = (count + 1) / 2 ;
    
    switch (count & 1){
    case 0: do{ *to1 = *from1 ; to1 += 2 ; from1 += 2 ;
    case 1:     *to0 = *from0 ; to0 += 2 ; from0 += 2 ;
            }while(--n>0);
    }
}

void memcpy_t5(char *to , char *from , int count){
#define DEF(x) int*to##x=(int*)to+x;int*from##x=(int*)from+x 
#define EXEC(x) *to##x=*from##x;to##x+=8;from##x+=8;
    DEF(0) ;DEF(1) ;DEF(2) ;DEF(3) ;DEF(4) ;DEF(5) ;DEF(6) ;DEF(7) ;
    int rem = count % 32 ;
    int n = (count)/32;
    switch( (count / 4)%8 ) {
    case 0: do{ EXEC(7) ;
    case 7:     EXEC(6) ;
    case 6:     EXEC(5) ;
    case 5:     EXEC(4) ;
    case 4:     EXEC(3) ;
    case 3:     EXEC(2) ;
    case 2:     EXEC(1) ;
    case 1:     EXEC(0) ;
            }while(--n>0);
    }    
    to = (char*)to0 ;
    from = (char*)from0 ;
    while ( rem -- != 0 ) {
        *to ++ = *from ++ ;
    }
#undef DEF
#undef EXEC
}

int main(int argc, char **argv)
{
	char a[1000] = {'a'};
	char b[1000] = {'c'};
	
	memset(a, 'a', 1000);
	memset(b, 'b', 1000);
	
	//duff_memcpy(a, b, 1000);
	memcpy_t5(a, b, 1000);
	//memcpy(a, b, 1000);
	
	printf("a[999]: %c\n", a[999]);
	system("pause");
	
	return 0;
}
