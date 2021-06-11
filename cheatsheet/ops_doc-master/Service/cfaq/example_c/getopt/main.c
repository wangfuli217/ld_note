#include <stdio.h>
#include <getopt.h>
#include <stdlib.h>

//getopt.exe -a -b 2 -c

//The options argument is a string that specifies the option characters that are valid for this program. 
//An option character in this string can be followed by a colon (‘:’) to indicate that it takes a required argument. 
//If an option character is followed by two colons (‘::’), its argument is optional; this is a GNU extension.


int main(int argc, char** argv)
{
	int aflag=0, bflag=0, cflag=0;
	int ch;

	while ((ch = getopt(argc, argv, "ab:c")) != -1)
	{
		printf("optind: %d\n", optind);
		
		switch (ch) 
		{
			case 'a':
				printf("HAVE option: -a \n");
				aflag = 1;
				break;
			case 'b':
				printf("HAVE option: -b ");
				bflag = atoi(optarg);
				printf("The argument of -b is %s\n", optarg);
				break;
			case 'c':
				printf("HAVE option: -c\n");
				cflag = 1;
				break;
			case '?':
				printf("Unknown option: %c\n",(char)optopt);
			break;
		}
	}
	
	system("pause");
	
	return 0;
}
