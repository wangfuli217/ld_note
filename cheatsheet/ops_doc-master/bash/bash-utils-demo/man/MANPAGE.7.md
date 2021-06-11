Man:        Bash-Utils Documentation
Man-name:   bash-utils
Author:     Pierre Cassat
Section:    7
Date: 2016-04-27
Version: 0.1.1


## USAGE

To create a script using the library, you can call the *model* argument of the library itself, which
will create a starter template script:

    bash-utils model bash-utils /path/to/your/script.sh

Actually, the only requirement to use the library is to source it in your script:

    source bash-utils --

The final double-dashes `--` are required to avoid parameters expansion when including the library.

You can also use it as your script's *interpreter* defining it in your 
[*hash bang* (*shebang*)](https://en.wikipedia.org/wiki/Shebang_%28Unix%29) line (this is the case
of the model):

    #!/usr/bin/env bash-utils

    # write your script here

You can even enable some library's flags by adding options to the *shebang*:

    #!/usr/bin/env bash-utils -v

You must separate them when using multiple flags:

    #!/usr/bin/env bash-utils -v -x

### Notes about *bash* scripting and usage

#### Use your binaries easily

To enable "per-user" binaries (let the system look in any `$HOME/bin/` directory when searching scripts), 
be sure to add that directory to the `$PATH` environment variable (in your `$HOME/.bashrc` for instance):

    # user binaries path
    [ -d "${HOME}/bin" ] && export PATH="${PATH}:${HOME}/bin";

You can name your scripts following your preferences and place it where you want as long as you can access it easily.
The file extension has no incidence upon the script's type (*bash* in our case) as the interpreter is designed by the 
[**shebang** directive](https://en.wikipedia.org/wiki/Shebang_%28Unix%29) ; you could name your script with an 
`.sh`, a `.bash` and even a `.py` extension (which would have no real sense here) or let it without extension 
at all with no difference.

#### Scripts terminal usage

A command-line program (such as a shell script) often accepts to set some options and arguments calling it in a terminal
or another script. A global synopsis of a command line call can be:

    path/to/script [-o | --options (=argument)] [--] [<parameter> ...]
    # e.g.:
    program-to-run -o --option='my value' --option-2 'my value' argument1 argument2

The rules are the followings:

-   *options* are various settings passed to the script when calling it ; each option is prefixed by one or more dash `-` 
    and can have an argument ; by convention, a short option is composed by one single letter prefixed by one dash, e.g. `-o`, 
    and a long option is composed by a word prefixed by two dashes, e.g. `--option` ; when an option accepts an argument, 
    it must be separated from the option name by an equal sign, e.g. `--option=argument` and `-o=argument` ; e.g. 
    `./script -o --option-with-no-arg --option-with-arg=argument_value`
-   a double dashes ` -- ` can be used to identify the end of options ; the rest of the call will be considered as arguments
    only
-   an *argument* is a setting passed to the script when calling it ; the arguments are not the same as the options as 
    they are not named but identified by their positions ; e.g. `./script --option argument1 argument2`

#### Commands vs. builtins

*Bash* proposes a large set of **builtins** "commands", which must be differentiated from *external commands*. The bash 
builtins are always available in any bash environment while external commands must be installed on the system to work.
If you have a doubt about a command, you can verify running `type <command-name>`, which will respond `... is a shell builtin`
for builtins. If you have the choice, you should always prefer a builtin rather than an external command, unless you
are absolutely sure it is present on all UNIX installations.

To get the help about an external command, you can read its *manpage*:

    man <command-name>

To get the help about a builtin, you may use `help`:

    help <builtin>

### Starter template

Below is a very simple starter template of a script using the library:

    #!/usr/bin/env bash-utils
    # reset bash options here if needed
    # set +E
    
    # write your scripts logic here
    # ...
    
    # a script should always return a status
    exit 0

You should use the *model* module for a more complex template:

    bash-utils model bash-utils

### Customize your script

To build your own command, you may first override informational variables:

    CMD_NAME=...
    CMD_VERSION=...
    CMD_COPYRIGHT=...
    CMD_LICENSE=...
    CMD_SOURCES=...
    CMD_DESCRIPTION=...
    CMD_SYNOPSIS=...
    CMD_HELP=...
    CMD_OPTS_SHORT=(...)
    CMD_OPTS_LONG=(...)
    CMD_ARGS=(...)
    #CMD_SYNOPSIS=...
    CMD_USAGE=...

Then you can customize script's options (see below) to fit your needs and write your script's logic in the last
part of the model.

## DOCUMENTATION

### Library's methods

The library embeds a short set of methods to facilitate your scripts:

-   the `die()` method will exit with an error message and a back trace, all to STDERR
-   the `error()` method will exit with an error message to STDERR (user friendly)
-   the `warning()` method will write an error message to STDERR (without exiting the script)
-   the `try()` method will emulate a *try/catch* process by calling a sub-command catching its result

Errors are handled by the `die()` method (using the *trap* built-in command - see the *Technical points* section below).

A special *options* and *arguments* handling is designed to rebuild the input command and follow special treatments
for default options and arguments. To use this, add in your script:

    rearrange_options "$@"
    [ -n "$CMD_REQ" ] && eval set -- "$CMD_REQ";
    common_options "$@"

You can **override any method** by re-defining it after having sourced the library:

    source bash-utils -- || { echo "> ${BASH_SOURCE[0]}:${LINENO}: bash-utils not found!" >&2; exit 1; };
    
    error() {
        # your custom error handler
    }

The best practice is to create user methods instead of overload native ones and call them:

    source bash-utils -- || { echo "> ${BASH_SOURCE[0]}:${LINENO}: bash-utils not found!" >&2; exit 1; };
    
    user_error() {
        # your custom error handler
    }
    
    [ -f filename ] || user_error 'file not found';

### Script's options

Default options handled by the library are:

-   **-q** | **--quiet**: enables the `$QUIET` environment variables ; this should decrease script's output (only errors or
    required output should be returned) ; this option disables the `$VERBOSE` environment variable
-   **-v** | **--verbose**: enables the `$VERBOSE` environment variable ; this should increase script's verbosity (inform
    user about what is happening) ; this option disables the `$QUIET` environment variable
-   **-f** | **--force**: enables the `$FORCE` environment variable ; this should let the user to choose all default behaviors
    in case a choice is required (no prompt running the script)
-   **-x** | **--debug**: enables the `$DEBUG` environment variable ; this should drastically increase script's verbosity
    (verbosity should be one level more than in `$VERBOSE` mode)
-   **--dry-run**: enables the `$DRY_RUN` environment variable ; this should not do sensible stuff but inform user about
    what should be done

The library also handles those informational options:

-   **-V** | **--version** to get the name and version number of the script
-   **-h** | **--help** to get the full help information of script's usage

The output of the informational arguments listed above are constructed using the `CMD_...` environment
variables you may define for each script (see the *Customize your script* section above).

These options are handled by the *getopt* program. You can add your own options by overriding the following variables:

    CMD_OPTS_SHORT=(f h q v V x)
    CMD_OPTS_LONG=(debug dry-run force help quiet verbose version)

The `CMD_OPTS_...` definitions are used to build auto-completion.

By default, the `common_options()` method will throw en error if an unknown option is met. You can avoid this behavior
by prefixing the `CMD_OPTS_SHORT` by a colon `:`:

    CMD_OPTS_SHORT=(':' f h q v V x)

For each option added, you MUST define your own treatment for it in a parsing loop:

    while [ $# -gt 0 ]; do
        case "$1" in
            # do not throw error for common options
            -f | -h | -q | -v | -V | -x | --force | --help | --quiet | --verbose | --version | --debug | --dry-run ) true;;
            # user option
            -o | --my-option )
                OPTARG="$(echo "$2" | cut -d'=' -f2)"
                MYVAR="${OPTARG:-default}"
                shift
                ;;
        esac
        shift
    done

In your script, you can use a flag like:

    $FLAG && ...; # do something when FLAG is ENABLED
    $FLAG || ...; # do something when FLAG is DISABLED

Due to known limitations of the *getopt* program, you should always use an equal sign between 
an option (short or long) and its argument: `-o=arg` or `--option=arg`, even if that argument is required.

### Script's arguments

Arguments can be handled in the same logic as options:

-   you may first define them in the `CMD_ARGS` array, with a trailing double point if it requires a second argument,
and two double points if it can accept a second argument:

        CMD_ARGS=('argument:' 'arg2::' arg3)

-   then, once you have looped (and shifted) over all options, you can loop over arguments:

        case "$1" in
            ...
        esac

The `CMD_ARGS` definition is used to build auto-completion.

### Technical points

The library enables the following *Bash* options by default:

-   `posix`: match the POSIX 1003.2 standard
-   `expand_aliases`: allow to use aliases in scripts
-   `allexport`: export all modified variables
-   `errexit`: exit if a command has a non-zero status
-   `errtrace`: trap on ERR are inherited by shell functions
-   `pipefail`: do not mask pipeline's errors
-   `nounset`: throw error on unset variable usage
-   `functrace`: trap on DEBUG and RETURN are inherited by shell functions

Run `help set` for a full list of bash *set* built-in available options. 

Moreover, the library *trap* errors and early exits signals to the `die()` function to display an error string and
stack trace in each case. It also defines a `shutdown_handler()` method trapped at the end of the process; you can 
redefine this function with your own logic to make a cleanup at the end of each run.

To make robust scripts, here are some reminders:

-   to use a variable eventually unset: `echo ${VARIABLE:-default}` and `echo ${VARIABLE[*]:-}`
-   to make a silent sub-command call: `val=$(sub-command 2>/dev/null)`

## FILES

*bin/bash-utils* | **libexec/bash-utils**
:   This is the "entry point" of *Bash-Utils* ; it should be available in one of the `$PATH` paths for all users ;
it acts like a loader of the library and a script's interpreter you can use as a script's *shebang*.

**libexec/bash-utils-core**
:   This is the core of *Bash-Utils* ; it mostly defines required functions and environment variables for the library
to work by itself and to handle its modules ; it uses almost only bash *builtins*.

**libexec/bash-utils-lib**
:   This is the library of functions ; it embeds various useful functions and variables commonly used in *bash* scripts.

**libexec/bash-utils-cmd**
:   This is the script that handles default parameters and actions of *Bash-Utils* when you call it directly.

**libexec/bash-utils-modules/**
:   This is the directory where modules are stored ; each module is a single script in that directory ; a module is
identified by its filename.

**etc/bash_completion.d/bash-utils-completion**
:   This is the script that handles terminal completion for the library (core and modules).

## SEE ALSO

Online *bash* scripting guides and tools:

-   the *Bash Guide for Beginners*: <http://tldp.org/LDP/Bash-Beginners-Guide/html/index.html> (recommended) 
-   the *Advanced Bash-Scripting Guide*: <http://tldp.org/LDP/abs/html/index.html> (recommended) 
-   the *Bash Reference Manual*: <http://www.gnu.org/software/bash/manual/html_node/index.html>
-   the *GNU Coding Standards*: <http://www.gnu.org/prep/standards/standards.html>
-   *BATS*, a test suite for Bash scripts: <http://github.com/sstephenson/bats>
-   *ShellCheck*, a Bash validator: <http://www.shellcheck.net/>

bash(1), bash-utils(1), getopt(1)
