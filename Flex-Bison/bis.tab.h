/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_BIS_TAB_H_INCLUDED
# define YY_YY_BIS_TAB_H_INCLUDED
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
    T_EOF = 0,
    T_PROGRAM = 258,
    T_FUNCTION = 259,
    T_ENDFUNCTION = 260,
    T_STRUCT = 261,
    T_ENDSTRUCT = 262,
    T_TYPEDEF = 263,
    T_VARS = 264,
    T_CHAR = 265,
    T_INTEGER = 266,
    T_RETURN = 267,
    T_STARTMAIN = 268,
    T_ENDMAIN = 269,
    T_WHILE = 270,
    T_ENDWHILE = 271,
    T_FOR = 272,
    T_TO = 273,
    T_STEP = 274,
    T_ENDFOR = 275,
    T_IF = 276,
    T_THEN = 277,
    T_ELSE = 278,
    T_ELSEIF = 279,
    T_ENDIF = 280,
    T_SWITCH = 281,
    T_CASE = 282,
    T_DEFAULT = 283,
    T_ENDSWITCH = 284,
    T_PRINT = 285,
    T_BREAK = 286,
    T_ADD = 287,
    T_SUB = 288,
    T_POWER = 289,
    T_MUL = 290,
    T_DIV = 291,
    T_LT = 292,
    T_GT = 293,
    T_EQ = 294,
    T_NQ = 295,
    T_AND = 296,
    T_OR = 297,
    T_ASSIGN = 298,
    T_LPAR = 299,
    T_RPAR = 300,
    T_SCOLON = 301,
    T_COMMA = 302,
    T_COLON = 303,
    T_LBRAC = 304,
    T_RBRAC = 305,
    T_NL = 306,
    Unknown = 307,
    T_ID = 308,
    T_STRING = 309,
    T_NUMBER = 310,
    T_C = 311,
    LOWER_THAN_ELSE = 312
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 25 "bis.y"

      int intval;
      char *strval;

#line 121 "bis.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_BIS_TAB_H_INCLUDED  */
