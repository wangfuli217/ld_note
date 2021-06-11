SUBDIRS := bar foo
LIBS := foo/libfoo.a bar/libbar.a
MAKE = make

all: $(LIBS)

$(LIBS):
	for dir in $(SUBDIRS);do $(MAKE) -C $$dir all || exit 1; done #-C enter son dir to make

clean:
	@for dir in $(SUBDIRS); do make -C $$dir clean || exit 1; done


.PHONY: all clean
