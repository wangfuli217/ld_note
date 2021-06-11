Man:        Piwi Bash Library Manual
Man-name:   piwi-bash-library
Author:     Pierre Cassat
Date: 2014-12-20
Version: 0.2.0


## NAME

Piwi-Bash-Library - An open source day-to-day bash library.

## SYNOPSIS

**piwi-bash-library-script** [*common options*] [*script options* [=*value*]] (*--*) [*arguments*] (*--*)

**piwi-bash-library-script**  [**-h**|**-V**]  [**-x**|**-v**|**-i**|**-q**|**-f**]
    [**--help**|**--usage**|**--man**]
    [**--force**|**--help**|**--interactive**|**--quiet**|**--verbose**|**--debug**|**--dry-run**]
    [**--version**|**--libversion**]
    [**--logfile** *=filename*] [**working-dir** *=path*]
        [*script options ...*]  (--)  [*arguments ...*]

**piwi-bash-library-script**  [*common options*] 
    [**-t**|**--target** *=path*]  [**--local**]
    [**-b**|**--branch** *=branch*]  [**-r**|**--release** *=version*]
    [**-p**|**--preset** *=(default dev user full)*]
    [**-e**|**--exec** *='string to eval'*]
        help | usage
        version
        check
        install
        update
        uninstall
        documentation
        clean 

## DESCRIPTION

**Bash**, the "*Bourne-Again-SHell*", is a *Unix shell* written for the GNU Project as a
free software replacement of the original Bourne shell (sh). The present library is a tool
for Bash scripts facilities. To use the library, just include its source file using:
`source path/to/piwi-bash-library.bash` and call its methods.

The library is NOT a script doing some work itself except dealing with a copy of the library
; it is just a library. This manual explains the library itself, its options and
usage methods but you MAY keep in mind that the final manual page to read is the one of
the real script you will call, using the tools of the library to build its own work. See the
"*Interface*" section of this manual for information about the library interface (when calling
it directly).

The following features are available using the library:

-   some common methods to work with *strings*, *integers*, *files* and *arrays*
-   a management of information messages like *warnings* and *errors*
-   a management of a simple *help or usage information* for each script (just defining some variables
    in the script)
-   the creation of some *colorized and stylized content* for terminal output: some methods are designed
    to wrap a string between colored or styled tags, according to the current system,
    and to build a colorized content using XML-like tags (`<mytag>my content</mytag>`)
-   a management of a *configuration dotfile* for a script: some methods allow you to read, write,
    update and delete configuration values in a file
-   a management of *temporary files* and *log files*
-   a management of *script's options and arguments* (re-arrangement, loop etc)
-   a set of *common options* (described in next "*Options*" section) to let the user interact
    with the script, such as increase or decrease verbosity, make a dry run, ask to force 
    commands or to always prompt for confirmation

For the library source code and messages outputs, we mostly try to follow the
[GNU coding standards](http://www.gnu.org/prep/standards/standards.html) to keep user in
a known environment ...

For a complete information and a documentation, see <http://github.com/piwi/bash-library/wiki/>.

## INTERFACE

When calling the library script itself from the command line, a user interface is available to
deal (install/update/uninstall) with a copy of the library locally or globally in your 
system (3rd synopsis form). To start with this interface, you can run:

    path/to/piwi-bash-library.bash (--less) help

A basic synopsis of the interface is:

    path/to/piwi-bash-library.bash -[common options] --target=path --preset=default action-name

See the "*Options*" section below for specific options usage.

### The following actions are available:

**check**
:   check if your library is up-to-date

**documentation**
:   see the library documentation ; use option **verbose** to increase verbosity ; you can
add an `md` prefix to get the documentation in Markdown format (**mddocumentation**)

**help** and **usage**
:   get an 'help' and 'usage' information about the library

**install**
:   install a copy of the library locally or in your system

**uninstall**
:   uninstall a copy from a system path

**update**
:   update the library with a newer version if so ; this will update the MINOR version

**version**
:   get the version information about the library ; use option **quiet** to get only
the version number (alias of **libversion**)

## OPTIONS

Each script depending on the library may define its own options. Please report to the script's
manpage or help string for more information.

### The following common options are supported:

**--dry-run**
:    see commands to run but do not run them actually ; this will define the environment variables 
*DRYRUN* on *true* and *INTERACTIVE* and *FORCED* on *false*

**-f**, **--force**
:    force some commands to not prompt confirmation ; this will define the environment
variables *FORCED* on *true* and *VERBOSE* and *DEBUG* on *false*

**-h**, **--help**
:    show an information message 

**-i**, **--interactive**
:    ask for confirmation before any action ; this will define the environment variables
*INTERACTIVE* on *true* and *FORCED* on *false*

**--libversion**
:    see the library version ; use option *quiet* to only have the version number

**--log** *filename*
:    define the log filename to use (default is *pwibashlib.log*) ; this will update
the environment variable *LOGFILE*

**--man**
:    try to open a manpage for current script if available, or show the help string otherwise

**-q**, **--quiet**
:    decrease script verbosity, nothing will be written unless errors ; this will define
the environment variables *VERBOSE* on *false* and *QUIET* on *true*

**-v**, **--verbose**
:    increase script verbosity ; this will define the environment variables *VERBOSE* on *true*
and *QUIET* on *false*

**-V**, **--version**
:    see the script version when available ; use option **quiet** to only have the version number

**--working-dir** *path*
:    redefine the working directory (default is *pwd*) ; the `path` argument must exist ; this will update
the environment variable *WORKINGDIR*

**-x**, **--debug**
:    enable debug mode ; this will define the environment variables *DEBUG* and *VERBOSE* on *true*
and *QUIET* on *false*

**--usage**
:    show a quick usage information

You can group short options like `-xc`, set an option argument like `-d(=)value` or
`--long=value` and use `--` to explicitly specify the end of the script options.
Options are treated in the command line order (`-vq` will finally retain `-q`).

You can mix short options, long options and script arguments at your convenience. 

In some cases, you can use an automatic long option named as a program like `--less` for the
"less" program. If this program is installed in the system, it will be used for certain
option rendering. For instance, a long "help" output can be loaded via `less` running:

    piwi-bash-library-script -h --less

### Specific options of the library's interface:

Calling the library script itself to use its interface, you can use the following options:

**-b**, **--branch** *name*
:    defines the GIT branch to use from the remote repository ; the branch MUST exist in the
repository ; it defaults to "*master*"

**-e**, **--exec** *'bash string to evaluate'*
:    a bash raw script string to evaluate in library's environment ; the execution will stop
after the `evaluate` process (exclusive action) and exit with its last status

**--local**
:    defines the current directory as target directory (alias of **target=pwd**)

**-p**, **--preset** *type*
:    defines the preset type to use for an installation ; can be "*default*" (default value),
"*user*", "*dev*" or "*full*" ; the value of this option will be used to define the
files to install ; see the "*Files*" section below for more information

**-r**, **--release** *version_number*
:    defines the GIT version tag to use from the remote repository ; the release MUST exist in the
repository ; default behavior follows the **branch** option

**-t**, **--target** *path*
:    defines the target directory of a copy installation ; if it does not exist, `path` will
be created ; it defaults to current path (`$HOME/bin`)


## ENVIRONMENT

The library defines the followings environment variables:

COLOR_LIGHT COLOR_DARK COLOR_INFO COLOR_NOTICE COLOR_WARNING COLOR_ERROR COLOR_COMMENT
:    a set of predefined colors

VERBOSE QUIET DEBUG INTERACTIVE FORCED
:    the library flags, activated by script common options (see previous section)

USEROS USERSHELL SHELLVERSION
:    the current user operating system, binary shell in use and bash version

NAME VERSION DATE DESCRIPTION_USAGE LICENSE_USAGE HOMEPAGE_USAGE SYNOPSIS_USAGE OPTIONS_USAGE
:   these are used to build the help information of the scripts ; they may be defined for each script

SYNOPSIS_MANPAGE DESCRIPTION_MANPAGE OPTIONS_MANPAGE EXAMPLES_MANPAGE EXIT_STATUS_MANPAGE FILES_MANPAGE ENVIRONMENT_MANPAGE COPYRIGHT_MANPAGE BUGS_MANPAGE AUTHOR_MANPAGE SEE_ALSO_MANPAGE
:    these are used to build man-pages and help information ; they may be defined for each script

NAME VERSION DATE PRESENTATION COPYRIGHT LICENSE SOURCES ADDITIONAL_INFO
:   these are used to build the version string of the scripts ; they may be defined for each script

SCRIPT_OPTS SCRIPT_ARGS SCRIPT_PROGRAMS OPTIONS_ALLOWED LONG_OPTIONS_ALLOWED ARGIND ARGUMENT
:   these are used for options and arguments ; see the documentation for more informations

LOREMIPSUM LOREMIPSUM_SHORT LOREMIPSUM_MULTILINE
:   these are defined for tests with sample strings

CMD_OUT CMD_ERR CMD_STATUS
:   these are defined after usage of the `evaluate()` method or derivatives with respectively the STDOUT, STDERR and
exit STATUS of the evaluated command

## EXIT STATUS

The library defines and uses some specific error status:

*E_ERROR* = **90**
:   classic error

*E_OPTS* = **81**
:   script options error

*E_CMD* = **82**
:   missing command error

*E_PATH* = **83**
:   path not found error


## FILES

**piwi-bash-library.bash** | **piwi-bash-library**
:    the standalone library source file 

**piwi-bash-library.man**
:    the manpage of the library, installed in section 3 of system manpages for global installation

**piwi-bash-library-README.md** (optional)
:    the standard README file of the version installed (Markdown syntax) ; it is installed
by the interface using the "user" or "full" presets

**piwi-bash-library-DOC.md** (optional)
:    the development documentation file of the version installed (Markdown syntax) ; it
is installed by the interface using the "dev" or "full" presets

## LICENSE

Copyleft (ↄ) 2013-2015, Pierre Cassat & contributors
<http://e-piwi.fr/> - Some rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

For sources & updates, see <http://github.com/piwi/bash-library>. 

For documentation, see <http://github.com/piwi/bash-library/wiki/>. 

To read GPL-3.0 license conditions, see <http://www.gnu.org/licenses/gpl-3.0.html>.

## BUGS

To transmit bugs, see <http://github.com/piwi/bash-library/issues>.

## AUTHOR

The *piwi-bash-library* is created and maintained by Pierre Cassat 
(piwi - <http://e-piwi.fr/> - <me [at] e-piwi.fr>) & contributors.

## SEE ALSO

bash(1), sed(1), grep(1), printf(1), echo(1), tput(1), uname(1), getopt(1), getopts(1)
