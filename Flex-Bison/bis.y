
%{
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "bis.tab.h"
#include "hashtbl.h"
#include "hashtbl.c"
#include "settings.h"

void yyerror(char const *S); //Συνάρτηση για εμφάνιση error
extern int yylineno; //Καταμέτρηση γραμμών
extern char* yytext; //Χρήση yytext του lex
extern FILE *yyin; //Χρήση yyin του lex
extern FILE *yyout; //Χρήση yyout του lex
int yylex(void);
void typedef_id_match(char *x, char *y);		
int scope=0;
HASHTBL *hashtbl;						
%}
//Χρησιμοποιείται για διευκρίνιση των σφαλμάτων
%define parse.error verbose
//Ορισμός σωρών για τους τύπους δεδομένων των σημασιολογικών τιμών
%union{
      int intval;
      char *strval;
}
//Ορισμός των tokens
%token <strval> T_PROGRAM       "program"  
%token <strval> T_FUNCTION      "function"   
%token <strval> T_ENDFUNCTION   "endfunction"
%token <strval> T_STRUCT        "struct"
%token <strval> T_ENDSTRUCT     "endstruct"
%token <strval> T_TYPEDEF       "typedef"
%token <strval> T_VARS          "vars" 
%token <strval> T_CHAR          "char" 
%token <strval> T_INTEGER      "int"
%token <strval> T_RETURN        "return"
%token <strval> T_STARTMAIN     "startmain"
%token <strval> T_ENDMAIN       "endmain"

/*Εντολές*/ 
%token <strval> T_WHILE         "while"
%token <strval> T_ENDWHILE      "endwhile"
%token <strval> T_FOR           "for"
%token <strval> T_TO            "to"
%token <strval> T_STEP          "step"
%token <strval> T_ENDFOR        "endfor"
%token <strval> T_IF            "if"
%token <strval> T_THEN          "then"
%token <strval> T_ELSE          "else"
%token <strval> T_ELSEIF        "elseif"
%token <strval> T_ENDIF         "endif"
%token <strval> T_SWITCH        "switch"
%token <strval> T_CASE          "case"
%token <strval> T_DEFAULT       "default"
%token <strval> T_ENDSWITCH     "endswitch"
%token <strval> T_PRINT         "print"
%token <strval> T_BREAK         "break"
/*Symbols*/
%token <strval> T_ADD           "add"
%token <strval> T_SUB           "subtract"      
%token <strval> T_POWER         "power"
%token <strval> T_MUL           "multiply"
%token <strval> T_DIV           "divide"
%token <strval> T_LT            "less than"
%token <strval> T_GT            "greater than"
%token <strval> T_EQ            "equal"
%token <strval> T_NQ            "not equal"
%token <strval> T_AND           "and"
%token <strval> T_OR            "or"
%token <strval> T_ASSIGN        "assign"
%token <strval> T_LPAR          "left parenthesis"
%token <strval> T_RPAR          "right parenthesis"
%token <strval> T_SCOLON        "semicolon"
%token <strval> T_COMMA         "comma"           
%token <strval> T_COLON         "colon"
%token <strval> T_LBRAC         "left bracket"
%token <strval> T_RBRAC         "right bracket"
%token <strval> T_NL            "new line"
%token <strval> Unknown         "unknown"
 // Tokens δεδομένων
%token <strval> T_ID            "id"
%token <strval> T_STRING        "string"
%token <intval> T_NUMBER        "number"
%token <strval> T_C             "character"
/*End of File*/
%token <strval> T_EOF           0

//Προτεραιότητες συντελεστών
%left T_COMMA
%right T_ASSIGN 
%left T_OR
%left T_AND
%left T_EQ T_NQ T_LT T_GT
%left T_ADD T_SUB
%left T_MUL T_DIV
%left T_POWER
%left T_LPAR T_RPAR T_LBRAC T_RBRAC
//Επίλυση dangling else
%nonassoc LOWER_THAN_ELSE
%nonassoc T_ELSE
%%


program:    T_PROGRAM T_ID T_NL structs T_NL functions T_NL main {hashtbl_insert(hashtbl, $2, NULL, scope);}
            | T_PROGRAM T_ID T_NL functions T_NL main {hashtbl_insert(hashtbl, $2, NULL, scope);}
            | T_PROGRAM T_ID T_NL structs T_NL main {hashtbl_insert(hashtbl, $2, NULL, scope);}
            | T_PROGRAM T_ID T_NL main {hashtbl_insert(hashtbl, $2, NULL, scope);}
            ;
functions:  function
            | functions T_NL function 
            ;
function:   T_FUNCTION T_ID {hashtbl_insert(hashtbl, $2, NULL, scope); scope++;} T_LPAR arguments T_RPAR T_NL body {scope--;}
            ;
body:       declare commands return T_ENDFUNCTION
            ;
declare:    declare  T_VARS type variable T_SCOLON
            | %empty
            ;           
return:     T_RETURN T_NUMBER 
            | T_RETURN T_C
            | T_RETURN T_ID   {hashtbl_search(hashtbl, $2, scope);}
            ;            
variable:   T_ID {hashtbl_insert(hashtbl, $1, NULL, scope);}
            | T_ID T_LBRAC T_NUMBER T_RBRAC {hashtbl_insert(hashtbl, $1, NULL, scope);}
            | variable T_COMMA variable
            ;
type:       T_CHAR
            | T_INTEGER
            ;
main:       T_STARTMAIN {scope++;} declare commands T_ENDMAIN {scope--;}
            ;

commands:   commands  command
            | %empty
            ;
command:    command_assign
            | command_loop
            | command_check
            | print
            | break
            | functioncall
            ;
command_assign:   T_ID T_ASSIGN expression T_SCOLON {hashtbl_search(hashtbl, $1, scope); }
                  | T_ID T_ASSIGN T_C T_SCOLON {hashtbl_search(hashtbl, $1, scope);}
                  ;
expression: term 
            | expression operator term
            ;
term:       factor
            | functioncall 
            ; 
factor:     T_ID {hashtbl_search(hashtbl, $1, scope);}
            | T_ID T_LBRAC T_NUMBER T_RBRAC {hashtbl_search(hashtbl, $1, scope);}
            | T_NUMBER
            | T_LPAR expression T_RPAR
            ;
operator:   T_ADD
            |T_SUB
            |T_MUL
            |T_DIV
            |T_POWER
            ;
functioncall:     T_ID T_LPAR functioncall_arguments T_RPAR {hashtbl_search(hashtbl, $1, scope);}
                  ;
functioncall_arguments: factor
                        | functioncall_arguments T_COMMA functioncall_arguments
                        | %empty
                        ;
arguments:  argument
            | arguments T_COMMA argument
            | %empty
            ;
argument:   T_VARS type T_ID {hashtbl_insert(hashtbl, $3, NULL, scope);}
            ;
            
command_loop:     T_WHILE T_LPAR condition T_RPAR {scope++;} commands T_ENDWHILE {scope--;}
                  | T_FOR count T_TO T_NUMBER T_STEP T_NUMBER {scope++;} commands T_ENDFOR {scope--;}
                  ;
count:      T_ID T_COLON T_ASSIGN T_NUMBER {hashtbl_search(hashtbl, $1, scope);}
            ;
condition:  expression condition_operator expression 
            ;
condition_operator:     T_LT 
                        | T_GT 
                        | T_EQ 
                        | T_NQ 
                        | T_AND 
                        | T_OR
                        ;
command_check:    T_IF T_LPAR condition T_RPAR {scope++;} T_THEN commands if_tail T_ENDIF {scope--;}
                  | T_SWITCH T_LPAR expression T_RPAR cases T_ENDSWITCH
                  ;
cases:            cases case
                  | %empty
                  ;

case:             T_CASE T_LPAR expression T_RPAR T_COLON {scope++;} commands  {scope--;}
                  | T_DEFAULT T_COLON {scope++;} commands {scope--;}
                  ;

if_tail:          if_tail T_ELSEIF T_LPAR condition T_RPAR {scope++;} commands {scope--;}
                  | if_tail T_ELSE {scope++;} commands {scope--;}
                  | %empty %prec LOWER_THAN_ELSE  
                  ;        
print:            T_PRINT T_LPAR T_STRING T_COMMA T_LBRAC T_ID T_RBRAC T_RPAR T_SCOLON {hashtbl_insert(hashtbl, $3, NULL, scope); hashtbl_search(hashtbl, $6, scope);}
                  | T_PRINT T_LPAR T_STRING T_RPAR  T_SCOLON {hashtbl_insert(hashtbl, $3, NULL, scope);}
                  ;
break:            T_BREAK T_SCOLON
                  ;
structs:          struct
                  | structs T_NL struct
                  ;
struct:           T_STRUCT T_ID {scope++;} T_NL declare T_ENDSTRUCT       {hashtbl_insert(hashtbl, $2, NULL, scope); scope--;}
                  | T_TYPEDEF T_STRUCT T_ID {scope++;} T_NL declare T_ID T_ENDSTRUCT {hashtbl_insert(hashtbl, $3, NULL, scope); hashtbl_insert(hashtbl, $7, NULL,scope); typedef_id_match(hashtbl_get_value(hashtbl, $3, scope), hashtbl_get_value(hashtbl, $7, scope)); scope--;}
                  ;
%%								    
    
//Εμφάνιση error όταν υπάρχει συντακτικό λάθος
void yyerror(char const *s) 
{
    fprintf(stderr,"\nThere is an error: %s\nLine: %d\nToken: %s\n", s, yylineno, yytext);
	exit(1);
}	

//Χρησιμοποιείται για να εξασφαλίσει ότι το όνομα του struct χρησιμοποιείται σωστά στον ορισμό του με typedef
void typedef_id_match(char *x, char *y){
      int flag;
      flag = strcmp(x, y);
      if ( flag != 0)
      yyerror("Wrong use of TYPEDEF(ID's do not match)\n");
 
}								


int main ( int argc, char **argv  ) 
  {
      //Δημιουργία hash table για αποθήκευση τιμών
      if (!(hashtbl=hashtbl_create(10, NULL))){
        puts ("[Error]: Could not open file");
        return EXIT_FAILURE;
       }
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;
  yyout = fopen ( "output", "w" );	
  yyparse ();
  fclose(yyin);
  //Αποδέσμευση μνήμης με καταστροφή του hash table
  hashtbl_destroy(hashtbl);
  return 0;
  }  
