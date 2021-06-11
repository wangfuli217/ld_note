# A simple hello world example with version number generation
# and unit test example

TEMPLATE = subdirs

# Take care to have the SUBDIRs below in the right order - libs first!
# But note: with 'ordered', make will not build the subdirs in parallel,
# while MSVC still builds the projects in parallel ... so this isn't
# sufficient for MSVC, but slows down things with make. Better to use
# depenedencies (see below).
#CONFIG = ordered
SUBDIRS = app-lib \
          app-main \
          unittest \

# We do not need to add (repeat) depends if we use CONFIG=ordered above
# see e.g. http://www.qtcentre.org/wiki/index.php?title=Undocumented_qmake
# NOTE: Seems this could be helpful for visual studio solution files to
# guarantee the libs are built before the target is linked!? There have
# been timing problems, currently Visual Studio builds are not well tested
# (but you *can* build the executables via Qt Creator with the Visual Studio
# C++ compilers, i.e. MSVC kits!)
app-main.depends = app-lib
unittest.depends = app-lib

OTHER_FILES += ../README.md \
    ../bin/run-build.sh
