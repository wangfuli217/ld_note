#include "Vector.hpp"

#include "unity.h"

#include "Numbers.hpp"

// class AFn : public IFn, public std::enable_shared_from_this<AFn>
// class AVector : public IVector_inherit<AVector>, virtual public AFn
// class LVector : virtual public AVector, public IMeta_inherit<LVector>

void test_empty_vector() {
	std::shared_ptr<const LVector> e = LVector::EMPTY;
	TEST_ASSERT_EQUAL_STRING("[]", e->toString().c_str());
	TEST_ASSERT_EQUAL(0, e->length());
	TEST_ASSERT_EQUAL_STRING("[1]", e->assocN(0, std::make_shared<Integer>(1))->toString().c_str());
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_empty_vector);
    return UNITY_END();
}
