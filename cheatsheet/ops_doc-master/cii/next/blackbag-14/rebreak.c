#include "firebert.h"
#include "util.h"
#include <sys/stat.h>

// -----------------------------------------------------------------

int
main(int argc, char **argv) { 
	int c = 0;

	while((c = getopt(argc, argv, "")) != -1) { 
		switch(c) {
		default:
			fmt_eprint("??\n");
			exit(1);
		}
	}
	
	argc -= optind;
	argv += optind;

	if(argc) { 
		FILE *spanf = NULL;
		if((spanf = fopen(argv[0], "r"))) {
			if(!strncmp(argv[0], "spans.", 6)) {
				size_t rxs = 0, txs = 0;
				u_char *rxb = NULL, *txb = NULL;
				char fn[2048];
				char *sel = argv[0] + 6;

				fmt_sfmt(fn, 2048, "%s.rx.dump", sel);

				if((rxb = read_file(fn, &rxs))) {
					fn[strlen(sel)+1] = 't';
					if((txb = read_file(fn, &txs))) {
						char buf[100];

						if(mkdir(sel, 0755) >= 0) { 
							int sctr = 0, cctr = 0;

							while(fgets(buf, 100, spanf)) {
								FILE *fp = NULL;
								size_t l = strtoul(&buf[2], NULL, 0);
								
								if(buf[0] == 'S') {
									if(l <= rxs) {				
										if((fp = pfopen("w", "%s/s.%d.raw", sel, sctr++))) {
											fwrite(rxb, l, 1, fp);
											rxs -= l;
											rxb += l;
											fclose(fp);
										}
									}
								}


								if(buf[0] == 'C') {
									if(l <= txs) {				
										if((fp = pfopen("w", "%s/c.%d.raw", sel, cctr++))) {
											fwrite(txb, l, 1, fp);
											txs -= l;
											txb += l;
											fclose(fp);
										}
									}
								}
							}
						} else
							fmt_eprint("can't create dump directory ./%s: %s\n", sel, strerror(errno));
					} else
						fmt_eprint("can't read raw file \"%s\": %s\n", fn, strerror(errno));		
				} else
	       				fmt_eprint("can't read raw file \"%s\": %s\n", fn, strerror(errno));			     
			} else
				fmt_eprint("must use original name of span file (it's how I know what raw files to use)\n");
		} else
			fmt_eprint("can't open \"%s\": %s\n", argv[0], strerror(errno));
	} else 
		fmt_eprint("rebreak <spans.x.y.z.j:nnnn>\n");

	exit(0);
}
