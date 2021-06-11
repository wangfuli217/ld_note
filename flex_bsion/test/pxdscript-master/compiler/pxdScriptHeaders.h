#ifndef __pxdscriptheaders_h
#define __pxdscriptheaders_h

// Chunk ID's;
#define FUNCTION_ID 0
#define PROGRAM_ID 1
#define CODE_ID 2
#define CONSTANTS_ID 3

// Constant types:
#define INT_CONST 0
#define ZSTRING_CONST 1

// Trigger types:
#define trigger_neverK 0
#define trigger_on_initK 1
#define trigger_on_clickK 2
#define trigger_on_collideK 3
#define trigger_on_pickupK 4


// The function and program headers:
typedef struct FUNCTIONHEADER {
    char *name;				        /* zero-terminated */
    unsigned char inputs;		  /* number of inputs */
    unsigned char outputs;		/* returns (0 or 1) */
    unsigned char localLimit;
    unsigned short int stackLimit;
    unsigned int startCode;
    unsigned int endCode;
} FUNCTIONHEADER; 


typedef struct PROGRAMHEADER {
    char *name;
    unsigned char localLimit;
    unsigned short int stackLimit;
    unsigned char triggertype;		/* Numbered as in the enum in TRIGGER */
    char *triggerArgument;	 
    unsigned int startCode;
    unsigned int endCode;
} PROGRAMHEADER;

typedef struct CONSTANT {
    char type;			/* 0 == int, 1 == z-string */
    int nr;
    union {
      int  intval;
      char *str;
    } val;
   struct CONSTANT *next; 
} CONSTANT;

#endif
