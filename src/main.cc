#include <stdio.h>
#define INPUTFILE "tests/lab1/1.sy"
extern int yyparse();
extern FILE *yyin;


// int main() {
//   yyparse();
//   return 0;
// }


int main(){
  yyin = fopen(INPUTFILE,"r");
  if(yyin==NULL){
    printf("unable to open input\n");
    return 1;
  }
  yyparse();
  int yylex();  // 调用词法分析器，每次返回一个TOKEN
  fclose(yyin);
  return 0;
}