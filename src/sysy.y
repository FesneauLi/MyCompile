%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
extern int yylex(void);
%}

%token INT 
%token IDENT
%token ADD MUL SUB DIV
%token LPAREN RPAREN
%token AND OR NOT 
%token EQ NE LT GT LE GE

%left OR
%left AND
%left EQ NE
%left LT GT LE GE
%right NOT

%%
Calc : 
    | Exp { printf("= %d\n", $1); }
    ;

Exp : Term { $$ = $1; }
    | Exp ADD Term { $$ = $1 + $3; }
    | Exp SUB Term { $$ = $1 - $3; } 
    ;
    
Term : Factor {$$ = $1;}
    | Term MUL Factor { $$ = $1 * $3; } 
    | Term DIV Factor { $$ = $1 / $3; } 
    ;

Factor : INT { $$ = $1; }
    | LPAREN Exp RPAREN { $$ = $2; }  // 括号表达式
    ;
%%

void yyerror(const char *s) {
    printf("error: %s\n", s);
}