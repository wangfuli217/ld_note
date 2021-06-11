include ../common.mk
TOP = ..

LFLAGS :=                       $(LFLAGS) -L$(TOP)/../third-party/libevent-1.0b -levent 

TARGETS = 			int				\
				string				\
				seq				\
				oid				\
				null				\

ALIASES =							\
				eoc				\
				printablestring			\
				utf8string			\
				bitstring			\
				integer				\
				boolean				\
				descriptor			\
				enumerated			\
				external			\
				ia5string			\
				numstring			\
				octetstring			\
				real				\
				sequence			\
				t61string			\
				timestring			\
				utctime				\
				videotexstring			\
				sset				\

MODULES = 			

all:				$(TARGETS)
				@for name in $(MODULES); do\
					(cd $$name; ${MAKE} all);\
				done

int:				int.o common.o
				$(CC) $(CFLAGS) -o $@ $< common.o $(LFLAGS)

string:				string.o common.o
				$(CC) $(CFLAGS) -o $@ $< common.o $(LFLAGS)

seq:				seq.o common.o
				$(CC) $(CFLAGS) -o $@ $< common.o $(LFLAGS)

null:				null.o common.o
				$(CC) $(CFLAGS) -o $@ $< common.o $(LFLAGS)

oid:				oid.o common.o
				$(CC) $(CFLAGS) -o $@ $< common.o $(LFLAGS)

install:			$(TARGETS)
				install -d /usr/local/bin/blackbag/asn
				install $(TARGETS) /usr/local/bin/blackbag/asn
				install $(ALIASES) /usr/local/bin/blackbag/asn
				install -m 755 asn1 /usr/local/bin/blackbag

clean:
				rm -f *.o *.a $(TARGETS)
