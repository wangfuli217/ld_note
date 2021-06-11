load 'lib/bats-support/load'
load 'lib/bats-assert/load'

function preprocessing_sections_are_still_there() {
  cat $1 | grep "@@@"
}

@test "proper file with shebang can be preprocessed" {
  run ../preprocess.sh target/good.sh
  assert_success
  run cat target/good.sh
  assert_line --index 0 '#!/bin/bash'
  assert_line --index 1 --partial '# Build date:'
  assert_line --index 2 'echo "Hello World"'
}

@test "proper file preprocessed with custom start and end tokens" {
  run ../preprocess.sh target/good-custom-start-end.sh "@@@CUSTOMSTART@@@" "@@@CUSTOMEND@@@"
  assert_success
  run cat target/good-custom-start-end.sh
  assert_line --index 0 '#!/bin/bash'
  assert_line --index 1 --partial '# Build date:'
  assert_line --index 2 'echo "Hello World"'
}

@test "proper file without shebang can be preprocessed" {
  run ../preprocess.sh target/good-no-shebang.sh
  assert_success
  run cat target/good-no-shebang.sh
  assert_line --index 0 --partial '# Build date:'
  assert_line --index 1 'echo "Hello World"'
}

@test "file with wrong shebang can not be preprocessed" {
  run ../preprocess.sh target/bad-wrong-shebang.sh
  assert_failure
  diff target/bad-wrong-shebang.sh examples/bad-wrong-shebang.sh # No preprocessing happened
}

@test "file improper end token can not be preprocessed" {
  run ../preprocess.sh target/bad-improper-end.sh
  assert_failure
  diff target/bad-wrong-shebang.sh examples/bad-wrong-shebang.sh # No preprocessing happened
}

@test "file improper start token can not be preprocessed" {
  run ../preprocess.sh target/bad-improper-start.sh
  assert_failure
  diff target/bad-wrong-shebang.sh examples/bad-wrong-shebang.sh # No preprocessing happened
}
