#include "firebert.h"
#include "bfmt.h"
#include "util.h"

int	 SizeIncluded = 1;
size_t	 Size = 32;
int	 LE = 0;
int	 Nudge = 0;
int	 UnitLength = 1;
int 	 ASCII = 0;

/* ------------------------------------------------------------------ */

static size_t 
_len(u_char *bp, u_char *ep) {
	size_t l = (size_t)(ep - bp);
	u_char buf[20], *lp = buf, *tp = &lp[20];

	l /= UnitLength;
	if(SizeIncluded)
		l += (Size / 8);	
	l += Nudge;

	if(ASCII) { 
		char fmtstr[] = "%0.XX";

		switch(Size) { 
		case 8:
			fmtstr[3] = '2';
			break;

		case 16:
			fmtstr[3] = '4';
			break;

		default:
		case 32:
			fmtstr[3] = '8';
			break;
		}

	       	if(ASCII > 1) 
			fmtstr[4] = 'u';		

		fprintf(stdout, fmtstr, l);		       
	} else { 
		switch(Size) {
		case 8:
			if(LE)
				lst8((u_int8_t)l, &lp, tp);
			else
				nst8((u_int8_t)l, &lp, tp);
			break;
		case 16:
			if(LE)
				lst16((u_int16_t)l, &lp, tp);
			else
				nst16((u_int16_t)l, &lp, tp);
			break;
		case 24:
			if(LE)
				lst24((u_int32_t)l, &lp, tp);
			else
				nst24((u_int32_t)l, &lp, tp);
			break;
		case 32:
			if(LE)
				lst32((u_int32_t)l, &lp, tp);
			else
				nst32((u_int32_t)l, &lp, tp);
			break;
		case 64:
			if(LE)
				lst64((u_int64_t)l, &lp, tp);
			else
				nst64((u_int64_t)l, &lp, tp);
			break;
		default:
			break;		
		}
		fwrite(buf, (size_t)(lp - buf), 1, stdout);
	}


	return((size_t)(lp - buf));
}

// ------------------------------------------------------------ 

static void 
_usage(void) {
	fmt_eprint(	"len [flags] <file> ; # or:\n"
			"\tcat | len [flags]\n"
			"\t-n\t<nudge>\t\tinteger to add to length\n"	
			"\t-x\t\t\tswap to little-endian\n"
			"\t-s\t<size>\t\tsize in bits of length field\n"
			"\t-o\t<offset>\t\twrite length at specified offset\n"	
			"\t-+\t\t\twrite length at end (?!)\n"
			"\t-f\t<file>\t\tread data from this file\n"
			"\t-t\t\t\tdon't include size word in size\n"
			"\n"
			"\tconsume input, write a binary length\n");
}

// ------------------------------------------------------------ 

int
main(int argc, char **argv) {
	int Pad = 0, Off = 0;
	int c = 0;
	char *file = NULL;
	size_t bl = 0;
	u_char *buf = NULL;
	size_t offset = 0;
	int append = 0;

	while((c = getopt(argc, argv, "adp:tu:hn:f:o:O:+s:x")) != -1) {
		switch(c) { 
		case 'a':
			ASCII = 1;
			SizeIncluded = 0;
			break;

		case 'd':
			ASCII = 2; // decimal
			SizeIncluded = 0;
			break;			       		       

		case 'O':
			Off = atoi(optarg);
			break;

		case 'p':
			Pad = atoi(optarg);
			break;

		case 't':
			SizeIncluded = 0;
			break;
		case 'u':
			UnitLength = atoi(optarg);
			break;

		case 'n':
			Nudge = atoi(optarg);
			break;

		case 'x':
			LE = 1;
			break;

		case 's':
			Size = atoi(optarg);
			break;

		case 'o':
			offset = atoi(optarg);
			break;

		case '+':
			append = 1;		
			break;

		case 'f':
			file = optarg;
			break;

		case 'h':
		default:
			_usage();
			exit(1);
		}
	}

	argc -= optind;
	argv += optind;

	if((buf = read_file_or_stdin(file, &bl))) {
		u_char *bp = buf, *ep = &bp[bl];

		if(offset && &bp[offset] < ep) {
			fwrite(bp, offset, 1, stdout);
			_len(bp, ep);
			bp += offset;
			fwrite(bp, (size_t)(ep - bp), 1, stdout);	
		} else if(!append) {
			size_t tot = _len(bp, ep);
			size_t p = 0;
			fwrite(bp, (size_t)(ep - bp), 1, stdout);	
			tot += (size_t)(ep - bp);
			tot += Off;
	
			if(Pad) { 
				p = Pad - (tot % Pad);

				bp[0] = 0;
				while(p--)
					fwrite(buf, 1, 1, stdout);
			}
		} else {
			fwrite(bp, (size_t)(ep - bp), 1, stdout);	
			_len(bp, ep);			
		} 
	} else {
		_len(NULL, NULL);
	}

	exit(0);
}
