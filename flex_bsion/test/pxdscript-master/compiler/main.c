/* main file for U1Comp
 *
 * history:
 */

#include <stdio.h>
#include <stdlib.h>
#include "error.h"
#include "pretty.h"
#include "tree.h"
#include "symbol.h"
#include "weed.h"
#include "type.h"
#include "resource.h"
#include "emit.h"
#include "code.h"
#include "memory.h"
#include "assembler.h"

void yyparse();

struct SCRIPTCOLLECTION *thescriptcollection;
int interactiveMode = 0;

int main(int argc, char **argv)
{
	/* debugging */
	setbuf(stdout, NULL);
	setbuf(stderr, NULL);

	if(argc < 3){
		printf("Usage: u1comp <infile> <outfile>\n");
		//exit(1);
		
		printf("Interactive mode!\n");
		interactiveMode = 1; // make yyparse() abort after '\n'
		while (1) {
			printf("> ");
			yyparse();
			
			#if 1
			printf("// Prettyprinting...\n");
			prettySCRIPTCOLLECTION(thescriptcollection);
			errorCheck();
			#endif
		}
	} else {
		if(freopen(argv[1],"r",stdin) != NULL){
		printf("// Parsing...\n");
		lineno=1;
		yyparse(); /* Build AST */
		} else {
			printf("Couldn't open file %s\n",argv[1]);
			exit(1);
		}
	}
	errorCheck();

  printf("// Weeding...\n");
  weedSCRIPTCOLLECTION(thescriptcollection);
  errorCheck();

  printf("// Symbolchecking...\n");
  symSCRIPTCOLLECTION(thescriptcollection);
  errorCheck();

  printf("// Typechecking...\n");
  typeSCRIPTCOLLECTION(thescriptcollection);
  errorCheck();

  #if 0
  printf("// Prettyprinting...\n");
  prettySCRIPTCOLLECTION(thescriptcollection);
  errorCheck();
  #endif
  
  printf("// Resource calculations...\n");
  resSCRIPTCOLLECTION(thescriptcollection);
  errorCheck();

  printf("// Coding...\n");
  codeSCRIPTCOLLECTION(thescriptcollection);
  errorCheck();

  printf("// Emitting (asm)...\n");
  emitSCRIPTCOLLECTION(thescriptcollection);
  errorCheck();
  
  printf("// Assembling...\n");
  AssembleFile(argv[2]);
  
    
 
 return 0;
}
