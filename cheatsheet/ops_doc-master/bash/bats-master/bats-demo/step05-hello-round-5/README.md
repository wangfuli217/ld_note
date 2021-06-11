# Unit testing Hello World with Bats - Round 5

Now the script is used on a daily basis, users feel the need for improvements.

They sometimes have trouble debugging or remembreing options. They would like to have a more verbosity and a help. We have also decided to introduc switches.

> **focus of this section**
>
> - refactoring of tests
> - adding new tests
> - check the test does not always pass or pass when it should not


## Specifications for Round 5

Existing specifications

- The script must output Hello x! where x stand for the name given as a parameter
- When no name is provided the script should result in errors
- Whenever the script is called without parameters or wrong parameters, it should state why the program failed and print the usage


Additional specifications

- The script must provide a way to print input parameters in order to debug
- There must be a way to set on/off the verbosity


## Impact analysis

Hello World now has the following parameters :

 - -v : increase verbosity. in verbose mode  parameters' values will show up
 - -n name : indicates the name of the person to say hello to

There are many changes to be done from a technical standpoint.

- most of the calls to the program will be altered due to the addition of the -n switch
- need some code to manage the command line options
- new tests are required for -v and -h


## Adding -n switch

Each test is adapted to fit the -n switch. For instance :

```
@test "should output Hello Alice!" {
  run $BATS_TEST_DIRNAME/hello-world.sh -n Alice
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Alice!" ]
}
```

All tests now fail, excepted the test for no arguments. Let's fix the code. I need some code to manage the command line options. getopts it a quick and dirty option.

````
name=$1
`````

is replaced with

```name=
while getopts "n:" opt; do
  case $opt in
    n)
      name=$OPTARG
      ;;
  esac
done
```

Well ... Test for errors are OK, while tests that souuld output the name still fail.

```
 ✗ should output Hello Alice!
   (in test file step05-hello-round-5/hello-world-names-test.bats, line 10)
     `[ "$status" -eq 0 ]' failed
```

Adding the trace of the output should help.

```
@test "should output Hello Alice!" {
  run $BATS_TEST_DIRNAME/hello-world.sh -n Alice
  echo "output=$output"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Alice!" ]
}
```

We now know what is wrong. The output contains the usage instead of the name.

```
✗ should output Hello Alice!
   (in test file step05-hello-round-5/hello-world-names-test.bats, line 11)
     `[ "$status" -eq 0 ]' failed
   output=Usage: hello-world.sh <name>
```

It is uncleat to me why. We want to add some verbose option and trace. Thus it's time to do this step. Debugging will become easier.

## Adding -v switch

We will focus on the following tasks

> - new tests are required for -v
> - new tests are required for -n to ensure that it works nicely with -v

Let's add a new test file named [hello-world-verbosity-test.bats](hello-world-verbosity-test.bats) and change the implementation in [hello-world.sh](hello-world.sh).

```
# -v will set the verbosity on
# as this is a parameter, a message must be yield
# I do not check the status because -v is probably wrong. however it is not the purpose of this test

@test "When -v should change verbosity and output a trace" {
  run $BATS_TEST_DIRNAME/hello-world.sh -v
  echo "output=$output"
  [[ "$output" =~ "verbose mode is on" ]]
}

# When verbose is on, each input parameter must yield a trace

@test "When -v and -n should output the value of name" {
  run $BATS_TEST_DIRNAME/hello-world.sh -v -n "Alice"
  echo "output=$output"
  [[ "$output" =~ "input parameter name = 'Alice'" ]]
}

```
OK, fine.

```
$ bats step05-hello-round-5/hello-world-verbosity-test.bats
 ✓ When -v should change verbosity and output a trace
 ✓ When -v and -n should output the value of name

2 tests, 0 failures
```

## Fixing names tests

Let's give a try to [hello-world-names-test.bats](hello-world-names-test.bats)

```
 ✗ should output Hello Alice!
   (in test file step05-hello-round-5/hello-world-names-test.bats, line 11)
     `[ "$status" -eq 0 ]' failed
   output=input parameter name = 'Alice'
   Usage: hello-world.sh <name>
```

The parameter is set, but another check cause the program to stop.

The issue is caused by the test on line 4.
This line checks whether the number of arguement is not 1 and then issue an error message. The name option now requires 2 words. This tests should be changed to "$# -eq 0"

Now the programm does not stop because of the wrong number of parameters.
However, the script still fail.

```
$ bats step05-hello-round-5/hello-world-names-test.bats
 ✗ should output Hello Alice!
   (in test file step05-hello-round-5/hello-world-names-test.bats, line 12)
     `[ "$output" = "Hello Alice!" ]' failed
   output=input parameter name = 'Alice'
   Hello Alice!
...
5 tests, 3 failures
```

Do you guess why ?

The test in [hello-world-verbosity-test.bats](hello-world-verbosity-test.bats)  verifies that a message is issued.

```
@test "When -v and -n should output the value of name" {
  run $BATS_TEST_DIRNAME/hello-world.sh -v -n "Alice"
  echo "output=$output"
  [[ "$output" =~ "input parameter name = 'Alice'" ]]
}
```

However it does not check whether this message is issued only when the -v switch is on. Thus a very simple implementation that always echo the parameter seems correct.

To fix this, let's add a new test

```
@test "When no -v should not output the value of name" {
  run $BATS_TEST_DIRNAME/hello-world.sh -n "Alice"
  echo "output=$output"
  [[ ! "$output" =~ "input parameter name = 'Alice'" ]]
}
```

Run the test before trying to fix the code. This is a way to ensure that the test works as expected. It must fail here, otherwise the test is poorly written.

Great, it failed!

```
$ bats step05-hello-round-5/hello-world-verbosity-test.bats
 ✓ When -v should change verbosity and output a trace
 ✓ When -v and -n should output the value of name
 ✗ When no -v should not output the value of name
   (in test file step05-hello-round-5/hello-world-verbosity-test.bats, line 29)
     `[[ ! "$output" =~ "input parameter name = 'Alice'" ]]' failed
   output=input parameter name = 'Alice'
   Hello Alice!

3 tests, 1 failure
```
Let's fix the code

````
      #echo "input parameter name = '""$name""'"
      [[ $verbosity -ge 1 ]] && echo "input parameter name = '""$name""'"
````

and run the test again

```
$ bats step05-hello-round-5/hello-world-verbosity-test.bats
 ✓ When -v should change verbosity and output a trace
 ✓ When -v and -n should output the value of name
 ✓ When no -v should not output the value of name

3 tests, 0 failures
```

## Last check

There still a minor issue with one of the tests because of the change in usage.

```
$ /bats step05-hello-round-5/
 ✓ should output Hello Alice!
 ✓ should output Hello Jabberwock!
 ✓ should output Hello Cheshire Cat! when names has many words
 ✓ When no name is provided should exit with 1
 ✓ When no name is provided output should contain name is mandatory
 ✓ When no parameter is provided should exit with 1
 ✗ When no parameter is provided output should contain the usage
   (in test file step05-hello-round-5/hello-world-parameters-test.bats, line 13)
     `[[ "$output" =~ "Usage: hello-world.sh -n name"  ]]' failed
 ✗ When no parameter is provided should output the usage on first line
   (in test file step05-hello-round-5/hello-world-parameters-test.bats, line 19)
     `[ "${lines[0]}" = "Usage: hello-world.sh -n name" ]' failed
   line_0=Usage: hello-world.sh <name>
 ✓ When -v should change verbosity and output a trace
 ✓ When -v and -n should output the value of name
 ✓ When no -v should not output the value of name

11 tests, 2 failures
````

The test has not been updated after the addition of -v. Thus both test and  code are wrong.

Code is updated and as the test must test the same mesage at many places, the message has been put in a variable. Shell variables can be used in a test.

```
#!/usr/bin/env bats

USAGE="Usage: hello-world.sh [-v] -n name"
...
@test "When no parameter is provided output should contain the usage" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  [[ "$output" =~ "$USAGE"  ]]
}
```

Every test passed.

```
$ bats step05-hello-round-5/
 ✓ should output Hello Alice!
 ✓ should output Hello Jabberwock!
 ✓ should output Hello Cheshire Cat! when names has many words
 ✓ When no name is provided should exit with 1
 ✓ When no name is provided output should contain name is mandatory
 ✓ When no parameter is provided should exit with 1
 ✓ When no parameter is provided output should contain the usage
 ✓ When no parameter is provided should output the usage on first line
 ✓ When -v should change verbosity and output a trace
 ✓ When -v and -n should output the value of name
 ✓ When no -v should not output the value of name

11 tests, 0 failures
```

Cool! It's time for a break.

## What we have learned

> - how to refactor tests
> - how to refactor code easily because regresssions will be detected
> - how to detects tests that always pass and cases were testing it works is not enough

