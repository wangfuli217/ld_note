#!/bin/sh

shopt -s expand_aliases

oneTimeSetUp(){
  echo "Something dumb" > temp_file
}

test_Equality() {
  assertEquals 1 1
}

square() { expr $1 \* $1; }

test_square_table() {
  while read desc arg want ok; do
    got=$(square ${arg} 2>&1); rtrn=$?
    if [ ${ok} -eq ${SHUNIT_TRUE} ]; then
      assertTrue "${desc}: square() unexpected error; return ${rtrn}" ${rtrn}
      assertEquals "${desc}: square() = '${got}', want ${want}" "${got}" "${want}"
    else
      assertFalse "${desc}: square() expected error, got '${got}'" ${rtrn}
    fi
  done <<EOF
one   1  1  ${SHUNIT_TRUE}
two   2  4  ${SHUNIT_TRUE}
three 3  9  ${SHUNIT_TRUE}
five  5  25 ${SHUNIT_TRUE}
empty '' '' ${SHUNIT_FALSE}
EOF
}

oneTimeTearDown(){
  rm -f temp_file || true
}

. ../shunit2