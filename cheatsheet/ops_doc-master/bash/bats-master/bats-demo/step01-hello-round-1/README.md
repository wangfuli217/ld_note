# Unit testing Hello World with Bats - Round 1

Let's start with a very common scenario and build it with an Agile process

> **focus of this section**
> basic use of bats
> how to debug

<br>

## Specifications Round 1

- The script must output Hello x! where x stand for the name given as a parameter


<br>

## Let's write the test

A test transcription of the specification might be

````
# file hello-world-test.bats
#!/usr/bin/env bats
@test "should output Hello Alice!" {
  run $BATS_TEST_DIRNAME/hello-world.sh  Alice
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Alice!" ]
}
````


First thinks first, whats is $BATS_TEST_DIRNAME ?

$BATS_TEST_DIRNAME is one of the environment variables provided by Bats

As I run the test from the home of the project, the script is not in the current directory.
I need to provide the path to the script under test. As the script and the test lies in the same folder, I can use the path of the test directory as the path to the script.


Whenever the test is not in the same directory as the test (for instance you run some integration tests that lies somewhere else) you may either hardcode the path or set an environment variable before the test call.

For instance, use a variable SUT_DIRNAME

````
# file hello-world-test.bats
#!/usr/bin/env bats
@test "should output Hello Alice!" {
  run $SUT_DIRNAME/hello-world.sh  Alice
  ...
}
````

and set it before the test is called

````
$ export SUT_DIRNAME=...
$ bats  step01-hello-round-1/hello-world-test.bats
````

<br>

## Running the test

Now check what happen

````
$ bats  step01-hello-round-1/hello-world-test.bats
 ✗ should output Hello Alice!
   (in test file step01-hello-round-1/hello-world-test.bats, line 10)
     `[ "$status" -eq 0 ]' failed

1 test, 1 failure
````


**_What's wrong with the test ?_**

This is a pretty common situation.

Bats is great when it comes to run a test suite again and again. However, debugging is not so easy.

Here are some stategies that helps debugging

<br>

### %%_add traces_**

Add prints of the output to the test

```
@test "should output Hello Alice!" {
  run $BATS_TEST_DIRNAME/hello-world.sh  Alice
  echo "status=$status"
  echo "output=$output"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello Alice!" ]
}
```

For whatever reason Bats sometimes does not output errors on failure

````
$ bats step01-hello-round-1/hello-world-test.bats
 ✗ should output Hello Alice!
   (in test file step01-hello-round-1/hello-world-test.bats, line 18)
     `[ "$status" -eq 0 ]' failed
   status=127
   output=/home/cfalguiere/projects/batsTest/bats/libexec/bats-exec-test: line 58: /home/cfalguiere/projects/batsTest/bats-demo/step01-hello-round-1/hello-world.sh: No such file or directory

1 test, 1 failure
````

Be careful of adding the traces before the checks. The test will exit on [ "$status" -eq 0 ] and will never reach the code after the checks.

<br>

### %%_remove run_**

Run the test without the _run_ wrapper. The function exits right away and this will prevent _run_ from swallowing the output.

```
$ /bats step01-hello-round-1/hello-world-test.bats
 ✗ should output Hello Alice!
   (in test file step01-hello-round-1/hello-world-test.bats, line 15)
     `$BATS_TEST_DIRNAME/hello-world.sh  Alice' failed
   /tmp/bats.21725.src: line 15: /home/cfalguiere/projects/batsTest/bats-demo/step01-hello-round-1/hello-world.sh: No such file or directory
````

It is easier to implement, but the drawback is that the test does not work anymore. When the problem is fixed, the test fail because _status_ and _output_ does not exist.

````
 ✗ Debug-2 - should output Hello Alice!
   (in test file step01-hello-round-1/hello-world-test-debug.bats, line 27)
     `[ "$status" -eq 0 ]' failed with status 2
   Hello Alice!
   /tmp/bats.22504.src: line 27: [: : integer expression expected

```
As _run_ was not used, these variables are not provided to the test function.


<br>

## Imprement the script

Let's start with a very simple  implementation to check the output

```
#!/bin/bash
echo Hello $1!
```

If you forgot to give exec permissions, the next step will  be

```
✗ Debug-1 - should output Hello Alice!
   (in test file step01-hello-round-1/hello-world-test-debug.bats, line 19)
     `[ "$status" -eq 0 ]' failed
   status=126
   output=/home/cfalguiere/projects/batsTest/bats/libexec/bats-exec-test: line 58: /home/cfalguiere/projects/batsTest/bats-demo/step01-hello-round-1/hello-world.sh: Permission denied
```

Now ot's OK!

```
$ bats step01-hello-round-1/hello-world-test.bats
 ✓ should output Hello Alice!

1 test, 0 failures
```

<br>

## What we have learned

> - how to write a basic test
> - how to run a test
> - how to debug a test
