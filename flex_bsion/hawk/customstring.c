#include "customstring.h"

char* concat_string(char* s1, char* s2) {
	
	if (s1 == NULL) {
		char* tmp = (char*)malloc(strlen(s2) + 1);
		tmp[0] = '\0'; 
		strcat(tmp, s2);
		return tmp;
	}
	if (s2 == NULL) {
		char* tmp = (char*)calloc(strlen(s1) / sizeof(char) + 1, sizeof(char));
		tmp[0] = '\0'; 
		strcat(tmp, s1);
		return tmp;
	}
	
	char* tmp = (char*)malloc(strlen(s1) + strlen(s2) + 2);
	tmp[0] = '\0'; 

    strcat(tmp, s1);
    strcat(tmp, s2);

	return tmp;
}

char* substitute_string(char* string, int from, int to, char* subwith) {
	char* str = (char*)calloc(BIG_STRING_BUFFER_SIZE, sizeof(char*));
	
	strncpy(str, string, from);
	strcpy(str + from, subwith);
	strcpy(str + from + strlen(subwith), string + to);
	return str; 
}
char* get_substring(char* string, int from, int to) {
	char* str = (char*)calloc(BIG_STRING_BUFFER_SIZE, sizeof(char*));

	strncpy(str, string, from); // + from, to - from);
	return str; 
}


char* regexp_get_substring(char* string, char* regexp) {
	regex_t regex;
	regmatch_t matches[2];
	int reti;

	reti = regcomp(&regex, regexp, 0);
	if (reti) {
		die("Could not compile regex", REGEX_ERROR);
	}

	reti = regexec(&regex, string, 2, matches, 0);
	if (!reti) {
		//printf("--> get %s %d:%d\n", string, matches[0].rm_so, matches[0].rm_eo);
		return get_substring(string, matches[0].rm_so, matches[0].rm_eo);
	} else {
		//printf("--> get no match\n");
		return NULL;
	}
}

char* regexp_substitute_string(char* string, char* regexp, char* subwith) {

	regex_t regex;
	regmatch_t matches[2];
	int reti;

	reti = regcomp(&regex, regexp, 0);
	if (reti) {
		die("Could not compile regex", REGEX_ERROR);
	}

	reti = regexec(&regex, string, 2, matches, 0);
	if (!reti) {
		//printf("--> sub %s %d:%d with >%s<\n", string, matches[0].rm_so, matches[0].rm_eo, subwith);
		return substitute_string(string, matches[0].rm_so, matches[0].rm_eo, subwith);
	}
	else if (reti == REG_NOMATCH) {
		//printf("--> sub no match\n");
		return string;
	}
}

char* regexp_substitute_string_frombeginning(char* string, char* regexp, char* subwith) {

	regex_t regex;
	regmatch_t matches[2];
	int reti;

	reti = regcomp(&regex, regexp, 0);
	if (reti) {
		die("Could not compile regex", REGEX_ERROR);
	}

	reti = regexec(&regex, string, 2, matches, 0);
	if (!reti) {
		//printf("--> sub %s %d:%d with >%s<\n", string, 0, matches[0].rm_eo, subwith);
		return substitute_string(string, 0, matches[0].rm_eo, subwith);
	}
	else if (reti == REG_NOMATCH) {
		//printf("--> sub no match\n");
		return string;
	}
}

char* regexp_global_substitute_string(char* string, char* regexp, char* subwith) {

	regex_t regex;
	regmatch_t matches[2];
	int reti;

	reti = regcomp(&regex, regexp, 0);
	if (reti) {
		die("Could not compile regex", REGEX_ERROR);
	}

	reti = regexec(&regex, string, 2, matches, 0);
	if (!reti) {
		char* old = substitute_string(string, matches[0].rm_so, matches[0].rm_eo, subwith);
		char* new;
		while (1) {
			reti = regexec(&regex, old, 2, matches, 0);
			if (reti == REG_NOMATCH) return old;
			if (reti) return old;
			new = substitute_string(old, matches[0].rm_so, matches[0].rm_eo, subwith);
			free(old);
			old = new;
		}
	}
	else if (reti == REG_NOMATCH) {
		
		return string;
	}
}

