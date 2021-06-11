#!/usr/bin/env bash
# 
# action for ../interface-test.sh
#

RESET_DIR="${_BASEDIR}/reset/"

ACTION_DESCRIPTION="Refresh the reset dump with current media data (old dump file will be backuped) \n\
\t<${COLOR_COMMENT}>- Reset dir is '${RESET_DIR}'</${COLOR_COMMENT}> \n\
\t<${COLOR_COMMENT}>- Backup dir is '${_BACKUP_DIR}'</${COLOR_COMMENT}> ";
if [ "$SCRIPTMAN" = 'true' ]; then return; fi

project_required
targetdir_required

if [ "$_SET" = 'full' ]
    then DUMP_NAMETMP="${_PROJECT}"
    else DUMP_NAMETMP="${_SET}"
fi

NOW=$(date "+%Y%m%d-%H%M")

DUMPFILE="${RESET_DIR}/${_PROJECT}_reset.txt"
if [ -f "${DUMPFILE}" ]; then
    iexec "mv ${DUMPFILE} ${DUMPFILE}.${NOW}"
fi
iexec "ls -AlGF ${_BASEDIR} > ${DUMPFILE}"

# Endfile
