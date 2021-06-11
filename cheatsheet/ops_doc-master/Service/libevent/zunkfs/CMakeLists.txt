PROJECT(zunkfs C)

SET( CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE )
SET(CMAKE_VERBOSE_MAKEFILE ON)

INCLUDE(UsePkgConfig)
INCLUDE(FindPkgConfig)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")

option(DEBUG "Compile in DEBUG mode")
if(DEBUG)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
    message("Compiling in debug mode")
else(DEBUG)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3")
    message("Compiling in optimized mode")
endif(DEBUG)

pkg_check_modules(FUSE fuse)
INCLUDE_DIRECTORIES(${FUSE_INCLUDE_DIRS})

LINK_LIBRARIES(ssl sqlite3 ${FUSE_LIBRARIES} event)
IF(APPLE)
	LINK_LIBRARIES(crypto)
	ADD_DEFINITIONS(-DZUNKFS_OS=Darwin)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -framework CoreFoundation")
ENDIF()

IF("${CMAKE_SYSTEM}" MATCHES "Linux")
	SET_SOURCE_FILES_PROPERTIES(fuse.c
		PROPERTIES
			COMPILE_FLAGS "-D_FILE_OFFSET_BITS=64"
	)
	ADD_DEFINITIONS(-DZUNKFS_OS=Linux)
ENDIF()


INCLUDE(CheckIncludeFile)
INCLUDE(CheckLibraryExists)
INCLUDE(CheckCSourceCompiles)

SET(CORE_SOURCES
chunk-tree.c	chunk-db.c
dir.c		file.c
utils.c		mutex.c
base64.c	fuse.c
)
#SET(UNIT_TEST_OBJS
#	${CORE_OBJS} 
#	unit-test-utils.c
#	chunk-db-mem.c
#)
#
#SET(DBTYPES
#	chunk-db-local.o
#	chunk-db-cmd.o
#	chunk-db-map.o
#	chunk-db-sqlite.o
#	chunk-db-mem.o
#	chunk-db-zdb.o
#)
#
#ADD_EXECUTABLE(ctree-unit-test ctree-unit-test.c)
#ADD_EXECUTABLE(dir-unit-test dir-unit-test.c)
#ADD_EXECUTABLE(file-unit-test file-unit-test.c)
#ADD_EXECUTABLE(zunkfs-list-ddents zunkfs-list-ddents.c)
#ADD_EXECUTABLE(zunkfs-list-ddent zunkfs-list-ddent.c)
ADD_LIBRARY(ZUNKFS_CORE ${CORE_SOURCES})
ADD_EXECUTABLE(zunkfs ${CORE_SOURCES} ${DBTYPES})
TARGET_LINK_LIBRARIES(zunkfs ${ZUNKFS_CORE})
