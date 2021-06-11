# CHANGELOG for remote repository  https://github.com/piwi/bash-library

* (upcoming release)

    * 89f004b - fix #2: wrong test in SCRIPT_ARGS array usage (piwi)
    * 4d31bca - update modules/wiki (piwi)
    * e1ef444 - update of modules/markdown-extended (piwi)
    * 93dc5f2 - the library is now under Travis-CI auto-testing (piwi)
    * 515268c - add the DOCUMENTATION as a manpage (piwi)
    * 1b70091 - no more 'realpath' usage in builders (piwi)
    * 2489001 - test of travis auto-testing (piwi)
    * abc6594 - update the copyright notice to a copyleft and to 2015 (happy new year ;) (piwi)
    * ac18f52 - upgrade of modules/markdown-extended to v0.1-gamma4 (piwi)
    * 951d10c - review of the getopts sample script following #06dc8f7 (piwi)
    * 06dc8f7 - new 'getargs' method (based on the 'getopts' model) (piwi)
    * c737a9e - more control on vcs_version errors (piwi)
    * 55e796e - new manpage generation following #38982b7 (piwi)
    * d2a109e - fix a typo in the manpage builder (piwi)
    * 38982b7 - fix the manpage with new MDE rules (piwi)
    * 666e6e8 - upgrade of modules/markdown-extended (piwi)
    * c146755 - fix typos in builders (piwi)
    * 3ef3939 - update of modules/markdown-extended (piwi)
    * e551055 - fucking tabs ... (piwi)
    * c9913a1 - uniform tabs-to-spaces due to git attributes (piwi)
    * 1c51409 - review of git attributes (piwi)
    * 4bccc36 - missing cvs version in the 'make-release' builder (piwi)
    * a2bcf5c - update of modules/wiki (piwi)
    * 1dbd0f5 - fixing the 'make-release' builder (piwi)

* v0.2.0 (2014-12-20 - 9d18b07)

    *   moving test scripts from 'demo/' to 'samples/'
    *   new management of library's environment flags
    *   review of the 'job control' and 'output control' methods according to current env flags
    *   reorganization of library sections
    * a600215 - Version 0.2.0 : automatic version number and date insertion (piwi)
    * 7df65b1 - fixing the 'make-release' builder (piwi)

* v0.1.0 (2014-12-16)

    *   'piwi/markdown-extended' is now a GIT submodule
    *   new 'sstephenson/bats' submodule for unit-testing
    *   new test suite with BATS in 'tests/'
    *   removing all 'doc/' contents: the documentation is now handle by the wiki on the repository at
        <http://github.com/piwi/bash-library/wiki>
    *   new internal builders in 'build/'
    *   large review of the options & arguments treatments: we now try to use the 'getopt' first to re-arrange
        everything, then the classic 'getopts'
    *   the whole library has been verified with <http://www.shellcheck.net/>
    *   new stack trace method
    * 34da313 - retro-upgrade to 0.0.1 (piwi)
    * 152f333 - uniformization of license blocks (piwi)
    * 7827f92 - review of the VCS methods (piwi)
    * 4183e69 - no more mention of Les Ateliers (piwi)
    * 1a6db7a - fix of a missing simple quotes escape for options arguments (piwi)
    * d789bb2 - add new wiki info in ChangeLog (piwi)
    * bcd4c44 - new doc info about the 'evaluate' method (piwi)
    * 3a37fa3 - the documentation is now handled by the repo wiki (piwi)

--
!! - moving ownership of the repository to: <http://github.com/piwi/bash-library>
NOTE - The "old-" tags referred to <http://github.com/atelierspierrot/piwi-bash-library>.
--

* old-v2.0.4 (2014-11-21 - 7263593)

    * 3473ae5 - fix not-compatible 'stat' argument for non-linux OS (piwi)
    * 93b7770 - new 'evaluate()' method and derivatives to replace internal 'eval()' catching ell events + demo script 'eval.sh' (piwi)
    * 723a782 - update of all scripts shebang for compatibility (piwi)
    * 853eb78 - info of #10f8447 in ChangeLog (piwi)
    * 10f8447 - moving the 'bin/' scripts in 'demo/' directory (piwi)

* old-v2.0.3 (2014-06-29 - 72a125c)

    * f948ff7 - internal interface seems ok, fixes #1 (Piero Wbmstr)
    * cacfe8c - merging new history with old one (Piero Wbmstr)

* old-v2.0.2 (2014-06-11 - 0a144d6)

    * b6cec60 - manage options in alphabetical order & correct GitHub url (Piero Wbmstr)
    * 96a540e - Fix: missing 'd' option deletion (Piero Wbmstr)
    * 1910473 - Fix: verify if library exists for an update (Piero Wbmstr)
    * 9f59c6e - No more '-l' neither '-d' default short options (Piero Wbmstr)
    * 7490455 - New 'release' option for the interface to choose a sepcific library version to install/upadte to (Piero Wbmstr)
    * f47cea8 - Fix: 'resolve' method re-writing (Piero Wbmstr)

* old-v2.0.1 (2014-04-16 - 3129fe6)

    * e0ebee1 - Work on CVS stuff in lib + correcting the pre-tag-hook (Piero Wbmstr)
    * 9ff752e - Corrections in pre-tag-hook and library_version (Piero Wbmstr)

* old-v2.0.0 (2014-04-09 - 5ad20a6)

    * 1fb52d2 - Allow not Linux OS to run the 'pre-tag-hook' (Piero Wbmstr)
    * a675cb3 - Last validation before 2.0 (Piero Wbmstr)

* old-v2.0.0-beta (2014-04-09 - a5fc970)

    *   all methods are renamed with underscores
    *   new method 'debug_echo'
    *   constants are renamed with "meaningful" names
    *   the whole USAGE and MANAPAGE constructions are reviewed
    *   !! NOTE - see the `scripts/upgrade-1-2.sh` script to upgrade a project
    * 8190ca4 - New method 'debug_echo' (Piero Wbmstr)
    * 9721a0b - Adding debug infos in the pre-tag-hook (Piero Wbmstr)
    * 256edd1 - New corrections in the pre-tag-hook (Piero Wbmstr)
    * 7fc8fa8 - Corrections in the pre-tag-hook (Piero Wbmstr)
    * 8ccc005 - Full review before publishing version 2.0 (Piero Wbmstr)
    * e9610e9 - Welcome in version 2 ! (Piero Wbmstr)
    * 7ec15db - Merge branch 'wip' - preparing version 2.0 (Piero Wbmstr)
    * b41d617 - Master/wip diff (!) (Piero Wbmstr)

* old-v1.0.4 (2013-10-24 - 0f8f355)

    * e452c5c - Keeping the "parsecomonoptions()" for compatibility (Piero Wbmstr)
    * 90adc3c - Renaming "parsecomonoptions()" to "parsecommonoptions()" (typo)" (Piero Wbmstr)
    * d0f7900 - Keep line breaks for 'simpl_error' output (Piero Wbmstr)
    * ffa7673 - New MarkdownExtended bin name (Piero Wbmstr)
    * fec9fcc - Install the manpage with the installer (Piero Wbmstr)

* old-v1.0.3 (2013-10-20 - 44379b5)

    * d4442af - The library manpage (Piero Wbmstr)
    * f4dc775 - Adding the MarkdownExtended as requirement for dev (Piero Wbmstr)
    * 5a82c2c - Creating the library MANPAGE (Piero Wbmstr)
    * 0c0a575 - Corrections in the installer (to be continued …) (Piero Wbmstr)

* old-v1.0.2 (2013-10-18 - a34da78)

    *   review of the options management
    *   new options 'man', 'help' and 'usage'
    *   creation of the internal API (direct run of the library)
    *   organization of the MANPAGE script's infos
    * a87664f - Handling some simple error messages with synopsis (Piero Wbmstr)
    * 2f68838 - Using config 'BIN_DIR' in the installer (Piero Wbmstr)
    * 3fd22eb - Authorize scripts to over-write "COMMON_OPTIONS_ARGS" (Piero Wbmstr)
    * e597d7d - Update Development.md (Piero Wbmstr)
    * e1cfbd3 - Update Common-options.md (Piero Wbmstr)
    * e9d4b70 - Update Colorized-contents.md (Piero Wbmstr)
    * fb2ff62 - New installer script (Piero Wbmstr)
    * 05acb5a - New clone installer script - package updraged to 0.0.5-dev (Piero Wbmstr)
    * 4c531db - Corrections for Darwin usage (Piero Wbmstr)

* old-v1.0.1 (2014-04-04 - 737d784)

    * 8b908dd - WIP on lib & docs (Piero Wbmstr)
    * 56636f7 - Correction of a typo and in README (Piero Wbmstr)
    * 6d26cdd - Linux date format (missing quotes) (Piero Wbmstr)
    * 51172e5 - Corrections of missing "piwi-" prefixes (Piero Wbmstr)

* old-v1.0.0 (2013-11-03 - 1dc2d5c)

    *   review of the options management
    *   new options 'man', 'help' and 'usage'
    *   creation of the internal API (direct run of the library)
    *   organization of the MANPAGE script's infos
    * a044003 - Adding the 'help' 'man' and 'usage' options in the MANPAGE (Piero Wbmstr)
    * 3e93ad9 - Cleaning the pre-tag hook (Piero Wbmstr)
    * 9f1d71c - Adding the LICENSE file (Piero Wbmstr)

