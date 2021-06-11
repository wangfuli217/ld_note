# qmake project include file for library dependencies

# The following part was inspired
# from http://stackoverflow.com/questions/2288292/qmake-project-dependencies-linked-libraries

# This loop sets up the dependencies for libraries that are built with
# this project. Specify the libraries you need to depend on in the variable
# DEPENDENCY_LIBRARIES and this will add them to the necessary variables in
# the required format.
# On Windows for MinGW and MSVC kits, qmake generates another level of debug/release subdirs, grrr
win32 {
    CONFIG(debug, debug|release): subdir = debug/
    CONFIG(release, debug|release): subdir = release/
} else {
    subdir =
}
for(dep, DEPENDENCY_LIBRARIES) {
    deplib = ../$${dep}/$${subdir}$${QMAKE_PREFIX_STATICLIB}$${dep}.$${QMAKE_EXTENSION_STATICLIB}
    LIBS += $$deplib
    PRE_TARGETDEPS += $$deplib
}
