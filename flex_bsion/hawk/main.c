#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <fcntl.h>
#include <unistd.h>

#include <errno.h>
#include "entry.h"
#include "interpreter.h"
#include "customio.h"


char *parserInput;
char *textInput;
char *errorMessage;

extern int DEBUG = 0;

int parserReadOffset = 0;
int textReadLen = 0;
int maxtextReadLen = FILE_INPUT_BUFFER_SIZE;
int has_printed = 0;

void usage() {
	printstr("usage: hawk [-F<FS>] [-v] (-e <script> | -f <scriptfile>) [<filenames>]");
	die("", ARGUMENTS_ERROR);
}

//feed the parser
int readInputForLexer( char *buffer, int *numBytesRead, int maxBytesToRead ) {
    int numBytesToRead = maxBytesToRead;
    int bytesRemaining = strlen(parserInput)-parserReadOffset;
    int i;
    if ( numBytesToRead > bytesRemaining ) { numBytesToRead = bytesRemaining; }
    for ( i = 0; i < numBytesToRead; i++ ) {
        buffer[i] = parserInput[parserReadOffset+i];
    }
    *numBytesRead = numBytesToRead;
    parserReadOffset += numBytesToRead;
    return 0;
}

char* fieldsArray[32];

int main(int argc, char** argv) { 
	extern entry* head;
	extern entry* awkbegin;
	extern entry* awkend;
	
	errorMessage = (char*)malloc(sizeof(char) * 50);
	
	parserInput = (char*)calloc(FILE_INPUT_BUFFER_SIZE, sizeof(char));
	textInput = (char*)calloc(FILE_INPUT_BUFFER_SIZE, sizeof(char));
	
			
	//field and record separator default value
	char* FS = (char*)calloc(SMALL_STRING_BUFFER_SIZE, sizeof(char));
	char* RS = (char*)calloc(SMALL_STRING_BUFFER_SIZE, sizeof(char));
	RS[0] = '\n';
	FS[0] = ' ';
	
	//parsing params
	char* script_fname = (char*)calloc(BIG_STRING_BUFFER_SIZE, sizeof(char));
	int has_script_name = 0;
	
	int optres;
	opterr = 0;
	while ((optres = getopt(argc, argv, "vf:F:e:")) != -1) {
		switch (optres) {
			case 'f':
				//optarg has file with executable
				//printf("-f %s %d\n", optarg, strlen(optarg));
				strcpy(script_fname, optarg);
				has_script_name = 1;
				break;
			case 'e':
				//optarg has executable itself
				//printf("-f %s %d\n", optarg, strlen(optarg));
				strcpy(parserInput, optarg);
				has_script_name = 2;
				break;
			case 'F':
				//optarg has field separators
				//printf("-F %s\n", optarg);
				strcpy(FS, optarg);
				FS[strlen(optarg) + 1] = '\0';
				break;
			case 'v':
				//turn on verbose
				DEBUG = 1;
				break;
			default:
				has_script_name = 0;
		}
	}

	if (has_script_name == 0) usage();
	//_exit(0);
	
	//read source
	
	ssize_t res;
	if (has_script_name == 1) {
		int fdes = open(script_fname, O_RDONLY);
		
		if (fdes < 0) {
			printstr_err(strerror(errno));
			die(" - cannot open script file", IO_ERROR);
		}
		
		res = read(fdes, parserInput, FILE_INPUT_BUFFER_SIZE);
		if (res < 0) {
			printstr_err(strerror(errno));
			die(" - cannot read script file", IO_ERROR);
		}
		close(fdes);
	}
	
	yylval = new_entry_0();  
	yyparse(); 
	

		
	assign_variable("NF", NUM_VARIABLE, "", 0);
	assign_variable("NR", NUM_VARIABLE, "", 0);
	
	assign_variable("FS", STR_VARIABLE, FS, 0);
	assign_variable("RS", STR_VARIABLE, RS, 0);
	
	assign_variable("OFS", STR_VARIABLE, " ", 0);
	assign_variable("ORS", STR_VARIABLE, "\n", 0);
	
	//START AWKBEGIN
	if (awkbegin != NULL) run_block(awkbegin);
	if (has_printed) { printstr(get_string_from_variable("ORS")); has_printed = 0; }
	
	int go_stdin = (optind == argc) ? 1 : 0;
	
	while ((optind < argc) || go_stdin) {
		
		//iterate over all files
		
		textReadLen = 0;
		//read input text
		
		int fdes;
		if ((!go_stdin) && (strcmp(argv[optind], "-") != 0)) fdes = open(argv[optind], O_RDONLY);
				else { fdes = STDIN_FILENO; go_stdin = 1; }
		
		if (fdes < 0) {
			printstr_err(strerror(errno));
			printstr_err("  ");
			printstr_err(argv[optind]); 
			die(" - error opening", IO_ERROR); 
		};
		
		res = 1;
		while (res > 0) {
			res = read(fdes, (textInput + textReadLen), BIG_STRING_BUFFER_SIZE);
			textReadLen += res;
			if (textReadLen <= maxtextReadLen) {
				maxtextReadLen += FILE_INPUT_BUFFER_SIZE;
				textInput = (char*)realloc(textInput, maxtextReadLen);
				if (textInput == NULL) {printstr_err(argv[optind]); die(" - too big to buffer", IO_ERROR); };
			}
		}
		if (DEBUG) fprintf(stderr, "read done\n");
		textInput[textReadLen] = '\0';
		if (res < 0) {
			printstr_err(argv[optind]); 
			printstr_err(strerror(errno));
			die(" - error reading", IO_ERROR); 
		};
		

		//iterate over input text 
		char* current_line;// = (char*)calloc(BIG_STRING_BUFFER_SIZE * 10, sizeof(char));
		char* current_field;// = (char*)calloc(BIG_STRING_BUFFER_SIZE, sizeof(char));
		int line_number = 0;
		char* current_line_finder = strtok (textInput, RS);
		while (current_line_finder != NULL) {
			if (DEBUG) fprintf(stderr, "found line %d\n", line_number);
			//iterating over lines
			line_number++;
			char* current_line = (char*)calloc(strlen(current_line_finder) + 2, sizeof(char));
			memcpy(current_line, current_line_finder, strlen(current_line_finder));
			current_line[strlen(current_line_finder)] = '\0';
			current_line[strlen(current_line_finder) + 1] = '\0';
			assign_field(0, current_line);
			int field_number = 0;
			char* current_field_finder = strtok(current_line, FS);
			while (current_field_finder != NULL) {
				//iterating over fields
				current_field = (char*)calloc(strlen(current_field_finder) + 2, sizeof(char));
				memcpy(current_field, current_field_finder, strlen(current_field_finder)); 
			if (DEBUG) fprintf(stderr, " memcpy done\n");
				current_field[strlen(current_field_finder)] = '\0';
				current_field[strlen(current_field_finder) + 1] = '\0';
				
				//here in current_field we have our current field!
				
				field_number++;
			if (field_number < 10)
				assign_field(field_number, current_field);
				
				current_field_finder = strtok(current_field_finder + strlen(current_field_finder) + 1, " ");
			}
			if (DEBUG) fprintf(stderr, ">>>>>%d\n", field_number);	
				for (int i = field_number + 1; i <= 9; i++) assign_field(i, "");
			
			assign_variable("NF", NUM_VARIABLE, "", field_number);
			assign_variable("NR", NUM_VARIABLE, "", line_number);
			
			//EXECUTION OF MAIN BLOCK!!!
			has_printed = 0;
			run_block(head);
			if (has_printed) { printstr(get_string_from_variable("ORS")); has_printed = 0; }
			current_line_finder = strtok (current_line_finder + strlen(current_line_finder) + 1, "\n");
			free(current_line);
			free(current_field);
		}
		optind++;
		if (!go_stdin) { close(fdes); } else { go_stdin = 0; };
	}
	
	//START AWKEND
	if (awkend != NULL) run_block(awkend);
	if (has_printed) { printstr(get_string_from_variable("ORS")); has_printed = 0; }
	
	if (DEBUG) {
		printstr("Variables used:\n");
		print_variables();
	}
}
