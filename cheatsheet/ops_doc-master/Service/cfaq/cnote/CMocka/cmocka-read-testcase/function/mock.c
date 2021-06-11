/*
  will_return()和mock()是成对使用的：即有几个will_return()就要相应数量的mock()、mock_type()、mock_ptr_type(),

  但是mock()可以单独使用，这时不一定需要will_return()。

  */

#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef assert
#undef assert
#endif 
#define assert(expression) \
    mock_assert((int)(expression), #expression, __FILE__, __LINE__)
void mock_assert(const int result, const char* expression, const char *file,
                 const int line);

#define array_length(x) (sizeof(x) / sizeof((x)[0]))

typedef int (*BinaryOperator)(int a, int b);

typedef struct OperatorFunction 
{
	const char* operator;
	BinaryOperator function;
} OperatorFunction;

extern BinaryOperator find_operator_function_by_string(
        const size_t number_of_operator_functions,
        const OperatorFunction * const operator_functions,
        const char* const operator_string);
extern int perform_operation(
        int number_of_arguments, char *arguments[],
        const size_t number_of_operator_functions,
        const OperatorFunction * const operator_functions,
        int * const number_of_intermediate_values,
        int ** const intermediate_values, int * const error_occurred);
extern int example_main(int argc, char *argv[]);

int example_test_fprintf(FILE* const file, const char *format, ...) CMOCKA_PRINTF_ATTRIBUTE(2, 3);
int example_test_printf(const char *format, ...) CMOCKA_PRINTF_ATTRIBUTE(1, 2);		
	
BinaryOperator find_operator_function_by_string(
        const size_t number_of_operator_functions,
        const OperatorFunction * const operator_functions,
        const char* const operator_string)
{
    size_t i;
    assert(!number_of_operator_functions || operator_functions);
    assert(operator_string != NULL);

    for (i = 0; i < number_of_operator_functions; i++) 
	{
        const OperatorFunction *const operator_function =
            &operator_functions[i];
        if (strcmp(operator_function->operator, operator_string) == 0) {
            return operator_function->function;
        }
    }
    return NULL;
}

static int binary_operator(int a, int b)
{
	check_expected(a);
	check_expected(b);
	return (int)mock();    //这里只有mock()，没有will_return 
}

static void test_find_operator_function_by_string_null_string(void **state)
{
	const OperatorFunction operator_functions[] = {
		{"+", binary_operator},
	};

    (void) state; 

	expect_assert_failure(find_operator_function_by_string(
	    array_length(operator_functions), operator_functions, NULL));  
	
}

int main(void) {
	const struct CMUnitTest tests[] = {

		cmocka_unit_test(test_find_operator_function_by_string_null_string),
		
	};
	return cmocka_run_group_tests(tests, NULL, NULL);
}