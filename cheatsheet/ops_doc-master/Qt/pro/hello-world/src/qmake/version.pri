# qmake project include file for generating version header file
#
# NOTE: The generation depends on 'bash', so be sure on Windows to
# have it in PATH, e.g. add the cygwin directory to the environment
# variable 'Path'

# NOTE: All paths are relative to the including project file!
OTHER_FILES += ../../bin/create-buildtag.sh

# magically create buildtag.h with SCM revision etc.
version.target = $$OUT_PWD/buildtag.h
version.commands = @bash -c \'mkdir -p \"$$OUT_PWD\"; bash \"$$_PRO_FILE_PWD_/../../bin/create-buildtag.sh\" \"$$version.target\"\'
version.depends = checkalways	# ensure this is always made

# the target 'checkalways' just prints a build info
checkalways.commands = @bash -c \'echo -n \"checking revision number ... \"\'

QMAKE_EXTRA_TARGETS += version checkalways
PRE_TARGETDEPS += $$version.target
QMAKE_DISTCLEAN += $$version.target


# qmake sometimes adds automatically (due to include file analysis) a dependency
# to buildtag.h, but the targets above have the full path included.
# If we strip the full path and take the filename only, qmake will change the
# dependency to src/app-lib/buildtag.h, which is even worse.
# So, as workaround, we add another target without path, but do not add it to
# the dependencies manually.
versionlocal.target = $$basename(version.target)
versionlocal.commands = @bash -c \'ls -l \"$$versionlocal.target\"\'
versionlocal.depends = version  # this target will do the real work ...
QMAKE_EXTRA_TARGETS += versionlocal
