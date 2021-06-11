#include <ctype.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

// this function will change the case of all letters in the message array,
// lowercase letters will become uppercase, and vice versa
void flip_case(char *message)
{
    printf("flip_case()\n");
    printf("Before:   %s\n", message);

    for (size_t i=0, ml = strlen(message); i < ml; ++i)
    {
        const char temp = message[i];

        if (isupper(temp))
            message[i] = tolower(temp);
        else
        if (islower(temp))
            message[i] = toupper(temp);
    }

    printf("After:    %s\n\n", message);
}

// this function will add 10 to an integer i
void add_ten(int *i)
{
    printf("add_ten()\n");
    printf("Before:   %d\n", *i);
    *i += 10;
    printf("After:    %d\n\n", *i);
}

// this function will add 1 to even numbers in the numbers array,
// only the first n numbers are operated on
void kill_evens(int *numbers, size_t n)
{
    printf("kill_evens()\n");
    printf("Before:   ");

    for (size_t i=0; i < n; ++i)
        printf("%d ", numbers[i]);

    printf("\n");

    for (size_t i=0; i < n; ++i)
        if (numbers[i] % 2 == 0)
            numbers[i] += 1;

    printf("After:    ");

    for (size_t i=0; i < n; ++i)
        printf("%d ", numbers[i]);

    printf("\n\n");
}

int main(void)
{
    flip_case((char[]){"Hello C99 World!"});

    add_ten(&(int){5});

    kill_evens((int[]){2, 3, 29, 90, 5, 6, 8, 0}, 8);

    printf("Current time: %s\n", ctime(&(time_t){time(NULL)}));
	
	system("pause");
	
	return 0;
}


