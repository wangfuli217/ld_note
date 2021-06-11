#define CODE_APPLE	1
#define CODE_ORANGE	2
#define CODE_NONE	0

switch(classifyfunc(string)) {
	case CODE_APPLE:
		...

	case CODE_ORANGE:
		...

	case CODE_NONE:
		...
}

static struct lookuptab {
	char *string;
	int code;
} tab[] = {
	{"apple",	CODE_APPLE},
	{"orange",	CODE_ORANGE},
};

classifyfunc(char *string)
{
	int i;
	for(i = 0; i < sizeof(tab) / sizeof(tab[0]); i++)
		if(strcmp(tab[i].string, string) == 0)
			return tab[i].code;

	return CODE_NONE;
}

或者使用if
if(strcmp(string, "apple") == 0) {
	...
} else if(strcmp(string, "orange") == 0) {
	...
}