#include "format/fmt.h"
#include <stdlib.h>
#include <string.h>
#include "check.h"

static char *
int2str(void *arg) {
	int *a = arg;
	static char buf[50];
	fmt_sfmt(buf, 50, "%d", *a);
	return buf;
}

START_TEST(fmt_add_test)
{
	char *s = NULL;
	int i = 10;
	fmt_add('I', int2str);
	s = fmt_string("%I", &i);
	fail_unless(!strcmp(s, "10"), "malformat");
	free(s);
}
END_TEST

START_TEST(fmt_build_test) 
{
	stringvec_t v;
	char *res, *cp;
	size_t len;
	int i = 0;	

	fmt_starts(&v, 2);
	for(i = 0; i < 9; i++) {
		fmt_build(&v, 10, "%d.%d.%d\n", i, i, i);
	}
	res = fmt_finalize(&v, &len);

	fail_unless(len == 54, "len");

	i = 0;

	while((cp = strsep(&res, "\n"))) {
		if(*cp) {
			int a, b, c;
			sscanf(cp, "%d.%d.%d", &a, &b, &c);
			fail_unless(a == i && b == i && c == i, "num");
			i++;
		}
	}

	fail_unless(v.base == NULL, "zeroed");
	fail_unless(v.len == 0, "zeroed");
	fail_unless(v.off == 0, "zeroed");
}
END_TEST

#include <sys/types.h>
#include <sys/time.h>
#include <time.h>
#include "format/fmt-extra.h"
#include "flow.h"

START_TEST(extra_text) 
{
	fmt_register_netflow_short('F');
	fmt_register_netflow_long('G');

	{
		flow_t fp;
		memset(&fp, 0, sizeof(fp));
		free(fmt_string("%F", &fp));
		free(fmt_string("%f", &fp));
		free(fmt_string("%G", &fp));
		free(fmt_string("%g", &fp));
	}
}
END_TEST


START_TEST(fmt_no_build)
{
	stringvec_t v;
	char* s;
	size_t len;

	s = malloc(1);
	s[0] = 'X';
	free (s);

	fmt_starts (&v, 1);
	s = fmt_finalize (&v, &len);
	fail_unless (s[0] == NULL, NULL);
	fail_unless (len == 0, NULL);
	free (s);
}
END_TEST
