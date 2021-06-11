#include "firebert.h"
#include "util.h"
#include "bfmt.h"

int
main(int argc, char **argv) { 
	u_char buf[128], *bp = buf, *ep = &buf[sizeof buf];
	unsigned long long v = 0;
	int nbo = 1;
	int bsz = 32;
	
	if(argc < 2) { 
		fmt_eprint("nint [[n|b]|[h|l]]bitsz] <number>\n");
		exit(1);
	}

	if(argc > 2) { 
		bsz = 0;

		switch(argv[1][0]) { 
		case 't': { 
			v = time(NULL);
			bsz = 32;
			nbo = 1;
		}	break;
			
		case 'n':
		case 'N':
		case 'b':
		case 'B':
			nbo = 1;
			argv[1]++;
			break;

		case 'h':
		case 'H':
		case 'l':
		case 'L':
			nbo = 0;
			argv[1]++;
			break;

		default:
			break;
		}	

		if(!bsz)	
			bsz = atoi(argv[1]);
		argv[1] = argv[2];	
	}

	if(!v)
		v = strtoull(argv[1], NULL, 0);

	switch(bsz) { 
	case 8: {
		u_char wire = (u_char) v;
		nst8(wire, &bp, ep);
	}	break;

	case 16: {
		u_int16_t wire = (u_int16_t)v;
		if(nbo) nst16(wire, &bp, ep);
		else	lst16(wire, &bp, ep);
	}	break;

	case 32: {
		u_int32_t wire = (u_int32_t)v;
		if(nbo) nst32(wire, &bp, ep);
		else	lst32(wire, &bp, ep);
	}	break;

	case 64: {
		u_int64_t wire = v;
		if(nbo) nst64(wire, &bp, ep);
		else	lst64(wire, &bp, ep);
	}	break;

	default:
		fmt_eprint("nint doesn't speak int%d\n", bsz);
		exit(1);
	}

	fwrite(buf, (size_t)(bp - buf), 1, stdout);
	exit(0);
}
