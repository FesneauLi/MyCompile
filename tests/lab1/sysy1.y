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

%start Program

%%
Program : CompUnit
        ;

CompUnit : /* empty */
         | CompUnit Decl
         | CompUnit FuncDef
         | Stmt
         ;

Decl : VarDecl	';'											{  $$ = $1;   }
     ;
VarDef : BType IDENT { /* id */ }
       ;
FuncDef : FuncType IDENT '(' FuncFParams ')' Block
        ;

FuncType : "void" { $$ = $1; }
         | "int" { $$ = $1; }
         ;
FuncFParams : /* empty */
            | FuncFParam
            | FuncFParams ',' FuncFParam
            ;
FuncFParam : INT
            ;


VarDecl : BType VarDefList
        ;
VarDefList : VarDef
           | VarDefList ',' VarDef
           ;
VarDef : IDENT ;
BType : "int" { $$ = $1; }
      ;

Block : '{' BlockItemList '}'
      ;
BlockItemList : /* empty */
              | BlockItemList BlockItem
              ;
BlockItem : Decl
          | Stmt
          ;


Stmt : LVal '=' Exp ';'
     | Exp ';'
     | IfStmt
     | WhileStmt
     | ReturnStmt
     ;

IfStmt : "if" '(' Condition ')' Stmt { /*if statement */ }
       | "if" '(' Condition ')' Stmt "else" Stmt { /* if-else */ }
       ;

WhileStmt : "while" '(' Condition ')' Stmt { /* while loop */ }
          ;
Condition : Exp {$$ = $1; }
        ;
ReturnStmt : "return" Exp ';' { /* return value */ }
           | "return" ';' { /* return only */ }
           ;

LVal : IDENT {/*variable*/}
        | IDENT '[' Exp ']' { /* array */ }
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
    | LPAREN Exp RPAREN { $$ = $2; }  
    ;

%%

void yyerror(const char *s) {
    printf("error: %s\n", s);
}
