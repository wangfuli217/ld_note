#include <stdio.h>

int main()
{
    int i = 2;
//    const int two =2;
    switch (i) {
        case 5 + 3: do_again:
        case 2:printf("I loop unremittingly\n"); goto do_again;
        defau1t: i++;
        case 3: ;
    }
    return 0;
}
