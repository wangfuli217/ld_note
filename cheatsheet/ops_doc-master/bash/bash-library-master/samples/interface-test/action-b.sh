#!/usr/bin/env bash
# 
# action for ../interface-test.sh
#

ACTIONB_DIR="${_BASEDIR}/action-b/"
DEFAULT_ACTION='full'

LISTSETS=""
for myset in $ACTIONB_DIR/*.pool; do
    myaction="${myset##$ACTIONB_DIR/}"
    if [ ! -z "${_PROJECT}" ]
        then myaction="${myaction%%_${_PROJECT}.pool}"
        else myaction="${myaction%%.sql}"
    fi
    if [ -n "${LISTSETS}" ]; then LISTSETS="${LISTSETS},"; fi
    LISTSETS="${LISTSETS} '<${COLOR_NOTICE}>${myaction}</${COLOR_NOTICE}>'"
    if [ "${myaction}" = "${DEFAULT_ACTION}" ]; then
        LISTSETS="${LISTSETS} (default)"
    fi
done

ACTION_DESCRIPTION="Copy a set of media files (PDF and images) in a directory ; use the 'set' option to choose the pool set to insert ; \n\
\t'SET' can be in${LISTSETS} \n\
\t<${COLOR_COMMENT}>- Sets dir is '${ACTIONB_DIR}'</${COLOR_COMMENT}>";
if [ "$SCRIPTMAN" = 'true' ]; then return; fi

#root_required
project_required
targetdir_required

IMPORTSET="${ACTIONB_DIR}/${_SET}_${_PROJECT}.pool"
if [ ! -d "$IMPORTSET" ]; then error "Unknown images pool directory '${IMPORTSET}' !"; fi

iexec "mkdir -p ${_TARGETMEDIA}/action-b/"
iexec "cp -r ${IMPORTSET}/* ${_TARGETMEDIA}/action-b/"
iexec "chmod -R 777 ${_TARGETMEDIA}"

# Endfile
