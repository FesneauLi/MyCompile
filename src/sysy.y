%{
#include <stdio.h>
void yyerror(const char *s);
extern int yylex(void);
%}

%token INT
%token ADD MUL

%%
Calc : 
    | Exp { printf("= %d\n", $1); }
    ;

Exp : Factor { $$ = $1;}
    | Exp ADD Factor { $$ = $1 + $3; }
    ;

Factor : Term { $$ = $1; }
    | Factor MUL Term { $$ = $1 * $3; }
    ;

Term: INT { $$ = $1; }
    ;
%%

void yyerror(const char *s) {
    printf("error: %s\n", s);
}
