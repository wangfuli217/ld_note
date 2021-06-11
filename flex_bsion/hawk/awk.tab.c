/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "awk.y" /* yacc.c:339  */

	//This file belongs to yacc
	
    #include <stdlib.h>
    #include <math.h>
    #include <unistd.h>
    #include "customstring.h"
    #include "customio.h"
    #include "entry.h"
    extern int yylineno;
    extern int yylex();
    extern int DEBUG;
    
    void yyerror(char *s) {
		printstr_err(s); printstr_err(" on line "); 
		printint_err(yylineno); printstr_err("\n");
		//fprintf(stderr, "%s on line %d\n", s, yylineno);
		exit(SYNTAX_ERROR);
    }
    void printop(char *s) {
		if (DEBUG) fprintf(stderr, "Got %s\n", s);
	}
	void printrun(char* s) {
		if (DEBUG) fprintf(stderr, "Running %s\n", s);
	}
	
	void die(char* s, int exitcode) {
		fprintf(stderr, "%s\n", s);
		exit(exitcode);
	}
	
	void warning(char* s) {
		fprintf(stderr, "warning: %s\n", s);
	}
		
	char* type_by_enum[] = { "none", "singleop", "blockop", "exprop", "assignop", "value", "strvalue", "id", "binaryop", "unaryop", "ifop", "whileop", "funop", "regex", "arrvalue" };

	//SOME ACTUALLY USEFUL STUFF
	
	
	entry* head;
	entry* awkbegin;
	entry* awkend;
	
	
	void rec_print(entry* a, int depth) {
		if (a == NULL) return;
		if (DEBUG == 0) return;

		for (int i = 0; i < depth; i++) printstr(" ");
		char* strbuf = (char*)calloc(50, sizeof(char));
		sprintf(strbuf, "%p %d %s %c ", a, a->type, type_by_enum[a->type], a->op);
		printstr(strbuf);
		free(strbuf);
		if (a->text != NULL) printstr(a->text);
		printstr("\n");
		for (int i = 0; i < a->argc; i++) {
			rec_print((entry*)((a->argv)[i]), depth + 1);
		}
	
	}

	entry* new_entry_0(){
		entry* tmp = (entry*)malloc(sizeof(entry));
		tmp->type = none;
		tmp->argc = 0;
		tmp->argv = (struct entry**)malloc(sizeof(entry*) * 5);
		tmp->text = "\0";
		tmp->op = '\0';
		tmp->op2 = '\0';
		return tmp;
	}
	entry* new_entry_1(entry* a) {
		entry* tmp = new_entry_0();
		tmp->argc = 1;
		(tmp->argv)[0] = a;
		return tmp;
	}
	entry* new_entry_2(entry* a, entry* b) {
		entry* tmp = new_entry_1(a);
		tmp->argc = 2;
		(tmp->argv)[1] = b;
		return tmp;
	}
	
	//OPERATORS
	entry* new_block_op_2(entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = blockop;
		return tmp;
	};
	
	//EXPRESSIONS
	entry* new_expr_op(entry* a) {
		entry* tmp = new_entry_1(a);
		tmp->type = exprop;
		return tmp;
	}
	entry* new_expr_value(entry* a) {
		entry* tmp = new_entry_1(a);
		tmp->type = value;
		return tmp;
	}
	entry* new_assign_op(entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = assignop;
		return tmp;
	}
	entry* new_binary_op(char op, entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = binaryop;
		tmp->op = op;
		return tmp;
	}
	entry* new_binary_op2(char op, char op2, entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = binaryop;
		tmp->op = op;
		tmp->op2 = op2;
		return tmp;
	}
	entry* new_unary_op(char op, entry* a) {
		entry* tmp = new_entry_1(a);
		tmp->type = unaryop;
		tmp-> op = op;
		return tmp;
	}
	entry* new_id_value(entry* a) {
		entry* tmp = new_entry_1(a);
		tmp->type = value;
		return tmp;
	}
	entry* new_if_op(entry* a, entry* b, entry* c) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = ifop;
		tmp->argc = 3;
		(tmp->argv)[2] = c;
		return tmp;
	}
	entry* new_while_op(entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = whileop;
		return tmp;
	}
	entry* new_fun_op(entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = funop;
		return tmp;
	}
	entry* new_sub_fun_op(entry* a, entry* b, entry* c, entry* d) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = funop;
		tmp->argc = 4;
		(tmp->argv)[2] = c;
		(tmp->argv)[3] = d;
		return tmp;
	}
	entry* new_regex() {
		entry* tmp = new_entry_0();
		tmp->type = regex;
		return tmp;
	}
	entry* new_arrval_op(entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = arrvalue;
		return tmp;
	}

#line 235 "awk.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "awk.tab.h".  */
#ifndef YY_YY_AWK_TAB_H_INCLUDED
# define YY_YY_AWK_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    AWKBEGIN = 258,
    AWKEND = 259,
    REGMATCH = 260,
    COMMENT = 261,
    IF = 262,
    ELSE = 263,
    WHILE = 264,
    EXIT = 265,
    EQ = 266,
    LE = 267,
    GE = 268,
    NE = 269,
    BOOLAND = 270,
    BOOLOR = 271,
    REGEX = 272,
    STRING = 273,
    NUM = 274,
    ID = 275,
    SQBROP = 276,
    SQBRCL = 277
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_AWK_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 309 "awk.tab.c" /* yacc.c:358  */

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
#else
typedef signed char yytype_int8;
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
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
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
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
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
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
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

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  36
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   264

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  37
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  11
/* YYNRULES -- Number of rules.  */
#define YYNRULES  45
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  102

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   277

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    35,     2,     2,     2,     2,     2,     2,
      26,    27,    33,    31,    36,    32,     2,    34,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    25,
      30,    28,    29,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    23,     2,    24,     2,     2,     2,     2,
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
      15,    16,    17,    18,    19,    20,    21,    22
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint8 yyrline[] =
{
       0,   190,   190,   191,   192,   193,   196,   197,   200,   201,
     202,   203,   204,   207,   208,   209,   212,   212,   214,   215,
     216,   219,   220,   221,   222,   223,   224,   225,   226,   227,
     230,   231,   232,   235,   236,   237,   240,   241,   242,   243,
     244,   245,   246,   247,   248,   249
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "AWKBEGIN", "AWKEND", "REGMATCH",
  "COMMENT", "IF", "ELSE", "WHILE", "EXIT", "EQ", "LE", "GE", "NE",
  "BOOLAND", "BOOLOR", "REGEX", "STRING", "NUM", "ID", "SQBROP", "SQBRCL",
  "'{'", "'}'", "';'", "'('", "')'", "'='", "'>'", "'<'", "'+'", "'-'",
  "'*'", "'/'", "'!'", "','", "$accept", "PROGRAM", "OPS", "OP1", "OP2",
  "OP", "EXPR", "EXPR1", "EXPR2", "TERM", "VAL", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   123,   125,    59,    40,    41,    61,    62,
      60,    43,    45,    42,    47,    33,    44
};
# endif

#define YYPACT_NINF -72

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-72)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
       6,   -12,     7,     8,    10,   -72,   -72,   220,   166,   190,
     208,   208,    21,   166,   -72,   -72,   -72,    11,   191,    -4,
     -16,   -72,   166,   190,   190,   -72,   -72,   190,   212,   190,
     166,    42,    15,   -14,   -72,   -72,   -72,   -72,   -72,   208,
     208,   208,   208,   208,   208,   208,   208,   208,   208,   208,
     208,    76,    16,    19,    26,   228,    23,   -72,    94,    33,
     -72,    -4,    -4,    -4,    -4,    -4,    -4,    -4,    -4,   -16,
     -16,   -72,   -72,    32,   166,   166,   -72,   -26,   -72,   -72,
      41,   166,    48,   -72,   -72,   -72,   -72,   208,   166,   112,
     166,    40,   130,    65,   -72,   -72,   -72,   -72,    47,   166,
     148,   -72
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     0,    45,    36,    40,     0,     0,
       0,     0,     0,     2,    16,    17,     6,     0,    18,    21,
      30,    33,     0,     0,     0,    12,    20,     0,     0,     0,
       0,     0,     0,    40,    37,    38,     1,     7,     9,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    40,     0,    19,     0,     8,
      39,    22,    23,    24,    25,    26,    27,    28,    29,    31,
      32,    34,    35,     0,     0,     0,    41,     0,    42,     8,
       0,     0,    16,    13,    11,    15,    44,     0,     0,     0,
       0,     0,     0,     3,    10,    14,    43,     4,     0,     0,
       0,     5
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -72,   -72,    -8,   -71,   -67,   -11,    30,   -72,   218,   -17,
      -5
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,    12,    13,    14,    15,    16,    17,    18,    19,    20,
      21
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      31,    86,    37,    82,    84,    34,    35,    27,    85,     1,
      87,    22,    28,     2,    51,     3,     4,    49,    50,    94,
      37,    36,    58,    95,     5,     6,     7,    47,    48,     8,
      69,    70,     9,    23,    24,    25,    38,    80,    10,    32,
      37,    11,    60,    74,    71,    72,    75,    37,    76,     2,
      78,     3,     4,    52,    53,    81,    90,    54,    56,    57,
       5,     6,     7,    83,    88,    30,    59,    96,     9,    98,
      99,     0,     0,    89,    10,     0,     0,    11,    37,     0,
      92,    37,    91,     2,     0,     3,     4,     0,     0,    37,
       0,   100,     0,     0,     5,     6,     7,     0,     0,    30,
      73,     2,     9,     3,     4,     0,     0,     0,    10,     0,
       0,    11,     5,     6,     7,     0,     0,    30,    79,     2,
       9,     3,     4,     0,     0,     0,    10,     0,     0,    11,
       5,     6,     7,     0,     0,    30,    93,     2,     9,     3,
       4,     0,     0,     0,    10,     0,     0,    11,     5,     6,
       7,     0,     0,    30,    97,     2,     9,     3,     4,     0,
       0,     0,    10,     0,     0,    11,     5,     6,     7,     0,
       0,    30,   101,     2,     9,     3,     4,     0,     0,     0,
      10,     0,     0,    11,     5,     6,     7,     0,     0,    30,
       0,     0,     9,     0,     0,     0,     0,     0,    10,     0,
       0,    11,    39,    40,    41,    42,    43,    44,     5,     6,
       7,     0,     0,     0,     0,     0,     9,     0,     0,     0,
      45,    46,    10,     0,     0,    11,     5,     6,    33,     0,
       5,     6,    55,     0,     9,     0,     0,    26,     9,     0,
      10,    27,     0,    11,    10,    77,    28,    11,    29,    27,
       0,     0,     0,     0,    28,     0,    29,    61,    62,    63,
      64,    65,    66,    67,    68
};

static const yytype_int8 yycheck[] =
{
       8,    27,    13,    74,    75,    10,    11,    21,    75,     3,
      36,    23,    26,     7,    22,     9,    10,    33,    34,    90,
      31,     0,    30,    90,    18,    19,    20,    31,    32,    23,
      47,    48,    26,    26,    26,    25,    25,     4,    32,     9,
      51,    35,    27,    27,    49,    50,    27,    58,    22,     7,
      27,     9,    10,    23,    24,    23,     8,    27,    28,    29,
      18,    19,    20,    74,    23,    23,    24,    27,    26,     4,
      23,    -1,    -1,    81,    32,    -1,    -1,    35,    89,    -1,
      88,    92,    87,     7,    -1,     9,    10,    -1,    -1,   100,
      -1,    99,    -1,    -1,    18,    19,    20,    -1,    -1,    23,
      24,     7,    26,     9,    10,    -1,    -1,    -1,    32,    -1,
      -1,    35,    18,    19,    20,    -1,    -1,    23,    24,     7,
      26,     9,    10,    -1,    -1,    -1,    32,    -1,    -1,    35,
      18,    19,    20,    -1,    -1,    23,    24,     7,    26,     9,
      10,    -1,    -1,    -1,    32,    -1,    -1,    35,    18,    19,
      20,    -1,    -1,    23,    24,     7,    26,     9,    10,    -1,
      -1,    -1,    32,    -1,    -1,    35,    18,    19,    20,    -1,
      -1,    23,    24,     7,    26,     9,    10,    -1,    -1,    -1,
      32,    -1,    -1,    35,    18,    19,    20,    -1,    -1,    23,
      -1,    -1,    26,    -1,    -1,    -1,    -1,    -1,    32,    -1,
      -1,    35,    11,    12,    13,    14,    15,    16,    18,    19,
      20,    -1,    -1,    -1,    -1,    -1,    26,    -1,    -1,    -1,
      29,    30,    32,    -1,    -1,    35,    18,    19,    20,    -1,
      18,    19,    20,    -1,    26,    -1,    -1,    17,    26,    -1,
      32,    21,    -1,    35,    32,    17,    26,    35,    28,    21,
      -1,    -1,    -1,    -1,    26,    -1,    28,    39,    40,    41,
      42,    43,    44,    45,    46
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     7,     9,    10,    18,    19,    20,    23,    26,
      32,    35,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    23,    26,    26,    25,    17,    21,    26,    28,
      23,    39,    43,    20,    47,    47,     0,    42,    25,    11,
      12,    13,    14,    15,    16,    29,    30,    31,    32,    33,
      34,    39,    43,    43,    43,    20,    43,    43,    39,    24,
      27,    45,    45,    45,    45,    45,    45,    45,    45,    46,
      46,    47,    47,    24,    27,    27,    22,    17,    27,    24,
       4,    23,    40,    42,    40,    41,    27,    36,    23,    39,
       8,    47,    39,    24,    40,    41,    27,    24,     4,    23,
      39,    24
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    37,    38,    38,    38,    38,    39,    39,    40,    40,
      40,    40,    40,    41,    41,    41,    42,    42,    43,    43,
      43,    44,    44,    44,    44,    44,    44,    44,    44,    44,
      45,    45,    45,    46,    46,    46,    47,    47,    47,    47,
      47,    47,    47,    47,    47,    47
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     7,     7,    11,     1,     2,     3,     2,
       7,     5,     2,     5,     7,     5,     1,     1,     1,     3,
       2,     1,     3,     3,     3,     3,     3,     3,     3,     3,
       1,     3,     3,     1,     3,     3,     1,     2,     2,     3,
       1,     4,     4,     7,     5,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

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
#ifndef YYINITDEPTH
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
static YYSIZE_T
yystrlen (const char *yystr)
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

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
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
  int yytoken = 0;
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

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
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
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
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
      if (yytable_value_is_error (yyn))
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
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

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
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 190 "awk.y" /* yacc.c:1646  */
    { rec_print((yyvsp[0]), 0); head = (yyvsp[0]); awkbegin = NULL; awkend = NULL;}
#line 1479 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 3:
#line 191 "awk.y" /* yacc.c:1646  */
    { rec_print((yyvsp[-1]), 0); head = (yyvsp[-1]); awkbegin = (yyvsp[-4]); awkend = NULL;}
#line 1485 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 4:
#line 192 "awk.y" /* yacc.c:1646  */
    { rec_print((yyvsp[-5]), 0); head = (yyvsp[-5]); awkbegin = NULL; awkend = (yyvsp[-1]);}
#line 1491 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 193 "awk.y" /* yacc.c:1646  */
    { rec_print((yyvsp[-5]), 0); head = (yyvsp[-5]); awkbegin = (yyvsp[-8]); awkend = (yyvsp[-1]);}
#line 1497 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 7:
#line 197 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_block_op_2((yyvsp[-1]), (yyvsp[0]));}
#line 1503 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 200 "awk.y" /* yacc.c:1646  */
    { (yyval) = (yyvsp[-1]); printop("op in braces");}
#line 1509 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 201 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_expr_op((yyvsp[-1])); printop("expression");}
#line 1515 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 202 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_if_op((yyvsp[-4]), (yyvsp[-2]), (yyvsp[0])); printop("if/else 1");}
#line 1521 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 203 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_while_op((yyvsp[-2]), (yyvsp[0])); printop("while 1");}
#line 1527 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 12:
#line 204 "awk.y" /* yacc.c:1646  */
    { /*$$ = new exitop();*/ printop("exit");}
#line 1533 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 13:
#line 207 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_if_op((yyvsp[-2]), (yyvsp[0]), NULL); printop("if");}
#line 1539 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 208 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_if_op((yyvsp[-4]), (yyvsp[-2]), (yyvsp[0])); printop("if/else 2");}
#line 1545 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 209 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_while_op((yyvsp[-2]), (yyvsp[0])); printop("while 2");}
#line 1551 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 215 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_assign_op((yyvsp[-2]), (yyvsp[0])); printop("assign value");}
#line 1557 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 216 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op('~', (yyvsp[-1]), (yyvsp[0])); printop("regex match");}
#line 1563 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 220 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op2('=', '=', (yyvsp[-2]), (yyvsp[0])); printop("binary ==");}
#line 1569 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 221 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op2('<', '=', (yyvsp[-2]), (yyvsp[0])); printop("binary <=");}
#line 1575 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 222 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op2('>', '=', (yyvsp[-2]), (yyvsp[0])); printop("binary >=");}
#line 1581 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 223 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op2('!', '=', (yyvsp[-2]), (yyvsp[0])); printop("binary !=");}
#line 1587 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 224 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op2('&', '&', (yyvsp[-2]), (yyvsp[0])); printop("binary &&");}
#line 1593 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 225 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op2('|', '|', (yyvsp[-2]), (yyvsp[0])); printop("binary ||");}
#line 1599 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 226 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op('>', (yyvsp[-2]), (yyvsp[0])); printop("binary >");}
#line 1605 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 227 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op('<', (yyvsp[-2]), (yyvsp[0])); printop("binary <");}
#line 1611 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 231 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op('+', (yyvsp[-2]), (yyvsp[0])); printop("binary +");}
#line 1617 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 232 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op('-', (yyvsp[-2]), (yyvsp[0]));  printop("binary -");}
#line 1623 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 34:
#line 236 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op('*', (yyvsp[-2]), (yyvsp[0]));  printop("binary *");}
#line 1629 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 35:
#line 237 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_binary_op('/', (yyvsp[-2]), (yyvsp[0]));  printop("binary /");}
#line 1635 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 36:
#line 240 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_expr_value((yyvsp[0])); printop("plain value");}
#line 1641 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 241 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_unary_op('-', (yyvsp[0])); printop("unary -");}
#line 1647 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 242 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_unary_op('!', (yyvsp[0])); printop("binary !");}
#line 1653 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 243 "awk.y" /* yacc.c:1646  */
    { (yyval) = (yyvsp[-1]); }
#line 1659 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 40:
#line 244 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_id_value((yyvsp[0])); printop("value by id");}
#line 1665 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 245 "awk.y" /* yacc.c:1646  */
    { (yyval)=new_arrval_op((yyvsp[-3]), (yyvsp[-1])); printop("arrvaluecall");}
#line 1671 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 246 "awk.y" /* yacc.c:1646  */
    { (yyval)=new_fun_op((yyvsp[-3]), (yyvsp[-1])); printop("funcall");}
#line 1677 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 247 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_sub_fun_op((yyvsp[-6]), (yyvsp[-4]), (yyvsp[-3]), (yyvsp[-1])); printop("regexp funcall"); }
#line 1683 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 248 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_sub_fun_op((yyvsp[-4]), (yyvsp[-2]), (yyvsp[-1]), NULL); printop("regexp funcall"); }
#line 1689 "awk.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 249 "awk.y" /* yacc.c:1646  */
    { (yyval) = new_expr_value((yyvsp[0])); printop("string"); }
#line 1695 "awk.tab.c" /* yacc.c:1646  */
    break;


#line 1699 "awk.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
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

  /* Do not reclaim the symbols of the rule whose action triggered
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
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
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

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


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

#if !defined yyoverflow || YYERROR_VERBOSE
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
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
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
  return yyresult;
}
#line 252 "awk.y" /* yacc.c:1906  */

