%option noinput
%option nounput
%option noyywrap

%{
#include "sysy.tab.hh"
%}

digit [0-9]+
id [a-zA-Z_][a-zA-Z0-9_]*
blank [ \t\n]

%%


"+"             { printf("<+>");return ADD; }
"-"             { printf("<->");return SUB; }
"*"             { printf("<*>");return MUL; }
"/"             { printf("</>");return DIV; }

"("             { printf("<LPAREN>");return LPAREN;}
")"             { printf("<RPAREN>");return RPAREN;}
"["             { printf("<LB>");return LB;}
"]"             { printf("<RB>");return RB;}
"{"             { printf("<OB>");return OB;}
"}"             { printf("<CB>");return CB;}
";"				{ printf("<SEMI>");return (SEMI);}
":"				{ printf("<COLON>");return (COLON);}
","				{ printf("<COMMA>");return (COMMA);}


"<"					{printf("<LT>");return (LT);}
"<="				{printf("<LE>");return (LE);}
">"					{printf("<GT>");return (GT);}
">="				{printf("<GE>");return (GE);}
"=="				{printf("<EQ>");return (EQ);}
"!="				{printf("<NE>");return (NE);}
"="					{printf("<ASSIGN>");return (ASSIGN);}

"!"					{printf("<NOT>");return (NOT);}
"&&"				{printf("<AND>");return (AND);}
"||"				{printf("<OR>");return (OR);}

"main" 					{printf("<MAIN>");return (MAIN);}
"if" 					{printf("<IF>");return (IF);}
"else" 					{printf("<ELSE>");return (ELSE);}
"while" 				{printf("<WHILE>");return (WHILE);}
"for" 				{printf("<FOR>");return (FOR);}
"break" 				{printf("<BREAK>");return (BREAK);}
"continue" 				{printf("<CONTINUE>");return (CONTINUE);}
"return" 				{printf("<RETURN>");return (RETURN);}

"int"           {printf("<INT>");return (INT);}
{blank}         { }

{digit}        { yylval = atoi(yytext);printf("<INTNUM>"); return INT; }
{id}        { yylval = atoi(yytext);printf("<IDENT>"); return IDENT; } 

.               { printf("ERROR(%s)\n", yytext); }

%%
