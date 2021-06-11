#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#define FILE_MODE       (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)

int main() {
	int fd = -1000;
	int pd = -1000;

	fd = open("test", O_WRONLY | O_CREAT | O_TRUNC, FILE_MODE);
	dup2(fd, STDOUT_FILENO);

	printf("hello world\n");

	if (close(fd) == -1)
		puts("close pd error!");
	return 0;
}
