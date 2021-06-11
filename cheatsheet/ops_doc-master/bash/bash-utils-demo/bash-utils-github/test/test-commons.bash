#!/usr/bin/env bats
#
# <http://github.com/e-picas/bash-utils>
# Copyright (c) 2015 Pierre Cassat & contributors
# License Apache 2.0 - This program comes with ABSOLUTELY NO WARRANTY.
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code or see <http://www.apache.org/licenses/LICENSE-2.0>.
#
# Common library for BATS tests
#

TEST_DEBUG=true
TESTBASHUTILS_ROOT_DIR="$(pwd)"
TESTBASHUTILS_MAKE="make"
TESTBASHUTILS_TEST_DIR="${TESTBASHUTILS_ROOT_DIR}/test/"
TESTBASHUTILS_TEST_TMPSCRIPT="${TESTBASHUTILS_ROOT_DIR}/test/tmp-test-script.sh"
TESTBASHUTILS_TESTSCRIPT="${TESTBASHUTILS_ROOT_DIR}/test/bash-utils-sample.sh"
TESTBASHUTILS_BIN="${TESTBASHUTILS_ROOT_DIR}/bin/bash-utils"
TESTBASHUTILS_CORE="${TESTBASHUTILS_ROOT_DIR}/libexec/bash-utils-core"
TESTBASHUTILS_MODULES="${TESTBASHUTILS_ROOT_DIR}/libexec/bash-utils-modules/"
TESTBASHUTILS_MODELMODULE="${TESTBASHUTILS_MODULES}/model"
TESTBASHUTILS_MANPAGE1="${TESTBASHUTILS_ROOT_DIR}/man/bash-utils.1.man"
TESTBASHUTILS_MANPAGE2="${TESTBASHUTILS_ROOT_DIR}/man/bash-utils.7.man"

bats_definition=$(declare -f run)
source "$TESTBASHUTILS_CORE" -- || { echo "> bash-utils-core not found!" >&2; exit 1; };
set +o posix
set +u
eval "$bats_definition"
