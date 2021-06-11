# each VAR in LIST , do TEXT
# return XX[]XX[]XX
# $(foreach VAR,LIST,TEXT)
dirs := a b c d
files := $(foreach dir,$(dirs),$(wildcard $(dir)/*))
# <==>
# files = $(wildcard a/* b/* c/* d/*)

all :
	echo "files = $(files)"
