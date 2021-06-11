# DEFINING AND REDEFINING PATTERN RULES
#
# You define an implicit rule by writing a pattern rule. A pattern
# rule looks like an ordinary rule, except that its target contains
# the character '%' (exactly one of them). The target is considered
# a pattern for matching file names; the '%' can match any nonempty
# substring, while other characters match only themselves. The
# prerequisites likewise use '%' to show how their names relate to
# the target name.
#
# The pattern rule '%.o : %.c' says how to make any file stem.o from
# another file stem.c.
#
#   %.o: %.c
#     $(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@ 
#
#
# Automatic variables
# 
# These variables have values computed afresh for each rule that is
# executed, based on the target and prequisites of the rule.
#
# $@
#   The file name of the target fo the rule. If the target is an archive
#   member, the '$@' is the name of the archive file. In a pattern rule
#   that has multiple targets, '$@' is the name of whichever target
#   caused the rule's recipe to be run.
# 
# $%
#   The target member name, when the target is an archive member. For
#   example, if the target is foo.a(bar.o) then '$%' is bar.o and '$@'
#   is foo.a. '$%' is empty when the target is not an archive member.
#
# $<
#   The name of the first prerequisite. If the target got its recipe
#   from an implicit rule, this will be the first prerequisite added
#   by the implicit name.
#
# $?
#   The names of all the prerequisites that are newer than the target,
#   with spaces between them. If the target does not exist, all 
#   prerequisites will be included. For prerequisites which are archive
#   members, only the named member is used.
#
# $^
#   The names of all the prerequisites, with spaces between them. For
#   prerequisites which are archive members, only the named member is
#   used. A target has only one prerequisite on each other file it
#   depends on, no matter how many times each file is listed as a
#   prerequisite. So if you list a prerequisite more than once for a 
#   target, the value of '$^' contains just one copy of the name. This
#   list does not contain any of the order-only prerequisites.
#
# $+
#   This is like '$^', but prerequisites listed more than once are
#   duplicated in the order they were listed in the makefile. This is
#   primarily useful for use in linking commands where it is meaningful
#   to repeat library file names in a particular order.
#
# $|
#   The names of all order-only prerequisites, with spaces between them.
#
# $*
#   The stem with which an implicit rule matches. If the target is
#   dir/a.foo.b and the target pattern is a.%.b then the stem is dir/foo.
#   The stem is useful for constructing names of related files.
#
# Of the variables, '$@', '$<', '$%', '%*', have values that are single
#   file names. '$^', '$?', '$+', have vlaues that are lists of file
#   names. These seven have variants that get just the file's directory
#   name or just the file name within the directory. The variant variables'
#   name are formed by apppending 'D' or 'F', respectively. The functions
#   dir and notdir can be used to obtain a simliar effect. Note, however,
#   that the 'D' variants all omit the trailing slash which always appears
#   in the output of the dir function.
#
# $(@D)
#   The directory part of the file of the target, with the trailing slash
#   removed. If the value of '$@' is dir/foo.o then '$(@D)' is dir. The
#   value is . if '$@' does not contain a slash.
#
# $(@F)
#   The file-within-directory part of the file name of the target. If the
#   value of '$@' is dir/foo.o then '$(@F)' is foo.o. '$(@F)' is equivalent
#   to '$(notdir $@)'.
#
# $(*D)
# $(*F)
#   The directory part and the file-within-directory part of the stem;
#   dir and foo in this example.
#
# $(%D)
# $(%F)
#   The directory part and the file-within-directory part of the archive
#   member name. This makes sense only for archive member targets of the
#   form archive(member) and is useful only when member may contain a
#   directory name.
#
# $(<D)
# $(<F)
#   The directory part and the file-within-directory part of the first
#   prerequisite.
#
# $(^D)
# $(^F)
#   Lists of the directory part and the file-within-directory part of 
#   all prerequisites.
#   
# $(+D)
# $(+F)
#   Lists of the directory part and the file-within-directory part of 
#   all prerequisites, including multiple instances of duplicated
#   prerequisites.
#
# $(?D)
# $(?F)
#   Lists of the directory part and the file-within-directory part of 
#   all prerequisites that are newer than the target.
#
# HOW PATTERNS MATCH
# 
# A target pattern is composed of a '%' between a prefix and a suffix,
# either or both of which may be empty. The pattern matches a file name
# only if the file name starts with the prefix and ends with the suffix,
# without overlap. The text between the prefix and the suffix is called
# the stem. Thus, when the pattern '%.o' matches the file name test.o,
# the stem is 'test'. The pattern rule prerequisites are turned into
# actual file names by substuting the stem for the character '%'. Thus,
# if in the same example one of the prerequisites is written as '%.c',
# it expands to 'test.c'.
#
# When the target patten does not contain a slash (and it usually does
# not), directory names in the file names are removed from the file name
# before it is compared with the target prefix and suffix. After the 
# comparison of the file name to the target pattern, the directory names,
# along with the slash that ends them, are added on to the prerequisite
# file names generated from the pattern rule's prerequisite patterns and
# the file name. The directories are ignored only for the purpose of
# finding an implicit rule to use, not in the application of that rule.
# Thus, 'e%t' matches the file name src/eat, with 'src/a' as the stem.
# When prerequisites are turned into file names, the directories from
# the stem are added at the front, while the rest of the stem is substituted
# for the '%'. The stem 'src/a' with a prerequisite pattern 'c%r' gives
# the file name src/car.
#
all: c.o a.o b.o a.o | d.o
	@echo \$$\(@\) $@
	@echo \$$\(%\) $%
	@echo \$$\(\<\) $<
	@echo \$$\(?\) $?
	@echo \$$\(^\) $^
	@echo \$$\(+\) $+
	@echo \$$\(\|\) $|
	@echo \$$\(\*\) $*

a.%.b:
	@echo \$$\(\*\) $*

$(info make)
$(info make dir/a.foo.b)
$(info )

clean:
	rm *.o
