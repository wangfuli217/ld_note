#include "stdafx.h"
#include "ExceptionTest.h"


void exceptionTest(void)
{
    // 在catch语句或catch语句直接调用的函数内，
    // 可以用空throw语句重新抛出当前catch到的异常。
    // 如果在其他地方用空throw语句，编译器将调用terminate。

    // 要捕获所有的异常，用catch(...)，如果和其他catch语句一起出现，
    // 要放在最后，在catch(...)之后的语句永远不会被匹配。

    /*
        标准异常类及其继承关系：
        exception
            bad_alloc
            bad_cast
            runtime_error
                overflow_error
                underflow_error
                range_error
            logic_error
                domain_error
                invalid_argument
                out_of_range
                length_error
    */
}
