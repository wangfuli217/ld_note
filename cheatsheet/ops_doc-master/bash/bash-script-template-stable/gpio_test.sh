#!/bin/bash
###############################################################################
# usage
###############################################################################
#  gpio_test.sh IO6_IO15 enable 
#  gpio_test.sh IO0_IO02 enable 
# _DEBUG=on gpio_test.sh


###############################################################################
# dabug
###############################################################################
export DEBUG
debug (){
  ${_DEBUG:-:} "$@"
}

_DEBUG() { 
  [ "$DEBUG" == "on" ] && "$@" || : 
}

###############################################################################
# set -euo pipefail
###############################################################################
set -o errexit  # Exit on most errors (see the manual)         |  set -e
# set -o errtrace # Make sure any error trap is inherited      |  set -E
set -o nounset  # Disallow expansion of unset variables        |  set -u
# set -o pipefail # Use last non-zero exit code in a pipeline  |  set -e

###############################################################################
# signal
###############################################################################
traperr() {
  echo "($?)ERROR: at about ${LINENO}"
}
trap traperr ERR


###############################################################################
# main start
###############################################################################

GPIO_DESC=$1
if [ "${GPIO_DESC}" = "-h" ]; then
cat <<EOF
  gpio_test.sh IO6_IO15 enable
  gpio_test.sh IO6_IO15 disable
  DEBUG=on gpio_test.sh IO6_IO15 enable
EOF
fi

group=${GPIO_DESC:2:1}
index=${GPIO_DESC:6:2}
if [ "${index:0:1}" = 0 ]; then
  num=${index:1:1}
  position=$((group * 32 + num))
else
  position=$((group * 32 + index))
fi

echo ${position} > /sys/class/gpio/export || true
echo "out" > /sys/class/gpio/gpio${position}/direction || true

if [ -z "$2" ]; then
  echo 1 > /sys/class/gpio/gpio${position}/value
  _DEBUG echo "/sys/class/gpio/gpio${position}/value enable"
else
  if [ "$2" = enable ]; then
    echo 1 > /sys/class/gpio/gpio${position}/value
    _DEBUG echo "/sys/class/gpio/gpio${position}/value enable"
  else
    echo 0 > /sys/class/gpio/gpio${position}/value
    _DEBUG echo "/sys/class/gpio/gpio${position}/value disable"
  fi
fi