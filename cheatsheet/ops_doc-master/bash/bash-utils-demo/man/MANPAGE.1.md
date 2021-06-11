Man:        Bash-Utils Manual
Man-name:   bash-utils
Author:     Pierre Cassat
Section:    1
Date: 2016-04-27
Version: 0.1.1


## NAME

Bash-Utils - A short *bash* library for better scripting.

## SYNOPSIS

Usage of the library as a script's interpreter:

    #!/usr/bin/env bash-utils

Usage of the library in a script:

    source bash-utils -- || { echo "> bash-utils not found!" >&2; exit 1; };

Usage of the library as a command:

**bash-utils** [**-fhqvVx**]
    [**--debug**|**--dry-run**|**--force**|**--help**|**--quiet**|**--verbose**|**--version**]
    [**-e**|**--exec**[=*arg*]] <arguments>

## DESCRIPTION

The *Bash-Utils* command is a small library of utilities to quickly write robust and complete *Bash* scripts.
It proposes a set of useful functions and environment variables in an enhanced environment with some system 
options enabled by default, to let you build a script with user options and arguments, an automatic generation 
of some informational output about the script's usage, a special handling of errors, stack trace and debugging, 
and some more features (see bash-utils(7) for a full documentation).

It also embeds a various set of *modules* constructed as stand-alone bash-utils scripts you can use "as-is",
calling them directly, or in a script using the library with the help of the `run()` or `use()` functions.

## OPTIONS

### Scripts using the library

The following options are supported by default for any script using the library:

*--dry-run*
:   Process a dry-run. 

*-f*, *--force*
:   Force some commands to not prompt confirmation. 

*-h*, *--help*
:   See the help information about the script, a module or the library itself.

*-q*, *--quiet*
:   Decrease script's verbosity. 

*-v*, *--verbose*
:   Increase script's verbosity. 

*-V*, *--version*
:   See the script, module or library version and copyright information ; 
use option `--quiet` to get version number only.

*-x*, *--debug*
:   See some debugging information.

Please note that these options are available but not necessarily used in scripts or modules.

### Using the library as a command

The following additional options are available when you call the library itself:

*-e*, *--exec* [**=arg**]
:   Execute the argument in the library's environment ; as the argument is optional, the equal sign
is REQUIRED ; without argument, any piped content will be evaluated:

        bash-utils --exec='onoff_bit true'
        echo 'onoff_bit true' | bash-utils --exec

The following additional arguments are available when you call the library itself:

*about*
:   alias of '--version'

*about module-name*
:   alias of 'module-name --version'

*help*
:   alias of '--help'

*help module-name*
:   get the help about a module

*modules*
:   get the list of available modules

*usage*
:   get the library synopsis

*usage module-name*
:   get a module synopsis

*version*
:   alias of '--version --quiet'

*version module-name*
:   alias of 'module-name --version --quiet'

## EXAMPLES

You can use the *model* module to get a full example of a script using the library.

    bash-utils model bash-utils

A starter template is available in bash-utils(7).

## LICENSE

Copyright (c) 2015, Pierre Cassat & contributors

Licensed under the Apache Software Foundation license, Version 2.0 (the "License");
you may not use this file except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code or see 
<http://www.apache.org/licenses/LICENSE-2.0>.

## BUGS

To transmit bugs, see <http://github.com/e-picas/bash-utils/issues>.

## AUTHOR

**Bash-Utils** is created and maintained by Pierre Cassat (picas - <http://picas.fr/>)
& contributors.

## SEE ALSO

For documentation, sources & updates, see <http://github.com/e-picas/bash-utils.git>. 

bash(1), bash-utils(7)
