/** @file string.c
	@brief The detailed implementation of string operations. 

	@author Qing Charles Cao (cao@utk.edu)
*/

#include "string.h"
//-------------------------------------------------------------------------
void mystrcpy(char *dest, const char *src)
{
    int i;

    i = 0;
    while (src[i] != '\0')
    {
        dest[i] = src[i];
        i++;
    }
    dest[i] = '\0';
}

//-------------------------------------------------------------------------
void mystrncpy(char *dest, const char *src, uint8_t n)
{
    int i;

    for (i = 0; i < n; i++)
    {
        dest[i] = src[i];
    }
}

//-------------------------------------------------------------------------
void strappend(char *base, char *string)
{
    int length1, length2;
    uint8_t i;

    length1 = mystrlen(base);
    length2 = mystrlen(string);
    for (i = 0; i < length2; i++)
    {
        base[i + length1] = string[i];
    }
    base[length1 + length2] = '\0';
}

//-------------------------------------------------------------------------
char *str_from_integer(int num)
{
    static char temp[7];
    int internal;
    uint8_t length;
    uint8_t i;
    uint8_t offset = 5;
    uint8_t remainder;

    if (num < 0)
    {
        internal = -num;
    }
    else
    {
        internal = num;
    }
    temp[6] = '\0';
    do
    {
        remainder = internal % 10;
        temp[offset] = dec2asciichar(remainder);
        internal = internal / 10;
        offset--;
    }

    while (internal != 0);
    if (num < 0)
    {
        temp[offset] = '-';
        if (offset == 0)
        {
            return temp;
        }
        else
        {
            offset--;
        }
    }
    {
        length = 7 - offset - 1;
        for (i = 0; i < length; i++)
        {
            temp[i] = temp[i + offset + 1];
        }
    }
    return temp;
}

//-------------------------------------------------------------------------
int superstring(char *string1, char *string2)
{
    //returns string1 is a superstring of string2, (equal or longer but string2 is prefix) then return 0
    //else return 1
    char *p, *q;

    p = string1;
    q = string2;
    while ((*p == *q) && (*p != '\0'))
    {
        p++;
        q++;
    }
    if ((*q == '\0') && (*p != '\0'))
    {
        return 0;
    }

    if ((*q == '\0') && (*p == '\0'))
    {
        return 0;
    }

    return 1;
}

//-------------------------------------------------------------------------
int mystrncmp(char *s, uint8_t start1, char *t, uint8_t start2, uint8_t length)
{
    uint8_t i;

    for (i = 0; i < length; i++)
    {
        if (s[i + start1] != t[i + start2])
        {
            return 1;
        }
    }
    return 0;
}

//--------------------------------------------------------------------------
int mystrlen(char *s)
{
    int count = 0;

    while (s[count] != '\0')
    {
        count++;
    }

    return count;
}
