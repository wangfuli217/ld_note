#include <sys/types.h>
#include <err.h>	/* err() */
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>	/* printf(), puts() */
#include <string.h>	/* memset() */
#include <db.h>		/* dbopen() */

/*
 * color_example:
 *   Maps color strings to integer values, like "red" => 0xff0000.
 */
void
color_example(void)
{
	DB *db;
	DBT key, value;
	int i, r;

	puts("color_example:");

	/* Create an empty table. */
	db = dbopen(NULL, O_RDWR, 0777, DB_HASH, NULL);
	if (db == NULL)
		err(1, "dbopen");

	/* Add keys => values to table. */
	{
		char *keys[] = { "red", "green", "blue" };
		int values[] = { 0xff0000, 0x00ff00, 0x0000ff };

		for (i = 0; i < 3; i++) {
			/* key.size must count the '\0' byte */
			key.data = keys[i];
			key.size = strlen(keys[i]) + 1;
			value.data = &values[i];
			value.size = sizeof values[i];

			/*
			 * Insert key, value into table. DB will
			 * allocate its own storage for key, value.
			 */
			if (db->put(db, &key, &value, 0) < 0)
				err(1, "db->put");
		}
	}

	/* Check if keys exist. */
	{
		char *keys[] = { "blue", "green", "orange", "red" };

		for (i = 0; i < 4; i++) {
			key.data = (void *)keys[i];
			key.size = strlen(keys[i]) + 1;

			r = db->get(db, &key, &value, 0);
			if (r < 0)
				err(1, "db->get");
			else if (r > 0) {
				printf("\t'%s' is not in table\n",
				    (char *)key.data);
			} else {
				printf("\t'%s' has value %06x\n",
				    (char *)key.data, *(int *)value.data);
			}
		}
	}

	/* Destroy table. */
	db->close(db);
}


/*
 * number_example:
 *   Maps numbers to strings or numbers, like 2 => 2.71828 or 4 => "four".
 *
 * First I need a VALUE that can either be a string or a number.
 */
typedef struct value {
	int v_type;
#define T_NUM	0x1	/* use v_num */
#define T_STR	0x2	/* use v_str */

	union {
		double u_num;
		char *u_str;
	} v_union;
#define v_num v_union.u_num
#define v_str v_union.u_str
} VALUE;

void
number_example(void)
{
	DB *db;
	DBT key, value;
	VALUE v, *vp;
	double d;
	int i, r;

	puts("number_example:");

	db = dbopen(NULL, O_RDWR, 0777, DB_HASH, NULL);
	if (db == NULL)
		err(1, "dbopen");

	/* Add numeric values. */
	{
		double keys[] = { 2, 3, 4, 5.6 };
		double values[] = { 2.71828, 3.14159, 4.47214, 7.8 };

		for (i = 0; i < 4; i++) {
			memset(&v, 0, sizeof v);
			v.v_type = T_NUM;
			v.v_num = values[i];

			key.data = &keys[i];
			key.size = sizeof keys[i];
			value.data = &v;
			value.size = sizeof v;

			if (db->put(db, &key, &value, 0) < 0)
				err(1, "db->put");
		}
	}

	/*
	 * Add string values.
	 *
	 * For this example, all of my values will be static string
	 * constants. This removes the need to free(vp->v_str)
	 * when I replace or delete a value.
	 */
	{
		double keys[] = { 4, 8, 10 };
		char *values[] = { "four", "eight", "ten" };

		for (i = 0; i < 3; i++) {
			memset(&v, 0, sizeof v);
			v.v_type = T_STR;
			v.v_str = values[i];

			key.data = &keys[i];
			key.size = sizeof keys[i];
			value.data = &v;
			value.size = sizeof v;

			/*
			 * db->put can replace an entry (so I can change
			 * it from 4 => 4.47214 to 4 => "four").
			 *
			 * I am storing the strings outside the DB.
			 * To put them inside the DB, I would need to
			 * remove the v.v_str pointer and append each
			 * string data to value.data.
			 */
			if (db->put(db, &key, &value, 0) < 0)
				err(1, "db->put");
		}
	}

	/* Delete key 8. */
	d = 8;
	key.data = &d;
	key.size = sizeof d;
	r = db->del(db, &key, 0);
	if (r < 0)
		err(1, "db->del");

	/* Iterate all keys. */
	r = db->seq(db, &key, &value, R_FIRST);
	if (r < 0)
		err(1, "db->seq");
	else if (r > 0)
		puts("\tno keys!");
	else {
		printf("\tall keys: %g", *(double *)key.data);
		while ((r = db->seq(db, &key, &value, R_NEXT)) == 0)
			printf(", %g", *(double *)key.data);
		if (r < 0)
			err(1, "db->seq");
		puts("");
	}

	/* Check if keys exist. */
	{
		double keys[] = { 2, 3, 4, 5.6, 7, 8, 10 };

		for (i = 0; i < 7; i++) {
			key.data = &keys[i];
			key.size = sizeof keys[i];

			r = db->get(db, &key, &value, 0);
			if (r < 0)
				err(1, "db->get");
			else if (r > 0) {
				printf("\t%g is not in the table\n", keys[i]);
				continue;
			}

			vp = (VALUE *)value.data;
			if (vp->v_type & T_NUM) {
				printf("\t%g has value %g\n",
				    keys[i], vp->v_num);
			} else if (vp->v_type & T_STR) {
				printf("\t%g has value '%s'\n",
				    keys[i], vp->v_str);
			} else {
				printf("\t%g has invalid value\n",
				    keys[i]);
			}
		}
	}

	db->close(db);
}

int
main()
{
	color_example();
	number_example();
	return 0;
}