# ubulk dev backlog

## Done

* Do a manual bulk build with pbulk
* Do a scripted install of all desired packages
* Make a backlog
* Formal script that can update pkgsrc
    - config file with pkgsrc dir (/usr/pkgsrc)
        - command-arg to override default config location (/etc/ubulk.conf)
    - git-only
    - die on error
* Command-arg to get command-arg help
* Log results and be ready to be run from cron
    - config log file (/var/log/ubulk-build.log)
    - summary to stdout / details to log file
    - output path to log file
* Option to use pkg_chk to see what's new (in log output)
    - config setting (yes)
    - command-line arg to override config setting
    - if you can't find pkg_chk, just warn and continue
        - (i.e. user has to bootstrap it, maybe with a prior run of ubulk)
    - if pkg_chk finds no deltas, skip build
* Option and command-arg to skip pkgsrc update
    - so you can just do the pkg_chk (now) or the build (later)
* Make some sort of automated test suite
    - at least covering the options/settings, and output
    - maybe in a chroot?
* Create the sandbox
    - config location (/usr/sandbox)
    - config mksandbox args (--without-x)
    - mksandbox --rwdirs=/var/spool
    - after running pkg_chk
    - install traps/handlers to tear down the sandbox no matter how the build ends
* Option and command-arg to ignore/assume sandbox state
    - i.e. if you just want to leave the prior sandbox up
    - if set, warn if system /etc/mk.conf is newer than sandbox /etc/mk.conf
* Chroot and prep for pbulk
    - after sandbox setup
    - run a script once inside
    - no matter what happens to that script, exit the chroot when finished
        - see mk/bulk/do-sandbox-build for examples
        - or maybe 'sandbox' can do it for us
    - create /bulklog, /scratch
    - add pbulk, chown /scratch
    - use "ignore sandbox" option/arg to control whether setup stuff is done
    - summary to stdout / details to a log file
        - show log file path in output/email

## Build Backlog

* Install pbulk
    - during chroot setup phase
    - remove earlier pkg_bulk dir if one is there
    - bootstrap pkg_bulk dir
    - configure pbulk mk.conf to use system-wide work and output dirs
    - clean, build and install pbulk into prepared dir
* Option and command-arg to skip installing pbulk
    - in case you know the one there is still OK
* Configure pbulk
    - during chroot setup phase
    - obey "install pbulk" option/arg
    - expose some things as config options:
        - reuse_scan_results (yes)
        - report_recipients (root)
        - report_subject_prefix (pkgsrc bulk build)
        - make (/usr/bin/make)
        - ulimit -t (1800)
        - ulimit -v (2097152)
        - package list location (/etc/pkglist)
    - make sure to set/obey config options like the pkgsrc location
    - make sure to set/obey system options like the packages directory
        - see mksandbox for examples
* Configure mk.conf
    - during chroot setup phase
    - obey the "ignore sandbox" option
    - set an environment variable that lets the user have pbulk-specific stuff in their system (and chroot) /etc/mk.conf
        - that way they can set e.g. MAKE_JOBS in the "normal" place
        - if MAKE_JOBS isn't set, suggest it
    - set WRKOBJDIR and NO_MULTI_PKG
    - let the rest just pass through
* Sort out wget or curl
    - after installing pbulk, before configuring pbulk or mk.conf
    - obey "skip installing pbulk" option/arg
    - install into the pkg_bulk tree, same as pbulk
    - configure sandbox's /etc/mk.conf with TOOLS_PLATFORM.curl
* Run the build
    - after all the other setup
    - summary to screen, details to log
    - add something to outer log referencing inner log
* Clean up after build
    - after the build, whether it succeeds or fails
        - but still exit with the right code
    - figure out what junk is left behind and delete it
        - maybe wait until sandbox is unmounted?
* Make all the paths / users / etc. configurable
    - e.g. /scratch, pbulk
* Option and command-arg to retry / continue / do a quick build
    - maybe this is the same as a 'skip the chroot' option?!?
    - auto-set all the 'skip' options
    - do a manual 'scan' and 'build'
        - or use one of the other wrapper scripts?
* Option and command-arg to set nice level
    - default 10

## Install Backlog
* Formal script that can install chosen packages
    - reuse config file from build script
        - command arg to override config file location
    - die on error
    - map chosen package names to package files (die on mismatch)
    - install all the packages, recording result of each, but waiting until the end to exit
    - no handling of old packages and/or rc.d stuff, yet
* Log results and be ready to be run from cron
    - config log file (/var/log/ubulk-install.log)
    - summary to stdout / details to log file
    - output path to log file
* Delete old packages before install
    - after checking that package files all match
    - delete everything installed in the system
    - on error, die with comprehensive error message
* Check if expected packages are actually installed
    - i.e. maybe they reported "success" but aren't really there
    - at the very end of the script (even after later stories)
    - output any differences
    - if differences, exit with error code
* Stop all pkgsrc-based services
    - before deleting all the packages
    - Remember to use RCD_SCRIPTS_DIR for checking for rc.d scripts
    - figure out which packages to stop, based on installed package list
    - stop them in reverse-dependency order
    - report failed stops
    - config option to continue or stop after failed stop (continue)
    - don't worry about restarting them, yet
* Option and command-arg to ignore services
    - e.g. if you want to manually stop and start them
* Start old services again
    - after successful install
    - obey config option
    - only start the ones that were stopped
    - report failed starts
    - config option to continue or stop after failed start (continue)
    - report missing rc.d scripts
    - config option to continue or stop after missing script (continue)
* Option and command-arg to skip deletion (and just do install)
    - e.g. if you had a prior delete fail, and manually finished it
* Show log output during startup
    - start recording output before starting services
    - report output after services started
    - ignore errors
* Option and command-arg to skip log reporting
    - e.g. if you have other monitoring techniques

## Later Backlog
* Make a README.md
* Documentation (man page?)
* Make tests run in parallel
* Have it figure out which packages have been deleted since last build and pipe their uninstall output to the user (so they can see anything that needs to be cleaned up)
* Log all the INSTALL and UNINSTALL messages somewhere
* Do an install in the sandbox and diff that against the prod install, and report to the user (as part of the build)
* Figure out ccache
* Figure out devel/cpuflags
* rsync pbulk reports to somewhere web-accessible; include that in the output / email
* Turn this whole thing into a pkgsrc package :)
    - version number
    - releases
* Give user a way to pass additional env into the chroot
* Install mksandbox if it's missing
    - use an isolated build and install location
    - follow pattern from installing pbulk
    - should work even if the rest of pkgsrc is messy
    - workdirs should be totally isolated
    - ideally don't rebuild dependencies that don't need it
    - don't create a package (explicitly; it's ok if the system mk.conf triggers it)
* Get the tests passing on a bare system
    - i.e. uninstall pkg_chk and mksandbox, etc.
* Get the tests passing on a non-root OSX pkgsrc

