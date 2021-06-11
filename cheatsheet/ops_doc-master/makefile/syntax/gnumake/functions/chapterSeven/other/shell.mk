content := $(shell cat foo.c)

all :
	@echo "$(content)"

