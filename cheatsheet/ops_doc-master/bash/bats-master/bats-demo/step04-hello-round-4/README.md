# Unit testing Hello World with Bats - Round 4

After the demo, user were happy. They feel the need for a usage of this beautiful program.

> **focus of this section**
> checking output spanning on multiple lines
> organizing tests in multiple files
> run a test suite


## Specifications for Round 4

Existing specifications


- The script must output Hello x! where x stand for the name given as a parameter
- When no name is provided the script should result in errors


Additional specifications

- Whenever the script is called without parameters or wrong parameters, it should state why the program failed and print the usage



## New test file

I will not change the arguments for now.


As this specification is more about how to deal with parameters, I've started a new test file named [hello-world-parameters-test.bat](hello-world-parameters-test.bat). Old test file has also been renamed.


The new test file contains the lines below

```
# file hello-world-parameters-test.bat
#!/usr/bin/env bats

@test "When no parameter is provided should exit with 1" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  [ "$status" -eq 1 ]
}

@test "When no parameter is provided should output the usage" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  [ "$output" = "Usage: hello-world.sh <name>" ]
}
```

The first test is fine but it fails the second check because the code has not been fixed yet.

```
$ bats step04-hello-round-4/hello-world-parameters-test.bats
 ✓ When no parameter is provided should exit with 1
 ✗ When no parameter is provided should output the usage
   (in test file step04-hello-round-4/hello-world-parameters-test.bats, line 13)
     `[ "$output" = "Usage: hello-world.sh <name>" ]' failed

2 tests, 1 failures
```

Here is the script rewritten to allow multiple checks. The code now use a table and add error message for each test. If there are error messages it shows all the message errors


````
#!/bin/bash
errors=()
[[ $# -ne 1 ]] && errors+="Usage: $0 <name>"

name=$1
[[ -z $name ]] && errors+="No name provided. Name is mandatory!"

[[ -z ${errors[@]} ]] || { for i in ${errors[@]}; do echo "$i"; done; exit 1; }

echo "Hello $name!"
`````


Well, Rome wasn't build in a day ...


````
$ bats step04-hello-round-4/hello-world-parameters-test.bats
 ✓ When no parameter is provided should exit with 1
 ✗ When no parameter is provided should output the usage
   (in test file step04-hello-round-4/hello-world-parameters-test.bats, line 14)
     `[ "$output" = "Usage: hello-world.sh <name>" ]' failed

2 tests, 1 failures
````

Adding an debug trace in the test shows that the output contains both messages and words of the messages are issued on multiple lines.

````
@test "When no parameter is provided should output the usage" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  echo "output=$output"
  [ "$output" = "Usage: hello-world.sh <name>" ]
}
````

````
 ✗ When no parameter is provided should output the usage
   (in test file step04-hello-round-4/hello-world-parameters-test.bats, line 14)
     `[ "$output" = "Usage: hello-world.sh <name>" ]' failed
   output=Usage:
   /home/cfalguiere/projects/batsTest/bats-demo/step04-hello-round-4/hello-world.sh
   <name>No
   name
   provided.
   Name
   is
   mandatory!
```

To focus on the usage message, the test must be rewritten. The script report the usage on first line. Then the test may be rewritten as shown below.

```
@test "When no parameter is provided should output the usage on first line" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  echo "line_0=${lines[0]}"
  [ "${lines[0]}" = "Usage: hello-world.sh <name>" ]
}
```

The variable _output_ contains all the lines yield by the script. The array _lines_ contain the same information but each line in a row.


The old test is skipped for the time being. This instruct Bats to ignore this tests.

We want to focus on test that could pass while we are debugging. We will fix this later.

```
@test "When no parameter is provided should output the usage" {
  skip
  run $BATS_TEST_DIRNAME/hello-world.sh
  echo "output=$output"
  [ "$output" = "Usage: hello-world.sh <name>" ]
}
```

Now you can see that the second test is marked as skipped and the third fails.  The first lines contains only the first word of the message.

```
cfalguiere@ip-172-31-30-150:~/projects/batsTest/bats-demo$ ../bats/bin/bats step04-hello-round-4/hello-world-parameters-test.bats
 ✓ When no parameter is provided should exit with 1
 - When no parameter is provided should output the usage (skipped)
 ✗ When no parameter is provided should output the usage on first line
   (in test file step04-hello-round-4/hello-world-parameters-test.bats, line 21)
     `[ "${lines[0]}" = "Usage: hello-world.sh <name>" ]' failed
   line_0=Usage:

3 tests, 1 failure, 1 skipped
```

The word split is caused by a mistake in the script.

The array expansion list the content of the array. However, quoting the expansion preserve the array items while the non quoted version end up with a list of words. Pay attention to the spacing in the example below.

```
$ export a1=( "aa    aa" "bb    bb" )
$ echo  ${a1[@]}
aa aa bb bb
$ echo  "${a1[@]}"
aa    aa bb    bb
````

The script is altered to change this behavior.

```
#[[ -z ${errors[@]} ]] || { for i in ${errors[@]}; do echo "$i"; done; exit 1; }
[[ -z ${errors[@]} ]] || { for i in "${errors[@]}"; do echo $i; done; exit 1; }
```


There are some progress. The text is no more splitted by words but both messages are on the same line. But it looks like there is only one item in the array.

```

cfalguiere@ip-172-31-30-150:~/projects/batsTest/bats-demo$ ../bats/bin/bats step04-hello-round-4/hello-world-parameters-test.bats
 ✓ When no parameter is provided should exit with 1
 - When no parameter is provided should output the usage (skipped)
 ✗ When no parameter is provided should output the usage on first line
   (in test file step04-hello-round-4/hello-world-parameters-test.bats, line 21)
     `[ "${lines[0]}" = "Usage: hello-world.sh <name>" ]' failed
   line_0=Usage: /home/cfalguiere/projects/batsTest/bats-demo/step04-hello-round-4/hello-world.sh <name>No name provided. Name is mandatory!

3 tests, 1 failure, 1 skipped
```

This is caused by another mistake when adding the message into the array.

Let's check the example below.

````
$ export a2=()
$ a2+="aaa"
$ a2+="bbb"
$ for i in "${a2[@]}"; do echo $i; done
aaabbb
$ a2+=("ccc")
$ for i in "${a2[@]}"; do echo $i; done
aaabbb
ccc
$ a2+="ddd"
$ for i in "${a2[@]}"; do echo $i; done
```

The += concatenate arrays. The used with a string as a right side operand it concatenates the string to the first item.

After the messages has been fixed as below there is only one message.

````
#[[ $# -ne 1 ]] && errors+="Usage: $0 <name>"
[[ $# -ne 1 ]] && errors+=("Usage: $0 <name>")
```

```
$ bats step04-hello-round-4/hello-world-parameters-test.bats
 ✓ When no parameter is provided should exit with 1
 - When no parameter is provided should output the usage (skipped)
 ✗ When no parameter is provided should output the usage on first line
   (in test file step04-hello-round-4/hello-world-parameters-test.bats, line 21)
     `[ "${lines[0]}" = "Usage: hello-world.sh <name>" ]' failed
   line_0=Usage: /home/cfalguiere/projects/batsTest/bats-demo/step04-hello-round-4/hello-world.sh <name>

3 tests, 1 failure, 1 skipped
```

The test does not expect the full path to the command. There are many options from a hardcoded name to a combination of readlink and basename.


Ok, after some adjustments not more failing test shows up.

```
$ bats step04-hello-round-4/hello-world-parameters-test.bats
 ✓ When no parameter is provided should exit with 1
 - When no parameter is provided should output the usage (skipped)
 ✓ When no parameter is provided should output the usage on first line

3 tests, 0 failures, 1 skipped
````

But, wait a minute, the slipped test is still there. A valid option is to remove this test. The line_0 test checks the message.

Another option is to check whether the output contains the message.

```
@test "When no parameter is provided should contain the usage" {
  run $BATS_TEST_DIRNAME/hello-world.sh
  #[ "$output" = "Usage: hello-world.sh <name>" ]
  [[ "$output" =~ "Usage: hello-world.sh <name>" ]]
}
```

The =~ operator checks whether the string on the left side matched the regex on the right side. This operator is only defined in test v2. Thus the double brackets must be used.


Now it works as expected.

```
cfalguiere@ip-172-31-30-150:~/projects/batsTest/bats-demo$ ../bats/bin/bats step04-hello-round-4/hello-world-parameters-test.bats
 ✓ When no parameter is provided should exit with 1
 ✓ When no parameter is provided output should contain the usage
 ✓ When no parameter is provided should output the usage on first line

4 tests, 0 failures, 0 skipped
```

Let's give a try to the program

````
$ ./step04-hello-round-4/hello-world.sh
Usage: hello-world.sh <name>
No name provided. Name is mandatory!
````

Is it done ?

Well .... No

Remember. We have splitted the tests in two different files.

What if I run all the tests in the test suite ?

````
$ bats step04-hello-round-4
 ✓ should output Hello Alice!
 ✓ should output Hello Jabberwock!
 ✓ should output Hello Cheshire Cat! when names has many words
 ✓ When no name is provided should exit with 1
 ✗ When no name is provided should output name is mandatory
   (in test file step04-hello-round-4/hello-world-names-test.bats, line 46)
     `[ "$output" = "No name provided. Name is mandatory!" ]' failed
   output=Usage: hello-world.sh <name>
   No name provided. Name is mandatory!
 ✓ When no parameter is provided should exit with 1
 ✓ When no parameter is provided output should contain the usage
 ✓ When no parameter is provided should output the usage on first line

8 tests, 1 failure, 0 skipped
````

Bats may run a test file, a list of test files or a folder.

When Bats it runs against a folder, all the files having the extension .bats are run. Bats does no scan subdirectories.


The other test file need be updated as well because output now has two lines.

````
$ bats step04-hello-round-4/hello-world-names-test.bats
 ✓ should output Hello Alice!
 ✓ should output Hello Jabberwock!
 ✓ should output Hello Cheshire Cat! when names has many words
 ✓ When no name is provided should exit with 1
 ✓ When no name is provided output should contain name is mandatory

5 tests, 0 failures
````

Now the round is done.

<br>

## What we have learned

- how to organize tests in different files
- how to test output spanning on multiple lines
- how to test output on a specific line
- how to skip a test
- how to run a test suite by listing the files or running the test folder
