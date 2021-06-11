#include "firebert.h"
#include "util.h"
#include "uasn1.h"
#include "common.h"

int
main(int argc, char **argv) {
	size_t bl = 0;
	u_char *buf = NULL;
	int c = 0;

	ASN_Tag = ASN1_SEQUENCE;
	ASN_Type = ASN1_CONSTRUCTED;

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

	if((buf = read_file_or_args(argv, &bl))) {
		u_char *obuf = malloc(bl + 1024);
		asn_t *a = asn_writer(obuf, &obuf[bl + 1024]);		       		
		pair_t p;

		if(!ASN_Length_Override)
			ASN_Length = bl;

		asn_write_length(a, ASN_Length);
		asn_write_id(a, ASN_Class, ASN_Type, ASN_Tag);
			
		if((p = asn_encoding(a)).key) { 
			fwrite(p.key, (size_t)(p.value - p.key), 1, (ASN_Out?ASN_Out:stdout));
			fwrite(buf, bl, 1, (ASN_Out?ASN_Out:stdout));
		}
	}	

	exit(0);
}
