#include "customio.h"
#include <errno.h>


void printstr(char* s) {
	int res = write(STDOUT_FILENO, s, strlen(s));
	if (res < 0) {
		printstr_err(strerror(errno));
		printstr_err("\n");
		exit(-10);
	}
}
void printstr_err(char* s) {
	int res = write(STDERR_FILENO, s, strlen(s));
	//exit(-10);
}

void printint(int x) {
	char* tmp = (char*)calloc(50, sizeof(char));
	sprintf(tmp, "%d", x);
	int res = write(STDOUT_FILENO, tmp, strlen(tmp));
	if (res < 0) {
		printstr_err(strerror(errno));
		printstr_err("\n");
		exit(-10);
	}
	free(tmp);
}

void printint_err(int x) {
	char* tmp = (char*)calloc(50, sizeof(char));
	sprintf(tmp, "%d", x);
	int res = write(STDERR_FILENO, tmp, strlen(tmp));
	if (res < 0) {
		printstr_err(strerror(errno));
		printstr_err("\n");
		exit(-10);
	}
	free(tmp);
}

void printdouble(double x) {
	char* tmp = (char*)calloc(50, sizeof(char));
	sprintf(tmp, "%lf", x);
	int n = 1;
	int i = 0;
	for (i = strlen(tmp) - 1; i >= 0; i--) {
		//write(STDOUT_FILENO, &tmp[i], 1);
		//printf(">%c", tmp[i]);
		if (tmp[i] == '.') break;
		if (tmp[i] != '0') {
			i++;
			break;
		}
		
	}
	//exit(0);
	int res = write(STDOUT_FILENO, tmp, i);
	if (res < 0) {
		printstr_err(strerror(errno));
		printstr_err("\n");
		exit(-10);
	}
	free(tmp);
}

