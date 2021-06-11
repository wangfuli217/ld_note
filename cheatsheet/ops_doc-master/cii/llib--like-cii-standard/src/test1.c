#include <string.h>

#include "test1.h"
#include "mem.h"
#include "str.h"
#include "assert.h"
#include "safeint.h"

static void validSuite(TestSuite_t* suite) {

    assert(suite && suite->Name);
}

void TestSuite_AddTest(TestSuite_t* suite, const char* name, const char* tags, TestSuite_Test_func testFunc) {

    Test_t* test;
    validSuite(suite);
    assert(suite && name && testFunc);

    NEW(test);
    test->Name = Str_adup(name);
    if (tags)
        test->Tags = Str_adup(tags);
    else
        test->Tags = (char*)tags;

    test->Test_func = testFunc;

    suite->Tests = SList_push_front(suite->Tests, test);
}

static void freeTest(void** t, void* env) {

    Test_t* test;

    assert(t && *t);
    assert(env == NULL);

    test = (Test_t*)(*t);
    if (test->Name) FREE(test->Name);
    if (test->Tags) FREE(test->Tags);

    FREE(test);
}

void TestSuite_FreeTests(TestSuite_t* suite) {

    assert(suite);
    validSuite(suite);
    
    SList_map(suite->Tests, freeTest, NULL);
    SList_free(&(suite->Tests));
}

static int isTagInTags(char* tag, char** tagsArray, size_t size) {

    unsigned i;
    
    safe_size(size);

    for (i = 0; i < size; i++)
        if (strcmp(tag, tagsArray[i]) == 0) {
            return FOUND;
        }
    return NOT_FOUND;
}


static struct TestEnv {
    char** tagsArray;
    size_t size;
    TestSuite_t* suite;
    TestSuite_Filter filter;
};

static void lookup(int table[4][4], TestSuite_Filter filter, int* found, int* ret1, int* ret2) {

    int i;
    for (i = 0; i < TestSuite__MAX; i++) {
        if (table[i][0] == filter) {
            *found = table[i][1];
            *ret1  = table[i][2];
            *ret2  = table[i][3];
            return;
        }
    }
    assert(0);
    return;
}

static int shouldRunIt(char** testTags, size_t tsize, char** runTags, size_t rsize, TestSuite_Filter filter) {

    // If filter is any
    //  For each runTag
    //      if it is in testTags return true
    //  return false
    // If filter is all
    //  For each runTag
    //      if it is not in testTags return false
    //  return true
    // If filter is exceptAny
    //   For each runTag
    //      if it is in testTag return false
    //   return true
    // If filter is exceptAll
    //   For each runTag
    //      if it is not in testTag return true
    //   return false
    int table[][4] = {
            { TestSuite_Any,          FOUND,      1, 0 },
            { TestSuite_All,          NOT_FOUND,  0, 1 },
            { TestSuite_ExceptAny,    FOUND,      0, 1 },
            { TestSuite_ExceptAll,    NOT_FOUND,  1, 0 } };
    unsigned i;
    int found;
    int insideLoopRet;
    int finalRet;

    assert(testTags && runTags);
    assert(filter < TestSuite__MAX);
    safe_size(rsize);
    safe_size(tsize);

    lookup(table, filter, &found, &insideLoopRet, &finalRet);

    for (i = 0; i < rsize; i++)
        if (isTagInTags(runTags[i], testTags, tsize) == found)
            return insideLoopRet;
    return finalRet;
}

static void testExec(void** test, void* cl) {

    Test_t* t = *test;
    struct TestEnv* tenv = cl;
    TestSuite_t* suite = tenv->suite;
    size_t size;
    char** testTags = NULL;
    int shouldRun = 1;
    
    // Split the tags if present and figure out if it shouldn't run it
    if (t->Tags) {
        testTags = Str_split(t->Tags, ",", TOKENIZER_NO_EMPTIES, &size);
        shouldRun = shouldRunIt(testTags, size, tenv->tagsArray, tenv->size, tenv->filter);
        FREE(testTags);
    }

    // This will be true even if t->tags = NULL
    if (shouldRun) {
        int status;
        char* path;
        //  If there is a setup routine call it
        if (suite->Setup) suite->Setup();
        
        // Run test
        status = t->Test_func();
        path = Str_asprintf("/%s/%s/", tenv->suite->Name, t->Name);
        printf("%-30s%s\n", path, status == TEST_SUCCESS ? "Ok" : "FAILED !!!");
        FREE(path);

        //  If there is a teardown routing call it
        if (suite->TearDown) suite->TearDown();
    }
}

void TestSuite_Run(TestSuite_t* suite, char* tags, TestSuite_Filter filter) {

    char** tagsArray = NULL;
    size_t size = 0;
    struct TestEnv tenv;

    validSuite(suite);
    
    // Extract the tags passed to the function
    if (tags)
        tagsArray = Str_split(tags, ",", TOKENIZER_NO_EMPTIES, &size);

    tenv.size = size;
    tenv.suite = suite;
    tenv.tagsArray = tagsArray;
    tenv.filter = filter;

    // Execute each test
    SList_map(suite->Tests, testExec, &tenv);
    if (tagsArray)
        FREE(tagsArray);
}

static SList_T suite_reg = NULL;

void TestSuite_Register(TestSuite_t* suite) {
    suite_reg = SList_push_front(suite_reg, suite);
}

void TestSuite_RunAllTests(char* tags, TestSuite_Filter filter) {

    SList_T l = suite_reg;
    for (; l; l = l->rest) {
        TestSuite_t* t = l->first;
        TestSuite_Run(t, tags, filter);
    }
}

void TestSuite_FreeAllTests() {
    SList_T l = suite_reg;

    // Free the tests inside testcases
    for (; l; l = l->rest) {
        TestSuite_t* t = l->first;
        TestSuite_FreeTests(t);
    }
    // Free the list itself
    SList_free(&suite_reg);

}