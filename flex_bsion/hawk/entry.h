#ifndef H_ENTRY
#define H_ENTRY

	typedef enum {
			none = 0, singleop, blockop, exprop, assignop, value, strvalue, id, binaryop, unaryop, ifop, whileop, funop, regex, arrvalue
	} entry_type ;

	/*
	 typedef struct {
		entry_type type = none;
		entry* argv[5];
		int argc = 0;
		char* text = "\0"; //NULL;// = (char*)calloc(1024, sizeof(char));
		char op = '\0';
		char op2 = '\0';
	} entry;
	*/
	
	typedef struct {
		entry_type type;
		struct entry** argv;
		int argc;
		char* text; 
		char op;
		char op2;
	} entry;
	#define YYSTYPE entry*

	entry* new_entry_0();

	void yyerror(char *s);
	int readInputForLexer( char *buffer, int *numBytesRead, int maxBytesToRead );
	
	//Headers for 1.y
	void printop(char *s);
	void printrun(char* s);	
	void die(char* s, int exitcode);
	void warning(char* s);
	extern entry* yylval;
	int yyparse();
	void rec_print(entry* a, int depth);
	
	#define ARGUMENTS_ERROR 1
	#define SYNTAX_ERROR 2
	#define VAR_NOT_FOUND_ERROR 3
	#define REGEX_ERROR 4
	#define SUB_NOT_FOUND_ERROR 5
	#define IO_ERROR 6
	
//	#define FILE_INPUT_BUFFER_SIZE 65536
	#define FILE_INPUT_BUFFER_SIZE (16*1024*1024)
	#define SMALL_STRING_BUFFER_SIZE 64
	#define BIG_STRING_BUFFER_SIZE 1024 * 1024 * 4
//	#define BIG_STRING_BUFFER_SIZE 1024 
	#define VARIABLES_COUNT 1024
	
#endif
