#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>

int main(int argc, char *argv[]){
    setlocale(LC_CTYPE, "en_US.UTF-8");
    wchar_t wc = L'中';
    char buf[100] = {};
    int len = wctomb(buf, wc);
    printf("%d\n", len);
    for (int i = 0; i < len; i++){
        printf("0x%02X ", (unsigned char)buf[i]);
    }
    return 0;
}
