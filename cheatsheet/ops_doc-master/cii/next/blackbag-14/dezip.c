#include "firebert.h"
#include "util.h"
#include "bfmt.h"
#include <sys/stat.h>

// ------------------------------------------------------------ 

int
main(int argc, char **argv) {
	size_t l = 0;
	u_char *bp = NULL;
	int ctr = 0;

	if(mkdir("zips", 0755) == -1) {
		perror("mkdir");
		exit(1);
	}

	/* it's 2005, Jeremy */

	if((bp = read_file(argv[1] ? argv[1] : "in.bin", &l))) {
		u_char *ep = &bp[l], *op = bp;

		while(bp < ep) {
			u_char keyf[] = { 'P', 'K', 0x3, 0x4 };
			u_char keys[] = { 'P', 'K', 0x7, 0x8 };
			u_char keye[] = { 'P', 'K', 0x5, 0x6 };

			u_char *hp = memstrb(bp, ep, keyf, 4);
			if(hp) {
				if((hp - 16) >= bp && !memcmp((hp - 16), keys, 4))
					hp -= 16;
				if(1) {
					FILE *fp = NULL;				
	       				u_char *tp = memstrb(hp, ep, keye, 4);
					if(!tp) 
						tp = ep;
					else {
						size_t sz = 0;
						ld32(&tp, ep);
						ld16(&tp, ep);
						ld16(&tp, ep);
						ld16(&tp, ep);
						ld16(&tp, ep);
						ld32(&tp, ep);
						ld32(&tp, ep);
						sz = ld16(&tp, ep);
						if(&tp[sz] < ep)
							tp += sz;
						else 
							tp = ep;
					}						
				
					if((fp = pfopen("w", "zips/%d.zip", ctr++))) {
						fwrite(hp, (size_t)(tp - hp), 1, fp);
						fclose(fp);
					}
				
					fmt_print("Z %lx:%lu\n", (size_t)(hp - op), (size_t)(tp - hp));

					bp = tp;
				}
			} else
				bp = ep;
		}
	}

	fmt_eprint("%u archives found\n", ctr);		
	exit(0);
}


