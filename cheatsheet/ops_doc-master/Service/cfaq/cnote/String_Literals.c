char* str = "hello, world"; /* string literal */
/* string literals can be used to initialize arrays */
char a1[] = "abc"; /* a1 is char[4] holding {'a','b','c','\0'} */
char a2[4] = "abc"; /* same as a1 */
char a3[3] = "abc"; /* a1 is char[3] holding {'a','b','c'}, missing the '\0' */

char* s = "foobar";
s[0] = 'F'; /* undefined behaviour */
/* it's good practice to denote string literals as such, by using `const` */
char const* s1 = "foobar";
s1[0] = 'F'; /* compiler error! */

// Version < C99
/* only two narrow or two wide string literals may be concatenated */
char* s = "Hello, " "World";
// Version ≥ C99
/* since C99, more than two can be concatenated */
/* concatenation is implementation defined */
char* s1 = "Hello" ", " "World";
/* common usages are concatenations of format strings */
char* fmt = "%" PRId16; /* PRId16 macro since C99 */


/* normal string literal, of type char[] */
char* s1 = "abc";
/* wide character string literal, of type wchar_t[] */
wchar_t* s2 = L"abc";
// Version ≥ C11
/* UTF-8 string literal, of type char[] */
char* s3 = u8"abc";
/* 16-bit wide string literal, of type char16_t[] */
char16_t* s4 = u"abc";
/* 32-bit wide string literal, of type char32_t[] */
char32_t* s5 = U"abc";