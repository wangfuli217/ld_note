include common.mk
TOP = .

CFLAGS := 			-I../third-party/libevent-1.0b $(CFLAGS)
LFLAGS :=			-L../third-party/libevent-1.0b -levent -lssl -lm $(LFLAGS) 

TARGETS = 			blit				\
				crnl				\
				dehexify			\
				httphexify			\
				unasn				\
				nint				\
				no				\
				pad				\
				rebreak				\
				unify				\
				deunify				\
				len				\
				shf				\
				tsec				\
				sub				\
				touchwait			\
				roidrage			\
				telson				\
				deezee				\
				dezip				\
				httpcat				\
				binhex				\
				hexify				\
				pstrip				\
				tcbs				\
				b64				\
				d64				\
				dedump				\
				nstrz				\
				replug				\
				genacl				\
				c				\

FBOBJS = 			util.o				\
				cons.o				\
				ether_utils.o			\
				aguri.o				\
				unicode.o			\
				uasn1.o				\
				l4.o				\
				hash.o				\
				arena.o				\
				freelist.o			\
				log.o				\
				timer.o				\
				strutil.o			\
				par.o				\
				tbuf.o				\
				bfmt.o				\
				firebert.o			\
				httputils.o			\
				httprequest.o			\
				slist.o				\
				plugboard.o			\



MODULES = 			jenkins-hash format

all:				libfirebert.a $(TARGETS) 

libfirebert.a:			$(FBOBJS)
				@for name in $(MODULES); do\
					(cd $$name; ${MAKE} all);\
				done

				ar rc $@ $(FBOBJS)
				ranlib $@

replug:				replug.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

dehexify:			dehexify.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

httphexify:			httphexify.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

telson:				telson.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

nint:				nint.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

pad:				pad.o
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

no:				no.o
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

rebreak:			rebreak.o
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

deezee:				LFLAGS := -lz
deezee:				deezee.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

dezip:				dezip.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

blit:				blit.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

tcbs:				LFLAGS := $(LFLAGS) -lpcap       
tcbs:				tcbs.o
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

pstrip:				LFLAGS := $(LFLAGS) -lpcap       
pstrip:				pstrip.o
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

nstrz:				nstrz.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

httpcat:			httpcat.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

hexify:				hexify.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

b64:				b64.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

genacl:				genacl.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

dedump:				dedump.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

d64:				d64.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

unify:				unify.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

deunify:			deunify.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

len:				len.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

shf:				shf.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

sub:				sub.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

touchwait:			touchwait.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

tsec:				tsec.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

roidrage:			roidrage.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

unasn:				unasn.o
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

binhex:				binhex.o	
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

c:				c.o
				$(CC) $(CFLAGS) -o $@ $< $(LFLAGS)

clean:				
				rm -f *.o *.a $(TARGETS)
				@for name in $(MODULES); do\
					(cd $$name; ${MAKE} clean);\
				done

install:			$(TARGETS)
				install -d /usr/local/bin/blackbag
				install $(TARGETS) /usr/local/bin/blackbag
				install -m 644 sub.macros /usr/local/bin/blackbag
				install -m 755 bkb /usr/local/bin   

