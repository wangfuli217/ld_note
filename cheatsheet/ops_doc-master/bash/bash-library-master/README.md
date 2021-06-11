Piwi-Bash-Library
=================

An open source day-to-day bash library.

[![Build Status](https://travis-ci.org/piwi/bash-library.svg?branch=dev)](https://travis-ci.org/piwi/bash-library)

Key features:

-   manage strings, files, integers and arrays easily
-   build colorized contents with text effect, foreground and background colors
-   execute sub-jobs with a large control upon outputs, errors and status
-   build some scripts with command line options and arguments easily
-   the library is well-documented and unit-tested 

To begin, have a look at [the wiki](http://github.com/piwi/bash-library/wiki).


Installation
------------

Installing the *Piwi Bash Library* is as simple as making a copy of two files in your target
directory: the **library source itself** and **its Unix manual page**.

You can install the package in many ways explained in the [Global documentation](http://github.com/piwi/bash-library/wiki) ;
the best practice is to use **the internal interface** as it presents facilities to update the library.

    wget --no-check-certificate https://github.com/piwi/bash-library/archive/master.tar.gz
    tar -xvf master.tar.gz
    cd piwi-bash-library-master
    ./bin/piwi-bash-library help

To read the library's manpage, run:

    man man/piwi-bash-library.man

Usage
-----

To use the library in a bash script, just `source` it at the top of your code or before any
call of its methods or variables:

    #!/bin/bash
    source path/to/piwi-bash-library.bash
    ...

The full documentation of the library is available online at <http://github.com/piwi/bash-library/wiki>.


Demonstrations
--------------

A set of test and demonstration files is included in the `samples/` directory of the package.
These files are not required for a normal usage of the library.

To run one of these tests, just run:

    cd path/to/downloaded/package/piwi-bash-library
    ./samples/file-test.sh

You can use the `--help` option to get help or info:

    ./samples/file-test.sh --help


Author & License
----------------

-   For sources & updates, see <http://github.com/piwi/bash-library>
-   For documentation, see <http://github.com/piwi/bash-library/wiki/>
-   To transmit bugs, see <http://github.com/piwi/bash-library/issues>
-   To read GPL-3.0 license conditions, see <http://www.gnu.org/licenses/gpl-3.0.html>


    Piwi Bash Library - An open source day-to-day bash library
    Copyleft (ↄ) 2013-2015 Pierre Cassat & contributors
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
