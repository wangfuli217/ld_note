#include "firebert.h"
#include "uasn1.h"
#include "util.h"

int
main(int argc, char **argv) {
	int c = 0;
	int v = 1;
	size_t max = 4096;
	size_t after = 128;
	size_t before = 128;
	char *file = NULL;
	size_t fl = 0;
       	u_int32_t f[1024];
	size_t l = 0;
	u_char *buf = NULL;

	while((c = getopt(argc, argv, "a:b:qf:m:")) != -1) {
		switch(c) {
		case 'a':
			after = strtoul(optarg, NULL, 0);
			break;

		case 'b':
			before = strtoul(optarg, NULL, 0);
			break;
			       
		case 'm':
			max = strtoul(optarg, NULL, 0);
			break;
		case 'q':
			v = 0;
			break;
		case 'f':
			file = optarg;
			break;	
		}
	}

	argc -= optind;
	argv += optind;

	if(argv[0]) 
		oidstr(argv[0], f, &fl);

	if(file)
		buf = read_file(file, &l);
	else
		buf = read_desc(fileno(stdin), &l);

	if(buf) {
		u_char *bp = buf, *ep = &buf[l];
		u_char *cp = bp;

		while((cp = memchr(cp, 0x6, (size_t)(ep - cp))) && &cp[5] < ep) {
			if(cp[1] > 2 && cp[1] < 0x2F && &cp[cp[1]] < ep) {
				u_char *op = &cp[2], *tp = &op[cp[1]];

				asn_t *a = asn_reader(op, tp);
				pair_t p = asn_read_oid(a);
				if(p.key) {
					u_int32_t *arcs = p.key;
					int m = p2v(p.value),
					    i = 0;

					for(i = 0; i < fl && i < m; i++) 
						if(arcs[i] != f[i])
							break;

					if(!fl || i == fl) {
						char *str = NULL;
						size_t cl = after > before ? before : after;

						if(&tp[cl] >= ep)
							cl = (size_t)(ep - tp);

						if((tp - cl) < bp)
							cl = (size_t)(tp - bp);
						
						if(v) {
	       						fmt_eprint("-----------------------------\n%s", (str = shexdump((tp - cl), cl)));
							free(str);						
						}

						fmt_eprint("%lx ", (size_t)(cp - bp));

						for(i = 0; i < m; i++) 
							fmt_eprint(".%u", arcs[i]);
						fmt_eprint("\n");

						if(v) {
       							u_char *sp = tp;
	       						asn_t *av = asn_reader(sp, ep);

							for(;;) { 						
								int class = 0, constructed = 0, tag = 0;
							
								if((tag = asn_read_id(av, &class, &constructed))) {
									ssize_t ol = asn_read_length(av);
									u_char *objp = asn_mark(av), *obje = &objp[ol];
					       						
									if(ol != -1 && ol < max && obje < ep) {
										fmt_eprint("%d%s:%d =\n", class, constructed ? "+" : "", tag);
										if(ol) 
											fmt_eprint("%s\n", shexdump(objp, ol));

										asn_release(&av);
										av = asn_reader(obje, ep);
									} else
										break;	
								}
							}

							if(cl && v) {
								fmt_eprint("%s\n", (str = shexdump(tp, cl)));
								free(str);
							}
						}


					}
				} 

				asn_release(&a);
			}

			cp++;
		}			
	}

	exit(0);
}
