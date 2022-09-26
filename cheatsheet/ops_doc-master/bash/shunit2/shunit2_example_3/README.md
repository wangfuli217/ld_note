# shunit2_example_3

Branch|[![Travis CI logo](TravisCI.png)](https://travis-ci.org)
---|---
master|[![Build Status](https://travis-ci.org/richelbilderbeek/shunit2_example_3.svg?branch=master)](https://travis-ci.org/richelbilderbeek/shunit2_example_3)
develop|[![Build Status](https://travis-ci.org/richelbilderbeek/shunit2_example_3.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/shunit2_example_3)

[shunit2 example](https://github.com/richelbilderbeek/shunit2_examples).

## Architecture

The file `my_functions` contains the function `is_password`.

The file `my_functions_test` contains the test.

The file `run` prompts the user for a password, and displays a message dependent if the password is correct.

The file `tests` sources the tests of `my_functions_test` and `shunit2`, which triggers all tests to run.
Note: in practice this does not happen yet.
