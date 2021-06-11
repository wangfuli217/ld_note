#!/bin/bash
###############################################################################
# usage
###############################################################################
# gpio_array_test.sh
# configuation gpio_conf_array for test array
# set and reset cycle: RESET_INTERVAL default is 10

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
set -o errexit  # Exit on most errors (see the manual)
# set -o errtrace # Make sure any error trap is inherited
set -o nounset  # Disallow expansion of unset variables
# set -o pipefail # Use last non-zero exit code in a pipeline

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

if [ "$#" -eq 2 ]; then
  if [ "$1" = "-h" ]; then
cat <<EOF
    gpio_array_test.sh
    gpio_array_test.sh
    DEBUG=on gpio_array_test.sh
EOF
  fi
fi

RESET_INTERVAL=10
declare -a gpio_conf_array=(
  'IO4_IO14'
  'IO4_IO15'
  'IO1_IO09'
  'IO4_IO05'
  'IO6_IO14'
  'IO6_IO11'
  'IO2_IO31'
  'IO6_IO15'
)

declare -a gpio_index_array=()
for gpio_conf in "${gpio_conf_array[@]}"; do
  group=${gpio_conf:2:1}
  index=${gpio_conf:6:2}

  if [ "${index:0:1}" = 0 ]; then
    num=${index:1:1}
    position=$((group * 32 + num))
  else
    position=$((group * 32 + index))
  fi

  gpio_index_array[${#gpio_index_array[@]}]=${position}
done

# for gpio_index in "${gpio_index_array[@]}"; do
#   echo "gpio_index: ${gpio_index}"
# done
# exit

# export gpio
for gpio_index in "${gpio_index_array[@]}"; do
  echo ${gpio_index} >/sys/class/gpio/export || true
done

# configure direction
for gpio_index in "${gpio_index_array[@]}"; do
  echo "out" >/sys/class/gpio/gpio${gpio_index}/direction || true
done

while true; do

  # set value 1
  for gpio_index in "${gpio_index_array[@]}"; do
    echo 1 >/sys/class/gpio/gpio${gpio_index}/value
    _DEBUG echo "/sys/class/gpio/gpio${gpio_index}/value enable"
  done

  _DEBUG echo "sleep ${RESET_INTERVAL} enable"
  sleep ${RESET_INTERVAL}

  # set value 0
  for gpio_index in "${gpio_index_array[@]}"; do
    echo 0 >/sys/class/gpio/gpio${gpio_index}/value
    _DEBUG echo "/sys/class/gpio/gpio${gpio_index}/value disable"
  done

  _DEBUG echo "sleep ${RESET_INTERVAL} disable"
  sleep ${RESET_INTERVAL}

done
