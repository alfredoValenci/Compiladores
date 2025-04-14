%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(const char *s);
%}

%token NUMBER BOOL
%token AND OR NOT
%left OR
%left AND
%right NOT
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%
input:
    expr '\n'        { printf("Expresión válida\n"); }
  | error '\n'       { printf("Expresión inválida\n"); yyerrok; }
;

expr:
      expr '+' term
    | expr '-' term
    | term
;

term:
      term '*' factor
    | term '/' factor
    | factor
;

factor:
      '(' expr ')'
    | logical
;

logical:
      logical AND logical
    | logical OR logical
    | NOT factor
    | BOOL
    | NUMBER
;

%%

int yyerror(const char *s) {
    return 0;
}

int main(void) {
    printf("Introduce una expresión combinada:\n");
    while (1) {
        printf(">> ");
        if (yyparse() != 0) break;
    }
    return 0;
}
