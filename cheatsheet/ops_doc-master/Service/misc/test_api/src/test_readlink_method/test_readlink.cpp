//============================================================================
// Name        : test.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>

#include <stdio.h>
#include <unistd.h>

using namespace std;

#define PATH_MAX 1024

char * get_exe_path()
{
    static char buf[PATH_MAX];
    int i;

    char path[1024] = {0};

    snprintf(path, sizeof(path), "/proc/%d/exe", getpid());

    int rslt = readlink(path, buf, PATH_MAX);
    if (rslt < 0 || rslt >= PATH_MAX)
    {
        return NULL;
    }
    buf[rslt] = '\0';

    printf("%s\n", buf);

    for (i = rslt; i >= 0; i--)
    {
        printf("buf[%d] %c\n", i, buf[i]);
        if (buf[i] == '/')
        {
            buf[i + 1] = '\0';
            break;
        }
    }

    return buf;
}

int main(int argc, char ** argv)
{
    printf("%d\n", getpid());
//    sleep(10000);
    printf("%s\n", get_exe_path());
    return 0;
}

