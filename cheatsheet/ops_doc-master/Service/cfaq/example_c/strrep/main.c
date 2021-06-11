#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>

static char*
strrep(const char* src, char* str, char* rstr)
{
	char	*temp, *pos;
	size_t 	src_len, str_len, rstr_len;
	
	src_len = strlen(src);
	str_len = strlen(str);
	rstr_len = strlen(rstr);
	
	temp = (char*)calloc(1, src_len + rstr_len);
	
	if (temp == NULL) return NULL;

	pos = strstr(src, str);
	
	if (pos == NULL) return NULL;
	
	memcpy(temp, src, pos - src);
	memcpy(temp + (pos - src), rstr, rstr_len);
	memcpy(temp + (pos - src) + rstr_len, pos + str_len, src + src_len - pos - str_len);
	
	return temp;
}

static char*
strrrep(const char* src, const char* str, const char* rstr, char** endptr)
{
	char	*temp, *pos;
	size_t 	src_len, str_len, rstr_len;
	
	src_len = strlen(src);
	str_len = strlen(str);
	rstr_len = strlen(rstr);
	
	temp = (char*)calloc(1, src_len + rstr_len);
	
	if (temp == NULL) return NULL;

	pos = strstr(src, str);
	
	if (pos == NULL) return NULL;
	
	memcpy(temp, src, pos - src);
	memcpy(temp + (pos - src), rstr, rstr_len);
	memcpy(temp + (pos - src) + rstr_len, pos + str_len, src + src_len - pos - str_len);
	
	*endptr = pos + str_len;
	
	return temp;	
}

int 
main(int argc, char **argv)
{
	char *new_str;
	char *end;
	
	new_str = strrep("hello world", "world", "hellooooooo");
	
	printf("STR: %s\n", new_str ? new_str : "***");
	free(new_str);
	
	new_str = NULL;
	end = "world world";
	do {
		new_str = strrrep(end, "world", "hellooooooo", &end);
		
		printf("STR: %s\n", new_str ? new_str : "###");
		
		
	} while(end && new_str);
	
	system("pause");
	return 0;
}
