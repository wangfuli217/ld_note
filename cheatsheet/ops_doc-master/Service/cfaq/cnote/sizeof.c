#include <stdio.h>
int main(void){
printf("%zu\n", sizeof(int)); /* Valid, outputs the size of an int object, which is platform-dependent. */
printf("%zu\n", sizeof int); /* Invalid, types as arguments need to be surrounded by parentheses! */

char ch = 'a';
printf("%zu\n", sizeof(ch)); /* Valid, will output the size of a char object, which is always 1 for
all platforms. */
printf("%zu\n", sizeof ch);  /* Valid, will output the size of a char object, which is always 1 for
all platforms. */
}