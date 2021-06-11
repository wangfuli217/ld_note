#include "List.hpp"
#include "Numbers.hpp"

#include "unity.h"

void test_empty_list(void) {
	std::shared_ptr<const ISeq> e = List::Empty;
	TEST_ASSERT_EQUAL_STRING("()", e->toString().c_str());
}

void test_empty_list_seq(void) {
	std::shared_ptr<const ISeq> e = List::Empty;
	TEST_ASSERT_EQUAL_STRING("()", e->seq()->toString().c_str());
	TEST_ASSERT_EQUAL_PTR(List::Empty.get(), e->seq().get());
}

void test_empty_list_cons(void) {
	std::shared_ptr<const ISeq> e = List::Empty;
	std::shared_ptr<const ISeq> a = e->cons(std::make_shared<const Integer>(Integer(1)));
	TEST_ASSERT_EQUAL_STRING("(1)", a->toString().c_str());
}

void test_empty_list_count(void) {
	std::shared_ptr<const ISeq> e = List::Empty;
	TEST_ASSERT_EQUAL_UINT(0, e->count());
}

void test_empty_list_empty(void) {
	std::shared_ptr<const ISeq> e = List::Empty;
	TEST_ASSERT_EQUAL_STRING("()", e->empty()->toString().c_str());
	TEST_ASSERT_EQUAL_PTR(List::Empty.get(), e->empty().get());
}

void test_empty_list_first(void) {
	std::shared_ptr<const ISeq> e = List::Empty;
	TEST_ASSERT_EQUAL_PTR(NULL, e->first().get());
}

void test_empty_list_next(void) {
	std::shared_ptr<const ISeq> e = List::Empty;
	TEST_ASSERT_EQUAL_PTR(NULL, e->next().get());
}

void test_empty_list_more(void) {
	std::shared_ptr<const ISeq> e = List::Empty;
	TEST_ASSERT_EQUAL_STRING("()", e->more()->toString().c_str());
	TEST_ASSERT_EQUAL_PTR(List::Empty.get(), e->more().get());
}


void test_list(void) {
	const std::shared_ptr<List> a = std::make_shared<List>(std::make_shared<const Integer>(Integer(1)));
	TEST_ASSERT_EQUAL_STRING("(1)", a->toString().c_str());
	TEST_ASSERT_EQUAL_STRING("(1)", a->seq()->toString().c_str());
	TEST_ASSERT_EQUAL_STRING("(2 1)", a->cons(std::make_shared<const Integer>(Integer(2)))->toString().c_str());
	TEST_ASSERT_EQUAL_UINT(1, a->count());
	TEST_ASSERT_EQUAL_PTR(List::Empty.get(), a->empty().get());
	TEST_ASSERT_EQUAL_STRING("1", a->first()->toString().c_str());
	TEST_ASSERT_EQUAL_STRING("()", a->more()->toString().c_str());
	TEST_ASSERT_EQUAL_PTR(NULL, a->next().get());
}

void test_list2(void) {
	std::vector<std::shared_ptr<const lisp_object> > entries({
		std::make_shared<const Integer>(Integer(1)),
		std::make_shared<const Integer>(Integer(2)),
		std::make_shared<const Integer>(Integer(3)),
		std::make_shared<const Integer>(Integer(4)),
		std::make_shared<const Integer>(Integer(5)),
		std::make_shared<const Integer>(Integer(6)),
		std::make_shared<const Integer>(Integer(7)),
		std::make_shared<const Integer>(Integer(8)),
	});
	const std::shared_ptr<List> a = std::make_shared<List>(entries);
	TEST_ASSERT_EQUAL_STRING("(1 2 3 4 5 6 7 8)", a->toString().c_str());
	TEST_ASSERT_EQUAL_STRING("(1 2 3 4 5 6 7 8)", a->seq()->toString().c_str());
	TEST_ASSERT_EQUAL_STRING("(9 1 2 3 4 5 6 7 8)", a->cons(std::make_shared<const Integer>(Integer(9)))->toString().c_str());
	TEST_ASSERT_EQUAL_UINT(8, a->count());
	TEST_ASSERT_EQUAL_PTR(List::Empty.get(), a->empty().get());
	TEST_ASSERT_EQUAL_STRING("1", a->first()->toString().c_str());
	TEST_ASSERT_EQUAL_STRING("(2 3 4 5 6 7 8)", a->more()->toString().c_str());
	TEST_ASSERT_EQUAL_STRING("(2 3 4 5 6 7 8)", a->next()->toString().c_str());
}


int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_empty_list);
    RUN_TEST(test_empty_list_seq);
    RUN_TEST(test_empty_list_cons);
    RUN_TEST(test_empty_list_count);
    RUN_TEST(test_empty_list_empty);
    RUN_TEST(test_empty_list_first);
    RUN_TEST(test_empty_list_next);
    RUN_TEST(test_empty_list_more);

    RUN_TEST(test_list);
    RUN_TEST(test_list2);
    return UNITY_END();
}
