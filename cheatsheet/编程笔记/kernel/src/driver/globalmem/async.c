/*
 * =====================================================================================
 *
 *       Filename:  async.c
 *
 *    Description:  
 *
 *        Created:  05.12.10
 *       Revision:  
 *       Compiler:  GCC 4.4
 *
 *         Author:  Yang Zhang, treblih.divad@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>
#include <stdio.h>

void input_handler(int num)
{
    char data[MAX_LEN];
    int len;
    len = read(STDIN_FILENO, &data, MAX_LEN);
    data[len] = 0;
    printf("input available: %s\n", data);
}

int main(int argc, const char *argv[])
{
    int flag;
    signal(SIGIO, input_handler);
    fcntl(STDIN_FILENO, F_SETOWN, getpid());
    flag = fcntl(STDIN_FILENO, F_GETEL);
    fcntl(STDIN_FILENO, F_SETFL, flag | FASYNC);
    while (1);
    return 0;
}
