#include "asmutils.h"
#include <string.h>
#include <stdlib.h>
#include "memory.h"
#include "error.h"

unsigned int line = 0;             // track the line number in the text input file (for error reporting)
const int START_SIZE = 50;

char *strconcat(char *s1, char *s2) { 
  char *s;
  s = (char *)Malloc(strlen(s1)+strlen(s2)+1);
  sprintf(s,"%s%s",s1,s2);
  return s;
}

void writeZString(char *str, FILE *f) {
 char zero = 0;	

 if (str != NULL && strlen(str) > 0)	
  fwrite(str, strlen(str), 1, f);	
 
 /* Zero terminate in file */
 fwrite(&zero, 1, 1, f);	
}


// Read a single token from the text source file
char *getToken(FILE *f) {
  char *token = NULL;	
  char *temp;
  int i = 0;
  int read;
  int curSize = START_SIZE;
  char c;
  	
  token = (char *)Malloc(START_SIZE);
  
  // skip whitespace 
  do {
   read = fread(&c, 1, 1, f);
   if ((read == 1) && (c == '\n'))
    line++;
  } while((read == 1) && ((c == ' ') || (c == '\n') || (c == '\t')));
  
  if (read == 0)
   return NULL;
  
  // read token 
  do {
   // maybe grow token
   if (i >= curSize) {
     temp = (char *)Malloc(2*curSize);
     memcpy(temp, token, curSize);
     token = temp;
     curSize *= 2;	
   }
   token[i] = c;
   i++;
   read = fread(&c, 1, 1, f);
   if ((read == 1) && (c == '\n'))
    line++;
  } while ( (read == 1) && (c != ' ') && (c != '\n') && (c != '\t'));
    
  token[i] = 0;
  return token;	
}


// Same as above, but it's assumed that the token is surrounded by "'s and these are trimmed away before
// the result is returned.
char *getStringToken(FILE *f) {
  char *token = NULL;	
  char *temp;
  int i = 0;
  int j = 0;
  int read;
  int curSize = START_SIZE;
  char c;
  	
  token = (char *)Malloc(START_SIZE);
  
  // skip whitespace and first " 
  do {
   read = fread(&c, 1, 1, f);
   if ((read == 1) && (c == '\n'))
    line++;
    
    // break at FIRST '"' 
   if ((read == 1) && (c == '"'))
    j = 1;
      
  } while((read == 1) && (j == 0) && ((c == ' ') || (c == '"') || (c == '\n') || (c == '\t')));
  
  if (read == 0)
   return NULL;
  
  // read token 
  do {
   // maybe grow 
   if (i >= curSize) {
     temp = (char *)Malloc(2*curSize);
     memcpy(temp, token, curSize);
     token = temp;
     curSize *= 2;	
   }
   
   // check is to make sure that it handles the empty string 
   if (c != '"') {
     token[i] = c;
     i++;
   }
     
   read = fread(&c, 1, 1, f);
   if ((read == 1) && (c == '\n'))
    line++;
  } while ( (read == 1) && (c != '"') && (c != '\n') && (c != '\t'));
    
  token[i] = 0;
  return token;	
}
