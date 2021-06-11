#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>
#include <wchar.h>

int main(int argc, char *argv[]){
    setlocale(LC_CTYPE, "en_US.UTF-8");
    wchar_t ws[] = L"中国人";
    printf("len %d, size %d\n", wcslen(ws), sizeof(ws));
    unsigned char* b = (unsigned char*)ws;
    int len = sizeof(ws);
    for (int i = 0; i < len; i++) {
        printf("%02X ", b[i]);
    }
    return 0;
}
