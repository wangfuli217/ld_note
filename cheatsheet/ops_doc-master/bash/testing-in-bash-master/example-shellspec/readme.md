# ShellSpec test drive

ShellSpec is the latest and the most featureful test framework I've found for Bash. It has sexy syntax and new releases are coming up
frequently.

However, it's also pretty new, first released in 2019. I expect some rough edges to be polished and some breaking API changes here.
Also, while I really like its DSL, one has to decide if this is really his thing or not. I for one prefer BDD style for more end-user facing tests only, and I like it better if the unit tests are more similar to production code, so they can be used as concrete examples.


## Test format

There's a specific DSL built into the framework to support BDD style tests:

```bash
Describe 'lib.sh'
  Include ./lib.sh # include other script

  Describe 'calc()'
    It 'calculates'
      When call calc 1 + 1
      The output should eq 2
    End
  End
End
```

✔️ What's really interesting is that despite this DSL, files are simple Bash files. It's possible mix simple
Bash statements and functions with the DSL, so even if the DSL lacks certain features, it's usually not a limitation.

⚠️ This language looks really neat and extensible, but on the other hand it's something that one have to get used to
in order to write tests efficiently.

⚠️ Also, some features of this DSL are not on par what's achievable with Bash. For example, [currently it's only possible
to have beforeAll and afterAll functions with Bash snippets](https://github.com/shellspec/shellspec/issues/7).


## Test Discovery

✔️ The test runner considers all files as tests that are in the spec folder and their name contains "spec".
A subset of the tests can also be executed with filters, or it’s even possible to focus on a single test case.

✔️ It also expects a specific project structure, and comes with an initializer to generate that.


## Assertions

✔️ The framework provide many customizable/combinable assertions via it's DSL, and the failures generated by these assertions
contain all necessary context information.

⚠️ Assertions can not be used in all places. For example I couldn't use them in after hooks when I wanted to check a post condition
for each test. Althoug I could work around the issue with Bash snippets, it made the tests a bit harder to read.


## Custom assertions

✔️ The DSL itself is extensible with custom matchers.

⚠️ Compared with other frameworks where it's simply done by defining a function it's less straightforward.

If all else fails Bash functions can be directly called from the tests, and with that custom assertions can be implemented.
However it might have the downside that the basy code has to interface with the DSL, which might be not so convenient,
and the test code will be a mix of DSL and bash. 


## Mocking

✔️ Mocking is possible with all [three common techniques](https://github.com/dodie/testing-in-bash/tree/master/mocking):

- alias
- function export
- PATH override


## Activity

⚠️ The project is really new, it's been around since 2019. This means that the project might have some rough edges,
as some features are not polished yet. (E.g. the beforeAll functionality [was removed at one point](https://github.com/shellspec/shellspec/issues/7) because it was not ready yet.)

✔️ The project is very active, and had quite some releases over the past year. The author is active answering issues and
taking care of PRs.


## Documentation

✔️ The project has [detailed examples](https://github.com/shellspec/shellspec/tree/master/sample/spec) on how to use the framework.
Also, it has a [getting started guide](https://github.com/shellspec/shellspec/) and [website](https://shellspec.info/) covering the
basics.

✔️ The thing I like the most is the interactive help. Although it's a bit confusing at first what assertions are available in the DSL, the tool helps with interactive help when it encounters an invalid expression.

For example, I got the following error message when I tried to use the non-existent "contain" keyword:

```bash
#"The output should contain 'Total'"

Unknown word 'contain' after should verb. The correct word is one of the following.
            
     be, end, equal, eq, has, include, match, start, satisfy
```
