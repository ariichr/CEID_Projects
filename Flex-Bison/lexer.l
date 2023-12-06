%{
#include "bis.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
extern YYSTYPE yylval;
//DEBUG = 1 για debug mode, εκτελούνται print, = 0 για απενεργοποίηση
#define DEBUG 1
//Όταν είναι 1, ο λεκτικός αναλυτής λαμβάνει υπόψη το new line. Γίνεται 1 μόνο όταν διαβαστούν συγκεκριμένα tokens.
int nl_flag = 0;
void t_print(int number);
char ss[256];
%}
 // Επίλογες του flex για την διευκόλυνση του κώδικα(noyywrap-> Διαβάζει ένα αρχείο κάθε φορά, yylineno-> Διατηρεί τον αριθμό της τρέχων γραμμής)
%option noyywrap   
%option yylineno
 // Ορισμός Υποαναλυτών
%x MULTI_LINE_COMMENT
%x SINGLE_LINE_COMMENT
%x STRING
 // Ισοδύναμες εκφράσεις (Regular Expressions)
digit   [0-9]
num	{digit}+
id      [a-zA-Z]+[0-9a-zA-Z_]*
char    '[0-9a-zA-Z()!./,\?<>;:!'@#$%^&*+-=]'

%%
 //Κανόνες λεκτικής ανάλυσης
"PROGRAM"       {nl_flag = 1; t_print(T_PROGRAM); return T_PROGRAM;}
"FUNCTION"      {nl_flag = 1; t_print(T_FUNCTION); return T_FUNCTION;}
"END_FUNCTION"  {nl_flag = 1; t_print(T_ENDFUNCTION); return T_ENDFUNCTION;} 
"VARS"          {t_print(T_VARS); return T_VARS;}
"CHAR"          {t_print(T_CHAR); return T_CHAR;}
"INTEGER"       {t_print(T_INTEGER); return T_INTEGER;}
"RETURN"        {t_print(T_RETURN); return T_RETURN;} 
"STARTMAIN"     {t_print(T_STARTMAIN); return T_STARTMAIN;}
"ENDMAIN"       {t_print(T_ENDMAIN); return T_ENDMAIN;}
"WHILE"         {t_print(T_WHILE); return T_WHILE;}
"ENDWHILE"      {t_print(T_ENDWHILE); return T_ENDWHILE;}
"FOR"           {t_print(T_FOR); return T_FOR;}
"TO"            {t_print(T_TO); return T_TO;}
"STEP"          {t_print(T_STEP); return T_STEP;}
"ENDFOR"        {t_print(T_ENDFOR); return T_ENDFOR ;}
"IF"            {t_print(T_ENDIF); return T_IF;}
"THEN"          {t_print(T_THEN); return T_THEN;}
"ELSE"          {t_print(T_ELSE); return T_ELSE;}
"ELSEIF"        {t_print(T_ELSEIF); return T_ELSEIF;}
"ENDIF"         {t_print(T_ENDIF); return T_ENDIF;}
"SWITCH"        {t_print(T_SWITCH); return T_SWITCH;}
"CASE"          {t_print(T_CASE); return T_CASE;}
"DEFAULT"       {t_print(T_DEFAULT); return T_DEFAULT;}
"ENDSWITCH"     {t_print(T_ENDSWITCH); return T_ENDSWITCH;}
"PRINT"         {t_print(T_PRINT); return T_PRINT;}
"BREAK"         {t_print(T_BREAK); return T_BREAK;}
"STRUCT"        {nl_flag = 1; t_print(T_STRUCT); return T_STRUCT;}
"TYPEDEF"       {t_print(T_TYPEDEF); return T_TYPEDEF;}
"ENDSTRUCT"     {nl_flag = 1; t_print(T_ENDSTRUCT); return T_ENDSTRUCT;}

        /*MULTI_LINE_COMMENT*/
"/*"                            {printf("Multi-Lined Comment found\n"); BEGIN(MULTI_LINE_COMMENT);}     /*Είσοδος στον υποαναλυτή*/
<MULTI_LINE_COMMENT>"*/"        {BEGIN(INITIAL); printf("Multi-Lined Comment ended\n");}                  /*Επιστροφή από τον υποαναλυτή*/              
<MULTI_LINE_COMMENT>(\n|\r\n)   {}
<MULTI_LINE_COMMENT>(\.)           {}   

        /*SINGLE_LINE_COMMENT*/
"%"                             {printf("Comment found\n"); BEGIN(SINGLE_LINE_COMMENT);}                  /*Είσοδος στον υποαναλυτή*/
<SINGLE_LINE_COMMENT>(\n|\r\n)  {BEGIN(INITIAL); printf("Comment ended.\n");}                    /*Επιστροφή από τον υποαναλυτή*/
<SINGLE_LINE_COMMENT>.          {}                                                               /*νεα γραμμη στο comment */    

        /*STRING*/
\"                    {strcpy(ss, ""); printf("String found\n"); BEGIN(STRING);}               /*Είσοδος στον υποαναλυτή*/
<STRING>\"            {BEGIN(INITIAL); yylval.strval=strdup(ss); printf("%s\n", ss); return T_STRING;}              /*Επιστροφή από τον υποαναλυτή*/       
<STRING>(\n|\r\n)       {}                                                       /*νεα γραμμη στο string */
<STRING>.               {strcat(ss, yytext);}

        /*Τελεστές*/
"+"	{t_print(T_ADD); return T_ADD;}
"-"     {t_print(T_SUB); return T_SUB;}
"^"     {t_print(T_POWER); return T_POWER;}
"*"     {t_print(T_MUL); return T_MUL;}
"/"     {t_print(T_DIV); return T_DIV;}
">"     {t_print(T_GT); return T_GT;}
"<"     {t_print(T_LT); return T_LT;}
"=="    {t_print(T_EQ); return T_EQ;}
"!="    {t_print(T_NQ); return T_NQ;}
"AND"   {t_print(T_AND); return T_AND;}
"OR"    {t_print(T_OR); return T_OR;}


        /*Σύμβολα*/
"="     {t_print(T_ASSIGN); return T_ASSIGN;}
"("     {t_print(T_LPAR); return T_LPAR;}
")"     {t_print(T_RPAR); return T_RPAR;}
";"     {t_print(T_SCOLON); return T_SCOLON;}
","     {t_print(T_COMMA); return T_COMMA;}
":"     {t_print(T_COLON); return T_COLON;}
"["     {t_print(T_LBRAC); return T_LBRAC;}
"]"     {t_print(T_RBRAC); return T_RBRAC;}
[\r\n]+	{if(nl_flag==1) {t_print(T_NL); nl_flag=0; return T_NL;}}
[ \t]   {       }

{num} 	{t_print(T_NUMBER); yylval.intval=atoi(yytext); return T_NUMBER;}	/* yylval-> Αποθηκεύει τις τιμές στο union του bis.y*/ 
{id}    {t_print(T_ID); yylval.strval=strdup(yytext); return T_ID;}             /* (intval, strval)-> Τύποι αποθήκευσης τιμών του union Integer και String(char *) αντίστοιχα*/
{char}  {t_print(T_C); yylval.strval-strdup(yytext); return T_C;}               /* atoi-> μετατρέπει ένα string σε integer, strdup->αντιγράφει ενα string και επιστρέφει τον δείκτη του*/

.       {t_print(Unknown); return Unknown;} 

<<EOF>> {return T_EOF;}


%%
//Print που χρησιμοποιείται όταν κάνουμε debug
void t_print(int number){
        if(DEBUG){
                printf("%s | %d | %d\n", yytext, number, yylineno);
        }
}
