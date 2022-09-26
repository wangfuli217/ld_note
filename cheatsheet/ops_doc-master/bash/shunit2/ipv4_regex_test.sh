testBRE() {
  grep -q '^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$' <<< '10.0.0.10'
  assertTrue "$?"
  gsed '/^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$/Q1' <<< '10.0.0.10'
  assertFalse "$?"
}

testBREnawk() {
  awk '/^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$/{exit 1}' <<< '10.0.0.10'
  assertFalse "$?"
  gawk '/^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$/{exit 1}' <<< '10.0.0.10'
  assertFalse "$?"
}

testERE() {
  grep -E -q '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' <<< '10.0.0.10'
  assertTrue "$?"
  grep -E -q '^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$' <<< '10.0.0.10'
  assertTrue "$?"
  gsed -E '/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/Q1' <<< '10.0.0.10'
  assertFalse "$?"
}

testEREshorter() {
  grep -E -q '^([0-9]+(\.|$)){4}' <<< '10.0.0.10'
  assertTrue "$?"
  gsed -E '/^([0-9]+(\.|$)){4}/Q1' <<< '10.0.0.10'
  assertFalse "$?"
}

testPCRE() {
  perl -ne '/^\d+\.\d+\.\d+\.\d+$/ and exit 1' <<< '10.0.0.10'
  assertFalse "$?"
}

testPCREshorter() {
  perl -ne '/^(\d+(\.|$)){4}/ and exit 1' <<< '10.0.0.10'
  assertFalse "$?"
  perl -ne '/(\d+(\.|\b)){4}/ and exit 1' <<< '10.0.0.10'
  assertFalse "$?"
}

testPCRERuby() {
  ruby -ne '/^(\d+[\.$]){4}/ and exit 1' <<< '10.0.0.10'
  assertFalse "$?"
}

. shunit2