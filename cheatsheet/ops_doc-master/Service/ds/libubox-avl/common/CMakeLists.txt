function(compile_common_test executable source)
    # create executable
    ADD_EXECUTABLE(${executable} ${source})

    TARGET_LINK_LIBRARIES(${executable} oonf_common)
    TARGET_LINK_LIBRARIES(${executable} static_cunit)
    
    # link regex for windows and android
    IF (WIN32 OR ANDROID)
        TARGET_LINK_LIBRARIES(${executable} oonf_regex)
    ENDIF(WIN32 OR ANDROID)

    # link extra win32 libs
    IF(WIN32)
        SET_TARGET_PROPERTIES(${executable} PROPERTIES ENABLE_EXPORTS true)
        TARGET_LINK_LIBRARIES(${executable} ws2_32 iphlpapi)
    ENDIF(WIN32)
endfunction(compile_common_test)

# just run all of these tests
set(TESTS test_common_avl
          test_common_isonumber
          test_common_list
          test_common_netaddr
          test_common_string
          test_common_regex)

foreach(TEST ${TESTS})
    compile_common_test(${TEST} ${TEST}.c)
    ADD_TEST(NAME ${TEST} COMMAND ${TEST})
endforeach(TEST)
