# Unit testing Hello World with Bats - Round 3

After the demo, user were happy with Hello World and new specificxations arose.

> **focus of this section**
> checking for error exit
> checking for error message

<br>

## Specifications for Round 3

Existing specifications


- The script must output Hello x! where x stand for the name given as a parameter


Additional specifications

- When no name is provided the script should result in errors

<br>

## New test file

Two tests are added to check for error management.

```
@test "When no name is provided should exit with 1" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  echo "output=$output"
  [ "$status" -eq 1 ]
}

@test "When no name is provided should output name is mandatory" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  echo "output=$output"
  [ "$output" = "No name provided. Name is mandatory!" ]
}
```

Run the test once to ensure that new tests do not pass already.

```
cfalguiere@ip-172-31-30-150:~/projects/batsTest/bats-demo$ ../bats/bin/bats step03-hello-round-3/hello-world-test.bats
 ✓ should output Hello Alice!
 ✓ should output Hello Jabberwock!
 ✓ should output Hello Cheshire Cat! when names has many words
 ✗ When no name is provided should exit with 1
   (in test file step03-hello-round-3/hello-world-test.bats, line 37)
     `[ "$status" -eq 1 ]' failed
   output=Hello !
 ✗ When no name is provided should output name is mandatory
   (in test file step03-hello-round-3/hello-world-test.bats, line 46)
     `[ "$output" = "No name provided. Name is mandatory!" ]' failed
   output=Hello !

5 tests, 2 failures
```

It is often useful to check that the test fails before fixing the test. One of the issues with tests is that they might be written in such a way that they always pass.


Now, the script is changed to add the parameter check


```
#!/bin/bash
name=$1
[[ -z $name ]] && { echo "No name provided. Name is mandatory!"; exit 1; }
echo "Hello $name!"
```

and all the tests pass

```
$ bats step03-hello-round-3/hello-world-test.bats
 ✓ should output Hello Alice!
 ✓ should output Hello Jabberwock!
 ✓ should output Hello Cheshire Cat! when names has many words
 ✓ When no name is provided should exit with 1
 ✓ When no name is provided should output name is mandatory

5 tests, 0 failures
```

<br>

## What we have learned

> - the need to ensure that a test is not always passing
> - how to test script error management
