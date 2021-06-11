
# Advances use

## Run bats

This section shows basis use of bats.

Example tests and scripts lies in  [basic-test-1.bats](basic-test-1.bats)

The bats test run 3 sample scripts

- simple-script: echoes the first parameter and exits with the second parameter
- simple-script-with-errors: makes an attempt to use a non existant file
- simple-script-with-stderr: prints bar on stderr
- simple-script-with-multiple-lines: print two lines consisting of foo and bar

Bats run with human-readable option

```
$ bats  step00-basics/basic-test.bats
 ✓ simple-script should pass
 ✗ simple-script should fail on exit 1
   (in test file step00-basics/simple-test.bats, line 13)
     `$BATS_TEST_DIRNAME/simple-script.sh  "foo" 1' failed
   foo
 ✗ simple-script-with-error should fail on cat foo
   (in test file step00-basics/simple-test.bats, line 17)
     `$BATS_TEST_DIRNAME/simple-script-with-errors.sh' failed
   cat: foo: No such file or directory
 ✓ simple-script-with-stderr should pass

4 tests, 2 failures
```

Bats run with TAP option which is easier to use in a program
```
$ /bats --tap  step00-basics/basic-test.bats
1..4
ok 1 simple-script should pass
not ok 2 simple-script should fail on exit 1
# (in test file step00-basics/simple-test.bats, line 13)
#   `$BATS_TEST_DIRNAME/simple-script.sh  "foo" 1' failed
# foo
not ok 3 simple-script-with-error should fail on cat foo
# (in test file step00-basics/simple-test.bats, line 17)
#   `$BATS_TEST_DIRNAME/simple-script-with-errors.sh' failed
# cat: foo: No such file or directory
ok 4 simple-script-with-stderr should pass
```

## Check exit code and output

In this section, you will learn how to check the exit code and output.

Example tests and scripts lies in  [basic-test-2.bats](basic-test-2.bats)

```
$ bats step00-basics/basic-test-2.bats
 ✓ simple-script should pass
 ✗ simple-script will fail because exit code is not as expected
   (in test file step00-basics/basic-test-2.bats, line 18)
     `[ "$status" -eq 0 ]' failed
 ✗ simple-script-with-error will fail on cat foo
   (in test file step00-basics/basic-test-2.bats, line 27)
     `[ "$status" -eq 0 ]' failed
 ✓ simple-script should pass on exit 4
 ✓ simple-script-with-stderr should pass
 ✗ simple-script-with-multiple-lines will fail
   (in test file step00-basics/basic-test-2.bats, line 52)
     `[ "$status" -eq 0 ]' failed

6 tests, 3 failures
```

## Advanced checks (multiple lines, patterns, ...)

This section shows more advanced tests


```
$ bats step00-basics/basic-test-3.bats
 ✓ simple-script output should start with fo
 ✓ simple-script-with-multiple-lines output should contain foo
 ✓ simple-script-with-multiple-lines should output foo then bar
 ✗ simple-script-with-multiple-lines should output foo - will fail
   (in test file step00-basics/basic-test-3.bats, line 41)
     `[ "${lines[@]}" = "foo" ]' failed with status 2
   /tmp/bats.4468.src: line 41: [: too many arguments
 ✓ simple-script-with-multiple-lines should output foo - will pass
 ✓ simple-script-with-multiple-lines should output 2 lines
 ✓ simple-script-with-multiple-lines should output lines consisting of 3 letters
 ✓ simple-script-with-multiple-lines should output lines consisting of 3 letters - loop

8 tests, 1 failure
```

## Debug and troubleshooting

This section shows different techniques to feature out whats happen in the test


```
$ bats  step00-basics/basic-test-4.bats
 ✗ simple-script-with-multiple-lines should output foo - debug
   (in test file step00-basics/basic-test-4.bats, line 15)
     `[ "${output}" = "foo" ]' failed
   content of ${output} = foo
   bar
   expansion of ${lines[@]} = foo bar
 ✓ simple-script-with-multiple-lines should contain foo - output file
 ✓ same name - first should fail, second should pass
 ✓ same name - first should fail, second should pass

5 tests, 2 failures
```
