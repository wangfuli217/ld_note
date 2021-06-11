#include "firebert.h"
#include "util.h"
#include "strutil.h"
#include "tbuf.h"

char TABLE[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz./";

size_t 
fake64e(u_char *buffer, size_t len, char *str, size_t strl) {
        int notleading = 0;
        int pos = len % 3;
        u_char b0 = 0;
        u_char b1 = 0;
        u_char b2 = 0;
	tbuf_t *sb = tbuf_new(NULL, 0);

        switch(pos) {
        case 1: 
		b2 = buffer[0];
		break;

        case 2: 
		b1 = buffer[0];
		b2 = buffer[1];
		break;
	default: 
       		break;
        }

        do {
		int c = (b0 & 0xfc) >> 2;
		if(notleading || c != 0) {
			tbuf_cat(sb, &(TABLE[c]), 1);
			notleading = 1;
		}
		c = (b0 & 3) << 4 | (b1 & 0xf0) >> 4;
		if(notleading || c != 0) {
			tbuf_cat(sb, &(TABLE[c]), 1);
			notleading = 1;
		}
		c = (b1 & 0xf) << 2 | (b2 & 0xc0) >> 6;
		if(notleading || c != 0) {
			tbuf_cat(sb, &(TABLE[c]), 1);
			notleading = 1;
		}
		c = b2 & 0x3f;
		if(notleading || c != 0) {
			tbuf_cat(sb, &(TABLE[c]), 1);
			notleading = 1;
		}
		if(pos >= len)
			break;

                b0 = buffer[pos++];
                b1 = buffer[pos++];
                b2 = buffer[pos++];
        } while(1);

//	b0 = 0;
//	tbuf_cat(sb, &b0, 1);

	{
		size_t l = 0;
		char *d = tbuf_raw(&sb, &l);
		strncpy(str, d, strl < l ? strl : l);
		return(strl < l ? strl : l);
	}
}

int
main(int argc, char **argv) {
	u_char *buf = NULL;
	size_t l = 0;

	if(argv[1] && !strcmp(argv[1], "-h")) {
		fmt_eprint("cat | b64 ; # or b64 <data> --- convert binary stdin to ASCII base64 out\n");
		exit(1);
	}

	if(argv[1]) {
		buf = (u_char*) copy_argv(&argv[1]);
		l = strlen((char*) buf);
	} else {
		buf = read_desc(fileno(stdin), &l);
	}

	if(buf) {
		char *out = malloc(l * 2);
		l = fake64e(buf, l, out, l * 2);
		if(getenv("B64_RAW"))
			fwrite(out, l, 1, stdout); 
		else { 
			while(l) { 
				size_t ol = 65; 
				if(l < ol)
					ol = l;

				fwrite(out, ol, 1, stdout);
				fwrite("\n", 1, 1, stdout);

				l -= ol;
				out += ol;			
			}
		}
	}

	exit(0);
}
