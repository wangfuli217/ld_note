all = all help subst patsubst strip findstring \
		filter filter-out sort word wordlist words firstword \
		lastword example dir notdir suffix basename addsuffix \
		addprefix join wildcard realpath abspath \
		foreach if or and call origin shell error warning info

.PHONY: $(all)
help:
	@echo "Function call syntax"
	@echo " \$$(function arguments)"
	@echo 
	@echo "Supported object: $(sort $(all))"

all: $(filter-out all,$(all))

# Functions for string substitution and Analysis
include subst.mk
include patsubst.mk
include strip.mk
include findstring.mk
include filter.mk
include filter-out.mk
include sort.mk
include word.mk
include wordlist.mk
include words.mk
include firstword.mk
include lastword.mk

# Functions for file names
include dir.mk
include notdir.mk
include suffix.mk
include basename.mk
include addsuffix.mk
include addprefix.mk
include join.mk
include wildcard.mk
include realpath.mk
include abspath.mk

# Other functions
include foreach.mk
include if.mk
include or.mk
include and.mk

include call.mk
include origin.mk
include shell.mk
include errors.mk

# Examples
include example.mk

