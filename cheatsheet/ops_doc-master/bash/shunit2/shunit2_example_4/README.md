# shunit2_example_4

Branch|[![Travis CI logo](TravisCI.png)](https://travis-ci.org)
---|---
master|[![Build Status](https://travis-ci.org/richelbilderbeek/shunit2_example_4.svg?branch=master)](https://travis-ci.org/richelbilderbeek/shunit2_example_4)
develop|[![Build Status](https://travis-ci.org/richelbilderbeek/shunit2_example_4.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/shunit2_example_4)

[shunit2 example](https://github.com/richelbilderbeek/shunit2_examples) after [this issue](https://github.com/kward/shunit2/issues/52#issue-226638329).

## Architecture

The file `my_functions` contains the function `is_a` and `is_b`.

The file `is_a_test` contains the test for `is_a`.
The file `is_b_test` contains the test for `is_b`.

The file `run` prompts the user for an `a` and a `b`, and displays a message dependent if the values are `a` and `b`.

The file `tests` sources the tests of `my_functions_test` and `shunit2`, which triggers all tests to run.
Note: in practice this does not happen yet.
