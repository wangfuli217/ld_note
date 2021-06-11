Contribute to Bash-Utils
========================

If you want to contribute to this project, this documentation
file will introduce you the "dev-cycle" of Bash-Utils.


Inform about a bug or request for a new feature
-----------------------------------------------

### Bug ticketing

A bug is a *demonstrable problem caused by the code* (and not due to a special user behaviour).
Bugs are inevitable and exist in all software. If you find one and want to transmit it, first
**it is very helpful** as it will participate to build a robust software.

But ... a bug report is helpful as long as it can be understood, reproduced, and that it permits to
identify the error (and what caused it). A good bug report MUST follow these guidelines:

-   **first**: search in the issue tracker if your bug has not been transmitted yet ; if you find an existing one,
    you can add a new comment to the appropriate thread with your experience if it seems different
    from the others ;
-   **then**: check if it exists right now: try to reproduce it with the current code to confirm it still exists ;
-   if you **finally** create a bug ticket, try to detail it as much as possible:
    -   what is your environment (application version, OS, device ...)?
    -   describe and comment the steps that brought you to that bug
    -   try to isolate the problem as much as possible
    -   what did you expect?

### Feature requests

If you want to ask for a new feature, please follow these guidelines:

-   the goal of this project is to be (and keep) relevant for a large public ; maybe your request
    is quite personal (you have a particular need) and can be discussed with me by email ; in this
    case please do not make a feature request (!)
-   if you think something is missing or have an idea to increase one of Bash-Utils's features, then
    you are ready for a "feature request" ; you can create an issue ticket beginning its name by
    "feature request: " ; please detail your request or your idea as much as possible, with a lot 
    of your experience.

Actually change the code
------------------------

First of all, you may do the following three things:

-   read the *How to contribute* section below to learn about forking, working and pulling,
-   from your fork of the repository, switch to the `dev` branch: this is where the dev things are done,
-   if you plan to create a module, switch to the `dev-modules` branch and read the *Create a new module* section below.

### How to contribute ?

If you want to correct a typo or update a feature of Bash-Utils, the first thing to do is
[create your own fork of the repository](http://help.github.com/articles/fork-a-repo).
You will need a (free) [GitHub](http://github.com/) account to do this and your copy will appear in your forks list.
Your work belongs to THIS repository (your own fork - you have no right to make 
direct `push` on the original repository).

Once your work seems finished, you'll have to commit it and push it on your fork (you may 
finally see your modifications on the sources view on GitHub). Then you'll have to make a 
"pull-request" to the original repository, commenting it with a description of your correction or
update, or anything you want me to know about ... Then, if your work seems ok and can be tested,
and when I'll have the time to do so (!), your work will finally be 
"merged" in the original repository and you will be able to (eventually) close your fork. 
Note that the "merge" of a pull-request keeps your name and profile as the "commiter" 
(the one who made the stuff).

**BEFORE** you start a work on the code, please check that this has NOT been done yet, or part
of it, by giving a look at <http://github.com/e-picas/bash-utils/pulls>. If you 
find a pull-request that seems to be like the modification you were going to do, you can 
comment the request with your vision of the thing or your experience and participate to that
work.

### Full installation of a fork

To prepare a development version of Bash-Utils, clone your fork of the repository and
put it on the "dev" branch:

    git clone https://github.com/<your-username>/bash-utils.git
    cd bash-utils
    git checkout dev

Then you can create your own branch with the name of your feature:

    git checkout -b <my-branch>

The development process of the package requires some external dependencies to work:

-   *Markdown-Extended*, a markdown parser: <http://github.com/e-picas/markdown-extended>
-   *BATS*, a test suite for Bash scripts: <http://github.com/sstephenson/bats>
-   *ShellCheck*, a Bash scripting validator: <http://github.com/koalaman/shellcheck>

Once you have installed them, your clone is ready.

You can *synchronize* your fork with current original repository by defining a remote to it
and pulling new commits:

    // create an "upstream" remote to the original repo
    git remote add upstream http://github.com/e-picas/bash-utils.git

    // get last original remote commits
    git checkout dev
    git pull upstream dev

As said above, all development MUST be done on the `dev` branch of the repository. Doing so we
can commit our development features to let users using a clone test and improve them.

### Create a new module

If you want to create a new module, put your fork on a new `module-NAME` branch and develop your
module in the `libexec/bash-utils-modules/` directory using the Bash-Utils internal *model* module:

    bash-utils model module <module-name>

Then create a unit-test file to test your module's features in a `test/module-NAME.bats` file.
A good practice should be to develop on a "test-driven-programming" concept:

-   the test of a feature is first written and should fail
-   the feature is developed to pass the tests

Once your module is done, ask for a pull-request to the "dev-modules" branch. It is at least up-to-date with
last "master" release.

A module is finally integrated on "master" ONLY IF IT IS WELL CODED AND PASSED ITS TESTS.

Please note that ANY module will finally be part of *Bash-Utils* and will be offered under the same 
license and copyright conditions. You can add an information about module's authors in the module itself.

How-tos
-------

The `Makefile-dev` script distributed with the sources embeds all required utilities to build, test and document
the package whith the help of (the `make` command)[https://www.gnu.org/software/make/manual/html_node/Introduction.html].

### Terminal completion

To load local *Bash-Utils* auto-completion, use:

    source libexec/bash-utils-completion

To enable the completion function for a module, use:

    _bashutils_MODULE_NAME()
    {
        export COMPMODULE='MODULE_NAME'
        _bashutils
        unset COMPMODULE
        return $?
    }
    complete -o default -F _bashutils_MODULE_NAME module-cmd

### Generate the man-pages

The manpages of the app are built with [Markdown-Extended](http://github.com/e-picas/markdown-extended).

To automatically re-generate the manpages of the package, you can use:

    make manpages

To generate them manually, you can run:

    bin/markdown-extended -f man -o man/bash-utils.1.man man/MANPAGE.1.md
    man man/bash-utils.1.man
    bin/markdown-extended -f man -o man/bash-utils.1.man man/MANPAGE.7.md
    man man/bash-utils.7.man

### Launch unit-tests

The unit-testing of the app is handled with [BATS](http://github.com/sstephenson/bats).

You can verify that your package passes all tests running:

    make tests

All tests are stored in the `test/` directory of the package and
are *Bats* scripts. See the documentation of Bats for more info.

To test the lib manually, you can run:

    bats test/*.bats

### Check coding standards errors

You can check the code common errors using [ShellCheck](http://github.com/koalaman/shellcheck)
by running:

    make code-check

The default behavior of such a validation will ignore the following rules:

-   **SC2034**: unused variables ; because of the library structure
-   **SC2016**: single quotes not expanded ; because of the error usage of functions

You can check the lib manually running:

    shellcheck --shell=bash --exclude=SC2034,SC2016 libexec/*

### Make a new release

When the work gets a stable stage, it seems to be time to build and publish a new release. This
is done by creating a tag named like `vX.Y.Z[-status]` from the "master" branch after having
merged the "dev" one in. Please see the [Semantic Versioning](http://semver.org/) work by 
Tom Preston-Werner for more info about the release version name construction rules.

You can build a new release running:

    make release VERSION=X.Y.Z

This will call first the `version X.Y.Z` and `manpages` actions of Makefile.

To make a new release of the package manually, you must follow these steps:

1.  merge the "dev" branch into "master"

        git checkout master
        git merge --no-ff --no-commit dev

2.  validate unit-tests:

        make tests

3.  bump new version number and commit:

        make version VERSION=X.Y.Z-STATE

4.  update the changelog ; you can use <https://github.com/atelierspierrot/atelierspierrot/blob/master/console/git-changelog.sh>.

5.  commit changes:

        git commit -a -m "preparing release X.Y.Z-STATE"

6.  create the release tag and publish it:

        git tag -a vX.Y.Z-STATE -m "new release ..."
        git push origin vX.Y.Z-STATE

Finally, don't forget to push all changes to `origin` and to make a release page
on GitHub's repository. The best practice is to attach the archive and a checksum to the release.

Coding rules
------------

You can inspire yourself from <http://wiki.bash-hackers.org/scripting/style>.

Keep in mind the followings:

-   use space (no tab) ; 1 tab = 4 spaces
-   comment your work (just enough)
-   in case of error, ALWAYS use the `die()` or `error()` functions with a message

Useful links
------------

-   the *Bash Guide for Beginners*: <http://tldp.org/LDP/Bash-Beginners-Guide/html/index.html> (recommended) 
-   the *Advanced Bash-Scripting Guide*: <http://tldp.org/LDP/abs/html/index.html> (recommended) 
-   the *Bash Reference Manual*: <http://www.gnu.org/software/bash/manual/html_node/index.html>
-   the *GNU Coding Standards*: <http://www.gnu.org/prep/standards/standards.html>
-   *BATS*, a test suite for Bash scripts: <http://github.com/sstephenson/bats>
-   *ShellCheck*, a Bash validator: <http://www.shellcheck.net/> (wiki: <https://github.com/koalaman/shellcheck/wiki>)
-   a well-done POSIX review: <http://shellhaters.org/>
-   the last (2008) version of *POSIX* specifications: <http://pubs.opengroup.org/onlinepubs/9699919799/>


----

If you have questions, you can (eventually) contact me at *me [at] e [dash] e-picas [dot] fr*.
