#!/usr/bin/env bash
# 
# action for ../interface-test.sh
#

ACTIONA_DIR="${_BASEDIR}/action-a/"

ACTION_DESCRIPTION="Copy a set of media files (PDF and images) in a directory \n\
\t<${COLOR_COMMENT}>- Sets dir is '${ACTIONA_DIR}'</${COLOR_COMMENT}>";
if [ "$SCRIPTMAN" = 'true' ]; then return; fi

#root_required
project_required
targetdir_required

if [ ! -d "$ACTIONA_DIR" ]; then error "Unknown images pool directory '${ACTIONA_DIR}' !"; fi

iexec "mkdir -p ${_TARGETMEDIA}/action-a/"
iexec "cp -r ${ACTIONA_DIR}/* ${_TARGETMEDIA}/action-a/"
iexec "chmod -R 777 ${_TARGETMEDIA}"

# Endfile
