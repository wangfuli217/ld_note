Bash-Utils - Utilities for Bash scripting
=========================================

[![Build Status](https://travis-ci.org/e-picas/bash-utils.svg)](https://travis-ci.org/e-picas/bash-utils)

The `Bash-Utils` command is a small library of utilities to quickly build robust and complete
[Bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) scripts.
It proposes a set of useful functions and environment variables in an enhanced environment with some system options enabled by default,
to let you build a script with user options and arguments, an automatic generation of some informational output about 
the script's usage (version, help etc), a special handling of errors, stack trace and debugging, and some more features.
The library also embeds and proposes a set of *modules* you can use as-is ; 
see the [`libexec/bash-utils-modules/`](libexec/bash-utils-modules/) directory.

The library is licensed under an [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0) and
is fully "unit-tested" using [BATS](http://github.com/sstephenson/bats) to keep it as robust as possible.


Key features
------------

-   handling of some common options with associated behaviors: *verbose*, *quiet*, *force*, *help*, *version* ...
-   handling of errors with information about what throws it or where it was thrown
-   some debugging information (enabled by default) with a *stack trace* in case of process or sub-processes errors
-   generation of an automatic *synopsis* of the script based on declared available options (shorts and longs, with or 
    without arguments)
-   generation of some help and version strings for the script based on declared variables
-   a set of commonly used functions about *booleans*, *integers*, *strings*, *arrays* and *file system*


Installation
------------

To make the library accessible for all users, the best practice is to install it in a global path like `/usr/local/bin/`:

    make install DESTDIR=/usr/local/bin

This way, any user can use it in its scripts by *sourcing* it:

    source bash-utils

For a full download and installation from the command line, run:

    wget --no-check-certificate https://github.com/e-picas/bash-utils/archive/master.tar.gz
    tar -xvf master.tar.gz
    cd bash-utils*
    make install DESTDIR=/usr/local/bin

You can use the `make` command to clean-up an installed library or update it ; to get a full usage, run `make`.


Starter template
----------------

To load the library, the best practice is to use it as your script's *interpreter* defining it as your 
[*shebang*](https://en.wikipedia.org/wiki/Shebang_%28Unix%29): 

    #!/usr/bin/env bash-utils
    
    # write your script here
    # ...

To let such notation work correctly, the *bash-utils* script must be accessible from your `$PATH` variable.
To check this, use: `/usr/bin/env bash-utils --version`.

If you prefer use a classic *shebang*, you just have to load the library by *sourcing* it:

    #!/usr/bin/env bash
    source bash-utils -- # keep the trailing double-dash to avoid parameter expansion
    
    # write your script here
    # ...

The library embeds a *model* module you can use as a more complex starter template:

    bash-utils model bash-utils ~/bin/name-of-your-script


Usage
-----

For a documentation of the library, please see the [documentation manpage](man/MANPAGE.7.md).

For a complete review of the library's usage, please see the [usage manpage](man/MANPAGE.1.md).

If you want to test the library locally, you need to install its binary in one of your `$PATH` directory
(it will be replaced if you finally install the library):

    ln -s "$(pwd)/bin/bash-utils" /usr/local/bin/
