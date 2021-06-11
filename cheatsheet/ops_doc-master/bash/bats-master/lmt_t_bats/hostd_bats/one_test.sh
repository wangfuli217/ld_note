#!/bin/bash
batsdir=$(dirname $(readlink -f $(which bats)))
echo $batsdir
export PATH=$batsdir:$PATH:/usr/libexec/bats-core/

in=$1
a_test=$2

if [[ ! -e "$in" ]]
then
  echo "not found: '$in'"
  exit 2
fi

out=$(mktemp)
bats-preprocess < $in > $out

if [[ -z "$a_test" ]] || ! grep -q "^$a_test" $out
then
  echo "test '$a_test' not found in $in"
  echo "available test are:"
  grep -o -E '^test_[^ ]+' $out
  exit 1
fi

echo "temp_file: $out"
export BATS_TEST_SOURCE=$out
bats-exec-test $in $a_test