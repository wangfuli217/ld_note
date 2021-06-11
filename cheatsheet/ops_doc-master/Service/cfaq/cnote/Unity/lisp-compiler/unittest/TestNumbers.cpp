#include "Numbers.hpp"

#include "unity.h"

struct test_data_i {
	long i;
	std::string expected;
};

void test_integer(void) {
	struct test_data_i data[] = {
		{0, "0"},
		{1, "1"},
		{-1, "-1"},
		{10, "10"},
		{-10, "-10"},
		{2736, "2736"},
		{-2736, "-2736"},
		{536870911, "536870911"},
		{-536870912, "-536870912"},
	};
	size_t data_count = sizeof(data)/sizeof(data[0]);
	for(size_t i = 0; i < data_count;  i++) {
		Integer a(data[i].i);
		TEST_ASSERT_EQUAL_STRING(data[i].expected.c_str(), a.toString().c_str());
		TEST_ASSERT_EQUAL(data[i].i, (long)a);

		const Integer b = a;
		TEST_ASSERT_EQUAL_STRING(data[i].expected.c_str(), b.toString().c_str());

		const Integer c(data[i].i);
		TEST_ASSERT_EQUAL_STRING(data[i].expected.c_str(), c.toString().c_str());
	}
}

struct test_data_f {
	double x;
	std::string expected;
};

void test_float(void) {
	struct test_data_f data[] = {
		{0.0, "0"},
        { 3.3830102744703936e-74, "3.38301e-74"},
        { -7.808793319244098e+180, "-7.80879e+180"},
        { -1.116240615436433e+257, "-1.11624e+257"},
        { -4.474217486501186e-98, "-4.47422e-98"},
        { 2.551330225124468e+227, "2.55133e+227"},
        { -5.586243311594498e+114, "-5.58624e+114"},
        { -1.9638495479072282e+39, "-1.96385e+39"},
        { -9.379950647423316e+83, "-9.37995e+83"},
        { -1.779476947470501e+101, "-1.77948e+101"},
        { -3.1562114238196845e-189, "-3.15621e-189"},
        { 5.923117747870643e-108, "5.92312e-108"},
        { 1.8563926817741926e-264, "1.85639e-264"},
        { -2.5118492190358267e-16, "-2.51185e-16"},
        { -2.8979900686128697e-99, "-2.89799e-99"},
        { 5.558913806322226e-202, "5.55891e-202"},
        { -4.199353966327336e-83, "-4.19935e-83"},
        { -7.947043443990472e-185, "-7.94704e-185"},
        { 1.2226938225065016e-25, "1.22269e-25"},
        { 1.5983262622130207e+56, "1.59833e+56"},
        { 1.084094471192463e-200, "1.08409e-200"},
        { 3.8547840245831654e-274, "3.85478e-274"},
        { 5.737113723493468e-131, "5.73711e-131"},
        { -6.354596607132215e+58, "-6.3546e+58"},
        { -4.644672297406679e-96, "-4.64467e-96"},
        { -1.247283555379344e+271, "-1.24728e+271"},
        { -1.922826530910511e+135, "-1.92283e+135"},
        { -1.150823979210901e+133, "-1.15082e+133"},
        { -9.625621103417222e-57, "-9.62562e-57"},
        { -1.394256960569535e+303, "-1.39426e+303"},
        { 1.106935384820126e+184, "1.10694e+184"},
        { 1.3745629336289501e-248, "1.37456e-248"},
        { -1.6239665626807802e+162, "-1.62397e+162"},
        { -2.8705374780007167e-09, "-2.87054e-09"},
        { 8.427026998307476e+287, "8.42703e+287"},
        { 9.693509881319873e-164, "9.69351e-164"},
        { -3.6644724313512395e+199, "-3.66447e+199"},
        { 2.4438302280087908e-17, "2.44383e-17"},
        { 1.603926355223715e+53, "1.60393e+53"},
        { -6.93715759327617e+263, "-6.93716e+263"},
        { 423247314940.0702, "4.23247e+11"},
	};
	size_t data_count = sizeof(data)/sizeof(data[0]);
	for(size_t i = 0; i < data_count;  i++) {
		Float a(data[i].x);
		TEST_ASSERT_EQUAL(data[i].x, (double)a);
		TEST_ASSERT_EQUAL_STRING(data[i].expected.c_str(), a.toString().c_str());

		const Float b = a;
		TEST_ASSERT_EQUAL_STRING(data[i].expected.c_str(), b.toString().c_str());

		const Float c(data[i].x);
		TEST_ASSERT_EQUAL_STRING(data[i].expected.c_str(), c.toString().c_str());
	}
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_integer);
    RUN_TEST(test_float);
    return UNITY_END();
}
