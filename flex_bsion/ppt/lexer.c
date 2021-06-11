
// This is an ad-hoc lexer

#include <stdio.h>
#include <ctype.h>
#include <stdbool.h>
#include "string.h"

typedef enum TokenType {
	TYPE_AUTO,
	TYPE_BREAK,
	TYPE_CASE,
	TYPE_CHAR,
	TYPE_CONST,
	TYPE_CONTINUE,
	TYPE_DEFAULT,
	TYPE_DO,
	TYPE_DOUBLE,
	TYPE_ELSE,
	TYPE_ENUM,
	TYPE_EXTERN,
	TYPE_FLOAT,
	TYPE_FOR,
	TYPE_GOTO,
	TYPE_IF,
	TYPE_INT,
	TYPE_LONG,
	TYPE_REGISTER,
	TYPE_RETURN,
	TYPE_SHORT,
	TYPE_SIGNED,
	TYPE_SIZEOF,
	TYPE_STATIC,
	TYPE_STRUCT,
	TYPE_SWITCH,
	TYPE_TYPEDEF,
	TYPE_UNION,
	TYPE_UNSIGNED,
	TYPE_VOID,
	TYPE_VOLATILE,
	TYPE_WHILE,
	TYPE_CONSTANT,
	TYPE_STRING_LITERAL,
	TYPE_ELLIPSIS,
	TYPE_RIGHT_ASSIGN,
	TYPE_LEFT_ASSIGN,
	TYPE_ADD_ASSIGN,
	TYPE_SUB_ASSIGN,
	TYPE_MUL_ASSIGN,
	TYPE_DIV_ASSIGN,
	TYPE_MOD_ASSIGN,
	TYPE_AND_ASSIGN,
	TYPE_XOR_ASSIGN,
	TYPE_OR_ASSIGN,
	TYPE_RIGHT_OP,
	TYPE_LEFT_OP,
	TYPE_INC_OP,
	TYPE_DEC_OP,
	TYPE_PTR_OP,
	TYPE_AND_OP,
	TYPE_OR_OP,
	TYPE_LE_OP,
	TYPE_GE_OP,
	TYPE_EQ_OP,
	TYPE_NE_OP,
	TYPE_SEMICOLON,
	TYPE_LEFT_BRACE,
	TYPE_RIGHT_BRACE,
	TYPE_COMMA,
	TYPE_ASSIGN,
	TYPE_LEFT_PAREN,
	TYPE_RIGHT_PAREN,
	TYPE_LEFT_BRACKET,
	TYPE_RIGHT_BRACKET,
	TYPE_DOT,
	TYPE_AND,
	TYPE_NOT,
	TYPE_TILDE,
	TYPE_SUB,
	TYPE_ADD,
	TYPE_MUL,
	TYPE_DIV,
	TYPE_MOD,
	TYPE_GREATER,
	TYPE_LESS,
	TYPE_XOR,
	TYPE_OR,
	TYPE_QUESTION_MARK,
	TYPE_IDENTIFIER,
	TYPE_CONSTANT,
	TYPE_STRING_LITERAL,
	TYPE_CHARACTER,
	TYPE_UNKNOWN,
};

typedef struct Token {
	TokenType type;
	String string;
	union {
		int value_integer;
		char *value_string;
		double value_double;
	} value;
};

typedef struct Keyword {
	TokenType type;
	char *word;
};

typedef struct TokenTypeAction {
	TokenType type;
	int (*get_matched)(FILE *, String *);
};

int token_create(Token *token) {
	token = malloc(sizeof(struct Token));
	if (token == NULL) {
		return -1;
	}
	token->type = TYPE_UNKNOWN;
	if (string_create(token->string) < 0) {
		return -1;
	}
	return 0;
}

int token_destroy(Token *token) {
	string_destroy(token->string);
	free(token);
	return 0;
}

int token_update(Token *token, TokenType type, char *string) {
	token->type = type;
	string_assign(token->string, string);
	return 0;
}

int token_update_if_longer(Token *token, TokenType type, char *string) {
	if (strlen(string) > string_size(token->string)) {
		token_update(token, type, string);
	}
	return 0;
}

int put_back_file(FILE *file_pointer, const char *string) {
	for (int i = strlen(string) - 1; i >= 0; i--) {
		ungetc(string[i], file_pointer);
	}
	return 0;
}

bool is_word(File *file_pointer, const char *word) {
	const int word_size = strlen(word);
	bool is_successful = true;
	char matched_characters[word_size];
	int matched_characters_size = 0;
	for (int i = 0; i < word_size; i++) {
		char c = fgetc(file_pointer);
		if (c == EOF || c != word[i]) {
			is_successful = false;
			break;
		}
		matched_characters[matched_characters_size] = c;
		matched_characters_size++;
	}
	put_back_file(file_pointer, matched_characters);
	return is_successful;
}

int skip_space(FILE *file_pointer) {
	char c;
	do {
		c = fgetc(file_pointer);
	} while (c != EOF && isspace(c));
	ungetc(c, file_pointer);
}

int skip_comment(FILE *file_pointer) {
	char c;
	if (is_word(file_pointer, "#") || is_word(file_pointer, "//")) {
		skip_to(file_pointer, "\n");
	} else if (is_word(file_pointer, "/*")) {
		skip_to(file_pointer, "*/");
	}
	return 0;
}

int scan_to(FILE *file_pointer, String *string, const char *word) {
	const int word_size = strlen(word);
	if (word_size == 0) {
		return 0;
	}
	String *temp_string;
	string_create(temp_string);
	do {
		if (get_word(file_pointer, temp_string, word) > 0) {
			string_concat(temp_string, word);
			break;
		}
		c = fgetc(file_pointer);
		if (c != EOF) {
			string_push_back(temp_string, c);
		}
	} while (c != EOF);
	int temp_string_size = string_size(temp_string);
	put_back_file(file_pointer, string_raw(temp_string));
	string_concat(string, temp_string);
	string_destroy(temp_string);
	return temp_string_size;
}

int skip_to(FILE *file_pointer, const char *word) {
	String *temp_string;
	string_create(temp_string);
	int scanned_size = scan_to(file_pointer, temp_string, word);
	if (scanned_size <= 0) {
		string_destroy(temp_string);
		return 0;
	}
	string_destroy(temp_string);
	fseek(file_pointer, scanned_size, SEEK_CUR);
	return scanned_size;
}

int get_string_literal(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	char c = fgetc(file_pointer);	
	if (c == EOF) {
		string_destroy(temp_string);
		return 0;
	}
	string_push_back(temp_string, c);
	if (c != '\"') {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	int scanned_size = scan_to(file_pointer, temp_string, "\"");
	if (scanned_size <= 0) {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	string_concat(string, temp_string);
	put_back_file(file_pointer, string_raw(temp_string));
	string_destroy(temp_string);
	return 0;
}

typedef struct Buffer {
	String *string;
	FILE *file_pointer;
};

int buffer_create(Buffer *buffer, FILE *file_pointer) {
	buffer = malloc(sizeof(String));
	if (buffer == NULL) {
		return -1;
	}
	if (string_create(buffer->string) < 0) {
		return -1;
	}
	buffer->file_pointer = file_pointer;
	return 0;
}

int buffer_destory(Buffer *buffer) {
	put_back_file(buffer->file_pointer, string_raw(buffer->string));
	free(buffer->string);
	free(buffer);
}

int buffer_get_next_any(Buffer *buffer) {
	char c = fgetc(buffer->file_pointer);
	if (c == EOF) {
		return 0;
	}
	return 1;
}

int buffer_get_next(Buffer *buffer, char target) {
	char c = fgetc(buffer->file_pointer);
	if (c == EOF) {
		return 0;
	}
	if (c != target) {
		ungetc(c);
		return 0;
	}
	string_push_back(buffer->file_pointer, c);
	return 1;
}

int buffer_string_size(Buffer *buffer) {
	return string_size(buffer->string);
}

int buffer_concat_after_string(Buffer *buffer, String *string) {
	if (string_concat(string, string_raw(buffer->string)) < 0) {
		return -1;
	}
	return 0;
}

/*int get_character(FILE *file_pointer, String *string) {
	Buffer *buffer;
	buffer_create(buffer, file_pointer);
	if (buffer_get_next(buffer, '\'') == 0) {
		buffer_destory(buffer);
		return 0;
	}
	if (buffer_get_next_any(buffer) == 0) {
		buffer_destory(buffer);
		return 0;
	}
	if (buffer_get_next(buffer, '\'') == 0) {
		buffer_destory(buffer);
		return 0;
	}
	int buffer_string_size = buffer_string_size(buffer);
	buffer_concat_after_string(buffer, string);
	buffer_destroy(buffer);
	return buffer_string_size;
}*/

int get_character(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	char c = fgetc(file_pointer);
	if (c == EOF) {
		string_destroy(temp_string);
		return 0;
	}
	string_push_back(temp_string, c);
	if (c != '\'') {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	c = fgetc(file_pointer);
	if (c == EOF) {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	string_push_back(temp_string, c);
	c = fgetc(file_pointer);
	if (c == EOF) {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}	
	string_push_back(temp_string, c);
	if (c != '\'') {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	put_back_file(file_pointer, string_raw(string));
	string_concat(string, temp_string);
	string_destroy(temp_string);
	return 0;
}

/*int get_identifier(FILE *file_pointer, String *string) {
	Buffer *buffer;
	buffer_create(buffer, file_pointer);
	int l_size = get_l(file_pointer, temp_string);
	if (l_size <= 0) {
		return 0;
	}
	fseek(file_pointer, l_size, SEEK_CUR);
	int total_size = l_size;
	do {
		int next_size = get_l(file_pointer, temp_string) == 0? get_d(file_pointer, temp_string): 0;
		if (next_size > 0) {
			fseek(file_pointer, next_size, SEEK_CUR);
			total_size += next_size;
		}
	} while (next_size > 0);
	put_back_file(file_pointer, string_raw(temp_string));
	string_concat(string, temp_string);
	string_destroy(temp_string);
	return total_size;
}*/

int get_identifier(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	int l_size = get_l(file_pointer, temp_string);
	if (l_size <= 0) {
		return 0;
	}
	fseek(file_pointer, l_size, SEEK_CUR);
	int total_size = l_size;
	do {
		int next_size = get_l(file_pointer, temp_string) == 0? get_d(file_pointer, temp_string): 0;
		if (next_size > 0) {
			fseek(file_pointer, next_size, SEEK_CUR);
			total_size += next_size;
		}
	} while (next_size > 0);
	put_back_file(file_pointer, string_raw(temp_string));
	string_concat(string, temp_string);
	string_destroy(temp_string);
	return total_size;
}

/*int get_constant_hex(FILE *file_pointer, String *string) {
	Buffer *buffer;
	buffer_create(buffer, file_pointer);
	if (buffer_get_next(buffer, '0') == 0) {
		buffer_destory(buffer);
		return 0;
	}
	if (buffer_get_next(buffer, 'x') == 0 && buffer_get_next(buffer, 'X') == 0) {
		buffer_destory(buffer);
		return 0;
	}
	int h_size = get_h(file_pointer, temp_string);
	if (h_size <= 0) {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	fseek(file_pointer, h_size, SEEK_CUR);
	while ((h_size = get_h(file_pointer, temp_string)) > 0) {
		fseek(file_pointer, h_size, SEEK_CUR);
	}
	get_is(file_pointer, temp_string);
	put_back_file(file_pointer, string_raw(temp_string));
	int temp_string_size = string_size(temp_string);
	string_concat(string, temp_string);
	string_destroy(temp_string);
	return temp_string_size;
}*/

int get_constant_hex(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	char c = fgetc(file_pointer);
	string_push_back(temp_string, c);
	if (c != '0') {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	c = fgetc(file_pointer);
	string_push_back(temp_string, c)
	if (c != 'x' && c != 'X') {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	int h_size = get_h(file_pointer, temp_string);
	if (h_size <= 0) {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	fseek(file_pointer, h_size, SEEK_CUR);
	while ((h_size = get_h(file_pointer, temp_string)) > 0) {
		fseek(file_pointer, h_size, SEEK_CUR);
	}
	get_is(file_pointer, temp_string);
	put_back_file(file_pointer, string_raw(temp_string));
	int temp_string_size = string_size(temp_string);
	string_concat(string, temp_string);
	string_destroy(temp_string);
	return temp_string_size;
}

int get_constant_normal(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	int digits_size = get_digits(file_pointer, temp_string);
	if (digits_size == 0 || (digits_size == 1 && string_get(temp_string, 0) == '0')) {
		string_destroy(temp_string);
		return 0;
	}
	int is_size = get_is(file_pointer, temp_string);
	fseek(file_pointer, is_size, SEEK_CUR);
	put_back_file(file_pointer, string_raw(temp_string));
	int temp_string_size = string_size(temp_string);
	string_concat(string, temp_string);
	string_destroy(temp_string);
	return temp_string_size;
}

/*bool is_d(FILE *file_pointer) {
	char c = fgetc(file_pointer);
	ungetc(c, file_pointer);
	if (isdigit(c)) {
		return true;
	}
	return false;
}*/

int get_d(FILE *file_pointer, String *string) {
	char c = fgetc(file_pointer);
	ungetc(c, file_pointer);
	if (c == EOF || !isdigit(c)) {
		return 0;
	}
	string_push_back(string, c);
	return 1;
}

int get_l(FILE *file_pointer, String *string) {
	char c = fgetc(file_pointer);
	ungetc(c, file_pointer);
	if (c == EOF || (!isalpha(c) && c != '_')) {
		return 0;
	}
	string_push_back(string, c);
	return 1;
}

int get_h(FILE *file_pointer, String *string) {
	char c = fgetc(file_pointer);
	ungetc(c, file_pointer);
	if (c == EOF || (c < 'A' && c > 'F' && c < 'a' && c > 'f')) {
		return 0;
	}
	string_push_back(string, c);
	return 1; 
}

int get_digits(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	while (get_d(file_pointer, temp_string) >= 0) {
		fseek(file_pointer, 1, SEEK_CUR);
	}
	put_back_file(file_pointer, string_raw(temp_string));
	string_concat(string, string_raw(temp_string));
	int temp_string_size = string_size(temp_string);
	string_destroy(temp_string);
	return temp_string_size;
}

int get_e(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	char c = fgetc(file_pointer);
	string_push_back(temp_string, c);
	if (c == EOF || (c != 'e' && c != 'E')) {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	c = fgetc(file_pointer);
	string_push_back(temp_string, c);
	if (c == EOF || (c != '+' && c != '-' && !isdigit(c))) {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	int digits_size = get_digits(file_pointer, temp_string);
	if (digits_size <= 0) {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	fseek(file_pointer, digits_size, SEEK_CUR);
	if (string_concat(string, string_raw(temp_string)) < 0) {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	int temp_string_size = string_size(temp_string);
	string_destroy(temp_string);
	return temp_string_size;
}

int get_fs(FILE *file_pointer, String *string) {
	char c = fgetc(file_pointer);
	if (c == EOF || (c != 'f' && c != 'F' && c != 'l' && c != 'L')) {
		ungetc(c, file_pointer);
		return 0;
	}
	string_push_back(string, c);
	return 1;
}

int get_is(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	char c;
	do {
		c = fgetc(file_pointer);
		string_push_back(temp_string, c);
	} while (c != EOF && (c == 'u' || c == 'U' || c == 'l' || c == 'L'));
	put_back_file(file_pointer, string_raw(temp_string));
	string_pop_back(temp_string);
	string_concat(string, string_raw(temp_string));
	int temp_string_size = string_size(temp_string);
	string_destroy(temp_string);
	return temp_string_size;
}

int get_constant_float_type_1(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	int digits_size = get_digits(file_pointer, temp_string);
	if (digits_size <= 0) {
		string_destroy(temp_string);
		return 0
	}
	fseek(file_pointer, digits_size, SEEK_CUR);
	int e_size = get_e(file_pointer, temp_string);
	if (e_size <= 0) {
		string_destroy(temp_string);
		return 0;
	}
	fseek(file_pointer, e_size, SEEK_CUR);
	int fs_size = get_fs(file_pointer, temp_string);
	fseek(file_pointer, fs_size, SEEK_CUR);
	put_back_file(file_pointer, string_raw(temp_string));
	string_concat(string, string_raw(temp_string));
	int temp_string_size = string_size(temp_string);
	string_destroy(temp_string);
	return temp_string_size;
}

int get_constant_float_type_2(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	int digits_size = get_digits(file_pointer, temp_string);
	fseek(file_pointer, digits_size, SEEK_CUR);
	if (get_word(file_pointer, temp_string, ".") <= 0) {
		string_destroy(temp_string);
		return 0;
	}
	fseek(file_pointer, 1, SEEK_CUR);
	digits_size = get_digits(file_pointer, temp_string);
	if (digits_size <= 0) {
		string_destroy(temp_string);
		return 0;
	}
	int e_size = get_e(file_pointer, temp_string);
	fseek(file_pointer, e_size, SEEK_CUR);
	int fs_size = get_fs(file_pointer, temp_string);
	fseek(file_pointer, fs_size, SEEK_CUR);
	put_back_file(file_pointer, string_raw(temp_string));
	string_concat(string, string_raw(temp_string));
	int temp_string_size = string_size(temp_string);
	string_destroy(temp_string);
	return temp_string_size;	
}

int get_constant_float_type_3(FILE *file_pointer, String *string) {
	String *temp_string;
	string_create(temp_string);
	int digits_size = get_digits(file_pointer, temp_string);
	if (digits_size <= 0) {
		string_destroy(temp_string);
		return 0;
	}
	if (get_word(file_pointer, temp_string, ".") <= 0) {
		string_destroy(temp_string);
		return 0;
	}
	fseek(file_pointer, 1, SEEK_CUR);
	digits_size = get_digits(file_pointer, temp_string);
	if (digits_size <= 0) {
		string_destroy(temp_string);
		return 0;
	}
	int e_size = get_e(file_pointer, temp_string);
	fseek(file_pointer, e_size, SEEK_CUR);
	int fs_size = get_fs(file_pointer, temp_string);
	fseek(file_pointer, fs_size, SEEK_CUR);
	put_back_file(file_pointer, string_raw(temp_string));
	string_concat(string, string_raw(temp_string));
	int temp_string_size = string_size(temp_string);
	string_destroy(temp_string);
	return temp_string_size;
}

int get_word(FILE *file_pointer, String *string, const char *word) {
	const int word_size = strlen(word);
	String *temp_string;
	string_create(temp_string);
	bool is_matched = true;
	for (int i = 0; i < word_size; i++) {
		char c = fgetc(file_pointer);
		string_push_back(temp_string);
		if (c == EOF || c != word[i]) {
			is_matched = false;
			break;
		}
	}
	if (!is_matched) {
		put_back_file(file_pointer, string_raw(temp_string));
		string_destroy(temp_string);
		return 0;
	}
	string_concat(string, string_raw(temp_string));
	put_back_file(file_pointer, string_raw(temp_string));
	string_destroy(temp_string);
	return word_size;
}

int lex_initialize() {
	return 0;
}

int get_one_token(Token *token, FILE *file_pointer) {
	fseek(file_pointer, 0, SEEK_END);
	if (ftell(file_pointer) == 0) {
		return -1;
	}
	rewind(file_pointer);

	skip_space(file_pointer);

	skip_comment(file_pointer);

	const int keywords_size = 78;
	const Keyword keywords[keywords_size] = {
		{TYPE_AUTO, "auto"},
		{TYPE_BREAK, "break"},
		{TYPE_CASE, "case"},
		{TYPE_CHAR, "char"},
		{TYPE_CONST, "const"},
		{TYPE_CONTINUE, "continue"},
		{TYPE_DEFAULT, "default"},
		{TYPE_DO, "do"},
		{TYPE_DOUBLE, "double"},
		{TYPE_ELSE, "else"},
		{TYPE_ENUM, "enum"},
		{TYPE_EXTERN, "extern"},
		{TYPE_FLOAT, "float"},
		{TYPE_FOR, "for"},
		{TYPE_GOTO, "goto"},
		{TYPE_IF, "if"},
		{TYPE_INT, "int"},
		{TYPE_LONG, "long"},
		{TYPE_REGISTER, "register"},
		{TYPE_RETURN, "return"},
		{TYPE_SHORT, "short"},
		{TYPE_SIGNED, "signed"},
		{TYPE_SIZEOF, "sizeof"},
		{TYPE_STATIC, "static"},
		{TYPE_STRUCT, "struct"},
		{TYPE_SWITCH, "switch"},
		{TYPE_TYPEDEF, "typedef"},
		{TYPE_UNION, "union"},
		{TYPE_UNSIGNED, "unsigned"},
		{TYPE_VOID, "void"},
		{TYPE_VOLATILE, "volatile"},
		{TYPE_WHILE, "while"},
		{TYPE_CONSTANT, "constant"},
		{TYPE_ELLIPSIS, "..."},
		{TYPE_RIGHT_ASSIGN, ">>="},
		{TYPE_LEFT_ASSIGN, "<<="},
		{TYPE_ADD_ASSIGN, "+="},
		{TYPE_SUB_ASSIGN, "-="},
		{TYPE_MUL_ASSIGN, "*="},
		{TYPE_DIV_ASSIGN, "/="},
		{TYPE_MOD_ASSIGN, "%="},
		{TYPE_AND_ASSIGN, "&="},
		{TYPE_XOR_ASSIGN, "^="},
		{TYPE_OR_ASSIGN, "|="},
		{TYPE_RIGHT_OP, ">>"},
		{TYPE_LEFT_OP, "<<"},
		{TYPE_INC_OP, "++"},
		{TYPE_DEC_OP, "--"},
		{TYPE_PTR_OP, "->"},
		{TYPE_AND_OP, "&&"},
		{TYPE_OR_OP, "||"},
		{TYPE_LE_OP, "<="},
		{TYPE_GE_OP, ">="},
		{TYPE_EQ_OP, "=="},
		{TYPE_NE_OP, "!="},
		{TYPE_SEMICOLON, ";"},
		{TYPE_LEFT_BRACE, "{"},
		{TYPE_RIGHT_BRACE, "}"},
		{TYPE_COMMA, ","},
		{TYPE_ASSIGN, "="},
		{TYPE_LEFT_PAREN, "("},
		{TYPE_RIGHT_PAREN, ")"},
		{TYPE_LEFT_BRACKET, "["},
		{TYPE_RIGHT_BRACKET, "]"},
		{TYPE_DOT, "."},
		{TYPE_AND, "&"},
		{TYPE_NOT, "!"},
		{TYPE_TILDE, "~"},
		{TYPE_SUB, "-"},
		{TYPE_ADD, "+"},
		{TYPE_MUL, "*"},
		{TYPE_DIV, "/"},
		{TYPE_MOD, "%"},
		{TYPE_GREATER, ">"},
		{TYPE_LESS, "<"},
		{TYPE_XOR, "^"},
		{TYPE_OR, "|"},
		{TYPE_QUESTION_MARK, "?"},
	};

	const int token_type_actions_size = 9;
	const TokenTypeAction token_type_actions[token_type_actions_size] = {
		{TYPE_IDENTIFIER, get_identifier},
		{TYPE_CONSTANT, get_constant_normal},
		{TYPE_CONSTANT, get_constant_hex},
		{TYPE_CONSTANT, get_constant_float_type_1},
		{TYPE_CONSTANT, get_constant_float_type_2},
		{TYPE_CONSTANT, get_constant_float_type_3},
		{TYPE_STRING_LITERAL, get_string_literal},
		{TYPE_CHARACTER, get_character},
	};

	for (int i = 0; i < keywords_size; i++) {
		if (is_word(file_pointer, keywords[i].word)) {
			token_update_if_longer(token, keywords[i].type, keywords[i].word);
		}
	}

	for (int i = 0; i < token_type_actions_size; i++) {
		String *string;
		string_create(string);
		int matched_size = token_type_actions[i].get_matched(file_pointer, string);
		if (matched_size > 0) {
			token_update_if_longer(token, token_type_actions[i].type, string);
		}
		string_destroy(string);
	}

	return 0;
}

int get_tokens() {

}
