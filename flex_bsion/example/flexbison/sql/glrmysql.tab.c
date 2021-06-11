
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison GLR parsers in C
   
      Copyright (C) 2002, 2003, 2004, 2005, 2006 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C GLR parser skeleton written by Paul Hilfinger.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "glr.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0




/* Copy the first part of user declarations.  */

/* Line 172 of glr.c  */
#line 17 "glrmysql.y"

#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

void yyerror(const char *s, ...);
void emit(char *s, ...);


/* Line 172 of glr.c  */
#line 69 "glrmysql.tab.c"



#include "glrmysql.tab.h"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif

/* Default (constant) value used for initialization for null
   right-hand sides.  Unlike the standard yacc.c template,
   here we set the default value of $$ to a zeroed-out value.
   Since the default value is undefined, this behavior is
   technically correct.  */
static YYSTYPE yyval_default;

/* Copy the second part of user declarations.  */


/* Line 243 of glr.c  */
#line 104 "glrmysql.tab.c"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
}
#endif

#ifndef YYFREE
# define YYFREE free
#endif
#ifndef YYMALLOC
# define YYMALLOC malloc
#endif
#ifndef YYREALLOC
# define YYREALLOC realloc
#endif

#define YYSIZEMAX ((size_t) -1)

#ifdef __cplusplus
   typedef bool yybool;
#else
   typedef unsigned char yybool;
#endif
#define yytrue 1
#define yyfalse 0

#ifndef YYSETJMP
# include <setjmp.h>
# define YYJMP_BUF jmp_buf
# define YYSETJMP(env) setjmp (env)
# define YYLONGJMP(env, val) longjmp (env, val)
#endif

/*-----------------.
| GCC extensions.  |
`-----------------*/

#ifndef __attribute__
/* This feature is available in gcc versions 2.5 and later.  */
# if (! defined __GNUC__ || __GNUC__ < 2 \
      || (__GNUC__ == 2 && __GNUC_MINOR__ < 5) || __STRICT_ANSI__)
#  define __attribute__(Spec) /* empty */
# endif
#endif


#ifdef __cplusplus
# define YYOPTIONAL_LOC(Name) /* empty */
#else
# define YYOPTIONAL_LOC(Name) Name __attribute__ ((__unused__))
#endif

#ifndef YYASSERT
# define YYASSERT(condition) ((void) ((condition) || (abort (), 0)))
#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  31
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1696

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  254
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  74
/* YYNRULES -- Number of rules.  */
#define YYNRULES  301
/* YYNRULES -- Number of states.  */
#define YYNSTATES  626
/* YYMAXRHS -- Maximum number of symbols on right-hand side of rule.  */
#define YYMAXRHS 11
/* YYMAXLEFT -- Maximum number of symbols to the left of a handle
   accessed by $0, $-1, etc., in any rule.  */
#define YYMAXLEFT 0

/* YYTRANSLATE(X) -- Bison symbol number corresponding to X.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   494

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const unsigned char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    17,     2,     2,     2,    28,    22,     2,
     252,   253,    26,    24,   250,    25,   251,    27,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,   249,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    30,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    21,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    18,    19,    20,    23,    29,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,    85,    86,    87,    88,    89,    90,    91,    92,    93,
      94,    95,    96,    97,    98,    99,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,   129,   130,   131,   132,   133,
     134,   135,   136,   137,   138,   139,   140,   141,   142,   143,
     144,   145,   146,   147,   148,   149,   150,   151,   152,   153,
     154,   155,   156,   157,   158,   159,   160,   161,   162,   163,
     164,   165,   166,   167,   168,   169,   170,   171,   172,   173,
     174,   175,   176,   177,   178,   179,   180,   181,   182,   183,
     184,   185,   186,   187,   188,   189,   190,   191,   192,   193,
     194,   195,   196,   197,   198,   199,   200,   201,   202,   203,
     204,   205,   206,   207,   208,   209,   210,   211,   212,   213,
     214,   215,   216,   217,   218,   219,   220,   221,   222,   223,
     224,   225,   226,   227,   228,   229,   230,   231,   232,   233,
     234,   235,   236,   237,   238,   239,   240,   241,   242,   243,
     244,   245,   246,   247,   248
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const unsigned short int yyprhs[] =
{
       0,     0,     3,     6,    10,    12,    16,    28,    29,    32,
      33,    38,    41,    46,    47,    49,    51,    52,    55,    56,
      59,    60,    64,    65,    68,    73,    74,    77,    79,    83,
      84,    87,    90,    93,    96,    99,   102,   105,   108,   110,
     114,   116,   119,   121,   125,   127,   129,   133,   139,   143,
     147,   149,   150,   153,   155,   156,   162,   166,   172,   179,
     185,   186,   188,   190,   191,   193,   195,   197,   200,   203,
     204,   206,   207,   210,   215,   222,   229,   236,   237,   240,
     241,   243,   247,   251,   253,   261,   264,   267,   270,   271,
     278,   281,   286,   287,   290,   298,   300,   309,   310,   316,
     317,   320,   323,   326,   329,   331,   332,   333,   337,   341,
     347,   349,   351,   355,   359,   367,   375,   379,   383,   389,
     395,   397,   406,   414,   422,   424,   433,   434,   437,   440,
     444,   450,   456,   464,   466,   471,   476,   477,   481,   483,
     492,   503,   513,   520,   532,   541,   543,   547,   548,   553,
     559,   564,   569,   575,   581,   582,   586,   589,   593,   597,
     601,   605,   608,   614,   618,   622,   625,   629,   630,   634,
     640,   641,   643,   644,   647,   650,   651,   656,   660,   663,
     667,   671,   675,   679,   683,   687,   691,   695,   699,   703,
     705,   707,   709,   711,   713,   717,   723,   726,   731,   733,
     735,   737,   739,   743,   747,   751,   755,   761,   767,   769,
     773,   777,   778,   780,   782,   783,   785,   787,   790,   792,
     796,   800,   804,   806,   808,   812,   814,   816,   818,   820,
     824,   828,   832,   836,   840,   844,   847,   851,   855,   859,
     863,   869,   876,   883,   890,   894,   898,   902,   906,   909,
     912,   916,   920,   925,   929,   934,   940,   942,   946,   947,
     949,   955,   962,   968,   975,   980,   986,   991,   996,  1001,
    1006,  1013,  1022,  1027,  1035,  1037,  1039,  1041,  1048,  1055,
    1059,  1063,  1067,  1071,  1075,  1079,  1083,  1087,  1091,  1096,
    1103,  1107,  1113,  1118,  1124,  1128,  1133,  1137,  1142,  1144,
    1146,  1148
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const short int yyrhs[] =
{
     255,     0,    -1,   256,   249,    -1,   255,   256,   249,    -1,
     257,    -1,   187,   268,   269,    -1,   187,   268,   269,   105,
     271,   258,   259,   263,   264,   265,   266,    -1,    -1,   237,
     322,    -1,    -1,   108,    47,   260,   262,    -1,   322,   261,
      -1,   260,   250,   322,   261,    -1,    -1,    39,    -1,    81,
      -1,    -1,   239,   183,    -1,    -1,   109,   322,    -1,    -1,
     161,    47,   260,    -1,    -1,   134,   322,    -1,   134,   322,
     250,   322,    -1,    -1,   125,   267,    -1,     3,    -1,   267,
     250,     3,    -1,    -1,   268,    33,    -1,   268,    84,    -1,
     268,    85,    -1,   268,   110,    -1,   268,   206,    -1,   268,
     203,    -1,   268,   201,    -1,   268,   202,    -1,   270,    -1,
     269,   250,   270,    -1,    26,    -1,   322,   275,    -1,   272,
      -1,   271,   250,   272,    -1,   273,    -1,   276,    -1,     3,
     275,   283,    -1,     3,   251,     3,   275,   283,    -1,   286,
     274,     3,    -1,   252,   271,   253,    -1,    38,    -1,    -1,
      38,     3,    -1,     3,    -1,    -1,   272,   277,   127,   273,
     281,    -1,   272,   206,   273,    -1,   272,   206,   273,   156,
     322,    -1,   272,   279,   278,   127,   273,   282,    -1,   272,
     152,   280,   127,   273,    -1,    -1,   118,    -1,    62,    -1,
      -1,   163,    -1,   133,    -1,   182,    -1,   133,   278,    -1,
     182,   278,    -1,    -1,   282,    -1,    -1,   156,   322,    -1,
     228,   252,   267,   253,    -1,   227,   128,   284,   252,   285,
     253,    -1,   115,   128,   284,   252,   285,   253,    -1,   103,
     128,   284,   252,   285,   253,    -1,    -1,   102,   127,    -1,
      -1,     3,    -1,   285,   250,     3,    -1,   252,   257,   253,
      -1,   287,    -1,    80,   288,   105,     3,   258,   264,   265,
      -1,   288,   144,    -1,   288,   169,    -1,   288,   115,    -1,
      -1,    80,   288,   289,   105,   271,   258,    -1,     3,   290,
      -1,   289,   250,     3,   290,    -1,    -1,   251,    26,    -1,
      80,   288,   105,   289,   228,   271,   258,    -1,   291,    -1,
     121,   293,   294,     3,   295,   232,   296,   292,    -1,    -1,
     156,   157,   128,   225,   298,    -1,    -1,   293,   144,    -1,
     293,    79,    -1,   293,   110,    -1,   293,   115,    -1,   125,
      -1,    -1,    -1,   252,   267,   253,    -1,   252,   297,   253,
      -1,   296,   250,   252,   297,   253,    -1,   322,    -1,    78,
      -1,   297,   250,   322,    -1,   297,   250,    78,    -1,   121,
     293,   294,     3,   190,   298,   292,    -1,   121,   293,   294,
       3,   295,   257,   292,    -1,     3,    20,   322,    -1,     3,
      20,    78,    -1,   298,   250,     3,    20,   322,    -1,   298,
     250,     3,    20,    78,    -1,   299,    -1,   177,   293,   294,
       3,   295,   232,   296,   292,    -1,   177,   293,   294,     3,
     190,   298,   292,    -1,   177,   293,   294,     3,   295,   257,
     292,    -1,   300,    -1,   225,   301,   271,   190,   302,   258,
     264,   265,    -1,    -1,   293,   144,    -1,   293,   115,    -1,
       3,    20,   322,    -1,     3,   251,     3,    20,   322,    -1,
     302,   250,     3,    20,   322,    -1,   302,   250,     3,   251,
       3,    20,   322,    -1,   303,    -1,    61,    68,   304,     3,
      -1,    61,   184,   304,     3,    -1,    -1,   114,    18,    97,
      -1,   305,    -1,    61,   318,   207,   304,     3,   252,   306,
     253,    -1,    61,   318,   207,   304,     3,   251,     3,   252,
     306,   253,    -1,    61,   318,   207,   304,     3,   252,   306,
     253,   316,    -1,    61,   318,   207,   304,     3,   316,    -1,
      61,   318,   207,   304,     3,   251,     3,   252,   306,   253,
     316,    -1,    61,   318,   207,   304,     3,   251,     3,   316,
      -1,   307,    -1,   306,   250,   307,    -1,    -1,   308,     3,
     314,   309,    -1,   166,   128,   252,   267,   253,    -1,   128,
     252,   267,   253,    -1,   116,   252,   267,   253,    -1,   106,
     116,   252,   267,   253,    -1,   106,   128,   252,   267,   253,
      -1,    -1,   309,    18,   154,    -1,   309,   154,    -1,   309,
      78,     4,    -1,   309,    78,     5,    -1,   309,    78,     7,
      -1,   309,    78,     6,    -1,   309,    40,    -1,   309,   222,
     252,   267,   253,    -1,   309,   222,   128,    -1,   309,   166,
     128,    -1,   309,   128,    -1,   309,    56,     4,    -1,    -1,
     252,     5,   253,    -1,   252,     5,   250,     5,   253,    -1,
      -1,    43,    -1,    -1,   312,   224,    -1,   312,   243,    -1,
      -1,   313,    52,   190,     4,    -1,   313,    54,     4,    -1,
      44,   310,    -1,   215,   310,   312,    -1,   192,   310,   312,
      -1,   147,   310,   312,    -1,   122,   310,   312,    -1,   123,
     310,   312,    -1,    42,   310,   312,    -1,   172,   310,   312,
      -1,    87,   310,   312,    -1,   101,   310,   312,    -1,    76,
     310,   312,    -1,    70,    -1,   212,    -1,   213,    -1,    71,
      -1,   241,    -1,    52,   310,   313,    -1,   234,   252,     5,
     253,   313,    -1,    43,   310,    -1,   233,   252,     5,   253,
      -1,   214,    -1,    45,    -1,   146,    -1,   141,    -1,   216,
     311,   313,    -1,   209,   311,   313,    -1,   148,   311,   313,
      -1,   142,   311,   313,    -1,    95,   252,   315,   253,   313,
      -1,   190,   252,   315,   253,   313,    -1,     4,    -1,   315,
     250,     4,    -1,   317,   274,   257,    -1,    -1,   115,    -1,
     177,    -1,    -1,   208,    -1,   319,    -1,   190,   320,    -1,
     321,    -1,   320,   250,   321,    -1,     8,    20,   322,    -1,
       8,     9,   322,    -1,     3,    -1,     8,    -1,     3,   251,
       3,    -1,     4,    -1,     5,    -1,     7,    -1,     6,    -1,
     322,    24,   322,    -1,   322,    25,   322,    -1,   322,    26,
     322,    -1,   322,    27,   322,    -1,   322,    28,   322,    -1,
     322,    29,   322,    -1,    25,   322,    -1,   322,    12,   322,
      -1,   322,    10,   322,    -1,   322,    11,   322,    -1,   322,
      20,   322,    -1,   322,    20,   252,   257,   253,    -1,   322,
      20,    37,   252,   257,   253,    -1,   322,    20,   193,   252,
     257,   253,    -1,   322,    20,    33,   252,   257,   253,    -1,
     322,    21,   322,    -1,   322,    22,   322,    -1,   322,    30,
     322,    -1,   322,    23,   322,    -1,    18,   322,    -1,    17,
     322,    -1,     8,     9,   322,    -1,   322,    15,   154,    -1,
     322,    15,    18,   154,    -1,   322,    15,     6,    -1,   322,
      15,    18,     6,    -1,   322,    19,   322,    36,   322,    -1,
     322,    -1,   322,   250,   323,    -1,    -1,   323,    -1,   322,
      16,   252,   323,   253,    -1,   322,    18,    16,   252,   323,
     253,    -1,   322,    16,   252,   257,   253,    -1,   322,    18,
      16,   252,   257,   253,    -1,    97,   252,   257,   253,    -1,
      18,    97,   252,   257,   253,    -1,     3,   252,   324,   253,
      -1,   248,   252,    26,   253,    -1,   248,   252,   322,   253,
      -1,   244,   252,   323,   253,    -1,   244,   252,   322,   105,
     322,   253,    -1,   244,   252,   322,   105,   322,   102,   322,
     253,    -1,   245,   252,   323,   253,    -1,   245,   252,   325,
     322,   105,   323,   253,    -1,   131,    -1,   218,    -1,    46,
      -1,   246,   252,   322,   250,   326,   253,    -1,   247,   252,
     322,   250,   326,   253,    -1,   124,   322,    72,    -1,   124,
     322,    73,    -1,   124,   322,    74,    -1,   124,   322,    75,
      -1,   124,   322,   242,    -1,   124,   322,   241,    -1,   124,
     322,   111,    -1,   124,   322,   112,    -1,   124,   322,   113,
      -1,    50,   322,   327,    94,    -1,    50,   322,   327,    91,
     322,    94,    -1,    50,   327,    94,    -1,    50,   327,    91,
     322,    94,    -1,   236,   322,   211,   322,    -1,   327,   236,
     322,   211,   322,    -1,   322,    14,   322,    -1,   322,    18,
      14,   322,    -1,   322,    13,   322,    -1,   322,    18,    13,
     322,    -1,    65,    -1,    63,    -1,    64,    -1,    43,   322,
      -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const unsigned short int yyrline[] =
{
       0,   308,   308,   309,   314,   317,   319,   325,   326,   328,
     329,   333,   335,   339,   340,   341,   344,   345,   348,   348,
     350,   350,   353,   353,   354,   357,   358,   361,   362,   365,
     366,   367,   368,   369,   370,   371,   372,   373,   376,   377,
     378,   381,   383,   384,   387,   388,   392,   393,   395,   396,
     399,   400,   403,   404,   405,   409,   411,   413,   415,   417,
     421,   422,   423,   426,   427,   430,   431,   434,   435,   436,
     439,   439,   442,   443,   447,   449,   451,   453,   456,   457,
     460,   461,   464,   469,   472,   477,   478,   479,   480,   483,
     488,   489,   493,   493,   495,   503,   506,   512,   513,   516,
     517,   518,   519,   520,   523,   523,   526,   527,   530,   531,
     534,   535,   536,   537,   540,   546,   552,   555,   558,   561,
     567,   570,   576,   582,   588,   591,   598,   599,   600,   604,
     607,   610,   613,   621,   625,   626,   629,   630,   634,   637,
     641,   646,   651,   655,   661,   666,   667,   670,   670,   673,
     674,   675,   676,   677,   680,   681,   682,   683,   684,   685,
     686,   687,   688,   689,   690,   691,   692,   695,   696,   697,
     700,   701,   704,   705,   706,   709,   710,   711,   715,   716,
     717,   718,   719,   720,   721,   722,   723,   724,   725,   726,
     727,   728,   729,   730,   731,   732,   733,   734,   735,   736,
     737,   738,   739,   740,   741,   742,   743,   744,   747,   748,
     751,   754,   755,   756,   759,   760,   765,   768,   770,   770,
     773,   775,   780,   781,   782,   783,   784,   785,   786,   789,
     790,   791,   792,   793,   794,   795,   796,   797,   798,   799,
     800,   801,   802,   803,   804,   805,   806,   807,   808,   809,
     810,   813,   814,   815,   816,   819,   823,   824,   827,   828,
     831,   832,   833,   834,   835,   836,   839,   843,   844,   846,
     847,   848,   849,   850,   853,   854,   855,   858,   859,   862,
     863,   864,   865,   866,   867,   868,   869,   870,   873,   874,
     875,   876,   879,   880,   883,   884,   887,   888,   891,   892,
     893,   896
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "NAME", "STRING", "INTNUM", "BOOL",
  "APPROXNUM", "USERVAR", "ASSIGN", "OR", "XOR", "ANDOP", "REGEXP", "LIKE",
  "IS", "IN", "'!'", "NOT", "BETWEEN", "COMPARISON", "'|'", "'&'", "SHIFT",
  "'+'", "'-'", "'*'", "'/'", "'%'", "MOD", "'^'", "UMINUS", "ADD", "ALL",
  "ALTER", "ANALYZE", "AND", "ANY", "AS", "ASC", "AUTO_INCREMENT",
  "BEFORE", "BIGINT", "BINARY", "BIT", "BLOB", "BOTH", "BY", "CALL",
  "CASCADE", "CASE", "CHANGE", "CHAR", "CHECK", "COLLATE", "COLUMN",
  "COMMENT", "CONDITION", "CONSTRAINT", "CONTINUE", "CONVERT", "CREATE",
  "CROSS", "CURRENT_DATE", "CURRENT_TIME", "CURRENT_TIMESTAMP",
  "CURRENT_USER", "CURSOR", "DATABASE", "DATABASES", "DATE", "DATETIME",
  "DAY_HOUR", "DAY_MICROSECOND", "DAY_MINUTE", "DAY_SECOND", "DECIMAL",
  "DECLARE", "DEFAULT", "DELAYED", "DELETE", "DESC", "DESCRIBE",
  "DETERMINISTIC", "DISTINCT", "DISTINCTROW", "DIV", "DOUBLE", "DROP",
  "DUAL", "EACH", "ELSE", "ELSEIF", "ENCLOSED", "END", "ENUM", "ESCAPED",
  "EXISTS", "EXIT", "EXPLAIN", "FETCH", "FLOAT", "FOR", "FORCE", "FOREIGN",
  "FROM", "FULLTEXT", "GRANT", "GROUP", "HAVING", "HIGH_PRIORITY",
  "HOUR_MICROSECOND", "HOUR_MINUTE", "HOUR_SECOND", "IF", "IGNORE",
  "INDEX", "INFILE", "INNER", "INOUT", "INSENSITIVE", "INSERT", "INT",
  "INTEGER", "INTERVAL", "INTO", "ITERATE", "JOIN", "KEY", "KEYS", "KILL",
  "LEADING", "LEAVE", "LEFT", "LIMIT", "LINES", "LOAD", "LOCALTIME",
  "LOCALTIMESTAMP", "LOCK", "LONG", "LONGBLOB", "LONGTEXT", "LOOP",
  "LOW_PRIORITY", "MATCH", "MEDIUMBLOB", "MEDIUMINT", "MEDIUMTEXT",
  "MINUTE_MICROSECOND", "MINUTE_SECOND", "MODIFIES", "NATURAL",
  "NO_WRITE_TO_BINLOG", "NULLX", "NUMBER", "ON", "DUPLICATE", "OPTIMIZE",
  "OPTION", "OPTIONALLY", "ORDER", "OUT", "OUTER", "OUTFILE", "PRECISION",
  "PRIMARY", "PROCEDURE", "PURGE", "QUICK", "READ", "READS", "REAL",
  "REFERENCES", "RELEASE", "RENAME", "REPEAT", "REPLACE", "REQUIRE",
  "RESTRICT", "RETURN", "REVOKE", "RIGHT", "ROLLUP", "SCHEMA", "SCHEMAS",
  "SECOND_MICROSECOND", "SELECT", "SENSITIVE", "SEPARATOR", "SET", "SHOW",
  "SMALLINT", "SOME", "SONAME", "SPATIAL", "SPECIFIC", "SQL",
  "SQLEXCEPTION", "SQLSTATE", "SQLWARNING", "SQL_BIG_RESULT",
  "SQL_CALC_FOUND_ROWS", "SQL_SMALL_RESULT", "SSL", "STARTING",
  "STRAIGHT_JOIN", "TABLE", "TEMPORARY", "TEXT", "TERMINATED", "THEN",
  "TIME", "TIMESTAMP", "TINYBLOB", "TINYINT", "TINYTEXT", "TO", "TRAILING",
  "TRIGGER", "UNDO", "UNION", "UNIQUE", "UNLOCK", "UNSIGNED", "UPDATE",
  "USAGE", "USE", "USING", "UTC_DATE", "UTC_TIME", "UTC_TIMESTAMP",
  "VALUES", "VARBINARY", "VARCHAR", "VARYING", "WHEN", "WHERE", "WHILE",
  "WITH", "WRITE", "YEAR", "YEAR_MONTH", "ZEROFILL", "FSUBSTRING", "FTRIM",
  "FDATE_ADD", "FDATE_SUB", "FCOUNT", "';'", "','", "'.'", "'('", "')'",
  "$accept", "stmt_list", "stmt", "select_stmt", "opt_where",
  "opt_groupby", "groupby_list", "opt_asc_desc", "opt_with_rollup",
  "opt_having", "opt_orderby", "opt_limit", "opt_into_list", "column_list",
  "select_opts", "select_expr_list", "select_expr", "table_references",
  "table_reference", "table_factor", "opt_as", "opt_as_alias",
  "join_table", "opt_inner_cross", "opt_outer", "left_or_right",
  "opt_left_or_right_outer", "opt_join_condition", "join_condition",
  "index_hint", "opt_for_join", "index_list", "table_subquery",
  "delete_stmt", "delete_opts", "delete_list", "opt_dot_star",
  "insert_stmt", "opt_ondupupdate", "insert_opts", "opt_into",
  "opt_col_names", "insert_vals_list", "insert_vals", "insert_asgn_list",
  "replace_stmt", "update_stmt", "update_opts", "update_asgn_list",
  "create_database_stmt", "opt_if_not_exists", "create_table_stmt",
  "create_col_list", "create_definition", "$@1", "column_atts",
  "opt_length", "opt_binary", "opt_uz", "opt_csc", "data_type",
  "enum_list", "create_select_statement", "opt_ignore_replace",
  "opt_temporary", "set_stmt", "set_list", "set_expr", "expr", "val_list",
  "opt_val_list", "trim_ltb", "interval_exp", "case_list", 0
};
#endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const unsigned short int yyr1[] =
{
       0,   254,   255,   255,   256,   257,   257,   258,   258,   259,
     259,   260,   260,   261,   261,   261,   262,   262,   263,   263,
     264,   264,   265,   265,   265,   266,   266,   267,   267,   268,
     268,   268,   268,   268,   268,   268,   268,   268,   269,   269,
     269,   270,   271,   271,   272,   272,   273,   273,   273,   273,
     274,   274,   275,   275,   275,   276,   276,   276,   276,   276,
     277,   277,   277,   278,   278,   279,   279,   280,   280,   280,
     281,   281,   282,   282,   283,   283,   283,   283,   284,   284,
     285,   285,   286,   256,   287,   288,   288,   288,   288,   287,
     289,   289,   290,   290,   287,   256,   291,   292,   292,   293,
     293,   293,   293,   293,   294,   294,   295,   295,   296,   296,
     297,   297,   297,   297,   291,   291,   298,   298,   298,   298,
     256,   299,   299,   299,   256,   300,   301,   301,   301,   302,
     302,   302,   302,   256,   303,   303,   304,   304,   256,   305,
     305,   305,   305,   305,   305,   306,   306,   308,   307,   307,
     307,   307,   307,   307,   309,   309,   309,   309,   309,   309,
     309,   309,   309,   309,   309,   309,   309,   310,   310,   310,
     311,   311,   312,   312,   312,   313,   313,   313,   314,   314,
     314,   314,   314,   314,   314,   314,   314,   314,   314,   314,
     314,   314,   314,   314,   314,   314,   314,   314,   314,   314,
     314,   314,   314,   314,   314,   314,   314,   314,   315,   315,
     316,   317,   317,   317,   318,   318,   256,   319,   320,   320,
     321,   321,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   323,   323,   324,   324,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   325,   325,   325,   322,   322,   326,
     326,   326,   326,   326,   326,   326,   326,   326,   322,   322,
     322,   322,   327,   327,   322,   322,   322,   322,   322,   322,
     322,   322
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const unsigned char yyr2[] =
{
       0,     2,     2,     3,     1,     3,    11,     0,     2,     0,
       4,     2,     4,     0,     1,     1,     0,     2,     0,     2,
       0,     3,     0,     2,     4,     0,     2,     1,     3,     0,
       2,     2,     2,     2,     2,     2,     2,     2,     1,     3,
       1,     2,     1,     3,     1,     1,     3,     5,     3,     3,
       1,     0,     2,     1,     0,     5,     3,     5,     6,     5,
       0,     1,     1,     0,     1,     1,     1,     2,     2,     0,
       1,     0,     2,     4,     6,     6,     6,     0,     2,     0,
       1,     3,     3,     1,     7,     2,     2,     2,     0,     6,
       2,     4,     0,     2,     7,     1,     8,     0,     5,     0,
       2,     2,     2,     2,     1,     0,     0,     3,     3,     5,
       1,     1,     3,     3,     7,     7,     3,     3,     5,     5,
       1,     8,     7,     7,     1,     8,     0,     2,     2,     3,
       5,     5,     7,     1,     4,     4,     0,     3,     1,     8,
      10,     9,     6,    11,     8,     1,     3,     0,     4,     5,
       4,     4,     5,     5,     0,     3,     2,     3,     3,     3,
       3,     2,     5,     3,     3,     2,     3,     0,     3,     5,
       0,     1,     0,     2,     2,     0,     4,     3,     2,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     1,
       1,     1,     1,     1,     3,     5,     2,     4,     1,     1,
       1,     1,     3,     3,     3,     3,     5,     5,     1,     3,
       3,     0,     1,     1,     0,     1,     1,     2,     1,     3,
       3,     3,     1,     1,     3,     1,     1,     1,     1,     3,
       3,     3,     3,     3,     3,     2,     3,     3,     3,     3,
       5,     6,     6,     6,     3,     3,     3,     3,     2,     2,
       3,     3,     4,     3,     4,     5,     1,     3,     0,     1,
       5,     6,     5,     6,     4,     5,     4,     4,     4,     4,
       6,     8,     4,     7,     1,     1,     1,     6,     6,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     4,     6,
       3,     5,     4,     5,     3,     4,     3,     4,     1,     1,
       1,     2
};

/* YYDPREC[RULE-NUM] -- Dynamic precedence of rule #RULE-NUM (0 if none).  */
static const unsigned char yydprec[] =
{
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     1,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     2,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0
};

/* YYMERGER[RULE-NUM] -- Index of merging function for rule #RULE-NUM.  */
static const unsigned char yymerger[] =
{
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0
};

/* YYDEFACT[S] -- default rule to reduce with in state S when YYTABLE
   doesn't specify something else to do.  Zero means the default is an
   error.  */
static const unsigned short int yydefact[] =
{
       0,   214,    88,    99,    99,    29,     0,    99,     0,     0,
       4,    83,    95,   120,   124,   133,   138,   216,   136,   136,
     215,     0,     0,   105,   105,     0,     0,   217,   218,     0,
       0,     1,     0,     2,     0,     0,     0,   136,    92,     0,
      87,    85,    86,     0,   101,   102,   103,   104,   100,     0,
       0,   222,   225,   226,   228,   227,   223,     0,     0,     0,
      40,    30,     0,     0,   299,   300,   298,    31,    32,     0,
      33,    36,    37,    35,    34,     0,     0,     0,     0,     0,
       5,    38,    54,     0,     0,     0,   103,   100,    54,     0,
       0,    42,    44,    45,    51,     3,     0,   134,   135,     0,
       0,    90,     7,     0,     0,     0,   106,   106,     0,   258,
       0,   249,     0,   248,   235,   301,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    53,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    41,
     221,   220,   219,     0,    77,     0,     0,     0,     0,    62,
      61,    65,    69,    66,     0,     0,    63,    50,     0,   137,
     211,    93,     0,    20,     0,     7,    92,     0,     0,     0,
       0,     0,   224,   256,   259,     0,   250,     0,     0,     0,
       0,   290,     0,     0,   256,     0,   276,   274,   275,     0,
       0,     0,     0,     0,     0,     7,    39,   237,   238,   236,
     296,   294,   253,     0,   251,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   239,   244,   245,   247,   229,   230,
     231,   232,   233,   234,   246,    52,    54,     0,     0,     0,
      46,    82,    49,     0,     7,    43,    63,    63,     0,    56,
       0,    64,     0,    48,   212,   213,     0,   147,   142,    51,
       8,     0,    22,     7,    89,    91,     0,    97,    27,     0,
       0,    97,    97,     0,    97,     0,   266,     0,     0,     0,
     288,     0,     0,   264,     0,   269,   272,     0,     0,     0,
     267,   268,     9,   254,   252,     0,     0,   297,   295,     0,
       0,     0,     0,     0,     0,    77,    79,    79,    79,     0,
       0,     0,    20,    67,    68,     0,     0,    71,     0,   211,
       0,     0,     0,     0,     0,   145,     0,     0,     0,     0,
      84,    94,     0,     0,     0,   114,     0,   107,     0,    97,
     115,   122,    97,   123,   257,   264,   292,     0,   291,     0,
       0,     0,     0,     0,     0,     0,    18,   262,   260,     0,
       0,   255,     0,     0,     0,   240,    47,     0,     0,     0,
       0,   129,     0,     0,    22,    59,    57,     0,     0,    55,
      70,     0,   147,   144,     0,     0,     0,     0,     0,   147,
     211,     0,   210,    21,    13,    23,   117,   116,     0,     0,
      28,   111,     0,   110,     0,    96,   121,   289,   293,     0,
     270,     0,     0,   277,   278,     0,     0,    20,   263,   261,
     243,   241,   242,    78,     0,     0,     0,     0,     0,     0,
     125,    72,     0,    58,     0,     0,     0,     0,     0,     0,
     146,   141,   167,   167,   167,   199,   167,   189,   192,   167,
     167,     0,   167,   167,   167,   201,   170,   200,   167,   170,
     167,     0,   167,   170,   190,   191,   198,   167,   170,     0,
       0,   193,   154,     0,    14,    15,    11,     0,     0,     0,
       0,   108,     0,     0,   273,   279,   280,   281,   282,   285,
     286,   287,   284,   283,    16,    19,    22,    80,     0,     0,
       0,   130,   131,     0,     0,   211,     0,     0,   151,   150,
       0,     0,   172,   196,   178,   175,   172,   172,     0,   172,
     172,   172,   171,   175,   172,   175,   172,     0,   172,   175,
     172,   175,     0,     0,   148,    13,    24,     0,   119,   118,
     113,   112,     0,   271,     0,    10,    25,     0,    76,    75,
      74,     0,    73,   143,   152,   153,   149,     0,   184,   194,
     188,   186,   208,     0,   187,   182,   183,   205,   181,   204,
     185,     0,   180,   203,   179,   202,     0,     0,     0,   161,
       0,     0,   165,   156,     0,     0,    12,    98,   109,    17,
       0,     6,    81,   132,     0,   168,   173,   174,     0,     0,
       0,   175,   175,   197,   175,   155,   166,   157,   158,   160,
     159,   164,   163,     0,    26,     0,     0,   177,   209,   206,
     207,   195,     0,   169,   176,   162
};

/* YYPDEFGOTO[NTERM-NUM].  */
static const short int yydefgoto[] =
{
      -1,     8,     9,    10,   173,   356,   393,   476,   545,   417,
     262,   330,   591,   269,    25,    80,    81,    90,    91,    92,
     168,   149,    93,   165,   252,   166,   248,   379,   380,   240,
     368,   498,    94,    11,    22,    43,   101,    12,   335,    23,
      49,   179,   339,   402,   267,    13,    14,    30,   244,    15,
      35,    16,   324,   325,   326,   534,   512,   523,   558,   559,
     472,   563,   258,   259,    21,    17,    27,    28,   183,   184,
     185,   200,   353,   118
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -353
static const short int yypact[] =
{
     -11,   -50,  -353,  -353,  -353,  -353,    31,     9,   151,   -92,
    -353,  -353,  -353,  -353,  -353,  -353,  -353,  -353,    86,    86,
    -353,     2,    24,   229,   229,   120,   132,   -68,  -353,    71,
      10,  -353,   -38,  -353,   195,   225,   243,    86,   -19,   253,
    -353,  -353,  -353,   -70,  -353,  -353,  -353,  -353,  -353,   254,
     255,   -78,  -353,  -353,  -353,  -353,   231,   802,   865,   802,
    -353,  -353,   802,   217,  -353,  -353,  -353,  -353,  -353,    19,
    -353,  -353,  -353,  -353,  -353,    25,    38,    40,    49,    53,
     -62,  -353,  1645,   802,   802,    31,    11,    12,    14,     0,
    -148,   244,  -353,  -353,   245,  -353,   214,  -353,  -353,   317,
     293,  -353,    65,  -156,    10,   322,  -159,  -112,   331,   802,
     802,   986,    91,   986,  -353,  -353,   802,  1210,   -37,   164,
     802,   527,   802,   802,   292,    10,   802,  -353,   802,   802,
     802,   802,   802,    23,   107,   316,   802,     3,   802,   802,
     802,   802,   802,   802,   802,   802,   802,   802,   367,  -353,
    1666,  1666,  -353,   371,   -33,   122,   -47,   380,    10,  -353,
    -353,  -353,    36,  -353,    10,   266,   262,  -353,   391,  -353,
     -96,  -353,   802,   238,    10,  -160,   -19,   397,   408,  -136,
     397,  -123,  -353,  1062,  -353,   174,  1666,   164,  1255,   -29,
     802,  -353,   802,   176,  1041,   189,  -353,  -353,  -353,   193,
     802,  1104,  1129,   198,   953,  -160,  -353,  1230,  1321,  1015,
    1370,  1370,  -353,    18,  -353,   554,   802,   802,   206,  1616,
     207,   208,   241,   164,  1139,   454,   678,   539,   352,   352,
     442,   442,   442,   442,  -353,  -353,    70,   366,   376,   388,
    -353,  -353,  -353,   -18,   -40,   244,   262,   262,   382,   368,
      10,  -353,   395,  -353,  -353,  -353,   520,   113,  -353,   245,
    1666,   478,   407,  -160,  -353,  -353,   509,  -107,  -353,    16,
     290,   387,  -107,   290,   387,   802,  -353,   294,   802,   802,
    -353,  1539,  1295,  -353,   802,  -353,  -353,  1518,   424,   424,
    -353,  -353,   441,  -353,  -353,   298,   300,  1370,  1370,   554,
     802,   164,   164,   164,   301,   -33,   472,   472,   472,   802,
     553,   572,   238,  -353,  -353,    10,   802,   -93,    10,   -90,
     -36,   326,   328,   453,    95,  -353,   579,   164,   802,   802,
    -353,  -353,   603,   426,   582,  -353,   583,  -353,   666,  -101,
    -353,  -353,  -101,  -353,  -353,   394,  1666,  1560,  -353,   802,
     925,   802,   802,   334,   335,   542,   484,  -353,  -353,   341,
     342,  1073,   343,   345,   346,  -353,  -353,   474,   350,   351,
     360,  1666,   593,   -15,   407,  -353,  1666,   802,   362,  -353,
    -353,   -80,   113,  -353,   363,   364,   408,   408,   373,   113,
     -89,  1286,  -353,   377,  1581,  1161,  -353,  1666,   495,   606,
    -353,  -353,   100,  1666,   385,  -353,  -353,  -353,  1666,   802,
    -353,   379,  1189,  -353,  -353,   802,   802,   238,  -353,  -353,
    -353,  -353,  -353,  -353,   626,   626,   626,   802,   802,   631,
    -353,  1666,   408,  -353,   119,   408,   408,   142,   148,   408,
    -353,  -353,   386,   386,   386,  -353,   386,  -353,  -353,   386,
     386,   389,   386,   386,   386,  -353,   596,  -353,   386,   596,
     386,   390,   386,   596,  -353,  -353,  -353,   386,   596,   393,
     396,  -353,  -353,   802,  -353,  -353,  -353,   802,   415,   672,
     778,  -353,   666,   974,  -353,  -353,  -353,  -353,  -353,  -353,
    -353,  -353,  -353,  -353,   -61,  1666,   407,  -353,   184,   191,
     220,  1666,  1666,   629,   221,   -41,   236,   237,  -353,  -353,
     242,   645,  -353,  -353,  -353,  -353,  -353,  -353,   650,  -353,
    -353,  -353,  -353,  -353,  -353,  -353,  -353,   650,  -353,  -353,
    -353,  -353,   651,   652,     5,  1581,  1666,   397,  -353,  1666,
    -353,  1666,   247,  -353,   476,  -353,   530,   657,  -353,  -353,
    -353,   802,  -353,  -353,  -353,  -353,  -353,   248,  -164,    32,
    -164,  -164,  -353,   258,  -164,  -164,  -164,    32,  -164,    32,
    -164,   260,  -164,    32,  -164,    32,   409,   410,   507,  -353,
     660,   381,  -353,  -353,   537,   -98,  -353,   432,  -353,  -353,
     408,  -353,  -353,  1666,   680,  -353,  -353,  -353,   496,   683,
     684,  -353,  -353,  -353,  -353,  -353,  -353,  -353,  -353,  -353,
    -353,  -353,  -353,   408,   443,   439,   690,  -353,  -353,    32,
      32,    32,   265,  -353,  -353,  -353
};

/* YYPGOTO[NTERM-NUM].  */
static const short int yypgoto[] =
{
    -353,  -353,   687,   533,    68,  -353,   281,   163,  -353,  -353,
    -256,  -352,  -353,   -99,  -353,  -353,   573,   112,   552,  -120,
     452,   -72,  -353,  -353,  -115,  -353,  -353,  -353,   332,   412,
     -69,  -181,  -353,  -353,  -353,   679,   543,  -353,    89,   513,
     697,   616,   451,   246,  -179,  -353,  -353,  -353,  -353,  -353,
      52,  -353,   344,   336,  -353,  -353,   435,  -174,   -81,  -255,
    -353,   200,  -315,  -353,  -353,  -353,  -353,   647,   -25,   -73,
    -353,  -353,   444,   617
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -265
static const short int yytable[] =
{
      82,   272,   309,    88,   383,   428,    51,    52,    53,    54,
      55,    56,  -126,    88,  -128,  -127,   154,   127,    18,   254,
      57,    58,   430,   578,   293,   254,   254,    38,    59,   212,
     612,   177,   111,   113,   114,   104,   220,   115,   117,    26,
     221,   213,   157,   125,   249,   579,    62,   195,   199,   333,
       1,     5,   148,    63,   190,   333,   374,   191,   150,   151,
     596,   580,   279,   377,     5,   280,    64,    65,    66,     2,
     237,    36,   174,   127,   254,   441,   377,   172,   180,   597,
     384,   255,   238,   581,   598,   186,   599,   255,   255,    99,
     158,   188,   385,   178,   105,   194,   270,   201,   202,   204,
      69,    82,   158,   207,   208,   209,   210,   211,   148,   273,
       3,   219,   224,   225,   226,   227,   228,   229,   230,   231,
     232,   233,   234,    51,    52,    53,    54,    55,    56,    39,
     317,   313,   314,   582,    19,   378,   255,    57,    58,    40,
     178,    83,   296,   334,   546,    59,    60,   260,   378,   404,
      44,    31,    84,    61,   613,   256,   257,    33,    20,   583,
    -139,   496,   382,    62,   305,   281,     4,   282,    41,   246,
      63,   584,   294,   108,   109,   287,     5,   214,   544,     6,
     105,    45,    85,    64,    65,    66,    86,     5,   126,   473,
     553,   297,   298,    42,   239,   375,   222,   172,   381,   192,
      34,   156,   344,   158,    67,    68,   242,   192,  -140,    37,
     311,    95,     1,    96,     7,    87,   175,    69,   247,   320,
      51,    52,    53,    54,    55,    56,   360,   585,    97,   321,
      70,     2,   100,   310,    57,    58,   429,   205,   369,   370,
     110,   322,    59,   264,   499,   500,    98,    75,    76,    77,
      78,    79,    89,   346,   347,   223,   102,   106,   107,   350,
      62,  -126,    89,  -128,  -127,   153,   336,    63,   567,   337,
     569,   119,     3,   292,   573,   361,   575,   120,   411,   323,
      64,    65,    66,   167,   371,   525,   263,   437,   438,   529,
     121,   376,   122,   -92,   531,    51,    52,    53,    54,    55,
      56,   123,   172,   394,   395,   124,   159,   397,    44,    57,
      58,   169,   312,   403,    69,   -92,   100,    59,   203,   171,
     170,    71,    72,    73,   408,   176,    74,   412,     4,   216,
     217,   331,   218,   504,   182,    62,   506,   507,     5,    45,
     510,     6,    63,   187,    46,   389,   619,   620,   390,   621,
     480,     5,   431,   481,    47,    64,    65,    66,   587,   215,
     340,   341,   160,   343,    75,    76,    77,    78,    79,   389,
     235,   -60,   505,    48,   236,   241,     7,   161,   143,   144,
     145,   146,   147,   243,   483,   607,   608,   609,   610,    69,
     394,   495,   336,   250,   253,   508,   162,  -264,   336,   261,
     266,   509,   501,   502,  -264,  -264,  -264,  -264,  -264,  -264,
    -264,   268,  -264,  -264,  -264,  -264,  -264,  -264,  -264,  -264,
    -264,  -264,  -264,  -264,  -264,   251,   163,   276,   405,   283,
    -264,   406,  -264,  -264,   547,   560,   561,   548,   564,   565,
     566,   547,   285,   568,   549,   570,   286,   572,   535,   574,
     164,   290,   536,   116,   539,   541,  -264,   403,   299,   301,
     302,    75,    76,    77,    78,    79,  -264,  -264,  -264,  -264,
     547,   336,   147,   550,   552,  -264,   139,   140,   141,   142,
     143,   144,   145,   146,   147,  -264,   336,   336,  -264,   554,
     555,   614,   336,   303,   306,   556,  -264,   480,   594,  -264,
     588,   595,  -264,  -264,   307,  -264,  -264,  -264,   600,   315,
     600,   601,  -264,   602,   622,   336,   308,    24,   625,  -264,
      29,  -264,   318,   319,   316,   328,   593,  -264,  -264,   332,
      51,    52,    53,    54,    55,    56,    75,    76,    77,    78,
      79,   329,   338,   333,    57,    58,  -264,   345,   352,   355,
    -264,   357,    59,   358,   365,  -264,   372,    51,    52,    53,
      54,    55,    56,   141,   142,   143,   144,   145,   146,   147,
      62,    57,    58,   196,   367,   373,  -264,    63,   386,    59,
     387,   388,   391,   398,  -264,   399,   400,   413,   414,   415,
      64,    65,    66,   416,   418,   419,   420,    62,   421,   422,
    -264,   423,   424,   425,    63,  -264,    51,    52,    53,    54,
      55,    56,   426,   427,   432,   435,   436,    64,    65,    66,
      57,    58,   155,   478,    69,   439,   479,   473,    59,   497,
    -264,  -264,   484,  -264,   503,  -264,  -264,   482,   511,   522,
     537,   518,   527,  -264,  -264,   532,    62,  -264,   533,   551,
     557,    69,   193,    63,   562,   590,   576,   577,   197,   589,
     592,   605,   603,   604,   606,   611,    64,    65,    66,    51,
      52,    53,    54,    55,    56,    51,    52,    53,    54,    55,
      56,   396,   334,    57,    58,   615,   616,   617,   618,    57,
      58,    59,   623,   336,   624,    32,   494,    59,   586,   206,
      69,   140,   141,   142,   143,   144,   145,   146,   147,    62,
     245,   327,   271,   433,   274,    62,    63,   366,   103,   265,
     277,    50,    63,   181,   342,   440,   434,   571,   542,    64,
      65,    66,   152,   354,   189,    64,    65,    66,     0,     0,
       0,     5,     0,     0,   401,   198,     0,     0,   295,     0,
     538,     0,     0,     0,     0,     0,   304,     0,     0,     0,
       0,     0,     0,    69,     0,     0,     0,     0,     0,    69,
       0,    75,    76,    77,    78,    79,     0,     0,     0,     0,
       0,    51,    52,    53,    54,    55,    56,     0,     0,     0,
       0,     0,     0,     0,     0,    57,    58,     0,    75,    76,
      77,    78,    79,    59,     0,    51,    52,    53,    54,    55,
      56,     0,     0,     0,     0,     0,     0,     0,     0,    57,
      58,    62,     0,     0,     0,     0,     0,    59,    63,     0,
       0,     0,   359,     0,   362,   363,   364,     0,     0,     0,
       0,    64,    65,    66,     0,    62,     0,    75,    76,    77,
      78,    79,    63,     0,     0,     0,   540,     0,     0,     0,
     392,     0,     0,     0,     0,    64,    65,    66,    51,    52,
      53,    54,    55,    56,     0,    69,     0,     0,   513,   514,
       0,   515,    57,    58,   516,   517,     0,   519,   520,   521,
      59,     0,     0,   524,     0,   526,     0,   528,     0,    69,
       0,     0,   530,     0,     0,     0,     0,     0,    62,     0,
      75,    76,    77,    78,    79,    63,    75,    76,    77,    78,
      79,     0,     0,     0,     0,     0,     0,     0,    64,    65,
      66,     0,     0,     0,     0,   128,   129,   130,   131,   132,
     133,   134,     0,   135,   136,   137,   138,   139,   140,   141,
     142,   143,   144,   145,   146,   147,     0,     0,     0,     0,
       0,     0,   112,   128,   129,   130,   131,   132,   133,   134,
       0,   135,   136,   137,   138,   139,   140,   141,   142,   143,
     144,   145,   146,   147,   128,   129,   130,   131,   132,   133,
     134,     0,   135,   136,   137,   138,   139,   140,   141,   142,
     143,   144,   145,   146,   147,   136,   137,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147,     0,     0,     0,
       0,     0,    75,    76,    77,    78,    79,   409,   131,   132,
     133,   134,     0,   135,   136,   137,   138,   139,   140,   141,
     142,   143,   144,   145,   146,   147,    75,    76,    77,    78,
      79,   128,   129,   130,   131,   132,   133,   134,     0,   135,
     136,   137,   138,   139,   140,   141,   142,   143,   144,   145,
     146,   147,   128,   129,   130,   131,   132,   133,   134,     0,
     135,   136,   137,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   147,   137,   138,   139,   140,   141,   142,   143,
     144,   145,   146,   147,     0,     0,     0,     0,     0,    75,
      76,    77,    78,    79,   128,   129,   130,   131,   132,   133,
     134,     0,   135,   136,   137,   138,   139,   140,   141,   142,
     143,   144,   145,   146,   147,     0,     0,     0,     0,   128,
     129,   130,   131,   132,   133,   134,   284,   135,   136,   137,
     138,   139,   140,   141,   142,   143,   144,   145,   146,   147,
     138,   139,   140,   141,   142,   143,   144,   145,   146,   147,
       0,   128,   129,   130,   131,   132,   133,   134,   410,   135,
     136,   137,   138,   139,   140,   141,   142,   143,   144,   145,
     146,   147,     0,     0,     0,     0,     0,     0,     0,   128,
     129,   130,   131,   132,   133,   134,   291,   135,   136,   137,
     138,   139,   140,   141,   142,   143,   144,   145,   146,   147,
     128,   129,   130,   131,   132,   133,   134,   543,   135,   136,
     137,   138,   139,   140,   141,   142,   143,   144,   145,   146,
     147,   129,   130,   131,   132,   133,   134,     0,   135,   136,
     137,   138,   139,   140,   141,   142,   143,   144,   145,   146,
     147,   485,   486,   487,   488,   128,   129,   130,   131,   132,
     133,   134,     0,   135,   136,   137,   138,   139,   140,   141,
     142,   143,   144,   145,   146,   147,     0,     0,     0,     0,
       0,   275,     0,     0,     0,     0,     0,     0,     0,     0,
     489,   490,   491,     0,     0,   128,   129,   130,   131,   132,
     133,   134,   275,   135,   136,   137,   138,   139,   140,   141,
     142,   143,   144,   145,   146,   147,     0,     0,   442,   443,
     444,   445,     0,   130,   131,   132,   133,   134,   446,   135,
     136,   137,   138,   139,   140,   141,   142,   143,   144,   145,
     146,   147,     0,     0,   288,     0,   447,   448,     0,     0,
       0,     0,   449,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   450,     0,     0,     0,     0,     0,   289,
       0,   451,     0,  -265,  -265,  -265,  -265,   452,   135,   136,
     137,   138,   139,   140,   141,   142,   143,   144,   145,   146,
     147,     0,     0,     0,     0,     0,     0,     0,   453,   454,
       0,   477,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   455,   456,     0,
     492,   493,   457,   458,   459,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   116,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   460,     0,
       0,     0,     0,     0,     0,     0,   278,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   461,     0,   462,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   463,     0,     0,   464,   465,
     466,   467,   468,     0,     0,     0,   349,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   469,
     470,     0,     0,     0,     0,     0,     0,   471,   128,   129,
     130,   131,   132,   133,   134,     0,   135,   136,   137,   138,
     139,   140,   141,   142,   143,   144,   145,   146,   147,   128,
     129,   130,   131,   132,   133,   134,     0,   135,   136,   137,
     138,   139,   140,   141,   142,   143,   144,   145,   146,   147,
     128,   129,   130,   131,   132,   133,   134,     0,   135,   136,
     137,   138,   139,   140,   141,   142,   143,   144,   145,   146,
     147,   128,   129,   130,   131,   132,   133,   134,     0,   135,
     136,   137,   138,   139,   140,   141,   142,   143,   144,   145,
     146,   147,     0,     0,     0,     0,     0,     0,     0,     0,
     474,     0,     0,   351,     0,     0,   128,   129,   130,   131,
     132,   133,   134,   348,   135,   136,   137,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147,     0,   127,     0,
       0,     0,   300,     0,   407,   128,   129,   130,   131,   132,
     133,   134,   475,   135,   136,   137,   138,   139,   140,   141,
     142,   143,   144,   145,   146,   147,   128,   129,   130,   131,
     132,   133,   134,   148,   135,   136,   137,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147
};

/* YYCONFLP[YYPACT[STATE-NUM]] -- Pointer into YYCONFL of start of
   list of conflicting reductions corresponding to action entry for
   state STATE-NUM in yytable.  0 means no conflicts.  The list in
   yyconfl is terminated by a rule number of 0.  */
static const unsigned char yyconflp[] =
{
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     3,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     5,     0,     0,
       0,     0,     0,     0,     7,     9,    11,    13,    15,    17,
      19,     0,    21,    23,    25,    27,    29,    31,    33,    35,
      37,    39,    41,    43,    45,     0,     0,     0,     0,     0,
      47,     0,    49,    51,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    53,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    55,    57,    59,    61,
       0,     0,     0,     0,     0,    63,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    65,     0,     0,    67,     0,
       0,     0,     0,     0,     0,     0,    69,     0,     0,    71,
       0,     0,    73,    75,     0,    77,    79,    81,     0,     0,
       0,     0,    83,     0,     0,     0,     0,     0,     0,    85,
       0,    87,     0,     0,     1,     0,     0,    89,    91,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    93,     0,     0,     0,
      95,     0,     0,     0,     0,    97,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    99,     0,     0,     0,
       0,     0,     0,     0,   101,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     103,     0,     0,     0,     0,   105,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     107,   109,     0,   111,     0,   113,   115,     0,     0,     0,
       0,     0,     0,   117,   119,     0,     0,   121,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0
};

/* YYCONFL[I] -- lists of conflicting rule numbers, each terminated by
   0, pointed into by YYCONFLP.  */
static const short int yyconfl[] =
{
       0,    56,     0,    71,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0,   265,     0,   265,     0,   265,     0,   265,
       0,   265,     0
};

static const short int yycheck[] =
{
      25,   180,    20,     3,   319,    20,     3,     4,     5,     6,
       7,     8,     3,     3,     3,     3,    88,     3,    68,   115,
      17,    18,   374,    18,     6,   115,   115,     3,    25,     6,
     128,   190,    57,    58,    59,   105,    33,    62,    63,     8,
      37,    18,   190,   105,   164,    40,    43,   120,   121,   156,
      61,   187,    38,    50,    91,   156,   312,    94,    83,    84,
     224,    56,    91,   156,   187,    94,    63,    64,    65,    80,
     103,    19,   228,     3,   115,   390,   156,   237,   190,   243,
     116,   177,   115,    78,    52,   110,    54,   177,   177,    37,
     250,   116,   128,   252,   250,   120,   232,   122,   123,   124,
      97,   126,   250,   128,   129,   130,   131,   132,    38,   232,
     121,   136,   137,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   147,     3,     4,     5,     6,     7,     8,   105,
     250,   246,   247,   128,   184,   228,   177,    17,    18,   115,
     252,     9,   215,   250,   496,    25,    26,   172,   228,   250,
      79,     0,    20,    33,   252,   251,   252,   249,   208,   154,
     249,   417,   252,    43,   236,   190,   177,   192,   144,   133,
      50,   166,   154,   251,   252,   200,   187,   154,   239,   190,
     250,   110,   250,    63,    64,    65,   115,   187,   250,   250,
     505,   216,   217,   169,   227,   315,   193,   237,   318,   236,
     114,    89,   275,   250,    84,    85,   253,   236,   249,   207,
     250,   249,    61,    18,   225,   144,   104,    97,   182,   106,
       3,     4,     5,     6,     7,     8,   299,   222,     3,   116,
     110,    80,   251,   251,    17,    18,   251,   125,   307,   308,
       9,   128,    25,   175,   425,   426,     3,   244,   245,   246,
     247,   248,   252,   278,   279,   252,     3,     3,     3,   284,
      43,   252,   252,   252,   252,   251,   250,    50,   523,   253,
     525,   252,   121,   205,   529,   300,   531,   252,   351,   166,
      63,    64,    65,    38,   309,   459,   174,   386,   387,   463,
     252,   316,   252,   228,   468,     3,     4,     5,     6,     7,
       8,   252,   237,   328,   329,   252,    62,   332,    79,    17,
      18,    97,   244,   338,    97,   250,   251,    25,    26,    26,
       3,   201,   202,   203,   349,     3,   206,   352,   177,    13,
      14,   263,    16,   432,     3,    43,   435,   436,   187,   110,
     439,   190,    50,   252,   115,   250,   601,   602,   253,   604,
     250,   187,   377,   253,   125,    63,    64,    65,   537,   252,
     271,   272,   118,   274,   244,   245,   246,   247,   248,   250,
       3,   127,   253,   144,     3,   253,   225,   133,    26,    27,
      28,    29,    30,     3,   409,     4,     5,     6,     7,    97,
     415,   416,   250,   127,     3,   253,   152,     3,   250,   161,
       3,   253,   427,   428,    10,    11,    12,    13,    14,    15,
      16,     3,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,   163,   182,   253,   339,   253,
      36,   342,    38,    39,   250,   516,   517,   253,   519,   520,
     521,   250,   253,   524,   253,   526,   253,   528,   473,   530,
     206,   253,   477,   236,   479,   480,    62,   482,   252,   252,
     252,   244,   245,   246,   247,   248,    72,    73,    74,    75,
     250,   250,    30,   253,   253,    81,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    91,   250,   250,    94,   253,
     253,   590,   250,   252,   128,   253,   102,   250,   250,   105,
     253,   253,   108,   109,   128,   111,   112,   113,   250,   127,
     250,   253,   118,   253,   613,   250,   128,     4,   253,   125,
       7,   127,   127,     3,   156,    47,   551,   133,   134,    20,
       3,     4,     5,     6,     7,     8,   244,   245,   246,   247,
     248,   134,   252,   156,    17,    18,   152,   253,   124,   108,
     156,   253,    25,   253,   253,   161,     3,     3,     4,     5,
       6,     7,     8,    24,    25,    26,    27,    28,    29,    30,
      43,    17,    18,    46,   102,     3,   182,    50,   252,    25,
     252,   128,     3,   157,   190,     3,     3,   253,   253,    47,
      63,    64,    65,   109,   253,   253,   253,    43,   253,   253,
     206,   127,   252,   252,    50,   211,     3,     4,     5,     6,
       7,     8,   252,    20,   252,   252,   252,    63,    64,    65,
      17,    18,    89,   128,    97,   252,    20,   250,    25,     3,
     236,   237,   253,   239,     3,   241,   242,   252,   252,    43,
     225,   252,   252,   249,   250,   252,    43,   253,   252,    20,
       5,    97,   119,    50,     4,   125,     5,     5,   131,   183,
       3,   154,   253,   253,     4,   128,    63,    64,    65,     3,
       4,     5,     6,     7,     8,     3,     4,     5,     6,     7,
       8,    78,   250,    17,    18,     5,   190,     4,     4,    17,
      18,    25,   253,   250,     4,     8,   415,    25,   535,   126,
      97,    23,    24,    25,    26,    27,    28,    29,    30,    43,
     158,   259,   179,   381,   181,    43,    50,   305,    39,   176,
     187,    24,    50,   107,   273,   389,   382,   527,   482,    63,
      64,    65,    85,   289,   117,    63,    64,    65,    -1,    -1,
      -1,   187,    -1,    -1,    78,   218,    -1,    -1,   215,    -1,
      78,    -1,    -1,    -1,    -1,    -1,   223,    -1,    -1,    -1,
      -1,    -1,    -1,    97,    -1,    -1,    -1,    -1,    -1,    97,
      -1,   244,   245,   246,   247,   248,    -1,    -1,    -1,    -1,
      -1,     3,     4,     5,     6,     7,     8,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    17,    18,    -1,   244,   245,
     246,   247,   248,    25,    -1,     3,     4,     5,     6,     7,
       8,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    17,
      18,    43,    -1,    -1,    -1,    -1,    -1,    25,    50,    -1,
      -1,    -1,   299,    -1,   301,   302,   303,    -1,    -1,    -1,
      -1,    63,    64,    65,    -1,    43,    -1,   244,   245,   246,
     247,   248,    50,    -1,    -1,    -1,    78,    -1,    -1,    -1,
     327,    -1,    -1,    -1,    -1,    63,    64,    65,     3,     4,
       5,     6,     7,     8,    -1,    97,    -1,    -1,   443,   444,
      -1,   446,    17,    18,   449,   450,    -1,   452,   453,   454,
      25,    -1,    -1,   458,    -1,   460,    -1,   462,    -1,    97,
      -1,    -1,   467,    -1,    -1,    -1,    -1,    -1,    43,    -1,
     244,   245,   246,   247,   248,    50,   244,   245,   246,   247,
     248,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    63,    64,
      65,    -1,    -1,    -1,    -1,    10,    11,    12,    13,    14,
      15,    16,    -1,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    -1,    -1,    -1,    -1,
      -1,    -1,    97,    10,    11,    12,    13,    14,    15,    16,
      -1,    18,    19,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    10,    11,    12,    13,    14,    15,
      16,    -1,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    -1,    -1,    -1,
      -1,    -1,   244,   245,   246,   247,   248,   102,    13,    14,
      15,    16,    -1,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,   244,   245,   246,   247,
     248,    10,    11,    12,    13,    14,    15,    16,    -1,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    10,    11,    12,    13,    14,    15,    16,    -1,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    -1,    -1,    -1,    -1,    -1,   244,
     245,   246,   247,   248,    10,    11,    12,    13,    14,    15,
      16,    -1,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    -1,    -1,    -1,    -1,    10,
      11,    12,    13,    14,    15,    16,   105,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      -1,    10,    11,    12,    13,    14,    15,    16,   253,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    10,
      11,    12,    13,    14,    15,    16,   253,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      10,    11,    12,    13,    14,    15,    16,   253,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    11,    12,    13,    14,    15,    16,    -1,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    72,    73,    74,    75,    10,    11,    12,    13,    14,
      15,    16,    -1,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    -1,    -1,    -1,    -1,
      -1,   250,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     111,   112,   113,    -1,    -1,    10,    11,    12,    13,    14,
      15,    16,   250,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    -1,    -1,    42,    43,
      44,    45,    -1,    12,    13,    14,    15,    16,    52,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    -1,    -1,   250,    -1,    70,    71,    -1,    -1,
      -1,    -1,    76,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    87,    -1,    -1,    -1,    -1,    -1,   250,
      -1,    95,    -1,    13,    14,    15,    16,   101,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   122,   123,
      -1,   250,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   141,   142,    -1,
     241,   242,   146,   147,   148,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   236,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   172,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   211,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   190,    -1,   192,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   209,    -1,    -1,   212,   213,
     214,   215,   216,    -1,    -1,    -1,   211,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   233,
     234,    -1,    -1,    -1,    -1,    -1,    -1,   241,    10,    11,
      12,    13,    14,    15,    16,    -1,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    10,
      11,    12,    13,    14,    15,    16,    -1,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      10,    11,    12,    13,    14,    15,    16,    -1,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    10,    11,    12,    13,    14,    15,    16,    -1,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      39,    -1,    -1,   105,    -1,    -1,    10,    11,    12,    13,
      14,    15,    16,    94,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    -1,     3,    -1,
      -1,    -1,    36,    -1,    94,    10,    11,    12,    13,    14,
      15,    16,    81,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    10,    11,    12,    13,
      14,    15,    16,    38,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const unsigned short int yystos[] =
{
       0,    61,    80,   121,   177,   187,   190,   225,   255,   256,
     257,   287,   291,   299,   300,   303,   305,   319,    68,   184,
     208,   318,   288,   293,   293,   268,     8,   320,   321,   293,
     301,     0,   256,   249,   114,   304,   304,   207,     3,   105,
     115,   144,   169,   289,    79,   110,   115,   125,   144,   294,
     294,     3,     4,     5,     6,     7,     8,    17,    18,    25,
      26,    33,    43,    50,    63,    64,    65,    84,    85,    97,
     110,   201,   202,   203,   206,   244,   245,   246,   247,   248,
     269,   270,   322,     9,    20,   250,   115,   144,     3,   252,
     271,   272,   273,   276,   286,   249,    18,     3,     3,   304,
     251,   290,     3,   289,   105,   250,     3,     3,   251,   252,
       9,   322,    97,   322,   322,   322,   236,   322,   327,   252,
     252,   252,   252,   252,   252,   105,   250,     3,    10,    11,
      12,    13,    14,    15,    16,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    38,   275,
     322,   322,   321,   251,   275,   257,   271,   190,   250,    62,
     118,   133,   152,   182,   206,   277,   279,    38,   274,    97,
       3,    26,   237,   258,   228,   271,     3,   190,   252,   295,
     190,   295,     3,   322,   323,   324,   322,   252,   322,   327,
      91,    94,   236,   257,   322,   323,    46,   131,   218,   323,
     325,   322,   322,    26,   322,   271,   270,   322,   322,   322,
     322,   322,     6,    18,   154,   252,    13,    14,    16,   322,
      33,    37,   193,   252,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,     3,     3,   103,   115,   227,
     283,   253,   253,     3,   302,   272,   133,   182,   280,   273,
     127,   163,   278,     3,   115,   177,   251,   252,   316,   317,
     322,   161,   264,   271,   258,   290,     3,   298,     3,   267,
     232,   257,   298,   232,   257,   250,   253,   257,   211,    91,
      94,   322,   322,   253,   105,   253,   253,   322,   250,   250,
     253,   253,   258,     6,   154,   257,   323,   322,   322,   252,
      36,   252,   252,   252,   257,   275,   128,   128,   128,    20,
     251,   250,   258,   278,   278,   127,   156,   273,   127,     3,
     106,   116,   128,   166,   306,   307,   308,   274,    47,   134,
     265,   258,    20,   156,   250,   292,   250,   253,   252,   296,
     292,   292,   296,   292,   323,   253,   322,   322,    94,   211,
     322,   105,   124,   326,   326,   108,   259,   253,   253,   257,
     323,   322,   257,   257,   257,   253,   283,   102,   284,   284,
     284,   322,     3,     3,   264,   273,   322,   156,   228,   281,
     282,   273,   252,   316,   116,   128,   252,   252,   128,   250,
     253,     3,   257,   260,   322,   322,    78,   322,   157,     3,
       3,    78,   297,   322,   250,   292,   292,    94,   322,   102,
     253,   323,   322,   253,   253,    47,   109,   263,   253,   253,
     253,   253,   253,   127,   252,   252,   252,    20,    20,   251,
     265,   322,   252,   282,   306,   252,   252,   267,   267,   252,
     307,   316,    42,    43,    44,    45,    52,    70,    71,    76,
      87,    95,   101,   122,   123,   141,   142,   146,   147,   148,
     172,   190,   192,   209,   212,   213,   214,   215,   216,   233,
     234,   241,   314,   250,    39,    81,   261,   250,   128,    20,
     250,   253,   252,   322,   253,    72,    73,    74,    75,   111,
     112,   113,   241,   242,   260,   322,   264,     3,   285,   285,
     285,   322,   322,     3,   267,   253,   267,   267,   253,   253,
     267,   252,   310,   310,   310,   310,   310,   310,   252,   310,
     310,   310,    43,   311,   310,   311,   310,   252,   310,   311,
     310,   311,   252,   252,   309,   322,   322,   225,    78,   322,
      78,   322,   297,   253,   239,   262,   265,   250,   253,   253,
     253,    20,   253,   316,   253,   253,   253,     5,   312,   313,
     312,   312,     4,   315,   312,   312,   312,   313,   312,   313,
     312,   315,   312,   313,   312,   313,     5,     5,    18,    40,
      56,    78,   128,   154,   166,   222,   261,   298,   253,   183,
     125,   266,     3,   322,   250,   253,   224,   243,    52,    54,
     250,   253,   253,   253,   253,   154,     4,     4,     5,     6,
       7,   128,   128,   252,   267,     5,   190,     4,     4,   313,
     313,   313,   267,   253,     4,   253
};


/* Prevent warning if -Wmissing-prototypes.  */
int yyparse (void);

/* Error token number */
#define YYTERROR 1

/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */


#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N) ((void) 0)
#endif


#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */
#define YYLEX yylex ()

YYSTYPE yylval;

YYLTYPE yylloc;

int yynerrs;
int yychar;

static const int YYEOF = 0;
static const int YYEMPTY = -2;

typedef enum { yyok, yyaccept, yyabort, yyerr } YYRESULTTAG;

#define YYCHK(YYE)							     \
   do { YYRESULTTAG yyflag = YYE; if (yyflag != yyok) return yyflag; }	     \
   while (YYID (0))

#if YYDEBUG

# ifndef YYFPRINTF
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			    \
do {									    \
  if (yydebug)								    \
    {									    \
      YYFPRINTF (stderr, "%s ", Title);					    \
      yy_symbol_print (stderr, Type,					    \
		       Value);  \
      YYFPRINTF (stderr, "\n");						    \
    }									    \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;

#else /* !YYDEBUG */

# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)

#endif /* !YYDEBUG */

/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   SIZE_MAX < YYMAXDEPTH * sizeof (GLRStackItem)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif

/* Minimum number of free items on the stack allowed after an
   allocation.  This is to allow allocation and initialization
   to be completed by functions that call yyexpandGLRStack before the
   stack is expanded, thus insuring that all necessary pointers get
   properly redirected to new data.  */
#define YYHEADROOM 2

#ifndef YYSTACKEXPANDABLE
# if (! defined __cplusplus \
      || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL))
#  define YYSTACKEXPANDABLE 1
# else
#  define YYSTACKEXPANDABLE 0
# endif
#endif

#if YYSTACKEXPANDABLE
# define YY_RESERVE_GLRSTACK(Yystack)			\
  do {							\
    if (Yystack->yyspaceLeft < YYHEADROOM)		\
      yyexpandGLRStack (Yystack);			\
  } while (YYID (0))
#else
# define YY_RESERVE_GLRSTACK(Yystack)			\
  do {							\
    if (Yystack->yyspaceLeft < YYHEADROOM)		\
      yyMemoryExhausted (Yystack);			\
  } while (YYID (0))
#endif


#if YYERROR_VERBOSE

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static size_t
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      size_t yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return strlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

#endif /* !YYERROR_VERBOSE */

/** State numbers, as in LALR(1) machine */
typedef int yyStateNum;

/** Rule numbers, as in LALR(1) machine */
typedef int yyRuleNum;

/** Grammar symbol */
typedef short int yySymbol;

/** Item references, as in LALR(1) machine */
typedef short int yyItemNum;

typedef struct yyGLRState yyGLRState;
typedef struct yyGLRStateSet yyGLRStateSet;
typedef struct yySemanticOption yySemanticOption;
typedef union yyGLRStackItem yyGLRStackItem;
typedef struct yyGLRStack yyGLRStack;

struct yyGLRState {
  /** Type tag: always true.  */
  yybool yyisState;
  /** Type tag for yysemantics.  If true, yysval applies, otherwise
   *  yyfirstVal applies.  */
  yybool yyresolved;
  /** Number of corresponding LALR(1) machine state.  */
  yyStateNum yylrState;
  /** Preceding state in this stack */
  yyGLRState* yypred;
  /** Source position of the first token produced by my symbol */
  size_t yyposn;
  union {
    /** First in a chain of alternative reductions producing the
     *  non-terminal corresponding to this state, threaded through
     *  yynext.  */
    yySemanticOption* yyfirstVal;
    /** Semantic value for this state.  */
    YYSTYPE yysval;
  } yysemantics;
  /** Source location for this state.  */
  YYLTYPE yyloc;
};

struct yyGLRStateSet {
  yyGLRState** yystates;
  /** During nondeterministic operation, yylookaheadNeeds tracks which
   *  stacks have actually needed the current lookahead.  During deterministic
   *  operation, yylookaheadNeeds[0] is not maintained since it would merely
   *  duplicate yychar != YYEMPTY.  */
  yybool* yylookaheadNeeds;
  size_t yysize, yycapacity;
};

struct yySemanticOption {
  /** Type tag: always false.  */
  yybool yyisState;
  /** Rule number for this reduction */
  yyRuleNum yyrule;
  /** The last RHS state in the list of states to be reduced.  */
  yyGLRState* yystate;
  /** The lookahead for this reduction.  */
  int yyrawchar;
  YYSTYPE yyval;
  YYLTYPE yyloc;
  /** Next sibling in chain of options.  To facilitate merging,
   *  options are chained in decreasing order by address.  */
  yySemanticOption* yynext;
};

/** Type of the items in the GLR stack.  The yyisState field
 *  indicates which item of the union is valid.  */
union yyGLRStackItem {
  yyGLRState yystate;
  yySemanticOption yyoption;
};

struct yyGLRStack {
  int yyerrState;


  YYJMP_BUF yyexception_buffer;
  yyGLRStackItem* yyitems;
  yyGLRStackItem* yynextFree;
  size_t yyspaceLeft;
  yyGLRState* yysplitPoint;
  yyGLRState* yylastDeleted;
  yyGLRStateSet yytops;
};

#if YYSTACKEXPANDABLE
static void yyexpandGLRStack (yyGLRStack* yystackp);
#endif

static void yyFail (yyGLRStack* yystackp, const char* yymsg)
  __attribute__ ((__noreturn__));
static void
yyFail (yyGLRStack* yystackp, const char* yymsg)
{
  if (yymsg != NULL)
    yyerror (yymsg);
  YYLONGJMP (yystackp->yyexception_buffer, 1);
}

static void yyMemoryExhausted (yyGLRStack* yystackp)
  __attribute__ ((__noreturn__));
static void
yyMemoryExhausted (yyGLRStack* yystackp)
{
  YYLONGJMP (yystackp->yyexception_buffer, 2);
}

#if YYDEBUG || YYERROR_VERBOSE
/** A printable representation of TOKEN.  */
static inline const char*
yytokenName (yySymbol yytoken)
{
  if (yytoken == YYEMPTY)
    return "";

  return yytname[yytoken];
}
#endif

/** Fill in YYVSP[YYLOW1 .. YYLOW0-1] from the chain of states starting
 *  at YYVSP[YYLOW0].yystate.yypred.  Leaves YYVSP[YYLOW1].yystate.yypred
 *  containing the pointer to the next state in the chain.  */
static void yyfillin (yyGLRStackItem *, int, int) __attribute__ ((__unused__));
static void
yyfillin (yyGLRStackItem *yyvsp, int yylow0, int yylow1)
{
  yyGLRState* s;
  int i;
  s = yyvsp[yylow0].yystate.yypred;
  for (i = yylow0-1; i >= yylow1; i -= 1)
    {
      YYASSERT (s->yyresolved);
      yyvsp[i].yystate.yyresolved = yytrue;
      yyvsp[i].yystate.yysemantics.yysval = s->yysemantics.yysval;
      yyvsp[i].yystate.yyloc = s->yyloc;
      s = yyvsp[i].yystate.yypred = s->yypred;
    }
}

/* Do nothing if YYNORMAL or if *YYLOW <= YYLOW1.  Otherwise, fill in
 * YYVSP[YYLOW1 .. *YYLOW-1] as in yyfillin and set *YYLOW = YYLOW1.
 * For convenience, always return YYLOW1.  */
static inline int yyfill (yyGLRStackItem *, int *, int, yybool)
     __attribute__ ((__unused__));
static inline int
yyfill (yyGLRStackItem *yyvsp, int *yylow, int yylow1, yybool yynormal)
{
  if (!yynormal && yylow1 < *yylow)
    {
      yyfillin (yyvsp, *yylow, yylow1);
      *yylow = yylow1;
    }
  return yylow1;
}

/** Perform user action for rule number YYN, with RHS length YYRHSLEN,
 *  and top stack item YYVSP.  YYLVALP points to place to put semantic
 *  value ($$), and yylocp points to place for location information
 *  (@$).  Returns yyok for normal return, yyaccept for YYACCEPT,
 *  yyerr for YYERROR, yyabort for YYABORT.  */
/*ARGSUSED*/ static YYRESULTTAG
yyuserAction (yyRuleNum yyn, int yyrhslen, yyGLRStackItem* yyvsp,
	      YYSTYPE* yyvalp,
	      YYLTYPE* YYOPTIONAL_LOC (yylocp),
	      yyGLRStack* yystackp
	      )
{
  yybool yynormal __attribute__ ((__unused__)) =
    (yystackp->yysplitPoint == NULL);
  int yylow;
# undef yyerrok
# define yyerrok (yystackp->yyerrState = 0)
# undef YYACCEPT
# define YYACCEPT return yyaccept
# undef YYABORT
# define YYABORT return yyabort
# undef YYERROR
# define YYERROR return yyerrok, yyerr
# undef YYRECOVERING
# define YYRECOVERING() (yystackp->yyerrState != 0)
# undef yyclearin
# define yyclearin (yychar = YYEMPTY)
# undef YYFILL
# define YYFILL(N) yyfill (yyvsp, &yylow, N, yynormal)
# undef YYBACKUP
# define YYBACKUP(Token, Value)						     \
  return yyerror (YY_("syntax error: cannot back up")),     \
	 yyerrok, yyerr

  yylow = 1;
  if (yyrhslen == 0)
    *yyvalp = yyval_default;
  else
    *yyvalp = yyvsp[YYFILL (1-yyrhslen)].yystate.yysemantics.yysval;
  YYLLOC_DEFAULT ((*yylocp), (yyvsp - yyrhslen), yyrhslen);

  switch (yyn)
    {
        case 4:

/* Line 936 of glr.c  */
#line 314 "glrmysql.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 936 of glr.c  */
#line 318 "glrmysql.y"
    { emit("SELECTNODATA %d %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 6:

/* Line 936 of glr.c  */
#line 322 "glrmysql.y"
    { emit("SELECT %d %d %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (11))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (11))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (11))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 8:

/* Line 936 of glr.c  */
#line 326 "glrmysql.y"
    { emit("WHERE"); ;}
    break;

  case 10:

/* Line 936 of glr.c  */
#line 330 "glrmysql.y"
    { emit("GROUPBYLIST %d %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (4))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 11:

/* Line 936 of glr.c  */
#line 334 "glrmysql.y"
    { emit("GROUPBY %d",  (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (2))].yystate.yysemantics.yysval.intval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 12:

/* Line 936 of glr.c  */
#line 336 "glrmysql.y"
    { emit("GROUPBY %d",  (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (4))].yystate.yysemantics.yysval.intval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (4))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 13:

/* Line 936 of glr.c  */
#line 339 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 14:

/* Line 936 of glr.c  */
#line 340 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 15:

/* Line 936 of glr.c  */
#line 341 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 16:

/* Line 936 of glr.c  */
#line 344 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 17:

/* Line 936 of glr.c  */
#line 345 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 19:

/* Line 936 of glr.c  */
#line 348 "glrmysql.y"
    { emit("HAVING"); ;}
    break;

  case 21:

/* Line 936 of glr.c  */
#line 350 "glrmysql.y"
    { emit("ORDERBY %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 23:

/* Line 936 of glr.c  */
#line 353 "glrmysql.y"
    { emit("LIMIT 1"); ;}
    break;

  case 24:

/* Line 936 of glr.c  */
#line 354 "glrmysql.y"
    { emit("LIMIT 2"); ;}
    break;

  case 26:

/* Line 936 of glr.c  */
#line 358 "glrmysql.y"
    { emit("INTO %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (2))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 27:

/* Line 936 of glr.c  */
#line 361 "glrmysql.y"
    { emit("COLUMN %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 28:

/* Line 936 of glr.c  */
#line 362 "glrmysql.y"
    { emit("COLUMN %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 29:

/* Line 936 of glr.c  */
#line 365 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 30:

/* Line 936 of glr.c  */
#line 366 "glrmysql.y"
    { if(((*yyvalp).intval) & 01) yyerror("duplicate ALL option"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 01; ;}
    break;

  case 31:

/* Line 936 of glr.c  */
#line 367 "glrmysql.y"
    { if(((*yyvalp).intval) & 02) yyerror("duplicate DISTINCT option"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 02; ;}
    break;

  case 32:

/* Line 936 of glr.c  */
#line 368 "glrmysql.y"
    { if(((*yyvalp).intval) & 04) yyerror("duplicate DISTINCTROW option"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 04; ;}
    break;

  case 33:

/* Line 936 of glr.c  */
#line 369 "glrmysql.y"
    { if(((*yyvalp).intval) & 010) yyerror("duplicate HIGH_PRIORITY option"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 010; ;}
    break;

  case 34:

/* Line 936 of glr.c  */
#line 370 "glrmysql.y"
    { if(((*yyvalp).intval) & 020) yyerror("duplicate STRAIGHT_JOIN option"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 020; ;}
    break;

  case 35:

/* Line 936 of glr.c  */
#line 371 "glrmysql.y"
    { if(((*yyvalp).intval) & 040) yyerror("duplicate SQL_SMALL_RESULT option"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 040; ;}
    break;

  case 36:

/* Line 936 of glr.c  */
#line 372 "glrmysql.y"
    { if(((*yyvalp).intval) & 0100) yyerror("duplicate SQL_BIG_RESULT option"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 0100; ;}
    break;

  case 37:

/* Line 936 of glr.c  */
#line 373 "glrmysql.y"
    { if(((*yyvalp).intval) & 0200) yyerror("duplicate SQL_CALC_FOUND_ROWS option"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 0200; ;}
    break;

  case 38:

/* Line 936 of glr.c  */
#line 376 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 39:

/* Line 936 of glr.c  */
#line 377 "glrmysql.y"
    {((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 40:

/* Line 936 of glr.c  */
#line 378 "glrmysql.y"
    { emit("SELECTALL"); ((*yyvalp).intval) = 1; ;}
    break;

  case 42:

/* Line 936 of glr.c  */
#line 383 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 43:

/* Line 936 of glr.c  */
#line 384 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 46:

/* Line 936 of glr.c  */
#line 392 "glrmysql.y"
    { emit("TABLE %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 47:

/* Line 936 of glr.c  */
#line 393 "glrmysql.y"
    { emit("TABLE %s.%s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.strval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval));
                               free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 48:

/* Line 936 of glr.c  */
#line 395 "glrmysql.y"
    { emit("SUBQUERYAS %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 49:

/* Line 936 of glr.c  */
#line 396 "glrmysql.y"
    { emit("TABLEREFERENCES %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 52:

/* Line 936 of glr.c  */
#line 403 "glrmysql.y"
    { emit ("ALIAS %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (2))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (2))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 53:

/* Line 936 of glr.c  */
#line 404 "glrmysql.y"
    { emit ("ALIAS %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 55:

/* Line 936 of glr.c  */
#line 410 "glrmysql.y"
    { emit("JOIN %d", 0100+(((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (5))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 56:

/* Line 936 of glr.c  */
#line 412 "glrmysql.y"
    { emit("JOIN %d", 0200); ;}
    break;

  case 57:

/* Line 936 of glr.c  */
#line 414 "glrmysql.y"
    { emit("JOIN %d", 0200); ;}
    break;

  case 58:

/* Line 936 of glr.c  */
#line 416 "glrmysql.y"
    { emit("JOIN %d", 0300+(((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (6))].yystate.yysemantics.yysval.intval)+(((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (6))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 59:

/* Line 936 of glr.c  */
#line 418 "glrmysql.y"
    { emit("JOIN %d", 0400+(((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 60:

/* Line 936 of glr.c  */
#line 421 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 61:

/* Line 936 of glr.c  */
#line 422 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 62:

/* Line 936 of glr.c  */
#line 423 "glrmysql.y"
    { ((*yyvalp).intval) = 2; ;}
    break;

  case 63:

/* Line 936 of glr.c  */
#line 426 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 64:

/* Line 936 of glr.c  */
#line 427 "glrmysql.y"
    {((*yyvalp).intval) = 4; ;}
    break;

  case 65:

/* Line 936 of glr.c  */
#line 430 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 66:

/* Line 936 of glr.c  */
#line 431 "glrmysql.y"
    { ((*yyvalp).intval) = 2; ;}
    break;

  case 67:

/* Line 936 of glr.c  */
#line 434 "glrmysql.y"
    { ((*yyvalp).intval) = 1 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (2))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 68:

/* Line 936 of glr.c  */
#line 435 "glrmysql.y"
    { ((*yyvalp).intval) = 2 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (2))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 69:

/* Line 936 of glr.c  */
#line 436 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 72:

/* Line 936 of glr.c  */
#line 442 "glrmysql.y"
    { emit("ONEXPR"); ;}
    break;

  case 73:

/* Line 936 of glr.c  */
#line 443 "glrmysql.y"
    { emit("USING %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 74:

/* Line 936 of glr.c  */
#line 448 "glrmysql.y"
    { emit("INDEXHINT %d %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (6))].yystate.yysemantics.yysval.intval), 010+(((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (6))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 75:

/* Line 936 of glr.c  */
#line 450 "glrmysql.y"
    { emit("INDEXHINT %d %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (6))].yystate.yysemantics.yysval.intval), 020+(((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (6))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 76:

/* Line 936 of glr.c  */
#line 452 "glrmysql.y"
    { emit("INDEXHINT %d %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (6))].yystate.yysemantics.yysval.intval), 030+(((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (6))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 78:

/* Line 936 of glr.c  */
#line 456 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 79:

/* Line 936 of glr.c  */
#line 457 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 80:

/* Line 936 of glr.c  */
#line 460 "glrmysql.y"
    { emit("INDEX %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 81:

/* Line 936 of glr.c  */
#line 461 "glrmysql.y"
    { emit("INDEX %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 82:

/* Line 936 of glr.c  */
#line 464 "glrmysql.y"
    { emit("SUBQUERY"); ;}
    break;

  case 83:

/* Line 936 of glr.c  */
#line 469 "glrmysql.y"
    { emit("STMT"); ;}
    break;

  case 84:

/* Line 936 of glr.c  */
#line 474 "glrmysql.y"
    { emit("DELETEONE %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (7))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 85:

/* Line 936 of glr.c  */
#line 477 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) + 01; ;}
    break;

  case 86:

/* Line 936 of glr.c  */
#line 478 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) + 02; ;}
    break;

  case 87:

/* Line 936 of glr.c  */
#line 479 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) + 04; ;}
    break;

  case 88:

/* Line 936 of glr.c  */
#line 480 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 89:

/* Line 936 of glr.c  */
#line 486 "glrmysql.y"
    { emit("DELETEMULTI %d %d %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (6))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (6))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (6))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 90:

/* Line 936 of glr.c  */
#line 488 "glrmysql.y"
    { emit("TABLE %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 91:

/* Line 936 of glr.c  */
#line 490 "glrmysql.y"
    { emit("TABLE %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (4))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 94:

/* Line 936 of glr.c  */
#line 498 "glrmysql.y"
    { emit("DELETEMULTI %d %d %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (7))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((6) - (7))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 95:

/* Line 936 of glr.c  */
#line 503 "glrmysql.y"
    { emit("STMT"); ;}
    break;

  case 96:

/* Line 936 of glr.c  */
#line 509 "glrmysql.y"
    { emit("INSERTVALS %d %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((7) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (8))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (8))].yystate.yysemantics.yysval.strval)) ;}
    break;

  case 98:

/* Line 936 of glr.c  */
#line 513 "glrmysql.y"
    { emit("DUPUPDATE %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (5))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 99:

/* Line 936 of glr.c  */
#line 516 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 100:

/* Line 936 of glr.c  */
#line 517 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 01 ; ;}
    break;

  case 101:

/* Line 936 of glr.c  */
#line 518 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 02 ; ;}
    break;

  case 102:

/* Line 936 of glr.c  */
#line 519 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 04 ; ;}
    break;

  case 103:

/* Line 936 of glr.c  */
#line 520 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 010 ; ;}
    break;

  case 107:

/* Line 936 of glr.c  */
#line 527 "glrmysql.y"
    { emit("INSERTCOLS %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 108:

/* Line 936 of glr.c  */
#line 530 "glrmysql.y"
    { emit("VALUES %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 109:

/* Line 936 of glr.c  */
#line 531 "glrmysql.y"
    { emit("VALUES %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.intval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 110:

/* Line 936 of glr.c  */
#line 534 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 111:

/* Line 936 of glr.c  */
#line 535 "glrmysql.y"
    { emit("DEFAULT"); ((*yyvalp).intval) = 1; ;}
    break;

  case 112:

/* Line 936 of glr.c  */
#line 536 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 113:

/* Line 936 of glr.c  */
#line 537 "glrmysql.y"
    { emit("DEFAULT"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 114:

/* Line 936 of glr.c  */
#line 543 "glrmysql.y"
    { emit("INSERTASGN %d %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (7))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((6) - (7))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.strval)) ;}
    break;

  case 115:

/* Line 936 of glr.c  */
#line 548 "glrmysql.y"
    { emit("INSERTSELECT %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (7))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 116:

/* Line 936 of glr.c  */
#line 553 "glrmysql.y"
    { if ((((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.subtok) != 4) yyerror("bad insert assignment to %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval));
       emit("ASSIGN %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 117:

/* Line 936 of glr.c  */
#line 556 "glrmysql.y"
    { if ((((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.subtok) != 4) yyerror("bad insert assignment to %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval));
                 emit("DEFAULT"); emit("ASSIGN %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 118:

/* Line 936 of glr.c  */
#line 559 "glrmysql.y"
    { if ((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.subtok) != 4) yyerror("bad insert assignment to %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.intval));
                 emit("ASSIGN %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 119:

/* Line 936 of glr.c  */
#line 562 "glrmysql.y"
    { if ((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.subtok) != 4) yyerror("bad insert assignment to %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.intval));
                 emit("DEFAULT"); emit("ASSIGN %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 120:

/* Line 936 of glr.c  */
#line 567 "glrmysql.y"
    { emit("STMT"); ;}
    break;

  case 121:

/* Line 936 of glr.c  */
#line 573 "glrmysql.y"
    { emit("REPLACEVALS %d %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((7) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (8))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (8))].yystate.yysemantics.yysval.strval)) ;}
    break;

  case 122:

/* Line 936 of glr.c  */
#line 579 "glrmysql.y"
    { emit("REPLACEASGN %d %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (7))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((6) - (7))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.strval)) ;}
    break;

  case 123:

/* Line 936 of glr.c  */
#line 584 "glrmysql.y"
    { emit("REPLACESELECT %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (7))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (7))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 124:

/* Line 936 of glr.c  */
#line 588 "glrmysql.y"
    { emit("STMT"); ;}
    break;

  case 125:

/* Line 936 of glr.c  */
#line 595 "glrmysql.y"
    { emit("UPDATE %d %d %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (8))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 126:

/* Line 936 of glr.c  */
#line 598 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 127:

/* Line 936 of glr.c  */
#line 599 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 01 ; ;}
    break;

  case 128:

/* Line 936 of glr.c  */
#line 600 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 010 ; ;}
    break;

  case 129:

/* Line 936 of glr.c  */
#line 605 "glrmysql.y"
    { if ((((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.subtok) != 4) yyerror("bad insert assignment to %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval));
	 emit("ASSIGN %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 130:

/* Line 936 of glr.c  */
#line 608 "glrmysql.y"
    { if ((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.subtok) != 4) yyerror("bad insert assignment to %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.strval));
	 emit("ASSIGN %s.%s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.strval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 131:

/* Line 936 of glr.c  */
#line 611 "glrmysql.y"
    { if ((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.subtok) != 4) yyerror("bad insert assignment to %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval));
	 emit("ASSIGN %s.%s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 132:

/* Line 936 of glr.c  */
#line 614 "glrmysql.y"
    { if ((((yyGLRStackItem const *)yyvsp)[YYFILL ((6) - (7))].yystate.yysemantics.yysval.subtok) != 4) yyerror("bad insert assignment to %s.$s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (7))].yystate.yysemantics.yysval.strval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (7))].yystate.yysemantics.yysval.strval));
	 emit("ASSIGN %s.%s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (7))].yystate.yysemantics.yysval.strval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (7))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (7))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (7))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 133:

/* Line 936 of glr.c  */
#line 621 "glrmysql.y"
    { emit("STMT"); ;}
    break;

  case 134:

/* Line 936 of glr.c  */
#line 625 "glrmysql.y"
    { emit("CREATEDATABASE %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (4))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (4))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 135:

/* Line 936 of glr.c  */
#line 626 "glrmysql.y"
    { emit("CREATEDATABASE %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (4))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (4))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 136:

/* Line 936 of glr.c  */
#line 629 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 137:

/* Line 936 of glr.c  */
#line 630 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 138:

/* Line 936 of glr.c  */
#line 634 "glrmysql.y"
    { emit("STMT"); ;}
    break;

  case 139:

/* Line 936 of glr.c  */
#line 638 "glrmysql.y"
    { emit("CREATE %d %d %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((7) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (8))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (8))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 140:

/* Line 936 of glr.c  */
#line 642 "glrmysql.y"
    { emit("CREATE %d %d %d %s.%s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (10))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (10))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((9) - (10))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (10))].yystate.yysemantics.yysval.strval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((7) - (10))].yystate.yysemantics.yysval.strval));
                          free((((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (10))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((7) - (10))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 141:

/* Line 936 of glr.c  */
#line 648 "glrmysql.y"
    { emit("CREATESELECT %d %d %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (9))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (9))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((7) - (9))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (9))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (9))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 142:

/* Line 936 of glr.c  */
#line 652 "glrmysql.y"
    { emit("CREATESELECT %d %d 0 %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (6))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (6))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (6))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (6))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 143:

/* Line 936 of glr.c  */
#line 657 "glrmysql.y"
    { emit("CREATESELECT %d %d 0 %s.%s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (11))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (11))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (11))].yystate.yysemantics.yysval.strval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((7) - (11))].yystate.yysemantics.yysval.strval));
                              free((((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (11))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((7) - (11))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 144:

/* Line 936 of glr.c  */
#line 662 "glrmysql.y"
    { emit("CREATESELECT %d %d 0 %s.%s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (8))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (8))].yystate.yysemantics.yysval.strval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((7) - (8))].yystate.yysemantics.yysval.strval));
                          free((((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (8))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((7) - (8))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 145:

/* Line 936 of glr.c  */
#line 666 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 146:

/* Line 936 of glr.c  */
#line 667 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 147:

/* Line 936 of glr.c  */
#line 670 "glrmysql.y"
    { emit("STARTCOL"); ;}
    break;

  case 148:

/* Line 936 of glr.c  */
#line 671 "glrmysql.y"
    { emit("COLUMNDEF %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (4))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (4))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 149:

/* Line 936 of glr.c  */
#line 673 "glrmysql.y"
    { emit("PRIKEY %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 150:

/* Line 936 of glr.c  */
#line 674 "glrmysql.y"
    { emit("KEY %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 151:

/* Line 936 of glr.c  */
#line 675 "glrmysql.y"
    { emit("KEY %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 152:

/* Line 936 of glr.c  */
#line 676 "glrmysql.y"
    { emit("TEXTINDEX %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 153:

/* Line 936 of glr.c  */
#line 677 "glrmysql.y"
    { emit("TEXTINDEX %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 154:

/* Line 936 of glr.c  */
#line 680 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 155:

/* Line 936 of glr.c  */
#line 681 "glrmysql.y"
    { emit("ATTR NOTNULL"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 157:

/* Line 936 of glr.c  */
#line 683 "glrmysql.y"
    { emit("ATTR DEFAULT STRING %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 158:

/* Line 936 of glr.c  */
#line 684 "glrmysql.y"
    { emit("ATTR DEFAULT NUMBER %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 159:

/* Line 936 of glr.c  */
#line 685 "glrmysql.y"
    { emit("ATTR DEFAULT FLOAT %g", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.floatval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 160:

/* Line 936 of glr.c  */
#line 686 "glrmysql.y"
    { emit("ATTR DEFAULT BOOL %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 161:

/* Line 936 of glr.c  */
#line 687 "glrmysql.y"
    { emit("ATTR AUTOINC"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 162:

/* Line 936 of glr.c  */
#line 688 "glrmysql.y"
    { emit("ATTR UNIQUEKEY %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.intval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 163:

/* Line 936 of glr.c  */
#line 689 "glrmysql.y"
    { emit("ATTR UNIQUEKEY"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 164:

/* Line 936 of glr.c  */
#line 690 "glrmysql.y"
    { emit("ATTR PRIKEY"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 165:

/* Line 936 of glr.c  */
#line 691 "glrmysql.y"
    { emit("ATTR PRIKEY"); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 166:

/* Line 936 of glr.c  */
#line 692 "glrmysql.y"
    { emit("ATTR COMMENT %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 167:

/* Line 936 of glr.c  */
#line 695 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 168:

/* Line 936 of glr.c  */
#line 696 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 169:

/* Line 936 of glr.c  */
#line 697 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (5))].yystate.yysemantics.yysval.intval) + 1000*(((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 170:

/* Line 936 of glr.c  */
#line 700 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 171:

/* Line 936 of glr.c  */
#line 701 "glrmysql.y"
    { ((*yyvalp).intval) = 4000; ;}
    break;

  case 172:

/* Line 936 of glr.c  */
#line 704 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 173:

/* Line 936 of glr.c  */
#line 705 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 1000; ;}
    break;

  case 174:

/* Line 936 of glr.c  */
#line 706 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (2))].yystate.yysemantics.yysval.intval) | 2000; ;}
    break;

  case 176:

/* Line 936 of glr.c  */
#line 710 "glrmysql.y"
    { emit("COLCHARSET %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (4))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (4))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 177:

/* Line 936 of glr.c  */
#line 711 "glrmysql.y"
    { emit("COLCOLLATE %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 178:

/* Line 936 of glr.c  */
#line 715 "glrmysql.y"
    { ((*yyvalp).intval) = 10000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (2))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 179:

/* Line 936 of glr.c  */
#line 716 "glrmysql.y"
    { ((*yyvalp).intval) = 10000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 180:

/* Line 936 of glr.c  */
#line 717 "glrmysql.y"
    { ((*yyvalp).intval) = 20000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval) + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 181:

/* Line 936 of glr.c  */
#line 718 "glrmysql.y"
    { ((*yyvalp).intval) = 30000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval) + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 182:

/* Line 936 of glr.c  */
#line 719 "glrmysql.y"
    { ((*yyvalp).intval) = 40000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval) + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 183:

/* Line 936 of glr.c  */
#line 720 "glrmysql.y"
    { ((*yyvalp).intval) = 50000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval) + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 184:

/* Line 936 of glr.c  */
#line 721 "glrmysql.y"
    { ((*yyvalp).intval) = 60000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval) + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 185:

/* Line 936 of glr.c  */
#line 722 "glrmysql.y"
    { ((*yyvalp).intval) = 70000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval) + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 186:

/* Line 936 of glr.c  */
#line 723 "glrmysql.y"
    { ((*yyvalp).intval) = 80000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval) + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 187:

/* Line 936 of glr.c  */
#line 724 "glrmysql.y"
    { ((*yyvalp).intval) = 90000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval) + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 188:

/* Line 936 of glr.c  */
#line 725 "glrmysql.y"
    { ((*yyvalp).intval) = 110000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval) + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 189:

/* Line 936 of glr.c  */
#line 726 "glrmysql.y"
    { ((*yyvalp).intval) = 100001; ;}
    break;

  case 190:

/* Line 936 of glr.c  */
#line 727 "glrmysql.y"
    { ((*yyvalp).intval) = 100002; ;}
    break;

  case 191:

/* Line 936 of glr.c  */
#line 728 "glrmysql.y"
    { ((*yyvalp).intval) = 100003; ;}
    break;

  case 192:

/* Line 936 of glr.c  */
#line 729 "glrmysql.y"
    { ((*yyvalp).intval) = 100004; ;}
    break;

  case 193:

/* Line 936 of glr.c  */
#line 730 "glrmysql.y"
    { ((*yyvalp).intval) = 100005; ;}
    break;

  case 194:

/* Line 936 of glr.c  */
#line 731 "glrmysql.y"
    { ((*yyvalp).intval) = 120000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 195:

/* Line 936 of glr.c  */
#line 732 "glrmysql.y"
    { ((*yyvalp).intval) = 130000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 196:

/* Line 936 of glr.c  */
#line 733 "glrmysql.y"
    { ((*yyvalp).intval) = 140000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (2))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 197:

/* Line 936 of glr.c  */
#line 734 "glrmysql.y"
    { ((*yyvalp).intval) = 150000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 198:

/* Line 936 of glr.c  */
#line 735 "glrmysql.y"
    { ((*yyvalp).intval) = 160001; ;}
    break;

  case 199:

/* Line 936 of glr.c  */
#line 736 "glrmysql.y"
    { ((*yyvalp).intval) = 160002; ;}
    break;

  case 200:

/* Line 936 of glr.c  */
#line 737 "glrmysql.y"
    { ((*yyvalp).intval) = 160003; ;}
    break;

  case 201:

/* Line 936 of glr.c  */
#line 738 "glrmysql.y"
    { ((*yyvalp).intval) = 160004; ;}
    break;

  case 202:

/* Line 936 of glr.c  */
#line 739 "glrmysql.y"
    { ((*yyvalp).intval) = 170000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 203:

/* Line 936 of glr.c  */
#line 740 "glrmysql.y"
    { ((*yyvalp).intval) = 171000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 204:

/* Line 936 of glr.c  */
#line 741 "glrmysql.y"
    { ((*yyvalp).intval) = 172000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 205:

/* Line 936 of glr.c  */
#line 742 "glrmysql.y"
    { ((*yyvalp).intval) = 173000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 206:

/* Line 936 of glr.c  */
#line 743 "glrmysql.y"
    { ((*yyvalp).intval) = 200000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 207:

/* Line 936 of glr.c  */
#line 744 "glrmysql.y"
    { ((*yyvalp).intval) = 210000 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (5))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 208:

/* Line 936 of glr.c  */
#line 747 "glrmysql.y"
    { emit("ENUMVAL %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = 1; ;}
    break;

  case 209:

/* Line 936 of glr.c  */
#line 748 "glrmysql.y"
    { emit("ENUMVAL %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval) + 1; ;}
    break;

  case 210:

/* Line 936 of glr.c  */
#line 751 "glrmysql.y"
    { emit("CREATESELECT %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.intval)) ;}
    break;

  case 211:

/* Line 936 of glr.c  */
#line 754 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 212:

/* Line 936 of glr.c  */
#line 755 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 213:

/* Line 936 of glr.c  */
#line 756 "glrmysql.y"
    { ((*yyvalp).intval) = 2; ;}
    break;

  case 214:

/* Line 936 of glr.c  */
#line 759 "glrmysql.y"
    { ((*yyvalp).intval) = 0; ;}
    break;

  case 215:

/* Line 936 of glr.c  */
#line 760 "glrmysql.y"
    { ((*yyvalp).intval) = 1;;}
    break;

  case 216:

/* Line 936 of glr.c  */
#line 765 "glrmysql.y"
    { emit("STMT"); ;}
    break;

  case 220:

/* Line 936 of glr.c  */
#line 773 "glrmysql.y"
    { if ((((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.subtok) != 4) yyerror("bad set to @%s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval));
		 emit("SET %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 221:

/* Line 936 of glr.c  */
#line 775 "glrmysql.y"
    { emit("SET %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 222:

/* Line 936 of glr.c  */
#line 780 "glrmysql.y"
    { emit("NAME %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 223:

/* Line 936 of glr.c  */
#line 781 "glrmysql.y"
    { emit("USERVAR %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 224:

/* Line 936 of glr.c  */
#line 782 "glrmysql.y"
    { emit("FIELDNAME %s.%s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 225:

/* Line 936 of glr.c  */
#line 783 "glrmysql.y"
    { emit("STRING %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 226:

/* Line 936 of glr.c  */
#line 784 "glrmysql.y"
    { emit("NUMBER %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 227:

/* Line 936 of glr.c  */
#line 785 "glrmysql.y"
    { emit("FLOAT %g", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.floatval)); ;}
    break;

  case 228:

/* Line 936 of glr.c  */
#line 786 "glrmysql.y"
    { emit("BOOL %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (1))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 229:

/* Line 936 of glr.c  */
#line 789 "glrmysql.y"
    { emit("ADD"); ;}
    break;

  case 230:

/* Line 936 of glr.c  */
#line 790 "glrmysql.y"
    { emit("SUB"); ;}
    break;

  case 231:

/* Line 936 of glr.c  */
#line 791 "glrmysql.y"
    { emit("MUL"); ;}
    break;

  case 232:

/* Line 936 of glr.c  */
#line 792 "glrmysql.y"
    { emit("DIV"); ;}
    break;

  case 233:

/* Line 936 of glr.c  */
#line 793 "glrmysql.y"
    { emit("MOD"); ;}
    break;

  case 234:

/* Line 936 of glr.c  */
#line 794 "glrmysql.y"
    { emit("MOD"); ;}
    break;

  case 235:

/* Line 936 of glr.c  */
#line 795 "glrmysql.y"
    { emit("NEG"); ;}
    break;

  case 236:

/* Line 936 of glr.c  */
#line 796 "glrmysql.y"
    { emit("AND"); ;}
    break;

  case 237:

/* Line 936 of glr.c  */
#line 797 "glrmysql.y"
    { emit("OR"); ;}
    break;

  case 238:

/* Line 936 of glr.c  */
#line 798 "glrmysql.y"
    { emit("XOR"); ;}
    break;

  case 239:

/* Line 936 of glr.c  */
#line 799 "glrmysql.y"
    { emit("CMP %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.subtok)); ;}
    break;

  case 240:

/* Line 936 of glr.c  */
#line 800 "glrmysql.y"
    { emit("CMPSELECT %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (5))].yystate.yysemantics.yysval.subtok)); ;}
    break;

  case 241:

/* Line 936 of glr.c  */
#line 801 "glrmysql.y"
    { emit("CMPANYSELECT %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (6))].yystate.yysemantics.yysval.subtok)); ;}
    break;

  case 242:

/* Line 936 of glr.c  */
#line 802 "glrmysql.y"
    { emit("CMPANYSELECT %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (6))].yystate.yysemantics.yysval.subtok)); ;}
    break;

  case 243:

/* Line 936 of glr.c  */
#line 803 "glrmysql.y"
    { emit("CMPALLSELECT %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (6))].yystate.yysemantics.yysval.subtok)); ;}
    break;

  case 244:

/* Line 936 of glr.c  */
#line 804 "glrmysql.y"
    { emit("BITOR"); ;}
    break;

  case 245:

/* Line 936 of glr.c  */
#line 805 "glrmysql.y"
    { emit("BITAND"); ;}
    break;

  case 246:

/* Line 936 of glr.c  */
#line 806 "glrmysql.y"
    { emit("BITXOR"); ;}
    break;

  case 247:

/* Line 936 of glr.c  */
#line 807 "glrmysql.y"
    { emit("SHIFT %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.subtok)==1?"left":"right"); ;}
    break;

  case 248:

/* Line 936 of glr.c  */
#line 808 "glrmysql.y"
    { emit("NOT"); ;}
    break;

  case 249:

/* Line 936 of glr.c  */
#line 809 "glrmysql.y"
    { emit("NOT"); ;}
    break;

  case 250:

/* Line 936 of glr.c  */
#line 810 "glrmysql.y"
    { emit("ASSIGN @%s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (3))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 251:

/* Line 936 of glr.c  */
#line 813 "glrmysql.y"
    { emit("ISNULL"); ;}
    break;

  case 252:

/* Line 936 of glr.c  */
#line 814 "glrmysql.y"
    { emit("ISNULL"); emit("NOT"); ;}
    break;

  case 253:

/* Line 936 of glr.c  */
#line 815 "glrmysql.y"
    { emit("ISBOOL %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 254:

/* Line 936 of glr.c  */
#line 816 "glrmysql.y"
    { emit("ISBOOL %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (4))].yystate.yysemantics.yysval.intval)); emit("NOT"); ;}
    break;

  case 255:

/* Line 936 of glr.c  */
#line 819 "glrmysql.y"
    { emit("BETWEEN"); ;}
    break;

  case 256:

/* Line 936 of glr.c  */
#line 823 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 257:

/* Line 936 of glr.c  */
#line 824 "glrmysql.y"
    { ((*yyvalp).intval) = 1 + (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (3))].yystate.yysemantics.yysval.intval); ;}
    break;

  case 258:

/* Line 936 of glr.c  */
#line 827 "glrmysql.y"
    { ((*yyvalp).intval) = 0 ;}
    break;

  case 260:

/* Line 936 of glr.c  */
#line 831 "glrmysql.y"
    { emit("ISIN %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((4) - (5))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 261:

/* Line 936 of glr.c  */
#line 832 "glrmysql.y"
    { emit("ISIN %d", (((yyGLRStackItem const *)yyvsp)[YYFILL ((5) - (6))].yystate.yysemantics.yysval.intval)); emit("NOT"); ;}
    break;

  case 262:

/* Line 936 of glr.c  */
#line 833 "glrmysql.y"
    { emit("INSELECT"); ;}
    break;

  case 263:

/* Line 936 of glr.c  */
#line 834 "glrmysql.y"
    { emit("INSELECT"); emit("NOT"); ;}
    break;

  case 264:

/* Line 936 of glr.c  */
#line 835 "glrmysql.y"
    { emit("EXISTS 1"); ;}
    break;

  case 265:

/* Line 936 of glr.c  */
#line 836 "glrmysql.y"
    { emit("EXISTS 0"); ;}
    break;

  case 266:

/* Line 936 of glr.c  */
#line 839 "glrmysql.y"
    {  emit("CALL %d %s", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval), (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (4))].yystate.yysemantics.yysval.strval)); free((((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (4))].yystate.yysemantics.yysval.strval)); ;}
    break;

  case 267:

/* Line 936 of glr.c  */
#line 843 "glrmysql.y"
    { emit("COUNTALL") ;}
    break;

  case 268:

/* Line 936 of glr.c  */
#line 844 "glrmysql.y"
    { emit(" CALL 1 COUNT"); ;}
    break;

  case 269:

/* Line 936 of glr.c  */
#line 846 "glrmysql.y"
    {  emit("CALL %d SUBSTR", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval));;}
    break;

  case 270:

/* Line 936 of glr.c  */
#line 847 "glrmysql.y"
    {  emit("CALL 2 SUBSTR"); ;}
    break;

  case 271:

/* Line 936 of glr.c  */
#line 848 "glrmysql.y"
    {  emit("CALL 3 SUBSTR"); ;}
    break;

  case 272:

/* Line 936 of glr.c  */
#line 849 "glrmysql.y"
    { emit("CALL %d TRIM", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 273:

/* Line 936 of glr.c  */
#line 850 "glrmysql.y"
    { emit("CALL 3 TRIM"); ;}
    break;

  case 274:

/* Line 936 of glr.c  */
#line 853 "glrmysql.y"
    { emit("INT 1"); ;}
    break;

  case 275:

/* Line 936 of glr.c  */
#line 854 "glrmysql.y"
    { emit("INT 2"); ;}
    break;

  case 276:

/* Line 936 of glr.c  */
#line 855 "glrmysql.y"
    { emit("INT 3"); ;}
    break;

  case 277:

/* Line 936 of glr.c  */
#line 858 "glrmysql.y"
    { emit("CALL 3 DATE_ADD"); ;}
    break;

  case 278:

/* Line 936 of glr.c  */
#line 859 "glrmysql.y"
    { emit("CALL 3 DATE_SUB"); ;}
    break;

  case 279:

/* Line 936 of glr.c  */
#line 862 "glrmysql.y"
    { emit("NUMBER 1"); ;}
    break;

  case 280:

/* Line 936 of glr.c  */
#line 863 "glrmysql.y"
    { emit("NUMBER 2"); ;}
    break;

  case 281:

/* Line 936 of glr.c  */
#line 864 "glrmysql.y"
    { emit("NUMBER 3"); ;}
    break;

  case 282:

/* Line 936 of glr.c  */
#line 865 "glrmysql.y"
    { emit("NUMBER 4"); ;}
    break;

  case 283:

/* Line 936 of glr.c  */
#line 866 "glrmysql.y"
    { emit("NUMBER 5"); ;}
    break;

  case 284:

/* Line 936 of glr.c  */
#line 867 "glrmysql.y"
    { emit("NUMBER 6"); ;}
    break;

  case 285:

/* Line 936 of glr.c  */
#line 868 "glrmysql.y"
    { emit("NUMBER 7"); ;}
    break;

  case 286:

/* Line 936 of glr.c  */
#line 869 "glrmysql.y"
    { emit("NUMBER 8"); ;}
    break;

  case 287:

/* Line 936 of glr.c  */
#line 870 "glrmysql.y"
    { emit("NUMBER 9"); ;}
    break;

  case 288:

/* Line 936 of glr.c  */
#line 873 "glrmysql.y"
    { emit("CASEVAL %d 0", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (4))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 289:

/* Line 936 of glr.c  */
#line 874 "glrmysql.y"
    { emit("CASEVAL %d 1", (((yyGLRStackItem const *)yyvsp)[YYFILL ((3) - (6))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 290:

/* Line 936 of glr.c  */
#line 875 "glrmysql.y"
    { emit("CASE %d 0", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (3))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 291:

/* Line 936 of glr.c  */
#line 876 "glrmysql.y"
    { emit("CASE %d 1", (((yyGLRStackItem const *)yyvsp)[YYFILL ((2) - (5))].yystate.yysemantics.yysval.intval)); ;}
    break;

  case 292:

/* Line 936 of glr.c  */
#line 879 "glrmysql.y"
    { ((*yyvalp).intval) = 1; ;}
    break;

  case 293:

/* Line 936 of glr.c  */
#line 880 "glrmysql.y"
    { ((*yyvalp).intval) = (((yyGLRStackItem const *)yyvsp)[YYFILL ((1) - (5))].yystate.yysemantics.yysval.intval)+1; ;}
    break;

  case 294:

/* Line 936 of glr.c  */
#line 883 "glrmysql.y"
    { emit("LIKE"); ;}
    break;

  case 295:

/* Line 936 of glr.c  */
#line 884 "glrmysql.y"
    { emit("LIKE"); emit("NOT"); ;}
    break;

  case 296:

/* Line 936 of glr.c  */
#line 887 "glrmysql.y"
    { emit("REGEXP"); ;}
    break;

  case 297:

/* Line 936 of glr.c  */
#line 888 "glrmysql.y"
    { emit("REGEXP"); emit("NOT"); ;}
    break;

  case 298:

/* Line 936 of glr.c  */
#line 891 "glrmysql.y"
    { emit("NOW") ;}
    break;

  case 299:

/* Line 936 of glr.c  */
#line 892 "glrmysql.y"
    { emit("NOW") ;}
    break;

  case 300:

/* Line 936 of glr.c  */
#line 893 "glrmysql.y"
    { emit("NOW") ;}
    break;

  case 301:

/* Line 936 of glr.c  */
#line 896 "glrmysql.y"
    { emit("STRTOBIN"); ;}
    break;



/* Line 936 of glr.c  */
#line 3817 "glrmysql.tab.c"
      default: break;
    }

  return yyok;
# undef yyerrok
# undef YYABORT
# undef YYACCEPT
# undef YYERROR
# undef YYBACKUP
# undef yyclearin
# undef YYRECOVERING
}


/*ARGSUSED*/ static void
yyuserMerge (int yyn, YYSTYPE* yy0, YYSTYPE* yy1)
{
  YYUSE (yy0);
  YYUSE (yy1);

  switch (yyn)
    {
      
      default: break;
    }
}

			      /* Bison grammar-table manipulation.  */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/** Number of symbols composing the right hand side of rule #RULE.  */
static inline int
yyrhsLength (yyRuleNum yyrule)
{
  return yyr2[yyrule];
}

static void
yydestroyGLRState (char const *yymsg, yyGLRState *yys)
{
  if (yys->yyresolved)
    yydestruct (yymsg, yystos[yys->yylrState],
		&yys->yysemantics.yysval);
  else
    {
#if YYDEBUG
      if (yydebug)
	{
	  if (yys->yysemantics.yyfirstVal)
	    YYFPRINTF (stderr, "%s unresolved ", yymsg);
	  else
	    YYFPRINTF (stderr, "%s incomplete ", yymsg);
	  yy_symbol_print (stderr, yystos[yys->yylrState],
			   NULL);
	  YYFPRINTF (stderr, "\n");
	}
#endif

      if (yys->yysemantics.yyfirstVal)
	{
	  yySemanticOption *yyoption = yys->yysemantics.yyfirstVal;
	  yyGLRState *yyrh;
	  int yyn;
	  for (yyrh = yyoption->yystate, yyn = yyrhsLength (yyoption->yyrule);
	       yyn > 0;
	       yyrh = yyrh->yypred, yyn -= 1)
	    yydestroyGLRState (yymsg, yyrh);
	}
    }
}

/** Left-hand-side symbol for rule #RULE.  */
static inline yySymbol
yylhsNonterm (yyRuleNum yyrule)
{
  return yyr1[yyrule];
}

#define yyis_pact_ninf(yystate) \
  ((yystate) == YYPACT_NINF)

/** True iff LR state STATE has only a default reduction (regardless
 *  of token).  */
static inline yybool
yyisDefaultedState (yyStateNum yystate)
{
  return yyis_pact_ninf (yypact[yystate]);
}

/** The default reduction for STATE, assuming it has one.  */
static inline yyRuleNum
yydefaultAction (yyStateNum yystate)
{
  return yydefact[yystate];
}

#define yyis_table_ninf(yytable_value) \
  ((yytable_value) == YYTABLE_NINF)

/** Set *YYACTION to the action to take in YYSTATE on seeing YYTOKEN.
 *  Result R means
 *    R < 0:  Reduce on rule -R.
 *    R = 0:  Error.
 *    R > 0:  Shift to state R.
 *  Set *CONFLICTS to a pointer into yyconfl to 0-terminated list of
 *  conflicting reductions.
 */
static inline void
yygetLRActions (yyStateNum yystate, int yytoken,
		int* yyaction, const short int** yyconflicts)
{
  int yyindex = yypact[yystate] + yytoken;
  if (yyindex < 0 || YYLAST < yyindex || yycheck[yyindex] != yytoken)
    {
      *yyaction = -yydefact[yystate];
      *yyconflicts = yyconfl;
    }
  else if (! yyis_table_ninf (yytable[yyindex]))
    {
      *yyaction = yytable[yyindex];
      *yyconflicts = yyconfl + yyconflp[yyindex];
    }
  else
    {
      *yyaction = 0;
      *yyconflicts = yyconfl + yyconflp[yyindex];
    }
}

static inline yyStateNum
yyLRgotoState (yyStateNum yystate, yySymbol yylhs)
{
  int yyr;
  yyr = yypgoto[yylhs - YYNTOKENS] + yystate;
  if (0 <= yyr && yyr <= YYLAST && yycheck[yyr] == yystate)
    return yytable[yyr];
  else
    return yydefgoto[yylhs - YYNTOKENS];
}

static inline yybool
yyisShiftAction (int yyaction)
{
  return 0 < yyaction;
}

static inline yybool
yyisErrorAction (int yyaction)
{
  return yyaction == 0;
}

				/* GLRStates */

/** Return a fresh GLRStackItem.  Callers should call
 * YY_RESERVE_GLRSTACK afterwards to make sure there is sufficient
 * headroom.  */

static inline yyGLRStackItem*
yynewGLRStackItem (yyGLRStack* yystackp, yybool yyisState)
{
  yyGLRStackItem* yynewItem = yystackp->yynextFree;
  yystackp->yyspaceLeft -= 1;
  yystackp->yynextFree += 1;
  yynewItem->yystate.yyisState = yyisState;
  return yynewItem;
}

/** Add a new semantic action that will execute the action for rule
 *  RULENUM on the semantic values in RHS to the list of
 *  alternative actions for STATE.  Assumes that RHS comes from
 *  stack #K of *STACKP. */
static void
yyaddDeferredAction (yyGLRStack* yystackp, size_t yyk, yyGLRState* yystate,
		     yyGLRState* rhs, yyRuleNum yyrule)
{
  yySemanticOption* yynewOption =
    &yynewGLRStackItem (yystackp, yyfalse)->yyoption;
  yynewOption->yystate = rhs;
  yynewOption->yyrule = yyrule;
  if (yystackp->yytops.yylookaheadNeeds[yyk])
    {
      yynewOption->yyrawchar = yychar;
      yynewOption->yyval = yylval;
      yynewOption->yyloc = yylloc;
    }
  else
    yynewOption->yyrawchar = YYEMPTY;
  yynewOption->yynext = yystate->yysemantics.yyfirstVal;
  yystate->yysemantics.yyfirstVal = yynewOption;

  YY_RESERVE_GLRSTACK (yystackp);
}

				/* GLRStacks */

/** Initialize SET to a singleton set containing an empty stack.  */
static yybool
yyinitStateSet (yyGLRStateSet* yyset)
{
  yyset->yysize = 1;
  yyset->yycapacity = 16;
  yyset->yystates = (yyGLRState**) YYMALLOC (16 * sizeof yyset->yystates[0]);
  if (! yyset->yystates)
    return yyfalse;
  yyset->yystates[0] = NULL;
  yyset->yylookaheadNeeds =
    (yybool*) YYMALLOC (16 * sizeof yyset->yylookaheadNeeds[0]);
  if (! yyset->yylookaheadNeeds)
    {
      YYFREE (yyset->yystates);
      return yyfalse;
    }
  return yytrue;
}

static void yyfreeStateSet (yyGLRStateSet* yyset)
{
  YYFREE (yyset->yystates);
  YYFREE (yyset->yylookaheadNeeds);
}

/** Initialize STACK to a single empty stack, with total maximum
 *  capacity for all stacks of SIZE.  */
static yybool
yyinitGLRStack (yyGLRStack* yystackp, size_t yysize)
{
  yystackp->yyerrState = 0;
  yynerrs = 0;
  yystackp->yyspaceLeft = yysize;
  yystackp->yyitems =
    (yyGLRStackItem*) YYMALLOC (yysize * sizeof yystackp->yynextFree[0]);
  if (!yystackp->yyitems)
    return yyfalse;
  yystackp->yynextFree = yystackp->yyitems;
  yystackp->yysplitPoint = NULL;
  yystackp->yylastDeleted = NULL;
  return yyinitStateSet (&yystackp->yytops);
}


#if YYSTACKEXPANDABLE
# define YYRELOC(YYFROMITEMS,YYTOITEMS,YYX,YYTYPE) \
  &((YYTOITEMS) - ((YYFROMITEMS) - (yyGLRStackItem*) (YYX)))->YYTYPE

/** If STACK is expandable, extend it.  WARNING: Pointers into the
    stack from outside should be considered invalid after this call.
    We always expand when there are 1 or fewer items left AFTER an
    allocation, so that we can avoid having external pointers exist
    across an allocation.  */
static void
yyexpandGLRStack (yyGLRStack* yystackp)
{
  yyGLRStackItem* yynewItems;
  yyGLRStackItem* yyp0, *yyp1;
  size_t yysize, yynewSize;
  size_t yyn;
  yysize = yystackp->yynextFree - yystackp->yyitems;
  if (YYMAXDEPTH - YYHEADROOM < yysize)
    yyMemoryExhausted (yystackp);
  yynewSize = 2*yysize;
  if (YYMAXDEPTH < yynewSize)
    yynewSize = YYMAXDEPTH;
  yynewItems = (yyGLRStackItem*) YYMALLOC (yynewSize * sizeof yynewItems[0]);
  if (! yynewItems)
    yyMemoryExhausted (yystackp);
  for (yyp0 = yystackp->yyitems, yyp1 = yynewItems, yyn = yysize;
       0 < yyn;
       yyn -= 1, yyp0 += 1, yyp1 += 1)
    {
      *yyp1 = *yyp0;
      if (*(yybool *) yyp0)
	{
	  yyGLRState* yys0 = &yyp0->yystate;
	  yyGLRState* yys1 = &yyp1->yystate;
	  if (yys0->yypred != NULL)
	    yys1->yypred =
	      YYRELOC (yyp0, yyp1, yys0->yypred, yystate);
	  if (! yys0->yyresolved && yys0->yysemantics.yyfirstVal != NULL)
	    yys1->yysemantics.yyfirstVal =
	      YYRELOC(yyp0, yyp1, yys0->yysemantics.yyfirstVal, yyoption);
	}
      else
	{
	  yySemanticOption* yyv0 = &yyp0->yyoption;
	  yySemanticOption* yyv1 = &yyp1->yyoption;
	  if (yyv0->yystate != NULL)
	    yyv1->yystate = YYRELOC (yyp0, yyp1, yyv0->yystate, yystate);
	  if (yyv0->yynext != NULL)
	    yyv1->yynext = YYRELOC (yyp0, yyp1, yyv0->yynext, yyoption);
	}
    }
  if (yystackp->yysplitPoint != NULL)
    yystackp->yysplitPoint = YYRELOC (yystackp->yyitems, yynewItems,
				 yystackp->yysplitPoint, yystate);

  for (yyn = 0; yyn < yystackp->yytops.yysize; yyn += 1)
    if (yystackp->yytops.yystates[yyn] != NULL)
      yystackp->yytops.yystates[yyn] =
	YYRELOC (yystackp->yyitems, yynewItems,
		 yystackp->yytops.yystates[yyn], yystate);
  YYFREE (yystackp->yyitems);
  yystackp->yyitems = yynewItems;
  yystackp->yynextFree = yynewItems + yysize;
  yystackp->yyspaceLeft = yynewSize - yysize;
}
#endif

static void
yyfreeGLRStack (yyGLRStack* yystackp)
{
  YYFREE (yystackp->yyitems);
  yyfreeStateSet (&yystackp->yytops);
}

/** Assuming that S is a GLRState somewhere on STACK, update the
 *  splitpoint of STACK, if needed, so that it is at least as deep as
 *  S.  */
static inline void
yyupdateSplit (yyGLRStack* yystackp, yyGLRState* yys)
{
  if (yystackp->yysplitPoint != NULL && yystackp->yysplitPoint > yys)
    yystackp->yysplitPoint = yys;
}

/** Invalidate stack #K in STACK.  */
static inline void
yymarkStackDeleted (yyGLRStack* yystackp, size_t yyk)
{
  if (yystackp->yytops.yystates[yyk] != NULL)
    yystackp->yylastDeleted = yystackp->yytops.yystates[yyk];
  yystackp->yytops.yystates[yyk] = NULL;
}

/** Undelete the last stack that was marked as deleted.  Can only be
    done once after a deletion, and only when all other stacks have
    been deleted.  */
static void
yyundeleteLastStack (yyGLRStack* yystackp)
{
  if (yystackp->yylastDeleted == NULL || yystackp->yytops.yysize != 0)
    return;
  yystackp->yytops.yystates[0] = yystackp->yylastDeleted;
  yystackp->yytops.yysize = 1;
  YYDPRINTF ((stderr, "Restoring last deleted stack as stack #0.\n"));
  yystackp->yylastDeleted = NULL;
}

static inline void
yyremoveDeletes (yyGLRStack* yystackp)
{
  size_t yyi, yyj;
  yyi = yyj = 0;
  while (yyj < yystackp->yytops.yysize)
    {
      if (yystackp->yytops.yystates[yyi] == NULL)
	{
	  if (yyi == yyj)
	    {
	      YYDPRINTF ((stderr, "Removing dead stacks.\n"));
	    }
	  yystackp->yytops.yysize -= 1;
	}
      else
	{
	  yystackp->yytops.yystates[yyj] = yystackp->yytops.yystates[yyi];
	  /* In the current implementation, it's unnecessary to copy
	     yystackp->yytops.yylookaheadNeeds[yyi] since, after
	     yyremoveDeletes returns, the parser immediately either enters
	     deterministic operation or shifts a token.  However, it doesn't
	     hurt, and the code might evolve to need it.  */
	  yystackp->yytops.yylookaheadNeeds[yyj] =
	    yystackp->yytops.yylookaheadNeeds[yyi];
	  if (yyj != yyi)
	    {
	      YYDPRINTF ((stderr, "Rename stack %lu -> %lu.\n",
			  (unsigned long int) yyi, (unsigned long int) yyj));
	    }
	  yyj += 1;
	}
      yyi += 1;
    }
}

/** Shift to a new state on stack #K of STACK, corresponding to LR state
 * LRSTATE, at input position POSN, with (resolved) semantic value SVAL.  */
static inline void
yyglrShift (yyGLRStack* yystackp, size_t yyk, yyStateNum yylrState,
	    size_t yyposn,
	    YYSTYPE* yyvalp, YYLTYPE* yylocp)
{
  yyGLRState* yynewState = &yynewGLRStackItem (yystackp, yytrue)->yystate;

  yynewState->yylrState = yylrState;
  yynewState->yyposn = yyposn;
  yynewState->yyresolved = yytrue;
  yynewState->yypred = yystackp->yytops.yystates[yyk];
  yynewState->yysemantics.yysval = *yyvalp;
  yynewState->yyloc = *yylocp;
  yystackp->yytops.yystates[yyk] = yynewState;

  YY_RESERVE_GLRSTACK (yystackp);
}

/** Shift stack #K of YYSTACK, to a new state corresponding to LR
 *  state YYLRSTATE, at input position YYPOSN, with the (unresolved)
 *  semantic value of YYRHS under the action for YYRULE.  */
static inline void
yyglrShiftDefer (yyGLRStack* yystackp, size_t yyk, yyStateNum yylrState,
		 size_t yyposn, yyGLRState* rhs, yyRuleNum yyrule)
{
  yyGLRState* yynewState = &yynewGLRStackItem (yystackp, yytrue)->yystate;

  yynewState->yylrState = yylrState;
  yynewState->yyposn = yyposn;
  yynewState->yyresolved = yyfalse;
  yynewState->yypred = yystackp->yytops.yystates[yyk];
  yynewState->yysemantics.yyfirstVal = NULL;
  yystackp->yytops.yystates[yyk] = yynewState;

  /* Invokes YY_RESERVE_GLRSTACK.  */
  yyaddDeferredAction (yystackp, yyk, yynewState, rhs, yyrule);
}

/** Pop the symbols consumed by reduction #RULE from the top of stack
 *  #K of STACK, and perform the appropriate semantic action on their
 *  semantic values.  Assumes that all ambiguities in semantic values
 *  have been previously resolved.  Set *VALP to the resulting value,
 *  and *LOCP to the computed location (if any).  Return value is as
 *  for userAction.  */
static inline YYRESULTTAG
yydoAction (yyGLRStack* yystackp, size_t yyk, yyRuleNum yyrule,
	    YYSTYPE* yyvalp, YYLTYPE* yylocp)
{
  int yynrhs = yyrhsLength (yyrule);

  if (yystackp->yysplitPoint == NULL)
    {
      /* Standard special case: single stack.  */
      yyGLRStackItem* rhs = (yyGLRStackItem*) yystackp->yytops.yystates[yyk];
      YYASSERT (yyk == 0);
      yystackp->yynextFree -= yynrhs;
      yystackp->yyspaceLeft += yynrhs;
      yystackp->yytops.yystates[0] = & yystackp->yynextFree[-1].yystate;
      return yyuserAction (yyrule, yynrhs, rhs,
			   yyvalp, yylocp, yystackp);
    }
  else
    {
      /* At present, doAction is never called in nondeterministic
       * mode, so this branch is never taken.  It is here in
       * anticipation of a future feature that will allow immediate
       * evaluation of selected actions in nondeterministic mode.  */
      int yyi;
      yyGLRState* yys;
      yyGLRStackItem yyrhsVals[YYMAXRHS + YYMAXLEFT + 1];
      yys = yyrhsVals[YYMAXRHS + YYMAXLEFT].yystate.yypred
	= yystackp->yytops.yystates[yyk];
      for (yyi = 0; yyi < yynrhs; yyi += 1)
	{
	  yys = yys->yypred;
	  YYASSERT (yys);
	}
      yyupdateSplit (yystackp, yys);
      yystackp->yytops.yystates[yyk] = yys;
      return yyuserAction (yyrule, yynrhs, yyrhsVals + YYMAXRHS + YYMAXLEFT - 1,
			   yyvalp, yylocp, yystackp);
    }
}

#if !YYDEBUG
# define YY_REDUCE_PRINT(Args)
#else
# define YY_REDUCE_PRINT(Args)		\
do {					\
  if (yydebug)				\
    yy_reduce_print Args;		\
} while (YYID (0))

/*----------------------------------------------------------.
| Report that the RULE is going to be reduced on stack #K.  |
`----------------------------------------------------------*/

/*ARGSUSED*/ static inline void
yy_reduce_print (yyGLRStack* yystackp, size_t yyk, yyRuleNum yyrule,
		 YYSTYPE* yyvalp, YYLTYPE* yylocp)
{
  int yynrhs = yyrhsLength (yyrule);
  yybool yynormal __attribute__ ((__unused__)) =
    (yystackp->yysplitPoint == NULL);
  yyGLRStackItem* yyvsp = (yyGLRStackItem*) yystackp->yytops.yystates[yyk];
  int yylow = 1;
  int yyi;
  YYUSE (yyvalp);
  YYUSE (yylocp);
  YYFPRINTF (stderr, "Reducing stack %lu by rule %d (line %lu):\n",
	     (unsigned long int) yyk, yyrule - 1,
	     (unsigned long int) yyrline[yyrule]);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(((yyGLRStackItem const *)yyvsp)[YYFILL ((yyi + 1) - (yynrhs))].yystate.yysemantics.yysval)
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}
#endif

/** Pop items off stack #K of STACK according to grammar rule RULE,
 *  and push back on the resulting nonterminal symbol.  Perform the
 *  semantic action associated with RULE and store its value with the
 *  newly pushed state, if FORCEEVAL or if STACK is currently
 *  unambiguous.  Otherwise, store the deferred semantic action with
 *  the new state.  If the new state would have an identical input
 *  position, LR state, and predecessor to an existing state on the stack,
 *  it is identified with that existing state, eliminating stack #K from
 *  the STACK.  In this case, the (necessarily deferred) semantic value is
 *  added to the options for the existing state's semantic value.
 */
static inline YYRESULTTAG
yyglrReduce (yyGLRStack* yystackp, size_t yyk, yyRuleNum yyrule,
	     yybool yyforceEval)
{
  size_t yyposn = yystackp->yytops.yystates[yyk]->yyposn;

  if (yyforceEval || yystackp->yysplitPoint == NULL)
    {
      YYSTYPE yysval;
      YYLTYPE yyloc;

      YY_REDUCE_PRINT ((yystackp, yyk, yyrule, &yysval, &yyloc));
      YYCHK (yydoAction (yystackp, yyk, yyrule, &yysval,
			 &yyloc));
      YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyrule], &yysval, &yyloc);
      yyglrShift (yystackp, yyk,
		  yyLRgotoState (yystackp->yytops.yystates[yyk]->yylrState,
				 yylhsNonterm (yyrule)),
		  yyposn, &yysval, &yyloc);
    }
  else
    {
      size_t yyi;
      int yyn;
      yyGLRState* yys, *yys0 = yystackp->yytops.yystates[yyk];
      yyStateNum yynewLRState;

      for (yys = yystackp->yytops.yystates[yyk], yyn = yyrhsLength (yyrule);
	   0 < yyn; yyn -= 1)
	{
	  yys = yys->yypred;
	  YYASSERT (yys);
	}
      yyupdateSplit (yystackp, yys);
      yynewLRState = yyLRgotoState (yys->yylrState, yylhsNonterm (yyrule));
      YYDPRINTF ((stderr,
		  "Reduced stack %lu by rule #%d; action deferred.  Now in state %d.\n",
		  (unsigned long int) yyk, yyrule - 1, yynewLRState));
      for (yyi = 0; yyi < yystackp->yytops.yysize; yyi += 1)
	if (yyi != yyk && yystackp->yytops.yystates[yyi] != NULL)
	  {
	    yyGLRState* yyp, *yysplit = yystackp->yysplitPoint;
	    yyp = yystackp->yytops.yystates[yyi];
	    while (yyp != yys && yyp != yysplit && yyp->yyposn >= yyposn)
	      {
		if (yyp->yylrState == yynewLRState && yyp->yypred == yys)
		  {
		    yyaddDeferredAction (yystackp, yyk, yyp, yys0, yyrule);
		    yymarkStackDeleted (yystackp, yyk);
		    YYDPRINTF ((stderr, "Merging stack %lu into stack %lu.\n",
				(unsigned long int) yyk,
				(unsigned long int) yyi));
		    return yyok;
		  }
		yyp = yyp->yypred;
	      }
	  }
      yystackp->yytops.yystates[yyk] = yys;
      yyglrShiftDefer (yystackp, yyk, yynewLRState, yyposn, yys0, yyrule);
    }
  return yyok;
}

static size_t
yysplitStack (yyGLRStack* yystackp, size_t yyk)
{
  if (yystackp->yysplitPoint == NULL)
    {
      YYASSERT (yyk == 0);
      yystackp->yysplitPoint = yystackp->yytops.yystates[yyk];
    }
  if (yystackp->yytops.yysize >= yystackp->yytops.yycapacity)
    {
      yyGLRState** yynewStates;
      yybool* yynewLookaheadNeeds;

      yynewStates = NULL;

      if (yystackp->yytops.yycapacity
	  > (YYSIZEMAX / (2 * sizeof yynewStates[0])))
	yyMemoryExhausted (yystackp);
      yystackp->yytops.yycapacity *= 2;

      yynewStates =
	(yyGLRState**) YYREALLOC (yystackp->yytops.yystates,
				  (yystackp->yytops.yycapacity
				   * sizeof yynewStates[0]));
      if (yynewStates == NULL)
	yyMemoryExhausted (yystackp);
      yystackp->yytops.yystates = yynewStates;

      yynewLookaheadNeeds =
	(yybool*) YYREALLOC (yystackp->yytops.yylookaheadNeeds,
			     (yystackp->yytops.yycapacity
			      * sizeof yynewLookaheadNeeds[0]));
      if (yynewLookaheadNeeds == NULL)
	yyMemoryExhausted (yystackp);
      yystackp->yytops.yylookaheadNeeds = yynewLookaheadNeeds;
    }
  yystackp->yytops.yystates[yystackp->yytops.yysize]
    = yystackp->yytops.yystates[yyk];
  yystackp->yytops.yylookaheadNeeds[yystackp->yytops.yysize]
    = yystackp->yytops.yylookaheadNeeds[yyk];
  yystackp->yytops.yysize += 1;
  return yystackp->yytops.yysize-1;
}

/** True iff Y0 and Y1 represent identical options at the top level.
 *  That is, they represent the same rule applied to RHS symbols
 *  that produce the same terminal symbols.  */
static yybool
yyidenticalOptions (yySemanticOption* yyy0, yySemanticOption* yyy1)
{
  if (yyy0->yyrule == yyy1->yyrule)
    {
      yyGLRState *yys0, *yys1;
      int yyn;
      for (yys0 = yyy0->yystate, yys1 = yyy1->yystate,
	   yyn = yyrhsLength (yyy0->yyrule);
	   yyn > 0;
	   yys0 = yys0->yypred, yys1 = yys1->yypred, yyn -= 1)
	if (yys0->yyposn != yys1->yyposn)
	  return yyfalse;
      return yytrue;
    }
  else
    return yyfalse;
}

/** Assuming identicalOptions (Y0,Y1), destructively merge the
 *  alternative semantic values for the RHS-symbols of Y1 and Y0.  */
static void
yymergeOptionSets (yySemanticOption* yyy0, yySemanticOption* yyy1)
{
  yyGLRState *yys0, *yys1;
  int yyn;
  for (yys0 = yyy0->yystate, yys1 = yyy1->yystate,
       yyn = yyrhsLength (yyy0->yyrule);
       yyn > 0;
       yys0 = yys0->yypred, yys1 = yys1->yypred, yyn -= 1)
    {
      if (yys0 == yys1)
	break;
      else if (yys0->yyresolved)
	{
	  yys1->yyresolved = yytrue;
	  yys1->yysemantics.yysval = yys0->yysemantics.yysval;
	}
      else if (yys1->yyresolved)
	{
	  yys0->yyresolved = yytrue;
	  yys0->yysemantics.yysval = yys1->yysemantics.yysval;
	}
      else
	{
	  yySemanticOption** yyz0p;
	  yySemanticOption* yyz1;
	  yyz0p = &yys0->yysemantics.yyfirstVal;
	  yyz1 = yys1->yysemantics.yyfirstVal;
	  while (YYID (yytrue))
	    {
	      if (yyz1 == *yyz0p || yyz1 == NULL)
		break;
	      else if (*yyz0p == NULL)
		{
		  *yyz0p = yyz1;
		  break;
		}
	      else if (*yyz0p < yyz1)
		{
		  yySemanticOption* yyz = *yyz0p;
		  *yyz0p = yyz1;
		  yyz1 = yyz1->yynext;
		  (*yyz0p)->yynext = yyz;
		}
	      yyz0p = &(*yyz0p)->yynext;
	    }
	  yys1->yysemantics.yyfirstVal = yys0->yysemantics.yyfirstVal;
	}
    }
}

/** Y0 and Y1 represent two possible actions to take in a given
 *  parsing state; return 0 if no combination is possible,
 *  1 if user-mergeable, 2 if Y0 is preferred, 3 if Y1 is preferred.  */
static int
yypreference (yySemanticOption* y0, yySemanticOption* y1)
{
  yyRuleNum r0 = y0->yyrule, r1 = y1->yyrule;
  int p0 = yydprec[r0], p1 = yydprec[r1];

  if (p0 == p1)
    {
      if (yymerger[r0] == 0 || yymerger[r0] != yymerger[r1])
	return 0;
      else
	return 1;
    }
  if (p0 == 0 || p1 == 0)
    return 0;
  if (p0 < p1)
    return 3;
  if (p1 < p0)
    return 2;
  return 0;
}

static YYRESULTTAG yyresolveValue (yyGLRState* yys,
				   yyGLRStack* yystackp);


/** Resolve the previous N states starting at and including state S.  If result
 *  != yyok, some states may have been left unresolved possibly with empty
 *  semantic option chains.  Regardless of whether result = yyok, each state
 *  has been left with consistent data so that yydestroyGLRState can be invoked
 *  if necessary.  */
static YYRESULTTAG
yyresolveStates (yyGLRState* yys, int yyn,
		 yyGLRStack* yystackp)
{
  if (0 < yyn)
    {
      YYASSERT (yys->yypred);
      YYCHK (yyresolveStates (yys->yypred, yyn-1, yystackp));
      if (! yys->yyresolved)
	YYCHK (yyresolveValue (yys, yystackp));
    }
  return yyok;
}

/** Resolve the states for the RHS of OPT, perform its user action, and return
 *  the semantic value and location.  Regardless of whether result = yyok, all
 *  RHS states have been destroyed (assuming the user action destroys all RHS
 *  semantic values if invoked).  */
static YYRESULTTAG
yyresolveAction (yySemanticOption* yyopt, yyGLRStack* yystackp,
		 YYSTYPE* yyvalp, YYLTYPE* yylocp)
{
  yyGLRStackItem yyrhsVals[YYMAXRHS + YYMAXLEFT + 1];
  int yynrhs;
  int yychar_current;
  YYSTYPE yylval_current;
  YYLTYPE yylloc_current;
  YYRESULTTAG yyflag;

  yynrhs = yyrhsLength (yyopt->yyrule);
  yyflag = yyresolveStates (yyopt->yystate, yynrhs, yystackp);
  if (yyflag != yyok)
    {
      yyGLRState *yys;
      for (yys = yyopt->yystate; yynrhs > 0; yys = yys->yypred, yynrhs -= 1)
	yydestroyGLRState ("Cleanup: popping", yys);
      return yyflag;
    }

  yyrhsVals[YYMAXRHS + YYMAXLEFT].yystate.yypred = yyopt->yystate;
  yychar_current = yychar;
  yylval_current = yylval;
  yylloc_current = yylloc;
  yychar = yyopt->yyrawchar;
  yylval = yyopt->yyval;
  yylloc = yyopt->yyloc;
  yyflag = yyuserAction (yyopt->yyrule, yynrhs,
			   yyrhsVals + YYMAXRHS + YYMAXLEFT - 1,
			   yyvalp, yylocp, yystackp);
  yychar = yychar_current;
  yylval = yylval_current;
  yylloc = yylloc_current;
  return yyflag;
}

#if YYDEBUG
static void
yyreportTree (yySemanticOption* yyx, int yyindent)
{
  int yynrhs = yyrhsLength (yyx->yyrule);
  int yyi;
  yyGLRState* yys;
  yyGLRState* yystates[1 + YYMAXRHS];
  yyGLRState yyleftmost_state;

  for (yyi = yynrhs, yys = yyx->yystate; 0 < yyi; yyi -= 1, yys = yys->yypred)
    yystates[yyi] = yys;
  if (yys == NULL)
    {
      yyleftmost_state.yyposn = 0;
      yystates[0] = &yyleftmost_state;
    }
  else
    yystates[0] = yys;

  if (yyx->yystate->yyposn < yys->yyposn + 1)
    YYFPRINTF (stderr, "%*s%s -> <Rule %d, empty>\n",
	       yyindent, "", yytokenName (yylhsNonterm (yyx->yyrule)),
	       yyx->yyrule - 1);
  else
    YYFPRINTF (stderr, "%*s%s -> <Rule %d, tokens %lu .. %lu>\n",
	       yyindent, "", yytokenName (yylhsNonterm (yyx->yyrule)),
	       yyx->yyrule - 1, (unsigned long int) (yys->yyposn + 1),
	       (unsigned long int) yyx->yystate->yyposn);
  for (yyi = 1; yyi <= yynrhs; yyi += 1)
    {
      if (yystates[yyi]->yyresolved)
	{
	  if (yystates[yyi-1]->yyposn+1 > yystates[yyi]->yyposn)
	    YYFPRINTF (stderr, "%*s%s <empty>\n", yyindent+2, "",
		       yytokenName (yyrhs[yyprhs[yyx->yyrule]+yyi-1]));
	  else
	    YYFPRINTF (stderr, "%*s%s <tokens %lu .. %lu>\n", yyindent+2, "",
		       yytokenName (yyrhs[yyprhs[yyx->yyrule]+yyi-1]),
		       (unsigned long int) (yystates[yyi - 1]->yyposn + 1),
		       (unsigned long int) yystates[yyi]->yyposn);
	}
      else
	yyreportTree (yystates[yyi]->yysemantics.yyfirstVal, yyindent+2);
    }
}
#endif

/*ARGSUSED*/ static YYRESULTTAG
yyreportAmbiguity (yySemanticOption* yyx0,
		   yySemanticOption* yyx1)
{
  YYUSE (yyx0);
  YYUSE (yyx1);

#if YYDEBUG
  YYFPRINTF (stderr, "Ambiguity detected.\n");
  YYFPRINTF (stderr, "Option 1,\n");
  yyreportTree (yyx0, 2);
  YYFPRINTF (stderr, "\nOption 2,\n");
  yyreportTree (yyx1, 2);
  YYFPRINTF (stderr, "\n");
#endif

  yyerror (YY_("syntax is ambiguous"));
  return yyabort;
}

/** Starting at and including state S1, resolve the location for each of the
 *  previous N1 states that is unresolved.  The first semantic option of a state
 *  is always chosen.  */
static void
yyresolveLocations (yyGLRState* yys1, int yyn1,
		    yyGLRStack *yystackp)
{
  if (0 < yyn1)
    {
      yyresolveLocations (yys1->yypred, yyn1 - 1, yystackp);
      if (!yys1->yyresolved)
	{
	  yySemanticOption *yyoption;
	  yyGLRStackItem yyrhsloc[1 + YYMAXRHS];
	  int yynrhs;
	  int yychar_current;
	  YYSTYPE yylval_current;
	  YYLTYPE yylloc_current;
	  yyoption = yys1->yysemantics.yyfirstVal;
	  YYASSERT (yyoption != NULL);
	  yynrhs = yyrhsLength (yyoption->yyrule);
	  if (yynrhs > 0)
	    {
	      yyGLRState *yys;
	      int yyn;
	      yyresolveLocations (yyoption->yystate, yynrhs,
				  yystackp);
	      for (yys = yyoption->yystate, yyn = yynrhs;
		   yyn > 0;
		   yys = yys->yypred, yyn -= 1)
		yyrhsloc[yyn].yystate.yyloc = yys->yyloc;
	    }
	  else
	    {
	      /* Both yyresolveAction and yyresolveLocations traverse the GSS
		 in reverse rightmost order.  It is only necessary to invoke
		 yyresolveLocations on a subforest for which yyresolveAction
		 would have been invoked next had an ambiguity not been
		 detected.  Thus the location of the previous state (but not
		 necessarily the previous state itself) is guaranteed to be
		 resolved already.  */
	      yyGLRState *yyprevious = yyoption->yystate;
	      yyrhsloc[0].yystate.yyloc = yyprevious->yyloc;
	    }
	  yychar_current = yychar;
	  yylval_current = yylval;
	  yylloc_current = yylloc;
	  yychar = yyoption->yyrawchar;
	  yylval = yyoption->yyval;
	  yylloc = yyoption->yyloc;
	  YYLLOC_DEFAULT ((yys1->yyloc), yyrhsloc, yynrhs);
	  yychar = yychar_current;
	  yylval = yylval_current;
	  yylloc = yylloc_current;
	}
    }
}

/** Resolve the ambiguity represented in state S, perform the indicated
 *  actions, and set the semantic value of S.  If result != yyok, the chain of
 *  semantic options in S has been cleared instead or it has been left
 *  unmodified except that redundant options may have been removed.  Regardless
 *  of whether result = yyok, S has been left with consistent data so that
 *  yydestroyGLRState can be invoked if necessary.  */
static YYRESULTTAG
yyresolveValue (yyGLRState* yys, yyGLRStack* yystackp)
{
  yySemanticOption* yyoptionList = yys->yysemantics.yyfirstVal;
  yySemanticOption* yybest;
  yySemanticOption** yypp;
  yybool yymerge;
  YYSTYPE yysval;
  YYRESULTTAG yyflag;
  YYLTYPE *yylocp = &yys->yyloc;

  yybest = yyoptionList;
  yymerge = yyfalse;
  for (yypp = &yyoptionList->yynext; *yypp != NULL; )
    {
      yySemanticOption* yyp = *yypp;

      if (yyidenticalOptions (yybest, yyp))
	{
	  yymergeOptionSets (yybest, yyp);
	  *yypp = yyp->yynext;
	}
      else
	{
	  switch (yypreference (yybest, yyp))
	    {
	    case 0:
	      yyresolveLocations (yys, 1, yystackp);
	      return yyreportAmbiguity (yybest, yyp);
	      break;
	    case 1:
	      yymerge = yytrue;
	      break;
	    case 2:
	      break;
	    case 3:
	      yybest = yyp;
	      yymerge = yyfalse;
	      break;
	    default:
	      /* This cannot happen so it is not worth a YYASSERT (yyfalse),
		 but some compilers complain if the default case is
		 omitted.  */
	      break;
	    }
	  yypp = &yyp->yynext;
	}
    }

  if (yymerge)
    {
      yySemanticOption* yyp;
      int yyprec = yydprec[yybest->yyrule];
      yyflag = yyresolveAction (yybest, yystackp, &yysval,
				yylocp);
      if (yyflag == yyok)
	for (yyp = yybest->yynext; yyp != NULL; yyp = yyp->yynext)
	  {
	    if (yyprec == yydprec[yyp->yyrule])
	      {
		YYSTYPE yysval_other;
		YYLTYPE yydummy;
		yyflag = yyresolveAction (yyp, yystackp, &yysval_other,
					  &yydummy);
		if (yyflag != yyok)
		  {
		    yydestruct ("Cleanup: discarding incompletely merged value for",
				yystos[yys->yylrState],
				&yysval);
		    break;
		  }
		yyuserMerge (yymerger[yyp->yyrule], &yysval, &yysval_other);
	      }
	  }
    }
  else
    yyflag = yyresolveAction (yybest, yystackp, &yysval, yylocp);

  if (yyflag == yyok)
    {
      yys->yyresolved = yytrue;
      yys->yysemantics.yysval = yysval;
    }
  else
    yys->yysemantics.yyfirstVal = NULL;
  return yyflag;
}

static YYRESULTTAG
yyresolveStack (yyGLRStack* yystackp)
{
  if (yystackp->yysplitPoint != NULL)
    {
      yyGLRState* yys;
      int yyn;

      for (yyn = 0, yys = yystackp->yytops.yystates[0];
	   yys != yystackp->yysplitPoint;
	   yys = yys->yypred, yyn += 1)
	continue;
      YYCHK (yyresolveStates (yystackp->yytops.yystates[0], yyn, yystackp
			     ));
    }
  return yyok;
}

static void
yycompressStack (yyGLRStack* yystackp)
{
  yyGLRState* yyp, *yyq, *yyr;

  if (yystackp->yytops.yysize != 1 || yystackp->yysplitPoint == NULL)
    return;

  for (yyp = yystackp->yytops.yystates[0], yyq = yyp->yypred, yyr = NULL;
       yyp != yystackp->yysplitPoint;
       yyr = yyp, yyp = yyq, yyq = yyp->yypred)
    yyp->yypred = yyr;

  yystackp->yyspaceLeft += yystackp->yynextFree - yystackp->yyitems;
  yystackp->yynextFree = ((yyGLRStackItem*) yystackp->yysplitPoint) + 1;
  yystackp->yyspaceLeft -= yystackp->yynextFree - yystackp->yyitems;
  yystackp->yysplitPoint = NULL;
  yystackp->yylastDeleted = NULL;

  while (yyr != NULL)
    {
      yystackp->yynextFree->yystate = *yyr;
      yyr = yyr->yypred;
      yystackp->yynextFree->yystate.yypred = &yystackp->yynextFree[-1].yystate;
      yystackp->yytops.yystates[0] = &yystackp->yynextFree->yystate;
      yystackp->yynextFree += 1;
      yystackp->yyspaceLeft -= 1;
    }
}

static YYRESULTTAG
yyprocessOneStack (yyGLRStack* yystackp, size_t yyk,
		   size_t yyposn)
{
  int yyaction;
  const short int* yyconflicts;
  yyRuleNum yyrule;

  while (yystackp->yytops.yystates[yyk] != NULL)
    {
      yyStateNum yystate = yystackp->yytops.yystates[yyk]->yylrState;
      YYDPRINTF ((stderr, "Stack %lu Entering state %d\n",
		  (unsigned long int) yyk, yystate));

      YYASSERT (yystate != YYFINAL);

      if (yyisDefaultedState (yystate))
	{
	  yyrule = yydefaultAction (yystate);
	  if (yyrule == 0)
	    {
	      YYDPRINTF ((stderr, "Stack %lu dies.\n",
			  (unsigned long int) yyk));
	      yymarkStackDeleted (yystackp, yyk);
	      return yyok;
	    }
	  YYCHK (yyglrReduce (yystackp, yyk, yyrule, yyfalse));
	}
      else
	{
	  yySymbol yytoken;
	  yystackp->yytops.yylookaheadNeeds[yyk] = yytrue;
	  if (yychar == YYEMPTY)
	    {
	      YYDPRINTF ((stderr, "Reading a token: "));
	      yychar = YYLEX;
	    }

	  if (yychar <= YYEOF)
	    {
	      yychar = yytoken = YYEOF;
	      YYDPRINTF ((stderr, "Now at end of input.\n"));
	    }
	  else
	    {
	      yytoken = YYTRANSLATE (yychar);
	      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
	    }

	  yygetLRActions (yystate, yytoken, &yyaction, &yyconflicts);

	  while (*yyconflicts != 0)
	    {
	      size_t yynewStack = yysplitStack (yystackp, yyk);
	      YYDPRINTF ((stderr, "Splitting off stack %lu from %lu.\n",
			  (unsigned long int) yynewStack,
			  (unsigned long int) yyk));
	      YYCHK (yyglrReduce (yystackp, yynewStack,
				  *yyconflicts, yyfalse));
	      YYCHK (yyprocessOneStack (yystackp, yynewStack,
					yyposn));
	      yyconflicts += 1;
	    }

	  if (yyisShiftAction (yyaction))
	    break;
	  else if (yyisErrorAction (yyaction))
	    {
	      YYDPRINTF ((stderr, "Stack %lu dies.\n",
			  (unsigned long int) yyk));
	      yymarkStackDeleted (yystackp, yyk);
	      break;
	    }
	  else
	    YYCHK (yyglrReduce (yystackp, yyk, -yyaction,
				yyfalse));
	}
    }
  return yyok;
}

/*ARGSUSED*/ static void
yyreportSyntaxError (yyGLRStack* yystackp)
{
  if (yystackp->yyerrState == 0)
    {
#if YYERROR_VERBOSE
      int yyn;
      yyn = yypact[yystackp->yytops.yystates[0]->yylrState];
      if (YYPACT_NINF < yyn && yyn <= YYLAST)
	{
	  yySymbol yytoken = YYTRANSLATE (yychar);
	  size_t yysize0 = yytnamerr (NULL, yytokenName (yytoken));
	  size_t yysize = yysize0;
	  size_t yysize1;
	  yybool yysize_overflow = yyfalse;
	  char* yymsg = NULL;
	  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
	  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
	  int yyx;
	  char *yyfmt;
	  char const *yyf;
	  static char const yyunexpected[] = "syntax error, unexpected %s";
	  static char const yyexpecting[] = ", expecting %s";
	  static char const yyor[] = " or %s";
	  char yyformat[sizeof yyunexpected
			+ sizeof yyexpecting - 1
			+ ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
			   * (sizeof yyor - 1))];
	  char const *yyprefix = yyexpecting;

	  /* Start YYX at -YYN if negative to avoid negative indexes in
	     YYCHECK.  */
	  int yyxbegin = yyn < 0 ? -yyn : 0;

	  /* Stay within bounds of both yycheck and yytname.  */
	  int yychecklim = YYLAST - yyn + 1;
	  int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
	  int yycount = 1;

	  yyarg[0] = yytokenName (yytoken);
	  yyfmt = yystpcpy (yyformat, yyunexpected);

	  for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	      {
		if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
		  {
		    yycount = 1;
		    yysize = yysize0;
		    yyformat[sizeof yyunexpected - 1] = '\0';
		    break;
		  }
		yyarg[yycount++] = yytokenName (yyx);
		yysize1 = yysize + yytnamerr (NULL, yytokenName (yyx));
		yysize_overflow |= yysize1 < yysize;
		yysize = yysize1;
		yyfmt = yystpcpy (yyfmt, yyprefix);
		yyprefix = yyor;
	      }

	  yyf = YY_(yyformat);
	  yysize1 = yysize + strlen (yyf);
	  yysize_overflow |= yysize1 < yysize;
	  yysize = yysize1;

	  if (!yysize_overflow)
	    yymsg = (char *) YYMALLOC (yysize);

	  if (yymsg)
	    {
	      char *yyp = yymsg;
	      int yyi = 0;
	      while ((*yyp = *yyf))
		{
		  if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		    {
		      yyp += yytnamerr (yyp, yyarg[yyi++]);
		      yyf += 2;
		    }
		  else
		    {
		      yyp++;
		      yyf++;
		    }
		}
	      yyerror (yymsg);
	      YYFREE (yymsg);
	    }
	  else
	    {
	      yyerror (YY_("syntax error"));
	      yyMemoryExhausted (yystackp);
	    }
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror (YY_("syntax error"));
      yynerrs += 1;
    }
}

/* Recover from a syntax error on *YYSTACKP, assuming that *YYSTACKP->YYTOKENP,
   yylval, and yylloc are the syntactic category, semantic value, and location
   of the lookahead.  */
/*ARGSUSED*/ static void
yyrecoverSyntaxError (yyGLRStack* yystackp)
{
  size_t yyk;
  int yyj;

  if (yystackp->yyerrState == 3)
    /* We just shifted the error token and (perhaps) took some
       reductions.  Skip tokens until we can proceed.  */
    while (YYID (yytrue))
      {
	yySymbol yytoken;
	if (yychar == YYEOF)
	  yyFail (yystackp, NULL);
	if (yychar != YYEMPTY)
	  {
	    yytoken = YYTRANSLATE (yychar);
	    yydestruct ("Error: discarding",
			yytoken, &yylval);
	  }
	YYDPRINTF ((stderr, "Reading a token: "));
	yychar = YYLEX;
	if (yychar <= YYEOF)
	  {
	    yychar = yytoken = YYEOF;
	    YYDPRINTF ((stderr, "Now at end of input.\n"));
	  }
	else
	  {
	    yytoken = YYTRANSLATE (yychar);
	    YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
	  }
	yyj = yypact[yystackp->yytops.yystates[0]->yylrState];
	if (yyis_pact_ninf (yyj))
	  return;
	yyj += yytoken;
	if (yyj < 0 || YYLAST < yyj || yycheck[yyj] != yytoken)
	  {
	    if (yydefact[yystackp->yytops.yystates[0]->yylrState] != 0)
	      return;
	  }
	else if (yytable[yyj] != 0 && ! yyis_table_ninf (yytable[yyj]))
	  return;
      }

  /* Reduce to one stack.  */
  for (yyk = 0; yyk < yystackp->yytops.yysize; yyk += 1)
    if (yystackp->yytops.yystates[yyk] != NULL)
      break;
  if (yyk >= yystackp->yytops.yysize)
    yyFail (yystackp, NULL);
  for (yyk += 1; yyk < yystackp->yytops.yysize; yyk += 1)
    yymarkStackDeleted (yystackp, yyk);
  yyremoveDeletes (yystackp);
  yycompressStack (yystackp);

  /* Now pop stack until we find a state that shifts the error token.  */
  yystackp->yyerrState = 3;
  while (yystackp->yytops.yystates[0] != NULL)
    {
      yyGLRState *yys = yystackp->yytops.yystates[0];
      yyj = yypact[yys->yylrState];
      if (! yyis_pact_ninf (yyj))
	{
	  yyj += YYTERROR;
	  if (0 <= yyj && yyj <= YYLAST && yycheck[yyj] == YYTERROR
	      && yyisShiftAction (yytable[yyj]))
	    {
	      /* Shift the error token having adjusted its location.  */
	      YYLTYPE yyerrloc;
	      YY_SYMBOL_PRINT ("Shifting", yystos[yytable[yyj]],
			       &yylval, &yyerrloc);
	      yyglrShift (yystackp, 0, yytable[yyj],
			  yys->yyposn, &yylval, &yyerrloc);
	      yys = yystackp->yytops.yystates[0];
	      break;
	    }
	}

      if (yys->yypred != NULL)
	yydestroyGLRState ("Error: popping", yys);
      yystackp->yytops.yystates[0] = yys->yypred;
      yystackp->yynextFree -= 1;
      yystackp->yyspaceLeft += 1;
    }
  if (yystackp->yytops.yystates[0] == NULL)
    yyFail (yystackp, NULL);
}

#define YYCHK1(YYE)							     \
  do {									     \
    switch (YYE) {							     \
    case yyok:								     \
      break;								     \
    case yyabort:							     \
      goto yyabortlab;							     \
    case yyaccept:							     \
      goto yyacceptlab;							     \
    case yyerr:								     \
      goto yyuser_error;						     \
    default:								     \
      goto yybuglab;							     \
    }									     \
  } while (YYID (0))


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
  int yyresult;
  yyGLRStack yystack;
  yyGLRStack* const yystackp = &yystack;
  size_t yyposn;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY;
  yylval = yyval_default;


  if (! yyinitGLRStack (yystackp, YYINITDEPTH))
    goto yyexhaustedlab;
  switch (YYSETJMP (yystack.yyexception_buffer))
    {
    case 0: break;
    case 1: goto yyabortlab;
    case 2: goto yyexhaustedlab;
    default: goto yybuglab;
    }
  yyglrShift (&yystack, 0, 0, 0, &yylval, &yylloc);
  yyposn = 0;

  while (YYID (yytrue))
    {
      /* For efficiency, we have two loops, the first of which is
	 specialized to deterministic operation (single stack, no
	 potential ambiguity).  */
      /* Standard mode */
      while (YYID (yytrue))
	{
	  yyRuleNum yyrule;
	  int yyaction;
	  const short int* yyconflicts;

	  yyStateNum yystate = yystack.yytops.yystates[0]->yylrState;
	  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
	  if (yystate == YYFINAL)
	    goto yyacceptlab;
	  if (yyisDefaultedState (yystate))
	    {
	      yyrule = yydefaultAction (yystate);
	      if (yyrule == 0)
		{

		  yyreportSyntaxError (&yystack);
		  goto yyuser_error;
		}
	      YYCHK1 (yyglrReduce (&yystack, 0, yyrule, yytrue));
	    }
	  else
	    {
	      yySymbol yytoken;
	      if (yychar == YYEMPTY)
		{
		  YYDPRINTF ((stderr, "Reading a token: "));
		  yychar = YYLEX;
		}

	      if (yychar <= YYEOF)
		{
		  yychar = yytoken = YYEOF;
		  YYDPRINTF ((stderr, "Now at end of input.\n"));
		}
	      else
		{
		  yytoken = YYTRANSLATE (yychar);
		  YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
		}

	      yygetLRActions (yystate, yytoken, &yyaction, &yyconflicts);
	      if (*yyconflicts != 0)
		break;
	      if (yyisShiftAction (yyaction))
		{
		  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
		  yychar = YYEMPTY;
		  yyposn += 1;
		  yyglrShift (&yystack, 0, yyaction, yyposn, &yylval, &yylloc);
		  if (0 < yystack.yyerrState)
		    yystack.yyerrState -= 1;
		}
	      else if (yyisErrorAction (yyaction))
		{

		  yyreportSyntaxError (&yystack);
		  goto yyuser_error;
		}
	      else
		YYCHK1 (yyglrReduce (&yystack, 0, -yyaction, yytrue));
	    }
	}

      while (YYID (yytrue))
	{
	  yySymbol yytoken_to_shift;
	  size_t yys;

	  for (yys = 0; yys < yystack.yytops.yysize; yys += 1)
	    yystackp->yytops.yylookaheadNeeds[yys] = yychar != YYEMPTY;

	  /* yyprocessOneStack returns one of three things:

	      - An error flag.  If the caller is yyprocessOneStack, it
		immediately returns as well.  When the caller is finally
		yyparse, it jumps to an error label via YYCHK1.

	      - yyok, but yyprocessOneStack has invoked yymarkStackDeleted
		(&yystack, yys), which sets the top state of yys to NULL.  Thus,
		yyparse's following invocation of yyremoveDeletes will remove
		the stack.

	      - yyok, when ready to shift a token.

	     Except in the first case, yyparse will invoke yyremoveDeletes and
	     then shift the next token onto all remaining stacks.  This
	     synchronization of the shift (that is, after all preceding
	     reductions on all stacks) helps prevent double destructor calls
	     on yylval in the event of memory exhaustion.  */

	  for (yys = 0; yys < yystack.yytops.yysize; yys += 1)
	    YYCHK1 (yyprocessOneStack (&yystack, yys, yyposn));
	  yyremoveDeletes (&yystack);
	  if (yystack.yytops.yysize == 0)
	    {
	      yyundeleteLastStack (&yystack);
	      if (yystack.yytops.yysize == 0)
		yyFail (&yystack, YY_("syntax error"));
	      YYCHK1 (yyresolveStack (&yystack));
	      YYDPRINTF ((stderr, "Returning to deterministic operation.\n"));

	      yyreportSyntaxError (&yystack);
	      goto yyuser_error;
	    }

	  /* If any yyglrShift call fails, it will fail after shifting.  Thus,
	     a copy of yylval will already be on stack 0 in the event of a
	     failure in the following loop.  Thus, yychar is set to YYEMPTY
	     before the loop to make sure the user destructor for yylval isn't
	     called twice.  */
	  yytoken_to_shift = YYTRANSLATE (yychar);
	  yychar = YYEMPTY;
	  yyposn += 1;
	  for (yys = 0; yys < yystack.yytops.yysize; yys += 1)
	    {
	      int yyaction;
	      const short int* yyconflicts;
	      yyStateNum yystate = yystack.yytops.yystates[yys]->yylrState;
	      yygetLRActions (yystate, yytoken_to_shift, &yyaction,
			      &yyconflicts);
	      /* Note that yyconflicts were handled by yyprocessOneStack.  */
	      YYDPRINTF ((stderr, "On stack %lu, ", (unsigned long int) yys));
	      YY_SYMBOL_PRINT ("shifting", yytoken_to_shift, &yylval, &yylloc);
	      yyglrShift (&yystack, yys, yyaction, yyposn,
			  &yylval, &yylloc);
	      YYDPRINTF ((stderr, "Stack %lu now in state #%d\n",
			  (unsigned long int) yys,
			  yystack.yytops.yystates[yys]->yylrState));
	    }

	  if (yystack.yytops.yysize == 1)
	    {
	      YYCHK1 (yyresolveStack (&yystack));
	      YYDPRINTF ((stderr, "Returning to deterministic operation.\n"));
	      yycompressStack (&yystack);
	      break;
	    }
	}
      continue;
    yyuser_error:
      yyrecoverSyntaxError (&yystack);
      yyposn = yystack.yytops.yystates[0]->yyposn;
    }

 yyacceptlab:
  yyresult = 0;
  goto yyreturn;

 yybuglab:
  YYASSERT (yyfalse);
  goto yyabortlab;

 yyabortlab:
  yyresult = 1;
  goto yyreturn;

 yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturn;

 yyreturn:
  if (yychar != YYEMPTY)
    yydestruct ("Cleanup: discarding lookahead",
		YYTRANSLATE (yychar),
		&yylval);

  /* If the stack is well-formed, pop the stack until it is empty,
     destroying its entries as we go.  But free the stack regardless
     of whether it is well-formed.  */
  if (yystack.yyitems)
    {
      yyGLRState** yystates = yystack.yytops.yystates;
      if (yystates)
	{
	  size_t yysize = yystack.yytops.yysize;
	  size_t yyk;
	  for (yyk = 0; yyk < yysize; yyk += 1)
	    if (yystates[yyk])
	      {
		while (yystates[yyk])
		  {
		    yyGLRState *yys = yystates[yyk];
		    if (yys->yypred != NULL)
		      yydestroyGLRState ("Cleanup: popping", yys);
		    yystates[yyk] = yys->yypred;
		    yystack.yynextFree -= 1;
		    yystack.yyspaceLeft += 1;
		  }
		break;
	      }
	}
      yyfreeGLRStack (&yystack);
    }

  /* Make sure YYID is used.  */
  return YYID (yyresult);
}

/* DEBUGGING ONLY */
#if YYDEBUG
static void yypstack (yyGLRStack* yystackp, size_t yyk)
  __attribute__ ((__unused__));
static void yypdumpstack (yyGLRStack* yystackp) __attribute__ ((__unused__));

static void
yy_yypstack (yyGLRState* yys)
{
  if (yys->yypred)
    {
      yy_yypstack (yys->yypred);
      YYFPRINTF (stderr, " -> ");
    }
  YYFPRINTF (stderr, "%d@%lu", yys->yylrState,
             (unsigned long int) yys->yyposn);
}

static void
yypstates (yyGLRState* yyst)
{
  if (yyst == NULL)
    YYFPRINTF (stderr, "<null>");
  else
    yy_yypstack (yyst);
  YYFPRINTF (stderr, "\n");
}

static void
yypstack (yyGLRStack* yystackp, size_t yyk)
{
  yypstates (yystackp->yytops.yystates[yyk]);
}

#define YYINDEX(YYX)							     \
    ((YYX) == NULL ? -1 : (yyGLRStackItem*) (YYX) - yystackp->yyitems)


static void
yypdumpstack (yyGLRStack* yystackp)
{
  yyGLRStackItem* yyp;
  size_t yyi;
  for (yyp = yystackp->yyitems; yyp < yystackp->yynextFree; yyp += 1)
    {
      YYFPRINTF (stderr, "%3lu. ",
                 (unsigned long int) (yyp - yystackp->yyitems));
      if (*(yybool *) yyp)
	{
	  YYFPRINTF (stderr, "Res: %d, LR State: %d, posn: %lu, pred: %ld",
		     yyp->yystate.yyresolved, yyp->yystate.yylrState,
		     (unsigned long int) yyp->yystate.yyposn,
		     (long int) YYINDEX (yyp->yystate.yypred));
	  if (! yyp->yystate.yyresolved)
	    YYFPRINTF (stderr, ", firstVal: %ld",
		       (long int) YYINDEX (yyp->yystate
                                             .yysemantics.yyfirstVal));
	}
      else
	{
	  YYFPRINTF (stderr, "Option. rule: %d, state: %ld, next: %ld",
		     yyp->yyoption.yyrule - 1,
		     (long int) YYINDEX (yyp->yyoption.yystate),
		     (long int) YYINDEX (yyp->yyoption.yynext));
	}
      YYFPRINTF (stderr, "\n");
    }
  YYFPRINTF (stderr, "Tops:");
  for (yyi = 0; yyi < yystackp->yytops.yysize; yyi += 1)
    YYFPRINTF (stderr, "%lu: %ld; ", (unsigned long int) yyi,
	       (long int) YYINDEX (yystackp->yytops.yystates[yyi]));
  YYFPRINTF (stderr, "\n");
}
#endif



/* Line 2634 of glr.c  */
#line 899 "glrmysql.y"


void
emit(char *s, ...)
{
  extern yylineno;

  va_list ap;
  va_start(ap, s);

  printf("rpn: ");
  vfprintf(stdout, s, ap);
  printf("\n");
}

void
yyerror(const char *s, ...)
{
  extern yylineno;

  va_list ap;
  va_start(ap, s);

  fprintf(stderr, "%d: error: ", yylineno);
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}

main(int ac, char **av)
{
  extern FILE *yyin;

  if(ac > 1 && !strcmp(av[1], "-d")) {
    yydebug = 1; ac--; av++;
  }

  if(ac > 1 && (yyin = fopen(av[1], "r")) == NULL) {
    perror(av[1]);
    exit(1);
  }

  if(!yyparse())
    printf("SQL parse worked\n");
  else
    printf("SQL parse failed\n");
} /* main */

