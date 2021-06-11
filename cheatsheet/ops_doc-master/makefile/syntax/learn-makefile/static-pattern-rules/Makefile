# Static pattern rules
#
# Static pattern rules are rules which specify multiple targets and
# construct the prerequisite names for each target based on the
# target name. They are more general than ordinary rules with multiple
# targets because the targets do not have to have identical 
# prerequisites.
#
objects = $(patsubst %.c,%.o,$(wildcard *.c))

main: $(objects)

$(objects): %.o: %.c
	cc -g -c $< -o $@

.PHONY: clean
clean:
	$(RM) main $(objects)
