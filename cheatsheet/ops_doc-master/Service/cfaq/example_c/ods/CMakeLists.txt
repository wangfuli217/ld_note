cmake_minimum_required(VERSION 2.8.11)

project(ods)



include_directories(
    E:/data/example/ods/
    E:/data/example/ods/

)

# Linker options
set(CMAKE_LDFLAGS "${CMAKE_LDFLAGS}  ")

# Library path
set(CMAKE_LDFLAGS "${CMAKE_LDFLAGS} -L\".\" ")

# Define the CXX sources
set ( CXX_SRCS
    main.cpp
    AdjacencyLists.cpp
    AdjacencyMatrix.cpp
    array.cpp
    ArrayDeque.cpp
    ArrayQueue.cpp
    ArrayStack.cpp
    BinaryHeap.cpp
    BinarySearchTree.cpp
    BinaryTree.cpp
    BinaryTrie.cpp
    ChainedHashTable.cpp
    DLList.cpp
    DualArrayDeque.cpp
    FastArrayStack.cpp
    FastSqrt.cpp
    LinearHashTable.cpp
    MeldableHeap.cpp
    RedBlackTree.cpp
    RootishArrayStack.cpp
    ScapegoatTree.cpp
    SEList.cpp
    SkiplistSSet.cpp
    SLList.cpp
    Treap.cpp
    utils.cpp
    XFastTrie.cpp
    YFastTrie.cpp
)

set_source_files_properties(
    ${CXX_SRCS} PROPERTIES COMPILE_FLAGS 
    " -g -O0 -Wall")

add_executable(ods ${CXX_SRCS} ${C_SRCS})

