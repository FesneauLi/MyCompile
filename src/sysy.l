%option noinput
%option nounput
%option noyywrap

%{
#include "sysy.tab.hh"
%}

digit [0-9]
blank [ \t\n]

%%

{digit}+        { yylval = atoi(yytext); return INT; }
"+"             { return ADD; }
"*"             { return MUL; }
{blank}         { }
.               { printf("ERROR(%s)\n", yytext); }

%%
