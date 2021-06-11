#include <stddef.h>
#include <stdio.h>

///
/// @brief Appends contents of array `from` to array `to`.
/// @pre `limit` != `0`
/// @note No operation is performed for a `limit` of `0`.
/// @remarks Resulting array is NUL-terminated.
/// @param [out] to      String to be written to.
/// @param limit         Maximum number of bytes that string `to` can store, including NUL.
/// @param [in] from     String to be copied from.
/// @returns Size of resulting string (NUL not counted).
///
size_t strscat(char *to, size_t limit, const char *from)
{
    size_t s=0;

    if (limit != 0)
    {
        while (to[s] != '\0')
            ++s;

        for (size_t i=0; from[i] != '\0' && s < limit - 1; ++i, ++s)
            to[s] = from[i];

        to[s] = '\0';
    }

    return s;
}

typedef struct
{
    char        *to;
    size_t      limit;
    const char  *from;
    const char  *result;
    size_t      retval;
} test_t;

static size_t tests_failed;

static void run_test(test_t *t)
{
    size_t i=0;

    if (t->retval != strscat(t->to, t->limit, t->from))
    {
        ++tests_failed;
        return;
    }

    while (t->result[i] != '\0' || t->to[i] != '\0')
        if (t->result[i] != t->to[i])
        {
            ++tests_failed;
            break;
        }
        else
            ++i;
}

#define RUN_TEST(...)   run_test(&(test_t){__VA_ARGS__})

int 
main(int argc, char* argv[])
{
    RUN_TEST(
        .to     = (char[15]){"The Cutty"},
        .limit  = 15,
        .from   = " Sark is a ship dry-docked in London.",
        .result = "The Cutty Sark",
        .retval = 14
    );

    RUN_TEST(
        .to     = (char[15]){"The Cutty"},
        .limit  = 0,
        .from   = "this won't get appended",
        .result = "The Cutty",
        .retval = 0
    );

    RUN_TEST(
        .to     = (char[15]){"The Cutty"},
        .limit  = 15,
        .from   = "!",
        .result = "The Cutty!",
        .retval = 10
    );

    RUN_TEST(
        .to     = (char[]){"The Cutty Sark"},
        .limit  = 3,
        .from   = "this shouldn't get appended",
        .result = "The Cutty Sark",
        .retval = 14
    );

    RUN_TEST(
        .to     = (char[]){"The Cutty Sark"},
        .limit  = 1,
        .from   = "this shouldn't get appended, either",
        .result = "The Cutty Sark",
        .retval = 14
    );

    RUN_TEST(
        .to     = (char[]){""},
        .limit  = 1,
        .from   = "this had better not get appended!",
        .result = "",
        .retval = 0
    );

    (void)fprintf(stderr, "Number of tests failed: %zu.\n", tests_failed);
	
	system("pause");
	
	return 0;
}
