
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 1



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 10 "lpmysql.y"

#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

 

/* Line 189 of yacc.c  */
#line 81 "lpmysql.tab.c"

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

/* "%code requires" blocks.  */

/* Line 209 of yacc.c  */
#line 17 "lpmysql.y"

char *filename;

typedef struct YYLTYPE {
  int first_line;
  int first_column;
  int last_line;
  int last_column;
  char *filename;
} YYLTYPE;
# define YYLTYPE_IS_DECLARED 1

# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (N)                                                            \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	  (Current).filename     = YYRHSLOC (Rhs, 1).filename;	        \
	}								\
      else								\
	{ /* empty RHS */						\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	  (Current).filename  = NULL;					\
	}								\
    while (0)



/* Line 209 of yacc.c  */
#line 140 "lpmysql.tab.c"

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NAME = 258,
     STRING = 259,
     INTNUM = 260,
     BOOL = 261,
     APPROXNUM = 262,
     USERVAR = 263,
     ASSIGN = 264,
     OR = 265,
     XOR = 266,
     ANDOP = 267,
     REGEXP = 268,
     LIKE = 269,
     IS = 270,
     IN = 271,
     NOT = 272,
     BETWEEN = 273,
     COMPARISON = 274,
     SHIFT = 275,
     MOD = 276,
     UMINUS = 277,
     ADD = 278,
     ALL = 279,
     ALTER = 280,
     ANALYZE = 281,
     AND = 282,
     ANY = 283,
     AS = 284,
     ASC = 285,
     AUTO_INCREMENT = 286,
     BEFORE = 287,
     BIGINT = 288,
     BINARY = 289,
     BIT = 290,
     BLOB = 291,
     BOTH = 292,
     BY = 293,
     CALL = 294,
     CASCADE = 295,
     CASE = 296,
     CHANGE = 297,
     CHAR = 298,
     CHECK = 299,
     COLLATE = 300,
     COLUMN = 301,
     COMMENT = 302,
     CONDITION = 303,
     CONSTRAINT = 304,
     CONTINUE = 305,
     CONVERT = 306,
     CREATE = 307,
     CROSS = 308,
     CURRENT_DATE = 309,
     CURRENT_TIME = 310,
     CURRENT_TIMESTAMP = 311,
     CURRENT_USER = 312,
     CURSOR = 313,
     DATABASE = 314,
     DATABASES = 315,
     DATE = 316,
     DATETIME = 317,
     DAY_HOUR = 318,
     DAY_MICROSECOND = 319,
     DAY_MINUTE = 320,
     DAY_SECOND = 321,
     DECIMAL = 322,
     DECLARE = 323,
     DEFAULT = 324,
     DELAYED = 325,
     DELETE = 326,
     DESC = 327,
     DESCRIBE = 328,
     DETERMINISTIC = 329,
     DISTINCT = 330,
     DISTINCTROW = 331,
     DIV = 332,
     DOUBLE = 333,
     DROP = 334,
     DUAL = 335,
     EACH = 336,
     ELSE = 337,
     ELSEIF = 338,
     ENCLOSED = 339,
     END = 340,
     ENUM = 341,
     ESCAPED = 342,
     EXISTS = 343,
     EXIT = 344,
     EXPLAIN = 345,
     FETCH = 346,
     FLOAT = 347,
     FOR = 348,
     FORCE = 349,
     FOREIGN = 350,
     FROM = 351,
     FULLTEXT = 352,
     GRANT = 353,
     GROUP = 354,
     HAVING = 355,
     HIGH_PRIORITY = 356,
     HOUR_MICROSECOND = 357,
     HOUR_MINUTE = 358,
     HOUR_SECOND = 359,
     IF = 360,
     IGNORE = 361,
     INDEX = 362,
     INFILE = 363,
     INNER = 364,
     INOUT = 365,
     INSENSITIVE = 366,
     INSERT = 367,
     INT = 368,
     INTEGER = 369,
     INTERVAL = 370,
     INTO = 371,
     ITERATE = 372,
     JOIN = 373,
     KEY = 374,
     KEYS = 375,
     KILL = 376,
     LEADING = 377,
     LEAVE = 378,
     LEFT = 379,
     LIMIT = 380,
     LINES = 381,
     LOAD = 382,
     LOCALTIME = 383,
     LOCALTIMESTAMP = 384,
     LOCK = 385,
     LONG = 386,
     LONGBLOB = 387,
     LONGTEXT = 388,
     LOOP = 389,
     LOW_PRIORITY = 390,
     MATCH = 391,
     MEDIUMBLOB = 392,
     MEDIUMINT = 393,
     MEDIUMTEXT = 394,
     MINUTE_MICROSECOND = 395,
     MINUTE_SECOND = 396,
     MODIFIES = 397,
     NATURAL = 398,
     NO_WRITE_TO_BINLOG = 399,
     NULLX = 400,
     NUMBER = 401,
     ON = 402,
     ONDUPLICATE = 403,
     OPTIMIZE = 404,
     OPTION = 405,
     OPTIONALLY = 406,
     ORDER = 407,
     OUT = 408,
     OUTER = 409,
     OUTFILE = 410,
     PRECISION = 411,
     PRIMARY = 412,
     PROCEDURE = 413,
     PURGE = 414,
     QUICK = 415,
     READ = 416,
     READS = 417,
     REAL = 418,
     REFERENCES = 419,
     RELEASE = 420,
     RENAME = 421,
     REPEAT = 422,
     REPLACE = 423,
     REQUIRE = 424,
     RESTRICT = 425,
     RETURN = 426,
     REVOKE = 427,
     RIGHT = 428,
     ROLLUP = 429,
     SCHEMA = 430,
     SCHEMAS = 431,
     SECOND_MICROSECOND = 432,
     SELECT = 433,
     SENSITIVE = 434,
     SEPARATOR = 435,
     SET = 436,
     SHOW = 437,
     SMALLINT = 438,
     SOME = 439,
     SONAME = 440,
     SPATIAL = 441,
     SPECIFIC = 442,
     SQL = 443,
     SQLEXCEPTION = 444,
     SQLSTATE = 445,
     SQLWARNING = 446,
     SQL_BIG_RESULT = 447,
     SQL_CALC_FOUND_ROWS = 448,
     SQL_SMALL_RESULT = 449,
     SSL = 450,
     STARTING = 451,
     STRAIGHT_JOIN = 452,
     TABLE = 453,
     TEMPORARY = 454,
     TEXT = 455,
     TERMINATED = 456,
     THEN = 457,
     TIME = 458,
     TIMESTAMP = 459,
     TINYBLOB = 460,
     TINYINT = 461,
     TINYTEXT = 462,
     TO = 463,
     TRAILING = 464,
     TRIGGER = 465,
     UNDO = 466,
     UNION = 467,
     UNIQUE = 468,
     UNLOCK = 469,
     UNSIGNED = 470,
     UPDATE = 471,
     USAGE = 472,
     USE = 473,
     USING = 474,
     UTC_DATE = 475,
     UTC_TIME = 476,
     UTC_TIMESTAMP = 477,
     VALUES = 478,
     VARBINARY = 479,
     VARCHAR = 480,
     VARYING = 481,
     WHEN = 482,
     WHERE = 483,
     WHILE = 484,
     WITH = 485,
     WRITE = 486,
     YEAR = 487,
     YEAR_MONTH = 488,
     ZEROFILL = 489,
     FSUBSTRING = 490,
     FTRIM = 491,
     FDATE_ADD = 492,
     FDATE_SUB = 493,
     FCOUNT = 494
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 51 "lpmysql.y"

	int intval;
	double floatval;
	char *strval;
	int subtok;



/* Line 214 of yacc.c  */
#line 405 "lpmysql.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;
# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


/* Copy the second part of user declarations.  */

/* Line 264 of yacc.c  */
#line 330 "lpmysql.y"

void yyerror(char *s, ...);
void lyyerror(YYLTYPE, char *s, ...);
void emit(char *s, ...);
 

/* Line 264 of yacc.c  */
#line 437 "lpmysql.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

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
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
	     && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  33
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1525

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  254
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  74
/* YYNRULES -- Number of rules.  */
#define YYNRULES  304
/* YYNRULES -- Number of states.  */
#define YYNSTATES  626

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   494

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
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
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     6,    10,    13,    17,    19,    23,    35,
      36,    39,    40,    45,    48,    53,    54,    56,    58,    59,
      62,    63,    66,    67,    71,    72,    75,    80,    81,    84,
      86,    88,    92,    96,    97,   100,   103,   106,   109,   112,
     115,   118,   121,   123,   127,   129,   132,   134,   138,   140,
     142,   146,   152,   156,   160,   162,   163,   166,   168,   169,
     175,   179,   185,   192,   198,   199,   201,   203,   204,   206,
     208,   210,   213,   216,   217,   219,   220,   223,   228,   235,
     242,   249,   250,   253,   254,   256,   260,   264,   266,   274,
     277,   280,   283,   284,   291,   294,   299,   300,   303,   311,
     313,   322,   323,   328,   329,   332,   335,   338,   341,   343,
     344,   345,   349,   353,   359,   361,   363,   367,   371,   379,
     387,   391,   395,   401,   407,   409,   418,   426,   434,   436,
     445,   446,   449,   452,   456,   462,   468,   476,   478,   483,
     488,   489,   492,   494,   503,   514,   524,   531,   543,   552,
     554,   558,   559,   564,   570,   575,   580,   586,   592,   593,
     597,   600,   604,   608,   612,   616,   619,   625,   629,   633,
     636,   640,   641,   645,   651,   652,   654,   655,   658,   661,
     662,   667,   671,   674,   678,   682,   686,   690,   694,   698,
     702,   706,   710,   714,   716,   718,   720,   722,   724,   728,
     734,   737,   742,   744,   746,   748,   750,   754,   758,   762,
     766,   772,   778,   780,   784,   788,   789,   791,   793,   794,
     796,   798,   801,   803,   807,   811,   815,   817,   819,   823,
     825,   827,   829,   831,   835,   839,   843,   847,   851,   855,
     858,   862,   866,   870,   874,   880,   887,   894,   901,   905,
     909,   913,   917,   920,   923,   927,   931,   936,   940,   945,
     951,   953,   957,   958,   960,   966,   973,   979,   986,   991,
     996,  1001,  1006,  1011,  1018,  1027,  1032,  1040,  1042,  1044,
    1046,  1053,  1060,  1064,  1068,  1072,  1076,  1080,  1084,  1088,
    1092,  1096,  1101,  1108,  1112,  1118,  1123,  1129,  1133,  1138,
    1142,  1147,  1149,  1151,  1153
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
     255,     0,    -1,   256,   249,    -1,   255,   256,   249,    -1,
       1,   249,    -1,   255,     1,   249,    -1,   257,    -1,   187,
     268,   269,    -1,   187,   268,   269,   105,   271,   258,   259,
     263,   264,   265,   266,    -1,    -1,   237,   322,    -1,    -1,
     108,    47,   260,   262,    -1,   322,   261,    -1,   260,   250,
     322,   261,    -1,    -1,    39,    -1,    81,    -1,    -1,   239,
     183,    -1,    -1,   109,   322,    -1,    -1,   161,    47,   260,
      -1,    -1,   134,   322,    -1,   134,   322,   250,   322,    -1,
      -1,   125,   267,    -1,     3,    -1,     4,    -1,   267,   250,
       3,    -1,   267,   250,     4,    -1,    -1,   268,    33,    -1,
     268,    84,    -1,   268,    85,    -1,   268,   110,    -1,   268,
     206,    -1,   268,   203,    -1,   268,   201,    -1,   268,   202,
      -1,   270,    -1,   269,   250,   270,    -1,    26,    -1,   322,
     275,    -1,   272,    -1,   271,   250,   272,    -1,   273,    -1,
     276,    -1,     3,   275,   283,    -1,     3,   251,     3,   275,
     283,    -1,   286,   274,     3,    -1,   252,   271,   253,    -1,
      38,    -1,    -1,    38,     3,    -1,     3,    -1,    -1,   272,
     277,   127,   273,   281,    -1,   272,   206,   273,    -1,   272,
     206,   273,   156,   322,    -1,   272,   279,   278,   127,   273,
     282,    -1,   272,   152,   280,   127,   273,    -1,    -1,   118,
      -1,    62,    -1,    -1,   163,    -1,   133,    -1,   182,    -1,
     133,   278,    -1,   182,   278,    -1,    -1,   282,    -1,    -1,
     156,   322,    -1,   228,   252,   267,   253,    -1,   227,   128,
     284,   252,   285,   253,    -1,   115,   128,   284,   252,   285,
     253,    -1,   103,   128,   284,   252,   285,   253,    -1,    -1,
     102,   127,    -1,    -1,     3,    -1,   285,   250,     3,    -1,
     252,   257,   253,    -1,   287,    -1,    80,   288,   105,     3,
     258,   264,   265,    -1,   288,   144,    -1,   288,   169,    -1,
     288,   115,    -1,    -1,    80,   288,   289,   105,   271,   258,
      -1,     3,   290,    -1,   289,   250,     3,   290,    -1,    -1,
     251,    26,    -1,    80,   288,   105,   289,   228,   271,   258,
      -1,   291,    -1,   121,   293,   294,     3,   295,   232,   296,
     292,    -1,    -1,   157,   128,   225,   298,    -1,    -1,   293,
     144,    -1,   293,    79,    -1,   293,   110,    -1,   293,   115,
      -1,   125,    -1,    -1,    -1,   252,   267,   253,    -1,   252,
     297,   253,    -1,   296,   250,   252,   297,   253,    -1,   322,
      -1,    78,    -1,   297,   250,   322,    -1,   297,   250,    78,
      -1,   121,   293,   294,     3,   190,   298,   292,    -1,   121,
     293,   294,     3,   295,   257,   292,    -1,     3,    20,   322,
      -1,     3,    20,    78,    -1,   298,   250,     3,    20,   322,
      -1,   298,   250,     3,    20,    78,    -1,   299,    -1,   177,
     293,   294,     3,   295,   232,   296,   292,    -1,   177,   293,
     294,     3,   190,   298,   292,    -1,   177,   293,   294,     3,
     295,   257,   292,    -1,   300,    -1,   225,   301,   271,   190,
     302,   258,   264,   265,    -1,    -1,   293,   144,    -1,   293,
     115,    -1,     3,    20,   322,    -1,     3,   251,     3,    20,
     322,    -1,   302,   250,     3,    20,   322,    -1,   302,   250,
       3,   251,     3,    20,   322,    -1,   303,    -1,    61,    68,
     304,     3,    -1,    61,   184,   304,     3,    -1,    -1,   114,
      97,    -1,   305,    -1,    61,   318,   207,   304,     3,   252,
     306,   253,    -1,    61,   318,   207,   304,     3,   251,     3,
     252,   306,   253,    -1,    61,   318,   207,   304,     3,   252,
     306,   253,   316,    -1,    61,   318,   207,   304,     3,   316,
      -1,    61,   318,   207,   304,     3,   251,     3,   252,   306,
     253,   316,    -1,    61,   318,   207,   304,     3,   251,     3,
     316,    -1,   307,    -1,   306,   250,   307,    -1,    -1,   308,
       3,   314,   309,    -1,   166,   128,   252,   267,   253,    -1,
     128,   252,   267,   253,    -1,   116,   252,   267,   253,    -1,
     106,   116,   252,   267,   253,    -1,   106,   128,   252,   267,
     253,    -1,    -1,   309,    18,   154,    -1,   309,   154,    -1,
     309,    78,     4,    -1,   309,    78,     5,    -1,   309,    78,
       7,    -1,   309,    78,     6,    -1,   309,    40,    -1,   309,
     222,   252,   267,   253,    -1,   309,   222,   128,    -1,   309,
     166,   128,    -1,   309,   128,    -1,   309,    56,     4,    -1,
      -1,   252,     5,   253,    -1,   252,     5,   250,     5,   253,
      -1,    -1,    43,    -1,    -1,   312,   224,    -1,   312,   243,
      -1,    -1,   313,    52,   190,     4,    -1,   313,    54,     4,
      -1,    44,   310,    -1,   215,   310,   312,    -1,   192,   310,
     312,    -1,   147,   310,   312,    -1,   122,   310,   312,    -1,
     123,   310,   312,    -1,    42,   310,   312,    -1,   172,   310,
     312,    -1,    87,   310,   312,    -1,   101,   310,   312,    -1,
      76,   310,   312,    -1,    70,    -1,   212,    -1,   213,    -1,
      71,    -1,   241,    -1,    52,   310,   313,    -1,   234,   252,
       5,   253,   313,    -1,    43,   310,    -1,   233,   252,     5,
     253,    -1,   214,    -1,    45,    -1,   146,    -1,   141,    -1,
     216,   311,   313,    -1,   209,   311,   313,    -1,   148,   311,
     313,    -1,   142,   311,   313,    -1,    95,   252,   315,   253,
     313,    -1,   190,   252,   315,   253,   313,    -1,     4,    -1,
     315,   250,     4,    -1,   317,   274,   257,    -1,    -1,   115,
      -1,   177,    -1,    -1,   208,    -1,   319,    -1,   190,   320,
      -1,   321,    -1,   320,   250,   321,    -1,     8,    20,   322,
      -1,     8,     9,   322,    -1,     3,    -1,     8,    -1,     3,
     251,     3,    -1,     4,    -1,     5,    -1,     7,    -1,     6,
      -1,   322,    24,   322,    -1,   322,    25,   322,    -1,   322,
      26,   322,    -1,   322,    27,   322,    -1,   322,    28,   322,
      -1,   322,    29,   322,    -1,    25,   322,    -1,   322,    12,
     322,    -1,   322,    10,   322,    -1,   322,    11,   322,    -1,
     322,    20,   322,    -1,   322,    20,   252,   257,   253,    -1,
     322,    20,    37,   252,   257,   253,    -1,   322,    20,   193,
     252,   257,   253,    -1,   322,    20,    33,   252,   257,   253,
      -1,   322,    21,   322,    -1,   322,    22,   322,    -1,   322,
      30,   322,    -1,   322,    23,   322,    -1,    18,   322,    -1,
      17,   322,    -1,     8,     9,   322,    -1,   322,    15,   154,
      -1,   322,    15,    18,   154,    -1,   322,    15,     6,    -1,
     322,    15,    18,     6,    -1,   322,    19,   322,    36,   322,
      -1,   322,    -1,   322,   250,   323,    -1,    -1,   323,    -1,
     322,    16,   252,   323,   253,    -1,   322,    18,    16,   252,
     323,   253,    -1,   322,    16,   252,   257,   253,    -1,   322,
      18,    16,   252,   257,   253,    -1,    97,   252,   257,   253,
      -1,     3,   252,   324,   253,    -1,   248,   252,    26,   253,
      -1,   248,   252,   322,   253,    -1,   244,   252,   323,   253,
      -1,   244,   252,   322,   105,   322,   253,    -1,   244,   252,
     322,   105,   322,   102,   322,   253,    -1,   245,   252,   323,
     253,    -1,   245,   252,   325,   322,   105,   323,   253,    -1,
     131,    -1,   218,    -1,    46,    -1,   246,   252,   322,   250,
     326,   253,    -1,   247,   252,   322,   250,   326,   253,    -1,
     124,   322,    72,    -1,   124,   322,    73,    -1,   124,   322,
      74,    -1,   124,   322,    75,    -1,   124,   322,   242,    -1,
     124,   322,   241,    -1,   124,   322,   111,    -1,   124,   322,
     112,    -1,   124,   322,   113,    -1,    50,   322,   327,    94,
      -1,    50,   322,   327,    91,   322,    94,    -1,    50,   327,
      94,    -1,    50,   327,    91,   322,    94,    -1,   236,   322,
     211,   322,    -1,   327,   236,   322,   211,   322,    -1,   322,
      14,   322,    -1,   322,    18,    14,   322,    -1,   322,    13,
     322,    -1,   322,    18,    13,   322,    -1,    65,    -1,    63,
      -1,    64,    -1,    43,   322,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   340,   340,   341,   344,   345,   349,   352,   354,   360,
     361,   363,   364,   368,   370,   374,   375,   376,   379,   380,
     383,   383,   385,   385,   388,   388,   389,   392,   393,   396,
     397,   399,   400,   404,   405,   406,   407,   408,   409,   410,
     411,   412,   415,   416,   417,   420,   422,   423,   426,   427,
     431,   432,   434,   435,   438,   439,   442,   443,   444,   448,
     450,   452,   454,   456,   460,   461,   462,   465,   466,   469,
     470,   473,   474,   475,   478,   478,   481,   482,   486,   488,
     490,   492,   495,   496,   499,   500,   503,   508,   511,   516,
     517,   518,   519,   522,   527,   528,   532,   532,   534,   542,
     545,   551,   552,   555,   556,   557,   558,   559,   562,   562,
     565,   566,   569,   570,   573,   574,   575,   576,   579,   585,
     591,   594,   597,   600,   606,   609,   615,   621,   627,   630,
     637,   638,   639,   643,   646,   649,   652,   660,   664,   665,
     668,   669,   675,   678,   682,   687,   692,   696,   702,   707,
     708,   711,   711,   714,   715,   716,   717,   718,   721,   722,
     723,   724,   725,   726,   727,   728,   729,   730,   731,   732,
     733,   736,   737,   738,   741,   742,   745,   746,   747,   750,
     751,   752,   756,   757,   758,   759,   760,   761,   762,   763,
     764,   765,   766,   767,   768,   769,   770,   771,   772,   773,
     774,   775,   776,   777,   778,   779,   780,   781,   782,   783,
     784,   785,   788,   789,   792,   795,   796,   797,   800,   801,
     806,   809,   811,   811,   814,   816,   821,   822,   823,   824,
     825,   826,   827,   830,   831,   832,   833,   834,   835,   836,
     837,   838,   839,   840,   841,   842,   843,   844,   845,   846,
     847,   848,   849,   850,   851,   854,   855,   856,   857,   860,
     864,   865,   868,   869,   872,   873,   874,   875,   876,   879,
     883,   884,   886,   887,   888,   889,   890,   893,   894,   895,
     898,   899,   902,   903,   904,   905,   906,   907,   908,   909,
     910,   913,   914,   915,   916,   919,   920,   923,   924,   927,
     928,   931,   932,   933,   936
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
  "NO_WRITE_TO_BINLOG", "NULLX", "NUMBER", "ON", "ONDUPLICATE", "OPTIMIZE",
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

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,    33,   272,   273,
     274,   124,    38,   275,    43,    45,    42,    47,    37,   276,
      94,   277,   278,   279,   280,   281,   282,   283,   284,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
     296,   297,   298,   299,   300,   301,   302,   303,   304,   305,
     306,   307,   308,   309,   310,   311,   312,   313,   314,   315,
     316,   317,   318,   319,   320,   321,   322,   323,   324,   325,
     326,   327,   328,   329,   330,   331,   332,   333,   334,   335,
     336,   337,   338,   339,   340,   341,   342,   343,   344,   345,
     346,   347,   348,   349,   350,   351,   352,   353,   354,   355,
     356,   357,   358,   359,   360,   361,   362,   363,   364,   365,
     366,   367,   368,   369,   370,   371,   372,   373,   374,   375,
     376,   377,   378,   379,   380,   381,   382,   383,   384,   385,
     386,   387,   388,   389,   390,   391,   392,   393,   394,   395,
     396,   397,   398,   399,   400,   401,   402,   403,   404,   405,
     406,   407,   408,   409,   410,   411,   412,   413,   414,   415,
     416,   417,   418,   419,   420,   421,   422,   423,   424,   425,
     426,   427,   428,   429,   430,   431,   432,   433,   434,   435,
     436,   437,   438,   439,   440,   441,   442,   443,   444,   445,
     446,   447,   448,   449,   450,   451,   452,   453,   454,   455,
     456,   457,   458,   459,   460,   461,   462,   463,   464,   465,
     466,   467,   468,   469,   470,   471,   472,   473,   474,   475,
     476,   477,   478,   479,   480,   481,   482,   483,   484,   485,
     486,   487,   488,   489,   490,   491,   492,   493,   494,    59,
      44,    46,    40,    41
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint16 yyr1[] =
{
       0,   254,   255,   255,   255,   255,   256,   257,   257,   258,
     258,   259,   259,   260,   260,   261,   261,   261,   262,   262,
     263,   263,   264,   264,   265,   265,   265,   266,   266,   267,
     267,   267,   267,   268,   268,   268,   268,   268,   268,   268,
     268,   268,   269,   269,   269,   270,   271,   271,   272,   272,
     273,   273,   273,   273,   274,   274,   275,   275,   275,   276,
     276,   276,   276,   276,   277,   277,   277,   278,   278,   279,
     279,   280,   280,   280,   281,   281,   282,   282,   283,   283,
     283,   283,   284,   284,   285,   285,   286,   256,   287,   288,
     288,   288,   288,   287,   289,   289,   290,   290,   287,   256,
     291,   292,   292,   293,   293,   293,   293,   293,   294,   294,
     295,   295,   296,   296,   297,   297,   297,   297,   291,   291,
     298,   298,   298,   298,   256,   299,   299,   299,   256,   300,
     301,   301,   301,   302,   302,   302,   302,   256,   303,   303,
     304,   304,   256,   305,   305,   305,   305,   305,   305,   306,
     306,   308,   307,   307,   307,   307,   307,   307,   309,   309,
     309,   309,   309,   309,   309,   309,   309,   309,   309,   309,
     309,   310,   310,   310,   311,   311,   312,   312,   312,   313,
     313,   313,   314,   314,   314,   314,   314,   314,   314,   314,
     314,   314,   314,   314,   314,   314,   314,   314,   314,   314,
     314,   314,   314,   314,   314,   314,   314,   314,   314,   314,
     314,   314,   315,   315,   316,   317,   317,   317,   318,   318,
     256,   319,   320,   320,   321,   321,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     323,   323,   324,   324,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   325,   325,   325,
     322,   322,   326,   326,   326,   326,   326,   326,   326,   326,
     326,   322,   322,   322,   322,   327,   327,   322,   322,   322,
     322,   322,   322,   322,   322
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     3,     2,     3,     1,     3,    11,     0,
       2,     0,     4,     2,     4,     0,     1,     1,     0,     2,
       0,     2,     0,     3,     0,     2,     4,     0,     2,     1,
       1,     3,     3,     0,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     3,     1,     2,     1,     3,     1,     1,
       3,     5,     3,     3,     1,     0,     2,     1,     0,     5,
       3,     5,     6,     5,     0,     1,     1,     0,     1,     1,
       1,     2,     2,     0,     1,     0,     2,     4,     6,     6,
       6,     0,     2,     0,     1,     3,     3,     1,     7,     2,
       2,     2,     0,     6,     2,     4,     0,     2,     7,     1,
       8,     0,     4,     0,     2,     2,     2,     2,     1,     0,
       0,     3,     3,     5,     1,     1,     3,     3,     7,     7,
       3,     3,     5,     5,     1,     8,     7,     7,     1,     8,
       0,     2,     2,     3,     5,     5,     7,     1,     4,     4,
       0,     2,     1,     8,    10,     9,     6,    11,     8,     1,
       3,     0,     4,     5,     4,     4,     5,     5,     0,     3,
       2,     3,     3,     3,     3,     2,     5,     3,     3,     2,
       3,     0,     3,     5,     0,     1,     0,     2,     2,     0,
       4,     3,     2,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     1,     1,     1,     1,     1,     3,     5,
       2,     4,     1,     1,     1,     1,     3,     3,     3,     3,
       5,     5,     1,     3,     3,     0,     1,     1,     0,     1,
       1,     2,     1,     3,     3,     3,     1,     1,     3,     1,
       1,     1,     1,     3,     3,     3,     3,     3,     3,     2,
       3,     3,     3,     3,     5,     6,     6,     6,     3,     3,
       3,     3,     2,     2,     3,     3,     4,     3,     4,     5,
       1,     3,     0,     1,     5,     6,     5,     6,     4,     4,
       4,     4,     4,     6,     8,     4,     7,     1,     1,     1,
       6,     6,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     4,     6,     3,     5,     4,     5,     3,     4,     3,
       4,     1,     1,     1,     2
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
       0,     0,   218,    92,   103,   103,    33,     0,   103,     0,
       0,     6,    87,    99,   124,   128,   137,   142,   220,     4,
     140,   140,   219,     0,     0,   109,   109,     0,     0,   221,
     222,     0,     0,     1,     0,     0,     2,     0,     0,     0,
     140,    96,     0,    91,    89,    90,     0,   105,   106,   107,
     108,   104,     0,     0,   226,   229,   230,   232,   231,   227,
       0,     0,     0,    44,    34,     0,     0,   302,   303,   301,
      35,    36,     0,    37,    40,    41,    39,    38,     0,     0,
       0,     0,     0,     7,    42,    58,     0,     0,     0,   107,
     104,    58,     0,     0,    46,    48,    49,    55,     5,     3,
     141,   138,   139,     0,     0,    94,     9,     0,     0,     0,
     110,   110,     0,   262,     0,   253,   252,   239,   304,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      57,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    45,   225,   224,   223,     0,    81,     0,     0,
       0,     0,    66,    65,    69,    73,    70,     0,     0,    67,
      54,     0,   215,    97,     0,    22,     0,     9,    96,     0,
       0,     0,     0,     0,   228,   260,   263,     0,   254,     0,
       0,     0,   293,     0,     0,   260,     0,   279,   277,   278,
       0,     0,     0,     0,     0,     0,     9,    43,   241,   242,
     240,   299,   297,   257,     0,   255,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   243,   248,   249,   251,   233,
     234,   235,   236,   237,   238,   250,    56,    58,     0,     0,
       0,    50,    86,    53,     0,     9,    47,    67,    67,     0,
      60,     0,    68,     0,    52,   216,   217,     0,   151,   146,
      55,    10,     0,    24,     9,    93,    95,     0,   101,    29,
      30,     0,     0,   101,   101,     0,   101,     0,   269,     0,
       0,   291,     0,     0,   268,     0,   272,   275,     0,     0,
       0,   270,   271,    11,   258,   256,     0,     0,   300,   298,
       0,     0,     0,     0,     0,     0,    81,    83,    83,    83,
       0,     0,     0,    22,    71,    72,     0,     0,    75,     0,
     215,     0,     0,     0,     0,     0,   149,     0,     0,     0,
       0,    88,    98,     0,     0,     0,   118,     0,   111,     0,
     101,   119,   126,   101,   127,   261,   295,     0,   294,     0,
       0,     0,     0,     0,     0,     0,    20,   266,   264,     0,
       0,   259,     0,     0,     0,   244,    51,     0,     0,     0,
       0,   133,     0,     0,    24,    63,    61,     0,     0,    59,
      74,     0,   151,   148,     0,     0,     0,     0,     0,   151,
     215,     0,   214,    23,    15,    25,   121,   120,     0,     0,
      31,    32,   115,     0,   114,     0,   100,   125,   292,   296,
       0,   273,     0,     0,   280,   281,     0,     0,    22,   267,
     265,   247,   245,   246,    82,     0,     0,     0,     0,     0,
       0,   129,    76,     0,    62,     0,     0,     0,     0,     0,
       0,   150,   145,   171,   171,   171,   203,   171,   193,   196,
     171,   171,     0,   171,   171,   171,   205,   174,   204,   171,
     174,   171,     0,   171,   174,   194,   195,   202,   171,   174,
       0,     0,   197,   158,     0,    16,    17,    13,     0,     0,
       0,     0,   112,     0,     0,   276,   282,   283,   284,   285,
     288,   289,   290,   287,   286,    18,    21,    24,    84,     0,
       0,     0,   134,   135,     0,     0,   215,     0,     0,   155,
     154,     0,     0,   176,   200,   182,   179,   176,   176,     0,
     176,   176,   176,   175,   179,   176,   179,   176,     0,   176,
     179,   176,   179,     0,     0,   152,    15,    26,   102,   123,
     122,   117,   116,     0,   274,     0,    12,    27,     0,    80,
      79,    78,     0,    77,   147,   156,   157,   153,     0,   188,
     198,   192,   190,   212,     0,   191,   186,   187,   209,   185,
     208,   189,     0,   184,   207,   183,   206,     0,     0,     0,
     165,     0,     0,   169,   160,     0,     0,    14,   113,    19,
       0,     8,    85,   136,     0,   172,   177,   178,     0,     0,
       0,   179,   179,   201,   179,   159,   170,   161,   162,   164,
     163,   168,   167,     0,    28,     0,     0,   181,   213,   210,
     211,   199,     0,   173,   180,   166
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     9,    10,    11,   175,   356,   393,   477,   546,   418,
     263,   331,   591,   271,    27,    83,    84,    93,    94,    95,
     171,   152,    96,   168,   253,   169,   249,   379,   380,   241,
     368,   499,    97,    12,    24,    46,   105,    13,   336,    25,
      52,   181,   340,   403,   268,    14,    15,    32,   245,    16,
      38,    17,   325,   326,   327,   535,   513,   524,   559,   560,
     473,   564,   259,   260,    23,    18,    29,    30,   185,   186,
     187,   201,   353,   121
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -362
static const yytype_int16 yypact[] =
{
      89,  -231,   -54,  -362,  -362,  -362,  -362,    39,     2,    88,
    -196,  -362,  -362,  -362,  -362,  -362,  -362,  -362,  -362,  -362,
     -46,   -46,  -362,  -106,    19,   209,   209,   197,    74,  -123,
    -362,   133,     3,  -362,  -101,   -87,  -362,   114,   214,   233,
     -46,    -6,   247,  -362,  -362,  -362,   -69,  -362,  -362,  -362,
    -362,  -362,   260,   265,  -119,  -362,  -362,  -362,  -362,   271,
     681,   681,   681,  -362,  -362,   681,   341,  -362,  -362,  -362,
    -362,  -362,    35,  -362,  -362,  -362,  -362,  -362,    44,    48,
      63,    69,    81,   -65,  -362,  1418,   681,   681,    39,     4,
       5,     8,    -1,  -105,   374,  -362,  -362,   288,  -362,  -362,
    -362,  -362,  -362,   353,   334,  -362,   126,  -199,     3,   359,
    -149,  -142,   371,   681,   681,   587,   587,  -362,  -362,   681,
     989,   -71,   200,   681,   221,   681,   681,   407,     3,   681,
    -362,   681,   681,   681,   681,   681,     6,   145,   351,   681,
     134,   681,   681,   681,   681,   681,   681,   681,   681,   681,
     681,   406,  -362,  1439,  1439,  -362,   423,   -84,   175,   -58,
     432,     3,  -362,  -362,  -362,   -96,  -362,     3,   313,   285,
    -362,   449,   -31,  -362,   681,   297,     3,  -193,    -6,   491,
     338,   -14,   491,     9,  -362,   821,  -362,   257,  1439,  1033,
     -64,   681,  -362,   681,   263,   800,   270,  -362,  -362,  -362,
     279,   681,   855,   920,   281,   745,  -193,  -362,  1459,   874,
    1477,  1495,  1495,  -362,    22,  -362,   456,   681,   681,   266,
    1389,   290,   300,   307,   200,   570,   892,   393,   458,   366,
     366,   519,   519,   519,   519,  -362,  -362,    12,   433,   434,
     435,  -362,  -362,  -362,   -17,  -192,   374,   285,   285,   437,
     410,     3,  -362,   440,  -362,  -362,  -362,   557,   195,  -362,
     288,  1439,   521,   436,  -193,  -362,  -362,   551,  -125,  -362,
    -362,    42,   320,   416,  -125,   320,   416,   681,  -362,   681,
     681,  -362,  1312,  1066,  -362,   681,  -362,  -362,  1291,   450,
     450,  -362,  -362,   467,  -362,  -362,   323,   325,  1495,  1495,
     456,   681,   200,   200,   200,   326,   -84,   479,   479,   479,
     681,   579,   581,   297,  -362,  -362,     3,   681,  -131,     3,
     -20,   -73,   350,   373,   498,    67,  -362,   625,   200,   681,
     681,  -362,  -362,   472,   501,   627,  -362,   404,  -362,   540,
    -115,  -362,  -362,  -115,  -362,  -362,  1439,  1333,  -362,   681,
      51,   681,   681,   378,   379,   588,   527,  -362,  -362,   385,
     387,   712,   389,   391,   392,  -362,  -362,   520,   394,   396,
     397,  1439,   630,   -16,   436,  -362,  1439,   681,   405,  -362,
    -362,  -131,   195,  -362,   408,   409,   338,   338,   411,   195,
     -66,  1059,  -362,   412,  1354,   941,  -362,  1439,   431,   638,
    -362,  -362,  -362,    85,  1439,   413,  -362,  -362,  -362,  1439,
     681,  -362,   414,   962,  -362,  -362,   681,   681,   297,  -362,
    -362,  -362,  -362,  -362,  -362,   661,   661,   661,   681,   681,
     671,  -362,  1439,   338,  -362,    87,   338,   338,   120,   122,
     338,  -362,  -362,   424,   424,   424,  -362,   424,  -362,  -362,
     424,   424,   425,   424,   424,   424,  -362,   632,  -362,   424,
     632,   424,   426,   424,   632,  -362,  -362,  -362,   424,   632,
     439,   441,  -362,  -362,   681,  -362,  -362,  -362,   681,   491,
     616,   665,  -362,   540,   779,  -362,  -362,  -362,  -362,  -362,
    -362,  -362,  -362,  -362,  -362,    66,  1439,   436,  -362,   135,
     184,   196,  1439,  1439,   672,   243,   -33,   245,   250,  -362,
    -362,   252,   691,  -362,  -362,  -362,  -362,  -362,  -362,   693,
    -362,  -362,  -362,  -362,  -362,  -362,  -362,  -362,   693,  -362,
    -362,  -362,  -362,   700,   702,   473,  1354,  1439,   459,  -362,
    1439,  -362,  1439,   258,  -362,   528,  -362,   585,   709,  -362,
    -362,  -362,   681,  -362,  -362,  -362,  -362,  -362,   259,   -37,
       0,   -37,   -37,  -362,   264,   -37,   -37,   -37,     0,   -37,
       0,   -37,   274,   -37,     0,   -37,     0,   461,   468,   568,
    -362,   719,   324,  -362,  -362,   597,   -72,  -362,  -362,  -362,
     338,  -362,  -362,  1439,   721,  -362,  -362,  -362,   537,   743,
     744,  -362,  -362,  -362,  -362,  -362,  -362,  -362,  -362,  -362,
    -362,  -362,  -362,   338,   499,   497,   747,  -362,  -362,     0,
       0,     0,   278,  -362,  -362,  -362
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -362,  -362,   767,   127,   -51,  -362,   336,   217,  -362,  -362,
    -287,  -361,  -362,  -258,  -362,  -362,   648,   181,   593,  -158,
     522,   -81,  -362,  -362,   291,  -362,  -362,  -362,   398,   474,
     232,   128,  -362,  -362,  -362,   739,   605,  -362,    -4,   525,
     770,   706,   563,   369,  -181,  -362,  -362,  -362,  -362,  -362,
     168,  -362,   471,   465,  -362,  -362,   663,  -227,   620,  -233,
    -362,   327,  -299,  -362,  -362,  -362,  -362,   768,   -27,  -107,
    -362,  -362,   567,   738
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -145
static const yytype_int16 yytable[] =
{
      85,   274,    91,   310,   429,  -130,    91,  -132,  -131,   250,
     157,   130,   213,   431,    20,   130,   196,   200,    19,   238,
     191,   383,    41,   192,   214,   377,   374,   280,   294,   176,
     281,   239,   334,   115,   116,   117,   108,   247,   118,   120,
     128,   179,   334,   384,   174,   174,   151,    28,   182,   255,
     151,   109,   598,    36,   599,   385,   612,   161,   312,   153,
     154,   131,   132,   133,   134,   135,   136,   137,    37,   138,
     139,   140,   141,   142,   143,   144,   145,   146,   147,   148,
     149,   150,   255,    86,   255,   160,   248,   188,    33,    34,
       1,   442,   189,   318,    87,   255,   195,   378,   202,   203,
     205,    40,    85,   180,   208,   209,   210,   211,   212,   297,
     180,   256,   220,   225,   226,   227,   228,   229,   230,   231,
     232,   233,   234,   235,    42,   335,   265,    88,   438,   439,
      21,   497,   112,   113,    43,   405,   547,    54,    55,    56,
      57,    58,    59,   240,   256,   161,   256,   261,    98,     2,
       2,    60,    61,   410,    22,   293,   306,   256,   375,    62,
     215,   381,    99,    44,   282,   193,   283,   221,     3,     3,
     345,   222,   193,     6,   288,   505,   295,    65,   507,   508,
     613,   109,   511,  -143,    66,   129,     6,   596,    45,    39,
     298,   299,   161,   360,   313,   243,     6,    67,    68,    69,
      54,    55,    56,    57,    58,    59,   597,   554,   103,     4,
       4,   100,    47,   332,    60,    61,  -144,   101,   272,   158,
     257,   258,    62,    63,    54,    55,    56,    57,    58,    59,
      64,    72,   382,   526,   311,   430,   102,   530,    60,    61,
      65,   275,   532,    48,   412,   104,    62,    66,    89,   194,
     106,    92,   346,   347,  -130,    92,  -132,  -131,   350,   156,
      67,    68,    69,   110,    65,     5,     5,   197,   111,   341,
     342,    66,   344,   159,   361,     6,     6,    90,     7,     7,
     114,    70,    71,   371,    67,    68,    69,   122,    47,   177,
     376,   568,   337,   570,    72,   338,   123,   574,   538,   576,
     124,   321,   394,   395,   411,   545,   397,    73,   273,   206,
     276,   322,   404,     8,     8,   125,   474,   389,    72,    48,
     390,   126,   409,   323,    49,   413,   170,   223,   607,   608,
     609,   610,   614,   127,    50,   481,   406,   389,   482,   407,
     506,   269,   270,   296,    54,    55,    56,    57,    58,    59,
     432,   305,   198,    51,   -96,   622,   172,   264,    60,    61,
     173,   324,   178,   174,   217,   218,    62,   219,   619,   620,
     337,   621,   337,   509,   184,   510,   -96,   104,    78,    79,
      80,    81,    82,   484,    65,   548,   224,     6,   549,   394,
     496,    66,   146,   147,   148,   149,   150,   216,    74,    75,
      76,   502,   503,    77,    67,    68,    69,   400,   401,   236,
      54,    55,    56,    57,    58,    59,   143,   144,   145,   146,
     147,   148,   149,   150,    60,    61,   237,   359,   242,   362,
     363,   364,    62,   204,   548,   244,   162,   550,    72,   199,
     251,    78,    79,    80,    81,    82,   548,   536,   252,   551,
      65,   537,   254,   540,   542,   392,   404,    66,   262,    54,
      55,    56,    57,    58,    59,    78,    79,    80,    81,    82,
      67,    68,    69,    60,    61,    54,    55,    56,    57,    58,
      59,    62,   144,   145,   146,   147,   148,   149,   150,    60,
      61,   579,   163,   337,   267,   337,   553,    62,   555,    65,
     337,   -64,   337,   556,    72,   557,    66,   164,   481,   594,
     278,   588,   595,   580,   600,    65,   284,   601,   300,    67,
      68,    69,    66,   286,   600,   593,   165,   602,   337,   581,
      26,   625,   287,    31,   291,    67,    68,    69,   314,   315,
     369,   370,   302,    54,    55,    56,    57,    58,    59,   150,
     396,   582,   303,    72,   500,   501,   166,    60,    61,   304,
     320,   307,   308,   309,   316,    62,   317,   319,   329,    72,
     330,   333,   339,   334,   352,   355,   357,   119,   358,   365,
     167,   367,   372,    65,   373,    78,    79,    80,    81,    82,
      66,   141,   142,   143,   144,   145,   146,   147,   148,   149,
     150,   583,   386,    67,    68,    69,   139,   140,   141,   142,
     143,   144,   145,   146,   147,   148,   149,   150,   402,    54,
      55,    56,    57,    58,    59,   387,   388,   584,   391,   398,
     399,   414,   415,    60,    61,   416,   417,    72,   419,   585,
     420,    62,   421,     6,   422,   423,   425,   424,   426,   427,
     428,    78,    79,    80,    81,    82,   479,   433,   480,    65,
     436,   437,   474,   440,   498,   483,    66,   485,    54,    55,
      56,    57,    58,    59,   504,   523,   512,   519,   528,    67,
      68,    69,    60,    61,    54,    55,    56,    57,    58,    59,
      62,   533,   552,   534,   539,   586,   558,   563,    60,    61,
      78,    79,    80,    81,    82,   577,    62,   578,    65,   335,
     590,   589,   592,    72,   603,    66,    78,    79,    80,    81,
      82,   604,   605,   606,    65,   611,   615,   616,    67,    68,
      69,    66,   140,   141,   142,   143,   144,   145,   146,   147,
     148,   149,   150,   541,    67,    68,    69,   617,   618,   337,
     623,   624,   495,   587,   246,   131,   132,   133,   134,   135,
     136,   137,    72,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   147,   148,   149,   150,    35,   207,    72,   434,
     366,   107,   328,   266,    78,    79,    80,    81,    82,   131,
     132,   133,   134,   135,   136,   137,    53,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147,   148,   149,   150,
     131,   132,   133,   134,   135,   136,   137,   183,   138,   139,
     140,   141,   142,   143,   144,   145,   146,   147,   148,   149,
     150,   131,   132,   133,   134,   135,   136,   137,   343,   138,
     139,   140,   141,   142,   143,   144,   145,   146,   147,   148,
     149,   150,   543,   435,   441,   572,   155,   354,   190,     0,
      78,    79,    80,    81,    82,   131,   132,   133,   134,   135,
     136,   137,     0,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   147,   148,   149,   150,   133,   134,   135,   136,
     137,     0,   138,   139,   140,   141,   142,   143,   144,   145,
     146,   147,   148,   149,   150,   285,     0,     0,     0,    78,
      79,    80,    81,    82,   142,   143,   144,   145,   146,   147,
     148,   149,   150,     0,     0,    78,    79,    80,    81,    82,
     131,   132,   133,   134,   135,   136,   137,     0,   138,   139,
     140,   141,   142,   143,   144,   145,   146,   147,   148,   149,
     150,   131,   132,   133,   134,   135,   136,   137,     0,   138,
     139,   140,   141,   142,   143,   144,   145,   146,   147,   148,
     149,   150,   131,   132,   133,   134,   135,   136,   137,     0,
     138,   139,   140,   141,   142,   143,   144,   145,   146,   147,
     148,   149,   150,     0,     0,     0,     0,     0,   292,   131,
     132,   133,   134,   135,   136,   137,     0,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147,   148,   149,   150,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   544,     0,   486,   487,   488,   489,     0,     0,
       0,     0,     0,   131,   132,   133,   134,   135,   136,   137,
     277,   138,   139,   140,   141,   142,   143,   144,   145,   146,
     147,   148,   149,   150,     0,     0,     0,     0,     0,     0,
       0,   277,     0,   490,   491,   492,   131,   132,   133,   134,
     135,   136,   137,     0,   138,   139,   140,   141,   142,   143,
     144,   145,   146,   147,   148,   149,   150,     0,     0,     0,
       0,   443,   444,   445,   446,   289,     0,   514,   515,     0,
     516,   447,     0,   517,   518,     0,   520,   521,   522,     0,
       0,     0,   525,     0,   527,     0,   529,     0,     0,   448,
     449,   531,     0,     0,     0,   450,     0,   561,   562,     0,
     565,   566,   567,     0,     0,   569,   451,   571,     0,   573,
       0,   575,     0,     0,   452,     0,     0,     0,     0,     0,
     453,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     290,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   454,   455,     0,     0,     0,     0,     0,     0,     0,
       0,   478,     0,     0,     0,     0,     0,     0,     0,     0,
     456,   457,     0,   493,   494,   458,   459,   460,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   119,     0,     0,     0,     0,
       0,   461,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   279,     0,     0,     0,     0,   462,
       0,   463,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   464,     0,
       0,   465,   466,   467,   468,   469,     0,   349,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   470,   471,     0,     0,     0,     0,     0,     0,
     472,   131,   132,   133,   134,   135,   136,   137,     0,   138,
     139,   140,   141,   142,   143,   144,   145,   146,   147,   148,
     149,   150,   131,   132,   133,   134,   135,   136,   137,     0,
     138,   139,   140,   141,   142,   143,   144,   145,   146,   147,
     148,   149,   150,   131,   132,   133,   134,   135,   136,   137,
       0,   138,   139,   140,   141,   142,   143,   144,   145,   146,
     147,   148,   149,   150,   131,   132,   133,   134,   135,   136,
     137,     0,   138,   139,   140,   141,   142,   143,   144,   145,
     146,   147,   148,   149,   150,     0,     0,     0,     0,     0,
       0,     0,     0,   475,     0,     0,   351,     0,     0,   131,
     132,   133,   134,   135,   136,   137,   348,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147,   148,   149,   150,
       0,   130,     0,     0,     0,   301,     0,   408,   131,   132,
     133,   134,   135,   136,   137,   476,   138,   139,   140,   141,
     142,   143,   144,   145,   146,   147,   148,   149,   150,   131,
     132,   133,   134,   135,   136,   137,   151,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147,   148,   149,   150,
     132,   133,   134,   135,   136,   137,     0,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147,   148,   149,   150,
     134,   135,   136,   137,     0,   138,   139,   140,   141,   142,
     143,   144,   145,   146,   147,   148,   149,   150,  -145,  -145,
    -145,  -145,     0,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   147,   148,   149,   150
};

static const yytype_int16 yycheck[] =
{
      27,   182,     3,    20,    20,     3,     3,     3,     3,   167,
      91,     3,     6,   374,    68,     3,   123,   124,   249,   103,
      91,   320,     3,    94,    18,   156,   313,    91,     6,   228,
      94,   115,   157,    60,    61,    62,   105,   133,    65,    66,
     105,   190,   157,   116,   237,   237,    38,     8,   190,   115,
      38,   250,    52,   249,    54,   128,   128,   250,   250,    86,
      87,    10,    11,    12,    13,    14,    15,    16,   114,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,   115,     9,   115,   190,   182,   114,     0,     1,
       1,   390,   119,   251,    20,   115,   123,   228,   125,   126,
     127,   207,   129,   252,   131,   132,   133,   134,   135,   216,
     252,   177,   139,   140,   141,   142,   143,   144,   145,   146,
     147,   148,   149,   150,   105,   250,   177,   250,   386,   387,
     184,   418,   251,   252,   115,   250,   497,     3,     4,     5,
       6,     7,     8,   227,   177,   250,   177,   174,   249,    61,
      61,    17,    18,   102,   208,   206,   237,   177,   316,    25,
     154,   319,   249,   144,   191,   236,   193,    33,    80,    80,
     277,    37,   236,   187,   201,   433,   154,    43,   436,   437,
     252,   250,   440,   249,    50,   250,   187,   224,   169,    21,
     217,   218,   250,   300,   245,   253,   187,    63,    64,    65,
       3,     4,     5,     6,     7,     8,   243,   506,    40,   121,
     121,    97,    79,   264,    17,    18,   249,     3,   232,    92,
     251,   252,    25,    26,     3,     4,     5,     6,     7,     8,
      33,    97,   252,   460,   251,   251,     3,   464,    17,    18,
      43,   232,   469,   110,   351,   251,    25,    50,   115,   122,
       3,   252,   279,   280,   252,   252,   252,   252,   285,   251,
      63,    64,    65,     3,    43,   177,   177,    46,     3,   273,
     274,    50,   276,    92,   301,   187,   187,   144,   190,   190,
       9,    84,    85,   310,    63,    64,    65,   252,    79,   108,
     317,   524,   250,   526,    97,   253,   252,   530,   479,   532,
     252,   106,   329,   330,   253,   239,   333,   110,   181,   128,
     183,   116,   339,   225,   225,   252,   250,   250,    97,   110,
     253,   252,   349,   128,   115,   352,    38,   193,     4,     5,
       6,     7,   590,   252,   125,   250,   340,   250,   253,   343,
     253,     3,     4,   216,     3,     4,     5,     6,     7,     8,
     377,   224,   131,   144,   228,   613,     3,   176,    17,    18,
      26,   166,     3,   237,    13,    14,    25,    16,   601,   602,
     250,   604,   250,   253,     3,   253,   250,   251,   244,   245,
     246,   247,   248,   410,    43,   250,   252,   187,   253,   416,
     417,    50,    26,    27,    28,    29,    30,   252,   201,   202,
     203,   428,   429,   206,    63,    64,    65,     3,     4,     3,
       3,     4,     5,     6,     7,     8,    23,    24,    25,    26,
      27,    28,    29,    30,    17,    18,     3,   300,   253,   302,
     303,   304,    25,    26,   250,     3,    62,   253,    97,   218,
     127,   244,   245,   246,   247,   248,   250,   474,   163,   253,
      43,   478,     3,   480,   481,   328,   483,    50,   161,     3,
       4,     5,     6,     7,     8,   244,   245,   246,   247,   248,
      63,    64,    65,    17,    18,     3,     4,     5,     6,     7,
       8,    25,    24,    25,    26,    27,    28,    29,    30,    17,
      18,    18,   118,   250,     3,   250,   253,    25,   253,    43,
     250,   127,   250,   253,    97,   253,    50,   133,   250,   250,
     253,   253,   253,    40,   250,    43,   253,   253,   252,    63,
      64,    65,    50,   253,   250,   552,   152,   253,   250,    56,
       5,   253,   253,     8,   253,    63,    64,    65,   247,   248,
     308,   309,   252,     3,     4,     5,     6,     7,     8,    30,
      78,    78,   252,    97,   426,   427,   182,    17,    18,   252,
       3,   128,   128,   128,   127,    25,   156,   127,    47,    97,
     134,    20,   252,   157,   124,   108,   253,   236,   253,   253,
     206,   102,     3,    43,     3,   244,   245,   246,   247,   248,
      50,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,   128,   252,    63,    64,    65,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    78,     3,
       4,     5,     6,     7,     8,   252,   128,   154,     3,   128,
       3,   253,   253,    17,    18,    47,   109,    97,   253,   166,
     253,    25,   253,   187,   253,   253,   252,   127,   252,   252,
      20,   244,   245,   246,   247,   248,   225,   252,    20,    43,
     252,   252,   250,   252,     3,   252,    50,   253,     3,     4,
       5,     6,     7,     8,     3,    43,   252,   252,   252,    63,
      64,    65,    17,    18,     3,     4,     5,     6,     7,     8,
      25,   252,    20,   252,    78,   222,     5,     4,    17,    18,
     244,   245,   246,   247,   248,     5,    25,     5,    43,   250,
     125,   183,     3,    97,   253,    50,   244,   245,   246,   247,
     248,   253,   154,     4,    43,   128,     5,   190,    63,    64,
      65,    50,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    78,    63,    64,    65,     4,     4,   250,
     253,     4,   416,   536,   161,    10,    11,    12,    13,    14,
      15,    16,    97,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,     9,   129,    97,   381,
     306,    42,   260,   178,   244,   245,   246,   247,   248,    10,
      11,    12,    13,    14,    15,    16,    26,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      10,    11,    12,    13,    14,    15,    16,   111,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    10,    11,    12,    13,    14,    15,    16,   275,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,   483,   382,   389,   528,    88,   290,   120,    -1,
     244,   245,   246,   247,   248,    10,    11,    12,    13,    14,
      15,    16,    -1,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    12,    13,    14,    15,
      16,    -1,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,   105,    -1,    -1,    -1,   244,
     245,   246,   247,   248,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    -1,    -1,   244,   245,   246,   247,   248,
      10,    11,    12,    13,    14,    15,    16,    -1,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    10,    11,    12,    13,    14,    15,    16,    -1,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    10,    11,    12,    13,    14,    15,    16,    -1,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    -1,    -1,    -1,    -1,    -1,   253,    10,
      11,    12,    13,    14,    15,    16,    -1,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   253,    -1,    72,    73,    74,    75,    -1,    -1,
      -1,    -1,    -1,    10,    11,    12,    13,    14,    15,    16,
     250,    18,    19,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   250,    -1,   111,   112,   113,    10,    11,    12,    13,
      14,    15,    16,    -1,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    -1,    -1,    -1,
      -1,    42,    43,    44,    45,   250,    -1,   444,   445,    -1,
     447,    52,    -1,   450,   451,    -1,   453,   454,   455,    -1,
      -1,    -1,   459,    -1,   461,    -1,   463,    -1,    -1,    70,
      71,   468,    -1,    -1,    -1,    76,    -1,   517,   518,    -1,
     520,   521,   522,    -1,    -1,   525,    87,   527,    -1,   529,
      -1,   531,    -1,    -1,    95,    -1,    -1,    -1,    -1,    -1,
     101,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     250,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   122,   123,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   250,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     141,   142,    -1,   241,   242,   146,   147,   148,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   236,    -1,    -1,    -1,    -1,
      -1,   172,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   211,    -1,    -1,    -1,    -1,   190,
      -1,   192,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   209,    -1,
      -1,   212,   213,   214,   215,   216,    -1,   211,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   233,   234,    -1,    -1,    -1,    -1,    -1,    -1,
     241,    10,    11,    12,    13,    14,    15,    16,    -1,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    10,    11,    12,    13,    14,    15,    16,    -1,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    10,    11,    12,    13,    14,    15,    16,
      -1,    18,    19,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    10,    11,    12,    13,    14,    15,
      16,    -1,    18,    19,    20,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    39,    -1,    -1,   105,    -1,    -1,    10,
      11,    12,    13,    14,    15,    16,    94,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      -1,     3,    -1,    -1,    -1,    36,    -1,    94,    10,    11,
      12,    13,    14,    15,    16,    81,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    10,
      11,    12,    13,    14,    15,    16,    38,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      11,    12,    13,    14,    15,    16,    -1,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      13,    14,    15,    16,    -1,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    13,    14,
      15,    16,    -1,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint16 yystos[] =
{
       0,     1,    61,    80,   121,   177,   187,   190,   225,   255,
     256,   257,   287,   291,   299,   300,   303,   305,   319,   249,
      68,   184,   208,   318,   288,   293,   293,   268,     8,   320,
     321,   293,   301,     0,     1,   256,   249,   114,   304,   304,
     207,     3,   105,   115,   144,   169,   289,    79,   110,   115,
     125,   144,   294,   294,     3,     4,     5,     6,     7,     8,
      17,    18,    25,    26,    33,    43,    50,    63,    64,    65,
      84,    85,    97,   110,   201,   202,   203,   206,   244,   245,
     246,   247,   248,   269,   270,   322,     9,    20,   250,   115,
     144,     3,   252,   271,   272,   273,   276,   286,   249,   249,
      97,     3,     3,   304,   251,   290,     3,   289,   105,   250,
       3,     3,   251,   252,     9,   322,   322,   322,   322,   236,
     322,   327,   252,   252,   252,   252,   252,   252,   105,   250,
       3,    10,    11,    12,    13,    14,    15,    16,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    38,   275,   322,   322,   321,   251,   275,   257,   271,
     190,   250,    62,   118,   133,   152,   182,   206,   277,   279,
      38,   274,     3,    26,   237,   258,   228,   271,     3,   190,
     252,   295,   190,   295,     3,   322,   323,   324,   322,   322,
     327,    91,    94,   236,   257,   322,   323,    46,   131,   218,
     323,   325,   322,   322,    26,   322,   271,   270,   322,   322,
     322,   322,   322,     6,    18,   154,   252,    13,    14,    16,
     322,    33,    37,   193,   252,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,     3,     3,   103,   115,
     227,   283,   253,   253,     3,   302,   272,   133,   182,   280,
     273,   127,   163,   278,     3,   115,   177,   251,   252,   316,
     317,   322,   161,   264,   271,   258,   290,     3,   298,     3,
       4,   267,   232,   257,   298,   232,   257,   250,   253,   211,
      91,    94,   322,   322,   253,   105,   253,   253,   322,   250,
     250,   253,   253,   258,     6,   154,   257,   323,   322,   322,
     252,    36,   252,   252,   252,   257,   275,   128,   128,   128,
      20,   251,   250,   258,   278,   278,   127,   156,   273,   127,
       3,   106,   116,   128,   166,   306,   307,   308,   274,    47,
     134,   265,   258,    20,   157,   250,   292,   250,   253,   252,
     296,   292,   292,   296,   292,   323,   322,   322,    94,   211,
     322,   105,   124,   326,   326,   108,   259,   253,   253,   257,
     323,   322,   257,   257,   257,   253,   283,   102,   284,   284,
     284,   322,     3,     3,   264,   273,   322,   156,   228,   281,
     282,   273,   252,   316,   116,   128,   252,   252,   128,   250,
     253,     3,   257,   260,   322,   322,    78,   322,   128,     3,
       3,     4,    78,   297,   322,   250,   292,   292,    94,   322,
     102,   253,   323,   322,   253,   253,    47,   109,   263,   253,
     253,   253,   253,   253,   127,   252,   252,   252,    20,    20,
     251,   265,   322,   252,   282,   306,   252,   252,   267,   267,
     252,   307,   316,    42,    43,    44,    45,    52,    70,    71,
      76,    87,    95,   101,   122,   123,   141,   142,   146,   147,
     148,   172,   190,   192,   209,   212,   213,   214,   215,   216,
     233,   234,   241,   314,   250,    39,    81,   261,   250,   225,
      20,   250,   253,   252,   322,   253,    72,    73,    74,    75,
     111,   112,   113,   241,   242,   260,   322,   264,     3,   285,
     285,   285,   322,   322,     3,   267,   253,   267,   267,   253,
     253,   267,   252,   310,   310,   310,   310,   310,   310,   252,
     310,   310,   310,    43,   311,   310,   311,   310,   252,   310,
     311,   310,   311,   252,   252,   309,   322,   322,   298,    78,
     322,    78,   322,   297,   253,   239,   262,   265,   250,   253,
     253,   253,    20,   253,   316,   253,   253,   253,     5,   312,
     313,   312,   312,     4,   315,   312,   312,   312,   313,   312,
     313,   312,   315,   312,   313,   312,   313,     5,     5,    18,
      40,    56,    78,   128,   154,   166,   222,   261,   253,   183,
     125,   266,     3,   322,   250,   253,   224,   243,    52,    54,
     250,   253,   253,   253,   253,   154,     4,     4,     5,     6,
       7,   128,   128,   252,   267,     5,   190,     4,     4,   313,
     313,   313,   267,   253,     4,   253
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value, Location); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    YYLTYPE const * const yylocationp;
#endif
{
  if (!yyvaluep)
    return;
  YYUSE (yylocationp);
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

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep, yylocationp)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    YYLTYPE const * const yylocationp;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  YY_LOCATION_PRINT (yyoutput, *yylocationp);
  YYFPRINTF (yyoutput, ": ");
  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yylsp, yyrule)
    YYSTYPE *yyvsp;
    YYLTYPE *yylsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       , &(yylsp[(yyi + 1) - (yynrhs)])		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, yylsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
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
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
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
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
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

      yyarg[0] = yytname[yytype];
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
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
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
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
#else
static void
yydestruct (yymsg, yytype, yyvaluep, yylocationp)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
    YYLTYPE *yylocationp;
#endif
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {
      case 3: /* "NAME" */

/* Line 1000 of yacc.c  */
#line 336 "lpmysql.y"
	{ printf ("free at %d %s\n",(*yylocationp).first_line, (yyvaluep->strval)); free((yyvaluep->strval)); };

/* Line 1000 of yacc.c  */
#line 2171 "lpmysql.tab.c"
	break;
      case 4: /* "STRING" */

/* Line 1000 of yacc.c  */
#line 336 "lpmysql.y"
	{ printf ("free at %d %s\n",(*yylocationp).first_line, (yyvaluep->strval)); free((yyvaluep->strval)); };

/* Line 1000 of yacc.c  */
#line 2180 "lpmysql.tab.c"
	break;
      case 8: /* "USERVAR" */

/* Line 1000 of yacc.c  */
#line 336 "lpmysql.y"
	{ printf ("free at %d %s\n",(*yylocationp).first_line, (yyvaluep->strval)); free((yyvaluep->strval)); };

/* Line 1000 of yacc.c  */
#line 2189 "lpmysql.tab.c"
	break;

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Location data for the lookahead symbol.  */
YYLTYPE yylloc;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.
       `yyls': related to locations.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[2];

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;
  yylsp = yyls;

#if YYLTYPE_IS_TRIVIAL
  /* Initialize the default location before parsing starts.  */
  yylloc.first_line   = yylloc.last_line   = 1;
  yylloc.first_column = yylloc.last_column = 1;
#endif

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;
	YYLTYPE *yyls1 = yyls;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yyls1, yysize * sizeof (*yylsp),
		    &yystacksize);

	yyls = yyls1;
	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
	YYSTACK_RELOCATE (yyls_alloc, yyls);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
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

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;
  *++yylsp = yylloc;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location.  */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 6:

/* Line 1455 of yacc.c  */
#line 349 "lpmysql.y"
    { emit("STMT"); ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 353 "lpmysql.y"
    { emit("SELECTNODATA %d %d", (yyvsp[(2) - (3)].intval), (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 357 "lpmysql.y"
    { emit("SELECT %d %d %d", (yyvsp[(2) - (11)].intval), (yyvsp[(3) - (11)].intval), (yyvsp[(5) - (11)].intval)); ;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 361 "lpmysql.y"
    { emit("WHERE"); ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 365 "lpmysql.y"
    { emit("GROUPBYLIST %d %d", (yyvsp[(3) - (4)].intval), (yyvsp[(4) - (4)].intval)); ;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 369 "lpmysql.y"
    { emit("GROUPBY %d",  (yyvsp[(2) - (2)].intval)); (yyval.intval) = 1; ;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 371 "lpmysql.y"
    { emit("GROUPBY %d",  (yyvsp[(4) - (4)].intval)); (yyval.intval) = (yyvsp[(1) - (4)].intval) + 1; ;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 374 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 375 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 376 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 379 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 380 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 383 "lpmysql.y"
    { emit("HAVING"); ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 385 "lpmysql.y"
    { emit("ORDERBY %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 388 "lpmysql.y"
    { emit("LIMIT 1"); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 389 "lpmysql.y"
    { emit("LIMIT 2"); ;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 393 "lpmysql.y"
    { emit("INTO %d", (yyvsp[(2) - (2)].intval)); ;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 396 "lpmysql.y"
    { emit("COLUMN %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); (yyval.intval) = 1; ;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 397 "lpmysql.y"
    { lyyerror((yylsp[(1) - (1)]), "string %s found where name required", (yyvsp[(1) - (1)].strval));
                              emit("COLUMN %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); (yyval.intval) = 1; ;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 399 "lpmysql.y"
    { emit("COLUMN %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 400 "lpmysql.y"
    { lyyerror((yylsp[(3) - (3)]), "string %s found where name required", (yyvsp[(1) - (3)].intval));
                            emit("COLUMN %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 404 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 405 "lpmysql.y"
    { if((yyval.intval) & 01) lyyerror((yylsp[(2) - (2)]),"duplicate ALL option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 01; ;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 406 "lpmysql.y"
    { if((yyval.intval) & 02) lyyerror((yylsp[(2) - (2)]),"duplicate DISTINCT option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 02; ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 407 "lpmysql.y"
    { if((yyval.intval) & 04) lyyerror((yylsp[(2) - (2)]),"duplicate DISTINCTROW option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 04; ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 408 "lpmysql.y"
    { if((yyval.intval) & 010) lyyerror((yylsp[(2) - (2)]),"duplicate HIGH_PRIORITY option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 010; ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 409 "lpmysql.y"
    { if((yyval.intval) & 020) lyyerror((yylsp[(2) - (2)]),"duplicate STRAIGHT_JOIN option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 020; ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 410 "lpmysql.y"
    { if((yyval.intval) & 040) lyyerror((yylsp[(2) - (2)]),"duplicate SQL_SMALL_RESULT option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 040; ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 411 "lpmysql.y"
    { if((yyval.intval) & 0100) lyyerror((yylsp[(2) - (2)]),"duplicate SQL_BIG_RESULT option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 0100; ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 412 "lpmysql.y"
    { if((yyval.intval) & 0200) lyyerror((yylsp[(2) - (2)]),"duplicate SQL_CALC_FOUND_ROWS option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 0200; ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 415 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 416 "lpmysql.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 417 "lpmysql.y"
    { emit("SELECTALL"); (yyval.intval) = 1; ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 422 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 423 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 431 "lpmysql.y"
    { emit("TABLE %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); ;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 432 "lpmysql.y"
    { emit("TABLE %s.%s", (yyvsp[(1) - (5)].strval), (yyvsp[(3) - (5)].strval));
                               free((yyvsp[(1) - (5)].strval)); free((yyvsp[(3) - (5)].strval)); ;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 434 "lpmysql.y"
    { emit("SUBQUERYAS %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 435 "lpmysql.y"
    { emit("TABLEREFERENCES %d", (yyvsp[(2) - (3)].intval)); ;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 442 "lpmysql.y"
    { emit ("ALIAS %s", (yyvsp[(2) - (2)].strval)); free((yyvsp[(2) - (2)].strval)); ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 443 "lpmysql.y"
    { emit ("ALIAS %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 449 "lpmysql.y"
    { emit("JOIN %d", 0100+(yyvsp[(2) - (5)].intval)); ;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 451 "lpmysql.y"
    { emit("JOIN %d", 0200); ;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 453 "lpmysql.y"
    { emit("JOIN %d", 0200); ;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 455 "lpmysql.y"
    { emit("JOIN %d", 0300+(yyvsp[(2) - (6)].intval)+(yyvsp[(3) - (6)].intval)); ;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 457 "lpmysql.y"
    { emit("JOIN %d", 0400+(yyvsp[(3) - (5)].intval)); ;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 460 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 461 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 462 "lpmysql.y"
    { (yyval.intval) = 2; ;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 465 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 466 "lpmysql.y"
    {(yyval.intval) = 4; ;}
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 469 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 470 "lpmysql.y"
    { (yyval.intval) = 2; ;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 473 "lpmysql.y"
    { (yyval.intval) = 1 + (yyvsp[(2) - (2)].intval); ;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 474 "lpmysql.y"
    { (yyval.intval) = 2 + (yyvsp[(2) - (2)].intval); ;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 475 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 481 "lpmysql.y"
    { emit("ONEXPR"); ;}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 482 "lpmysql.y"
    { emit("USING %d", (yyvsp[(3) - (4)].intval)); ;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 487 "lpmysql.y"
    { emit("INDEXHINT %d %d", (yyvsp[(5) - (6)].intval), 010+(yyvsp[(3) - (6)].intval)); ;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 489 "lpmysql.y"
    { emit("INDEXHINT %d %d", (yyvsp[(5) - (6)].intval), 020+(yyvsp[(3) - (6)].intval)); ;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 491 "lpmysql.y"
    { emit("INDEXHINT %d %d", (yyvsp[(5) - (6)].intval), 030+(yyvsp[(3) - (6)].intval)); ;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 495 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 496 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 499 "lpmysql.y"
    { emit("INDEX %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); (yyval.intval) = 1; ;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 500 "lpmysql.y"
    { emit("INDEX %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 503 "lpmysql.y"
    { emit("SUBQUERY"); ;}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 508 "lpmysql.y"
    { emit("STMT"); ;}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 513 "lpmysql.y"
    { emit("DELETEONE %d %s", (yyvsp[(2) - (7)].intval), (yyvsp[(4) - (7)].strval)); free((yyvsp[(4) - (7)].strval)); ;}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 516 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) + 01; ;}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 517 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) + 02; ;}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 518 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) + 04; ;}
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 519 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 525 "lpmysql.y"
    { emit("DELETEMULTI %d %d %d", (yyvsp[(2) - (6)].intval), (yyvsp[(3) - (6)].intval), (yyvsp[(5) - (6)].intval)); ;}
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 527 "lpmysql.y"
    { emit("TABLE %s", (yyvsp[(1) - (2)].strval)); free((yyvsp[(1) - (2)].strval)); (yyval.intval) = 1; ;}
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 529 "lpmysql.y"
    { emit("TABLE %s", (yyvsp[(3) - (4)].strval)); free((yyvsp[(3) - (4)].strval)); (yyval.intval) = (yyvsp[(1) - (4)].intval) + 1; ;}
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 537 "lpmysql.y"
    { emit("DELETEMULTI %d %d %d", (yyvsp[(2) - (7)].intval), (yyvsp[(4) - (7)].intval), (yyvsp[(6) - (7)].intval)); ;}
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 542 "lpmysql.y"
    { emit("STMT"); ;}
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 548 "lpmysql.y"
    { emit("INSERTVALS %d %d %s", (yyvsp[(2) - (8)].intval), (yyvsp[(7) - (8)].intval), (yyvsp[(4) - (8)].strval)); free((yyvsp[(4) - (8)].strval)) ;}
    break;

  case 102:

/* Line 1455 of yacc.c  */
#line 552 "lpmysql.y"
    { emit("DUPUPDATE %d", (yyvsp[(4) - (4)].intval)); ;}
    break;

  case 103:

/* Line 1455 of yacc.c  */
#line 555 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 556 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 01 ; ;}
    break;

  case 105:

/* Line 1455 of yacc.c  */
#line 557 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 02 ; ;}
    break;

  case 106:

/* Line 1455 of yacc.c  */
#line 558 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 04 ; ;}
    break;

  case 107:

/* Line 1455 of yacc.c  */
#line 559 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 010 ; ;}
    break;

  case 111:

/* Line 1455 of yacc.c  */
#line 566 "lpmysql.y"
    { emit("INSERTCOLS %d", (yyvsp[(2) - (3)].intval)); ;}
    break;

  case 112:

/* Line 1455 of yacc.c  */
#line 569 "lpmysql.y"
    { emit("VALUES %d", (yyvsp[(2) - (3)].intval)); (yyval.intval) = 1; ;}
    break;

  case 113:

/* Line 1455 of yacc.c  */
#line 570 "lpmysql.y"
    { emit("VALUES %d", (yyvsp[(4) - (5)].intval)); (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; ;}
    break;

  case 114:

/* Line 1455 of yacc.c  */
#line 573 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 115:

/* Line 1455 of yacc.c  */
#line 574 "lpmysql.y"
    { emit("DEFAULT"); (yyval.intval) = 1; ;}
    break;

  case 116:

/* Line 1455 of yacc.c  */
#line 575 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 117:

/* Line 1455 of yacc.c  */
#line 576 "lpmysql.y"
    { emit("DEFAULT"); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 118:

/* Line 1455 of yacc.c  */
#line 582 "lpmysql.y"
    { emit("INSERTASGN %d %d %s", (yyvsp[(2) - (7)].intval), (yyvsp[(6) - (7)].intval), (yyvsp[(4) - (7)].strval)); free((yyvsp[(4) - (7)].strval)) ;}
    break;

  case 119:

/* Line 1455 of yacc.c  */
#line 587 "lpmysql.y"
    { emit("INSERTSELECT %d %s", (yyvsp[(2) - (7)].intval), (yyvsp[(4) - (7)].strval)); free((yyvsp[(4) - (7)].strval)); ;}
    break;

  case 120:

/* Line 1455 of yacc.c  */
#line 592 "lpmysql.y"
    { if ((yyvsp[(2) - (3)].subtok) != 4) { lyyerror((yylsp[(2) - (3)]),"bad insert assignment to %s", (yyvsp[(1) - (3)].strval)); YYERROR; }
       emit("ASSIGN %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); (yyval.intval) = 1; ;}
    break;

  case 121:

/* Line 1455 of yacc.c  */
#line 595 "lpmysql.y"
    { if ((yyvsp[(2) - (3)].subtok) != 4) { lyyerror((yylsp[(2) - (3)]),"bad insert assignment to %s", (yyvsp[(1) - (3)].strval)); YYERROR; }
                 emit("DEFAULT"); emit("ASSIGN %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); (yyval.intval) = 1; ;}
    break;

  case 122:

/* Line 1455 of yacc.c  */
#line 598 "lpmysql.y"
    { if ((yyvsp[(4) - (5)].subtok) != 4) { lyyerror((yylsp[(4) - (5)]),"bad insert assignment to %s", (yyvsp[(1) - (5)].intval)); YYERROR; }
                 emit("ASSIGN %s", (yyvsp[(3) - (5)].strval)); free((yyvsp[(3) - (5)].strval)); (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; ;}
    break;

  case 123:

/* Line 1455 of yacc.c  */
#line 601 "lpmysql.y"
    { if ((yyvsp[(4) - (5)].subtok) != 4) { lyyerror((yylsp[(4) - (5)]),"bad insert assignment to %s", (yyvsp[(1) - (5)].intval)); YYERROR; }
                 emit("DEFAULT"); emit("ASSIGN %s", (yyvsp[(3) - (5)].strval)); free((yyvsp[(3) - (5)].strval)); (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; ;}
    break;

  case 124:

/* Line 1455 of yacc.c  */
#line 606 "lpmysql.y"
    { emit("STMT"); ;}
    break;

  case 125:

/* Line 1455 of yacc.c  */
#line 612 "lpmysql.y"
    { emit("REPLACEVALS %d %d %s", (yyvsp[(2) - (8)].intval), (yyvsp[(7) - (8)].intval), (yyvsp[(4) - (8)].strval)); free((yyvsp[(4) - (8)].strval)) ;}
    break;

  case 126:

/* Line 1455 of yacc.c  */
#line 618 "lpmysql.y"
    { emit("REPLACEASGN %d %d %s", (yyvsp[(2) - (7)].intval), (yyvsp[(6) - (7)].intval), (yyvsp[(4) - (7)].strval)); free((yyvsp[(4) - (7)].strval)) ;}
    break;

  case 127:

/* Line 1455 of yacc.c  */
#line 623 "lpmysql.y"
    { emit("REPLACESELECT %d %s", (yyvsp[(2) - (7)].intval), (yyvsp[(4) - (7)].strval)); free((yyvsp[(4) - (7)].strval)); ;}
    break;

  case 128:

/* Line 1455 of yacc.c  */
#line 627 "lpmysql.y"
    { emit("STMT"); ;}
    break;

  case 129:

/* Line 1455 of yacc.c  */
#line 634 "lpmysql.y"
    { emit("UPDATE %d %d %d", (yyvsp[(2) - (8)].intval), (yyvsp[(3) - (8)].intval), (yyvsp[(5) - (8)].intval)); ;}
    break;

  case 130:

/* Line 1455 of yacc.c  */
#line 637 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 131:

/* Line 1455 of yacc.c  */
#line 638 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 01 ; ;}
    break;

  case 132:

/* Line 1455 of yacc.c  */
#line 639 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 010 ; ;}
    break;

  case 133:

/* Line 1455 of yacc.c  */
#line 644 "lpmysql.y"
    { if ((yyvsp[(2) - (3)].subtok) != 4) { lyyerror((yylsp[(2) - (3)]),"bad update assignment to %s", (yyvsp[(1) - (3)].strval)); YYERROR; }
	 emit("ASSIGN %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); (yyval.intval) = 1; ;}
    break;

  case 134:

/* Line 1455 of yacc.c  */
#line 647 "lpmysql.y"
    { if ((yyvsp[(4) - (5)].subtok) != 4) { lyyerror((yylsp[(4) - (5)]),"bad update assignment to %s", (yyvsp[(1) - (5)].strval)); YYERROR; }
	 emit("ASSIGN %s.%s", (yyvsp[(1) - (5)].strval), (yyvsp[(3) - (5)].strval)); free((yyvsp[(1) - (5)].strval)); free((yyvsp[(3) - (5)].strval)); (yyval.intval) = 1; ;}
    break;

  case 135:

/* Line 1455 of yacc.c  */
#line 650 "lpmysql.y"
    { if ((yyvsp[(4) - (5)].subtok) != 4) { lyyerror((yylsp[(4) - (5)]),"bad update assignment to %s", (yyvsp[(3) - (5)].strval)); YYERROR; }
	 emit("ASSIGN %s.%s", (yyvsp[(3) - (5)].strval)); free((yyvsp[(3) - (5)].strval)); (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; ;}
    break;

  case 136:

/* Line 1455 of yacc.c  */
#line 653 "lpmysql.y"
    { if ((yyvsp[(6) - (7)].subtok) != 4) { lyyerror((yylsp[(6) - (7)]),"bad update  assignment to %s.$s", (yyvsp[(3) - (7)].strval), (yyvsp[(5) - (7)].strval)); YYERROR; }
	 emit("ASSIGN %s.%s", (yyvsp[(3) - (7)].strval), (yyvsp[(5) - (7)].strval)); free((yyvsp[(3) - (7)].strval)); free((yyvsp[(5) - (7)].strval)); (yyval.intval) = 1; ;}
    break;

  case 137:

/* Line 1455 of yacc.c  */
#line 660 "lpmysql.y"
    { emit("STMT"); ;}
    break;

  case 138:

/* Line 1455 of yacc.c  */
#line 664 "lpmysql.y"
    { emit("CREATEDATABASE %d %s", (yyvsp[(3) - (4)].intval), (yyvsp[(4) - (4)].strval)); free((yyvsp[(4) - (4)].strval)); ;}
    break;

  case 139:

/* Line 1455 of yacc.c  */
#line 665 "lpmysql.y"
    { emit("CREATEDATABASE %d %s", (yyvsp[(3) - (4)].intval), (yyvsp[(4) - (4)].strval)); free((yyvsp[(4) - (4)].strval)); ;}
    break;

  case 140:

/* Line 1455 of yacc.c  */
#line 668 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 141:

/* Line 1455 of yacc.c  */
#line 669 "lpmysql.y"
    { if(!(yyvsp[(2) - (2)].subtok)) { lyyerror((yylsp[(2) - (2)]),"IF EXISTS doesn't exist"); YYERROR; }
                        (yyval.intval) = (yyvsp[(2) - (2)].subtok); /* NOT EXISTS hack */ ;}
    break;

  case 142:

/* Line 1455 of yacc.c  */
#line 675 "lpmysql.y"
    { emit("STMT"); ;}
    break;

  case 143:

/* Line 1455 of yacc.c  */
#line 679 "lpmysql.y"
    { emit("CREATE %d %d %d %s", (yyvsp[(2) - (8)].intval), (yyvsp[(4) - (8)].intval), (yyvsp[(7) - (8)].intval), (yyvsp[(5) - (8)].strval)); free((yyvsp[(5) - (8)].strval)); ;}
    break;

  case 144:

/* Line 1455 of yacc.c  */
#line 683 "lpmysql.y"
    { emit("CREATE %d %d %d %s.%s", (yyvsp[(2) - (10)].intval), (yyvsp[(4) - (10)].intval), (yyvsp[(9) - (10)].intval), (yyvsp[(5) - (10)].strval), (yyvsp[(7) - (10)].strval));
                          free((yyvsp[(5) - (10)].strval)); free((yyvsp[(7) - (10)].strval)); ;}
    break;

  case 145:

/* Line 1455 of yacc.c  */
#line 689 "lpmysql.y"
    { emit("CREATESELECT %d %d %d %s", (yyvsp[(2) - (9)].intval), (yyvsp[(4) - (9)].intval), (yyvsp[(7) - (9)].intval), (yyvsp[(5) - (9)].strval)); free((yyvsp[(5) - (9)].strval)); ;}
    break;

  case 146:

/* Line 1455 of yacc.c  */
#line 693 "lpmysql.y"
    { emit("CREATESELECT %d %d 0 %s", (yyvsp[(2) - (6)].intval), (yyvsp[(4) - (6)].intval), (yyvsp[(5) - (6)].strval)); free((yyvsp[(5) - (6)].strval)); ;}
    break;

  case 147:

/* Line 1455 of yacc.c  */
#line 698 "lpmysql.y"
    { emit("CREATESELECT %d %d 0 %s.%s", (yyvsp[(2) - (11)].intval), (yyvsp[(4) - (11)].intval), (yyvsp[(5) - (11)].strval), (yyvsp[(7) - (11)].strval));
                              free((yyvsp[(5) - (11)].strval)); free((yyvsp[(7) - (11)].strval)); ;}
    break;

  case 148:

/* Line 1455 of yacc.c  */
#line 703 "lpmysql.y"
    { emit("CREATESELECT %d %d 0 %s.%s", (yyvsp[(2) - (8)].intval), (yyvsp[(4) - (8)].intval), (yyvsp[(5) - (8)].strval), (yyvsp[(7) - (8)].strval));
                          free((yyvsp[(5) - (8)].strval)); free((yyvsp[(7) - (8)].strval)); ;}
    break;

  case 149:

/* Line 1455 of yacc.c  */
#line 707 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 150:

/* Line 1455 of yacc.c  */
#line 708 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 151:

/* Line 1455 of yacc.c  */
#line 711 "lpmysql.y"
    { emit("STARTCOL"); ;}
    break;

  case 152:

/* Line 1455 of yacc.c  */
#line 712 "lpmysql.y"
    { emit("COLUMNDEF %d %s", (yyvsp[(3) - (4)].intval), (yyvsp[(2) - (4)].strval)); free((yyvsp[(2) - (4)].strval)); ;}
    break;

  case 153:

/* Line 1455 of yacc.c  */
#line 714 "lpmysql.y"
    { emit("PRIKEY %d", (yyvsp[(4) - (5)].intval)); ;}
    break;

  case 154:

/* Line 1455 of yacc.c  */
#line 715 "lpmysql.y"
    { emit("KEY %d", (yyvsp[(3) - (4)].intval)); ;}
    break;

  case 155:

/* Line 1455 of yacc.c  */
#line 716 "lpmysql.y"
    { emit("KEY %d", (yyvsp[(3) - (4)].intval)); ;}
    break;

  case 156:

/* Line 1455 of yacc.c  */
#line 717 "lpmysql.y"
    { emit("TEXTINDEX %d", (yyvsp[(4) - (5)].intval)); ;}
    break;

  case 157:

/* Line 1455 of yacc.c  */
#line 718 "lpmysql.y"
    { emit("TEXTINDEX %d", (yyvsp[(4) - (5)].intval)); ;}
    break;

  case 158:

/* Line 1455 of yacc.c  */
#line 721 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 159:

/* Line 1455 of yacc.c  */
#line 722 "lpmysql.y"
    { emit("ATTR NOTNULL"); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 161:

/* Line 1455 of yacc.c  */
#line 724 "lpmysql.y"
    { emit("ATTR DEFAULT STRING %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 162:

/* Line 1455 of yacc.c  */
#line 725 "lpmysql.y"
    { emit("ATTR DEFAULT NUMBER %d", (yyvsp[(3) - (3)].intval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 163:

/* Line 1455 of yacc.c  */
#line 726 "lpmysql.y"
    { emit("ATTR DEFAULT FLOAT %g", (yyvsp[(3) - (3)].floatval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 164:

/* Line 1455 of yacc.c  */
#line 727 "lpmysql.y"
    { emit("ATTR DEFAULT BOOL %d", (yyvsp[(3) - (3)].intval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 165:

/* Line 1455 of yacc.c  */
#line 728 "lpmysql.y"
    { emit("ATTR AUTOINC"); (yyval.intval) = (yyvsp[(1) - (2)].intval) + 1; ;}
    break;

  case 166:

/* Line 1455 of yacc.c  */
#line 729 "lpmysql.y"
    { emit("ATTR UNIQUEKEY %d", (yyvsp[(4) - (5)].intval)); (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; ;}
    break;

  case 167:

/* Line 1455 of yacc.c  */
#line 730 "lpmysql.y"
    { emit("ATTR UNIQUEKEY"); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 168:

/* Line 1455 of yacc.c  */
#line 731 "lpmysql.y"
    { emit("ATTR PRIKEY"); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 169:

/* Line 1455 of yacc.c  */
#line 732 "lpmysql.y"
    { emit("ATTR PRIKEY"); (yyval.intval) = (yyvsp[(1) - (2)].intval) + 1; ;}
    break;

  case 170:

/* Line 1455 of yacc.c  */
#line 733 "lpmysql.y"
    { emit("ATTR COMMENT %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 171:

/* Line 1455 of yacc.c  */
#line 736 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 172:

/* Line 1455 of yacc.c  */
#line 737 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(2) - (3)].intval); ;}
    break;

  case 173:

/* Line 1455 of yacc.c  */
#line 738 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(2) - (5)].intval) + 1000*(yyvsp[(4) - (5)].intval); ;}
    break;

  case 174:

/* Line 1455 of yacc.c  */
#line 741 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 175:

/* Line 1455 of yacc.c  */
#line 742 "lpmysql.y"
    { (yyval.intval) = 4000; ;}
    break;

  case 176:

/* Line 1455 of yacc.c  */
#line 745 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 177:

/* Line 1455 of yacc.c  */
#line 746 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 1000; ;}
    break;

  case 178:

/* Line 1455 of yacc.c  */
#line 747 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 2000; ;}
    break;

  case 180:

/* Line 1455 of yacc.c  */
#line 751 "lpmysql.y"
    { emit("COLCHARSET %s", (yyvsp[(4) - (4)].strval)); free((yyvsp[(4) - (4)].strval)); ;}
    break;

  case 181:

/* Line 1455 of yacc.c  */
#line 752 "lpmysql.y"
    { emit("COLCOLLATE %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); ;}
    break;

  case 182:

/* Line 1455 of yacc.c  */
#line 756 "lpmysql.y"
    { (yyval.intval) = 10000 + (yyvsp[(2) - (2)].intval); ;}
    break;

  case 183:

/* Line 1455 of yacc.c  */
#line 757 "lpmysql.y"
    { (yyval.intval) = 10000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 184:

/* Line 1455 of yacc.c  */
#line 758 "lpmysql.y"
    { (yyval.intval) = 20000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 185:

/* Line 1455 of yacc.c  */
#line 759 "lpmysql.y"
    { (yyval.intval) = 30000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 186:

/* Line 1455 of yacc.c  */
#line 760 "lpmysql.y"
    { (yyval.intval) = 40000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 187:

/* Line 1455 of yacc.c  */
#line 761 "lpmysql.y"
    { (yyval.intval) = 50000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 188:

/* Line 1455 of yacc.c  */
#line 762 "lpmysql.y"
    { (yyval.intval) = 60000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 189:

/* Line 1455 of yacc.c  */
#line 763 "lpmysql.y"
    { (yyval.intval) = 70000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 190:

/* Line 1455 of yacc.c  */
#line 764 "lpmysql.y"
    { (yyval.intval) = 80000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 191:

/* Line 1455 of yacc.c  */
#line 765 "lpmysql.y"
    { (yyval.intval) = 90000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 192:

/* Line 1455 of yacc.c  */
#line 766 "lpmysql.y"
    { (yyval.intval) = 110000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 193:

/* Line 1455 of yacc.c  */
#line 767 "lpmysql.y"
    { (yyval.intval) = 100001; ;}
    break;

  case 194:

/* Line 1455 of yacc.c  */
#line 768 "lpmysql.y"
    { (yyval.intval) = 100002; ;}
    break;

  case 195:

/* Line 1455 of yacc.c  */
#line 769 "lpmysql.y"
    { (yyval.intval) = 100003; ;}
    break;

  case 196:

/* Line 1455 of yacc.c  */
#line 770 "lpmysql.y"
    { (yyval.intval) = 100004; ;}
    break;

  case 197:

/* Line 1455 of yacc.c  */
#line 771 "lpmysql.y"
    { (yyval.intval) = 100005; ;}
    break;

  case 198:

/* Line 1455 of yacc.c  */
#line 772 "lpmysql.y"
    { (yyval.intval) = 120000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 199:

/* Line 1455 of yacc.c  */
#line 773 "lpmysql.y"
    { (yyval.intval) = 130000 + (yyvsp[(3) - (5)].intval); ;}
    break;

  case 200:

/* Line 1455 of yacc.c  */
#line 774 "lpmysql.y"
    { (yyval.intval) = 140000 + (yyvsp[(2) - (2)].intval); ;}
    break;

  case 201:

/* Line 1455 of yacc.c  */
#line 775 "lpmysql.y"
    { (yyval.intval) = 150000 + (yyvsp[(3) - (4)].intval); ;}
    break;

  case 202:

/* Line 1455 of yacc.c  */
#line 776 "lpmysql.y"
    { (yyval.intval) = 160001; ;}
    break;

  case 203:

/* Line 1455 of yacc.c  */
#line 777 "lpmysql.y"
    { (yyval.intval) = 160002; ;}
    break;

  case 204:

/* Line 1455 of yacc.c  */
#line 778 "lpmysql.y"
    { (yyval.intval) = 160003; ;}
    break;

  case 205:

/* Line 1455 of yacc.c  */
#line 779 "lpmysql.y"
    { (yyval.intval) = 160004; ;}
    break;

  case 206:

/* Line 1455 of yacc.c  */
#line 780 "lpmysql.y"
    { (yyval.intval) = 170000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 207:

/* Line 1455 of yacc.c  */
#line 781 "lpmysql.y"
    { (yyval.intval) = 171000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 208:

/* Line 1455 of yacc.c  */
#line 782 "lpmysql.y"
    { (yyval.intval) = 172000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 209:

/* Line 1455 of yacc.c  */
#line 783 "lpmysql.y"
    { (yyval.intval) = 173000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 210:

/* Line 1455 of yacc.c  */
#line 784 "lpmysql.y"
    { (yyval.intval) = 200000 + (yyvsp[(3) - (5)].intval); ;}
    break;

  case 211:

/* Line 1455 of yacc.c  */
#line 785 "lpmysql.y"
    { (yyval.intval) = 210000 + (yyvsp[(3) - (5)].intval); ;}
    break;

  case 212:

/* Line 1455 of yacc.c  */
#line 788 "lpmysql.y"
    { emit("ENUMVAL %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); (yyval.intval) = 1; ;}
    break;

  case 213:

/* Line 1455 of yacc.c  */
#line 789 "lpmysql.y"
    { emit("ENUMVAL %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 214:

/* Line 1455 of yacc.c  */
#line 792 "lpmysql.y"
    { emit("CREATESELECT %d", (yyvsp[(1) - (3)].intval)) ;}
    break;

  case 215:

/* Line 1455 of yacc.c  */
#line 795 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 216:

/* Line 1455 of yacc.c  */
#line 796 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 217:

/* Line 1455 of yacc.c  */
#line 797 "lpmysql.y"
    { (yyval.intval) = 2; ;}
    break;

  case 218:

/* Line 1455 of yacc.c  */
#line 800 "lpmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 219:

/* Line 1455 of yacc.c  */
#line 801 "lpmysql.y"
    { (yyval.intval) = 1;;}
    break;

  case 220:

/* Line 1455 of yacc.c  */
#line 806 "lpmysql.y"
    { emit("STMT"); ;}
    break;

  case 224:

/* Line 1455 of yacc.c  */
#line 814 "lpmysql.y"
    { if ((yyvsp[(2) - (3)].subtok) != 4) { lyyerror((yylsp[(2) - (3)]),"bad set to @%s", (yyvsp[(1) - (3)].strval)); YYERROR; }
		 emit("SET %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); ;}
    break;

  case 225:

/* Line 1455 of yacc.c  */
#line 816 "lpmysql.y"
    { emit("SET %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); ;}
    break;

  case 226:

/* Line 1455 of yacc.c  */
#line 821 "lpmysql.y"
    { emit("NAME %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 227:

/* Line 1455 of yacc.c  */
#line 822 "lpmysql.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 228:

/* Line 1455 of yacc.c  */
#line 823 "lpmysql.y"
    { emit("FIELDNAME %s.%s", (yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); ;}
    break;

  case 229:

/* Line 1455 of yacc.c  */
#line 824 "lpmysql.y"
    { emit("STRING %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 230:

/* Line 1455 of yacc.c  */
#line 825 "lpmysql.y"
    { emit("NUMBER %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 231:

/* Line 1455 of yacc.c  */
#line 826 "lpmysql.y"
    { emit("FLOAT %g", (yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 232:

/* Line 1455 of yacc.c  */
#line 827 "lpmysql.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 233:

/* Line 1455 of yacc.c  */
#line 830 "lpmysql.y"
    { emit("ADD"); ;}
    break;

  case 234:

/* Line 1455 of yacc.c  */
#line 831 "lpmysql.y"
    { emit("SUB"); ;}
    break;

  case 235:

/* Line 1455 of yacc.c  */
#line 832 "lpmysql.y"
    { emit("MUL"); ;}
    break;

  case 236:

/* Line 1455 of yacc.c  */
#line 833 "lpmysql.y"
    { emit("DIV"); ;}
    break;

  case 237:

/* Line 1455 of yacc.c  */
#line 834 "lpmysql.y"
    { emit("MOD"); ;}
    break;

  case 238:

/* Line 1455 of yacc.c  */
#line 835 "lpmysql.y"
    { emit("MOD"); ;}
    break;

  case 239:

/* Line 1455 of yacc.c  */
#line 836 "lpmysql.y"
    { emit("NEG"); ;}
    break;

  case 240:

/* Line 1455 of yacc.c  */
#line 837 "lpmysql.y"
    { emit("AND"); ;}
    break;

  case 241:

/* Line 1455 of yacc.c  */
#line 838 "lpmysql.y"
    { emit("OR"); ;}
    break;

  case 242:

/* Line 1455 of yacc.c  */
#line 839 "lpmysql.y"
    { emit("XOR"); ;}
    break;

  case 243:

/* Line 1455 of yacc.c  */
#line 840 "lpmysql.y"
    { emit("CMP %d", (yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 244:

/* Line 1455 of yacc.c  */
#line 841 "lpmysql.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 245:

/* Line 1455 of yacc.c  */
#line 842 "lpmysql.y"
    { emit("CMPANYSELECT %d", (yyvsp[(2) - (6)].subtok)); ;}
    break;

  case 246:

/* Line 1455 of yacc.c  */
#line 843 "lpmysql.y"
    { emit("CMPANYSELECT %d", (yyvsp[(2) - (6)].subtok)); ;}
    break;

  case 247:

/* Line 1455 of yacc.c  */
#line 844 "lpmysql.y"
    { emit("CMPALLSELECT %d", (yyvsp[(2) - (6)].subtok)); ;}
    break;

  case 248:

/* Line 1455 of yacc.c  */
#line 845 "lpmysql.y"
    { emit("BITOR"); ;}
    break;

  case 249:

/* Line 1455 of yacc.c  */
#line 846 "lpmysql.y"
    { emit("BITAND"); ;}
    break;

  case 250:

/* Line 1455 of yacc.c  */
#line 847 "lpmysql.y"
    { emit("BITXOR"); ;}
    break;

  case 251:

/* Line 1455 of yacc.c  */
#line 848 "lpmysql.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 252:

/* Line 1455 of yacc.c  */
#line 849 "lpmysql.y"
    { emit("NOT"); ;}
    break;

  case 253:

/* Line 1455 of yacc.c  */
#line 850 "lpmysql.y"
    { emit("NOT"); ;}
    break;

  case 254:

/* Line 1455 of yacc.c  */
#line 851 "lpmysql.y"
    { emit("ASSIGN @%s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); ;}
    break;

  case 255:

/* Line 1455 of yacc.c  */
#line 854 "lpmysql.y"
    { emit("ISNULL"); ;}
    break;

  case 256:

/* Line 1455 of yacc.c  */
#line 855 "lpmysql.y"
    { emit("ISNULL"); emit("NOT"); ;}
    break;

  case 257:

/* Line 1455 of yacc.c  */
#line 856 "lpmysql.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 258:

/* Line 1455 of yacc.c  */
#line 857 "lpmysql.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 259:

/* Line 1455 of yacc.c  */
#line 860 "lpmysql.y"
    { emit("BETWEEN"); ;}
    break;

  case 260:

/* Line 1455 of yacc.c  */
#line 864 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 261:

/* Line 1455 of yacc.c  */
#line 865 "lpmysql.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 262:

/* Line 1455 of yacc.c  */
#line 868 "lpmysql.y"
    { (yyval.intval) = 0 ;}
    break;

  case 264:

/* Line 1455 of yacc.c  */
#line 872 "lpmysql.y"
    { emit("ISIN %d", (yyvsp[(4) - (5)].intval)); ;}
    break;

  case 265:

/* Line 1455 of yacc.c  */
#line 873 "lpmysql.y"
    { emit("ISIN %d", (yyvsp[(5) - (6)].intval)); emit("NOT"); ;}
    break;

  case 266:

/* Line 1455 of yacc.c  */
#line 874 "lpmysql.y"
    { emit("INSELECT"); ;}
    break;

  case 267:

/* Line 1455 of yacc.c  */
#line 875 "lpmysql.y"
    { emit("INSELECT"); emit("NOT"); ;}
    break;

  case 268:

/* Line 1455 of yacc.c  */
#line 876 "lpmysql.y"
    { emit("EXISTS"); if((yyvsp[(1) - (4)].subtok))emit("NOT"); ;}
    break;

  case 269:

/* Line 1455 of yacc.c  */
#line 879 "lpmysql.y"
    {  emit("CALL %d %s", (yyvsp[(3) - (4)].intval), (yyvsp[(1) - (4)].strval)); free((yyvsp[(1) - (4)].strval)); ;}
    break;

  case 270:

/* Line 1455 of yacc.c  */
#line 883 "lpmysql.y"
    { emit("COUNTALL") ;}
    break;

  case 271:

/* Line 1455 of yacc.c  */
#line 884 "lpmysql.y"
    { emit(" CALL 1 COUNT"); ;}
    break;

  case 272:

/* Line 1455 of yacc.c  */
#line 886 "lpmysql.y"
    {  emit("CALL %d SUBSTR", (yyvsp[(3) - (4)].intval));;}
    break;

  case 273:

/* Line 1455 of yacc.c  */
#line 887 "lpmysql.y"
    {  emit("CALL 2 SUBSTR"); ;}
    break;

  case 274:

/* Line 1455 of yacc.c  */
#line 888 "lpmysql.y"
    {  emit("CALL 3 SUBSTR"); ;}
    break;

  case 275:

/* Line 1455 of yacc.c  */
#line 889 "lpmysql.y"
    { emit("CALL %d TRIM", (yyvsp[(3) - (4)].intval)); ;}
    break;

  case 276:

/* Line 1455 of yacc.c  */
#line 890 "lpmysql.y"
    { emit("CALL 3 TRIM"); ;}
    break;

  case 277:

/* Line 1455 of yacc.c  */
#line 893 "lpmysql.y"
    { emit("INT 1"); ;}
    break;

  case 278:

/* Line 1455 of yacc.c  */
#line 894 "lpmysql.y"
    { emit("INT 2"); ;}
    break;

  case 279:

/* Line 1455 of yacc.c  */
#line 895 "lpmysql.y"
    { emit("INT 3"); ;}
    break;

  case 280:

/* Line 1455 of yacc.c  */
#line 898 "lpmysql.y"
    { emit("CALL 3 DATE_ADD"); ;}
    break;

  case 281:

/* Line 1455 of yacc.c  */
#line 899 "lpmysql.y"
    { emit("CALL 3 DATE_SUB"); ;}
    break;

  case 282:

/* Line 1455 of yacc.c  */
#line 902 "lpmysql.y"
    { emit("NUMBER 1"); ;}
    break;

  case 283:

/* Line 1455 of yacc.c  */
#line 903 "lpmysql.y"
    { emit("NUMBER 2"); ;}
    break;

  case 284:

/* Line 1455 of yacc.c  */
#line 904 "lpmysql.y"
    { emit("NUMBER 3"); ;}
    break;

  case 285:

/* Line 1455 of yacc.c  */
#line 905 "lpmysql.y"
    { emit("NUMBER 4"); ;}
    break;

  case 286:

/* Line 1455 of yacc.c  */
#line 906 "lpmysql.y"
    { emit("NUMBER 5"); ;}
    break;

  case 287:

/* Line 1455 of yacc.c  */
#line 907 "lpmysql.y"
    { emit("NUMBER 6"); ;}
    break;

  case 288:

/* Line 1455 of yacc.c  */
#line 908 "lpmysql.y"
    { emit("NUMBER 7"); ;}
    break;

  case 289:

/* Line 1455 of yacc.c  */
#line 909 "lpmysql.y"
    { emit("NUMBER 8"); ;}
    break;

  case 290:

/* Line 1455 of yacc.c  */
#line 910 "lpmysql.y"
    { emit("NUMBER 9"); ;}
    break;

  case 291:

/* Line 1455 of yacc.c  */
#line 913 "lpmysql.y"
    { emit("CASEVAL %d 0", (yyvsp[(3) - (4)].intval)); ;}
    break;

  case 292:

/* Line 1455 of yacc.c  */
#line 914 "lpmysql.y"
    { emit("CASEVAL %d 1", (yyvsp[(3) - (6)].intval)); ;}
    break;

  case 293:

/* Line 1455 of yacc.c  */
#line 915 "lpmysql.y"
    { emit("CASE %d 0", (yyvsp[(2) - (3)].intval)); ;}
    break;

  case 294:

/* Line 1455 of yacc.c  */
#line 916 "lpmysql.y"
    { emit("CASE %d 1", (yyvsp[(2) - (5)].intval)); ;}
    break;

  case 295:

/* Line 1455 of yacc.c  */
#line 919 "lpmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 296:

/* Line 1455 of yacc.c  */
#line 920 "lpmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval)+1; ;}
    break;

  case 297:

/* Line 1455 of yacc.c  */
#line 923 "lpmysql.y"
    { emit("LIKE"); ;}
    break;

  case 298:

/* Line 1455 of yacc.c  */
#line 924 "lpmysql.y"
    { emit("LIKE"); emit("NOT"); ;}
    break;

  case 299:

/* Line 1455 of yacc.c  */
#line 927 "lpmysql.y"
    { emit("REGEXP"); ;}
    break;

  case 300:

/* Line 1455 of yacc.c  */
#line 928 "lpmysql.y"
    { emit("REGEXP"); emit("NOT"); ;}
    break;

  case 301:

/* Line 1455 of yacc.c  */
#line 931 "lpmysql.y"
    { emit("NOW") ;}
    break;

  case 302:

/* Line 1455 of yacc.c  */
#line 932 "lpmysql.y"
    { emit("NOW") ;}
    break;

  case 303:

/* Line 1455 of yacc.c  */
#line 933 "lpmysql.y"
    { emit("NOW") ;}
    break;

  case 304:

/* Line 1455 of yacc.c  */
#line 936 "lpmysql.y"
    { emit("STRTOBIN"); ;}
    break;



/* Line 1455 of yacc.c  */
#line 4441 "lpmysql.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }

  yyerror_range[0] = yylloc;

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval, &yylloc);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  yyerror_range[0] = yylsp[1-yylen];
  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;

      yyerror_range[0] = *yylsp;
      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp, yylsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;

  yyerror_range[1] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, (yyerror_range - 1), 2);
  *++yylsp = yyloc;

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval, &yylloc);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp, yylsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 939 "lpmysql.y"


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
yyerror(char *s, ...)
{
  va_list ap;
  va_start(ap, s);

  if(yylloc.first_line)
    fprintf(stderr, "%s:%d.%d-%d.%d: error: ", yylloc.filename, yylloc.first_line, yylloc.first_column,
	    yylloc.last_line, yylloc.last_column);
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");

}

void
lyyerror(YYLTYPE t, char *s, ...)
{
  va_list ap;
  va_start(ap, s);

  if(t.first_line)
    fprintf(stderr, "%s:%d.%d-%d.%d: error: ", t.filename, t.first_line, t.first_column,
	    t.last_line, t.last_column);
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}

main(int ac, char **av)
{
  extern FILE *yyin;

  if(ac > 1 && !strcmp(av[1], "-d")) {
    yydebug = 1; ac--; av++;
  }

  if(ac > 1) {
    if((yyin = fopen(av[1], "r")) == NULL) {
      perror(av[1]);
      exit(1);
    }
    filename = av[1];
  } else
    filename = "(stdin)";

  if(!yyparse())
    printf("SQL parse worked\n");
  else
    printf("SQL parse failed\n");
} /* main */

