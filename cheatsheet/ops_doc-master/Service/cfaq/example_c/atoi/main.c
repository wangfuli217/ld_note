#include <stdio.h>
#include <stdlib.h>

const int dig_table[] = {
    1, 10, 100, 1000, 10000, 100000, 
    1000000, 1000000, 10000000, 100000000, 1000000000
};

int
my_atoi(const char* str)
{
    char    *c;
    int     result;
    
    result = 0;
 
    int len = strlen(str);
    for (int i = 0; i < len; i++) {
        if (*(str + i) >= '0' && *(str + i) <= '9') {
            result = (*(str + i) - 48)  + 10 * result;
            printf("result : %d\n", result);         
        }
    }
    
    if (*str == '-') {
        return ~(result) + 1;
    }
    
    return result;
}

int
my_atoi_2(const char* str)
{
    char    *c;
    int     result;
    int     len;
    
    result = 0;
    
    if (*str == '-') {
        len = strlen(str) - 1;
        c = str + 1;
    } else {
        len = strlen(str);
        c = str + 1;
    }
     
    for (int i = 0; i < len; i++) {
        if (*(c + i) >= '0' && *(c + i) <= '9') {
            result += dig_table[len - i - 1] * (*(c + i) - 48);
            printf("result : %d\n", result);         
        }
    }
    
    if (*str == '-') {
        return ~(result) + 1;
    }
    
    return result;
}


int
my_itoa(const int i, char* str)
{
    char *temp;
    unsigned int uv;
    char aux;
    char *begin, *end;
    
    uv = i < 0 ? -i : i;
    printf("uv: %u\n", uv);
    temp = str;
    
    printf("temp: %s\n", temp);
    do {
        *temp++ = (char)(48 + (uv % 10));
        printf("temp: %c\n", *temp);
    } while (uv /= 10);
    if (i < 0) {
        *temp++ = '-';
    }
    *temp = '\0';
    
    begin = str;
    end = temp - 1;
    
//    while (begin <= end) {
//        aux = *temp; *temp-- = *begin++; *begin = aux;
//    }
    
    return 0;
}

int main(int argc, char **argv)
{
	char temp[] = "-123456";
    char buff[32] = {0};
    
    printf("INT: %d\n", my_atoi(temp));
    printf("INT: %d\n", my_atoi_2(temp));
    printf("STR: %s\n", my_itoa(-123456, buff));
    
    system("pause");
    
	return 0;
}
