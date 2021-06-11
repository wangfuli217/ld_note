#include "firebert.h"
#include "util.h"
#include "strutil.h"
#include "tbuf.h"
#include "slist.h"
#include "hash.h"

// This is total slop code

#define DICT "/usr/share/dict/words"
#define MACROS "/usr/local/bin/blackbag/sub.macros"

tbuf_t *OUT = NULL;
slist_t *Stack = NULL;
u_char *_lupe(u_char *cp, u_char *ep, size_t *l);

typedef struct macro_s { 
	char *name;
	char *expansion;
} macro_t;

hash_t *Macros = NULL;

// ------------------------------------------------------------ 

static void
_word(char *arg) {
	int fd = 0;
	char *file = getenv("SUB_DICT");
	size_t minsz = 0;

	if(!file) file = DICT;

	if(arg) 
		minsz = atoi(arg);

	if((fd = open(file, O_RDONLY)) != -1) {
		char buf[200];
		size_t l = file_size(fd);

		while(1) {
			char *cp = NULL;
			size_t off = random() % (l - 201);
			lseek(fd, off, SEEK_SET);
			read(fd, buf, 200);
			if((cp = strchr(buf, '\n'))) {
				char *ep = strchr(&cp[1], '\n');
				char *str = nult(&cp[1], ep);
				if(strlen(str) > minsz) {
					tbuf_cats(OUT, str);					
					break;
				}
			}
		}

		close(fd);
	}
}

// ------------------------------------------------------------ 

void
sysexec(char *cmdline) { 
	char *argv[256];
	size_t argl = 0;

	argv[argl++] = "sh";
	argv[argl++] = "-c";
	argv[argl++] = cmdline;
	argv[argl++] = NULL;

	execvp("/bin/sh", argv);
}

// ------------------------------------------------------------ 

static void
_pcl(int *pipe) { 
	close(pipe[0]);
	close(pipe[1]);
}

// ------------------------------------------------------------ 

u_char *
pipex(char *cmdline, u_char *cp, u_char *ep, size_t *l) { 
	tbuf_t *out = tbuf_empty();
	int e = 0;

	int inpipe[2];
	int outpipe[2];

	if((e = pipe(inpipe)) != -1 && pipe(outpipe) != -1) { 
		int infd = 0, outfd = 0;
		int pid = 0;

		if(!(pid = fork())) {
			infd = inpipe[0];
			outfd = outpipe[1];		
			
			dup2(infd, STDIN_FILENO);
			dup2(outfd, STDOUT_FILENO);
			dup2(outfd, STDERR_FILENO);

			_pcl(inpipe);
			_pcl(outpipe);

			sysexec(cmdline);
			assert(0 || !"exec failed");
		} else {
			int status = 0;

			infd = outpipe[0];
			outfd = inpipe[1];
			close(outpipe[1]);     
			close(inpipe[0]);
		
			atomicio(write, outfd, cp, (size_t)(ep - cp));
			close(outfd);

			while(1) { 
				u_char buf[100];
				ssize_t l = 0;
				if((l = read(outpipe[0], buf, 100)) > 0) 
					tbuf_cat(out, buf, l);
				if(l < 100)
					break;
			}      

       			close(infd);
			waitpid(pid, &status, 0);
		}
	} else { 
		if(e != -1) {
			close(inpipe[0]);
			close(inpipe[1]);
		}			
	}

	return(tbuf_raw(&out, l));
}

// ------------------------------------------------------------ 

static void
_hex(char *arg) {
	if(arg) {
		size_t n = strtoul(arg, NULL, 0);
		while(n--) {
			u_char c = (u_char) random();
			tbuf_catp(OUT, "%.2X", c);
		}
	}
}

// ------------------------------------------------------------ 

static void 
_shell(char *arg) {
	if(arg) {
		FILE *fp = NULL;

		if((fp = popen(arg, "r"))) { // EEK!
			int c = 0;

			while((c = fgetc(fp)) != EOF) 
				tbuf_cat(OUT, (u_char*)&c, 1);	// XXX look	       

			fclose(fp);
		}
	}	       
}

// ------------------------------------------------------------ 

static size_t
_markpipe(char *arg, u_char *cp, u_char *ep) {
	char *marker = NULL;
	u_char *mark = NULL, *out = NULL;
	size_t ml = 0, ret = (size_t)(ep - cp);

	if((marker = strstr(arg, "<<")) || (marker = strstr(arg, "#:"))) {
		*marker++ = 0;
		marker++;				
	} else 
		marker = "####";
	ml = strlen(marker);

	if((mark = memstr(cp, ret, (u_char*)marker, ml))) 
		ret = &mark[ml] - cp;
	else
		mark = ep;

	out = _lupe(cp, mark, &ml);
	mark = pipex(arg, out, &out[ml], &ml);
	tbuf_cat(OUT, mark, ml);
	free(mark);
	free(out);
	return(ret);
}

// ------------------------------------------------------------ 

static size_t 
_subst(char *cmd, u_char *cp, u_char *ep) {
	size_t ret = 0;
	char *arg = strchr(cmd, ':');
	if(arg) 
		*arg++ = 0;
	else
		arg = "";

	if(!strcasecmp(cmd, "word")) 
		_word(arg);
	else if(!strcasecmp(cmd, "mark"))
		ret = _markpipe(arg, cp, ep);		       
	else if(!strcasecmp(cmd, "hex"))
		_hex(arg);
	else if(!strcasecmp(cmd, "shell"))
		_shell(arg);		       
      	else {
		macro_t *mp = NULL;

		if((mp = hash_get(Macros, cmd, strlen(cmd)))) { 
       			char exp[2048];
			exp[2047] = 0;

			if(strstr(mp->expansion, "%s")) { 
				fmt_sfmt(exp, 2048, mp->expansion, arg);
				ret = _subst(exp, cp, ep);
			} else {
				strncpy(exp, mp->expansion, 2047);
				ret = _subst(exp, cp, ep);
			}
		}			
	}

	return(ret);
}

// ------------------------------------------------------------ 

static void 
_usage(void) {
	fmt_eprint(	"sub <data> ; # or:\n"
			"\tcat | sub\n"
			"\n"
			"sub reads its input and makes substitutions based on commands, incl:\n"
			"\n"
			"\t${hex:<count>}\tgenerate <count> random hex bytes\n"
			"\t${shell:<command>}\tsubstitute the output of a shell command\n"
			"\t${word[:size]}\tinsert a word (optionally at least <size> long)\n");
			
}

// ------------------------------------------------------------ 

u_char *
_lupe(u_char *cp, u_char *ep, size_t *l) { 
	u_char *ret = NULL;

	if(OUT) 
		Stack = slist_push(Stack, OUT);
	
	OUT = tbuf_empty();		     

	while(cp < ep) {
		if(cp[0] == '$' && &cp[4] < ep && cp[1] == '{') {
			char *s = (char*)&cp[2], *mp = s;
			while(mp < (char*) ep && mp[0] != '}')
				mp++;
			if(mp < (char*) ep) {
				size_t adv = _subst(nult(s, mp), (u_char*)mp+1, ep);
				cp = (u_char*) mp + 1;
				cp += adv;
				continue;
			}					
		} 

		tbuf_cat(OUT, cp, 1);
		cp++;
	}

	ret = tbuf_raw(&OUT, l);
	Stack = slist_pop(Stack, (void**)&OUT);
	return(ret);       
}

// ------------------------------------------------------------ 

static void
_load_macros(char *file) { 
	char *buf = NULL;
	size_t bl = 0;

	if((buf = (char*) read_file(file, &bl))) { 
		char *tp = NULL, *bp = buf;

		while((tp = strsep(&bp, "\n"))) { 
			if(*tp && *tp != '#') {
				char *cp = NULL;

				if((cp = strchr(tp, '='))) { 
					macro_t *m = malloc(sizeof(*m));
					*cp++ = 0;
					m->name = strdup(tp);
					m->expansion = strdup(strim(cp));
					hash_put(Macros, m->name, strlen(m->name), m);
				}
			}
       		}

		free(buf);
	}
}

// ------------------------------------------------------------ 

int
main(int argc, char **argv) {
	size_t l = 0;
	int c = 0;
	u_char *buf = NULL;
	char *macrofile = MACROS;	

	Macros = hash_new(10);
	signal(SIGPIPE, SIG_IGN);

	while((c = getopt(argc, argv, "hm:a:")) != -1) { 
		switch(c) { 
		case 'a':
			_load_macros(optarg);
			break;

		case 'm':
			macrofile = optarg;
			break;
		case 'h':
		default:
			_usage();
			exit(1);
		}
	}

	argc -= optind;
	argv += optind;

	_load_macros(macrofile);
		
	if(argv[0]) { 
		buf = (u_char*) copy_argv(&argv[0]);
		l = strlen((char*)buf);
	} else 
		buf = read_desc(fileno(stdin), &l);
		
	if(buf) {
		u_char *cp = buf, *ep = &buf[l], *op = NULL;
		size_t ol = 0;

		srandom(getpid() + time(NULL));
	
		if((op = _lupe(cp, ep, &ol))) 
			fwrite(op, ol, 1, stdout);
	}

	exit(0);
}


