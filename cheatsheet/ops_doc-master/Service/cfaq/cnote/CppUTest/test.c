/* file: test.c */

#include <CppUTest/CommandLineTestRunner.h>
#include <CppUTest/TestHarness.h>

extern "C"
{
#include "sample.h"
}


/* 定义个 TEST_GROUP, 名称为 sample */
TEST_GROUP(sample)
{
    void setup()
    {
        printf ("测试开始......\n");
    }

    void teardown()
    {
        printf ("测试结束......\n");
    }
    
};

/* 定义一个属于 TEST_GROUP 的 TEST, 名称为 ret_int_success */
TEST(sample, ret_int_success)
{
    int sum = ret_int(1, 2);
    CHECK_EQUAL(sum, 3);
}

/* 定义一个属于 TEST_GROUP 的 TEST, 名称为 ret_int_failed */
TEST(sample, ret_int_failed)
{
    int sum = ret_int(2, 2);
    CHECK_EQUAL(sum, 4);
}

TEST(sample, init_student)
{
    struct Student *stu = NULL;
    stu = (struct Student*) malloc(sizeof(struct Student));
    char name[80] = {'t', 'e', 's', 't', '\0'};
    
    init_student(stu, name, 100);
    free(stu);
}

int main(int argc, char *argv[])
{
    CommandLineTestRunner::RunAllTests(argc, argv);
    return 0;
}