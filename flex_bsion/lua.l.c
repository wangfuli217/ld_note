


--- file: m.cmd ---
byacc -d lua.y
rem flex -Bs8 -Cef -oylex.c lua.l
flex -Bs8 -Cem -oylex.c lua.l
cl -MD -Ox -DYYMAIN ylex.c -link /opt:ref /opt:icf /opt:nowin98

--- file: y.tab.h ---
#ifndef YYERRCODE
#define YYERRCODE 256
#endif

#define TK_EOF 0
#define TK_AND 257
#define TK_BREAK 258
#define TK_DO 259
#define TK_ELSE 260
#define TK_ELSEIF 261
#define TK_END 262
#define TK_FALSE 263
#define TK_FOR 264
#define TK_FUNCTION 265
#define TK_IF 266
#define TK_IN 267
#define TK_LOCAL 268
#define TK_NIL 269
#define TK_NOT 270
#define TK_OR 271
#define TK_REPEAT 272
#define TK_RETURN 273
#define TK_THEN 274
#define TK_TRUE 275
#define TK_UNTIL 276
#define TK_WHILE 277
#define TK_CONCAT 278
#define TK_DOTS 279
#define TK_EQ 280
#define TK_GE 281
#define TK_LE 282
#define TK_NE 283
#define TK_NUMBER 284
#define TK_NAME 285
#define TK_STRING 286
#define TK_LONGSTRING 287
#define TK_SHORTCOMMENT 288
#define TK_LONGCOMMENT 289
#define TK_WHITESPACE 290
#define TK_NEWLINE 291
#define TK_BADCHAR 292

/* eof */


