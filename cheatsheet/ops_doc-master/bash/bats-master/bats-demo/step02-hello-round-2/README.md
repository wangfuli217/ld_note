# Unit testing Hello World with Bats - Round 2

Now it's OK, what additionnal tests do I need ?

> **focus of this section**
> adding new tests
> understand why tests are useful


<br>

## Question time

- Does it wotk for another name (just in case Alice were hardcoded) ?
- Does it wotk for composite names ?
- What do I expect when this script is called without parameter ?

I ended up with a new test file [here](hello-world-test.bats).


Let's run

```
$ bats step02-hello-round-2/hello-world-test.bats
 ✓ should output Hello Alice!
 ✓ should output Hello Jabberwock!
 ✗ should output Hello Cheshire Cat! when name has many words
   (in test file step02-hello-round-2/hello-world-test.bats, line 27)
     `[ "$output" = "Hello Cheshire Cat!" ]' failed
 ✗ should output Hello!
   (in test file step02-hello-round-2/hello-world-test.bats, line 45)
     `[ "$output" = "Hello!" ]' failed

4 tests, 2 failures
```

With a few extra traces, here what is happening

````
$ bats step02-hello-round-2/hello-world-test.bats
 ✓ should output Hello Alice!
 ✓ should output Hello Jabberwock!
 ✗ should output Hello Cheshire Cat! when name has many words
   (in test file step02-hello-round-2/hello-world-test.bats, line 28)
     `[ "$output" = "Hello Cheshire Cat!" ]' failed
   output=Hello Cheshire!
 ✗ should output Hello!
   (in test file step02-hello-round-2/hello-world-test.bats, line 47)
     `[ "$output" = "Hello!" ]' failed
   output=Hello !

4 tests, 2 failures
```

Third test is a false negative. The test should call hello-world.sh  "Cheshire Cat" in order to pass only one parameter.

Fourth test is a true negative. As the variable is not checked, the space is always issued.

Let's change the echo for "echo Hello$([ -z $1 ] || echo $1)!". When the parameter is empty it does nothing, otherwize it echoes the parameter

```
$ bats step02-hello-round-2/hello-world-test.bats
 ✗ should output Hello Alice!
   (in test file step02-hello-round-2/hello-world-test.bats, line 11)
     `[ "$output" = "Hello Alice!" ]' failed
 ✗ should output Hello Jabberwock!
   (in test file step02-hello-round-2/hello-world-test.bats, line 19)
     `[ "$output" = "Hello Jabberwock!" ]' failed
 ✗ should output Hello Cheshire Cat! when name has many word
   (in test file step02-hello-round-2/hello-world-test.bats, line 28)
     `[ "$output" = "Hello Cheshire Cat!" ]' failed
   output=HelloCheshire!
 ✓ should output Hello!

4 tests, 3 failures
````

Though it works fine for the last, it fails the first one. Guess why ?

The trace of the third test show why. The space is now missing.

After fixing the space the script is now

```
#!/bin/bash
echo Hello$([ -z $1 ] || echo " $1")!
```


````
$ bats step02-hello-round-2/hello-world-test.bats
 ✓ should output Hello Alice!
 ✓ should output Hello Jabberwock!
 ✗ should output Hello Cheshire Cat! when name has many words
   (in test file step02-hello-round-2/hello-world-test.bats, line 37)
     `[ "$output" = "Hello Cheshire Cat!" ]' failed
   output=/home/cfalguiere/projects/batsTest/bats-demo/step02-hello-round-2/hello-world.sh: line 2: [: Cheshire: binary operator expected
   Hello Cheshire Cat!
 ✓ should output Hello!

4 tests, 1 failures
````

Same problem occurs on CLI. Weirdly enough, the output is correct, but there is an error message on the way.

````
$ bash -x ./step02-hello-round-2/hello-world.sh "Cheshire Cat"
++ '[' -z Cheshire Cat ']'
./step02-hello-round-2/hello-world.sh: line 2: [: Cheshire: binary operator expected
++ echo ' Cheshire Cat'
+ echo Hello Cheshire 'Cat!'
Hello Cheshire Cat!
`````

It sounds like the test is wrong. The variable has been expanded into two words and -z expects only one argument/

The script is now

```
#!/bin/bash
echo Hello$([ -z "$1" ] || echo " $1")!
```

and all tests pass.

````
$ bats step02-hello-round-2/hello-world-test.bats
 ✓ should output Hello Alice!
 ✓ should output Hello Jabberwock!
 ✓ should output Hello Cheshire Cat! when names has many words
 ✓ should output Hello!

4 tests, 1 failure
````

I can now demo my work and get feedback from users.


<br>

## What we have learned

> - why testing with different values is useful
> - how to find new tests
