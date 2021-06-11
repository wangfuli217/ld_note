#include <stdio.h>
#include <stdlib.h>

int 
main(void)
{
    char first, last, ch;

    printf("Enter a first and last name: ");
    first = getchar();
    while ((ch = getchar()) != ' ')
    {
        ch = getchar();
        if (ch == '\n' || ch == ' ')
            break;
    }

    while ((last = getchar()) != ' ' || (last = getchar()) != '\n')
        printf("%c", last);

    printf(",%c.", first);
    system("pause");
    
    return 0;
}

