
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
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 10 "pmysql.y"

#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

void yyerror(char *s, ...);
void emit(char *s, ...);


/* Line 189 of yacc.c  */
#line 83 "pmysql.tab.c"

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
#line 20 "pmysql.y"

	int intval;
	double floatval;
	char *strval;
	int subtok;



/* Line 214 of yacc.c  */
#line 367 "pmysql.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 379 "pmysql.tab.c"

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
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

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
#define YYFINAL  31
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1548

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  254
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  74
/* YYNRULES -- Number of rules.  */
#define YYNRULES  300
/* YYNRULES -- Number of states.  */
#define YYNSTATES  620

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
       0,     0,     3,     6,    10,    12,    16,    28,    29,    32,
      33,    38,    41,    46,    47,    49,    51,    52,    55,    56,
      59,    60,    64,    65,    68,    73,    74,    77,    79,    83,
      84,    87,    90,    93,    96,    99,   102,   105,   108,   110,
     114,   116,   119,   121,   125,   127,   129,   133,   139,   143,
     147,   149,   150,   153,   155,   156,   162,   166,   172,   179,
     185,   186,   188,   190,   191,   193,   195,   197,   200,   203,
     204,   206,   207,   210,   215,   222,   229,   236,   237,   240,
     241,   243,   247,   251,   253,   261,   264,   267,   270,   271,
     278,   281,   286,   287,   290,   298,   300,   309,   310,   315,
     316,   319,   322,   325,   328,   330,   331,   332,   336,   340,
     346,   348,   350,   354,   358,   366,   374,   378,   382,   388,
     394,   396,   405,   413,   421,   423,   432,   433,   436,   439,
     443,   449,   455,   463,   465,   470,   475,   476,   479,   481,
     490,   501,   511,   518,   530,   539,   541,   545,   546,   551,
     557,   562,   567,   573,   579,   580,   584,   587,   591,   595,
     599,   603,   606,   612,   616,   620,   623,   627,   628,   632,
     638,   639,   641,   642,   645,   648,   649,   654,   658,   661,
     665,   669,   673,   677,   681,   685,   689,   693,   697,   701,
     703,   705,   707,   709,   711,   715,   721,   724,   729,   731,
     733,   735,   737,   741,   745,   749,   753,   759,   765,   767,
     771,   775,   776,   778,   780,   781,   783,   785,   788,   790,
     794,   798,   802,   804,   806,   810,   812,   814,   816,   818,
     822,   826,   830,   834,   838,   842,   845,   849,   853,   857,
     861,   867,   874,   881,   888,   892,   896,   900,   904,   907,
     910,   914,   918,   923,   927,   932,   938,   940,   944,   945,
     947,   953,   960,   966,   973,   978,   983,   988,   993,   998,
    1005,  1014,  1019,  1027,  1029,  1031,  1033,  1040,  1047,  1051,
    1055,  1059,  1063,  1067,  1071,  1075,  1079,  1083,  1088,  1095,
    1099,  1105,  1110,  1116,  1120,  1125,  1129,  1134,  1136,  1138,
    1140
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
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
     157,   128,   225,   298,    -1,    -1,   293,   144,    -1,   293,
      79,    -1,   293,   110,    -1,   293,   115,    -1,   125,    -1,
      -1,    -1,   252,   267,   253,    -1,   252,   297,   253,    -1,
     296,   250,   252,   297,   253,    -1,   322,    -1,    78,    -1,
     297,   250,   322,    -1,   297,   250,    78,    -1,   121,   293,
     294,     3,   190,   298,   292,    -1,   121,   293,   294,     3,
     295,   257,   292,    -1,     3,    20,   322,    -1,     3,    20,
      78,    -1,   298,   250,     3,    20,   322,    -1,   298,   250,
       3,    20,    78,    -1,   299,    -1,   177,   293,   294,     3,
     295,   232,   296,   292,    -1,   177,   293,   294,     3,   190,
     298,   292,    -1,   177,   293,   294,     3,   295,   257,   292,
      -1,   300,    -1,   225,   301,   271,   190,   302,   258,   264,
     265,    -1,    -1,   293,   144,    -1,   293,   115,    -1,     3,
      20,   322,    -1,     3,   251,     3,    20,   322,    -1,   302,
     250,     3,    20,   322,    -1,   302,   250,     3,   251,     3,
      20,   322,    -1,   303,    -1,    61,    68,   304,     3,    -1,
      61,   184,   304,     3,    -1,    -1,   114,    97,    -1,   305,
      -1,    61,   318,   207,   304,     3,   252,   306,   253,    -1,
      61,   318,   207,   304,     3,   251,     3,   252,   306,   253,
      -1,    61,   318,   207,   304,     3,   252,   306,   253,   316,
      -1,    61,   318,   207,   304,     3,   316,    -1,    61,   318,
     207,   304,     3,   251,     3,   252,   306,   253,   316,    -1,
      61,   318,   207,   304,     3,   251,     3,   316,    -1,   307,
      -1,   306,   250,   307,    -1,    -1,   308,     3,   314,   309,
      -1,   166,   128,   252,   267,   253,    -1,   128,   252,   267,
     253,    -1,   116,   252,   267,   253,    -1,   106,   116,   252,
     267,   253,    -1,   106,   128,   252,   267,   253,    -1,    -1,
     309,    18,   154,    -1,   309,   154,    -1,   309,    78,     4,
      -1,   309,    78,     5,    -1,   309,    78,     7,    -1,   309,
      78,     6,    -1,   309,    40,    -1,   309,   222,   252,   267,
     253,    -1,   309,   222,   128,    -1,   309,   166,   128,    -1,
     309,   128,    -1,   309,    56,     4,    -1,    -1,   252,     5,
     253,    -1,   252,     5,   250,     5,   253,    -1,    -1,    43,
      -1,    -1,   312,   224,    -1,   312,   243,    -1,    -1,   313,
      52,   190,     4,    -1,   313,    54,     4,    -1,    44,   310,
      -1,   215,   310,   312,    -1,   192,   310,   312,    -1,   147,
     310,   312,    -1,   122,   310,   312,    -1,   123,   310,   312,
      -1,    42,   310,   312,    -1,   172,   310,   312,    -1,    87,
     310,   312,    -1,   101,   310,   312,    -1,    76,   310,   312,
      -1,    70,    -1,   212,    -1,   213,    -1,    71,    -1,   241,
      -1,    52,   310,   313,    -1,   234,   252,     5,   253,   313,
      -1,    43,   310,    -1,   233,   252,     5,   253,    -1,   214,
      -1,    45,    -1,   146,    -1,   141,    -1,   216,   311,   313,
      -1,   209,   311,   313,    -1,   148,   311,   313,    -1,   142,
     311,   313,    -1,    95,   252,   315,   253,   313,    -1,   190,
     252,   315,   253,   313,    -1,     4,    -1,   315,   250,     4,
      -1,   317,   274,   257,    -1,    -1,   115,    -1,   177,    -1,
      -1,   208,    -1,   319,    -1,   190,   320,    -1,   321,    -1,
     320,   250,   321,    -1,     8,    20,   322,    -1,     8,     9,
     322,    -1,     3,    -1,     8,    -1,     3,   251,     3,    -1,
       4,    -1,     5,    -1,     7,    -1,     6,    -1,   322,    24,
     322,    -1,   322,    25,   322,    -1,   322,    26,   322,    -1,
     322,    27,   322,    -1,   322,    28,   322,    -1,   322,    29,
     322,    -1,    25,   322,    -1,   322,    12,   322,    -1,   322,
      10,   322,    -1,   322,    11,   322,    -1,   322,    20,   322,
      -1,   322,    20,   252,   257,   253,    -1,   322,    20,    37,
     252,   257,   253,    -1,   322,    20,   193,   252,   257,   253,
      -1,   322,    20,    33,   252,   257,   253,    -1,   322,    21,
     322,    -1,   322,    22,   322,    -1,   322,    30,   322,    -1,
     322,    23,   322,    -1,    18,   322,    -1,    17,   322,    -1,
       8,     9,   322,    -1,   322,    15,   154,    -1,   322,    15,
      18,   154,    -1,   322,    15,     6,    -1,   322,    15,    18,
       6,    -1,   322,    19,   322,    36,   322,    -1,   322,    -1,
     322,   250,   323,    -1,    -1,   323,    -1,   322,    16,   252,
     323,   253,    -1,   322,    18,    16,   252,   323,   253,    -1,
     322,    16,   252,   257,   253,    -1,   322,    18,    16,   252,
     257,   253,    -1,    97,   252,   257,   253,    -1,     3,   252,
     324,   253,    -1,   248,   252,    26,   253,    -1,   248,   252,
     322,   253,    -1,   244,   252,   323,   253,    -1,   244,   252,
     322,   105,   322,   253,    -1,   244,   252,   322,   105,   322,
     102,   322,   253,    -1,   245,   252,   323,   253,    -1,   245,
     252,   325,   322,   105,   323,   253,    -1,   131,    -1,   218,
      -1,    46,    -1,   246,   252,   322,   250,   326,   253,    -1,
     247,   252,   322,   250,   326,   253,    -1,   124,   322,    72,
      -1,   124,   322,    73,    -1,   124,   322,    74,    -1,   124,
     322,    75,    -1,   124,   322,   242,    -1,   124,   322,   241,
      -1,   124,   322,   111,    -1,   124,   322,   112,    -1,   124,
     322,   113,    -1,    50,   322,   327,    94,    -1,    50,   322,
     327,    91,   322,    94,    -1,    50,   327,    94,    -1,    50,
     327,    91,   322,    94,    -1,   236,   322,   211,   322,    -1,
     327,   236,   322,   211,   322,    -1,   322,    14,   322,    -1,
     322,    18,    14,   322,    -1,   322,    13,   322,    -1,   322,
      18,    13,   322,    -1,    65,    -1,    63,    -1,    64,    -1,
      43,   322,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   301,   301,   302,   307,   310,   312,   318,   319,   321,
     322,   326,   328,   332,   333,   334,   337,   338,   341,   341,
     343,   343,   346,   346,   347,   350,   351,   354,   355,   358,
     359,   360,   361,   362,   363,   364,   365,   366,   369,   370,
     371,   374,   376,   377,   380,   381,   385,   386,   388,   389,
     392,   393,   396,   397,   398,   402,   404,   406,   408,   410,
     414,   415,   416,   419,   420,   423,   424,   427,   428,   429,
     432,   432,   435,   436,   440,   442,   444,   446,   449,   450,
     453,   454,   457,   462,   465,   470,   471,   472,   473,   476,
     481,   482,   486,   486,   488,   496,   499,   505,   506,   509,
     510,   511,   512,   513,   516,   516,   519,   520,   523,   524,
     527,   528,   529,   530,   533,   539,   545,   548,   551,   554,
     560,   563,   569,   575,   581,   584,   591,   592,   593,   597,
     600,   603,   606,   614,   618,   619,   622,   623,   629,   632,
     636,   641,   646,   650,   656,   661,   662,   665,   665,   668,
     669,   670,   671,   672,   675,   676,   677,   678,   679,   680,
     681,   682,   683,   684,   685,   686,   687,   690,   691,   692,
     695,   696,   699,   700,   701,   704,   705,   706,   710,   711,
     712,   713,   714,   715,   716,   717,   718,   719,   720,   721,
     722,   723,   724,   725,   726,   727,   728,   729,   730,   731,
     732,   733,   734,   735,   736,   737,   738,   739,   742,   743,
     746,   749,   750,   751,   754,   755,   760,   763,   765,   765,
     768,   770,   775,   776,   777,   778,   779,   780,   781,   784,
     785,   786,   787,   788,   789,   790,   791,   792,   793,   794,
     795,   796,   797,   798,   799,   800,   801,   802,   803,   804,
     805,   808,   809,   810,   811,   814,   818,   819,   822,   823,
     826,   827,   828,   829,   830,   833,   837,   838,   840,   841,
     842,   843,   844,   847,   848,   849,   852,   853,   856,   857,
     858,   859,   860,   861,   862,   863,   864,   867,   868,   869,
     870,   873,   874,   877,   878,   881,   882,   885,   886,   887,
     890
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
     322,   322,   322,   325,   325,   325,   322,   322,   326,   326,
     326,   326,   326,   326,   326,   326,   326,   322,   322,   322,
     322,   327,   327,   322,   322,   322,   322,   322,   322,   322,
     322
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
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
       2,     4,     0,     2,     7,     1,     8,     0,     4,     0,
       2,     2,     2,     2,     1,     0,     0,     3,     3,     5,
       1,     1,     3,     3,     7,     7,     3,     3,     5,     5,
       1,     8,     7,     7,     1,     8,     0,     2,     2,     3,
       5,     5,     7,     1,     4,     4,     0,     2,     1,     8,
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
       5,     6,     5,     6,     4,     4,     4,     4,     4,     6,
       8,     4,     7,     1,     1,     1,     6,     6,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     4,     6,     3,
       5,     4,     5,     3,     4,     3,     4,     1,     1,     1,
       2
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
       0,   214,    88,    99,    99,    29,     0,    99,     0,     0,
       4,    83,    95,   120,   124,   133,   138,   216,   136,   136,
     215,     0,     0,   105,   105,     0,     0,   217,   218,     0,
       0,     1,     0,     2,     0,     0,     0,   136,    92,     0,
      87,    85,    86,     0,   101,   102,   103,   104,   100,     0,
       0,   222,   225,   226,   228,   227,   223,     0,     0,     0,
      40,    30,     0,     0,   298,   299,   297,    31,    32,     0,
      33,    36,    37,    35,    34,     0,     0,     0,     0,     0,
       5,    38,    54,     0,     0,     0,   103,   100,    54,     0,
       0,    42,    44,    45,    51,     3,   137,   134,   135,     0,
       0,    90,     7,     0,     0,     0,   106,   106,     0,   258,
       0,   249,   248,   235,   300,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    53,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    41,   221,
     220,   219,     0,    77,     0,     0,     0,     0,    62,    61,
      65,    69,    66,     0,     0,    63,    50,     0,   211,    93,
       0,    20,     0,     7,    92,     0,     0,     0,     0,     0,
     224,   256,   259,     0,   250,     0,     0,     0,   289,     0,
       0,   256,     0,   275,   273,   274,     0,     0,     0,     0,
       0,     0,     7,    39,   237,   238,   236,   295,   293,   253,
       0,   251,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   239,   244,   245,   247,   229,   230,   231,   232,   233,
     234,   246,    52,    54,     0,     0,     0,    46,    82,    49,
       0,     7,    43,    63,    63,     0,    56,     0,    64,     0,
      48,   212,   213,     0,   147,   142,    51,     8,     0,    22,
       7,    89,    91,     0,    97,    27,     0,     0,    97,    97,
       0,    97,     0,   265,     0,     0,   287,     0,     0,   264,
       0,   268,   271,     0,     0,     0,   266,   267,     9,   254,
     252,     0,     0,   296,   294,     0,     0,     0,     0,     0,
       0,    77,    79,    79,    79,     0,     0,     0,    20,    67,
      68,     0,     0,    71,     0,   211,     0,     0,     0,     0,
       0,   145,     0,     0,     0,     0,    84,    94,     0,     0,
       0,   114,     0,   107,     0,    97,   115,   122,    97,   123,
     257,   291,     0,   290,     0,     0,     0,     0,     0,     0,
       0,    18,   262,   260,     0,     0,   255,     0,     0,     0,
     240,    47,     0,     0,     0,     0,   129,     0,     0,    22,
      59,    57,     0,     0,    55,    70,     0,   147,   144,     0,
       0,     0,     0,     0,   147,   211,     0,   210,    21,    13,
      23,   117,   116,     0,     0,    28,   111,     0,   110,     0,
      96,   121,   288,   292,     0,   269,     0,     0,   276,   277,
       0,     0,    20,   263,   261,   243,   241,   242,    78,     0,
       0,     0,     0,     0,     0,   125,    72,     0,    58,     0,
       0,     0,     0,     0,     0,   146,   141,   167,   167,   167,
     199,   167,   189,   192,   167,   167,     0,   167,   167,   167,
     201,   170,   200,   167,   170,   167,     0,   167,   170,   190,
     191,   198,   167,   170,     0,     0,   193,   154,     0,    14,
      15,    11,     0,     0,     0,     0,   108,     0,     0,   272,
     278,   279,   280,   281,   284,   285,   286,   283,   282,    16,
      19,    22,    80,     0,     0,     0,   130,   131,     0,     0,
     211,     0,     0,   151,   150,     0,     0,   172,   196,   178,
     175,   172,   172,     0,   172,   172,   172,   171,   175,   172,
     175,   172,     0,   172,   175,   172,   175,     0,     0,   148,
      13,    24,    98,   119,   118,   113,   112,     0,   270,     0,
      10,    25,     0,    76,    75,    74,     0,    73,   143,   152,
     153,   149,     0,   184,   194,   188,   186,   208,     0,   187,
     182,   183,   205,   181,   204,   185,     0,   180,   203,   179,
     202,     0,     0,     0,   161,     0,     0,   165,   156,     0,
       0,    12,   109,    17,     0,     6,    81,   132,     0,   168,
     173,   174,     0,     0,     0,   175,   175,   197,   175,   155,
     166,   157,   158,   160,   159,   164,   163,     0,    26,     0,
       0,   177,   209,   206,   207,   195,     0,   169,   176,   162
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     8,     9,    10,   171,   351,   388,   471,   540,   412,
     259,   326,   585,   266,    25,    80,    81,    90,    91,    92,
     167,   148,    93,   164,   249,   165,   245,   374,   375,   237,
     363,   493,    94,    11,    22,    43,   101,    12,   331,    23,
      49,   177,   335,   397,   264,    13,    14,    30,   241,    15,
      35,    16,   320,   321,   322,   529,   507,   518,   553,   554,
     467,   558,   255,   256,    21,    17,    27,    28,   181,   182,
     183,   197,   348,   117
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -470
static const yytype_int16 yypact[] =
{
      96,   -38,  -470,  -470,  -470,  -470,    52,     0,   964,  -237,
    -470,  -470,  -470,  -470,  -470,  -470,  -470,  -470,    17,    17,
    -470,   -57,   243,   239,   239,   307,   252,   -96,  -470,   187,
       1,  -470,   -74,  -470,   147,   255,   271,    17,    47,   305,
    -470,  -470,  -470,   -99,  -470,  -470,  -470,  -470,  -470,   317,
     323,   -33,  -470,  -470,  -470,  -470,   319,   571,   571,   571,
    -470,  -470,   571,   403,  -470,  -470,  -470,  -470,  -470,   121,
    -470,  -470,  -470,  -470,  -470,   128,   148,   153,   162,   166,
     -91,  -470,  1497,   571,   571,    52,     2,     4,     6,    -1,
    -164,   362,  -470,  -470,   298,  -470,  -470,  -470,  -470,   392,
     393,  -470,   101,    19,     1,   422,  -122,   -49,   426,   571,
     571,   869,   869,  -470,  -470,   571,  1008,   -55,   244,   571,
     338,   571,   571,   453,     1,   571,  -470,   571,   571,   571,
     571,   571,     7,   202,   268,   571,   130,   571,   571,   571,
     571,   571,   571,   571,   571,   571,   571,   433,  -470,  1518,
    1518,  -470,   437,   -95,   211,    25,   452,     1,  -470,  -470,
    -470,   -83,  -470,     1,   370,   342,  -470,   503,   -69,  -470,
     571,   350,     1,  -209,    47,   512,   517,  -131,   512,   -48,
    -470,   836,  -470,   294,  1518,  1098,   -46,   571,  -470,   571,
     304,   815,   311,  -470,  -470,  -470,   312,   571,   857,   925,
     314,   186,  -209,  -470,  1183,  1027,  1053,  1232,  1232,  -470,
      12,  -470,   469,   571,   571,   318,  1468,   329,   335,   340,
     244,   501,   513,   783,   616,   339,   339,   539,   539,   539,
     539,  -470,  -470,   120,   443,   462,   463,  -470,  -470,  -470,
     -10,   -72,   362,   342,   342,   466,   438,     1,  -470,   468,
    -470,  -470,  -470,   594,   316,  -470,   298,  1518,   554,   472,
    -209,  -470,  -470,   588,  -128,  -470,    41,   358,   455,  -128,
     358,   455,   571,  -470,   571,   571,  -470,  1391,  1158,  -470,
     571,  -470,  -470,  1303,   491,   491,  -470,  -470,   508,  -470,
    -470,   364,   384,  1232,  1232,   469,   571,   244,   244,   244,
     385,   -95,   551,   551,   551,   571,   651,   652,   350,  -470,
    -470,     1,   571,  -104,     1,   -84,    63,   405,   406,   531,
      77,  -470,   657,   244,   571,   571,  -470,  -470,   555,   533,
     666,  -470,   667,  -470,   659,  -110,  -470,  -470,  -110,  -470,
    -470,  1518,  1412,  -470,   571,    51,   571,   571,   418,   419,
     626,   565,  -470,  -470,   425,   427,   602,   428,   429,   430,
    -470,  -470,   548,   434,   435,   436,  1518,   665,    -9,   472,
    -470,  1518,   571,   444,  -470,  -470,  -104,   316,  -470,   454,
     456,   517,   517,   458,   316,   -93,  1148,  -470,   445,  1433,
     966,  -470,  1518,   480,   687,  -470,  -470,    84,  1518,   460,
    -470,  -470,  -470,  1518,   571,  -470,   465,   987,  -470,  -470,
     571,   571,   350,  -470,  -470,  -470,  -470,  -470,  -470,   676,
     676,   676,   571,   571,   716,  -470,  1518,   517,  -470,   143,
     517,   517,   163,   173,   517,  -470,  -470,   473,   473,   473,
    -470,   473,  -470,  -470,   473,   473,   474,   473,   473,   473,
    -470,   677,  -470,   473,   677,   473,   475,   473,   677,  -470,
    -470,  -470,   473,   677,   476,   487,  -470,  -470,   571,  -470,
    -470,  -470,   571,   512,   686,   727,  -470,   659,   210,  -470,
    -470,  -470,  -470,  -470,  -470,  -470,  -470,  -470,  -470,    26,
    1518,   472,  -470,   180,   184,   188,  1518,  1518,   701,   192,
      10,   198,   212,  -470,  -470,   231,   733,  -470,  -470,  -470,
    -470,  -470,  -470,   736,  -470,  -470,  -470,  -470,  -470,  -470,
    -470,  -470,   736,  -470,  -470,  -470,  -470,   737,   738,   261,
    1433,  1518,   496,  -470,  1518,  -470,  1518,   235,  -470,   558,
    -470,   622,   745,  -470,  -470,  -470,   571,  -470,  -470,  -470,
    -470,  -470,   248,  -203,    35,  -203,  -203,  -470,   249,  -203,
    -203,  -203,    35,  -203,    35,  -203,   254,  -203,    35,  -203,
      35,   500,   502,   600,  -470,   753,   486,  -470,  -470,   630,
    -109,  -470,  -470,  -470,   517,  -470,  -470,  1518,   754,  -470,
    -470,  -470,   570,   757,   758,  -470,  -470,  -470,  -470,  -470,
    -470,  -470,  -470,  -470,  -470,  -470,  -470,   517,   519,   510,
     763,  -470,  -470,    35,    35,    35,   295,  -470,  -470,  -470
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -470,  -470,   765,   -35,    75,  -470,   368,   251,  -470,  -470,
    -284,  -342,  -470,  -339,  -470,  -470,   654,   181,   628,  -140,
     530,   -73,  -470,  -470,    46,  -470,  -470,  -470,   411,   492,
       3,   -60,  -470,  -470,  -470,   749,   620,  -470,    24,   542,
     771,   689,   527,   321,  -177,  -470,  -470,  -470,  -470,  -470,
      16,  -470,   446,   420,  -470,  -470,   327,   -64,    88,  -469,
    -470,   292,  -233,  -470,  -470,  -470,  -470,   735,   -25,  -103,
    -470,  -470,   536,   706
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -141
static const yytype_int16 yytable[] =
{
      82,   269,    88,  -126,    88,  -128,   104,  -127,   234,   126,
     305,   423,    33,   209,   124,   153,   192,   196,   289,   606,
     235,   590,   251,   246,   369,   210,   156,   425,   170,   329,
      18,   251,   111,   112,   113,    36,   187,   114,   116,   188,
     591,   157,   432,   433,   147,   275,   251,   329,   276,   562,
     243,   564,   372,    99,   154,   568,     5,   570,   149,   150,
      26,   127,   128,   129,   130,   131,   132,   133,   175,   134,
     135,   136,   137,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   378,   190,   252,   184,   157,   592,   499,   593,
     185,   501,   502,   252,   191,   505,   198,   199,   201,   244,
      82,   267,   204,   205,   206,   207,   208,   313,   252,   292,
     216,   221,   222,   223,   224,   225,   226,   227,   228,   229,
     230,   231,   330,   126,   373,   251,   613,   614,   491,   615,
     176,    34,   236,    51,    52,    53,    54,    55,    56,     5,
     399,   178,   268,   607,   271,   257,    19,    57,    58,   541,
      37,   105,   436,   404,    85,    59,  -139,     1,   147,   125,
     301,   211,   277,   217,   278,   170,   290,   218,   377,   340,
      20,   370,   283,    62,   376,    95,     2,   291,   307,   379,
      63,   189,   253,   254,   270,   300,     5,   252,   293,   294,
     189,   380,   355,    64,    65,    66,   127,   128,   129,   130,
     131,   132,   133,   176,   134,   135,   136,   137,   138,   139,
     140,   141,   142,   143,   144,   145,   146,     3,   108,   109,
     127,   128,   129,   130,   131,   132,   133,    69,   134,   135,
     136,   137,   138,   139,   140,   141,   142,   143,   144,   145,
     146,   306,   424,   406,    96,   608,    38,   172,   261,   341,
     342,    89,  -126,    89,  -128,   345,  -127,   152,    97,  -140,
     354,    83,   357,   358,   359,   539,    44,   548,   616,   105,
     155,   356,    84,     4,    98,   157,   468,   288,   239,   573,
     366,   213,   214,     5,   215,   173,     6,   371,   387,   309,
     310,   332,   336,   337,   333,   339,   532,    45,   100,   389,
     390,   574,    86,   392,   405,   202,   364,   365,   102,   398,
      51,    52,    53,    54,    55,    56,   308,   575,    44,   403,
     106,     7,   407,   219,    57,    58,   107,   384,   110,   -92,
     385,    87,    59,    60,   475,   327,   166,   476,   170,   576,
      61,    51,    52,    53,    54,    55,    56,   426,    39,    45,
      62,   -92,   100,   260,    46,    57,    58,    63,    40,   400,
     494,   495,   401,    59,    47,   142,   143,   144,   145,   146,
      64,    65,    66,   118,    75,    76,    77,    78,    79,   478,
     119,    62,   220,    48,   193,   389,   490,    41,    63,   577,
     520,    67,    68,   384,   524,   168,   500,   496,   497,   526,
     120,    64,    65,    66,    69,   121,    51,    52,    53,    54,
      55,    56,    42,   332,   122,   578,   503,    70,   123,   169,
      57,    58,   316,   332,   158,   174,   504,   579,    59,   180,
     542,     5,   317,   543,   542,    69,   232,   544,   542,   287,
     233,   545,   332,   530,   318,   547,    62,   531,   332,   534,
     536,   549,   398,    63,   212,   240,    51,    52,    53,    54,
      55,    56,   332,   538,   238,   550,    64,    65,    66,   194,
      57,    58,    51,    52,    53,    54,    55,    56,    59,   200,
     159,   332,   319,   580,   551,   475,    57,    58,   582,   -60,
     601,   602,   603,   604,    59,   160,    62,   247,   588,   594,
      69,   589,   595,    63,   594,   248,   250,   596,    71,    72,
      73,   258,    62,    74,   161,   263,    64,    65,    66,    63,
     265,   587,   137,   138,   139,   140,   141,   142,   143,   144,
     145,   146,    64,    65,    66,   138,   139,   140,   141,   142,
     143,   144,   145,   146,   162,   332,    24,   273,   619,    29,
      69,    75,    76,    77,    78,    79,   195,   279,    51,    52,
      53,    54,    55,    56,   281,   282,    69,   286,   163,   146,
     295,   302,    57,    58,    51,    52,    53,    54,    55,    56,
      59,   297,    75,    76,    77,    78,    79,   298,    57,    58,
     303,   304,   299,   311,   312,   314,    59,   315,    62,   555,
     556,   324,   559,   560,   561,    63,   325,   563,   328,   565,
     334,   567,   329,   569,    62,   347,   350,   352,    64,    65,
      66,    63,   136,   137,   138,   139,   140,   141,   142,   143,
     144,   145,   146,   391,    64,    65,    66,   353,   360,   115,
     140,   141,   142,   143,   144,   145,   146,    75,    76,    77,
      78,    79,    69,   362,   367,   368,     5,   381,   382,   383,
     386,   393,    51,    52,    53,    54,    55,    56,    69,   394,
     395,   408,   409,   410,   411,   418,    57,    58,   413,   492,
     414,   415,   416,   417,    59,   422,   419,   420,   421,    51,
      52,    53,    54,    55,    56,   468,   427,    75,    76,    77,
      78,    79,    62,    57,    58,   473,   430,   474,   431,    63,
     434,    59,   477,    75,    76,    77,    78,    79,   479,   498,
     517,   546,    64,    65,    66,   506,   513,   522,   527,    62,
      51,    52,    53,    54,    55,    56,    63,   396,   552,   528,
     557,   583,   571,   572,    57,    58,   330,   584,   586,    64,
      65,    66,    59,   597,   599,   598,    69,   600,   605,   609,
     610,   611,   612,   617,   533,   508,   509,   618,   510,   332,
      62,   511,   512,    32,   514,   515,   516,    63,   489,   203,
     519,   581,   521,    69,   523,   242,   323,   428,   103,   525,
      64,    65,    66,   361,   262,    50,   179,   338,   537,    75,
      76,    77,    78,    79,   435,   535,   139,   140,   141,   142,
     143,   144,   145,   146,   566,    75,    76,    77,    78,    79,
     151,   349,   186,   429,    69,   127,   128,   129,   130,   131,
     132,   133,     0,   134,   135,   136,   137,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   127,   128,   129,   130,
     131,   132,   133,     0,   134,   135,   136,   137,   138,   139,
     140,   141,   142,   143,   144,   145,   146,   127,   128,   129,
     130,   131,   132,   133,     0,   134,   135,   136,   137,   138,
     139,   140,   141,   142,   143,   144,   145,   146,   135,   136,
     137,   138,   139,   140,   141,   142,   143,   144,   145,   146,
       0,     0,     0,    75,    76,    77,    78,    79,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     280,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      75,    76,    77,    78,    79,   127,   128,   129,   130,   131,
     132,   133,     0,   134,   135,   136,   137,   138,   139,   140,
     141,   142,   143,   144,   145,   146,     0,     0,     0,     0,
       0,     0,     0,     0,    31,     0,     0,     0,     0,     0,
       0,    75,    76,    77,    78,    79,   127,   128,   129,   130,
     131,   132,   133,     0,   134,   135,   136,   137,   138,   139,
     140,   141,   142,   143,   144,   145,   146,   127,   128,   129,
     130,   131,   132,   133,     0,   134,   135,   136,   137,   138,
     139,   140,   141,   142,   143,   144,   145,   146,   127,   128,
     129,   130,   131,   132,   133,     1,   134,   135,   136,   137,
     138,   139,   140,   141,   142,   143,   144,   145,   146,   129,
     130,   131,   132,   133,     2,   134,   135,   136,   137,   138,
     139,   140,   141,   142,   143,   144,   145,   146,     0,   480,
     481,   482,   483,     0,     0,   272,   130,   131,   132,   133,
       0,   134,   135,   136,   137,   138,   139,   140,   141,   142,
     143,   144,   145,   146,     0,     3,   272,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   484,   485,
     486,     0,     0,     0,     0,     0,     0,   284,   127,   128,
     129,   130,   131,   132,   133,     0,   134,   135,   136,   137,
     138,   139,   140,   141,   142,   143,   144,   145,   146,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     4,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     5,     0,     0,     6,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   127,   128,
     129,   130,   131,   132,   133,   285,   134,   135,   136,   137,
     138,   139,   140,   141,   142,   143,   144,   145,   146,     7,
     437,   438,   439,   440,   128,   129,   130,   131,   132,   133,
     441,   134,   135,   136,   137,   138,   139,   140,   141,   142,
     143,   144,   145,   146,     0,     0,   472,     0,   442,   443,
       0,     0,     0,     0,   444,     0,     0,     0,   487,   488,
       0,     0,     0,     0,     0,   445,     0,     0,     0,     0,
       0,     0,     0,   446,   115,  -141,  -141,  -141,  -141,   447,
     134,   135,   136,   137,   138,   139,   140,   141,   142,   143,
     144,   145,   146,     0,     0,     0,     0,     0,     0,     0,
     448,   449,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   450,
     451,     0,     0,     0,   452,   453,   454,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   274,
       0,     0,     0,   127,   128,   129,   130,   131,   132,   133,
     455,   134,   135,   136,   137,   138,   139,   140,   141,   142,
     143,   144,   145,   146,     0,     0,     0,     0,   456,     0,
     457,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   458,     0,     0,
     459,   460,   461,   462,   463,     0,     0,     0,     0,   344,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   464,   465,     0,     0,     0,     0,     0,     0,   466,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   127,   128,   129,   130,   131,   132,   133,   346,   134,
     135,   136,   137,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   127,   128,   129,   130,   131,   132,   133,     0,
     134,   135,   136,   137,   138,   139,   140,   141,   142,   143,
     144,   145,   146,   127,   128,   129,   130,   131,   132,   133,
       0,   134,   135,   136,   137,   138,   139,   140,   141,   142,
     143,   144,   145,   146,     0,     0,     0,     0,     0,     0,
       0,     0,   469,     0,     0,     0,     0,     0,   127,   128,
     129,   130,   131,   132,   133,   343,   134,   135,   136,   137,
     138,   139,   140,   141,   142,   143,   144,   145,   146,     0,
     126,     0,     0,     0,   296,     0,   402,   127,   128,   129,
     130,   131,   132,   133,   470,   134,   135,   136,   137,   138,
     139,   140,   141,   142,   143,   144,   145,   146,   127,   128,
     129,   130,   131,   132,   133,   147,   134,   135,   136,   137,
     138,   139,   140,   141,   142,   143,   144,   145,   146
};

static const yytype_int16 yycheck[] =
{
      25,   178,     3,     3,     3,     3,   105,     3,   103,     3,
      20,    20,   249,     6,   105,    88,   119,   120,     6,   128,
     115,   224,   115,   163,   308,    18,   190,   369,   237,   157,
      68,   115,    57,    58,    59,    19,    91,    62,    63,    94,
     243,   250,   381,   382,    38,    91,   115,   157,    94,   518,
     133,   520,   156,    37,    89,   524,   187,   526,    83,    84,
       8,    10,    11,    12,    13,    14,    15,    16,   190,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,   315,   118,   177,   110,   250,    52,   427,    54,
     115,   430,   431,   177,   119,   434,   121,   122,   123,   182,
     125,   232,   127,   128,   129,   130,   131,   247,   177,   212,
     135,   136,   137,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   250,     3,   228,   115,   595,   596,   412,   598,
     252,   114,   227,     3,     4,     5,     6,     7,     8,   187,
     250,   190,   177,   252,   179,   170,   184,    17,    18,   491,
     207,   250,   385,   102,   250,    25,   249,    61,    38,   250,
     233,   154,   187,    33,   189,   237,   154,    37,   252,   272,
     208,   311,   197,    43,   314,   249,    80,   212,   250,   116,
      50,   236,   251,   252,   232,   220,   187,   177,   213,   214,
     236,   128,   295,    63,    64,    65,    10,    11,    12,    13,
      14,    15,    16,   252,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,   121,   251,   252,
      10,    11,    12,    13,    14,    15,    16,    97,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,   251,   251,   346,    97,   584,     3,   228,   173,   274,
     275,   252,   252,   252,   252,   280,   252,   251,     3,   249,
     295,     9,   297,   298,   299,   239,    79,   500,   607,   250,
      89,   296,    20,   177,     3,   250,   250,   202,   253,    18,
     305,    13,    14,   187,    16,   104,   190,   312,   323,   243,
     244,   250,   268,   269,   253,   271,   473,   110,   251,   324,
     325,    40,   115,   328,   253,   124,   303,   304,     3,   334,
       3,     4,     5,     6,     7,     8,   241,    56,    79,   344,
       3,   225,   347,   193,    17,    18,     3,   250,     9,   228,
     253,   144,    25,    26,   250,   260,    38,   253,   237,    78,
      33,     3,     4,     5,     6,     7,     8,   372,   105,   110,
      43,   250,   251,   172,   115,    17,    18,    50,   115,   335,
     420,   421,   338,    25,   125,    26,    27,    28,    29,    30,
      63,    64,    65,   252,   244,   245,   246,   247,   248,   404,
     252,    43,   252,   144,    46,   410,   411,   144,    50,   128,
     454,    84,    85,   250,   458,     3,   253,   422,   423,   463,
     252,    63,    64,    65,    97,   252,     3,     4,     5,     6,
       7,     8,   169,   250,   252,   154,   253,   110,   252,    26,
      17,    18,   106,   250,    62,     3,   253,   166,    25,     3,
     250,   187,   116,   253,   250,    97,     3,   253,   250,   253,
       3,   253,   250,   468,   128,   253,    43,   472,   250,   474,
     475,   253,   477,    50,   252,     3,     3,     4,     5,     6,
       7,     8,   250,   253,   253,   253,    63,    64,    65,   131,
      17,    18,     3,     4,     5,     6,     7,     8,    25,    26,
     118,   250,   166,   222,   253,   250,    17,    18,   253,   127,
       4,     5,     6,     7,    25,   133,    43,   127,   250,   250,
      97,   253,   253,    50,   250,   163,     3,   253,   201,   202,
     203,   161,    43,   206,   152,     3,    63,    64,    65,    50,
       3,   546,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    63,    64,    65,    22,    23,    24,    25,    26,
      27,    28,    29,    30,   182,   250,     4,   253,   253,     7,
      97,   244,   245,   246,   247,   248,   218,   253,     3,     4,
       5,     6,     7,     8,   253,   253,    97,   253,   206,    30,
     252,   128,    17,    18,     3,     4,     5,     6,     7,     8,
      25,   252,   244,   245,   246,   247,   248,   252,    17,    18,
     128,   128,   252,   127,   156,   127,    25,     3,    43,   511,
     512,    47,   514,   515,   516,    50,   134,   519,    20,   521,
     252,   523,   157,   525,    43,   124,   108,   253,    63,    64,
      65,    50,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    78,    63,    64,    65,   253,   253,   236,
      24,    25,    26,    27,    28,    29,    30,   244,   245,   246,
     247,   248,    97,   102,     3,     3,   187,   252,   252,   128,
       3,   128,     3,     4,     5,     6,     7,     8,    97,     3,
       3,   253,   253,    47,   109,   127,    17,    18,   253,     3,
     253,   253,   253,   253,    25,    20,   252,   252,   252,     3,
       4,     5,     6,     7,     8,   250,   252,   244,   245,   246,
     247,   248,    43,    17,    18,   225,   252,    20,   252,    50,
     252,    25,   252,   244,   245,   246,   247,   248,   253,     3,
      43,    20,    63,    64,    65,   252,   252,   252,   252,    43,
       3,     4,     5,     6,     7,     8,    50,    78,     5,   252,
       4,   183,     5,     5,    17,    18,   250,   125,     3,    63,
      64,    65,    25,   253,   154,   253,    97,     4,   128,     5,
     190,     4,     4,   253,    78,   438,   439,     4,   441,   250,
      43,   444,   445,     8,   447,   448,   449,    50,   410,   125,
     453,   530,   455,    97,   457,   157,   256,   376,    39,   462,
      63,    64,    65,   301,   174,    24,   107,   270,   477,   244,
     245,   246,   247,   248,   384,    78,    23,    24,    25,    26,
      27,    28,    29,    30,   522,   244,   245,   246,   247,   248,
      85,   285,   116,   377,    97,    10,    11,    12,    13,    14,
      15,    16,    -1,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    10,    11,    12,    13,
      14,    15,    16,    -1,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    10,    11,    12,
      13,    14,    15,    16,    -1,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      -1,    -1,    -1,   244,   245,   246,   247,   248,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     105,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     244,   245,   246,   247,   248,    10,    11,    12,    13,    14,
      15,    16,    -1,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,     0,    -1,    -1,    -1,    -1,    -1,
      -1,   244,   245,   246,   247,   248,    10,    11,    12,    13,
      14,    15,    16,    -1,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    10,    11,    12,
      13,    14,    15,    16,    -1,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    10,    11,
      12,    13,    14,    15,    16,    61,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    12,
      13,    14,    15,    16,    80,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    -1,    72,
      73,    74,    75,    -1,    -1,   250,    13,    14,    15,    16,
      -1,    18,    19,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    -1,   121,   250,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   111,   112,
     113,    -1,    -1,    -1,    -1,    -1,    -1,   250,    10,    11,
      12,    13,    14,    15,    16,    -1,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   177,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   187,    -1,    -1,   190,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    10,    11,
      12,    13,    14,    15,    16,   250,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,   225,
      42,    43,    44,    45,    11,    12,    13,    14,    15,    16,
      52,    18,    19,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    -1,    -1,   250,    -1,    70,    71,
      -1,    -1,    -1,    -1,    76,    -1,    -1,    -1,   241,   242,
      -1,    -1,    -1,    -1,    -1,    87,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    95,   236,    13,    14,    15,    16,   101,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     122,   123,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   141,
     142,    -1,    -1,    -1,   146,   147,   148,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   211,
      -1,    -1,    -1,    10,    11,    12,    13,    14,    15,    16,
     172,    18,    19,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    -1,    -1,    -1,    -1,   190,    -1,
     192,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   209,    -1,    -1,
     212,   213,   214,   215,   216,    -1,    -1,    -1,    -1,   211,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   233,   234,    -1,    -1,    -1,    -1,    -1,    -1,   241,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    10,    11,    12,    13,    14,    15,    16,   105,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    10,    11,    12,    13,    14,    15,    16,    -1,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    10,    11,    12,    13,    14,    15,    16,
      -1,    18,    19,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    39,    -1,    -1,    -1,    -1,    -1,    10,    11,
      12,    13,    14,    15,    16,    94,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    -1,
       3,    -1,    -1,    -1,    36,    -1,    94,    10,    11,    12,
      13,    14,    15,    16,    81,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    10,    11,
      12,    13,    14,    15,    16,    38,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint16 yystos[] =
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
     271,   272,   273,   276,   286,   249,    97,     3,     3,   304,
     251,   290,     3,   289,   105,   250,     3,     3,   251,   252,
       9,   322,   322,   322,   322,   236,   322,   327,   252,   252,
     252,   252,   252,   252,   105,   250,     3,    10,    11,    12,
      13,    14,    15,    16,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    38,   275,   322,
     322,   321,   251,   275,   257,   271,   190,   250,    62,   118,
     133,   152,   182,   206,   277,   279,    38,   274,     3,    26,
     237,   258,   228,   271,     3,   190,   252,   295,   190,   295,
       3,   322,   323,   324,   322,   322,   327,    91,    94,   236,
     257,   322,   323,    46,   131,   218,   323,   325,   322,   322,
      26,   322,   271,   270,   322,   322,   322,   322,   322,     6,
      18,   154,   252,    13,    14,    16,   322,    33,    37,   193,
     252,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,     3,     3,   103,   115,   227,   283,   253,   253,
       3,   302,   272,   133,   182,   280,   273,   127,   163,   278,
       3,   115,   177,   251,   252,   316,   317,   322,   161,   264,
     271,   258,   290,     3,   298,     3,   267,   232,   257,   298,
     232,   257,   250,   253,   211,    91,    94,   322,   322,   253,
     105,   253,   253,   322,   250,   250,   253,   253,   258,     6,
     154,   257,   323,   322,   322,   252,    36,   252,   252,   252,
     257,   275,   128,   128,   128,    20,   251,   250,   258,   278,
     278,   127,   156,   273,   127,     3,   106,   116,   128,   166,
     306,   307,   308,   274,    47,   134,   265,   258,    20,   157,
     250,   292,   250,   253,   252,   296,   292,   292,   296,   292,
     323,   322,   322,    94,   211,   322,   105,   124,   326,   326,
     108,   259,   253,   253,   257,   323,   322,   257,   257,   257,
     253,   283,   102,   284,   284,   284,   322,     3,     3,   264,
     273,   322,   156,   228,   281,   282,   273,   252,   316,   116,
     128,   252,   252,   128,   250,   253,     3,   257,   260,   322,
     322,    78,   322,   128,     3,     3,    78,   297,   322,   250,
     292,   292,    94,   322,   102,   253,   323,   322,   253,   253,
      47,   109,   263,   253,   253,   253,   253,   253,   127,   252,
     252,   252,    20,    20,   251,   265,   322,   252,   282,   306,
     252,   252,   267,   267,   252,   307,   316,    42,    43,    44,
      45,    52,    70,    71,    76,    87,    95,   101,   122,   123,
     141,   142,   146,   147,   148,   172,   190,   192,   209,   212,
     213,   214,   215,   216,   233,   234,   241,   314,   250,    39,
      81,   261,   250,   225,    20,   250,   253,   252,   322,   253,
      72,    73,    74,    75,   111,   112,   113,   241,   242,   260,
     322,   264,     3,   285,   285,   285,   322,   322,     3,   267,
     253,   267,   267,   253,   253,   267,   252,   310,   310,   310,
     310,   310,   310,   252,   310,   310,   310,    43,   311,   310,
     311,   310,   252,   310,   311,   310,   311,   252,   252,   309,
     322,   322,   298,    78,   322,    78,   322,   297,   253,   239,
     262,   265,   250,   253,   253,   253,    20,   253,   316,   253,
     253,   253,     5,   312,   313,   312,   312,     4,   315,   312,
     312,   312,   313,   312,   313,   312,   315,   312,   313,   312,
     313,     5,     5,    18,    40,    56,    78,   128,   154,   166,
     222,   261,   253,   183,   125,   266,     3,   322,   250,   253,
     224,   243,    52,    54,   250,   253,   253,   253,   253,   154,
       4,     4,     5,     6,     7,   128,   128,   252,   267,     5,
     190,     4,     4,   313,   313,   313,   267,   253,     4,   253
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
		  Type, Value); \
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
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
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

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
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
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
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
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
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
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
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

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
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

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

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
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

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


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 4:

/* Line 1455 of yacc.c  */
#line 307 "pmysql.y"
    { emit("STMT"); ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 311 "pmysql.y"
    { emit("SELECTNODATA %d %d", (yyvsp[(2) - (3)].intval), (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 315 "pmysql.y"
    { emit("SELECT %d %d %d", (yyvsp[(2) - (11)].intval), (yyvsp[(3) - (11)].intval), (yyvsp[(5) - (11)].intval)); ;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 319 "pmysql.y"
    { emit("WHERE"); ;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 323 "pmysql.y"
    { emit("GROUPBYLIST %d %d", (yyvsp[(3) - (4)].intval), (yyvsp[(4) - (4)].intval)); ;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 327 "pmysql.y"
    { emit("GROUPBY %d",  (yyvsp[(2) - (2)].intval)); (yyval.intval) = 1; ;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 329 "pmysql.y"
    { emit("GROUPBY %d",  (yyvsp[(4) - (4)].intval)); (yyval.intval) = (yyvsp[(1) - (4)].intval) + 1; ;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 332 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 333 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 334 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 337 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 338 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 341 "pmysql.y"
    { emit("HAVING"); ;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 343 "pmysql.y"
    { emit("ORDERBY %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 346 "pmysql.y"
    { emit("LIMIT 1"); ;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 347 "pmysql.y"
    { emit("LIMIT 2"); ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 351 "pmysql.y"
    { emit("INTO %d", (yyvsp[(2) - (2)].intval)); ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 354 "pmysql.y"
    { emit("COLUMN %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); (yyval.intval) = 1; ;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 355 "pmysql.y"
    { emit("COLUMN %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 358 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 359 "pmysql.y"
    { if((yyval.intval) & 01) yyerror("duplicate ALL option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 01; ;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 360 "pmysql.y"
    { if((yyval.intval) & 02) yyerror("duplicate DISTINCT option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 02; ;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 361 "pmysql.y"
    { if((yyval.intval) & 04) yyerror("duplicate DISTINCTROW option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 04; ;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 362 "pmysql.y"
    { if((yyval.intval) & 010) yyerror("duplicate HIGH_PRIORITY option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 010; ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 363 "pmysql.y"
    { if((yyval.intval) & 020) yyerror("duplicate STRAIGHT_JOIN option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 020; ;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 364 "pmysql.y"
    { if((yyval.intval) & 040) yyerror("duplicate SQL_SMALL_RESULT option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 040; ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 365 "pmysql.y"
    { if((yyval.intval) & 0100) yyerror("duplicate SQL_BIG_RESULT option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 0100; ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 366 "pmysql.y"
    { if((yyval.intval) & 0200) yyerror("duplicate SQL_CALC_FOUND_ROWS option"); (yyval.intval) = (yyvsp[(1) - (2)].intval) | 0200; ;}
    break;

  case 38:

/* Line 1455 of yacc.c  */
#line 369 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 370 "pmysql.y"
    {(yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 371 "pmysql.y"
    { emit("SELECTALL"); (yyval.intval) = 1; ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 376 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 377 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 385 "pmysql.y"
    { emit("TABLE %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 386 "pmysql.y"
    { emit("TABLE %s.%s", (yyvsp[(1) - (5)].strval), (yyvsp[(3) - (5)].strval));
                               free((yyvsp[(1) - (5)].strval)); free((yyvsp[(3) - (5)].strval)); ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 388 "pmysql.y"
    { emit("SUBQUERYAS %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 389 "pmysql.y"
    { emit("TABLEREFERENCES %d", (yyvsp[(2) - (3)].intval)); ;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 396 "pmysql.y"
    { emit ("ALIAS %s", (yyvsp[(2) - (2)].strval)); free((yyvsp[(2) - (2)].strval)); ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 397 "pmysql.y"
    { emit ("ALIAS %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 403 "pmysql.y"
    { emit("JOIN %d", 0100+(yyvsp[(2) - (5)].intval)); ;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 405 "pmysql.y"
    { emit("JOIN %d", 0200); ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 407 "pmysql.y"
    { emit("JOIN %d", 0200); ;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 409 "pmysql.y"
    { emit("JOIN %d", 0300+(yyvsp[(2) - (6)].intval)+(yyvsp[(3) - (6)].intval)); ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 411 "pmysql.y"
    { emit("JOIN %d", 0400+(yyvsp[(3) - (5)].intval)); ;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 414 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 415 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 416 "pmysql.y"
    { (yyval.intval) = 2; ;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 419 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 420 "pmysql.y"
    {(yyval.intval) = 4; ;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 423 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 424 "pmysql.y"
    { (yyval.intval) = 2; ;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 427 "pmysql.y"
    { (yyval.intval) = 1 + (yyvsp[(2) - (2)].intval); ;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 428 "pmysql.y"
    { (yyval.intval) = 2 + (yyvsp[(2) - (2)].intval); ;}
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 429 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 435 "pmysql.y"
    { emit("ONEXPR"); ;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 436 "pmysql.y"
    { emit("USING %d", (yyvsp[(3) - (4)].intval)); ;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 441 "pmysql.y"
    { emit("INDEXHINT %d %d", (yyvsp[(5) - (6)].intval), 010+(yyvsp[(3) - (6)].intval)); ;}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 443 "pmysql.y"
    { emit("INDEXHINT %d %d", (yyvsp[(5) - (6)].intval), 020+(yyvsp[(3) - (6)].intval)); ;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 445 "pmysql.y"
    { emit("INDEXHINT %d %d", (yyvsp[(5) - (6)].intval), 030+(yyvsp[(3) - (6)].intval)); ;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 449 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 450 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 453 "pmysql.y"
    { emit("INDEX %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); (yyval.intval) = 1; ;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 454 "pmysql.y"
    { emit("INDEX %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 457 "pmysql.y"
    { emit("SUBQUERY"); ;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 462 "pmysql.y"
    { emit("STMT"); ;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 467 "pmysql.y"
    { emit("DELETEONE %d %s", (yyvsp[(2) - (7)].intval), (yyvsp[(4) - (7)].strval)); free((yyvsp[(4) - (7)].strval)); ;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 470 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) + 01; ;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 471 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) + 02; ;}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 472 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) + 04; ;}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 473 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 479 "pmysql.y"
    { emit("DELETEMULTI %d %d %d", (yyvsp[(2) - (6)].intval), (yyvsp[(3) - (6)].intval), (yyvsp[(5) - (6)].intval)); ;}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 481 "pmysql.y"
    { emit("TABLE %s", (yyvsp[(1) - (2)].strval)); free((yyvsp[(1) - (2)].strval)); (yyval.intval) = 1; ;}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 483 "pmysql.y"
    { emit("TABLE %s", (yyvsp[(3) - (4)].strval)); free((yyvsp[(3) - (4)].strval)); (yyval.intval) = (yyvsp[(1) - (4)].intval) + 1; ;}
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 491 "pmysql.y"
    { emit("DELETEMULTI %d %d %d", (yyvsp[(2) - (7)].intval), (yyvsp[(4) - (7)].intval), (yyvsp[(6) - (7)].intval)); ;}
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 496 "pmysql.y"
    { emit("STMT"); ;}
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 502 "pmysql.y"
    { emit("INSERTVALS %d %d %s", (yyvsp[(2) - (8)].intval), (yyvsp[(7) - (8)].intval), (yyvsp[(4) - (8)].strval)); free((yyvsp[(4) - (8)].strval)) ;}
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 506 "pmysql.y"
    { emit("DUPUPDATE %d", (yyvsp[(4) - (4)].intval)); ;}
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 509 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 510 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 01 ; ;}
    break;

  case 101:

/* Line 1455 of yacc.c  */
#line 511 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 02 ; ;}
    break;

  case 102:

/* Line 1455 of yacc.c  */
#line 512 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 04 ; ;}
    break;

  case 103:

/* Line 1455 of yacc.c  */
#line 513 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 010 ; ;}
    break;

  case 107:

/* Line 1455 of yacc.c  */
#line 520 "pmysql.y"
    { emit("INSERTCOLS %d", (yyvsp[(2) - (3)].intval)); ;}
    break;

  case 108:

/* Line 1455 of yacc.c  */
#line 523 "pmysql.y"
    { emit("VALUES %d", (yyvsp[(2) - (3)].intval)); (yyval.intval) = 1; ;}
    break;

  case 109:

/* Line 1455 of yacc.c  */
#line 524 "pmysql.y"
    { emit("VALUES %d", (yyvsp[(4) - (5)].intval)); (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; ;}
    break;

  case 110:

/* Line 1455 of yacc.c  */
#line 527 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 111:

/* Line 1455 of yacc.c  */
#line 528 "pmysql.y"
    { emit("DEFAULT"); (yyval.intval) = 1; ;}
    break;

  case 112:

/* Line 1455 of yacc.c  */
#line 529 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 113:

/* Line 1455 of yacc.c  */
#line 530 "pmysql.y"
    { emit("DEFAULT"); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 114:

/* Line 1455 of yacc.c  */
#line 536 "pmysql.y"
    { emit("INSERTASGN %d %d %s", (yyvsp[(2) - (7)].intval), (yyvsp[(6) - (7)].intval), (yyvsp[(4) - (7)].strval)); free((yyvsp[(4) - (7)].strval)) ;}
    break;

  case 115:

/* Line 1455 of yacc.c  */
#line 541 "pmysql.y"
    { emit("INSERTSELECT %d %s", (yyvsp[(2) - (7)].intval), (yyvsp[(4) - (7)].strval)); free((yyvsp[(4) - (7)].strval)); ;}
    break;

  case 116:

/* Line 1455 of yacc.c  */
#line 546 "pmysql.y"
    { if ((yyvsp[(2) - (3)].subtok) != 4) yyerror("bad insert assignment to %s", (yyvsp[(1) - (3)].strval));
       emit("ASSIGN %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); (yyval.intval) = 1; ;}
    break;

  case 117:

/* Line 1455 of yacc.c  */
#line 549 "pmysql.y"
    { if ((yyvsp[(2) - (3)].subtok) != 4) yyerror("bad insert assignment to %s", (yyvsp[(1) - (3)].strval));
                 emit("DEFAULT"); emit("ASSIGN %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); (yyval.intval) = 1; ;}
    break;

  case 118:

/* Line 1455 of yacc.c  */
#line 552 "pmysql.y"
    { if ((yyvsp[(4) - (5)].subtok) != 4) yyerror("bad insert assignment to %s", (yyvsp[(1) - (5)].intval));
                 emit("ASSIGN %s", (yyvsp[(3) - (5)].strval)); free((yyvsp[(3) - (5)].strval)); (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; ;}
    break;

  case 119:

/* Line 1455 of yacc.c  */
#line 555 "pmysql.y"
    { if ((yyvsp[(4) - (5)].subtok) != 4) yyerror("bad insert assignment to %s", (yyvsp[(1) - (5)].intval));
                 emit("DEFAULT"); emit("ASSIGN %s", (yyvsp[(3) - (5)].strval)); free((yyvsp[(3) - (5)].strval)); (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; ;}
    break;

  case 120:

/* Line 1455 of yacc.c  */
#line 560 "pmysql.y"
    { emit("STMT"); ;}
    break;

  case 121:

/* Line 1455 of yacc.c  */
#line 566 "pmysql.y"
    { emit("REPLACEVALS %d %d %s", (yyvsp[(2) - (8)].intval), (yyvsp[(7) - (8)].intval), (yyvsp[(4) - (8)].strval)); free((yyvsp[(4) - (8)].strval)) ;}
    break;

  case 122:

/* Line 1455 of yacc.c  */
#line 572 "pmysql.y"
    { emit("REPLACEASGN %d %d %s", (yyvsp[(2) - (7)].intval), (yyvsp[(6) - (7)].intval), (yyvsp[(4) - (7)].strval)); free((yyvsp[(4) - (7)].strval)) ;}
    break;

  case 123:

/* Line 1455 of yacc.c  */
#line 577 "pmysql.y"
    { emit("REPLACESELECT %d %s", (yyvsp[(2) - (7)].intval), (yyvsp[(4) - (7)].strval)); free((yyvsp[(4) - (7)].strval)); ;}
    break;

  case 124:

/* Line 1455 of yacc.c  */
#line 581 "pmysql.y"
    { emit("STMT"); ;}
    break;

  case 125:

/* Line 1455 of yacc.c  */
#line 588 "pmysql.y"
    { emit("UPDATE %d %d %d", (yyvsp[(2) - (8)].intval), (yyvsp[(3) - (8)].intval), (yyvsp[(5) - (8)].intval)); ;}
    break;

  case 126:

/* Line 1455 of yacc.c  */
#line 591 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 127:

/* Line 1455 of yacc.c  */
#line 592 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 01 ; ;}
    break;

  case 128:

/* Line 1455 of yacc.c  */
#line 593 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 010 ; ;}
    break;

  case 129:

/* Line 1455 of yacc.c  */
#line 598 "pmysql.y"
    { if ((yyvsp[(2) - (3)].subtok) != 4) yyerror("bad insert assignment to %s", (yyvsp[(1) - (3)].strval));
	 emit("ASSIGN %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); (yyval.intval) = 1; ;}
    break;

  case 130:

/* Line 1455 of yacc.c  */
#line 601 "pmysql.y"
    { if ((yyvsp[(4) - (5)].subtok) != 4) yyerror("bad insert assignment to %s", (yyvsp[(1) - (5)].strval));
	 emit("ASSIGN %s.%s", (yyvsp[(1) - (5)].strval), (yyvsp[(3) - (5)].strval)); free((yyvsp[(1) - (5)].strval)); free((yyvsp[(3) - (5)].strval)); (yyval.intval) = 1; ;}
    break;

  case 131:

/* Line 1455 of yacc.c  */
#line 604 "pmysql.y"
    { if ((yyvsp[(4) - (5)].subtok) != 4) yyerror("bad insert assignment to %s", (yyvsp[(3) - (5)].strval));
	 emit("ASSIGN %s.%s", (yyvsp[(3) - (5)].strval)); free((yyvsp[(3) - (5)].strval)); (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; ;}
    break;

  case 132:

/* Line 1455 of yacc.c  */
#line 607 "pmysql.y"
    { if ((yyvsp[(6) - (7)].subtok) != 4) yyerror("bad insert assignment to %s.$s", (yyvsp[(3) - (7)].strval), (yyvsp[(5) - (7)].strval));
	 emit("ASSIGN %s.%s", (yyvsp[(3) - (7)].strval), (yyvsp[(5) - (7)].strval)); free((yyvsp[(3) - (7)].strval)); free((yyvsp[(5) - (7)].strval)); (yyval.intval) = 1; ;}
    break;

  case 133:

/* Line 1455 of yacc.c  */
#line 614 "pmysql.y"
    { emit("STMT"); ;}
    break;

  case 134:

/* Line 1455 of yacc.c  */
#line 618 "pmysql.y"
    { emit("CREATEDATABASE %d %s", (yyvsp[(3) - (4)].intval), (yyvsp[(4) - (4)].strval)); free((yyvsp[(4) - (4)].strval)); ;}
    break;

  case 135:

/* Line 1455 of yacc.c  */
#line 619 "pmysql.y"
    { emit("CREATEDATABASE %d %s", (yyvsp[(3) - (4)].intval), (yyvsp[(4) - (4)].strval)); free((yyvsp[(4) - (4)].strval)); ;}
    break;

  case 136:

/* Line 1455 of yacc.c  */
#line 622 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 137:

/* Line 1455 of yacc.c  */
#line 623 "pmysql.y"
    { if(!(yyvsp[(2) - (2)].subtok))yyerror("IF EXISTS doesn't exist");
                        (yyval.intval) = (yyvsp[(2) - (2)].subtok); /* NOT EXISTS hack */ ;}
    break;

  case 138:

/* Line 1455 of yacc.c  */
#line 629 "pmysql.y"
    { emit("STMT"); ;}
    break;

  case 139:

/* Line 1455 of yacc.c  */
#line 633 "pmysql.y"
    { emit("CREATE %d %d %d %s", (yyvsp[(2) - (8)].intval), (yyvsp[(4) - (8)].intval), (yyvsp[(7) - (8)].intval), (yyvsp[(5) - (8)].strval)); free((yyvsp[(5) - (8)].strval)); ;}
    break;

  case 140:

/* Line 1455 of yacc.c  */
#line 637 "pmysql.y"
    { emit("CREATE %d %d %d %s.%s", (yyvsp[(2) - (10)].intval), (yyvsp[(4) - (10)].intval), (yyvsp[(9) - (10)].intval), (yyvsp[(5) - (10)].strval), (yyvsp[(7) - (10)].strval));
                          free((yyvsp[(5) - (10)].strval)); free((yyvsp[(7) - (10)].strval)); ;}
    break;

  case 141:

/* Line 1455 of yacc.c  */
#line 643 "pmysql.y"
    { emit("CREATESELECT %d %d %d %s", (yyvsp[(2) - (9)].intval), (yyvsp[(4) - (9)].intval), (yyvsp[(7) - (9)].intval), (yyvsp[(5) - (9)].strval)); free((yyvsp[(5) - (9)].strval)); ;}
    break;

  case 142:

/* Line 1455 of yacc.c  */
#line 647 "pmysql.y"
    { emit("CREATESELECT %d %d 0 %s", (yyvsp[(2) - (6)].intval), (yyvsp[(4) - (6)].intval), (yyvsp[(5) - (6)].strval)); free((yyvsp[(5) - (6)].strval)); ;}
    break;

  case 143:

/* Line 1455 of yacc.c  */
#line 652 "pmysql.y"
    { emit("CREATESELECT %d %d 0 %s.%s", (yyvsp[(2) - (11)].intval), (yyvsp[(4) - (11)].intval), (yyvsp[(5) - (11)].strval), (yyvsp[(7) - (11)].strval));
                              free((yyvsp[(5) - (11)].strval)); free((yyvsp[(7) - (11)].strval)); ;}
    break;

  case 144:

/* Line 1455 of yacc.c  */
#line 657 "pmysql.y"
    { emit("CREATESELECT %d %d 0 %s.%s", (yyvsp[(2) - (8)].intval), (yyvsp[(4) - (8)].intval), (yyvsp[(5) - (8)].strval), (yyvsp[(7) - (8)].strval));
                          free((yyvsp[(5) - (8)].strval)); free((yyvsp[(7) - (8)].strval)); ;}
    break;

  case 145:

/* Line 1455 of yacc.c  */
#line 661 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 146:

/* Line 1455 of yacc.c  */
#line 662 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 147:

/* Line 1455 of yacc.c  */
#line 665 "pmysql.y"
    { emit("STARTCOL"); ;}
    break;

  case 148:

/* Line 1455 of yacc.c  */
#line 666 "pmysql.y"
    { emit("COLUMNDEF %d %s", (yyvsp[(3) - (4)].intval), (yyvsp[(2) - (4)].strval)); free((yyvsp[(2) - (4)].strval)); ;}
    break;

  case 149:

/* Line 1455 of yacc.c  */
#line 668 "pmysql.y"
    { emit("PRIKEY %d", (yyvsp[(4) - (5)].intval)); ;}
    break;

  case 150:

/* Line 1455 of yacc.c  */
#line 669 "pmysql.y"
    { emit("KEY %d", (yyvsp[(3) - (4)].intval)); ;}
    break;

  case 151:

/* Line 1455 of yacc.c  */
#line 670 "pmysql.y"
    { emit("KEY %d", (yyvsp[(3) - (4)].intval)); ;}
    break;

  case 152:

/* Line 1455 of yacc.c  */
#line 671 "pmysql.y"
    { emit("TEXTINDEX %d", (yyvsp[(4) - (5)].intval)); ;}
    break;

  case 153:

/* Line 1455 of yacc.c  */
#line 672 "pmysql.y"
    { emit("TEXTINDEX %d", (yyvsp[(4) - (5)].intval)); ;}
    break;

  case 154:

/* Line 1455 of yacc.c  */
#line 675 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 155:

/* Line 1455 of yacc.c  */
#line 676 "pmysql.y"
    { emit("ATTR NOTNULL"); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 157:

/* Line 1455 of yacc.c  */
#line 678 "pmysql.y"
    { emit("ATTR DEFAULT STRING %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 158:

/* Line 1455 of yacc.c  */
#line 679 "pmysql.y"
    { emit("ATTR DEFAULT NUMBER %d", (yyvsp[(3) - (3)].intval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 159:

/* Line 1455 of yacc.c  */
#line 680 "pmysql.y"
    { emit("ATTR DEFAULT FLOAT %g", (yyvsp[(3) - (3)].floatval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 160:

/* Line 1455 of yacc.c  */
#line 681 "pmysql.y"
    { emit("ATTR DEFAULT BOOL %d", (yyvsp[(3) - (3)].intval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 161:

/* Line 1455 of yacc.c  */
#line 682 "pmysql.y"
    { emit("ATTR AUTOINC"); (yyval.intval) = (yyvsp[(1) - (2)].intval) + 1; ;}
    break;

  case 162:

/* Line 1455 of yacc.c  */
#line 683 "pmysql.y"
    { emit("ATTR UNIQUEKEY %d", (yyvsp[(4) - (5)].intval)); (yyval.intval) = (yyvsp[(1) - (5)].intval) + 1; ;}
    break;

  case 163:

/* Line 1455 of yacc.c  */
#line 684 "pmysql.y"
    { emit("ATTR UNIQUEKEY"); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 164:

/* Line 1455 of yacc.c  */
#line 685 "pmysql.y"
    { emit("ATTR PRIKEY"); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 165:

/* Line 1455 of yacc.c  */
#line 686 "pmysql.y"
    { emit("ATTR PRIKEY"); (yyval.intval) = (yyvsp[(1) - (2)].intval) + 1; ;}
    break;

  case 166:

/* Line 1455 of yacc.c  */
#line 687 "pmysql.y"
    { emit("ATTR COMMENT %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 167:

/* Line 1455 of yacc.c  */
#line 690 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 168:

/* Line 1455 of yacc.c  */
#line 691 "pmysql.y"
    { (yyval.intval) = (yyvsp[(2) - (3)].intval); ;}
    break;

  case 169:

/* Line 1455 of yacc.c  */
#line 692 "pmysql.y"
    { (yyval.intval) = (yyvsp[(2) - (5)].intval) + 1000*(yyvsp[(4) - (5)].intval); ;}
    break;

  case 170:

/* Line 1455 of yacc.c  */
#line 695 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 171:

/* Line 1455 of yacc.c  */
#line 696 "pmysql.y"
    { (yyval.intval) = 4000; ;}
    break;

  case 172:

/* Line 1455 of yacc.c  */
#line 699 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 173:

/* Line 1455 of yacc.c  */
#line 700 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 1000; ;}
    break;

  case 174:

/* Line 1455 of yacc.c  */
#line 701 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (2)].intval) | 2000; ;}
    break;

  case 176:

/* Line 1455 of yacc.c  */
#line 705 "pmysql.y"
    { emit("COLCHARSET %s", (yyvsp[(4) - (4)].strval)); free((yyvsp[(4) - (4)].strval)); ;}
    break;

  case 177:

/* Line 1455 of yacc.c  */
#line 706 "pmysql.y"
    { emit("COLCOLLATE %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); ;}
    break;

  case 178:

/* Line 1455 of yacc.c  */
#line 710 "pmysql.y"
    { (yyval.intval) = 10000 + (yyvsp[(2) - (2)].intval); ;}
    break;

  case 179:

/* Line 1455 of yacc.c  */
#line 711 "pmysql.y"
    { (yyval.intval) = 10000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 180:

/* Line 1455 of yacc.c  */
#line 712 "pmysql.y"
    { (yyval.intval) = 20000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 181:

/* Line 1455 of yacc.c  */
#line 713 "pmysql.y"
    { (yyval.intval) = 30000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 182:

/* Line 1455 of yacc.c  */
#line 714 "pmysql.y"
    { (yyval.intval) = 40000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 183:

/* Line 1455 of yacc.c  */
#line 715 "pmysql.y"
    { (yyval.intval) = 50000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 184:

/* Line 1455 of yacc.c  */
#line 716 "pmysql.y"
    { (yyval.intval) = 60000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 185:

/* Line 1455 of yacc.c  */
#line 717 "pmysql.y"
    { (yyval.intval) = 70000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 186:

/* Line 1455 of yacc.c  */
#line 718 "pmysql.y"
    { (yyval.intval) = 80000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 187:

/* Line 1455 of yacc.c  */
#line 719 "pmysql.y"
    { (yyval.intval) = 90000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 188:

/* Line 1455 of yacc.c  */
#line 720 "pmysql.y"
    { (yyval.intval) = 110000 + (yyvsp[(2) - (3)].intval) + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 189:

/* Line 1455 of yacc.c  */
#line 721 "pmysql.y"
    { (yyval.intval) = 100001; ;}
    break;

  case 190:

/* Line 1455 of yacc.c  */
#line 722 "pmysql.y"
    { (yyval.intval) = 100002; ;}
    break;

  case 191:

/* Line 1455 of yacc.c  */
#line 723 "pmysql.y"
    { (yyval.intval) = 100003; ;}
    break;

  case 192:

/* Line 1455 of yacc.c  */
#line 724 "pmysql.y"
    { (yyval.intval) = 100004; ;}
    break;

  case 193:

/* Line 1455 of yacc.c  */
#line 725 "pmysql.y"
    { (yyval.intval) = 100005; ;}
    break;

  case 194:

/* Line 1455 of yacc.c  */
#line 726 "pmysql.y"
    { (yyval.intval) = 120000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 195:

/* Line 1455 of yacc.c  */
#line 727 "pmysql.y"
    { (yyval.intval) = 130000 + (yyvsp[(3) - (5)].intval); ;}
    break;

  case 196:

/* Line 1455 of yacc.c  */
#line 728 "pmysql.y"
    { (yyval.intval) = 140000 + (yyvsp[(2) - (2)].intval); ;}
    break;

  case 197:

/* Line 1455 of yacc.c  */
#line 729 "pmysql.y"
    { (yyval.intval) = 150000 + (yyvsp[(3) - (4)].intval); ;}
    break;

  case 198:

/* Line 1455 of yacc.c  */
#line 730 "pmysql.y"
    { (yyval.intval) = 160001; ;}
    break;

  case 199:

/* Line 1455 of yacc.c  */
#line 731 "pmysql.y"
    { (yyval.intval) = 160002; ;}
    break;

  case 200:

/* Line 1455 of yacc.c  */
#line 732 "pmysql.y"
    { (yyval.intval) = 160003; ;}
    break;

  case 201:

/* Line 1455 of yacc.c  */
#line 733 "pmysql.y"
    { (yyval.intval) = 160004; ;}
    break;

  case 202:

/* Line 1455 of yacc.c  */
#line 734 "pmysql.y"
    { (yyval.intval) = 170000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 203:

/* Line 1455 of yacc.c  */
#line 735 "pmysql.y"
    { (yyval.intval) = 171000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 204:

/* Line 1455 of yacc.c  */
#line 736 "pmysql.y"
    { (yyval.intval) = 172000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 205:

/* Line 1455 of yacc.c  */
#line 737 "pmysql.y"
    { (yyval.intval) = 173000 + (yyvsp[(2) - (3)].intval); ;}
    break;

  case 206:

/* Line 1455 of yacc.c  */
#line 738 "pmysql.y"
    { (yyval.intval) = 200000 + (yyvsp[(3) - (5)].intval); ;}
    break;

  case 207:

/* Line 1455 of yacc.c  */
#line 739 "pmysql.y"
    { (yyval.intval) = 210000 + (yyvsp[(3) - (5)].intval); ;}
    break;

  case 208:

/* Line 1455 of yacc.c  */
#line 742 "pmysql.y"
    { emit("ENUMVAL %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); (yyval.intval) = 1; ;}
    break;

  case 209:

/* Line 1455 of yacc.c  */
#line 743 "pmysql.y"
    { emit("ENUMVAL %s", (yyvsp[(3) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); (yyval.intval) = (yyvsp[(1) - (3)].intval) + 1; ;}
    break;

  case 210:

/* Line 1455 of yacc.c  */
#line 746 "pmysql.y"
    { emit("CREATESELECT %d", (yyvsp[(1) - (3)].intval)) ;}
    break;

  case 211:

/* Line 1455 of yacc.c  */
#line 749 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 212:

/* Line 1455 of yacc.c  */
#line 750 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 213:

/* Line 1455 of yacc.c  */
#line 751 "pmysql.y"
    { (yyval.intval) = 2; ;}
    break;

  case 214:

/* Line 1455 of yacc.c  */
#line 754 "pmysql.y"
    { (yyval.intval) = 0; ;}
    break;

  case 215:

/* Line 1455 of yacc.c  */
#line 755 "pmysql.y"
    { (yyval.intval) = 1;;}
    break;

  case 216:

/* Line 1455 of yacc.c  */
#line 760 "pmysql.y"
    { emit("STMT"); ;}
    break;

  case 220:

/* Line 1455 of yacc.c  */
#line 768 "pmysql.y"
    { if ((yyvsp[(2) - (3)].subtok) != 4) yyerror("bad set to @%s", (yyvsp[(1) - (3)].strval));
		 emit("SET %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); ;}
    break;

  case 221:

/* Line 1455 of yacc.c  */
#line 770 "pmysql.y"
    { emit("SET %s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); ;}
    break;

  case 222:

/* Line 1455 of yacc.c  */
#line 775 "pmysql.y"
    { emit("NAME %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 223:

/* Line 1455 of yacc.c  */
#line 776 "pmysql.y"
    { emit("USERVAR %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 224:

/* Line 1455 of yacc.c  */
#line 777 "pmysql.y"
    { emit("FIELDNAME %s.%s", (yyvsp[(1) - (3)].strval), (yyvsp[(3) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); free((yyvsp[(3) - (3)].strval)); ;}
    break;

  case 225:

/* Line 1455 of yacc.c  */
#line 778 "pmysql.y"
    { emit("STRING %s", (yyvsp[(1) - (1)].strval)); free((yyvsp[(1) - (1)].strval)); ;}
    break;

  case 226:

/* Line 1455 of yacc.c  */
#line 779 "pmysql.y"
    { emit("NUMBER %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 227:

/* Line 1455 of yacc.c  */
#line 780 "pmysql.y"
    { emit("FLOAT %g", (yyvsp[(1) - (1)].floatval)); ;}
    break;

  case 228:

/* Line 1455 of yacc.c  */
#line 781 "pmysql.y"
    { emit("BOOL %d", (yyvsp[(1) - (1)].intval)); ;}
    break;

  case 229:

/* Line 1455 of yacc.c  */
#line 784 "pmysql.y"
    { emit("ADD"); ;}
    break;

  case 230:

/* Line 1455 of yacc.c  */
#line 785 "pmysql.y"
    { emit("SUB"); ;}
    break;

  case 231:

/* Line 1455 of yacc.c  */
#line 786 "pmysql.y"
    { emit("MUL"); ;}
    break;

  case 232:

/* Line 1455 of yacc.c  */
#line 787 "pmysql.y"
    { emit("DIV"); ;}
    break;

  case 233:

/* Line 1455 of yacc.c  */
#line 788 "pmysql.y"
    { emit("MOD"); ;}
    break;

  case 234:

/* Line 1455 of yacc.c  */
#line 789 "pmysql.y"
    { emit("MOD"); ;}
    break;

  case 235:

/* Line 1455 of yacc.c  */
#line 790 "pmysql.y"
    { emit("NEG"); ;}
    break;

  case 236:

/* Line 1455 of yacc.c  */
#line 791 "pmysql.y"
    { emit("AND"); ;}
    break;

  case 237:

/* Line 1455 of yacc.c  */
#line 792 "pmysql.y"
    { emit("OR"); ;}
    break;

  case 238:

/* Line 1455 of yacc.c  */
#line 793 "pmysql.y"
    { emit("XOR"); ;}
    break;

  case 239:

/* Line 1455 of yacc.c  */
#line 794 "pmysql.y"
    { emit("CMP %d", (yyvsp[(2) - (3)].subtok)); ;}
    break;

  case 240:

/* Line 1455 of yacc.c  */
#line 795 "pmysql.y"
    { emit("CMPSELECT %d", (yyvsp[(2) - (5)].subtok)); ;}
    break;

  case 241:

/* Line 1455 of yacc.c  */
#line 796 "pmysql.y"
    { emit("CMPANYSELECT %d", (yyvsp[(2) - (6)].subtok)); ;}
    break;

  case 242:

/* Line 1455 of yacc.c  */
#line 797 "pmysql.y"
    { emit("CMPANYSELECT %d", (yyvsp[(2) - (6)].subtok)); ;}
    break;

  case 243:

/* Line 1455 of yacc.c  */
#line 798 "pmysql.y"
    { emit("CMPALLSELECT %d", (yyvsp[(2) - (6)].subtok)); ;}
    break;

  case 244:

/* Line 1455 of yacc.c  */
#line 799 "pmysql.y"
    { emit("BITOR"); ;}
    break;

  case 245:

/* Line 1455 of yacc.c  */
#line 800 "pmysql.y"
    { emit("BITAND"); ;}
    break;

  case 246:

/* Line 1455 of yacc.c  */
#line 801 "pmysql.y"
    { emit("BITXOR"); ;}
    break;

  case 247:

/* Line 1455 of yacc.c  */
#line 802 "pmysql.y"
    { emit("SHIFT %s", (yyvsp[(2) - (3)].subtok)==1?"left":"right"); ;}
    break;

  case 248:

/* Line 1455 of yacc.c  */
#line 803 "pmysql.y"
    { emit("NOT"); ;}
    break;

  case 249:

/* Line 1455 of yacc.c  */
#line 804 "pmysql.y"
    { emit("NOT"); ;}
    break;

  case 250:

/* Line 1455 of yacc.c  */
#line 805 "pmysql.y"
    { emit("ASSIGN @%s", (yyvsp[(1) - (3)].strval)); free((yyvsp[(1) - (3)].strval)); ;}
    break;

  case 251:

/* Line 1455 of yacc.c  */
#line 808 "pmysql.y"
    { emit("ISNULL"); ;}
    break;

  case 252:

/* Line 1455 of yacc.c  */
#line 809 "pmysql.y"
    { emit("ISNULL"); emit("NOT"); ;}
    break;

  case 253:

/* Line 1455 of yacc.c  */
#line 810 "pmysql.y"
    { emit("ISBOOL %d", (yyvsp[(3) - (3)].intval)); ;}
    break;

  case 254:

/* Line 1455 of yacc.c  */
#line 811 "pmysql.y"
    { emit("ISBOOL %d", (yyvsp[(4) - (4)].intval)); emit("NOT"); ;}
    break;

  case 255:

/* Line 1455 of yacc.c  */
#line 814 "pmysql.y"
    { emit("BETWEEN"); ;}
    break;

  case 256:

/* Line 1455 of yacc.c  */
#line 818 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 257:

/* Line 1455 of yacc.c  */
#line 819 "pmysql.y"
    { (yyval.intval) = 1 + (yyvsp[(3) - (3)].intval); ;}
    break;

  case 258:

/* Line 1455 of yacc.c  */
#line 822 "pmysql.y"
    { (yyval.intval) = 0 ;}
    break;

  case 260:

/* Line 1455 of yacc.c  */
#line 826 "pmysql.y"
    { emit("ISIN %d", (yyvsp[(4) - (5)].intval)); ;}
    break;

  case 261:

/* Line 1455 of yacc.c  */
#line 827 "pmysql.y"
    { emit("ISIN %d", (yyvsp[(5) - (6)].intval)); emit("NOT"); ;}
    break;

  case 262:

/* Line 1455 of yacc.c  */
#line 828 "pmysql.y"
    { emit("INSELECT"); ;}
    break;

  case 263:

/* Line 1455 of yacc.c  */
#line 829 "pmysql.y"
    { emit("INSELECT"); emit("NOT"); ;}
    break;

  case 264:

/* Line 1455 of yacc.c  */
#line 830 "pmysql.y"
    { emit("EXISTS"); if((yyvsp[(1) - (4)].subtok))emit("NOT"); ;}
    break;

  case 265:

/* Line 1455 of yacc.c  */
#line 833 "pmysql.y"
    {  emit("CALL %d %s", (yyvsp[(3) - (4)].intval), (yyvsp[(1) - (4)].strval)); free((yyvsp[(1) - (4)].strval)); ;}
    break;

  case 266:

/* Line 1455 of yacc.c  */
#line 837 "pmysql.y"
    { emit("COUNTALL") ;}
    break;

  case 267:

/* Line 1455 of yacc.c  */
#line 838 "pmysql.y"
    { emit(" CALL 1 COUNT"); ;}
    break;

  case 268:

/* Line 1455 of yacc.c  */
#line 840 "pmysql.y"
    {  emit("CALL %d SUBSTR", (yyvsp[(3) - (4)].intval));;}
    break;

  case 269:

/* Line 1455 of yacc.c  */
#line 841 "pmysql.y"
    {  emit("CALL 2 SUBSTR"); ;}
    break;

  case 270:

/* Line 1455 of yacc.c  */
#line 842 "pmysql.y"
    {  emit("CALL 3 SUBSTR"); ;}
    break;

  case 271:

/* Line 1455 of yacc.c  */
#line 843 "pmysql.y"
    { emit("CALL %d TRIM", (yyvsp[(3) - (4)].intval)); ;}
    break;

  case 272:

/* Line 1455 of yacc.c  */
#line 844 "pmysql.y"
    { emit("CALL 3 TRIM"); ;}
    break;

  case 273:

/* Line 1455 of yacc.c  */
#line 847 "pmysql.y"
    { emit("INT 1"); ;}
    break;

  case 274:

/* Line 1455 of yacc.c  */
#line 848 "pmysql.y"
    { emit("INT 2"); ;}
    break;

  case 275:

/* Line 1455 of yacc.c  */
#line 849 "pmysql.y"
    { emit("INT 3"); ;}
    break;

  case 276:

/* Line 1455 of yacc.c  */
#line 852 "pmysql.y"
    { emit("CALL 3 DATE_ADD"); ;}
    break;

  case 277:

/* Line 1455 of yacc.c  */
#line 853 "pmysql.y"
    { emit("CALL 3 DATE_SUB"); ;}
    break;

  case 278:

/* Line 1455 of yacc.c  */
#line 856 "pmysql.y"
    { emit("NUMBER 1"); ;}
    break;

  case 279:

/* Line 1455 of yacc.c  */
#line 857 "pmysql.y"
    { emit("NUMBER 2"); ;}
    break;

  case 280:

/* Line 1455 of yacc.c  */
#line 858 "pmysql.y"
    { emit("NUMBER 3"); ;}
    break;

  case 281:

/* Line 1455 of yacc.c  */
#line 859 "pmysql.y"
    { emit("NUMBER 4"); ;}
    break;

  case 282:

/* Line 1455 of yacc.c  */
#line 860 "pmysql.y"
    { emit("NUMBER 5"); ;}
    break;

  case 283:

/* Line 1455 of yacc.c  */
#line 861 "pmysql.y"
    { emit("NUMBER 6"); ;}
    break;

  case 284:

/* Line 1455 of yacc.c  */
#line 862 "pmysql.y"
    { emit("NUMBER 7"); ;}
    break;

  case 285:

/* Line 1455 of yacc.c  */
#line 863 "pmysql.y"
    { emit("NUMBER 8"); ;}
    break;

  case 286:

/* Line 1455 of yacc.c  */
#line 864 "pmysql.y"
    { emit("NUMBER 9"); ;}
    break;

  case 287:

/* Line 1455 of yacc.c  */
#line 867 "pmysql.y"
    { emit("CASEVAL %d 0", (yyvsp[(3) - (4)].intval)); ;}
    break;

  case 288:

/* Line 1455 of yacc.c  */
#line 868 "pmysql.y"
    { emit("CASEVAL %d 1", (yyvsp[(3) - (6)].intval)); ;}
    break;

  case 289:

/* Line 1455 of yacc.c  */
#line 869 "pmysql.y"
    { emit("CASE %d 0", (yyvsp[(2) - (3)].intval)); ;}
    break;

  case 290:

/* Line 1455 of yacc.c  */
#line 870 "pmysql.y"
    { emit("CASE %d 1", (yyvsp[(2) - (5)].intval)); ;}
    break;

  case 291:

/* Line 1455 of yacc.c  */
#line 873 "pmysql.y"
    { (yyval.intval) = 1; ;}
    break;

  case 292:

/* Line 1455 of yacc.c  */
#line 874 "pmysql.y"
    { (yyval.intval) = (yyvsp[(1) - (5)].intval)+1; ;}
    break;

  case 293:

/* Line 1455 of yacc.c  */
#line 877 "pmysql.y"
    { emit("LIKE"); ;}
    break;

  case 294:

/* Line 1455 of yacc.c  */
#line 878 "pmysql.y"
    { emit("LIKE"); emit("NOT"); ;}
    break;

  case 295:

/* Line 1455 of yacc.c  */
#line 881 "pmysql.y"
    { emit("REGEXP"); ;}
    break;

  case 296:

/* Line 1455 of yacc.c  */
#line 882 "pmysql.y"
    { emit("REGEXP"); emit("NOT"); ;}
    break;

  case 297:

/* Line 1455 of yacc.c  */
#line 885 "pmysql.y"
    { emit("NOW") ;}
    break;

  case 298:

/* Line 1455 of yacc.c  */
#line 886 "pmysql.y"
    { emit("NOW") ;}
    break;

  case 299:

/* Line 1455 of yacc.c  */
#line 887 "pmysql.y"
    { emit("NOW") ;}
    break;

  case 300:

/* Line 1455 of yacc.c  */
#line 890 "pmysql.y"
    { emit("STRTOBIN"); ;}
    break;



/* Line 1455 of yacc.c  */
#line 4303 "pmysql.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

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
		      yytoken, &yylval);
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


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


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
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
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
#line 893 "pmysql.y"


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

