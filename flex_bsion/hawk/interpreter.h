#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <fcntl.h>
#include <unistd.h>
#include "entry.h"

#ifndef H_INTERPRETER
#define H_INTERPRETER

#define NUM_VARIABLE 0
#define STR_VARIABLE 1
typedef struct{
	char* id;
	int type;
	double dvalue;
	char* svalue;
} variable;

/*
typedef struct{
	char* id = "";
	int type = NUM_VARIABLE;
	double dvalue = 0;
	char* svalue = "";
} variable;
*/

int assign_variable(char* id, int type, char* svalue, double dvalue);
int assign_field(int field_number, char* value);
int get_variable(char* id, variable** var);
char* get_string_from_variable(char* id);
int print_variables();
int get_num_from_value(entry* value, double* store);
int get_str_from_value(entry* value, char** store);
int calculate_op(entry* cur, double* result);
int run_block(entry* cur);

#endif
