#include "firebert.h"
#include "util.h"
#include "bfmt.h"
#include "uasn1.h"

// ------------------------------------------------------------ 

static void
_tab(int tabc) { 
	while(tabc--) fmt_eprint("\t");	
}

// ------------------------------------------------------------ 

static char *
_strlwr(char *out, char *in, size_t l) { 
	char *ret = out;
	while(l-- && *in)  
		*out++ = tolower(*in++);
	*out = 0;
	return(ret);
}

// ------------------------------------------------------------ 

static char *
_container(int tag, int class) { 
	static char buf[1024]; /* hack hack */
	int n = 0;

	if(class == ASN1_U) { 
		char tbuf[100];
#undef  X
#define X(x, y) case y: fmt_sfmt(buf, 1024, "bkb asn1 %s", _strlwr(tbuf, #x, 100)); break;

		switch(tag) {
		ASN1_TAGS
		default:
			n = 1;
			break;
		}
	}

	if(class != ASN1_U || n) { 
		fmt_sfmt(buf, 1024, "bkb asn1 seq -T %sc%d",
			 (class == ASN1_U ? "u" : 
			  (class == ASN1_A ? "a" : 
			   (class == ASN1_C ? "C" :
			    "p"))), tag);
	}

	return(buf);
}

// ------------------------------------------------------------ 

static char *
_tag(int tag, int class) { 
	static char buf[1024]; /* hack hack */
	int n = 0;

       	if(class == ASN1_U) {
		char tbuf[100];
#undef  X
#define X(x, y) case y: fmt_sfmt(buf, 1024, "%s", _strlwr(tbuf, #x, 100)); break;

		switch(tag) { 
		ASN1_TAGS
       		default:
			n = 1;
			break;			
		}
	}

	if(class != ASN1_U || n) 
		fmt_sfmt(buf, 1024, "string -T %sp%d",
			 (class == ASN1_U ? "u" : 
			  (class == ASN1_A ? "a" : 
			   (class == ASN1_C ? "C" :
			    "p"))), tag);
	
	return(buf);
}

// ------------------------------------------------------------ 

static void
_string(asn_t *a, int tag, int class, int tabc) { 
	pair_t p = asn_read_string(a);
	u_char *cp = NULL;
	if((cp = p.key)) { 
		size_t l = p2v(p.value), i = 0;

		for(i = 0; l < 1024 && i < l; i++) 
			if(!isprint(cp[i]))
				break;

		if(i == l) {
			char buf[1024];
			memcpy(buf, cp, l);
			buf[l] = 0;

			fmt_eprint("bkb asn1 %s \"%s\" ;\n", _tag(tag, class), buf);
		} else {
			char *s = shexify(cp, l);
			
			fmt_eprint("bkb binhex %s | bkb asn1 %s ;\n", s, _tag(tag, class));

			free(s);
		}

		free(p.key);
	} 
}

// ------------------------------------------------------------ 

static void
_next(asn_t *A, int tab) { 
	static int Count = 0;	
	int t = 0, class = 0, cons = 0;

	Count += 1;

	while(!asn_over(A)) { 
		if((t = asn_read_id(A, &class, &cons)) != -1) { 
			ssize_t l = asn_read_length(A);
			u_char *b = NULL;

			if(!l) { 
				_tab(tab);
				fmt_eprint("echo -n "" | bkb asn1 %s;\n", _tag(t, class));
			} if((b = asn_bound(A, l))) {	       
				if(cons) { 
					_tab(tab);
					fmt_eprint("(\n");
					_next(A, tab+1);
					_tab(tab);
					fmt_eprint(") | %s;\n", _container(t, class));
				} else {
					_tab(tab);

					switch(t) { 
					case ASN1_BOOLEAN: { 
						int v = asn_read_bool(A);
						fmt_eprint("bkb asn1 boolean %d;\n", v);
       					} 	break;
					case ASN1_INTEGER: { 
						int64_t v = asn_read_int(A);
						fmt_eprint("bkb asn1 integer %Lx;\n", v);
					}	break;
					case ASN1_NULL: 
						fmt_eprint("bkb asn1 null;\n");	
						break;
					case ASN1_OID: {
						pair_t p = asn_read_oid(A);
						if(p.key) { 
							unsigned *arcs = p.key;
							int narcs = p2v(p.value), i = 0;
							for(i = 0; i < narcs; i++) 
								fmt_eprint("%s%u%s", i ? "." : "bkb asn1 oid ", arcs[i], i == (narcs-1) ? ";\n" : "");
						}
					} 	break;							
					
					default: { 
						_string(A, t, class, tab);
					}	break;

					}
				}

				asn_unbound(A, b);
			}
		}
	}
}

// ------------------------------------------------------------ 

int
main(int argc, char **argv) { 
	u_char *buf = NULL;
	size_t bl = 0;
	char *file = NULL;

	if(argv[1])
		file = argv[1];

	if((buf = read_file_or_stdin(file, &bl))) { 
		u_char *bp = buf, *ep = &buf[bl];
		asn_t *A = asn_reader(bp, ep);

		_next(A, 0);
	}

	exit(0);
}
