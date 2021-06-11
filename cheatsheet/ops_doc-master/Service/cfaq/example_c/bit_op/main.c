#include <stdio.h>
#include <stdlib.h>

typedef union str_u str_t;
union str_u {
    unsigned int    ui;
    unsigned short  usi;
    unsigned char   uc;
    char            c;
};


int main(int argc, char **argv)
{
	char    a[] = "hel";
    str_t   *str;
    char    *b;
    
    b = (char*)malloc(10);
    str = (void*)b;
    
    str->ui = (((const unsigned char*)(a))[3] << 24) |
              (((const unsigned char*)(a))[2] << 16) |
              (((const unsigned char*)(a))[1] << 8) | 
              (((const unsigned char*)(a))[0]);
    
    //str->usi = (((const unsigned char*)(a))[1] << 8) | (((const unsigned char*)(a))[0]);
      
    printf("STR: %s\n", b);
	printf("UI: %d\n", str->ui);
    
#ifdef _WIN32    
    system("pause");
#endif	
	return 0;
}
