/* wig error.h
 *
 * History:
 * 17.10.2000 - created, defined yyerror()
 */

void yyerror(const char *format, ...);
void reportError(int lineno, const char *format, ...);
void reportWarning(int lineno, const char *format, ...);
void errorCheck();

extern int lineno;
