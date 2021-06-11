#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(void) {
    char asciiString[50] = "Hello world!";
    char utf8String[50] = "Γειά σου Κόσμε!"; /* "Hello World!" in Greek */
    printf("asciiString has %zu bytes in the array\n", sizeof(asciiString));
    printf("utf8String has %zu bytes in the array\n", sizeof(utf8String));
    printf("%s is %zu bytes\n", asciiString, strlen(asciiString));
    printf("%s is %zu bytes\n", utf8String, strlen(utf8String));
    
    return 0;
}
