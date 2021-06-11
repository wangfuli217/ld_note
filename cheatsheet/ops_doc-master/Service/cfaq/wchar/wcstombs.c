#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <locale.h>
int main(int argc, char *argv){
    setlocale(LC_CTYPE, "en_US.UTF-8");
    wchar_t* ws = L"中国人";
    printf("%ls\n", ws);
    char buf[255] = {};
    size_t len = wcstombs(buf, ws, 255);
    for (int i = 0; i < len; i++){
        printf("0x%02X ", (unsigned char)buf[i]);
    }
    return 0;
}

