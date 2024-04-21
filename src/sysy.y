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
%token LPAREN RPAREN LB RB OB CB 
%token AND OR NOT 
%token EQ NE LT GT LE GE
%token ASSIGN

%token SEMI COLON COMMA
%token IF ELSE WHILE FOR BREAK CONTINUE RETURN MAIN


%left OR
%left AND
%left EQ NE
%left LT GT LE GE 
%right NOT



%start CompUnit
%% 

CompUnit :  Decl {printf("Decl Success!");}
    |       FuncDef {printf("FuncDef Success!");}
    |       CompUnit FuncDef 
    |       CompUnit Decl;
    
    

Decl :      VarDecl;
VarDecl :   BType VarDef SEMI
    |       BType LVal SEMI;
VarDef :    IDENT
    |       IDENT ASSIGN Exp2


FuncDef: BType MAIN LPAREN RPAREN Block
    |    BType MAIN LPAREN FuncFParams RPAREN Block
    |    BType IDENT LPAREN RPAREN Block
    |    BType IDENT LPAREN FuncFParams RPAREN Block;

FuncFParams : FuncFParam
    | FuncFParams COMMA FuncFParam;
FuncFParam : BType IDENT 
    | BType IDENT LB Calc RB;

Params : Param
    | Params COMMA Param;
Param  : LOrExp {$$=$1;};


Block : OB CB {} 
    | OB BlockGroup CB {};

BlockGroup : BlockItem
    | BlockGroup BlockItem {};

BlockItem: Decl | Stmt;

Stmt : LVal ASSIGN Exp SEMI
    | BType LVal SEMI
    | Exp SEMI
    | SEMI
    | Block
    | IF LPAREN Cond RPAREN Stmt
    | IF LPAREN Cond RPAREN Stmt ELSE Stmt
    | BREAK SEMI
    | CONTINUE SEMI
    | RETURN SEMI
    | RETURN Exp SEMI
    | IDENT ASSIGN Exp SEMI
    | Exp ASSIGN  IDENT SEMI
    | IDENT LPAREN Params RPAREN SEMI;

LVal : IDENT 
    | IDENT ArrayList;

ArrayList : LB Exp RB 
    | ArrayList LB Exp RB;

Cond : LOrExp {$$=$1;};

LOrExp : LAndExp {$$ = $1;}
    |    LOrExp OR LAndExp;

LAndExp : EqExp {$$ = $1;}
    |    LAndExp AND EqExp;

EqExp : RelExp {$$=$1;}
    | EqExp EQ RelExp 
    | EqExp NE RelExp ;

RelExp : Exp {$$=$1;}
       | RelExp LT Exp 
       | RelExp GT Exp
       | RelExp LE Exp 
       | RelExp GE Exp 
       | IDENT LPAREN Params RPAREN;




BType :     INT {};

Calc : 
    | Exp { printf("= %d\n", $1); }
    ;

Exp : Exp1 { $$ = $1; }
    | Exp ADD Exp1 { $$ = $1 + $3; }
    | Exp SUB Exp1  { $$ = $1 - $3; } 
    ;
    
Exp1 : Exp2 {$$ = $1;}
    | Exp1 MUL Exp2 { $$ = $1 * $3; } 
    | Exp1 DIV Exp2 { $$ = $1 / $3; } 
    ;

Exp2: INT { $$ = $1; }
    | IDENT {$$ = $1;}
    | SUB INT  {$$ = (-1)*$1; }
    | LPAREN Exp RPAREN { $$ = $2; }  // 括号表达式
    ;
%%

void yyerror(const char *s) {
    printf("error: %s\n", s);
}
