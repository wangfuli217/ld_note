# Set suffix rules for generating flex scanners

.SUFFIXES: .o .cpp .l

.o: 
	$(CCC) $(CCFLAGS) $(LDFLAGS) -o $@ $<

.cpp: 
	$(CCC) $(CCFLAGS) $(LDFLAGS) -o $@ $<

.l.cpp: 
	$(LEX) $(LFLAGS) --outfile=$@ $<

#############################################################################

LEX=flex
CCC=g++

#############################################################################
# List flex scanner programs to build
#############################################################################

PROGS = f0 f0b f1 fwc fwc2 fwc3 fstr fmulstr

all:
	make $(PROGS)

# Compile f1.l with "--noline" option to suppress #line directive 
# Needed so __LINE__ shows the line number from f1.cpp rather than from f1.l

f1.cpp: f1.l
	$(LEX) --noline --stdout $(LFLAGS) $< | grep -v \#line >$@

fwc2.cpp: fwc2.l
	$(LEX) --fast --outfile=$@ $<
fwc2: fwc2.o
	$(CCC) -Ofast -o fwc2 fwc2.o 
fwc3.cpp: fwc3.l
	$(LEX) --fast --outfile=$@ $<
fwc3: fwc3.o
	$(CCC) -Ofast -o fwc3 fwc3.o 


clean:
	rm -f `ls *.l | sed "s/\.l/.cpp/g"` 2>/dev/null
	rm -f $(PROGS) *.o *.exe a.out lex.*.c lex.*.cpp *.dot *.output *.stackdump core oo

f0.o: f0.cpp
f0b.o: f0b.cpp
f1.o: f1.cpp
fwc.o: fwc.cpp
fwc2.o: fwc2.cpp
fwc3.o: fwc3.cpp
fstr.o: fstr.cpp
fmulstr.o: fmulstr.cpp
