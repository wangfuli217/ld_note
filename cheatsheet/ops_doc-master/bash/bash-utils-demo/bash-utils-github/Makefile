#
# <http://github.com/e-picas/bash-utils>
# Copyright (c) 2015 Pierre Cassat & contributors
# License Apache 2.0 - This program comes with ABSOLUTELY NO WARRANTY.
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code or see <http://www.apache.org/licenses/LICENSE-2.0>.
#
# GNU make:  install / cleanup / test
# on git clones:    rebuild manpages / upgrade version / create release / validate
#
## usage: make install <DESTDIR=prefix>       # install or update the library in <prefix>
##        make cleanup <DESTDIR=prefix>       # remove the library from <prefix>
##        make link <DESTDIR=prefix>          # link the local library's binary in <prefix>
##        make check                          # check your environment
##
##   e.g. make install /usr/local
##        make cleanup /opt
##

.DEFAULT_GOAL := help
SHELL:=/usr/bin/env bash
DESTDIR:=/usr/local
ROOTDIR:=$(shell pwd)
ISGITCLONE=$(shell [ -d "$(ROOTDIR)/.git" ] && echo 1 || echo 0)

# development tools
ifeq ($(ISGITCLONE),1)
	DATE:=$(DATE_GIT)
	include Makefile-dev
endif

# help & debug
debug:
	@echo "DESTDIR : $(DESTDIR)"
	@echo "ROOTDIR : $(ROOTDIR)"
	@if [ "$(ISGITCLONE)" = 1 ]; then \
		echo "MAKEFILE_LIST : $(MAKEFILE_LIST)"; \
		echo "SHELL : $(SHELL)"; \
		echo "SHELLCHECK_CMD: $(SHELLCHECK_CMD)"; \
		echo "BATS_CMD: $(BATS_CMD)"; \
		echo "MDE_CMD: $(MDE_CMD)"; \
		echo "GIT_CMD: $(GIT_CMD)"; \
		echo "CURRENT_VERSION: $(CURRENT_VERSION)"; \
		echo "DATE: $(DATE)"; \
	fi

# this will output any line of this file with a double-sharp tag
help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

check:
	@$(SHELL) "$(ROOTDIR)"/test/check-env.sh

# install/cleanup stuff
check-destdir:
	@if [ -z "$(DESTDIR)" ] || [ ! -d "$(DESTDIR)" ]; then \
		echo "Invalid destination directory '$(DESTDIR)' (run 'make help' to get help)." >&2; \
		exit 1; \
	fi

cleanup: check-destdir
	rm -rf $(DESTDIR)/{bin,etc/bash_completion.d,libexec,share/man/{man1,man7}}/bash-utils*

install: check-destdir cleanup
	mkdir -p $(DESTDIR)/{bin,etc/bash_completion.d,libexec,share/man/{man1,man7}}
	cp -R "$(ROOTDIR)"/bin/* $(DESTDIR)/bin/
	cp -R "$(ROOTDIR)"/libexec/* $(DESTDIR)/libexec/
	cp -R "$(ROOTDIR)"/etc/bash_completion.d/* $(DESTDIR)/etc/bash_completion.d/
	cp -R "$(ROOTDIR)"/man/*.1.man $(DESTDIR)/share/man/man1/
	cp -R "$(ROOTDIR)"/man/*.7.man $(DESTDIR)/share/man/man7/

link: check-destdir
	@if [ ! -e "$(ROOTDIR)/bin/bash-utils" ]; then \
		echo "Binary to link not found in '$(ROOTDIR)' (run 'make help' to get help)." >&2; \
		exit 1; \
	fi
	mkdir -p "$(DESTDIR)"/bin
	ln -s "$(ROOTDIR)/bin/bash-utils" "$(DESTDIR)"/bin/
