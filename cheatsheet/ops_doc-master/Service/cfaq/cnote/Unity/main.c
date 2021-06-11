#include "unity.h"
// #include "UnitUnderTest.h" /* The unit to be tested. */
void setUp (void) {} /* Is run before every test, put unit init calls here. */
void tearDown (void) {} /* Is run after every test, put unit clean-up calls here. */
int FunctionUnderTest(void){
    return 5;
}
void test_FunctionUnderTest_should_ReturnFive(void)
{
    TEST_ASSERT_EQUAL_INT( 5, FunctionUnderTest() );
}

void test_TheFirst(void){
    TEST_IGNORE_MESSAGE("Hello world!"); /* Ignore this test but print a message. */
}
int main (void)
{
    UNITY_BEGIN();
    RUN_TEST(test_TheFirst); /* Run the test. */
    RUN_TEST(test_FunctionUnderTest_should_ReturnFive);
    return UNITY_END();
}