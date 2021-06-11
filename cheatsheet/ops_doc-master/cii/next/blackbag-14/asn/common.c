#include "firebert.h"
#include "util.h"
#include "uasn1.h"

u_int32_t 	ASN_Length		= 0;
int 		ASN_Length_Override 	= 0;
u_int32_t	ASN_Tag			= 0;
int		ASN_Class		= ASN1_U;
int		ASN_Type		= 0;
FILE *		ASN_Out			= NULL;
int		ASN_Raw			= 0;

// ------------------------------------------------------------ 

char *
asnopts(char *inopts) {
	static char buf[1024];
	fmt_sfmt(buf, 1024, "%sL:T:o:r", inopts);
	return(buf);
}

// ------------------------------------------------------------ 

int
asnopt(int c) {
	int ret = -1;

	switch(c) {
	case 'r':
		ASN_Raw = 1;
		ret = 0; break;

	case 'o': {
		if(!(ASN_Out = fopen(optarg, "w"))) {
			perror("open");
			exit(1);	
		} 
	}	ret = 0; break;

	case 'L':
		ASN_Length_Override = 1;
		ASN_Length = strtoul(optarg, NULL, 0);
		ret = 0; break;
	case 'T': {
		switch(tolower(optarg[0])) { 
		case 'u':		       	
			ASN_Class = ASN1_U; optarg++; break;
		case 'a':
			ASN_Class = ASN1_A; optarg++; break;
		case 'c':
			ASN_Class = ASN1_C; optarg++; break;
		case 'p':
			ASN_Class = ASN1_P; optarg++; break;
		default:
			break;
		} 

		if(tolower(optarg[0]) == 'p') {
			ASN_Type = ASN1_PRIMITIVE; optarg++;
		} 

		if(tolower(optarg[0]) == 'c') {
			ASN_Type = ASN1_CONSTRUCTED; optarg++;
		} 

		ASN_Tag = strtoul(optarg, NULL, 0);
	}	ret = 0; break;

	default:
		break;
	}

	return(ret);
}
