
/* 
 ============================================================================
 * Program Name 	: scanner.l
 * Author		: #B96902133, Hakki Caner Kirmizi
 * Description		: A C source code scanner written with flex.
 * Environment		: Windows-7 Entreprise
 * Editor		: vim 7.2 for WIN 
 * Integration Tests	: linux2.csie.ntu.edu.tw
 * Flex			: 2.5.35
 * Compiler		: gcc (Debian 4.4.3-3) 4.4.3
 * Version Control	: TortoiseSVN 1.6.7, Build 18415 - 32 Bit
 * Project Hosting	: http://code.google.com/p/c-source-scanner/
 * 
 * INSTRUCTIONS
 * ------------
 * Build		: flex scanner.l
 * Compile		: gcc lex.yy.c
 * Run			: There are two options...
 *  1) a.out [input-filename] // recommended for long source codes
 *  2) a.out // hit enter and use stdin; BE AWARE OF BUFFER SIZE!!!
 * 
 * DETAILS
 * -------
 * c-source-scanner is written for these purposes:
 *  1) To understand how to scan a program's source code file.
 *  2) To understand how to use a scanner generator to 'generate' a 
 *     source code generator.
 *  3) To understand how to use finite automata concept via defining regular 
 *     expressions to match the lexeme of the code and output the tokens.
 * 
 * c-source-scanner is NOT written for these purposes (at-least-for-now):
 *  1) To provide a 'full' scanner program for C language.
 *  2) To construct a symbol table for future enhancements of building a 
 *     real compiler.
 *
 * NOTES
 * -----
 *  1) scanner.l follows up the c naming conventions: 
 *     http://www.cprogramming.com/tutorial/style_naming_conventions.html
 *  2) Constant ID of the ASCII characters are same with their ASCII codes.
 *  3) Regex for comments based on: 
 *     http://ostermiller.org/findcomment.html
 *  4) O'Reilly's Flex&Bison book is a very good resource, if you want to
 *     know more about flex and bison.
 ============================================================================
 */

	/* we do not need flex library */
%option noyywrap
  
	/* ----- DEFINITIONS PART ----- */
	/* ============================ */
	
	/* DEFINITIONS FOR TOKEN CODES */
	/* --------------------------- */
	
	/* ' The literal block %{ ... %} ' in this part is copied to verbatim to the generated 
	    C source file near the beginning, before the beginning of yylex() */
%{
#define PLUS		43
#define MINUS		45
#define MULT		42
#define DIV		47
#define PERCENT		37
#define LAND		265
#define LOR		266
#define LNOT		33
#define LESSTHAN	60
#define GREATERTHAN 	62
#define LTEQUAL		261		
#define GTEQUAL		262
#define EQUAL		263		
#define NOTEQUAL	264
#define BITAND		38
#define BITOR		124
#define BITXOR		94
#define LPARA		40
#define RPARA		41
#define LBRACKET	91
#define RBRACKET	93
#define LCURLY		123
#define RCURLY		125
#define COMMA		44
#define SEMICOLON	59
#define ASSIGN		61
#define CHARSYM		268
#define INTSYM		269
#define VOIDSYM		270
#define IFSYM		271
#define ELSESYM		272
#define WHILESYM	273
#define FORSYM		274
#define CONTINUESYM	275
#define BREAKSYM	276
#define RETURNSYM	277
#define IDENTIFIER	258
#define INTEGER		259
#define STRING		260

/* Function		: dec_to_hex
 * Description		: Decimal to Hexadecimal Converter
 * The function takes a char pointer (which is flex's yytext) and using 
 * format place holder tecnique to do the convertion. Additionally it
 * manipulates the string to construct the 32-bit representation of the 
 * hexadecimal number (e.g. 0x7fffffff).
 */
const char* dec_to_hex(const char* number) {
	char *temp;
	char *buffer;
	int len, i;
	
	temp = malloc(sizeof(char) * 11);
	buffer = malloc(sizeof(char) * 8);
	sprintf(buffer, "%x", atoi(number));
	sprintf(temp, "0x");
	len = strlen(buffer);
	
	for (i=2; i<10-len; i++)
		temp[i] = '0';
	
	strncat(temp, buffer, len);
	return temp;
	free(buffer);
	free(temp);
}

/* Function		: clean_str 
 * Description		: Remove leading/tailing double quotes of string
 * The function takes a char pointer (which is flex's yytext) and using 
 * strncpy function to copy it to the temp array starting from the 1st
 * index of 'str' and ignoring the tailing double quote with exchanging
 * it a null-character.
 */
const char* clean_str(const char* str) {
	char *temp;
	int len;
	len = strlen(str);
	temp = malloc(sizeof(char) * (len-1));
	strncpy(temp, (++str), len-1);
	temp[len-2] = '\0';
	return temp;
	free(temp);
}

%}

	/* DEFINITIONS FOR FINITE AUTOMATA */
	/* ------------------------------- */
	
	/* Universal Character Name: the naming conventions for UCS defined by International Standard ISO/IEC 10646 */
UCN     		(\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8})
	
	/* DIGIT: any number from 0 to 9 */
DIGIT			[0-9]

	/* LETTER: any uppercase or lowercase letter */
LETTER			[A-Za-z]

	/* DELIMITER: any occurence of 'space', 'tab' or 'newline' */
DELIMITER		[ \t\n]

	/* IDENTIFIER: starting with a letter; following by any occurence of letter, digit or underscore */
IDENTIFIER		([_a-zA-Z]|{UCN})([_a-zA-Z0-9]|{UCN})*

	/* INTEGER: 0 or more occurence of consecutive digits */
INTEGER			0|([1-9][0-9]*)

	/* STRING: anything between double quote; just considers \" and \\ characters */
STRING			L?\"([^"\\]|\\['"?\\abfnrtv]|\\[0-7]{1,3}|\\[Xx][0-9a-fA-F]+|{UCN})*\"

	/* COMMENT: any c style comment */
COMMENT			("/*"([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*"*"+"/")|("//".*)


%%
	/* ----- RULES PART ----- */
	/* ====================== */

	/* RULES FOR OPERATORS AND PUNCTUATIONS */
	/* ------------------------------------ */
"+"			{ printf("%d\n", PLUS); }
"-" 			{ printf("%d\n", MINUS); }
"*"			{ printf("%d\n", MULT); }
"/"			{ printf("%d\n", DIV); }
"%"			{ printf("%d\n", PERCENT); }
"&&"			{ printf("%d\n", LAND); }
"||"			{ printf("%d\n", LOR); }
"!"			{ printf("%d\n", LNOT); }
"<"			{ printf("%d\n", LESSTHAN); }
">"			{ printf("%d\n", GREATERTHAN); }
"<="			{ printf("%d\n", LTEQUAL); }
">="			{ printf("%d\n", GTEQUAL); }
"=="			{ printf("%d\n", EQUAL); }
"!="			{ printf("%d\n", NOTEQUAL); }
"&"			{ printf("%d\n", BITAND); }
"|"			{ printf("%d\n", BITOR); }
"^"			{ printf("%d\n", BITXOR); }
"("			{ printf("%d\n", LPARA); }
")"			{ printf("%d\n", RPARA); }
"["			{ printf("%d\n", LBRACKET); }
"]"			{ printf("%d\n", RBRACKET); }
"{"			{ printf("%d\n", LCURLY); }
"}"			{ printf("%d\n", RCURLY); }
","			{ printf("%d\n", COMMA); }
";"			{ printf("%d\n", SEMICOLON); }
"="			{ printf("%d\n", ASSIGN); }

	/* RULES FOR KEYWORDS */
	/* ------------------ */
"char"			{ printf("%d\n", CHARSYM); }
"int"			{ printf("%d\n", INTSYM); }
"void"			{ printf("%d\n", VOIDSYM); }
"if"			{ printf("%d\n", IFSYM); }
"else"			{ printf("%d\n", ELSESYM); }
"while"			{ printf("%d\n", WHILESYM); }
"for" 			{ printf("%d\n", FORSYM); }
"continue"		{ printf("%d\n", CONTINUESYM); }
"break"			{ printf("%d\n", BREAKSYM); }
"return"		{ printf("%d\n", RETURNSYM); }
	
	/* RULES FOR IDENTIFIIERS */
	/* ---------------------- */
{IDENTIFIER}		{ printf("%d\t%s\n", IDENTIFIER, yytext); }

	/* RULES FOR LITERALS */
	/* ------------------ */
{INTEGER}		{ printf("%d\t%s\n", INTEGER, dec_to_hex(yytext)); }
{STRING}		{ printf("%d\t%s\n", STRING, clean_str(yytext)); }

	/* ignore any kind of white space; i.e. no 'action'! */
{DELIMITER}+

	/* ignore any kind of comments; i.e. no 'action'! */
{COMMENT}

%%
	/* ----- USER CODE PART ----- */
	/* ========================== */
main(argc, argv)
int argc;
char **argv;
{
	YY_BUFFER_STATE bp;
	extern FILE* yyin;
	
	if (argc>1) {
		yyin = fopen(argv[1],"r");
	} else {
		yyin = stdin;
		bp = yy_create_buffer(yyin, YY_BUF_SIZE); // YY_BUF_SIZE defined by flex, typically 16K=16384
		yy_switch_to_buffer(bp);  // tell it to use the buffer we just made
	}
	yylex();
}