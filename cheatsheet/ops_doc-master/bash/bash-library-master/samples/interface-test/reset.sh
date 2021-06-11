#!/usr/bin/env bash
# 
# action for ../interface-test.sh
#

RESET_DIR="${_BASEDIR}/reset/"

ACTION_DESCRIPTION="A new media dump is loaded in the project (any existing data are over-written) ; \n\
\tthe script will automatically load the dump file named '<${COLOR_NOTICE}>[PROJECT]_reset.txt</${COLOR_NOTICE}>' in the '<${COLOR_NOTICE}>[PROJECT]</${COLOR_NOTICE}>' media dir \n\
\t<${COLOR_COMMENT}>- Reset dir is '${RESET_DIR}'</${COLOR_COMMENT}>";
if [ "$SCRIPTMAN" = 'true' ]; then return; fi

root_required
project_required
targetdir_required

DUMPFILE="${RESET_DIR}/${_PROJECT}_reset.txt"
if [ ! -f "$DUMPFILE" ]; then error "Unknown media dump file '${DUMPFILE}' !"; fi

iexec "rm -rf ${_TARGETMEDIA}/action-a/"
iexec "rm -rf ${_TARGETMEDIA}/action-b/"
iexec "cp ${DUMPFILE} ${_TARGETMEDIA}"

# Endfile
