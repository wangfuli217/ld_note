
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TK_EOF = 0,
     TK_AND = 257,
     TK_BREAK = 259,
     TK_DO = 260,
     TK_ELSE = 261,
     TK_ELSEIF = 262,
     TK_END = 263,
     TK_FALSE = 264,
     TK_FOR = 265,
     TK_FUNCTION = 266,
     TK_IF = 267,
     TK_IN = 268,
     TK_LOCAL = 269,
     TK_NIL = 270,
     TK_NOT = 271,
     TK_OR = 272,
     TK_REPEAT = 273,
     TK_RETURN = 274,
     TK_THEN = 275,
     TK_TRUE = 276,
     TK_UNTIL = 277,
     TK_WHILE = 278,
     TK_CONCAT = 279,
     TK_DOTS = 280,
     TK_EQ = 281,
     TK_GE = 282,
     TK_LE = 283,
     TK_NE = 284,
     TK_NUMBER = 285,
     TK_NAME = 286,
     TK_STRING = 287,
     TK_LONGSTRING = 288,
     TK_SHORTCOMMENT = 289,
     TK_LONGCOMMENT = 290,
     TK_WHITESPACE = 291,
     TK_NEWLINE = 292,
     TK_BADCHAR = 293
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


