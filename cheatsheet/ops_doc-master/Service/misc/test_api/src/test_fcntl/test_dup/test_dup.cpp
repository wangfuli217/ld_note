#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#define FILE_MODE       (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)

int main() {
	int fd = -1000;
	int pd = -1000;

	fd = open("test", O_WRONLY | O_CREAT | O_TRUNC, FILE_MODE);
	pd = dup(fd);
	printf("fd:%d\npd:%d\n", fd, pd);
	if (close(fd) == -1)
		puts("close fd error!");

	if (write(pd, "1", 1) != 1)
		puts("write error!");
	if (close(pd) == -1)
		puts("close pd error!");
	return 0;
}
