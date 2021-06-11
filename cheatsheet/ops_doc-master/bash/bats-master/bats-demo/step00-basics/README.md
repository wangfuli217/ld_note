# Bats basics


## What is Bats ?

When you're used to unit testing your code, writing shell script and maintaining a bunch of shell scripts might be very uncomfortable. Bats helps by providing a test tool similar to RSpec.


**Bats** stands for **Bash Automated Testing System**.

> Bats is a TAP-compliant testing framework for Bash. It provides a simple way to verify that the UNIX programs you write behave as expected.
>
>A Bats test file is a Bash script with special syntax for defining test cases. Under the hood, each test case is just a function with a description.
>
>-- [Bats project (github repository)](https://github.com/sstephenson/bats)

<br>

I've found interessing resources listed at the end of this page. However I've decided to make my own for two reasons

- gather all the resources I've found useful in one place
- document some use cases I've found difficult to understand, especially if you're not an skilled shell programmer.


This document is an introduction to Bats basics. The following steps show Bats in action on a basic use case and show more advanced examples. But fot the time being let's run a very basic example.

<br>

**_So let's go!_**
<br>

<br>

## A very basic example of Bats test

Here is a very simple Bats test


```
# file simple-echo-test.bats
#!/usr/bin/env bats

@test "simple-echo should output foo" {
  run simple-echo.sh  "foo"
  [ "$status" -eq 0 ]
  [ "$output" = "foo" ]
}
```

<br>

## Anatomy of a Bats test

Bats tests often follow the  pattern described below

<br>

### **_Test block_**


A Bats test has the following structure

- **@test**: this keyword tells Bats that there is a test here
- **a description**: for instance "simple-script should output foo"
- **a function**: whatever code lies within curly braes { }

Bats will report success or failuure depending on the result of this function. You might use any kind of code. For instance, if the function only consists of the call to the script and the script fails, Bats will report a failure.

A Bats test file may contain multiple _@test_ blocks

<br>

### **_Test function_**

A typical Bats test use the following pattern

- **_run_**: an optional wrapper used to collect information
- **a function or program under test**: for instance simple-script.sh  "foo"
- **some checks**

These checks are any command which result in true or false.
A typical check makes use of the [test command](http://manpages.ubuntu.com/manpages/xenial/man1/test.1.html).

You may use whatever kind of check you're used to, for instance [ -z "$varname" ] or [ -f "$filename" ] to check whether a variable is empty or whether a file exists.

Keep in mind that this is a plain shell function. You may intialize variables or use conditional instructions if need be.

<br>

### **_run wrapper_**

Bats provides some helpers to ease testing.

Run yields 3 variables upon execution of the function or program under test.

- **status**: the exit code
- **output**: the outputt of the functio or program. it collects stdout and stderr
- **lines**: an array consisting of each line of the output

These variables requires the use of the _run_ wrapper.

<br>

## Bats test execution

When you run the test file, Bats outputs a pretty human readable test report.


```
$ bats simple-echo-test.bats
 ✓ simple-echo should output foo

1 tests, 0 failures
```


However, this report might be tricky to analyze when running in an automated tool or CI tool. Hopefully, Bats provides a _--tap_ option.

```
$ bats --tap simple-echo-test.bats
1..1
ok 1 simple-echo should output foo
```

With this option, Bats produce a formatted report

- the **first line** shows the range of test numbers (for instance 1..4 when the file contains 4 tests)
- **each line** shows ok or not ok, the test number, the test description


<br>

## Test failuures report


When a test fails, Bats shows the output of the program and an error report.


For instance, let's write a simple script to print a file and call it with a wrong file


```
# file simple-cat-test.bats
#!/usr/bin/env bats

@test "simple-cat should output the content of the file" {
  run simple-cat.sh foofile
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "foo" ]
}

```

Bats report the error reported by the script execution


```
$ bats  test.bats
 ✗ simple-cat should output the content of the file
   (in test file simple-cat-test.bats, line 4)
     `simple-cat.sh  foofile'  failed
   cat: foo: No such file or directory

1 test, 1 failure
```


Bats with TAP option which makes it easier to use in a CI tool

```
$ /bats --tap  simple-cat-test.bats
1..1
not ok 1 simple-cat should output the content of the file
# (in test file simple-cat-test.bats, line 4)
#   `simple-cat.sh foofile' failed
# cat: foo: No such file or directory
```

<br>

## Bats resources

Bats project
- [Bats project (github repository)](https://github.com/sstephenson/bats)
- [Bats prokect's Wiki](https://github.com/sstephenson/bats/wiki)

Some other useful resources:

- [Bats manual (Ubuntu version)](http://manpages.ubuntu.com/manpages/yakkety/man7/bats.7.html)
- https://blog.engineyard.com/2014/bats-test-command-line-tools
- https://medium.com/@pimterry/testing-your-shell-scripts-with-bats-abfca9bdc5b9
- http://blog.spike.cx/post/60548255435/testing-bash-scripts-with-bats

Thanks to the authors of Bats and all of these posts where I found useful examples and explanations.


