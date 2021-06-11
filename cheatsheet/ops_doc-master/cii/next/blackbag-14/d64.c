#include "firebert.h"
#include "util.h"
#include "strutil.h"
#include "tbuf.h"
       
char TABLE[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz./";


size_t
fake64d(char *str, size_t len, u_char *o, size_t ol) {
	u_char a[102400];
	int i = 0, j = 0, rlen = 0;
	size_t tl = strlen(TABLE);
		
        if(len == 0)
		return(0);

        for(i = 0; i < len; i++) {
		for(j = 0; str[i] != TABLE[j] && j < tl; j++);

		if(j == tl) {
			continue;
		} 

		a[rlen++] = j;
	}
	
	len = rlen;

        i = len - 1;
        j = len;

	do {
		a[j] = a[i];
                if(--i < 0)
                    break;
                a[j] |= (a[i] & 3) << 6;
                j--;
                a[j] = (u_char)((a[i] & 0x3c) >> 2);
                if(--i < 0)
                    break;
                a[j] |= (a[i] & 0xf) << 4;
                j--;
                a[j] = (u_char)((a[i] & 0x30) >> 4);
                if(--i < 0)
                    break;
                a[j] |= a[i] << 2;
                a[j - 1] = 0;
                j--;
	} while(--i >= 0);

	memcpy(o, &a[j+1], (len - j));
	return (len - j);
}

int
main(int argc, char **argv) {
	u_char *buf = NULL;
	size_t l = 0;

	if(argv[1] && !strcmp(argv[1], "-h")) {
		fmt_eprint(	"cat | d64 ; # or d64 <data> --- convert ASCII base64 stdin to binary stdout\n");
		exit(1);
	}

	if(argv[1]) {
		buf = (u_char*) copy_argv(&argv[1]);
		l = strlen((char*) buf);
	} else {
		buf = read_desc(fileno(stdin), &l);
	}

	if(buf) {
		size_t len = 0;
		u_char *out = malloc(l * 2);
		len = fake64d((char*)buf, l, out, l * 2);
		fwrite(out, len, 1, stdout);
	}

	exit(0);
}
