#!/usr/bin/env bash
# 
# action for ../interface-test.sh
#

ACTION_DESCRIPTION="Synchronize current script (bin and dependencies) with a copy ;  use the '-t' option to set the copy target dir ; \n\
\tthe script uses the 'rsync' binary so target dir contents won't be deleted but replaced if they are older than current version. \n\
\t<${COLOR_COMMENT}>- Synchornized dir is '${_BASEDIR}/'</${COLOR_COMMENT}> \n\
\t<${COLOR_COMMENT}>- Synchronized binary is '$0'</${COLOR_COMMENT}>";
if [ "$SCRIPTMAN" = 'true' ]; then return; fi

root_required
targetdir_required

BASETARGET="${_TARGET%%/$_BASEDIR}"
if [ ! -d "$BASETARGET" ]; then path_error "${BASETARGET}"; fi

BASESCRIPT=$(basename "$0")
BASELIB_DIR="${_BASEDIR}/../../bin/"

iexec "rsync -rP ${_BASEDIR} ${BASETARGET}"
iexec "cp -f $0 ${BASETARGET} && chmod +x ${BASETARGET}/${BASESCRIPT}"
iexec "mkdir ${BASETARGET}/bin && cp ${BASELIB_DIR}/piwi-bash-library.bash ${BASETARGET}/bin/ && cp ${BASELIB_DIR}/../README.md ${BASETARGET}/bin/"
iexec "sed -i '' -e 's/\/..\/src\/piwi-bash-library.bash/\/bin\/piwi-bash-library.bash/g' ${BASETARGET}/${BASESCRIPT}"

# Endfile
