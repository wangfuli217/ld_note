#include "firebert.h"
#include "util.h"
#include "uasn1.h"
#include "common.h"

int
main(int argc, char **argv) {
	int c = 0;

	ASN_Tag = ASN1_NULL;

	while((c = getopt(argc, argv, asnopts(""))) != -1) {
		switch(c) { 
		default:
			if(asnopt(c) == -1) { 
				fmt_eprint("??\n");
				exit(1);
			}

			break;
		}
	}

	argc -= optind;
	argv += optind;

	if(1) {
		u_char *obuf = malloc(20);
		asn_t *a = asn_writer(obuf, &obuf[20]);		       		
		pair_t p;

		asn_write_length(a, ASN_Length);
		asn_write_id(a, ASN_Class, ASN_Type, ASN_Tag);
			
		if((p = asn_encoding(a)).key) 
			fwrite(p.key, (size_t)(p.value - p.key), 1, (ASN_Out?ASN_Out:stdout));
	}	

	exit(0);
}
