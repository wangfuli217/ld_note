#include <stdio.h>
#include <unistd.h>
int main(int argc, const char *argv[])
{
	int stop = 0;
	int age = 1;
	while (!stop) {
		switch(age){
			case 1:
				printf("1111111\n");
				stop = 1;
				break;
			case 2:
				printf("222222222\n");
				break;
		}
		sleep(1);
	}
	return 0;
}
